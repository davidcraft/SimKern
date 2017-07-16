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
        number_of_genomes = arguments[1]
        path = arguments[2]
        file_extension = input_file.split(".")[1]
        createAndAnalyzeKGenomes(file_extension, input_file, path, number_of_genomes)
    elif len(arguments) == 4:
        # Sim1
        input_file = arguments[0]
        number_of_genomes = arguments[1]
        number_of_trials = arguments[2]
        path = arguments[3]
        file_extension = input_file.split(".")[1]
        createSimilarityScoresBetweenPermutationsOfGenomes(file_extension, input_file, path,
                                                           number_of_genomes, number_of_trials)
    else:
        log.warning("Program expects three arguments for SIM0: a file expressing differential equations, " +
                    "an integer representing number of genomes to create, and a path to store generated files,\n" +
                    "or four arguments for SIM1:  a file expressing differential equations, " +
                    "an integer representing number of genomes to create, an integer representing number of trials "
                    "to compute, and a path to store generated files")
    return


def promptUserForInput():
    # TODO: Reprompt if non-sensible answer.
    simulation_to_run = input("-------Main Menu-------\n"
                              "Choose your simulation:\n"
                              "\t0: SIM0 - create and analyze K genomes\n"
                              "\t1: SIM1 - create similarity scores between R permutations of  K genomes\n"
                              "\tQ: Quit\n")
    simulation_as_int = safeCast(simulation_to_run, int)
    simulation_as_string = safeCast(simulation_to_run, str, "Q")
    if simulation_as_int == 0:
        input_file = recursivelyPromptUser("Enter path of input file:\n", str)
        permutations = recursivelyPromptUser("Enter number of genomes (K) as an integer:\n", int)
        path = recursivelyPromptUser("Enter path of output folder (must not be root directory):\n", str)
        file_extension = input_file.split(".")[1]
        createAndAnalyzeKGenomes(file_extension, input_file, path, permutations)
    elif simulation_as_int == 1:
        input_file = recursivelyPromptUser("Enter path of input file:\n", str)
        file_extension = input_file.split(".")[1]  # TODO: prompt if MATLAB or Octave
        permutations = recursivelyPromptUser("Enter number of genomes (K) as an integer:\n", int)
        number_of_trials = recursivelyPromptUser("Enter number of trials for each genome (R) as an integer:\n", int)
        path = recursivelyPromptUser("Enter path of output folder (must not be root directory):\n", str)
        createSimilarityScoresBetweenPermutationsOfGenomes(file_extension, input_file, path, permutations, number_of_trials)
    elif simulation_as_string == "Q":
        return
    else:
        print("Invalid command, please type 0, 1, or 'Q'.\n")
        promptUserForInput()

def recursivelyPromptUser(message, return_type):
    response = input(message)
    cast_response = safeCast(response, return_type)
    if cast_response is None:
        print("Invalid command, looking for an input of type %.\n", return_type)
        recursivelyPromptUser(message, return_type)
    else:
        return response

def safeCast(val, to_type, default=None):
    try:
        return to_type(val)
    except (ValueError, TypeError):
        return default


def createAndAnalyzeKGenomes(file_extension, input_file, path, number_of_genomes):
    with open(input_file) as data_file:
        try:
            genomes = processInputFileAndCreateGenomes(data_file, file_extension,
                                                       path, number_of_genomes)
            third_party_result = callThirdPartyService(file_extension, path, genomes[0])
        except ValueError as valueError:
            log.error(valueError)
        finally:
            log.debug("Closing file %s", input_file)
            data_file.close()


def processInputFileAndCreateGenomes(data_file, file_extension, path, number_of_genomes):
    file_parsing_service = FileProcessingService(data_file, file_extension, number_of_genomes, path)
    return file_parsing_service.createGenomes()


def callThirdPartyService(file_extension, path, file_list):
    third_party_caller_service = ThirdPartyProgramCaller(path, file_extension, file_list)
    return third_party_caller_service.callThirdPartyProgram()


def createSimilarityScoresBetweenPermutationsOfGenomes(file_extension, input_file, path,
                                                       number_of_genomes, number_of_trials):
    with open(input_file) as data_file:
        try:
            trial_files = createTrialFiles(data_file, file_extension, number_of_genomes, number_of_trials, path)
            simulations = runAllGenomesAndCreateMatrix(file_extension, trial_files, path)
            log.debug("Trial Files %s", trial_files)
        except ValueError as valueError:
            log.error(valueError)
        finally:
            log.debug("Closing file %s", input_file)
            data_file.close()


#Begin SIM1 using Octave: --> #TODO - Maybe incorporate these into SIM1
def createTrialFiles(data_file, file_extension, number_of_genomes, number_of_trials, path):
    process_trial_files = Sim1FileProcessingService(data_file, file_extension, number_of_genomes,
                                                    number_of_trials, path)
    return process_trial_files.createTrialFiles()


def runAllGenomesAndCreateMatrix(file_extension, trial_files, path):
    output_matrix = []
    third_party_caller_service = ThirdPartyProgramCaller(path, file_extension, trial_files)
    third_party_caller_service.callThirdPartyProgram()
    return output_matrix

if __name__ == "__main__":
    main()
