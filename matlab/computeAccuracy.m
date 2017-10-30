function [accuracy] = computeAccuracy(yTest,yTestPrediction)

confMat = confusionmat(yTest,yTestPrediction);

accuracy = (sum(diag(confMat)))/(sum(confMat(:)));
end