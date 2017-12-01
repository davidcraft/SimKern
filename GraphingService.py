import matplotlib.pyplot as matplotlib
import os

from Utilities.OperatingSystemUtil import OperatingSystemUtil

import logging


class GraphingService(object):

    log = logging.getLogger(__name__)
    logging.basicConfig()
    log.setLevel(logging.INFO)

    def __init__(self):
        pass

    DEFAULT_PLOT_FILENAME = "MachineLearningMultiBarPlot"
    COLOR_PROGRESSION = ['r', 'g', 'b']

    def makeMultiBarPlotWithMultipleAnalysis(self, full_data, output_path, title):
        #TODO: Color code and label plots
        basic_plot = matplotlib.figure()

        full_data_sorted_by_percentage = self.sortByPercentage(full_data)

        location_on_plot = 1
        x_ticks = []

        for percentage in full_data_sorted_by_percentage.keys():
            data = full_data_sorted_by_percentage[percentage].values()
            keys = full_data_sorted_by_percentage[percentage].keys()
            positions = list(range(location_on_plot, location_on_plot + len(keys)))

            matplotlib.boxplot(data, positions=positions, widths=0.6)
            x_ticks.append(location_on_plot + (len(keys) / 2))
            location_on_plot += 4

        matplotlib.title(title)

        # set axes limits and labels
        matplotlib.ylim(0, 1)
        matplotlib.ylabel("Accuracy distribution")

        matplotlib.xlim(0, location_on_plot - 2)
        matplotlib.xlabel("% Train")
        matplotlib.xticks(x_ticks, full_data_sorted_by_percentage.keys())
        basic_plot.show()

        current_path = os.getcwd()
        OperatingSystemUtil.changeWorkingDirectory(output_path)
        basic_plot.savefig(self.DEFAULT_PLOT_FILENAME, bbox_inches='tight')
        OperatingSystemUtil.changeWorkingDirectory(current_path)

    def sortByPercentage(self, full_data):
        by_percentage = {}
        for analysis_type in full_data.keys():
            for percentage_data in full_data[analysis_type].keys():
                # results_by_percentage = {analysis_type: full_data[analysis_type][percentage_data]}
                if percentage_data not in by_percentage.keys():
                    by_percentage[percentage_data] = {analysis_type: full_data[analysis_type][percentage_data]}
                else:
                    by_percentage[percentage_data][analysis_type] = full_data[analysis_type][percentage_data]
        return by_percentage

    def makeMultiBarPlot(self, data, output_path, title):
        basic_plot = matplotlib.figure()
        matplotlib.boxplot(data.values(), labels=data.keys())
        matplotlib.title(title)
        matplotlib.xlabel("% Train")
        matplotlib.ylabel("Accuracy distribution")
        basic_plot.show()

        current_path = os.getcwd()
        OperatingSystemUtil.changeWorkingDirectory(output_path)
        basic_plot.savefig(self.DEFAULT_PLOT_FILENAME, bbox_inches='tight')
        OperatingSystemUtil.changeWorkingDirectory(current_path)

# Required Citation (BibTex/LaTex):
# @Article{Hunter:2007,
#   Author    = {Hunter, J. D.},
#   Title     = {Matplotlib: A 2D graphics environment},
#   Journal   = {Computing In Science \& Engineering},
#   Volume    = {9},
#   Number    = {3},
#   Pages     = {90--95},
#   abstract  = {Matplotlib is a 2D graphics package used for Python
#   for application development, interactive scripting, and
#   publication-quality image generation across user
#   interfaces and operating systems.},
#   publisher = {IEEE COMPUTER SOC},
#   doi = {10.1109/MCSE.2007.55},
#   year      = 2007
# }