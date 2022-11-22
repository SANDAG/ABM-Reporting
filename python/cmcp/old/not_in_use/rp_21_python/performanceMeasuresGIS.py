# -*- coding: utf-8 -*-
""" RP-2021 Performance Measures provided by GIS Module.

This module contains class holding all information and utilities relating to
2021 Regional Plan Main Performance Measures provided by the GIS team.

Notes:
    docstring style guide - http://google.github.io/styleguide/pyguide.html
"""

import datetime
from functools import lru_cache  # caching decorator for modules
import os
import pandas as pd
import pyodbc
import settings  # python project settings file


class PerformanceMeasuresGIS(object):
    """ This is the parent class for all information and utilities relating to
    2021 Regional Plan Main Performance Measures provided by the GIS team.

    Args:
        scenario_id: Integer scenario id of the loaded ABM scenario in the ABM
            database table [dimension].[scenario]

    Methods:
        check_scenario: Check GIS Performance Measure database table for
            existence of the ABM scenario id
    Properties:
        insert_performance_measures: Insert GIS Performance Measure data into
            ABM Performance Measure database results table
        performance_measures: GIS Performance Measure data from GIS
            Performance Measure database for the given ABM scenario id
    """

    def __init__(self, scenario_id: int) -> None:
        self.scenario_id = scenario_id

    def check_scenario(self) -> bool:
        """ Check the GIS Performance Measure database table for existence of
        an ABM scenario id and return boolean True/False if it does/does not
        exists.

        Returns:
            Boolean indicator if scenario exists in table
        """
        with settings.engines["GIS"].connect() as conn:
            exists = pd.read_sql(
                sql="SELECT ISNULL((SELECT TOP (1) 1 FROM " +
                    "[dbo].[PerformanceMeasures] WHERE [scenario_id] = " +
                    str(self.scenario_id) + "), 0)",
                con=conn)

        return bool(exists.values[0][0])

    @property
    @lru_cache(maxsize=1)
    def performance_measures(self) -> pd.DataFrame:
        """ Get all performance measure data present in the GIS Performance
        Measure database for an ABM scenario id transformed into format of
        non-GIS ABM performance measures.

         Returns:
             Pandas DataFrame of performance measure data
                scenario_id - ABM scenario id
                measure - name of performance measure
                metric - name of metric within performance measure
                value - performance measure result
                updated_by - SQL user who last updated record
                updated_date - date record was updated
        """
        sql = """SELECT
                     [scenario_id]
                     ,[performance_measure] AS [measure]
                     ,[metric]
                     ,[value]
                     ,[updated_by]
                     ,[updated_date]
                FROM
                    [dbo].[PerformanceMeasures]
                WHERE
                    [scenario_id] = """ + str(self.scenario_id)

        with settings.engines["GIS"].connect() as conn:
            data = pd.read_sql(
                sql=sql,
                con=conn)

        return data

    def insert_performance_measures(self) -> None:
        """ Insert GIS Performance Measure data for a given ABM scenario id
        into the ABM-Reporting Performance Measure database results table."""
        # if ABM scenario id does not exist in GIS Performance Measures
        # database then return error message
        if not self.check_scenario():
            msg = ("invalid parameter: scenario_id not present in "
                   "GIS Performance Measures database")
            ValueError(msg)
        else:
            # get performance measure data and append username + date of access
            data = self.performance_measures

            data = data[["scenario_id",
                         "measure",
                         "metric",
                         "value",
                         "updated_by",
                         "updated_date"]]

            # delete old results from the results table if they exist
            with settings.engines["ABM-Reporting"].begin() as conn:
                conn.execute(
                    "DELETE FROM [rp_2021].[results] WHERE [scenario_id] = " +
                    str(self.scenario_id) + " AND [measure] IN ('SE-SM-2'," +
                    "'SE-SM-4','SM-2','SM-3','SM-4')")

                # insert new results into the results table
                data.to_sql(name="results",
                            schema="rp_2021",
                            con=conn,
                            if_exists="append",
                            index=False,
                            method="multi")
