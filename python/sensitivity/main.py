import openpyxl
import pandas as pd
import pyodbc
import settings  # import python settings file
import sys


# user inputs a list of ABM database scenario_id
input_string = input(("Enter a list of ABM [scenario_id]s separated by "
                      "spaces (e.g. 1 2 3)"))
scenarios = input_string.split()


# build SQL Server connection string
conn = pyodbc.connect("DRIVER={SQL Server Native Client 11.0};SERVER="
                      + settings.server +
                      ";DATABASE=" +
                      settings.database +
                      ";Trusted_Connection=yes;")


# if one ABM scenario is entered then run sensitivity test measures
# for a single scenario  -----------------------------------------------------
if len(scenarios) == 1:
    # initialize single scenario Sensitivity Measure Excel workbook template
    template = openpyxl.load_workbook(settings.templatePaths["scenarioTemplate"])
    templateWriter = pd.ExcelWriter(
        path=settings.templateWritePaths["scenarioTemplate"] + " " + scenarios[0] + ".xlsx",
        mode="w",
        engine="openpyxl")
    templateWriter.book = template
    templateWriter.sheets = dict((ws.title, ws) for ws in template.worksheets)

    # for each dictionary of single scenario Sensitivity Measures ------------
    for measure in settings.singleScenarioMeasures:
        print("Running: " + measure["sp"] + " " + measure["args"])

        # execute stored procedure with specified arguments
        result = pd.read_sql_query(
            sql="EXECUTE " + measure["sp"] + " " + measure["args"],
            con=conn,
            params=[int(scenarios[0])]
        )

        # write results to specified Excel template sheet and row
        for sheet, row in list(zip(measure["sheets"], measure["rows"])):
            result.to_excel(
                excel_writer=templateWriter,
                sheet_name=sheet,
                na_rep="NULL",
                header=True,
                index=False,
                startrow=row,
                engine="openpyxl"
            )

# if more than one ABM scenario is entered then run sensitivity test measures
# for up to five scenarios  --------------------------------------------------
elif 1 < len(scenarios) <= 5:
    # initialize multiple scenario Sensitivity Measure Excel workbook template
    template = openpyxl.load_workbook(settings.templatePaths["multipleScenariosTemplate"])
    templateWriter = pd.ExcelWriter(
        path=settings.templateWritePaths["multipleScenariosTemplate"],
        mode="w",
        engine="openpyxl")
    templateWriter.book = template
    templateWriter.sheets = dict((ws.title, ws) for ws in template.worksheets)

    # for each dictionary of single scenario Sensitivity Measures ------------
    for measure in settings.multipleScenarioMeasures:
        print("Running: " + measure["sp"] + " " + measure["args"])

        # initialize empty measure result DataFrame
        result = pd.DataFrame()

        # for each scenario
        for scenario_id in scenarios:
            scenario_id = int(scenario_id)

            # execute stored procedure with specified arguments
            qry_result = pd.read_sql_query(
                sql="EXECUTE " + measure["sp"] + " " + measure["args"],
                con=conn,
                params=[scenario_id]
            )

            # filter results of stored procedure if filter specified
            if measure["filter"] is not None:
                qry_result = qry_result.query(measure["filter"]).reset_index(drop=True)

            # drop columns from the query result set if specified
            if measure["drop"] is not None:
                qry_result = qry_result.drop(columns=measure["drop"])

            # create DataFrame of scenario_id and concatenate with query result
            qry_result = pd.concat(
                objs=[pd.Series([scenario_id] * len(qry_result.index), name="scenario_id"),
                      qry_result],
                axis=1)

            # append final result set for the scenario
            # to the measure result set DataFrame
            result = result.append(qry_result)

        # write measure result to specified Excel template sheet and row
        for sheet, row in list(zip(measure["sheets"], measure["rows"])):
            result.to_excel(
                excel_writer=templateWriter,
                sheet_name=sheet,
                na_rep="NULL",
                header=True,
                index=False,
                startrow=row,
                engine="openpyxl"
            )

# current implementation can only handle up to five ABM scenarios ------------
else:
    sys.exit("Error: enter one to five ABM [scenario_id]s")

# save the completed template
templateWriter.save()
