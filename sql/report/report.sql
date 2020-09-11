SET NOCOUNT ON;
GO


-- create [report] schema ----------------------------------------------------
-- note that [report] schema permissions are defined at end of file
IF NOT EXISTS (
    SELECT TOP 1
        [schema_name]
    FROM
        [information_schema].[schemata]
    WHERE
        [schema_name] = 'report'
)
EXEC ('CREATE SCHEMA [report]')
GO

-- add metadata for [report] schema
IF EXISTS(
    SELECT TOP 1
        [FullObjectName]
    FROM
        [db_meta].[data_dictionary]
    WHERE
        [ObjectType] = 'SCHEMA'
        AND [FullObjectName] = '[report]'
        AND [PropertyName] = 'MS_Description'
)
BEGIN
    EXECUTE [db_meta].[drop_xp] 'report', 'MS_Description'
    EXECUTE [db_meta].[add_xp] 'report', 'MS_Description', 'schema to hold objects associated with core reporting outputs of the abm model'
END
GO




-- create function to assign tour mode ---------------------------------------
-- to all resident ABM sub-model tours inbound/outbound directions
-- based on SANDAG tour mode hierarchy
DROP FUNCTION IF EXISTS [report].[fn_resident_tourjourney_mode]
GO

CREATE FUNCTION [report].[fn_resident_tourjourney_mode]
(
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
)
RETURNS TABLE
AS
RETURN
/**
summary:   >
    Calculate aggregate mode for San Diego Resident ABM sub-models
	(Individiual, Internal-External, Joint) tour journey
	(tour and inbound/outbound direction) according to the SANDAG determined
	hierarchy.
    For a unique tour journey ([tour_id], [inbound_id]):
	If transit is a mode on any trip in the journey then use transit as the
	mode. If transit is not present then use the mode with the longest
	distance on the journey. If there are any ties then apply a hierarchy
	(super-walk > walk > bike > sr3 > sr2 > sov > tnc > taxi > school bus).
	Returns table of unique tour journeys ([tour_id], [inbound_id]) for
	all San Diego Resident ABM sub-model non-NULL tours
    ([tour_id] != 0, [tour].[weight_tour] > 0, [tour].[weight_person_tour] > 0)
    for a given [scenario_id] with the calculated SANDAG aggregate tour
    journey mode.

revisions:
    - None
**/
    with [tour_distances] AS (
    	-- create table of total tour distances
	    -- segmented by inbound/outbound direction and mode
	    -- returns a list of unique ([tour_id], [inbound_id], [mode_aggregate_trip_description])
	    -- with the summation of total distance within each 3-tuple
	    SELECT
		    [person_trip].[tour_id]
		    ,[person_trip].[inbound_id]
		    ,[mode_trip].[mode_aggregate_trip_description]
		    ,SUM([distance_total]) AS [distance_total]
	    FROM
		    [fact].[person_trip]
	    INNER JOIN
		    [dimension].[mode_trip]
	    ON
		    [person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
	    INNER JOIN
		    [dimension].[model_trip]
	    ON
		    [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
	    INNER JOIN
		    [dimension].[tour]
	    ON
		    [person_trip].[scenario_id] = [tour].[scenario_id]
		    AND [person_trip].[tour_id] = [tour].[tour_id]
	    WHERE
		    [person_trip].[scenario_id] = @scenario_id
		    -- remove NULL tours aka trip records not associated with tours
		    AND [tour].[tour_id] > 0
            -- San Diego Resident models only
		    AND [model_trip].[model_trip_description] IN ('Individual',
													      'Internal-External',
													      'Joint')
	    GROUP BY
		    [person_trip].[scenario_id]
		    ,[person_trip].[tour_id]
		    ,[person_trip].[inbound_id]
		    ,[mode_trip].[mode_aggregate_trip_description]),
	-- using aggregated tour distances list
	-- segmented by inbound/outbound direction
	-- if transit is present at any point in the tour then use transit as the mode
	-- if transit is not present use the longest distance mode
	-- if there is a tie, then super-walk > walk > bike > sr3 > sr2 > sov > tnc > taxi > school bus
	-- return final tour list with the calculated tour mode
	-- unique by ([tour_id], [inbound_id])
	[tiebreakers] AS (
		SELECT
			[tour_id]
			,[inbound_id]
			,MAX([transit_tour]) AS [transit_tour]
            ,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Super-Walk'
							THEN 1 ELSE 0 END) AS [tiebreaker_sw]
			,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Walk'
							THEN 1 ELSE 0 END) AS [tiebreaker_walk]
			,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Bike'
							THEN 1 ELSE 0 END) AS [tiebreaker_bike]
			,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Shared Ride 3+'
							THEN 1 ELSE 0 END) AS [tiebreaker_sr3]
			,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Shared Ride 2'
							THEN 1 ELSE 0 END) AS [tiebreaker_sr2]
			,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Drive Alone'
							THEN 1 ELSE 0 END) AS [tiebreaker_da]
            ,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Pooled TNC'
							THEN 1 ELSE 0 END) AS [tiebreaker_tnc_p]
            ,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Non-Pooled TNC'
							THEN 1 ELSE 0 END) AS [tiebreaker_tnc_np]
			,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Taxi'
							THEN 1 ELSE 0 END) AS [tiebreaker_taxi]
			,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'School Bus'
							THEN 1 ELSE 0 END) AS [tiebreaker_sb]
		FROM (
			-- create aggregated tour distances from tour distances list
			-- identify tours where transit is present
			-- and get the mode of the record with the largest tour distance
			-- segmented by inbound/outbound direction
			-- takes list of unique ([tour_id], [inbound_id], [mode_aggregate_trip_description])
			-- and returns the records with the longest distances within the 3-tuple
			-- this in not unique within ([tour_id], [inbound_id]) as there can be ties
			SELECT
				[tour_distances].[tour_id]
				,[tour_distances].[inbound_id]
				,[tour_distances].[mode_aggregate_trip_description]
				,[tt].[transit_tour]
			FROM
				[tour_distances]
			INNER JOIN (
				SELECT
					[tour_id]
					,[inbound_id]
					,MAX(CASE	WHEN [mode_aggregate_trip_description] = 'Transit'
								THEN 1 ELSE 0 END) AS [transit_tour]
					,MAX([distance_total]) AS [longest_distance]
				FROM
					[tour_distances]
				GROUP BY
					[tour_id]
					,[inbound_id]) AS [tt]
			ON
				[tour_distances].[tour_id] = [tt].[tour_id]
				AND [tour_distances].[inbound_id] = [tt].[inbound_id]
				AND [tour_distances].[distance_total] = [tt].[longest_distance]
			) AS [agg_tour_distances]
		GROUP BY
			[tour_id]
			,[inbound_id])
	SELECT
		@scenario_id AS [scenario_id]
		,[tour_id]
		,[inbound_id]
		,CASE	WHEN [transit_tour] = 1 THEN 'Transit'
                WHEN [tiebreaker_sw] = 1 THEN 'Super-Walk'
				WHEN [tiebreaker_walk] = 1 THEN 'Walk'
				WHEN [tiebreaker_bike] = 1 THEN 'Bike'
				WHEN [tiebreaker_sr3] = 1 THEN 'Shared Ride 3+'
				WHEN [tiebreaker_sr2] = 1 THEN 'Shared Ride 2'
				WHEN [tiebreaker_da] = 1 THEN 'Drive Alone'
                WHEN [tiebreaker_tnc_p] = 1 THEN 'Pooled TNC'
                WHEN [tiebreaker_tnc_np] = 1 THEN 'Non-Pooled TNC'
				WHEN [tiebreaker_taxi] = 1 THEN 'Taxi'
				WHEN [tiebreaker_sb] = 1 THEN 'School Bus'
				ELSE NULL END AS [mode_aggregate_description]
	FROM
		[tiebreakers]
GO

-- add metadata for [report].[fn_resident_tourjourney_mode]
EXECUTE [db_meta].[add_xp] 'report.fn_resident_tourjourney_mode', 'MS_Description', 'inline function returning list of all ABM San Diego Resident sub-model non-NULL unique tour journeys ([tour_id], [inbound_id]) with the calculated aggregate SANDAG tour mode appended.'
GO




-- create stored procedure for San Diego resident ----------------------------
-- trip mode share by home location
DROP PROCEDURE IF EXISTS [report].[sp_resident_homelocation_tripmode_share]
GO

CREATE PROCEDURE [report].[sp_resident_homelocation_tripmode_share]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@geography_column nvarchar(max)  -- column in [dimension].[geography] table
    -- used to aggregate home location to user-specified geography resolution
AS
/**
summary:   >
    San Diego resident person trip and trip mode share of trips originating
    from the resident's home location at a user-determined geographic
    resolution. Note that the trip mode is simply the given ABM model
    trip mode.

filters:   >
    [model_trip].[model_trip_description] IN ('Individual', 'Internal-External','Joint')
        ABM resident sub-models
    [person_trip].[geography_trip_origin_id] = [household].[geography_household_location_id]
        limit trips to only those originating in the residents home location
        note that both the ABM resident sub-models and household location
        models operate at the same geography resolution so this condition
        is valid to use

revisions:
    - None
**/
BEGIN
	-- ensure the input geography column exists
	-- in the [dimension].[geography] table
	-- stop execution if it does not and throw error
	IF COL_LENGTH((SELECT [base_object_name] from sys.synonyms where name = 'geography'), @geography_column) IS NULL
	BEGIN
		RAISERROR ('The column %s does not exist in the [dimension].[geography] table.', 16, 1, @geography_column)
	END
	-- if it does exist then continue execution
	ELSE
	BEGIN
	    SET NOCOUNT ON;

	    -- build dynamic SQL string
	    DECLARE @sql nvarchar(max) = '
		    SELECT
			    ISNULL([geography].' + @geography_column + ', ''Exclude'') AS [geography]
			    ,ISNULL([mode_aggregate_trip_description], ''Total'') AS [mode_aggregate_trip_description]
			    ,SUM([person_trip].[weight_person_trip]) AS [person_trips]
                ,SUM([person_trip].[weight_trip]) AS [trips]
            INTO #aggregated_trips
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
			    [dimension].[household]
		    ON
			    [person_trip].[scenario_id] = [household].[scenario_id]
			    AND [person_trip].[household_id] = [household].[household_id]
                -- limit trips to only those originating in the residents home
                -- location, note that both the ABM resident sub-models and
                -- household location models operate at the same geography
                -- resolution so this condition is valid
			    AND [person_trip].[geography_trip_origin_id] = [household].[geography_household_location_id]
		    INNER JOIN
			    [dimension].[geography]
		    ON
			    [household].[geography_household_location_id] = [geography].[geography_id]
		    WHERE
			    [person_trip].[scenario_id] = ' + CONVERT(varchar, @scenario_id) + '
			    AND [household].[scenario_id] = ' + CONVERT(varchar,  @scenario_id) + '
			    AND [model_trip].[model_trip_description] IN (''Individual'',
														      ''Internal-External'',
														      ''Joint'') -- San Diego Resident Models
		    GROUP BY
			    [geography].' + @geography_column + '
			    ,[mode_aggregate_trip_description]
		    WITH ROLLUP;


        -- create dataset of unique combinations of home location, age categories,
        -- and modes to ensure 0-cells are included
        SELECT
            [geography]
            ,[mode_aggregate_trip_description]
        INTO #combinations
        FROM (
            SELECT DISTINCT
                [geography]
            FROM #aggregated_trips
            WHERE #aggregated_trips.[geography] != ''Exclude'') AS [geographies]
        CROSS JOIN (
            SELECT DISTINCT
                [mode_aggregate_trip_description]
            FROM #aggregated_trips) AS [modes];


	    -- create and output mode share percentages within each geography
	    SELECT
		    ' + CONVERT(varchar, @scenario_id) + ' AS [scenario_id]
		    ,#combinations.[geography]
		    ,#combinations.[mode_aggregate_trip_description]
		    ,100.0 * ISNULL(#aggregated_trips.[person_trips], 0) /
                [tbl_totals].[person_trips] AS [pct_person_trips]
		    ,ISNULL(#aggregated_trips.[person_trips], 0) AS [person_trips]
            ,100.0 * ISNULL(#aggregated_trips.[trips], 0) /
                [tbl_totals].[trips] AS [pct_trips]
		    ,ISNULL(#aggregated_trips.[trips], 0) AS [trips]
	    FROM
		    #aggregated_trips
        RIGHT OUTER JOIN
            #combinations
        ON
            #aggregated_trips.[geography] = #combinations.[geography]
            AND #aggregated_trips.[mode_aggregate_trip_description] = #combinations.[mode_aggregate_trip_description]
	    INNER JOIN (
		    SELECT
			    [geography]
			    ,[person_trips]
                ,[trips]
		    FROM
			    #aggregated_trips
		    WHERE
			    [mode_aggregate_trip_description] = ''Total'') AS [tbl_totals]
	    ON
		    #aggregated_trips.[geography] = [tbl_totals].[geography]
	    WHERE
		    #aggregated_trips.[geography] != ''Exclude''
        ORDER BY
            #combinations.[geography]
		    ,CASE   WHEN #combinations.[mode_aggregate_trip_description] = ''Total''
                    THEN ''ZZ''
                    ELSE #combinations.[mode_aggregate_trip_description]
                    END'

	    -- execute dynamic SQL string
	    EXECUTE (@sql)

	END
END
GO

-- add metadata for [report].[sp_resident_homelocation_tripmode_share]
EXECUTE [db_meta].[add_xp] 'report.sp_resident_homelocation_tripmode_share', 'MS_Description', 'San Diego resident person trip and trip mode share of trips originating from the resident''s home location'
GO




-- create stored procedure for San Diego resident ----------------------------
-- vehicle miles travelled
DROP PROCEDURE IF EXISTS [report].[sp_resident_vmt]
GO

CREATE PROCEDURE [report].[sp_resident_vmt]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@geography_column nvarchar(max),  -- column in [dimension].[geography]
    -- table used to aggregate activity location to user-specified geography
    -- resolution
	@workers bit = 0,  -- select workers only, includes telecommuters
	@home_location bit = 0,  -- assign activity to home location
    -- assign activity to workplace location, includes telecommuters
	@work_location bit = 0
AS

/**
summary:   >
    San Diego resident person trip and trip mode share of trips originating
    from the resident's home location at a user-determined geographic
    resolution. Note that the trip mode is simply the given ABM model
    trip mode.

filters:   >
    [model_trip].[model_trip_description] IN ('Individual', 'Internal-External','Joint')
        ABM resident sub-models
    [person_trip].[geography_trip_origin_id] = [household].[geography_household_location_id]
        limit trips to only those originating in the residents home location
        note that both the ABM resident sub-models and household location
        models operate at the same geography resolution so this condition
        is valid to use

revisions:
    - None
**/

BEGIN
	-- ensure the input geography column exists
	-- in the [dimension].[geography] table
	-- stop execution if it does not and throw error
	IF COL_LENGTH((SELECT [base_object_name] from sys.synonyms where name = 'geography'), @geography_column) IS NULL
	BEGIN
		RAISERROR ('The column %s does not exist in the [dimension].[geography] table.', 16, 1, @geography_column)
	END
	-- if it does exist then continue execution
	ELSE
	BEGIN
	    SET NOCOUNT ON;

	    -- ensure only one of indicator to assign activity to home or work location
	    -- is selected
	    IF CONVERT(int, @home_location) + CONVERT(int, @work_location) > 1
	    BEGIN
	    RAISERROR ('Select to assign activity to either home or work location.', 16, 1)
	    END

	    -- if activity is assigned to work location then the workers
	    -- only filter must be selected
	    IF CONVERT(int, @workers) = 0 AND CONVERT(int, @work_location) >= 1
	    BEGIN
	    RAISERROR ('Assigning activity to work location requires selection of workers only filter.', 16, 1)
	    END


	    -- if all input parameters are valid execute the stored procedure
	    -- build dynamic SQL string
	    -- note the use of nvarchar(max) throughout to avoid implicit conversion to varchar(8000)
	    DECLARE @sql nvarchar(max) = '
	    SELECT
		    ' + CONVERT(nvarchar(max), @scenario_id) + ' AS [scenario_id]
		    ,CASE	WHEN ' + CONVERT(nvarchar(max), @workers) + ' = 0
                    THEN ''All Residents''
				    WHEN ' + CONVERT(nvarchar(max), @workers) + ' = 1
                    THEN ''Workers Only''
				    ELSE NULL END AS [population]
		    ,CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1
                    THEN ''Activity Assigned to Home Location''
				    WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1
                    THEN ''Activity Assigned to Workplace Location''
				    ELSE NULL END AS [activity_location]
		    ,[persons].' + @geography_column + '
		    ,[persons].[persons]
		    ,ROUND(ISNULL([trips].[trips], 0), 2) AS [trips]
		    ,ROUND(ISNULL([trips].[trips], 0) /
                [persons].[persons], 2) AS [trips_per_capita]
		    ,ROUND(ISNULL([trips].[vmt], 0), 2) AS [vmt]
		    ,ROUND(ISNULL([trips].[vmt], 0) /
                [persons].[persons], 2) AS [vmt_per_capita]
	    FROM ( -- get total population within assigned activity location
		    SELECT DISTINCT -- distinct here when only total is wanted
            -- avoids duplicate Total column caused by ROLLUP
			    ISNULL(CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1
						    THEN [geography_household_location].household_location_' + @geography_column + '
						    WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1
						    THEN  [geography_work_location].work_location_' + @geography_column + '
						    ELSE NULL
						    END, ''Total'') AS ' + @geography_column + '
			    ,COUNT([person_id]) AS [persons]
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
		    INNER JOIN
			    [dimension].[geography_work_location]
		    ON
			    [person].[geography_work_location_id] = [geography_work_location].[geography_work_location_id]
		    WHERE
			    [person].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
			    AND [household].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
			    AND [person].[person_id] > 0  -- remove Not Applicable records
                -- exclude non-workers if worker filter is selected
			    AND (' + CONVERT(nvarchar(max), @workers) + ' = 0
                     OR (' + CONVERT(nvarchar(max), @workers) + ' = 1
                         AND [person].[work_segment] != ''Not Applicable''))
		    GROUP BY
			    CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1
					    THEN [geography_household_location].household_location_' + @geography_column + '
					    WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1
					    THEN  [geography_work_location].work_location_' + @geography_column + '
					    ELSE NULL END
		    WITH ROLLUP) AS [persons]
	    LEFT OUTER JOIN ( -- get trips and vmt for each person and assign to activity location
            -- left join keeps zones with residents/employees even if 0 trips/vmt
		    SELECT DISTINCT -- distinct here for case when only total is wanted
            -- avoids duplicate Total column caused by ROLLUP
			    ISNULL(CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1
						    THEN [geography_household_location].household_location_' + @geography_column + '
						    WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1
						    THEN  [geography_work_location].work_location_' + @geography_column + '
						    ELSE NULL
						    END, ''Total'') AS ' + @geography_column + '
			    ,SUM([person_trip].[weight_trip]) AS [trips]
			    ,SUM([person_trip].[weight_trip] * [person_trip].[distance_drive]) AS [vmt]
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
		    INNER JOIN
			    [dimension].[geography_work_location]
		    ON
			    [person].[geography_work_location_id] = [geography_work_location].[geography_work_location_id]
		    WHERE
			    [person_trip].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
			    AND [person].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
			    AND [household].[scenario_id] = ' + CONVERT(nvarchar(max), @scenario_id) + '
                -- only resident models use synthetic population
			    AND [model_trip].[model_trip_description] IN (''Individual'',
														      ''Internal-External'',
														      ''Joint'')
                -- exclude non-workers if worker filter is selected
			    AND (' + CONVERT(nvarchar(max), @workers) + ' = 0
                     OR (' + CONVERT(nvarchar(max), @workers) + ' = 1
                         AND [person].[work_segment] != ''Not Applicable''))
		    GROUP BY
			    CASE	WHEN ' + CONVERT(nvarchar(max), @home_location) + ' = 1
					    THEN [geography_household_location].household_location_' + @geography_column + '
					    WHEN ' + CONVERT(nvarchar(max), @work_location) + ' = 1
					    THEN  [geography_work_location].work_location_' + @geography_column + '
					    ELSE NULL END
		    WITH ROLLUP) AS [trips]
	    ON
		    [persons].' + @geography_column + ' = [trips].' + @geography_column + '
	    ORDER BY -- keep sort order of alphabetical with Total at bottom
		    CASE WHEN [persons].' + @geography_column + ' = ''Total'' THEN ''ZZ''
		    ELSE [persons].' + @geography_column + ' END ASC
		    OPTION(MAXDOP 1)'


	    -- execute dynamic SQL string
	    EXECUTE (@sql)
    END
END
GO

-- add metadata for [report].[sp_resident_vmt]
EXECUTE [db_meta].[add_xp] 'report.sp_resident_vmt', 'MS_Description', 'trips and vehicle miles travelled by residents and/or resident workers assigned to their home or workplace location'
GO




-- create stored procedure for resident worker tour journey mode share -------
DROP PROCEDURE IF EXISTS [report].[sp_residentworker_worklocation_tourjourneymode_share]
GO

CREATE PROCEDURE [report].[sp_residentworker_worklocation_tourjourneymode_share]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@geography_column nvarchar(max)  -- column in [dimension].[geography] table
    -- used to aggregate home location to user-specified geography resolution
AS
/**
summary:   >
    San Diego resident person trip mode share of work purpose trips where the
    mode is the SANDAG hierarchy tour journey mode. A tour journey is defined
    as the inbound/outbound leg of a tour. Activity is assigned to the
    destinating work purpose location (the work location) with the geographic
    resolution determined by the user. Tour journey mode is determined via the
    SANDAG tour journey mode hierarchy defined by
    [report].[fn_resident_tourjourney_mode].

filters:   >
    [model_trip].[model_trip_description] IN ('Individual', 'Internal-External','Joint')
        ABM resident sub-models
    [purpose_trip_destination].[purpose_trip_destination_description] = 'Work'
        work purpose trips only
    [tour].[tour_category] = ''Mandatory'
        mandatory tours only to filter out At-Work subtours with Work purpose

revisions:
    - None
**/
BEGIN
	-- ensure the input geography column exists
	-- in the [dimension].[geography] table
	-- stop execution if it does not and throw error
	IF COL_LENGTH((SELECT [base_object_name] from sys.synonyms where name = 'geography'), @geography_column) IS NULL
	BEGIN
		RAISERROR ('The column %s does not exist in the [dimension].[geography] table.', 16, 1, @geography_column)
	END
	-- if it does exist then continue execution
	ELSE
	BEGIN
	    SET NOCOUNT ON;

	    -- build dynamic SQL string
	    DECLARE @sql nvarchar(max) = '
        SELECT
	        ISNULL([geography].' + @geography_column + ', ''Exclude'') AS [geography]
	        ,ISNULL([mode_aggregate_description], ''Total'') AS [mode_aggregate_description]
	        ,SUM([person_trip].[weight_person_trip]) AS [person_trips]
            ,SUM([person_trip].[weight_trip]) AS [trips]
        INTO #aggregated_trips
        FROM
	        [fact].[person_trip]
        INNER JOIN
	        [dimension].[model_trip]
        ON
	        [person_trip].[model_trip_id] = [model_trip].[model_trip_id]
        INNER JOIN
	        [report].[fn_resident_tourjourney_mode](' + CONVERT(nvarchar, @scenario_id) + ')
        ON
	        [person_trip].[scenario_id] = [fn_resident_tourjourney_mode].[scenario_id]
	        AND [person_trip].[tour_id] = [fn_resident_tourjourney_mode].[tour_id]
            AND [person_trip].[inbound_id] = [fn_resident_tourjourney_mode].[inbound_id]
        INNER JOIN
	        [dimension].[purpose_trip_destination]
        ON
	        [person_trip].[purpose_trip_destination_id] = [purpose_trip_destination].[purpose_trip_destination_id]
        INNER JOIN
	        [dimension].[tour]
        ON
	        [person_trip].[scenario_id] = [tour].[scenario_id]
	        AND [person_trip].[tour_id] = [tour].[tour_id]
        INNER JOIN
	        [dimension].[geography]
        ON
	        [person_trip].[geography_trip_destination_id] = [geography].[geography_id]
        WHERE
	        [person_trip].[scenario_id] = ' + CONVERT(nvarchar, @scenario_id) + '
	        AND [tour].[scenario_id] = ' + CONVERT(nvarchar, @scenario_id) + '
            -- San Diego Resident Models
	        AND [model_trip].[model_trip_description] IN (''Individual'',
												          ''Internal-External'',
												          ''Joint'')
	        AND [purpose_trip_destination].[purpose_trip_destination_description] = ''Work''
            -- necessary to filter out At-Work subtour trips with Work trip purpose
	        AND [tour].[tour_category] = ''Mandatory''
        GROUP BY
	        [geography].' + @geography_column + '
	        ,[mode_aggregate_description]
        WITH ROLLUP
        OPTION (MAXDOP 1);


        -- create dataset of unique combinations of home location, age categories,
        -- and modes to ensure 0-cells are included
        SELECT
            [geography]
            ,[mode_aggregate_description]
        INTO #combinations
        FROM (
            SELECT DISTINCT
                [geography]
            FROM #aggregated_trips
            WHERE #aggregated_trips.[geography] != ''Exclude'') AS [geographies]
        CROSS JOIN (
            SELECT DISTINCT
                [mode_aggregate_description]
            FROM #aggregated_trips) AS [modes];


        -- create and output mode share percentages within each geography
        SELECT
	        ' + CONVERT(nvarchar, @scenario_id) + ' AS [scenario_id]
	        ,#combinations.[geography]
	        ,#combinations.[mode_aggregate_description]
	        ,ROUND(100.0 * ISNULL(#aggregated_trips.[person_trips], 0) /
                [tbl_totals].[person_trips], 2) AS [pct_person_trips]
	        ,ISNULL(#aggregated_trips.[person_trips], 0) AS [person_trips]
            ,100.0 * ISNULL(#aggregated_trips.[trips], 0) /
                [tbl_totals].[trips] AS [pct_trips]
	        ,ISNULL(#aggregated_trips.[trips], 0) AS [trips]
        FROM
	        #aggregated_trips
        RIGHT OUTER JOIN
            #combinations
        ON
            #aggregated_trips.[geography] = #combinations.[geography]
            AND #aggregated_trips.[mode_aggregate_description] = #combinations.[mode_aggregate_description]
        INNER JOIN (
	        SELECT
		        [geography]
		        ,[person_trips]
                ,[trips]
	        FROM
		        #aggregated_trips
	        WHERE
		        [mode_aggregate_description] = ''Total'') AS [tbl_totals]
        ON
	        #aggregated_trips.[geography] = [tbl_totals].[geography]
        WHERE
	        #aggregated_trips.[geography] != ''Exclude''
        ORDER BY
            #combinations.[geography]
            ,CASE   WHEN #combinations.[mode_aggregate_description] = ''Total''
                    THEN ''ZZ''
                    ELSE #combinations.[mode_aggregate_description]
                    END'

	    -- execute dynamic SQL string
	    EXECUTE (@sql)
	END
END
GO

-- add metadata for [report].[sp_residentworker_worklocation_tourjourneymode_share]
EXECUTE [db_meta].[add_xp] 'report.sp_residentworker_worklocation_tourjourneymode_share', 'MS_Description', 'San Diego resident person tour journey mode share of work purpose tour journeys'
GO




-- create stored procedure for ABM sub-model mode split ----------------------
DROP PROCEDURE IF EXISTS [report].[sp_submodel_tripmode_share]
GO

CREATE PROCEDURE [report].[sp_submodel_tripmode_share]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@model_list varchar(200)
    -- list of ABM sub-models to include delimited by commas
	-- example usage to get mode split for resident models:
	-- EXECUTE [report].[sp_mode_split] 1, 'Individual,Internal-External,Joint'
	-- see [dimension].[model_trip].[model_trip_description] for valid values
    -- note that no spaces should be included between commas
AS

/**
summary:   >
    Person trip and trip mode share for user-specified list of
    ABM sub-models. Note that the trip mode is simply the given ABM model
    trip mode.

filters:   >
    [model_trip].[model_trip_description] IN list of input ABM sub-models

revisions:
    - None
**/

    -- ensure the input @model_list parameter contains
    -- valid ABM sub-model descriptions
    IF EXISTS(
	    SELECT
		    [value]
	    FROM
		    STRING_SPLIT(@model_list, ',') AS [mode_list]
	    LEFT OUTER JOIN
		    [dimension].[model_trip]
	    ON
		    [mode_list].[value] = [model_trip].[model_trip_description]
	    WHERE
		    [model_trip].[model_trip_id] IS NULL)
    BEGIN
        RAISERROR ('Input value for ABM sub-model does not exist. Check the @model_list parameter.', 16, 1)
        RETURN -1
    END;

    SET NOCOUNT ON;

    -- get person trips and trips by mode
    DECLARE @aggregated_trips TABLE (
	    [mode_aggregate_trip_description] nvarchar(50) NOT NULL,
	    [person_trips] float NOT NULL,
	    [trips] float NOT NULL)
    INSERT INTO @aggregated_trips
    SELECT
	    ISNULL([mode_aggregate_trip_description], 'Total') AS [mode_aggregate_trip_description]
	    ,SUM([weight_person_trip]) AS [person_trips]
	    ,SUM([weight_trip]) AS [trips]
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
    WHERE
	    [scenario_id] = @scenario_id
	    AND [model_trip].[model_trip_description] IN (SELECT [value] FROM STRING_SPLIT(@model_list, ','))
    GROUP BY
	    [mode_aggregate_trip_description]
    WITH ROLLUP

    -- get total person trips and trips
    DECLARE @total_person_trips float = (
        SELECT
            [person_trips]
        FROM
            @aggregated_trips
        WHERE
            [mode_aggregate_trip_description] = 'Total'
    )

    DECLARE @total_trips float = (
        SELECT
            [trips]
        FROM
            @aggregated_trips
        WHERE
            [mode_aggregate_trip_description] = 'Total'
    )

    SELECT
	    @scenario_id AS [scenario_id]
	    ,[mode_aggregate_trip_description]
	    ,100.0 * [person_trips] / @total_person_trips AS [pct_person_trips]
	    ,[person_trips]
	    ,100.0 * [trips] / @total_trips AS [pct_trips]
	    ,[trips]
    FROM
	    @aggregated_trips

RETURN
GO

-- add metadata for [report].[sp_submodel_tripmode_share]
EXECUTE [db_meta].[add_xp] 'report.sp_submodel_tripmode_share', 'MS_Description', 'person trip and trip mode share for user-specified ABM sub-models'
GO




-- define [report] schema permissions -----------------------------------------
-- drop [report] role if it exists
DECLARE @RoleName sysname
set @RoleName = 'report_user'

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

    DROP ROLE [report_user]
END
GO
-- create user role for [report] schema
CREATE ROLE [report_user] AUTHORIZATION dbo;
-- allow all users to select, view definitions
-- and execute [report] stored procedures
GRANT EXECUTE ON SCHEMA :: [report] TO [report_user];
GRANT SELECT ON SCHEMA :: [report] TO [report_user];
GRANT VIEW DEFINITION ON SCHEMA :: [report] TO [report_user];
