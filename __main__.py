import logging
import sys

from FileProcessingService import FileProcessingService
from Sim1FileProcessingService import Sim1FileProcessingService
from ThirdPartyProgramCaller import ThirdPartyProgramCaller

log = logging.getLogger(__name__)
logging.basicConfig()
log.setLevel(logging.INFO)

def main():
    arguments = sys.argv[1:]
    if len(arguments) == 0:
        promptUserForInput()

    elif len(arguments) == 3:
        # Sim0
        input_file = arguments[0]
        permutations = arguments[1]
        path = arguments[2]
        file_extension = input_file.split(".")[1]
        createAndAnalyzeKGenomes(file_extension, input_file, path, permutations)
    elif len(arguments) == 4:
        # Sim1
        input_file = arguments[0]
        permutations = arguments[1]  # raw_input("Enter number of permutations (K):\n") # arguments[1]
        big_r = arguments[2]
        path = arguments[3]  # raw_input("Enter path of output folder:\n") #arguments[2]
        file_extension = input_file.split(".")[1]
        createSimilarityScoresBetweenPermutationsOfGenomes(file_extension, input_file, path, permutations, big_r)
    else:
        log.warn("Program expects three arguments for SIM0: a file expressing differential equations, " +
                 "an integer representing number of genomes to create, and a path to store generated files,\n" +
                 "or four arguments for SIM1:  a file expressing differential equations, " +
                 "an integer representing number of genomes to create, an integer representing number of permutations "
                 "to compute, and a path to store generated files")
    return


def promptUserForInput():
    simulation_to_run = raw_input("-------Main Menu-------\n"
                                  "Choose your simulation:\n"
                                  "\t0: SIM0 - create and analyze K genomes\n"
                                  "\t1: SIM1 - create similarity scores between R permutations of  K genomes\n"
                                  "\tQ: Quit\n")
    simulation_as_int = safe_cast(simulation_to_run, int)
    simulation_as_string = safe_cast(simulation_to_run, str, "Q")
    if simulation_as_int == 0:
        input_file = raw_input("Enter path of input file:\n")
        permutations = int(raw_input("Enter number of genomes (K) as an integer:\n"))
        path = raw_input("Enter path of output folder (must not be root directory):\n")
        file_extension = input_file.split(".")[1]
        createAndAnalyzeKGenomes(file_extension, input_file, path, permutations)
    elif simulation_as_int == 1:
        input_file = raw_input("Enter path of input file:\n")
        permutations = int(raw_input("Enter number of genomes (K) as an integer:\n"))
        big_r = int(raw_input("Enter number of permutation for each genome (R) as an integer:\n"))
        path = raw_input("Enter path of output folder (must not be root directory):\n")
        file_extension = input_file.split(".")[1]
        createSimilarityScoresBetweenPermutationsOfGenomes(file_extension, input_file, path, permutations, big_r)
    elif simulation_as_string == "Q":
        return


def safe_cast(val, to_type, default=None):
    try:
        return to_type(val)
    except (ValueError, TypeError):
        return default


def createAndAnalyzeKGenomes(file_extension, input_file, path, permutations):
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

# Sim0 file parser:
def processInputFileAndCreateGenomePermutations(data_file, file_extension, path, permutations):
    file_parsing_service = FileProcessingService(data_file, file_extension, permutations, path)
    return file_parsing_service.createGenomePermutations()

def callThirdPartyService(file_extension, path):
    thirdPartyCallerService = ThirdPartyProgramCaller(path, file_extension)
    return thirdPartyCallerService.callThirdPartyProgram()


def createSimilarityScoresBetweenPermutationsOfGenomes(file_extension, input_file, path, permutations, big_r):
    with open(input_file) as data_file:
        try:
            trial_files = createRTrialFilesAndGenomeCallFile(data_file, file_extension, permutations, big_r, path)
            simulations = runAllKGenomesAndCreateMatrix(data_file, file_extension, permutations, big_r, path)
            print(trial_files)
        except ValueError as valueError:
            log.error(valueError.message)
        finally:
            log.debug("Closing file %s", input_file)
            data_file.close()


#Begin SIM1 using Octave: --> #TODO - Maybe incorporate these into SIM1
def createRTrialFilesAndGenomeCallFile(data_file, file_extension, permutations, big_r, path): #FileProcessingServiceSim1
    f = open('sim1/run_simulation_readGenome.m.u')
    process_R_Files = Sim1FileProcessingService(data_file, file_extension, big_r, path)
    return process_R_Files.SIM1_createTrialFiles()


def runAllKGenomesAndCreateMatrix(data_file, file_extension, permutations, big_r, path):
    outputMatrix = []
    trialFileList = createAndNameRTrialFiles(big_r, permutations)
    for genome in range(permutations):
        outputRow = runRSimulationsAndCreateOutputList()
        replaceGenomeFileNamefromFiles(trialFileList) #TODO - pass in a list? Or smthg like a directory?
        outputMatrix.append(outputRow)
    return outputMatrix


def createAndNameRTrialFiles(R, K):
    return []


def runRSimulationsAndCreateOutputList(path, file_extension): #
    octaveCall = ThirdPartyProgramCaller(path, file_extension)
    outputList = octaveCall.callOctave('/GenomeFiles', '/TrialCallFile')
    return outputList


def replaceGenomeFileNamefromFiles(trialFileList):
    for trialFile in trialFileList:
        pass #TODO - Replace every appearance of a file name with an input filename


if __name__ == "__main__":
    main()
