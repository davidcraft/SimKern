from __future__ import division
from svmutil import *
import copy


def typicalSVM(train_y,train_X,kernel,test_X=None,test_y=None):

# This function will do SVM training and predicting and will print the results

# INPUTs

# train_y is the training responses; a list of 0s and 1s
# train_X is the training data. Should be a list of lists.
# kernel is the type of prespecified kernel to be used. Options include "l" (linear), "p" (polynomial), "r" (RBF), and
#   "s" (sigmoid). For custom kernel, see kernelSvm.py
# test_X is the testing data; a list of lists.
# test_Y is the testing responses; a list of 0s and 1s.

# NOTES

# If test_X is unspecified, it will print training predictions and training accuracy.
# If test_X is specified but test_Y is not, it will print the above information as well as testing predictions.
# If test_Y is also specified, it will print all of the above as well as testing accuracy.

    if kernel=="l":
        kernel=0
    elif kernel=="p":
        kernel=1
    elif kernel=="r":
        kernel=2
    elif kernel=="s":
        kernel=3
    else:
        print("Use kernelSvm for custom kernels")

    mod=svm_train(train_y,train_X,"-t "+str(kernel))

    if test_X is not None:
        newX=copy.deepcopy(train_X)
        newX.extend(test_X)
        if test_y is not None:
            newY=copy.deepcopy(train_y)
            newY.extend(test_y)
        else:
            newY=train_y+[0]*test_X.__len__()
    else:
        newX=train_X
        newY=train_y

    predicts=svm_predict(newY,newX,mod)

    [trPr,trAc,tePr,teAc]=stats(predicts[0],train_y,test_y,test_X)

    print("Training predictions: "+str(trPr))
    print("Training accuracy: "+str(trAc))

    if test_X is not None:
        print("Testing predictions: "+str(tePr))

        if test_y is not None:
            print("Testing accuracy: "+str(teAc))






def stats(predicts, train_y, test_y, test_X):

# This function computes accuracy for training and testing.

# INPUTS

# predicts is the predictions for both training and testing data; a list of 0s and 1s
# See typicalSVM for explanations of train_y, test_y, and test_X


# OUTPUTS

# trPr is the predictions for the training set; a list of 0s and 1s.
# trAc is the accuracy of the training predictions; a decimal.
# tePr is the predictions for the testing set; a list of 0s and 1s.
# teAc is the accuracy of the testing set; a decimal.

    tePr=None
    teAc=None

    trLen=train_y.__len__()
    trPr=range(trLen)
    count=0
    for i in range(0,trLen):
        trPr[i]=predicts[i]
        if trPr[i]==train_y[i]:
            count=count+1

    trAc=count/trLen

    if test_X is not None:
        teLen=test_X.__len__()
        tePr=range(teLen)

        for i in range(0,teLen):
            tePr[i]=predicts[i+trLen]
        if test_y is not None:
            count = 0
            for i in range(0,teLen):
                if tePr[i]==test_y[i]:
                    count=count+1
            teAc=count/teLen


    return[trPr,trAc,tePr,teAc]


