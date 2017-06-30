#TODO: Get this up and running.
import unittest
from FileProcessingService import FileProcessingService
from SupportedFileTypes import SupportedFileTypes
from pyramid import testing


class FileProcessingServiceIT(unittest.TestCase):

    def setUp(self):
        fileProcessingService = FileProcessingService("file", SupportedFileTypes.MATLAB)
        self.config = testing.setUp()

    def tearDown(self):
        testing.tearDown()

    def testOctaveFile(self):
        print("Testing permutations of genomes as Octave files are successfully generated.")
        with testing.testConfig() as config:
            file = config.add_route('Testing', '/SampleDataFiles/BIOMD0000000149_M.txt')
            fileParsingService = FileProcessingService(file, SupportedFileTypes.MATLAB, 10)
            genome_permutations = fileParsingService.extractGenomePermutations()
            assert len(genome_permutations) > 0
