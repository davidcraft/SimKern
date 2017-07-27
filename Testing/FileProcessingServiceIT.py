import logging
import os
import re
import shutil
import unittest

from FileProcessingService import FileProcessingService
from Sim1FileProcessingService import Sim1FileProcessingService
from SupportedFileTypes import SupportedFileTypes
from SupportedDistributions import SupportedDistributions


class FileProcessingServiceIT(unittest.TestCase):

    log = logging.getLogger(__name__)
    log.setLevel(logging.INFO)

    def setUp(self):
        self.current_working_dir = os.getcwd()  # Should be this package.

    def tearDown(self):
        if self.file_processing_service:
            self.file_processing_service.data_file.close()
        if self.generated_folder != "/" and os.path.isdir(self.generated_folder):
            shutil.rmtree(self.generated_folder)

    def setupFileProcessingService(self, data_file, file_type):
        self.file_processing_service = FileProcessingService(data_file, file_type, 10, self.current_working_dir)
        self.generated_folder = self.current_working_dir + self.file_processing_service.GENERATED_FOLDER_NAME

    def setupFileProcessingServiceForSim1(self, data_file, file_type):
        self.sim1FileProcessingService = Sim1FileProcessingService(data_file, file_type, 10, 5, self.current_working_dir)

    def setTargetFile(self, path_name, file_name):
        resource_path = '/'.join((path_name, file_name))
        return open(resource_path)


    def testOctaveGenomeFilesSuccessfullyCreated(self):
        data_file = self.setTargetFile('SampleDataFiles', 'WNT_ERK_crosstalk.octave')
        self.setupFileProcessingService(data_file, SupportedFileTypes.OCTAVE)
        self.assertGenomeFilesCreatedSuccessfully(SupportedFileTypes.OCTAVE)

    # TODO: test for MATLAB

    def testRGenomeFilesSuccessfullyCreated(self):
        # Note: This is R the program, not R an integer representing permutations.
        data_file = self.setTargetFile('SampleDataFiles', 'booleanModel.r.t')
        self.setupFileProcessingService(data_file, SupportedFileTypes.R)
        self.assertGenomeFilesCreatedSuccessfully(SupportedFileTypes.R)

    def assertGenomeFilesCreatedSuccessfully(self, file_type):
        number_of_genomes = self.file_processing_service.number_of_genomes
        self.log.info("Testing %s genomes are successfully created as %s files.", number_of_genomes, file_type)

        genomes_response = self.file_processing_service.createGenomes()
        created_genome_files = genomes_response[0]
        assert len(created_genome_files) == number_of_genomes
        assert os.path.isdir(self.current_working_dir)
        created_files = [file for file in os.listdir(self.generated_folder)]
        assert len(created_files) == (2 * number_of_genomes)
        assert len([file for file in created_files if re.findall(r'.*_key.*', file)]) == number_of_genomes
        assert len([file for file in created_files if re.findall(r'' + file_type + '', file)]) == (2 * number_of_genomes)

    def testSim1FileProcessingServiceForOctave(self):
        data_file = self.setTargetFile('SampleDataFiles', 'WNT_ERK_crosstalk.octave')
        self.setupFileProcessingService(data_file, SupportedFileTypes.MATLAB)

        data_file_for_sim1 = self.setTargetFile('SampleDataFiles', 'run_simulation_readGenome.octave.u')
        self.setupFileProcessingServiceForSim1(data_file_for_sim1, SupportedFileTypes.OCTAVE)

        number_of_genomes = self.sim1FileProcessingService.number_of_genomes
        number_of_trials = self.sim1FileProcessingService.number_of_trials

        self.log.info("Testing %s genomes are successfully created as Octave files.", number_of_genomes)
        self.file_processing_service.createGenomes()

        self.assertSim1TrialFilesSuccessfullyCreated(number_of_genomes, number_of_trials)

    # TODO: Test for MATLAB

    def testSim1FileProcessingServiceForR(self):
        data_file = self.setTargetFile('SampleDataFiles', 'booleanModel.r.t')
        self.setupFileProcessingService(data_file, SupportedFileTypes.R)

        data_file_for_sim1 = self.setTargetFile('SampleDataFiles', 'booleanTest.r.u')
        self.setupFileProcessingServiceForSim1(data_file_for_sim1, SupportedFileTypes.R)

        number_of_genomes = self.sim1FileProcessingService.number_of_genomes
        number_of_trials = self.sim1FileProcessingService.number_of_trials

        self.log.info("Testing %s genomes are successfully created as R files.", number_of_genomes)
        self.file_processing_service.createGenomes()

        self.assertSim1TrialFilesSuccessfullyCreated(number_of_genomes, number_of_trials)

    def assertSim1TrialFilesSuccessfullyCreated(self, number_of_genomes, number_of_trials):
        trial_files_created = self.sim1FileProcessingService.createTrialFiles()
        assert len(trial_files_created) == number_of_trials * number_of_genomes
        assert os.path.isdir(self.current_working_dir)
        total_created_files = [file for file in os.listdir(self.generated_folder)]
        # 2*K files created + R*K trial files
        assert len(total_created_files) == (2 * number_of_genomes) + len(trial_files_created)
        assert len([file for file in total_created_files if re.findall(r'trial\d*_genome\d*.*', file)]) == len(
            trial_files_created)

    def testDollarSignSyntaxValuesCorrectlyExtractedForR(self):
        data_file = self.setTargetFile('SampleDataFiles', 'booleanModel.r.t')
        self.setupFileProcessingService(data_file, SupportedFileTypes.R)
        fp_service = self.file_processing_service

        line_default = 'variableOne <- $gauss(0,1),name=varOne$;'
        target_sequence_default = self.extractTargetSequenceFromLine(line_default)
        assert fp_service.extractCoefficientName(target_sequence_default) == 'varOne'
        assert fp_service.extractDistributionName(target_sequence_default) == SupportedDistributions.GAUSS
        assert fp_service.extractParameters(target_sequence_default) == ['0', '1']

        line_no_name = 'variableOne <- $gamma(0,1)$;'
        target_sequence_no_name = self.extractTargetSequenceFromLine(line_no_name)
        assert fp_service.extractCoefficientName(target_sequence_no_name) == 'coefficient1'
        assert fp_service.extractDistributionName(target_sequence_no_name) == SupportedDistributions.GAMMA
        assert fp_service.extractParameters(target_sequence_no_name) == ['0', '1']

        line_quick = 'variableOne <- $0,name=varOne$;'
        target_sequence_quick = self.extractTargetSequenceFromLine(line_quick)
        assert fp_service.extractCoefficientName(target_sequence_quick) == 'varOne'
        assert fp_service.extractDistributionName(target_sequence_quick) == SupportedDistributions.GAUSS
        assert fp_service.extractParameters(target_sequence_quick) == ['0']

        line_quick_no_name = 'variableOne <- $0$'
        target_sequence_quick_no_name = self.extractTargetSequenceFromLine(line_quick_no_name)
        assert fp_service.extractCoefficientName(target_sequence_no_name) == 'coefficient2'
        assert fp_service.extractDistributionName(target_sequence_quick_no_name) == SupportedDistributions.GAUSS
        assert fp_service.extractParameters(target_sequence_quick_no_name) == ['0']

        bool_default = '$boolean(0.5), name= B_AKT2$,'
        target_sequence_bool_default = self.extractTargetSequenceFromLine(bool_default)
        assert fp_service.extractCoefficientName(target_sequence_bool_default) == 'B_AKT2'
        assert fp_service.extractDistributionName(target_sequence_bool_default) == SupportedDistributions.BOOLEAN
        assert fp_service.extractParameters(target_sequence_bool_default) == ['0.5']

        mutate_default = '$mutate(CTNNB1, 0, .304), name= M_CTNNB1$'
        target_sequence_mutate_default = self.extractTargetSequenceFromLine(mutate_default)
        assert fp_service.extractCoefficientName(target_sequence_mutate_default) == 'M_CTNNB1'
        assert fp_service.extractDistributionName(target_sequence_mutate_default) == SupportedDistributions.MUTATE
        assert fp_service.extractParameters(target_sequence_mutate_default) == ['CTNNB1', '0', '.304']

    def testDollarSignSyntaxValuesCorrectlyExtractedForMATLAB(self):
        data_file = self.setTargetFile('SampleDataFiles', 'WNT_ERK_crosstalk.octave')
        self.setupFileProcessingService(data_file, SupportedFileTypes.MATLAB)
        fp_service = self.file_processing_service

        line_default = 'variableOne=$gauss(0,1),name=varOne$;'
        target_sequence_default = self.extractTargetSequenceFromLine(line_default)
        assert fp_service.extractCoefficientName(target_sequence_default) == 'varOne'
        assert fp_service.extractDistributionName(target_sequence_default) == SupportedDistributions.GAUSS
        assert fp_service.extractParameters(target_sequence_default) == ['0', '1']

        line_no_name = 'variableOne=$gamma(0,1)$;'
        target_sequence_no_name = self.extractTargetSequenceFromLine(line_no_name)
        assert fp_service.extractCoefficientName(target_sequence_no_name) == 'coefficient1'
        assert fp_service.extractDistributionName(target_sequence_no_name) == SupportedDistributions.GAMMA
        assert fp_service.extractParameters(target_sequence_no_name) == ['0', '1']

        line_quick = 'variableOne=$0,name=varOne$;'
        target_sequence_quick = self.extractTargetSequenceFromLine(line_quick)
        assert fp_service.extractCoefficientName(target_sequence_quick) == 'varOne'
        assert fp_service.extractDistributionName(target_sequence_quick) == SupportedDistributions.GAUSS
        assert fp_service.extractParameters(target_sequence_quick) == ['0']

        line_quick_no_name = 'variableOne=$0$'
        target_sequence_quick_no_name = self.extractTargetSequenceFromLine(line_quick_no_name)
        assert fp_service.extractCoefficientName(target_sequence_no_name) == 'coefficient2'
        assert fp_service.extractDistributionName(target_sequence_quick_no_name) == SupportedDistributions.GAUSS
        assert fp_service.extractParameters(target_sequence_quick_no_name) == ['0']

    def extractTargetSequenceFromLine(self, line):
        search_result = self.file_processing_service.IDENTIFIER_REGEX.search(line)
        assert search_result is not None
        return line[(search_result.regs[0][0] + 1):(search_result.regs[0][1] - 1)]
