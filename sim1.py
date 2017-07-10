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
        sim1FileProcessor.SIM1_HandleMATLABOrOctave()
        programCaller = ThirdPartyProgramCaller(self.path, "m")

        programCaller.callOctave(programCaller.files_directory+"/GenomeFiles", "TrialCallFile.m") #Change TrialCallFile

    def create