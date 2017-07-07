from FileProcessingService import FileProcessingService
import os

class Sim1FileProcessingService(FileProcessingService):
    def __init__(self,u_file_instance,file_type,r_trials,path = os.getcwd()):
        FileProcessingService.__init__(self,u_file_instance,file_type,r_trials,path = os.getcwd()) #Note r_trials is analogous to permutations

    def getRValue(self):
        return self.permutations

    def SIM1_HandleMATLABOrOctave(self):
        trial_file_list = []
        path = self.maybeCreateNewFileDirectory()
        genome_call_file = open(path + '/GenomeCallFile.m', 'w') #Will contain the R .m files

        for trial in range(1, self.permutations + 1): #note - permutations refers to R now, not K
            family_coefs = []
            trial_name = 'trial' + str(trial)  # Note - T
            new_m_file = open(path + "/" + trial_name + ".m", "w") #
            trial_file_list.append(trial_name + ".m") #Writing file name to python list
            genome_call_file.write(trial_name + "\n") #Writing filename to GenomeCall File

            for line in self.data_file.readlines():
                if line[0] == '%':
                    new_m_file.write(line)
                    continue
                search_result = self.IDENTIFIER_REGEX.search(line)
                if search_result is not None:
                    target_sequence = line[(search_result.regs[0][0] + 1):(search_result.regs[0][1] - 1)]
                    distribution = self.extractDistributionName(target_sequence)
                    params = self.extractParameters(target_sequence)
                    coefficient_value = self.retrieveCoefficientValueFromDistribution(distribution, params)
                    # Replace $stuff$ with extracted coefficient value, write to file
                    new_line = self.IDENTIFIER_REGEX.sub(str(coefficient_value), line)
                    new_m_file.write(new_line)
                    family_coefs.append(coefficient_value)
                else:
                    new_m_file.write(line)
            new_m_file.close()

            self.data_file.seek(0)
        genome_call_file.close()
        return trial_file_list

Sim1File = open('sim1/run_simulation_readGenome.m.u','r')
R = 10
path = os.getcwd()
Sim1fps = Sim1FileProcessingService(Sim1File, 'm', R,path)
print(Sim1fps.getRValue())
