from __future__ import division
from svmutil import *
import copy


def typicalSVM(y,X,kernel,newXs=None,newYs=None):

# This function will do SVM training and predicting and will print the results

# INPUTs

# y is the training responses; a list of 0s and 1s
# X is the training data. Should be a list of lists.
# kernel is the type of prespecified kernel to be used. Options include "l" (linear), "p" (polynomial), "r" (RBF), and
#   "s" (sigmoid). For custom kernel, see kernelSvm.py
# newXs is the testing data; a list of lists.
# newYs is the testing responses; a list of 0s and 1s.

# NOTES

# If newXs is unspecified, it will print training predictions and training accuracy.
# If newXs is specified but newYs is not, it will print the above information as well as testing predictions.
# If newYs is also specified, it will print all of the above as well as testing accuracy.

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

    mod=svm_train(y,X,"-t "+str(kernel))

    if newXs is not None:
        newX=copy.deepcopy(X)
        newX.extend(newXs)
        if newYs is not None:
            newY=copy.deepcopy(y)
            newY.extend(newYs)
        else:
            newY=y+[0]*newXs.__len__()
    else:
        newX=X
        newY=y

    predicts=svm_predict(newY,newX,mod)

    [trPr,trAc,tePr,teAc]=stats(predicts[0],y,newYs,newXs)

    print("Training predictions: "+str(trPr))
    print("Training accuracy: "+str(trAc))

    if newXs is not None:
        print("Testing predictions: "+str(tePr))

        if newYs is not None:
            print("Testing accuracy: "+str(teAc))






def stats(predicts,y,newYs,newXs):

# This function computes accuracy for training and testing.

# INPUTS

# predicts is the predictions for both training and testing data; a list of 0s and 1s
# See typicalSVM for explanations of y, newYs, and newXs


# OUTPUTS

# trPr is the predictions for the training set; a list of 0s and 1s.
# trAc is the accuracy of the training predictions; a decimal.
# tePr is the predictions for the testing set; a list of 0s and 1s.
# teAc is the accuracy of the testing set; a decimal.

    tePr=None
    teAc=None

    trLen=y.__len__()
    trPr=range(trLen)
    count=0
    for i in range(0,trLen):
        trPr[i]=predicts[i]
        if trPr[i]==y[i]:
            count=count+1

    trAc=count/trLen

    if newXs is not None:
        teLen=newXs.__len__()
        tePr=range(teLen)

        for i in range(0,teLen):
            tePr[i]=predicts[i+trLen]
        if newYs is not None:
            count = 0
            for i in range(0,teLen):
                if tePr[i]==predicts[i+trLen]:
                    count=count+1
            teAc=count/teLen


    return[trPr,trAc,tePr,teAc]


