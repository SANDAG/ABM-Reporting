import pyodbc
import sqlalchemy
import urllib
import yaml

# create dictionary of ABM SQL database scenario ids and the corresponding
# scenario label they map to within the Performance Measure template
# possible labels: 2016, 2025nb, 2035nb, 2050nb, 2025build, 2035build, 2050build

scenarios = {
    #186: "2016_Base",                   # 2016 Base
    142: "2050_nb",                     # 2050 No Build
    267: "2050_Vision",                 # 2050 Vision
    261: "2050_i8_nb",                  # 2050 i8 nb
    266: "2050_i8_alt1",                # 2050 i8 alt1
    265: "2050_i8_alt2",                # 2050 i8 alt2
    #xxx: "2021_rp_b_2035b",       # Regional Plan Build (DS38) - 2035
    #459: "2021_rp_b_2050b",        # Regional Plan Build (DS38) - 2050
    #631: "nc_nb_ds39_2050",        # North County CMCP No Build DS39 - 2050
    #630: "nc_nb_ds38_2050",        # North County CMCP No Build DS38 - 2050
    #668: "nc_alt1_ds39_2050",      # North County CMCP Alt 1 DS39 - 2050
    #667: "nc_alt1_ds38_2050",       # North County CMCP Alt 1 DS38 - 2050
    #736: "nc_alt1_ds38_2050_mod"    # North County CMCP Alt 1 DS38 - 2050 Modified
    
}

# map scenario labels to template sheet columns
# Sheet: (Scenario Label)
# scenario label needs to be consistent with those in the scenarios dictionary
template_columns = {
    "Primary Measures": {
        #"2016": 5,
        "2050_nb": 6,
        "2050_Vision": 7,
        "2050_i8_nb": 8,
        "2050_i8_alt1": 9,
        "2050_i8_alt2": 10,
        #"2021_rp_b_2050b": 11,
		#"nc_nb_ds39_2050": 14,
        #"nc_nb_ds38_2050": 17,
        #"nc_alt1_ds39_2050": 20,
        #"nc_alt1_ds38_2050": 23
        #"nc_alt1_ds38_2050_mod": 24
    }
}

# List of CMCP corridors
cmcp_corridor = [
    #"Coast, Canyons, and Trails",
    #"North County"
    #"San Vicente",
    #"South Bay to Sorrento"
    "Kumeyaay",
    "Region"
    ]

# set path to write output Performance Measure workbook
# example format: C:/Users/gsc/Desktop/PerformanceMeasures_{cmcp_corridor}.xlsx
templateWritePath = r"..\..\CMCP_PerformanceMeasures_"

# set path to input Performance Measure workbook Template
template_path = r"..\..\resources\cmcp\input\CMCP_PerformanceMeasures_Template.xlsx"

# set path to input list of performance measure outputs and locations to write into Excel template
template_locations_path = r"..\..\resources\cmcp\input\template_location.csv"

# get SQL server attributes from local file
with open("../../resources/cmcp/database-specs.yaml", "r", encoding="utf8") as stream:
    try:
        db_info = yaml.safe_load(stream)
    except yaml.YAMLError as exc:
        print(exc)

# set SQL Server connection attributes
sqlAttributes = {
    "ABM-Reporting": {
        "server": db_info['server1']['name'],
        "database": db_info['server1']['db1_1']
    },
    "GIS": {
        "server": db_info['server2']['name'],
        "database": db_info['server2']['db2_1']
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

database = db_info['server1']['db1_1']

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
        "sp": "[cmcp].[sp_mode_share]",
        "args": "@scenario_id={},@update=1,@silent=1,@work=0,@distance_threshold=0"
    },
    "CMCP Mode Share - Work Trips": {
        "sp": "[cmcp].[sp_mode_share]",
        "args": "@scenario_id={},@update=1,@silent=1,@work=1,@distance_threshold=0"
    },
    "CMCP Mode Share - Trips Under 3 Miles": {
        "sp": "[cmcp].[sp_mode_share]",
        "args": "@scenario_id={},@update=1,@silent=1,@work=0,@distance_threshold=3"
    },
    "Bike and pedestrian miles travelled": {
        "sp": "[cmcp].[sp_bmt_pmt]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "Daily vehicle hours of delay": {
        "sp": "[cmcp].[sp_vhd]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "Link VMT": {
        "sp": "[cmcp].[sp_link_vmt]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "Daily all vehicle delay per capita": {
        "sp": "[cmcp].[sp_vehicle_delay_per_capita]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "Average Commute Time to Work": {
        "sp": "[cmcp].[sp_commute_time]",
        "args": "@scenario_id={},@peak_period=1,@update=1,@silent=1"
    },
    "Percent of pop with 20 mins of transport": {
        "sp": "[cmcp].[sp_physical_activity]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "VMT per employee": {
        "sp": "[cmcp].[sp_resident_vmt]",
        "args": "@scenario_id={},@workers=1, @home_location=0, @work_location=1, @update=1,@silent=1"
    },
    "VMT per capita": {
        "sp": "[cmcp].[sp_resident_vmt]",
        "args": "@scenario_id={},@workers=0, @home_location=1, @work_location=0, @update=1,@silent=1"
    },
    "Screenline person throughput by Auto": {
        "sp": "[cmcp].[sp_screenline_auto_personThroughput]",
        "args": "@scenario_id={},@peak_period=0, @update=1, @silent=1"
    },
    "Screenline person throughput by Transit": {
        "sp": "[cmcp].[sp_screenline_transit_personThroughput]",
        "args": "@scenario_id={},@peak_period=0, @update=1, @silent=1"
    }
}

# dictionary of Python-based performance measure
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