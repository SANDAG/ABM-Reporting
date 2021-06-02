# -*- coding: utf-8 -*-
""" Access Measure Module

This module contains class holding all information and utilities relating to
the CMCP 2021 Access Measures. These measures mirror the  Regional Plan Main
Performance Measures M1-(a-c) and M5-(a-c).

Notes:
    docstring style guide - http://google.github.io/styleguide/pyguide.html
"""

import csv
from functools import lru_cache  # caching decorator for modules
import pandas as pd
import pyodbc
import sqlalchemy


class AccessMeasures(object):
    """ This is the parent class for all information and utilities relating to
    CMCP 2021 Access Measures.

    Args:
        scenario_id: Integer scenario id of the loaded ABM scenario in the ABM
            database table [dimension].[scenario]
        conn: SQL Alchemy connection engine (see sqlalchemy.engine.Engine)

    Methods:
        calc_transit_access: Calculate percentage of eligible population
            with access to any one destination of interest within maximum
            allowed travel time by transit access mode speed one (mm/mt/walk)
        filter_destinations: Filter destination list based on input
            destination(s) of interest at specified geography
        populations: Get master list of MGRAs with populations of interest fields

    Properties:
        destinations: Master list of MGRAs with destination(s) interest fields
        scenario_path: UNC file path to loaded ABM scenario folder
    """

    def __init__(self, scenario_id: int, conn: sqlalchemy.engine.Engine) -> None:
        self.scenario_id = scenario_id
        self.conn = conn

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
                otherCollegeEnrollment - total other college enrollment
        """
        with self.conn.connect() as conn:
            destinations = pd.read_sql(
                sql="SELECT * FROM [cmcp_2021].[fn_destinations] (" +
                    str(self.scenario_id) + ")",
                con=conn)

        return destinations[["mgra",
                             "taz",
                             "employmentCenterTier",
                             "empHealth",
                             "parkActive",
                             "empRetail",
                             "higherLearningEnrollment",
                             "otherCollegeEnrollment"]]

    @lru_cache(maxsize=1)
    def populations(self, cmcp_name: str, age_18_plus: int) -> pd.DataFrame:
        """ Get master list of MGRAs with population(s) of interest fields.

        Args:
            cmcp_name: String to filter origin MGRAs within specified CMCP
                name, specify Region for entire Region
            age_18_plus: 1/0 Integer to limit population to aged 18+

        Returns:
            Pandas DataFrame of MGRAs with fields describing populations
            of interest.
                mgra - Master Geographic Reference Area geography number
                taz - Transportation Access Zone geography number
                pop - Total population
                popSenior - 75+ population
                popNonSenior - Under 75 population
                popMinority - Non-White or Hispanic population
                popNonMinority - White Non-Hispanic population
                popLowIncome - Low Income population
                popNonLowIncome - Non-Low Income population """
        with self.conn.connect() as conn:
            if cmcp_name == 'Region':
                pop = pd.read_sql(
                    sql="SELECT DISTINCT * FROM [cmcp_2021].[fn_person_coc] (" +
                    str(self.scenario_id) + "," + str(age_18_plus) +
                    ") OPTION(MAXDOP 1)",
                    con=conn)
            else:
                pop = pd.read_sql(
                    sql="SELECT * FROM [cmcp_2021].[fn_person_coc] (" +
                        str(self.scenario_id) + "," + str(age_18_plus) +
                        ") WHERE [cmcp_name] = '" + cmcp_name +
                        "' OPTION(MAXDOP 1)",
                    con=conn)

        return pop[["mgra",
                    "taz",
                    "pop",
                    "popSenior",
                    "popNonSenior",
                    "popMinority",
                    "popNonMinority",
                    "popLowIncome",
                    "popNonLowIncome"]]

    @property
    @lru_cache(maxsize=1)
    def scenario_path(self) -> str:
        """ Get UNC file path of loaded ABM scenario folder """
        with self.conn.connect() as conn:
            path = pd.read_sql(
                sql="SELECT RTRIM([path]) AS [path] FROM [dimension].[scenario] WHERE [scenario_id] =  " +
                    str(self.scenario_id),
                con=conn)

        return path.iloc[0]["path"]

    def calc_transit_access(self, criteria: str, max_time: int,
                            cmcp_name: str, age_18_plus: int) -> pd.Series:
        """ Calculates the percentage of the population with access to any one
         destination via transit using walk to transit access. Access is
         calculated for the overall population and within the
         Low Income/Non-Low Income, Minority/Non-Minority and Seniors/Non-Senior
         populations.

         Args:
             criteria: String indicating filter of interest to apply to the
                destinations used in the filter_destinations() method. Must
                be a valid string passed to Pandas.query.
            max_time: Integer indicating the maximum skim time in minutes
                allowed for an origin-destination pair to be considered
                accessible. The maximum time defined must be in the set
                {30, 45} as the ABM2 transit access files are only created
                for either of these two maximum time values.
            cmcp_name: String to filter origin MGRAs within
                specified CMCP name, if not specified then the entire Region
                is used.
            age_18_plus: 1/0 Integer to limit population to aged 18+.

        Returns:
            Pandas.Series of the percentage of the population with access """

        # select population based on input parameters
        pop = self.populations(cmcp_name=cmcp_name, age_18_plus=age_18_plus)

        # initialize indicator of accessibility
        pop["access"] = 0

        # select MGRA destinations based on input filtering criteria
        d = self.filter_destinations("mgra", criteria)

        # load the MGRA-MGRA transit access skims
        # based on input maximum skim time parameter
        if max_time == 30:
            skim_path = self.scenario_path + "/output/walkMgrasWithin30Min_AM.csv"
        elif max_time == 45:
            skim_path = self.scenario_path + "/output/walkMgrasWithin45Min_AM.csv"
        else:
            raise ValueError("Invalid parameter: max_time must be in {30, 45}")

        # go through each record in the skim csv file
        # where the file is formatted as:
        # origin MGRA, [all available destination MGRAs]
        # if available destination MGRAs are in the selected MGRA destinations
        # based on input filtering criteria then save the origin MGRA
        accessible_origins = []
        with open(skim_path) as skim_file:
            skim_reader = csv.reader(skim_file)
            for row in skim_reader:
                accessible_destinations = list(map(int, row[1:]))
                if any(d.isin(accessible_destinations)):
                    accessible_origins.append(int(row[0]))

        # if population MGRA present in the saved origin MGRAs
        # then set access column to 1
        pop.loc[pop["mgra"].isin(accessible_origins), "access"] = 1

        # calculate percentage of population with accessibility
        metric = pop[pop["access"] == 1].sum().divide(pop.sum())

        metric.rename(index={"pop": "Population Access Pct",
                             "popSenior": "Senior Access Pct",
                             "popNonSenior": "Non-Senior Access Pct",
                             "popMinority": "Minority Access Pct",
                             "popNonMinority": "Non-Minority Access Pct",
                             "popLowIncome": "Low Income Access Pct",
                             "popNonLowIncome": "Non-Low Income Access Pct"},
                      inplace=True)

        metric = metric[["Population Access Pct",
                         "Low Income Access Pct",
                         "Non-Low Income Access Pct",
                         "Minority Access Pct",
                         "Non-Minority Access Pct",
                         "Senior Access Pct",
                         "Non-Senior Access Pct"]]

        return metric

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
