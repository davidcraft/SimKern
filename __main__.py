import logging
import sys


from FileProcessingService import FileProcessingService
from Sim1FileProcessingService import Sim1FileProcessingService
from ThirdPartyProgramCaller import ThirdPartyProgramCaller
from MachineLearningDataProcessingService import MachineLearningDataProcessingService
from Utilities.SafeCastUtil import SafeCastUtil

log = logging.getLogger(__name__)
logging.basicConfig()
log.setLevel(logging.INFO)


def main():
    arguments = sys.argv[1:]
    if len(arguments) == 0:
        promptUserForInput()

    elif SafeCastUtil.safeCast(arguments[0], int) == 0:  # SIM0
        log.info("SIM0 genome creation requested...")
        if len(arguments) is not 5:
            log.info("Program expects 5 arguments: an integer expressing the desired action from the main menu, "
                     "a master SIM0 file, an integer representing number of genomes to create, an expected response"
                     " type, and a path to store generated files\n")
            return
        input_file = arguments[1]
        number_of_genomes = arguments[2]
        response_type = arguments[3]
        output_path = arguments[4]
        file_extension = input_file.split(".")[1]
        log.info("Starting SIM0 genome creation K=%s genomes, from file %s, being output to %s/GenomeFiles with "
                 "expected response type %s.", number_of_genomes, input_file, output_path, response_type)
        createGenomesSIM0(file_extension, input_file, output_path, number_of_genomes, response_type)

    elif SafeCastUtil.safeCast(arguments[0], int) == 1:  # SIM1
        log.info("SIM1 genome creation requested...")
        if len(arguments) is not 6:
            log.info("Program expects 6 arguments: an integer expressing the desired action from the main menu, "
                     "a master SIM1 file, an integer representing number of genomes to create (K), another "
                     "integer representing trials for each genome (R), an expected response type, "
                     "and a path to store generated files\n")
            return
        input_file = arguments[1]
        number_of_genomes = arguments[2]
        number_of_trials = arguments[3]
        response_type = arguments[4]
        output_path = arguments[5]
        file_extension = input_file.split(".")[1]
        log.info("Starting SIM1 genome creation K=%s genomes, and R=%s trials from file %s,"
                 " being output to %s/GenomeFiles.",
                 number_of_genomes, number_of_trials, input_file, output_path)
        createGenomesSIM1(file_extension, input_file, output_path, number_of_genomes, number_of_trials, response_type)

    elif SafeCastUtil.safeCast(arguments[0], int) == 2:
        log.info("Machine Learning on SIM0 data requested...")
        if len(arguments) is not 5:
            log.info("Program expects 5 arguments: an integer expressing the desired action from the main menu, "
                     "a Sim0Output.csv file expressing the third party program results of SIM0, the accompanying "
                     "Sim0GenomesMatrix file, 'REGRESSION' or 'CLASSIFICATION' for the type of analysis, and a list of"
                     "indices for categorical features in the Sim0GenomesMatrix.")
            return
        output_file = arguments[1]
        genomes_matrix_file = arguments[2]
        analysis = arguments[3]
        categorical_variables = arguments[4].split(",")
        performSIM0Analysis(analysis, genomes_matrix_file, output_file, categorical_variables)
    elif SafeCastUtil.safeCast(arguments[0], int) == 3:
        log.info("Machine Learning on SIM1 data requested...")
        if len(arguments) is not 4:
            log.info("Program expects 4 arguments: an integer expressing the desired action from the main menu, "
                     "a Sim0Output.csv file expressing the third party program results of SIM0, "
                     "a Sim1SimilarityMatrix.csv file, and 'REGRESSION' or 'CLASSIFICATION' for the type of analysis.")
            return
        output_file = arguments[1]
        similarity_matrix = arguments[2]
        analysis_type = arguments[3]
        performSIM1Analysis(output_file, similarity_matrix, analysis_type)
    elif SafeCastUtil.safeCast(arguments[0], int) == 4:
        log.info("Machine Learning on both SIM0 and SIM1 data requested...")
        if len(arguments) is not 6:
            log.info("Program expects 6 arguments: an integer expressing the desired action from the main menu, "
                     "a Sim0Output.csv file expressing the third party program results of SIM0, the accompanying "
                     "Sim0GenomesMatrix file, a Sim1SimilarityMatrix.csv file, 'REGRESSION' or 'CLASSIFICATION' "
                     "for the type of analysis, and a list of indices for categorical features in "
                     "the Sim0GenomesMatrix.")
            return
        output_file = arguments[1]
        genomes_matrix_file = arguments[2]
        similarity_matrix = arguments[3]
        analysis_type = arguments[4].split(",")
        categorical_variables = arguments[5]
        performSIM0SIM1Analysis(output_file, genomes_matrix_file, similarity_matrix, analysis_type,
                                categorical_variables)
    return


def promptUserForInput():
    simulation_to_run = input("-------Main Menu-------\n"
                              "Choose your task:\n"
                              "\t0: SIM0 - create K genomes\n"
                              "\t1: SIM1 - create R permutations of K genomes\n"
                              "\t2: Perform machine learning with existing SIM0 data\n"
                              "\t3: Perform machine learning with existing SIM1 data\n"
                              "\t4: Perform machine learning with both SIM0 and SIM1 data\n"
                              "\tQ: Quit\n")
    simulation_as_int = SafeCastUtil.safeCast(simulation_to_run, int)
    simulation_as_string = SafeCastUtil.safeCast(simulation_to_run, str, "Q")
    if simulation_as_int == 0:
        input_file = recursivelyPromptUser("Enter path of input file:\n", str)
        permutations = recursivelyPromptUser("Enter number of genomes (K) as an integer:\n", int)
        path = recursivelyPromptUser("Enter path of output folder (must not be root directory):\n", str)
        file_extension = input_file.split(".")[1]
        response_type = recursivelyPromptUser("Enter expected third party response type:\n", str)
        createGenomesSIM0(file_extension, input_file, path, permutations, response_type)
    elif simulation_as_int == 1:
        input_file = recursivelyPromptUser("Enter path of input file:\n", str)
        file_extension = input_file.split(".")[1]
        permutations = recursivelyPromptUser("Enter number of genomes (K) as an integer:\n", int)
        number_of_trials = recursivelyPromptUser("Enter number of trials for each genome (R) as an integer:\n", int)
        path = recursivelyPromptUser("Enter path of output folder (must not be root directory):\n", str)
        response_type = recursivelyPromptUser("Enter expected third party response type:\n", str).split(",")
        createGenomesSIM1(file_extension, input_file, path, permutations, number_of_trials, response_type)
    elif simulation_as_int == 2:
        output_file = recursivelyPromptUser("Enter path of input Sim0Output.csv file:\n", str)
        genomes_matrix_file = recursivelyPromptUser("Enter path of input Sim0GenomesMatrix.csv file:\n", str)
        analysis = recursivelyPromptUser("Enter 'REGRESSION' or 'CLASSIFICATION' for analysis type:\n", str)
        categorical_variables = recursivelyPromptUser("Enter categorical variables for Sim0GenomesMatrix.\n", str).split(",")
        performSIM0Analysis(analysis, genomes_matrix_file, output_file,
                            SafeCastUtil.safeCast(categorical_variables, list))
    elif simulation_as_int == 3:
        output_file = recursivelyPromptUser("Enter path of Sim1Responses.csv file:\n", str)
        similarity_matrix = recursivelyPromptUser("Enter path of .CSV file representing the similarity matrix:\n", str)
        analysis_type = recursivelyPromptUser("Enter 'REGRESSION' or 'CLASSIFICATION' for analysis type", str)
        performSIM1Analysis(output_file, similarity_matrix, analysis_type)
    elif simulation_as_int == 4:
        output_file = recursivelyPromptUser("Enter path of Sim1Responses.csv file:\n", str)
        genomes_matrix_file = recursivelyPromptUser("Enter path of input Sim0GenomesMatrix.csv file:\n", str)
        similarity_matrix = recursivelyPromptUser("Enter path of .CSV file representing the similarity matrix:\n", str)
        analysis_type = recursivelyPromptUser("Enter 'REGRESSION' or 'CLASSIFICATION' for analysis type\n", str)
        categorical_variables = recursivelyPromptUser("Enter categorical variables for Sim0GenomesMatrix.\n", str).split(",")
        performSIM0SIM1Analysis(output_file, genomes_matrix_file, similarity_matrix, analysis_type,
                                SafeCastUtil.safeCast(categorical_variables, list))
    elif simulation_as_string == "Q":
        return
    else:
        print("Invalid command, please type 0, 1, 2, 3 or 'Q'.\n")
        promptUserForInput()


def recursivelyPromptUser(message, return_type):
    response = input(message)
    cast_response = SafeCastUtil.safeCast(response, return_type)
    if cast_response is None:
        print("Invalid command, looking for an input of type %.\n", return_type)
        recursivelyPromptUser(message, return_type)
    else:
        return response


def createGenomesSIM0(file_extension, input_file, path, number_of_genomes, response_type):
    with open(input_file) as data_file:
        try:
            genomes = processInputFileAndCreateGenomes(data_file, file_extension, path, number_of_genomes)
            third_party_result = callThirdPartyService(file_extension, path, genomes[0], True, number_of_genomes,
                                                       0, response_type)
            log.info("Results of third party call: %s", third_party_result)
        except ValueError as valueError:
            log.error(valueError)
        finally:
            log.debug("Closing file %s", input_file)
            data_file.close()


def processInputFileAndCreateGenomes(data_file, file_extension, path, number_of_genomes):
    file_parsing_service = FileProcessingService(data_file, file_extension, number_of_genomes, path)
    return file_parsing_service.createGenomes()


def callThirdPartyService(file_extension, path, file_list, record_output, number_of_genomes, number_of_trials,
                          response_type):
    third_party_caller_service = ThirdPartyProgramCaller(path, file_extension, file_list, response_type,
                                                         number_of_genomes, number_of_trials)
    return third_party_caller_service.callThirdPartyProgram(record_output)


def createGenomesSIM1(file_extension, input_file, path, number_of_genomes, number_of_trials, response_type):
    with open(input_file) as data_file:
        try:
            trial_files = createTrialFiles(data_file, file_extension, number_of_genomes, number_of_trials, path)
            third_party_result = callThirdPartyService(file_extension, path, trial_files, False,
                                                       number_of_genomes, number_of_trials, response_type)
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
    log.info("Created all the trial files")
    return trial_files


def performSIM0Analysis(analysis, genomes_matrix_file, output_file, categorical_variables):
    data_processor = MachineLearningDataProcessingService(100)
    data_processor.performMachineLearningOnSIM0(output_file, genomes_matrix_file, analysis, categorical_variables)


def performSIM1Analysis(output_file, similarity_matrix, analysis_type):
    data_processor = MachineLearningDataProcessingService(100)
    data_processor.performMachineLearningOnSIM1(output_file, similarity_matrix, analysis_type)


def performSIM0SIM1Analysis(output_file, genomes_matrix_file, similarity_matrix, analysis_type, categorical_variables):
    data_processor = MachineLearningDataProcessingService(100)
    data_processor.performFullSIM0SIM1Analysis(output_file, genomes_matrix_file, similarity_matrix, analysis_type,
                                               categorical_variables)

if __name__ == "__main__":
    main()
