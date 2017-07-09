import unittest
from FileProcessingService import FileProcessingService
from SupportedFileTypes import SupportedFileTypes
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
        resource_path = '/'.join(('SampleDataFiles', 'WNT_ERK_crosstalk.m'))
        data_file = pkg_resources.resource_stream(__package__, resource_path)

        self.fileProcessingService = FileProcessingService(data_file, SupportedFileTypes.MATLAB,
                                                           10, self.current_working_dir)
        self.generated_folder = self.current_working_dir + self.fileProcessingService.GENERATED_FOLDER_NAME

    def tearDown(self):
        if self.generated_folder != "/":
            shutil.rmtree(self.generated_folder)

    def testMATLABFilesSuccessfullyCreated(self):
        permutations = self.fileProcessingService.permutations

        self.log.info("Testing %s permutations of genomes as Octave files are successfully generated.", permutations)
        genome_permutations = self.fileProcessingService.createGenomePermutations()

        assert len(genome_permutations) == permutations

        assert os.path.isdir(self.current_working_dir)
        created_files = [file for file in os.listdir(self.generated_folder)]
        assert len(created_files) == (2 * permutations) + 1
        assert len([file for file in created_files if re.findall(r'.*_key.*', file)]) == permutations

