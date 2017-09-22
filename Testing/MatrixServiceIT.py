import logging
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
        pass

    def randomizeSimulationResponses(self):
        simulation_result = {}
        for trial in range(0, self.number_of_trials):
            for genome in range(0, self.number_of_genomes):
                simulation_result["trial" + str(trial) + "genome" + str(genome)] = randint(0, 1)
        return simulation_result

    def testSimilarityKernelMatrixCreated(self):
        simulation_result = self.randomizeSimulationResponses()

        matrix_service = MatrixService.MatrixService(simulation_result, self.number_of_genomes, self.number_of_trials)
        kernel_matrix = matrix_service.generateSimilarityMatrix()

        self.log.info("Generated kernel matrix: %s", kernel_matrix)
        assert kernel_matrix is not None
        for genome in range(0, self.number_of_genomes):
            for other_genome in range(0, self.number_of_genomes):
                assert kernel_matrix[genome][other_genome] == kernel_matrix[other_genome][genome]

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
