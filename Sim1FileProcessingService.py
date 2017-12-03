from FileProcessingService import FileProcessingService
from SupportedFileTypes import SupportedFileTypes
import os
import re
import collections

from Utilities.SafeCastUtil import SafeCastUtil


class Sim1FileProcessingService(FileProcessingService):

    GENOMES_KEY_FILE_REGEX = re.compile(r'genome(\d+)?')
    DEFAULT_NUM_TRIALS = 100

    def __init__(self, u_file_instance, file_type, number_of_genomes, number_of_trials, path=os.getcwd()):
        self.number_of_trials = SafeCastUtil.safeCast(number_of_trials, int, self.DEFAULT_NUM_TRIALS)
        # Note r_trials is analogous to permutations
        FileProcessingService.__init__(self, u_file_instance, file_type, number_of_genomes, path)

    def createTrialFiles(self):
        if self.file_type == SupportedFileTypes.MATLAB or self.file_type == SupportedFileTypes.OCTAVE:
            return self.handleSim1FileProcessing("%")
        elif self.file_type == SupportedFileTypes.R:
            return self.handleSim1FileProcessing("#")

    def handleSim1FileProcessing(self, comment_character):
        '''
        Creates r_trials of type self.file_type files with $distribution(a,b),name=x$ replaced with values
        Also creates TrialCallFile, which calls each of the R generated .m values
        :return: sim1_file_list --> list of names of all files created
        '''
        sim1_file_list = []
        path = self.maybeCreateNewFileDirectory()

        for trial in range(1, self.number_of_trials + 1):
            coefficient_map = collections.OrderedDict()
            trial_name = 'trial' + str(trial)  # Note - T
            new_trial_file = open(path + "/" + trial_name + "_genome1." + self.file_type, "w")
            sim1_file_list.append(trial_name + "_genome1." + self.file_type)
            for line in self.data_file.readlines():
                if line[0] == comment_character:
                    new_trial_file.write(line)
                    continue
                new_line = self.maybeGenerateNewLineAndSaveCoefficientValues(coefficient_map, line)
                new_trial_file.write(new_line)

            new_trial_file.close()
            self.data_file.seek(0)
            for genome in range(2, self.number_of_genomes + 1):
                genome_name = 'genome' + str(genome)
                new_trial_genome_file = open(path + "/" + trial_name + "_" + genome_name + "." + self.file_type, "w")
                # Writing file name to python list
                sim1_file_list.append(trial_name + "_" + genome_name + "." + self.file_type)
                trial_file = open(path + "/" + trial_name + "_genome1." + self.file_type, "r")
                for line in trial_file.readlines():
                    if line[0] == comment_character:
                        new_trial_genome_file.write(line)
                        continue
                    search_result_for_genomes_file = self.GENOMES_KEY_FILE_REGEX.search(line)
                    if search_result_for_genomes_file is not None:
                        new_line = self.GENOMES_KEY_FILE_REGEX.sub(genome_name, line)
                        new_trial_genome_file.write(new_line)
                    else:
                        new_trial_genome_file.write(line)
                new_trial_genome_file.close()
                self.data_file.seek(0)
        return sim1_file_list
