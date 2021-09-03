SET NOCOUNT ON;
GO


-- create [mode_choice_report] schema ----------------------------------------
-- note [mode_choice_report] schema permissions are defined at end of file
IF NOT EXISTS (
    SELECT TOP 1
        [schema_name]
    FROM
        [information_schema].[schemata] 
    WHERE
        [schema_name] = 'mode_choice_report'
)
EXEC ('CREATE SCHEMA [mode_choice_report]')
GO




-- create demographics query -------------------------------------------------
DROP PROCEDURE IF EXISTS [mode_choice_report].[demographics]
GO
CREATE PROCEDURE [mode_choice_report].[demographics]
    @scenario_id integer,
    @mgraPath nvarchar(max)
WITH RECOMPILE
AS
BEGIN
	SET NOCOUNT ON;

    -- read CSV file containg project-area MGRAs, insert to temporary table
    -- assumed format is one-column [mgra] field with headers
    CREATE TABLE #projectMGRAs 
        ([mgra] char(20) NOT NULL,
            CONSTRAINT pk_demographicsProjectMGRAs PRIMARY KEY CLUSTERED ([mgra]))
    DECLARE @sqlBI nvarchar(max) = '
        BULK INSERT #projectMGRAs
        FROM ''' + @mgraPath + '''
        WITH (FIRSTROW = 2, TABLOCK,
        FIELDTERMINATOR='','', ROWTERMINATOR=''\n'', MAXERRORS=1);'
    EXECUTE(@sqlBI);

    -- create CTE of results
    with [results] AS (
        -- synthetic population based population in the project area
        -- includes non-institutionalized group quarters
        SELECT
            1 AS [order]
            ,'Population' AS [metric]
            ,COUNT([person_id]) AS [value]
        FROM
            [dimension].[person]
        INNER JOIN
            [dimension].[household]
        ON
            [person].[scenario_id] = [household].[scenario_id]
            AND [person].[household_id] = [household].[household_id]
        INNER JOIN
            [dimension].[geography]
        ON
            [household].[geography_household_location_id] = [geography].[geography_id]
        INNER JOIN  -- restrict to MGRAs within project area
            #projectMGRAs
        ON
            [geography].[mgra_13] = #projectMGRAs.[mgra]
        WHERE
            [person].[scenario_id] = @scenario_id
            AND [household].[scenario_id] = @scenario_id
            AND [person].[person_id] > 0  -- remove Not Applicable records
            AND [household].[household_id] > 0  -- remove Not Applicable records

        UNION ALL

        -- synthetic population based households in the project area
        -- includes non-institutionalized group quarters
        SELECT
            2 AS [order]
            ,'Households' AS [metric]
            ,COUNT([household_id]) AS [value]
        FROM
            [dimension].[household]
        INNER JOIN
            [dimension].[geography]
        ON
            [household].[geography_household_location_id] = [geography].[geography_id]
        INNER JOIN  -- restrict to MGRAs within project area
            #projectMGRAs
        ON
            [geography].[mgra_13] = #projectMGRAs.[mgra]
        WHERE
            [household].[scenario_id] = @scenario_id
            AND [household].[household_id] > 0  -- remove Not Applicable records

        UNION ALL

        -- synthetic population based persons who live in the project area and are employed
        -- includes non-institutionalized group quarters
        SELECT
            4 AS [order]
            ,'Employed Residents' AS [metric]
            ,SUM(CASE WHEN [person].[abm_person_type] IN ('Full-Time Worker',
                                                          'Part-Time Worker')
                      THEN 1 ELSE 0 END) AS [value]
        FROM
            [dimension].[person]
        INNER JOIN
            [dimension].[household]
        ON
            [person].[scenario_id] = [household].[scenario_id]
            AND [person].[household_id] = [household].[household_id]
        INNER JOIN
            [dimension].[geography]
        ON
            [household].[geography_household_location_id] = [geography].[geography_id]
        INNER JOIN  -- restrict to MGRAs within project area
            #projectMGRAs
        ON
            [geography].[mgra_13] = #projectMGRAs.[mgra]
        WHERE
            [person].[scenario_id] = @scenario_id
            AND [household].[scenario_id] = @scenario_id
            AND [person].[person_id] > 0  -- remove Not Applicable records
            AND [household].[household_id] > 0  -- remove Not Applicable records

        UNION ALL

        -- synthetic population based persons who are employed in the project area
        -- includes non-institutionalized group quarters
        -- includes full-time telecommuters who reside in the project area (work from home)
        SELECT
            5 AS [order]
            ,'Employees' AS [metric]
            ,COUNT([person_id]) AS [value]
        FROM
            [dimension].[person]
        INNER JOIN
            [dimension].[geography]
        ON
            [person].[geography_work_location_id] = [geography].[geography_id]
        INNER JOIN  -- restrict to MGRAs within project area
            #projectMGRAs
        ON
            [geography].[mgra_13] = #projectMGRAs.[mgra]
        WHERE
            [person].[scenario_id] = @scenario_id
            AND [person].[person_id] > 0  -- remove Not Applicable records
            AND [person].[abm_person_type] IN ('Full-Time Worker', 'Part-Time Worker')
    )
    -- get all results from the CTE and calculate household size
    SELECT * FROM [results]
    UNION ALL
    SELECT
        3 AS [order]
        ,'Household Size' AS [metric]
        ,1.0 * (SELECT [value] FROM [results] WHERE [metric] = 'Population') /
         NULLIF((SELECT [value] FROM [results] WHERE [metric] = 'Households'), 0) AS [value]

    DROP TABLE #projectMGRAs

END
GO




-- create mgra inter/intra-zonal query ---------------------------------------
DROP PROCEDURE IF EXISTS [mode_choice_report].[mgra_intrazonals]
GO
CREATE PROCEDURE [mode_choice_report].[mgra_intrazonals]
    @scenario_id integer,
    @mgraPath nvarchar(max)
WITH RECOMPILE
AS
BEGIN
	SET NOCOUNT ON;

    -- read CSV file containg project-area MGRAs, insert to temporary table
    -- assumed format is one-column [mgra] field with headers
    CREATE TABLE #projectMGRAs 
        ([mgra] char(20) NOT NULL,
            CONSTRAINT pk_mgraIntrazonalsProjectMGRAs PRIMARY KEY CLUSTERED ([mgra]))
    DECLARE @sqlBI nvarchar(max) = '
        BULK INSERT #projectMGRAs
        FROM ''' + @mgraPath + '''
        WITH (FIRSTROW = 2, TABLOCK,
        FIELDTERMINATOR='','', ROWTERMINATOR=''\n'', MAXERRORS=1);'
    EXECUTE(@sqlBI);

    -- create CTE of results
    with [results] AS (
        SELECT
            1 AS [order]
            ,'MGRA Intra-zonal' AS [metric]
            ,SUM([weight_person_trip]) AS [value]
        FROM
            [fact].[person_trip]
        INNER JOIN
            [dimension].[model]
        ON
            [person_trip].[model_trip_id] = [model].[model_id]
        INNER JOIN
            [dimension].[geography_trip_origin]
        ON
            [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
        LEFT OUTER JOIN
            #projectMGRAs AS [originProjectMGRAs]
        ON
            [geography_trip_origin].[trip_origin_mgra_13] = [originProjectMGRAs].[mgra]
        INNER JOIN
            [dimension].[geography_trip_destination]
        ON
            [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
        LEFT OUTER JOIN
            #projectMGRAs AS [destinationProjectMGRAs]
        ON
            [geography_trip_destination].[trip_destination_mgra_13] = [destinationProjectMGRAs].[mgra]
        WHERE
            [person_trip].[scenario_id] = @scenario_id
            AND [model].[model_aggregate_description] = 'Resident Models'
            -- restrict to trips where origin and destination MGRAs within project area
            AND ([originProjectMGRAs].[mgra] IS NOT NULL AND [destinationProjectMGRAs].[mgra] IS NOT NULL)
            -- restrict to trips where origin and destination MGRAs are equal
            AND [originProjectMGRAs].[mgra] = [destinationProjectMGRAs].[mgra]

        UNION ALL

        SELECT
            2 AS [order]
            ,'MGRA Inter-zonal' AS [metric]
            ,SUM([weight_person_trip]) AS [value]
        FROM
            [fact].[person_trip]
        INNER JOIN
            [dimension].[model]
        ON
            [person_trip].[model_trip_id] = [model].[model_id]
        INNER JOIN
            [dimension].[geography_trip_origin]
        ON
            [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
        LEFT OUTER JOIN
            #projectMGRAs AS [originProjectMGRAs]
        ON
            [geography_trip_origin].[trip_origin_mgra_13] = [originProjectMGRAs].[mgra]
        INNER JOIN
            [dimension].[geography_trip_destination]
        ON
            [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
        LEFT OUTER JOIN
            #projectMGRAs AS [destinationProjectMGRAs]
        ON
            [geography_trip_destination].[trip_destination_mgra_13] = [destinationProjectMGRAs].[mgra]
        WHERE
            [person_trip].[scenario_id] = @scenario_id
            AND [model].[model_aggregate_description] = 'Resident Models'
            -- restrict to trips where origin OR destination MGRAs within project area
            -- but origin AND destination MGRAs are not equal
            AND ([originProjectMGRAs].[mgra] IS NOT NULL OR [destinationProjectMGRAs].[mgra] IS NOT NULL)
            AND NOT [originProjectMGRAs].[mgra] = [destinationProjectMGRAs].[mgra]

        UNION ALL

        SELECT
            3 AS [order]
            ,'Total Trips' AS [metric]
            ,SUM([weight_person_trip]) AS [value]
        FROM
            [fact].[person_trip]
        INNER JOIN
            [dimension].[model]
        ON
            [person_trip].[model_trip_id] = [model].[model_id]
        INNER JOIN
            [dimension].[geography_trip_origin]
        ON
            [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
        LEFT OUTER JOIN
            #projectMGRAs AS [originProjectMGRAs]
        ON
            [geography_trip_origin].[trip_origin_mgra_13] = [originProjectMGRAs].[mgra]
        INNER JOIN
            [dimension].[geography_trip_destination]
        ON
            [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
        LEFT OUTER JOIN
            #projectMGRAs AS [destinationProjectMGRAs]
        ON
            [geography_trip_destination].[trip_destination_mgra_13] = [destinationProjectMGRAs].[mgra]
        WHERE
            [person_trip].[scenario_id] = @scenario_id
            AND [model].[model_aggregate_description] = 'Resident Models'
            -- restrict to trips where origin OR destination MGRAs within project area
            AND ([originProjectMGRAs].[mgra] IS NOT NULL OR [destinationProjectMGRAs].[mgra] IS NOT NULL)
    )
    -- get all results from the CTE and calculate MGRA Intra-zonal percentage
    SELECT * FROM [results]
    UNION ALL
    SELECT
        4 AS [order]
        ,'MGRA Intra-zonal Pct.' AS [metric]
        ,ROUND(100.0 * (SELECT [value] FROM [results] WHERE [metric] = 'MGRA Intra-zonal') /
         (SELECT [value] FROM [results] WHERE [metric] = 'Total Trips'), 2) AS [value]


    DROP TABLE #projectMGRAs

END
GO




-- create internal capture query ---------------------------------------------
DROP PROCEDURE IF EXISTS [mode_choice_report].[internal_capture]
GO
CREATE PROCEDURE [mode_choice_report].[internal_capture]
    @scenario_id integer,
    @mgraPath nvarchar(max)
WITH RECOMPILE
AS
BEGIN
	SET NOCOUNT ON;

    -- read CSV file containg project-area MGRAs, insert to temporary table
    -- assumed format is one-column [mgra] field with headers
    CREATE TABLE #projectMGRAs 
        ([mgra] char(20) NOT NULL,
            CONSTRAINT pk_internalCaptureProjectMGRAs PRIMARY KEY CLUSTERED ([mgra]))
    DECLARE @sqlBI nvarchar(max) = '
        BULK INSERT #projectMGRAs
        FROM ''' + @mgraPath + '''
        WITH (FIRSTROW = 2, TABLOCK,
        FIELDTERMINATOR='','', ROWTERMINATOR=''\n'', MAXERRORS=1);'
    EXECUTE(@sqlBI);

    -- create lookup containing MGRAs and TAZ ids to capture trips
    --  in the project area that operate at both the MGRA and TAZ level
    with [project_area] AS (
        SELECT
            [geography_id]
        FROM
            #projectMGRAs
        INNER JOIN
            [dimension].[geography]
        ON
            [geography].[mgra_13] != 'Not Applicable'
            AND #projectMGRAs.[mgra] = [geography].[mgra_13]

        UNION ALL

        SELECT DISTINCT
            [taz_geography].[geography_id]
        FROM
            #projectMGRAs
        INNER JOIN
            [dimension].[geography] AS [mgra_geography]
        ON
            [mgra_geography].[mgra_13] != 'Not Applicable'
            AND #projectMGRAs.[mgra] = [mgra_geography].[mgra_13]
        INNER JOIN
            [dimension].[geography] AS [taz_geography]
        ON
            [taz_geography].[mgra_13] = 'Not Applicable'
            AND [taz_geography].[taz_13] != 'Not Applicable'
            AND [mgra_geography].[taz_13] = [taz_geography].[taz_13]),
    [results] AS (
        SELECT
            1 AS [order]
            ,'Total Vehicle Trips' AS [metric]
            ,SUM([weight_trip]) AS [value]  -- vehicle trips not person trips
        FROM
            [fact].[person_trip]
        INNER JOIN
            [dimension].[mode_trip]
        ON
            [person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
        LEFT OUTER JOIN
            [project_area] AS [origin_project_area]
        ON
            [person_trip].[geography_trip_origin_id] = [origin_project_area].[geography_id]
        LEFT OUTER JOIN
            [project_area] AS [destination_project_area]
        ON
            [person_trip].[geography_trip_destination_id] = [destination_project_area].[geography_id]
        WHERE
            [person_trip].[scenario_id] = @scenario_id
            -- restrict to trips where origin OR destination within project area
            AND ([origin_project_area].[geography_id] IS NOT NULL OR [destination_project_area].[geography_id] IS NOT NULL)
            -- restrict to modes where trip is assigned to highway network
            AND [mode_trip].[mode_aggregate_trip_description] IN ('Drive Alone',
                                                                  'Shared Ride 2',
                                                                  'Shared Ride 3+',
                                                                  'Taxi',
                                                                  'Non-Pooled TNC',
                                                                  'Pooled TNC',
                                                                  'Light Heavy Duty Truck',
                                                                  'Medium Heavy Duty Truck',
                                                                  'Heavy Heavy Duty Truck')

        UNION ALL

        SELECT
            99 AS [order]
            ,'Study Area Intra-zonal Vehicle Trips' AS [metric]
            ,SUM([weight_trip]) AS [value]  -- vehicle trips not person trips
        FROM
            [fact].[person_trip]
        INNER JOIN
            [dimension].[mode_trip]
        ON
            [person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
        LEFT OUTER JOIN
            [project_area] AS [origin_project_area]
        ON
            [person_trip].[geography_trip_origin_id] = [origin_project_area].[geography_id]
        LEFT OUTER JOIN
            [project_area] AS [destination_project_area]
        ON
            [person_trip].[geography_trip_destination_id] = [destination_project_area].[geography_id]
        WHERE
            [person_trip].[scenario_id] = @scenario_id
            -- restrict to trips where origin AND destination within project area
            AND ([origin_project_area].[geography_id] IS NOT NULL AND [destination_project_area].[geography_id] IS NOT NULL)
            -- restrict to modes where trip is assigned to highway network
            AND [mode_trip].[mode_aggregate_trip_description] IN ('Drive Alone',
                                                                  'Shared Ride 2',
                                                                  'Shared Ride 3+',
                                                                  'Taxi',
                                                                  'Non-Pooled TNC',
                                                                  'Pooled TNC',
                                                                  'Light Heavy Duty Truck',
                                                                  'Medium Heavy Duty Truck',
                                                                  'Heavy Heavy Duty Truck')
    )
    -- get results from the CTE and calculate study area internal capture rate
    SELECT
        'Study Area Internal Vehicle Capture Rate' AS [metric]
        ,ROUND(100.0 * (SELECT [value] FROM [results] WHERE [metric] = 'Study Area Intra-zonal Vehicle Trips') /
         (SELECT [value] FROM [results] WHERE [metric] = 'Total Vehicle Trips'), 2) AS [value]


    DROP TABLE #projectMGRAs

END
GO




-- create mode share query ---------------------------------------------------
DROP PROCEDURE IF EXISTS [mode_choice_report].[mode_share]
GO
CREATE PROCEDURE [mode_choice_report].[mode_share]
    @scenario_id integer,
	@geography_column nvarchar(max) = '',  -- optional column in [dimension].[geography]
    -- table used to aggregate activity location to user-specified geography resolution
    @mgraPath nvarchar(max) = ''  -- optional path to MGRA project list in lieu of geography column
WITH RECOMPILE
AS
BEGIN
	SET NOCOUNT ON;

	-- ensure one of geography column or MGRA project list is specified
	IF LEN(@mgraPath) = 0 AND LEN(@geography_column) = 0
		RAISERROR('User must specify either a column in [dimension].[geography] or path to MGRA project list', 16, 1)
	-- ensure only one of geography column or MGRA project list is specified
	ELSE IF LEN(@mgraPath) > 0 AND LEN(@geography_column) > 0
		RAISERROR('User may only specify one of either a column in [dimension].[geography] or path to MGRA project list', 16, 1)

	-- geography column stored procedure ----
	ELSE IF LEN(@geography_column) > 0
	BEGIN
		-- build dynamic SQL string
		-- note the use of nvarchar(max) throughout to avoid implicit conversion to varchar(8000)
		DECLARE @sqlModeChoice nvarchar(max) = '
		-- declare temporary table to hold mode choice result output
		CREATE TABLE #mode_choice_report_mode_share (
			[' + @geography_column + '] nvarchar(100),
			[Mode] nvarchar(50),
			[Person Trips] integer,
			CONSTRAINT [pk_mode_choice_report_mode_share] PRIMARY KEY ([' + @geography_column + '], [Mode])
		)

		-- declare cursor to loop through chosen geographies
		DECLARE db_cursor CURSOR FOR 
		SELECT DISTINCT [' + @geography_column + '] FROM [dimension].[geography]
		WHERE [' + @geography_column + '] NOT IN (''Not Applicable'')

		-- open cursor and loop through unique geography names
		DECLARE @geo_name nvarchar (100)
		OPEN db_cursor
		FETCH NEXT FROM db_cursor INTO @geo_name 
		WHILE @@FETCH_STATUS = 0  
		BEGIN
			INSERT INTO #mode_choice_report_mode_share
			SELECT
				@geo_name AS [' + @geography_column + ']
				,CASE WHEN [mode].[mode_aggregate_description] IN (''Drive Alone'',
																   ''Shared Ride 2'',
																   ''Shared Ride 3+'',
																   ''Walk'',
																   ''Bike'',
																   ''Transit'',
																   ''School Bus'')
					  THEN [mode].[mode_aggregate_description]
					  WHEN [mode].[mode_aggregate_description] = ''Super-Walk''
					  THEN ''Micromobility & Microtransit''
					  WHEN [mode].[mode_aggregate_description] IN (''Taxi'',
																   ''Non-Pooled TNC'',
																   ''Pooled TNC'')
					  THEN ''Taxi & TNC''
					  ELSE NULL END AS [Mode]
				,SUM([weight_person_trip]) AS [Person Trips]
			FROM
				[fact].[person_trip]
			INNER JOIN
				[dimension].[model]
			ON
				[person_trip].[model_trip_id] = [model].[model_id]
			INNER JOIN
				[dimension].[mode]
			ON
				[person_trip].[mode_trip_id] = [mode].[mode_id]
			INNER JOIN
				[dimension].[geography] AS [origin_geography]
			ON
				[person_trip].[geography_trip_origin_id] = [origin_geography].[geography_id]
			INNER JOIN
				[dimension].[geography] AS [destination_geography]
			ON
				[person_trip].[geography_trip_destination_id] = [destination_geography].[geography_id]
			WHERE
				[person_trip].[scenario_id] = ' +CONVERT(nvarchar, @scenario_id) + '
				AND [model].[model_aggregate_description] = ''Resident Models''
				AND ([origin_geography].[' + @geography_column +'] = @geo_name OR 
					 [destination_geography].[' + @geography_column +'] = @geo_name)
			GROUP BY
				CASE WHEN [mode].[mode_aggregate_description] IN (''Drive Alone'',
																  ''Shared Ride 2'',
																  ''Shared Ride 3+'',
																  ''Walk'',
																  ''Bike'',
																  ''Transit'',
																  ''School Bus'')
					 THEN [mode].[mode_aggregate_description]
					 WHEN [mode].[mode_aggregate_description] = ''Super-Walk''
					 THEN ''Micromobility & Microtransit''
					 WHEN [mode].[mode_aggregate_description] IN (''Taxi'',
																  ''Non-Pooled TNC'',
																  ''Pooled TNC'')
					 THEN ''Taxi & TNC''
					 ELSE NULL END

			FETCH NEXT FROM db_cursor INTO @geo_name

		END 

		CLOSE db_cursor  
		DEALLOCATE db_cursor   


		-- return person-trip mode share within each unique geography in the chosen geography
		SELECT
			[combos].[' + @geography_column + ']
			,[combos].[Mode]
			,ISNULL(100.0 * [Person Trips] / SUM([Person Trips]) OVER (PARTITION BY [combos].[' + @geography_column + ']), 0) AS [Percentage]
		FROM
			#mode_choice_report_mode_share
		RIGHT OUTER JOIN (
			SELECT DISTINCT
				[' + @geography_column + ']
				,CASE WHEN [mode].[mode_aggregate_description] IN (''Drive Alone'',
																   ''Shared Ride 2'',
																   ''Shared Ride 3+'',
																   ''Walk'',
																   ''Bike'',
																   ''Transit'',
																   ''School Bus'')
						THEN [mode].[mode_aggregate_description]
						WHEN [mode].[mode_aggregate_description] = ''Super-Walk''
						THEN ''Micromobility & Microtransit''
						WHEN [mode].[mode_aggregate_description] IN (''Taxi'',
																	 ''Non-Pooled TNC'',
																	 ''Pooled TNC'')
						THEN ''Taxi & TNC''
						ELSE ''Drive Alone''  -- added this just to remove NULL values
						END AS [Mode]
			FROM
				[dimension].[mode]
			CROSS JOIN (
				SELECT DISTINCT
					[' + @geography_column + ']
				FROM
					[dimension].[geography]
				WHERE
					[' + @geography_column + '] != ''Not Applicable''
			) AS [geographies]) AS [combos]
		ON
			#mode_choice_report_mode_share.[' + @geography_column + '] = [combos].[' + @geography_column + ']
			AND #mode_choice_report_mode_share.[Mode] = [combos].[Mode]

		DROP TABLE #mode_choice_report_mode_share
		'

		EXECUTE(@sqlModeChoice)
	END

	-- MGRA project list stored procedure ----
	ELSE IF LEN(@mgraPath) > 0
	BEGIN
		-- read CSV file containg project-area MGRAs, insert to temporary table
		-- assumed format is one-column [mgra] field with headers
		CREATE TABLE #projectMGRAs 
			([mgra] char(20) NOT NULL,
			 CONSTRAINT pk_modeShareProjectMGRAs PRIMARY KEY CLUSTERED ([mgra]))
		DECLARE @sqlBI nvarchar(max) = '
			BULK INSERT #projectMGRAs
			FROM ''' + @mgraPath + '''
			WITH (FIRSTROW = 2, TABLOCK,
			FIELDTERMINATOR='','', ROWTERMINATOR=''\n'', MAXERRORS=1);'
		EXECUTE(@sqlBI)


		-- return person-trip mode share within project-area MGRAs
		SELECT
			[Modes].[Mode]
			,ISNULL(100.0 * [Person Trips] / SUM([Person Trips]) OVER (), 0) AS [Percentage]
		FROM (
			SELECT
				CASE WHEN [mode].[mode_aggregate_description] IN ('Drive Alone',
																  'Shared Ride 2',
																  'Shared Ride 3+',
																  'Walk',
																  'Bike',
																  'Transit',
																  'School Bus')
					 THEN [mode].[mode_aggregate_description]
					 WHEN [mode].[mode_aggregate_description] = 'Super-Walk'
					 THEN 'Micromobility & Microtransit'
					 WHEN [mode].[mode_aggregate_description] IN ('Taxi',
																  'Non-Pooled TNC',
																  'Pooled TNC')
					 THEN 'Taxi & TNC'
					 ELSE NULL END AS [Mode]
				,SUM([weight_person_trip]) AS [Person Trips]
			FROM
				[fact].[person_trip]
			INNER JOIN
				[dimension].[model]
			ON
				[person_trip].[model_trip_id] = [model].[model_id]
			INNER JOIN
				[dimension].[mode]
			ON
				[person_trip].[mode_trip_id] = [mode].[mode_id]
			INNER JOIN
				[dimension].[geography_trip_origin]
			ON
				[person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
			LEFT OUTER JOIN
				#projectMGRAs AS [originProjectMGRAs]
			ON
				[geography_trip_origin].[trip_origin_mgra_13] = [originProjectMGRAs].[mgra]
			INNER JOIN
				[dimension].[geography_trip_destination]
			ON
				[person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
			LEFT OUTER JOIN
				#projectMGRAs AS [destinationProjectMGRAs]
			ON
				[geography_trip_destination].[trip_destination_mgra_13] = [destinationProjectMGRAs].[mgra]
			WHERE
				[person_trip].[scenario_id] = @scenario_id
				AND [model].[model_aggregate_description] = 'Resident Models'
				-- restrict to trips where origin OR destination MGRAs within project area
				AND ([originProjectMGRAs].[mgra] IS NOT NULL OR [destinationProjectMGRAs].[mgra] IS NOT NULL)
			GROUP BY
				CASE WHEN [mode].[mode_aggregate_description] IN ('Drive Alone',
																  'Shared Ride 2',
																  'Shared Ride 3+',
																  'Walk',
																  'Bike',
																  'Transit',
																  'School Bus')
					 THEN [mode].[mode_aggregate_description]
					 WHEN [mode].[mode_aggregate_description] = 'Super-Walk'
					 THEN 'Micromobility & Microtransit'
					 WHEN [mode].[mode_aggregate_description] IN ('Taxi',
																  'Non-Pooled TNC',
																  'Pooled TNC')
					 THEN 'Taxi & TNC'
					 ELSE NULL END
		) AS [tt]
		RIGHT OUTER JOIN (
			SELECT DISTINCT
				CASE WHEN [mode].[mode_aggregate_description] IN ('Drive Alone',
																  'Shared Ride 2',
																  'Shared Ride 3+',
																  'Walk',
																  'Bike',
																  'Transit',
																  'School Bus')
						THEN [mode].[mode_aggregate_description]
						WHEN [mode].[mode_aggregate_description] = 'Super-Walk'
						THEN 'Micromobility & Microtransit'
						WHEN [mode].[mode_aggregate_description] IN ('Taxi',
																	 'Non-Pooled TNC',
																	 'Pooled TNC')
						THEN 'Taxi & TNC'
						ELSE 'Drive Alone'  -- added this just to remove NULL values
						END AS [Mode]
			FROM
				[dimension].[mode]) AS [Modes]
		ON
			[tt].[Mode] = [Modes].[Mode]

		DROP TABLE #projectMGRAs
	END

END
GO




-- create peak-period mode share query ---------------------------------------
DROP PROCEDURE IF EXISTS [mode_choice_report].[mode_share_peak]
GO
CREATE PROCEDURE [mode_choice_report].[mode_share_peak]
    @scenario_id integer,
	@geography_column nvarchar(max) = '',  -- optional column in [dimension].[geography]
    -- table used to aggregate activity location to user-specified geography resolution
    @mgraPath nvarchar(max) = ''  -- optional path to MGRA project list in lieu of geography column
WITH RECOMPILE
AS
BEGIN
	SET NOCOUNT ON;

		-- ensure one of geography column or MGRA project list is specified
	IF LEN(@mgraPath) = 0 AND LEN(@geography_column) = 0
		RAISERROR('User must specify either a column in [dimension].[geography] or path to MGRA project list', 16, 1)
	-- ensure only one of geography column or MGRA project list is specified
	ELSE IF LEN(@mgraPath) > 0 AND LEN(@geography_column) > 0
		RAISERROR('User may only specify one of either a column in [dimension].[geography] or path to MGRA project list', 16, 1)

	-- geography column stored procedure ----
	ELSE IF LEN(@geography_column) > 0
	BEGIN
		-- build dynamic SQL string
		-- note the use of nvarchar(max) throughout to avoid implicit conversion to varchar(8000)
		DECLARE @sqlModeChoice nvarchar(max) = '
		-- declare temporary table to hold mode choice result output
		CREATE TABLE #mode_choice_report_mode_share (
			[' + @geography_column + '] nvarchar(100),
			[Mode] nvarchar(50),
			[Person Trips] integer,
			CONSTRAINT [pk_mode_choice_report_mode_share] PRIMARY KEY ([' + @geography_column + '], [Mode])
		)

		-- declare cursor to loop through chosen geographies
		DECLARE db_cursor CURSOR FOR 
		SELECT DISTINCT [' + @geography_column + '] FROM [dimension].[geography]
		WHERE [' + @geography_column + '] NOT IN (''Not Applicable'')

		-- open cursor and loop through unique geography names
		DECLARE @geo_name nvarchar (100)
		OPEN db_cursor
		FETCH NEXT FROM db_cursor INTO @geo_name 
		WHILE @@FETCH_STATUS = 0  
		BEGIN
			INSERT INTO #mode_choice_report_mode_share
			SELECT
				@geo_name AS [' + @geography_column + ']
				,CASE WHEN [mode].[mode_aggregate_description] IN (''Drive Alone'',
																   ''Shared Ride 2'',
																   ''Shared Ride 3+'',
																   ''Walk'',
																   ''Bike'',
																   ''Transit'',
																   ''School Bus'')
					  THEN [mode].[mode_aggregate_description]
					  WHEN [mode].[mode_aggregate_description] = ''Super-Walk''
					  THEN ''Micromobility & Microtransit''
					  WHEN [mode].[mode_aggregate_description] IN (''Taxi'',
																   ''Non-Pooled TNC'',
																   ''Pooled TNC'')
					  THEN ''Taxi & TNC''
					  ELSE NULL END AS [Mode]
				,SUM([weight_person_trip]) AS [Person Trips]
			FROM
				[fact].[person_trip]
			INNER JOIN
				[dimension].[time_trip_start]
			ON
				[person_trip].[time_trip_start_id] = [time_trip_start].[time_trip_start_id]
			INNER JOIN
				[dimension].[purpose_trip_origin]
			ON
				[person_trip].[purpose_trip_origin_id] = [purpose_trip_origin].[purpose_trip_origin_id]
			INNER JOIN
				[dimension].[purpose_trip_destination]
			ON
				[person_trip].[purpose_trip_destination_id] = [purpose_trip_destination].[purpose_trip_destination_id]
			INNER JOIN
				[dimension].[model]
			ON
				[person_trip].[model_trip_id] = [model].[model_id]
			INNER JOIN
				[dimension].[mode]
			ON
				[person_trip].[mode_trip_id] = [mode].[mode_id]
			INNER JOIN
				[dimension].[geography] AS [origin_geography]
			ON
				[person_trip].[geography_trip_origin_id] = [origin_geography].[geography_id]
			INNER JOIN
				[dimension].[geography] AS [destination_geography]
			ON
				[person_trip].[geography_trip_destination_id] = [destination_geography].[geography_id]
			WHERE
				[person_trip].[scenario_id] = ' + CONVERT(nvarchar, @scenario_id) + '
				AND [model].[model_aggregate_description] = ''Resident Models''
				AND ([origin_geography].[' + @geography_column +'] = @geo_name OR 
					 [destination_geography].[' + @geography_column +'] = @geo_name)
				AND [time_trip_start].[trip_start_abm_5_tod] IN (''2'', ''4'')  -- ABM Peak Periods
				-- limit to direct Home-Work or Work-Home trips
				AND (([purpose_trip_origin].[purpose_trip_origin_description] = ''Work'' AND [purpose_trip_destination].[purpose_trip_destination_description] = ''Home'')
					OR ([purpose_trip_origin].[purpose_trip_origin_description] = ''Home'' AND [purpose_trip_destination].[purpose_trip_destination_description] = ''Work''))
			GROUP BY
				CASE WHEN [mode].[mode_aggregate_description] IN (''Drive Alone'',
																  ''Shared Ride 2'',
																  ''Shared Ride 3+'',
																  ''Walk'',
																  ''Bike'',
																  ''Transit'',
																  ''School Bus'')
					 THEN [mode].[mode_aggregate_description]
					 WHEN [mode].[mode_aggregate_description] = ''Super-Walk''
					 THEN ''Micromobility & Microtransit''
					 WHEN [mode].[mode_aggregate_description] IN (''Taxi'',
																  ''Non-Pooled TNC'',
																  ''Pooled TNC'')
					 THEN ''Taxi & TNC''
					 ELSE NULL END

			FETCH NEXT FROM db_cursor INTO @geo_name

		END 

		CLOSE db_cursor  
		DEALLOCATE db_cursor   


		-- return person-trip mode share within each unique geography in the chosen geography
		SELECT
			[combos].[' + @geography_column + ']
			,[combos].[Mode]
			,ISNULL(100.0 * [Person Trips] / SUM([Person Trips]) OVER (PARTITION BY [combos].[' + @geography_column + ']), 0) AS [Percentage]
		FROM
			#mode_choice_report_mode_share
		RIGHT OUTER JOIN (
			SELECT DISTINCT
				[' + @geography_column + ']
				,CASE WHEN [mode].[mode_aggregate_description] IN (''Drive Alone'',
																   ''Shared Ride 2'',
																   ''Shared Ride 3+'',
																   ''Walk'',
																   ''Bike'',
																   ''Transit'',
																   ''School Bus'')
						THEN [mode].[mode_aggregate_description]
						WHEN [mode].[mode_aggregate_description] = ''Super-Walk''
						THEN ''Micromobility & Microtransit''
						WHEN [mode].[mode_aggregate_description] IN (''Taxi'',
																	 ''Non-Pooled TNC'',
																	 ''Pooled TNC'')
						THEN ''Taxi & TNC''
						ELSE ''Drive Alone''  -- added this just to remove NULL values
						END AS [Mode]
			FROM
				[dimension].[mode]
			CROSS JOIN (
				SELECT DISTINCT
					[' + @geography_column + ']
				FROM
					[dimension].[geography]
				WHERE
					[' + @geography_column + '] != ''Not Applicable''
			) AS [geographies]) AS [combos]
		ON
			#mode_choice_report_mode_share.[' + @geography_column + '] = [combos].[' + @geography_column + ']
			AND #mode_choice_report_mode_share.[Mode] = [combos].[Mode]

		DROP TABLE #mode_choice_report_mode_share
		'

		EXECUTE(@sqlModeChoice)
	END

	-- MGRA project list stored procedure ----
	ELSE IF LEN(@mgraPath) > 0
	BEGIN
		-- read CSV file containg project-area MGRAs, insert to temporary table
		-- assumed format is one-column [mgra] field with headers
		CREATE TABLE #projectMGRAs 
			([mgra] char(20) NOT NULL,
				CONSTRAINT pk_peakModeShareProjectMGRAs PRIMARY KEY CLUSTERED ([mgra]))
		DECLARE @sqlBI nvarchar(max) = '
			BULK INSERT #projectMGRAs
			FROM ''' + @mgraPath + '''
			WITH (FIRSTROW = 2, TABLOCK,
			FIELDTERMINATOR='','', ROWTERMINATOR=''\n'', MAXERRORS=1);'
		EXECUTE(@sqlBI)

		-- return person-trip mode share within project-area MGRAs
		-- for trips that start in the ABM peak period
		-- for trips that are direct home-work or work-home trips
		SELECT
			[Modes].[Mode]
			,ISNULL(100.0 * [Person Trips] / SUM([Person Trips]) OVER (), 0) AS [Percentage]
		FROM (
			SELECT
				CASE WHEN [mode].[mode_aggregate_description] IN ('Drive Alone',
																  'Shared Ride 2',
																  'Shared Ride 3+',
																  'Walk',
																  'Bike',
																  'Transit',
																  'School Bus')
					 THEN [mode].[mode_aggregate_description]
					 WHEN [mode].[mode_aggregate_description] = 'Super-Walk'
					 THEN 'Micromobility & Microtransit'
					 WHEN [mode].[mode_aggregate_description] IN ('Taxi',
																  'Non-Pooled TNC',
																  'Pooled TNC')
					 THEN 'Taxi & TNC'
					 ELSE NULL END AS [Mode]
				,SUM([weight_person_trip]) AS [Person Trips]
			FROM
				[fact].[person_trip]
			INNER JOIN
				[dimension].[time_trip_start]
			ON
				[person_trip].[time_trip_start_id] = [time_trip_start].[time_trip_start_id]
			INNER JOIN
				[dimension].[mode]
			ON
				[person_trip].[mode_trip_id] = [mode].[mode_id]
			INNER JOIN
				[dimension].[purpose_trip_origin]
			ON
				[person_trip].[purpose_trip_origin_id] = [purpose_trip_origin].[purpose_trip_origin_id]
			INNER JOIN
				[dimension].[purpose_trip_destination]
			ON
				[person_trip].[purpose_trip_destination_id] = [purpose_trip_destination].[purpose_trip_destination_id]
			INNER JOIN
				[dimension].[geography_trip_origin]
			ON
				[person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
			LEFT OUTER JOIN
				#projectMGRAs AS [originProjectMGRAs]
			ON
				[geography_trip_origin].[trip_origin_mgra_13] = [originProjectMGRAs].[mgra]
			INNER JOIN
				[dimension].[geography_trip_destination]
			ON
				[person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
			LEFT OUTER JOIN
				#projectMGRAs AS [destinationProjectMGRAs]
			ON
				[geography_trip_destination].[trip_destination_mgra_13] = [destinationProjectMGRAs].[mgra]
			WHERE
				[person_trip].[scenario_id] = @scenario_id
				-- restrict to trips where origin OR destination MGRAs within project area
				AND ([originProjectMGRAs].[mgra] IS NOT NULL OR [destinationProjectMGRAs].[mgra] IS NOT NULL)
				AND [time_trip_start].[trip_start_abm_5_tod] IN ('2', '4')  -- ABM Peak Periods
				-- limit to direct Home-Work or Work-Home trips
				AND (([purpose_trip_origin].[purpose_trip_origin_description] = 'Work' AND [purpose_trip_destination].[purpose_trip_destination_description] = 'Home')
					OR ([purpose_trip_origin].[purpose_trip_origin_description] = 'Home' AND [purpose_trip_destination].[purpose_trip_destination_description] = 'Work'))
			GROUP BY
				CASE WHEN [mode].[mode_aggregate_description] IN ('Drive Alone',
																  'Shared Ride 2',
																  'Shared Ride 3+',
																  'Walk',
																  'Bike',
																  'Transit',
																  'School Bus')
					 THEN [mode].[mode_aggregate_description]
					 WHEN [mode].[mode_aggregate_description] = 'Super-Walk'
					 THEN 'Micromobility & Microtransit'
					 WHEN [mode].[mode_aggregate_description] IN ('Taxi',
																  'Non-Pooled TNC',
																  'Pooled TNC')
					 THEN 'Taxi & TNC'
					 ELSE NULL END
		) AS [tt]
		RIGHT OUTER JOIN (
			SELECT DISTINCT
				CASE WHEN [mode].[mode_aggregate_description] IN ('Drive Alone',
																  'Shared Ride 2',
																  'Shared Ride 3+',
																  'Walk',
																  'Bike',
																  'Transit',
																  'School Bus')
						THEN [mode].[mode_aggregate_description]
						WHEN [mode].[mode_aggregate_description] = 'Super-Walk'
						THEN 'Micromobility & Microtransit'
						WHEN [mode].[mode_aggregate_description] IN ('Taxi',
																	 'Non-Pooled TNC',
																	 'Pooled TNC')
						THEN 'Taxi & TNC'
						ELSE 'Drive Alone'  -- added this just to remove NULL values
						END AS [Mode]
			FROM
				[dimension].[mode]) AS [Modes]
		ON
			[tt].[Mode] = [Modes].[Mode]

		DROP TABLE #projectMGRAs
	END

END
GO




-- create trip length query --------------------------------------------------
DROP PROCEDURE IF EXISTS [mode_choice_report].[trip_lengths]
GO
CREATE PROCEDURE [mode_choice_report].[trip_lengths]
    @scenario_id integer,
    @mgraPath nvarchar(max)
WITH RECOMPILE
AS
BEGIN
	SET NOCOUNT ON;

    -- read CSV file containg project-area MGRAs, insert to temporary table
    -- assumed format is one-column [mgra] field with headers
    CREATE TABLE #projectMGRAs 
        ([mgra] char(20) NOT NULL,
         CONSTRAINT pk_tripLengthsProjectMGRAs PRIMARY KEY CLUSTERED ([mgra]))
    DECLARE @sqlBI nvarchar(max) = '
        BULK INSERT #projectMGRAs
        FROM ''' + @mgraPath + '''
        WITH (FIRSTROW = 2, TABLOCK,
        FIELDTERMINATOR='','', ROWTERMINATOR=''\n'', MAXERRORS=1);'
    EXECUTE(@sqlBI)


    -- ABM Resident models average person-trip trip length for trips that
    -- originate or destinate within the project study area
    SELECT
        1 AS [order]
        ,'Resident Person Trip Length' AS [metric]
        ,SUM([weight_person_trip] * [distance_total]) / SUM([weight_person_trip]) AS [value]
    FROM
        [fact].[person_trip]
    INNER JOIN
        [dimension].[model]
    ON
        [person_trip].[model_trip_id] = [model].[model_id]
    INNER JOIN
        [dimension].[geography_trip_origin]
    ON
        [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
    LEFT OUTER JOIN
        #projectMGRAs AS [originProjectMGRAs]
    ON
        [geography_trip_origin].[trip_origin_mgra_13] = [originProjectMGRAs].[mgra]
    INNER JOIN
        [dimension].[geography_trip_destination]
    ON
        [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
    LEFT OUTER JOIN
        #projectMGRAs AS [destinationProjectMGRAs]
    ON
        [geography_trip_destination].[trip_destination_mgra_13] = [destinationProjectMGRAs].[mgra]
    WHERE
        [person_trip].[scenario_id] = @scenario_id
        AND [model].[model_aggregate_description] = 'Resident Models'  -- restrict to ABM Resident trip models
        -- restrict to trips where origin OR destination MGRAs within project area
        AND ([originProjectMGRAs].[mgra] IS NOT NULL OR [destinationProjectMGRAs].[mgra] IS NOT NULL)

    UNION ALL

    -- ABM Resident models average vehicle-trip trip length for trips that
    -- originate or destinate within the project study area that use personal auto modes
    SELECT
        2 AS [order]
        ,'Resident Auto-Trip Vehicle Trip Length' AS [metric]
        ,SUM([weight_trip] * [distance_total]) / SUM([weight_trip]) AS [value]
    FROM
        [fact].[person_trip]
    INNER JOIN
        [dimension].[model]
    ON
        [person_trip].[model_trip_id] = [model].[model_id]
    INNER JOIN
        [dimension].[mode]
    ON
        [person_trip].[mode_trip_id] = [mode].[mode_id]
    INNER JOIN
        [dimension].[geography_trip_origin]
    ON
        [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
    LEFT OUTER JOIN
        #projectMGRAs AS [originProjectMGRAs]
    ON
        [geography_trip_origin].[trip_origin_mgra_13] = [originProjectMGRAs].[mgra]
    INNER JOIN
        [dimension].[geography_trip_destination]
    ON
        [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
    LEFT OUTER JOIN
        #projectMGRAs AS [destinationProjectMGRAs]
    ON
        [geography_trip_destination].[trip_destination_mgra_13] = [destinationProjectMGRAs].[mgra]
    WHERE
        [person_trip].[scenario_id] = @scenario_id
        -- restrict to trips where origin OR destination MGRAs within project area
        AND ([originProjectMGRAs].[mgra] IS NOT NULL OR [destinationProjectMGRAs].[mgra] IS NOT NULL)
        AND [model].[model_aggregate_description] = 'Resident Models'  -- restrict to ABM Resident trip models
        AND [mode].[mode_aggregate_description] IN ('Drive Alone', 'Shared Ride 2', 'Shared Ride 3+')  -- personal auto modes

    UNION ALL

    --all ABM models average person-trip trip length for trips that
    -- originate or destinate within the project study area
    SELECT
        3 AS [order]
        ,'All Model Person Trip Length' AS [metric]
        ,SUM([weight_person_trip] * [distance_total]) / SUM([weight_person_trip]) AS [value]
    FROM
        [fact].[person_trip]
    INNER JOIN
        [dimension].[geography_trip_origin]
    ON
        [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
    LEFT OUTER JOIN
        #projectMGRAs AS [originProjectMGRAs]
    ON
        [geography_trip_origin].[trip_origin_mgra_13] = [originProjectMGRAs].[mgra]
    INNER JOIN
        [dimension].[geography_trip_destination]
    ON
        [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
    LEFT OUTER JOIN
        #projectMGRAs AS [destinationProjectMGRAs]
    ON
        [geography_trip_destination].[trip_destination_mgra_13] = [destinationProjectMGRAs].[mgra]
    WHERE
        [person_trip].[scenario_id] = @scenario_id
        -- restrict to trips where origin OR destination MGRAs within project area
        AND ([originProjectMGRAs].[mgra] IS NOT NULL OR [destinationProjectMGRAs].[mgra] IS NOT NULL)

    UNION ALL

    -- all ABM models average person-trip trip length for trips that
    -- originate or destinate within the project study area that use personal auto modes
    SELECT
        4 AS [order]
        ,'All Model Vehicle Trip Length' AS [metric]
        ,SUM([weight_trip] * [distance_total]) / SUM([weight_trip]) AS [value]
    FROM
        [fact].[person_trip]
    INNER JOIN
        [dimension].[mode]
    ON
        [person_trip].[mode_trip_id] = [mode].[mode_id]
    INNER JOIN
        [dimension].[geography_trip_origin]
    ON
        [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
    LEFT OUTER JOIN
        #projectMGRAs AS [originProjectMGRAs]
    ON
        [geography_trip_origin].[trip_origin_mgra_13] = [originProjectMGRAs].[mgra]
    INNER JOIN
        [dimension].[geography_trip_destination]
    ON
        [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
    LEFT OUTER JOIN
        #projectMGRAs AS [destinationProjectMGRAs]
    ON
        [geography_trip_destination].[trip_destination_mgra_13] = [destinationProjectMGRAs].[mgra]
    WHERE
        [person_trip].[scenario_id] = @scenario_id
        -- restrict to trips where origin OR destination MGRAs within project area
        AND ([originProjectMGRAs].[mgra] IS NOT NULL OR [destinationProjectMGRAs].[mgra] IS NOT NULL)
        AND [mode].[mode_aggregate_description] IN ('Drive Alone', 'Shared Ride 2', 'Shared Ride 3+')  -- personal auto modes

    UNION ALL

    -- ABM Resident models average Work-purpose person-trip tour length for tours that
    -- originate within the project study area by persons who reside in the project study area
    SELECT
        5 AS [order]
        ,'Resident Round-Trip Commuter Tour Length' AS [metric]
        ,SUM([weight_person_tour] * [distance_total]) / SUM([weight_person_tour]) AS [value]
    FROM (
        SELECT
            [tour].[tour_id]
            ,SUM([distance_total]) AS [distance_total]
            ,MAX([weight_person_trip]) AS [weight_person_tour]
        FROM
            [fact].[person_trip]
        INNER JOIN
            [dimension].[tour]
        ON
            [person_trip].[scenario_id] = [tour].[scenario_id]
            AND [person_trip].[tour_id] = [tour].[tour_id]
        INNER JOIN
            [dimension].[geography_tour_origin]
        ON
            [tour].[geography_tour_origin_id] = [geography_tour_origin].[geography_tour_origin_id]
        INNER JOIN  -- only use trips on tours originating in study-area
            #projectMGRAs AS [tourOriginProjectMGRAs]
        ON
            [geography_tour_origin].[tour_origin_mgra_13] = [tourOriginProjectMGRAs].[mgra]
        INNER JOIN
            [dimension].[model]
        ON
            [person_trip].[model_trip_id] = [model].[model_id]
        INNER JOIN
            [dimension].[purpose]
        ON
            [tour].[purpose_tour_id] = [purpose].[purpose_id]
        INNER JOIN
            [dimension].[household]
        ON
            [person_trip].[scenario_id] = [household].[scenario_id]
            AND [person_trip].[household_id] = [household].[household_id]
        INNER JOIN
            [dimension].[geography_household_location]
        ON
            [household].[geography_household_location_id] = [geography_household_location].[geography_household_location_id]
        INNER JOIN  -- only use trips made by residents of study-area
            #projectMGRAs AS [homeProjectMGRAs]
        ON
            [geography_household_location].[household_location_mgra_13] = [homeProjectMGRAs].[mgra]
        WHERE
            [person_trip].[scenario_id] = @scenario_id
            AND [tour].[scenario_id] = @scenario_id
            AND [household].[scenario_id] = @scenario_id
            AND [model].[model_aggregate_description] = 'Resident Models'  -- ABM resident models
            AND [purpose].[purpose_description] = 'Work'  -- Work purpose tours
        GROUP BY
            [tour].[tour_id]
    ) AS [tt]

    UNION ALL

    -- ABM Resident models average Work-purpose person-trip tour length for tours that
    -- destinate within the project study area by persons who work in the project study area
    SELECT
        6 AS [order]
        ,'Employee Round-Trip Commuter Tour Length' AS [metric]
        ,SUM([weight_person_tour] * [distance_total]) / SUM([weight_person_tour]) AS [value]
    FROM (
        SELECT
            [tour].[tour_id]
            ,SUM([distance_total]) AS [distance_total]
            ,MAX([weight_person_trip]) AS [weight_person_tour]
        FROM
            [fact].[person_trip]
        INNER JOIN
            [dimension].[tour]
        ON
            [person_trip].[scenario_id] = [tour].[scenario_id]
            AND [person_trip].[tour_id] = [tour].[tour_id]
        INNER JOIN
            [dimension].[geography_tour_destination]
        ON
            [tour].[geography_tour_destination_id] = [geography_tour_destination].[geography_tour_destination_id]
        INNER JOIN  -- only use trips on tours destinating in study-area
            #projectMGRAs AS [tourDestinationProjectMGRAs]
        ON
            [geography_tour_destination].[tour_destination_mgra_13] = [tourDestinationProjectMGRAs].[mgra]
        INNER JOIN
            [dimension].[model]
        ON
            [person_trip].[model_trip_id] = [model].[model_id]
        INNER JOIN
            [dimension].[purpose]
        ON
            [tour].[purpose_tour_id] = [purpose].[purpose_id]
        INNER JOIN
            [dimension].[person]
        ON
            [person_trip].[scenario_id] = [person].[scenario_id]
            AND [person_trip].[person_id] = [person].[person_id]
        INNER JOIN
            [dimension].[geography_work_location]
        ON
            [person].[geography_work_location_id] = [geography_work_location].[geography_work_location_id]
        INNER JOIN  -- only use trips made by employees of study-area
            #projectMGRAs AS [workProjectMGRAs]
        ON
            [geography_work_location].[work_location_mgra_13] = [workProjectMGRAs].[mgra]
        WHERE
            [person_trip].[scenario_id] = @scenario_id
            AND [tour].[scenario_id] = @scenario_id
            AND [person].[scenario_id] = @scenario_id
            AND [model].[model_aggregate_description] = 'Resident Models'  -- ABM resident models
            AND [purpose].[purpose_description] = 'Work'  -- Work purpose tours
        GROUP BY
            [tour].[tour_id]
    ) AS [tt]
    OPTION(MAXDOP 1)

    DROP TABLE #projectMGRAs

END
GO
