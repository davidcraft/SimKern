import re
import os
import random
import csv
from SupportedFileTypes import SupportedFileTypes
from SupportedDistributions import SupportedDistributions


class FileProcessingService(object):

    GENERATED_FOLDER_NAME = "/GenomeFiles"
    GENOMES_FILE_NAME = "Genomes.txt"
    IDENTIFIER_REGEX = re.compile(r'\$.+\$')
    DEFAULT_GAUSSIAN_STANDARD_DEVIATION = 0.1
    OUTPUT_FILE_NAME = "Sim0GenomesMatrix.csv"

    num_generated_coefficients = 0

    def __init__(self, data_file, file_type, number_of_genomes, path):
        self.data_file = data_file
        self.file_type = file_type
        self.number_of_genomes = int(number_of_genomes)
        self.path = path

    def createGenomes(self):
        if self.file_type == SupportedFileTypes.MATLAB or self.file_type == SupportedFileTypes.OCTAVE:
            return self.handleFile("%")
        elif self.file_type == SupportedFileTypes.R:
            return self.handleFile("#")
            # Note - fn will need to be able to take in files containing booleans

    def handleFile(self, comment_character, file_name_root="genome"):
        genomes_file_list = []

        path = self.maybeCreateNewFileDirectory()

        genomes = {}
        for genome in range(1, self.number_of_genomes + 1):
            genome_name = file_name_root + str(genome) #Note - changed this to a parameter for SIM1
            coefficient_map = {}
            new_m_file = open(path + "/" + genome_name + "." + self.file_type, "w")
            genomes_file_list.append(genome_name + "." + self.file_type)

            for line in self.data_file:
                if line[0] == comment_character:
                    new_m_file.write(line)
                    continue
                search_result = self.IDENTIFIER_REGEX.search(line)
                if search_result is not None:
                    target_sequence = line[(search_result.regs[0][0] + 1):(search_result.regs[0][1] - 1)]
                    coefficient_name = self.extractCoefficientName(target_sequence)
                    distribution = self.extractDistributionName(target_sequence)
                    params = self.extractParameters(target_sequence)
                    coefficient_value = self.retrieveCoefficientValueFromDistribution(distribution, params)
                    # Replace $stuff$ with extracted coefficient value, write to file
                    new_line = self.IDENTIFIER_REGEX.sub(str(coefficient_value), line)
                    new_m_file.write(new_line)
                    if type(coefficient_value) is str:
                        coefficient_value = self.replaceCoefValue(coefficient_value)
                    coefficient_map[coefficient_name] = coefficient_value
                else:
                    new_m_file.write(line)
            new_m_file.close()

            self.data_file.seek(0)
            self.num_generated_coefficients = 0
            genomes[genome_name] = coefficient_map

        self.writeGenomesKeyFilesToDirectory(genomes, path)
        genomes_matrix = self.createGenomesMatrix(genomes)
        self.writeDataFile(genomes_matrix)
        return [genomes_file_list, genomes_matrix]

    def maybeCreateNewFileDirectory(self):
        target_directory = self.path + self.GENERATED_FOLDER_NAME
        if os.getcwd() != "/":
            if not os.path.isdir(target_directory):
                os.mkdir(target_directory)
        else:
            raise ValueError('Provided path must not be root directory.')
        return target_directory

    def extractCoefficientName(self, target_sequence):
        if "name=" in target_sequence:
            return target_sequence.split("name=")[1].strip()
        else:
            self.num_generated_coefficients += 1
            return "coefficient" + str(self.num_generated_coefficients)

    def extractDistributionName(self, target_sequence):
        if "name=" in target_sequence or ("(" in target_sequence and ")" in target_sequence):
            distribution_name = re.findall(r'[a-z]*', target_sequence.split("name=")[0])[0]
            if distribution_name == '':
                return SupportedDistributions.GAUSS
            else:
                return distribution_name
        else:
            return SupportedDistributions.GAUSS

    def extractParameters(self, target_sequence):
        if self.file_type == SupportedFileTypes.R:
            if "(" in target_sequence and ")" in target_sequence:
                regex = re.compile(r'\(.+\)')
                search_result = regex.search(target_sequence)
                sequence = target_sequence[(search_result.regs[0][0] + 1):(search_result.regs[0][1] - 1)]
                return [param.strip() for param in sequence.split(",")]
            else:
                regex = re.compile(r'\d+')
                return [substring for substring in re.findall(regex, target_sequence.split("name=")[0])]
        elif self.file_type == SupportedFileTypes.MATLAB or SupportedFileTypes.OCTAVE:
            pattern = re.compile('-?\ *[0-9]+\.?[0-9]*(?:[Ee]\ *-?\ *[0-9]+)?')  # now supports scientific notation
            return [param.strip() for param in re.findall(pattern, target_sequence.split("name=")[0])]

    def retrieveCoefficientValueFromDistribution(self, distribution, params):
        # Selection from a series of both discrete and continuous probability distributions
        if distribution == SupportedDistributions.UNIFORM:
            return self.generateRandomValueFromUniformDistribution(params[0], params[1])
        elif distribution == SupportedDistributions.GAUSS:  # changed form GAUSSIAN TO GAUSS
            if len(params) <= 1:
                return self.generateRandomValueFromGaussianDistribution(params[0],
                                                                        self.DEFAULT_GAUSSIAN_STANDARD_DEVIATION*float(params[0]))
            else:
                return self.generateRandomValueFromGaussianDistribution(params[0], params[1])
        elif distribution == SupportedDistributions.DISCRETE:
            return self.generateRandomValueFromDiscreteDistribution(params)  # TODO - test this
        elif distribution == SupportedDistributions.GAMMA:
            return self.generateRandomValueFromGammaDistribution(params[0], params[1])
        elif distribution == SupportedDistributions.LOGNORMAL:
            return self.generateRandomValueFromLogNormalDistribution(params[0], params[1])
        elif distribution == SupportedDistributions.BINOMIAL:
            return self.generateRandomValueFromBinomialDistribution(params[0], params[1])
        elif distribution == SupportedDistributions.POISSON:
            return self.generateRandomValueFromPoissonDistribution(params[0], params[1])
        elif distribution == SupportedDistributions.BOOLEAN:
            return self.pickBoolean(params[0])
        elif distribution == SupportedDistributions.MUTATE:
            return self.pickMutation(params[0], params[1], params[2])
        else:
            raise ValueError('Unsupported distribution: ' + distribution)

    def generateRandomValueFromUniformDistribution(self, mini, maxi):
        return random.uniform(float(mini), float(maxi))

    def generateRandomValueFromGaussianDistribution(self, mu, sigma):
        return random.gauss(float(mu), float(sigma))

    def generateRandomValueFromDiscreteDistribution(self, values):
        return random.choice(values)

    def generateRandomValueFromGammaDistribution(self, k, theta):
        return random.gamma(float(k), float(theta))

    def generateRandomValueFromLogNormalDistribution(self, mu, sigma):
        return random.lognormal(float(mu), float(sigma))

    def generateRandomValueFromBinomialDistribution(self, n, p):
        return random.binomial(float(n), float(p))

    def generateRandomValueFromPoissonDistribution(self, k, lmbda):
        return random.poisson(float(k), float(lmbda))

    # Only supported for R
    def pickBoolean(self, probability_of_zero):
        val = random.uniform(0, 1)
        if val < float(probability_of_zero):
            return 0
        else:
            return 1

    # Only supported for R
    def pickMutation(self, node, probability_of_knock_out, probability_of_over_expression):
        val = random.uniform(0, 1)
        if val < float(probability_of_knock_out):
            return "fixGenes( network, " + '"' + str(node) + '"' + ", 0)"
        elif float(probability_of_knock_out) < val < (float(probability_of_over_expression) + float(probability_of_knock_out)):
            return "fixGenes( network, " + '"' + str(node) + '"' + ", 1)"
        else:
            return ""

    def writeGenomesKeyFilesToDirectory(self, genomes, path):
        for genome in genomes.keys():
            new_genome_file = open(path + "/" + genome + "_key." + self.file_type, "w")
            for value in genomes[genome].keys():
                if self.file_type == SupportedFileTypes.MATLAB or SupportedFileTypes.OCTAVE:
                    new_genome_file.write(str(value) + "=" + str(genomes[genome][value]) + ";" + "\n")
                elif self.file_type == SupportedFileTypes.R:
                    new_genome_file.write(str(value) + "<-" + str(genomes[genome][value]) + "\n")
            new_genome_file.close()

    def createGenomesMatrix(self, genomes):
        genomes_matrix = []
        counter = 0
        for genome in genomes.keys():
            genomes_matrix.append([])
            for value in genomes[genome].keys():
                genomes_matrix[counter].append((genomes[genome][value]))
            counter = counter + 1
        return genomes_matrix

    def replaceCoefValue(self, coefficient_string):
        if coefficient_string == "":
            return int(-1)
        else:
            pos = coefficient_string.index(")")
            return int(coefficient_string[pos - 1])

    def writeDataFile(self, genomes_matrix):
        self.changeWorkingDirectory(self.path + "/GenomeFiles")
        with open(self.OUTPUT_FILE_NAME, 'w') as csv_file:
            try:
                data_writer = csv.writer(csv_file)
                for i in range(0, self.number_of_genomes):
                    data_writer.writerow(genomes_matrix[i])
            finally:
                csv_file.close()
                
    def changeWorkingDirectory(self, new_directory):
         os.chdir(new_directory)
