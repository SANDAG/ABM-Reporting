SET NOCOUNT ON;
GO


-- create [cmcp_2021] schema -------------------------------------------------
-- note [cmcp_2021] schema permissions are defined at end of file
IF NOT EXISTS (
    SELECT TOP 1
        [schema_name]
    FROM
        [information_schema].[schemata] 
    WHERE
        [schema_name] = 'cmcp_2021'
)
EXEC ('CREATE SCHEMA [cmcp_2021]')
GO

-- add metadata for [cmcp_2021] schema
IF EXISTS(
    SELECT TOP 1
        [FullObjectName]
    FROM
        [db_meta].[data_dictionary]
    WHERE
        [ObjectType] = 'SCHEMA'
        AND [FullObjectName] = '[cmcp_2021]'
        AND [PropertyName] = 'MS_Description'
)
BEGIN
    EXECUTE [db_meta].[drop_xp] 'cmcp_2021', 'MS_Description'
    EXECUTE [db_meta].[add_xp] 'cmcp_2021', 'MS_Description', 'schema to hold all objects associated with the 2021 CMCP Study'
END
GO


-- create table of cmcp corridors --------------------------------------------
DROP TABLE IF EXISTS [cmcp_2021].[cmcp_corridors]
/**
summary:   >
    Creates table holding 2021 CMCP corridor metadata.
**/
BEGIN
    -- create table to hold results of 2021 regional plan measures
	CREATE TABLE [cmcp_2021].[cmcp_corridors] (
        [id] int NOT NULL,
        [cmcp_name] nvarchar(50) NOT NULL,
		[sub_area] nvarchar(100) NULL,
        [notes] nvarchar(100) NULL,
        [last_update] smalldatetime NOT NULL,
        [shape] geometry NOT NULL,
		CONSTRAINT pk_cmcp_corridors PRIMARY KEY ([id]))
	WITH (DATA_COMPRESSION = PAGE)

    -- insert data from GIS server
    INSERT INTO [cmcp_2021].[cmcp_corridors]
    SELECT 
        [OBJECTID] AS [id]
        ,[CorridorName] AS [sub_area]
        ,[SubArea] AS [sub_area]
        ,[Notes] AS [notes]
        ,[LastUpdate] AS [last_update]
        ,[Shape] AS [shape]
    FROM OPENQUERY([sql2014b8],'SELECT * FROM [CMCP].[dbo].[CMCPCORRIDORS]')
 
    -- add table metadata
	EXECUTE [db_meta].[add_xp] 'cmcp_2021.cmcp_corridors', 'MS_Description', 'table to hold CMCP corridor metadata'
    EXECUTE [db_meta].[add_xp] 'cmcp_2021.cmcp_corridors.id', 'MS_Description', 'unique surrogate key'
	EXECUTE [db_meta].[add_xp] 'cmcp_2021.cmcp_corridors.cmcp_name', 'MS_Description', 'name of the CMCP corridor'
	EXECUTE [db_meta].[add_xp] 'cmcp_2021.cmcp_corridors.sub_area', 'MS_Description', 'sub-area of the CMCP measure'
	EXECUTE [db_meta].[add_xp] 'cmcp_2021.cmcp_corridors.notes', 'MS_Description', 'notes'
	EXECUTE [db_meta].[add_xp] 'cmcp_2021.cmcp_corridors.shape', 'MS_Description', 'CMCP corridor geometry in EPSG:2230'
END
GO


-- create table holding results of cmcp_2021 measures ------------------------
DROP TABLE IF EXISTS [cmcp_2021].[results]
/**
summary:   >
    Creates table holding results from 2021 CMCP measures.
    This holds all outputs except for interim results used as inputs
    to other processes from:
        ??? TODO: Update this
**/
BEGIN
    -- create table to hold results of 2021 regional plan measures
	CREATE TABLE [cmcp_2021].[results] (
        [scenario_id] int NOT NULL,
        [cmcp_name] nvarchar(50) NOT NULL,
		[measure] nvarchar(100) NOT NULL,
        [metric] nvarchar(200) NOT NULL,
        [value] float NOT NULL,
        [updated_by] nvarchar(100) NOT NULL,
        [updated_date] smalldatetime NOT NULL,
		CONSTRAINT pk_cmcp_results PRIMARY KEY ([scenario_id], [cmcp_name], [measure], [metric]))
	WITH (DATA_COMPRESSION = PAGE)

    -- add table metadata
	EXECUTE [db_meta].[add_xp] 'cmcp_2021.results', 'MS_Description', 'table to hold results for 2021 CMCP measures'
    EXECUTE [db_meta].[add_xp] 'cmcp_2021.results.scenario_id', 'MS_Description', 'ABM scenario in ABM database [dimension].[scenario]'
	EXECUTE [db_meta].[add_xp] 'cmcp_2021.results.cmcp_name', 'MS_Description', 'name of the CMCP corridor'
	EXECUTE [db_meta].[add_xp] 'cmcp_2021.results.measure', 'MS_Description', 'name of the CMCP measure'
	EXECUTE [db_meta].[add_xp] 'cmcp_2021.results.metric', 'MS_Description', 'metric within the measure'
	EXECUTE [db_meta].[add_xp] 'cmcp_2021.results.value', 'MS_Description', 'value of the specified metric within the measure'
    EXECUTE [db_meta].[add_xp] 'cmcp_2021.results.updated_by', 'MS_Description', 'SQL username who last updated the value of the specified metric within the measure'
    EXECUTE [db_meta].[add_xp] 'cmcp_2021.results.updated_date', 'MS_Description', 'date the value of the specified metric within the measure was last updated'
END
GO


-- create destinations table valued function for access measures destinations ----
DROP FUNCTION IF EXISTS [cmcp_2021].[fn_destinations]
GO

CREATE FUNCTION [cmcp_2021].[fn_destinations] (
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
)
RETURNS TABLE
AS
RETURN
/**
summary:   >
    Destinations at the MGRA level used in calculations for the CMCP 2021
	Access Measures. These measures mirror the 2021 Regional Plan Main
    Performance Measures M1 and M5. Allows aggregation to MGRA or TAZ level
	for both transit and auto accessibility.
**/
SELECT
    CONVERT(integer, [geography].[mgra_13]) AS [mgra]
	,CONVERT(integer, [geography].[taz_13]) AS [taz]
    ,ISNULL([mgra_tiers].[tier], 0) AS [employmentCenterTier]
	,[emp_health] AS [empHealth]
	,[parkactive] AS [parkActive]
	,[emp_retail] AS [empRetail]
    ,[collegeenroll] + [othercollegeenroll] AS [higherLearningEnrollment]
    ,[othercollegeenroll] AS [otherCollegeEnrollment]
FROM
	[fact].[mgra_based_input]
INNER JOIN
	[dimension].[geography]
ON
	[mgra_based_input].[geography_id] = [geography].[geography_id]
LEFT OUTER JOIN (  -- get indicators if MGRAs in Tier 1-4 employment centers
	SELECT
		[mgra_13]
		,[tier]
	FROM OPENQUERY(DDAMWSQL16, 'SELECT [mgra_13], [tier] FROM [employment].[employment_centers].[fn_get_mgra_xref](1) WHERE [tier] IN (1,2,3,4)')) AS [mgra_tiers]
ON
	[geography].[mgra_13] = CONVERT(nvarchar, [mgra_tiers].[mgra_13])
WHERE
	[mgra_based_input].[scenario_id] = @scenario_id
GO

-- add metadata for [cmcp_2021].[fn_destinations]
EXECUTE [db_meta].[add_xp] 'cmcp_2021.fn_destinations', 'MS_Description', 'access measures destinations'
GO


-- high-frequency transit stops by CMCP corridor -----------------------------
DROP FUNCTION IF EXISTS [cmcp_2021].[fn_hf_transit_stops]
GO

CREATE FUNCTION [cmcp_2021].[fn_hf_transit_stops](@scenario_id integer) 
RETURNS TABLE
AS
/**	
summary:   >
    Input for Measure: Percentage of Population within 0.5-mile of
    high-frequency (≤15 min peak) transit stops. High-frequency transit
    stops are defined by the combined headway frequency of transit stops on a
    node, route, and direction where multiple stops ocurring on the same node,
    route, direction, and configuration are counted only once.
**/
RETURN
with [high_freq_nodes] AS (
	-- combine multiple stops at the same [near_node]
	-- on the same [route] and [direction] across different [config]
	-- summing vehicles defined by the headways
	-- have to select distinct as same [near_node]
	-- on different [route] and/or [direction] can appear
	SELECT DISTINCT
		[near_node]
	FROM (
		-- combine multiple stops at the same [near_node] with the same [config]
		-- not double-counting the vehicles defined by the headways
		SELECT DISTINCT
			[near_node]
			,[config]
			,[config] / 1000 AS [route]
			,([config] - 1000 * ([config] / 1000)) / 100 AS [direction]
			,CASE WHEN [am_headway] > 0 THEN 60.0 / [am_headway] ELSE 0 END AS [am_vehicles]
			,CASE WHEN [pm_headway] > 0 THEN 60.0 / [pm_headway] ELSE 0 END AS [pm_vehicles]
			,CASE WHEN [op_headway] > 0 THEN 60.0 / [op_headway] ELSE 0 END AS [op_vehicles]
		FROM
			[dimension].[transit_stop]
		INNER JOIN
			[dimension].[transit_route]
		ON
			[transit_stop].[scenario_id] = [transit_route].[scenario_id]
			AND [transit_stop].[transit_route_id] = [transit_route].[transit_route_id]
		WHERE
			[transit_stop].[scenario_id] = @scenario_id
			AND [transit_route].[scenario_id] = @scenario_id) AS [unique_stops]
	GROUP BY
		[near_node]
		,[route]
		,[direction]
	HAVING
        -- hardcoded 60/15 translates 15 minute headways into vehicles per hour
		SUM([am_vehicles]) >= 60.0 / 15
		OR SUM([pm_vehicles]) >= 60.0 / 15
		OR SUM([op_vehicles]) >= 60.0 / 15)

SELECT
	@scenario_id AS [scenario_id]
	,[cmcp_name]
	,[tt_high_freq_nodes].[near_node]
	,[transit_stop_shape] AS [near_node_shape]
FROM (
	-- create an interim table of the high-frequency transit nodes
	-- to allow one-to-one join of geometry column as
	-- geometry columns do not allow for DISTINCT statements
	-- [near_node]s can have multiple [transit_stop_id]s
	-- but the [transit_stop_shape] is always the same within a [near_node]
	SELECT
		[high_freq_nodes].[near_node]
		,MIN([transit_stop].[transit_stop_id]) AS [min_transit_stop_id]
	FROM
		[high_freq_nodes]
	INNER JOIN
		[dimension].[transit_stop]
	ON
		[transit_stop].[scenario_id] = @scenario_id
		AND [transit_stop].[near_node] = [high_freq_nodes].[near_node]
	GROUP BY
		[high_freq_nodes].[near_node]) AS [tt_high_freq_nodes]
INNER JOIN (
    SELECT 
		[transit_stop_id]
        ,[transit_stop_shape]
        ,[cmcp_name]
	FROM 
		[dimension].[transit_stop]
    INNER JOIN
        [cmcp_2021].[cmcp_corridors]
    ON
		[transit_stop].scenario_id = @scenario_id
		AND	[cmcp_corridors].[shape].STIntersects([transit_stop].[transit_stop_shape]) = 1) AS [xref]	
ON	
	[tt_high_freq_nodes].[min_transit_stop_id] = [xref].[transit_stop_id]

UNION ALL

SELECT
	@scenario_id AS [scenario_id]
	,'Region' [CorridorName]
	,[tt_high_freq_nodes].[near_node]
	,[transit_stop_shape] AS [near_node_shape]
FROM (
	-- create an interim table of the high-frequency transit nodes
	-- to allow one-to-one join of geometry column as
	-- geometry columns do not allow for DISTINCT statements
	-- [near_node]s can have multiple [transit_stop_id]s
	-- but the [transit_stop_shape] is always the same within a [near_node]
	SELECT
		[high_freq_nodes].[near_node]
		,MIN([transit_stop].[transit_stop_id]) AS [min_transit_stop_id]
	FROM
		[high_freq_nodes]
	INNER JOIN
		[dimension].[transit_stop]
	ON
		[transit_stop].[scenario_id] = @scenario_id
		AND [transit_stop].[near_node] = [high_freq_nodes].[near_node]
	GROUP BY
		[high_freq_nodes].[near_node]) AS [tt_high_freq_nodes]
	INNER JOIN	
			[dimension].[transit_stop]			
	ON	 	
		[transit_stop].scenario_id = @scenario_id
		AND	[tt_high_freq_nodes].[min_transit_stop_id] = [transit_stop].[transit_stop_id]
GO

EXECUTE [db_meta].[add_xp] 'cmcp_2021.fn_hf_transit_stops', 'MS_Description', 'high-frequency transit stops by CMCP corridor'
GO


-- create xref function of scenario highway network links to CMCP corridor ---
DROP FUNCTION IF EXISTS [cmcp_2021].[fn_hwy_cmcp_xref]
GO

CREATE FUNCTION [cmcp_2021].[fn_hwy_cmcp_xref](@scenario_id integer) 
RETURNS TABLE
AS
RETURN
SELECT DISTINCT
	[cmcp_name]
    ,[hwy_link_id]
FROM 
	[dimension].[hwy_link]
INNER JOIN
	[cmcp_2021].[cmcp_corridors]
ON
	[cmcp_corridors].[shape].STIntersects([hwy_link].[shape]) = 1
WHERE     
	[hwy_link].[scenario_id] = @scenario_id 
GO

EXECUTE [db_meta].[add_xp] 'cmcp_2021.fn_hwy_cmcp_xref', 'MS_Description', 'cross-reference of ABM scenario highway network links to CMCP corridors'
GO


-- create xref function of Series 13 MGRAs and CMCP corridors ----------------
DROP FUNCTION IF EXISTS [cmcp_2021].[fn_mgra_cmcp_xref]
GO

CREATE FUNCTION [cmcp_2021].[fn_mgra_cmcp_xref]() 
RETURNS TABLE
AS
RETURN
SELECT DISTINCT
	[cmcp_name]
    ,[mgra_13]
FROM 
	[dimension].[geography]
INNER JOIN
	[cmcp_2021].[cmcp_corridors]
ON
	[cmcp_corridors].[shape].STIntersects([geography].[mgra_13_shape]) = 1
WHERE     
	[geography].[mgra_13] <> 'Not Applicable' 
GO

EXECUTE [db_meta].[add_xp] 'cmcp_2021.fn_mgra_cmcp_xref', 'MS_Description', 'cross-reference of Series 13 MGRAs to CMCP corridors'
GO


-- community of concern population by CMCP corridor --------------------------
DROP FUNCTION IF EXISTS [cmcp_2021].[fn_person_coc]
GO

CREATE FUNCTION [cmcp_2021].[fn_person_coc]
(
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@age_18_plus bit = 0  -- optional 1/0 switch to limit population to aged 18+
)
RETURNS TABLE
AS
RETURN
/**	
summary:   >
    Return table of Community of Concern (CoC) populations by CMCP corridors.
**/
SELECT
    @scenario_id AS [scenario_id]
	,[cmcp_name]
    ,CONVERT(integer, [geography].[mgra_13]) AS [mgra]
	,CONVERT(integer, [geography].[taz_13]) AS [taz]
	,SUM([weight_person]) AS [pop]
	,SUM(CASE WHEN [person].[age] >= 75 THEN [weight_person] ELSE 0 END) AS [popSenior]
    ,SUM(CASE WHEN [person].[age] >= 75 THEN 0 ELSE [weight_person] END) AS [popNonSenior]
	,SUM(CASE WHEN [person].[race] IN ('Some Other Race Alone',
									   'Asian Alone',
									   'Black or African American Alone',
									   'Two or More Major Race Groups',
									   'Native Hawaiian and Other Pacific Islander Alone',
									   'American Indian and Alaska Native Tribes specified; or American Indian or Alaska Native, not specified and no other races')
                   OR [person].[hispanic] = 'Hispanic'
            THEN [weight_person] ELSE 0 END) AS [popMinority]
    ,SUM(CASE WHEN [person].[race] IN ('Some Other Race Alone',
									   'Asian Alone',
									   'Black or African American Alone',
									   'Two or More Major Race Groups',
									   'Native Hawaiian and Other Pacific Islander Alone',
									   'American Indian and Alaska Native Tribes specified; or American Indian or Alaska Native, not specified and no other races')
                   OR [person].[hispanic] = 'Hispanic'
            THEN 0 ELSE [weight_person] END) AS [popNonMinority]
	,SUM(CASE WHEN [household].[poverty] <= 2 THEN [weight_person] ELSE 0 END) AS [popLowIncome]
    ,SUM(CASE WHEN [household].[poverty] <= 2 THEN 0 ELSE [weight_person] END) AS [popNonLowIncome]
    ,SUM(CASE WHEN [person].[age] >= 75
              OR ([person].[race] IN ('Some Other Race Alone',
									  'Asian Alone',
									  'Black or African American Alone',
									  'Two or More Major Race Groups',
									  'Native Hawaiian and Other Pacific Islander Alone',
									  'American Indian and Alaska Native Tribes specified; or American Indian or Alaska Native, not specified and no other races')
                  OR [person].[hispanic] = 'Hispanic')
              OR [household].[poverty] <= 2
              THEN [weight_person] ELSE 0 END) AS [popCoC]
    ,SUM(CASE WHEN [person].[age] >= 75
              OR ([person].[race] IN ('Some Other Race Alone',
									  'Asian Alone',
									  'Black or African American Alone',
									  'Two or More Major Race Groups',
									  'Native Hawaiian and Other Pacific Islander Alone',
									  'American Indian and Alaska Native Tribes specified; or American Indian or Alaska Native, not specified and no other races')
                  OR [person].[hispanic] = 'Hispanic')
              OR [household].[poverty] <= 2
              THEN 0 ELSE [weight_person] END) AS [popNonCoC]
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
INNER JOIN
    [cmcp_2021].[fn_mgra_cmcp_xref]() AS [xref]
ON
    [geography].[mgra_13] = [xref].[mgra_13]
WHERE
	[person].[scenario_id] = @scenario_id
	AND [household].[scenario_id] = @scenario_id
	AND ((@age_18_plus = 1 AND [person].[age] >= 18) OR @age_18_plus = 0)  -- if age 18+ option is selected restrict population to individuals age 18 or older
GROUP BY
    [geography].[mgra_13]
	,[geography].[taz_13]
    ,[cmcp_name]
GO

EXECUTE [db_meta].[add_xp] 'cmcp_2021.fn_person_coc', 'MS_Description', 'community of concern population by CMCP corridor'
GO


-- transit stops by CMCP corridor --------------------------------------------
DROP FUNCTION IF EXISTS [cmcp_2021].[fn_transit_stops]
GO

CREATE FUNCTION [cmcp_2021].[fn_transit_stops](@scenario_id integer) 
RETURNS TABLE
AS
/**	
summary:   >
    Input for Measure: Percentage and Total Population in Multi-Family
    residences within 0..25-miles of a transit stop by CMCP corridor.
**/
RETURN
SELECT
	[min_stop_id] AS [stop_id]
	,[nodes_cmcp].[near_node]
	,[cmcp_name]
	,[transit_stop_shape] AS [shape]
FROM (
	SELECT DISTINCT
        [near_node]
        ,[cmcp_name]
	FROM 
		[dimension].[transit_stop]
    INNER JOIN
		[cmcp_2021].[cmcp_corridors]
    ON
        [transit_stop].[scenario_id] = @scenario_id
		AND	[cmcp_corridors].[shape].STIntersects([transit_stop].[transit_stop_shape]) = 1) AS [nodes_cmcp]
INNER JOIN (
	SELECT 
		[near_node]
        ,MIN([transit_stop_id]) AS [min_stop_id]
	FROM 
		[dimension].[transit_stop]
	WHERE 	
		[transit_stop].[scenario_id] = @scenario_id
	GROUP BY
		[near_node]) AS [min_stop]
ON
	[nodes_cmcp].[near_node] =  [min_stop].[near_node]
INNER JOIN 
	[dimension].[transit_stop]
ON  
	[min_stop].[min_stop_id] = [transit_stop].[transit_stop_id]
WHERE 	
	[transit_stop].[scenario_id] = @scenario_id

UNION ALL

SELECT
	[min_stop_id] AS [stop_id]
	,[transit_stop].[near_node]
	,'Region' AS [cmcp_name]
	,[transit_stop_shape] AS [shape]
FROM
	[dimension].[transit_stop]
INNER JOIN (
	SELECT 
		[near_node]
        ,MIN([transit_stop_id]) AS [min_stop_id]
	FROM 
		[dimension].[transit_stop]
	WHERE 	
		[transit_stop].[scenario_id] = @scenario_id
	GROUP BY
		[near_node]) AS [min_stop]
ON  
	[min_stop].[min_stop_id] = [transit_stop].[transit_stop_id]
WHERE 	
	[transit_stop].[scenario_id] = @scenario_id

GO

EXECUTE [db_meta].[add_xp] 'cmcp_2021.fn_transit_stops', 'MS_Description', 'transit stops by CMCP corridor'
GO


-- average peak-period person-trip travel time to work by mode ---------------
DROP PROCEDURE IF EXISTS [cmcp_2021].[sp_commute_time]
GO

CREATE PROCEDURE [cmcp_2021].[sp_commute_time]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@peak_period bit,  -- 1/0 switch filtering to peak period trips
    @update bit,  -- 1/0 switch to actually run the measure
        -- and update the [cmcp_2021].[results] table instead of
        -- grabbing the results from the [cmcp_2021].[results] table
    @silent bit   -- 1/0 switch to suppress result set output so only the
        -- [cmcp_2021].[results] table is updated with no output
AS
/**	
summary:   >
	Based on Federal RTP 2020 Performance Measure A, average peak-period
    person trip travel time in minutes to work by mode by CMCP Corridor.
    Only trips that go directly from home to work are considered.
    Similar to Performance Measures 1a and 7d in the 2015 RTP.

filters:   >
    [model_trip].[model_trip_description] IN ('Individual', 'Internal-External','Joint')
        ABM resident sub-models
    [inbound].[inbound_description] = 'Outbound'
        only to-work trips are considered
    [time_trip_start].[trip_start_abm_5_tod] IN ('2', '4')
        peak period trips that start in the ABM five time of day peak periods
    [purpose_trip_origin].[purpose_trip_origin_description] = 'Home'
        trips must originate at home
    [purpose_trip_destination].[purpose_trip_destination_description] = 'Work'
        trips must destinate at work
**/
BEGIN
    SET NOCOUNT ON;
    DECLARE @measure nvarchar(100) = 'Average Commute Time to Work'

    -- if update switch is selected then run the performance measure and replace
    -- the value of the result set in the [results] table
    IF(@update = 1)
    BEGIN
        -- remove measure result for the given ABM scenario from the results table
        DELETE FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] = @measure
  
	    -- create temporary table for Series 13 MGRAs to CMCP corridor xref
	    SELECT [mgra_13], [cmcp_name]
	    INTO [#mgra_cmcp_xref_all]
	    FROM [cmcp_2021].[fn_mgra_cmcp_xref]() 

	    -- declare cursor to loop through cmcp corridor names
        DECLARE db_cursor CURSOR FOR 
	    SELECT DISTINCT [cmcp_name] FROM [cmcp_2021].[cmcp_corridors] 
	    WHERE [cmcp_name] NOT IN ('Central Mobility Hub and Connections')
	    UNION ALL SELECT 'Region'

        -- open cursor and loop through cmcp corridor names
        DECLARE @cmcp_name nvarchar (100)
	    OPEN db_cursor
	    FETCH NEXT FROM db_cursor INTO @cmcp_name 
	    WHILE @@FETCH_STATUS = 0  

        BEGIN 
		     -- insert result set into results table
		    INSERT INTO [cmcp_2021].[results] (
			    [scenario_id]
			    ,[cmcp_name]
			    ,[measure]
			    ,[metric]
			    ,[value]
			    ,[updated_by]
			    ,[updated_date])  
		    SELECT
			    @scenario_id AS [scenario_id]        
			    ,@cmcp_name AS [cmcp_name]
			    ,@measure AS [measure]
			    ,CONCAT(CASE WHEN @peak_period = 1 THEN 'Peak Period' ELSE 'All Day' END, ' - ',
				        RTRIM([mode_aggregate_trip_description])) 	  
			    ,SUM([time_total] * [weight_person_trip]) /
					    SUM([weight_person_trip]) 
			    ,USER_NAME() AS [updated_by]
			    ,SYSDATETIME() AS [updated_date]
		    FROM
			    [fact].[person_trip]
		    INNER JOIN
			     [dimension].[inbound]
		    ON
			    [person_trip].[inbound_id] = [inbound].[inbound_id]
		    INNER JOIN
			     [dimension].[mode_trip]
		    ON
			    [person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
		    INNER JOIN
			     [dimension].[model_trip]
		    ON
			    [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
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
			     dimension.geography
		    ON
			    [person_trip].geography_trip_origin_id = geography.geography_id
		    LEFT OUTER JOIN
			    [#mgra_cmcp_xref_all] AS [xref]
		    ON
			    [xref].[cmcp_name] = @cmcp_name
			    AND [xref].[mgra_13] = [geography].mgra_13
		    WHERE
			    [person_trip].[scenario_id] = @scenario_id
			    -- to work trips only
			    AND [inbound].[inbound_description] = 'Outbound'
			    -- resident models only
			    AND [model_trip].[model_trip_description] IN ('Individual',
															  'Internal-External',
															  'Joint')
			    -- trips that start in abm five time of day peak periods only
			    AND ((@peak_period = 1 and [time_trip_start].[trip_start_abm_5_tod] IN ('2', '4'))
				     OR @peak_period = 0)
			    -- work trips must start at home, a direct to work trip
			    AND [purpose_trip_origin].[purpose_trip_origin_description] = 'Home'
			    AND [purpose_trip_destination].[purpose_trip_destination_description] = 'Work'
			    AND ([xref].[mgra_13] IS NOT NULL OR @cmcp_name = 'Region')
		     GROUP BY
				    [mode_aggregate_trip_description]
		  
		    FETCH NEXT FROM db_cursor INTO @cmcp_name
	    END 

	    CLOSE db_cursor  
	    DEALLOCATE db_cursor   

	    DROP TABLE [#mgra_cmcp_xref_all]
    END
	
    -- if silent switch is selected then do not output a result set
    IF(@silent = 1)
        RETURN;
    ELSE
        -- return the result set
        SELECT
            [scenario_id]
		    ,[cmcp_name]
            ,[measure]
            ,[metric]
            ,[value]
            ,[updated_by]
            ,[updated_date]
        FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] = @measure
END
GO

EXECUTE [db_meta].[add_xp] 'cmcp_2021.sp_commute_time', 'MS_Description', 'average commute time by mode by CMCP corridor'
GO


-- vehicle delay per capita --------------------------------------------------
DROP PROCEDURE IF EXISTS [cmcp_2021].[sp_vehicle_delay_per_capita]
GO

CREATE PROCEDURE [cmcp_2021].[sp_vehicle_delay_per_capita]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@update bit = 1,  -- 1/0 switch to actually run the measure
        -- and update the [cmcp_2021].[results] table instead of
        -- grabbing the results from the [cmcp_2021].[results] table
    @silent bit = 1  -- 1/0 switch to suppress result set output so only the
        -- [cmcp_2021].[results] table is updated with no output
AS
/**	
summary:   >
    Daily vehicle delay per capita (minutes) by CMCP corridor.
    Based on Federal RTP 2020 Performance Measure 1A, Daily vehicle delay
    per capita (minutes). Formerly Performance Measure 1B in the 2015 RP,
    this is the sum of link level vehicle flows multiplied by the difference
    between congested and free flow travel time and then divided by the total
    synthetic population for a given ABM scenario.
    Here, the metric is given within each CMCP corridor via an on-the-fly 
    spatial insersects xref between CMCP corridors and highway network links.

filters:   >
    ([time] - ([tm] + [tx])) >= 0 
        remove 0 values from vehicle delay
    [hwy_flow].[tm] != 999
        remove missing values for the loaded highway travel time
**/
BEGIN
    SET NOCOUNT ON;
    DECLARE @measure nvarchar(100) = 'Daily Vehicle Delay per Capita'

    -- if update switch is selected then run the performance measure and replace
    -- the value of the result set in the [results] table
    IF(@update = 1)
    BEGIN
        -- remove measure result for the given ABM scenario from the results table
        DELETE FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] = @measure

	    -- create temporary table for Series 13 MGRAs to CMCP corridor xref
	    SELECT [mgra_13], [cmcp_name]
	    INTO [#mgra_cmcp_xref_all]
	    FROM [cmcp_2021].[fn_mgra_cmcp_xref]()

        -- create temporary table for ABM scenario highway network
        -- to CMCP corridor xref
	    SELECT [hwy_link_id], [cmcp_name]
	    INTO [#hwy_cmcp_xref_all]
	    FROM [cmcp_2021].[fn_hwy_cmcp_xref](@scenario_id) 

	    -- declare cursor to loop through cmcp corridor names
        DECLARE db_cursor CURSOR FOR 
	    SELECT DISTINCT [cmcp_name] FROM [cmcp_2021].[cmcp_corridors] 
	    WHERE [cmcp_name] NOT IN ('Central Mobility Hub and Connections')
	    UNION ALL SELECT 'Region'

        -- open cursor and loop through cmcp corridor names
        DECLARE @cmcp_name nvarchar (100)
	    OPEN db_cursor
	    FETCH NEXT FROM db_cursor INTO @cmcp_name 
	    WHILE @@FETCH_STATUS = 0  

        BEGIN 
            -- get total population with CMCP corridor
		    DECLARE @population float = (
		        SELECT
			        SUM([weight_person]) AS [population]
		        FROM
			        [dimension].[person]
		        INNER JOIN
			        [dimension].[household]
		        ON
			        [person].[scenario_id] = household.[scenario_id]
			        AND [person].[household_id] = [household].[household_id]
		        INNER JOIN 
			        [dimension].[geography]
		        ON
			        [household].[geography_household_location_id] = [geography].[geography_id]	
		        LEFT OUTER JOIN
			        [#mgra_cmcp_xref_all]
		        ON
			        [#mgra_cmcp_xref_all].[cmcp_name] = @cmcp_name
			        AND [geography].[mgra_13] =  [#mgra_cmcp_xref_all].[mgra_13]
		        WHERE
			        [person].[scenario_id] = @scenario_id
			        AND [household].[scenario_id] = @scenario_id
			        AND ([#mgra_cmcp_xref_all].[mgra_13] IS NOT NULL OR @cmcp_name = 'Region')
            )
		
            -- get vhd within cmcp corridor
	        DECLARE @vehicle_delay float = (
		        SELECT			
			        SUM(([time] - ([tm] + [tx])) * [flow]) AS [vd]    
		        FROM
			        [fact].[hwy_flow]
		        INNER JOIN
			        [dimension].[hwy_link_ab_tod]
		        ON
			        [hwy_flow].[scenario_id] = [hwy_link_ab_tod].[scenario_id]
			        AND [hwy_flow].[hwy_link_ab_tod_id] = [hwy_link_ab_tod].[hwy_link_ab_tod_id]
		        LEFT OUTER JOIN 
			        [#hwy_cmcp_xref_all]
		        ON 
			        [#hwy_cmcp_xref_all].[cmcp_name] = @cmcp_name
			        AND [hwy_flow].[hwy_link_id] = [#hwy_cmcp_xref_all].[hwy_link_id]	
		        WHERE
			        [hwy_flow].[scenario_id] = @scenario_id
			        AND [hwy_link_ab_tod].[scenario_id] = @scenario_id
			        AND ([time] - ([tm] + [tx])) >= 0  -- remove 0 values from vehicle delay
			        AND [tm] != 999  -- remove missing values for the loaded highway travel time
			        AND ([#hwy_cmcp_xref_all].[hwy_link_id] IS NOT NULL OR @cmcp_name = 'Region')
	        )
	
		     -- insert result set into results table
		    INSERT INTO [cmcp_2021].[results] (
			    [scenario_id]
			    ,[cmcp_name]
			    ,[measure]
			    ,[metric]
			    ,[value]
			    ,[updated_by]
			    ,[updated_date]) 
		    SELECT
                @scenario_id AS [scenario_id]
			    ,@cmcp_name AS [cmcp_name] 
			    ,@measure AS [measure]
			    ,@measure AS [metric]
			    ,@vehicle_delay/@population AS [value]
			    ,USER_NAME() AS [updated_by]
			    ,SYSDATETIME() AS [updated_date]
                
		    FETCH NEXT FROM db_cursor INTO @cmcp_name
	    END 

	    CLOSE db_cursor  
	    DEALLOCATE db_cursor   

	    DROP TABLE [#mgra_cmcp_xref_all]
        DROP TABLE [#hwy_cmcp_xref_all]
    END
	
    -- if silent switch is selected then do not output a result set
    IF(@silent = 1)
        RETURN;
    ELSE
        -- return the result set
        SELECT
            [scenario_id]
		    ,[cmcp_name]
            ,[measure]
            ,[metric]
            ,[value]
            ,[updated_by]
            ,[updated_date]
        FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] = @measure
END
GO

EXECUTE [db_meta].[add_xp] 'cmcp_2021.sp_vehicle_delay_per_capita', 'MS_Description', 'vehicle delay (minutes) per capita by CMCP corridor'
GO


-- corridor vmt and vmt per lane mile ----------------------------------------
DROP PROCEDURE IF EXISTS [cmcp_2021].[sp_link_vmt]
GO

CREATE PROCEDURE [cmcp_2021].[sp_link_vmt]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [dbo].[cmcp_pm_results] table instead of
        -- grabbing the results from the [dbo].[cmcp_pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [cmcp_2021].[results] table is updated with no output
AS
/**	
summary:   >
    Highway network link-based VMT and link-based VMT per lane mile by CMCP
    corridor.
**/
BEGIN
    SET NOCOUNT ON;

    -- if update switch is selected then run the performance measure and replace
    -- the value of the result set in the [results] table
    IF(@update = 1)
    BEGIN
        -- remove measure result for the given ABM scenario from the results table
        DELETE FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] IN ('VMT', 'VMT per Lane Mile')

        -- create temporary table for ABM scenario highway network
        -- to CMCP corridor xref
	    SELECT [hwy_link_id], [cmcp_name]
	    INTO [#hwy_cmcp_xref_all]
	    FROM [cmcp_2021].[fn_hwy_cmcp_xref](@scenario_id) 

	    -- declare cursor to loop through cmcp corridor names
        DECLARE db_cursor CURSOR FOR 
	    SELECT DISTINCT [cmcp_name] FROM [cmcp_2021].[cmcp_corridors] 
	    WHERE [cmcp_name] NOT IN ('Central Mobility Hub and Connections')
	    UNION ALL SELECT 'Region'

        -- open cursor and loop through cmcp corridor names
        DECLARE @cmcp_name nvarchar (100)
	    OPEN db_cursor
	    FETCH NEXT FROM db_cursor INTO @cmcp_name 
	    WHILE @@FETCH_STATUS = 0  

        BEGIN 
            -- link-based VMT by CMCP corridor
	        DECLARE @vmt float = (
		        SELECT 			
			        SUM([hwy_flow].[flow] * [hwy_link].[length_mile]) AS [vmt]	
		        FROM
			        [fact].[hwy_flow]
		        INNER JOIN
			        [dimension].[hwy_link]	
		        ON
			        [hwy_flow].[scenario_id] = [hwy_link].[scenario_id]
			        AND [hwy_flow].[hwy_link_id] = [hwy_link].[hwy_link_id]
		        LEFT OUTER JOIN 
			         [#hwy_cmcp_xref_all] AS [xref]
		        ON 
			        [xref].[cmcp_name] = @cmcp_name
			        AND [hwy_link].[hwy_link_id] = [xref].[hwy_link_id]
		        WHERE
			        [hwy_flow].[scenario_id] = @scenario_id
			        AND [hwy_link].[scenario_id] = @scenario_id
			        AND ([xref].[hwy_link_id] IS NOT NULL OR @cmcp_name = 'Region')
            ) 
            
            -- total lane miles by CMCP corridor for mid-day time period
		    DECLARE @lanemiles float = (
			    SELECT
			        --auxiliary lanes not included		
				    SUM(CASE WHEN [ln] = 9 THEN 0 ELSE [ln]*[length_mile] END) AS [lane_miles]
			    FROM 
				    [dimension].[hwy_link_ab_tod]
			    INNER JOIN 
				    [dimension].[hwy_link]
			    ON 
				    [hwy_link_ab_tod].hwy_link_id = hwy_link.hwy_link_id
				    and [hwy_link_ab_tod].scenario_id = hwy_link.scenario_id
			    INNER JOIN
				    [dimension].[time]
			    ON
				    time.time_id = [hwy_link_ab_tod].time_id
			    LEFT OUTER JOIN 
				    [#hwy_cmcp_xref_all] AS [xref]
			    ON 
				    [xref].[cmcp_name] = @cmcp_name
				    AND [hwy_link].hwy_link_id = [xref].[hwy_link_id]	
			    WHERE 
				    [hwy_link_ab_tod].scenario_id = @scenario_id
				    AND [abm_5_tod] = '3'  -- mid-day
				    AND ([xref].[hwy_link_id] IS NOT NULL OR @cmcp_name = 'Region')
            ) 

		     -- insert result set into results table
		    INSERT INTO [cmcp_2021].[results] (
			    [scenario_id]
			    ,[cmcp_name]
			    ,[measure]
			    ,[metric]
			    ,[value]
			    ,[updated_by]
			    ,[updated_date]) 
		    SELECT
                @scenario_id AS [scenario_id]
			    ,@cmcp_name AS [cmcp_name] 
			    ,'VMT' AS [measure]
			    ,'VMT' AS [metric]
			    ,@vmt AS [value]
			    ,USER_NAME() AS [updated_by]
			    ,SYSDATETIME() AS [updated_date]

            -- insert result set into results table
		    INSERT INTO [cmcp_2021].[results] (
			    [scenario_id]
			    ,[cmcp_name]
			    ,[measure]
			    ,[metric]
			    ,[value]
			    ,[updated_by]
			    ,[updated_date]) 
		    SELECT
                @scenario_id AS [scenario_id]
			    ,@cmcp_name AS [cmcp_name] 
			    ,'VMT per Lane Mile' AS [measure]
			    ,'VMT per Lane Mile' AS [metric]
			    ,@vmt/@lanemiles AS [value]
			    ,USER_NAME() AS [updated_by]
			    ,SYSDATETIME() AS [updated_date]
                
		    FETCH NEXT FROM db_cursor INTO @cmcp_name
	    END 

	    CLOSE db_cursor  
	    DEALLOCATE db_cursor   

	    DROP TABLE [#hwy_cmcp_xref_all]
    END
	
    -- if silent switch is selected then do not output a result set
    IF(@silent = 1)
        RETURN;
    ELSE
        -- return the result set
        SELECT
            [scenario_id]
		    ,[cmcp_name]
            ,[measure]
            ,[metric]
            ,[value]
            ,[updated_by]
            ,[updated_date]
        FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] IN ('VMT', 'VMT per Lane Mile')
END
GO

EXECUTE [db_meta].[add_xp] 'cmcp_2021.sp_link_vmt', 'MS_Description', 'vmt and vmt per lane mile by CMCP corridor'
GO


-- mode share by cmcp corridor -----------------------------------------------
DROP PROCEDURE IF EXISTS [cmcp_2021].[sp_mode_share]
GO

CREATE PROCEDURE [cmcp_2021].[sp_mode_share]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]  	
	@update bit,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [cmcp_2021].[results] table instead of
        -- grabbing the results from the [cmcp_2021].[results] table
    @silent bit,  -- 1/0 switch to suppress result set output so only the
        -- [cmcp_2021].[results] table is updated with no output
	@work bit,  -- 1/0  switch to limit trip purpose to work
	@distance_threshold float -- limit to trips under supplied distance threshold
        -- threshold defined in miles
        -- threshold of 0 allows ALL trips
AS
/**	
summary:   >
    Percent of person-trips by mode by CMCP corridor for trips where either
    the origin or destination are within the CMCP study area. Based on Federal
    RTP 2020 Performance Measure 2A.

    Option to filter to work purpose trips (defined as outbound work tour
    where the mode is determined by the SANDAG tour journey mode hierarchy).

    Option to filter to trips below a specified distance threshold.
    

filters:   >
    [model_trip].[model_trip_description] IN ('Individual', 'Internal-External','Joint')
        ABM resident sub-models
	[tour].[tour_category] = 'Mandatory'
		part of AND condition used if option selected to filter trips to
		outbound work-tour destination only
	[purpose_trip_destination].[purpose_trip_destination_description] = 'Work'
		part of AND condition used if option selected to filter trips to
		outbound work-tour destination only
    [origin_xref].[mgra_13] IS NOT NULL OR [destination_xref].[mgra_13] IS NOT NULL OR @corridor_name = 'Region'
	    Origin or destination within CMCP study area unless Regional metric
        Loops through every CMCP study area and entire Region
    [person_trip].[dist_total] <= @distance_threshold OR @distance_threshold = 0
        Filter trips to those under supplied distance threshold unless threshold set to 0
**/
BEGIN
    SET NOCOUNT ON;

    -- create name of the measure based on options selected
    DECLARE @measure nvarchar(100)
    IF(@work = 0 AND @distance_threshold = 0)
        SET @measure = 'CMCP Mode Share'
    IF(@work = 0 AND @distance_threshold > 0)
        SET @measure = 'CMCP Mode Share - Trips Under ' + CONVERT(nvarchar, @distance_threshold) + ' Miles' 
    IF(@work = 1 AND @distance_threshold = 0)
        SET @measure = 'CMCP Mode Share - Work Trips'
    IF(@work = 1 AND @distance_threshold > 0)
        SET @measure = 'CMCP Mode Share - Work Trips Under ' + CONVERT(nvarchar, @distance_threshold) + ' Miles' 

    -- if update switch is selected then run the measure and replace
    -- the value of the result set in the [cmcp_2021].[results] table
    IF(@update = 1)
    BEGIN
        -- remove measure result for the given ABM scenario from the results table
        DELETE FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] = @measure

	    -- create temporary table for Series 13 MGRAs to CMCP corridor xref
	    SELECT [mgra_13], [cmcp_name]
	    INTO [#mgra_cmcp_xref_all]
	    FROM [cmcp_2021].[fn_mgra_cmcp_xref]()

   
        -- create table variable to hold result set
        DECLARE @aggregated_trips TABLE (
		    [cmcp_name] nvarchar(30) NOT NULL,
	        [mode_aggregate_description] nvarchar(15) NOT NULL,
	        [person_trips] float NOT NULL)


        -- declare cursor to loop through cmcp corridor names
        DECLARE db_cursor CURSOR FOR 
	    SELECT DISTINCT [cmcp_name] FROM [cmcp_2021].[cmcp_corridors] 
	    WHERE [cmcp_name] NOT IN ('Central Mobility Hub and Connections')
	    UNION ALL SELECT 'Region'

        DECLARE @cmcp_name nvarchar (100)

        -- if the work switch IS NOT selected
        IF(@work = 0)
        BEGIN
            -- open cursor and loop through cmcp corridor names
	        OPEN db_cursor
	        FETCH NEXT FROM db_cursor INTO @cmcp_name 
	        WHILE @@FETCH_STATUS = 0  

            -- get person trips by mode for resident models only (Individual, Internal-External, Joint)
		    BEGIN 
			    INSERT INTO @aggregated_trips
			    SELECT
				    @cmcp_name AS [cmcp_name]          
				    ,ISNULL(CASE WHEN [mode_trip].[mode_aggregate_trip_description] IN
								    ('School Bus',
								     'Taxi',
								     'Heavy Heavy Duty Truck',
								     'Light Heavy Duty Truck',
								     'Medium Heavy Duty Truck',
								     'Parking Lot',
								     'Pickup/Drop-off',
								     'Rental car',
								     'TNC Shared',
								     'TNC Single',
								     'Shuttle/Van/Courtesy Vehicle')
							     THEN 'Other'
							     ELSE [mode_trip].[mode_aggregate_trip_description]
							     END, 'Total') AS [mode_aggregate_description]
				    ,SUM(ISNULL([weight_person_trip], 0)) AS [person_trips]
			    FROM
				    [fact].[person_trip]
			    INNER JOIN
				    [dimension].[model_trip]
			    ON
				    [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
			    INNER JOIN
				    [dimension].[mode_trip]
			    ON
				    [person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
			    INNER JOIN
				    [dimension].[geography_trip_origin]
			    ON
				    [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
			    INNER JOIN
				    [dimension].[geography_trip_destination]
			    ON
				    [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
			    LEFT JOIN
				    [#mgra_cmcp_xref_all] AS [origin_xref]
			    ON
					[origin_xref].[cmcp_name] = @cmcp_name
				    AND [geography_trip_origin].[trip_origin_mgra_13] = [origin_xref].[mgra_13]
			    LEFT JOIN
				    [#mgra_cmcp_xref_all] [destination_xref]
			    ON
					[destination_xref].[cmcp_name] = @cmcp_name
				    AND [geography_trip_destination].[trip_destination_mgra_13] = [destination_xref].[mgra_13]
			    WHERE
				    [person_trip].[scenario_id] = @scenario_id
				    AND [model_trip].[model_trip_description] IN ('Individual', 'Internal-External', 'Joint')     
				    AND ([origin_xref].[mgra_13] IS NOT NULL OR [destination_xref].[mgra_13] IS NOT NULL OR @cmcp_name = 'Region')
				    AND ([person_trip].[dist_total] <= @distance_threshold OR @distance_threshold = 0)
			    GROUP BY
				    CASE WHEN [mode_trip].[mode_aggregate_trip_description] IN
				            ('School Bus',
					         'Taxi',
					         'Heavy Heavy Duty Truck',
					         'Light Heavy Duty Truck',
					         'Medium Heavy Duty Truck',
					         'Parking Lot',
					         'Pickup/Drop-off',
					         'Rental car',
					         'TNC Shared',
					         'TNC Single',
					         'Shuttle/Van/Courtesy Vehicle')
					     THEN 'Other'
					     ELSE [mode_trip].[mode_aggregate_trip_description]
					     END
				    WITH ROLLUP

			    FETCH NEXT FROM db_cursor INTO @cmcp_name
		    END 

		    CLOSE db_cursor  
		    DEALLOCATE db_cursor 
	    END
	

        -- if the work switch IS selected
        IF(@work = 1)
        BEGIN
	        -- open cursor and loop through cmcp corridor names
	        OPEN db_cursor
	        FETCH NEXT FROM db_cursor INTO @cmcp_name 
	        WHILE @@FETCH_STATUS = 0  

            -- get outbound work tour journeys
            -- for resident models only (Individual, Internal-External, Joint)
            -- filtered by tour origin or tour destination in cmcp corridor
            -- mode is determined by the SANDAG tour mode hierarchy
            -- person trip weight set to final work destinating person trip weight
            BEGIN
                INSERT INTO @aggregated_trips
                SELECT
			        @cmcp_name AS [cmcp_name]
                    ,ISNULL(CASE WHEN [fn_resident_tourjourney_mode].[mode_aggregate_description] IN
                                    ('School Bus',
                                     'Taxi',
                                     'Heavy Heavy Duty Truck',
                                     'Light Heavy Duty Truck',
                                     'Medium Heavy Duty Truck',
                                     'Parking Lot',
                                     'Pickup/Drop-off',
                                     'Rental car',
						             'TNC Shared',
						             'TNC Single',
                                     'Shuttle/Van/Courtesy Vehicle')
                                 THEN 'Other'
                                 ELSE [fn_resident_tourjourney_mode].[mode_aggregate_description]
                                 END, 'Total') AS [mode_aggregate_description]
                    ,SUM(ISNULL([weight_person_trip], 0)) AS [person_trips]
                FROM
	                [fact].[person_trip]
                INNER JOIN
                    [dimension].[tour]
                ON
                    [person_trip].[scenario_id] = [tour].[scenario_id]
                    AND [person_trip].[tour_id] = [tour].[tour_id]
                INNER JOIN
                    [report].[fn_resident_tourjourney_mode](@scenario_id)
                ON
                    [person_trip].[scenario_id] = [fn_resident_tourjourney_mode].[scenario_id]
                    AND [person_trip].[tour_id] = [fn_resident_tourjourney_mode].[tour_id]
                    AND [person_trip].[inbound_id] = [fn_resident_tourjourney_mode].[inbound_id]
                INNER JOIN
                    [dimension].[inbound]
                ON
                    [person_trip].[inbound_id] = [inbound].[inbound_id]
                INNER JOIN
	                [dimension].[model_trip]
                ON
	                [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
                INNER JOIN
                    [dimension].[purpose_trip_destination]
                ON
                    [person_trip].[purpose_trip_destination_id] = [purpose_trip_destination].[purpose_trip_destination_id]
                INNER JOIN
	                [dimension].[geography_tour_origin]
                ON
	                [tour].[geography_tour_origin_id] = [geography_tour_origin].[geography_tour_origin_id]
                INNER JOIN
	                [dimension].[geography_tour_destination]
                ON
	                [tour].[geography_tour_destination_id] = [geography_tour_destination].[geography_tour_destination_id]
               LEFT JOIN
	                [#mgra_cmcp_xref_all] AS [origin_xref] 
		        ON
					[origin_xref].[cmcp_name] = @cmcp_name
			        AND [geography_tour_origin].[tour_origin_mgra_13] = [origin_xref].[mgra_13]
                LEFT JOIN
			        [#mgra_cmcp_xref_all] AS [destination_xref]
                ON
	                [destination_xref].[cmcp_name] = @cmcp_name
			        AND [geography_tour_destination].[tour_destination_mgra_13] = [destination_xref].[mgra_13]
                WHERE
	                [person_trip].[scenario_id] = @scenario_id
                    AND [tour].[scenario_id] = @scenario_id
                    -- mandatory tours only to remove at-work subtours
                    AND [tour].[tour_category] = 'Mandatory'
                    -- outbound tour journey legs only
                    AND [inbound].[inbound_description] = 'Outbound'
                    -- use person trip weight at the final work destinating trip
                    AND [purpose_trip_destination].[purpose_trip_destination_description] = 'Work'
                    AND [model_trip].[model_trip_description] IN ('Individual', 'Internal-External', 'Joint')     
			        AND ([origin_xref].[mgra_13] IS NOT NULL OR [destination_xref].[mgra_13] IS NOT NULL OR @cmcp_name = 'Region')
			        AND ([person_trip].[dist_total] <= @distance_threshold OR @distance_threshold = 0)
                GROUP BY
			        CASE WHEN [fn_resident_tourjourney_mode].[mode_aggregate_description] IN
                                ('School Bus',
                                'Taxi',
                                'Heavy Heavy Duty Truck',
                                'Light Heavy Duty Truck',
                                'Medium Heavy Duty Truck',
                                'Parking Lot',
                                'Pickup/Drop-off',
                                'Rental car',
						        'TNC Shared',
						        'TNC Single',
                                'Shuttle/Van/Courtesy Vehicle')
                            THEN 'Other'
                            ELSE [fn_resident_tourjourney_mode].[mode_aggregate_description]
                            END
                    WITH ROLLUP

			    FETCH NEXT FROM db_cursor INTO @cmcp_name
	        END 

		    CLOSE db_cursor  
		    DEALLOCATE db_cursor 

            DROP TABLE [#mgra_cmcp_xref_all]
	    END


        -- insert result set into results table
		INSERT INTO [cmcp_2021].[results] (
			[scenario_id]
			,[cmcp_name]
			,[measure]
			,[metric]
			,[value]
			,[updated_by]
			,[updated_date])
        SELECT
	        @scenario_id AS [scenario_id]
		     ,[combos].[cmcp_name] AS [cmcp_name]
            ,@measure AS [measure]
	        ,CONCAT('Percentage of Total Person Trips - ', [combos].[mode]) AS [metric]
	        ,ISNULL(1.0 * [trips].[person_trips] /[total_trips].[person_trips], 0) AS [value]
            ,USER_NAME() AS [updated_by]
            ,SYSDATETIME() AS [updated_date]
        FROM
	        @aggregated_trips AS [trips]
        INNER JOIN
	        @aggregated_trips AS [total_trips]
	    ON
            [trips].[cmcp_name] = [total_trips].[cmcp_name]
            AND [total_trips].[mode_aggregate_description] = 'Total'
        RIGHT OUTER JOIN (  -- ensure all cmcp corridors and all modes are represented
            SELECT
                [cmcp_name]
                ,[mode]
            FROM (
                SELECT DISTINCT [cmcp_name] FROM [cmcp_2021].[cmcp_corridors] 
                WHERE [cmcp_name] NOT IN ('Central Mobility Hub and Connections')
                UNION ALL SELECT 'Region') AS [corridors]
            CROSS JOIN (
                SELECT DISTINCT
                    CASE WHEN [mode_aggregate_trip_description] IN ('School Bus',
                                                                    'Taxi',
                                                                    'Heavy Heavy Duty Truck',
                                                                    'Light Heavy Duty Truck',
                                                                    'Medium Heavy Duty Truck',
                                                                    'Not Applicable',
                                                                    'Parking Lot',
                                                                    'Pickup/Drop-off',
                                                                    'Rental car',
															        'TNC Shared',
															        'TNC Single',
                                                                    'Shuttle/Van/Courtesy Vehicle')
                    THEN 'Other' ELSE [mode_aggregate_trip_description] END AS [mode]
                FROM
                    [dimension].[mode_trip]) AS [modes]) AS [combos]
        ON
            [trips].[cmcp_name] = [combos].[cmcp_name]
            AND [trips].[mode_aggregate_description] = [combos].[mode]


	    -- insert result set into results table
		INSERT INTO [cmcp_2021].[results] (
			[scenario_id]
			,[cmcp_name]
			,[measure]
			,[metric]
			,[value]
			,[updated_by]
			,[updated_date])
        SELECT
	        @scenario_id AS [scenario_id]
		     ,[cmcp_name]
            ,@measure AS [measure]
	        ,CONCAT('Total Person Trips - ', [mode_aggregate_description]) AS [metric]
	        ,[trips].[person_trips]  AS [value]
            ,USER_NAME() AS [updated_by]
            ,SYSDATETIME() AS [updated_date]
        FROM
	        @aggregated_trips AS [trips]


    END

    -- if silent switch is selected then do not output a result set
    IF(@silent = 1)
        RETURN;
    ELSE
        -- return the result set
        SELECT
            [scenario_id]
		    ,[cmcp_name]
            ,[measure]
            ,[metric]
            ,[value]
            ,[updated_by]
            ,[updated_date]
        FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] = @measure;
END
GO

EXECUTE [db_meta].[add_xp] 'cmcp_2021.sp_mode_share', 'MS_Description', 'mode share by CMCP corridor'
GO


-- percentage of population with physical activity ---------------------------
DROP PROCEDURE IF EXISTS [cmcp_2021].[sp_physical_activity]
GO

CREATE PROCEDURE [cmcp_2021].[sp_physical_activity]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [cmcp_2021].[results] table instead of
        -- grabbing the results from the [cmcp_2021].[results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [cmcp_2021].[results] table is updated with no output
AS
/**	
summary:   >
    Percent of population with at least 20 minutes of transportation related physical activity

filters:   >
    None
**/
BEGIN
    SET NOCOUNT ON;

    DECLARE @measure nvarchar(100) = 'Percentage of Population With >= 20 Minutes of Physical Activity'

    -- if update switch is selected then run the measure and replace
    -- the value of the result set in the [cmcp_2021].[results] table
    IF(@update = 1)
    BEGIN
        -- remove measure result for the given ABM scenario from the results table
        DELETE FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] = @measure

	    -- create temporary table for Series 13 MGRAs to CMCP corridor xref
	    SELECT [mgra_13], [cmcp_name]
	    INTO [#mgra_cmcp_xref_all]
	    FROM [cmcp_2021].[fn_mgra_cmcp_xref]()

	    -- declare cursor to loop through cmcp corridor names
        DECLARE db_cursor CURSOR FOR 
	    SELECT DISTINCT [cmcp_name] FROM [cmcp_2021].[cmcp_corridors] 
	    WHERE [cmcp_name] NOT IN ('Central Mobility Hub and Connections')
	    UNION ALL SELECT 'Region'

        -- open cursor and loop through cmcp corridor names
        DECLARE @cmcp_name nvarchar (100)
	    OPEN db_cursor
	    FETCH NEXT FROM db_cursor INTO @cmcp_name 
	    WHILE @@FETCH_STATUS = 0  

        BEGIN
		     -- insert result set into results table
		    INSERT INTO [cmcp_2021].[results] (
			    [scenario_id]
			    ,[cmcp_name]
			    ,[measure]
			    ,[metric]
			    ,[value]
			    ,[updated_by]
			    ,[updated_date]) 
		    SELECT
			    @scenario_id
			    ,@cmcp_name
			    ,@measure
			    ,@measure		
			    ,1.0* SUM(CASE WHEN [person_activity].[activity] >= 20 THEN [weight_person] ELSE 0 END) /SUM([weight_person])  AS [value]
			    ,USER_NAME() AS [updated_by]
			    ,SYSDATETIME() AS [updated_date]
		    FROM 
			    [dimension].[person]
		    INNER JOIN 
			    [dimension].[household]
		    ON 
			    [person].[scenario_id] = [household].[scenario_id]
			    AND	[person].[household_id] = [household].[household_id]
		    JOIN 
			    [dimension].[geography]
		    ON 
			    [household].[geography_household_location_id] = [geography].[geography_id]		
		    LEFT OUTER JOIN
			    [#mgra_cmcp_xref_all]
		    ON 
			    [#mgra_cmcp_xref_all].[cmcp_name] = @cmcp_name
			    AND [geography].[mgra_13] = [#mgra_cmcp_xref_all].[mgra_13]
		    LEFT OUTER JOIN (
			    SELECT
				    [person_id]
				    ,SUM([time_walk] + [time_bike]) AS [activity]
			    FROM
				    [fact].[person_trip]
			    WHERE
				    [person_trip].[scenario_id] = @scenario_id
			    GROUP BY
				    [person_id]) AS [person_activity]
		    ON
			    [person].[scenario_id] = @scenario_id
			    AND [person].[person_id] = [person_activity].[person_id]
		    WHERE
			    [person].[scenario_id] = @scenario_id
			    AND [household].[scenario_id] = @scenario_id
			    AND ([#mgra_cmcp_xref_all].[mgra_13] IS NOT NULL OR @cmcp_name = 'Region')
			
		    FETCH NEXT FROM db_cursor INTO @cmcp_name
	    END 

	    CLOSE db_cursor  
	    DEALLOCATE db_cursor   

	    DROP TABLE [#mgra_cmcp_xref_all]

    END
	
    -- if silent switch is selected then do not output a result set
    IF(@silent = 1)
        RETURN;
    ELSE
        -- return the result set
        SELECT
            [scenario_id]
		    ,[cmcp_name]
            ,[measure]
            ,[metric]
            ,[value]
            ,[updated_by]
            ,[updated_date]
        FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] = @measure;
END
GO

EXECUTE [db_meta].[add_xp] 'cmcp_2021.sp_physical_activity', 'MS_Description', 'percentage of population with >= 20 minutes of physical activity by CMCP corridor'
GO


-- bicycle and pedestrian miles traveled by CMCP corridor --------------------
DROP PROCEDURE IF EXISTS [cmcp_2021].[sp_bmt_pmt]
GO

CREATE PROCEDURE [cmcp_2021].[sp_bmt_pmt]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]	
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [dbo].[cmcp_pm_results] table instead of
        -- grabbing the results from the [dbo].[cmcp_pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [dbo].[cmcp_pm_results] table is updated with no output
AS
/**	
summary:   >
    Bicycle and pedestrian miles travelled by CMCP corridor. Includes all
    models. Based on Federal 2020 RTP Performance Measures 3a/3b. Similar to
    [rtp_2015].[sp_pmt_bmt] in the 2015 RTP.

filters:   >
    None
**/
BEGIN
    SET NOCOUNT ON;

    DECLARE @measure nvarchar(100) = 'Bicycle and Pedestrian Miles Traveled'

    -- if update switch is selected then run the measure and replace
    -- the value of the result set in the [cmcp_2021].[results] table
    IF(@update = 1)
    BEGIN
        -- remove measure result for the given ABM scenario from the results table
        DELETE FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] = @measure

	    -- create temporary table for Series 13 MGRAs to CMCP corridor xref
	    SELECT [mgra_13], [cmcp_name]
	    INTO [#mgra_cmcp_xref_all]
	    FROM [cmcp_2021].[fn_mgra_cmcp_xref]()

	    -- declare cursor to loop through cmcp corridor names
        DECLARE db_cursor CURSOR FOR 
	    SELECT DISTINCT [cmcp_name] FROM [cmcp_2021].[cmcp_corridors] 
	    WHERE [cmcp_name] NOT IN ('Central Mobility Hub and Connections')
	    UNION ALL SELECT 'Region'

        -- open cursor and loop through cmcp corridor names
        DECLARE @cmcp_name nvarchar (100)
	    OPEN db_cursor
	    FETCH NEXT FROM db_cursor INTO @cmcp_name 
	    WHILE @@FETCH_STATUS = 0  

        BEGIN
		     -- insert Biycle Miles Traveled into results table
		    INSERT INTO [cmcp_2021].[results] (
			    [scenario_id]
			    ,[cmcp_name]
			    ,[measure]
			    ,[metric]
			    ,[value]
			    ,[updated_by]
			    ,[updated_date]) 
		    SELECT
			    @scenario_id AS [scenario_id]
			    ,@cmcp_name AS [cmcp_name]
			    ,@measure AS [measure]
			    ,'Bicycle Miles Traveled' AS metric	
			    ,SUM([weight_person_trip] * [dist_bike]) AS [value]		
			    ,USER_NAME() AS [updated_by]
			    ,SYSDATETIME() AS [updated_date]
		    FROM
			    [fact].[person_trip]
		    INNER JOIN 
			    [dimension].[geography_trip_origin]
		    ON
			    [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
		    INNER JOIN 
			    [dimension].[geography_trip_destination]
		    ON
			    [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]
		    LEFT OUTER JOIN
			    [#mgra_cmcp_xref_all] AS [origin_xref]
		    ON
			    [origin_xref].[mgra_13] = [geography_trip_origin].trip_origin_mgra_13
		    LEFT OUTER JOIN
			    [#mgra_cmcp_xref_all] AS [destination_xref]
		    ON
			    [destination_xref].[mgra_13] = [geography_trip_destination].trip_destination_mgra_13
		    WHERE
			    [person_trip].[scenario_id] = @scenario_id
			    AND ([origin_xref].[mgra_13] IS NOT NULL OR [destination_xref].[mgra_13] IS NOT NULL OR @cmcp_name = 'Region')			
		

		    -- insert Pedestrian Miles Traveled into results table
		    INSERT INTO [cmcp_2021].[results] (
			    [scenario_id]
			    ,[cmcp_name]
			    ,[measure]
			    ,[metric]
			    ,[value]
			    ,[updated_by]
			    ,[updated_date]) 
		    SELECT
			    @scenario_id AS [scenario_id]
			    ,@cmcp_name AS [cmcp_name]
			    ,@measure AS [measure]
			    ,'Pedestrian Miles Traveled' AS [metric]
			    ,SUM([weight_person_trip] * [dist_walk]) AS [value]    
			    ,USER_NAME() AS [updated_by]
			    ,SYSDATETIME() AS [updated_date]
		    FROM
			    [fact].[person_trip]
		    INNER JOIN 
			    [dimension].[geography_trip_origin]
		    ON
			    [person_trip].[geography_trip_origin_id] = [geography_trip_origin].[geography_trip_origin_id]
		    INNER JOIN 
			    [dimension].[geography_trip_destination]
		    ON
			    [person_trip].[geography_trip_destination_id] = [geography_trip_destination].[geography_trip_destination_id]    
		    LEFT OUTER JOIN
			    [#mgra_cmcp_xref_all] AS [origin_xref]
		    ON
			    [origin_xref].[mgra_13] = [geography_trip_origin].[trip_origin_mgra_13]
		    LEFT OUTER JOIN
			    [#mgra_cmcp_xref_all] AS [destination_xref]
		    ON
			    [destination_xref].[mgra_13] = [geography_trip_destination].[trip_destination_mgra_13]
		    WHERE
			    [person_trip].[scenario_id] = @scenario_id
			    AND ([origin_xref].[mgra_13] IS NOT NULL OR [destination_xref].[mgra_13] IS NOT NULL OR @cmcp_name = 'Region')

		    FETCH NEXT FROM db_cursor INTO @cmcp_name

	    END 

	    CLOSE db_cursor  
	    DEALLOCATE db_cursor   

	    DROP TABLE [#mgra_cmcp_xref_all]

    END
	
    -- if silent switch is selected then do not output a result set
    IF(@silent = 1)
        RETURN;
    ELSE
        -- return the result set
        SELECT
            [scenario_id]
		    ,[cmcp_name]
            ,[measure]
            ,[metric]
            ,[value]
            ,[updated_by]
            ,[updated_date]
        FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] = @measure;
END
GO

EXECUTE [db_meta].[add_xp] 'cmcp_2021.sp_bmt_pmt', 'MS_Description', 'bicycle and pedestrian miles travelled by CMCP corridor'
GO


-- resident VMT --------------------------------------------------------------
DROP PROCEDURE IF EXISTS [cmcp_2021].[sp_resident_vmt]
GO

CREATE PROCEDURE [cmcp_2021].[sp_resident_vmt]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]	
	@workers bit,   -- select workers only, includes telecommuters
    @home_location bit,  -- assign activity to home location
	@work_location bit,  -- assign activity to workplace location, includes telecommuters
    @update bit,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [cmcp_2021].[results] table instead of
        -- grabbing the results from the [cmcp_2021].[results] table
    @silent bit  -- 1/0 switch to suppress result set output so only the
        -- [cmcp_2021].[results] table is updated with no output
AS


/**
summary:   >
    San Diego resident vehicle miles traveled (VMT) per capita for CMCP
    corridors. VMT is assigned to either the resident's home or work
    location. Optional filter to select workers only.

filters:   >
    [model_trip].[model_trip_description] IN ('Individual', 'Internal-External','Joint')
        ABM resident sub-models
    [person].[work_segment] != 'Not Applicable'
        if @workers parameter is specified, select only worker
**/
BEGIN
    SET NOCOUNT ON;

    -- ensure only one of indicator to activity assignment is chose
    IF CONVERT(int, @home_location) + CONVERT(int, @work_location) > 1 OR
       CONVERT(int, @home_location) + CONVERT(int, @work_location) = 0
    BEGIN
        RAISERROR ('Select to assign activity to either home or work location.', 16, 1)
    END

    -- if activity assigned to work location then workers only filter must be selected
    IF CONVERT(int, @workers) = 0 AND CONVERT(int, @work_location) >= 1
    BEGIN
        RAISERROR ('Assigning activity to work location requires selection of workers only filter.', 16, 1)
    END

    -- create name of the measure based on options selected
    DECLARE @measure nvarchar(100)
    IF CONVERT(int, @workers) = 1 SET @measure = 'VMT per Employee'
    IF CONVERT(int, @workers) = 0  AND CONVERT(int, @home_location) = 1 SET @measure = 'VMT per Capita'

    -- if update switch is selected then run the measure and replace
    -- the value of the result set in the [cmcp_2021].[results] table
    IF(@update = 1)
    BEGIN
        -- remove measure result for the given ABM scenario from the results table
        DELETE FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] = @measure

	    -- create temporary table for Series 13 MGRAs to CMCP corridor xref
	    SELECT [mgra_13], [cmcp_name]
	    INTO [#mgra_cmcp_xref_all]
	    FROM [cmcp_2021].[fn_mgra_cmcp_xref]()

        -- insert result set to the results table
        INSERT INTO [cmcp_2021].[results] (
			[scenario_id]
			,[cmcp_name]
			,[measure]
			,[metric]
			,[value]
			,[updated_by]
			,[updated_date]) 
		SELECT
			@scenario_id AS [scenario_id]
			,CASE WHEN [persons].[cmcp_name] IS NULL THEN [cmcp_names].[cmcp_name]
				  ELSE [persons].[cmcp_name] END AS [cmcp_name]
			,@measure AS [measure]
			,CASE WHEN @workers = 0 AND @home_location = 1 THEN 'All Residents - Activity Assigned to Home Location'
                  WHEN @workers = 0 AND @work_location = 1 THEN 'All Residents - Activity Assigned to Workplace Location'
				  WHEN @workers = 1 THEN 'Workers Only - Activity Assigned to Workplace Location'
				  ELSE NULL END AS [metric]
			,ROUND(ISNULL(ISNULL([trips].[vmt], 0) / NULLIF([persons].[persons], 0), 0), 2) AS [value]
			,USER_NAME() AS [updated_by]
			,SYSDATETIME() AS [updated_date]
		FROM ( -- get total population within assigned activity location
			SELECT
				-- have to designate between Rollup "Region" total and "Non-CMCP" NULL values
				ISNULL(CASE WHEN @home_location = 1 THEN (CASE WHEN [household_cmcp].[cmcp_name] IS NULL THEN 'Non-CMCP' ELSE [household_cmcp].[cmcp_name] END)
							WHEN @work_location = 1 THEN (CASE WHEN [work_cmcp].[cmcp_name] IS NULL THEN 'Non-CMCP' ELSE [work_cmcp].[cmcp_name] END)
							ELSE NULL END, 'Region') AS [cmcp_name]
				,SUM([person].[weight_person]) AS [persons]
			FROM
				[dimension].[person]
			INNER JOIN
				[dimension].[household]
			ON
				[person].[scenario_id] = [household].[scenario_id]
				AND [person].[household_id] = [household].[household_id]
			INNER JOIN
				[dimension].[geography_household_location]
			ON
				[household].[geography_household_location_id] = [geography_household_location].[geography_household_location_id]
			LEFT OUTER JOIN  -- keep Non-CMCP areas
				[#mgra_cmcp_xref_all] AS [household_cmcp]
			ON
				[geography_household_location].[household_location_mgra_13] = [household_cmcp].[mgra_13]
			INNER JOIN
				[dimension].[geography_work_location]
			ON
				[person].[geography_work_location_id] = [geography_work_location].[geography_work_location_id]
			LEFT OUTER JOIN  -- keep Non-CMCP areas
				[#mgra_cmcp_xref_all] AS [work_cmcp]
			ON
				[geography_work_location].[work_location_mgra_13] = [work_cmcp].[mgra_13]
			WHERE
				[person].[scenario_id] = @scenario_id
				AND [household].[scenario_id] = @scenario_id
				AND [person].[weight_person] > 0
				-- exclude non-workers if worker filter is selected
				AND  (@workers = 0 OR (@workers = 1 AND [person].[work_segment] != 'Non-Worker'))				
			GROUP BY
				-- have to designate between Rollup "Region" total and "Non-CMCP" NULL values
				CASE WHEN @home_location = 1 THEN (CASE WHEN [household_cmcp].[cmcp_name] IS NULL THEN 'Non-CMCP' ELSE [household_cmcp].[cmcp_name] END)
					 WHEN @work_location = 1 THEN (CASE WHEN [work_cmcp].[cmcp_name] IS NULL THEN 'Non-CMCP' ELSE [work_cmcp].[cmcp_name] END)
					 ELSE NULL END
			WITH ROLLUP) AS [persons]
		LEFT OUTER JOIN ( -- get trips and vmt for each person and assign to activity location
			-- left join keeps zones with residents/employees even if 0 trips/vmt
			SELECT
				-- have to designate between Rollup "Region" total and "Non-CMCP" NULL values
				ISNULL(CASE WHEN @home_location = 1 THEN (CASE WHEN [household_cmcp].[cmcp_name] IS NULL THEN 'Non-CMCP' ELSE [household_cmcp].[cmcp_name] END)
							WHEN @work_location = 1 THEN (CASE WHEN [work_cmcp].[cmcp_name] IS NULL THEN 'Non-CMCP' ELSE [work_cmcp].[cmcp_name] END)
							ELSE NULL END, 'Region') AS [cmcp_name]
				,SUM([person_trip].[weight_trip]) AS [trips]
				,SUM([person_trip].[weight_person_trip]) AS [person_trips]
				,SUM([person_trip].[weight_trip] * [person_trip].[dist_drive]) AS [vmt]
				,SUM([person_trip].[weight_person_trip] * [person_trip].[dist_total]) AS [pmt]
			FROM
				[fact].[person_trip]
			INNER JOIN
				[dimension].[model_trip]
			ON
				[person_trip].[model_trip_id] = [model_trip].[model_trip_id]
			INNER JOIN
				[dimension].[household]
			ON
				[person_trip].[scenario_id] = [household].[scenario_id]
				AND [person_trip].[household_id] = [household].[household_id]
			INNER JOIN
				[dimension].[person]
			ON
				[person_trip].[scenario_id] = [person].[scenario_id]
				AND [person_trip].[person_id] = [person].[person_id]
			INNER JOIN
				[dimension].[geography_household_location]
			ON
				[household].[geography_household_location_id] = [geography_household_location].[geography_household_location_id]
			LEFT OUTER JOIN  -- keep Non-CMCP areas
				[#mgra_cmcp_xref_all] AS [household_cmcp]
			ON
				[geography_household_location].[household_location_mgra_13] = [household_cmcp].[mgra_13]
			INNER JOIN
				[dimension].[geography_work_location]
			ON
				[person].[geography_work_location_id] = [geography_work_location].[geography_work_location_id]
			LEFT OUTER JOIN  -- keep Non-CMCP areas
				[#mgra_cmcp_xref_all] AS [work_cmcp]
			ON
				[geography_work_location].[work_location_mgra_13] = [work_cmcp].[mgra_13]
			WHERE
				[person_trip].[scenario_id] = @scenario_id
				AND [person].[scenario_id] =  @scenario_id
				AND [household].[scenario_id] = @scenario_id
				-- only resident models use synthetic population
			AND [model_trip].[model_trip_description] IN ('Individual',
															  'Internal-External',
															  'Joint')
				-- exclude non-workers if worker filter is selected
				AND (@workers = 0 OR (@workers = 1 AND [person].[work_segment] != 'Non-Worker'))
			GROUP BY
				-- have to designate between Rollup "Region" total and "Non-CMCP" NULL values
				CASE WHEN @home_location = 1 THEN (CASE WHEN [household_cmcp].[cmcp_name] IS NULL THEN 'Non-CMCP' ELSE [household_cmcp].[cmcp_name] END)
					 WHEN @work_location = 1 THEN (CASE WHEN [work_cmcp].[cmcp_name] IS NULL THEN 'Non-CMCP' ELSE [work_cmcp].[cmcp_name] END)
					 ELSE NULL END
			WITH ROLLUP) AS [trips]
		ON
			[persons].[cmcp_name] = [trips].[cmcp_name]
		-- want all geography zones represented regardless of 0-activity
		FULL OUTER JOIN  ( -- make full outer join to keep "Region" and "Non-CMCP" records
			SELECT DISTINCT 
				[cmcp_name]
			FROM
				[cmcp_2021].[cmcp_corridors]) AS [cmcp_names]
		ON
			[persons].[cmcp_name] = [cmcp_names].[cmcp_name]
		OPTION (MAXDOP 1)	

		DROP TABLE [#mgra_cmcp_xref_all]

    END

    -- if silent switch is selected then do not output a result set
    IF(@silent = 1)
        RETURN;
    ELSE
        -- return the result set
        SELECT
            [scenario_id]
		    ,[cmcp_name]
            ,[measure]
            ,[metric]
            ,[value]
            ,[updated_by]
            ,[updated_date]
        FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] = @measure;
END
GO

EXECUTE [db_meta].[add_xp] 'cmcp_2021.sp_resident_vmt', 'MS_Description', 'San Diego resident VMT per capita by CMCP corridor'
GO


-- total vehicle hour delay (vhd) by cmcp corridor ---------------------------
DROP PROCEDURE IF EXISTS [cmcp_2021].[sp_vhd]
GO

CREATE PROCEDURE [cmcp_2021].[sp_vhd]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
    @update bit = 1,  -- 1/0 switch to actually run the ABM performance
        -- measure and update the [dbo].[cmcp_pm_results] table instead of
        -- grabbing the results from the [dbo].[cmcp_pm_results] table
    @silent bit = 0  -- 1/0 switch to suppress result set output so only the
        -- [dbo].[cmcp_pm_results] table is updated with no output
AS
/**
summary:   >
    Vehicle hours of delay (VHD) by CMCP Corridor
	

filters:   >
**/
BEGIN
    SET NOCOUNT ON;
    DECLARE @measure nvarchar(100) = 'Daily Vehicle Hours of Delay'

    -- if update switch is selected then run the performance measure and replace
    -- the value of the result set in the [results] table
    IF(@update = 1)
    BEGIN
        -- remove measure result for the given ABM scenario from the results table
        DELETE FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] = @measure

        -- create temporary table for ABM scenario highway network
        -- to CMCP corridor xref
	    SELECT [hwy_link_id], [cmcp_name]
	    INTO [#hwy_cmcp_xref_all]
	    FROM [cmcp_2021].[fn_hwy_cmcp_xref](@scenario_id) 

	    -- declare cursor to loop through cmcp corridor names
        DECLARE db_cursor CURSOR FOR 
	    SELECT DISTINCT [cmcp_name] FROM [cmcp_2021].[cmcp_corridors] 
	    WHERE [cmcp_name] NOT IN ('Central Mobility Hub and Connections')
	    UNION ALL SELECT 'Region'

        -- open cursor and loop through cmcp corridor names
        DECLARE @cmcp_name nvarchar (100)
	    OPEN db_cursor
	    FETCH NEXT FROM db_cursor INTO @cmcp_name 
	    WHILE @@FETCH_STATUS = 0  

        BEGIN 
		     -- insert result set into results table
		    INSERT INTO [cmcp_2021].[results] (
			    [scenario_id]
			    ,[cmcp_name]
			    ,[measure]
			    ,[metric]
			    ,[value]
			    ,[updated_by]
			    ,[updated_date]) 
            SELECT
			    @scenario_id AS [scenario_id]
			    ,@cmcp_name AS [cmcp_name] 
			    ,@measure AS [measure]
			    ,CONCAT(RTRIM([mode_description]), ' - ', [facility_type], ' - ', [metric]) AS [metric]
			    ,[value]
			    ,USER_NAME() AS [updated_by]
			    ,SYSDATETIME() AS [updated_date]
		    FROM (
				SELECT
					@cmcp_name AS [cmcp_name]
					,ISNULL(CASE WHEN [hwy_link].[ifc] = 1 THEN 'Highway (SHS)'  -- hardcoded ifc descriptions
							    	WHEN [hwy_link].[ifc] BETWEEN 2 AND 10 THEN 'Arterial'  -- hardcoded ifc descriptions
									ELSE NULL END, 'All Facility') AS [facility_type]					
					,ISNULL(CASE WHEN [mode_aggregate_description] IN ('Light Heavy Duty Truck', 'Medium Heavy Duty Truck', 'Heavy Heavy Duty Truck') 
									THEN 'Heavy duty truck'
									WHEN [mode_aggregate_description] IN	('Shared Ride 2', 'Shared Ride 3' )
									THEN 'Carpool'
									ELSE [mode_aggregate_description] END,'All vehicles') [mode_description]
					,SUM(IIF([hwy_flow].[time] < [hwy_link_ab_tod].[tm] + [hwy_link_ab_tod].[tx], 0  -- vhd always >= 0
								,[hwy_flow_mode].[flow]* ([hwy_flow].[time] - [hwy_link_ab_tod].[tm] - [hwy_link_ab_tod].[tx]) / 60.0)) AS [VHD]
					, SUM(CASE WHEN [abm_5_tod] IN ('2','4')  -- abm five time of day peak periods
                      THEN IIF([hwy_flow].[time] < [hwy_link_ab_tod].[tm] + [hwy_link_ab_tod].[tx], 0  -- vhd always >= 0
                               ,[hwy_flow_mode].[flow]* ([hwy_flow].[time] - [hwy_link_ab_tod].[tm] - [hwy_link_ab_tod].[tx]) / 60.0)
                      ELSE 0 END) AS [VHD - Peak Period]
          
				FROM
					[fact].[hwy_flow]
				INNER JOIN
				    [dimension].[hwy_link]
				ON
					[hwy_flow].[scenario_id] = [hwy_link].[scenario_id]
					AND [hwy_flow].[hwy_link_id] = [hwy_link].[hwy_link_id]
				INNER JOIN
					[dimension].[hwy_link_ab_tod]
				ON
					[hwy_flow].[scenario_id] = [hwy_link_ab_tod].[scenario_id]
					AND [hwy_flow].[hwy_link_ab_tod_id] = [hwy_link_ab_tod].[hwy_link_ab_tod_id]
				INNER JOIN
					[fact].[hwy_flow_mode]
				ON
					[hwy_link_ab_tod].[scenario_id] = [hwy_flow_mode].[scenario_id]
					AND [hwy_link_ab_tod].[hwy_link_ab_tod_id] = [hwy_flow_mode].[hwy_link_ab_tod_id]
				INNER JOIN
					[dimension].[time]
				ON
					[hwy_flow].[time_id] = [time].[time_id]
				INNER JOIN
					[dimension].[mode]
				ON
					[hwy_flow_mode].[mode_id] = [mode].[mode_id]
				LEFT OUTER JOIN 
					[#hwy_cmcp_xref_all] AS [xref]
				ON 
					[xref].[cmcp_name] = @cmcp_name
					AND [hwy_flow].hwy_link_id = xref.hwy_link_id	
				WHERE
					[hwy_flow].[scenario_id] = @scenario_id
					AND [hwy_link].[scenario_id] = @scenario_id
					AND [hwy_link_ab_tod].[scenario_id] = @scenario_id
					AND [hwy_flow_mode].[scenario_id] = @scenario_id				
					AND ([xref].[cmcp_name] = @cmcp_name OR @cmcp_name ='Region')
				GROUP BY CUBE (					 
					CASE WHEN [hwy_link].[ifc] = 1 THEN 'Highway (SHS)'  -- hardcoded ifc descriptions
							WHEN [hwy_link].[ifc] BETWEEN 2 AND 10 THEN 'Arterial'  -- hardcoded ifc descriptions
							ELSE NULL END
					,CASE WHEN [mode_aggregate_description] IN ('Light Heavy Duty Truck', 'Medium Heavy Duty Truck', 'Heavy Heavy Duty Truck') 
							THEN 'Heavy duty truck'
							WHEN [mode_aggregate_description] IN	('Shared Ride 2', 'Shared Ride 3' )
							THEN 'Carpool'
							ELSE [mode_aggregate_description] END
					) ) AS [p]
			 UNPIVOT
				(value FOR metric IN ([VHD], [VHD - Peak Period])) AS [un_p]
                
		    FETCH NEXT FROM db_cursor INTO @cmcp_name
	    END 

	    CLOSE db_cursor  
	    DEALLOCATE db_cursor   

	    DROP TABLE [#hwy_cmcp_xref_all]
    END
	
    -- if silent switch is selected then do not output a result set
    IF(@silent = 1)
        RETURN;
    ELSE
        -- return the result set
        SELECT
            [scenario_id]
		    ,[cmcp_name]
            ,[measure]
            ,[metric]
            ,[value]
            ,[updated_by]
            ,[updated_date]
        FROM
            [cmcp_2021].[results]
        WHERE
            [scenario_id] = @scenario_id
            AND [measure] =@measure
END
GO

EXECUTE [db_meta].[add_xp] 'cmcp_2021.sp_vhd', 'MS_Description', 'vehicle hours of delay (vhd) by CMCP corridor'
GO


-- define [cmcp_2021] schema permissions -----------------------------------------
-- drop [cmcp_2021] role if it exists
DECLARE @RoleName sysname
set @RoleName = N'cmcp_2021_user'

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

    DROP ROLE [cmcp_2021_user]
END
GO
-- create user role for [cmcp_2021] schema
CREATE ROLE [cmcp_2021_user] AUTHORIZATION dbo;
-- allow all users to select, view definitions
-- and execute [cmcp_2021] stored procedures
GRANT EXECUTE ON SCHEMA :: [cmcp_2021] TO [cmcp_2021_user];
GRANT SELECT ON SCHEMA :: [cmcp_2021] TO [cmcp_2021_user];
GRANT VIEW DEFINITION ON SCHEMA :: [cmcp_2021] TO [cmcp_2021_user];
-- deny insert and update on [cmcp_2021].[results] so user can only
-- add new information via stored procedures, allow deletes
GRANT DELETE ON [cmcp_2021].[results] TO [cmcp_2021_user];
DENY INSERT ON [cmcp_2021].[results] TO [cmcp_2021_user];
DENY UPDATE ON [cmcp_2021].[results] TO [cmcp_2021_user];
