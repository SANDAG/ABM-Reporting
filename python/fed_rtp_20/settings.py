# set path to RP19 Performance Measure Excel workbook template
template_path = ("./resources/fed_rtp_20/templates/"
                 "Scenario SDF Performance Measures_template.xlsx")

# set path to write completed
# Federal RTP 2020 Performance Measure Excel workbook
# and set protection option and password
template_write = "./Scenario SDF Performance Measures.xlsx"
template_protect = False
template_password = ""

# set SQL Server connection attributes
server = "${database_server}"
database = "${database_name}"


# initialize dictionary to hold ad-hoc queries to run
# and the sheets+rows in the Excel template to write result sets to
# ad-hoc queries must only contain a single row-set in the result set
adhoc_queries = [
    # scenario name
    {"query": ("SELECT [scenario_id], RTRIM([name]) AS [name] FROM "
               "[dimension].[scenario] WHERE [scenario_id] = ?"),
     "columns": ["scenario_id"] +
                ["name"] * 4,
     "sheets": ["Master"] * 2 +
               ["Main 8 Table",
                "Additional PM Table",
                "Social Equity PM Table"],
     "rows": [2] + [1] * 3 + [2]},
    # total households
    {"query": ("SELECT SUM([weight_household]) AS [total_hh] FROM "
               "[dimension].[household] WHERE [scenario_id] = ? "
               "AND [unittype] = 'Non-Group Quarters'"),
     "columns": ["total_hh"],
     "sheets": ["Master"],
     "rows": [3]},
    # total employment and college enrollment
    {"query": ("SELECT SUM([emp_total]) AS [emp_total],"
               "SUM([collegeenroll] + [othercollegeenroll]) AS [college] "
               "FROM [fact].[mgra_based_input] WHERE [scenario_id] = ?"),
     "columns": ["emp_total",
                 "college"],
     "sheets": ["Master"] * 2,
     "rows": [9, 10]},
    # total person trips
    {"query": ("SELECT SUM([weight_person_trip]) AS [person_trips] FROM "
               "[fact].[person_trip] WHERE [scenario_id] = ?"),
     "columns": ["person_trips"],
     "sheets": ["Master"],
     "rows": [15]}
]


# initialize dictionary to hold Performance Measure
# stored procedures to run, their arguments, and the sheets+rows
# in the Excel template to write result sets to
fed_rtp_20_pm = [
    # Performance Measure 1a
    {"sp": "[fed_rtp_20].[sp_pm_1a]",
     "args": "@scenario_id=?,@update=1,@silent=0",
     "metrics": ["Vehicle Delay per Capita"] * 2,
     "sheets": ["Master", "Main 8 Table"],
     "rows": [20, 2]},
    # Performance Measure 2a
    {"sp": "[fed_rtp_20].[sp_pm_2a]",
     "args": "@scenario_id=?,@update=1,@silent=0,@uats=0,@work=0",
     "metrics": ["Percentage of Total Person Trips - Drive Alone",
                 "Percentage of Total Person Trips - Shared Ride 2",
                 "Percentage of Total Person Trips - Shared Ride 3",
                 "Percentage of Total Person Trips - Transit",
                 "Percentage of Total Person Trips - Bike",
                 "Percentage of Total Person Trips - Walk",
                 "Percentage of Total Person Trips - Other",
                 "Percentage of Total Person Trips - Total Carpool",
                 "Percentage of Total Person Trips - Transit",
                 "Percentage of Total Person Trips - Total Bike and Walk"],
     "sheets": ["Master"] * 7 +
               ["Main 8 Table"] * 3,
     "rows": list(range(22, 29)) +
             list(range(4, 7))},
    # Performance Measure 2a - UATS
    {"sp": "[fed_rtp_20].[sp_pm_2a]",
     "args": "@scenario_id=?,@update=1,@silent=0,@uats=1,@work=0",
     "metrics": ["Percentage of Total Person Trips - Drive Alone",
                 "Percentage of Total Person Trips - Shared Ride 2",
                 "Percentage of Total Person Trips - Shared Ride 3",
                 "Percentage of Total Person Trips - Transit",
                 "Percentage of Total Person Trips - Bike",
                 "Percentage of Total Person Trips - Walk",
                 "Percentage of Total Person Trips - Other",
                 "Percentage of Total Person Trips - Total Carpool",
                 "Percentage of Total Person Trips - Transit",
                 "Percentage of Total Person Trips - Total Bike and Walk"],
     "sheets": ["Master"] * 7 +
               ["Main 8 Table"] * 3,
     "rows": list(range(38, 45)) +
             list(range(12, 15))},
    # Performance Measure 2a - Work
    {"sp": "[fed_rtp_20].[sp_pm_2a]",
     "args": "@scenario_id=?,@update=1,@silent=0,@uats=0,@work=1",
     "metrics": ["Percentage of Total Person Trips - Drive Alone",
                 "Percentage of Total Person Trips - Shared Ride 2",
                 "Percentage of Total Person Trips - Shared Ride 3",
                 "Percentage of Total Person Trips - Transit",
                 "Percentage of Total Person Trips - Bike",
                 "Percentage of Total Person Trips - Walk",
                 "Percentage of Total Person Trips - Other",
                 "Percentage of Total Person Trips - Total Carpool",
                 "Percentage of Total Person Trips - Transit",
                 "Percentage of Total Person Trips - Total Bike and Walk"],
     "sheets": ["Master"] * 7 +
               ["Main 8 Table"] * 3,
     "rows": list(range(30, 37)) +
             list(range(8, 11))},
    # Performance Measure 2a - UATS x Work
    {"sp": "[fed_rtp_20].[sp_pm_2a]",
     "args": "@scenario_id=?,@update=1,@silent=0,@uats=1,@work=1",
     "metrics": ["Percentage of Total Person Trips - Drive Alone",
                 "Percentage of Total Person Trips - Shared Ride 2",
                 "Percentage of Total Person Trips - Shared Ride 3",
                 "Percentage of Total Person Trips - Transit",
                 "Percentage of Total Person Trips - Bike",
                 "Percentage of Total Person Trips - Walk",
                 "Percentage of Total Person Trips - Other",
                 "Percentage of Total Person Trips - Total Carpool",
                 "Percentage of Total Person Trips - Transit",
                 "Percentage of Total Person Trips - Total Bike and Walk"],
     "sheets": ["Master"] * 7 +
               ["Main 8 Table"] * 3,
     "rows": list(range(46, 53)) +
             list(range(16, 19))},
    # Performance Measure 2b
    {"sp": "[fed_rtp_20].[sp_pm_2b]",
     "args": "@scenario_id=?,@update=1,@silent=0",
     "metrics": ["VMT",
                 "VMT per Capita",
                 "VMT per Capita"],
     "sheets": ["Master"] * 2 +
               ["Main 8 Table"],
     "rows": [11, 12,
              21]},
    # Performance Measure 6a
    {"sp": "[fed_rtp_20].[sp_pm_6a]",
     "args": "@scenario_id=?,@update=1,@silent=0",
     "metrics": ["Physical Activity per Capita - Total",
                 "Physical Activity per Capita - Low Income",
                 "Physical Activity per Capita - Non-Low Income",
                 "Physical Activity per Capita - Minority",
                 "Physical Activity per Capita - Non-Minority",
                 "Physical Activity per Capita - Senior",
                 "Physical Activity per Capita - Non-Senior",
                 "Physical Activity per Capita - Total",
                 "Physical Activity per Capita - Total",
                 "Physical Activity per Capita - Low Income",
                 "Physical Activity per Capita - Non-Low Income",
                 "Physical Activity per Capita - Minority",
                 "Physical Activity per Capita - Non-Minority",
                 "Physical Activity per Capita - Senior",
                 "Physical Activity per Capita - Non-Senior"],
     "sheets": ["Master"] * 7 +
               ["Main 8 Table"] +
               ["Social Equity PM Table"] * 7,
     "rows": list(range(74, 81)) +
             [31] +
             list(range(50, 57))},
    # Performance Measure A
    {"sp": "[fed_rtp_20].[sp_pm_A]",
     "args": "@scenario_id=?,@update=1,@silent=0",
     "metrics": ["Average Direct to Work Travel Time - Total - Total",
                 "Average Direct to Work Travel Time - Total - Drive Alone",
                 "Average Direct to Work Travel Time - Total - Shared Ride 2",
                 "Average Direct to Work Travel Time - Total - Shared Ride 3",
                 "Average Direct to Work Travel Time - Total - Transit",
                 "Average Direct to Work Travel Time - Total - Bike",
                 "Average Direct to Work Travel Time - Total - Walk",
                 "Average Direct to Work Travel Time - Low Income - Total",
                 "Average Direct to Work Travel Time - Low Income - Drive Alone",
                 "Average Direct to Work Travel Time - Low Income - Shared Ride 2",
                 "Average Direct to Work Travel Time - Low Income - Shared Ride 3",
                 "Average Direct to Work Travel Time - Low Income - Transit",
                 "Average Direct to Work Travel Time - Low Income - Bike",
                 "Average Direct to Work Travel Time - Low Income - Walk",
                 "Average Direct to Work Travel Time - Non-Low Income - Total",
                 "Average Direct to Work Travel Time - Non-Low Income - Drive Alone",
                 "Average Direct to Work Travel Time - Non-Low Income - Shared Ride 2",
                 "Average Direct to Work Travel Time - Non-Low Income - Shared Ride 3",
                 "Average Direct to Work Travel Time - Non-Low Income - Transit",
                 "Average Direct to Work Travel Time - Non-Low Income - Bike",
                 "Average Direct to Work Travel Time - Non-Low Income - Walk",
                 "Average Direct to Work Travel Time - Minority - Total",
                 "Average Direct to Work Travel Time - Minority - Drive Alone",
                 "Average Direct to Work Travel Time - Minority - Shared Ride 2",
                 "Average Direct to Work Travel Time - Minority - Shared Ride 3",
                 "Average Direct to Work Travel Time - Minority - Transit",
                 "Average Direct to Work Travel Time - Minority - Bike",
                 "Average Direct to Work Travel Time - Minority - Walk",
                 "Average Direct to Work Travel Time - Non-Minority - Total",
                 "Average Direct to Work Travel Time - Non-Minority - Drive Alone",
                 "Average Direct to Work Travel Time - Non-Minority - Shared Ride 2",
                 "Average Direct to Work Travel Time - Non-Minority - Shared Ride 3",
                 "Average Direct to Work Travel Time - Non-Minority - Transit",
                 "Average Direct to Work Travel Time - Non-Minority - Bike",
                 "Average Direct to Work Travel Time - Non-Minority - Walk",
                 "Average Direct to Work Travel Time - Total - Total",
                 "Average Direct to Work Travel Time - Total - Drive Alone",
                 "Average Direct to Work Travel Time - Total - Total Carpool",
                 "Average Direct to Work Travel Time - Total - Transit",
                 "Average Direct to Work Travel Time - Total - Bike",
                 "Average Direct to Work Travel Time - Total - Walk",
                 "Average Direct to Work Travel Time - Low Income - Total",
                 "Average Direct to Work Travel Time - Low Income - Drive Alone",
                 "Average Direct to Work Travel Time - Low Income - Total Carpool",
                 "Average Direct to Work Travel Time - Low Income - Transit",
                 "Average Direct to Work Travel Time - Low Income - Bike",
                 "Average Direct to Work Travel Time - Low Income - Walk",
                 "Average Direct to Work Travel Time - Non-Low Income - Total",
                 "Average Direct to Work Travel Time - Non-Low Income - Drive Alone",
                 "Average Direct to Work Travel Time - Non-Low Income - Total Carpool",
                 "Average Direct to Work Travel Time - Non-Low Income - Transit",
                 "Average Direct to Work Travel Time - Non-Low Income - Bike",
                 "Average Direct to Work Travel Time - Non-Low Income - Walk",
                 "Average Direct to Work Travel Time - Minority - Total",
                 "Average Direct to Work Travel Time - Minority - Drive Alone",
                 "Average Direct to Work Travel Time - Minority - Total Carpool",
                 "Average Direct to Work Travel Time - Minority - Transit",
                 "Average Direct to Work Travel Time - Minority - Bike",
                 "Average Direct to Work Travel Time - Minority - Walk",
                 "Average Direct to Work Travel Time - Non-Minority - Total",
                 "Average Direct to Work Travel Time - Non-Minority - Drive Alone",
                 "Average Direct to Work Travel Time - Non-Minority - Total Carpool",
                 "Average Direct to Work Travel Time - Non-Minority - Transit",
                 "Average Direct to Work Travel Time - Non-Minority - Bike",
                 "Average Direct to Work Travel Time - Non-Minority - Walk"],
     "sheets": ["Master"] * 35 +
               ["Additional PM Table"] * 6 +
               ["Social Equity PM Table"] * 24,
     "rows": list(range(194, 201)) +
             list(range(201, 208)) +
             list(range(208, 215)) +
             list(range(215, 222)) +
             list(range(222, 229)) +
             list(range(2, 8)) +
             list(range(4, 28))},
    # Performance Measure B
    {"sp": "[fed_rtp_20].[sp_pm_B]",
     "args": "@scenario_id=?,@update=1,@silent=0",
     "metrics": ["Average Travel Time"] * 2,
     "sheets": ["Master",
                "Additional PM Table"],
     "rows": [229,
              8]},
    # Performance Measure C
    {"sp": "[fed_rtp_20].[sp_pm_C]",
     "args": "@scenario_id=?,@update=1,@silent=0",
     "metrics": ["Average Travel Time - Total",
                 "Average Travel Time - San Ysidro",
                 "Average Travel Time - Otay Mesa",
                 "Average Travel Time - Otay Mesa East",
                 "Average Travel Time - Tecate",
                 "Average Travel Time - Jacumba"] * 2,
     "sheets": ["Master"] * 6 +
               ["Additional PM Table"] * 6,
     "rows": list(range(230, 236)) +
             list(range(9, 15))},
    # Performance Measure D
    {"sp": "[fed_rtp_20].[sp_pm_D]",
     "args": "@scenario_id=?,@update=1,@silent=0",
     "metrics": ["Average Travel Time"] * 2,
     "sheets": ["Master",
                "Additional PM Table"],
     "rows": [236,
              15]},
    # Performance Measure E
    {"sp": "[fed_rtp_20].[sp_pm_E]",
     "args": "@scenario_id=?,@update=1,@silent=0",
     "metrics": ["Average Travel Time"] * 2,
     "sheets": ["Master",
                "Additional PM Table"],
     "rows": [237,
              16]},
    # Performance Measure F
    {"sp": "[fed_rtp_20].[sp_pm_F]",
     "args": "@scenario_id=?,@update=1,@silent=0",
     "metrics": ["Percentage of Household Income Spent on Transportation Costs - Total",
                 "Percentage of Household Income Spent on Transportation Costs - Low Income",
                 "Percentage of Household Income Spent on Transportation Costs - Non-Low Income",
                 "Percentage of Household Income Spent on Transportation Costs - Minority",
                 "Percentage of Household Income Spent on Transportation Costs - Non-Minority",
                 "Percentage of Household Income Spent on Transportation Costs - Senior",
                 "Percentage of Household Income Spent on Transportation Costs - Non-Senior",
                 "Percentage of Household Income Spent on Transportation Costs - Total"],
     "sheets": ["Master"] * 7 +
               ["Additional PM Table"],
     "rows": list(range(238, 245)) +
             [17]},
    # Performance Measure H
    {"sp": "[fed_rtp_20].[sp_pm_H]",
     "args": "@scenario_id=?,@update=1,@silent=0",
     "metrics": ["Average Travel Time"] * 2,
     "sheets": ["Master"] +
               ["Additional PM Table"],
     "rows": [253] + [20]},
    # Performance Measure I
    {"sp": "[fed_rtp_20].[sp_pm_I]",
     "args": "@scenario_id=?,@update=1,@silent=0",
     "metrics": ["Percentage of Population Engaging in Transportation-Related Physical Activity - Total",
                 "Percentage of Population Engaging in Transportation-Related Physical Activity - Low Income",
                 "Percentage of Population Engaging in Transportation-Related Physical Activity - Non-Low Income",
                 "Percentage of Population Engaging in Transportation-Related Physical Activity - Minority",
                 "Percentage of Population Engaging in Transportation-Related Physical Activity - Non-Minority",
                 "Percentage of Population Engaging in Transportation-Related Physical Activity - Senior",
                 "Percentage of Population Engaging in Transportation-Related Physical Activity - Non-Senior",
                 "Percentage of Population Engaging in Transportation-Related Physical Activity - Total"],
     "sheets": ["Master"] * 7 +
               ["Additional PM Table"],
     "rows": list(range(254, 261)) +
             [21]},
    # Performance Measure J
    {"sp": "[fed_rtp_20].[sp_pm_J]",
     "args": "@scenario_id=?,@update=1,@silent=0",
     "metrics": ["Average Direct to Work Travel Distance - Total",
                 "Average Direct to Work Travel Distance - Drive Alone",
                 "Average Direct to Work Travel Distance - Total Carpool",
                 "Average Direct to Work Travel Distance - Transit",
                 "Average Direct to Work Travel Distance - Bike",
                 "Average Direct to Work Travel Distance - Walk"] * 2,
     "sheets": ["Master"] * 6 +
               ["Additional PM Table"] * 6,
     "rows": list(range(261, 267)) +
             list(range(22, 28))},
    # Federal RTP 2020 Populations
    {"sp": "[fed_rtp_20].[sp_population]",
     "args": "@scenario_id=?,@update=1,@silent=0",
     "metrics": ["Population - Total",
                 "Population - Low Income",
                 "Population - Minority",
                 "Population - Senior",
                 "Population - CoC"],
     "sheets": ["Master"] * 5,
     "rows": list(range(4, 9))
     }
]
