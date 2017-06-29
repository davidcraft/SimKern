import sys

from FileProcessingService import FileProcessingService


def main():
    arguments = sys.argv[1:]
    if len(arguments) != 2:
        print "Program expects two arguments, a file of differential equations," \
              " and an integer representing number of permutations."
        return
    input_file = arguments[0]
    permutations = arguments[1]
    file_extension = input_file.split(".")[1]
    with open(input_file) as data_file:
        try:
            file_parsing_service = FileProcessingService(data_file, file_extension, permutations)
            genome_permutations = file_parsing_service.extractGenomePermutations()
            saveGeneratedFiles(genome_permutations)
        except ValueError as valueError:
            print valueError.message
        finally:
            print "Closing file ", input_file
            data_file.close()


def saveGeneratedFiles(genomes):
    for gene in genomes:
        pass

if __name__ == "__main__":
    main()
