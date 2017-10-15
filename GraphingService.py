import matplotlib.pyplot as matplotlib
import os

import logging


class GraphingService(object):

    log = logging.getLogger(__name__)
    logging.basicConfig()
    log.setLevel(logging.INFO)

    def __init__(self):
        pass

    def makeMultiBarPlot(self, data, output_path):
        basic_plot = matplotlib.figure()
        matplotlib.boxplot(data.values(), labels=data.keys())
        matplotlib.title("Similarity Matrix SVM Multi-Classifier Results By Percent Train")
        matplotlib.xlabel("% Train")
        matplotlib.ylabel("Accuracy distribution")
        basic_plot.show()

        current_path = os.getcwd()
        self.changeWorkingDirectory(output_path)
        basic_plot.savefig("SimilarityMatrixSVMPlot", bbox_inches='tight')
        self.changeWorkingDirectory(current_path)

    # TODO: repeated code with FileProcessingService. DRY it up.
    def changeWorkingDirectory(self, new_directory):
        if not os.path.isdir(new_directory):
            os.mkdir(new_directory)
        os.chdir(new_directory)

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