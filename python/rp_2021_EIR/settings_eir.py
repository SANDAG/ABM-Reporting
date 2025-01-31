import pyodbc
import sqlalchemy
import urllib
import pandas as pd
import yaml
from datetime import datetime

# create dictionary of ABM SQL database scenario ids and the corresponding
# scenario label they map to within the Performance Measure template
# possible labels: 2016, 2025nb, 2035nb, 2050nb, 2025build, 2035build, 2050build
scenarios = {

    # 767: "2016",
    # 759: "2025nb",
    # 759: "2025_LUCB",
    # 764: "2035nb",
    # 766: "2035_LUCB",
    # 773: "2050nb",
    # 768: "2050_LUCB"

}

# map scenario labels to template sheet columns
# Sheet: (Scenario Label)
template_columns = {
    # "Stats 2016 Build and No Build": {
    #     "2016": 3,
    #     "2025nb": 4,
    #     "2025_LUCB": 5,
    #     "2035nb": 6,
    #     "2035_LUCB": 7,
    #     "2050nb": 8,
    #     "2050_LUCB": 9

    # }
}

# set path to write Performance Measure workbook
# example format: C:/Users/gsc/Desktop/PerformanceMeasures.xlsx
now = datetime.now()
templateWritePath = f"python/rp_final_EIR/2021RP_final_EIR_data_summary_{now.strftime('%Y%m%d-%H%M')}"

# set path to Performance Measure workbook Template
template_path = "resources/rp_2021/2021RP_final_EIR_data.xlsx"

# list of performance measure outputs
# and locations to write into Excel template
# Measure, Metric, sheet, row
template_locations_path = "resources/rp_2021/2021RP_final_EIR_template_location.csv"

# get SQL server attributes from local file
try:
    with open("resources/database-specs.yaml", "r", encoding="utf8") as stream:
        try:
            db_info = yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            print(exc)
except FileNotFoundError as e:
    print(f'''"resources/database-specs.yaml" not found, ensure:\n 
        - that you have appropriate permissions and \n
        - that you are running main_eir.py from the ABM-Reporting directory''')

# set SQL Server connection attributes
sqlAttributes = {
    "ABM-Reporting": {
        "server": db_info['server1']['name'],
        "database": db_info['server1']['db1_1']
    }
}

conn_reporting = pyodbc.connect("DRIVER={SQL Server Native Client 11.0};SERVER="
                      + sqlAttributes["ABM-Reporting"]["server"] +
                      ";DATABASE=" +
                      sqlAttributes["ABM-Reporting"]["database"] +
                      ";Trusted_Connection=yes;")


sql_measures_db = {
    "SM-1 - All Trips All Simulated Models": {
        "sp": "[eir].[sp_trip_length_allsimulated]",
        "args": "@scenario_id=?,@all_models=0, @peak_period=0"
    },
    "SM-1 - All Trips All Day All Simulated Models": {
        "sp": "[eir].[sp_modeshare_allsimulated]",
        "args": "@scenario_id=?,@peak_period=0"
    },
    "VMT per service population": {
        "sp": "[eir].[sp_vmt_per_service_pop]",
        "args": "@scenario_id=?"
    },
    "Total Service Population": {
        "sp": "[eir].[sp_tpa_service_pop]",
        "args": "@scenario_id=?"
    },
    "Population within TPAs": {
        "sp": "[eir].[sp_tpa_pop]",
        "args": "@scenario_id=?"
    },
    "Employment within TPAs": {
        "sp": "[eir].[sp_tpa_employment]",
        "args": "@scenario_id=?"
    },
    "Employment Region Wide": {
        "sp": "[eir].[sp_total_employment]",
        "args": "@scenario_id=?"
    },
    "Population Region Wide": {
        "sp": "[eir].[sp_total_pop]",
        "args": "@scenario_id=?"
    },
    "Transit Service Miles": {
        "sp": "[eir].[sp_transit_vmt_vht]",
        "args": "@scenario_id=?"
    }
}

sql_measures_reporting = {
    "M-4": {
        "sp": "[rp_2021].[sp_pm_m4]",
        "args": "@scenario_id=?"
    }
}

sql_measures_reporting_diffformat = {
    "All Residents": {
        "sp": "[rp_2021].[sp_resident_vmt]",
        "args": "@scenario_id=?, @geography_column='region_2004_name', @workers=0, @home_location=1, @work_location=0 "
    },
    "Workers Only": {
        "sp": "[rp_2021].[sp_resident_vmt]",
        "args": "@scenario_id=?, @geography_column='region_2004_name', @workers=1, @home_location=0, @work_location=1"
    }
}

sql_measures_db_lanemile = {
    "Lane Miles of Roadways": {
        "sp": "[eir].[sp_link_miles_by_facility]",
        "args": "@scenario_id=?"
    }
}



