# -*- coding: utf-8 -*-
""" RP-2021 Performance Measures M1 and M5 Module.

This module contains class holding all information and utilities relating to
2021 Regional Plan Main Performance Measures M1-(a-c) and M5-(a-c).
Additionally, this class is used to calculate the 2021 Regional Plan Social
Equity Performance Measures SE-M1-(a-c) and SE-M5-(a-d)

Notes:
    docstring style guide - http://google.github.io/styleguide/pyguide.html
"""

from functools import lru_cache  # caching decorator for modules
import openmatrix as omx
import os
import pandas as pd
import pyodbc
import settings  # python project settings file


class PerformanceMeasuresM1M5(object):
    """ This is the parent class for all information and utilities relating to
    2021 Regional Plan Main Performance Measures M1-(a-c) and M5-(a-c).

    Args:
        scenario_id: Integer scenario id of the loaded ABM scenario in the ABM
            database table [dimension].[scenario]

    Methods:
        calc_bike_walk_access: Calculate percentage of eligible population with
            access to any one destination of interest within maximum allowed
            travel time by any combination of bicycle, walk, micro-mobility,
            and/or micro-transit modes
        calc_drive_access: Calculate percentage of eligible population with
            access to any one destination of interest within maximum allowed
            travel time by drive alone and carpool modes
        calc_transit_access: Calculate percentage of eligible population
            with access to any one destination of interest within maximum
            allowed travel time by transit access mode speed one (mm/mt/walk)
        filter_destinations: Filter destination list based on input
            destination(s) of interest at specified geography

    Properties:
        destinations: Master list of MGRAs with destination(s) interest fields
        populations: Master list of MGRAs with populations of interest fields
        populations_over18: Master list of MGRAs with over 18 populations of
            interest fields
        scenario_path: UNC file path to loaded ABM scenario folder
    """

    def __init__(self, scenario_id: int) -> None:
        self.scenario_id = scenario_id

    @property
    @lru_cache(maxsize=1)
    def destinations(self) -> pd.DataFrame:
        """ Get master list of MGRAs with destination(s) of interest fields.

        Returns:
            Pandas DataFrame of MGRAs with fields describing destinations of
            interest.
                mgra - Master Geographic Reference Area geography number
                taz - Transportation Access Zone geography number
                employmentCenterTier - Employment Center Tier (1-4) where
                    Tier 0 means no Employment Center
                empHealth - number of health services employees
                parkActive - park acres
                empRetail - number of retail activity employees
                higherLearningEnrollment - total university and other college
                    enrollment
        """
        with settings.engines["ABM-Reporting"].connect() as conn:
            dest = pd.read_sql(
                sql="EXECUTE [rp_2021].[sp_m1_m5_destinations]  " +
                    str(self.scenario_id),
                con=conn)

        return dest

    @property
    @lru_cache(maxsize=1)
    def populations(self) -> pd.DataFrame:
        """ Get master list of MGRAs with population(s) of interest fields.

         Returns:
             Pandas DataFrame of MGRAs with fields describing populations
             of interest.
                mgra - Master Geographic Reference Area geography number
                taz - Transportation Access Zone geography number
                mobilityHub - 1/0 indicator if mgra is in a Mobility Hub
                pop - Total population
                popSenior - 75+ population
                popNonSenior - Under 75 population
                popMinority - Non-White or Hispanic population
                popNonMinority - White Non-Hispanic population
                popLowIncome - Low Income population
                popNonLowIncome - Non-Low Income population"""
        with settings.engines["ABM-Reporting"].connect() as conn:
            pop = pd.read_sql(
                sql="EXECUTE [rp_2021].[sp_m1_m5_populations]  " +
                    str(self.scenario_id) + ",0",  # 18 plus switch turned off
                con=conn)

        # convert geography columns from string to numeric
        pop[["mgra", "taz"]] = pop[["mgra", "taz"]].apply(pd.to_numeric)

        return pop

    @property
    @lru_cache(maxsize=1)
    def populations_over18(self) -> pd.DataFrame:
        """ Get master list of MGRAs with 18+ population(s) of interest fields.

         Returns:
             Pandas of DataFrame of MGRAs with fields describing 18+
             populations of interest.
                mgra - Master Geographic Reference Area geography number
                taz - Transportation Access Zone geography number
                mobilityHub - 1/0 indicator if mgra is in a Mobility Hub
                pop - Total 18+ population
                popSenior - 75+ population
                popNonSenior - Under 75 18+ population
                popMinority - Non-White or Hispanic 18+ population
                popNonMinority - White Non-Hispanic 18+ population
                popLowIncome - Low Income 18+ population
                popNonLowIncome - Non-Low Income 18+ population"""
        with settings.engines["ABM-Reporting"].connect() as conn:
            pop_over18 = pd.read_sql(
                sql="EXECUTE [rp_2021].[sp_m1_m5_populations]  " +
                    str(self.scenario_id) + ",1",  # 18 plus switch turned on
                con=conn)

        # convert geography columns from string to numeric
        pop_over18[["mgra", "taz"]] = pop_over18[["mgra", "taz"]].apply(pd.to_numeric)

        return pop_over18

    @property
    @lru_cache(maxsize=1)
    def scenario_path(self) -> str:
        """ Get UNC file path of loaded ABM scenario folder """
        with settings.engines["ABM-Reporting"].connect() as conn:
            path = pd.read_sql(
                sql="SELECT[path] FROM [dimension].[scenario] WHERE [scenario_id] =  " +
                    str(self.scenario_id),
                con=conn)

        return path.iloc[0]["path"]

    def calc_bike_walk_access(self, criteria: str, max_time: int, over18: bool,
                              mobility_hub: bool, access_cols: list) -> pd.Series:
        """ Calculates the percentage of the population with access to any one
         destination via any combination of bicycle, walk, micro-mobility,
         and/or micro-transit modes. Access is calculated for the
         overall population and within the Low Income/Non-Low Income,
         Minority/Non-Minority and Seniors/Non-Senior populations.

         Args:
             criteria: String indicating filter of interest to apply to the
                destinations used in the filter_destinations() method. Must
                be a valid string passed to Pandas.query
            max_time: Integer indicating the maximum skim time in minutes
                allowed for an origin-destination pair to be considered
                accessible
            over18: Boolean indicating whether to use the total population or
                the population of 18+ year old persons only
            mobility_hub: Boolean indicating whether to restrict population
                to MGRAs within mobility hubs
            access_cols: List of String names of access columns in the
              to use in access time calculation (bikeTime, walkTime, mmTime,
              mtTime)

        Returns:
            Pandas.Series of the percentage of the population with access """

        # select population based on input over18 boolean
        if over18:
            pop = self.populations_over18
        else:
            pop = self.populations

        # filter population based on input mobility hub boolean
        if mobility_hub:
            pop = pop.loc[pop["mobilityHub"] == 1].copy()

        # initialize indicator of accessibility
        pop["access"] = 0

        # select MGRA and TAZ destinations based on input filtering criteria
        d_mgra = self.filter_destinations("mgra", criteria)
        d_taz = self.filter_destinations("taz", criteria)

        # load the MGRA-MGRA bicycle skims
        bike_mgra_skims = pd.read_csv(
            os.path.join(self.scenario_path, "output", "bikeMgraLogsum.csv"),
            usecols=["i",  # origin MGRA geography
                     "j",  # destination MGRA geography
                     "time"]  # time in minutes
        )

        bike_mgra_skims.rename(columns={"time": "bikeTime"}, inplace=True)

        # load the MGRA-MGRA walk skims
        walk_mgra_skims = pd.read_csv(
            os.path.join(self.scenario_path, "output", "microMgraEquivMinutes.csv"),
            usecols=["i",  # origin MGRA geography
                     "j",  # destination MGRA geography
                     "walkTime",  # time in minutes walk mode
                     "mmTime",  # time in minutes micro-mobility mode
                     "mtTime"]  # time in minutes micro-transit mode
        )

        # combine the bicycle and walk MGRA-MGRA skims
        # set na values of skims to 999
        mgra_skims = bike_mgra_skims.merge(walk_mgra_skims, on=["i", "j"], how="outer")
        mgra_skims.fillna(999, inplace=True)

        # calculate access time based on input list of access columns
        mgra_skims["accessTime"] = mgra_skims[access_cols].min(axis=1)

        # filter skims where time <= specified maximum
        # and destination is in MGRA destinations
        mgra_skims = mgra_skims[(mgra_skims["accessTime"] <= max_time) & mgra_skims["j"].isin(d_mgra)]

        # if population MGRA present in the filtered MGRA skim origins
        # then set access column to 1
        pop.loc[pop["mgra"].isin(mgra_skims["i"]), "access"] = 1

        # if bicycle skim in input list of access columns
        if "bikeTime" in access_cols:
            # load the TAZ-TAZ bicycle skims
            taz_skims = pd.read_csv(
                os.path.join(self.scenario_path, "output", "bikeTazLogsum.csv"),
                usecols=["i",  # origin TAZ geography
                         "j",  # destination TAZ geography
                         "time"]  # time in minutes
            )

            # filter skims where time <= specified maximum
            # and destination is in TAZ destinations
            taz_skims = taz_skims[(taz_skims["time"] <= max_time) & taz_skims["j"].isin(d_taz)]

            # if population TAZ still present in filtered TAZ skim origins
            # then set access column to 1
            pop.loc[pop["taz"].isin(taz_skims["i"]), "access"] = 1
        else:
            pass

        # calculate percentage of population with accessibility
        pct = pop[pop["access"] == 1].sum().divide(pop.sum())

        pct.rename(index={"pop": "Population Access Pct",
                          "popSenior": "Senior Access Pct",
                          "popNonSenior": "Non-Senior Access Pct",
                          "popMinority": "Minority Access Pct",
                          "popNonMinority": "Non-Minority Access Pct",
                          "popLowIncome": "Low Income Access Pct",
                          "popNonLowIncome": "Non-Low Income Access Pct"}, inplace=True)

        return pct[["Population Access Pct",
                    "Low Income Access Pct",
                    "Non-Low Income Access Pct",
                    "Minority Access Pct",
                    "Non-Minority Access Pct",
                    "Senior Access Pct",
                    "Non-Senior Access Pct"]]

    def calc_drive_access(self, criteria: str, max_time: int, over18: bool,
                          mobility_hub: bool, matrix: str) -> pd.Series:
        """ Calculates the percentage of the population with access to any one
            destination via the auto mode. Access is calculated for the
            overall population and within the Low Income/Non-Low Income,
            Minority/Non-Minority and Seniors/Non-Senior populations.

            Note access is defined at the TAZ-TAZ level for auto mode skims.
            The network vehicle class input determines which auto mode travel
            time skim is used to define accessibility. Additionally, the auto
            mode terminal time walk skims are added to the auto mode travel
            time skim to get door to door travel times.

            Args:
                criteria: String indicating filter of interest to apply to the
                    destinations used in the filter_destinations() method. Must
                    be a valid string passed to Pandas.query
                max_time: Integer indicating the maximum skim time in minutes
                    allowed for an origin-destination pair to be considered
                    accessible
                over18: Boolean indicating whether to use the total population or
                    the population of 18+ year old persons only
                mobility_hub: Boolean indicating whether to restrict population
                    to MGRAs within mobility hubs
                matrix: String name of the travel network vehicle class matrix
                    used to get the auto mode travel time skim defining access

            Returns:
                Pandas.Series of the percentage of the population with access """
        # select population based on input over18 boolean
        if over18:
            pop = self.populations_over18
        else:
            pop = self.populations

        # filter population based on input mobility hub boolean
        if mobility_hub:
            pop = pop.loc[pop["mobilityHub"] == 1].copy()

        # aggregate population to the taz level
        pop = pop.groupby("taz").sum()

        # initialize indicator of accessibility
        pop["access"] = 0

        # select TAZ destinations based on input filtering criteria
        d = self.filter_destinations("taz", criteria)

        # read in auto terminal time fixed width file
        terminal_times = pd.read_fwf(
            os.path.join(self.scenario_path, "input", "zone.term"),
            widths=[5, 7],
            names=["destinationTAZ",
                   "timeAutoTerminalWalk"],
            dtype={"destinationTAZ": "int16",
                   "timeAutoTerminalWalk": "float32"})

        # add records with 0s for TAZs with no terminal times
        # and return terminal times as numpy array ordered by TAZ
        terminal_times = terminal_times.merge(
            pd.DataFrame({"destinationTAZ": range(1, 4997)}),
            on="destinationTAZ",
            how="right")
        terminal_times["timeAutoTerminalWalk"] = terminal_times["timeAutoTerminalWalk"].fillna(0)
        terminal_times = terminal_times["timeAutoTerminalWalk"].to_numpy()

        # using the input network vehicle class matrix open the
        # appropriate auto mode omx file and travel time skim matrix
        omx_fn = "traffic_skims_" + matrix[:2] + ".omx"
        fn = os.path.join(self.scenario_path, "output", omx_fn)
        omx_file = omx.open_file(fn)
        omx_map = omx_file.mapping("zone_number")

        # for each origin loop through destinations
        # if any destination is accessible given input maximum time
        # then set origin as accessible to destinations
        for row in pop.itertuples():
            o_idx = [omx_map[number] for number in [row.Index]*len(d)]
            d_idx = [omx_map[number] for number in d]
            if any(t <= max_time for t in omx_file[matrix + "_TIME"][o_idx, d_idx] + terminal_times[d_idx]):
                pop.at[row.Index, "access"] = 1

        omx_file.close()

        # calculate percentage of population with accessibility
        pct = pop[pop["access"] == 1].sum().divide(pop.sum())

        pct.rename(index={"pop": "Population Access Pct",
                          "popSenior": "Senior Access Pct",
                          "popNonSenior": "Non-Senior Access Pct",
                          "popMinority": "Minority Access Pct",
                          "popNonMinority": "Non-Minority Access Pct",
                          "popLowIncome": "Low Income Access Pct",
                          "popNonLowIncome": "Non-Low Income Access Pct"}, inplace=True)

        return pct[["Population Access Pct",
                    "Low Income Access Pct",
                    "Non-Low Income Access Pct",
                    "Minority Access Pct",
                    "Non-Minority Access Pct",
                    "Senior Access Pct",
                    "Non-Senior Access Pct"]]

    def calc_transit_access(self, criteria: str, max_time: int, over18: bool,
                            mobility_hub: bool, tod: str) -> pd.Series:
        """ Calculates the percentage of the population with access to any one
         destination via transit using transit access speed one
         (walk/micro-mobility/micro-transit). Access is calculated for the
         overall population and within the Low Income/Non-Low Income,
         Minority/Non-Minority and Seniors/Non-Senior populations.

         Note if any of the MGRA-MGRA transit travel time skims are under the
         maximum time defined as accessible for the MGRA-MGRA zone pair then
         that zone is considered accessible.

         Args:
             criteria: String indicating filter of interest to apply to the
                destinations used in the filter_destinations() method. Must
                be a valid string passed to Pandas.query
            max_time: Integer indicating the maximum skim time in minutes
                allowed for an origin-destination pair to be considered
                accessible
            over18: Boolean indicating whether to use the total population or
                the population of 18+ year old persons only
            mobility_hub: Boolean indicating whether to restrict population
                    to MGRAs within mobility hubs
            tod: String name of ABM five time of day period used to get the
                transit travel time skim file defining access

        Returns:
            Pandas.Series of the percentage of the population with access """

        # select population based on input over18 boolean
        if over18:
            pop = self.populations_over18
        else:
            pop = self.populations

        # filter population based on input mobility hub boolean
        if mobility_hub:
            pop = pop.loc[pop["mobilityHub"] == 1].copy()

        # initialize indicator of accessibility
        pop["access"] = 0

        # select MGRA destinations based on input filtering criteria
        d = self.filter_destinations("mgra", criteria)

        # load the MGRA-MGRA transit access skims
        # based on input time of day parameter
        if tod == "AM":
            mgra_skims = pd.read_csv(
                os.path.join(self.scenario_path, "output", "walkMgrasWithin45Min_AM.csv"),
                names=["i", "j", "time"],  # header not created
                usecols=["i",  # origin MGRA geography
                         "j",  # destination MGRA geography
                         "time"])  # time in minutes
        elif tod == "MD":
            mgra_skims = pd.read_csv(
                os.path.join(self.scenario_path, "output", "walkMgrasWithin30Min_MD.csv"),
                names=["i", "j", "time"],  # header not created
                usecols=["i",  # origin MGRA geography
                         "j",  # destination MGRA geography
                         "time"])  # time in minutes
        else:
            raise ValueError("invalid parameter: tod must be in ('AM', 'MD')")
            return

        # filter skims where time <= specified maximum
        # and destination is in MGRA destinations
        mgra_skims = mgra_skims[(mgra_skims["time"] <= max_time) & mgra_skims["j"].isin(d)]

        # if population MGRA present in the filtered MGRA skim origins
        # then set access column to 1
        pop.loc[pop["mgra"].isin(mgra_skims["i"]), "access"] = 1

        # calculate percentage of population with accessibility
        pct = pop[pop["access"] == 1].sum().divide(pop.sum())

        pct.rename(index={"pop": "Population Access Pct",
                          "popSenior": "Senior Access Pct",
                          "popNonSenior": "Non-Senior Access Pct",
                          "popMinority": "Minority Access Pct",
                          "popNonMinority": "Non-Minority Access Pct",
                          "popLowIncome": "Low Income Access Pct",
                          "popNonLowIncome": "Non-Low Income Access Pct"}, inplace=True)

        return pct[["Population Access Pct",
                    "Low Income Access Pct",
                    "Non-Low Income Access Pct",
                    "Minority Access Pct",
                    "Non-Minority Access Pct",
                    "Senior Access Pct",
                    "Non-Senior Access Pct"]]

    def filter_destinations(self, geography: str, criteria: str) -> pd.Series:
        """ Filter master list of MGRAs with destination(s) of interest fields
        to specified destination(s) criteria aggregating to specified geography.

        Args:
            geography: String indicating geography of interest to aggregate to
                and return
            criteria: String indicating filter of interest to apply. Must be a
                valid string passed to Pandas.query

        Returns:
            Pandas Series of specified geography numbers fulfilling
            specified destination(s) criteria """

        # sum destination fields to specified geography
        destinations = self.destinations.groupby([geography]).sum()

        # apply criteria filter
        destinations.query(criteria, inplace=True)

        # return eligible geographies as Pandas Series
        return destinations.index.to_series()
