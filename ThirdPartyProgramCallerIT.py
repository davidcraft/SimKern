import unittest
from ThirdPartyProgramCaller import ThirdPartyProgramCaller
from FileProcessingService import FileProcessingService
from SupportedFileTypes import SupportedFileTypes
import os
import shutil
import logging


class ThirdPartyProgramCallerIT(unittest.TestCase):

    log = logging.getLogger(__name__)
    log.setLevel(logging.INFO)

    current_working_dir = os.getcwd()  # Should be this package.
    number_of_genomes = 10

    def setUp(self):
        data_file = self.setTargetFile('SampleDataFiles', 'WNT_ERK_crosstalk.m')

        file_processing_service = FileProcessingService(data_file, SupportedFileTypes.MATLAB,
                                                        self.number_of_genomes, self.current_working_dir)
        self.generated_folder = self.current_working_dir + file_processing_service.GENERATED_FOLDER_NAME
        genomes_created = file_processing_service.createGenomes()
        file_processing_service.data_file.close()

        self.thirdPartyProgramCaller = ThirdPartyProgramCaller(self.current_working_dir, SupportedFileTypes.MATLAB,
                                                               genomes_created[0])

    def tearDown(self):
        if self.generated_folder != "/":
            shutil.rmtree(self.generated_folder)

    def setTargetFile(self, path_name, file_name):
        resource_path = '/'.join((path_name, file_name))
        return open(resource_path)

    # def callOctaveAndReturnSimulationResult(self):
    #     self.log.info("Testing %s genomes of .m files successfully call Octave and return results.",
    #                   self.number_of_genomes)
    #     simulation_result = self.thirdPartyProgramCaller.callThirdPartyProgram(True)
    #     assert len(simulation_result) == self.number_of_genomes
    #     for genome_result in simulation_result.values():
    #         assert (genome_result == 0 or genome_result == 1)
    #
    #     # Check directory successfully set back to original
    #     assert os.path.isdir(self.current_working_dir)
    #     created_files = [file for file in os.listdir(self.generated_folder)]
    #
    #     # Check files successfully written
    #     assert len(created_files) == (self.number_of_genomes * 2) + 1
    #     assert len([file for file in created_files if file == self.thirdPartyProgramCaller.OUTPUT_FILE_NAME]) == 1

    # TODO: test using R and MATLAB

    def callMATLABAndReturnSimulationResult(self):
        self.log.info("Testing %s genomes of .m files sucessfully call MATLAB and return results.",self.number_of_genomes)
        simulation_result = self.thirdPartyProgramCaller.callThirdPartyProgram(True)
        assert len(simulation_result) == self.number_of_genomes
        for genome_result in simulation_result.values():
            assert (genome_result == 0 or genome_result == 1)

        #Check directory sucessfully set back to original
        assert os.path.isdir(self.current_working_dir)
        created_files = [file for file in os.listdir(self.generated_folder)]

        #Check files sucessfully written
        assert len(created_files) == (self.number_of_genomes * 2) + 1
        assert len([file for file in created_files if file == self.thirdPartyProgramCaller.OUTPUT_FILE_NAME]) == 1



