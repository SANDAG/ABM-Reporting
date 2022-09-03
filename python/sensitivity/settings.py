# set paths to Sensitivity Excel workbook templates
templatePaths = {
    "scenarioTemplate": ("./resources/templates/"
                         "Scenario Sensitivity_template.xlsx"),
    "multipleScenariosTemplate": ("./resources/templates/"
                                  "Multiple Scenarios Sensitivity_template.xlsx")
}

# set path to write completed Sensitivity Excel workbook
# and set protection option and password
templateWritePaths = {
    "scenarioTemplate": "./Scenario Sensitivity Measures",
    "multipleScenariosTemplate": "./Multiple Scenarios Sensitivity Measures"
}

# initialize dictionary to hold single scenario Sensitivity Measures
# processes to run, their arguments, and the sheets+rows
# in the Excel template to write result sets to
singleScenarioMeasures = [
    # Person Counts
    # Persons by Worker and Non-Worker
    {"class": "TripLists",
     "fn": "count_persons",
     "args": {},
     "sheet": "Persons Counts",
     "row": 2},
    # Person Counts by Telework Status
    {"class": "TripLists",
     "fn": "count_workers_by_telestatus",
     "args": {},
     "sheet": "Persons Counts",
     "row": 10},
    # Person Counts by Telework Status
    {"class": "TripLists",
     "fn": "count_workers_by_telestatus",
     "args": {"occasional_telework": 'yes'},
     "sheet": "Persons Counts",
     "row": 18},
    #################################################################
    # VMT calculations
    # VMT per capita by telework status Summary
    {"class": "TripLists",
     "fn": "calculate_telework_metric",
     "args": {"metric": "vmt_per_capita", "weight": "trips"},
     "sheet": "VMTperworker",
     "row": 2},
    # Total Trip VMT
    {"class": "TripLists",
     "fn": "calculate_telework_metric",
     "args": {"metric": "totalvmt", "weight": "trips"},
     "sheet": "VMTperworker",
     "row": 9},
    #################################################################
    # VMT TOD
    # VMT per capita by TOD
    {"class": "TripLists",
     "fn": "calculate_tod_metric_telework",  # 1
     "args": {"metric": "vmt_per_capita", "weight": "trips"},
     "sheet": "vmtTOD",
     "row": 1},
    # share VMT per capita by TOD
    {"class": "TripLists",
     "fn": "calculate_tod_metric_telework",  # 2
     "args": {"metric": "vmt_per_capita_share", "weight": "trips"},
     "sheet": "vmtTOD",
     "row": 10},
    # VMT per capita by TOD occasional_telework
    {"class": "TripLists",
     "fn": "calculate_tod_metric_telework",  # 3
     "args": {"metric": "vmt_per_capita", "weight": "trips", "occasional_telework": 'yes'},
     "sheet": "vmtTOD",
     "row": 19},
    # share VMT per capita by TOD occasional_telework
    {"class": "TripLists",
     "fn": "calculate_tod_metric_telework",  # 4
     "args": {"metric": "vmt_per_capita_share", "weight": "trips", "occasional_telework": 'yes'},
     "sheet": "vmtTOD",
     "row": 28},
    #################################################################
    # Person Trips by TOD & Telework Status share
    {"class": "TripLists",
     "fn": "calculate_tod_metric_telework",  # 4
     "args": {"metric": "share", "weight": "persons", "resident_only": "yes"},
     "sheet": "tripsTOD",
     "row": 3},
    # Trips by TOD & Telework Status share
    {"class": "TripLists",
     "fn": "calculate_tod_metric_telework",  # 5
     "args": {"metric": "share", "weight": "trips", "resident_only": "yes"},
     "sheet": "tripsTOD",
     "row": 14},
    # Person Trips by TOD & Telework Status
    {"class": "TripLists",
     "fn": "calculate_tod_metric_telework",  # 6
     "args": {"metric": "trips", "weight": "persons", "resident_only": "yes"},
     "sheet": "tripsTOD",
     "row": 26},
    # Trips by TOD & Telework Status
    {"class": "TripLists",
     "fn": "calculate_tod_metric_telework",  # 7
     "args": {"metric": "trips", "weight": "trips", "resident_only": "yes"},
     "sheet": "tripsTOD",
     "row": 37},
    #################################################################
    # Trip Rate
    # Person Trip Rate by Telework Status
    {"class": "TripLists",
     "fn": "calculate_telework_metric",
     "args": {"metric": "trip_rate", "weight": "persons", "resident_only": "yes"},
     "sheet": "tripRate",
     "row": 2},
    # Trip Rate by Telework Status
    {"class": "TripLists",
     "fn": "calculate_telework_metric",
     "args": {"metric": "trip_rate", "weight": "trips", "resident_only": "yes"},
     "sheet": "tripRate",
     "row": 7},
    ################################################################
    # Mode Share
    # Person Trip Mode Share
    {"class": "TripLists",
     "fn": "calculate_mode_metric",
     "args": {"metric": "share", "weight": "persons"},
     "sheet": "modeShare",
     "row": 2},
    # Trip Mode Share
    {"class": "TripLists",
     "fn": "calculate_mode_metric",
     "args": {"metric": "share", "weight": "trips"},
     "sheet": "modeShare",
     "row": 20},
    # Person Trips by Mode
    {"class": "TripLists",
     "fn": "calculate_mode_metric",
     "args": {"metric": "trips", "weight": "persons"},
     "sheet": "modeShare",
     "row": 38},
    # Trips by Mode
    {"class": "TripLists",
     "fn": "calculate_mode_metric",
     "args": {"metric": "trips", "weight": "trips"},
     "sheet": "modeShare",
     "row": 56},
    # #################################################################
    # Mode Share Telework
    # Person Trip Mode Share by Telework
    {"class": "TripLists",
     "fn": "calculate_mode_metric_telework",
     "args": {"metric": "share", "weight": "persons"},
     "sheet": "modeShareTele",
     "row": 2},
    # Trip Mode Share by Telework
    {"class": "TripLists",
     "fn": "calculate_mode_metric_telework",
     "args": {"metric": "share", "weight": "trips"},
     "sheet": "modeShareTele",
     "row": 11},
    # Person Trips by Mode by Telework
    {"class": "TripLists",
     "fn": "calculate_mode_metric_telework",
     "args": {"metric": "trips", "weight": "persons"},
     "sheet": "modeShareTele",
     "row": 20},
    # Trips by Mode by Telework
    {"class": "TripLists",
     "fn": "calculate_mode_metric_telework",
     "args": {"metric": "trips", "weight": "trips"},
     "sheet": "modeShareTele",
     "row": 29},
    #################################################################
    # tripLengthMode
    # Person Trip Distance by Mode
    {"class": "TripLists",
     "fn": "calculate_mode_metric",
     "args": {"metric": "distance", "weight": "persons"},
     "sheet": "tripLengthMode",
     "row": 2},
    # Trip Distance by Mode
    {"class": "TripLists",
     "fn": "calculate_mode_metric",
     "args": {"metric": "distance", "weight": "trips"},
     "sheet": "tripLengthMode",
     "row": 20},
    # Person Trip Time by Mode
    {"class": "TripLists",
     "fn": "calculate_mode_metric",
     "args": {"metric": "time", "weight": "persons"},
     "sheet": "tripLengthMode",
     "row": 38},
    # Trip Time by Mode
    {"class": "TripLists",
     "fn": "calculate_mode_metric",
     "args": {"metric": "time", "weight": "trips"},
     "sheet": "tripLengthMode",
     "row": 56},
    #################################################################
    # tripLengthMode by Tele
    # Person Trip Distance by Mode and Telework
    {"class": "TripLists",
     "fn": "calculate_mode_metric_telework",
     "args": {"metric": "distance", "weight": "persons"},
     "sheet": "tripLengthModeTele",
     "row": 2},
    # Trip Distance by Mode and Telework
    {"class": "TripLists",
     "fn": "calculate_mode_metric_telework",
     "args": {"metric": "distance", "weight": "trips"},
     "sheet": "tripLengthModeTele",
     "row": 11},
    # Person Trip Time by Mode and Telework
    {"class": "TripLists",
     "fn": "calculate_mode_metric_telework",
     "args": {"metric": "time", "weight": "persons"},
     "sheet": "tripLengthModeTele",
     "row": 20},
    # Trip Time by Mode and Telework
    {"class": "TripLists",
     "fn": "calculate_mode_metric_telework",
     "args": {"metric": "time", "weight": "trips"},
     "sheet": "tripLengthModeTele",
     "row": 29},
    #################################################################
    # Purpose Share
    # Person Trip Purpose Share
    {"class": "TripLists",
     "fn": "calculate_purpose_metric",
     "args": {"metric": "share", "weight": "persons"},
     "sheet": "purposeShare",
     "row": 2},
    # Trip Purpose Share
    {"class": "TripLists",
     "fn": "calculate_purpose_metric",
     "args": {"metric": "share", "weight": "trips"},
     "sheet": "purposeShare",
     "row": 20},
    # Person Trips by Purpose
    {"class": "TripLists",
     "fn": "calculate_purpose_metric",
     "args": {"metric": "trips", "weight": "persons"},
     "sheet": "purposeShare",
     "row": 38},
    # Trips by Purpose
    {"class": "TripLists",
     "fn": "calculate_purpose_metric",
     "args": {"metric": "trips", "weight": "trips"},
     "sheet": "purposeShare",
     "row": 56},
    ################################################################
    # Purpose Share by Telework status
    # Person Trip Purpose Share by Telework status
    {"class": "TripLists",
     "fn": "calculate_purpose_metric_telework",
     "args": {"metric": "share", "weight": "persons", "resident_only": "yes"},
     "sheet": "purposeShareTele",
     "row": 2},
    # Trip Purpose Share by Telework status
    {"class": "TripLists",
     "fn": "calculate_purpose_metric_telework",
     "args": {"metric": "share", "weight": "trips", "resident_only": "yes"},
     "sheet": "purposeShareTele",
     "row": 11},
    # Person Trips by Purpose by Telework status
    {"class": "TripLists",
     "fn": "calculate_purpose_metric_telework",
     "args": {"metric": "trips", "weight": "persons", "resident_only": "yes"},
     "sheet": "purposeShareTele",
     "row": 20},
    # Trips by Purpose by Telework status
    {"class": "TripLists",
     "fn": "calculate_purpose_metric_telework",
     "args": {"metric": "trips", "weight": "trips", "resident_only": "yes"},
     "sheet": "purposeShareTele",
     "row": 29},
    ################################################################
    # tripLengthPurpose
    # Person Trip Distance by Purpose
    {"class": "TripLists",
     "fn": "calculate_purpose_metric",
     "args": {"metric": "distance", "weight": "persons"},
     "sheet": "tripLengthPurpose",
     "row": 2},
    # Trip Distance by Purpose
    {"class": "TripLists",
     "fn": "calculate_purpose_metric",
     "args": {"metric": "distance", "weight": "trips"},
     "sheet": "tripLengthPurpose",
     "row": 20},
    # Person Trip Time by Purpose
    {"class": "TripLists",
     "fn": "calculate_purpose_metric",
     "args": {"metric": "time", "weight": "persons"},
     "sheet": "tripLengthPurpose",
     "row": 38},
    # Trip Time by Purpose
    {"class": "TripLists",
     "fn": "calculate_purpose_metric",
     "args": {"metric": "time", "weight": "trips"},
     "sheet": "tripLengthPurpose",
     "row": 56},
    ###############################################################
    # tripLengthPurpose by Telestatus
    # Person Trip Distance by Purpose
    {"class": "TripLists",
     "fn": "calculate_purpose_metric_telework",
     "args": {"metric": "distance", "weight": "persons", "resident_only": "yes"},
     "sheet": "tripLengthPurposeTele",
     "row": 2},
    # Trip Distance by Purpose
    {"class": "TripLists",
     "fn": "calculate_purpose_metric_telework",
     "args": {"metric": "distance", "weight": "trips", "resident_only": "yes"},
     "sheet": "tripLengthPurposeTele",
     "row": 11},
    # Person Trip Time by Purpose
    {"class": "TripLists",
     "fn": "calculate_purpose_metric_telework",
     "args": {"metric": "time", "weight": "persons", "resident_only": "yes"},
     "sheet": "tripLengthPurposeTele",
     "row": 20},
    # Trip Time by Purpose
    {"class": "TripLists",
     "fn": "calculate_purpose_metric_telework",
     "args": {"metric": "time", "weight": "trips", "resident_only": "yes"},
     "sheet": "tripLengthPurposeTele",
     "row": 29},
    ###############################################################
    # Trip Rate by Purpose by Telework status
    # Person Trip Rate by Purpose
    {"class": "TripLists",
     "fn": "calculate_purpose_metric_telework",
     "args": {"metric": "trip_rate", "weight": "persons", "resident_only": "yes"},
     "sheet": "tripRatePurposeTele",
     "row": 2},
    # Trip Rate by Purpose
    {"class": "TripLists",
     "fn": "calculate_purpose_metric_telework",
     "args": {"metric": "trip_rate", "weight": "trips", "resident_only": "yes"},
     "sheet": "tripRatePurposeTele",
     "row": 13},
    #################################################################
    # VMT by IFC and Mode
    {"class": "HighwayNetwork",
     "fn": "calculate_vmt",
     "args": None,
     "sheet": "highwayNetwork",
     "row": 2},
    # VHT by IFC and Mode
    {"class": "HighwayNetwork",
     "fn": "calculate_vht",
     "args": None,
     "sheet": "highwayNetwork",
     "row": 18},
    # VHD by IFC and Mode
    {"class": "HighwayNetwork",
     "fn": "calculate_vhd",
     "args": None,
     "sheet": "highwayNetwork",
     "row": 34},
    # Transit Boardings by Mode
    {"class": "TransitNetwork",
     "fn": "calculate_boardings",
     "args": None,
     "sheet": "transitNetwork",
     "row": 2},
    # Transit Transfers by Mode
    {"class": "TransitNetwork",
     "fn": "calculate_transfers",
     "args": None,
     "sheet": "transitNetwork",
     "row": 13},
    # AV and TNC Passengers Category trip share
    {"class": "TripLists",
     "fn": "calculate_passenger_metric",
     "args": {"metric": "share"},
     "sheet": "AVsTNCs",
     "row": 2},
    # AV and TNC Trips by Passengers
    {"class": "TripLists",
     "fn": "calculate_passenger_metric",
     "args": {"metric": "trips"},
     "sheet": "AVsTNCs",
     "row": 10},
    # AV and TNC VMT by Passengers
    {"class": "TripLists",
     "fn": "calculate_passenger_metric",
     "args": {"metric": "vmt"},
     "sheet": "AVsTNCs",
     "row": 26},
    # AV and TNC Trip Distance by Passengers
    {"class": "TripLists",
     "fn": "calculate_passenger_metric",
     "args": {"metric": "distance"},
     "sheet": "AVsTNCs",
     "row": 34},
    # AV and TNC Trip Distance by Passengers
    {"class": "TripLists",
     "fn": "calculate_passenger_metric",
     "args": {"metric": "time"},
     "sheet": "AVsTNCs",
     "row": 42},
    # Auto Ownership - Average by Category
    {"class": "LandUse",
     "fn": "calculate_ao_metric",
     "args": None,
     "sheet": "autoOwnership",
     "row": 2},
    # Total Person Trips
    {"class": "TripLists",
     "fn": "calculate_model_metric",
     "args": {"metric": "trips", "weight": "persons"},
     "sheet": "totalTrips",
     "row": 2},
    # Total Trips
    {"class": "TripLists",
     "fn": "calculate_model_metric",
     "args": {"metric": "trips", "weight": "trips"},
     "sheet": "totalTrips",
     "row": 8},
    #################################################################
    # Micro transit summary
    {"class": "TripLists",
     "fn": "calculate_microtransit",
     "args": {"visitor": False},
     "sheet": "microTransit",
     "row": 2},
    {"class": "TripLists",
     "fn": "calculate_microtransit",
     "args": {"visitor": True},
     "sheet": "microTransit",
     "row": 10}
]

# initialize dictionary to hold multiple scenario Sensitivity Measures
# processes to run, their arguments, result set filters,
# columns to drop from the result set, and the sheet+starting row in the
# Excel template to write result sets to
multipleScenarioMeasures = [
    # Person Trip Mode Share - Resident Models
    {"class": "TripLists",
     "fn": "calculate_mode_metric",
     "args": {"metric": "share", "weight": "persons"},
     "filter": "model == 'Resident Models'",
     "drop": None,
     "sheet": "modeShare",
     "row": 3},
    # Person Trip Mode Share - All Models
    {"class": "TripLists",
     "fn": "calculate_mode_metric",
     "args": {"metric": "share", "weight": "persons"},
     "filter": "model == 'All Models'",
     "drop": None,
     "sheet": "modeShare",
     "row": 44},
    # Person Trip Distance by Mode - Resident Models
    {"class": "TripLists",
     "fn": "calculate_mode_metric",
     "args": {"metric": "distance", "weight": "persons"},
     "filter": "model == 'Resident Models'",
     "drop": None,
     "sheet": "tripLengthMode",
     "row": 3},
    # Person Trip Distance by Mode - All Models
    {"class": "TripLists",
     "fn": "calculate_mode_metric",
     "args": {"metric": "distance", "weight": "persons"},
     "filter": "model == 'All Models'",
     "drop": None,
     "sheet": "tripLengthMode",
     "row": 44},
    # Person Trip Time by Mode - Resident Models
    {"class": "TripLists",
     "fn": "calculate_mode_metric",
     "args": {"metric": "time", "weight": "persons"},
     "filter": "model == 'Resident Models'",
     "drop": None,
     "sheet": "tripLengthMode",
     "row": 85},
    # Person Trip Time by Mode - All Models
    {"class": "TripLists",
     "fn": "calculate_mode_metric",
     "args": {"metric": "time", "weight": "persons"},
     "filter": "model == 'All Models'",
     "drop": None,
     "sheet": "tripLengthMode",
     "row": 126},
    # Person Trip Purpose Share - Resident Models
    {"class": "TripLists",
     "fn": "calculate_purpose_metric",
     "args": {"metric": "share", "weight": "persons"},
     "filter": "model == 'Resident Models'",
     "drop": None,
     "sheet": "purposeShare",
     "row": 3},
    # Person Trip Purpose Share - All Models
    {"class": "TripLists",
     "fn": "calculate_purpose_metric",
     "args": {"metric": "share", "weight": "persons"},
     "filter": "model == 'All Models'",
     "drop": None,
     "sheet": "purposeShare",
     "row": 44},
    # Person Trip Distance by Purpose - Resident Models
    {"class": "TripLists",
     "fn": "calculate_purpose_metric",
     "args": {"metric": "distance", "weight": "persons"},
     "filter": "model == 'Resident Models'",
     "drop": None,
     "sheet": "tripLengthPurpose",
     "row": 3},
    # Person Trip Distance by Purpose - All Models
    {"class": "TripLists",
     "fn": "calculate_purpose_metric",
     "args": {"metric": "distance", "weight": "persons"},
     "filter": "model == 'All Models'",
     "drop": None,
     "sheet": "tripLengthPurpose",
     "row": 44},
    # Person Trip Time by Purpose - Resident Models
    {"class": "TripLists",
     "fn": "calculate_purpose_metric",
     "args": {"metric": "time", "weight": "persons"},
     "filter": "model == 'Resident Models'",
     "drop": None,
     "sheet": "tripLengthPurpose",
     "row": 85},
    # Person Trip Time by Purpose - All Models
    {"class": "TripLists",
     "fn": "calculate_purpose_metric",
     "args": {"metric": "time", "weight": "persons"},
     "filter": "model == 'All Models'",
     "drop": None,
     "sheet": "tripLengthPurpose",
     "row": 126},
    # VMT by IFC and Mode
    {"class": "HighwayNetwork",
     "fn": "calculate_vmt",
     "args": None,
     "filter": "ifc_desc == 'Total'",
     "drop": ["ifc_desc"],
     "sheet": "highwayNetwork",
     "row": 3},
    # VHT by IFC and Mode
    {"class": "HighwayNetwork",
     "fn": "calculate_vht",
     "args": None,
     "filter": "ifc_desc == 'Total'",
     "drop": ["ifc_desc"],
     "sheet": "highwayNetwork",
     "row": 44},
    # VHD by IFC and Mode
    {"class": "HighwayNetwork",
     "fn": "calculate_vhd",
     "args": None,
     "filter": "ifc_desc == 'Total'",
     "drop": ["ifc_desc"],
     "sheet": "highwayNetwork",
     "row": 85},
    # Transit Boardings by Mode
    {"class": "TransitNetwork",
     "fn": "calculate_boardings",
     "args": None,
     "filter": "TOD == 'All'",
     "drop": None,
     "sheet": "transitNetwork",
     "row": 3},
    # Transit Transfers by Mode
    {"class": "TransitNetwork",
     "fn": "calculate_transfers",
     "args": None,
     "filter": "TOD == 'All'",
     "drop": None,
     "sheet": "transitNetwork",
     "row": 44},
    # AV and TNC Passengers Category trips
    {"class": "TripLists",
     "fn": "calculate_passenger_metric",
     "args": {"metric": "trips"},
     "filter": "model == 'AVs and TNCs'",
     "drop": None,
     "sheet": "AVsTNCs",
     "row": 3},
    # AV and TNC Passengers Category trip share
    {"class": "TripLists",
     "fn": "calculate_passenger_metric",
     "args": {"metric": "share"},
     "filter": "model == 'AVs and TNCs'",
     "drop": None,
     "sheet": "AVsTNCs",
     "row": 23},
    # AV Passengers Category trips
    {"class": "TripLists",
     "fn": "calculate_passenger_metric",
     "args": {"metric": "trips"},
     "filter": "model == 'AVs'",
     "drop": None,
     "sheet": "AVsTNCs",
     "row": 64},
    # AV Passengers Category trip share
    {"class": "TripLists",
     "fn": "calculate_passenger_metric",
     "args": {"metric": "share"},
     "filter": "model == 'AVs'",
     "drop": None,
     "sheet": "AVsTNCs",
     "row": 84},
    # TNC Passengers Category trips
    {"class": "TripLists",
     "fn": "calculate_passenger_metric",
     "args": {"metric": "trips"},
     "filter": "model == 'TNCs'",
     "drop": None,
     "sheet": "AVsTNCs",
     "row": 125},
    # TNC Passengers Category trip share
    {"class": "TripLists",
     "fn": "calculate_passenger_metric",
     "args": {"metric": "share"},
     "filter": "model == 'TNCs'",
     "drop": None,
     "sheet": "AVsTNCs",
     "row": 145},
    # AV and TNC VMT by Passengers
    {"class": "TripLists",
     "fn": "calculate_passenger_metric",
     "args": {"metric": "vmt"},
     "filter": "model == 'AVs and TNCs'",
     "drop": None,
     "sheet": "AVsTNCs",
     "row": 187},
     # AV VMT by Passengers
    {"class": "TripLists",
     "fn": "calculate_passenger_metric",
     "args": {"metric": "vmt"},
     "filter": "model == 'AVs'",
     "drop": None,
     "sheet": "AVsTNCs",
     "row": 247},
    # Total Person Trips
    {"class": "TripLists",
     "fn": "calculate_model_metric",
     "args": {"metric": "trips", "weight": "persons"},
     "filter": None,
     "drop": None,
     "sheet": "totalTrips",
     "row": 3},
    # Total Trips
    {"class": "TripLists",
     "fn": "calculate_model_metric",
     "args": {"metric": "trips", "weight": "trips"},
     "filter": None,
     "drop": None,
     "sheet": "totalTrips",
     "row": 35},
    # Auto Ownership - Average by Category
    {"class": "LandUse",
     "fn": "calculate_ao_metric",
     "args": None,
     "filter": None,
     "drop": None,
     "sheet": "autoOwnership",
     "row": 3}
]
