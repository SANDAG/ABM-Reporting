# -*- coding: utf-8 -*-
""" ABM Scenario Highway and Transit Network Sensitivity Test Module.

This module contains classes holding all information and utilities relating to
highway and transit network related sensitivity metrics of a SANDAG
Activity-Based Model (ABM) scenario.

Notes:
    docstring style guide - http://google.github.io/styleguide/pyguide.html
"""

from functools import lru_cache
import os
import numpy as np
import pandas as pd


class TravelNetwork(object):
    """ This is the parent class for all information and utilities relating
    to highway and transit network related sensitivity metrics of a SANDAG
    Activity-Based Model (ABM) scenario.

    Args:
        scenario_path: String location of the completed ABM scenario folder

    Subclasses:
        HighwayNetwork: Holds all highway network information and utilities
        TransitNetwork: Holds all transit network information and utilities
    """
    def __init__(self, scenario_path: str) -> None:
        self.scenario_path = scenario_path


class HighwayNetwork(TravelNetwork):
    """ A subclass of the TravelNetwork class. Holds all highway network
    related data for a completed ABM scenario model run. This includes input
    highway network data from the report/hwyTcad.csv and loaded highway
    network data from the report/hwyload_<<TOD>>.csv files. Class also
    includes functions to calculate vehicle hours delayed (vhd), vehicle hours
    time (vht), and vehicle miles traveled (vmt).

    Methods:
        calculate_vhd: Calculates vehicle hours delayed (vhd) by functional
            class (IFC) and mode
        calculate_vht: Calculates vehicle hours time (vht) by functional
            class (IFC) and mode
        calculate_vmt: Calculates vehicle miles travelled (vmt) by functional
            class (IFC) and mode

    Properties:
        input_network: Pandas DataFrame of the report/hwyTcad.csv file
        loaded_network: Pandas DataFrame of the report/hwyload_<<TOD>>.csv files
    """
    def calculate_vhd(self) -> pd.DataFrame:
        """ Calculate vehicle hours delayed (vhd) on the loaded highway
        network by functional class (IFC) and aggregated modes
        (Auto - Truck - Bus - Total).

        Vehicle hours delayed is calculated within each link, time period, and
        direction as vehicle flow multiplied by loaded time less free flow time
        less intersection delay time. """

        # merge input highway network and loaded network
        vhd = self.input_network.merge(
            self.loaded_network,
            left_on=["ID", "timePeriod"],
            right_on=["ID1", "timePeriod"],
            how="left")

        # calculate vehicle hours delayed by mode
        vhd["Auto"] = (vhd.AB_Flow_Auto * (vhd.AB_Time - vhd.ABTM - vhd.ABTX) / 60.0) + \
                      (vhd.BA_Flow_Auto * (vhd.BA_Time - vhd.BATM - vhd.BATX) / 60.0)
        vhd["Truck"] = (vhd.AB_Flow_Truck * (vhd.AB_Time - vhd.ABTM - vhd.ABTX) / 60.0) + \
                       (vhd.BA_Flow_Truck * (vhd.BA_Time - vhd.BATM - vhd.BATX) / 60.0)
        vhd["Bus"] = (vhd.ABPRELOAD * (vhd.AB_Time - vhd.ABTM - vhd.ABTX) / 60.0) + \
                     (vhd.BAPRELOAD * (vhd.BA_Time - vhd.BATM - vhd.BATX) / 60.0)

        # set negative vhd to zero
        vhd_cols = vhd[['Auto', 'Truck', 'Bus']].copy()
        vhd_cols[vhd_cols < 0] = 0
        vhd[['Auto', 'Truck', 'Bus']] = vhd_cols

        # calculate vhd totals
        vhd["Total"] = vhd[['Auto', 'Truck', 'Bus']].sum(axis=1)

        # sum vehicle hours delayed by functional class
        vhd = vhd.groupby(["IFC", "ifc_desc"], as_index=False)["Auto", "Truck", "Bus", "Total"].sum()

        # sum vehicle hours delayed across the entire network
        # and append to result assigning a functional class of Total/All
        total_vhd = vhd.sum()
        total_vhd["IFC"] = 99
        total_vhd["ifc_desc"] = "Total"
        vhd = vhd.append(total_vhd, ignore_index=True)

        vhd.set_index(keys="IFC", inplace=True)

        # return vehicle hours delayed by functional class and aggregated mode
        return vhd[["ifc_desc",
                    "Auto",
                    "Truck",
                    "Bus",
                    "Total"]]

    def calculate_vht(self) -> pd.DataFrame:
        """ Calculate vehicle hours time (vht) on the loaded highway
        network by functional class (IFC) and aggregated modes
        (Auto - Truck - Bus - Total).

        Vehicle hours time is calculated within each link, time period, and
        direction as vehicle flow multiplied by loaded time. """

        # merge input highway network and loaded network
        vht = self.input_network.merge(
            self.loaded_network,
            left_on=["ID", "timePeriod"],
            right_on=["ID1", "timePeriod"],
            how="left")

        # calculate vehicle hours time by mode
        vht["Auto"] = (vht.AB_Flow_Auto * vht.AB_Time) + (vht.BA_Flow_Auto * vht.BA_Time)
        vht["Truck"] = (vht.AB_Flow_Truck * vht.AB_Time) + (vht.BA_Flow_Truck * vht.BA_Time)
        vht["Bus"] = (vht.ABPRELOAD * vht.AB_Time) + (vht.BAPRELOAD * vht.BA_Time)
        vht["Total"] = vht[['Auto', 'Truck', 'Bus']].sum(axis=1)

        # sum vehicle hours time by functional class
        vht = vht.groupby(["IFC", "ifc_desc"], as_index=False)["Auto", "Truck", "Bus", "Total"].sum()

        # sum vehicle hours time across the entire network
        # and append to result assigning a functional class of Total/All
        total_vht = vht.sum()
        total_vht["IFC"] = 99
        total_vht["ifc_desc"] = "Total"
        vht = vht.append(total_vht, ignore_index=True)

        vht.set_index(keys="IFC", inplace=True)

        # return vehicle hours time by functional class and aggregated mode
        return vht[["ifc_desc",
                    "Auto",
                    "Truck",
                    "Bus",
                    "Total"]]

    def calculate_vmt(self) -> pd.DataFrame:
        """ Calculate vehicle miles traveled (vmt) on the loaded highway
        highway network by functional class (IFC) and aggregated modes
        (Auto - Truck - Bus - Total).

        Vehicle miles traveled is calculated as the sum of link-level vehicle
        flow multiplied by the link length in miles. """

        # merge input highway network and loaded network
        vmt = self.input_network.merge(
            self.loaded_network,
            left_on=["ID", "timePeriod"],
            right_on=["ID1", "timePeriod"],
            how="left")

        # calculate vehicle miles traveled by mode
        vmt["Auto"] = (vmt.AB_Flow_Auto + vmt.BA_Flow_Auto) * vmt.Length
        vmt["Truck"] = (vmt.AB_Flow_Truck + vmt.BA_Flow_Truck) * vmt.Length
        vmt["Bus"] = (vmt.ABPRELOAD + vmt.BAPRELOAD) * vmt.Length
        vmt["Total"] = vmt[['Auto', 'Truck', 'Bus']].sum(axis=1)

        # sum vehicle miles traveled by functional class
        vmt = vmt.groupby(["IFC", "ifc_desc"], as_index=False)["Auto", "Truck", "Bus", "Total"].sum()

        # sum vehicle miles traveled across the entire network
        # and append to result assigning a functional class of Total/All
        total_vmt = vmt.sum()
        total_vmt["IFC"] = 99
        total_vmt["ifc_desc"] = "Total"
        vmt = vmt.append(total_vmt, ignore_index=True)

        vmt.set_index(keys="IFC", inplace=True)

        # return vehicle miles traveled by functional class and aggregated mode
        return vmt[["ifc_desc",
                    "Auto",
                    "Truck",
                    "Bus",
                    "Total"]]

    @property
    @lru_cache(maxsize=1)
    def input_network(self) -> pd.DataFrame:
        """ Read the highway network from the ABM scenario folder. The network
        is read from the report/hwyTcad.csv file and transformed from wide to
        long by ABM five time of day period. The network is returned with the
        2-tuple ([ID], [timePeriod]) defining a unique record within the
        data-set. """

        # load the input highway network
        hwy_tcad = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "hwyTcad.csv"),
            usecols=["ID",  # hwycov id
                     "Length",  # length of link segment (miles)
                     "IFC",  # link functional class
                     "ABTM_EA",  # A-B direction Early AM free flow time (minutes)
                     "ABTM_AM",  # A-B direction AM Peak free flow time (minutes)
                     "ABTM_MD",  # A-B direction Mid-day free flow time (minutes)
                     "ABTM_PM",  # A-B direction PM Peak free flow time (minutes)
                     "ABTM_EV",  # A-B direction Evening free flow time (minutes)
                     "BATM_EA",  # B-A direction Early AM free flow time (minutes)
                     "BATM_AM",  # B-A direction AM Peak free flow time (minutes)
                     "BATM_MD",  # B-A direction Mid-day free flow time (minutes)
                     "BATM_PM",  # B-A direction PM Peak free flow time (minutes)
                     "BATM_EV",  # B-A direction Evening free flow time (minutes)
                     "ABTX_EA",  # A-B direction Early AM intersection delay time (minutes)
                     "ABTX_AM",  # A-B direction AM Peak intersection delay time (minutes)
                     "ABTX_MD",  # A-B direction Mid-day intersection delay time (minutes)
                     "ABTX_PM",  # A-B direction PM Peak intersection delay time (minutes)
                     "ABTX_EV",  # A-B direction Evening intersection delay time (minutes)
                     "BATX_EA",  # B-A direction Early AM intersection delay time (minutes)
                     "BATX_AM",  # B-A direction AM Peak intersection delay time (minutes)
                     "BATX_MD",  # B-A direction Mid-day intersection delay time (minutes)
                     "BATX_PM",  # B-A direction PM Peak intersection delay time (minutes)
                     "BATX_EV",  # B-A direction Evening intersection delay time (minutes)
                     "ABPRELOAD_EA",  # A-B direction Early AM bus volume
                     "ABPRELOAD_AM",  # A-B direction AM Peak bus volume
                     "ABPRELOAD_MD",  # A-B direction Mid-day bus volume
                     "ABPRELOAD_PM",  # A-B direction PM Peak bus volume
                     "ABPRELOAD_EV",  # A-B direction Evening bus volume
                     "BAPRELOAD_EA",  # B-A direction Early AM bus volume
                     "BAPRELOAD_AM",  # B-A direction AM Peak bus volume
                     "BAPRELOAD_MD",  # B-A direction Mid-day bus volume
                     "BAPRELOAD_PM",  # B-A direction PM Peak bus volume
                     "BAPRELOAD_EV"])  # B-A direction Evening bus volume]

        # restructure file to long-format by ABM 5 time of day period
        hwy_tcad = pd.wide_to_long(
            df=hwy_tcad,
            stubnames=["ABTM",
                       "BATM",
                       "ABTX",
                       "BATX",
                       "ABPRELOAD",
                       "BAPRELOAD"],
            i=["ID",
               "Length",
               "IFC"],
            j="timePeriod",
            sep="_",
            suffix="\w+").reset_index()

        # fill NaN values with 0s
        hwy_tcad.fillna(value=0, inplace=True)

        # add description of functional class to DataFrame
        conditions = [(hwy_tcad["IFC"] == 1),
                      (hwy_tcad["IFC"] == 2),
                      (hwy_tcad["IFC"] == 3),
                      (hwy_tcad["IFC"] == 4),
                      (hwy_tcad["IFC"] == 5),
                      (hwy_tcad["IFC"] == 6),
                      (hwy_tcad["IFC"] == 7),
                      (hwy_tcad["IFC"] == 8),
                      (hwy_tcad["IFC"] == 9),
                      (hwy_tcad["IFC"] == 10)]

        choices = ["Freeway",
                   "Prime Arterial",
                   "Major Arterial",
                   "Collector",
                   "Local Collector",
                   "Rural Collector",
                   "Local Road",
                   "Freeway Connector Ramp",
                   "Local Ramp",
                   "Zone Connector"]

        hwy_tcad["ifc_desc"] = np.select(conditions, choices)

        # return the input highway network
        return hwy_tcad

    @property
    @lru_cache(maxsize=1)
    def loaded_network(self) -> pd.DataFrame:
        """ Read the loaded highway network from the ABM scenario folder. The
        loaded network is read from five files split by ABM five time of day
         following the naming convention report/hwyload_<<TOD>>.csv.

         These files are combined adding a field designating the ABM five time
         of day period. Additionally, the vehicle flows by mode are aggregated
         to three categories (Auto - Truck - Total).

        The network is returned as a Pandas.DataFrame with the 2-tuple
        ([ID1], [timePeriod]) defining a unique record within the data-set.
        """

        # create list of loaded highway network files
        # and their respective ABM 5 time of day time periods
        load_files = [{"path": os.path.join("report", "hwyload_EA.csv"), "timePeriod": "EA"},
                      {"path": os.path.join("report", "hwyload_AM.csv"), "timePeriod": "AM"},
                      {"path": os.path.join("report", "hwyload_MD.csv"), "timePeriod": "MD"},
                      {"path": os.path.join("report", "hwyload_PM.csv"), "timePeriod": "PM"},
                      {"path": os.path.join("report", "hwyload_EV.csv"), "timePeriod": "EV"}]

        # initialize loaded highway network DataFrame
        hwy_load = pd.DataFrame()

        # for each loaded highway network file
        for file in load_files:
            # read the loaded highway network
            # for column names format is <<direction>>_Flow_<<mode>>_<<transponder>><<value of time>>
            # where <<transponder>> is optional attribute for single occupancy vehicle modes only
            # <<direction>> - AB or BA direction
            # <<mode>> - SOV, SR2, SR3, lhd, mhd, hhd
            # SOV - single occupancy vehicle
            # SR2 - shared ride 2
            # SR3 - shared ride 3
            # lhd - light heavy duty truck
            # mhd - medium heavy duty truck
            # hhd - heavy heavy duty truck
            # <<transponder>> - NT (non-transponder), T (transponder)
            # <<value of time>> - L (low), M (medium), H (high)
            data = pd.read_csv(
                os.path.join(self.scenario_path, file["path"]),
                usecols=["ID1",  # hwycov id
                         "AB_Time",  # A-B direction loaded time
                         "BA_Time",  # B-A direction loaded time
                         "AB_Flow_SOV_NTPL",
                         "BA_Flow_SOV_NTPL",
                         "AB_Flow_SOV_TPL",
                         "BA_Flow_SOV_TPL",
                         "AB_Flow_SR2L",
                         "BA_Flow_SR2L",
                         "AB_Flow_SR3L",
                         "BA_Flow_SR3L",
                         "AB_Flow_SOV_NTPM",
                         "BA_Flow_SOV_NTPM",
                         "AB_Flow_SOV_TPM",
                         "BA_Flow_SOV_TPM",
                         "AB_Flow_SR2M",
                         "BA_Flow_SR2M",
                         "AB_Flow_SR3M",
                         "BA_Flow_SR3M",
                         "AB_Flow_SOV_NTPH",
                         "BA_Flow_SOV_NTPH",
                         "AB_Flow_SOV_TPH",
                         "BA_Flow_SOV_TPH",
                         "AB_Flow_SR2H",
                         "BA_Flow_SR2H",
                         "AB_Flow_SR3H",
                         "BA_Flow_SR3H",
                         "AB_Flow_lhd",
                         "BA_Flow_lhd",
                         "AB_Flow_mhd",
                         "BA_Flow_mhd",
                         "AB_Flow_hhd",
                         "BA_Flow_hhd",
                         "AB_Flow",
                         "BA_Flow"])

            # combine flows by mode into aggregate mode categories
            # Auto - Truck - Total
            data["AB_Flow_Auto"] = data[["AB_Flow_SOV_NTPL",
                                         "AB_Flow_SOV_TPL",
                                         "AB_Flow_SR2L",
                                         "AB_Flow_SR3L",
                                         "AB_Flow_SOV_NTPM",
                                         "AB_Flow_SOV_TPM",
                                         "AB_Flow_SR2M",
                                         "AB_Flow_SR3M",
                                         "AB_Flow_SOV_NTPH",
                                         "AB_Flow_SOV_TPH",
                                         "AB_Flow_SR2H",
                                         "AB_Flow_SR3H"]].sum(axis=1)

            data["BA_Flow_Auto"] = data[["BA_Flow_SOV_NTPL",
                                         "BA_Flow_SOV_TPL",
                                         "BA_Flow_SR2L",
                                         "BA_Flow_SR3L",
                                         "BA_Flow_SOV_NTPM",
                                         "BA_Flow_SOV_TPM",
                                         "BA_Flow_SR2M",
                                         "BA_Flow_SR3M",
                                         "BA_Flow_SOV_NTPH",
                                         "BA_Flow_SOV_TPH",
                                         "BA_Flow_SR2H",
                                         "BA_Flow_SR3H"]].sum(axis=1)

            data["AB_Flow_Truck"] = data[["AB_Flow_lhd",
                                          "AB_Flow_mhd",
                                          "AB_Flow_hhd"]].sum(axis=1)

            data["BA_Flow_Truck"] = data[["BA_Flow_lhd",
                                          "BA_Flow_mhd",
                                          "BA_Flow_hhd"]].sum(axis=1)

            # re-calculate total flow columns
            # issue currently exists in files where flows by mode
            # do not equal the total flows
            data["AB_Flow"] = data[["AB_Flow_Auto",
                                    "AB_Flow_Truck"]].sum(axis=1)

            data["BA_Flow"] = data[["BA_Flow_Auto",
                                    "BA_Flow_Truck"]].sum(axis=1)

            # fill NaN values with 0s
            data.fillna(value=0, inplace=True)

            # append applicable ABM five time of day time period
            data = pd.concat(
                objs=[pd.Series([file["timePeriod"]] * len(data.index), name="timePeriod"),
                      data],
                axis=1)

            # restrict data-set to fields of interest
            data = data[["ID1",
                         "timePeriod",
                         "AB_Time",
                         "BA_Time",
                         "AB_Flow_Auto",
                         "BA_Flow_Auto",
                         "AB_Flow_Truck",
                         "BA_Flow_Truck",
                         "AB_Flow",
                         "BA_Flow"]]

            # add to result DataFrame
            hwy_load = hwy_load.append(data)

        # return combined and aggregated loaded highway network
        return hwy_load


class TransitNetwork(TravelNetwork):
    """ Holds all transit network related data for a completed ABM scenario
    model run. This includes transit route data from the
    report/transitRoute.csv and the route and stop based on and off movements
    of the loaded transit network from the report/transit_onoff.csv file.
    The class also includes functions to calculate boardings and transfers by
    ABM five time of day and transit route mode.

    Methods:
        calculate_boardings: Calculates boardings by ABM five time of day
        calculate_transfers:  Calculates transfers by ABM five time of day

    Properties:
        transit_onoff: Pandas DataFrame of the report/transit_onoff.csv file
        transit_route: Pandas DataFrame of the report/transitRoute.csv file
    """
    def calculate_boardings(self) -> pd.DataFrame:
        """ Calculate boardings on the loaded transit network by ABM five time
        of day and transit route mode. """

        boardings = self.transit_route.merge(
            self.transit_onoff,
            left_on="Route_ID",
            right_on="ROUTE",
            how="left")

        # sum boardings by ABM five time of day and transit route mode
        boardings = boardings.groupby(["TOD", "modeDescription"], as_index=False)["BOARDINGS"].sum()

        # sum boardings across all transit route modes for ABM five time of day
        # and append result to data-set
        total_mode = boardings.groupby(["TOD"], as_index=False)["BOARDINGS"].sum()
        total_mode["modeDescription"] = "Total"
        boardings = boardings.append(total_mode, ignore_index=True, sort=True)

        # sum boardings by mode across all ABM five time of day within transit route mode
        # and append result to data-set
        total_tod = boardings.groupby(["modeDescription"], as_index=False)["BOARDINGS"].sum()
        total_tod["TOD"] = "All"
        boardings = boardings.append(total_tod, ignore_index=True, sort=True)

        # reshape data-set from long to wide by mode
        boardings = boardings.pivot(index="TOD", columns="modeDescription", values="BOARDINGS")

        # sort data-set by TOD
        boardings = boardings.reindex(labels=["EA", "AM", "MD", "PM", "EV", "All"])

        # ensure all mode columns exist
        column_list = ["Commuter Rail",
                       "Light Rail",
                       "Freeway Rapid",
                       "Arterial Rapid",
                       "Premium Express Bus",
                       "Express Bus",
                       "Local Bus",
                       "Total"]

        for col in column_list:
            if col not in boardings.columns:
                boardings[col] = np.nan

        # return data-set with specified mode column ordering
        return boardings[column_list]

    def calculate_transfers(self) -> pd.DataFrame:
        """ Calculate transfers on the loaded transit network by ABM five time
        of day and transit route mode. """

        transfers = self.transit_route.merge(
            self.transit_onoff,
            left_on="Route_ID",
            right_on="ROUTE",
            how="left")

        # sum transfers by ABM five time of day and transit route mode
        transfers = transfers.groupby(["TOD", "modeDescription"], as_index=False)["DIRECTTRANSFEROFF"].sum()

        # sum transfers across all transit route modes for ABM five time of day
        # and append result to data-set
        total_mode = transfers.groupby(["TOD"], as_index=False)["DIRECTTRANSFEROFF"].sum()
        total_mode["modeDescription"] = "Total"
        transfers = transfers.append(total_mode, ignore_index=True, sort=True)

        # sum transfers by mode across all ABM five time of day within transit route mode
        # and append result to data-set
        total_tod = transfers.groupby(["modeDescription"], as_index=False)["DIRECTTRANSFEROFF"].sum()
        total_tod["TOD"] = "All"
        transfers = transfers.append(total_tod, ignore_index=True, sort=True)

        # reshape data-set from long to wide by mode
        transfers = transfers.pivot(index="TOD", columns="modeDescription", values="DIRECTTRANSFEROFF")

        # sort data-set by TOD
        transfers = transfers.reindex(labels=["EA", "AM", "MD", "PM", "EV", "All"])

        # ensure all mode columns exist
        column_list = ["Commuter Rail",
                       "Light Rail",
                       "Freeway Rapid",
                       "Arterial Rapid",
                       "Premium Express Bus",
                       "Express Bus",
                       "Local Bus",
                       "Total"]

        for col in column_list:
            if col not in transfers.columns:
                transfers[col] = np.nan

        # return data-set with specified mode column ordering
        return transfers[column_list]

    @property
    @lru_cache(maxsize=1)
    def transit_onoff(self) -> pd.DataFrame:
        """ Read the route and stop based on and off movements of the loaded
        transit network from the report/transit_onoff.csv file

        The on off movements are returned as a Pandas.DataFrame with the 4-tuple
        ([MODE], [ACCESSMODE], [TOD], [ROUTE], [STOP]) defining a unique record
        within the data-set.
        """
        # load the transit on/off movements
        on_off = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "transit_onoff.csv"),
            usecols=["MODE",  # transit mode
                     "ACCESSMODE",  # transit access mode
                     "TOD",  # ABM five time of day periods
                     "ROUTE",  # transit route id
                     "STOP",  # transit stop id
                     "BOARDINGS",  # number of boardings
                     "ALIGHTINGS",  # number of alightings
                     "DIRECTTRANSFERON",  # direct transfers on
                     "DIRECTTRANSFEROFF"])  # direct transfers off

        # return the on/off movements
        return on_off

    @property
    @lru_cache(maxsize=1)
    def transit_route(self) -> pd.DataFrame:
        """ Read the transit network routes from the ABM scenario folder. The
        transit network routes are read from the report/transitRoute.csv file.
        """
        # load the transit routes
        routes = pd.read_csv(
            os.path.join(self.scenario_path,
                         "report",
                         "transitRoute.csv"),
            usecols=["Route_ID",  # transit route id
                     "Mode"])  # transit route mode

        # add description of transit route mode to DataFrame
        conditions = [(routes["Mode"] == 4),
                      (routes["Mode"] == 5),
                      (routes["Mode"] == 6),
                      (routes["Mode"] == 7),
                      (routes["Mode"] == 8),
                      (routes["Mode"] == 9),
                      (routes["Mode"] == 10)]

        choices = ["Commuter Rail",
                   "Light Rail",
                   "Freeway Rapid",
                   "Arterial Rapid",
                   "Premium Express Bus",
                   "Express Bus",
                   "Local Bus"]

        routes["modeDescription"] = np.select(conditions, choices)

        # return the transit network routes
        return routes
