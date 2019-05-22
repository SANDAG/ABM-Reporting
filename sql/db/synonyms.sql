-- create dimension schema if it does not already exist ----------------------
IF NOT EXISTS (
    SELECT
        [schema_name]
    FROM
        [information_schema].[schemata]
    WHERE
        [schema_name] = 'dimension'
)
BEGIN
EXECUTE ('CREATE SCHEMA [dimension]')
EXECUTE [db_meta].[add_xp] 'dimension', 'MS_Description', 'schema to hold and manage ABM dimension tables and views'
END
GO




-- create fact schema if it does not already exist ---------------------------
IF NOT EXISTS (
    SELECT
        [schema_name]
    FROM
        [information_schema].[schemata]
    WHERE
        [schema_name] = 'fact'
)
BEGIN
EXECUTE ('CREATE SCHEMA [fact]')
EXECUTE [db_meta].[add_xp] 'fact', 'MS_Description', 'schema to hold and manage ABM fact tables'
END
GO




-- create synonyms for objects in the abm_2 database -------------------------
-- tables --------------------------------------------------------------------
DROP SYNONYM IF EXISTS [dimension].[bike_link]
GO
CREATE SYNONYM [dimension].[bike_link]
FOR [abm_2].[dimension].[bike_link]
GO

DROP SYNONYM IF EXISTS [dimension].[bike_link_ab]
GO
CREATE SYNONYM [dimension].[bike_link_ab]
FOR [abm_2].[dimension].[bike_link_ab]
GO

DROP SYNONYM IF EXISTS [dimension].[escort_stop_type]
GO
CREATE SYNONYM [dimension].[escort_stop_type]
FOR [abm_2].[dimension].[escort_stop_type]
GO

DROP SYNONYM IF EXISTS [dimension].[geography]
GO
CREATE SYNONYM [dimension].[geography]
FOR [abm_2].[dimension].[geography]
GO

DROP SYNONYM IF EXISTS [dimension].[household]
GO
CREATE SYNONYM [dimension].[household]
FOR [abm_2].[dimension].[household]
GO

DROP SYNONYM IF EXISTS [dimension].[hwy_link]
GO
CREATE SYNONYM [dimension].[hwy_link]
FOR [abm_2].[dimension].[hwy_link]
GO

DROP SYNONYM IF EXISTS [dimension].[hwy_link_ab]
GO
CREATE SYNONYM [dimension].[hwy_link_ab]
FOR [abm_2].[dimension].[hwy_link_ab]
GO

DROP SYNONYM IF EXISTS [dimension].[hwy_link_ab_tod]
GO
CREATE SYNONYM [dimension].[hwy_link_ab_tod]
FOR [abm_2].[dimension].[hwy_link_ab_tod]
GO

DROP SYNONYM IF EXISTS [dimension].[hwy_link_tod]
GO
CREATE SYNONYM [dimension].[hwy_link_tod]
FOR [abm_2].[dimension].[hwy_link_tod]
GO

DROP SYNONYM IF EXISTS [dimension].[inbound]
GO
CREATE SYNONYM [dimension].[inbound]
FOR [abm_2].[dimension].[inbound]
GO

DROP SYNONYM IF EXISTS [dimension].[mode]
GO
CREATE SYNONYM [dimension].[mode]
FOR [abm_2].[dimension].[mode]
GO

DROP SYNONYM IF EXISTS [dimension].[model]
GO
CREATE SYNONYM [dimension].[model]
FOR [abm_2].[dimension].[model]
GO

DROP SYNONYM IF EXISTS [dimension].[person]
GO
CREATE SYNONYM [dimension].[person]
FOR [abm_2].[dimension].[person]
GO

DROP SYNONYM IF EXISTS [dimension].[purpose]
GO
CREATE SYNONYM [dimension].[purpose]
FOR [abm_2].[dimension].[purpose]
GO

DROP SYNONYM IF EXISTS [dimension].[scenario]
GO
CREATE SYNONYM [dimension].[scenario]
FOR [abm_2].[dimension].[scenario]
GO

DROP SYNONYM IF EXISTS [dimension].[time]
GO
CREATE SYNONYM [dimension].[time]
FOR [abm_2].[dimension].[time]
GO

DROP SYNONYM IF EXISTS [dimension].[tour]
GO
CREATE SYNONYM [dimension].[tour]
FOR [abm_2].[dimension].[tour]
GO

DROP SYNONYM IF EXISTS [dimension].[transit_link]
GO
CREATE SYNONYM [dimension].[transit_link]
FOR [abm_2].[dimension].[transit_link]
GO

DROP SYNONYM IF EXISTS [dimension].[transit_route]
GO
CREATE SYNONYM [dimension].[transit_route]
FOR [abm_2].[dimension].[transit_route]
GO

DROP SYNONYM IF EXISTS [dimension].[transit_stop]
GO
CREATE SYNONYM [dimension].[transit_stop]
FOR [abm_2].[dimension].[transit_stop]
GO

DROP SYNONYM IF EXISTS [dimension].[transit_tap]
GO
CREATE SYNONYM [dimension].[transit_tap]
FOR [abm_2].[dimension].[transit_tap]
GO

DROP SYNONYM IF EXISTS [dimension].[value_of_time_drive_bin]
GO
CREATE SYNONYM [dimension].[value_of_time_drive_bin]
FOR [abm_2].[dimension].[value_of_time_drive_bin]
GO

DROP SYNONYM IF EXISTS [fact].[bike_flow]
GO
CREATE SYNONYM [fact].[bike_flow]
FOR [abm_2].[fact].[bike_flow]
GO

DROP SYNONYM IF EXISTS [fact].[bike_flow]
GO
CREATE SYNONYM [fact].[bike_flow]
FOR [abm_2].[fact].[bike_flow]
GO

DROP SYNONYM IF EXISTS [fact].[hwy_flow]
GO
CREATE SYNONYM [fact].[hwy_flow]
FOR [abm_2].[fact].[hwy_flow]
GO

DROP SYNONYM IF EXISTS [fact].[hwy_flow_mode]
GO
CREATE SYNONYM [fact].[hwy_flow_mode] 
FOR [abm_2].[fact].[hwy_flow_mode]
GO

DROP SYNONYM IF EXISTS [fact].[mgra_based_input]
GO
CREATE SYNONYM [fact].[mgra_based_input] 
FOR [abm_2].[fact].[mgra_based_input]
GO

DROP SYNONYM IF EXISTS [fact].[person_trip]
GO
CREATE SYNONYM [fact].[person_trip] 
FOR [abm_2].[fact].[person_trip]
GO

DROP SYNONYM IF EXISTS [fact].[transit_aggflow]
GO
CREATE SYNONYM [fact].[transit_aggflow] 
FOR [abm_2].[fact].[transit_aggflow]
GO

DROP SYNONYM IF EXISTS [fact].[transit_flow]
GO
CREATE SYNONYM [fact].[transit_flow] 
FOR [abm_2].[fact].[transit_flow]
GO

DROP SYNONYM IF EXISTS [fact].[transit_onoff]
GO
CREATE SYNONYM [fact].[transit_onoff] 
FOR [abm_2].[fact].[transit_onoff]
GO

DROP SYNONYM IF EXISTS [fact].[transit_pnr]
GO
CREATE SYNONYM [fact].[transit_pnr] 
FOR [abm_2].[fact].[transit_pnr]
GO




-- create synonyms for objects in the abm_2 database -------------------------
-- views ---------------------------------------------------------------------
DROP SYNONYM IF EXISTS [dimension].[escort_stop_type_destination]
GO
CREATE SYNONYM [dimension].[escort_stop_type_destination]
FOR [abm_2].[dimension].[escort_stop_type_destination]
GO

DROP SYNONYM IF EXISTS [dimension].[escort_stop_type_origin]
GO
CREATE SYNONYM [dimension].[escort_stop_type_origin]
FOR [abm_2].[dimension].[escort_stop_type_origin]
GO

DROP SYNONYM IF EXISTS [dimension].[geography_household_location]
GO
CREATE SYNONYM [dimension].[geography_household_location]
FOR [abm_2].[dimension].[geography_household_location]
GO

DROP SYNONYM IF EXISTS [dimension].[geography_parking_destination]
GO
CREATE SYNONYM [dimension].[geography_parking_destination]
FOR [abm_2].[dimension].[geography_parking_destination]
GO

DROP SYNONYM IF EXISTS [dimension].[geography_school_location]
GO
CREATE SYNONYM [dimension].[geography_school_location]
FOR [abm_2].[dimension].[geography_school_location]
GO

DROP SYNONYM IF EXISTS [dimension].[geography_tour_destination]
GO
CREATE SYNONYM [dimension].[geography_tour_destination]
FOR [abm_2].[dimension].[geography_tour_destination]
GO

DROP SYNONYM IF EXISTS [dimension].[geography_tour_origin]
GO
CREATE SYNONYM [dimension].[geography_tour_origin]
FOR [abm_2].[dimension].[geography_tour_origin]
GO

DROP SYNONYM IF EXISTS [dimension].[geography_trip_destination]
GO
CREATE SYNONYM [dimension].[geography_trip_destination]
FOR [abm_2].[dimension].[geography_trip_destination]
GO

DROP SYNONYM IF EXISTS [dimension].[geography_trip_origin]
GO
CREATE SYNONYM [dimension].[geography_trip_origin]
FOR [abm_2].[dimension].[geography_trip_origin]
GO

DROP SYNONYM IF EXISTS [dimension].[geography_work_location]
GO
CREATE SYNONYM [dimension].[geography_work_location]
FOR [abm_2].[dimension].[geography_work_location]
GO

DROP SYNONYM IF EXISTS [dimension].[mode_airport_arrival]
GO
CREATE SYNONYM [dimension].[mode_airport_arrival]
FOR [abm_2].[dimension].[mode_airport_arrival]
GO

DROP SYNONYM IF EXISTS [dimension].[mode_tour]
GO
CREATE SYNONYM [dimension].[mode_tour]
FOR [abm_2].[dimension].[mode_tour]
GO

DROP SYNONYM IF EXISTS [dimension].[mode_transit]
GO
CREATE SYNONYM [dimension].[mode_transit]
FOR [abm_2].[dimension].[mode_transit]
GO

DROP SYNONYM IF EXISTS [dimension].[mode_transit_access]
GO
CREATE SYNONYM [dimension].[mode_transit_access]
FOR [abm_2].[dimension].[mode_transit_access]
GO

DROP SYNONYM IF EXISTS [dimension].[mode_transit_route]
GO
CREATE SYNONYM [dimension].[mode_transit_route]
FOR [abm_2].[dimension].[mode_transit_route]
GO

DROP SYNONYM IF EXISTS [dimension].[mode_trip]
GO
CREATE SYNONYM [dimension].[mode_trip]
FOR [abm_2].[dimension].[mode_trip]
GO

DROP SYNONYM IF EXISTS [dimension].[model_tour]
GO
CREATE SYNONYM [dimension].[model_tour]
FOR [abm_2].[dimension].[model_tour]
GO

DROP SYNONYM IF EXISTS [dimension].[model_trip]
GO
CREATE SYNONYM [dimension].[model_trip]
FOR [abm_2].[dimension].[model_trip]
GO

DROP SYNONYM IF EXISTS [dimension].[purpose_tour]
GO
CREATE SYNONYM [dimension].[purpose_tour]
FOR [abm_2].[dimension].[purpose_tour]
GO

DROP SYNONYM IF EXISTS [dimension].[purpose_trip_destination]
GO
CREATE SYNONYM [dimension].[purpose_trip_destination]
FOR [abm_2].[dimension].[purpose_trip_destination]
GO

DROP SYNONYM IF EXISTS [dimension].[purpose_trip_origin]
GO
CREATE SYNONYM [dimension].[purpose_trip_origin]
FOR [abm_2].[dimension].[purpose_trip_origin]
GO

DROP SYNONYM IF EXISTS [dimension].[time_tour_end]
GO
CREATE SYNONYM [dimension].[time_tour_end]
FOR [abm_2].[dimension].[time_tour_end]
GO

DROP SYNONYM IF EXISTS [dimension].[time_tour_start]
GO
CREATE SYNONYM [dimension].[time_tour_start]
FOR [abm_2].[dimension].[time_tour_start]
GO

DROP SYNONYM IF EXISTS [dimension].[time_trip_end]
GO
CREATE SYNONYM [dimension].[time_trip_end]
FOR [abm_2].[dimension].[time_trip_end]
GO

DROP SYNONYM IF EXISTS [dimension].[time_trip_start]
GO
CREATE SYNONYM [dimension].[time_trip_start]
FOR [abm_2].[dimension].[time_trip_start]
GO