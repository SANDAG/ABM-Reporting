import pyodbc
import sqlalchemy
import urllib

# set mobility hub name of interest to filter origin MGRAs
moHubName = ""  # TODO: set Mobility Hub name of interest

# create dictionary of ABM SQL database scenario ids and the corresponding
# scenario label they map to within the Performance Measure template
# possible labels: 2016, 2025nb, 2035nb, 2050nb, 2025build, 2035build, 2050build
scenarios = {
    # 1: "2035build"  example format  TODO: set scenarios
}

# set path to write Mobility Hub Access Measure workbook
# suggested to include mobility hub name input parameter in file name
# example format: C:/Users/gsc/Desktop/MoHubAccess - Urban Core.xlsx
templateWritePath = ""  # TODO: set template write path

# set SQL Server connection attributes
sqlAttributes = {
    "ABM-Reporting": {
        "server": "",  # TODO: set SQL server name
        "database": ""  # TODO: set SQL server database name
    }
}

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
    }
}

# create SQL Server connection strings
connStrings = {
    "ABM-Reporting": "DRIVER={SQL Server Native Client 11.0};SERVER=" +
                     sqlAttributes["ABM-Reporting"]["server"] +
                     ";DATABASE=" + sqlAttributes["ABM-Reporting"]["database"]
                     + ";Trusted_Connection=yes;"
}

# create SQL alchemy engines using pyodbc sql server connection
pyodbc.pooling = False
engines = {
    "ABM-Reporting": sqlalchemy.create_engine(
        "mssql+pyodbc:///?odbc_connect=%s" %
        urllib.parse.quote_plus(connStrings["ABM-Reporting"]))
}

# dictionary of Python-based performance measures
# Measure: Metric: (class, method, args: (specific arguments))
python_measures = {
    "M-1-a - " + moHubName: {
        "Bike":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": False,
                 "mobility_hub_name": moHubName,
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
                 "mobility_hub_name": moHubName,
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
                 "mobility_hub_name": moHubName,
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
                 "mobility_hub_name": moHubName,
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
                 "mobility_hub_name": moHubName,
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
                 "mobility_hub_name": moHubName,
                 "access_cols": ["walkTime", "mmTime", "mtTime"]}
             }
    },
    "M-1-b - " + moHubName: {
        "Bike":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_walk_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "mobility_hub": False,
                 "mobility_hub_name": moHubName,
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
                 "mobility_hub_name": moHubName,
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
                 "mobility_hub_name": moHubName,
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
                 "mobility_hub_name": moHubName,
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
                 "mobility_hub_name": moHubName,
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
                 "mobility_hub_name": moHubName,
                 "access_cols": ["walkTime", "mmTime", "mtTime"]}
             }
    },
    "M-1-c - " + moHubName: {
        "Drive Alone":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_drive_access",
             "args": {
                 "criteria": "empHealth > 0",
                 "max_time": 30,
                 "over18": False,
                 "mobility_hub": False,
                 "mobility_hub_name": moHubName,
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
                 "mobility_hub_name": moHubName,
                 "tod": "MD"}
             }
    },
    "M-5-a - 30 minutes - " + moHubName: {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 1",
                 "max_time": 30,
                 "over18": True,
                 "mobility_hub": False,
                 "mobility_hub_name": moHubName,
                 "tod": "AM"}
             }
    },
    "M-5-a - 45 minutes - " + moHubName: {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 1",
                 "max_time": 45,
                 "over18": True,
                 "mobility_hub": False,
                 "mobility_hub_name": moHubName,
                 "tod": "AM"}
             }
    },
    "M-5-b - 30 minutes - " + moHubName: {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 2",
                 "max_time": 30,
                 "over18": True,
                 "mobility_hub": False,
                 "mobility_hub_name": moHubName,
                 "tod": "AM"}
             }
    },
    "M-5-b - 45 minutes - " + moHubName: {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 2",
                 "max_time": 45,
                 "over18": True,
                 "mobility_hub": False,
                 "mobility_hub_name": moHubName,
                 "tod": "AM"}
             }
    },
    "M-5-c - 30 minutes - " + moHubName: {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier > 0",
                 "max_time": 30,
                 "over18": True,
                 "mobility_hub": False,
                 "mobility_hub_name": moHubName,
                 "tod": "AM"}
             }
    },
    "M-5-c - 45 minutes - " + moHubName: {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier > 0",
                 "max_time": 45,
                 "over18": True,
                 "mobility_hub": False,
                 "mobility_hub_name": moHubName,
                 "tod": "AM"}
             }
    },
    "M-5-d - 30 minutes - " + moHubName: {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "higherLearningEnrollment > 0",
                 "max_time": 30,
                 "over18": True,
                 "mobility_hub": False,
                 "mobility_hub_name": moHubName,
                 "tod": "AM"}
             }
    },
    "M-5-d - 45 minutes - " + moHubName: {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "higherLearningEnrollment > 0",
                 "max_time": 45,
                 "over18": True,
                 "mobility_hub": False,
                 "mobility_hub_name": moHubName,
                 "tod": "AM"}
             }
    }
}

# dictionary of performance measure outputs
# and locations to write into Excel template
# Measure: Metric: (sheet, row)
template_locations = {
    "M-1-a - " + moHubName: {
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
            "row": 13
        },
        "Non-Low Income Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 14
        },
        "Non-Low Income Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 15
        },
        "Non-Low Income Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 16
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 17
        },
        "Non-Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 18
        },
        "Minority Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 20
        },
        "Minority Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 21
        },
        "Minority Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 22
        },
        "Minority Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 23
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 24
        },
        "Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 25
        },
        "Non-Minority Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 27
        },
        "Non-Minority Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 28
        },
        "Non-Minority Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 29
        },
        "Non-Minority Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 30
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 31
        },
        "Non-Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 32
        },
        "Senior Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 34
        },
        "Senior Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 35
        },
        "Senior Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 36
        },
        "Senior Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 37
        },
        "Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 38
        },
        "Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 39
        },
        "Non-Senior Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 41
        },
        "Non-Senior Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 42
        },
        "Non-Senior Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 43
        },
        "Non-Senior Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 44
        },
        "Non-Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 45
        },
        "Non-Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 46
        }
    },
    "M-1-b - " + moHubName: {
        "Population Access Pct - Walk": {
            "sheet": "PrimaryMeasures",
            "row": 12
        },
        "Population Access Pct - Bike": {
            "sheet": "PrimaryMeasures",
            "row": 13
        },
        "Population Access Pct - Walk + MM + MT": {
            "sheet": "PrimaryMeasures",
            "row": 14
        },
        "Population Access Pct - Bike + Walk + MM + MT": {
            "sheet": "PrimaryMeasures",
            "row": 15
        },
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 16
        },
        "Population Access Pct - Drive Alone": {
            "sheet": "PrimaryMeasures",
            "row": 17
        },
        "Low Income Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 49
        },
        "Low Income Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 50
        },
        "Low Income Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 51
        },
        "Low Income Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 52
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 53
        },
        "Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 54
        },
        "Non-Low Income Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 56
        },
        "Non-Low Income Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 57
        },
        "Non-Low Income Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 58
        },
        "Non-Low Income Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 59
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 60
        },
        "Non-Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 61
        },
        "Minority Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 63
        },
        "Minority Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 64
        },
        "Minority Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 65
        },
        "Minority Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 66
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 67
        },
        "Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 68
        },
        "Non-Minority Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 70
        },
        "Non-Minority Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 71
        },
        "Non-Minority Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 72
        },
        "Non-Minority Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 73
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 74
        },
        "Non-Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 75
        },
        "Senior Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 77
        },
        "Senior Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 78
        },
        "Senior Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 79
        },
        "Senior Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 80
        },
        "Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 81
        },
        "Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 82
        },
        "Non-Senior Access Pct - Walk": {
            "sheet": "Social Equity PMs",
            "row": 84
        },
        "Non-Senior Access Pct - Bike": {
            "sheet": "Social Equity PMs",
            "row": 85
        },
        "Non-Senior Access Pct - Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 86
        },
        "Non-Senior Access Pct - Bike + Walk + MM + MT": {
            "sheet": "Social Equity PMs",
            "row": 87
        },
        "Non-Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 88
        },
        "Non-Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 89
        }
    },
    "M-1-c - " + moHubName: {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 19
        },
        "Population Access Pct - Drive Alone": {
            "sheet": "PrimaryMeasures",
            "row": 20
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 92
        },
        "Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 93
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 95
        },
        "Non-Low Income Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 96
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 98
        },
        "Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 99
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 101
        },
        "Non-Minority Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 102
        },
        "Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 104
        },
        "Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 105
        },
        "Non-Senior Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 107
        },
        "Non-Senior Access Pct - Drive Alone": {
            "sheet": "Social Equity PMs",
            "row": 108
        }
    },
    "M-5-a - 30 minutes - " + moHubName: {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 22
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 110
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 112
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 114
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 116
        }
    },
    "M-5-a - 45 minutes - " + moHubName: {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 23
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 111
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 113
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 115
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 117
        }
    },
    "M-5-b - 30 minutes - " + moHubName: {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 25
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 119
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 121
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 123
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 125
        }
    },
    "M-5-b - 45 minutes - " + moHubName: {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 26
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 120
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 122
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 124
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 126
        }
    },
    "M-5-c - 30 minutes - " + moHubName: {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 28
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 128
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 130
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 132
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 134
        }
    },
    "M-5-c - 45 minutes - " + moHubName: {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 29
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 129
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 131
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 133
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 135
        }
    },
    "M-5-d - 30 minutes - " + moHubName: {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 31
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 137
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 139
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 141
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 143
        }
    },
    "M-5-d - 45 minutes - " + moHubName: {
        "Population Access Pct - Transit - Speed One": {
            "sheet": "PrimaryMeasures",
            "row": 32
        },
        "Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 138
        },
        "Non-Low Income Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 140
        },
        "Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 142
        },
        "Non-Minority Access Pct - Transit - Speed One": {
            "sheet": "Social Equity PMs",
            "row": 144
        }
    }
}
