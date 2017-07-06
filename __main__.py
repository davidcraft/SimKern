import sys
import logging

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


if __name__ == "__main__":
    main()
