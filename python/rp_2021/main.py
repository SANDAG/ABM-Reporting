import datetime
from performanceMeasuresM1M5 import PerformanceMeasuresM1M5
import settings
import os


# user inputs a list of ABM database scenario_id
input_string = input(("Enter a list of ABM [scenario_id]s separated by "
                      "spaces (e.g. 1 2 3)"))
scenarios = input_string.split()

# run Performance Measures M1 and M5
# import dictionary of M1 and M5 performance measures to run
print("Running Performance Measures M1 and M5")
measureDict = settings.access_pms

# for each scenario
for scenario in scenarios:
    print("Scenario: " + scenario)

    # initialize measure class objects
    pm_m1_m5 = PerformanceMeasuresM1M5(int(scenario))

    # for each measure
    for measureKey in measureDict:
        # delete old results from the results table if they exist
        with settings.engine.connect() as conn:
            conn.execute(
                "DELETE FROM [rp_2021].[results] WHERE [scenario_id] = " +
                str(scenario) + " AND [measure] = '" + measureKey + "'")

        # for each metric within the measure
        for metricKey in measureDict[measureKey]:
            metricDict = measureDict[measureKey][metricKey]
            # run the appropriate class method and write results to results table
            if metricDict["class"] == "PerformanceMeasuresM1M5":
                func = getattr(pm_m1_m5, metricDict["method"])(**metricDict["args"])
                result = func.to_frame(name="value")
                result["scenario_id"] = scenario
                result["measure"] = measureKey
                result["metric"] = metricKey + " - " + result.index
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
