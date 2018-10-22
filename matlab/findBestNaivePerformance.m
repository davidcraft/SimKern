function [bestNaive,bestNaiveLabel] = findBestNaivePerformance(linSvmResult,rbfSvmResult,rfResult)
% picks the best naive classifier. The best classifier is the one that is
% To determine the best classifier, the classifier with the highest median test set performance
% is determined for each training data subsample. The classifier that is highest
% most often (using mode() on the indices), is labelled the best classifier.

[maxVal,maxInd] = max([median(linSvmResult);median(rbfSvmResult);median(rfResult)]);

if mode(maxInd) == 1
    bestNaive = linSvmResult;
    bestNaiveLabel = 'linSVM';
elseif mode(maxInd) == 2
    bestNaive = rbfSvmResult;
    bestNaiveLabel = 'RBF SVM';
elseif mode(maxInd) == 3
    bestNaive = rfResult;
    bestNaiveLabel = 'RF';
else
    error('Oops.')
end