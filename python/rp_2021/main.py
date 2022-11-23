import datetime
from performanceMeasuresGIS import PerformanceMeasuresGIS
from performanceMeasuresM1M5 import PerformanceMeasuresM1M5
import settings
import openpyxl
import os
import pandas as pd
import numpy as np

# Template for how SimWrapper inputs will be formatted
simwrapper_template = pd.read_csv(settings.simWrapperTemplate, index_col = 0)

# Data frame for keeping track of measures to use in SimWrapper
simwrapper_measures = pd.DataFrame(
    index = settings.scenarios.keys()
)

# Indicate folder to write SimWrapper files
simwrapper_path = os.path.join(
    os.path.dirname(
        os.path.dirname(
            os.path.dirname(
                os.path.abspath(__file__)
                )
            )
        ),
    'resources',
    'simwrapper'
    )

# get GIS Performance Measures and populate SQL Server results table
print("---- Getting GIS Performance Measures ----")
for scenario in settings.scenarios:
    print("Scenario: " + str(scenario))

    # if scenario is the 2020 SB375 only scenario then skip access measures
    if settings.scenarios[scenario] == "2020":
        print("SB375 only scenario: no GIS access measures calculated")
    else:
        gis_data = PerformanceMeasuresGIS(
            scenario_id=scenario,
            conn_abm=settings.engines["ABM-Reporting"],
            conn_gis=settings.engines["GIS"]
        )
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

    # if scenario is the 2020 SB375 only scenario then skip access measures
    if settings.scenarios[scenario] == "2020":
        print("SB375 only scenario: no access measures calculated")
    else:
        # initialize access measure class object
        pm_m1_m5 = PerformanceMeasuresM1M5(
            scenario_id=scenario,
            conn=settings.engines["ABM-Reporting"]
        )

        # for each performance measure
        for measureKey in settings.python_measures:
            print("Measure: " + measureKey)

            # delete old results from the results table if they exist
            with settings.engines["ABM-Reporting"].begin() as conn:
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
                                  con=settings.engines["ABM-Reporting"],
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

    # write scenario to sheets of Excel template
    for sheet in settings.template_columns:
        col = settings.template_columns[sheet][settings.scenarios[scenario]]
        cell = template[sheet].cell(row=3, column=col)
        cell.value = scenario

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
                con=settings.engines["ABM-Reporting"],
                params=[scenario, measureKey, metricKey]
            )

            # If a metric is to be visualized in SimWrapper, add it to the `simwrapper_measures` data frame
            if "visualize" in settings.template_locations[measureKey][metricKey] and settings.template_locations[measureKey][metricKey]["visualize"]:
                colname = measureKey + '--' + metricKey
                try:
                    simwrapper_measures.loc[scenario, colname] = result.values[0, 0]
                except KeyError: #Column not there yet
                    simwrapper_measures[colname] = np.empty_like(simwrapper_measures.index)
                    simwrapper_measures.loc[scenario, colname] = result.values[0, 0]

                if colname not in simwrapper_metrics:
                    simwrapper_metrics.append(colname)

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

# Write SimWrapper inputs
for metric in simwrapper_measures.columns:
    df = simwrapper_template.copy()
    for col in df.columns:
        df[col] = df[col].map(simwrapper_measures[metric])
    df.to_csv(os.path.join(simwrapper_path, metric + '.csv'))
