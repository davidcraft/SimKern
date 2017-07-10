from Sim1FileProcessingService import Sim1FileProcessingService
from ThirdPartyProgramCaller import ThirdPartyProgramCaller
import os

class sim1(object):

    def __init__(self, data_file, file_type, number_of_genomes, trials, path=os.getcwd()):
        self.data_file = data_file
        self.file_type = file_type
        self.number_of_genomes = int(number_of_genomes)
        self.trials = int(trials)
        self.path = path

    def generateSimilarityMatrix(self):

        sim1FileProcessor = Sim1FileProcessingService(self.data_file, self.file_type, self.number_of_genomes, self.trials)
        file_list=sim1FileProcessor.createTrialFiles()
        programCaller = ThirdPartyProgramCaller(self.path, "m", file_list)
        responses=programCaller.getSim1Responses()
        responses=self.generateResponseMatrix(responses)

    def generateResponseMatrix(self, response_list):
        responses=range(self.number_of_genomes)
        for genome in self.number_of_genomes:
            responses[genome-1]=[]
        pos=0
        for trial in self.trials:
            for genome in self.number_of_genomes:
                responses[genome-1].append(response_list[pos])
                pos=pos+1