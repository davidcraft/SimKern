import sys

from FileParsingService import FileParsingService


def main():
    arguments = sys.argv[1:]
    if len(arguments) != 1:
        print "Program expects one argument, a file of differential equations."
        return
    input_file = arguments[0]
    file_extension = input_file.split(".")[1]
    with open(input_file) as data_file:
        try:
            file_parsing_service = FileParsingService(data_file, file_extension)
            differential_equations = file_parsing_service.extractDifferentialEquations()
            parseDifferentialEquations(differential_equations)
        except ValueError as valueError:
            print valueError.message
        finally:
            print "Closing file ", input_file
            data_file.close()


def parseDifferentialEquations(differential_equations):
    for differential_equation in differential_equations:
        print "Original Differential Equation: dx/dt=", differential_equation.original_string

if __name__ == "__main__":
    main()
