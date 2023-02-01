import datetime
import settings_eir as settings
import openpyxl
import os
import pandas as pd
import pyodbc


# initialize empty measure result DataFrame
result_df_1 = pd.DataFrame()
result_df_2 = pd.DataFrame()
result_df_3 = pd.DataFrame()

# for each performance measure from database
for measureKey in settings.sql_measures_db:
    print("Measure: " + measureKey)

    # get the performance measure dictionary
    measureDict = settings.sql_measures_db[measureKey]

    for scenario_id in settings.scenarios:
        print("Scenario: " + str(scenario_id))

        # execute stored procedure with specified arguments
        qry_result = pd.read_sql_query(
            sql="EXECUTE " + measureDict["sp"] + " " + measureDict["args"],
            con=settings.conn_reporting,
            params=[scenario_id]
        )

        # append final result set for the scenario
        # to the measure result set DataFrame
        result_df_1 = result_df_1.append(qry_result)

# for each performance measure from abm_14_2_0_reporting database
for measureKey in settings.sql_measures_reporting:
    print("Measure: " + measureKey)

    # get the performance measure dictionary
    measureDict = settings.sql_measures_reporting[measureKey]

    for scenario_id in settings.scenarios:
        print("Scenario: " + str(scenario_id))

        # execute stored procedure with specified arguments
        qry_result = pd.read_sql_query(
            sql="EXECUTE " + measureDict["sp"] + " " + measureDict["args"],
            con=settings.conn_reporting,
            params=[scenario_id]
        )

        # append final result set for the scenario
        # to the measure result set DataFrame
        result_df_1 = result_df_1.append(qry_result)

# drop the unnessessary fields to merge with results in the non-PM format
result_df_1 = result_df_1[["scenario_id", "measure", "metric", "value"]]


# for measure result tables not in the standard PM format

result_df_2_1 = pd.DataFrame()
result_df_2_2 = pd.DataFrame()

for measureKey in settings.sql_measures_reporting_diffformat:
    print("Measure: " + measureKey)

    # get the performance measure dictionary
    measureDict = settings.sql_measures_reporting_diffformat[measureKey]

    for scenario_id in settings.scenarios:
        print("Scenario: " + str(scenario_id))

        # execute stored procedure with specified arguments
        qry_result = pd.read_sql_query(
            sql="EXECUTE " + measureDict["sp"] + " " + measureDict["args"],
            con=settings.conn_reporting,
            params=[scenario_id]
        )

        # append final result set for the scenario
        # to the measure result set DataFrame
        result_df_2 = result_df_2.append(qry_result)

# select needed fields and rename col names to be consistent with standard PM outputs
result_df_2_1 = result_df_2[["scenario_id", "population", "activity_location", "vmt_per_capita"]]
result_df_2_1 = result_df_2_1.rename(columns = {'population': 'measure', 'activity_location': 'metric', 'vmt_per_capita': 'value'}, inplace = False)
result_df_2_2 = result_df_2[["scenario_id", "population", "region_2004_name", "vmt"]]
result_df_2_2 = result_df_2_2.rename(columns = {'population': 'measure', 'region_2004_name': 'metric', 'vmt': 'value'}, inplace = False)


# for measure result tables on lane miles
for measureKey in settings.sql_measures_db_lanemile:
    print("Measure: " + measureKey)

    # get the performance measure dictionary
    measureDict = settings.sql_measures_db_lanemile[measureKey]

    for scenario_id in settings.scenarios:
        print("Scenario: " + str(scenario_id))

        # execute stored procedure with specified arguments
        qry_result = pd.read_sql_query(
            sql="EXECUTE " + measureDict["sp"] + " " + measureDict["args"],
            con=settings.conn_reporting,
            params=[scenario_id]
        )

        # append final result set for the scenario
        # to the measure result set DataFrame
        result_df_3 = result_df_3.append(qry_result)

# select needed fields and rename col names to be consistent with standard PM outputs
result_df_3["measure"] = "Lane Miles of Roadways"
result_df_3 = result_df_3[["scenario_id", "measure", "Facility", "lane_miles"]]
result_df_3 = result_df_3.rename(columns = {'Facility': 'metric', 'lane_miles': 'value'}, inplace = False)

# merge all dataframe
result_df = pd.concat([result_df_1, result_df_2_1, result_df_2_2, result_df_3])


# initialize Performance Measures Excel workbook template
template = openpyxl.load_workbook(settings.template_path)
templateWriter = pd.ExcelWriter(
    path=settings.templateWritePath + ".xlsx",
    mode="w",
    engine="openpyxl")
templateWriter.book = template
templateWriter.sheets = dict((db.title, db) for db in template.worksheets)

template_locations = pd.read_csv(settings.template_locations_path)

for scenario in settings.scenarios:

    # write scenario to sheets of Excel template
    for sheet in settings.template_columns:
        col = settings.template_columns[sheet][settings.scenarios[scenario]]
        cell = template[sheet].cell(row=2, column=col)
        cell.value = scenario

    # for each dictionary of Performance Measures
    for line in template_locations.itertuples():
        measureKey = line.measureKey
        metricKey = line.metricKey
        sheet = line.sheet
        row = line.row - 1

        # filter out value for selected scenaio, measure and metric
        result = result_df[(result_df["scenario_id"] == scenario) & (result_df["measure"] == measureKey) & (result_df["metric"] == metricKey)]["value"]

        # set template write column based on scenario label and template sheet
        # and write results to specified Excel template sheet and row
        # if none is specified for the given scenario label and template sheet
        # then do not write results
        colDict = settings.template_columns[sheet]
        if settings.scenarios[scenario] in colDict.keys():
            col = colDict[settings.scenarios[scenario]] - 1

            # write result to specified Excel template sheet and row
            result.to_excel(
                excel_writer=templateWriter,
                sheet_name=sheet,
                na_rep="NULL",
                header=False,
                index=False,
                startrow=row,
                startcol=col,
                engine="openpyxl"
            )

# save the completed template
templateWriter.save()
