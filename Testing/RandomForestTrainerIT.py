import logging
import os
import shutil
import unittest

from RandomForest.RandomForestTrainer import RandomForestTrainer
from sklearn.ensemble import RandomForestClassifier
from FileProcessingService import FileProcessingService
from SupportedFileTypes import SupportedFileTypes
from SupportedThirdPartyResponses import SupportedThirdPartyResponses
from ThirdPartyProgramCaller import ThirdPartyProgramCaller


class RandomForestTrainerIT(unittest.TestCase):

    log = logging.getLogger(__name__)
    log.setLevel(logging.INFO)

    def setUp(self):
        self.current_working_dir = os.getcwd()  # Should be this package.
        self.number_of_genomes = 20

    def tearDown(self):
        if self.generated_folder != "/" and os.path.isdir(self.generated_folder):
            shutil.rmtree(self.generated_folder)

    def initializeServicesAndCreateGenomes(self, file_name, file_type, response_type):
        data_file = self.setTargetFile('SampleDataFiles', file_name)
        file_processing_service = FileProcessingService(data_file, file_type,
                                                        self.number_of_genomes, self.current_working_dir)
        self.generated_folder = self.current_working_dir + file_processing_service.GENERATED_FOLDER_NAME
        genomes_created = file_processing_service.createGenomes()
        file_processing_service.data_file.close()
        self.thirdPartyProgramCaller = ThirdPartyProgramCaller(self.current_working_dir, file_type, genomes_created[0],
                                                               response_type, self.number_of_genomes, 0)
        return genomes_created

    def setTargetFile(self, path_name, file_name):
        resource_path = '/'.join((path_name, file_name))
        return open(resource_path)

    def getThirdPartyResult(self):
        return self.thirdPartyProgramCaller.callThirdPartyProgram(True)

    @staticmethod
    def assertModelTrainedSuccessfully(genomes, model, expected_classes):
        assert model is not None
        assert model.feature_importances_.size == len(genomes[1][0])  # num 'importances' == num features
        if model is RandomForestClassifier:
            assert len(model.classes_) == expected_classes

    def testIntegerClassifierModelCreatedSuccessfully(self):
        genomes = self.initializeServicesAndCreateGenomes('WNT_ERK_crosstalk.octave', SupportedFileTypes.OCTAVE,
                                                          SupportedThirdPartyResponses.INTEGER)
        third_party_result = self.getThirdPartyResult()

        random_forest_trainer = RandomForestTrainer(genomes[1], third_party_result)
        random_forest_result = random_forest_trainer.trainRandomForestClassifier(0.7)

        self.assertModelTrainedSuccessfully(genomes, random_forest_result[0], 2)

    def testRegressorModelCreatedSuccessfully(self):
        genomes = self.initializeServicesAndCreateGenomes('WNT_ERK_crosstalk_float_output.octave',
                                                          SupportedFileTypes.OCTAVE,
                                                          SupportedThirdPartyResponses.FLOAT)
        third_party_result = self.getThirdPartyResult()

        random_forest_trainer = RandomForestTrainer(genomes[1], third_party_result)
        random_forest_result = random_forest_trainer.trainRandomForestRegressor(0.7)

        self.assertModelTrainedSuccessfully(genomes, random_forest_result[0], 2)

    def testMultiClassifierModelCreatedSuccessfullyWithLinearProgramming(self):
        response_type = SupportedThirdPartyResponses.INTEGER
        attempts_at_multi_classification = 0
        hit_more_than_two_outcomes = False
        third_party_result = {}
        genomes = []

        while attempts_at_multi_classification < 10 and not hit_more_than_two_outcomes:
            attempts_at_multi_classification += 1
            self.log.info("Attempt number %s at getting multi-classifier results.", attempts_at_multi_classification)
            genomes = self.initializeServicesAndCreateGenomes('linearProgrammingModel.octave',
                                                              SupportedFileTypes.OCTAVE, response_type)
            third_party_result = self.getThirdPartyResult()
            classes = list(set(third_party_result.values()))
            if len(classes) > 2:
                hit_more_than_two_outcomes = True

        if len(genomes) == 0 or third_party_result == {}:
            self.log.error("Unable to return more than 2 classes from third party response.")
            assert False

        random_forest_trainer = RandomForestTrainer(genomes[1], third_party_result)
        random_forest_result = random_forest_trainer.trainRandomForestClassifier(0.7)

        self.assertModelTrainedSuccessfully(genomes, random_forest_result[0], 3)
