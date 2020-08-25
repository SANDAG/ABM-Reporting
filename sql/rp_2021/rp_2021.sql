-- assumes ctemfac_2014 database exists

SET NOCOUNT ON;
GO


-- create [rp_2021] schema ---------------------------------------------------
-- note [rp_2021] schema permissions are defined at end of file
IF NOT EXISTS (
    SELECT TOP 1
        [schema_name]
    FROM
        [information_schema].[schemata] 
    WHERE
        [schema_name] = 'rp_2021'
)
EXEC ('CREATE SCHEMA [rp_2021]')
GO

-- add metadata for [rp_2021] schema
IF EXISTS(
    SELECT TOP 1
        [FullObjectName]
    FROM
        [db_meta].[data_dictionary]
    WHERE
        [ObjectType] = 'SCHEMA'
        AND [FullObjectName] = '[rp_2021]'
        AND [PropertyName] = 'MS_Description'
)
BEGIN
    EXECUTE [db_meta].[drop_xp] 'rp_2021', 'MS_Description'
    EXECUTE [db_meta].[add_xp] 'rp_2021', 'MS_Description', 'schema to hold all objects associated with the 2021 Regional Plan'
END
GO




-- create table holding results of rp_2021 Performance Measures --------------
DROP TABLE IF EXISTS [rp_2021].[pm_results]
/**	
summary:   >
    Creates table holding results from 2021 RP Performance Measures. This
    holds all outputs except for interim results used as inputs for other
    processes from:
        [rp_2021].[sp_particulate_matter_ctemfac_2014]
        [rp_2021].[sp_particulate_matter_ctemfac_2017]
**/
BEGIN
    -- create table to hold results of 2020 federal rtp peformance measures
	CREATE TABLE [rp_2021].[pm_results] (
        [scenario_id] int NOT NULL,
		[performance_measure] nvarchar(50) NOT NULL,
        [metric] nvarchar(200) NOT NULL,
        [value] float NOT NULL,
        [updated_by] nvarchar(100) NOT NULL,
        [updated_date] smalldatetime NOT NULL,
		CONSTRAINT pk_pmresults PRIMARY KEY ([scenario_id], [performance_measure], [metric]))
	WITH (DATA_COMPRESSION = PAGE)

    -- add table metadata
	EXECUTE [db_meta].[add_xp] 'rp_2021.pm_results', 'MS_Description', 'table to hold results for 2021 rp performance measures'
    EXECUTE [db_meta].[add_xp] 'rp_2021.pm_results.scenario_id', 'MS_Description', 'ABM scenario in ABM database [dimension].[scenario]'
	EXECUTE [db_meta].[add_xp] 'rp_2021.pm_results.performance_measure', 'MS_Description', 'name of the performance measure'
	EXECUTE [db_meta].[add_xp] 'rp_2021.pm_results.metric', 'MS_Description', 'metric within the performance measure'
	EXECUTE [db_meta].[add_xp] 'rp_2021.pm_results.value', 'MS_Description', 'value of the specified metric within the performance measure'
    EXECUTE [db_meta].[add_xp] 'rp_2021.pm_results.updated_by', 'MS_Description', 'SQL username who last updated the value of the specified metric within the performance measure'
    EXECUTE [db_meta].[add_xp] 'rp_2021.pm_results.updated_date', 'MS_Description', 'date the value of the specified metric within the performance measure was last updated'
END
GO




-- creates table holding square representation of San Diego ------------------
IF NOT EXISTS (
    SELECT TOP 1
        [object_id]
    FROM
        [sys].[objects]
    WHERE
        [object_id] = OBJECT_ID('[rp_2021].[particulate_matter_grid]')
        AND type = 'U'
)
BEGIN

/**	
summary:   >
    Creates table holding elements of a 100x100 square representation of the
    San Diego region. Each record in the table is a single square of the
    making up the entirety of a square San Diego region. Along with their 
    shape and centroid spatial attributes, each 100x100 square also contains
    the name of the Series 13 MGRA polygon that its centroid resides in. Note
    that 100x100 squares whose centroids do not fall within a Series 13 MGRA
    polygon are removed from the result. All spatial data uses EPSG: 2230.

    This table is used in conjunction with the functions
    [rp_2021].[fn_particulate_matter_ctemfac_2014] and
    [rp_2021].[fn_particulate_matter_ctemfac_2017] as well as the stored
    procedures [rp_2021].[sp_particulate_matter_ctemfac_2014] and 
    [rp_2021].[sp_particulate_matter_ctemfac_2017] to calculate
    person-level exposure to particulate matter emissions.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions: 
    - author: Gregor Schroeder, Ziying Ouyang, Rick Curry
      modification: create and translate to new abm database structure
      date: Spring 2018
**/

	RAISERROR('Note: Building [rp_2021].[particulate_matter_grid] takes approximately one hour and 45 minutes at a 100x100 grid size', 0, 1) WITH NOWAIT;

    -- create table to hold representation of square San Diego region
    -- to be split into square polygons
	CREATE TABLE [rp_2021].[particulate_matter_grid] (
		[id] int NOT NULL,
		[shape] geometry NOT NULL,
		[centroid] geometry NOT NULL,
		[mgra_13] nvarchar(20) NOT NULL,
		CONSTRAINT pk_particulatemattergrid PRIMARY KEY ([id]))
	WITH (DATA_COMPRESSION = PAGE)

    -- add table metadata
	EXECUTE [db_meta].[add_xp] 'rp_2021.particulate_matter_grid', 'MS_Description', 'a square representation of the San Diego region broken into a square polygon grid'
	EXECUTE [db_meta].[add_xp] 'rp_2021.particulate_matter_grid.id', 'MS_Description', 'particulate_matter_grid surrogate key'
	EXECUTE [db_meta].[add_xp] 'rp_2021.particulate_matter_grid.shape', 'MS_Description', 'geometry representation of square polygon grid'
	EXECUTE [db_meta].[add_xp] 'rp_2021.particulate_matter_grid.centroid', 'MS_Description', 'geometry representation of centroid of square polygon grid'
	EXECUTE [db_meta].[add_xp] 'rp_2021.particulate_matter_grid.mgra_13', 'MS_Description', 'the mgra_13 number that contains the square polygon''s centroid'


	-- define the square region to be split into square polygons
	-- ((x_min, y_min), (x_max, y_min), (x_max, y_max), (x_min, y_max))
	-- calculate by taking the envelope of the San Diego Region 2004 polygon
	-- and finding its minimum/maximum latitudes and longitudes
	DECLARE @x_min int = 6150700
	DECLARE @x_max int = 6613500
	DECLARE @y_min int = 1775300
	DECLARE @y_max int = 2129800

	-- create spatial index for the table on the [centroid] attribute
	-- use the square region bounding box of the San Diego region
	-- have to hardcode the bounding box, should match above variables
	SET QUOTED_IDENTIFIER ON; -- set this option for sqlcmd execution
	CREATE SPATIAL INDEX
        spix_particulatemattergrid_centroid
	ON
        [rp_2021].[particulate_matter_grid]([centroid])
    USING
        GEOMETRY_GRID
	WITH (
		BOUNDING_BOX = (xmin=6150700,
                        ymin=1775300,
                        xmax=6613500,
                        ymax=2129800),
		GRIDS = (LOW, LOW, MEDIUM, HIGH),
		CELLS_PER_OBJECT = 64,
		DATA_COMPRESSION = PAGE)

	-- declare size of square polygons to split square region into
    -- 100x100 is currently the agreed upon size
    -- this is noted in the documentation
	DECLARE @grid_size int = 100

	-- build individual polygons for the square region
	DECLARE @x_tracker int = @x_min
	DECLARE @counter int = 0

	WHILE @x_tracker < @x_max
	BEGIN
		DECLARE @y_tracker int = @y_min;
		WHILE @y_tracker < @y_max
		BEGIN
			SET @counter = @counter + 1;
			DECLARE @cell geometry
			DECLARE @centroid geometry
			DECLARE @mgra_13 nchar(20);
			-- build polygon assuming EPSG: 2230
			SET @cell = geometry::STPolyFromText('POLYGON((' + CONVERT(nvarchar, @x_tracker) + ' ' +CONVERT(nvarchar, @y_tracker) + ',' +
															   CONVERT(nvarchar, (@x_tracker + @grid_size)) + ' ' + CONVERT(nvarchar, @y_tracker) + ',' +
															   CONVERT(nvarchar, (@x_tracker + @grid_size)) + ' ' + CONVERT(nvarchar, (@y_tracker + @grid_size)) + ',' +
															   CONVERT(nvarchar, @x_tracker) + ' ' + CONVERT(nvarchar, (@y_tracker + @grid_size)) + ',' +
															   CONVERT(nvarchar, @x_tracker) + ' ' + CONVERT(nvarchar, @y_tracker) + '))', 2230)
			SET @centroid = @cell.STCentroid()

			INSERT INTO [rp_2021].[particulate_matter_grid] (
                [id], [shape], [centroid], [mgra_13]
            )
			VALUES (@counter, @cell, @centroid, 'Not Applicable')

			SET @y_tracker = @y_tracker + @grid_size;
		END
		SET @x_tracker = @x_tracker + @grid_size;
	END


	-- get xref of grid cell to mgra_13
	UPDATE [rp_2021].[particulate_matter_grid]
	SET [particulate_matter_grid].[mgra_13] = [mgras].[mgra_13]
	FROM
        -- this join is considerably sped up by forcing the query to use 
        -- the spatial index in its query plan
		[rp_2021].[particulate_matter_grid] WITH(INDEX(spix_particulatemattergrid_centroid))
	INNER JOIN (
		SELECT
			[mgra_13]
			,[mgra_13_shape]
		FROM
			[dimension].[geography]
		WHERE
			[mgra_13] != 'Not Applicable') AS [mgras]
	ON
		[particulate_matter_grid].[centroid].STWithin([mgra_13_shape]) = 1

	-- remove grid cells that do not match to a mgra_13
	DELETE FROM [rp_2021].[particulate_matter_grid] WHERE [mgra_13] = 'Not Applicable'
END
GO




-- create function to calculate link-level particulate matter for EMFAC 2014 -
DROP FUNCTION IF EXISTS [rp_2021].[fn_particulate_matter_ctemfac_2014]
GO

CREATE FUNCTION [rp_2021].[fn_particulate_matter_ctemfac_2014]
(
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
)
RETURNS TABLE
AS
RETURN
/**	
summary:   >
    Calculate link level emissions for particulate matter for a given ABM
    scenario. Exhaust calculation based on EMFAC 2017 User Guide page 12.
    https://www.arb.ca.gov/msei/downloads/emfac2017-volume-ii-pl-handbook.pdf

    Relies on the ctemfac_2014 database existing in the SQL environment, the
    port of the EMFAC 2014 Access database to SQL Server.

    Similar to [abm_13_2_3].[abm].[ctemfac11_particulate_matter_10]
    stored procedure originally created by Clint Daniels and Ziying Ouyang.

    This function is used in conjunction with the table
    [rp_2021].[particulate_matter_grid] and the stored
    procedure [rp_2021].[sp_particulate_matter_ctemfac_2014] to calculate
    person-level exposure to particulate emissions for EMFAC 2014.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions:
    - author: Gregor Schroeder
      modification: removed Idling Exhaust per Ziying Ouyang request
      date: June 2019
    - author: Gregor Schroeder
      modification: added Idling Exhaust
      date: May 2019
    - author: Gregor Schroeder
      modification: included particulate matter 10, corrected error
        in tire brake wear left outer join that resulted in double-counting of
        link-level running exhaust emissions, removed running loss calculation
        as no particulate matter 2.5 or 10 exists
      date: May 2019
    - author: Gregor Schroeder and Ziying Ouyang
      modification: create and translate to new abm database structure
      date: 10 July 2018
**/
    with [running_exhaust] AS (
        SELECT
	        [Category].[Name] AS [CategoryName]
	        ,[RunningExhaust].[Speed]
	        ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM25',
									                'PM25 TW',
									                'PM25 BW')
                        THEN [RunningExhaust].[Value]
                        ELSE 0 END) AS [Value_PM25]
            ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM10',
                                                    'PM10 TW',
                                                    'PM10 BW')
                        THEN [RunningExhaust].[Value]
                        ELSE 0 END) AS [Value_PM10]
        FROM
	        [ctemfac_2014].[dbo].[RunningExhaust]
        INNER JOIN
	        [ctemfac_2014].[dbo].[Pollutant]
        ON
	        [RunningExhaust].[PollutantID] = [Pollutant].[PollutantID]
        INNER JOIN
	        [ctemfac_2014].[dbo].[Category]
        ON
	        [RunningExhaust].[CategoryID] = [Category].[CategoryID]
        WHERE
	        [RunningExhaust].[AreaID] = (
                SELECT [AreaID] FROM [ctemfac_2014].[dbo].[Area] WHERE [Name] = 'San Diego (SD)'
            )
	        AND [RunningExhaust].[PeriodID] = (
                SELECT [PeriodID] FROM [ctemfac_2014].[dbo].[Period] WHERE [Year] = (
                    SELECT [year] FROM [dimension].[scenario] WHERE [scenario_id] = @scenario_id
                )
                AND [Season] = 'Annual'
            )
            -- particulate matter 2.5 and 10
	        AND [Pollutant].[Name] IN ('PM25',
								       'PM25 TW',
								       'PM25 BW',
                                       'PM10',
                                       'PM10 TW',
                                       'PM10 BW')
        GROUP BY
            [Category].[Name]
	        ,[RunningExhaust].[Speed]),
    [tire_brake_wear] AS (
	    SELECT
		    [Category].[Name] AS [CategoryName]
		    ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM25',
									                'PM25 TW',
									                'PM25 BW')
                        THEN [TireBrakeWear].[Value]
                        ELSE 0 END) AS [Value_PM25]
            ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM10',
                                                    'PM10 TW',
                                                    'PM10 BW')
                        THEN [TireBrakeWear].[Value]
                        ELSE 0 END) AS [Value_PM10]
	    FROM
		    [ctemfac_2014].[dbo].[TireBrakeWear]
	    INNER JOIN
		    [ctemfac_2014].[dbo].[Pollutant]
	    ON
		    [TireBrakeWear].[PollutantID] = [Pollutant].[PollutantID]
	    INNER JOIN
		    [ctemfac_2014].[dbo].[Category]
	    ON
		    [TireBrakeWear].[CategoryID] = [Category].[CategoryID]
	    WHERE
	        [TireBrakeWear].[AreaID] = (
                SELECT [AreaID] FROM [ctemfac_2014].[dbo].[Area] WHERE [Name] = 'San Diego (SD)'
            )
	        AND [TireBrakeWear].[PeriodID] = (
                SELECT [PeriodID] FROM [ctemfac_2014].[dbo].[Period] WHERE [Year] = (
                    SELECT [year] FROM [dimension].[scenario] WHERE [scenario_id] = @scenario_id
                )
                AND [Season] = 'Annual'
            )
            -- particulate matter 2.5 and 10
		    AND [Pollutant].[Name] IN ('PM25',
								       'PM25 TW',
								       'PM25 BW',
                                       'PM10',
                                       'PM10 TW',
                                       'PM10 BW')
        GROUP BY
            [Category].[Name]),
    [travel] AS (
    -- get link level speed and vmt by aggregated modes
    -- include lower and bounds of 5mph speed bins for the link
	    SELECT
		    [hwy_link].[hwy_link_id]
		    ,[hwy_link].[hwycov_id]
		    ,CASE	WHEN [mode].[mode_description] = 'Light Heavy Duty Truck' THEN 'Truck 1'
				    WHEN [mode].[mode_description] IN ('Medium Heavy Duty Truck',
													   'Heavy Heavy Duty Truck')
				    THEN 'Truck 2'
				    ELSE 'Non-truck' END AS [CategoryName]
		    -- create lower bound of 5mph speed bins
		    ,CASE	WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) - 5 < 5
				    THEN 5 -- speed bins begin at 5mph
				    WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) - 5 > 75
				    THEN 75 -- speed bins end at 75mph
				    ELSE 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) - 5
				    END AS [speed_bin_low]
		    -- create upper bound of 5mph speed bins
		    ,CASE	WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) < 5
				    THEN 5 -- speed bins begin at 5mph
				    WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) > 75
				    THEN 75 -- speed bins end at 75mph
				    ELSE 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1)
				    END AS [speed_bin_high]
		    ,[hwy_flow].[speed]
		    ,[hwy_flow_mode].[flow] * [hwy_link].[length_mile] AS [vmt]
	    FROM
		    [fact].[hwy_flow_mode]
	    INNER JOIN
		    [fact].[hwy_flow]
	    ON
		    [hwy_flow_mode].[scenario_id] = [hwy_flow].[scenario_id]
		    AND [hwy_flow_mode].[hwy_link_ab_tod_id] = [hwy_flow].[hwy_link_ab_tod_id]
	    INNER JOIN
		    [dimension].[hwy_link]
	    ON
		    [hwy_flow_mode].[scenario_id] = [hwy_link].[scenario_id]
		    AND [hwy_flow_mode].[hwy_link_id] = [hwy_link].[hwy_link_id]
	    INNER JOIN
		    [dimension].[mode]
	    ON
		    [hwy_flow_mode].[mode_id] = [mode].[mode_id]
	    INNER JOIN
		    [dimension].[time]
	    ON
		    [hwy_flow_mode].[time_id] = [time].[time_id]
	    WHERE
		    [hwy_flow_mode].[scenario_id] = @scenario_id
		    AND [hwy_flow].[scenario_id] = @scenario_id
		    AND [hwy_link].[scenario_id] = @scenario_id
            AND [hwy_flow_mode].[flow] * [hwy_link].[length_mile] > 0),
    [link_emissions] AS (
        SELECT
	        [travel].[hwy_link_id]
	        ,[travel].[hwycov_id]
            -- stratify by particulate matter 2.5 and 10
	        -- running exhaust calculation based on EMFAC 2017 User Guide page 12
	        -- https://www.arb.ca.gov/msei/downloads/emfac2017-volume-ii-pl-handbook.pdf
            ,SUM(ISNULL([travel].[vmt] * ([running_exhaust_high].[Value_PM25] * ([travel].[speed] - ([travel].[speed_bin_low] - 2.5)) / 5 +
					        [running_exhaust_low].[Value_PM25] * (([travel].[speed_bin_high] - 2.5) - [travel].[speed]) / 5),
				        0)) AS [running_exhaust_PM25]
            ,SUM(ISNULL([travel].[vmt] * [tire_brake_wear].[Value_PM25], 0)) AS [tire_brake_wear_PM25]
            ,SUM(ISNULL([travel].[vmt] * ([running_exhaust_high].[Value_PM10] * ([travel].[speed] - ([travel].[speed_bin_low] - 2.5)) / 5 +
					        [running_exhaust_low].[Value_PM10] * (([travel].[speed_bin_high] - 2.5) - [travel].[speed]) / 5),
				        0)) AS [running_exhaust_PM10]
            ,SUM(ISNULL([travel].[vmt] * [tire_brake_wear].[Value_PM10], 0)) AS [tire_brake_wear_PM10]
        FROM
	        [travel]
        LEFT OUTER JOIN
	        [running_exhaust] AS [running_exhaust_low]
        ON
	        [travel].[CategoryName] = [running_exhaust_low].[CategoryName]
	        AND [travel].[speed_bin_low] = [running_exhaust_low].[Speed]
        LEFT OUTER JOIN
	        [running_exhaust] AS [running_exhaust_high]
        ON
	        [travel].[CategoryName] = [running_exhaust_high].[CategoryName]
	        AND [travel].[speed_bin_high] = [running_exhaust_high].[Speed]
        LEFT OUTER JOIN
	        [tire_brake_wear]
        ON
	        [travel].[CategoryName] = [tire_brake_wear].[CategoryName]
        GROUP BY
	        [travel].[hwy_link_id]
	        ,[travel].[hwycov_id])
    SELECT
        @scenario_id AS [scenario_id]
	    ,[hwy_link_id]
	    ,[hwycov_id]
        ,[running_exhaust_PM25]
        ,[running_exhaust_PM10]
	    ,[running_exhaust_PM25] + [running_exhaust_PM10] AS [running_exhaust]
	    ,[tire_brake_wear_PM25]
        ,[tire_brake_wear_PM10]
        ,[tire_brake_wear_PM25] + [tire_brake_wear_PM10] AS [tire_brake_wear]
	    ,[running_exhaust_PM25] + [tire_brake_wear_PM25] AS [link_total_emissions_PM25]
	    ,[running_exhaust_PM10] + [tire_brake_wear_PM10] AS [link_total_emissions_PM10]
	    ,[running_exhaust_PM25] + [tire_brake_wear_PM25] +
	        [running_exhaust_PM10] + [tire_brake_wear_PM10] AS [link_total_emissions]
    FROM
	    [link_emissions]
GO

-- add metadata for [rp_2021].[fn_particulate_matter_ctemfac_2014]
EXECUTE [db_meta].[add_xp] 'rp_2021.fn_particulate_matter_ctemfac_2014', 'MS_Description', 'calculate link level particulate matter 2.5 and 10 emissions using emfac 2014'
GO




-- create function to calculate link-level particulate matter for EMFAC 2017 -
DROP FUNCTION IF EXISTS [rp_2021].[fn_particulate_matter_ctemfac_2017]
GO

CREATE FUNCTION [rp_2021].[fn_particulate_matter_ctemfac_2017]
(
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
)
RETURNS TABLE
AS
RETURN
/**	
summary:   >
    Calculate link level emissions for particulate matter for a given ABM
    scenario. Exhaust calculation based on EMFAC 2017 User Guide page 12.
    https://www.arb.ca.gov/msei/downloads/emfac2017-volume-ii-pl-handbook.pdf

    Relies on the ctemfac_2017 database existing in the SQL environment, the
    port of the EMFAC 2017 Access database to SQL Server.

    Similar to [abm_13_2_3].[abm].[ctemfac11_particulate_matter_10]
    stored procedure originally created by Clint Daniels and Ziying Ouyang.

    This function is used in conjunction with the table
    [rp_2021].[particulate_matter_grid] and the stored
    procedure [rp_2021].[sp_particulate_matter_ctemfac_2017] to calculate
    person-level exposure to particulate emissions for EMFAC 2017.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions:
    - author: Gregor Schroeder
      modification: removed Idling Exhaust per Ziying Ouyang request
      date: June 2019
    - author: Gregor Schroeder
      modification: added Idling Exhaust
      date: May 2019
    - author: Gregor Schroeder
      modification: included particulate matter 10, corrected error
        in tire brake wear left outer join that resulted in double-counting of
        link-level running exhaust emissions, removed running loss calculation
        as no particulate matter 2.5 or 10 exists
      date: May 2019
    - author: Gregor Schroeder and Ziying Ouyang
      modification: create and translate to new abm database structure
      date: 10 July 2018
**/
    with [running_exhaust] AS (
        SELECT
	        [Category].[Name] AS [CategoryName]
	        ,[RunningExhaust].[Speed]
	        ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM25',
									                'PM25 TW',
									                'PM25 BW')
                        THEN [RunningExhaust].[Value]
                        ELSE 0 END) AS [Value_PM25]
            ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM10',
                                                    'PM10 TW',
                                                    'PM10 BW')
                        THEN [RunningExhaust].[Value]
                        ELSE 0 END) AS [Value_PM10]
        FROM
	        [ctemfac_2017].[dbo].[RunningExhaust]
        INNER JOIN
	        [ctemfac_2017].[dbo].[Pollutant]
        ON
	        [RunningExhaust].[PollutantID] = [Pollutant].[PollutantID]
        INNER JOIN
	        [ctemfac_2017].[dbo].[Category]
        ON
	        [RunningExhaust].[CategoryID] = [Category].[CategoryID]
        WHERE
	        [RunningExhaust].[AreaID] = (
                SELECT [AreaID] FROM [ctemfac_2017].[dbo].[Area] WHERE [Name] = 'San Diego (SD)'
            )
	        AND [RunningExhaust].[PeriodID] = (
                SELECT [PeriodID] FROM [ctemfac_2017].[dbo].[Period] WHERE [Year] = (
                    SELECT [year] FROM [dimension].[scenario] WHERE [scenario_id] = @scenario_id
                )
                AND [Season] = 'Annual'
            )
            -- particulate matter 2.5 and 10
	        AND [Pollutant].[Name] IN ('PM25',
								       'PM25 TW',
								       'PM25 BW',
                                       'PM10',
                                       'PM10 TW',
                                       'PM10 BW')
        GROUP BY
            [Category].[Name]
	        ,[RunningExhaust].[Speed]),
    [tire_brake_wear] AS (
	    SELECT
		    [Category].[Name] AS [CategoryName]
		    ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM25',
									                'PM25 TW',
									                'PM25 BW')
                        THEN [TireBrakeWear].[Value]
                        ELSE 0 END) AS [Value_PM25]
            ,SUM(CASE   WHEN [Pollutant].[Name] IN ('PM10',
                                                    'PM10 TW',
                                                    'PM10 BW')
                        THEN [TireBrakeWear].[Value]
                        ELSE 0 END) AS [Value_PM10]
	    FROM
		    [ctemfac_2017].[dbo].[TireBrakeWear]
	    INNER JOIN
		    [ctemfac_2017].[dbo].[Pollutant]
	    ON
		    [TireBrakeWear].[PollutantID] = [Pollutant].[PollutantID]
	    INNER JOIN
		    [ctemfac_2017].[dbo].[Category]
	    ON
		    [TireBrakeWear].[CategoryID] = [Category].[CategoryID]
	    WHERE
	        [TireBrakeWear].[AreaID] = (
                SELECT [AreaID] FROM [ctemfac_2017].[dbo].[Area] WHERE [Name] = 'San Diego (SD)'
            )
	        AND [TireBrakeWear].[PeriodID] = (
                SELECT [PeriodID] FROM [ctemfac_2017].[dbo].[Period] WHERE [Year] = (
                    SELECT [year] FROM [dimension].[scenario] WHERE [scenario_id] = @scenario_id
                )
                AND [Season] = 'Annual'
            )
            -- particulate matter 2.5 and 10
		    AND [Pollutant].[Name] IN ('PM25',
								       'PM25 TW',
								       'PM25 BW',
                                       'PM10',
                                       'PM10 TW',
                                       'PM10 BW')
        GROUP BY
            [Category].[Name]),
    [travel] AS (
    -- get link level speed and vmt by aggregated modes
    -- include lower and bounds of 5mph speed bins for the link
	    SELECT
		    [hwy_link].[hwy_link_id]
		    ,[hwy_link].[hwycov_id]
		    ,CASE	WHEN [mode].[mode_description] = 'Light Heavy Duty Truck' THEN 'Truck 1'
				    WHEN [mode].[mode_description] IN ('Medium Heavy Duty Truck',
													   'Heavy Heavy Duty Truck')
				    THEN 'Truck 2'
				    ELSE 'Non-truck' END AS [CategoryName]
		    -- create lower bound of 5mph speed bins
		    ,CASE	WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) - 5 < 5
				    THEN 5 -- speed bins begin at 5mph
				    WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) - 5 > 75
				    THEN 75 -- speed bins end at 75mph
				    ELSE 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) - 5
				    END AS [speed_bin_low]
		    -- create upper bound of 5mph speed bins
		    ,CASE	WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) < 5
				    THEN 5 -- speed bins begin at 5mph
				    WHEN 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1) > 75
				    THEN 75 -- speed bins end at 75mph
				    ELSE 5 * ((CAST([hwy_flow].[speed] AS integer) / 5) + 1)
				    END AS [speed_bin_high]
		    ,[hwy_flow].[speed]
		    ,[hwy_flow_mode].[flow] * [hwy_link].[length_mile] AS [vmt]
	    FROM
		    [fact].[hwy_flow_mode]
	    INNER JOIN
		    [fact].[hwy_flow]
	    ON
		    [hwy_flow_mode].[scenario_id] = [hwy_flow].[scenario_id]
		    AND [hwy_flow_mode].[hwy_link_ab_tod_id] = [hwy_flow].[hwy_link_ab_tod_id]
	    INNER JOIN
		    [dimension].[hwy_link]
	    ON
		    [hwy_flow_mode].[scenario_id] = [hwy_link].[scenario_id]
		    AND [hwy_flow_mode].[hwy_link_id] = [hwy_link].[hwy_link_id]
	    INNER JOIN
		    [dimension].[mode]
	    ON
		    [hwy_flow_mode].[mode_id] = [mode].[mode_id]
	    INNER JOIN
		    [dimension].[time]
	    ON
		    [hwy_flow_mode].[time_id] = [time].[time_id]
	    WHERE
		    [hwy_flow_mode].[scenario_id] = @scenario_id
		    AND [hwy_flow].[scenario_id] = @scenario_id
		    AND [hwy_link].[scenario_id] = @scenario_id
            AND [hwy_flow_mode].[flow] * [hwy_link].[length_mile] > 0),
    [link_emissions] AS (
        SELECT
	        [travel].[hwy_link_id]
	        ,[travel].[hwycov_id]
            -- stratify by particulate matter 2.5 and 10
	        -- running exhaust calculation based on EMFAC 2017 User Guide page 12
	        -- https://www.arb.ca.gov/msei/downloads/emfac2017-volume-ii-pl-handbook.pdf
            ,SUM(ISNULL([travel].[vmt] * ([running_exhaust_high].[Value_PM25] * ([travel].[speed] - ([travel].[speed_bin_low] - 2.5)) / 5 +
					        [running_exhaust_low].[Value_PM25] * (([travel].[speed_bin_high] - 2.5) - [travel].[speed]) / 5),
				        0)) AS [running_exhaust_PM25]
            ,SUM(ISNULL([travel].[vmt] * [tire_brake_wear].[Value_PM25], 0)) AS [tire_brake_wear_PM25]
            ,SUM(ISNULL([travel].[vmt] * ([running_exhaust_high].[Value_PM10] * ([travel].[speed] - ([travel].[speed_bin_low] - 2.5)) / 5 +
					        [running_exhaust_low].[Value_PM10] * (([travel].[speed_bin_high] - 2.5) - [travel].[speed]) / 5),
				        0)) AS [running_exhaust_PM10]
            ,SUM(ISNULL([travel].[vmt] * [tire_brake_wear].[Value_PM10], 0)) AS [tire_brake_wear_PM10]
        FROM
	        [travel]
        LEFT OUTER JOIN
	        [running_exhaust] AS [running_exhaust_low]
        ON
	        [travel].[CategoryName] = [running_exhaust_low].[CategoryName]
	        AND [travel].[speed_bin_low] = [running_exhaust_low].[Speed]
        LEFT OUTER JOIN
	        [running_exhaust] AS [running_exhaust_high]
        ON
	        [travel].[CategoryName] = [running_exhaust_high].[CategoryName]
	        AND [travel].[speed_bin_high] = [running_exhaust_high].[Speed]
        LEFT OUTER JOIN
	        [tire_brake_wear]
        ON
	        [travel].[CategoryName] = [tire_brake_wear].[CategoryName]
        GROUP BY
	        [travel].[hwy_link_id]
	        ,[travel].[hwycov_id])
    SELECT
        @scenario_id AS [scenario_id]
	    ,[hwy_link_id]
	    ,[hwycov_id]
        ,[running_exhaust_PM25]
        ,[running_exhaust_PM10]
	    ,[running_exhaust_PM25] + [running_exhaust_PM10] AS [running_exhaust]
	    ,[tire_brake_wear_PM25]
        ,[tire_brake_wear_PM10]
        ,[tire_brake_wear_PM25] + [tire_brake_wear_PM10] AS [tire_brake_wear]
	    ,[running_exhaust_PM25] + [tire_brake_wear_PM25] AS [link_total_emissions_PM25]
	    ,[running_exhaust_PM10] + [tire_brake_wear_PM10] AS [link_total_emissions_PM10]
	    ,[running_exhaust_PM25] + [tire_brake_wear_PM25] +
	        [running_exhaust_PM10] + [tire_brake_wear_PM10] AS [link_total_emissions]
    FROM
	    [link_emissions]
GO

-- add metadata for [rp_2021].[fn_particulate_matter_ctemfac_2017]
EXECUTE [db_meta].[add_xp] 'rp_2021.fn_particulate_matter_ctemfac_2017', 'MS_Description', 'calculate link level particulate matter 2.5 and 10 emissions using emfac 2017'
GO




-- create stored procedure to calculate 
-- person-level particulate matter exposure ----------------------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_particulate_matter_ctemfac_2014]
GO

CREATE PROCEDURE [rp_2021].[sp_particulate_matter_ctemfac_2014]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@distance integer = 1000,  -- maximum distance of emissions exposure in feet
	@shoulder_width integer = 10  -- width of road shoulder in feet
AS
/**
summary:   >
     Calculate person-level exposure to particulate matter for a given ABM
     scenario. Returns both total and average per person exposure to tons of
     particulate matter 2.5 and 10 emissions for the total population and
     within Community of Concern groups.

    This stored procedure is used in conjunction with the table
    [rp_2021].[particulate_matter_grid] and the function
    [rp_2021].[fn_particulate_matter_ctemfac_2014] to calculate
    person-level exposure to particulate matter 2.5 and 10 emissions.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions:
    - author: Gregor Schroeder
      modification: switch final output metric from total particulate
        matter exposure to average person particulate matter exposure
      date: 14 June 2019
    - author: Gregor Schroeder
      modification: update to include particulate matter 10 and the updated
        [rp_2021].[fn_particulate_matter_ctemfac_2014] function
      date: 8 May 2019
    - author: Gregor Schroeder
      modification: create and translate to new abm database structure
      date: 12 July 2018
**/
SET NOCOUNT ON;

-- create temporary table of the xref between the highway network and the
-- 100x100 square grid representation of San Diego County
SELECT
	[particulate_matter_grid].[id]
	,[hwy_link_lanes].[hwy_link_id]
	,[hwy_link_lanes].[hwycov_id]
	,CASE	WHEN [hwy_link_lanes].[shape].STDistance([particulate_matter_grid].[centroid])
	            - @shoulder_width - CEILING([hwy_link_lanes].[lanes] / 2.0) * 12 <= 0
		    THEN 100
		    ELSE CEILING(([hwy_link_lanes].[shape].STDistance([particulate_matter_grid].[centroid]) -
		        @shoulder_width - CEILING([hwy_link_lanes].[lanes] / 2.0) * 12) / 100.0) * 100
		    END AS [interval]
	INTO #xref_grid_hwycov
FROM (
	SELECT
		[hwy_link].[hwy_link_id]
		,[hwy_link].[hwycov_id]
		,CONVERT(integer,
				CASE	WHEN [hwy_link].[iway] = 2
						THEN [ln_max] * 2
						ELSE [ln_max] END) AS [lanes]
		,[hwy_link].[shape].MakeValid() AS [shape]
	FROM
		[dimension].[hwy_link]
	INNER JOIN (
		SELECT
			[hwy_link_id]
			,MAX([ln]) AS [ln_max]
		FROM
			[dimension].[hwy_link_ab_tod]
		WHERE
			[scenario_id] = @scenario_id
			AND [ln] < 9 -- this coding means lane unavailable
		GROUP BY
			[hwy_link_id]) AS [link_ln_max]
	ON
		[hwy_link].[scenario_id] = @scenario_id
		AND [hwy_link].[hwy_link_id] = [link_ln_max].[hwy_link_id]
	WHERE
		[hwy_link].[scenario_id] = @scenario_id
		AND [hwy_link].[ifc] < 10) AS [hwy_link_lanes]
INNER JOIN
	[rp_2021].[particulate_matter_grid] WITH(INDEX(spix_particulatemattergrid_centroid))
ON
	[particulate_matter_grid].[centroid].STWithin([hwy_link_lanes].[shape].STBuffer(@distance + @shoulder_width + CEILING([hwy_link_lanes].[lanes] / 2.0) * 12)) = 1;


-- use the highway network to grid xref to output the final results
-- for Particulate Matter 2.5 and 10
with [grid_particulate_matter] AS (
-- for each (link, interval) tuple
-- calculate the link emissions at that interval/distance multiplied by 2 to assume symmetric emissions
-- assign the emissions uniformly to all the grids that the (link, interval) tuple is matched to
	SELECT
		#xref_grid_hwycov.[id]
        ,SUM([assigned_PM25]) AS [assigned_PM25]
        ,SUM([assigned_PM10]) AS [assigned_PM10]
		,SUM([assigned_PM]) AS [assigned_PM]
	FROM (
		SELECT
			#xref_grid_hwycov.[hwy_link_id]
			,[interval]
			,2 * [link_total_emissions_PM25] / COUNT([id]) / ([interval] / 100.0) AS [assigned_PM25]
            ,2 * [link_total_emissions_PM10] / COUNT([id]) / ([interval] / 100.0) AS [assigned_PM10]
            ,2 * [link_total_emissions] / COUNT([id]) / ([interval] / 100.0) AS [assigned_PM]
		FROM
			#xref_grid_hwycov
		INNER JOIN
			[rp_2021].[fn_particulate_matter_ctemfac_2014](@scenario_id)
		ON
			#xref_grid_hwycov.[hwycov_id] = [fn_particulate_matter_ctemfac_2014].[hwycov_id]
		GROUP BY
			#xref_grid_hwycov.[hwy_link_id]
			,[interval]
            ,[link_total_emissions_PM25]
            ,[link_total_emissions_PM10]
			,[link_total_emissions]
		HAVING
			(COUNT([id]) / 2) / ([interval] / 100.0) > 0) AS [link_interval_emissions]
	INNER JOIN
		#xref_grid_hwycov
	ON
		#xref_grid_hwycov.[hwy_link_id] = [link_interval_emissions].[hwy_link_id]
		AND #xref_grid_hwycov.[interval] = [link_interval_emissions].[interval]
	INNER JOIN
		[rp_2021].[particulate_matter_grid]
	ON
		#xref_grid_hwycov.[id] = [particulate_matter_grid].[id]
	GROUP BY
		#xref_grid_hwycov.[id]),
[mgra_13_particulate_matter] AS (
-- average the grid emissions within each mgra, grids are of equal size so average is ok
	SELECT
		[particulate_matter_grid].[mgra_13]
        ,AVG(ISNULL([assigned_PM25], 0)) AS [avg_PM25]
        ,AVG(ISNULL([assigned_PM10], 0)) AS [avg_PM10]
		,AVG(ISNULL([assigned_PM], 0)) AS [avg_PM]
	FROM
		[rp_2021].[particulate_matter_grid]
	LEFT OUTER JOIN
		[grid_particulate_matter]
	ON
		[particulate_matter_grid].[id] = [grid_particulate_matter].[id]
	GROUP BY
		[mgra_13]),
[population] AS (
    SELECT
	    [geography_household_location].[household_location_mgra_13]
	    ,SUM(CASE WHEN [fn_person_coc].[person_id] > 0 THEN 1 ELSE 0 END) AS [persons]  -- remove not applicable records
	    ,SUM(CASE WHEN [fn_person_coc].[senior] = 'Senior' THEN 1 ELSE 0 END) AS [senior]
	    ,SUM(CASE WHEN [fn_person_coc].[senior] = 'Non-Senior' THEN 1 ELSE 0 END) AS [non_senior]
        ,SUM(CASE WHEN [fn_person_coc].[minority] = 'Minority' THEN 1 ELSE 0 END) AS [minority]
	    ,SUM(CASE WHEN [fn_person_coc].[minority] = 'Non-Minority' THEN 1 ELSE 0 END) AS [non_minority]
        ,SUM(CASE WHEN [fn_person_coc].[low_income] = 'Low Income' THEN 1 ELSE 0 END) AS [low_income]
	    ,SUM(CASE WHEN [fn_person_coc].[low_income] = 'Non-Low Income' THEN 1 ELSE 0 END) AS [non_low_income]
    FROM
	    [rp_2021].[fn_person_coc] (@scenario_id)
    INNER JOIN
	    [dimension].[household]
    ON
	    [fn_person_coc].[scenario_id] = [household].[scenario_id]
	    AND [fn_person_coc].[household_id] = [household].[household_id]
    INNER JOIN
	    [dimension].[geography_household_location] -- this is at the mgra_13 level
    ON
	    [household].[geography_household_location_id] = [geography_household_location].[geography_household_location_id]
    WHERE
	    [fn_person_coc].[scenario_id] = @scenario_id
	    AND [household].[scenario_id] = @scenario_id
    GROUP BY
	    [geography_household_location].[household_location_mgra_13])
SELECT
    [Particulate Matter]
    ,[Population]
    ,[Average Particulate Matter]
FROM (
    SELECT
        SUM(ISNULL([avg_PM25], 0) * [persons]) / SUM([persons]) AS [person_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [persons]) / SUM([persons]) AS [person_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [persons]) / SUM([persons]) AS [person_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [senior]) / SUM([senior]) AS [senior_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [senior]) / SUM([senior]) AS [senior_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [senior]) / SUM([senior]) AS [senior_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_senior]) / SUM([non_senior]) AS [non_senior_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_senior]) / SUM([non_senior]) AS [non_senior_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_senior]) / SUM([non_senior]) AS [non_senior_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [minority]) / SUM([minority]) AS [minority_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [minority]) / SUM([minority]) AS [minority_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [minority]) / SUM([minority]) AS [minority_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_minority]) / SUM([non_minority]) AS [non_minority_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_minority]) / SUM([non_minority]) AS [non_minority_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_minority]) / SUM([non_minority]) AS [non_minority_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [low_income]) / SUM([low_income]) AS [low_income_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [low_income]) / SUM([low_income]) AS [low_income_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [low_income]) / SUM([low_income]) AS [low_income_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_low_income]) / SUM([non_low_income]) AS [non_low_income_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_low_income]) / SUM([non_low_income]) AS [non_low_income_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_low_income]) / SUM([non_low_income]) AS [non_low_income_PM]
    FROM
	    [population]
    LEFT OUTER JOIN
	    [mgra_13_particulate_matter]
    ON
	    [population].[household_location_mgra_13] = [mgra_13_particulate_matter].[mgra_13]
) AS [tt]
CROSS APPLY (
    VALUES ('Particulate Matter 2.5', 'Total', [person_PM25]),
           ('Particulate Matter 10', 'Total', [person_PM10]),
           ('Particulate Matter 2.5 and 10', 'Total', [person_PM]),
           ('Particulate Matter 2.5', 'Senior', [senior_PM25]),
           ('Particulate Matter 10', 'Senior', [senior_PM10]),
           ('Particulate Matter 2.5 and 10', 'Senior', [senior_PM]),
           ('Particulate Matter 2.5', 'Non-Senior', [non_senior_PM25]),
           ('Particulate Matter 10', 'Non-Senior', [non_senior_PM10]),
           ('Particulate Matter 2.5 and 10', 'Non-Senior', [non_senior_PM]),
           ('Particulate Matter 2.5', 'Minority', [minority_PM25]),
           ('Particulate Matter 10', 'Minority', [minority_PM10]),
           ('Particulate Matter 2.5 and 10', 'Minority', [minority_PM]),
           ('Particulate Matter 2.5', 'Non-Minority', [non_minority_PM25]),
           ('Particulate Matter 10', 'Non-Minority', [non_minority_PM10]),
           ('Particulate Matter 2.5 and 10', 'Non-Minority', [non_minority_PM]),
           ('Particulate Matter 2.5', 'Low Income', [low_income_PM25]),
           ('Particulate Matter 10', 'Low Income', [low_income_PM10]),
           ('Particulate Matter 2.5 and 10', 'Low Income', [low_income_PM]),
           ('Particulate Matter 2.5', 'Non-Low Income', [non_low_income_PM25]),
           ('Particulate Matter 10', 'Non-Low Income', [non_low_income_PM10]),
           ('Particulate Matter 2.5 and 10', 'Non-Low Income', [non_low_income_PM]))
x([Particulate Matter],
  [Population],
  [Average Particulate Matter])
OPTION(MAXDOP 1)


-- drop the highway network to grid xref temporary table
DROP TABLE #xref_grid_hwycov
GO

-- add metadata for [rp_2021].[sp_particulate_matter_ctemfac_2014]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_particulate_matter_ctemfac_2014', 'MS_Description', 'calculate person-level particulate matter 2.5 and 10 exposure using EMFAC 2014'
GO




-- create stored procedure to calculate
-- person-level particulate matter exposure ----------------------------------
DROP PROCEDURE IF EXISTS [rp_2021].[sp_particulate_matter_ctemfac_2017]
GO

CREATE PROCEDURE [rp_2021].[sp_particulate_matter_ctemfac_2017]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@distance integer = 1000,  -- maximum distance of emissions exposure in feet
	@shoulder_width integer = 10  -- width of road shoulder in feet
AS
/**
summary:   >
     Calculate person-level exposure to particulate matter for a given ABM
     scenario. Returns both total and average per person exposure to tons of
     particulate matter 2.5 and 10 emissions for the total population and
     within Community of Concern groups.

    This stored procedure is used in conjunction with the table
    [rp_2021].[particulate_matter_grid] and the function
    [rp_2021].[fn_particulate_matter_ctemfac_2017] to calculate
    person-level exposure to particulate matter 2.5 and 10 emissions.

    This recreates a process developed previously for the 2015 Regional
    Transporation Plan to calculate exposure to particulate matter 10 by
    Clint Daniels with input from Grace Chung.

revisions:
    - author: Gregor Schroeder
      modification: switch final output metric from total particulate
        matter exposure to average person particulate matter exposure
      date: 14 June 2019
    - author: Gregor Schroeder
      modification: update to include particulate matter 10 and the updated
        [rp_2021].[fn_particulate_matter_ctemfac_2017] function
      date: 8 May 2019
    - author: Gregor Schroeder
      modification: create and translate to new abm database structure
      date: 12 July 2018
**/
SET NOCOUNT ON;

-- create temporary table of the xref between the highway network and the
-- 100x100 square grid representation of San Diego County
SELECT
	[particulate_matter_grid].[id]
	,[hwy_link_lanes].[hwy_link_id]
	,[hwy_link_lanes].[hwycov_id]
	,CASE	WHEN [hwy_link_lanes].[shape].STDistance([particulate_matter_grid].[centroid])
	            - @shoulder_width - CEILING([hwy_link_lanes].[lanes] / 2.0) * 12 <= 0
		    THEN 100
		    ELSE CEILING(([hwy_link_lanes].[shape].STDistance([particulate_matter_grid].[centroid]) -
		        @shoulder_width - CEILING([hwy_link_lanes].[lanes] / 2.0) * 12) / 100.0) * 100
		    END AS [interval]
	INTO #xref_grid_hwycov
FROM (
	SELECT
		[hwy_link].[hwy_link_id]
		,[hwy_link].[hwycov_id]
		,CONVERT(integer,
				CASE	WHEN [hwy_link].[iway] = 2
						THEN [ln_max] * 2
						ELSE [ln_max] END) AS [lanes]
		,[hwy_link].[shape].MakeValid() AS [shape]
	FROM
		[dimension].[hwy_link]
	INNER JOIN (
		SELECT
			[hwy_link_id]
			,MAX([ln]) AS [ln_max]
		FROM
			[dimension].[hwy_link_ab_tod]
		WHERE
			[scenario_id] = @scenario_id
			AND [ln] < 9 -- this coding means lane unavailable
		GROUP BY
			[hwy_link_id]) AS [link_ln_max]
	ON
		[hwy_link].[scenario_id] = @scenario_id
		AND [hwy_link].[hwy_link_id] = [link_ln_max].[hwy_link_id]
	WHERE
		[hwy_link].[scenario_id] = @scenario_id
		AND [hwy_link].[ifc] < 10) AS [hwy_link_lanes]
INNER JOIN
	[rp_2021].[particulate_matter_grid] WITH(INDEX(spix_particulatemattergrid_centroid))
ON
	[particulate_matter_grid].[centroid].STWithin([hwy_link_lanes].[shape].STBuffer(@distance + @shoulder_width + CEILING([hwy_link_lanes].[lanes] / 2.0) * 12)) = 1;


-- use the highway network to grid xref to output the final results
-- for Particulate Matter 2.5 and 10
with [grid_particulate_matter] AS (
-- for each (link, interval) tuple
-- calculate the link emissions at that interval/distance multiplied by 2 to assume symmetric emissions
-- assign the emissions uniformly to all the grids that the (link, interval) tuple is matched to
	SELECT
		#xref_grid_hwycov.[id]
        ,SUM([assigned_PM25]) AS [assigned_PM25]
        ,SUM([assigned_PM10]) AS [assigned_PM10]
		,SUM([assigned_PM]) AS [assigned_PM]
	FROM (
		SELECT
			#xref_grid_hwycov.[hwy_link_id]
			,[interval]
			,2 * [link_total_emissions_PM25] / COUNT([id]) / ([interval] / 100.0) AS [assigned_PM25]
            ,2 * [link_total_emissions_PM10] / COUNT([id]) / ([interval] / 100.0) AS [assigned_PM10]
            ,2 * [link_total_emissions] / COUNT([id]) / ([interval] / 100.0) AS [assigned_PM]
		FROM
			#xref_grid_hwycov
		INNER JOIN
			[rp_2021].[fn_particulate_matter_ctemfac_2017](@scenario_id)
		ON
			#xref_grid_hwycov.[hwycov_id] = [fn_particulate_matter_ctemfac_2017].[hwycov_id]
		GROUP BY
			#xref_grid_hwycov.[hwy_link_id]
			,[interval]
            ,[link_total_emissions_PM25]
            ,[link_total_emissions_PM10]
			,[link_total_emissions]
		HAVING
			(COUNT([id]) / 2) / ([interval] / 100.0) > 0) AS [link_interval_emissions]
	INNER JOIN
		#xref_grid_hwycov
	ON
		#xref_grid_hwycov.[hwy_link_id] = [link_interval_emissions].[hwy_link_id]
		AND #xref_grid_hwycov.[interval] = [link_interval_emissions].[interval]
	INNER JOIN
		[rp_2021].[particulate_matter_grid]
	ON
		#xref_grid_hwycov.[id] = [particulate_matter_grid].[id]
	GROUP BY
		#xref_grid_hwycov.[id]),
[mgra_13_particulate_matter] AS (
-- average the grid emissions within each mgra, grids are of equal size so average is ok
	SELECT
		[particulate_matter_grid].[mgra_13]
        ,AVG(ISNULL([assigned_PM25], 0)) AS [avg_PM25]
        ,AVG(ISNULL([assigned_PM10], 0)) AS [avg_PM10]
		,AVG(ISNULL([assigned_PM], 0)) AS [avg_PM]
	FROM
		[rp_2021].[particulate_matter_grid]
	LEFT OUTER JOIN
		[grid_particulate_matter]
	ON
		[particulate_matter_grid].[id] = [grid_particulate_matter].[id]
	GROUP BY
		[mgra_13]),
[population] AS (
    SELECT
        [geography_household_location].[household_location_mgra_13]
	    ,SUM(CASE WHEN [fn_person_coc].[person_id] > 0 THEN 1 ELSE 0 END) AS [persons]  -- remove not applicable records
	    ,SUM(CASE WHEN [fn_person_coc].[senior] = 'Senior' THEN 1 ELSE 0 END) AS [senior]
	    ,SUM(CASE WHEN [fn_person_coc].[senior] = 'Non-Senior' THEN 1 ELSE 0 END) AS [non_senior]
        ,SUM(CASE WHEN [fn_person_coc].[minority] = 'Minority' THEN 1 ELSE 0 END) AS [minority]
	    ,SUM(CASE WHEN [fn_person_coc].[minority] = 'Non-Minority' THEN 1 ELSE 0 END) AS [non_minority]
        ,SUM(CASE WHEN [fn_person_coc].[low_income] = 'Low Income' THEN 1 ELSE 0 END) AS [low_income]
	    ,SUM(CASE WHEN [fn_person_coc].[low_income] = 'Non-Low Income' THEN 1 ELSE 0 END) AS [non_low_income]
    FROM
	    [rp_2021].[fn_person_coc] (@scenario_id)
    INNER JOIN
	    [dimension].[household]
    ON
	    [fn_person_coc].[scenario_id] = [household].[scenario_id]
	    AND [fn_person_coc].[household_id] = [household].[household_id]
    INNER JOIN
	    [dimension].[geography_household_location] -- this is at the mgra_13 level
    ON
	    [household].[geography_household_location_id] = [geography_household_location].[geography_household_location_id]
    WHERE
	    [fn_person_coc].[scenario_id] = @scenario_id
	    AND [household].[scenario_id] = @scenario_id
    GROUP BY
	    [geography_household_location].[household_location_mgra_13])
SELECT
    [Particulate Matter]
    ,[Population]
    ,[Average Particulate Matter]
FROM (
    SELECT
        SUM(ISNULL([avg_PM25], 0) * [persons]) / SUM([persons]) AS [person_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [persons]) / SUM([persons]) AS [person_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [persons]) / SUM([persons]) AS [person_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [senior]) / SUM([senior]) AS [senior_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [senior]) / SUM([senior]) AS [senior_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [senior]) / SUM([senior]) AS [senior_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_senior]) / SUM([non_senior]) AS [non_senior_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_senior]) / SUM([non_senior]) AS [non_senior_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_senior]) / SUM([non_senior]) AS [non_senior_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [minority]) / SUM([minority]) AS [minority_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [minority]) / SUM([minority]) AS [minority_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [minority]) / SUM([minority]) AS [minority_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_minority]) / SUM([non_minority]) AS [non_minority_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_minority]) / SUM([non_minority]) AS [non_minority_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_minority]) / SUM([non_minority]) AS [non_minority_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [low_income]) / SUM([low_income]) AS [low_income_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [low_income]) / SUM([low_income]) AS [low_income_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [low_income]) / SUM([low_income]) AS [low_income_PM]
        ,SUM(ISNULL([avg_PM25], 0) * [non_low_income]) / SUM([non_low_income]) AS [non_low_income_PM25]
        ,SUM(ISNULL([avg_PM10], 0) * [non_low_income]) / SUM([non_low_income]) AS [non_low_income_PM10]
        ,SUM(ISNULL([avg_PM], 0) * [non_low_income]) / SUM([non_low_income]) AS [non_low_income_PM]
    FROM
	    [population]
    LEFT OUTER JOIN
	    [mgra_13_particulate_matter]
    ON
	    [population].[household_location_mgra_13] = [mgra_13_particulate_matter].[mgra_13]
) AS [tt]
CROSS APPLY (
    VALUES ('Particulate Matter 2.5', 'Total', [person_PM25]),
           ('Particulate Matter 10', 'Total', [person_PM10]),
           ('Particulate Matter 2.5 and 10', 'Total', [person_PM]),
           ('Particulate Matter 2.5', 'Senior', [senior_PM25]),
           ('Particulate Matter 10', 'Senior', [senior_PM10]),
           ('Particulate Matter 2.5 and 10', 'Senior', [senior_PM]),
           ('Particulate Matter 2.5', 'Non-Senior', [non_senior_PM25]),
           ('Particulate Matter 10', 'Non-Senior', [non_senior_PM10]),
           ('Particulate Matter 2.5 and 10', 'Non-Senior', [non_senior_PM]),
           ('Particulate Matter 2.5', 'Minority', [minority_PM25]),
           ('Particulate Matter 10', 'Minority', [minority_PM10]),
           ('Particulate Matter 2.5 and 10', 'Minority', [minority_PM]),
           ('Particulate Matter 2.5', 'Non-Minority', [non_minority_PM25]),
           ('Particulate Matter 10', 'Non-Minority', [non_minority_PM10]),
           ('Particulate Matter 2.5 and 10', 'Non-Minority', [non_minority_PM]),
           ('Particulate Matter 2.5', 'Low Income', [low_income_PM25]),
           ('Particulate Matter 10', 'Low Income', [low_income_PM10]),
           ('Particulate Matter 2.5 and 10', 'Low Income', [low_income_PM]),
           ('Particulate Matter 2.5', 'Non-Low Income', [non_low_income_PM25]),
           ('Particulate Matter 10', 'Non-Low Income', [non_low_income_PM10]),
           ('Particulate Matter 2.5 and 10', 'Non-Low Income', [non_low_income_PM]))
x([Particulate Matter],
  [Population],
  [Average Particulate Matter])
OPTION(MAXDOP 1)

-- drop the highway network to grid xref temporary table
DROP TABLE #xref_grid_hwycov
GO

-- add metadata for [rp_2021].[sp_particulate_matter_ctemfac_2017]
EXECUTE [db_meta].[add_xp] 'rp_2021.sp_particulate_matter_ctemfac_2017', 'MS_Description', 'calculate person-level particulate matter 2.5 and 10 exposure using EMFAC 2017'
GO




-- create function to return ABM population with CoC designations ------------
DROP FUNCTION IF EXISTS [rp_2021].[fn_person_coc]
GO

CREATE FUNCTION [rp_2021].[fn_person_coc]
(
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
)
RETURNS TABLE
AS
RETURN
/**	
summary:   >
    Return table of ABM synthetic population for a given ABM scenario with
    Community of Concern (CoC) designations.
**/
SELECT
    @scenario_id AS [scenario_id]
	,[person].[person_id]
    ,[household].[household_id]
	,CASE   WHEN [person].[age] >= 75 
            THEN 'Senior'
            ELSE 'Non-Senior'
            END AS [senior]
	,CASE	WHEN [person].[race] IN ('Some Other Race Alone',
									 'Asian Alone',
									 'Black or African American Alone',
									 'Two or More Major Race Groups',
									 'Native Hawaiian and Other Pacific Islander Alone',
									 'American Indian and Alaska Native Tribes specified; or American Indian or Alaska Native, not specified and no other races')
                    OR [person].[hispanic] = 'Hispanic'
            THEN 'Minority'
            ELSE 'Non-Minority'
            END AS [minority]
	,CASE   WHEN [household].[poverty] <= 2
            THEN 'Low Income'
            ELSE 'Non-Low Income'
            END AS [low_income]
    ,CASE   WHEN [person].[age] >= 75
                OR ([person].[race] IN ('Some Other Race Alone',
									    'Asian Alone',
									    'Black or African American Alone',
									    'Two or More Major Race Groups',
									    'Native Hawaiian and Other Pacific Islander Alone',
									    'American Indian and Alaska Native Tribes specified; or American Indian or Alaska Native, not specified and no other races')
                        OR [person].[hispanic] = 'Hispanic')
                OR [household].[poverty] <= 2
            THEN 'CoC'
            ELSE 'Non-CoC'
            END AS [coc]
FROM
	[dimension].[person]
INNER JOIN
	[dimension].[household]
ON
	[person].[scenario_id] = [household].[scenario_id]
	AND [person].[household_id] = [household].[household_id]
WHERE
	[person].[scenario_id] = @scenario_id
	AND [household].[scenario_id] = @scenario_id
GO

-- add metadata for [rp_2021].[fn_person_coc]
EXECUTE [db_meta].[add_xp] 'rp_2021.fn_person_coc', 'MS_Description', 'return ABM synthetic population with Community of Concern (CoC) designations'
GO




-- define [rp_2021] schema permissions -----------------------------------------
-- drop [rp_2021] role if it exists
DECLARE @RoleName sysname
set @RoleName = N'rp_2021_user'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    DECLARE @RoleMemberName sysname
    DECLARE Member_Cursor CURSOR FOR
    select [name]
    from sys.database_principals 
    where principal_id in ( 
        select member_principal_id
        from sys.database_role_members
        where role_principal_id in (
            select principal_id
            FROM sys.database_principals where [name] = @RoleName AND type = 'R'))

    OPEN Member_Cursor;

    FETCH NEXT FROM Member_Cursor
    into @RoleMemberName
    
    DECLARE @SQL NVARCHAR(4000)

    WHILE @@FETCH_STATUS = 0
    BEGIN
        
        SET @SQL = 'ALTER ROLE '+ QUOTENAME(@RoleName,'[') +' DROP MEMBER '+ QUOTENAME(@RoleMemberName,'[')
        EXEC(@SQL)
        
        FETCH NEXT FROM Member_Cursor
        into @RoleMemberName
    END;

    CLOSE Member_Cursor;
    DEALLOCATE Member_Cursor;

    DROP ROLE [rp_2021_user]
END
GO
-- create user role for [rp_2021] schema
CREATE ROLE [rp_2021_user] AUTHORIZATION dbo;
-- allow all users to select, view definitions
-- and execute [rp_2021] stored procedures
GRANT EXECUTE ON SCHEMA :: [rp_2021] TO [rp_2021_user];
GRANT SELECT ON SCHEMA :: [rp_2021] TO [rp_2021_user];
GRANT VIEW DEFINITION ON SCHEMA :: [rp_2021] TO [rp_2021_user];
-- deny insert+update+delete on [rp_2021].[particulate_matter_grid]
DENY DELETE ON [rp_2021].[particulate_matter_grid] TO [rp_2021_user];
DENY INSERT ON [rp_2021].[particulate_matter_grid] TO [rp_2021_user];
DENY UPDATE ON [rp_2021].[particulate_matter_grid] TO [rp_2021_user];
-- deny insert and update on [rp_2021].[pm_results] so user can only
-- add new information via stored procedures, allow deletes
GRANT DELETE ON [rp_2021].[pm_results] TO [rp_2021_user];
DENY INSERT ON [rp_2021].[pm_results] TO [rp_2021_user];
DENY UPDATE ON [rp_2021].[pm_results] TO [rp_2021_user];