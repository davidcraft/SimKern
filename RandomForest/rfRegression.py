from __future__ import division
from sklearn.ensemble import RandomForestRegressor

def runRF(responses, data, pct_train):
    if type(responses)!=list:
        response_list = []
        for file in responses.keys():
            response_list.append(responses[file])
    else:
        response_list=responses



    print("RANDOM FOREST output")

    [train_y, train_X, test_X, test_y] = splitData(response_list, data, pct_train)
    mod=RandomForestRegressor(n_estimators=50)
    mod.fit(train_X, train_y)
    trPr=mod.predict(train_X)
    tePr=mod.predict(test_X)
    trSc=mod.score(train_X, train_y)
    teSc=mod.score(test_X, test_y)
    totSc=mod.score(data, response_list)
    print("Training predictions: " + str(trPr))
    print("Training R^2: " + str(trSc))
    print("Testing predictions: " + str(tePr))
    print("Testing ^2: " + str(teSc))
    print("Overall ^2: " + str(totSc))
    print("Variable importances: " + str(mod.feature_importances_))
    return [trSc,teSc,totSc]


def splitData(responses, data, pct_train):
    num_samples = data.__len__()
    num_characteristics = data[0].__len__()
    row_to_split_on = int(round(pct_train * num_samples))
    if row_to_split_on == num_samples:
        test_X = None
        test_y = None
        return [responses, data, test_y, test_X]
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
