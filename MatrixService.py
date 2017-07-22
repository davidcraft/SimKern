from __future__ import division


class MatrixService(object):

    def __init__(self, simulation_result, number_of_genomes, number_of_trials):
        self.simulation_result = simulation_result
        self.number_of_genomes = int(number_of_genomes)
        self.number_of_trials = int(number_of_trials)

    def generateSimilarityMatrix(self):
        response_matrix = self.generateGenomesByTrialMatrix()
        similarity_matrix = self.computeSimilarityScores(response_matrix)
        return similarity_matrix

    def generateGenomesByTrialMatrix(self):
        response_list = self.generateResponseList()
        genomes_by_trial_matrix = []
        for genome in range(0, self.number_of_genomes):
            genomes_by_trial_matrix.append([])
        pos = 0
        for trial in range(0, self.number_of_trials):
            for genome in range(0, self.number_of_genomes):
                genomes_by_trial_matrix[genome].append(response_list[pos])
                pos += 1
        return genomes_by_trial_matrix

    def generateResponseList(self):
        response_list = []
        for file in self.simulation_result.keys():
            response_list.append(self.simulation_result[file])
        return response_list

    def computeSimilarityScores(self, response_matrix):
        kernel = [None]*self.number_of_genomes
        for i in range(0, self.number_of_genomes):
            kernel[i] = [None]*self.number_of_genomes
            kernel[i][i] = 1

        for i in range(0, self.number_of_genomes - 1):
            for j in range(i + 1, self.number_of_genomes):
                num_valid = 0
                count = 0
                for k in range(0, self.number_of_trials):
                    if response_matrix[i][k] is not int(-1) and response_matrix[j][k] is not int(-1):
                        num_valid = num_valid+1
                        if response_matrix[i][k] == response_matrix[j][k]:
                            count = count + 1
                if num_valid == 0:
                    score = None
                else:
                    score = count / num_valid
                kernel[i][j] = score
                kernel[j][i] = score

        return kernel
