function [accuracy] = computeAccuracy(yTest,yTestPrediction)

confMat = confusionmat(yTest,yTestPrediction);

accuracy = (confMat(1,1) + confMat(2,2))/(sum(confMat(:)));
end