from travelNetwork import HighwayNetwork, TransitNetwork  # import custom network classes
from tripLists import TripLists  # import custom trip list class
from landUse import LandUse  # import custom land use class
import settings  # import python settings file
import openpyxl
import pandas as pd
import sys
import time
import datetime

# program timer initiated
start_time_program = time.time()

# user inputs a list of ABM scenario folders
input_string = input(("Enter a list of ABM scenario folder paths separated "
                      "by pipes (|): "))
scenarios = input_string.split("|")

# user chooses whether to run AV/TNC summaries
input_av_switch = input("Include AV/TNC summaries? Enter Yes (y) or No (n): ")
if input_av_switch in ["Yes", "yes", "Y", "y"]:
    input_av_switch = True
else:
    input_av_switch = False

# user inputs output file name
file_suffix = input("Enter output file name: ")

# get the scenario metadata from the master scenario list
scenarioMetadata = pd.read_csv("./resources/Scenario Metadata.csv",
                               usecols=["scenario_id",
                                        "description",
                                        "path"])

# filter to user input scenarios
# and reset the index
scenarioMetadata = scenarioMetadata[scenarioMetadata["path"].isin(scenarios)].reset_index(drop=True)
if len(scenarioMetadata.index) != len(scenarios):
    msg = "Not all input scenarios exist in resources/Scenario Metadata.csv"
    raise ValueError(msg)

# set ordering to user-input order
scenarioMetadata = scenarioMetadata.set_index("path").loc[scenarios]
scenarioMetadata = scenarioMetadata.reset_index(drop=False)


# if one ABM scenario is entered then run sensitivity test measures
# for a single scenario  -----------------------------------------------------
if len(scenarios) == 1:
    print("Running: " + scenarios[0])

    # initialize single scenario Sensitivity Measure Excel workbook template
    template = openpyxl.load_workbook(settings.templatePaths["scenarioTemplate"])
    templateWriter = pd.ExcelWriter(
        path=settings.templateWritePaths["scenarioTemplate"] + " - " + file_suffix + ".xlsx",
        mode="w",
        engine="openpyxl")
    templateWriter.book = template
    templateWriter.sheets = dict((ws.title, ws) for ws in template.worksheets)

    # initialize highway network, transit network, land use, and trip lists
    # from the scenario folder
    hwy = HighwayNetwork(scenario_path=scenarios[0])
    lu = LandUse(scenario_path=scenarios[0])
    transit = TransitNetwork(scenario_path=scenarios[0])
    trips = TripLists(scenario_path=scenarios[0])

    # write scenario information to Excel template
    scenarioMetadata.to_excel(
        excel_writer=templateWriter,
        sheet_name="scenario",
        na_rep="NULL",
        header=True,
        index=False,
        startrow=2,
        engine="openpyxl")

    # for each dictionary of single scenario Sensitivity Measures ------------
    for measure in settings.singleScenarioMeasures:
        print(measure)
        # append AV/TNV switch to the AV/TNC function arguments
        if measure["fn"] == "calculate_passenger_metric":
            measure["args"].update({"switch": input_av_switch})
        if measure["class"] == "HighwayNetwork":
            classObj = hwy
        elif measure["class"] == "TransitNetwork":
            classObj = transit
        elif measure["class"] == "TripLists":
            classObj = trips
        elif measure["class"] == "LandUse":
            classObj = lu
        else:
            msg = "Custom class does not exist: " + measure["class"]
            raise ValueError(msg)

        if measure["args"] is not None:
            data = getattr(classObj, measure["fn"])(**measure["args"])
        else:
            data = getattr(classObj, measure["fn"])()

        # write results to specified Excel template sheet and row
        data.to_excel(
            excel_writer=templateWriter,
            sheet_name=measure["sheet"],
            na_rep="NULL",
            header=True,
            index=True,
            startrow=measure["row"],
            engine="openpyxl")


# if more than one ABM scenario is entered then run sensitivity test measures
# for up to five scenarios  --------------------------------------------------
elif 1 < len(scenarios) <= 20:

    # initialize multiple scenario Sensitivity Measure Excel workbook template
    template = openpyxl.load_workbook(settings.templatePaths["multipleScenariosTemplate"])
    templateWriter = pd.ExcelWriter(
        path=settings.templateWritePaths["multipleScenariosTemplate"] + " - " + file_suffix + ".xlsx",
        mode="w",
        engine="openpyxl")
    templateWriter.book = template
    templateWriter.sheets = dict((ws.title, ws) for ws in template.worksheets)

    # for each scenario  -----------------------------------------------------
    for index, row in scenarioMetadata.iterrows():
        print("Running: " + row["path"])
        # initialize highway network, transit network, and trip lists
        # from the scenario folder
        hwy = HighwayNetwork(scenario_path=row["path"])
        lu = LandUse(scenario_path=row["path"])
        transit = TransitNetwork(scenario_path=row["path"])
        trips = TripLists(scenario_path=row["path"])

        # write scenario information to Excel template
        data = pd.DataFrame(
            {"scenario_id": [row["scenario_id"]],
             "description": [row["description"]],
             "path": [row["path"]],
             "sample_rate": [trips.sample_rate]})

        data.to_excel(
            excel_writer=templateWriter,
            sheet_name="scenarios",
            na_rep="NULL",
            header=False,
            index=False,
            startrow=3+index,
            engine="openpyxl")

        # for each dictionary of multiple scenario Sensitivity Measures  -----
        for measure in settings.multipleScenarioMeasures:
            # append AV/TNV switch to the AV/TNC function arguments
            if measure["fn"] == "calculate_passenger_metric":
                measure["args"].update({"switch": input_av_switch})

            if measure["class"] == "HighwayNetwork":
                classObj = hwy
            elif measure["class"] == "TransitNetwork":
                classObj = transit
            elif measure["class"] == "TripLists":
                classObj = trips
            elif measure["class"] == "LandUse":
                classObj = lu
            else:
                msg = "Custom class does not exist: " + measure["class"]
                raise ValueError(msg)

            if measure["args"] is not None:
                data = getattr(classObj, measure["fn"])(**measure["args"])
            else:
                data = getattr(classObj, measure["fn"])()

            # filter results of measure if filter specified
            if measure["filter"] is not None:
                data = data.query(measure["filter"])

            # drop columns from the results if specified
            if measure["drop"] is not None:
                data = data.drop(columns=measure["drop"])

            # create DataFrame of scenario description and concatenate with results
            data = pd.concat(
                objs=[pd.Series([row["description"]] * len(data.index), name="description"),
                      data.reset_index(drop=True)],
                axis=1)

            # write results to specified Excel template sheet and row
            data.to_excel(
                excel_writer=templateWriter,
                sheet_name=measure["sheet"],
                na_rep="NULL",
                header=False,
                index=False,
                startrow=measure["row"] + index,
                engine="openpyxl")

# current implementation can only handle up to five ABM scenarios ------------
else:
    sys.exit("Error: enter one to five ABM scenario folders")

# save the completed template
templateWriter.save()

print("entire program: ", str(datetime.timedelta(seconds=round(time.time() - start_time_program))))
