#TODO: Get this up and running.
import unittest
from FileParsingService import FileParsingService
from SupportedFileTypes import SupportedFileTypes
from pyramid import testing


class FileParsingServiceIT(unittest.TestCase):

    def setUp(self):
        from FileParsingService import FileParsingService
        fileParsingService = FileParsingService("file", SupportedFileTypes.MATLAB)
        self.config = testing.setUp()

    def tearDown(self):
        testing.tearDown()

    def testOctaveFile(self):
        print("Testing permutations of genomes as Octave files are successfully generated.")
        with testing.testConfig() as config:
            file = config.add_route('Testing', '/SampleDataFiles/BIOMD0000000149_M.txt')
            fileParsingService = FileParsingService(file, SupportedFileTypes.MATLAB, 10)
            genome_permutations = fileParsingService.extractGenomePermutations()
            assert len(genome_permutations) > 0