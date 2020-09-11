import pyodbc
import sqlalchemy
import urllib


# set SQL Server connection attributes
server =
database =

# create SQL Server connection string
connString = "DRIVER={SQL Server Native Client 11.0};SERVER=" + \
             server + ";DATABASE=" + database + ";Trusted_Connection=yes;"

# create SQL alchemy engine using pyodbc sql server connection
pyodbc.pooling = False
params = urllib.parse.quote_plus(connString)
engine = sqlalchemy.create_engine("mssql+pyodbc:///?odbc_connect=%s" % params)

access_pms = {
    "SE-M-1-a": {
        "Bike":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False}
             },
        "Carpool":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_drive_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "matrix": "MD_HOV3_H"}
             },
        "Drive Alone":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_drive_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "matrix": "MD_SOV_NT_L"}
             },
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False,
                 "tod": "MD"}
             },
        "Walk":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_walk_access",
             "args": {
                 "criteria": "empRetail > 0",
                 "max_time": 15,
                 "over18": False}
             }
    },
    "SE-M-1-b": {
        "Bike":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_bike_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False}
             },
        "Carpool":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_drive_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "matrix": "MD_HOV3_H"}
             },
        "Drive Alone":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_drive_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "matrix": "MD_SOV_NT_L"}
             },
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False,
                 "tod": "MD"}
             },
        "Walk":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_walk_access",
             "args": {
                 "criteria": "parkActive >= .5",
                 "max_time": 15,
                 "over18": False}
             }
    },
    "SE-M-1-c": {
        "Carpool":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_drive_access",
             "args": {
                 "criteria": "empHealth > 0",
                 "max_time": 30,
                 "over18": False,
                 "matrix": "MD_HOV3_H"}
             },
        "Drive Alone":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_drive_access",
             "args": {
                 "criteria": "empHealth > 0",
                 "max_time": 30,
                 "over18": False,
                 "matrix": "MD_SOV_NT_L"}
             },
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "empHealth > 0",
                 "max_time": 30,
                 "over18": False,
                 "tod": "MD"}
             }
    },
    "SE-M-5-a - 30 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 1",
                 "max_time": 30,
                 "over18": True,
                 "tod": "AM"}
             }
    },
    "SE-M-5-a - 45 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 1",
                 "max_time": 45,
                 "over18": True,
                 "tod": "AM"}
             }
    },
    "SE-M-5-b - 30 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 2",
                 "max_time": 30,
                 "over18": True,
                 "tod": "AM"}
             }
    },
    "SE-M-5-b - 45 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier == 2",
                 "max_time": 45,
                 "over18": True,
                 "tod": "AM"}
             }
    },
    "SE-M-5-c - 30 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "higherLearningEnrollment > 0",
                 "max_time": 30,
                 "over18": True,
                 "tod": "AM"}
             }
    },
    "SE-M-5-c - 45 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "higherLearningEnrollment > 0",
                 "max_time": 45,
                 "over18": True,
                 "tod": "AM"}
             }
    },
    "SE-M-5-d - 30 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier > 0",
                 "max_time": 30,
                 "over18": True,
                 "tod": "AM"}
             }
    },
    "SE-M-5-d - 45 minutes": {
        "Transit - Speed One":
            {"class": "PerformanceMeasuresM1M5",
             "method": "calc_transit_access",
             "args": {
                 "criteria": "employmentCenterTier > 0",
                 "max_time": 45,
                 "over18": True,
                 "tod": "AM"}
             }
    }
}
