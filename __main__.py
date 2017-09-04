import logging
import sys

from sklearn import svm
from FileProcessingService import FileProcessingService
from RandomForest.RandomForestTrainer import RandomForestTrainer
from Sim1FileProcessingService import Sim1FileProcessingService
from ThirdPartyProgramCaller import ThirdPartyProgramCaller
from MatrixService import MatrixService

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
        createAndAnalyzeGenomes(file_extension, input_file, path, number_of_genomes)
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
        createAndAnalyzeGenomes(file_extension, input_file, path, permutations)
    elif simulation_as_int == 1:
        input_file = recursivelyPromptUser("Enter path of input file:\n", str)
        file_extension = input_file.split(".")[1]
        permutations = recursivelyPromptUser("Enter number of genomes (K) as an integer:\n", int)
        number_of_trials = recursivelyPromptUser("Enter number of trials for each genome (R) as an integer:\n", int)
        path = recursivelyPromptUser("Enter path of output folder (must not be root directory):\n", str)
        createSimilarityScoresBetweenPermutationsOfGenomes(file_extension, input_file, path, permutations, number_of_trials)
    elif simulation_as_string == "Q":
        return
    else:
        print("Invalid command, please type 0, 1, or 'Q'.\n")
        promptUserForInput()

def safeCast(val, to_type, default=None):
    try:
        return to_type(val)
    except (ValueError, TypeError):
        return default

def recursivelyPromptUser(message, return_type):
    response = input(message)
    cast_response = safeCast(response, return_type)
    if cast_response is None:
        print("Invalid command, looking for an input of type %.\n", return_type)
        recursivelyPromptUser(message, return_type)
    else:
        return response


def createAndAnalyzeGenomes(file_extension, input_file, path, number_of_genomes):
    with open(input_file) as data_file:
        try:
            genomes = processInputFileAndCreateGenomes(data_file, file_extension,
                                                       path, number_of_genomes)
            third_party_result = callThirdPartyService(file_extension, path, genomes[0])
            log.info("Result of differential equation analysis %s", third_party_result)

            random_forest_model = trainRandomForestClassifier(genomes, third_party_result, 0.7)
            log.info("Random Forest Model successfully created based off of %s features", random_forest_model.n_features_)
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
    return third_party_caller_service.callThirdPartyProgram(True)

def trainRandomForestClassifier(genomes, third_party_result, percent_train):
    random_forest_trainer = RandomForestTrainer(genomes[1], third_party_result)
    return random_forest_trainer.trainRandomForest(percent_train)


def createSimilarityScoresBetweenPermutationsOfGenomes(file_extension, input_file, path,
                                                       number_of_genomes, number_of_trials):
    with open(input_file) as data_file:
        try:
            trial_files = createTrialFiles(data_file, file_extension, number_of_genomes, number_of_trials, path)
            third_party_program_output = runGenomeSimulations(file_extension, trial_files, path)
            matrices = generateMatrices(number_of_genomes, number_of_trials, third_party_program_output)
            trainSVMClassifier(number_of_genomes, matrices[0])
        except ValueError as valueError:
            log.error(valueError)
        finally:
            log.debug("Closing file %s", input_file)
            data_file.close()


def createTrialFiles(data_file, file_extension, number_of_genomes, number_of_trials, path):
    process_trial_files = Sim1FileProcessingService(data_file, file_extension, number_of_genomes,
                                                    number_of_trials, path)
    trial_files = process_trial_files.createTrialFiles()
    log.info("Trial Files: %s\n", trial_files)
    return trial_files


def runGenomeSimulations(file_extension, trial_files, path):
    third_party_caller_service = ThirdPartyProgramCaller(path, file_extension, trial_files)
    return third_party_caller_service.callThirdPartyProgram(False)


def generateMatrices(number_of_genomes, number_of_trials, third_party_program_output):
    matrix_service = MatrixService(third_party_program_output, number_of_genomes, number_of_trials)
    genomes_by_trial_matrix = matrix_service.generateGenomesByTrialMatrix()
    log.info("Successfully created genomes by trial matrix: %s\n", genomes_by_trial_matrix)

    kernel_matrix = matrix_service.generateSimilarityMatrix()
    log.info("Successfully created kernel similarity matrix: %s\n", kernel_matrix)

    return genomes_by_trial_matrix, kernel_matrix


def trainSVMClassifier(number_of_genomes, similarity_matrix):
    # As this grows we may want to consider extracting this to a service.
    classifier_model = svm.SVC()
    sample_labels = []
    for label in range(0, int(number_of_genomes)):
        sample_labels.append("feature" + str(label))
    classifier_model.fit(similarity_matrix, sample_labels)
    log.info("Successful creation of classifier model: %s\n", classifier_model)

if __name__ == "__main__":
    main()
