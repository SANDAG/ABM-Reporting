import pyodbc
import sqlalchemy
import urllib
import pandas as pd

# create dictionary of ABM SQL database scenario ids and the corresponding
# scenario label they map to within the Performance Measure template
# possible labels: 2016, 2025nb, 2035nb, 2050nb, 2025build, 2035build, 2050build
scenarios = {
    # example 582: "2016" TODO: enter scenarios
}

# set path to write Performance Measure workbook
# example: "C:/Users/gsc/Desktop/"
templateWritePath = ''  # TODO: enter path

# set SQL Server connection attributes
sqlAttributes = {
    "ABM-Reporting": {
        "server": "",  # TODO: enter SQL server
        "database": ""  # TODO: enter database
    },
    "GIS": {
        "server": "",  # TODO: enter SQL server
        "database": ""  # TODO: enter database
    }
}

# list of CMCP corridors
cmcp_corridor = [
    "Coast, Canyons, and Trails",
    "North County",
    "San Vicente",
    "South Bay to Sorrento",
    "Region"
]

# map scenario labels to template sheet columns
# Sheet: (Scenario Label)
template_columns = {
    "Primary Measures": {
        "2016": 5,
        "2025nb": 6,
        "2035nb": 7,
        "2050nb": 8,
        "2025build": 9,
        "2035build": 10,
        "2050build": 11
    }
}

# create SQL Server connection strings
connStrings = {
    "ABM-Reporting": "DRIVER={SQL Server Native Client 11.0};SERVER=" +
                     sqlAttributes["ABM-Reporting"]["server"] +
                     ";DATABASE=" + sqlAttributes["ABM-Reporting"]["database"]
                     + ";Trusted_Connection=yes;",
    "GIS": "DRIVER={SQL Server Native Client 11.0};SERVER=" +
                     sqlAttributes["GIS"]["server"] +
                     ";DATABASE=" + sqlAttributes["GIS"]["database"]
                     + ";Trusted_Connection=yes;"
}

# create SQL alchemy engines using pyodbc sql server connection
pyodbc.pooling = False
engines = {
    "ABM-Reporting": sqlalchemy.create_engine(
        "mssql+pyodbc:///?odbc_connect=%s" %
        urllib.parse.quote_plus(connStrings["ABM-Reporting"])),
    "GIS": sqlalchemy.create_engine(
        "mssql+pyodbc:///?odbc_connect=%s" %
        urllib.parse.quote_plus(connStrings["GIS"]))
}


# dictionary of SQL-based performance measures
# Measure: (sp, args)
sql_measures = {
    "CMCP Mode Share": {
        "sp": "[cmcp_2021].[sp_mode_share]",
        "args": "@scenario_id={},@update=1,@silent=1,@work=0,@distance_threshold=0"
    },
    "CMCP Mode Share - Work Trips": {
        "sp": "[cmcp_2021].[sp_mode_share]",
        "args": "@scenario_id={},@update=1,@silent=1,@work=1,@distance_threshold=0"
    },
    "CMCP Mode Share - Trips Under 3 Miles": {
        "sp": "[cmcp_2021].[sp_mode_share]",
        "args": "@scenario_id={},@update=1,@silent=1,@work=0,@distance_threshold=3"
    },
    "Bike and pedestrian miles travelled": {
        "sp": "[cmcp_2021].[sp_bmt_pmt]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "Daily vehicle hours of delay": {
        "sp": "[cmcp_2021].[sp_vhd]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "Link VMT": {
        "sp": "[cmcp_2021].[sp_link_vmt]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "Daily all vehicle delay per capita": {
        "sp": "[cmcp_2021].[sp_vehicle_delay_per_capita]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "Average Commute Time to Work": {
        "sp": "[cmcp_2021].[sp_commute_time]",
        "args": "@scenario_id={},@peak_period=1,@update=1,@silent=1"
    },
    "Percent of pop with 20 mins of transport": {
        "sp": "[cmcp_2021].[sp_physical_activity]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "VMT per employee": {
        "sp": "[cmcp_2021].[sp_resident_vmt]",
        "args": "@scenario_id={},@workers=1,@home_location=0,@work_location=1,@update=1,@silent=1"
    },
    "VMT per capita": {
        "sp": "[cmcp_2021].[sp_resident_vmt]",
        "args": "@scenario_id={},@workers=0,@home_location=1,@work_location=0,@update=1,@silent=1"
    }
}

# dictionary of Python-based performance measures
# Measure: Metric: (method, args: (specific arguments))
python_measures = {
    "Tier 1 Employment Center - 30 Minutes": {
        "Transit":
            {"method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 1",
                 "max_time": 30,
                 "age_18_plus": 1}
             }
    },
    "Tier 2 Employment Center - 30 Minutes": {
        "Transit":
            {"method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 2",
                 "max_time": 30,
                 "age_18_plus": 1}
             }
    },
    "Higher Education - 30 Minutes": {
        "Transit":
            {"method": "calc_transit_access",
             "args": {
                 "criteria": "higherLearningEnrollment > 0",
                 "max_time": 30,
                 "age_18_plus": 1}
             }
    },
    "Tier 1 Employment Center - 45 Minutes": {
        "Transit":
            {"method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 1",
                 "max_time": 45,
                 "age_18_plus": 1}
             }
    },
    "Tier 2 Employment Center - 45 Minutes": {
        "Transit":
            {"method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 2",
                 "max_time": 45,
                 "age_18_plus": 1}
             }
    },
    "Higher Education - 45 Minutes": {
        "Transit":
            {"method": "calc_transit_access",
             "args": {
                 "criteria": "higherLearningEnrollment > 0",
                 "max_time": 45,
                 "age_18_plus": 1}
             }
    }
}
