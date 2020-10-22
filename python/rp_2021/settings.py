import pyodbc
import sqlalchemy
import urllib

# create dictionary of ABM SQL database scenario ids and the corresponding
# scenario label they map to within the Performance Measure template
# possible labels: 2016, 2025nb, 2035nb, 2050nb, 2025build, 2035build, 2050build
scenarios = {
    # 1: "2035build"  example format
}

# set path to write Performance Measure workbook
# example format: C:/Users/gsc/Desktop/PerformanceMeasures.xlsx
templateWritePath = ""

# set SQL Server connection attributes
server = ""
database = ""

# map scenario labels to template sheet columns
# Sheet: (Scenario Label)
template_columns = {
    "PrimaryMeasures": {
        "2016": 4,
        "2025nb": 5,
        "2035nb": 6,
        "2050nb": 7,
        "2025build": 8,
        "2035build": 9,
        "2050build": 10
    },
    "Social Equity PMs": {
        "2016": 4,
        "2025nb": 5,
        "2035nb": 6,
        "2050nb": 7,
        "2025build": 8,
        "2035build": 9,
        "2050build": 10
    },
    "SupportingMeasures": {
        "2016": 4,
        "2025nb": 5,
        "2035nb": 6,
        "2050nb": 7,
        "2025build": 8,
        "2035build": 9,
        "2050build": 10
    },
    "SB375 Data Table": {
        "2016": 3,
        "2035nb": 5,
        "2050nb": 7,
        "2035build": 6,
        "2050build": 8
    }
}

# create SQL Server connection string
connString = "DRIVER={SQL Server Native Client 11.0};SERVER=" + \
             server + ";DATABASE=" + database + ";Trusted_Connection=yes;"

# create SQL alchemy engine using pyodbc sql server connection
pyodbc.pooling = False
params = urllib.parse.quote_plus(connString)
engine = sqlalchemy.create_engine("mssql+pyodbc:///?odbc_connect=%s" % params)

# dictionary of Python-based performance measures
# Measure: Metric: (class, method, args: (specific arguments))
python_measures = {
    "M-1-a": {
        "Bike":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": False,
                 "access_cols": ["bikeTime"]}
             },
        "Bike + Walk + MM + MT":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": False,
                 "access_cols": ["bikeTime", "walkTime", "mmTime", "mtTime"]}
             },
        "Drive Alone":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_drive_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": False,
                 "matrix": "MD_SOV_NT_L"}
             },
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": False,
                 "tod": "MD"}
             },
        "Walk":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": False,
                 "access_cols": ["walkTime"]}
             },
        "Walk + MM + MT":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": False,
                 "access_cols": ["walkTime", "mmTime", "mtTime"]}
             }
    },
    "M-1-a - Mobility Hubs": {
        "Bike":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": True,
                 "access_cols": ["bikeTime"]}
             },
        "Bike + Walk + MM + MT":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": True,
                 "access_cols": ["bikeTime", "walkTime", "mmTime", "mtTime"]}
             },
        "Drive Alone":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_drive_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": True,
                 "matrix": "MD_SOV_NT_L"}
             },
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": True,
                 "tod": "MD"}
             },
        "Walk":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": True,
                 "access_cols": ["walkTime"]}
             },
        "Walk + MM + MT":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": True,
                 "access_cols": ["walkTime", "mmTime", "mtTime"]}
             }
    },
    "M-1-b": {
        "Bike":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": False,
                 "access_cols": ["bikeTime"]}
             },
        "Bike + Walk + MM + MT":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": False,
                 "access_cols": ["bikeTime", "walkTime", "mmTime", "mtTime"]}
             },
        "Drive Alone":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_drive_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": False,
                 "matrix": "MD_SOV_NT_L"}
             },
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": False,
                 "tod": "MD"}
             },
        "Walk":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": False,
                 "access_cols": ["walkTime"]}
             },
        "Walk + MM + MT":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": False,
                 "access_cols": ["walkTime", "mmTime", "mtTime"]}
             }
    },
    "M-1-b - Mobility Hubs": {
        "Bike":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": True,
                 "access_cols": ["bikeTime"]}
             },
        "Bike + Walk + MM + MT":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": True,
                 "access_cols": ["bikeTime", "walkTime", "mmTime", "mtTime"]}
             },
        "Drive Alone":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_drive_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": True,
                 "matrix": "MD_SOV_NT_L"}
             },
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": True,
                 "tod": "MD"}
             },
        "Walk":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": True,
                 "access_cols": ["walkTime"]}
             },
        "Walk + MM + MT":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": True,
                 "access_cols": ["walkTime", "mmTime", "mtTime"]}
             }
    },
    "M-1-c": {
        "Drive Alone":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_drive_access",
             "args": {
                 "criteria": "empHealth > 0",
                 "max_time": 30,
                 "over18": False,
                 "mobility_hub": False,
                 "matrix": "MD_SOV_NT_L"}
             },
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "empHealth > 0",
                 "max_time": 30,
                 "over18": False,
                 "mobility_hub": False,
                 "tod": "MD"}
             }
    },
    "M-1-c - Mobility Hubs": {
        "Drive Alone":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_drive_access",
             "args": {
                 "criteria": "empHealth > 0",
                 "max_time": 30,
                 "over18": False,
                 "mobility_hub": True,
                 "matrix": "MD_SOV_NT_L"}
             },
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "empHealth > 0",
                 "max_time": 30,
                 "over18": False,
                 "mobility_hub": True,
                 "tod": "MD"}
             }
    },
    "M-5-a - 30 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 1",
                 "max_time": 30,
                 "over18": True,
                 "mobility_hub": False,
                 "tod": "AM"}
             }
    },
    "M-5-a - Mobility Hubs - 30 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 1",
                 "max_time": 30,
                 "over18": True,
                 "mobility_hub": True,
                 "tod": "AM"}
             }
    },
    "M-5-a - 45 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 1",
                 "max_time": 45,
                 "over18": True,
                 "mobility_hub": False,
                 "tod": "AM"}
             }
    },
    "M-5-a - Mobility Hubs - 45 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 1",
                 "max_time": 45,
                 "over18": True,
                 "mobility_hub": True,
                 "tod": "AM"}
             }
    },
    "M-5-b - 30 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 2",
                 "max_time": 30,
                 "over18": True,
                 "mobility_hub": False,
                 "tod": "AM"}
             }
    },
    "M-5-b - Mobility Hubs - 30 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 2",
                 "max_time": 30,
                 "over18": True,
                 "mobility_hub": True,
                 "tod": "AM"}
             }
    },
    "M-5-b - 45 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 2",
                 "max_time": 45,
                 "over18": True,
                 "mobility_hub": False,
                 "tod": "AM"}
             }
    },
    "M-5-b - Mobility Hubs - 45 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 2",
                 "max_time": 45,
                 "over18": True,
                 "mobility_hub": True,
                 "tod": "AM"}
             }
    },
    "M-5-c - 30 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "higherLearningEnrollment > 0",
                 "max_time": 30,
                 "over18": True,
                 "mobility_hub": False,
                 "tod": "AM"}
             }
    },
    "M-5-c - Mobility Hubs - 30 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "higherLearningEnrollment > 0",
                 "max_time": 30,
                 "over18": True,
                 "mobility_hub": True,
                 "tod": "AM"}
             }
    },
    "M-5-c - 45 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "higherLearningEnrollment > 0",
                 "max_time": 45,
                 "over18": True,
                 "mobility_hub": False,
                 "tod": "AM"}
             }
    },
    "M-5-c - Mobility Hubs - 45 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "higherLearningEnrollment > 0",
                 "max_time": 45,
                 "over18": True,
                 "mobility_hub": True,
                 "tod": "AM"}
             }
    },
    "M-5-d - 30 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier > 0",
                 "max_time": 30,
                 "over18": True,
                 "mobility_hub": False,
                 "tod": "AM"}
             }
    },
    "M-5-d - Mobility Hubs - 30 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier > 0",
                 "max_time": 30,
                 "over18": True,
                 "mobility_hub": True,
                 "tod": "AM"}
             }
    },
    "M-5-d - 45 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier > 0",
                 "max_time": 45,
                 "over18": True,
                 "mobility_hub": False,
                 "tod": "AM"}
             }
    },
    "M-5-d - Mobility Hubs - 45 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier > 0",
                 "max_time": 45,
                 "over18": True,
                 "mobility_hub": True,
                 "tod": "AM"}
             }
    }
}

# dictionary of SQL-based performance measures
# Measure: (sp, args)
sql_measures = {
    "M-4": {
        "sp": "[rp_2021].[sp_pm_m4]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "SM-1 - Peak Period Outbound Work Trips": {
        "sp": "[rp_2021].[sp_pm_sm1]",
        "args": "@scenario_id={},@update=1,@silent=1,@work=1,@peak_period=1"
    },
    "SM-1 - Outbound Work Trips": {
        "sp": "[rp_2021].[sp_pm_sm1]",
        "args": "@scenario_id={},@update=1,@silent=1,@work=1,@peak_period=0"
    },
    "SM-1 - All Trips": {
        "sp": "[rp_2021].[sp_pm_sm1]",
        "args": "@scenario_id={},@update=1,@silent=1,@work=0,@peak_period=0"
    },
    "SM-5": {
        "sp": "[rp_2021].[sp_pm_sm5]",
        "args": "@scenario_id={},@update=1,@silent=1,@mobilityHubs=0"
    },
    "SM-5 Mobility Hubs": {
        "sp": "[rp_2021].[sp_pm_sm5]",
        "args": "@scenario_id={},@update=1,@silent=1,@mobilityHubs=1"
    },
    "SM-6 Transportation-Related Physical Activity per Capita": {
        "sp": "[rp_2021].[sp_pm_sm6_activity]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "SM-6 Percentage of Population Engaged in Transportation-Related Physical Activity": {
        "sp": "[rp_2021].[sp_pm_sm6_pct]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "SM-7": {
        "sp": "[rp_2021].[sp_pm_sm7]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "SM-9-a": {
        "sp": "[rp_2021].[sp_pm_sm9a]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "SM-9-b": {
        "sp": "[rp_2021].[sp_pm_sm9b]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "SM-10": {
        "sp": "[rp_2021].[sp_pm_sm10]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "SB375 - Auto Ownership": {
        "sp": "[rp_2021].[sp_sb375_auto_ownership]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "SB375 - Housing Structures": {
        "sp": "[rp_2021].[sp_sb375_housing_structures]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "SB375 - Jobs": {
        "sp": "[rp_2021].[sp_sb375_jobs]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "SB375 - Median Household Income": {
        "sp": "[rp_2021].[sp_sb375_median_income]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "SB375 - Average Trip Length by Mode": {
        "sp": "[rp_2021].[sp_sb375_mode_measures]",
        "args": "@scenario_id={},@measure='distance',@low_income=0,@update=1,@silent=1"
    },
    "SB375 - Average Trip Time by Mode": {
        "sp": "[rp_2021].[sp_sb375_mode_measures]",
        "args": "@scenario_id={},@measure='time',@low_income=0,@update=1,@silent=1"
    },
    "SB375 - Average Trip Time by Mode for Low Income Residents": {
        "sp": "[rp_2021].[sp_sb375_mode_measures]",
        "args": "@scenario_id={},@measure='time',@low_income=1,@update=1,@silent=1"
    },
    "SB375 - Mode Share": {
        "sp": "[rp_2021].[sp_sb375_mode_measures]",
        "args": "@scenario_id={},@measure='share',@low_income=0,@update=1,@silent=1"
    },
    "SB375 - Population": {
        "sp": "[rp_2021].[sp_sb375_population]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "SB375 - Seat Utilization": {
        "sp": "[rp_2021].[sp_sb375_seat_utilization]",
        "args": "@scenario_id={},@update=1,@silent=1"
    },
    "SB375 - Travel Time by Purpose": {
        "sp": "[rp_2021].[sp_sb375_travel_time_purpose]",
        "args": "@scenario_id={},@update=1,@silent=1"
    }
}

# dictionary of performance measure outputs
# and locations to write into Excel template
# Measure: Metric: (sheet, row)
template_locations = {
    "M-1-a": {
        "Population Access Pct - Walk": {
            "sheet": "PrimaryMeasures",
            "row": 5
        },
        "Population Access Pct - Bike": {
            "sheet": "PrimaryMeasures",
            "row": 6
        },
        "Population Access Pct - Walk + MM + MT": {
            "sheet": "PrimaryMeasures",
            "row": 7
        },
        "Population Access Pct - Bike + Walk + MM + MT": {
            "sheet": "PrimaryMeasures",
            "row": 8
        },
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 9
        },
        "Population Access Pct - Drive Alone": {
            "sheet": "PrimaryMeasures",
            "row": 10
        },
        "Low Income Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 6
        },
        "Low Income Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 7
        },
        "Low Income Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 8
        },
        "Low Income Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 9
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 10
        },
        "Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 11
        },
        "Non-Low Income Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 19
        },
        "Non-Low Income Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 20
        },
        "Non-Low Income Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 21
        },
        "Non-Low Income Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 22
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 23
        },
        "Non-Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 24
        },
        "Minority Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 32
        },
        "Minority Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 33
        },
        "Minority Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 34
        },
        "Minority Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 35
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 36
        },
        "Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 37
        },
        "Non-Minority Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 45
        },
        "Non-Minority Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 46
        },
        "Non-Minority Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 47
        },
        "Non-Minority Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 48
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 49
        },
        "Non-Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 50
        },
        "Senior Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 58
        },
        "Senior Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 59
        },
        "Senior Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 60
        },
        "Senior Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 61
        },
        "Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 62
        },
        "Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 63
        },
        "Non-Senior Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 71
        },
        "Non-Senior Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 72
        },
        "Non-Senior Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 73
        },
        "Non-Senior Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 74
        },
        "Non-Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 75
        },
        "Non-Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 76
        }
    },
    "M-1-a - Mobility Hubs": {
        "Population Access Pct - Walk": {
            "sheet": "PrimaryMeasures",
            "row": 11
        },
        "Population Access Pct - Bike": {
            "sheet": "PrimaryMeasures",
            "row": 12
        },
        "Population Access Pct - Walk + MM + MT": {
            "sheet": "PrimaryMeasures",
            "row": 13
        },
        "Population Access Pct - Bike + Walk + MM + MT": {
            "sheet": "PrimaryMeasures",
            "row": 14
        },
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 15
        },
        "Population Access Pct - Drive Alone": {
            "sheet": "PrimaryMeasures",
            "row": 16
        },
        "Low Income Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 12
        },
        "Low Income Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 13
        },
        "Low Income Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 14
        },
        "Low Income Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 15
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 16
        },
        "Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 17
        },
        "Non-Low Income Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 25
        },
        "Non-Low Income Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 26
        },
        "Non-Low Income Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 27
        },
        "Non-Low Income Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 28
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 29
        },
        "Non-Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 30
        },
        "Minority Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 38
        },
        "Minority Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 39
        },
        "Minority Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 40
        },
        "Minority Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 41
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 42
        },
        "Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 43
        },
        "Non-Minority Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 51
        },
        "Non-Minority Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 52
        },
        "Non-Minority Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 53
        },
        "Non-Minority Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 54
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 55
        },
        "Non-Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 56
        },
        "Senior Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 64
        },
        "Senior Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 65
        },
        "Senior Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 66
        },
        "Senior Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 67
        },
        "Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 68
        },
        "Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 69
        },
        "Non-Senior Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 77
        },
        "Non-Senior Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 78
        },
        "Non-Senior Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 79
        },
        "Non-Senior Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 80
        },
        "Non-Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 81
        },
        "Non-Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 82
        }
    },
    "M-1-b": {
        "Population Access Pct - Walk": {
            "sheet": "PrimaryMeasures",
            "row": 18
        },
        "Population Access Pct - Bike": {
            "sheet": "PrimaryMeasures",
            "row": 19
        },
        "Population Access Pct - Walk + MM + MT": {
            "sheet": "PrimaryMeasures",
            "row": 20
        },
        "Population Access Pct - Bike + Walk + MM + MT": {
            "sheet": "PrimaryMeasures",
            "row": 21
        },
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 22
        },
        "Population Access Pct - Drive Alone": {
            "sheet": "PrimaryMeasures",
            "row": 23
        },
        "Low Income Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 85
        },
        "Low Income Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 86
        },
        "Low Income Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 87
        },
        "Low Income Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 88
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 89
        },
        "Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 90
        },
        "Non-Low Income Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 98
        },
        "Non-Low Income Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 99
        },
        "Non-Low Income Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 100
        },
        "Non-Low Income Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 101
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 102
        },
        "Non-Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 103
        },
        "Minority Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 111
        },
        "Minority Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 112
        },
        "Minority Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 113
        },
        "Minority Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 114
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 115
        },
        "Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 116
        },
        "Non-Minority Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 124
        },
        "Non-Minority Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 125
        },
        "Non-Minority Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 126
        },
        "Non-Minority Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 127
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 128
        },
        "Non-Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 129
        },
        "Senior Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 137
        },
        "Senior Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 138
        },
        "Senior Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 139
        },
        "Senior Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 140
        },
        "Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 141
        },
        "Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 142
        },
        "Non-Senior Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 150
        },
        "Non-Senior Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 151
        },
        "Non-Senior Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 152
        },
        "Non-Senior Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 153
        },
        "Non-Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 154
        },
        "Non-Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 155
        }
    },
    "M-1-b - Mobility Hubs": {
        "Population Access Pct - Walk": {
            "sheet": "PrimaryMeasures",
            "row": 24
        },
        "Population Access Pct - Bike": {
            "sheet": "PrimaryMeasures",
            "row": 25
        },
        "Population Access Pct - Walk + MM + MT": {
            "sheet": "PrimaryMeasures",
            "row": 26
        },
        "Population Access Pct - Bike + Walk + MM + MT": {
            "sheet": "PrimaryMeasures",
            "row": 27
        },
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 28
        },
        "Population Access Pct - Drive Alone": {
            "sheet": "PrimaryMeasures",
            "row": 29
        },
        "Low Income Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 91
        },
        "Low Income Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 92
        },
        "Low Income Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 93
        },
        "Low Income Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 94
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 95
        },
        "Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 96
        },
        "Non-Low Income Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 104
        },
        "Non-Low Income Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 105
        },
        "Non-Low Income Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 106
        },
        "Non-Low Income Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 107
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 108
        },
        "Non-Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 109
        },
        "Minority Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 117
        },
        "Minority Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 118
        },
        "Minority Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 119
        },
        "Minority Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 120
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 121
        },
        "Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 122
        },
        "Non-Minority Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 130
        },
        "Non-Minority Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 131
        },
        "Non-Minority Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 132
        },
        "Non-Minority Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 133
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 134
        },
        "Non-Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 135
        },
        "Senior Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 143
        },
        "Senior Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 144
        },
        "Senior Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 145
        },
        "Senior Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 146
        },
        "Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 147
        },
        "Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 148
        },
        "Non-Senior Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 156
        },
        "Non-Senior Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 157
        },
        "Non-Senior Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 158
        },
        "Non-Senior Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 159
        },
        "Non-Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 160
        },
        "Non-Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 161
        }
    },
    "M-1-c": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 31
        },
        "Population Access Pct - Drive Alone": {
            "sheet": "PrimaryMeasures",
            "row": 32
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 164
        },
        "Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 165
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 169
        },
        "Non-Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 170
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 174
        },
        "Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 175
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 179
        },
        "Non-Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 180
        },
        "Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 184
        },
        "Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 185
        },
        "Non-Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 189
        },
        "Non-Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 190
        }
    },
    "M-1-c - Mobility Hubs": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 33
        },
        "Population Access Pct - Drive Alone": {
            "sheet": "PrimaryMeasures",
            "row": 34
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 166
        },
        "Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 167
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 171
        },
        "Non-Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 172
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 176
        },
        "Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 177
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 181
        },
        "Non-Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 182
        },
        "Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 186
        },
        "Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 187
        },
        "Non-Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 191
        },
        "Non-Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 192
        }
    },
    "M-4": {
        "VMT": {
            "sheet": "PrimaryMeasures",
            "row": 39
        },
        "VMT per Capita": {
            "sheet": "PrimaryMeasures",
            "row": 40
        }
    },
    "M-5-a - 30 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 42
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 194
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 198
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 202
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 206
        }
    },
    "M-5-a - 45 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 43
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 195
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 199
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 203
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 207
        }
    },
    "M-5-a - Mobility Hubs - 30 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 44
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 196
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 200
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 204
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 208
        }
    },
    "M-5-a - Mobility Hubs - 45 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 45
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 197
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 201
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 205
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 209
        }
    },
    "M-5-b - 30 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 47
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 211
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 215
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 219
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 223
        }
    },
    "M-5-b - 45 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 48
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 212
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 216
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 220
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 224
        }
    },
    "M-5-b - Mobility Hubs - 30 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 49
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 213
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 217
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 221
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 225
        }
    },
    "M-5-b - Mobility Hubs - 45 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 50
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 214
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 218
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 222
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 226
        }
    },
    "M-5-c - 30 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 52
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 228
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 232
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 236
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 240
        }
    },
    "M-5-c - 45 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 53
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 229
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 233
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 237
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 241
        }
    },
    "M-5-c - Mobility Hubs - 30 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 54
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 230
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 234
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 238
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 242
        }
    },
    "M-5-c - Mobility Hubs - 45 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 55
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 231
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 235
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 239
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 243
        }
    },
    "M-5-d - 30 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 57
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 245
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 249
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 253
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 257
        }
    },
    "M-5-d - 45 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 58
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 246
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 250
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 254
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 258
        }
    },
    "M-5-d - Mobility Hubs - 30 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 59
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 247
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 251
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 255
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 259
        }
    },
    "M-5-d - Mobility Hubs - 45 minutes": {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 60
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 248
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 252
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 256
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 260
        }
    },
    "SM-1 - Peak Period Outbound Work Trips": {
        "Percentage of Person Trips - Bike & Walk": {
            "sheet": "SupportingMeasures",
            "row": 5
        },
        "Percentage of Person Trips - Carpool": {
            "sheet": "SupportingMeasures",
            "row": 6
        },
        "Percentage of Person Trips - Drive Alone": {
            "sheet": "SupportingMeasures",
            "row": 7
        },
        "Percentage of Person Trips - Other": {
            "sheet": "SupportingMeasures",
            "row": 8
        },
        "Percentage of Person Trips - Transit": {
            "sheet": "SupportingMeasures",
            "row": 9
        }
    },
    "SM-1 - Outbound Work Trips": {
        "Percentage of Person Trips - Bike & Walk": {
            "sheet": "SupportingMeasures",
            "row": 10
        },
        "Percentage of Person Trips - Carpool": {
            "sheet": "SupportingMeasures",
            "row": 11
        },
        "Percentage of Person Trips - Drive Alone": {
            "sheet": "SupportingMeasures",
            "row": 12
        },
        "Percentage of Person Trips - Other": {
            "sheet": "SupportingMeasures",
            "row": 13
        },
        "Percentage of Person Trips - Transit": {
            "sheet": "SupportingMeasures",
            "row": 14
        }
    },
    "SM-1 - All Trips": {
        "Percentage of Person Trips - Bike & Walk": {
            "sheet": "SupportingMeasures",
            "row": 15
        },
        "Percentage of Person Trips - Carpool": {
            "sheet": "SupportingMeasures",
            "row": 16
        },
        "Percentage of Person Trips - Drive Alone": {
            "sheet": "SupportingMeasures",
            "row": 17
        },
        "Percentage of Person Trips - Other": {
            "sheet": "SupportingMeasures",
            "row": 18
        },
        "Percentage of Person Trips - Transit": {
            "sheet": "SupportingMeasures",
            "row": 19
        }
    },
    "SM-5": {
        "Daily Transit Boardings - Tier 1": {
            "sheet": "SupportingMeasures",
            "row": 42
        },
        "Daily Transit Boardings - Tier 2": {
            "sheet": "SupportingMeasures",
            "row": 43
        },
        "Daily Transit Boardings - Tier 3": {
            "sheet": "SupportingMeasures",
            "row": 44
        },
        "Daily Transit Boardings - Total": {
            "sheet": "SupportingMeasures",
            "row": 45
        }
    },
    "SM-5 Mobility Hubs": {
        "Daily Transit Boardings - Tier 1": {
            "sheet": "SupportingMeasures",
            "row": 46
        },
        "Daily Transit Boardings - Tier 2": {
            "sheet": "SupportingMeasures",
            "row": 47
        },
        "Daily Transit Boardings - Tier 3": {
            "sheet": "SupportingMeasures",
            "row": 48
        },
        "Daily Transit Boardings - Total": {
            "sheet": "SupportingMeasures",
            "row": 49
        }
    },
    "SM-6 Transportation-Related Physical Activity per Capita": {
        "Total": {
            "sheet": "SupportingMeasures",
            "row": 51
        }
    },
    "SM-6 Percentage of Population Engaged in Transportation-Related Physical Activity": {
        "Total": {
            "sheet": "SupportingMeasures",
            "row": 52
        }
    },
    "SM-7": {
        "Average Travel Time": {
            "sheet": "SupportingMeasures",
            "row": 54
        }
    },
    "SM-9-a": {
        "TTI - Highway (SHS)": {
            "sheet": "SupportingMeasures",
            "row": 58
        },
        "TTI - Arterial": {
            "sheet": "SupportingMeasures",
            "row": 59
        },
        "TTI - All IFCs": {
            "sheet": "SupportingMeasures",
            "row": 60
        }
    },
    "SM-9-b": {
        "Heavy Heavy Duty Truck - Highway (SHS) - VHD": {
            "sheet": "SupportingMeasures",
            "row": 62
        },
        "Heavy Heavy Duty Truck - Arterial - VHD": {
            "sheet": "SupportingMeasures",
            "row": 63
        },
        "Heavy Heavy Duty Truck - Highway (SHS) - VHD - Peak Period": {
            "sheet": "SupportingMeasures",
            "row": 64
        },
        "Heavy Heavy Duty Truck - Arterial - VHD - Peak Period": {
            "sheet": "SupportingMeasures",
            "row": 65
        },
        "Medium Heavy Duty Truck - Highway (SHS) - VHD": {
            "sheet": "SupportingMeasures",
            "row": 66
        },
        "Medium Heavy Duty Truck - Arterial - VHD": {
            "sheet": "SupportingMeasures",
            "row": 67
        },
        "Medium Heavy Duty Truck - Highway (SHS) - VHD - Peak Period": {
            "sheet": "SupportingMeasures",
            "row": 68
        },
        "Medium Heavy Duty Truck - Arterial - VHD - Peak Period": {
            "sheet": "SupportingMeasures",
            "row": 69
        },
        "Light Heavy Duty Truck - Highway (SHS) - VHD": {
            "sheet": "SupportingMeasures",
            "row": 70
        },
        "Light Heavy Duty Truck - Arterial - VHD": {
            "sheet": "SupportingMeasures",
            "row": 71
        },
        "Light Heavy Duty Truck - Highway (SHS) - VHD - Peak Period": {
            "sheet": "SupportingMeasures",
            "row": 72
        },
        "Light Heavy Duty Truck - Arterial - VHD - Peak Period": {
            "sheet": "SupportingMeasures",
            "row": 73
        },
        "All Heavy Duty Trucks - Highway (SHS) - VHD": {
            "sheet": "SupportingMeasures",
            "row": 74
        },
        "All Heavy Duty Trucks - Arterial - VHD": {
            "sheet": "SupportingMeasures",
            "row": 75
        },
        "All Heavy Duty Trucks - Highway (SHS) - VHD - Peak Period": {
            "sheet": "SupportingMeasures",
            "row": 76
        },
        "All Heavy Duty Trucks - Arterial - VHD - Peak Period": {
            "sheet": "SupportingMeasures",
            "row": 77
        }
    },
    "SM-10": {
        "Total": {
            "sheet": "SupportingMeasures",
            "row": 79
        },
        "Low Income": {
            "sheet": "Social Equity PMs",
            "row": 389
        },
        "Non-Low Income": {
            "sheet": "Social Equity PMs",
            "row": 390
        },
        "Minority": {
            "sheet": "Social Equity PMs",
            "row": 391
        },
        "Non-Minority": {
            "sheet": "Social Equity PMs",
            "row": 392
        },
        "Senior": {
            "sheet": "Social Equity PMs",
            "row": 393
        },
        "Non-Senior": {
            "sheet": "Social Equity PMs",
            "row": 394
        }
    },
    "SB375 - Auto Ownership": {
        "Average Household Auto Ownership": {
            "sheet": "SB375 Data Table",
            "row": 37
        }
    },
    "SB375 - Housing Structures": {
        "Total Households": {
            "sheet": "SB375 Data Table",
            "row": 9
        },
        "Total Housing Structures": {
            "sheet": "SB375 Data Table",
            "row": 13
        },
        "Total Single-Family Housing Structures": {
            "sheet": "SB375 Data Table",
            "row": 14
        },
        "Share of Single-Family Housing Structures": {
            "sheet": "SB375 Data Table",
            "row": 15
        },
        "Total Multi-Family Housing Structures": {
            "sheet": "SB375 Data Table",
            "row": 16
        },
        "Share of Multi-Family Housing Structures": {
            "sheet": "SB375 Data Table",
            "row": 17
        }
    },
    "SB375 - Jobs": {
        "Total Jobs": {
            "sheet": "SB375 Data Table",
            "row": 10
        }
    },
    "SB375 - Median Household Income": {
        "Median Household Income": {
            "sheet": "SB375 Data Table",
            "row": 8
        }
    },
    "SB375 - Average Trip Length by Mode": {
        "Drive Alone": {
            "sheet": "SB375 Data Table",
            "row": 39
        },
        "Shared Ride 2": {
            "sheet": "SB375 Data Table",
            "row": 40
        },
        "Shared Ride 3+": {
            "sheet": "SB375 Data Table",
            "row": 41
        },
        "Drive to Transit": {
            "sheet": "SB375 Data Table",
            "row": 42
        },
        "Walk to Transit": {
            "sheet": "SB375 Data Table",
            "row": 43
        },
        "Bike": {
            "sheet": "SB375 Data Table",
            "row": 44
        },
        "Walk": {
            "sheet": "SB375 Data Table",
            "row": 45
        },
        "All Modes": {
            "sheet": "SB375 Data Table",
            "row": 46
        }
    },
    "SB375 - Average Trip Time by Mode": {
        "Drive Alone": {
            "sheet": "SB375 Data Table",
            "row": 51
        },
        "Shared Ride 2": {
            "sheet": "SB375 Data Table",
            "row": 52
        },
        "Shared Ride 3+": {
            "sheet": "SB375 Data Table",
            "row": 53
        },
        "Drive to Transit": {
            "sheet": "SB375 Data Table",
            "row": 54
        },
        "Walk to Transit": {
            "sheet": "SB375 Data Table",
            "row": 55
        },
        "Bike": {
            "sheet": "SB375 Data Table",
            "row": 56
        },
        "Walk": {
            "sheet": "SB375 Data Table",
            "row": 57
        },
        "All Modes": {
            "sheet": "SB375 Data Table",
            "row": 58
        }
    },
    "SB375 - Average Trip Time by Mode for Low Income Residents": {
        "Drive Alone": {
            "sheet": "SB375 Data Table",
            "row": 60
        },
        "Shared Ride 2": {
            "sheet": "SB375 Data Table",
            "row": 61
        },
        "Shared Ride 3+": {
            "sheet": "SB375 Data Table",
            "row": 62
        },
        "Drive to Transit": {
            "sheet": "SB375 Data Table",
            "row": 63
        },
        "Walk to Transit": {
            "sheet": "SB375 Data Table",
            "row": 64
        },
        "Bike": {
            "sheet": "SB375 Data Table",
            "row": 65
        },
        "Walk": {
            "sheet": "SB375 Data Table",
            "row": 66
        },
        "All Modes": {
            "sheet": "SB375 Data Table",
            "row": 67
        }
    },
    "SB375 - Mode Share": {
        "Drive Alone": {
            "sheet": "SB375 Data Table",
            "row": 69
        },
        "Shared Ride 2": {
            "sheet": "SB375 Data Table",
            "row": 70
        },
        "Shared Ride 3+": {
            "sheet": "SB375 Data Table",
            "row": 71
        },
        "Drive to Transit": {
            "sheet": "SB375 Data Table",
            "row": 72
        },
        "Walk to Transit": {
            "sheet": "SB375 Data Table",
            "row": 73
        },
        "Bike": {
            "sheet": "SB375 Data Table",
            "row": 74
        },
        "Walk": {
            "sheet": "SB375 Data Table",
            "row": 75
        },
        "All Modes": {
            "sheet": "SB375 Data Table",
            "row": 76
        }
    },
    "SB375 - Population": {
        "Total Population": {
            "sheet": "SB375 Data Table",
            "row": 4
        },
        "Modeled Population": {
            "sheet": "SB375 Data Table",
            "row": 5
        }
    },
    "SB375 - Seat Utilization": {
        "Seat Utilization": {
            "sheet": "SB375 Data Table",
            "row": 77
        }
    },
    "SB375 - Travel Time by Purpose": {
        "Outbound Work Trips": {
            "sheet": "SB375 Data Table",
            "row": 48
        },
        "Other Trips": {
            "sheet": "SB375 Data Table",
            "row": 49
        }
    }
}
