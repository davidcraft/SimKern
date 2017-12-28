import matplotlib.pyplot as matplotlib
import matplotlib.patches as mpatches
import os

from Utilities.OperatingSystemUtil import OperatingSystemUtil
from Utilities.SafeCastUtil import SafeCastUtil
from SupportedAnalysisTypes import SupportedAnalysisTypes

import logging


class GraphingService(object):

    log = logging.getLogger(__name__)
    logging.basicConfig()
    log.setLevel(logging.INFO)

    def __init__(self):
        pass

    DEFAULT_PLOT_FILENAME = "MachineLearningMultiBarPlot"
    COLOR_PROGRESSION = ['red', 'green', 'blue', 'purple', 'orange']

    def makeMultiBarPlotWithMultipleAnalysis(self, full_data, output_path, analysis_type, title):
        basic_plot = matplotlib.figure()

        full_data_sorted_by_percentage = self.sortByPercentage(full_data)

        location_on_plot = 1
        x_ticks = []

        for percentage in full_data_sorted_by_percentage.keys():
            data = full_data_sorted_by_percentage[percentage].values()
            keys = full_data_sorted_by_percentage[percentage].keys()
            positions = SafeCastUtil.safeCast(range(location_on_plot, location_on_plot + len(keys)), list)
            plot = matplotlib.boxplot(data, positions=positions, widths=0.6)
            self.color_by_analysis(keys, plot)
            x_ticks.append(location_on_plot + (len(keys) / 2))
            location_on_plot += 4

        matplotlib.title(title)

        # set axes limits and labels
        if analysis_type == SupportedAnalysisTypes.CLASSIFICATION:
            matplotlib.ylim(0, 1)
        else:
            matplotlib.ylim(-1, 1)
        matplotlib.ylabel("Accuracy distribution")

        matplotlib.xlim(0, location_on_plot - 1)
        matplotlib.xlabel("% Train")
        matplotlib.xticks(x_ticks, [SafeCastUtil.safeCast(k*100, int) for k in full_data_sorted_by_percentage.keys()])
        self.createLegend(full_data)

        basic_plot.show()

        current_path = os.getcwd()
        OperatingSystemUtil.changeWorkingDirectory(output_path)
        basic_plot.savefig(self.DEFAULT_PLOT_FILENAME, bbox_inches='tight')
        OperatingSystemUtil.changeWorkingDirectory(current_path)

    def sortByPercentage(self, full_data):
        by_percentage = {}
        for analysis_type in full_data.keys():
            for percentage_data in full_data[analysis_type].keys():
                if percentage_data not in by_percentage.keys():
                    by_percentage[percentage_data] = {analysis_type: full_data[analysis_type][percentage_data]}
                else:
                    by_percentage[percentage_data][analysis_type] = full_data[analysis_type][percentage_data]
        return by_percentage

    def color_by_analysis(self, keys, plot):
        for element in ['boxes', 'whiskers', 'fliers', 'means', 'medians', 'caps']:
            if len(keys) != 0 and len(plot[element]) % len(keys) == 0:
                color_split = SafeCastUtil.safeCast(len(plot[element]) / len(keys), int)
                i = 0
                color_index = 0
                while i < len(plot[element]):
                    if i % color_split == 0 and i > 0:
                        color_index += 1
                        if color_split >= len(self.COLOR_PROGRESSION):
                            color_index = 0
                    matplotlib.setp(plot[element][i], color=self.COLOR_PROGRESSION[color_index])
                    i += 1

    def createLegend(self, full_data):
        patches = []
        color_index = 0
        for key in full_data.keys():
            if color_index >= len(self.COLOR_PROGRESSION):
                color_index = 0
            patch = mpatches.Patch(color=self.COLOR_PROGRESSION[color_index], label=key)
            patches.append(patch)
            color_index += 1
        matplotlib.legend(handles=patches, loc=4)

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
