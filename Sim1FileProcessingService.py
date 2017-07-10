from FileProcessingService import FileProcessingService
from SupportedFileTypes import SupportedFileTypes
import os
import re


class Sim1FileProcessingService(FileProcessingService):

    GENOMES_KEY_FILE_REGEX = re.compile(r'genome(\d*)?')

    def __init__(self, u_file_instance, file_type, k_genomes, r_trials, path=os.getcwd()):
        self.number_of_trials = int(r_trials)
        # Note r_trials is analogous to permutations
        FileProcessingService.__init__(self, u_file_instance, file_type, k_genomes, path)

    def createTrialFiles(self):
        if self.file_type == SupportedFileTypes.MATLAB:
            return self.SIM1_HandleMATLABOrOctave()
        elif self.file_type == SupportedFileTypes.TXT:
            pass

    def getRValue(self):
        return self.number_of_genomes

    def SIM1_HandleMATLABOrOctave(self):
        '''
        Creates r_trials .m files with $distribution(a,b),name=x$ replaced with values
        Also creates TrialCallFile, which calls each of the R generated .m values
        :return: list of trial names
        '''
        trial_file_list = []
        path = self.maybeCreateNewFileDirectory()
        genome_call_file = open(path + '/TrialCallFile.m', 'w') #Will contain the R .m files

        for trial in range(1, self.number_of_trials + 1):
            for genome in range(1, self.number_of_genomes + 1):
                family_coefs = []
                trial_name = 'trial' + str(trial)  # Note - T
                genome_name = 'genome' + str(genome)
                new_m_file = open(path + "/" + trial_name + "_" + genome_name + ".m", "w") #
                trial_file_list.append(trial_name + "_" + genome_name + ".m") #Writing file name to python list
                genome_call_file.write(trial_name + "_" + genome_name + "\n") #Writing filename to GenomeCall File

                for line in self.data_file.readlines():
                    if line[0] == '%':
                        new_m_file.write(line)
                        continue
                    search_result_for_distribution = self.IDENTIFIER_REGEX.search(line)
                    search_result_for_genomes_file = self.GENOMES_KEY_FILE_REGEX.search(line)
                    if search_result_for_distribution is not None:
                        target_sequence = line[(search_result_for_distribution.regs[0][0] + 1):
                                               (search_result_for_distribution.regs[0][1] - 1)]
                        distribution = self.extractDistributionName(target_sequence)
                        params = self.extractParameters(target_sequence)
                        coefficient_value = self.retrieveCoefficientValueFromDistribution(distribution, params)
                        # Replace $stuff$ with extracted coefficient value, write to file
                        new_line = self.IDENTIFIER_REGEX.sub(str(coefficient_value), line)
                        new_m_file.write(new_line)
                        family_coefs.append(coefficient_value)
                    elif search_result_for_genomes_file is not None:
                        new_line = self.GENOMES_KEY_FILE_REGEX.sub(genome_name + "_key", line)
                        new_m_file.write(new_line)
                    else:
                        new_m_file.write(line)
                new_m_file.close()
                self.data_file.seek(0)
        genome_call_file.close()
        return trial_file_list
#
# Sim1File = open('sim1/run_simulation_readGenome.m.u','r')
# R = 10
# path = os.getcwd()
# Sim1fps = Sim1FileProcessingService(Sim1File, 'm', R,path)
# Sim1fps.SIM1_createTrialFiles()
# print(Sim1fps.getRValue())
