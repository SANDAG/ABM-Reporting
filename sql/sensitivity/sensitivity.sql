SET NOCOUNT ON;
GO


-- create [sensitivity] schema ---------------------------------------------------
-- note that [sensitivity] schema permissions are defined at end of file
IF NOT EXISTS (
    SELECT TOP 1
        [schema_name]
    FROM
        [information_schema].[schemata] 
    WHERE
        [schema_name] = 'sensitivity'
)
EXEC ('CREATE SCHEMA [sensitivity]')
GO

-- add metadata for [sensitivity] schema
IF EXISTS(
    SELECT TOP 1
        [FullObjectName]
    FROM
        [db_meta].[data_dictionary]
    WHERE
        [ObjectType] = 'SCHEMA'
        AND [FullObjectName] = '[sensitivity]'
        AND [PropertyName] = 'MS_Description'
)
BEGIN
    EXECUTE [db_meta].[drop_xp] 'sensitivity', 'MS_Description'
    EXECUTE [db_meta].[add_xp] 'sensitivity', 'MS_Description', 'schema to hold all objects associated with the 2020 ABM2+ sensitivity tests'
END
GO




-- create stored procedure to calculate 
-- highway network ifc metrics of interest  ----------------------------------
DROP PROCEDURE IF EXISTS [sensitivity].[sp_ifc_metrics]
GO

CREATE PROCEDURE [sensitivity].[sp_ifc_metrics]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@metric nvarchar(10)  -- metric of interest to calculate 
AS
/**
summary:   >
     Calculate a highway network based metric of interest by highway link
     ifc. The stored procedure calculates either the VHD, VHT, or VMT.
revisions:
**/
SET NOCOUNT ON;
BEGIN
    -- check input parameters
    IF (@metric NOT IN ('vhd', 'vht', 'vmt') OR @metric IS NULL)
    BEGIN
        RAISERROR('Invalid parameter: @metric must be one of (''vhd'', ''vht'', ''vmt'')', 18, 0)
        RETURN
    END;


    -- create table containing all ifc of interest
    -- ensures all combinations are represented if not present the scenario
    with [combos] AS (
        SELECT
            [ifcOrderNo]
            ,[ifcDesc]
        FROM ( 
            VALUES
                (1, 'Freeway'),
                (2, 'Prime Arterial'),
                (3, 'Major Arterial'),
                (4, 'Collector'),
                (5, 'Local Collector'),
                (6, 'Rural Collector'),
                (7, 'Local Road'),
                (8, 'Freeway Connector Ramp'),
                (9, 'Local Ramp'),
                (10, 'Zone Connector')
            ) AS [ifcs] ([ifcOrderNo], [ifcDesc])),
    -- calculate given metric within each ifc and mode
    -- combine modes into aggregate (Auto, Truck, Bus) categories
    [networkData] AS (
        SELECT
            CASE    WHEN [hwy_link].[ifc] = 1 THEN 'Freeway'
                    WHEN [hwy_link].[ifc] = 2 THEN 'Prime Arterial'
                    WHEN [hwy_link].[ifc] = 3 THEN 'Major Arterial'
                    WHEN [hwy_link].[ifc] = 4 THEN'Collector'
                    WHEN [hwy_link].[ifc] = 5 THEN 'Local Collector'
                    WHEN [hwy_link].[ifc] = 6 THEN 'Rural Collector'
                    WHEN [hwy_link].[ifc] = 7 THEN 'Local Road'
                    WHEN [hwy_link].[ifc] = 8 THEN 'Freeway Connector Ramp'
                    WHEN [hwy_link].[ifc] = 9 THEN 'Local Ramp'
                    WHEN [hwy_link].[ifc] = 10 THEN 'Zone Connector'
                    ELSE NULL END AS [ifc_desc]
            ,SUM(CASE   WHEN @metric = 'vhd'
                        THEN [hwyFlowModeWide].[autoFlow] * ([hwy_flow].[time] - [hwy_link_ab_tod].[tm] - [hwy_link_ab_tod].[tx]) / 60.0
                        WHEN @metric = 'vht'
                        THEN [hwyFlowModeWide].[autoFlow] * [hwy_flow].[time] / 60.0
                        WHEN @metric = 'vmt'
                        THEN [hwyFlowModeWide].[autoFlow] * [hwy_link].[length_mile]
                        ELSE NULL END) AS [Auto]
            ,SUM(CASE   WHEN @metric = 'vhd'
                        THEN [hwyFlowModeWide].[truckFlow] * ([hwy_flow].[time] - [hwy_link_ab_tod].[tm] - [hwy_link_ab_tod].[tx]) / 60.0
                        WHEN @metric = 'vht'
                        THEN [hwyFlowModeWide].[truckFlow] * [hwy_flow].[time] / 60.0
                        WHEN @metric = 'vmt'
                        THEN [hwyFlowModeWide].[truckFlow] * [hwy_link].[length_mile]
                        ELSE NULL END) AS [Truck]
            ,SUM(CASE   WHEN @metric = 'vhd'
                        THEN [hwyFlowModeWide].[busFlow] * ([hwy_flow].[time] - [hwy_link_ab_tod].[tm] - [hwy_link_ab_tod].[tx]) / 60.0
                        WHEN @metric = 'vht'
                        THEN [hwyFlowModeWide].[busFlow] * [hwy_flow].[time] / 60.0
                        WHEN @metric = 'vmt'
                        THEN [hwyFlowModeWide].[busFlow] * [hwy_link].[length_mile]
                        ELSE NULL END) AS [Bus]
            ,SUM(CASE   WHEN @metric = 'vhd'
                        THEN [hwy_flow].[flow] * ([hwy_flow].[time] - [hwy_link_ab_tod].[tm] - [hwy_link_ab_tod].[tx]) / 60.0
                        WHEN @metric = 'vht'
                        THEN [hwy_flow].[flow] * [hwy_flow].[time] / 60.0
                        WHEN @metric = 'vmt'
                        THEN [hwy_flow].[flow] * [hwy_link].[length_mile]
                        ELSE NULL END) AS [Total]
        FROM
            [fact].[hwy_flow]
        INNER JOIN (  -- joining fact tables not recommended but done here
            SELECT
                @scenario_id AS [scenario_id]
                ,[hwy_link_ab_tod_id]
                ,SUM(CASE   WHEN [mode_aggregate_description] IN ('Drive Alone',
                                                                  'Shared Ride 2',
                                                                  'Shared Ride 3')
                            THEN [flow]
                            ELSE 0 END) AS [autoFlow]
                ,SUM(CASE   WHEN [mode_aggregate_description] IN ('Light Heavy Duty Truck',
                                                                  'Medium Heavy Duty Truck',
                                                                  'Heavy Heavy Duty Truck')
                            THEN [flow]
                            ELSE 0 END) AS [truckFlow]
                ,SUM(CASE   WHEN [mode_aggregate_description] = 'Transit'
                            THEN [flow]
                            ELSE 0 END) AS [busFlow]
            FROM
                [fact].[hwy_flow_mode]
            INNER JOIN 
                [dimension].[mode]
            ON
                [hwy_flow_mode].[mode_id] = [mode].[mode_id]
            WHERE
                [scenario_id] = @scenario_id
            GROUP BY
                [hwy_link_ab_tod_id]) AS [hwyFlowModeWide]
        ON
            [hwy_flow].[scenario_id] = [hwyFlowModeWide].[scenario_id]
            AND [hwy_flow].[hwy_link_ab_tod_id] = [hwyFlowModeWide].[hwy_link_ab_tod_id]
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
        WHERE
            [hwy_flow].[scenario_id] = @scenario_id
            AND [hwy_link].[scenario_id] = @scenario_id
            AND [hwy_link_ab_tod].[scenario_id] = @scenario_id
        GROUP BY
            [hwy_link].[ifc])
    SELECT
        [ifc]
        ,[Auto]
        ,[Truck]
        ,[Bus]
        ,[Total]
    FROM (
        SELECT
            [combos].[ifcOrderNo]
            ,[combos].[ifcDesc] AS [ifc]
            ,[networkData].[Auto]
            ,[networkData].[Truck]
            ,[networkData].[Bus]
            ,[networkData].[Total]
        FROM
            [networkData]
        FULL OUTER JOIN
            [combos]
        ON
            [networkData].[ifc_desc] = [combos].[ifcDesc]
        UNION ALL
        SELECT
            99 AS [ifcOrderNo]
            ,'Total' AS [ifc]
            ,SUM([networkData].[Auto]) AS [Auto]
            ,SUM([networkData].[Truck]) AS [Truck]
            ,SUM([networkData].[Bus]) AS [Bus]
            ,SUM([networkData].[Total]) AS [Total]
        FROM
            [networkData]) AS [result_set]
    ORDER BY
        [ifcOrderNo]
OPTION ( OPTIMIZE FOR UNKNOWN )
END
GO

-- add metadata for [sensitivity].[sp_ifc_metrics]
EXECUTE [db_meta].[add_xp] 'sensitivity.sp_ifc_metrics', 'MS_Description', 'stored procedure that calculates a highway network based metric of interest by highway link ifc'
GO




-- create stored procedure to calculate 
-- trip-based mode metrics of interest  --------------------------------------
DROP PROCEDURE IF EXISTS [sensitivity].[sp_mode_metrics]
GO

CREATE PROCEDURE [sensitivity].[sp_mode_metrics]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@weight nvarchar(10),  -- weighting scheme to use in outputting metric of interest
	@metric nvarchar(10)  -- metric of interest to calculate 
AS
/**
summary:   >
     Calculate a trip-based metric of interest using a user-specified
     weighting criteria by ABM sub-model and mode. The stored procedure allows
     for either a trip or person-trip weighting scheme to calculate either the
     trip-based travel distance, mode share, travel time, or count of trips.
revisions:
**/
SET NOCOUNT ON;
BEGIN
    -- check input parameters
    IF (@weight NOT IN ('persons', 'trips') OR @weight IS NULL)
    BEGIN
        RAISERROR('Invalid parameter: @weight must be one of (''persons'', ''trips'')', 18, 0)
        RETURN
    END

    IF (@metric NOT IN ('distance', 'share', 'time', 'trips') OR @metric IS NULL)
    BEGIN
        RAISERROR('Invalid parameter: @metric must be one of (''distance'', ''share'', ''time'', ''trips'')', 18, 0)
        RETURN
    END;


    -- create table containing all combinations of models and modes of interest
    -- ensures all combinations are represented if not present the scenario
    with [combos] AS (
        SELECT
            [model_trip_id] AS [modelOrderNo]
            ,[model_trip_description] AS [model]
            ,[mode]
        FROM (
            SELECT
                [model_trip_id]
                ,LTRIM(RTRIM([model_trip_description])) AS [model_trip_description]
            FROM
                [dimension].[model_trip]
            WHERE
                [model_trip_description] != 'Not Applicable') AS [models]
        CROSS JOIN (
            SELECT
                [mode]
            FROM ( 
                VALUES
                    ('Drive Alone'),
                    ('Shared Ride 2'),
                    ('Shared Ride 3'),
                    ('TNC'),
                    ('Walk'),
                    ('Bike'),
                    ('Transit'),
                    ('Taxi'),
                    ('Truck'),
                    ('School Bus')
                ) AS [modes] ([mode])) AS [mode]),
    -- calculate given metric within each model and mode using given weight
    -- combine TNC modes and combine Truck modes
    [trips] AS (
        SELECT
            [model_trip].[model_trip_description] AS [model]
            ,CASE   WHEN [mode_trip].[mode_aggregate_trip_description] IN ('TNC Single',
                                                                           'TNC Shared')
                    THEN 'TNC'
                    WHEN [mode_trip].[mode_aggregate_trip_description] IN ('Light Heavy Duty Truck',
                                                                           'Medium Heavy Duty Truck',
                                                                           'Heavy Heavy Duty Truck')
                    THEN 'Truck'

                    ELSE [mode_trip].[mode_aggregate_trip_description]
                    END AS [mode]
            ,CASE   WHEN @weight = 'persons' THEN SUM(ISNULL([person_trip].[weight_person_trip], 0))
                    WHEN @weight = 'trips' THEN SUM(ISNULL([person_trip].[weight_trip], 0))
                    ELSE NULL END AS [weight]
            ,CASE   WHEN @metric = 'distance' THEN SUM(ISNULL([person_trip].[dist_total], 0))
                    WHEN @metric IN ('trips', 'share') THEN 0  -- only weight is unused if trips or share is selected
                    WHEN @metric = 'time' THEN SUM(ISNULL([person_trip].[time_total], 0))
                    ELSE NULL END AS [metric]
        FROM
            [fact].[person_trip]
        INNER JOIN 
            [dimension].[model_trip] 
        ON
            [person_trip].[model_trip_id] = [model_trip].[model_trip_id]  
        INNER JOIN
            [dimension].[mode_trip]
        ON
            [person_trip].[mode_trip_id]  = [mode_trip].[mode_trip_id]
        WHERE
            [person_trip].[scenario_id] = @scenario_id
        GROUP BY
            [model_trip].[model_trip_description]
            ,CASE   WHEN [mode_trip].[mode_aggregate_trip_description] IN ('TNC Single',
                                                                           'TNC Shared')
                    THEN 'TNC'
                    WHEN [mode_trip].[mode_aggregate_trip_description] IN ('Light Heavy Duty Truck',
                                                                           'Medium Heavy Duty Truck',
                                                                           'Heavy Heavy Duty Truck')
                    THEN 'Truck'

                    ELSE [mode_trip].[mode_aggregate_trip_description]
                    END)
    -- create metric by model and mode ensuring all models and modes are represented
    SELECT
        ISNULL([combos].[modelOrderNo], 0) AS [modelOrderNo]
        ,ISNULL([combos].[model], 'error') AS [model]
        ,ISNULL([combos].[mode], 'error') AS [mode]
        ,ISNULL([trips].[weight], 0) AS [weight]
        ,ISNULL([trips].[metric], 0) AS [metric]
    INTO #aggTrips
    FROM
        [trips]
    FULL OUTER JOIN
        [combos]
    ON
        [trips].[model] = [combos].[model]
        AND [trips].[mode] = [combos].[mode]


    -- add residential models aggregation
    INSERT INTO #aggTrips
    SELECT
        88 AS [modelOrderNo]
        ,'Resident Models' AS [model]
        ,[mode]
        ,SUM([weight]) AS [weight]
        ,SUM([metric]) AS [metric]
    FROM
        #aggTrips
    WHERE
        [model] IN ('Individual',
                    'Joint',
                    'Internal-External')
    GROUP BY
        [mode]


    -- add all models aggregation
    INSERT INTO #aggTrips
    SELECT
        99 AS [modelOrderNo]
        ,'All Models' AS [model]
        ,[mode]
        ,SUM([weight]) AS [weight]
        ,SUM([metric]) AS [metric]
    FROM
        #aggTrips
    GROUP BY
        [mode]


    -- add totals by model aggregation
    INSERT INTO #aggTrips
    SELECT
        [modelOrderNo]
        ,[model]
        ,'Total' AS [mode]
        ,SUM([weight]) AS [weight]
        ,SUM([metric]) AS [metric]
    FROM
        #aggTrips
    GROUP BY
        [modelOrderNo]
        ,[model]


    -- create final result set
    -- if metric selected is distance/time
    -- then calculate average distance/time by sub-model and mode
    IF @metric IN ('distance', 'time')
    BEGIN
        SELECT
            [model]
            ,[Drive Alone]
            ,[Shared Ride 2]
            ,[Shared Ride 3]
            ,[TNC]
            ,[Walk]
            ,[Bike]
            ,[Transit]
            ,[Taxi]
            ,[Truck]
            ,[School Bus]
            ,[Total]
        FROM (
            SELECT
                #aggTrips.[modelOrderNo]
                ,#aggTrips.[model]
                ,[mode]
                ,ISNULL([metric] / NULLIF([weight], 0), 0) AS [avgMetric]
            FROM
                #aggTrips) AS [finalResult]
        PIVOT (
            MAX([avgMetric]) FOR [mode] IN ([Drive Alone],
                                            [Shared Ride 2],
                                            [Shared Ride 3],
                                            [TNC],
                                            [Walk],
                                            [Bike],
                                            [Transit],
                                            [Taxi],
                                            [Truck],
                                            [School Bus],
                                            [Total])) AS [pvt]
        ORDER BY
            [modelOrderNo]
    END


    -- create final result set
    -- if metric selected is trips
    -- then calculate total trips by sub-model and mode
    IF @metric = 'trips'
    BEGIN
        SELECT
            [model]
            ,[Drive Alone]
            ,[Shared Ride 2]
            ,[Shared Ride 3]
            ,[TNC]
            ,[Walk]
            ,[Bike]
            ,[Transit]
            ,[Taxi]
            ,[Truck]
            ,[School Bus]
            ,[Total]
        FROM (
            SELECT
                #aggTrips.[modelOrderNo]
                ,#aggTrips.[model]
                ,[mode]
                ,ISNULL([weight], 0) AS [trips]
            FROM
                #aggTrips) AS [finalResult]
        PIVOT (
            MAX([trips]) FOR [mode] IN ([Drive Alone],
                                        [Shared Ride 2],
                                        [Shared Ride 3],
                                        [TNC],
                                        [Walk],
                                        [Bike],
                                        [Transit],
                                        [Taxi],
                                        [Truck],
                                        [School Bus],
                                        [Total])) AS [pvt]
        ORDER BY
            [modelOrderNo]
    END


    -- create final result set
    -- if metric selected is share
    -- then calculate share by sub-model
    IF @metric = 'share'
    BEGIN
        SELECT
            [model]
            ,[Drive Alone]
            ,[Shared Ride 2]
            ,[Shared Ride 3]
            ,[TNC]
            ,[Walk]
            ,[Bike]
            ,[Transit]
            ,[Taxi]
            ,[Truck]
            ,[School Bus]
            ,[Total]
        FROM (
            SELECT
                #aggTrips.[modelOrderNo]
                ,#aggTrips.[model]
                ,[mode]
                ,[weight] / NULLIF([totalWeight], 0) AS [share]
            FROM
                #aggTrips
            INNER JOIN (
                SELECT
                    [model]
                    ,SUM([weight]) AS [totalWeight]
                FROM
                    #aggTrips
                WHERE
                    [mode] != 'Total'
                GROUP BY
                    [model]) AS [totalAggTrips]
            ON
                #aggTrips.[model] = [totalAggTrips].[model]) AS [finalResult]
        PIVOT (
            MAX([share]) FOR [mode] IN ([Drive Alone],
                                      [Shared Ride 2],
                                      [Shared Ride 3],
                                      [TNC],
                                      [Walk],
                                      [Bike],
                                      [Transit],
                                      [Taxi],
                                      [Truck],
                                      [School Bus],
                                      [Total])) AS [pvt]
        ORDER BY
            [modelOrderNo]
    END


    -- clean up
    DROP TABLE #aggTrips
END
GO

-- add metadata for [sensitivity].[sp_mode_metrics]
EXECUTE [db_meta].[add_xp] 'sensitivity.sp_mode_metrics', 'MS_Description', 'stored procedure that calculates a trip-based metric of interest using a user-specified weighting criteria by ABM sub-model and mode'
GO




-- create stored procedure to calculate 
-- trip-based purpose metrics of interest  -----------------------------------
DROP PROCEDURE IF EXISTS [sensitivity].[sp_purpose_metrics]
GO

CREATE PROCEDURE [sensitivity].[sp_purpose_metrics]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@weight nvarchar(10),  -- weighting scheme to use in outputting metric of interest
	@metric nvarchar(10)  -- metric of interest to calculate 
AS
/**
summary:   >
     Calculate a trip-based metric of interest using a user-specified
     weighting criteria by ABM sub-model and purpose. The stored procedure
     allows for either a trip or person-trip weighting scheme to calculate
     either the trip-based travel distance, purpose share, travel time, or
     count of trips.
revisions:
**/
SET NOCOUNT ON;
BEGIN
    -- check input parameters
    IF (@weight NOT IN ('persons', 'trips') OR @weight IS NULL)
    BEGIN
        RAISERROR('Invalid parameter: @weight must be one of (''persons'', ''trips'')', 18, 0)
        RETURN
    END

    IF (@metric NOT IN ('distance', 'share', 'time', 'trips') OR @metric IS NULL)
    BEGIN
        RAISERROR('Invalid parameter: @metric must be one of (''distance'', ''share'', ''time'', ''trips'')', 18, 0)
        RETURN
    END;


    -- create table containing all combinations of models and modes of interest
    -- ensures all combinations are represented if not present the scenario
    with [combos] AS (
        SELECT
            [model_trip_id] AS [modelOrderNo]
            ,[model_trip_description] AS [model]
            ,[purpose]
        FROM (
            SELECT
                [model_trip_id]
                ,LTRIM(RTRIM([model_trip_description])) AS [model_trip_description]
            FROM
                [dimension].[model_trip]
            WHERE
                [model_trip_description] != 'Not Applicable') AS [models]
        CROSS JOIN (
            SELECT
                [purpose]
            FROM ( 
                VALUES
                    ('Business'),
                    ('Cargo'),
                    ('Discretionary/Recreation'),
                    ('Eating Out/Dining'),
                    ('Escort'),
                    ('Home'),
                    ('Maintenance'),
                    ('Not Applicable'),
                    ('Other'),
                    ('Personal'),
                    ('School'),
                    ('Shop'),
                    ('University'),
                    ('Visit'),
                    ('Work'),
                    ('Work-Based/Work-Related')
                ) AS [purposes] ([purpose])) AS [purpose]),
    -- calculate given metric within each model and purpose using given weight
    -- note the airport and E-I sub-models only have origin purposes instead of destination purposes
    [trips] AS (
        SELECT
            [model]
            ,CASE   WHEN [purpose] IN ('Resident-Business',
                                       'Visitor-Business')
                    THEN 'Business'  -- combine airport model business purposes
                    WHEN [purpose] IN ('Discretionary',
                                       'Recreation')
                    THEN 'Discretionary/Recreation'  -- combine discretionary and recreation purposes
                    WHEN [purpose] IN ('Eating Out',
                                       'Dining')
                    THEN 'Eating Out/Dining'  -- combine eating out and dining purposes
                    WHEN [purpose] IN ('External',
                                       'Unknown',
                                       'Non-Work')
                    THEN 'Other'  
                    WHEN [purpose] IN ('Resident-Personal',
                                       'Visitor-Personal')
                    THEN 'Personal'  -- combine airport model personal purposes
                    WHEN [purpose] = 'Visiting' THEN 'Visit'  -- map joint model visiting purpose to vist to align with other models
                    WHEN [purpose] IN ('Work-Based',
                                       'Work-Related')
                    THEN 'Work-Based/Work-Related'  -- combine work-based and work-related purposes
                    ELSE [purpose] END AS [purpose]
            ,SUM([weight]) AS [weight]
            ,SUM([metric]) AS [metric]
        FROM (
            SELECT
                [model_trip].[model_trip_description] AS [model]
                ,CASE   WHEN [model_trip].[model_trip_description] IN ('Airport - CBX',
                                                                       'Airport - SAN',
                                                                       'External-Internal')
                        THEN [purpose_trip_origin].[purpose_trip_origin_description]
                        ELSE [purpose_trip_destination].[purpose_trip_destination_description]
                        END AS [purpose]
                ,CASE   WHEN @weight = 'persons' THEN SUM(ISNULL([person_trip].[weight_person_trip], 0))
                        WHEN @weight = 'trips' THEN SUM(ISNULL([person_trip].[weight_trip], 0))
                        ELSE NULL END AS [weight]
                ,CASE   WHEN @metric = 'distance' THEN SUM(ISNULL([person_trip].[dist_total], 0))
                        WHEN @metric = 'share' THEN 0  -- only weight is unused if share is selected
                        WHEN @metric = 'time' THEN SUM(ISNULL([person_trip].[time_total], 0))
                        ELSE NULL END AS [metric]
            FROM
                [fact].[person_trip]
            INNER JOIN 
                [dimension].[model_trip] 
            ON
                [person_trip].[model_trip_id] = [model_trip].[model_trip_id]  
            INNER JOIN
                [dimension].[purpose_trip_origin]
            ON
                [person_trip].[purpose_trip_origin_id]  = [purpose_trip_origin].[purpose_trip_origin_id]
            INNER JOIN
                [dimension].[purpose_trip_destination]
            ON
                [person_trip].[purpose_trip_destination_id]  = [purpose_trip_destination].[purpose_trip_destination_id]
            WHERE
                [person_trip].[scenario_id] = @scenario_id
            GROUP BY
                [model_trip].[model_trip_description]
                ,CASE   WHEN [model_trip].[model_trip_description] IN ('Airport - CBX',
                                                                       'Airport - SAN',
                                                                       'External-Internal')
                        THEN [purpose_trip_origin].[purpose_trip_origin_description]
                        ELSE [purpose_trip_destination].[purpose_trip_destination_description]
                        END) AS [result]
        GROUP BY
            [model]
            ,CASE   WHEN [purpose] IN ('Resident-Business',
                                       'Visitor-Business')
                    THEN 'Business'  -- combine airport model business purposes
                    WHEN [purpose] IN ('Discretionary',
                                       'Recreation')
                    THEN 'Discretionary/Recreation'  -- combine discretionary and recreation purposes
                    WHEN [purpose] IN ('Eating Out',
                                       'Dining')
                    THEN 'Eating Out/Dining'  -- combine eating out and dining purposes
                    WHEN [purpose] IN ('External',
                                       'Unknown',
                                       'Non-Work')
                    THEN 'Other'  
                    WHEN [purpose] IN ('Resident-Personal',
                                       'Visitor-Personal')
                    THEN 'Personal'  -- combine airport model personal purposes
                    WHEN [purpose] = 'Visiting' THEN 'Visit'  -- map joint model visiting purpose to vist to align with other models
                    WHEN [purpose] IN ('Work-Based',
                                       'Work-Related')
                    THEN 'Work-Based/Work-Related'  -- combine work-based and work-related purposes
                    ELSE [purpose] END)
    -- create metric by model and mode ensuring all models and modes are represented
    SELECT
        ISNULL([combos].[modelOrderNo], 0) AS [modelOrderNo]
        ,ISNULL([combos].[model], 'error') AS [model]
        ,ISNULL([combos].[purpose], 'error') AS [purpose]
        ,ISNULL([trips].[weight], 0) AS [weight]
        ,ISNULL([trips].[metric], 0) AS [metric]
    INTO #aggTrips
    FROM
        [trips]
    FULL OUTER JOIN
        [combos]
    ON
        [trips].[model] = [combos].[model]
        AND [trips].[purpose] = [combos].[purpose]


    -- add residential models aggregation
    INSERT INTO #aggTrips
    SELECT
        88 AS [modelOrderNo]
        ,'Resident Models' AS [model]
        ,[purpose]
        ,SUM([weight]) AS [weight]
        ,SUM([metric]) AS [metric]
    FROM
        #aggTrips
    WHERE
        [model] IN ('Individual',
                    'Joint',
                    'Internal-External')
    GROUP BY
        [purpose]


    -- add all models aggregation
    INSERT INTO #aggTrips
    SELECT
        99 AS [modelOrderNo]
        ,'All Models' AS [model]
        ,[purpose]
        ,SUM([weight]) AS [weight]
        ,SUM([metric]) AS [metric]
    FROM
        #aggTrips
    GROUP BY
        [purpose]


    -- add totals by model aggregation
    INSERT INTO #aggTrips
    SELECT
        [modelOrderNo]
        ,[model]
        ,'Total' AS [purpose]
        ,SUM([weight]) AS [weight]
        ,SUM([metric]) AS [metric]
    FROM
        #aggTrips
    GROUP BY
        [modelOrderNo]
        ,[model]


    -- create final result set
    -- if metric selected is distance/time
    -- then calculate average distance/time by sub-model and purpose
    IF @metric IN ('distance', 'time')
    BEGIN
        SELECT
            [model]
            ,[Business]
            ,[Cargo]
            ,[Discretionary/Recreation]
            ,[Eating Out/Dining]
            ,[Escort]
            ,[Home]
            ,[Maintenance]
            ,[Not Applicable]
            ,[Other]
            ,[Personal]
            ,[School]
            ,[Shop]
            ,[University]
            ,[Visit]
            ,[Work]
            ,[Work-Based/Work-Related]
            ,[Total]
        FROM (
            SELECT
                #aggTrips.[modelOrderNo]
                ,#aggTrips.[model]
                ,[purpose]
                ,ISNULL([metric] / NULLIF([weight], 0), 0) AS [avgMetric]
            FROM
                #aggTrips) AS [finalResult]
        PIVOT (
            MAX([avgMetric]) FOR [purpose] IN ([Business]
                                               ,[Cargo]
                                               ,[Discretionary/Recreation]
                                               ,[Eating Out/Dining]
                                               ,[Escort]
                                               ,[Home]
                                               ,[Maintenance]
                                               ,[Not Applicable]
                                               ,[Other]
                                               ,[Personal]
                                               ,[School]
                                               ,[Shop]
                                               ,[University]
                                               ,[Visit]
                                               ,[Work]
                                               ,[Work-Based/Work-Related],
                                               [Total])) AS [pvt]
        ORDER BY
            [modelOrderNo]
    END


    -- create final result set
    -- if metric selected is share
    -- then calculate share by sub-model
    IF @metric = 'share'
    BEGIN
        SELECT
            [model]
            ,[Business]
            ,[Cargo]
            ,[Discretionary/Recreation]
            ,[Eating Out/Dining]
            ,[Escort]
            ,[Home]
            ,[Maintenance]
            ,[Not Applicable]
            ,[Other]
            ,[Personal]
            ,[School]
            ,[Shop]
            ,[University]
            ,[Visit]
            ,[Work]
            ,[Work-Based/Work-Related]
            ,[Total]
        FROM (
            SELECT
                #aggTrips.[modelOrderNo]
                ,#aggTrips.[model]
                ,[purpose]
                ,[weight] / NULLIF([totalWeight], 0) AS [share]
            FROM
                #aggTrips
            INNER JOIN (
                SELECT
                    [model]
                    ,SUM([weight]) AS [totalWeight]
                FROM
                    #aggTrips
                WHERE
                    [purpose] != 'Total'
                GROUP BY
                    [model]) AS [totalAggTrips]
            ON
                #aggTrips.[model] = [totalAggTrips].[model]) AS [finalResult]
        PIVOT (
            MAX([share]) FOR [purpose] IN ([Business]
                                           ,[Cargo]
                                           ,[Discretionary/Recreation]
                                           ,[Eating Out/Dining]
                                           ,[Escort]
                                           ,[Home]
                                           ,[Maintenance]
                                           ,[Not Applicable]
                                           ,[Other]
                                           ,[Personal]
                                           ,[School]
                                           ,[Shop]
                                           ,[University]
                                           ,[Visit]
                                           ,[Work]
                                           ,[Work-Based/Work-Related]
                                           ,[Total])) AS [pvt]
        ORDER BY
            [modelOrderNo]
    END


    -- clean up
    DROP TABLE #aggTrips
END
GO

-- add metadata for [sensitivity].[sp_purpose_metrics]
EXECUTE [db_meta].[add_xp] 'sensitivity.sp_purpose_metrics', 'MS_Description', 'stored procedure that calculates a trip-based metric of interest using a user-specified weighting criteria by ABM sub-model and purpose'
GO




-- create stored procedure to return scenario metadata -----------------------
DROP PROCEDURE IF EXISTS [sensitivity].[sp_scenario]
GO

CREATE PROCEDURE [sensitivity].[sp_scenario]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS
/**
summary:   >
     Return ABM scenario metadata.
revisions:
**/
BEGIN
    SELECT
        [scenario_id]
        ,[name]
        ,[year]
        ,[iteration]
        ,[sample_rate]
        ,[abm_version]
        ,[path]
    FROM
        [dimension].[scenario]
    WHERE
        [scenario_id] = @scenario_id
END
GO

-- add metadata for [sensitivity].[sp_scenario]
EXECUTE [db_meta].[add_xp] 'sensitivity.sp_scenario', 'MS_Description', 'stored procedure that returns scenario metadata'
GO




-- create stored procedure to calculate 
-- school location distance and students by student status  ------------------
DROP PROCEDURE IF EXISTS [sensitivity].[sp_school_location]
GO

CREATE PROCEDURE [sensitivity].[sp_school_location]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS
/**
summary:   >
     Calculate the number of students and average school location distance, a
     drive alone auto skim distance in miles, by student status. Note that
     home-schooled students are included with school location distance of 0.
revisions:
**/
BEGIN
    SELECT
        ISNULL(LTRIM(RTRIM([student_status])), 'All Students') AS [student_status]
        ,SUM(1.0 * [weight_person] * ISNULL([school_distance], 0)) / SUM(ISNULL([weight_person], 0)) / 5280 AS [distance]
        ,SUM([weight_person]) AS [persons]
    FROM
        [dimension].[person]
    WHERE
        [scenario_id] = @scenario_id
        AND NOT [student_status] IN ('Not Applicable', 'Not Attending School')  -- non-students
    GROUP BY
        [student_status]
    WITH ROLLUP
END
GO

-- add metadata for [sensitivity].[sp_school_location]
EXECUTE [db_meta].[add_xp] 'sensitivity.sp_school_location', 'MS_Description', 'stored procedure that calculates number of students and average school location distance by student status'
GO




-- create stored procedure to calculate 
-- trip-based transit-only mode metrics of interest  -------------------------
DROP PROCEDURE IF EXISTS [sensitivity].[sp_transit_mode_metrics]
GO

CREATE PROCEDURE [sensitivity].[sp_transit_mode_metrics]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@weight nvarchar(10),  -- weighting scheme to use in outputting metric of interest
	@metric nvarchar(10)  -- metric of interest to calculate 
AS
/**
summary:   >
     Calculate a trip-based metric of interest using a user-specified
     weighting criteria by ABM sub-model and mode restricted to transit-only
     modes. The stored procedure allows for either a trip or person-trip
     weighting scheme to calculate either the trip-based travel distance, mode
      share, travel time, or count of trips.
revisions:
**/
SET NOCOUNT ON;
BEGIN
    -- check input parameters
    IF (@weight NOT IN ('persons', 'trips') OR @weight IS NULL)
    BEGIN
        RAISERROR('Invalid parameter: @weight must be one of (''persons'', ''trips'')', 18, 0)
        RETURN
    END

    IF (@metric NOT IN ('distance', 'share', 'time', 'trips') OR @metric IS NULL)
    BEGIN
        RAISERROR('Invalid parameter: @metric must be one of (''distance'', ''share'', ''time'', ''trips'')', 18, 0)
        RETURN
    END;


    -- create table containing all combinations of models and transit modes of interest
    -- ensures all combinations are represented if not present the scenario
    with [combos] AS (
        SELECT
            [model_trip_id] AS [modelOrderNo]
            ,[model_trip_description] AS [model]
            ,[mode]
        FROM (
            SELECT
                [model_trip_id]
                ,LTRIM(RTRIM([model_trip_description])) AS [model_trip_description]
            FROM
                [dimension].[model_trip]
            WHERE
                [model_trip_description] != 'Not Applicable') AS [models]
        CROSS JOIN (
            SELECT
                [mode]
            FROM ( 
                VALUES
                    ('Kiss and Ride'),
                    ('Park and Ride'),
                    ('TNC to Transit'),
                    ('Walk to Transit')
                ) AS [modes] ([mode])) AS [mode]),
    -- calculate given metric within each model and mode using given weight
    -- combine transit modes across skim sets into access modes
    [trips] AS (
        SELECT
            [model_trip].[model_trip_description] AS [model]
            ,CASE   WHEN [mode_trip].[mode_trip_description] IN ('Kiss and Ride to Transit - Local Bus Only',
                                                                 'Kiss and Ride to Transit - Premium Transit Only',
                                                                 'Kiss and Ride to Transit - Local Bus and Premium Transit')
                    THEN 'Kiss and Ride'
                    WHEN [mode_trip].[mode_trip_description] IN ('Park and Ride to Transit - Local Bus Only',
                                                                 'Park and Ride to Transit - Premium Transit Only',
                                                                 'Park and Ride to Transit - Local Bus and Premium Transit')
                    THEN 'Park and Ride'
                    WHEN [mode_trip].[mode_trip_description] IN ('TNC to Transit - Local Bus Only',
                                                                 'TNC to Transit - Premium Transit Only',
                                                                 'TNC to Transit - Local Bus and Premium Transit')
                    THEN 'TNC to Transit'
                    WHEN [mode_trip].[mode_trip_description] IN ('Walk to Transit - Local Bus Only',
                                                                 'Walk to Transit - Premium Transit Only',
                                                                 'Walk to Transit - Local Bus and Premium Transit')
                    THEN 'Walk to Transit'
                    ELSE [mode_trip].[mode_trip_description]
                    END AS [mode]
            ,CASE   WHEN @weight = 'persons' THEN SUM(ISNULL([person_trip].[weight_person_trip], 0))
                    WHEN @weight = 'trips' THEN SUM(ISNULL([person_trip].[weight_trip], 0))
                    ELSE NULL END AS [weight]
            ,CASE   WHEN @metric = 'distance' THEN SUM(ISNULL([person_trip].[dist_total], 0))
                    WHEN @metric IN ('trips', 'share') THEN 0  -- only weight is unused if trips or share is selected
                    WHEN @metric = 'time' THEN SUM(ISNULL([person_trip].[time_total], 0))
                    ELSE NULL END AS [metric]
        FROM
            [fact].[person_trip]
        INNER JOIN 
            [dimension].[model_trip] 
        ON
            [person_trip].[model_trip_id] = [model_trip].[model_trip_id]  
        INNER JOIN
            [dimension].[mode_trip]
        ON
            [person_trip].[mode_trip_id]  = [mode_trip].[mode_trip_id]
        WHERE
            [person_trip].[scenario_id] = @scenario_id
            AND [mode_trip].[mode_aggregate_trip_description] = 'Transit' -- transit trips only
        GROUP BY
            [model_trip].[model_trip_description]
            ,CASE   WHEN [mode_trip].[mode_trip_description] IN ('Kiss and Ride to Transit - Local Bus Only',
                                                                 'Kiss and Ride to Transit - Premium Transit Only',
                                                                 'Kiss and Ride to Transit - Local Bus and Premium Transit')
                    THEN 'Kiss and Ride'
                    WHEN [mode_trip].[mode_trip_description] IN ('Park and Ride to Transit - Local Bus Only',
                                                                 'Park and Ride to Transit - Premium Transit Only',
                                                                 'Park and Ride to Transit - Local Bus and Premium Transit')
                    THEN 'Park and Ride'
                    WHEN [mode_trip].[mode_trip_description] IN ('TNC to Transit - Local Bus Only',
                                                                 'TNC to Transit - Premium Transit Only',
                                                                 'TNC to Transit - Local Bus and Premium Transit')
                    THEN 'TNC to Transit'
                    WHEN [mode_trip].[mode_trip_description] IN ('Walk to Transit - Local Bus Only',
                                                                 'Walk to Transit - Premium Transit Only',
                                                                 'Walk to Transit - Local Bus and Premium Transit')
                    THEN 'Walk to Transit'
                    ELSE [mode_trip].[mode_trip_description]
                    END)
    -- create metric by model and mode ensuring all models and modes are represented
    SELECT
        ISNULL([combos].[modelOrderNo], 0) AS [modelOrderNo]
        ,ISNULL([combos].[model], 'error') AS [model]
        ,ISNULL([combos].[mode], 'error') AS [mode]
        ,ISNULL([trips].[weight], 0) AS [weight]
        ,ISNULL([trips].[metric], 0) AS [metric]
    INTO #aggTrips
    FROM
        [trips]
    FULL OUTER JOIN
        [combos]
    ON
        [trips].[model] = [combos].[model]
        AND [trips].[mode] = [combos].[mode]
 

    -- add residential models aggregation
    INSERT INTO #aggTrips
    SELECT
        88 AS [modelOrderNo]
        ,'Resident Models' AS [model]
        ,[mode]
        ,SUM([weight]) AS [weight]
        ,SUM([metric]) AS [metric]
    FROM
        #aggTrips
    WHERE
        [model] IN ('Individual',
                    'Joint',
                    'Internal-External')
    GROUP BY
        [mode]


    -- add all models aggregation
    INSERT INTO #aggTrips
    SELECT
        99 AS [modelOrderNo]
        ,'All Models' AS [model]
        ,[mode]
        ,SUM([weight]) AS [weight]
        ,SUM([metric]) AS [metric]
    FROM
        #aggTrips
    GROUP BY
        [mode]


    -- add totals by model aggregation
    INSERT INTO #aggTrips
    SELECT
        [modelOrderNo]
        ,[model]
        ,'Total' AS [mode]
        ,SUM([weight]) AS [weight]
        ,SUM([metric]) AS [metric]
    FROM
        #aggTrips
    GROUP BY
        [modelOrderNo]
        ,[model]

    
    -- create final result set
    -- if metric selected is distance/time
    -- then calculate average distance/time by sub-model and mode
    IF @metric IN ('distance', 'time')
    BEGIN
        SELECT
            [model]
            ,[Kiss and Ride]
            ,[Park and Ride]
            ,[TNC to Transit]
            ,[Walk to Transit]
            ,[Total]
        FROM (
            SELECT
                #aggTrips.[modelOrderNo]
                ,#aggTrips.[model]
                ,[mode]
                ,ISNULL([metric] / NULLIF([weight], 0), 0) AS [avgMetric]
            FROM
                #aggTrips) AS [finalResult]
        PIVOT (
            MAX([avgMetric]) FOR [mode] IN ([Kiss and Ride]
                                            ,[Park and Ride]
                                            ,[TNC to Transit]
                                            ,[Walk to Transit]
                                            ,[Total])) AS [pvt]
        ORDER BY
            [modelOrderNo]
    END


    -- create final result set
    -- if metric selected is trips
    -- then calculate total trips by sub-model and mode
    IF @metric = 'trips'
    BEGIN
        SELECT
            [model]
            ,[Kiss and Ride]
            ,[Park and Ride]
            ,[TNC to Transit]
            ,[Walk to Transit]
            ,[Total]
        FROM (
            SELECT
                #aggTrips.[modelOrderNo]
                ,#aggTrips.[model]
                ,[mode]
                ,ISNULL([weight], 0) AS [trips]
            FROM
                #aggTrips) AS [finalResult]
        PIVOT (
            MAX([trips]) FOR [mode] IN ([Kiss and Ride]
                                        ,[Park and Ride]
                                        ,[TNC to Transit]
                                        ,[Walk to Transit]
                                        ,[Total])) AS [pvt]
        ORDER BY
            [modelOrderNo]
    END


    -- create final result set
    -- if metric selected is share
    -- then calculate share by sub-model
    IF @metric = 'share'
    BEGIN
        SELECT
            [model]
            ,[Kiss and Ride]
            ,[Park and Ride]
            ,[TNC to Transit]
            ,[Walk to Transit]
            ,[Total]
        FROM (
            SELECT
                #aggTrips.[modelOrderNo]
                ,#aggTrips.[model]
                ,[mode]
                ,[weight] / NULLIF([totalWeight], 0) AS [share]
            FROM
                #aggTrips
            INNER JOIN (
                SELECT
                    [model]
                    ,SUM([weight]) AS [totalWeight]
                FROM
                    #aggTrips
                WHERE
                    [mode] != 'Total'
                GROUP BY
                    [model]) AS [totalAggTrips]
            ON
                #aggTrips.[model] = [totalAggTrips].[model]) AS [finalResult]
        PIVOT (
            MAX([share]) FOR [mode] IN ([Kiss and Ride]
                                        ,[Park and Ride]
                                        ,[TNC to Transit]
                                        ,[Walk to Transit]
                                        ,[Total])) AS [pvt]
        ORDER BY
            [modelOrderNo]
    END


    -- clean up
    DROP TABLE #aggTrips
END
GO

-- add metadata for [sensitivity].[sp_transit_mode_metrics]
EXECUTE [db_meta].[add_xp] 'sensitivity.sp_transit_mode_metrics', 'MS_Description', 'stored procedure that calculates a trip-based metric of interest using a user-specified weighting criteria by ABM sub-model and mode restricted to transit-only modes'
GO




-- create stored procedure to calculate 
-- transit on/off metrics of interest by time of day and line haul mode  -----
DROP PROCEDURE IF EXISTS [sensitivity].[sp_transit_onoff_metrics]
GO

CREATE PROCEDURE [sensitivity].[sp_transit_onoff_metrics]
	@scenario_id integer,  -- ABM scenario in [dimension].[scenario]
	@metric nvarchar(30)  -- metric of interest to calculate
AS
/**
summary:   >
     Calculate transit on/off metric of interest. The stored procedure can be
     used to calculate either
        - the count of boardings, count of transfers, share
          of boardings, or share of transfers by ABM five time of day and
          transit route line haul mode
        - the amount of boardings/transfers per transit trip/transit person trip by
          ABM five time of day
revisions:
**/
SET NOCOUNT ON;
BEGIN
    -- check input parameters
    IF (@metric NOT IN ('boardings', 'boardings per trip', 'boardings share',
                        'transfers', 'transfers per trip', 'transfers share')
        OR @metric IS NULL)
    BEGIN
        RAISERROR('Invalid parameter: @metric must be one of (''boardings'', ''boardings per trip'', ''boardings share'', ''transfers'', ''transfers per trip'', ''transfers share'')', 18, 0)
        RETURN
    END;


    -- create table containing all combinations of times of day and transit modes of interest
    -- ensures all combinations are represented if not present the scenario
    with [combos] AS (
        SELECT
            [abm_5_tod]
            ,[abm_5_tod_desc]
            ,[mode]
        FROM (
            SELECT DISTINCT
                [abm_5_tod]
                ,CASE   WHEN [abm_5_tod] = '1' THEN 'EA'
                        WHEN [abm_5_tod] = '2' THEN 'AM'
                        WHEN [abm_5_tod] = '3' THEN 'MD'
                        WHEN [abm_5_tod] = '4' THEN 'PM'
                        WHEN [abm_5_tod] = '5' THEN 'EV'
                        END AS [abm_5_tod_desc]
            FROM
                [dimension].[time]
            WHERE
                [abm_5_tod] != 'Not Applicable') AS [times]
        CROSS JOIN (
            SELECT
                [mode]
            FROM (
                VALUES
                    ('Commuter Rail'),
                    ('Light Rail'),
                    ('Freeway Rapid'),
                    ('Arterial Rapid'),
                    ('Premium Express Bus'),
                    ('Express Bus'),
                    ('Local Bus')
                ) AS [modes] ([mode])) AS [mode]),
    [networkData] AS (
        SELECT
            CONVERT(integer, [time].[abm_5_tod]) AS [abm_5_tod]
            ,[mode_transit_route].[mode_transit_route_description] AS [mode]
            ,SUM(CASE   WHEN @metric IN ('boardings', 'boardings per trip', 'boardings share') THEN [boardings]
                        WHEN @metric IN ('transfers', 'transfers per trip', 'transfers share') THEN [direct_transfer_off]
                        ELSE 0 END) AS [metric]
        FROM
            [fact].[transit_onoff]
        INNER JOIN
            [dimension].[transit_route]
        ON
            [transit_onoff].[scenario_id] = [transit_route].[scenario_id]
            AND [transit_onoff].[transit_route_id] = [transit_route].[transit_route_id]
        INNER JOIN
            [dimension].[mode_transit_route]
        ON
            [mode_transit_route].[mode_transit_route_id] = [transit_route].[mode_transit_route_id]
        INNER JOIN
            [dimension].[time]
        ON
            [transit_onoff].[time_id] = [time].[time_id]
        WHERE
            [transit_onoff].[scenario_id] = @scenario_id
            AND [transit_route].[scenario_id] = @scenario_id
        GROUP BY
            [mode_transit_route].[mode_transit_route_description]
            ,[time].[abm_5_tod])
    -- create metric by time of day and mode ensuring all times and modes are represented
    SELECT
        ISNULL([combos].[abm_5_tod], 'error') AS [time_period]
        ,CONVERT(nvarchar(5), ISNULL([combos].[abm_5_tod_desc], 'error')) AS [time_period_desc]
        ,ISNULL([combos].[mode], 'error') AS [mode]
        ,ISNULL([networkData].[metric], 0) AS [metric]
    INTO #aggNetworkData
    FROM
        [networkData]
    FULL OUTER JOIN
        [combos]
    ON
        [networkData].[abm_5_tod] = [combos].[abm_5_tod]
        AND [networkData].[mode] = [combos].[mode]


    -- add all time periods aggregation
    INSERT INTO #aggNetworkData
    SELECT
        99 AS [time_period]
        ,'Total' AS [time_period_desc]
        ,[mode]
        ,SUM([metric]) AS [metric]
    FROM
        #aggNetworkData
    GROUP BY
        [mode]


    -- add all modes aggregation
    INSERT INTO #aggNetworkData
    SELECT
        [time_period]
        ,[time_period_desc]
        ,'Total' AS [mode]
        ,SUM([metric]) AS [metric]
    FROM
        #aggNetworkData
    GROUP BY
        [time_period]
        ,[time_period_desc]


    -- create final result set
    -- if metric selected is boardings
    -- then calculate total boardings by time period and mode
    IF @metric IN ('boardings', 'transfers')
    BEGIN
        SELECT
            [time_period_desc]
            ,[Commuter Rail]
            ,[Light Rail]
            ,[Freeway Rapid]
            ,[Arterial Rapid]
            ,[Premium Express Bus]
            ,[Express Bus]
            ,[Local Bus]
            ,[Total]
        FROM (
            SELECT
                [time_period]
                ,[time_period_desc]
                ,[mode]
                ,ISNULL([metric], 0) AS [counts]
            FROM
                #aggNetworkData) AS [finalResult]
        PIVOT (
            MAX([counts]) FOR [mode] IN ([Commuter Rail]
                                         ,[Light Rail]
                                         ,[Freeway Rapid]
                                         ,[Arterial Rapid]
                                         ,[Premium Express Bus]
                                         ,[Express Bus]
                                         ,[Local Bus]
                                         ,[Total])) AS [pvt]
        ORDER BY
            [time_period]
    END


    -- create final result set
    -- if metric selected is per trip
    -- then calculate per trip across by time period all modes
    IF @metric IN ('boardings per trip', 'transfers per trip')
    BEGIN
        with [trips] AS (
            SELECT
                [times].[abm_5_tod]
                ,[times].[abm_5_tod_desc]
                ,SUM([person_trip].[weight_person_trip]) AS [person_trips]
                ,SUM([person_trip].[weight_trip]) AS [trips]
            FROM
                [fact].[person_trip]
            INNER JOIN
                [dimension].[time_trip_start]
            ON
                [person_trip].[time_trip_start_id] = [time_trip_start].[time_trip_start_id]
            INNER JOIN
                [dimension].[mode_trip]
            ON
                [person_trip].[mode_trip_id] = [mode_trip].[mode_trip_id]
            RIGHT OUTER JOIN (
                SELECT DISTINCT
                    [abm_5_tod]
                    ,CASE   WHEN [abm_5_tod] = '1' THEN 'EA'
                            WHEN [abm_5_tod] = '2' THEN 'AM'
                            WHEN [abm_5_tod] = '3' THEN 'MD'
                            WHEN [abm_5_tod] = '4' THEN 'PM'
                            WHEN [abm_5_tod] = '5' THEN 'EV'
                            END AS [abm_5_tod_desc]
                FROM
                    [dimension].[time]
                WHERE
                    [abm_5_tod] != 'Not Applicable') AS [times]
            ON
                [time_trip_start].[trip_start_abm_5_tod] = [times].[abm_5_tod]
            WHERE
                [scenario_id] = 492
                AND [mode_trip].[mode_aggregate_trip_description] = 'Transit'
            GROUP BY
                [times].[abm_5_tod]
                ,[times].[abm_5_tod_desc]),
        [aggTrips] AS (
            SELECT
                [abm_5_tod]
                ,[abm_5_tod_desc]
                ,[person_trips]
                ,[trips]
            FROM
                [trips]
            UNION ALL
            SELECT
                '99' AS [abm_5_tod]
                ,'Total' AS [abm_5_tod_desc]
                ,SUM([person_trips]) AS [person_trips]
                ,SUM([trips]) AS [trips]
            FROM
                [trips]),
        [aggNetworkDataTimePeriod] AS (
            SELECT
                [time_period]
                ,[time_period_desc]
                ,SUM(ISNULL([metric], 0)) AS [counts]
            FROM
                #aggNetworkData
            GROUP BY
                [time_period]
                ,[time_period_desc])
        SELECT
            [time_period_desc]
            ,[counts] / [trips] AS [Metric Per Trip]
            ,[counts] / [person_trips] AS [Metric Per Person Trip]
        FROM
            [aggNetworkDataTimePeriod]
        INNER JOIN
            [aggTrips]
        ON
            [aggNetworkDataTimePeriod].[time_period] = [aggTrips].[abm_5_tod]
        ORDER BY
            [time_period]
    END


    -- create final result set
    -- if metric selected is share
    -- then calculate share by time period and mode
    IF @metric IN ('boardings share', 'transfers share')
    BEGIN
        SELECT
            [time_period_desc]
            ,[Commuter Rail]
            ,[Light Rail]
            ,[Freeway Rapid]
            ,[Arterial Rapid]
            ,[Premium Express Bus]
            ,[Express Bus]
            ,[Local Bus]
            ,[Total]
        FROM (
            SELECT
                [time_period]
                ,#aggNetworkData.[time_period_desc]
                ,[mode]
                ,[metric] / NULLIF([totalMetric], 0) AS [share]
            FROM
                #aggNetworkData
            INNER JOIN (
                SELECT
                    [time_period_desc]
                    ,SUM([metric]) AS [totalMetric]
                FROM
                    #aggNetworkData
                WHERE
                    [mode] != 'Total'
                GROUP BY
                    [time_period_desc]) AS [totalAggMetric]
            ON
                #aggNetworkData.[time_period_desc] = [totalAggMetric].[time_period_desc]) AS [finalResult]
        PIVOT (
            MAX([share]) FOR [mode] IN ([Commuter Rail]
                                        ,[Light Rail]
                                        ,[Freeway Rapid]
                                        ,[Arterial Rapid]
                                        ,[Premium Express Bus]
                                        ,[Express Bus]
                                        ,[Local Bus]
                                        ,[Total])) AS [pvt]
        ORDER BY
            [time_period]
    END


    -- clean up
    DROP TABLE #aggNetworkData
END
GO




-- create stored procedure to calculate 
-- work location distance and workers by emplyoment segment  -----------------
DROP PROCEDURE IF EXISTS [sensitivity].[sp_work_location]
GO

CREATE PROCEDURE [sensitivity].[sp_work_location]
	@scenario_id integer  -- ABM scenario in [dimension].[scenario]
AS
/**
summary:   >
     Calculate the number of workers and average work location distance, a 
     drive alone auto skim distance in miles, by employment segment. Note that
     work from home workers are included with work location distance of 0.
revisions:
**/
BEGIN
    SELECT
        ISNULL(LTRIM(RTRIM([work_segment])), 'All Workers') AS [work_segment]
        ,SUM(1.0 * [weight_person] * ISNULL([work_distance], 0)) / SUM(ISNULL([weight_person], 0)) / 5280 AS [distance]
        ,SUM([weight_person]) AS [persons]
    FROM
        [dimension].[person]
    WHERE
        [scenario_id] = @scenario_id
        AND NOT [work_segment] IN ('Not Applicable', 'Non-Worker')  -- non workers
    GROUP BY
        [work_segment]
    WITH ROLLUP
END
GO

-- add metadata for [sensitivity].[sp_work_location]
EXECUTE [db_meta].[add_xp] 'sensitivity.sp_work_location', 'MS_Description', 'stored procedure that calculates number of workers and average work location distance by employment segment'
GO




-- define [sensitivity] schema permissions -----------------------------------
-- drop [sensitivity] role if it exists
DECLARE @RoleName sysname
set @RoleName = N'sensitivity_user'

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

    DROP ROLE [sensitivity_user]
END
GO
-- create user role for [fed_rtp_20] schema
CREATE ROLE [sensitivity_user] AUTHORIZATION dbo;
-- allow all users to select, view definitions
-- and execute [sensitivity] stored procedures
GRANT EXECUTE ON SCHEMA :: [sensitivity] TO [sensitivity_user];
GRANT SELECT ON SCHEMA :: [sensitivity] TO [sensitivity_user];
GRANT VIEW DEFINITION ON SCHEMA :: [sensitivity] TO [sensitivity_user];