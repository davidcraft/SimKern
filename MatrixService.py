from __future__ import division
import os
import csv
import numpy as np


class MatrixService(object):
    
    OUTPUT_FILE_NAME = "Sim1SimilarityMatrix"
    OUTPUT_FOLDER_NAME = "/SimilarityMatrix"

    #TODO Add the inputs for weight_vector
    def __init__(self, simulation_result, number_of_genomes, number_of_trials):
        self.simulation_result = simulation_result
        self.number_of_genomes = int(number_of_genomes)
        self.number_of_trials = int(number_of_trials)
        self.list_of_maximum = []

    def generateSimilarityMatrix(self, output_trials=''):
        response_list = self.generateResponseList()
        index_matrix = self.generateIndexMatrix()
        similarity_matrix = self.computeSimilarityScores(response_list, index_matrix, weight_vector=None)
        self.writeDataFile(similarity_matrix, output_trials)
        return similarity_matrix

    def generateIndexMatrix(self):
        """return a matrix with the dimensions as number of trials * (number of genomes *
            length of SIM1Outputs) contains all the index"""
        index_list = np.arange(0, self.number_of_genomes * self.number_of_trials)
        response_matrix = index_list.reshape(self.number_of_trials, -1)
        return response_matrix

    def generateResponseList(self):
        response_list = []
        for file in self.simulation_result.keys():
            response_list.append(self.simulation_result[file])
        return response_list

    def computeSimilarityScores(self, response_list, index_matrix, weight_vector):
        kernel = [None]*self.number_of_genomes
        for i in range(0, self.number_of_genomes):
            kernel[i] = [None]*self.number_of_genomes
            kernel[i][i] = 1
        if type(response_list[0]) == np.ndarray:
            for i in range(0, self.number_of_genomes - 1):
                for j in range(i + 1, self.number_of_genomes):
                    total_score = 0
                    for k in range(0, self.number_of_trials):
                        index1 = index_matrix[k][i]
                        index2 = index_matrix[k][j]
                        matrix1 = response_list[index1]
                        matrix2 = response_list[index2]
                        total_score += self.computeSimilarityBetweenVectors(matrix1,matrix2,weight_vector)
                    score = total_score / self.number_of_trials
                    kernel[i][j] = score
                    kernel[j][i] = score
        else:
            valid_trial_list = self.getValidTrials(response_list,index_matrix)
            for i in range(0, self.number_of_genomes - 1):
                for j in range(i + 1, self.number_of_genomes):
                    num_valid = 0
                    count = 0
                    for k in valid_trial_list:
                        index1 = index_matrix[k][i]
                        index2 = index_matrix[k][j]
                        if response_list[index1] is not int(-1) and response_list[index2] is not int(-1):
                            num_valid = num_valid + 1
                            if response_list[index1] == response_list[index2]:
                                count = count + 1
                    if num_valid == 0:
                        score = None
                    else:
                        score = count / num_valid
                    kernel[i][j] = score
                    kernel[j][i] = score
        return kernel
    
    def getValidTrials(self, response_list,index_matrix):
        valid_trial_list = []
        for i in range(0, self.number_of_trials):
            index1 = index_matrix[i][0]
            for j in range(1, self.number_of_genomes):
                index2 = index_matrix[i][j]
                if response_list[index1] != response_list[index2]:
                    valid_trial_list.append(i)
                    break
        return valid_trial_list

    def computeSimilarityBetweenVectors(self, matrix1,matrix2,weight_vector):
        """compute the similarity score between two vectors/matrix,
        the weight must be a 1*n vector where n is the number of entities
        """
        num_of_entities,num_of_time_points = matrix1.shape
        matrix1, matrix2 = self.rescaleVector(matrix1, matrix2)
        if weight_vector is None:
            similarity = 1 - 1/(num_of_entities * num_of_time_points)*np.sum((matrix1 - matrix2)**2)
        else:
            similarity = 1 - 1/(num_of_entities * num_of_time_points)*np.sum(np.dot(weight_vector,(matrix1 - matrix2)**2))
        return similarity

    def rescaleVector(self, matrix1, matrix2):
        """take two sim1 output and return a rescaled version """
        max1 = np.amax(matrix1, axis=0, keepdims=True)
        max2 = np.amax(matrix2, axis=0, keepdims=True)
        max_vector = np.maximum(max1, max2)  # TODO Cache the value to improve effieciency
        new_matrix1 = matrix1/max_vector
        new_matrix2 = matrix2/max_vector
        return new_matrix1, new_matrix2

    def writeDataFile(self, similarity_matrix, output_trials):
        path = os.getcwd()
        self.changeWorkingDirectory(path + self.OUTPUT_FOLDER_NAME)
        file_name = self.OUTPUT_FILE_NAME + output_trials + ".csv"
        with open(file_name, 'w') as csv_file:
            try:
                data_writer = csv.writer(csv_file)
                for i in range(0, self.number_of_genomes):
                    data_writer.writerow(similarity_matrix[i])
            finally:
                csv_file.close()
                os.chdir(path)

    #TODO: repeated code with FileProcessingService. DRY it up.
    def changeWorkingDirectory(self, new_directory):
        if not os.path.isdir(new_directory):
            os.mkdir(new_directory)
        os.chdir(new_directory)

    @staticmethod
    def splitSimilarityMatrixForTraining(similarity_matrix, training_set):
        new_matrix = []
        for i in range(0, len(training_set)):
            new_matrix_row = []
            for j in range(0, len(training_set)):
                new_matrix_row.append(similarity_matrix[training_set[i], training_set[j]])

            new_matrix.append(np.around(new_matrix_row, 2).tolist())
        return new_matrix

    @staticmethod
    def splitSimilarityMatrixForTesting(similarity_matrix, testing_set, train_length):
        testing_matrix = []
        for i in range(0, len(testing_set)):
            new_matrix_row = []
            for j in range(0, train_length):
                new_matrix_row.append(similarity_matrix[testing_set[i], j])
            testing_matrix.append(new_matrix_row)
        return testing_matrix
