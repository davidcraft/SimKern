import sys
import logging

from FileProcessingService import FileProcessingService

log = logging.getLogger(__name__)
log.setLevel(logging.INFO)

def main():
    arguments = sys.argv[1:]
    if len(arguments) != 3:
        log.warn("Program expects three arguments, a file expressing differential equations," +
                "an integer representing number of permutations, and a path to store generated files.")
        return
    input_file = arguments[0]
    permutations = arguments[1]
    path = arguments[2]
    file_extension = input_file.split(".")[1]
    with open(input_file) as data_file:
        try:
            file_parsing_service = FileProcessingService(data_file, file_extension, permutations, path)
            genome_permutations = file_parsing_service.extractGenomePermutations()
            callThirdPartyService(genome_permutations)
        except ValueError as valueError:
            print valueError.message
        finally:
            log.debug("Closing file %s", input_file)
            data_file.close()


def callThirdPartyService(genomes):
    pass

if __name__ == "__main__":
    main()
