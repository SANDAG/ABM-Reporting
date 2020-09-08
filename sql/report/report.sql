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