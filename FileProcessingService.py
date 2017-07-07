import re
import os
import random
from SupportedFileTypes import SupportedFileTypes
from SupportedDistributions import SupportedDistributions


class FileProcessingService(object):

    GENERATED_FOLDER_NAME = "/GenomeFiles"
    GENOMES_FILE_NAME = "Genomes.txt"
    IDENTIFIER_REGEX = re.compile(r'\$.+\$')

    def __init__(self, data_file, file_type, permutations, path):
        self.data_file = data_file
        self.file_type = file_type
        self.permutations = int(permutations)
        self.path = path

    def createGenomePermutations(self):
        if self.file_type == SupportedFileTypes.MATLAB:
            return self.handleOctaveOrMATLABFile()
        elif self.file_type == SupportedFileTypes.TXT:
            pass
            # TODO - create handleTXTFile() Function
            # Note - fn will need to be able to take in files containing booleans

    def handleOctaveOrMATLABFile(self, file_name_root = "genome"):
        coefs = []
        genomes_file_list = []

        path = self.maybeCreateNewFileDirectory()
        m_call_file = open(path + '/mCallFile.m', 'w')

        genomes = {}

        for genome in range(1, self.permutations + 1):
            family_coefs = []
            genome_name = file_name_root + str(genome) #Note - changed this to a parameter for SIM1

            coefficient_map = {}
            new_m_file = open(path + "/" + genome_name + ".m", "w")
            genomes_file_list.append(genome_name + ".m")
            m_call_file.write(genome_name + "\n")

            for line in self.data_file.readlines():
                if line[0] == '%':
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
                    family_coefs.append(coefficient_value)
                else:
                    new_m_file.write(line)
            new_m_file.close()
            coefs.append(family_coefs)

            self.data_file.seek(0)
            genomes[genome_name] = coefficient_map

        m_call_file.close()
        self.writeGenomesFileToDirectory(genomes, path)

        return genomes_file_list


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
        pattern = re.compile('-?\ *[0-9]+?\.?[0-9]*(?:[Ee]\ *-?\ *[0-9]+)?')  # now supports scientific notation
        return [float(substring) for substring in re.findall(pattern, target_sequence.split("name=")[0])]

    def extractDistributionName(self, target_sequence):
        return re.findall(r'[a-z]*', target_sequence.split("name=")[0])[0]

    # Selection from a series of both discrete and continuous probability distributions

    def retrieveCoefficientValueFromDistribution(self, distribution, params):
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

    def generateRandomValueFromBionomialDistribution(self, n, p):
        return random.binomial(n, p)

    def generateRandomValueFromPoissonDistribution(self, k, lmbda):
        return random.poisson(k, lmbda)

    def writeGenomesFileToDirectory(self, genomes, path):
        for genome in genomes.keys():
            new_genome_file = open(path + "/" + genome + "_key.m", "w")
            for value in genomes[genome].keys():
                new_genome_file.write(str(value) + "=" + str(genomes[genome][value]) + ";" + "\n")
            new_genome_file.close()
