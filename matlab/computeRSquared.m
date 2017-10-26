function [rSquared] = computeRSquared(yTest,yTestPrediction)
meanYTest = mean(yTest);
rSquared = 1 - sum((yTestPrediction - yTest).^2)/sum((meanYTest - yTest).^2);
end