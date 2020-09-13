# set paths to Sensitivity Excel workbook templates
templatePaths ={
    "scenarioTemplate": ("./resources/sensitivity/templates/"
                         "Scenario Sensitivity_template.xlsx"),
    "multipleScenariosTemplate": ("./resources/sensitivity/templates/"
                                  "Multiple Scenarios Sensitivity_template.xlsx")
}

# set path to write completed Sensitivity Excel workbook
# and set protection option and password
templateWritePaths = {
    "scenarioTemplate": "./Scenario Sensitivity Measures",
    "multipleScenariosTemplate": "./Multiple Scenarios Sensitivity Measures.xlsx"
}

# set SQL Server connection attributes
server =
database =


# initialize dictionary to hold single scenario Sensitivity Measures
# stored procedures to run, their arguments, and the sheets+rows
# in the Excel template to write result sets to
singleScenarioMeasures = [
    # Scenario Metadata
    {"sp": "[sensitivity].[sp_scenario]",
     "args": "@scenario_id=?",
     "sheets": ["scenario"],
     "rows": [2]},
    # Person Trip Mode Share
    {"sp": "[sensitivity].[sp_mode_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='share'",
     "sheets": ["modeShare"],
     "rows": [2]},
    # Trip Mode Share
    {"sp": "[sensitivity].[sp_mode_metrics]",
     "args": "@scenario_id=?,@weight='trips',@metric='share'",
     "sheets": ["modeShare"],
     "rows": [20]},
    # Person Trip Distance by Mode
    {"sp": "[sensitivity].[sp_mode_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='distance'",
     "sheets": ["tripLengthMode"],
     "rows": [2]},
    # Person Trip Time by Mode
    {"sp": "[sensitivity].[sp_mode_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='time'",
     "sheets": ["tripLengthMode"],
     "rows": [20]},
    # Trip Distance by Mode
    {"sp": "[sensitivity].[sp_mode_metrics]",
     "args": "@scenario_id=?,@weight='trips',@metric='distance'",
     "sheets": ["tripLengthMode"],
     "rows": [38]},
    # Trip Time by Mode
    {"sp": "[sensitivity].[sp_mode_metrics]",
     "args": "@scenario_id=?,@weight='trips',@metric='time'",
     "sheets": ["tripLengthMode"],
     "rows": [56]},
    # Person Trip Purpose Share
    {"sp": "[sensitivity].[sp_purpose_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='share'",
     "sheets": ["purposeShare"],
     "rows": [2]},
    # Trip Purpose Share
    {"sp": "[sensitivity].[sp_purpose_metrics]",
     "args": "@scenario_id=?,@weight='trips',@metric='share'",
     "sheets": ["purposeShare"],
     "rows": [20]},
    # Person Trip Distance by Purpose
    {"sp": "[sensitivity].[sp_purpose_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='distance'",
     "sheets": ["tripLengthPurpose"],
     "rows": [2]},
    # Person Trip Time by Purpose
    {"sp": "[sensitivity].[sp_purpose_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='time'",
     "sheets": ["tripLengthPurpose"],
     "rows": [20]},
    # Trip Distance by Purpose
    {"sp": "[sensitivity].[sp_purpose_metrics]",
     "args": "@scenario_id=?,@weight='trips',@metric='distance'",
     "sheets": ["tripLengthPurpose"],
     "rows": [38]},
    # Trip Time by Purpose
    {"sp": "[sensitivity].[sp_purpose_metrics]",
     "args": "@scenario_id=?,@weight='trips',@metric='time'",
     "sheets": ["tripLengthPurpose"],
     "rows": [56]},
    # VMT by IFC and Mode
    {"sp": "[sensitivity].[sp_ifc_metrics]",
     "args": "@scenario_id=?,@metric='vmt'",
     "sheets": ["highwayNetwork"],
     "rows": [2]},
    # VHT by IFC and Mode
    {"sp": "[sensitivity].[sp_ifc_metrics]",
     "args": "@scenario_id=?,@metric='vht'",
     "sheets": ["highwayNetwork"],
     "rows": [18]},
    # VHD by IFC and Mode
    {"sp": "[sensitivity].[sp_ifc_metrics]",
     "args": "@scenario_id=?,@metric='vhd'",
     "sheets": ["highwayNetwork"],
     "rows": [34]},
    # Person Transit Trip Mode Share
    {"sp": "[sensitivity].[sp_transit_mode_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='share'",
     "sheets": ["transitModeShareTripLength"],
     "rows": [2]},
    # Person Transit Trips by Mode
    {"sp": "[sensitivity].[sp_transit_mode_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='trips'",
     "sheets": ["transitModeShareTripLength"],
     "rows": [20]},
    # Person Transit Trip Distance by Mode
    {"sp": "[sensitivity].[sp_transit_mode_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='distance'",
     "sheets": ["transitModeShareTripLength"],
     "rows": [38]},
    # Person Transit Trip Time by Mode
    {"sp": "[sensitivity].[sp_transit_mode_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='time'",
     "sheets": ["transitModeShareTripLength"],
     "rows": [56]},
    # Transit Boardings by Mode
    {"sp": "[sensitivity].[sp_transit_onoff_metrics]",
     "args": "@scenario_id=?,@metric='boardings'",
     "sheets": ["transitNetwork"],
     "rows": [2]},
    # Transit Boardings Mode Share
    {"sp": "[sensitivity].[sp_transit_onoff_metrics]",
     "args": "@scenario_id=?,@metric='boardings share'",
     "sheets": ["transitNetwork"],
     "rows": [13]},
    # Transit Boardings per Transit Trip
    {"sp": "[sensitivity].[sp_transit_onoff_metrics]",
     "args": "@scenario_id=?,@metric='boardings per trip'",
     "sheets": ["transitNetwork"],
     "rows": [24]},
    # Transit Transfers by Mode
    {"sp": "[sensitivity].[sp_transit_onoff_metrics]",
     "args": "@scenario_id=?,@metric='transfers'",
     "sheets": ["transitNetwork"],
     "rows": [35]},
    # Transit Transfers Mode Share
    {"sp": "[sensitivity].[sp_transit_onoff_metrics]",
     "args": "@scenario_id=?,@metric='transfers share'",
     "sheets": ["transitNetwork"],
     "rows": [46]},
    # Transit Transfers per Transit Trip
    {"sp": "[sensitivity].[sp_transit_onoff_metrics]",
     "args": "@scenario_id=?,@metric='transfers per trip'",
     "sheets": ["transitNetwork"],
     "rows": [57]},
    # Work Segment Distance and Persons
    {"sp": "[sensitivity].[sp_work_location]",
     "args": "@scenario_id=?",
     "sheets": ["workSchoolLocation"],
     "rows": [2]},
    # Student Status Distance and Persons
    {"sp": "[sensitivity].[sp_school_location]",
     "args": "@scenario_id=?",
     "sheets": ["workSchoolLocation"],
     "rows": [15]}
]


# initialize dictionary to hold multiple scenario Sensitivity Measures
# stored procedures to run, their arguments, result set filters,
# columns to drop from the result set, and the sheets+starting rows in the
# Excel template to write result sets to
multipleScenarioMeasures = [
    # Scenario Metadata
    {"sp": "[sensitivity].[sp_scenario]",
     "args": "@scenario_id=?",
     "filter": None,
     "drop": ["scenario_id"],  # scenario_id is appended in main.py
     "sheets": ["scenarios"],
     "rows": [2]},
    # Person Trip Mode Share
    {"sp": "[sensitivity].[sp_mode_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='share'",
     "filter": "model == 'All Models'",
     "drop": ["model"],
     "sheets": ["modeShare"],
     "rows": [2]},
    # Person Trip Distance by Mode
    {"sp": "[sensitivity].[sp_mode_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='distance'",
     "filter": "model == 'All Models'",
     "drop": ["model"],
     "sheets": ["tripLengthMode"],
     "rows": [2]},
    # Person Trip Time by Mode
    {"sp": "[sensitivity].[sp_mode_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='time'",
     "filter": "model == 'All Models'",
     "drop": ["model"],
     "sheets": ["tripLengthMode"],
     "rows": [43]},
    # Person Trip Purpose Share
    {"sp": "[sensitivity].[sp_purpose_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='share'",
     "filter": "model == 'All Models'",
     "drop": ["model"],
     "sheets": ["purposeShare"],
     "rows": [2]},
    # Person Trip Distance by Purpose
    {"sp": "[sensitivity].[sp_purpose_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='distance'",
     "filter": "model == 'All Models'",
     "drop": ["model"],
     "sheets": ["tripLengthPurpose"],
     "rows": [2]},
    # Person Trip Time by Purpose
    {"sp": "[sensitivity].[sp_purpose_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='time'",
     "filter": "model == 'All Models'",
     "drop": ["model"],
     "sheets": ["tripLengthPurpose"],
     "rows": [43]},
    # VMT by IFC and Mode
    {"sp": "[sensitivity].[sp_ifc_metrics]",
     "args": "@scenario_id=?,@metric='vmt'",
     "filter": "ifc == 'Total'",
     "drop": ["ifc"],
     "sheets": ["highwayNetwork"],
     "rows": [2]},
    # VHT by IFC and Mode
    {"sp": "[sensitivity].[sp_ifc_metrics]",
     "args": "@scenario_id=?,@metric='vht'",
     "filter": "ifc == 'Total'",
     "drop": ["ifc"],
     "sheets": ["highwayNetwork"],
     "rows": [43]},
    # VHD by IFC and Mode
    {"sp": "[sensitivity].[sp_ifc_metrics]",
     "args": "@scenario_id=?,@metric='vhd'",
     "filter": "ifc == 'Total'",
     "drop": ["ifc"],
     "sheets": ["highwayNetwork"],
     "rows": [84]},
    # Person Transit Trips by Mode
    {"sp": "[sensitivity].[sp_transit_mode_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='trips'",
     "filter": "model == 'All Models'",
     "drop": ["model"],
     "sheets": ["transitModeShareTripLength"],
     "rows": [2]},
    # Person Transit Trip Mode Share
    {"sp": "[sensitivity].[sp_transit_mode_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='share'",
     "filter": "model == 'All Models'",
     "drop": ["model"],
     "sheets": ["transitModeShareTripLength"],
     "rows": [43]},
    # Person Transit Trip Distance by Mode
    {"sp": "[sensitivity].[sp_transit_mode_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='distance'",
     "filter": "model == 'All Models'",
     "drop": ["model"],
     "sheets": ["transitModeShareTripLength"],
     "rows": [84]},
    # Person Transit Trip Time by Mode
    {"sp": "[sensitivity].[sp_transit_mode_metrics]",
     "args": "@scenario_id=?,@weight='persons',@metric='time'",
     "filter": "model == 'All Models'",
     "drop": ["model"],
     "sheets": ["transitModeShareTripLength"],
     "rows": [125]},
    # Transit Boardings by Mode
    {"sp": "[sensitivity].[sp_transit_onoff_metrics]",
     "args": "@scenario_id=?,@metric='boardings'",
     "filter": "time_period_desc == 'Total'",
     "drop": ["time_period_desc"],
     "sheets": ["transitNetwork"],
     "rows": [2]},
    # Transit Transfers by Mode
    {"sp": "[sensitivity].[sp_transit_onoff_metrics]",
     "args": "@scenario_id=?,@metric='transfers'",
     "filter": "time_period_desc == 'Total'",
     "drop": ["time_period_desc"],
     "sheets": ["transitNetwork"],
     "rows": [43]},
    # Transit Transfers per Transit Trip
    {"sp": "[sensitivity].[sp_transit_onoff_metrics]",
     "args": "@scenario_id=?,@metric='transfers per trip'",
     "filter": "time_period_desc == 'Total'",
     "drop": ["time_period_desc"],
     "sheets": ["transitNetwork"],
     "rows": [84]},
    # Work Segment Distance and Persons
    {"sp": "[sensitivity].[sp_work_location]",
     "args": "@scenario_id=?",
     "filter": "work_segment == 'All Workers'",
     "drop": ["work_segment"],
     "sheets": ["workSchoolLocation"],
     "rows": [2]},
    # Student Status Distance and Persons
    {"sp": "[sensitivity].[sp_school_location]",
     "args": "@scenario_id=?",
     "filter": "student_status == 'All Students'",
     "drop": ["student_status"],
     "sheets": ["workSchoolLocation"],
     "rows": [12]}
]
