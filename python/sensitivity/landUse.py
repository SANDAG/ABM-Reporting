from functools import lru_cache
import pandas as pd
import re


class LandUse:
    """ Holds all land use related data for a completed ABM scenario
    model run. This includes household data from the file
    output/householdData_<<iteration>>.csv. Class also includes
    functions to calculate auto ownership share.

    :type scenario_path: str
    :param scenario_path: the file path of the completed ABM scenario folder
    """

    def __init__(self, scenario_path):
        self.scenario_path = scenario_path

    @property
    def iteration(self):
        """ Get the ABM scenario number of iterations from the
        conf/sandag_abm.properties file. The ABM number of iterations is
        defined as the numeric character in the line of the properties file
        having the structure "Report.iteration = ?".

        :rtype integer
        :returns: ABM number of iterations """

        properties_file = open(self.scenario_path + "/conf/sandag_abm.properties", "r")
        iteration = None

        for line in properties_file:
            # strip all white space from the line
            line = line.replace(" ", "")

            # find line containing "Report.iteration ="
            m = re.compile("Report\.iteration=").match(line)
            if m:
                # take the portion of the line after the matching string
                # and return as the scenario year
                iteration = int(line[m.end():])
                break

        properties_file.close()

        return iteration

    @property
    @lru_cache(maxsize=1)
    def household_data(self):
        """ Read the Household Data output file from the ABM scenario output
        folder. The household data is read from the
        output/householdData_<<iteration>>.csv file.

        The household data is returned as a Pandas.DataFrame with the field
        [hh_id] defining a unique household record within the data-set.

        :rtpye :class: `pandas.DataFrame`
        :returns: Household Data """

        # load the output folder household data
        use_sampleRate = False
        try:
            hh = pd.read_csv(self.scenario_path + "/output/householdData_" + str(self.iteration) + ".csv",usecols=["hh_id",  # unique household id
                                         "autos",  # number of autos owned
                                         "HVs",  # number of non-autonomous autos owned
                                         "AVs", # number of autonomous autos owned
                                         "sampleRate"]) #sample rate by household
            hh['weight'] = 1/hh['sampleRate']
            use_sampleRate = True
        except:
            hh = pd.read_csv(self.scenario_path + "/output/householdData_" + str(self.iteration) + ".csv", usecols=["hh_id",  # unique household id
                                          "autos",  # number of autos owned
                                          "HVs",  # number of non-autonomous autos owned
                                          "AVs"]) # number of autonomous autos owned
            # assumes household weight of 1 for every household
            hh['weight'] = 1

        # return fields of interest
        return hh[["hh_id",
                   "autos",
                   "HVs",
                   "AVs",
                   "weight"]]

    def calculate_ao_metric(self):
        """ Calculate household auto-ownership by auto ownership
        categories (HVs, AVs, All).

        :rtpye :class: `pandas.DataFrame`
        :returns: Calculated household auto-ownership by auto
        ownership categories """

        data = self.household_data[["autos",
                                    "HVs",
                                    "AVs",
                                    "weight"]]
        def weighted_average(df,data_col,weight_col):
            df_data = df[data_col].multiply(df[weight_col], axis='index')
            df_weight = pd.notnull(df[data_col]).multiply(df[weight_col], axis='index')
            result = df_data.sum() / df_weight.sum()
            return result
        
        # calculate mean within each variable        
        data = weighted_average(data, ['autos','HVs','AVs'],'weight').reset_index(name="mean")
        data["households"] = "all"

        # pivot the result set by mode
        data = data.pivot(index="households", columns="index", values="mean")

        return data
