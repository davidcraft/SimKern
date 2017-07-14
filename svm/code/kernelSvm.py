from __future__ import division
from svmutil import *


def kernelSVM(train_y, S, test_S=None, test_y=None):

    # This function automates the entire process. It will train and test with the data specified and print the results.


    # INPUTS

    # train_y is the training responses. It is a list of 0s and 1s.
    # S is list of lists representing the similarity matrix. It is the kernel. Values should range from 0 to 1.
    # Diagonal should be all 1s. It should be square.
    # test_S is a list of lists (matrix) that includes similarity scores relating the test
    # data points to the training points, as well as the test points to each other
    # A test point should have a similarity score of 1 with itself.
    # Note: test_S will NOT be a square matrix.
    # test_y is a list of responses for the test data. Also 0s and 1s.

    # OUTPUT

    # This will print out the training predictions, the training accuracy, and if specified, the testing predictions
    # and the testing accuracy.


    mod=train(train_y, S)

    if test_S!=None:

        newY=updateY(train_y, test_S, test_y)
        newS=updateKernel(S, test_S)

        predicts=predict(newY,newS,mod)
        [trPr,trAc,tePr,teAc]=stats(predicts,test_y,test_S,train_y)

        print("Training predictions: "+str(trPr))
        print("Training accuracy: "+ str(trAc))
        print("Testing predictions: "+ str(tePr))

        if teAc!=None:

            print("Testing Accuracy: "+ str(teAc))

    else:

        predicts=predict(train_y, S, mod)
        right=0

        for i in range(0,train_y.__len__()):

            if predicts[i]==train_y[i]:

                right=right+1

        print("Training predictions: "+str(predicts))
        tot=train_y.__len__()
        trAc=(right/tot)
        print("Training accuracy: "+str(trAc))






def train(train_y, S):

    # This function will create an SVM model based on the training data (the custom kernel and responses).

    # INPUTS
    # train_y is a list of 1s  and 0s representing the responses for the training data
    # S is a list of lists representing a similarity matrix.
    # S must be a square matrix with max similarity scores on the diagonal.

    # OUTPUT
    # mod is an SVM model


        for i in range(0,S.__len__()):
            S[i]=[i+1]+S[i]

        prob = svm_problem(train_y, S, isKernel=True)
        param = svm_parameter('-t 4')
        mod = svm_train(prob, param)
        return mod







def updateKernel(S, test_S):

    # This function combines the training kernel with the similarities scores for the testing data points into a
    # symmetric matrix (list of lists) that can be used by the svm package


    #INTPUTS

    # S is the initial kernel used to train the SVM
    # test_S is a list of lists (matrix) that includes similarity scores relating the test data points to the
    # training points, as well as the test points to each other
    # A test point should have a max similarity score with itself.
    # Note: test_S will NOT be a square matrix.

    # OUTPUT

    # newS is the new kernel (one with similarity scores for all training and testing data) that will be used
    # for testing.

    lenTe = test_S.__len__()
    lenTr = S.__len__()

    for i in range(0,lenTe):

        for j in range(0,lenTr):

            S[j]=S[j]+[test_S[i][j]]

    for i in range(0,lenTe):

        test_S[i]=[lenTr+i+1]+test_S[i]

    newS=S+test_S
    return newS







def updateY(train_y,test_S,test_y):

    # This function combines the responses for the training data with the responses of the testing data so that the
    # svm package can carry out the predictions

    # INPUTS

    # train_y is a list of the responses for the training data. They are 0s and 1s.
    # test_S is a list of lists (matrix) that includes similarity scores relating the test
    # data points to the training points, as well as the test points to each other
    # A test point should have a max similarity score with itself.
    # Note: test_S will NOT be a square matrix.
    # test_y is a list of responses for the test data. Also 0s and 1s.

    # OUTPUT

    # newY is a list of all responses (training and testing). If the user did not include testing responses, 0.5s will
    # take their place because svm_predict requires the response matrix to be of same length as the similarity matrix.

    if test_y==None:

        newY=train_y+[.5]*test_S.__len__()

    else:

        newY=train_y+test_y

    return newY








def predict(newY, newS, model):

    # This function carries out the actual predictions on the test data using the training data

    # INPUTS

    # newY is a list of all responses (training and testing). 0s and 1s (unless testing responses not specified).
    # newS is a kernel with all similarity scores (training and testing).
    # model is the SVM that was formed from the training

    #OUTPUT
    # predicts is the the list of predictions (for training and testing).

    predicts=svm_predict(newY,newS,model)
    return predicts[0]




def stats(predicts,test_y,test_S,train_y):

    # This function calculates training accuracy and testing accuracy if desired

    # INPUTS

    # predicts is a list of 0s and 1s which are the predictions for both training and testing data
    # test_y is the testing responses
    # test_S is the testing similarity score matrix
    # train_y is the training responses

    # OUTPUTS

    # trPr is the training predictions as a list
    # trAC is the training accuracy as a decimal
    # tePr is the testing predictions as a list
    # teAc is the testing accuracy as a decimal

    lenPr=predicts.__len__()
    lenNS=test_S.__len__()
    trPr = [predicts[i] for i in range(0, lenPr - lenNS)]
    lenTrPr = trPr.__len__()
    right = 0

    for i in range(0, lenTrPr):

        if trPr[i] == train_y[i]:

            right = right + 1

    trAc = right / lenTrPr
    tePr = [predicts[i] for i in range(lenPr - lenNS, lenPr)]

    if test_y==None:

        teAc=None

    else:

        lenTePr = tePr.__len__()
        right=0

        for i in range(0,lenTePr):

            if tePr[i]==test_y[i]:

                right=right+1

        teAc=right/lenTePr

    return [trPr,trAc,tePr,teAc]
