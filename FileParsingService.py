import re
import numpy
from SupportedFileTypes import SupportedFileTypes
from DifferentialEquation import DifferentialEquation


class FileParsingService(object):
    def __init__(self, data_file, file_type):
        self.data_file = data_file
        self.file_type = file_type

    def extractDifferentialEquations(self):
        if self.file_type == SupportedFileTypes.MATLAB:
            return self.handleOctaveOrMATLABFile()

    def handleOctaveOrMATLABFile(self):
        # TODO: Support MATLAB
        # TODO: Generalize for arbitrary variable names.
        initial_conditions = []
        inital_condition_regex = re.compile(r'\tx0\(\d*\) = .*;\n')

        time = []
        time_regex = re.compile(r'\tt=linspace.*;')

        named_coefficients = {}
        named_coefficients_regex = re.compile(r'\t.*=[\d\.]*;')

        reactions = {}
        reaction_regex = re.compile(r'\treaction_.*')

        first_time_derivatives = []
        first_time_derivative_regex = re.compile(r'\txdot\(\d*\) = .*')

        for line in self.data_file.readlines():
            # TODO: Support time dependent coefficients
            # TODO Refactor to rely on parser library, not RegEx
            if line[0] == '%':
                continue
            if inital_condition_regex.search(line):
                initial_conditions.append(self.extractInitialCondition(line))
            elif time_regex.search(line):
                time = self.extractTimeInterval(line)
            elif named_coefficients_regex.search(line):
                self.extractAndAppendNamedCoefficient(line, named_coefficients)
            elif reaction_regex.search(line):
                self.extractAndAppendReaction(line, reactions)
            elif first_time_derivative_regex.search(line):
                self.extractAndAppendFirstTimeDerivative(first_time_derivatives, line)

        return self.createDifferentialEquations(first_time_derivatives, named_coefficients, reactions)

    def extractInitialCondition(self, line):
        return float(re.findall(r'[\d\.]+', line.split(" = ")[1])[0])

    def extractTimeInterval(self, line):
        params_to_linspace = [float(substring) for substring in re.findall(r'\d+', line)]
        return numpy.linspace(params_to_linspace[0] + 1, params_to_linspace[1], int(params_to_linspace[2]))

    def extractAndAppendFirstTimeDerivative(self, first_time_derivatives, line):
        first_time_derivative = line.split(" = ")[1].split(";")[0]
        first_time_derivatives.append(first_time_derivative)

    def extractAndAppendReaction(self, line, reactions):
        reaction_name = line.split("=")[0][1:]
        reaction_value = line.split("=")[1].split(";")[0]
        reactions[reaction_name] = reaction_value

    def extractAndAppendNamedCoefficient(self, line, named_coefficients):
        split_line_by_equals = line.split("=")
        coefficient_name = split_line_by_equals[0].strip()
        coefficient_value = split_line_by_equals[1].split(";")[0]
        named_coefficients[coefficient_name] = coefficient_value

    def createDifferentialEquations(self, first_time_derivatives, named_coefficients, reactions):
        differential_equations = []
        for first_time_derivative in first_time_derivatives:
            differential_equation = DifferentialEquation(first_time_derivative)
            for reaction in reactions.keys():
                first_time_derivative = re.sub(r'' + reaction + '', reactions[reaction], first_time_derivative)
            for named_coefficient in named_coefficients.keys():
                first_time_derivative = re.sub(r'' + named_coefficient + '', named_coefficients[named_coefficient],
                                               first_time_derivative)
            differential_equation.modified_string = first_time_derivative
            differential_equations.append(differential_equation)
        return differential_equations
