from __future__ import division

import logging

from sklearn import svm
from sklearn.svm import SVC
import numpy as np


class SupportVectorMachineTrainer(object):

    log = logging.getLogger(__name__)
    logging.basicConfig()
    log.setLevel(logging.INFO)

    def __init__(self, similarity_matrix, third_party_response):
        self.matrix = similarity_matrix
        self.third_party_response = third_party_response

    def trainSupportVectorMachineForSIM1(self, training_set):
        multi_classifier_model = svm.SVC(decision_function_shape='ovo')
        sample_labels = []
        for label in range(0, int(len(training_set))):
            sample_labels.append(int(training_set.tolist()[label]))
        multi_classifier_model.fit(self.matrix, sample_labels)
        self.log.debug("Successful creation of classifier model: %s\n", multi_classifier_model)
        return multi_classifier_model

    def trainSupportVectorMachineForSIM0(self, kernel_type, pct_train):

        # Supported kernel types include "linear," "poly," "rbf," "sigmoid," and "precomputed"
        if (type(self.third_party_response) != np.ndarray) & (type(self.third_party_response) != list):
            response_list = []
            for file in self.third_party_response.keys():
                response_list.append(self.third_party_response[file])
        else:
            response_list = self.third_party_response

        if kernel_type == "precomputed":
            [train_y, train_X, test_X, test_y] = self.splitMatrix(response_list, self.matrix, pct_train)
        else:
            [train_y, train_X, test_X, test_y] = self.splitData(response_list, self.matrix, pct_train)

        model = SVC(kernel=kernel_type)
        model.fit(train_X, train_y)
        trPr = model.predict(train_X)
        tePr = model.predict(test_X)
        [trAc, teAc, totAc] = self.getAccuracies(trPr, train_y, tePr, test_y)
        self.log.info("Training predictions: " + str(trPr))
        self.log.info("Training accuracy: " + str(trAc))
        self.log.info("Testing predictions: " + str(tePr))
        self.log.info("Testing accuracy: " + str(teAc))
        self.log.info("Overall accuracy: " + str(totAc))
        return [model, [trAc, teAc, totAc]]

    def splitMatrix(self, responses, data, pct_train):
        tot_data_length = data.__len__()
        row_to_split_on = int(round(pct_train * tot_data_length))
        if row_to_split_on == tot_data_length:
            test_S = None
            test_y = None
            self.log.info("Warning: no testing data specified. Decrease pct_train to fix.")
            return [responses, data, test_S, test_y]
        elif row_to_split_on == 0:
            self.log.info("Error: no training data specified. Increase pct_train.")
        else:
            train_y = []
            train_S = []
            test_y = []
            test_S = []
            for i in range(0, row_to_split_on):
                train_y.append(responses[i])
                train_S.append([])
                for j in range(0, row_to_split_on):
                    train_S[i].append(data[i][j])
            for i in range(row_to_split_on, tot_data_length):
                test_y.append(responses[i])
                test_S.append([])
                for j in range(0, train_S.__len__()):
                    test_S[i - row_to_split_on].append(data[i][j])
            return [train_y, train_S, test_S, test_y]

    def splitData(self, responses, data, pct_train):
        num_samples = data.__len__()
        num_characteristics = data[0].__len__()
        row_to_split_on = int(round(pct_train * num_samples))
        if row_to_split_on == num_samples:
            test_X = None
            test_y = None
            return [responses, data, test_X, test_y]
        elif row_to_split_on == 0:
            self.log.info("Error: no training data specified. Increase pct_train.")
        else:
            train_y = []
            train_X = []
            test_y = []
            test_X = []
            for i in range(0, row_to_split_on):
                train_y.append(responses[i])
                train_X.append([])
                for j in range(0, num_characteristics):
                    train_X[i].append(data[i][j])
            for i in range(row_to_split_on, num_samples):
                test_y.append(responses[i])
                test_X.append([])
                for j in range(0, num_characteristics):
                    test_X[i - row_to_split_on].append(data[i][j])
            return [train_y, train_X, test_X, test_y]

    def getAccuracies(self, trPr, train_y, tePr, test_y):
        trLen = train_y.__len__()
        count1 = 0
        for i in range(0, trLen):
            if trPr[i] == train_y[i]:
                count1 = count1 + 1

        trAc = count1 / trLen

        teLen = test_y.__len__()
        count2 = 0
        for i in range(0, teLen):
            if tePr[i] == test_y[i]:
                count2 = count2 + 1
        teAc = count2 / teLen

        totAc = (count1 + count2) / (trLen + teLen)

        return [trAc, teAc, totAc]
