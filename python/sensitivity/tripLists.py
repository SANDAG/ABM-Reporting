# -*- coding: utf-8 -*-
""" ABM Scenario Trip List Sensitivity Test Module.

This module contains classes holding all information and utilities relating to
trip list related sensitivity metrics of a SANDAG Activity-Based Model (ABM)
scenario.

Notes:
    docstring style guide - http://google.github.io/styleguide/pyguide.html
"""

from functools import lru_cache
import numpy as np
import openmatrix as om
import os
import os.path
import pandas as pd
import re
import time
import datetime


class TripLists:
    """ Holds all trip list data for a completed ABM scenario model run. This
    includes all report files from the ten ABM sub-models. These include
    - Airport (CBX) Model - report/airportCBXTrips.csv
    - Airport (SAN) Model - report/airportSANTrips.csv
    - Cross Border Model - report/crossBorderTrips.csv
    - Commercial Vehicle Model - report/commercialVehicleTrips.csv
    - External-External Model - report/externalExternalTrips.csv
    - External-Internal Model - report/externalInternalTrips.csv
    - Internal-External Model - report/internalExternalTrips.csv
    - Individual Model - report/individualTrips.csv
    - Joint Model - report/jointTrips.csv
    - Truck Model - report/truckTrips.csv
    - Visitor Model - report/visitorTrips.csv
    - Zombie AV Trips - report/zombieAVTrips.csv
    - Zombie TNC Trips - report/zombieTNCTrips.csv

    The class also includes methods to calculate metrics within modes and
    ABM sub-models.

    Args:
        scenario_path: String location of the completed ABM scenario folder

    Methods:
        calculate_mode_metric: Calculates a trip-based metric of interest by
            ABM sub-model and mode
        calculate_model_metric: Calculates a trip-based metric of interest by
            ABM sub-model
        count_workers_by_telestatus: Calculates number of workers by telestatus
        count_persons: Calculates total number of workers
        count_persons_models: Calculates person share by ABM sub-model
        calculate_telework_metric: Calculate a trip-based metric of interest by
            ABM sub-model and telestatus
        calculate_tod_metric_telework: Calculates a trip-based metric by time of day
        calculate_mode_metric_telework: Calculates a trip-based metric of interest by
            telestatus and mode
        calculate_passenger_metric: Calculates a trip-based metric of interest by
            telestatus and passenger status
        calculate_purpose_metric: Calculates a trip-based metric of interest by
            ABM sub-model and purpose
        calculate_purpose_metric_telework: Calculates a trip-based metric of interest by
            trip purpose and telestatus

    Properties:
        sample_rate: Final iteration ABM sample rate
        year: ABM scenario year
        iteration: ABM scenario number of iterations
        person_data: Person data output file from ABM scenario
        tour_data: Tour data output file from ABM scenario
        airport_cbx: Cross Border Express (CBX) model trip list
        airport_san: San Diego Airport (SAN) model trip list
        cross_border: Mexican Resident Cross Border model trip list
        cvm: Commercial Vehicle model trip list
        ee: External-External model trip list, placed here until it can be
            properly incorporated into the EMME data exporter process
        ei: External-Internal model trip list, placed here until it can be
            properly incorporated into the EMME data exporter process
        ie: San Diego Resident Internal-External model trip list
        individual: San Diego Resident Individual travel model trip list
        joint: San Diego Resident Joint travel model trip list
        truck: Truck model trip list, placed here until it can be
            properly incorporated into the EMME data exporter process
        visitor: Visitor model trip list
        zombie_av: 0-passenger Autonomous Vehicle trip list
        zombie_tnc: 0-passenger TNC Vehicle trip list
    """

    def __init__(self, scenario_path) -> None:
        self.scenario_path = scenario_path

    @property
    def sample_rate(self):
        """ Get the final iteration ABM sample rate from the
        conf/sandag_abm.properties file.

        The final iteration sample rate is defined as the final numeric
        character in the line of the properties having the structure
        "sample_rates = ?, ?, ?, ..." where each numeric character after
        the first is optional and delimited by a comma.

        :rtype float
        :returns: final iteration sample rate
        """

        properties_file = open(self.scenario_path + "/conf/sandag_abm.properties", "r")
        rate = None

        for line in properties_file:
            # strip all white space from the line
            line = line.replace(" ", "")

            # find line containing "sample_rates="
            m = re.compile("sample_rates=").match(line)
            if m:
                # take the portion of the line after the matching string
                # and split by the comma character
                line = line[m.end():].split(",")

                # if the split line contains a single element return that element
                # otherwise return the final element
                if len(line) == 0:
                    rate = float(line[0])
                else:
                    rate = float(line[-1])
                break

        properties_file.close()

        return rate

    @property
    def year(self):
        """ Get the ABM scenario year from the
        conf/sandag_abm.properties file.

        The ABM scenario year is defined as the numeric character
        in the line of the properties file having the structure
        "scenarioYear =  ?".

        :rtype integer
        :returns: ABM scenario year
        """

        properties_file = open(self.scenario_path + "/conf/sandag_abm.properties", "r")
        year = None

        for line in properties_file:
            # strip all white space from the line
            line = line.replace(" ", "")

            # find line containing "scenarioYear="
            m = re.compile("scenarioYear=").match(line)
            if m:
                # take the portion of the line after the matching string
                # and return as the scenario year
                year = int(line[m.end():])
                break

        properties_file.close()

        return year

    @property
    def iteration(self):
        """ Get the ABM scenario number of iterations from the
        conf/sandag_abm.properties file.

        The ABM number of iterations is defined as the numeric
        character in the line of the properties file having the
        structure "Report.iteration=?".

        :rtype integer
        :returns: ABM number of iterations
        """

        properties_file = open(self.scenario_path + "/conf/sandag_abm.properties", "r")
        iteration = None

        for line in properties_file:
            # strip all white space from the line
            line = line.replace(" ", "")

            # find line containing "Report.iteration="
            m = re.compile("Report\.iteration=").match(line)
            if m:
                # take the portion of the line after the matching string
                # and return as the scenario year
                iteration = int(line[m.end():])
                break

        properties_file.close()

        return iteration

    def pretty_print_path(self):
        """ Helper function to restructure personData filepath

        :rtype string
        :returns: Restructured personData fielpath
        """
        # full path of personData file
        path = self.scenario_path + "/output/personData_" + str(self.iteration) + ".csv"

        # path to persons data for excel spreadsheet output
        filename = os.path.split(path)[1]
        directory = os.path.split(os.path.split(path)[0])[1]
        model_run_name = os.path.split(os.path.split(os.path.split(path)[0])[0])[1]  # model run name
        filepath_pretty = model_run_name + "/" + directory + "/" + filename

        return filepath_pretty

    def count_workers_by_telestatus(self, occasional_telework='no'):
        """ Calculate total number of workers by telestatus in the
        person file to be used for per capita calculations

        :rtpye :class: `pandas.DataFrame`
        :returns: Number of worker in the personData file by telestatus
        """

        path = self.pretty_print_path()

        data = self.person_data[["person_id", "telestatus"]].copy()

        data = data[data["telestatus"] != "Not a Worker"]  # remove not a worker from count

        if occasional_telework == 'yes':
            # note: 4x faster than np.select
            data.loc[data["telestatus"].isin(
                ["1 day a week", "2-3 days a week", "4+ days a week"]), "telestatus"] = 'Occasional Telecommute'

        counts = data.groupby(["telestatus"]).count()
        counts.loc['Total'] = counts.sum()
        counts.reset_index(inplace=True)
        counts['File'] = path  # add file name

        results = counts.pivot(index="File", columns="telestatus", values="person_id")

        # add percentage share
        counts["Total"] = data.person_id.count()
        counts["share"] = counts.person_id / counts.Total
        percent_share = counts.pivot(index="File", columns="telestatus", values="share")

        results = results.append(percent_share, ignore_index=False, sort=True)

        cols = ["No Telecommute",
                "1 day a week",
                "2-3 days a week",
                "4+ days a week",
                "Work from Home",
                "Total"]

        if occasional_telework == 'yes':
            cols = ["No Telecommute",
                    "Occasional Telecommute",
                    "Work from Home",
                    "Total"]

        return results[cols]

    def count_persons(self):
        """ Calculate total number of workers in the person file
        to be used for per capita calculations

        :rtpye :class: `pandas.DataFrame`
        :returns: Number of worker in the personData file by telestatus
        """

        # full path of personData file
        path = self.pretty_print_path()

        data = self.person_data[["person_id", "telestatus"]].copy()

        conditions = [(data["telestatus"] == "Not a Worker"),
                      (data["telestatus"].isin(["No Telecommute",
                                                "1 day a week",
                                                "2-3 days a week",
                                                "4+ days a week",
                                                "Work from Home"]))]
        choices = ["Non-worker", "Worker"]
        data["telestatus"] = np.select(conditions, choices, default=data["telestatus"])

        counts = data.groupby(["telestatus"]).count()
        counts.loc['Total'] = counts.sum()
        counts.reset_index(inplace=True)
        counts['File'] = path  # add file name

        results = counts.pivot(index="File", columns="telestatus", values="person_id")

        # add percentage share
        counts["Total"] = data.person_id.count()
        counts["share"] = counts.person_id / counts.Total
        percent_share = counts.pivot(index="File", columns="telestatus", values="share")

        results = results.append(percent_share, ignore_index=False, sort=True)

        cols = ["Worker",
                "Non-worker",
                "Total"]

        return results[cols]

    def count_persons_models(self, workers_only="yes", metric="persons"):
        """ Person share in each model. NOTE: UNUSED

        :type workers_only: str
        :param workers_only: to include workers only in universe

        :type metric: str
        :param metric: to count duplicate or non duplicate person ids

        :rtype :class: `pandas.DataFrame`
        :returns: Calculated trip-based metric of interest using a
        user-specified weighting criteria by ABM sub-model and mode
        """

        trip_lists = [("Individual", self.individual),
                      ("Internal-External", self.internal_external),
                      ("Joint", self.joint)]

        # build DataFrame of person count in models
        result = pd.DataFrame()
        non_dups = pd.DataFrame()

        for submodel, trips in trip_lists:
            data = trips
            data["model"] = submodel

            # remove non-workers
            if workers_only == "yes":
                data = data[data["telestatus"] != "Not a Worker"].copy()

            # remove duplicate person ids - person id in file multiple times for person trips
            data = data.reset_index().drop_duplicates(
                subset=["PERSON_ID", "model", "telestatus"], keep='first')

            if metric == "non_duplicates":
                non_dups = non_dups.append(data[["PERSON_ID", "telestatus"]], ignore_index=True)

            data = data.groupby(["model", "telestatus"],
                                as_index=False)["PERSON_ID"].count()

            # add to result set
            result = result.append(data, ignore_index=True)

        # append weights/metrics for Resident Models and All Models
        resident = result.loc[result["model"].isin(["Individual",
                                                    "Joint",
                                                    "Internal-External"])]
        resident = resident.groupby(["telestatus"], as_index=False).sum()
        resident["model"] = "Resident Models"
        result = result.append(resident, ignore_index=True, sort=True)

        # append weights/metrics within each model
        all_models = result.groupby(["model"], as_index=False).sum()
        all_models["telestatus"] = "Total"
        result = result.append(all_models, ignore_index=True, sort=True)

        # pivot the result set by telework status
        if metric == "persons":
            result = result.pivot(index="model", columns="telestatus", values="PERSON_ID")
        elif metric == "share":
            result = result.merge(all_models, on="model", suffixes=("", "_total"))
            result["percent_share"] = result.PERSON_ID / result.PERSON_ID_total
            result = result.pivot(index="model", columns="telestatus", values="percent_share")
        elif metric == "non_duplicates":
            # remove duplicate person ids - person id may be in more than one model
            non_dups = non_dups.reset_index().drop_duplicates(
                subset=["PERSON_ID", "telestatus"], keep='first')
            non_dups['model'] = "Resident Models"
            non_dups = non_dups.groupby(["model", "telestatus"],
                                        as_index=False)["PERSON_ID"].count()
            # append weights/metrics within each model across all modes
            all_models = non_dups.groupby(["model"], as_index=False).sum()
            all_models["telestatus"] = "Total"
            non_dups = non_dups.append(all_models, ignore_index=True, sort=True)
            result = non_dups.pivot(index="model", columns="telestatus", values="PERSON_ID")
            non_dups = non_dups.merge(all_models, on="model", suffixes=("", "_total"))
            non_dups["percent_share"] = non_dups.PERSON_ID / non_dups.PERSON_ID_total
            percent_share = non_dups.pivot(index="model", columns="telestatus", values="percent_share")
            result = result.append(percent_share)
        else:
            msg = ("Invalid parameter: metric must be one of "
                   "('persons', 'share')")
            raise ValueError(msg)

        # order the result set rows and columns
        if metric != "non_duplicates":
            result = result.reindex(labels=["Individual",
                                            "Internal-External",
                                            "Joint",
                                            "Resident Models"])

        # add columns if they do not exist
        cols = ["No Telecommute",
                "1 day a week",
                "2-3 days a week",
                "4+ days a week",
                "Work from Home",
                "Not a Worker",  # remove non workers from universe
                "Total"]

        if workers_only == "yes":
            cols.remove("Not a Worker")

        for col in cols:
            if col not in result:
                result[col] = np.NaN

        # return the result set
        return result[cols]

    def calculate_telework_metric(self, metric, weight, workers_only="yes", resident_only="no"):
        """ Calculate a trip-based metric of interest using a user-specified
        weighting criteria by ABM sub-model and mode. The function allows
        for either a trip or person-trip weighting scheme to calculate either
        the trip-based travel distance, mode share, trip-based travel time,
        VMT, or count of trips.

        for VMT per capita sum all the vmt and divide by number of persons.

        vmt is a trip-level distance metric of auto distance
        trip-level means use trip weight (which is the vehicle weight) instead of person weight
        and auto distance means use the auto distance portions of trips

        for auto modes use the trip distance field
        (da, sr, tnc, taxi, school bus)

        for knr, pnr, tnc to transit if the trip is outbound then use transit access distance
        if it is inbound then use transit egress distance

        Note for VMT per capita, divide by number of persons in persons file.
        Do not use the distance calculation for VMT because for driving this
        includes walk distance from the car.

        :type workers_only: str
        :param workers_only: to include workers only. Possible values are
        ("yes","no")

        :type metric: str
        :param metric: Metric of interest to calculate. Possible values are
        ("distance", "share", "time", "trips")

        :type weight: str
        :param weight: Weighting scheme to use in outputting metric of
        interest. Possible values are ("persons", "trips")

        :type resident_only: str
        :param metric: output the sum of the resident models only
        ("yes","no")

        :rtype :class: `pandas.DataFrame`
        :returns: Calculated trip-based metric of interest using a
        user-specified weighting criteria by ABM sub-model and mode
        """

        if metric == "vmt_per_capita":
            print("vmt per capita calculation")

        trip_lists = [("Individual", self.individual),
                      ("Internal-External", self.internal_external),
                      ("Joint", self.joint)]

        start_time_tw_fn = time.time()

        # build DataFrame of weights/metrics by ABM sub-model and mode
        result = pd.DataFrame()
        for submodel, trips in trip_lists:
            data = trips
            data["model"] = submodel

            # remove non-workers
            if workers_only == "yes":
                data = data[data["telestatus"] != "Not a Worker"].copy()

            # select user-specified weight
            if weight == "persons":
                data["weight"] = data["weightPersonTrip"]
            elif weight in ["trips"]:
                data["weight"] = data["weightTrip"]
            else:
                msg = ("Invalid parameter: weight must be one of "
                       "('persons', 'trips')")
                raise ValueError(msg)

            # calculate user-specified metric
            # note for VMT always use weight_trip
            if metric in ["distance", "distance_per_capita"]:
                data["metric"] = data.distanceTotal * data.weight
            elif metric == "total_distance":
                data["metric"] = data.distanceTotal * data.weight
            elif metric == "time":
                data["metric"] = data.timeTotal * data.weight
            elif metric in ["share", "trips"]:
                data["metric"] = data["weight"]
            elif metric in ["vmt", "totalvmt", "vmt_per_capita"]:
                data["metric"] = data.vmt * data.weightTrip
            elif metric in ["trip_rate"]:
                data["metric"] = data["weight"]
            else:
                msg = ("Invalid parameter: metric must be one of "
                       "('distance', 'share', 'time', 'trips')")
                raise ValueError(msg)

            # recode modes to aggregate modes
            conditions = [(data["tripMode"].str.contains("to Transit")),
                          (data["tripMode"].isin(["Light Heavy Duty Truck",
                                              "Medium Heavy Duty Truck",
                                              "Heavy Heavy Duty Truck"]))]
            choices = ["Transit", "Truck"]
            data["tripMode"] = np.select(conditions, choices, default=data["tripMode"])

            data = data.groupby(["model", "telestatus"], as_index=False)["weight", "metric"].sum()

            # add to result set
            result = result.append(data, ignore_index=True)

        # append weights/metrics for Resident Models and All Models
        resident = result.loc[result["model"].isin(["Individual",
                                                    "Joint",
                                                    "Internal-External"])]
        resident = resident.groupby(["telestatus"], as_index=False).sum()
        resident["model"] = "Resident Models"

        result = result.append(resident, ignore_index=True, sort=True)

        # append weights/metrics within each model across all modes
        all_telestatus = result.groupby(["model"], as_index=False).sum()
        all_telestatus["telestatus"] = "Total"
        result = result.append(all_telestatus, ignore_index=True, sort=True)

        # calculate the metric of interest
        if metric in ["distance", "time", "vmt"]:
            result["weighted_metric"] = result.metric / result.weight
        elif metric == "total_distance":
            result["weighted_metric"] = result.metric
        elif metric == "totalvmt":
            result["weighted_metric"] = result.metric
        elif metric == "trips":
            result["weighted_metric"] = result["weight"]
        elif metric == "share":
            # merge weight across all modes with result set by ABM sub-model
            result = result.merge(all_telestatus, on="model", suffixes=("", "_total"))
            # divide weight by weight across all modes within each ABM sub-model
            result["weighted_metric"] = result.weight / result.weight_total
        elif metric in ["trip_rate"]:
            persons = self.count_workers_by_telestatus()[:1].T
            persons.reset_index(inplace=True)
            persons.rename(columns={persons.columns[1]: 'persons'}, inplace=True)
            result = result.merge(persons, on="telestatus")
            result["weighted_metric"] = result["weight"] / result.persons
        elif metric in ["distance_per_capita", "vmt_per_capita"]:
            persons = self.count_workers_by_telestatus()[:1].T
            persons.reset_index(inplace=True)
            persons.rename(columns={persons.columns[1]: 'persons'}, inplace=True)
            result = result.merge(persons, on="telestatus")
            result["weighted_metric"] = result["metric"] / result.persons
        else:
            msg = ("Invalid parameter: metric must be one of "
                   "('distance', 'share', 'time', 'trips')")
            raise ValueError(msg)

        # pivot the result set by telework status
        result = result.pivot(index="model", columns="telestatus", values="weighted_metric")

        # order the result set rows and columns
        result = result.reindex(labels=["Individual",
                                        "Internal-External",
                                        "Joint",
                                        "Resident Models"])

        # add columns if they do not exist
        cols = ["No Telecommute",
                "1 day a week",
                "2-3 days a week",
                "4+ days a week",
                "Work from Home",
                "Not a Worker",  # remove non workers from universe
                "Total"]

        if workers_only == "yes":
            cols.remove("Not a Worker")

        for col in cols:
            if col not in result:
                result[col] = np.NaN

        if resident_only == "yes":
            result = result[result.index == "Resident Models"]

        end_time = time.time()
        time_taken = end_time - start_time_tw_fn
        # print("calculate_telework_metric:", str(datetime.timedelta(seconds=(round(time_taken)))))
        print(metric, "by telework", weight, ":",
              str(datetime.timedelta(seconds=(round(time_taken)))))
        # return the result set
        return result[cols]

    def calculate_tod_metric_telework(self, metric, weight, workers_only="yes", occasional_telework='no',
                                      resident_only="no"):
        """ Calculate VMT by TOD

        :type metric: str
        :param metric: Metric of interest to calculate. Possible values are
        ("distance", "share", "time", "trips","vmt_per_capita", "vmt_per_capita_share")

        :type weight: str
        :param weight: Weighting scheme to use in outputting metric of
        interest. Possible values are ("persons", "trips")

        :type workers_only: str
        :param metric: Universe of workers only. Possible values are
        ("yes","no")

        :type resident_only: str
        :param metric: output the sum of the resident models only
        ("yes","no")

        :type occasional_telework: str
        :param metric: merge categories "1 day a week", "2-3 days a week",
        and "4+ days a week" into one category for occasional_telework (yes)
        ("yes","no")

        :rtpye :class: `pandas.DataFrame`
        :returns: Calculated trip-based metric of interest using a
        user-specified weighting criteria by ABM sub-model and TOD
        """

        start_time_tod_fn = time.time()
        telework_category = 'telework'  # for printing time taken

        trip_lists = [("Individual", self.individual),
                      ("Internal-External", self.internal_external),
                      ("Joint", self.joint)]

        # build DataFrame of weights/metrics by ABM sub-model and mode
        result = pd.DataFrame()

        for submodel, trips in trip_lists:

            data = trips
            data["model"] = submodel

            # remove workers from the universe
            # note: not in the read trips data bc some functions include non-workers
            if workers_only == "yes":
                # need a copy here because of assignments later on
                data = data[data["telestatus"] != "Not a Worker"].copy()

            if occasional_telework == 'yes':
                # note: 4x faster than np.select
                data.loc[data["telestatus"].isin(
                    ["1 day a week", "2-3 days a week", "4+ days a week"]), "telestatus"] = 'Occasional Telecommute'
                telework_category = 'occasional_telework'  # for printing time taken

            # select user-specified weight
            if weight == "persons":
                data["weight"] = data["weightPersonTrip"]
            elif weight == "trips":
                data["weight"] = data["weightTrip"]
            else:
                msg = ("Invalid parameter: weight must be one of "
                       "('persons', 'trips')")
                raise ValueError(msg)

            # calculate user-specified metric
            if metric == "distance":
                data["metric"] = data.distanceTotal * data.weight
            elif metric == "time":
                data["metric"] = data.timeTotal * data.weight
            elif metric in ["share", "trips"]:
                data["metric"] = data["weight"]
            elif metric in ["vmt_per_capita", "vmt_per_capita_share"]:
                data["metric"] = data.vmt * data.weightTrip
            else:
                msg = ("Invalid parameter: metric must be one of "
                       "('distance', 'share', 'time', 'trips', 'vmt_per_capita', 'vmt_per_capita_share')")
                raise ValueError(msg)

            # recode TOD from 1-5 to times of day
            conditions = [(data["departTimeFiveTod"] == 1),
                          (data["departTimeFiveTod"] == 2),
                          (data["departTimeFiveTod"] == 3),
                          (data["departTimeFiveTod"] == 4),
                          (data["departTimeFiveTod"] == 5)]

            choices = ["Early AM",
                       "AM Peak",
                       "Midday",
                       "PM Peak",
                       "Evening"]

            data["TOD"] = np.select(conditions, choices, default=data["departTimeFiveTod"])

            # group by TOD and telework status
            data = data.groupby(["model", "TOD", "telestatus"], as_index=False)["weight", "metric"].sum()

            #  add to result set
            result = result.append(data, ignore_index=True)

        resident = result.loc[result["model"].isin(["Individual",
                                                    "Joint",
                                                    "Internal-External"])]

        resident = resident.groupby(["TOD", "telestatus"], as_index=False).sum()
        resident["model"] = "Resident Models"

        result = result.append(resident, ignore_index=True, sort=True)

        # append weights/metrics within each model across all modes
        all_modes = result.groupby(["model", "telestatus"], as_index=False).sum()
        all_modes["TOD"] = "Total"
        result = result.append(all_modes, ignore_index=True, sort=True)

        # calculate the metric of interest
        if metric in ["distance", "time"]:
            result["weighted_metric"] = result.metric / result.weight
        elif metric == "trips":
            result["weighted_metric"] = result["weight"]
        elif metric == "share":
            # merge weight across all modes with result set by ABM sub-model
            result = result.merge(all_modes, on=["model", "telestatus"], suffixes=("", "_total"))
            # divide weight by weight across all modes within each ABM sub-model
            result["weighted_metric"] = result.weight / result.weight_total
        elif metric in ["vmt_per_capita", "vmt_per_capita_share"]:
            # persons data by telestatus for per capita denominator
            # a count of persons in each category
            persons = self.count_workers_by_telestatus()[:1].T
            persons.reset_index(inplace=True)
            persons.rename(columns={persons.columns[1]: 'persons'}, inplace=True)
            # person categories for occasional telework category
            if occasional_telework == 'yes':
                persons.loc[persons["telestatus"].isin(
                    ["1 day a week", "2-3 days a week", "4+ days a week"]), "telestatus"] = 'Occasional Telecommute'
                # recount persons in each category
                persons = persons.groupby(["telestatus"], as_index=False).sum()

            result = result.merge(persons, on="telestatus")
            result["weighted_metric"] = result["metric"] / result.persons
        else:
            msg = ("Invalid parameter: metric must be one of "
                   "('distance', 'share', 'time', 'trips', 'vmt_per_capita', 'vmt_per_capita_share')")
            raise ValueError(msg)

        result = result[result['model'] == "Resident Models"]
        result = result.pivot_table(index=["model", "TOD"], columns='telestatus',
                                    values="weighted_metric").reset_index()

        if metric == "vmt_per_capita_share":
            result1 = result.iloc[:, :2]
            result2 = result.iloc[:, 2:].div(result.iloc[:5, 2:].sum(axis=0), axis=1)
            result = result1.join(result2)

        row_order = ["Early AM",
                     "AM Peak",
                     "Midday",
                     "PM Peak",
                     "Evening",
                     "Total"]

        result["TOD"] = result["TOD"].astype("category")
        result["TOD"].cat.set_categories(row_order, inplace=True)

        result.sort_values(["TOD"], inplace=True)
        result.set_index("TOD", inplace=True)

        cols = ["No Telecommute",
                "1 day a week",
                "2-3 days a week",
                "4+ days a week",
                "Work from Home",
                "model"]

        if occasional_telework == 'yes':
            cols = ["No Telecommute",
                    "Occasional Telecommute",
                    "Work from Home",
                    "model"]

        end_time = time.time()
        time_taken = end_time - start_time_tod_fn

        print(metric, "by TOD by", telework_category, ":",
              str(datetime.timedelta(seconds=(round(time_taken)))))

        if resident_only == "yes":
            result = result[result["model"] == "Resident Models"]

        return result[cols]

    def calculate_mode_metric_telework(self, metric, weight, workers_only='yes', resident_only='yes'):
        """ Calculate a trip-based metric of interest using a user-specified
        weighting criteria by ABM sub-model and mode. The function allows
        for either a trip or person-trip weighting scheme to calculate either
        the trip-based travel distance, mode share, trip-based travel time,
        or count of trips.

        :param resident_only:
        :type metric: str
        :param metric: sum of all 3 resident models only
        ("yes", "no")

        :type weight: str
        :param weight: Weighting scheme to use in outputting metric of
        interest. Possible values are ("persons", "trips")

        :type workers_only: str
        :param metric: Universe of workers only. Possible values are
        ("yes","no")

        :rtpye :class: `pandas.DataFrame`
        :returns: Calculated trip-based metric of interest using a
        user-specified weighting criteria by ABM sub-model and mode
        """

        start_time_fn = time.time()

        trip_lists = [("Individual", self.individual),
                      ("Joint", self.joint),
                      ("Internal-External", self.internal_external)]

        # build DataFrame of weights/metrics by ABM sub-model and mode
        result = pd.DataFrame()
        for submodel, trips in trip_lists:
            data = trips.copy()
            data["model"] = submodel

            # remove non-workers if worker only universe specified
            if workers_only == 'yes':
                data = data[data["telestatus"] != "Not a Worker"].copy()

            # select user-specified weight
            if weight == "persons":
                data["weight"] = data["weightPersonTrip"]
            elif weight == "trips":
                data["weight"] = data["weightTrip"]
            else:
                msg = ("Invalid parameter: weight must be one of "
                       "('persons', 'trips')")
                raise ValueError(msg)

            # calculate user-specified metric
            if metric in ["distance", "totaldistance"]:
                data["metric"] = data.distanceTotal * data.weight
            elif metric == "time":
                data["metric"] = data.timeTotal * data.weight
            elif metric == "vmt":
                data["metric"] = data.vmt * data.weight_trip
            elif metric in ["share", "trips"]:
                data["metric"] = data["weight"]
            else:
                msg = ("Invalid parameter: metric must be one of "
                       "('distance', 'share', 'time', 'trips')")
                raise ValueError(msg)

            # recode modes to aggregate modes
            conditions = [(data["tripMode"].str.contains("to Transit")),
                          (data["tripMode"].isin(["Light Heavy Duty Truck",
                                              "Medium Heavy Duty Truck",
                                              "Heavy Heavy Duty Truck"]))]
            choices = ["Transit", "Truck"]
            data["tripMode"] = np.select(conditions, choices, default=data["tripMode"])

            data = data.groupby(["model", "tripMode", "telestatus"], as_index=False)["weight", "metric"].sum()

            # add to result set
            result = result.append(data, ignore_index=True)

        # append weights/metrics for Resident Models and All Models
        resident = result.loc[result["model"].isin(["Individual",
                                                    "Joint",
                                                    "Internal-External"])]

        resident = resident.groupby(["tripMode", "telestatus"], as_index=False).sum()
        resident["model"] = "Resident Models"

        # all_models = result.groupby(["mode"], as_index=False).sum()
        # all_models["submodel"] = "All Models"

        result = result.append(resident, ignore_index=True, sort=True)
        # result = result.append(all_models, ignore_index=True, sort=True)

        # append weights/metrics within each model across all modes
        all_modes = result.groupby(["model", "telestatus"], as_index=False).sum()
        all_modes["tripMode"] = "Total"
        result = result.append(all_modes, ignore_index=True, sort=True)

        # calculate the metric of interest
        if metric in ["distance", "time"]:
            result["weighted_metric"] = result.metric / result.weight
        elif metric == "totaldistance":
            result["weighted_metric"] = result["metric"]
        elif metric == "trips":
            result["weighted_metric"] = result["weight"]
        elif metric == "share":
            # merge weight across all modes with result set by ABM sub-model
            result = result.merge(all_modes, on=["model", "telestatus"], suffixes=("", "_total"))
            # divide weight by weight across all modes within each ABM sub-model
            result["weighted_metric"] = result.weight / result.weight_total
        else:
            msg = ("Invalid parameter: metric must be one of "
                   "('distance', 'share', 'time', 'trips')")
            raise ValueError(msg)

        # pivot the result set by mode
        # result = result.pivot(index=["model","telestatus"], columns="mode", values="weighted_metric")
        result = result.pivot_table(index=["model", "telestatus"], columns='tripMode',
                                    values="weighted_metric").reset_index()

        cols = ["telestatus",
                "Drive Alone",
                "Shared Ride 2",
                "Shared Ride 3+",
                "Non-Pooled TNC",
                "Pooled TNC",
                "Walk",
                "Bike",
                "Micro-Mobility",
                "Micro-Transit",
                "Transit",
                "Taxi",
                "Truck",
                "School Bus",
                "Total"]

        result.index.name = result.columns.name = None

        # order the result set rows and columns
        sorter = ["No Telecommute",
                  "1 day a week",
                  "2-3 days a week",
                  "4+ days a week",
                  "Work from Home",
                  "Not a Worker"]

        result["telestatus"] = result["telestatus"].astype("category")
        result["telestatus"].cat.set_categories(sorter, inplace=True)
        result.sort_values(["model", "telestatus"], inplace=True)

        sorter = ["Individual",
                  "Internal-External",
                  "Joint",
                  "Resident Models"]

        result.model = result.model.astype("category")
        result.model.cat.set_categories(sorter, inplace=True)

        result.sort_values(["model", "telestatus"], inplace=True)
        if resident_only:
            result = result[result["model"] == "Resident Models"]
        result.set_index('model', inplace=True)

        # add columns if they do not exist
        for col in cols:
            if col not in result:
                result[col] = np.NaN

        end_time = time.time()
        time_taken = end_time - start_time_fn
        print(metric, "by mode", weight, "and telework:",
              str(datetime.timedelta(seconds=(round(time_taken)))))

        return result[cols]

    def calculate_mode_metric(self, metric, weight) -> pd.DataFrame:
        """ Calculate a trip-based metric of interest using a user-specified
        weighting criteria by ABM sub-model and mode. The function allows
        for either a trip or person-trip weighting scheme to calculate either
        the trip-based travel distance, mode share, trip-based travel time,
        or count of trips.

        Args:
            metric: Metric of interest to calculate. Possible values are
                ("distance", "share", "time", "trips").
            weight: Weighting scheme to use in outputting metric of
                interest. Possible values are ("persons", "trips").
        """

        trip_lists = [("Airport - CBX", self.airport_cbx),
                      ("Airport - SAN", self.airport_san),
                      ("Commercial Vehicle", self.commercial_vehicle),
                      ("Cross Border", self.cross_border),
                      ("External-External", self.external_external),
                      ("External-Internal", self.external_internal),
                      ("Individual", self.individual),
                      ("Internal-External", self.internal_external),
                      ("Joint", self.joint),
                      ("Truck", self.truck),
                      ("Visitor", self.visitor)]

        # build DataFrame of weights/metrics by ABM sub-model and mode
        result = pd.DataFrame()

        for submodel, trips in trip_lists:

            data = trips
            data["model"] = submodel

            # select user-specified weight
            if weight == "persons":
                data["weight"] = data["weightPersonTrip"]
            elif weight == "trips":
                data["weight"] = data["weightTrip"]
            else:
                msg = ("Invalid parameter: weight must be one of "
                       "('persons', 'trips')")
                raise ValueError(msg)

            # calculate user-specified metric
            if metric == "distance":
                data["metric"] = data.distanceTotal * data.weight
            elif metric == "time":
                data["metric"] = data.timeTotal * data.weight
            elif metric in ["share", "trips"]:
                data["metric"] = data["weight"]
            else:
                msg = ("Invalid parameter: metric must be one of "
                       "('distance', 'share', 'time', 'trips')")
                raise ValueError(msg)

            # recode modes to aggregate modes
            conditions = [(data["tripMode"].str.contains("to Transit")),
                          (data["tripMode"].isin(["Light Heavy Duty Truck",
                                              "Medium Heavy Duty Truck",
                                              "Heavy Heavy Duty Truck"]))]
            choices = ["Transit", "Truck"]
            data["tripMode"] = np.select(conditions, choices, default=data["tripMode"])

            # aggregate weight and metric to ABM sub-model and mode
            data = data.groupby(["model", "tripMode"], as_index=False)["weight", "metric"].sum()

            # add to result set
            result = result.append(data, ignore_index=True)

        # append weights/metrics for Resident Models and All Models
        resident = result.loc[result["model"].isin(["Individual",
                                                    "Joint",
                                                    "Internal-External"])]
        resident = resident.groupby(["tripMode"], as_index=False).sum()
        resident["model"] = "Resident Models"

        all_models = result.groupby(["tripMode"], as_index=False).sum()
        all_models["model"] = "All Models"

        result = result.append(resident, ignore_index=True, sort=True)
        result = result.append(all_models, ignore_index=True, sort=True)

        # append weights/metrics within each model across all modes
        all_modes = result.groupby(["model"], as_index=False).sum()
        all_modes["tripMode"] = "Total"

        result = result.append(all_modes, ignore_index=True, sort=True)

        # calculate the metric of interest
        if metric in ["distance", "time"]:
            result["weighted_metric"] = result.metric / result.weight
        elif metric == "trips":
            result["weighted_metric"] = result["weight"]
        elif metric == "share":
            # merge weight across all modes with result set by ABM sub-model
            result = result.merge(all_modes, on="model", suffixes=("", "_total"))
            # divide weight by weight across all modes within each ABM sub-model
            result["weighted_metric"] = result.weight / result.weight_total
        else:
            msg = ("Invalid parameter: metric must be one of "
                   "('distance', 'share', 'time', 'trips')")
            raise ValueError(msg)

        # pivot the result set by mode
        result = result.pivot(index="model", columns="tripMode", values="weighted_metric")

        # order the result set rows and columns
        result = result.reindex(labels=["Airport - CBX",
                                        "Airport - SAN",
                                        "Commercial Vehicle",
                                        "Cross Border",
                                        "External-External",
                                        "External-Internal",
                                        "Individual",
                                        "Internal-External",
                                        "Joint",
                                        "Truck",
                                        "Visitor",
                                        "Resident Models",
                                        "All Models"])

        # add columns if they do not exist
        cols = ["Drive Alone",
                "Shared Ride 2",
                "Shared Ride 3+",
                "Non-Pooled TNC",
                "Pooled TNC",
                "Walk",
                "Bike",
                "Micro-Mobility",
                "Micro-Transit",
                "Transit",
                "Taxi",
                "Truck",
                "School Bus",
                "Total"]

        for col in cols:
            if col not in result:
                result[col] = np.NaN

        # return the result set
        return result[cols]

    def calculate_model_metric(self, metric, weight) -> pd.DataFrame:
        """ Calculate a trip-based metric of interest using a user-specified
        weighting criteria by ABM sub-model. The function allows
        for either a trip or person-trip weighting scheme to calculate either
        the trip-based travel distance, mode share, trip-based travel time,
        or count of trips.

        Args:
            metric: Metric of interest to calculate. Possible values are
                ("distance", "share", "time", "trips").
            weight: Weighting scheme to use in outputting metric of
                interest. Possible values are ("persons", "trips"). """

        trip_lists = [("Airport - CBX", self.airport_cbx),
                      ("Airport - SAN", self.airport_san),
                      ("Commercial Vehicle", self.commercial_vehicle),
                      ("Cross Border", self.cross_border),
                      ("External-External", self.external_external),
                      ("External-Internal", self.external_internal),
                      ("Individual", self.individual),
                      ("Internal-External", self.internal_external),
                      ("Joint", self.joint),
                      ("Truck", self.truck),
                      ("Visitor", self.visitor)]

        # build DataFrame of weights/metrics by ABM sub-model and mode
        result = pd.DataFrame()
        for submodel, trips in trip_lists:
            data = trips.copy()

            # select user-specified weight
            if weight == "persons":
                data["weight"] = data["weightPersonTrip"]
            elif weight == "trips":
                data["weight"] = data["weightTrip"]
            else:
                msg = ("Invalid parameter: weight must be one of "
                       "('persons', 'trips')")
                raise ValueError(msg)

            # calculate user-specified metric
            if metric == "distance":
                data["metric"] = data.distanceTotal * data.weight
            elif metric == "time":
                data["metric"] = data.timeTotal * data.weight
            elif metric in ["share", "trips"]:
                data["metric"] = data["weight"]
            else:
                msg = ("Invalid parameter: metric must be one of "
                       "('distance', 'share', 'time', 'trips')")
                raise ValueError(msg)

            # aggregate weight and metric to ABM sub-model
            data = data[["weight", "metric"]].sum()
            data["model"] = submodel

            # add to result set
            result = result.append(data, ignore_index=True)

        # append weights/metrics for Resident Models and All Models
        resident = result.loc[result["model"].isin(["Individual",
                                                    "Joint",
                                                    "Internal-External"])]
        resident = resident.sum()
        resident["model"] = "Resident Models"

        all_models = result.sum()
        all_models["model"] = "All Models"

        result = result.append(resident, ignore_index=True, sort=True)
        result = result.append(all_models, ignore_index=True, sort=True)

        # calculate the metric of interest
        if metric in ["distance", "time"]:
            result["weighted_metric"] = result.metric / result.weight
        elif metric == "trips":
            result["weighted_metric"] = result["weight"]
        elif metric == "share":
            # divide weight by weight across all ABM sub-models
            result["weighted_metric"] = result.weight / all_models.weight
        else:
            msg = ("Invalid parameter: metric must be one of "
                   "('distance', 'share', 'time', 'trips')")
            raise ValueError(msg)

        # pivot the result set by model
        result = result.pivot_table(values="weighted_metric",
                                    columns=["model"],
                                    aggfunc=np.sum,
                                    fill_value=0)

        # order the result set columns
        # add columns if they do not exist
        cols = ["Airport - CBX",
                "Airport - SAN",
                "Commercial Vehicle",
                "Cross Border",
                "External-External",
                "External-Internal",
                "Individual",
                "Internal-External",
                "Joint",
                "Truck",
                "Visitor",
                "Resident Models",
                "All Models"]

        for col in cols:
            if col not in result:
                result[col] = np.NaN

        # return the result set
        return result[cols]

    def calculate_passenger_metric(self, metric, switch=True):
        """ Calculate a trip-based metric of interest for the TNC and AV trip
        lists using a user-specified weighting criteria by ABM sub-model and
        passenger categories. The function uses a trip weighting scheme to
        calculate either the trip-based travel distance, share of trips by
        passenger category, trip-based travel time, count of trips, or VMT.

        :type metric: str
        :param metric: Metric of interest to calculate. Possible values are
        ("distance", "share", "time", "trips", "vmt")

        :type switch: boolean
        :param metric: Turn AV/TNC passenger metric report "on" or "off".
        Returns a DataFrame of all NaNs.

        :rtpye :class: `pandas.DataFrame`
        :returns: Calculated trip-based metric of interest by ABM sub-model
        and number of passengers
        """

        # return NaNs if AV/TNC switch is set to False
        if not switch:
            data = {"model": ["AVs", "TNCs", "AVs and TNCs"],
                    "0 passengers": [np.nan] * 3,
                    "1 passenger": [np.nan] * 3,
                    "2+ passengers": [np.nan] * 3,
                    "Total": [np.nan] * 3}
            idx = {"model": ["AVs", "TNCs", "AVs and TNCs"]}
            result = pd.DataFrame(data).set_index("model")
            return result

        trip_lists = [("AVs", self.household_av),
                      ("TNCs", self.tnc)]

        # check scenario has AVs and TNCs
        # return NaN DataFrame if scenario does not have both
        for submodel, trips in trip_lists:
            if trips is False:
                data = {"model": ["AVs", "TNCs", "AVs and TNCs"],
                        "0 passengers": [np.nan] * 3,
                        "1 passenger": [np.nan] * 3,
                        "2+ passengers": [np.nan] * 3,
                        "Total": [np.nan] * 3}
                idx = {"model": ["AVs", "TNCs", "AVs and TNCs"]}
                result = pd.DataFrame(data).set_index("model")
                return result

        # build DataFrame of weights/metrics by ABM sub-model and mode
        result = pd.DataFrame()
        for submodel, trips in trip_lists:
            data = trips
            data["model"] = submodel

            # use trip-based weight
            data["weight"] = data["weightTrip"]

            # calculate user-specified metric
            if metric in ["distance", "vmt"]:
                data["metric"] = data.distanceTotal * data.weight
            elif metric == "time":
                data["metric"] = data.timeTotal * data.weight
            elif metric in ["share", "trips"]:
                data["metric"] = data["weight"]
            else:
                msg = ("Invalid parameter: metric must be one of "
                       "('distance', 'share', 'time', 'trips', 'vmt')")
                raise ValueError(msg)

            # recode passenger column combining categories
            conditions = [(data["passengers"] == 0),
                          (data["passengers"] == 1),
                          (data["passengers"] > 1)]
            choices = ["0 passengers", "1 passenger", "2+ passengers"]
            data["passengersString"] = np.select(conditions, choices, default=np.nan)

            # aggregate weight and metric to ABM sub-model and passengers
            data = data.groupby(["model", "passengersString"], as_index=False)["weight", "metric"].sum()

            # add to result set
            result = result.append(data, ignore_index=True)

        # append weights/metrics for combined AV and TNC trip lists
        all_models = result.groupby(["passengersString"], as_index=False).sum()
        all_models["model"] = "AVs and TNCs"
        result = result.append(all_models, ignore_index=True, sort=True)

        # append weights/metrics within each model across all passenger categories
        all_passengers = result.groupby(["model"], as_index=False).sum()
        all_passengers["passengersString"] = "Total"
        result = result.append(all_passengers, ignore_index=True, sort=True)

        # calculate the metric of interest
        if metric in ["distance", "time"]:
            result["weighted_metric"] = result.metric / result.weight
        elif metric == "trips":
            result["weighted_metric"] = result["weight"]
        elif metric == "share":
            # merge weight across all passenger categories with result set by ABM sub-model
            result = result.merge(all_passengers, on="model", suffixes=("", "_total"))
            # divide weight by weight across all passenger categories within each ABM sub-model
            result["weighted_metric"] = result.weight / result.weight_total
        elif metric == "vmt":
            result["weighted_metric"] = result["metric"]
        else:
            msg = ("Invalid parameter: metric must be one of "
                   "('distance', 'share', 'time', 'trips', 'vmt')")
            raise ValueError(msg)

        # pivot the result set by mode
        result = result.pivot(index="model", columns="passengersString", values="weighted_metric")

        # order the result set rows and columns
        result = result.reindex(labels=["AVs",
                                        "TNCs",
                                        "AVs and TNCs"])

        # add columns if they do not exist
        cols = ["0 passengers",
                "1 passenger",
                "2+ passengers",
                "Total"]

        for col in cols:
            if col not in result:
                result[col] = np.NaN

        # return the result set
        return result[cols]

    def calculate_purpose_metric(self, metric, weight):
        """ Calculate a trip-based metric of interest using a user-specified
        weighting criteria by ABM sub-model and purpose. The function allows
        for either a trip or person-trip weighting scheme to calculate either
        the trip-based travel distance, purpose share, trip-based travel time,
        or count of trips.

        :type metric: str
        :param metric: Metric of interest to calculate. Possible values are
        ("distance", "share", "time", "trips")

        :type weight: str
        :param weight: Weighting scheme to use in outputting metric of
        interest. Possible values are ("persons", "trips")

        :rtpye :class: `pandas.DataFrame`
        :returns: Calculated trip-based metric of interest using a
        user-specified weighting criteria by ABM sub-model and purpose
        """

        start_time = time.time()
        trip_lists = [("Airport - CBX", self.airport_cbx),
                      ("Airport - SAN", self.airport_san),
                      ("Commercial Vehicle", self.commercial_vehicle),
                      ("Cross Border", self.cross_border),
                      ("External-External", self.external_external),
                      ("External-Internal", self.external_internal),
                      ("Individual", self.individual),
                      ("Internal-External", self.internal_external),
                      ("Joint", self.joint),
                      ("Truck", self.truck),
                      ("Visitor", self.visitor)]

        # build DataFrame of weights/metrics by ABM sub-model and purpose
        result = pd.DataFrame()
        for submodel, trips in trip_lists:
            data = trips.copy()
            data["model"] = submodel

            # select user-specified weight
            if weight == "persons":
                data["weight"] = data["weightPersonTrip"]
            elif weight == "trips":
                data["weight"] = data["weightTrip"]
            else:
                msg = ("Invalid parameter: weight must be one of "
                       "('persons', 'trips')")
                raise ValueError(msg)

            # calculate user-specified metric
            if metric == "distance":
                data["metric"] = data.distanceTotal * data.weight
            elif metric == "time":
                data["metric"] = data.timeTotal * data.weight
            elif metric in ["share", "trips"]:
                data["metric"] = data["weight"]
            else:
                msg = ("Invalid parameter: metric must be one of "
                       "('distance', 'share', 'time', 'trips')")
                raise ValueError(msg)

            # recode purposes to aggregate purposes
            conditions = [(data["purpose"].isin(["Resident Business",
                                                 "Visitor Business"])),
                          (data["purpose"].isin(["Discretionary",
                                                 "Recreation"])),
                          (data["purpose"].isin(["Eating Out",
                                                 "Dining"])),
                          (data["purpose"].isin(["External",
                                                 "Unknown",
                                                 "Non-Work"])),
                          (data["purpose"].isin(["Resident Personal",
                                                 "Visitor Personal"])),
                          (data["purpose"] == "Visiting"),
                          (data["purpose"].isin(["Work-Based",
                                                 "Work-Related",
                                                 "work related"]))]
            choices = ["Business",
                       "Discretionary/Recreation",
                       "Eating Out/Dining",
                       "Other",
                       "Personal",
                       "Visit",
                       "Work-Based/Work-Related"]
            data["purpose"] = np.select(conditions, choices, default=data["purpose"])

            # aggregate weight and metric to ABM sub-model and purposes
            data = data.groupby(["model", "purpose"], as_index=False)["weight", "metric"].sum()

            # add to result set
            result = result.append(data, ignore_index=True)

        # append weights/metrics for Resident Models and All Models
        resident = result.loc[result["model"].isin(["Individual",
                                                    "Joint",
                                                    "Internal-External"])]
        resident = resident.groupby(["purpose"], as_index=False).sum()
        resident["model"] = "Resident Models"

        all_models = result.groupby(["purpose"], as_index=False).sum()
        all_models["model"] = "All Models"

        result = result.append(resident, ignore_index=True, sort=True)
        result = result.append(all_models, ignore_index=True, sort=True)

        # append weights/metrics within each model across all purposes
        all_purposes = result.groupby(["model"], as_index=False).sum()
        all_purposes["purpose"] = "Total"
        result = result.append(all_purposes, ignore_index=True, sort=True)

        # calculate the metric of interest
        if metric in ["distance", "time"]:
            result["weighted_metric"] = result.metric / result.weight
        elif metric == "trips":
            result["weighted_metric"] = result["weight"]
        elif metric == "share":
            # merge weight across all purpose with result set by ABM sub-model
            result = result.merge(all_purposes, on="model", suffixes=("", "_total"))
            # divide weight by weight across all purposes within each ABM sub-model
            result["weighted_metric"] = result.weight / result.weight_total
        else:
            msg = ("Invalid parameter: metric must be one of "
                   "('distance', 'share', 'time', 'trips')")
            raise ValueError(msg)

        # pivot the result set by purpose
        result = result.pivot(index="model", columns="purpose", values="weighted_metric")

        # order the result set rows and columns
        result = result.reindex(labels=["Airport - CBX",
                                        "Airport - SAN",
                                        "Commercial Vehicle",
                                        "Cross Border",
                                        "External-External",
                                        "External-Internal",
                                        "Individual",
                                        "Internal-External",
                                        "Joint",
                                        "Truck",
                                        "Visitor",
                                        "Resident Models",
                                        "All Models"])

        # add columns if they do not exist
        cols = ["Business",
                "Cargo",
                "Discretionary/Recreation",
                "Eating Out/Dining",
                "Escort",
                "Home",
                "Maintenance",
                "Not Applicable",
                "Other",
                "Personal",
                "School",
                "Shop",
                "University",
                "Visit",
                "Work",
                "Work-Based/Work-Related",
                'Goods',   # Added
                'Return to Establishment',   # Added
                'Service',   # Added
                "Total"]

        for col in cols:
            if col not in result:
                result[col] = np.NaN

        end_time = time.time()

        # Time taken in seconds
        time_taken = end_time - start_time

        print(metric, "by purpose", weight, ":",
              str(datetime.timedelta(seconds=(round(time_taken)))))

        # return the result set
        return result[cols]

    def calculate_purpose_metric_telework(self, metric, weight, workers_only='yes', resident_only='no'):
        """ Calculate a trip-based metric of interest using a user-specified
        weighting criteria by ABM sub-model and purpose. The function allows
        for either a trip or person-trip weighting scheme to calculate either
        the trip-based travel distance, purpose share, trip-based travel time,
        or count of trips.

        :param resident_only:
        :type metric: str
        :param metric: Resident only output. Possible values are
        ("yes", "no")

        :type weight: str
        :param weight: Weighting scheme to use in outputting metric of
        interest. Possible values are ("persons", "trips")

        :type workers_only: str
        :param metric: Universe of workers only. Possible values are
        ("yes","no")

        :rtpye :class: `pandas.DataFrame`
        :returns: Calculated trip-based metric of interest using a
        user-specified weighting criteria by ABM sub-model and purpose
        """

        trip_lists = [("Individual", self.individual),
                      ("Internal-External", self.internal_external),
                      ("Joint", self.joint)]

        # build DataFrame of weights/metrics by ABM sub-model and purpose
        result = pd.DataFrame()
        for submodel, trips in trip_lists:
            data = trips.copy()
            data["model"] = submodel

            # remove non-workers if worker only universe specified
            if workers_only == 'yes':
                data = data[data["telestatus"] != "Not a Worker"]

            # select user-specified weight
            if weight == "persons":
                data["weight"] = data["weightPersonTrip"]
            elif weight == "trips":
                data["weight"] = data["weightTrip"]
            else:
                msg = ("Invalid parameter: weight must be one of "
                       "('persons', 'trips')")
                raise ValueError(msg)

            # calculate user-specified metric
            if metric == "distance":
                data["metric"] = data.distanceTotal * data.weight
            elif metric == "time":
                data["metric"] = data.timeTotal * data.weight
            elif metric in ["share", "trips"]:
                data["metric"] = data["weight"]
            elif metric in ["trip_rate"]:
                data["metric"] = data["weight"]
            else:
                msg = ("Invalid parameter: metric must be one of "
                       "('distance', 'share', 'time', 'trips')")
                raise ValueError(msg)

            # recode purposes to aggregate purposes
            conditions = [(data["purpose"].isin(["Resident Business",
                                                 "Visitor Business"])),
                          (data["purpose"].isin(["Discretionary",
                                                 "Recreation"])),
                          (data["purpose"].isin(["Eating Out",
                                                 "Dining"])),
                          (data["purpose"].isin(["External",
                                                 "Unknown",
                                                 "Non-Work"])),
                          (data["purpose"].isin(["Resident Personal",
                                                 "Visitor Personal"])),
                          (data["purpose"] == "Visiting"),
                          (data["purpose"].isin(["Work-Based",
                                                 "Work-Related",
                                                 "work related"]))]
            choices = ["Business",
                       "Discretionary/Recreation",
                       "Eating Out/Dining",
                       "Other",
                       "Personal",
                       "Visit",
                       "Work-Based/Work-Related"]
            data["purpose"] = np.select(conditions, choices, default=data["purpose"])

            # aggregate weight and metric to ABM sub-model and purposes
            data = data.groupby(["model", "purpose", "telestatus"], as_index=False)["weight", "metric"].sum()

            # add to result set
            result = result.append(data, ignore_index=True)

        # append weights/metrics for Resident Models and All Models
        resident = result.loc[result["model"].isin(["Individual",
                                                    "Joint",
                                                    "Internal-External"])]

        resident = resident.groupby(["purpose", "telestatus"], as_index=False).sum()
        resident["model"] = "Resident Models"

        # all_models = result.groupby(["tripPurposeDestination"], as_index=False).sum()
        # all_models["model"] = "All Models"

        result = result.append(resident, ignore_index=True, sort=True)
        # result = result.append(all_models, ignore_index=True, sort=True)

        # append weights/metrics within each model across all purposes
        all_purposes = result.groupby(["model", "telestatus"], as_index=False).sum()
        all_purposes["purpose"] = "Total"
        result = result.append(all_purposes, ignore_index=True, sort=True)

        # calculate the metric of interest
        if metric in ["distance", "time"]:
            result["weighted_metric"] = result.metric / result.weight
        elif metric == "trips":
            result["weighted_metric"] = result["weight"]
        elif metric == "share":
            # merge weight across all purpose with result set by ABM sub-model
            result = result.merge(all_purposes, on=["model", "telestatus"], suffixes=("", "_total"))
            # divide weight by weight across all purposes within each ABM sub-model
            result["weighted_metric"] = result.weight / result.weight_total
        elif metric in ["trip_rate"]:
            persons = self.count_workers_by_telestatus()[:1].T
            persons.reset_index(inplace=True)
            persons.rename(columns={persons.columns[1]: 'persons'}, inplace=True)
            result = result.merge(persons, on="telestatus")
            # data["metric"] = data["weight"] / data.persons
            # result["metric"] = result.persons
            result["weighted_metric"] = result["weight"] / result.persons
        else:
            msg = ("Invalid parameter: metric must be one of "
                   "('distance', 'share', 'time', 'trips')")
            raise ValueError(msg)

        # pivot the result set by purpose
        result = result.pivot_table(index=["model", "telestatus"], columns="purpose",
                                    values="weighted_metric").reset_index()

        result.index.name = result.columns.name = None

        # order the result set rows and columns
        sorter = ["No Telecommute",
                  "1 day a week",
                  "2-3 days a week",
                  "4+ days a week",
                  "Work from Home",
                  "Not a Worker"]

        result["telestatus"] = result["telestatus"].astype("category")
        result["telestatus"].cat.set_categories(sorter, inplace=True)
        result.sort_values(["model", "telestatus"], inplace=True)

        # order the models
        sorter = ["Individual",
                  "Internal-External",
                  "Joint",
                  "Resident Models"]

        result.model = result.model.astype("category")
        result.model.cat.set_categories(sorter, inplace=True)

        result.sort_values(["model", "telestatus"], inplace=True)

        result.set_index('model', inplace=True)

        # add columns if they do not exist
        cols = ["telestatus",
                "Business",
                "Cargo",
                "Discretionary/Recreation",
                "Eating Out/Dining",
                "Escort",
                "Home",
                "Maintenance",
                "Not Applicable",
                "Other",
                "Personal",
                "School",
                "Shop",
                "University",
                "Visit",
                "Work",
                "Work-Based/Work-Related",
                'Goods',   # Added
                'Return to Establishment',   # Added
                'Service',   # Added
                "Total"]

        for col in cols:
            if col not in result:
                result[col] = np.NaN

        if resident_only == "yes":
            result = result[result.index == "Resident Models"]

        # return the result set
        return result[cols]
        
    def calculate_microtransit(self, visitor=False):
        """ Calculates micro transit statistics on user-specified data.

        :type visitor: boolean
        :param visitor: Boolean indicating whether to use the visitor trip
        data or individual. Possible values are (True, False).

        :rtpye :class: pandas.DataFrame`
        :returns: Calculated micro transit statistics on user-specified data.
        """

        # Defining column values of interest
        mode_list = [4, 6, 6]
        mt_mode_list = ['micro_walkMode', 'micro_trnAcc', 'micro_trnEgr']
        mode_name_list = ["Walk", "Walk to Transit(Acc)", "Walk to Transit(Egr)"]

        if visitor:
            trips = self.raw_visitor
        else:
            trips = self.raw_individual

        data = []
        for i in range(len(mode_list)):

            # Calculate total trips
            total_trips = trips.shape[0]

            # Filter trips to the mode of interest
            mode_df = trips[trips["tripMode"] == mode_list[i]]

            # Calculate statistics for micro mobility choice
            micro_choice = mode_df.groupby(mt_mode_list[i]).count().iloc[:, 0].to_dict()
            micro_sum = sum(micro_choice.values())

            # Calculate proportion of trips that are micro transit
            # and proportion of walk trips that are micro transit
            if pd.isnull(micro_choice.get(3)):
                prop_micro, prop_micro_walk = 0, 0
            else:
                prop_micro = micro_choice.get(3) / total_trips
                prop_micro_walk = micro_choice.get(3) / micro_sum

            statistics = [mode_name_list[i], micro_choice.get(0), micro_choice.get(1),
                          micro_choice.get(2), micro_choice.get(3), micro_sum, prop_micro_walk, total_trips, prop_micro]

            data.append(statistics)

        # Constructing data frame
        cols = ['mode', 'Non Walk', 'Walk', 'Micro-Mobility', 'Micro-Transit', 
                'Total Walk', 'MT / Total Walk','Total Trips', 'MT / Total Trips']
        result = pd.DataFrame(columns=cols, data=data).fillna(0).set_index('mode')

        return result

    @property
    @lru_cache(maxsize=1)
    def person_data(self):
        """ Read the Person Data output file from the ABM scenario output
        folder. The person data is read from the
        output/personData_<<iteration>>.csv file.

        The person data is returned as a Pandas.DataFrame with the field
        [person_id] defining a unique person record within the data-set.

        Telework status is from personData [tele_choice]
        The model trip data [PersonID] is joined with [person_id] in personData
        In previous versions, the file wslocresults [WorkLocation] is used to
        get the work from home status for telechoice -1 and work location 99999

        :rtype :class: `pandas.DataFrame`
        :returns: Person Data
        """

        start_time = time.time()

        # load the person data
        persons = pd.read_csv(self.scenario_path + "/output/personData_" + str(self.iteration) + ".csv",
                              usecols=["person_id", "tele_choice", "hh_id", "person_num"])

        end_time = time.time()

        # Time taken in seconds
        time_taken = end_time - start_time
        print("read persons data: ", str(datetime.timedelta(seconds=round(time_taken))))

        conditions = [(persons["tele_choice"] == -1),
                      (persons["tele_choice"] == 0),
                      (persons["tele_choice"] == 1),
                      (persons["tele_choice"] == 2),
                      (persons["tele_choice"] == 3),
                      (persons["tele_choice"] == 9)]

        choices = ["Not a Worker",
                   "No Telecommute",
                   "1 day a week",
                   "2-3 days a week",
                   "4+ days a week",
                   "Work from Home"]

        persons["telestatus"] = np.select(conditions, choices, default=persons["tele_choice"])

        # use work location file if no "Work from Home"
        if ~persons['telestatus'].isin(["Work from Home"]).any():
            start_time = time.time()

            work_location = pd.read_csv(self.scenario_path + "/output/wslocResults_" + str(self.iteration) + ".csv",
                                        usecols=["PersonID", "WorkLocation"])

            end_time = time.time()
            time_taken = end_time - start_time
            print("read work location data: ", str(datetime.timedelta(seconds=round(time_taken))))

            persons = persons.merge(work_location, left_on="person_id", right_on="PersonID")

            conditions = [(persons["tele_choice"] == -1) & (persons["WorkLocation"] == 99999),
                          (persons["tele_choice"] == -1) & (persons["WorkLocation"] != 99999)]

            choicesneg1 = ["Work from Home", "Not a Worker"]

            persons["telestatus"] = np.select(conditions, choicesneg1, default=persons["telestatus"])

        # validate values
        persons['valid'] = persons['telestatus'].isin(choices)

        if ~persons['valid'].all():
            msg = ("Invalid tele choice. must be one of:", choices)
            raise ValueError(msg)

        # return fields of interest
        return persons[["person_id",
                        "tele_choice",
                        "hh_id",
                        "person_num",
                        "telestatus"]]

    @property
    @lru_cache(maxsize=1)
    def tour_data(self):
        """ Read the tour data output file from the ABM scenario output
        folder. The tour data is read from the
        output/jointTourData_<<iteration>>.csv file.

        The tour data is returned as a Pandas.DataFrame with the field
        ([hh_id], [tour_id]) defining a unique tour record within the data-set.
        [tour_participants] contains the person numbers within the household of the
        persons on the tour (and on all the trips in the tour) separated by spaces

        :rtpye :class: `pandas.DataFrame`
        :returns: Tour Data
        """

        start_time = time.time()

        # load tour list into Pandas DataFrame
        tours = pd.read_csv(self.scenario_path + "/output/jointTourData_" + str(self.iteration) + ".csv",
                            usecols=["hh_id", "tour_id", "tour_participants"])

        end_time = time.time()
        time_taken = end_time - start_time
        print("read tour data: ", str(datetime.timedelta(seconds=round(time_taken))))

        # return fields of interest
        return tours[["hh_id",
                      "tour_id",
                      "tour_participants"]]

    @property
    @lru_cache(maxsize=1)
    def tour_to_personid(self):
        """ Person id from tour data using person number and hh_id
        by splitting tour participants to get person numbers.
        Map back to the output/personData_<<iteration>>.csv file where
        the columns to map to are ([hhid], [pnum])
        person id is a unique surrogate key identifying persons

        The tour data is returned as a Pandas.DataFrame with the field
        [PERSON_ID] defining a unique person record within the data-set.

        :rtpye :class: `pandas.DataFrame`
        :returns: Work Location Data
        """

        # split the tour participants column by " " and append in wide-format
        # to each record

        start_time = time.time()

        participants = pd.concat(
            [self.tour_data[["hh_id", "tour_id"]],
             self.tour_data["tour_participants"].str.split(" ", expand=True)],
            axis=1
        )

        # melt the wide-format tour participants to long-format
        tourpersons = pd.melt(participants, id_vars=["hh_id", "tour_id"],
                              value_name="person_num")

        tourpersons = tourpersons[tourpersons["person_num"].notnull()]
        tourpersons["person_num"] = tourpersons["person_num"].astype("int64")

        tourpersons = tourpersons.merge(self.person_data, on=["hh_id", "person_num"])
        tourpersons.rename(columns={"hh_id": "HH_ID", "tour_id": "TOUR_ID"}, inplace=True)

        end_time = time.time()
        time_taken = end_time - start_time
        print("tour data to person id: ", str(datetime.timedelta(seconds=round(time_taken))))

        # return fields of interest
        return tourpersons

    @property
    @lru_cache(maxsize=1)
    def airport_cbx(self) -> pd.DataFrame:
        """ Read the Cross Border Express (CBX) Airport Model trip list from
        the ABM scenario report folder. The trip list is read from the
        report/airportCBXTrips.csv file.
        """
        # load the report folder airport trips CBX trip list
        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "airportCBXTrips.csv"),
            usecols=["tripID",  # unique trip id
                     "tripMode",  # trip mode
                     "weightTrip",  # trip weight
                     "weightPersonTrip",  # person trip weight
                     "timeTotal",  # total trip time
                     "distanceTotal",  # total trip distance
                     "costTotal",  # total trip cost
                     "tripPurpose"])  # trip purpose

        trips["purpose"] = trips["tripPurpose"]

        # return fields of interest
        return trips[["tripID",
                      "tripMode",
                      "weightTrip",
                      "weightPersonTrip",
                      "timeTotal",
                      "distanceTotal",
                      "costTotal",
                      "purpose"]]

    @property
    @lru_cache(maxsize=1)
    def airport_san(self) -> pd.DataFrame:
        """ Read the San Diego (SAN) Airport Model trip list from
        the ABM scenario report folder. The trip list is read from the
        report/airportSANTrips.csv file.
        """
        # load the report folder airport trips SAN trip list
        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "airportSANTrips.csv"),
            usecols=["tripID",  # unique trip id
                     "tripMode",  # trip mode
                     "weightTrip",  # trip weight
                     "weightPersonTrip",  # person trip weight
                     "timeTotal",  # total trip time
                     "distanceTotal",  # total trip distance
                     "costTotal",  # total trip cost
                     "tripPurpose"])  # trip purpose

        trips["purpose"] = trips["tripPurpose"]

        # return fields of interest
        return trips[["tripID",
                      "tripMode",
                      "weightTrip",
                      "weightPersonTrip",
                      "timeTotal",
                      "distanceTotal",
                      "costTotal",
                      "purpose"]]

    @property
    @lru_cache(maxsize=1)
    def household_av(self):
        """ Read the household autonomous vehicle (AV) trip list from the
        ABM scenario output folder. The trip list is read from the
        output/householdAVTrips.csv file. Note this trip list contains trips
        already written to the individual and joint models excepting
        0-passenger trips.

        It is also required to read in the mgra-based input file from the ABM
        scenario input folder as well as the distance and time skims from the
        ABM scenario output folder to append time and distance to the records
        (for simplicity all trips are assumed to use the  AM Peak Period HOV-2
        low value of time skim set).

        The trip list is returned as a Pandas.DataFrame with the 3-tuple
        ([hh_id], [veh_id], [vehicleTrip_id]) defining a unique record within
        the data-set.

        If the scenario does not contain a household av trip list return a
        boolean false.

        :rtpye :class: `pandas.DataFrame`
        :returns: Household AV trip list
        """

        if os.path.isfile(self.scenario_path + "/output/householdAVTrips.csv"):

            # load the output folder household av trip list
            trips = pd.read_csv(self.scenario_path + "/output/householdAVTrips.csv",
                                usecols=["hh_id",  # unique household surrogate key
                                         "veh_id",  # unique AV-vehicle surrogate key within household
                                         "vehicleTrip_id",  # unique trip surrogate key within ([hh_id], [veh_id])
                                         "orig_mgra",  # trip origin MGRA
                                         "dest_gra",  # trip destination MGRA
                                         "occupants"])  # occupants in vehicle (0-8)

            # read in mgra-based input file to get mgra-taz lookup
            mgra_input = pd.read_csv(self.scenario_path + "/input/mgra13_based_input" + str(self.year) + ".csv",
                                     usecols=["mgra",  # MGRA geography number
                                              "taz"])  # TAZ geography number

            # merge in TAZ origin and destination
            trips = trips.merge(mgra_input,
                                left_on="orig_mgra",
                                right_on="mgra")

            trips = trips.merge(mgra_input,
                                left_on="dest_gra",
                                right_on="mgra",
                                suffixes=("_orig", "_dest"))

            # append distance and time skims
            # using am peak period hov-2 low value of time
            am_skims = om.open_file(self.scenario_path + "/output/traffic_skims_AM.omx")

            trips["distanceTotal"] = [
                am_skims["AM_HOV2_L_DIST"][o - 1, d - 1]
                for o, d in zip(trips["taz_orig"], trips["taz_dest"])
            ]

            trips["timeTotal"] = [
                am_skims["AM_HOV2_L_TIME"][o - 1, d - 1]
                for o, d in zip(trips["taz_orig"], trips["taz_dest"])
            ]

            am_skims.close()

            # create person and trip-based weights based on occupancy
            trips["passengers"] = trips["occupants"]
            trips["weightPersonTrip"] = trips["occupants"] * 1 / self.sample_rate
            trips["weightTrip"] = 1 * 1 / self.sample_rate

            return trips[["hh_id",
                          "veh_id",
                          "vehicleTrip_id",
                          "passengers",
                          "distanceTotal",
                          "timeTotal",
                          "weightPersonTrip",
                          "weightTrip"]]

        else:
            return False

    @property
    @lru_cache(maxsize=1)
    def cross_border(self) -> pd.DataFrame:
        """ Read the Cross Border Model trip list from the ABM scenario report
        folder. The trip list is read from the report/crossBorderTrips.csv
        file.
        """
        # load the report folder cross border trip list
        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "crossBorderTrips.csv"),
            usecols=["tripID",  # unique trip id
                     "tripMode",  # trip mode
                     "weightTrip",  # trip weight
                     "weightPersonTrip",  # person trip weight
                     "timeTotal",  # total trip time
                     "distanceTotal",  # total trip distance
                     "costTotal",  # total trip cost
                     "tripPurposeDestination"])  # trip purpose

        trips["purpose"] = trips["tripPurposeDestination"]

        # return fields of interest
        return trips[["tripID",
                      "tripMode",
                      "weightTrip",
                      "weightPersonTrip",
                      "timeTotal",
                      "distanceTotal",
                      "costTotal",
                      "purpose"]]

    @property
    @lru_cache(maxsize=1)
    def commercial_vehicle(self) -> pd.DataFrame:
        """ Read the Commercial Vehicle Model trip list from the ABM scenario
        report folder. The trip list is read from the
        report/commercialVehicleTrips.csv file.
        """
        # load the report folder commercial vehicle trips trip list
        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "commercialVehicleTrips.csv"),
            usecols=["tripID",  # unique trip id
                     "tripMode",  # trip mode
                     "weightTrip",  # trip weight
                     "weightPersonTrip",  # person trip weight
                     "timeTotal",  # total trip time
                     "distanceTotal",  # total trip distance
                     "costTotal",  # total trip cost
                     "tripPurposeDestination"])  # trip purpose

        trips['purpose'] = trips["tripPurposeDestination"]

        # return fields of interest
        return trips[["tripID",
                      "tripMode",
                      "weightTrip",
                      "weightPersonTrip",
                      "timeTotal",
                      "distanceTotal",
                      "costTotal",
                      "purpose"]]

    @property
    @lru_cache(maxsize=1)
    def external_external(self) -> pd.DataFrame:
        """ Read the External-External Model trip list from the ABM scenario
        report folder. The trip list is read from the
        report/externalExternalTrips.csv file.
        """
        # load the report folder external-external trips trip list
        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "externalExternalTrips.csv"),
            usecols=["tripID",  # unique trip id
                     "tripMode",  # trip mode
                     "weightTrip",  # trip weight
                     "weightPersonTrip",  # person trip weight
                     "timeTotal",  # total trip time
                     "distanceTotal",  # total trip distance
                     "costTotal"])  # total trip cost

        # add Not Applicable trip purpose as model has no trip purposes
        trips["purpose"] = "Not Applicable"

        # return fields of interest
        return trips[["tripID",
                      "tripMode",
                      "weightTrip",
                      "weightPersonTrip",
                      "timeTotal",
                      "distanceTotal",
                      "costTotal",
                      "purpose"]]

    @property
    @lru_cache(maxsize=1)
    def external_internal(self) -> pd.DataFrame:
        """ Read the External-Internal Model trip list from the ABM scenario
        report folder. The trip list is read from the
        report/ExternalInternal.csv file.
        """
        # load the report folder external-internal trips trip list
        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "externalInternalTrips.csv"),
            usecols=["tripID",  # unique trip id
                     "tripMode",  # trip mode
                     "weightTrip",  # trip weight
                     "weightPersonTrip",  # person trip weight
                     "timeTotal",  # total trip time
                     "distanceTotal",  # total trip distance
                     "costTotal",  # total trip cost
                     "tripPurpose"]) # trip purpose

        trips["purpose"] = trips["tripPurpose"]

        # return fields of interest
        return trips[["tripID",
                      "tripMode",
                      "weightTrip",
                      "weightPersonTrip",
                      "timeTotal",
                      "distanceTotal",
                      "costTotal",
                      "purpose"]]

    @property
    @lru_cache(maxsize=1)
    def internal_external(self) -> pd.DataFrame:
        """ Read the Internal-External Model trip list from the ABM scenario
        report folder. The trip list is read from the
        report/internalExternalTrips.csv file.
        """
        # load the report folder internal-external trips trip list
        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "internalExternalTrips.csv"),
            usecols=["personID",   # person id
                     "tripID",  # unique trip id
                     "tripMode",  # trip mode
                     "weightTrip",  # trip weight
                     "weightPersonTrip",  # person trip weight
                     "timeTotal",  # total trip time
                     "distanceDrive",  # driven distance
                     "distanceDriveTransit",  # driven distance to transit
                     "distanceTotal",  # total trip distance
                     "costTotal",  # total trip cost
                     "inbound",   # direction of trip
                     "departTimeFiveTod"])  # abm five time of day

        # change inbound from true/false to 1/0 to match other trip files
        trips["inbound"] = trips["inbound"].astype(int)

        # add Not Applicable trip purpose as model has no trip purposes
        # trips["tripPurposeDestination"] = "Not Applicable"
        trips["purpose"] = "Not Applicable"

        # create trip vmt
        trips["vmt"] = (trips["distanceDrive"].fillna(0) +
                        trips["distanceDriveTransit"].fillna(0))

        # telecommute status
        trips = trips.merge(self.person_data, left_on="personID", right_on="person_id")

        # return fields of interest
        return trips[["personID",
                      "tripID",
                      "tripMode",
                      "weightTrip",
                      "weightPersonTrip",
                      "timeTotal",
                      "distanceTotal",
                      "costTotal",
                      "departTimeFiveTod",
                      "purpose",
                      "telestatus",
                      "vmt"]]

    @property
    @lru_cache(maxsize=1)
    def raw_individual(self) -> pd.DataFrame:
        """ Read the raw Individual Model trip list from the ABM scenario output
        folder. The trip list is read from the output/indivTripData_[iteration].csv
        file.
        """

        # raw individual file name
        file_name = "indivTripData_" + str(self.iteration) + ".csv"

        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "output",
                         file_name),
            usecols=["trip_mode",  # trip mode
                     "micro_walkMode",  # micro-mobility choice on walk mode
                     "micro_trnAcc",  # micro-mobility choice on transit access mode
                     "micro_trnEgr"])  # micro-mobility choice on transit egress mode

        trips = trips.rename({"trip_mode": "tripMode"}, axis=1)

        return trips

    @property
    @lru_cache(maxsize=1)
    def individual(self) -> pd.DataFrame:
        """ Read the Individual Model trip list from the ABM scenario report
        folder. The trip list is read from the report/individualTrips.csv
        file.
        """
        # load the report folder individual trips trip list
        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "individualTrips.csv"),
            usecols=["personID",  # person id
                     "tripID",  # unique trip id
                     "tripMode",  # trip mode
                     "weightTrip",  # trip weight
                     "weightPersonTrip",  # person trip weight
                     "timeTotal",  # total trip time
                     "distanceDrive",   # driven distance
                     "distanceDriveTransit",   # driven distance to transit
                     "distanceTotal",  # total trip distance
                     "costTotal",   # total trip cost
                     "departTimeFiveTod",  # abm five time of day
                     "tripPurposeDestination"])  # trip purpose

        # create trip vmt
        trips["vmt"] = (trips["distanceDrive"].fillna(0) +
                        trips["distanceDriveTransit"].fillna(0))

        trips["purpose"] = trips["tripPurposeDestination"]

        # telecommute status
        trips = trips.merge(self.person_data, left_on="personID", right_on="person_id")

        # return fields of interest
        return trips[["personID",
                      "tripID",
                      "tripMode",
                      "weightTrip",
                      "weightPersonTrip",
                      "timeTotal",
                      "distanceTotal",
                      "costTotal",
                      "departTimeFiveTod",
                      "tripPurposeDestination",
                      "telestatus",
                      "purpose",
                      "vmt"]]

    @property
    @lru_cache(maxsize=1)
    def joint(self) -> pd.DataFrame:
        """ Read the Joint Model trip list from the ABM scenario report
        folder. The trip list is read from the report/jointTrips.csv file.
        """
        # load the report folder joint trips trip list
        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "jointTrips.csv"),
            usecols=["personID",   # person id
                     "tripID",  # unique trip id
                     "tripMode",  # trip mode
                     "weightTrip",  # trip weight
                     "weightPersonTrip",  # person trip weight
                     "timeTotal",  # total trip time
                     "distanceDrive",  # driven distance
                     "distanceDriveTransit",  # driven distance to transit
                     "distanceTotal",  # total trip distance
                     "costTotal",  # total trip cost
                     "departTimeFiveTod",  # abm five time of day
                     "tripPurposeDestination"])   # trip purpose

        # create trip vmt
        trips["vmt"] = (trips["distanceDrive"].fillna(0) +
                        trips["distanceDriveTransit"].fillna(0))

        trips["purpose"] = trips["tripPurposeDestination"]

        # telecommute status
        # MODIFIED - did not merge on tele_choice or telestatus
        trips = trips.merge(self.person_data, left_on="personID", right_on="person_id")

        # return fields of interest
        return trips[["personID",
                      "tripID",
                      "tripMode",
                      "weightTrip",
                      "weightPersonTrip",
                      "timeTotal",
                      "distanceTotal",
                      "costTotal",
                      "departTimeFiveTod",
                      "purpose",
                      "telestatus",
                      "vmt"]]

    @property
    @lru_cache(maxsize=1)
    def tnc(self):
        """ Read the TNC vehicle (AV) trip list from the
        ABM scenario output folder. The trip list is read from the
        output/TNCTrips.csv file. Note this trip list contains trips
        already written to the airport, individual, joint, and visitor
        models excepting 0-passenger trips.

        It is also required to read in the distance and time skims from the
        ABM scenario output folder to append time and distance to the records
        (for simplicity all trips are assumed to use the AM Peak Period HOV-2
        low value of time skim set).

        The trip list is returned as a Pandas.DataFrame with [trip_ID]
        defining a unique record within the data-set.

        If the scenario does not contain a tnc trip list return a
        boolean false.

        :rtpye :class: `pandas.DataFrame`
        :returns: TNC trip list
        """

        if os.path.isfile(self.scenario_path + "/output/TNCTrips.csv"):

            # load the output folder tnc trip list
            trips = pd.read_csv(self.scenario_path + "/output/TNCTrips.csv",
                                usecols=["trip_ID",  # unique trip surrogate key
                                         "originTaz",  # trip origin TAZ
                                         "destinationTaz",  # trip destination TAZ
                                         "totalPassengers"])  # passengers in vehicle excluding driver (0-6)

            # append distance and time skims
            # using am peak period hov-2 low value of time
            am_skims = om.open_file(self.scenario_path + "/output/traffic_skims_AM.omx")

            trips["distanceTotal"] = [
                am_skims["AM_HOV2_L_DIST"][o - 1, d - 1]
                for o, d in zip(trips["originTaz"], trips["destinationTaz"])
            ]

            trips["timeTotal"] = [
                am_skims["AM_HOV2_L_TIME"][o - 1, d - 1]
                for o, d in zip(trips["originTaz"], trips["destinationTaz"])
            ]

            am_skims.close()

            # create person and trip-based weights based on occupancy
            trips["passengers"] = trips["totalPassengers"]
            trips["weightPersonTrip"] = (trips["totalPassengers"] + 1) * 1 / self.sample_rate
            trips["weightTrip"] = 1 * 1 / self.sample_rate

            return trips[["trip_ID",
                          "passengers",
                          "distanceTotal",
                          "timeTotal",
                          "weightPersonTrip",
                          "weightTrip"]]

        else:
            return False

    @property
    @lru_cache(maxsize=1)
    def truck(self) -> pd.DataFrame:
        """ Read the Truck Model trip list from the ABM scenario
        report folder. The trip list is read from the report/truckTrips.csv
        file.
        """
        # load the report folder truck trips trip list
        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "truckTrips.csv"),
            usecols=["tripID",  # unique trip id
                     "tripMode",  # trip mode
                     "weightTrip",  # trip weight
                     "weightPersonTrip",  # person trip weight
                     "timeTotal",  # total trip time
                     "distanceTotal",  # total trip distance
                     "costTotal"])  # total trip cost

        # add Not Applicable trip purpose as model has no trip purposes
        trips["purpose"] = "Not Applicable"

        # return fields of interest
        return trips[["tripID",
                      "tripMode",
                      "weightTrip",
                      "weightPersonTrip",
                      "timeTotal",
                      "distanceTotal",
                      "costTotal",
                      "purpose"]]

    @property
    @lru_cache(maxsize=1)
    def raw_visitor(self) -> pd.DataFrame:
        """ Read the raw Visitor Model trip list from the ABM scenario output
        folder. The trip list is read from the output/visitorTrips.csv file.
        """

        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "output",
                         "visitorTrips.csv"),
            usecols=["tripMode",  # trip mode
                     "micro_walkMode",  # micro-mobility choice on walk mode
                     "micro_trnAcc",  # micro-mobility choice on transit access mode
                     "micro_trnEgr"])  # micro-mobility choice on transit egress mode

        return trips

    @property
    @lru_cache(maxsize=1)
    def visitor(self) -> pd.DataFrame:
        """ Read the Visitor Model trip list from the ABM scenario report
        folder. The trip list is read from the report/visitorTrips.csv file.
        """
        # load the report folder visitor trips trip list
        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "visitorTrips.csv"),
            usecols=["tripID",  # unique trip id
                     "tripMode",  # trip mode
                     "weightTrip",  # trip weight
                     "weightPersonTrip",  # person trip weight
                     "timeTotal",  # total trip time
                     "distanceTotal",  # total trip distance
                     "costTotal",  # total trip cost
                     "tripPurposeDestination"])  # trip purpose

        trips["purpose"] = trips["tripPurposeDestination"]

        # return fields of interest
        return trips[["tripID",
                      "tripMode",
                      "weightTrip",
                      "weightPersonTrip",
                      "timeTotal",
                      "distanceTotal",
                      "costTotal",
                      "purpose"]]

    @property
    @lru_cache(maxsize=1)
    def zombie_av(self) -> pd.DataFrame:
        """ Read the Zombie AV trip list from the ABM scenario report
        folder. The trip list is read from the report/zombieAVTrips.csv file.
        """
        # load the report folder zombie AV trips trip list
        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "zombieAVTrips.csv"),
            usecols=["tripID",  # unique trip id
                     "tripMode",  # trip mode
                     "weightTrip",  # trip weight
                     "weightPersonTrip",  # person trip weight
                     "timeTotal",  # total trip time
                     "distanceTotal",  # total trip distance
                     "costTotal"])  # total trip cost

        # return fields of interest
        return trips[["tripID",
                      "tripMode",
                      "weightTrip",
                      "weightPersonTrip",
                      "timeTotal",
                      "distanceTotal",
                      "costTotal"]]

    @property
    @lru_cache(maxsize=1)
    def zombie_tnc(self) -> pd.DataFrame:
        """ Read the Zombie TNC trip list from the ABM scenario report
        folder. The trip list is read from the report/zombieTNCTrips.csv file.
        """
        # load the report folder zombie TNC trips trip list
        trips = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "zombieTNCTrips.csv"),
            usecols=["tripID",  # unique trip id
                     "tripMode",  # trip mode
                     "weightTrip",  # trip weight
                     "weightPersonTrip",  # person trip weight
                     "timeTotal",  # total trip time
                     "distanceTotal",  # total trip distance
                     "costTotal"])  # total trip cost

        # return fields of interest
        return trips[["tripID",
                      "tripMode",
                      "weightTrip",
                      "weightPersonTrip",
                      "timeTotal",
                      "distanceTotal",
                      "costTotal"]]
