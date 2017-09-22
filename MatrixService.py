from __future__ import division
import os
import csv
import numpy as np

class MatrixService(object):
    
    OUTPUT_FILE_NAME = "Sim1SimilarityMatrix.csv"

    #TODO Add the inputs for weight_vector
    def __init__(self, simulation_result, number_of_genomes, number_of_trials):
        self.simulation_result = simulation_result
        self.number_of_genomes = int(number_of_genomes)
        self.number_of_trials = int(number_of_trials)

    def generateSimilarityMatrix(self):
        response_list = self.generateResponseList()
        index_matrix = self.generateIndexMatrix()
        similarity_matrix = self.computeSimilarityScores(response_list,index_matrix,weight_vector=None)
        self.writeDataFile(similarity_matrix)
        return similarity_matrix

    def generateIndexMatrix(self):
        """return a matrix with the dimentions as number of trials * (number of geneomes * length of sim1outputs) contains all the index"""
        index_list = np.arange(0,self.number_of_genomes * self.number_of_trials)
        response_matrix = index_list.reshape(self.number_of_trials,-1)
        return response_matrix

    def generateResponseList(self):
        response_list = []
        for file in self.simulation_result.keys():
            response_list.append(self.simulation_result[file])
        return response_list

    def computeSimilarityScores(self, response_list,index_matrix,weight_vector):
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
            for j in range(1, self.number_of_genomes):
                index1 = index_matrix[i][j]
                index2 = index_matrix[i][0]
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
        max1 = np.amax(matrix1,axis = 1,keepdims = True)
        max2 = np.amax(matrix2 , axis = 1,keepdims = True)
        max_vector = np.max((max1,max2), axis = 0)#TODO check the if this is the correct
        matrix1 /= max_vector
        matrix2 /= max_vector
        return matrix1,matrix2

    def writeDataFile(self, similarity_matrix):
        path = os.getcwd()
        self.changeWorkingDirectory(path + "/GenomeFiles")
        with open(self.OUTPUT_FILE_NAME, 'w') as csv_file:
            try:
                data_writer = csv.writer(csv_file)
                for i in range(0, self.number_of_genomes):
                    data_writer.writerow(similarity_matrix[i])
            finally:
                csv_file.close()
                os.chdir(path)

    #TODO: repeated code with FileProcessingService. DRY it up.
    def changeWorkingDirectory(self, new_directory):
        if os.path.isdir(new_directory):
            os.chdir(new_directory)
        else:
            os.mkdir(new_directory)
