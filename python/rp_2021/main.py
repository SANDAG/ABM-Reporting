import datetime
from performanceMeasuresM1M5 import PerformanceMeasuresM1M5
import settings
import openpyxl
import os
import pandas as pd


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
        with settings.engine.begin() as conn:
            sql = "EXECUTE " + measureDict["sp"] + " " + measureDict["args"]
            conn.execute(sql.format(scenario))


# run Python-based Performance Measures and populate SQL Server results table
print("---- Running Python-based Performance Measures ----")
for scenario in settings.scenarios:
    print("Scenario: " + str(scenario))

    # initialize access measure class object
    pm_m1_m5 = PerformanceMeasuresM1M5(scenario)

    # for each performance measure
    for measureKey in settings.python_measures:
        print("Measure: " + measureKey)

        # delete old results from the results table if they exist
        with settings.engine.begin() as conn:
            conn.execute(
                "DELETE FROM [rp_2021].[results] WHERE [scenario_id] = " +
                str(scenario) + " AND [measure] = '" + measureKey + "'")

        # for each metric within the performance measure
        for metricKey in settings.python_measures[measureKey]:
            metricDict = settings.python_measures[measureKey][metricKey]
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
                              con=settings.engine,
                              if_exists="append",
                              index=False,
                              method="multi")


# populate Excel Workbook template with performance measure results
print("---- Populating Excel Workbook ----")

# initialize Performance Measures Excel workbook template
template = openpyxl.load_workbook("./resources/rp_2021/PerformanceMeasures_Template.xlsx")
templateWriter = pd.ExcelWriter(
    path=settings.templateWritePath,
    mode="w",
    engine="openpyxl")
templateWriter.book = template
templateWriter.sheets = dict((ws.title, ws) for ws in template.worksheets)

for scenario in settings.scenarios:
    # for each dictionary of Performance Measures
    for measureKey in settings.template_locations:

        measureDict = settings.template_locations[measureKey]

        # for each metric within each Performance Measure
        for metricKey in measureDict:

            metricDict = measureDict[metricKey]

            # get Performance Measure metric from SQL results table
            result = pd.read_sql_query(
                sql=("SELECT [value] FROM [rp_2021].[results] WHERE"
                     "[scenario_id] = ? AND [measure] = ? AND [metric] = ?"),
                con=settings.engine,
                params=[scenario, measureKey, metricKey]
            )

            # set template write column based on scenario label and template sheet
            # and write results to specified Excel template sheet and row
            # if none is specified for the given scenario label and template sheet
            # then do not write results
            colDict = settings.template_columns[metricDict["sheet"]]
            if settings.scenarios[scenario] in colDict.keys():
                col = colDict[settings.scenarios[scenario]]

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
