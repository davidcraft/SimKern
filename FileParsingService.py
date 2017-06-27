import re
import random
from SupportedFileTypes import SupportedFileTypes
from SupportedDistributions import SupportedDistributions


class FileParsingService(object):
    def __init__(self, data_file, file_type, permutations):
        self.data_file = data_file
        self.file_type = file_type
        self.permutations = int(permutations)

    def extractGenomePermutations(self):
        if self.file_type == SupportedFileTypes.MATLAB:
            return self.handleOctaveOrMATLABFile()

    def handleOctaveOrMATLABFile(self):
        identifier_regex = re.compile(r'\$.+\$')

        genomes = {}

        for genome in range(1, self.permutations):
            genome_name = "g" + str(genome)

            coefficient_map = {}

            for line in self.data_file.readlines():
                if line[0] == '%':
                    continue
                search_result = identifier_regex.search(line)
                if search_result is not None:
                    target_sequence = line[(search_result.regs[0][0] + 1):(search_result.regs[0][1] - 1)]
                    coefficient_name = self.extractCoefficientName(target_sequence)
                    distribution = self.extractDistributionName(target_sequence)
                    params = self.extractParameters(target_sequence)

                    coefficient_value = self.retreieveCoefficientValueFromDistribution(distribution, params)
                    #TODO: Replace text and generate a new file.
                    coefficient_map[coefficient_name] = coefficient_value

            self.data_file.seek(0)
            genomes[genome_name] = coefficient_map

        print("Genome Coefficient Replacements:", genomes)
        return genomes

    def extractCoefficientName(self, target_sequence):
        return target_sequence.split("name=")[1].strip()

    def extractParameters(self, target_sequence):
        return [float(substring) for substring in re.findall(r'[\d.]+', target_sequence.split("name=")[0])]

    def extractDistributionName(self, target_sequence):
        return re.findall(r'[a-z]*', target_sequence.split("name=")[0])[0]

    def retreieveCoefficientValueFromDistribution(self, distribution, params):
        if distribution == SupportedDistributions.UNIFORM:
            return self.generateRandomValueFromNormalDistribution(params[0], params[1])
        elif distribution == SupportedDistributions.GAUSS:
            return self.generateRandomValueFromGaussianDistribution(params[0], params[1])

    def generateRandomValueFromNormalDistribution(self, min, max):
        return random.uniform(min, max)

    def generateRandomValueFromGaussianDistribution(self, mu, sigma):
        return random.gauss(mu, sigma)