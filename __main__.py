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
from GraphingService import GraphingService

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
                     "a master SIM0 file, an integer representing number of genomes to create, "
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
                     "a master SIM1 file, an integer representing number of genomes to create (K), another "
                     "integer representing trials for each genome (R) and a path to store generated files\n")
            return
        input_file = arguments[1]
        number_of_genomes = arguments[2]
        number_of_trials = arguments[3]
        path = arguments[4]
        file_extension = input_file.split(".")[1]
        log.info("Starting SIM1 genome creation K=%s genomes, and R=%s trials from file %s,"
                 " being output to %s/GenomeFiles.",
                 number_of_genomes, number_of_trials, input_file, path)
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
        if len(arguments) is not 3:
            log.info("Program expects 3 arguments: an integer expressing the desired action from the main menu, "
                     "a file Sim0Output.csv file expressing the third party program results of SIM0,"
                     "and a Sim1SimilarityMatrix.csv file.")
            return
        output_file = arguments[1]
        similarity_matrix = arguments[2]
        performMachineLearningOnSIM1(output_file, similarity_matrix)
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
        output_file = recursivelyPromptUser("Enter path of Sim1Responses.csv file:\n", str)
        similarity_matrix = recursivelyPromptUser("Enter path of .CSV file representing the similarity matrix:\n", str)
        performMachineLearningOnSIM1(output_file, similarity_matrix)
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
            svm_trainer = SupportVectorMachineTrainer(new_matrix, new_responses)
            svm_results = svm_trainer.trainSupportVectorMachineForSIM0(SupportedKernelFunctionTypes.RADIAL_BASIS_FUNCTION,
                                                                       training_percent)
            results += rf_results[1] + svm_results[1]

    if analysis_type == 'REGRESSION':
        results = numpy.array(results).reshape((num_permutations, 3))
    else:
        results = numpy.array(results).reshape((num_permutations, 6))
    results = numpy.mean(results, axis=0)

    print("Final Accuracies:", results.tolist(), training_percent, num_permutations)


def performMachineLearningOnSIM1(output_file, similarity_matrix_file):
    training_percents = [.1, .25, .5, .75, .9]
    responses = readCSVFile(output_file)
    similarity_matrix = readCSVFile(similarity_matrix_file)
    results_by_percent_train = {}

    for training_percent in training_percents:
        accuracies_by_permutation = trainAndTestSimilarityMatrix(similarity_matrix, training_percent, responses)
        results_by_percent_train[training_percent] = accuracies_by_permutation
        log.info("Total accuracy for all rounds of matrix permutations with %s percent split: %s",
                 training_percent * 100, numpy.round(numpy.average(accuracies_by_permutation), 2))
    log.debug("Accuracies by training percent: %s", results_by_percent_train)
    plotMachineLearningResultsByPercentTrain(results_by_percent_train, similarity_matrix_file)


def readCSVFile(file):
    return numpy.loadtxt(open(file, "rb"), delimiter=",")


def trainAndTestSimilarityMatrix(similarity_matrix, training_percent, responses):
    num_genomes = len(similarity_matrix)
    total_accuracies = []
    num_permutations = 100
    num_optimizations = 10
    for permutation in range(0, num_permutations):
        most_accurate_model = None
        most_accurate_model_score = 0
        testing_set = None
        testing_matrix = None
        for hyperparameter_optimization in range(0, num_optimizations):
            order = numpy.random.permutation(num_genomes)
            train_length = int(training_percent * num_genomes)
            validation_length = int((num_genomes - train_length) / 4)  # 25% of testing set.

            training_set = order[0:train_length]
            validation_set = order[train_length: (train_length + validation_length)]
            testing_set = order[(train_length + validation_length):len(order)]

            training_matrix = MatrixService.splitSimilarityMatrixForTraining(similarity_matrix, training_set)
            validation_matrix = MatrixService.splitSimilarityMatrixForTestingAndValidation(similarity_matrix,
                                                                                           validation_set, train_length)
            testing_matrix = MatrixService.splitSimilarityMatrixForTestingAndValidation(similarity_matrix,
                                                                                        testing_set, train_length)

            trials_by_genome_SVM_trainer = SupportVectorMachineTrainer(training_matrix, responses)
            model = trials_by_genome_SVM_trainer.trainSupportVectorMachineForSIM1(training_set)
            model_score = predictAverageAccuracy(model, responses, validation_matrix, validation_set)
            if model_score <= most_accurate_model_score:
                continue
            most_accurate_model = model
            most_accurate_model_score = model_score
        average_accuracy = predictAverageAccuracy(most_accurate_model, responses, testing_matrix, testing_set)
        log.debug("Average accuracy for this round of matrix permutations: %s\n", average_accuracy)
        total_accuracies.append(average_accuracy)
    return total_accuracies


def predictAverageAccuracy(model, responses, testing_matrix, testing_set):
    if model is None:
        return 0
    predictions = model.predict(testing_matrix)
    accuracies = []
    for i in range(0, len(predictions)):
        genome = testing_set[i]
        real_response = responses[genome]
        prediction = predictions[i]
        accuracy = 0
        if real_response == prediction:
            accuracy = 1
        accuracies.append(accuracy)
        log.debug("Predicted outcome for genome %s vs actual outcome: %s vs %s", genome, prediction, real_response)
    average_accuracy = numpy.average(accuracies)
    log.debug("Average Accuracy for C-value %s: %s", model.C, average_accuracy)
    return average_accuracy


def plotMachineLearningResultsByPercentTrain(results_by_percent_train, csv_file_location):
    try:
        output_path = ""
        csv_path_split = csv_file_location.split("/")
        for i in range(1, len(csv_path_split) - 1):
            output_path += "/" + csv_path_split[i]

        graphing_service = GraphingService()
        graphing_service.makeMultiBarPlot(results_by_percent_train, output_path)
    except Exception as exception:
        log.error("Unable to create or save graphs due to: %s", exception)


if __name__ == "__main__":
    main()
