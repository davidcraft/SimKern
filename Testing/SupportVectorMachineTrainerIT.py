import logging
import os
import shutil
import unittest

from SupportVectorMachine.SupportVectorMachineTrainer import SupportVectorMachineTrainer
from FileProcessingService import FileProcessingService
from SupportVectorMachine.SupportedKernelFunctionTypes import SupportedKernelFunctionTypes
from SupportedFileTypes import SupportedFileTypes
from SupportedThirdPartyResponses import SupportedThirdPartyResponses
from ThirdPartyProgramCaller import ThirdPartyProgramCaller


class SupportVectorMachineIT(unittest.TestCase):

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
    def assertModelTrainedSuccessfully(model, expected_classes):
        assert model is not None
        assert len(model.classes_) == expected_classes

    def testIntegerClassifierModelCreatedSuccessfully(self):
        genomes = self.initializeServicesAndCreateGenomes('WNT_ERK_crosstalk.octave', SupportedFileTypes.OCTAVE,
                                                          SupportedThirdPartyResponses.INTEGER)
        third_party_result = self.getThirdPartyResult()

        svm_trainer = SupportVectorMachineTrainer(genomes[1], third_party_result)
        svm_result = svm_trainer.trainSupportVectorMachine(SupportedKernelFunctionTypes.RADIAL_BASIS_FUNCTION, 0.7)

        self.assertModelTrainedSuccessfully(svm_result[0], 2)
