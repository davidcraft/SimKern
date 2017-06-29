import re
import os
import random
from SupportedFileTypes import SupportedFileTypes
from SupportedDistributions import SupportedDistributions


class FileProcessingService(object):
    def __init__(self, data_file, file_type, permutations):
        self.data_file = data_file
        self.file_type = file_type
        self.permutations = int(permutations)

    def extractGenomePermutations(self):
        if self.file_type == SupportedFileTypes.MATLAB:
            return self.handleOctaveOrMATLABFile()
        elif self.file_type == SupportedFileTypes.TXT:
            pass
            #TODO - create handleTXTFile() Function
                    #Note - fn will need to be able to take in files containing booleans

    def handleOctaveOrMATLABFile(self): 
        #TODO - allow user to specify Folder Name or Names of files within folder

        coefs = []
        #list(range(self.permutations))
        genomesFileList=[]
        os.mkdir("GenomeFiles")
        path=os.getcwd()+"/GenomeFiles/"
        #TODO - What if file exists already?
        #- returns with - FileExistsError: [Errno 17] File exists: 'GenomeFiles'
        
        MCallFile=open(os.getcwd()+'/mCallFile.m','w')
 
        identifier_regex = re.compile(r'\$.+\$')
        genomes = {}

        for genome in range(1, self.permutations+1):
            familycoefs = []
            genome_name = "g" + str(genome)

            coefficient_map = {}
            NewMFile=open(path+genome_name+".m","w")
            genomesFileList.append(genome_name+".m")
            MCallfile.write('genome_name') #TODO - Talk with David about this

            for line in self.data_file.readlines():
                if line[0] == '%':
                    NewMFile.write(line)
                    continue
                search_result = identifier_regex.search(line)
                if search_result is not None:
                    target_sequence = line[(search_result.regs[0][0] + 1):(search_result.regs[0][1] - 1)]
                    coefficient_name = self.extractCoefficientName(target_sequence)
                    distribution = self.extractDistributionName(target_sequence)
                    params = self.extractParameters(target_sequence)
                    coefficient_value = self.retrieveCoefficientValueFromDistribution(distribution, params)
                    #Replace $stuff$ with extracted coefficient value, write to file
                    NewLine=identifier_regex.sub(str(coefficient_value),line)
                    NewMFile.write(NewLine)
                    coefficient_map[coefficient_name] = coefficient_value
                    familycoefs.append(coefficient_value)
                else:
                    NewMFile.write(line)
            NewMFile.close()
            coefs.append(familycoefs)

            self.data_file.seek(0)
            genomes[genome_name] = coefficient_map

        self.writeGenomesToFile(path,"genomes.txt",genomes)
        print(coefs)
        return genomesFileList

        
    def extractCoefficientName(self, target_sequence):
        return target_sequence.split("name=")[1].strip()

    def extractParameters(self,target_sequence):
        pattern = re.compile('-?\ *[0-9]+?\.?[0-9]*(?:[Ee]\ *-?\ *[0-9]+)?') #now supports scientific notation
        return [float(substring) for substring in re.findall(pattern, target_sequence.split("name=")[0])]

    def extractDistributionName(self, target_sequence):
        return re.findall(r'[a-z]*', target_sequence.split("name=")[0])[0]
    
    def writeGenomesToFile(self,path,NewGenomesFileName,genomesDictionary):
        GenomesFile=open(path+NewGenomesFileName,"w")
        GenomesFile.write(str(genomesDictionary))
        GenomesFile.close()
    
    #Selection from a series of both Discrete and Continous Probability Distributions
    
    def retrieveCoefficientValueFromDistribution(self, distribution, params):
        if distribution == SupportedDistributions.UNIFORM:
            return self.generateRandomValueFromUniformDistribution(params[0], params[1])
        elif distribution == SupportedDistributions.GAUSS: #changed form GAUSSIAN TO GAUSS
            return self.generateRandomValueFromGaussianDistribution(params[0], params[1])
        elif distribution == SupportedDistributions.DISCRETE:
            return self.generateRandomValueFromDiscreteDistribution(params) #TODO - test this
        elif distribution == SupportedDistributions.GAMMA:
            return self.generateRandomValueFromGammaDistribution(params[0], params[1])
        elif distribution == SupportedDistributions.LOGNORMAL:
            return self.generateRandomValueFromLogNormalDistribution(params[0], params[1])
        elif distribution == SupportedDistributions.BINOMIAL:
            return self.generateRandomValueFromBinomialDistribution(params[0], params[1])
        elif distribution == SupportedDistributions.POISSON:
            return self.generateRandomValueFromPoissonDistribution(params[0], params[1])


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
    