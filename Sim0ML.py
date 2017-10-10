from SupportVectorMachine.SupportVectorMachineTrainer import *
from RandomForest.RandomForestTrainer import *
import numpy as np



def sim0test(feature_file,responses_file,num_permutations,training_per_cent):
    matrix = csvReader(feature_file)
    num_examples = matrix.shape[0]
    num_genomes = matrix.shape[1]
    print(matrix.shape)
    which = np.arange(num_genomes)
    responses = csvReader(responses_file)
    assert (num_examples == len(responses))
    results = []
    for i in range(0, num_permutations):
        order = np.random.permutation(num_examples)
        newmatrix = matrix[order[:, None], order]
        newresponses = responses[order]


        [trAcSVM, teAcSVM, totAcSVM] = runSvm(newresponses, newmatrix, "precomputed", training_per_cent)

        # [trAcRF, teAcRF, totAcRF] = runRF(newresponses, newmatrix, training_per_cent)
        # results += [trAcSVM, teAcSVM, totAcSVM] + [trAcRF, teAcRF, totAcRF]
        results += [trAcSVM, teAcSVM, totAcSVM]

    results = np.array(results).reshape((num_permutations,3))
    results = np.mean(results, axis=0)
    print(results, training_per_cent ,num_permutations )

def csvReader(file):
    output = np.loadtxt(open(file, "rb"), delimiter=",")
    return output


sim0test('/Users/zhaoqiwang/Desktop/MGH/DSPP/GenomeFiles/SimilarityMatrix/Sim1SimilarityMatrixfinal.csv','/Users/zhaoqiwang/Desktop/MGH/DSPP/GenomeFiles/Sim0Output.csv',20,0.7)