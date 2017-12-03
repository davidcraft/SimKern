import logging
import unittest
import os

from MachineLearningDataProcessingService import MachineLearningDataProcessingService
from GraphingService import GraphingService


class MachineLearningDataProcessingServiceIT(unittest.TestCase):

    log = logging.getLogger(__name__)
    log.setLevel(logging.INFO)

    def setUp(self):
        self.current_working_dir = os.getcwd()  # Should be this package.
        self.sample_output = self.current_working_dir + "/SampleDataFiles/BoolNetOutputSample.csv"
        self.sample_genomes_matrix = self.current_working_dir + "/SampleDataFiles/BoolNetGenomesMatrixSample.csv"
        self.sample_similarity_matrix = self.current_working_dir + "/SampleDataFiles/BoolNetSimilarityMatrixSample.csv"

    def tearDown(self):
        if self.current_working_dir != "/":
            os.remove(self.current_working_dir + "/SampleDataFiles/" + GraphingService.DEFAULT_PLOT_FILENAME + ".png")

    def testSIM0ClassifierAnalysis(self):
        machine_learning_processor = MachineLearningDataProcessingService()
        machine_learning_processor.performMachineLearningOnSIM0(self.sample_output, self.sample_genomes_matrix,
                                                                "CLASSIFICATION")
        self.assertPlotPNGCreatedSuccessfully()

    def testSIM0RegressionAnalysis(self):
        machine_learning_processor = MachineLearningDataProcessingService()
        machine_learning_processor.performMachineLearningOnSIM0(self.sample_output, self.sample_genomes_matrix,
                                                                "REGRESSION")
        self.assertPlotPNGCreatedSuccessfully()

    def testSIM1ClassifierAnalysis(self):
        machine_learning_processor = MachineLearningDataProcessingService()
        machine_learning_processor.performMachineLearningOnSIM1(self.sample_output, self.sample_similarity_matrix)
        self.assertPlotPNGCreatedSuccessfully()

    def testSIM0SIM1CombinedClassifierAnalysis(self):
        machine_learning_processor = MachineLearningDataProcessingService()
        machine_learning_processor.performFullSIM0SIM1Analysis(self.sample_output, self.sample_genomes_matrix,
                                                               self.sample_similarity_matrix)
        self.assertPlotPNGCreatedSuccessfully()


    def assertPlotPNGCreatedSuccessfully(self):
        assert len([file for file in os.listdir(self.current_working_dir + "/SampleDataFiles")
                    if file == GraphingService.DEFAULT_PLOT_FILENAME + ".png"]) == 1
