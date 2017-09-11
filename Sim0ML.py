from SupportVectorMachine.SupportVectorMachineRunner import runSvm
from RandomForest.rfRunner import *
import numpy as np


def sim0test(feature_file, responses_file, num_permutations, training_percent):
    matrix = csvReader(feature_file)
    num_examples = len(matrix)
    num_genomes = len(matrix[0])
    which = np.arange(num_genomes)
    responses = csvReader(responses_file)
    results = []
    for i in range(0, num_permutations):
        order = np.random.permutation(num_examples)
        newmatrix = matrix[order[:, None], which]
        newresponses = responses[order]

        [trAcSVM, teAcSVM, totAcSVM] = runSvm(newresponses, newmatrix, 'rbf', training_percent)

        [trAcRF, teAcRF, totAcRF] = runRF(newresponses, newmatrix, training_percent)
        results += [trAcSVM, teAcSVM, totAcSVM] + [trAcRF, teAcRF, totAcRF]

    results = np.array(results).reshape((num_permutations, 6))
    results = np.mean(results, axis=0)
    print(results, training_percent, num_permutations)

def csvReader(file):
    output = np.loadtxt(open(file, "rb"), delimiter=",")
    return output

sim0test('/Users/zhaoqiwang/Desktop/MGH/DSPP/GenomeFiles/Sim0GenomesMatrix.csv',
         '/Users/zhaoqiwang/Desktop/MGH/DSPP/GenomeFiles/Sim0Output.csv', 10, 0.7)
