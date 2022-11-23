import datetime
from msilib import schema
from accessMeasures import AccessMeasures
from performanceMeasuresGIS import PerformanceMeasuresGIS
import settings
import openpyxl
import os
import pandas as pd

# get GIS Performance Measures and populate SQL Server results table
print("---- Getting GIS Performance Measures ----")
for scenario in settings.scenarios:
    print("Scenario: " + str(scenario))

    # if scenario is the 2020 SB375 only scenario then skip access measures
    if settings.scenarios[scenario] == "2020":
        print("SB375 only scenario: no GIS access measures calculated")
    else:
        gis_data = PerformanceMeasuresGIS(scenario)
        gis_data.insert_performance_measures()
        print("Finished getting GIS Performance Measures")

# run SQL-based Performance Measures and populate SQL Server results table
print("---- Running SQL-based Performance Measures ----")
for scenario in settings.scenarios:
    print("Scenario: " + str(scenario))

    # for each performance measure
    for measureKey in settings.sql_measures:
        print("Measure: " + measureKey)

        # get the performance measure dictionary
        measureDict = settings.sql_measures[measureKey]

        # execute stored procedure with specified arguments
        with settings.engines["ABM-Reporting"].begin() as conn:
            sql = "EXECUTE " + measureDict["sp"] + " " + measureDict["args"]
            conn.execute(sql.format(scenario))

# run Python-based Performance Measures and populate SQL Server results table
print("---- Running Python-based Performance Measures ----")
for scenario in settings.scenarios:
    print("Scenario: " + str(scenario))

    # initialize access measure class object
    access = AccessMeasures(
        scenario_id = scenario,
        conn = settings.engines["ABM-Reporting"]
    )

    # for each performance measure
    for measureKey in settings.python_measures:
        print("Measure: " + measureKey)

        # for each corridor
        for corridor in settings.cmcp_corridor:

            # delete old results from the results table if they exist
            with settings.engines["ABM-Reporting"].begin() as conn:
                conn.execute(
                    "DELETE FROM [dbo].[cmcp2021_results_NBE_TEST] WHERE [scenario_id] = " +
                    str(scenario) + " AND [measure] = '" + measureKey + 
                    "' AND [cmcp_name] = '" + corridor + "'"
                )

            # for each metric within the performance measure
            for metricKey in settings.python_measures[measureKey]:
                metricDict = settings.python_measures[measureKey][metricKey]

                # add corridor name to dictionary of arguments
                args = metricDict["args"]
                args["cmcp_name"] = corridor

                # run the appropriate class method and write results to results table
                func = getattr(access, metricDict["method"])(**args)
                result = func.to_frame(name="value")
                result["scenario_id"] = scenario
                result["cmcp_name"] = corridor
                result["measure"] = measureKey
                result["metric"] = result.index + " - " + metricKey
                result["updated_by"] = os.environ["userdomain"] + "\\" + os.getenv("username")
                result["updated_date"] = datetime.datetime.now()

                result = result[["scenario_id",
                                 "cmcp_name",
                                 "measure",
                                 "metric",
                                 "value",
                                 "updated_by",
                                 "updated_date"]]

                result.to_sql(name="cmcp2021_results_NBE_TEST",
                              schema="dbo",
                              con=settings.engines["ABM-Reporting"],
                              if_exists="append",
                              index=False,
                              method="multi")

# # run Python-based Performance Measures and populate SQL Server results table
# print("---- Running Python-based Performance Measures ----")
# for scenario in settings.scenarios:
#     print("Scenario: " + str(scenario))
#
#     # if scenario is the 2020 SB375 only scenario then skip access measures
#     if settings.scenarios[scenario] == "2020":
#         print("SB375 only scenario: no access measures calculated")
#     else:
#         # initialize access measure class object
#         pm_m1_m5 = PerformanceMeasuresM1M5(scenario)
#
#         # for each performance measure
#         for measureKey in settings.python_measures:
#             print("Measure: " + measureKey)
#
#             # delete old results from the results table if they exist
#             with settings.engines["ABM-Reporting"].begin() as conn:
#                 conn.execute(
#                     "DELETE FROM [rp_2021].[results] WHERE [scenario_id] = " +
#                     str(scenario) + " AND [measure] = '" + measureKey + "'")
#
#             # for each metric within the performance measure
#             for metricKey in settings.python_measures[measureKey]:
#                 metricDict = settings.python_measures[measureKey][metricKey]
#                 # run the appropriate class method and write results to results table
#                 if metricDict["class"] == "PerformanceMeasuresM1M5":
#
#                     func = getattr(pm_m1_m5, metricDict["method"])(**metricDict["args"])
#                     result = func.to_frame(name="value")
#                     result["scenario_id"] = scenario
#                     result["measure"] = measureKey
#                     result["metric"] = result.index + " - " + metricKey
#                     result["updated_by"] = os.environ["userdomain"] + "\\" + os.getenv("username")
#                     result["updated_date"] = datetime.datetime.now()
#
#                     result = result[["scenario_id",
#                                      "measure",
#                                      "metric",
#                                      "value",
#                                      "updated_by",
#                                      "updated_date"]]
#
#                     result.to_sql(name="results",
#                                   schema="rp_2021",
#                                   con=settings.engines["ABM-Reporting"],
#                                   if_exists="append",
#                                   index=False,
#                                   method="multi")

# populate Excel Workbook template with performance measure results
print("---- Populating Excel Workbook ----")
for corridor in settings.cmcp_corridor:
    # initialize Performance Measures Excel workbook template
    template = openpyxl.load_workbook(settings.template_path)
    templateWriter = pd.ExcelWriter(
        path=settings.templateWritePath + corridor + ".xlsx",
        mode="w",
        engine="openpyxl")
    templateWriter.book = template
    templateWriter.sheets = dict((ws.title, ws) for ws in template.worksheets)

    template['Primary Measures']['A1'] = corridor

    template_locations = pd.read_csv(settings.template_locations_path)

    for scenario in settings.scenarios:
        for line in template_locations.itertuples():
            measureKey = line.measureKey
            metricKey = line.metricKey
            sheet = line.sheet
            row = line.row

            # get Performance Measure metric from SQL results table
            result = pd.read_sql_query(
                sql=("SELECT [value] FROM [dbo].[cmcp2021_results_NBE_Test] WHERE"
                     "[scenario_id] = ? AND [measure] = ? AND [metric] = ? AND [cmcp_name] = ?"),
                con=settings.engines["ABM-Reporting"],
                params=[scenario, measureKey, metricKey, corridor]
            )

            # for each dictionary of Performance Measures
            # set template write column based on scenario label and template sheet
            # and write results to specified Excel template sheet and row
            # if none is specified for the given scenario label and template sheet
            # then do not write results
            colDict = settings.template_columns[sheet]
            if settings.scenarios[scenario] in colDict.keys():
                col = colDict[settings.scenarios[scenario]]

                # write scenario ID to Excel template
                data = pd.DataFrame({scenario})
                data.to_excel(
                    excel_writer=templateWriter,
                    sheet_name=sheet,
                    na_rep="NULL",
                    header=False,
                    index=False,
                    startrow=2,
                    startcol=col - 1,
                    engine="openpyxl")

                # write sql result to specified Excel template sheet and row
                result.to_excel(
                    excel_writer=templateWriter,
                    sheet_name=sheet,
                    na_rep="NULL",
                    header=False,
                    index=False,
                    startrow=row - 1,
                    startcol=col - 1,
                    engine="openpyxl"
                )

    # save the completed template
    templateWriter.save()
