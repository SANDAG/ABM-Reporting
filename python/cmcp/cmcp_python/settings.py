import pyodbc
import sqlalchemy
import urllib
import pandas as pd

# create dictionary of ABM SQL database scenario ids and the corresponding
# scenario label they map to within the Performance Measure template
# possible labels: 2016, 2025nb, 2035nb, 2050nb, 2025build, 2035build, 2050build
scenarios = {

    606: "2035nb",
    607: "2035build",
    608: "2035_sb2s_nb"

}

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
        "2050build": 11,
		"2035_sb2s_nb": 13
    }
}

# List of CMCP corridors
cmcp_corridor = ["Coast, Canyons, and Trails", "North County", "San Vicente", "South Bay to Sorrento", "Region"]

# set path to write Performance Measure workbook
# example format: C:/Users/gsc/Desktop/PerformanceMeasures.xlsx
templateWritePath = r"T:\projects\sr14\OWP\CMCP\i805_purple_line\analysis\ABM-Reporting-master\CMCP_PerformanceMeasures_"

# set path to Performance Measure workbook Template
template_path = r"T:\projects\sr14\OWP\CMCP\i805_purple_line\analysis\ABM-Reporting-master\resources\cmcp\input\CMCP_PerformanceMeasures_Template.xlsx"

# list of performance measure outputs
# and locations to write into Excel template
# Measure, Metric, sheet, row
template_locations_path = r"T:\projects\sr14\OWP\CMCP\i805_purple_line\analysis\ABM-Reporting-master\resources\cmcp\input\template_location.csv"

# set SQL Server connection attributes
sqlAttributes = {
    "ABM-Reporting": {
        "server": "DDAMWSQL16",
        "database": "ws"
    },
    "GIS": {
        "server": "sql2014b8",
        "database": "CMCP"
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

# dictionary of Python-based performance measures
# Measure: Metric: (class, method, args: (specific arguments))
# python_measures = {
#     "M-1-a": {
#         "Bike":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "empRetail > 0",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": False,
#                  "access_cols": ["bikeTime"]}
#              },
#         "Bike + Walk + MM + MT":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "empRetail > 0",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": False,
#                  "access_cols": ["bikeTime", "walkTime", "mmTime", "mtTime"]}
#              },
#         "Drive Alone":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_drive_access",
#              "args": {
#                  "criteria": "empRetail > 0",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": False,
#                  "matrix": "MD_SOV_NT_L"}
#              },
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "empRetail > 0",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": False,
#                  "tod": "MD"}
#              },
#         "Walk":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "empRetail > 0",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": False,
#                  "access_cols": ["walkTime"]}
#              },
#         "Walk + MM + MT":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "empRetail > 0",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": False,
#                  "access_cols": ["walkTime", "mmTime", "mtTime"]}
#              }
#     },
#     "M-1-a - Mobility Hubs": {
#         "Bike":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "empRetail > 0",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": True,
#                  "access_cols": ["bikeTime"]}
#              },
#         "Bike + Walk + MM + MT":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "empRetail > 0",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": True,
#                  "access_cols": ["bikeTime", "walkTime", "mmTime", "mtTime"]}
#              },
#         "Drive Alone":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_drive_access",
#              "args": {
#                  "criteria": "empRetail > 0",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": True,
#                  "matrix": "MD_SOV_NT_L"}
#              },
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "empRetail > 0",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": True,
#                  "tod": "MD"}
#              },
#         "Walk":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "empRetail > 0",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": True,
#                  "access_cols": ["walkTime"]}
#              },
#         "Walk + MM + MT":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "empRetail > 0",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": True,
#                  "access_cols": ["walkTime", "mmTime", "mtTime"]}
#              }
#     },
#     "M-1-b": {
#         "Bike":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "parkActive >= .5",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": False,
#                  "access_cols": ["bikeTime"]}
#              },
#         "Bike + Walk + MM + MT":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "parkActive >= .5",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": False,
#                  "access_cols": ["bikeTime", "walkTime", "mmTime", "mtTime"]}
#              },
#         "Drive Alone":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_drive_access",
#              "args": {
#                  "criteria": "parkActive >= .5",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": False,
#                  "matrix": "MD_SOV_NT_L"}
#              },
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "parkActive >= .5",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": False,
#                  "tod": "MD"}
#              },
#         "Walk":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "parkActive >= .5",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": False,
#                  "access_cols": ["walkTime"]}
#              },
#         "Walk + MM + MT":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "parkActive >= .5",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": False,
#                  "access_cols": ["walkTime", "mmTime", "mtTime"]}
#              }
#     },
#     "M-1-b - Mobility Hubs": {
#         "Bike":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "parkActive >= .5",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": True,
#                  "access_cols": ["bikeTime"]}
#              },
#         "Bike + Walk + MM + MT":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "parkActive >= .5",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": True,
#                  "access_cols": ["bikeTime", "walkTime", "mmTime", "mtTime"]}
#              },
#         "Drive Alone":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_drive_access",
#              "args": {
#                  "criteria": "parkActive >= .5",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": True,
#                  "matrix": "MD_SOV_NT_L"}
#              },
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "parkActive >= .5",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": True,
#                  "tod": "MD"}
#              },
#         "Walk":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "parkActive >= .5",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": True,
#                  "access_cols": ["walkTime"]}
#              },
#         "Walk + MM + MT":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_bike_walk_access",
#              "args": {
#                  "criteria": "parkActive >= .5",
#                  "max_time": 15,
#                  "over18": False,
#                  "mobility_hub": True,
#                  "access_cols": ["walkTime", "mmTime", "mtTime"]}
#              }
#     },
#     "M-1-c": {
#         "Drive Alone":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_drive_access",
#              "args": {
#                  "criteria": "empHealth > 0",
#                  "max_time": 30,
#                  "over18": False,
#                  "mobility_hub": False,
#                  "matrix": "MD_SOV_NT_L"}
#              },
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "empHealth > 0",
#                  "max_time": 30,
#                  "over18": False,
#                  "mobility_hub": False,
#                  "tod": "MD"}
#              }
#     },
#     "M-1-c - Mobility Hubs": {
#         "Drive Alone":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_drive_access",
#              "args": {
#                  "criteria": "empHealth > 0",
#                  "max_time": 30,
#                  "over18": False,
#                  "mobility_hub": True,
#                  "matrix": "MD_SOV_NT_L"}
#              },
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "empHealth > 0",
#                  "max_time": 30,
#                  "over18": False,
#                  "mobility_hub": True,
#                  "tod": "MD"}
#              }
#     },
#     "M-5-a - 30 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "employmentCenterTier == 1",
#                  "max_time": 30,
#                  "over18": True,
#                  "mobility_hub": False,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-a - Mobility Hubs - 30 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "employmentCenterTier == 1",
#                  "max_time": 30,
#                  "over18": True,
#                  "mobility_hub": True,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-a - 45 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "employmentCenterTier == 1",
#                  "max_time": 45,
#                  "over18": True,
#                  "mobility_hub": False,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-a - Mobility Hubs - 45 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "employmentCenterTier == 1",
#                  "max_time": 45,
#                  "over18": True,
#                  "mobility_hub": True,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-b - 30 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "employmentCenterTier == 2",
#                  "max_time": 30,
#                  "over18": True,
#                  "mobility_hub": False,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-b - Mobility Hubs - 30 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "employmentCenterTier == 2",
#                  "max_time": 30,
#                  "over18": True,
#                  "mobility_hub": True,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-b - 45 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "employmentCenterTier == 2",
#                  "max_time": 45,
#                  "over18": True,
#                  "mobility_hub": False,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-b - Mobility Hubs - 45 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "employmentCenterTier == 2",
#                  "max_time": 45,
#                  "over18": True,
#                  "mobility_hub": True,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-c - 30 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "employmentCenterTier > 0",
#                  "max_time": 30,
#                  "over18": True,
#                  "mobility_hub": False,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-c - Mobility Hubs - 30 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "employmentCenterTier > 0",
#                  "max_time": 30,
#                  "over18": True,
#                  "mobility_hub": True,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-c - 45 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "employmentCenterTier > 0",
#                  "max_time": 45,
#                  "over18": True,
#                  "mobility_hub": False,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-c - Mobility Hubs - 45 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "employmentCenterTier > 0",
#                  "max_time": 45,
#                  "over18": True,
#                  "mobility_hub": True,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-d - 30 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "higherLearningEnrollment > 0",
#                  "max_time": 30,
#                  "over18": True,
#                  "mobility_hub": False,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-d - Mobility Hubs - 30 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "higherLearningEnrollment > 0",
#                  "max_time": 30,
#                  "over18": True,
#                  "mobility_hub": True,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-d - 45 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "higherLearningEnrollment > 0",
#                  "max_time": 45,
#                  "over18": True,
#                  "mobility_hub": False,
#                  "tod": "AM"}
#              }
#     },
#     "M-5-d - Mobility Hubs - 45 minutes": {
#         "Transit - Speed One":
#             {"class": "PerformanceMeasuresM1M5",
#              "method": "calc_transit_access",
#              "args": {
#                  "criteria": "higherLearningEnrollment > 0",
#                  "max_time": 45,
#                  "over18": True,
#                  "mobility_hub": True,
#                  "tod": "AM"}
#              }
#     }
# }

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
        "args": "@scenario_id={},@workers=1, @home_location=0, @work_location=1, @update=1,@silent=1"
    },
    "VMT per capita": {
        "sp": "[cmcp_2021].[sp_resident_vmt]",
        "args": "@scenario_id={},@workers=0, @home_location=1, @work_location=0, @update=1,@silent=1"
    }
}



