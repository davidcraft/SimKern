import logging

import numpy

from GraphingService import GraphingService
from MatrixService import MatrixService
from RandomForest.RandomForestTrainer import RandomForestTrainer
from SupportVectorMachine.SupportVectorMachineTrainer import SupportVectorMachineTrainer
from SupportVectorMachine.SupportedKernelFunctionTypes import SupportedKernelFunctionTypes
from SupportedAnalysisTypes import SupportedAnalysisTypes


class MachineLearningDataProcessingService(object):
    log = logging.getLogger(__name__)
    logging.basicConfig()
    log.setLevel(logging.INFO)

    def __init__(self, num_permutations):
        self.NUM_PERMUTATIONS = num_permutations

    TRAINING_PERCENTS = [.2, .4, .6, .8, 1]

    def performMachineLearningOnSIM0(self, output_file, genomes_matrix_file, analysis_type):
        responses = self.readCSVFile(output_file)
        genome_matrix = self.readCSVFile(genomes_matrix_file)

        num_genomes = len(genome_matrix)

        order = numpy.random.permutation(num_genomes)

        train_length = int(0.5 * num_genomes)
        validation_and_testing_length = int(num_genomes / 4)

        training_set = order[0:train_length]
        validation_set = order[train_length: (train_length + validation_and_testing_length)]
        testing_set = order[(train_length + validation_and_testing_length): num_genomes]

        training_matrix = MatrixService.splitGenomeMatrix(genome_matrix, training_set)
        validation_matrix = MatrixService.splitGenomeMatrix(genome_matrix, validation_set)
        testing_matrix = MatrixService.splitGenomeMatrix(genome_matrix, testing_set)

        rf_results = self.runRandomForest(responses, testing_matrix, testing_set, train_length,
                                          training_matrix, validation_matrix, validation_set, analysis_type)
        svm_results_rbf = self.runGenomicSVM(responses, testing_matrix, testing_set, train_length,
                                             training_matrix, validation_matrix, validation_set,
                                             SupportedKernelFunctionTypes.RADIAL_BASIS_FUNCTION, analysis_type)
        svm_results_linear = self.runGenomicSVM(responses, testing_matrix, testing_set, train_length,
                                                training_matrix, validation_matrix, validation_set,
                                                SupportedKernelFunctionTypes.LINEAR, analysis_type)

        full_results = {
            "RF " + analysis_type: rf_results,
            "SVM " + analysis_type + " (RBF)": svm_results_rbf,
            "SVM " + analysis_type + " (LINEAR)": svm_results_linear
        }
        self.plotResults(full_results, genomes_matrix_file, "SVM and RF " + analysis_type + " SIM0 Results")

    def runRandomForest(self, responses, testing_matrix, testing_set, train_length, training_matrix,
                        validation_matrix, validation_set, analysis_type):
        rf_results = {}
        for training_percent in self.TRAINING_PERCENTS:
            total_accuracies = []
            for i in range(0, self.NUM_PERMUTATIONS):
                # further split training matrix.
                sub_order = numpy.random.permutation(train_length)
                sub_train_length = int(training_percent * train_length)
                sub_training_set = sub_order[0:sub_train_length]
                split_train_training_matrix = MatrixService.splitGenomeMatrix(numpy.array(training_matrix),
                                                                              sub_training_set)

                most_accurate_model = self.optimizeHyperparametersForRF(analysis_type, responses,
                                                                        split_train_training_matrix, sub_training_set,
                                                                        validation_matrix, validation_set)
                average_accuracy = self.predictModelAccuracy(most_accurate_model, responses,
                                                             testing_matrix, testing_set, analysis_type)
                self.log.debug("Average accuracy for this round of matrix permutations: %s\n", average_accuracy)
                total_accuracies.append(average_accuracy)
                rf_results[training_percent] = total_accuracies
            self.log.info("Total accuracy of RF Classifier for all rounds of matrix permutations with %s percent "
                          "split: %s", training_percent * 100, numpy.round(numpy.average(total_accuracies), 2))
        self.log.debug("Accuracies by training percent: %s", rf_results)
        return rf_results

    def optimizeHyperparametersForRF(self, analysis_type, responses, training_matrix, training_set,
                                     validation_matrix, validation_set):
        most_accurate_model = None
        most_accurate_model_score = 0
        p = len(training_matrix[0])  # number of features
        n = len(training_matrix)  # number of samples
        for mval in [1, (1 + numpy.sqrt(p)) / 2, numpy.sqrt(p), (numpy.sqrt(p) + p) / 2, p]:
            for max_depth in [0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.75, 1]:
                rf_trainer = RandomForestTrainer(training_matrix, responses)
                if analysis_type == SupportedAnalysisTypes.CLASSIFICATION:
                    model = rf_trainer.trainRandomForestClassifierNew(training_set, mval, max_depth*n)
                else:
                    model = rf_trainer.trainRandomForestRegressorNew(training_set, mval, max_depth*n)
                model_score = self.predictModelAccuracy(model, responses, validation_matrix,
                                                        validation_set, analysis_type)
                if model_score <= most_accurate_model_score:
                    continue
                most_accurate_model_score = model_score
                most_accurate_model = model
        return most_accurate_model

    def runGenomicSVM(self, responses, testing_matrix, testing_set, train_length, training_matrix, validation_matrix,
                      validation_set, kernel_type, analysis_type):
        svm_results = {}
        for training_percent in self.TRAINING_PERCENTS:
            total_accuracies = []
            for i in range(0, self.NUM_PERMUTATIONS):
                # further split training matrix.
                sub_order = numpy.random.permutation(train_length)
                sub_train_length = int(training_percent * train_length)
                sub_training_set = sub_order[0:sub_train_length]
                split_train_training_matrix = MatrixService.splitGenomeMatrix(numpy.array(training_matrix),
                                                                              sub_training_set)

                most_accurate_model = self.optimizeHyperparametersForSVM(kernel_type, analysis_type, responses,
                                                                         split_train_training_matrix, sub_training_set,
                                                                         validation_matrix, validation_set)

                average_accuracy = self.predictModelAccuracy(most_accurate_model, responses,
                                                             testing_matrix, testing_set, analysis_type)
                self.log.debug("Average accuracy for this round of matrix permutations: %s\n", average_accuracy)
                total_accuracies.append(average_accuracy)
                svm_results[training_percent] = total_accuracies
            self.log.info("Total accuracy of SVM %s for all rounds of matrix permutations with %s percent "
                          "split: %s", analysis_type, training_percent * 100,
                          numpy.round(numpy.average(total_accuracies), 2))
        self.log.debug("Accuracies by training percent: %s", svm_results)
        return svm_results

    def optimizeHyperparametersForSVM(self, kernel_type, analysis_type, responses, training_matrix, sub_training_set,
                                      validation_matrix, validation_set):
        most_accurate_model = None
        most_accurate_model_score = 0
        for c_val in [10E-2, 10E-1, 10E0, 10E1, 10E2, 10E3, 10E4, 10E5, 10E6]:
            if analysis_type is SupportedAnalysisTypes.CLASSIFICATION:
                if kernel_type is SupportedKernelFunctionTypes.RADIAL_BASIS_FUNCTION:
                    for gamma in [10E-5, 10E-4, 10E-3, 10E-2, 10E-1, 10E0, 10E1]:
                        svm_trainer = SupportVectorMachineTrainer(training_matrix, responses)
                        model = svm_trainer.trainSupportVectorMachineMultiClassifier(sub_training_set, kernel_type,
                                                                                     c_val, gamma)
                        model_score = self.predictModelAccuracy(model, responses, validation_matrix,
                                                                validation_set, analysis_type)
                        if model_score <= most_accurate_model_score:
                            continue
                        most_accurate_model = model
                        most_accurate_model_score = model_score
                else:
                    svm_trainer = SupportVectorMachineTrainer(training_matrix, responses)
                    model = svm_trainer.trainSupportVectorMachineMultiClassifier(sub_training_set, kernel_type,
                                                                                 c_val, 'auto')
                    model_score = self.predictModelAccuracy(model, responses, validation_matrix,
                                                            validation_set, analysis_type)
                    if model_score <= most_accurate_model_score:
                        continue
                    most_accurate_model = model
                    most_accurate_model_score = model_score
            elif analysis_type is SupportedAnalysisTypes.REGRESSION:
                for epsilon in [0.01, 0.05, 0.1, 0.15, 0.2]:
                    if kernel_type is SupportedKernelFunctionTypes.RADIAL_BASIS_FUNCTION:
                        for gamma in [10E-5, 10E-4, 10E-3, 10E-2, 10E-1, 10E0, 10E1]:
                            svm_trainer = SupportVectorMachineTrainer(training_matrix, responses)
                            model = svm_trainer.trainSupportVectorMachineRegressor(sub_training_set, kernel_type,
                                                                                   c_val, gamma, epsilon)
                            model_score = self.predictModelAccuracy(model, responses, validation_matrix,
                                                                    validation_set, analysis_type)
                            if model_score <= most_accurate_model_score:
                                continue
                            most_accurate_model = model
                            most_accurate_model_score = model_score
                    else:
                        svm_trainer = SupportVectorMachineTrainer(training_matrix, responses)
                        model = svm_trainer.trainSupportVectorMachineRegressor(sub_training_set, kernel_type,
                                                                               c_val, 'auto', epsilon)
                        model_score = self.predictModelAccuracy(model, responses, validation_matrix,
                                                                validation_set, analysis_type)
                        if model_score <= most_accurate_model_score:
                            continue
                        most_accurate_model = model
                        most_accurate_model_score = model_score

        return most_accurate_model

    def performMachineLearningOnSIM1(self, output_file, similarity_matrix_file, analysis_type):
        responses = self.readCSVFile(output_file)
        similarity_matrix = self.readCSVFile(similarity_matrix_file)

        num_genomes = len(similarity_matrix)
        order = numpy.random.permutation(num_genomes)

        train_length = int(0.5 * num_genomes)  # half the similarity matrix
        validation_and_testing_length = int(num_genomes / 4)  # 1/4 the similarity matrix.

        training_set = order[0:train_length]
        validation_set = order[train_length: (train_length + validation_and_testing_length)]
        testing_set = order[(train_length + validation_and_testing_length): num_genomes]

        training_matrix = MatrixService.splitSimilarityMatrixForTraining(similarity_matrix, training_set)
        validation_matrix = MatrixService.splitSimilarityMatrixForTestingAndValidation(similarity_matrix,
                                                                                       validation_set, train_length)
        testing_matrix = MatrixService.splitSimilarityMatrixForTestingAndValidation(similarity_matrix, testing_set,
                                                                                    train_length)

        kernelized_svm = self.runKernelizedSVM(responses, testing_matrix, testing_set, train_length,
                                               training_matrix, validation_matrix, validation_set, analysis_type)
        full_results = {
            "KERNELIZED SVM": kernelized_svm
        }

        self.plotResults(full_results, similarity_matrix_file, "SIM1 Kernelized SVM")

    def runKernelizedSVM(self, responses, testing_matrix, testing_set, train_length, training_matrix, validation_matrix,
                         validation_set, analysis_type):
        results_by_percent_train = {}
        for training_percent in self.TRAINING_PERCENTS:
            total_accuracies = []
            for permutation in range(0, self.NUM_PERMUTATIONS):

                # further split training matrix.
                sub_order = numpy.random.permutation(train_length)
                sub_train_length = int(training_percent * train_length)
                sub_training_set = sub_order[0:sub_train_length]
                split_train_training_matrix = MatrixService.splitSimilarityMatrixForTraining(
                    numpy.array(training_matrix), sub_training_set)

                trimmed_validation_matrix = MatrixService.trimMatrixForTesting(sub_train_length, validation_matrix)
                trimmed_testing_matrix = MatrixService.trimMatrixForTesting(sub_train_length, testing_matrix)

                most_accurate_model = self.optimizeHyperparametersForSVM(SupportedKernelFunctionTypes.RADIAL_BASIS_FUNCTION,
                                                                         analysis_type, responses,
                                                                         split_train_training_matrix, sub_training_set,
                                                                         trimmed_validation_matrix, validation_set)
                average_accuracy = self.predictModelAccuracy(most_accurate_model, responses,
                                                             trimmed_testing_matrix, testing_set, analysis_type)
                self.log.debug("Average accuracy for this round of matrix permutations: %s\n", average_accuracy)
                total_accuracies.append(average_accuracy)

            results_by_percent_train[training_percent] = total_accuracies
            self.log.info("Total accuracy for all rounds of matrix permutations with %s percent split: %s",
                          training_percent * 100, numpy.round(numpy.average(total_accuracies), 2))
        self.log.debug("Accuracies by training percent: %s", results_by_percent_train)
        return results_by_percent_train

    def performFullSIM0SIM1Analysis(self, output_file, genomes_matrix_file, similarity_matrix_file, analysis_type):
        responses = self.readCSVFile(output_file)
        genomes_matrix = self.readCSVFile(genomes_matrix_file)
        similarity_matrix = self.readCSVFile(similarity_matrix_file)

        num_genomes = len(genomes_matrix)

        order = numpy.random.permutation(num_genomes)

        train_length = int(0.5 * num_genomes)
        validation_and_testing_length = int(num_genomes / 4)

        training_set = order[0:train_length]
        validation_set = order[train_length: (train_length + validation_and_testing_length)]
        testing_set = order[(train_length + validation_and_testing_length): num_genomes]

        genomic_training_matrix = MatrixService.splitGenomeMatrix(genomes_matrix, training_set)
        genomic_validation_matrix = MatrixService.splitGenomeMatrix(genomes_matrix, validation_set)
        genomic_testing_matrix = MatrixService.splitGenomeMatrix(genomes_matrix, testing_set)

        kernel_training_matrix = MatrixService.splitSimilarityMatrixForTraining(similarity_matrix, training_set)
        kernel_validation_matrix = MatrixService.splitSimilarityMatrixForTestingAndValidation(similarity_matrix,
                                                                                              validation_set,
                                                                                              train_length)
        kernel_testing_matrix = MatrixService.splitSimilarityMatrixForTestingAndValidation(similarity_matrix,
                                                                                           testing_set,
                                                                                           train_length)

        rf_genomic_results = self.runRandomForest(responses, genomic_testing_matrix, testing_set,
                                                  train_length, genomic_training_matrix,
                                                  genomic_validation_matrix, validation_set, analysis_type)

        svm_genomic_results_rbf = self.runGenomicSVM(responses, genomic_testing_matrix, testing_set,
                                                     train_length, genomic_training_matrix,
                                                     genomic_validation_matrix, validation_set,
                                                     SupportedKernelFunctionTypes.RADIAL_BASIS_FUNCTION, analysis_type)

        svm_genomic_results_linear = self.runGenomicSVM(responses, genomic_testing_matrix, testing_set,
                                                        train_length, genomic_training_matrix,
                                                        genomic_validation_matrix, validation_set,
                                                        SupportedKernelFunctionTypes.LINEAR, analysis_type)

        svm_kernel_results = self.runKernelizedSVM(responses, kernel_testing_matrix, testing_set,
                                                   train_length, kernel_training_matrix,
                                                   kernel_validation_matrix, validation_set, analysis_type)
        full_results = {
            "RF SIM0 " + analysis_type: rf_genomic_results,
            "SVM SIM0 " + analysis_type + " (RBF)": svm_genomic_results_rbf,
            "SVM SIM0 " + analysis_type + " (LINEAR)": svm_genomic_results_linear,
            "SVM SIM1 " + analysis_type: svm_kernel_results
        }
        self.plotResults(full_results, genomes_matrix_file, "SIM0 SIM1 Combined Results")

    def readCSVFile(self, file):
        return numpy.loadtxt(open(file, "rb"), delimiter=",")

    def predictModelAccuracy(self, model, responses, testing_matrix, testing_set, analysis_type):
        if model is None:
            return 0
        predictions = model.predict(testing_matrix)
        accuracies = []
        for i in range(0, len(predictions)):
            genome = testing_set[i]
            real_response = responses[genome]
            prediction = predictions[i]
            accuracy = 0
            if analysis_type == SupportedAnalysisTypes.CLASSIFICATION and real_response == prediction:
                accuracy = 1
            if analysis_type == SupportedAnalysisTypes.REGRESSION and\
                            numpy.abs(prediction - real_response) <= numpy.std(responses):
                accuracy = 1
            accuracies.append(accuracy)
            self.log.debug("Predicted outcome for genome %s vs actual outcome: %s vs %s", genome, prediction,
                           real_response)
        average_accuracy = numpy.average(accuracies)
        return average_accuracy

    def plotResults(self, full_results, csv_file_location, title):
        try:
            output_path = ""
            csv_path_split = csv_file_location.split("/")
            for i in range(1, len(csv_path_split) - 1):
                output_path += "/" + csv_path_split[i]
            graphing_service = GraphingService()
            graphing_service.makeMultiBarPlotWithMultipleAnalysis(full_results, output_path, title)
        except Exception as exception:
            self.log.error("Unable to create or save graphs due to: %s", exception)
