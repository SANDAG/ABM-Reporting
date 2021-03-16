import datetime
from performanceMeasuresGIS import PerformanceMeasuresGIS
import settings
import openpyxl
import os
import pandas as pd


# get GIS Performance Measures and populate SQL Server results table
print("---- Getting GIS Performance Measures ----")
for scenario in settings.scenarios:
    print("Scenario: " + str(scenario))
    gis_data = PerformanceMeasuresGIS(scenario)
    gis_data.insert_performance_measures()


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


# populate Excel Workbook template with performance measure results
print("---- Populating Excel Workbook ----")

for corridor in settings.cmcp_corridor:
    # initialize Performance Measures Excel workbook template
    template = openpyxl.load_workbook(
        "./resources/cmcp_2021/CMCP_PerformanceMeasures_Template.xlsx"
    )

    templateWriter = pd.ExcelWriter(
        path=settings.templateWritePath + corridor + ".xlsx",
        mode="w",
        engine="openpyxl")
    templateWriter.book = template
    templateWriter.sheets = dict((ws.title, ws) for ws in template.worksheets)

    # get list of performance measure outputs
    template_locations = pd.read_csv(
        "./resources/cmcp_2021/CMCP_Template_Locations.csv"
    )

    for scenario in settings.scenarios:
        # for each dictionary of Performance Measures
        for line in template_locations.itertuples():
            measureKey = line.measureKey
            metricKey = line.metricKey
            sheet = line.sheet
            row = line.row

            # get Performance Measure metric from SQL results table
            result = pd.read_sql_query(
                sql=("SELECT [value] FROM [cmcp_2021].[results] WHERE"
                     "[scenario_id] = ? AND [measure] = ? AND "
                     "[metric] = ? AND [cmcp_name] = ?"),
                con=settings.engines["ABM-Reporting"],
                params=[scenario, measureKey, metricKey, corridor]
            )

            # set template write column based on scenario label and template sheet
            # and write results to specified Excel template sheet and row
            # if none is specified for the given scenario label and template sheet
            # then do not write results
            colDict = settings.template_columns[sheet]
            if settings.scenarios[scenario] in colDict.keys():
                col = colDict[settings.scenarios[scenario]]

                # write result to specified Excel template sheet and row
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
