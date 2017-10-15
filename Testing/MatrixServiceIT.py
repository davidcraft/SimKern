import logging
import shutil
import unittest
import os
import numpy
from random import randint

import MatrixService


class MatrixServiceIT(unittest.TestCase):

    log = logging.getLogger(__name__)
    log.setLevel(logging.INFO)

    def setUp(self):
        self.current_working_dir = os.getcwd()  # Should be this package.
        self.number_of_genomes = 10
        self.number_of_trials = 5

    def tearDown(self):
        generated_matrix_directory = self.current_working_dir + MatrixService.MatrixService.OUTPUT_FOLDER_NAME
        if generated_matrix_directory != "/" and os.path.isdir(generated_matrix_directory):
            shutil.rmtree(generated_matrix_directory)

    def randomizeSimulationResponses(self):
        simulation_result = {}
        for trial in range(0, self.number_of_trials):
            for genome in range(0, self.number_of_genomes):
                simulation_result["trial" + str(trial) + "genome" + str(genome)] = randint(0, 1)
        return simulation_result

    def validateSimilarityMatrix(self, similarity_matrix, number_of_genomes):
        for genome in range(0, number_of_genomes):
            for other_genome in range(0, number_of_genomes):
                assert similarity_matrix[genome][other_genome] == similarity_matrix[other_genome][genome]

    def testSimilarityKernelMatrixCreatedAndSplit(self):
        simulation_result = self.randomizeSimulationResponses()

        matrix_service = MatrixService.MatrixService(simulation_result, self.number_of_genomes, self.number_of_trials)
        similarity_matrix = matrix_service.generateSimilarityMatrix()

        self.log.info("Generated kernel matrix: %s", similarity_matrix)
        assert similarity_matrix is not None
        self.validateSimilarityMatrix(similarity_matrix, self.number_of_genomes)

        order = numpy.random.permutation(self.number_of_genomes)
        train_length = int(0.7 * self.number_of_genomes)
        training_set = order[0:train_length]
        testing_set = order[train_length:len(order)]

        similarity_matrix_as_matrix = numpy.matrix(similarity_matrix)
        training_matrix = matrix_service.splitSimilarityMatrixForTraining(similarity_matrix_as_matrix, training_set)
        assert len(training_matrix) is train_length and len(training_matrix[0]) is train_length
        self.validateSimilarityMatrix(training_matrix, train_length)

        testing_matrix = matrix_service.splitSimilarityMatrixForTesting(similarity_matrix_as_matrix, testing_set, train_length)
        assert len(testing_matrix) is len(testing_set) and len(testing_matrix[0]) is train_length
        for i in range(0, len(testing_matrix)):
            for j in range(0, len(testing_matrix[i])):
                assert testing_matrix[i][j] == similarity_matrix_as_matrix[testing_set[i], j]


    def testIndexGenomesByTrialMatrixCreated(self):
        simulation_result = self.randomizeSimulationResponses()

        matrix_service = MatrixService.MatrixService(simulation_result, self.number_of_genomes, self.number_of_trials)
        genomes_by_trial_matrix = matrix_service.generateIndexMatrix()

        self.log.info("Generated genomes by trial matrix: %s", genomes_by_trial_matrix)
        assert genomes_by_trial_matrix is not None
        assert len(genomes_by_trial_matrix) == self.number_of_trials
        for genome in range(0, len(genomes_by_trial_matrix)):
            assert len(genomes_by_trial_matrix[genome]) == self.number_of_genomes
            for trial in range(0, len(genomes_by_trial_matrix[genome])):
                integer_result = genomes_by_trial_matrix[genome][trial]
                assert type(numpy.asscalar(integer_result)) is int
