import logging
import sys

import numpy
from FileProcessingService import FileProcessingService
from RandomForest.RandomForestTrainer import RandomForestTrainer
from SupportVectorMachine.SupportVectorMachineTrainer import SupportVectorMachineTrainer
from Sim1FileProcessingService import Sim1FileProcessingService
from SupportVectorMachine.SupportedKernelFunctionTypes import SupportedKernelFunctionTypes
from ThirdPartyProgramCaller import ThirdPartyProgramCaller
from SupportedThirdPartyResponses import SupportedThirdPartyResponses
from MatrixService import MatrixService

log = logging.getLogger(__name__)
logging.basicConfig()
log.setLevel(logging.INFO)


def main():
    arguments = sys.argv[1:]
    # TODO: Also accept third party response type as an input
    if len(arguments) == 0:
        promptUserForInput()

    elif safeCast(arguments[0], int) == 0:  # SIM0
        log.info("SIM0 genome creation requested...")
        if len(arguments) is not 4:
            log.info("Program expects 4 arguments: an integer expressing the desired action from the main menu, "
                     "a file expressing differential equations, an integer representing number of genomes to create, "
                     "and a path to store generated files\n")
            return
        input_file = arguments[1]
        number_of_genomes = arguments[2]
        path = arguments[3]
        file_extension = input_file.split(".")[1]
        log.info("Starting SIM0 genome creation K=%s genomes, from file %s, being output to %s/GenomeFiles.",
                 number_of_genomes, input_file, path)
        createGenomesSIM0(file_extension, input_file, path, number_of_genomes)

    elif safeCast(arguments[0], int) == 1:  # SIM1
        log.info("SIM1 genome creation requested...")
        if len(arguments) is not 5:
            log.info("Program expects 5 arguments: an integer expressing the desired action from the main menu, "
                     "a file expressing differential equations, an integer representing number of genomes to "
                     "create (K), another integer representing trials for each genome (R) and a path to store "
                     "generated files\n")
            return
        input_file = arguments[1]
        number_of_genomes = arguments[2]
        number_of_trials = arguments[3]
        path = arguments[4]
        file_extension = input_file.split(".")[1]
        log.info("Starting SIM1 genome creation K=%s genomes, and R=%s trials from file %s,"
                 " being output to %s/GenomeFiles.",
                 number_of_genomes, input_file, path)
        createGenomesSIM1(file_extension, input_file, path, number_of_genomes, number_of_trials)

    elif safeCast(arguments[0], int) == 2:
        log.info("Machine Learning on SIM0 data requested...")
        if len(arguments) is not 4:
            log.info("Program expects 4 arguments: an integer expressing the desired action from the main menu, "
                     "a file Sim0Output.csv file expressing the third party program results of SIM0, the accompanying "
                     "Sim0GenomesMatrix file., and 'REGRESSION' or 'CLASSIFICATION' for the type of analysis.")
            return
        output_file = arguments[1]
        genomes_matrix_file = arguments[2]
        analysis = arguments[3]
        performMachineLearningOnSIM0(output_file, genomes_matrix_file, analysis)
    elif safeCast(arguments[0], int) == 3:
        log.info("Machine Learning on SIM1 data requested...")
        if len(arguments) is not 2:
            log.info("Program expects 2 arguments: an integer expressing the desired action from the main menu, "
                     "and a file Sim0Output.csv file expressing the similarity matrix output from SIM1 simulations.")
            return
        output_file = arguments[1]
        performMachineLearningOnSIM1(output_file)
    return

def promptUserForInput():
    simulation_to_run = input("-------Main Menu-------\n"
                              "Choose your task:\n"
                              "\t0: SIM0 - create K genomes\n"
                              "\t1: SIM1 - create R permutations of K genomes\n"
                              "\t2: Perform machine learning with existing SIM0 data\n"
                              "\t3: Perform machine learning with existing SIM1 data\n"
                              "\tQ: Quit\n")
    simulation_as_int = safeCast(simulation_to_run, int)
    simulation_as_string = safeCast(simulation_to_run, str, "Q")
    if simulation_as_int == 0:
        input_file = recursivelyPromptUser("Enter path of input file:\n", str)
        permutations = recursivelyPromptUser("Enter number of genomes (K) as an integer:\n", int)
        path = recursivelyPromptUser("Enter path of output folder (must not be root directory):\n", str)
        file_extension = input_file.split(".")[1]
        createGenomesSIM0(file_extension, input_file, path, permutations)
    elif simulation_as_int == 1:
        input_file = recursivelyPromptUser("Enter path of input file:\n", str)
        file_extension = input_file.split(".")[1]
        permutations = recursivelyPromptUser("Enter number of genomes (K) as an integer:\n", int)
        number_of_trials = recursivelyPromptUser("Enter number of trials for each genome (R) as an integer:\n", int)
        path = recursivelyPromptUser("Enter path of output folder (must not be root directory):\n", str)
        createGenomesSIM1(file_extension, input_file, path, permutations, number_of_trials)
    elif simulation_as_int == 2:
        output_file = recursivelyPromptUser("Enter path of input Sim0Output.csv file:\n", str)
        genomes_matrix_file = recursivelyPromptUser("Enter path of input Sim0GenomesMatrix.csv file:\n", str)
        analysis_type = recursivelyPromptUser("Enter 'REGRESSION' or 'CLASSIFICATION' for analysis type:\n", str)
        performMachineLearningOnSIM0(output_file, genomes_matrix_file, analysis_type)
    elif simulation_as_int == 3:
        output_file = recursivelyPromptUser("Enter path of .CSV file representing the similarity matrix\n", str)
        performMachineLearningOnSIM1(output_file)
    elif simulation_as_string == "Q":
        return
    else:
        print("Invalid command, please type 0, 1, 2, 3 or 'Q'.\n")
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


def createGenomesSIM0(file_extension, input_file, path, number_of_genomes):
    with open(input_file) as data_file:
        try:
            genomes = processInputFileAndCreateGenomes(data_file, file_extension, path, number_of_genomes)
            third_party_result = callThirdPartyService(file_extension, path, genomes[0], True, number_of_genomes,
                                                       number_of_trials=0)
            log.info("Results of third party call: %s", third_party_result)
        except ValueError as valueError:
            log.error(valueError)
        finally:
            log.debug("Closing file %s", input_file)
            data_file.close()


def processInputFileAndCreateGenomes(data_file, file_extension, path, number_of_genomes):
    file_parsing_service = FileProcessingService(data_file, file_extension, number_of_genomes, path)
    return file_parsing_service.createGenomes()


def callThirdPartyService(file_extension, path, file_list, record_output, number_of_genomes, number_of_trials):
    third_party_caller_service = ThirdPartyProgramCaller(path, file_extension, file_list,
                                                         SupportedThirdPartyResponses.FLOAT, number_of_genomes,
                                                         number_of_trials)
    return third_party_caller_service.callThirdPartyProgram(record_output)


def trainRandomForestClassifier(genomes, third_party_result, percent_train):
    random_forest_trainer = RandomForestTrainer(genomes[1], third_party_result)
    return random_forest_trainer.trainRandomForestClassifier(percent_train)


def createGenomesSIM1(file_extension, input_file, path, number_of_genomes, number_of_trials):
    with open(input_file) as data_file:
        try:
            trial_files = createTrialFiles(data_file, file_extension, number_of_genomes, number_of_trials, path)
            third_party_result = callThirdPartyService(file_extension, path, trial_files, False,
                                                       number_of_genomes, number_of_trials)
            log.info("Results of third party call: %s", third_party_result)
        except ValueError as valueError:
            log.error(valueError)
        finally:
            log.debug("Closing file %s", input_file)
            data_file.close()


def createTrialFiles(data_file, file_extension, number_of_genomes, number_of_trials, path):
    process_trial_files = Sim1FileProcessingService(data_file, file_extension, number_of_genomes,
                                                    number_of_trials, path)
    trial_files = process_trial_files.createTrialFiles()
    # log.info("Trial Files: %s\n", trial_files)
    log.info("Created all the trial files")
    return trial_files


def generateMatrices(number_of_genomes, number_of_trials, third_party_program_output):
    matrix_service = MatrixService(third_party_program_output, number_of_genomes, number_of_trials)
    genomes_by_trial_matrix = matrix_service.generateIndexMatrix()
    log.info("Successfully created genomes by trial matrix: %s\n", genomes_by_trial_matrix)

    kernel_matrix = matrix_service.generateSimilarityMatrix()
    log.info("Successfully created kernel similarity matrix: %s\n", kernel_matrix)

    return genomes_by_trial_matrix, kernel_matrix


def trainSim1SVMClassifier(number_of_genomes, matrices):
    trials_by_genome_SVM_trainer = SupportVectorMachineTrainer(matrices[1], None)
    return trials_by_genome_SVM_trainer.trainSupportVectorMachineForSIM1(number_of_genomes)


def performMachineLearningOnSIM0(output_file, genomes_matrix_file, analysis_type):
    responses = readCSVFile(output_file)
    matrix = readCSVFile(genomes_matrix_file)

    num_permutations = 10
    training_percent = .5

    num_examples = len(matrix)
    num_genomes = len(matrix[0])
    which = numpy.arange(num_genomes)
    results = []
    for i in range(0, num_permutations):
        order = numpy.random.permutation(num_examples)
        new_matrix = matrix[order[:, None], which].tolist()
        new_responses = responses[order].tolist()

        # TODO: Refactor these trainers so they don't need to be re-instantiated with each new permutation
        rf_trainer = RandomForestTrainer(new_matrix, new_responses)

        if analysis_type == 'REGRESSION':  # TODO: Make this an enum maybe?
            rf_results = rf_trainer.trainRandomForestRegressor(training_percent)
            results += rf_results[1]
        else:
            rf_results = rf_trainer.trainRandomForestClassifier(training_percent)
            # TODO: Verify this is indeed the similarity matrix we're passing in here.
            svm_trainer = SupportVectorMachineTrainer(new_matrix, new_responses)
            svm_results = svm_trainer.trainSupportVectorMachine(SupportedKernelFunctionTypes.RADIAL_BASIS_FUNCTION,
                                                                training_percent)
            results += rf_results[1] + svm_results[1]

    if analysis_type == 'REGRESSION':
        results = numpy.array(results).reshape((num_permutations, 3))
    else:
        results = numpy.array(results).reshape((num_permutations, 6))
    results = numpy.mean(results, axis=0)

    print("Final Accuracies:", results.tolist(), training_percent, num_permutations)


def performMachineLearningOnSIM1(output_file):
    similarity_matrix = readCSVFile(output_file)
    trials_by_genome_SVM_trainer = SupportVectorMachineTrainer(similarity_matrix, None)
    trials_by_genome_SVM_trainer.trainSupportVectorMachineForSIM1(len(similarity_matrix))


def readCSVFile(file):
    return numpy.loadtxt(open(file, "rb"), delimiter=",")


if __name__ == "__main__":
    main()
