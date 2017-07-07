import sys
import logging
import os
import numpy as np

from FileProcessingService import FileProcessingService
from ThirdPartyProgramCaller import ThirdPartyProgramCaller

log = logging.getLogger(__name__)
logging.basicConfig()
log.setLevel(logging.INFO)

def main():
    arguments = sys.argv[1:]
    if len(arguments) != 3:
        log.warn("Program expects three arguments, a file expressing differential equations, " +
                 "an integer representing number of permutations, and a path to store generated files.")
        return
    input_file = arguments[0]
    permutations = arguments[1]
    path = arguments[2]
    file_extension = input_file.split(".")[1]
    with open(input_file) as data_file:
        try:
            genome_permutations = processInputFileAndCreateGenomePermutations(data_file, file_extension,
                                                                              path, permutations)
            third_party_result = callThirdPartyService(file_extension, path)
        except ValueError as valueError:
            log.error(valueError.message)
        finally:
            log.debug("Closing file %s", input_file)
            data_file.close()


def callThirdPartyService(file_extension, path):
    thirdPartyCallerService = ThirdPartyProgramCaller(path, file_extension, )
    return thirdPartyCallerService.callThirdPartyProgram()


def processInputFileAndCreateGenomePermutations(data_file, file_extension, path, permutations):
    file_parsing_service = FileProcessingService(data_file, file_extension, permutations, path)
    return file_parsing_service.createGenomePermutations()

#Begin SIM1 using Octave: --> #TODO - Maybe incorporate these into SIM1
def createRTrialFilesAndGenomeCallFile(R,K): #FileProcessingServiceSim1
    f = open('sim1/run_simulation_readGenome.m.u')
    process_R_Files = FileProcessingService(f,'m',K,R,os.getcwd())
    return process_R_Files.handleRFilesForSIM1UsingMATLABOrOctave()

def runRSimulationsAndCreateOutputList(): #
    octaveCall = ThirdPartyProgramCaller(os.getcwd(),'MAT')
    outputList = octaveCall.callOctave('/GenomeFiles','/GenomeCallFile')
    return outputList

def replaceGenomeFileNamefromFiles(trialFileList):
    for trialFile in trialFileList:
        pass #TODO - Replace every appearance of a file name with an input filename

def RunAllKGenomesAndCreateMatrix(R,K):
    outputMatrix = []
    trialFileList = createAndNameRTrialFiles(R,K)
    for genome in range(K):
        outputRow = runRSimulationsAndCreateOutputList()
        replaceGenomeFileNamefromFiles(trialFileList) #TODO - pass in a list? Or smthg like a directory?
        outputMatrix.append(outputRow)
    return outputMatrix




if __name__ == "__main__":
    main()