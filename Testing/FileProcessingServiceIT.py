import unittest

from FileProcessingService import FileProcessingService
from Sim1FileProcessingService import Sim1FileProcessingService
from SupportedFileTypes import SupportedFileTypes
import unittest
import pkg_resources
import os
import shutil
import logging
import re

class FileProcessingServiceIT(unittest.TestCase):

    log = logging.getLogger(__name__)
    log.setLevel(logging.INFO)

    current_working_dir = os.getcwd()  # Should be this package.

    def setUp(self):
        data_file = self.setTargetFile('SampleDataFiles', 'WNT_ERK_crosstalk.m')

        self.file_processing_service = FileProcessingService(data_file, SupportedFileTypes.MATLAB,
                                                             10, self.current_working_dir)
        self.generated_folder = self.current_working_dir + self.file_processing_service.GENERATED_FOLDER_NAME

        data_file_for_sim1 = self.setTargetFile('SampleDataFiles', 'run_simulation_readGenome.m.u')
        self.sim1FileProcessingService = Sim1FileProcessingService(data_file, SupportedFileTypes.MATLAB, 10, 5,
                                                                   self.current_working_dir)

    def tearDown(self):
        self.file_processing_service.data_file.close()
        if self.generated_folder != "/":
            shutil.rmtree(self.generated_folder)


    def setTargetFile(self, path_name, file_name):
        resource_path = '/'.join((path_name, file_name))
        return open(resource_path)


    def testMATLABGenomeFilesSuccessfullyCreated(self):
        number_of_genomes = self.file_processing_service.number_of_genomes

        self.log.info("Testing %s genomes are successfully created as MATLAB files.", number_of_genomes)

        genomes_response = self.file_processing_service.createGenomes()
        created_genome_files = genomes_response[0]
        created_genome_matrix = genomes_response[1]

        assert len(created_genome_files) == number_of_genomes

        assert os.path.isdir(self.current_working_dir)
        created_files = [file for file in os.listdir(self.generated_folder)]
        assert len(created_files) == (2 * number_of_genomes)
        assert len([file for file in created_files if re.findall(r'.*_key.*', file)]) == number_of_genomes

    def testSim1FileProcessingServiceForMATLAB(self):
        number_of_genomes = self.sim1FileProcessingService.number_of_genomes
        number_of_trials = self.sim1FileProcessingService.number_of_trials

        self.log.info("Testing %s genomes are successfully created as MATLAB files.", number_of_genomes)
        genomes_created = self.file_processing_service.createGenomes()

        trial_files_created = self.sim1FileProcessingService.createTrialFiles()

        assert len(trial_files_created) == number_of_trials * number_of_genomes

        assert os.path.isdir(self.current_working_dir)
        total_created_files = [file for file in os.listdir(self.generated_folder)]

        # 2*K files created + R*K trial files
        assert len(total_created_files) == ((2 * number_of_genomes)) + len(trial_files_created)
        assert len([file for file in total_created_files if re.findall(r'trial\d*_genome\d*.*', file)]) == len(trial_files_created)
