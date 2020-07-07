
# set path to Report Excel workbook template
# template_path = "./resources/template/Mode_Choice_Template.xlsx"
template_path = "T:/ABM/SB/Template/Analysis/ModeChoice/Mode_Choice_Template.xlsx"

# note: original template_path on T drive:
# "\\nasb8\transdata\ABM\SB\Template\Analysis\ModeChoice\Mode_Choice_Template.xlsx"

# set path to write completed
# Excel workbook
report_write_path = "./Mode_Choice"

# set protection option and password
template_protect = False #True
template_password = ""

# set SQL Server connection attributes
server = "sql2014a8"
database = "popsyn_3_0"


# initialize dictionary to hold report queries to run
# and the sheets in the Excel template to write result sets to
report_queries = [
    # --===========book1==============
    # -- Book1_1  "LandUse":
    {"sp": "[sbreport].[lu_input_summary_mgra]",
     "args": "@scenario_id=?",
     "sheet": "LandUse - Book 1_1"},
    # -- Book1_2  "Residents":
    {"sp": "[sbreport].[resident_person_type_mgra]",
     "args": "@scenario_id=?",
     "sheet": "Residents - Book 1_2"},
    # -- Book1_3  "Employees":
    {"sp": "[sbreport].[employee_employ_type_mgra]",
     "args": "@scenario_id=?",
     "sheet": "Employees - Book 1_3"},
    # --===========book2==============
    # -- Book2_1  "InternalCapture":
    {"sp": "[sbreport].[res_ptrip_od_mgra]",
     "args": "@scenario_id=?",
     "sheet": "InternalCapture - Book 2_1"},
    # -- Book2_2  "PersonTripbyPurpose":
    {"sp": "[sbreport].[res_trip_purpose_mgra]",
     "args": "@scenario_id=?",
     "sheet": "TripPurpose - Book 2_2"},
    # -- Book2_3  "PersonTripbyModeChoice":
    {"sp": "[sbreport].[res_trip_mode_mgra]",
     "args": "@scenario_id=?",
     "sheet": "ModeChoice - Book 2_3"},
    # -- Book2_4  "PersonTripLength1":
    {"sp": "[sbreport].[res_triplength_all_mgra]",
     "args": "@scenario_id=?",
     "sheet": "PersonTripLength1 - Book 2_4"},
    # -- Book2_5  "CommuteModeChoice1":
    {"sp": "[sbreport].[res_trip_mode_commuter_mgra]",
     "args": "@scenario_id=?",
     "sheet": "CommuteModeChoice1 - Book 2_5"},
    # -- Book2_6  "Vehicle TripLength of Auto Modes, Residential Model", added on 10/31/2019
    {"sp": "[sbreport].[res_auto_mgra_vtrip_distance]",
     "args": "@scenario_id=?",
     "sheet": "VehicleTripLength - Book 2_6"},
    # --===========book22==============
    # -- Book22_1  "TourPerson_by_Orig":
    {"sp": "[sbreport].[res_commutertour_bymode_person_origmgra]",
     "args": "@scenario_id=?",
     "sheet": "ResTourPersonTrips - Book 22_1"},
    # -- Book22_2  "TourPerson_by_Dest":
    {"sp": "[sbreport].[res_commutertour_bymode_person_destmgra]",
     "args": "@scenario_id=?",
     "sheet": "EmpTourPersonTrips - Book 22_2"},
    # -- Book22_3  "TourPMT_by_Orig":
    {"sp": "[sbreport].[res_commutertour_bymode_pmt_origmgra]",
     "args": "@scenario_id=?",
     "sheet": "ResTourPMT - Book 22_3"},
    # -- Book22_4  "TourPMT_by_Dest":
    {"sp": "[sbreport].[res_commutertour_bymode_pmt_destmgra]",
     "args": "@scenario_id=?",
     "sheet": "EmpTourPMT - Book 22_4"},
    # -- Book22_5  "Tour_Average_Distance_by_Orig":
    {"sp": "[sbreport].[res_commutertour_bymode_distance_origmgra]",
     "args": "@scenario_id=?",
     "sheet": "ResTourATL - Book 22_5"},
    # -- Book22_6  "Tour_Average_Distance_by_Dest":
    {"sp": "[sbreport].[res_commutertour_bymode_distance_destmgra]",
     "args": "@scenario_id=?",
     "sheet": "EmpTourATL - Book 22_6"},
    # -- Book3_1  "ModelTypeTrips":
    {"sp": "[sbreport].[sim_trip_by_modeltype_mgra]",
     "args": "@scenario_id=?",
     "sheet": "ModelTypeTrips - Book 3_1"},
    # -- Book3_2  "TripsByMode":
    {"sp": "[sbreport].[sim_trip_bymode_mgra]",
     "args": "@scenario_id=?",
     "sheet": "TripsByMode - Book 3_2"},
    # -- Book3_3  "TripLength2":
    {"sp": "[sbreport].[sim_length_by_modeltype_mgra]",
     "args": "@scenario_id=?",
     "sheet": "TripLength2 - Book 3_3"},
    # -- Book3_4  "PersonMiles":
    {"sp": "[sbreport].[sim_length_all_mgra]",
     "args": "@scenario_id=?",
     "sheet": "PersonMiles - Book 3_4"},
    # -- Book3_5  "CommuteModeChoice2":
    {"sp": "[sbreport].[sim_commuter_mode_mgra]",
     "args": "@scenario_id=?",
     "sheet": "CommuteModeChoice2 - Book 3_5"},
    # -- Book3_6  "Vehicle TripLength of Auto Modes by Model Type", new added on 10/31/2019
    {"sp": "[sbreport].[sim_auto_vtrip_distance_by_mgra_modeltype]",
     "args": "@scenario_id=?",
     "sheet": "VehicleTripLength2 - Book 3_6"},
]
