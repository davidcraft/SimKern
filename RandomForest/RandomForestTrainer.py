from __future__ import division

import logging
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import RandomForestRegressor
from Utilities.SafeCastUtil import SafeCastUtil
from SupportedAnalysisTypes import SupportedAnalysisTypes
import numpy


class RandomForestTrainer(object):

    log = logging.getLogger(__name__)
    logging.basicConfig()
    log.setLevel(logging.INFO)
    log.addHandler(logging.StreamHandler())

    def __init__(self, genomes_array, third_party_response):
        self.genomes_array = genomes_array
        self.third_party_response = third_party_response

    def trainRandomForest(self, training_set, m_val, max_depth, analysis_type):
        max_leaf_nodes = numpy.maximum(2, SafeCastUtil.safeCast(numpy.ceil(max_depth), int))
        max_features = SafeCastUtil.safeCast(numpy.floor(m_val), int)
        if analysis_type == SupportedAnalysisTypes.CLASSIFICATION:
            model = RandomForestClassifier(n_estimators=100, max_leaf_nodes=max_leaf_nodes, max_features=max_features)
        else:
            model = RandomForestRegressor(n_estimators=100, max_leaf_nodes=max_leaf_nodes, max_features=max_features)
        sample_labels = []
        for label in range(0, int(len(training_set))):
            sample_labels.append(self.third_party_response[training_set.tolist()[label]])
        if len(numpy.unique(sample_labels)) <= 1:
            return None
        model.fit(self.genomes_array, sample_labels)
        self.log.debug("Successful creation of Random Forest classifier model: %s\n", model)
        return model

    # TODO: Remove this old code and fix up old ITs referencing it.
    def trainRandomForestClassifier(self, pct_train):
        if type(self.third_party_response) != list:
            response_as_list = self.third_party_response.values()
        else:
            response_as_list = self.third_party_response
        filtered_response = [response for response in response_as_list if int(response) >= 0]
        por_success = sum(filtered_response) / len(filtered_response)
        self.log.info("%s percent 1s \n%s percent 0s", str(100 * por_success), str(100 * (1 - por_success)))
        [train_y, train_x, test_x, test_y] = self.splitData(filtered_response, self.genomes_array, pct_train)
        model = RandomForestClassifier(n_estimators=50)
        model.fit(train_x, train_y)
        train_predict = model.predict(train_x)
        test_predict = model.predict(test_x)
        self.log.info("Variable importances: %s", str(model.feature_importances_))
        [train_accuracy, test_accuracy, total_accuracy] = self.getAccuraciesForClassifier(train_predict, train_y,
                                                                                          test_predict, test_y)

        return [model, [train_accuracy, test_accuracy, total_accuracy]]  # Return tuple of model and accuracies



    def trainRandomForestRegressor(self, pct_train):
        if type(self.third_party_response) != list:
            response_as_list = list(self.third_party_response.values())
        else:
            response_as_list = list(self.third_party_response)
        [train_y, train_x, test_x, test_y] = self.splitData(response_as_list, self.genomes_array, pct_train)
        model = RandomForestRegressor(n_estimators=50)
        model.fit(train_x, train_y)
        train_predict = model.predict(train_x)
        test_predict = model.predict(test_x)

        # Use standard deviation of all results as threshold for "accurate". TODO: Consider quelling outliers.
        std_dev_of_results = numpy.std(response_as_list)
        [train_accuracy, test_accuracy, total_accuracy] = self.getAccuraciesForRegressor(train_predict, train_y,
                                                                                         test_predict, test_y,
                                                                                         std_dev_of_results)

        self.log.info("Variable importances: %s", str(model.feature_importances_))
        return [model, [train_accuracy, test_accuracy, total_accuracy]]  # Return tuple of model and accuracies

    def splitData(self, responses, data, pct_train):
        num_samples = len(data)
        num_features = len(data[0])
        row_to_split_on = int(round(pct_train * num_samples))
        if row_to_split_on == num_samples:
            test_x = None
            test_y = None
            return [responses, data, test_y, test_x]
        elif row_to_split_on == 0:
            raise ValueError("Error: no training data specified. Increase pct_train.")
        else:
            train_y = []
            train_x = []
            test_y = []
            test_x = []
            for i in range(0, row_to_split_on):
                train_y.append(responses[i])
                train_x.append([])
                for j in range(0, num_features):
                    train_x[i].append(data[i][j])
            for i in range(row_to_split_on, num_samples):
                test_y.append(responses[i])
                test_x.append([])
                for j in range(0, num_features):
                    test_x[i - row_to_split_on].append(data[i][j])
            return [train_y, train_x, test_x, test_y]

    def getAccuraciesForClassifier(self, train_predict, train_y, test_predict, test_y):

        train_length = len(train_y)
        matching_train_predictions = self.count_matching_predictions(train_length, train_predict, train_y)

        train_accuracy = matching_train_predictions / train_length

        test_length = len(test_y)
        matching_test_predictions = self.count_matching_predictions(test_length, test_predict, test_y)
        test_accuracy = matching_test_predictions / test_length

        total_accuracy = (matching_train_predictions + matching_test_predictions) / (train_length + test_length)

        self.log.info("Training predictions: %s", str(train_predict))
        self.log.info("Training accuracy: %s", str(train_accuracy))
        self.log.info("Testing predictions: %s", str(test_predict))
        self.log.info("Testing accuracy: %s", str(test_accuracy))
        self.log.info("Total accuracy: %s", str(total_accuracy))

        return [train_accuracy, test_accuracy, total_accuracy]

    def count_matching_predictions(self, data_length, predicted_data, actual_data):
        count = 0
        for i in range(0, data_length):
            if predicted_data[i] == actual_data[i]:
                count += 1
        return count

    def getAccuraciesForRegressor(self, train_predict, train_y, test_predict, test_y, std_dev):
        train_length = len(train_y)
        matching_train_predictions = self.count_predictions_within_threshold(train_length, train_predict, train_y, std_dev)

        train_accuracy = matching_train_predictions / train_length

        test_length = len(test_y)
        matching_test_predictions = self.count_predictions_within_threshold(test_length, test_predict, test_y, std_dev)
        test_accuracy = matching_test_predictions / test_length

        total_accuracy = (matching_train_predictions + matching_test_predictions) / (train_length + test_length)

        self.log.info("Training predictions: %s", str(train_predict))
        self.log.info("Training accuracy: %s", str(train_accuracy))
        self.log.info("Testing predictions: %s", str(test_predict))
        self.log.info("Testing accuracy: %s", str(test_accuracy))
        self.log.info("Total accuracy: %s", str(total_accuracy))

        return [train_accuracy, test_accuracy, total_accuracy]

    def count_predictions_within_threshold(self, data_length, predicted_data, actual_data, threshold):
        count = 0
        for i in range(0, data_length):
            if numpy.abs(predicted_data[i] - actual_data[i]) <= threshold:
                count += 1
        return count

