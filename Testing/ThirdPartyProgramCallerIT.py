import logging
import os
import shutil
import unittest

from FileProcessingService import FileProcessingService
from SupportedFileTypes import SupportedFileTypes
from SupportedThirdPartyResponses import SupportedThirdPartyResponses
from ThirdPartyProgramCaller import ThirdPartyProgramCaller


class ThirdPartyProgramCallerIT(unittest.TestCase):

    log = logging.getLogger(__name__)
    log.setLevel(logging.INFO)

    number_of_genomes = 10

    def setUp(self):
        self.current_working_dir = os.getcwd()

    def tearDown(self):
        if self.generated_folder != "/" and os.path.isdir(self.generated_folder):
            shutil.rmtree(self.generated_folder)

    def initializeServicesAndCreateGenomes(self, file_name, file_type, expected_response_type):
        data_file = self.setTargetFile('SampleDataFiles', file_name)
        file_processing_service = FileProcessingService(data_file, file_type, self.number_of_genomes,
                                                        self.current_working_dir)
        self.generated_folder = self.current_working_dir + file_processing_service.GENERATED_FOLDER_NAME
        genomes_created = file_processing_service.createGenomes()
        file_processing_service.data_file.close()
        self.thirdPartyProgramCaller = ThirdPartyProgramCaller(self.current_working_dir, file_type, genomes_created[0],
                                                               expected_response_type, self.number_of_genomes)

    def setTargetFile(self, path_name, file_name):
        resource_path = '/'.join((path_name, file_name))
        return open(resource_path)

    def assertThirdPartyProgramCallerResults(self, simulation_result, expected_response_type):
        assert len(simulation_result) == self.number_of_genomes
        for genome_result in simulation_result.values():
            assert type(genome_result) is expected_response_type

        # Check directory successfully set back to original
        assert os.path.isdir(self.current_working_dir)
        created_files = [file for file in os.listdir(self.generated_folder)]
        # Check files successfully written
        assert len(created_files) == (self.number_of_genomes * 2) + 2

        output_folder = self.thirdPartyProgramCaller.OUTPUT_FOLDER_NAME
        simulation_outputs = [file for file in os.listdir(self.generated_folder + output_folder)]
        outputSIM0 = self.thirdPartyProgramCaller.SIM0OUTPUT_FILE_NAME + ".csv"
        outputSIM1 = self.thirdPartyProgramCaller.SIM1OUTPUT_FILE_NAME + ".csv"
        assert len([file for file in simulation_outputs if (file == outputSIM0 or file == outputSIM1)]) == 1

    def testCallOctaveAndReturnSimulationResult(self):
        expected_response_type = SupportedThirdPartyResponses.INTEGER
        self.initializeServicesAndCreateGenomes('WNT_ERK_crosstalk.octave', SupportedFileTypes.OCTAVE,
                                                expected_response_type)

        self.log.info("Testing %s genomes of .octave files successfully call Octave and return results.",
                      self.number_of_genomes)
        simulation_result = self.thirdPartyProgramCaller.callThirdPartyProgram(True)
        self.assertThirdPartyProgramCallerResults(simulation_result, expected_response_type)

    def testCallOctaveAndReturnSimulationResultForLinearProgramming(self):
        expected_response_type = SupportedThirdPartyResponses.INTEGER
        self.initializeServicesAndCreateGenomes('linearProgrammingModel.octave', SupportedFileTypes.OCTAVE,
                                                expected_response_type)

        self.log.info("Testing %s genomes of .octave files successfully call Octave and return results.",
                      self.number_of_genomes)
        simulation_result = self.thirdPartyProgramCaller.callThirdPartyProgram(True)
        self.assertThirdPartyProgramCallerResults(simulation_result, expected_response_type)

    def testCallOctaveAndReturnSimulationResultForNonIntegerResponse(self):
        expected_response_type = SupportedThirdPartyResponses.VECTOR
        self.initializeServicesAndCreateGenomes('linearProgrammingModelWithVectorResponse.octave', SupportedFileTypes.OCTAVE,
                                                expected_response_type)

        self.log.info("Testing %s genomes of .octave files successfully call Octave and return results.",
                      self.number_of_genomes)
        simulation_result = self.thirdPartyProgramCaller.callThirdPartyProgram(True)
        self.assertThirdPartyProgramCallerResults(simulation_result, expected_response_type)

    def callMATLABAndReturnSimulationResult(self):
        self.log.info("Testing %s genomes of .m files successfully call MATLAB and return results.",
                      self.number_of_genomes)
        expected_response_type = SupportedThirdPartyResponses.INTEGER
        self.initializeServicesAndCreateGenomes('rso.m', SupportedFileTypes.MATLAB,
                                                expected_response_type)

        simulation_result = self.thirdPartyProgramCaller.callThirdPartyProgram(True)
        self.assertThirdPartyProgramCallerResults(simulation_result, expected_response_type)

    def testCallRAndReturnSimulationResult(self):
        expected_response_type = SupportedThirdPartyResponses.INTEGER
        self.initializeServicesAndCreateGenomes('booleanModelTest.r.t', SupportedFileTypes.R,
                                                expected_response_type)

        self.log.info("Testing %s genomes of .m files successfully call R and return results.",
                      self.number_of_genomes)
        simulation_result = self.thirdPartyProgramCaller.callThirdPartyProgram(True)
        self.assertThirdPartyProgramCallerResults(simulation_result, expected_response_type)
