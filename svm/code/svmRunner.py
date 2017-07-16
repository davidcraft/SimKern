import kernelSvm
import typicalSvm

def runSvm(responses, data, svm_type, pct_train):

    if svm_type == "c":
        [train_y, train_S, test_S, test_y] = splitKernel(responses, data, pct_train)
        kernelSvm.kernelSVM(train_y, train_S, test_S, test_y)
    else:
        [train_y, train_X, test_X, test_y] = splitData(responses, data, pct_train)
        typicalSvm.typicalSVM(train_y, train_X, svm_type, test_X, test_y)

def splitKernel(responses, data, pct_train):
    tot_data_length = data.__len__()
    row_to_split_on = int(round(pct_train*tot_data_length))
    if row_to_split_on == tot_data_length:
        test_S = None
        test_y = None
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
            for j in range(0, tot_data_length):
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