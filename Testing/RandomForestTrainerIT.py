import logging
import os
import shutil
import unittest

from RandomForest.RandomForestTrainer import RandomForestTrainer
from FileProcessingService import FileProcessingService
from SupportedFileTypes import SupportedFileTypes
from ThirdPartyProgramCaller import ThirdPartyProgramCaller

class RandomForestTrainerIT(unittest.TestCase):

    log = logging.getLogger(__name__)
    log.setLevel(logging.INFO)

    def setUp(self):
        self.current_working_dir = os.getcwd()  # Should be this package.
        self.number_of_genomes = 20

    def tearDown(self):
        if self.generated_folder != "/":
            shutil.rmtree(self.generated_folder)

    def initializeServicesAndCreateGenomes(self, file_name, file_type):
        data_file = self.setTargetFile('SampleDataFiles', file_name)
        file_processing_service = FileProcessingService(data_file, file_type,
                                                        self.number_of_genomes, self.current_working_dir)
        self.generated_folder = self.current_working_dir + file_processing_service.GENERATED_FOLDER_NAME
        genomes_created = file_processing_service.createGenomes()
        file_processing_service.data_file.close()
        self.thirdPartyProgramCaller = ThirdPartyProgramCaller(self.current_working_dir, file_type,
                                                               genomes_created[0])
        return genomes_created

    def setTargetFile(self, path_name, file_name):
        resource_path = '/'.join((path_name, file_name))
        return open(resource_path)

    def getThirdPartyResult(self):
        return self.thirdPartyProgramCaller.callThirdPartyProgram(True)

    def testRandomForestModelCreatedSuccessfully(self):
        genomes = self.initializeServicesAndCreateGenomes('WNT_ERK_crosstalk.octave', SupportedFileTypes.OCTAVE)
        third_party_result = self.getThirdPartyResult()

        random_forest_trainer = RandomForestTrainer(genomes[1], third_party_result)
        random_forest_model = random_forest_trainer.trainRandomForest(0.7)

        assert random_forest_model is not None
        assert random_forest_model.feature_importances_.size == len(genomes[1][0])  # num 'importances' == num features


