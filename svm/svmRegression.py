from __future__ import division
from sklearn.svm import SVR

def runSVM(responses, data, kernel_type, pct_train):

# Supported kernel types include "linear," "poly," "rbf," "sigmoid," and "precomputed"
    if type(responses)!= list:
        response_list=[]
        for file in responses.keys():
            response_list.append(responses[file])
    else:
        response_list=responses
    print("SUPPORT VECTOR MACHINE output")


    if kernel_type == "precomputed":
        [train_y, train_X, test_X, test_y] = splitMatrix(response_list, data, pct_train)
    else:
        [train_y, train_X, test_X, test_y] = splitData(response_list, data, pct_train)

    mod=SVR(kernel=kernel_type)
    mod.fit(train_X, train_y)
    trPr = mod.predict(train_X)
    tePr = mod.predict(test_X)
    trSc = mod.score(train_X, train_y)
    teSc = mod.score(test_X, test_y)
    totSc = mod.score(data, response_list)
    print("Training predictions: " + str(trPr))
    print("Training accuracy: " + str(trSc))
    print("Testing predictions: " + str(tePr))
    print("Testing accuracy: " + str(teSc))
    print("Overall accuracy: " + str(totSc))
    return [trSc,teSc,totSc]

def splitMatrix(responses, data, pct_train):
    tot_data_length = data.__len__()
    row_to_split_on = int(round(pct_train*tot_data_length))
    if row_to_split_on == tot_data_length:
        test_S = None
        test_y = None
        print("Warning: no testing data specified. Decrease pct_train to fix.")
        return [responses, data, test_S, test_y]
    elif row_to_split_on == 0:
        print("Error: no training data specified. Increase pct_train.")
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
                test_S[i-row_to_split_on].append(data[i][j])
        return [train_y, train_S, test_S, test_y]

def splitData(responses, data, pct_train):
    num_samples = data.__len__()
    num_characteristics = data[0].__len__()
    row_to_split_on = int(round(pct_train * num_samples))
    if row_to_split_on == num_samples:
        test_X = None
        test_y = None
        return [responses, data, test_X, test_y]
    elif row_to_split_on == 0:
        print("Error: no training data specified. Increase pct_train.")
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