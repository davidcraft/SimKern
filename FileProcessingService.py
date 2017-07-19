import re
import os
import random
from SupportedFileTypes import SupportedFileTypes
from SupportedDistributions import SupportedDistributions


class FileProcessingService(object):

    GENERATED_FOLDER_NAME = "/GenomeFiles"
    GENOMES_FILE_NAME = "Genomes.txt"
    IDENTIFIER_REGEX = re.compile(r'\$.+\$')

    def __init__(self, data_file, file_type, number_of_genomes, path):
        self.data_file = data_file
        self.file_type = file_type
        self.number_of_genomes = int(number_of_genomes)
        self.path = path

    def createGenomes(self):
        if self.file_type == SupportedFileTypes.MATLAB:
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
                    coefficient_map[coefficient_name] = coefficient_value
                else:
                    new_m_file.write(line)
            new_m_file.close()

            self.data_file.seek(0)
            genomes[genome_name] = coefficient_map

        self.writeGenomesKeyFilesToDirectory(genomes, path)
        genomes_matrix = self.createGenomesMatrix(genomes)
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
        return target_sequence.split("name=")[1].strip()

    def extractParameters(self, target_sequence):
        if self.file_type == SupportedFileTypes.R:
            regex = re.compile(r'\(.+\)')
            search_result = regex.search(target_sequence)
            sequence = target_sequence[(search_result.regs[0][0] + 1):(search_result.regs[0][1] - 1)]
            return sequence.split(",")
        elif self.file_type == SupportedFileTypes.MATLAB:
            pattern = re.compile('-?\ *[0-9]+\.?[0-9]*(?:[Ee]\ *-?\ *[0-9]+)?') # now supports scientific notation
            return [float(substring) for substring in re.findall(pattern, target_sequence.split("name=")[0])]

    def extractDistributionName(self, target_sequence):
        return re.findall(r'[a-z]*', target_sequence.split("name=")[0])[0]

    def retrieveCoefficientValueFromDistribution(self, distribution, params):
        # Selection from a series of both discrete and continuous probability distributions
        if distribution == SupportedDistributions.UNIFORM:
            return self.generateRandomValueFromUniformDistribution(params[0], params[1])
        elif distribution == SupportedDistributions.GAUSS:  # changed form GAUSSIAN TO GAUSS
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
        return random.uniform(mini, maxi)

    def generateRandomValueFromGaussianDistribution(self, mu, sigma):
        return random.gauss(mu, sigma)

    def generateRandomValueFromDiscreteDistribution(self, values):
        return random.choice(values)

    def generateRandomValueFromGammaDistribution(self, k, theta):
        return random.gamma(k, theta)

    def generateRandomValueFromLogNormalDistribution(self, mu, sigma):
        return random.lognormal(mu, sigma)

    def generateRandomValueFromBinomialDistribution(self, n, p):
        return random.binomial(n, p)

    def generateRandomValueFromPoissonDistribution(self, k, lmbda):
        return random.poisson(k, lmbda)

    def pickBoolean(self, probability_of_zero):
        val = random.uniform(0, 1)
        if val < float(probability_of_zero):
            return "0"
        else:
            return "1"

    def pickMutation(self, node, probability_of_knock_out, probability_of_over_expression):
        val = random.uniform(0, 1)
        if val < float(probability_of_knock_out):
            return "fixGenes( network, " + '"' + node + '"' + ", 0)"
        elif val > float(probability_of_knock_out) and val < (float(probability_of_over_expression) + float(probability_of_knock_out)):
            return "fixGenes( network, " + '"' + node + '"' + ", 1)"
        else:
            return ""

    def writeGenomesKeyFilesToDirectory(self, genomes, path):
        for genome in genomes.keys():
            new_genome_file = open(path + "/" + genome + "_key." + self.file_type, "w")
            for value in genomes[genome].keys():
                genome_value = genomes[genome][value]
                if self.file_type == SupportedFileTypes.MATLAB:
                    new_genome_file.write(str(value) + "=" + str(genome_value) + ";" + "\n")
                elif self.file_type == SupportedFileTypes.R:
                    if genome_value is "":
                        new_genome_file.write(str(value) + "<-" + str(-1) + "\n")
                    elif ")" in genome_value:
                        pos = genome_value.index(")")
                        new_genome_file.write(str(value) + "<-" + str(genome_value[pos - 1]) + "\n")
                    else:
                        new_genome_file.write(str(value) + "<-" + str(genome_value) + "\n")
            new_genome_file.close()

    def createGenomesMatrix(self, genomes):
        genomes_matrix = []
        counter = 0
        for genome in genomes.keys():
            genomes_matrix.append([])
            for value in genomes[genome].keys():
                if genomes[genome][value] is "":
                    genomes_matrix[counter].append(int(-1))
                elif type(genomes[genome][value]) is not float:
                    if genomes[genome][value][0].isalpha():
                        pos = genomes[genome][value].index(")")
                        genomes_matrix[counter].append(int(genomes[genome][value][pos - 1]))
                    else:
                        genomes_matrix[counter].append(int(genomes[genome][value]))
                else:
                    genomes_matrix[counter].append((genomes[genome][value]))
            counter = counter + 1
        return genomes_matrix
