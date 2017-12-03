import logging
import numpy

from RandomForest.RandomForestTrainer import RandomForestTrainer
from SupportVectorMachine.SupportVectorMachineTrainer import SupportVectorMachineTrainer
from MatrixService import MatrixService
from GraphingService import GraphingService


class MachineLearningDataProcessingService(object):
    log = logging.getLogger(__name__)
    logging.basicConfig()
    log.setLevel(logging.INFO)

    def __init__(self):
        pass

    NUM_PERMUTATIONS = 100
    TRAINING_PERCENTS = [.2, .4, .6, .8, 1]

    def performMachineLearningOnSIM0(self, output_file, genomes_matrix_file, analysis_type):
        responses = self.readCSVFile(output_file)
        matrix = self.readCSVFile(genomes_matrix_file)

        num_genomes = len(matrix)

        order = numpy.random.permutation(num_genomes)

        train_length = int(0.5 * num_genomes)
        validation_and_testing_length = int(num_genomes / 4)

        training_set = order[0:train_length]
        validation_set = order[train_length: (train_length + validation_and_testing_length)]
        testing_set = order[(train_length + validation_and_testing_length): num_genomes]

        training_matrix = MatrixService.splitGenomeMatrix(matrix, training_set)
        validation_matrix = MatrixService.splitGenomeMatrix(matrix, validation_set)
        testing_matrix = MatrixService.splitGenomeMatrix(matrix, testing_set)

        if analysis_type == "CLASSIFICATION":
            rf_classifier_results = self.runRandomForestClassifier(responses, testing_matrix, testing_set, train_length,
                                                                   training_matrix, validation_matrix, validation_set)

            svm_classifier_results = self.runSVMClassifier(responses, testing_matrix, testing_set, train_length,
                                                           training_matrix, validation_matrix, validation_set)
            full_results = {
                "RF CLASSIFIER": rf_classifier_results,
                "SVM CLASSIFIER": svm_classifier_results
            }
            self.plotResults(full_results, genomes_matrix_file, "SVM and RF Classifier SIM0 Results")
        else:
            rf_regressor_results = self.runRandomForestRegressor(responses, testing_matrix, testing_set, train_length,
                                                                 training_matrix, validation_matrix, validation_set)
            full_results = {
                "RF REGRESSOR": rf_regressor_results,
            }
            self.plotResults(full_results, genomes_matrix_file, "RF Regressor SIM0 Results")

    def runRandomForestClassifier(self, responses, testing_matrix, testing_set, train_length, training_matrix,
                                  validation_matrix, validation_set):
        rf_classifier_results = {}
        for training_percent in self.TRAINING_PERCENTS:
            total_accuracies = []
            for i in range(0, self.NUM_PERMUTATIONS):
                most_accurate_model = None
                most_accurate_model_score = 0

                # further split training matrix.
                sub_order = numpy.random.permutation(train_length)
                sub_train_length = int(training_percent * train_length)
                sub_training_set = sub_order[0:sub_train_length]
                split_train_training_matrix = MatrixService.splitGenomeMatrix(numpy.array(training_matrix),
                                                                              sub_training_set)

                for hyperparameter_optimization in range(20, 30):
                    rf_trainer = RandomForestTrainer(split_train_training_matrix, responses)
                    model = rf_trainer.trainRandomForestClassifierNew(sub_training_set, hyperparameter_optimization)
                    model_score = self.predictModelAccuracy(model, responses, validation_matrix,
                                                            validation_set, True)
                    if model_score <= most_accurate_model_score:
                        continue
                    most_accurate_model = model
                    most_accurate_model_score = model_score
                average_accuracy = self.predictModelAccuracy(most_accurate_model, responses,
                                                             testing_matrix, testing_set, True)
                self.log.debug("Average accuracy for this round of matrix permutations: %s\n", average_accuracy)
                total_accuracies.append(average_accuracy)
                rf_classifier_results[training_percent] = total_accuracies
            self.log.info("Total accuracy of RF Classifier for all rounds of matrix permutations with %s percent "
                          "split: %s", training_percent * 100, numpy.round(numpy.average(total_accuracies), 2))
        self.log.debug("Accuracies by training percent: %s", rf_classifier_results)
        return rf_classifier_results

    def runSVMClassifier(self, responses, testing_matrix, testing_set, train_length, training_matrix, validation_matrix,
                         validation_set):
        svm_classifier_results = {}
        for training_percent in self.TRAINING_PERCENTS:
            total_accuracies = []
            for i in range(0, self.NUM_PERMUTATIONS):
                most_accurate_model = None
                most_accurate_model_score = 0

                # further split training matrix.
                sub_order = numpy.random.permutation(train_length)
                sub_train_length = int(training_percent * train_length)
                sub_training_set = sub_order[0:sub_train_length]
                split_train_training_matrix = MatrixService.splitGenomeMatrix(numpy.array(training_matrix),
                                                                              sub_training_set)

                for hyperparameter_optimization in range(-2, 6):
                    svm_trainer = SupportVectorMachineTrainer(split_train_training_matrix, responses)
                    c_val = 10 ** hyperparameter_optimization
                    model = svm_trainer.trainSupportVectorMachineMultiClassifier(sub_training_set, c_val)
                    model_score = self.predictModelAccuracy(model, responses, validation_matrix,
                                                            validation_set, True)
                    if model_score <= most_accurate_model_score:
                        continue
                    most_accurate_model = model
                    most_accurate_model_score = model_score
                average_accuracy = self.predictModelAccuracy(most_accurate_model, responses,
                                                             testing_matrix, testing_set, True)
                self.log.debug("Average accuracy for this round of matrix permutations: %s\n", average_accuracy)
                total_accuracies.append(average_accuracy)
                svm_classifier_results[training_percent] = total_accuracies
            self.log.info("Total accuracy of SVM Classifier for all rounds of matrix permutations with %s percent "
                          "split: %s", training_percent * 100, numpy.round(numpy.average(total_accuracies), 2))
        self.log.debug("Accuracies by training percent: %s", svm_classifier_results)
        return svm_classifier_results

    def runRandomForestRegressor(self, responses, testing_matrix, testing_set, train_length, training_matrix,
                                 validation_matrix, validation_set):
        rf_regressor_results = {}
        for training_percent in self.TRAINING_PERCENTS:
            total_accuracies = []
            for i in range(0, self.NUM_PERMUTATIONS):
                most_accurate_model = None
                most_accurate_model_score = 0

                # further split training matrix.
                sub_order = numpy.random.permutation(train_length)
                sub_train_length = int(training_percent * train_length)
                sub_training_set = sub_order[0:sub_train_length]
                split_train_training_matrix = MatrixService.splitGenomeMatrix(numpy.array(training_matrix),
                                                                              sub_training_set)

                for hyperparameter_optimization in range(20, 30):
                    rf_trainer = RandomForestTrainer(split_train_training_matrix, responses)
                    model = rf_trainer.trainRandomForestRegressorNew(sub_training_set, hyperparameter_optimization)
                    model_score = self.predictModelAccuracy(model, responses, validation_matrix,
                                                            validation_set, False)
                    if model_score <= most_accurate_model_score:
                        continue
                    most_accurate_model = model
                    most_accurate_model_score = model_score
                average_accuracy = self.predictModelAccuracy(most_accurate_model, responses,
                                                             testing_matrix, testing_set, False)
                self.log.debug("Average accuracy for this round of matrix permutations: %s\n", average_accuracy)
                total_accuracies.append(average_accuracy)
                rf_regressor_results[training_percent] = total_accuracies
            self.log.info("Total accuracy of RF Regressor for all rounds of matrix permutations with %s percent "
                          "split: %s", training_percent * 100, numpy.round(numpy.average(total_accuracies), 2))
        self.log.debug("Accuracies by training percent: %s", rf_regressor_results)
        return rf_regressor_results

    def performMachineLearningOnSIM1(self, output_file, similarity_matrix_file):
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
                                               training_matrix, validation_matrix, validation_set)
        full_results = {
            "KERNELIZED SVM": kernelized_svm
        }

        self.plotResults(full_results, similarity_matrix_file, "SIM1 Kernelized SVM")

    def runKernelizedSVM(self, responses, testing_matrix, testing_set, train_length, training_matrix, validation_matrix,
                         validation_set):
        results_by_percent_train = {}
        for training_percent in self.TRAINING_PERCENTS:
            total_accuracies = []
            for permutation in range(0, self.NUM_PERMUTATIONS):
                most_accurate_model = None
                most_accurate_model_score = 0

                # further split training matrix.
                sub_order = numpy.random.permutation(train_length)
                sub_train_length = int(training_percent * train_length)
                sub_training_set = sub_order[0:sub_train_length]
                split_train_training_matrix = MatrixService.splitSimilarityMatrixForTraining(
                    numpy.array(training_matrix), sub_training_set)

                trimmed_validation_matrix = MatrixService.trimMatrixForTesting(sub_train_length, validation_matrix)
                trimmed_testing_matrix = MatrixService.trimMatrixForTesting(sub_train_length, testing_matrix)

                for hyperparameter_optimization in range(-2, 6):  # c_val hyperparameter optimization
                    svm_trainer = SupportVectorMachineTrainer(split_train_training_matrix, responses)
                    c_val = 10 ** hyperparameter_optimization
                    model = svm_trainer.trainSupportVectorMachineMultiClassifier(sub_training_set, c_val)
                    model_score = self.predictModelAccuracy(model, responses, trimmed_validation_matrix,
                                                            validation_set, True)
                    if model_score <= most_accurate_model_score:
                        continue
                    most_accurate_model = model
                    most_accurate_model_score = model_score
                average_accuracy = self.predictModelAccuracy(most_accurate_model, responses,
                                                             trimmed_testing_matrix, testing_set, True)
                self.log.debug("Average accuracy for this round of matrix permutations: %s\n", average_accuracy)
                total_accuracies.append(average_accuracy)

            results_by_percent_train[training_percent] = total_accuracies
            self.log.info("Total accuracy for all rounds of matrix permutations with %s percent split: %s",
                          training_percent * 100, numpy.round(numpy.average(total_accuracies), 2))
        self.log.debug("Accuracies by training percent: %s", results_by_percent_train)
        return results_by_percent_train

    def performFullSIM0SIM1Analysis(self, output_file, genomes_matrix_file, similarity_matrix_file):
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

        rf_genomic_classifier_results = self.runRandomForestClassifier(responses, genomic_testing_matrix, testing_set,
                                                                       train_length, genomic_training_matrix,
                                                                       genomic_validation_matrix, validation_set)

        svm_genomic_classifier_results = self.runSVMClassifier(responses, genomic_testing_matrix, testing_set,
                                                               train_length, genomic_training_matrix,
                                                               genomic_validation_matrix, validation_set)

        svm_kernel_classifier_results = self.runKernelizedSVM(responses, kernel_testing_matrix, testing_set,
                                                              train_length, kernel_training_matrix,
                                                              kernel_validation_matrix, validation_set)
        full_results = {
            "RF SIM0 CLASSIFIER": rf_genomic_classifier_results,
            "SVM SIM0 CLASSIFIER": svm_genomic_classifier_results,
            "SVM SIM1 CLASSIFIER": svm_kernel_classifier_results
        }
        self.plotResults(full_results, genomes_matrix_file, "SIM0 SIM1 Combined Results")

    def readCSVFile(self, file):
        return numpy.loadtxt(open(file, "rb"), delimiter=",")

    def predictModelAccuracy(self, model, responses, testing_matrix, testing_set, is_classifier):
        if model is None:
            return 0
        predictions = model.predict(testing_matrix)
        accuracies = []
        for i in range(0, len(predictions)):
            genome = testing_set[i]
            real_response = responses[genome]
            prediction = predictions[i]
            accuracy = 0
            if (is_classifier and real_response == prediction) or numpy.abs(prediction - real_response) <= numpy.std(
                    responses):
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
