import unittest
from ThirdPartyProgramCaller import ThirdPartyProgramCaller
from FileProcessingService import FileProcessingService
from SupportedFileTypes import SupportedFileTypes
import pkg_resources
import os
import shutil
import logging

class ThirdPartyProgramCallerIT(unittest.TestCase):

    log = logging.getLogger(__name__)
    log.setLevel(logging.INFO)

    current_working_dir = os.getcwd() # Should be this package.
    permutations = 10

    def setUp(self):
        resource_path = '/'.join(('SampleDataFiles', 'WNT_ERK_crosstalk.m'))
        data_file = pkg_resources.resource_stream(__package__, resource_path)

        file_processing_service = FileProcessingService(data_file, SupportedFileTypes.MATLAB,
                                                        self.permutations, self.current_working_dir)
        self.generated_folder = self.current_working_dir + file_processing_service.GENERATED_FOLDER_NAME
        file_processing_service.createGenomePermutations()

        self.thirdPartyProgramCaller = ThirdPartyProgramCaller(self.current_working_dir, SupportedFileTypes.MATLAB)

    def tearDown(self):
        if self.generated_folder != "/":
            shutil.rmtree(self.generated_folder)

    def callOctaveAndReturnSimulationResult(self):
        self.log.info("Testing %s permutations of .m files successfully call Octave and return results.",
                      self.permutations)
        simulation_result = self.thirdPartyProgramCaller.callThirdPartyProgram()
        assert len(simulation_result) == self.permutations
        for genome_result in simulation_result:
            assert (genome_result == 0 or genome_result == 1)

        # Check directory successfully set back to original
        assert os.path.isdir(self.current_working_dir)
        created_files = [file for file in os.listdir(self.generated_folder)]

        # Check files successfully written
        assert len(created_files) == (self.permutations * 2) + 2
        assert len([file for file in created_files if file == self.thirdPartyProgramCaller.OUTPUT_FILE_NAME]) == 1
