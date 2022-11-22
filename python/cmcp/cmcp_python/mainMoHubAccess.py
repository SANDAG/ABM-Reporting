import datetime

from performanceMeasuresM1M5 import PerformanceMeasuresM1M5
import settingsMoHubAccess
import openpyxl
import os
import pandas as pd


# run Python-based Performance Measures and populate SQL Server results table
print("---- Running Python-based Performance Measures ----")
for scenario in settingsMoHubAccess.scenarios:
    print("Scenario: " + str(scenario))

    # if scenario is the 2020 SB375 only scenario then skip access measures
    if settingsMoHubAccess.scenarios[scenario] == "2020":
        print("SB375 only scenario: no access measures calculated")
    else:
        # initialize access measure class object
        pm_m1_m5 = PerformanceMeasuresM1M5(scenario)

        # for each performance measure
        for measureKey in settingsMoHubAccess.python_measures:
            print("Measure: " + measureKey)

            # delete old results from the results table if they exist
            with settingsMoHubAccess.engines["ABM-Reporting"].begin() as conn:
                conn.execute(
                    "DELETE FROM [rp_2021].[results] WHERE [scenario_id] = " +
                    str(scenario) + " AND [measure] = '" + measureKey + "'")

            # for each metric within the performance measure
            for metricKey in settingsMoHubAccess.python_measures[measureKey]:
                metricDict = settingsMoHubAccess.python_measures[measureKey][metricKey]
                # run the appropriate class method and write results to results table
                if metricDict["class"] == "PerformanceMeasuresM1M5":

                    func = getattr(pm_m1_m5, metricDict["method"])(**metricDict["args"])
                    result = func.to_frame(name="value")
                    result["scenario_id"] = scenario
                    result["measure"] = measureKey
                    result["metric"] = result.index + " - " + metricKey
                    result["updated_by"] = os.environ["userdomain"] + "\\" + os.getenv("username")
                    result["updated_date"] = datetime.datetime.now()

                    result = result[["scenario_id",
                                     "measure",
                                     "metric",
                                     "value",
                                     "updated_by",
                                     "updated_date"]]

                    result.to_sql(name="results",
                                  schema="rp_2021",
                                  con=settingsMoHubAccess.engines["ABM-Reporting"],
                                  if_exists="append",
                                  index=False,
                                  method="multi")


# populate Excel Workbook template with performance measure results
print("---- Populating Excel Workbook ----")

# initialize Mobility Hub Access Excel workbook template
template = openpyxl.load_workbook("./resources/rp_2021/MoHubAccess_Template.xlsx")
templateWriter = pd.ExcelWriter(
    path=settingsMoHubAccess.templateWritePath,
    mode="w",
    engine="openpyxl")
templateWriter.book = template
templateWriter.sheets = dict((ws.title, ws) for ws in template.worksheets)

for scenario in settingsMoHubAccess.scenarios:

    # write scenario to sheets of Excel template
    for sheet in settingsMoHubAccess.template_columns:
        col = settingsMoHubAccess.template_columns[sheet][settingsMoHubAccess.scenarios[scenario]]
        cell = template[sheet].cell(row=3, column=col)
        cell.value = scenario

    # for each dictionary of Performance Measures
    for measureKey in settingsMoHubAccess.template_locations:

        measureDict = settingsMoHubAccess.template_locations[measureKey]

        # for each metric within each Performance Measure
        for metricKey in measureDict:

            metricDict = measureDict[metricKey]

            # get Performance Measure metric from SQL results table
            result = pd.read_sql_query(
                sql=("SELECT [value] FROM [rp_2021].[results] WHERE"
                     "[scenario_id] = ? AND [measure] = ? AND [metric] = ?"),
                con=settingsMoHubAccess.engines["ABM-Reporting"],
                params=[scenario, measureKey, metricKey]
            )

            # set template write column based on scenario label and template sheet
            # and write results to specified Excel template sheet and row
            # if none is specified for the given scenario label and template sheet
            # then do not write results
            colDict = settingsMoHubAccess.template_columns[metricDict["sheet"]]
            if settingsMoHubAccess.scenarios[scenario] in colDict.keys():
                col = colDict[settingsMoHubAccess.scenarios[scenario]]

                # write result to specified Excel template sheet and row
                result.to_excel(
                    excel_writer=templateWriter,
                    sheet_name=metricDict["sheet"],
                    na_rep="NULL",
                    header=False,
                    index=False,
                    startrow=metricDict["row"] - 1,
                    startcol=col - 1,
                    engine="openpyxl"
                )

# save the completed template
templateWriter.save()
