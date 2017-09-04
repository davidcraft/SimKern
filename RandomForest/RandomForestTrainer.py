from __future__ import division

import logging
from sklearn.ensemble import RandomForestClassifier

from SupportedThirdPartyResponses import SupportedThirdPartyResponses


class RandomForestTrainer(object):

    log = logging.getLogger(__name__)
    logging.basicConfig()
    log.setLevel(logging.INFO)

    def __init__(self, genomes_array, third_party_response, response_type):
        self.genomes_array = genomes_array
        self.third_party_response = third_party_response
        self.response_type = response_type

    def trainRandomForest(self, pct_train):
        if self.response_type == SupportedThirdPartyResponses.INTEGER:
            if type(self.third_party_response) != list:
                response_as_list = self.third_party_response.values()
            else:
                response_as_list = self.third_party_response
            filtered_response = [response for response in response_as_list if int(response) >= 0]
            por_success = sum(filtered_response) / len(filtered_response)
            self.log.info("%s percent 1s \n%s percent 0s", str(100 * por_success), str(100 * (1 - por_success)))
            [train_y, train_x, test_x, test_y] = self.splitData(filtered_response, self.genomes_array, pct_train)
            mod = RandomForestClassifier(n_estimators=50)
            mod.fit(train_x, train_y)
            train_predict = mod.predict(train_x)
            test_predict = mod.predict(test_x)
            [train_accuracy, test_accuracy, total_accuracy] = self.getAccuracies(train_predict, train_y, test_predict, test_y)
            self.log.info("Training predictions: %s", str(train_predict))
            self.log.info("Training accuracy: %s", str(train_accuracy))
            self.log.info("Testing predictions: %s", str(test_predict))
            self.log.info("Testing accuracy: %s", str(test_accuracy))
            self.log.info("Total accuracy: %s", str(total_accuracy))
            self.log.info("Variable importances: %s", str(mod.feature_importances_))
            return mod

        elif self.response_type == SupportedThirdPartyResponses.VECTOR:
            # TODO: Figure out a good similarity score measure for these vectors and train a regressor.
            return None

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

    def getAccuracies(self, train_predict, train_y, test_predict, test_y):

        train_length = len(train_y)
        matching_train_predictions = self.count_matching_predictions(train_length, train_predict, train_y)

        train_accuracy = matching_train_predictions / train_length

        test_length = len(test_y)
        matching_test_predictions = self.count_matching_predictions(test_length, test_predict, test_y)
        test_accuracy = matching_test_predictions / test_length

        total_accuracy = (matching_train_predictions + matching_test_predictions) / (train_length + test_length)

        return [train_accuracy, test_accuracy, total_accuracy]

    def count_matching_predictions(self, data_length, predicted_data, actual_data):
        count = 0
        for i in range(0, data_length):
            if predicted_data[i] == actual_data[i]:
                count += 1
        return count
