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

    DEFAULT_PLOT_TITLE = "MachineLearningMultiBarPlot"

    def makeMultiBarPlot(self, data, output_path, title):
        basic_plot = matplotlib.figure()
        matplotlib.boxplot(data.values(), labels=data.keys())
        matplotlib.title(title)
        matplotlib.xlabel("% Train")
        matplotlib.ylabel("Accuracy distribution")
        basic_plot.show()

        current_path = os.getcwd()
        OperatingSystemUtil.changeWorkingDirectory(output_path)
        basic_plot.savefig(self.DEFAULT_PLOT_TITLE, bbox_inches='tight')
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