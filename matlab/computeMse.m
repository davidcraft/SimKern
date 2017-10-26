function [mse] = computeMse(yTest,yTestPrediction)
squaredError = (yTest-yTestPrediction).^2;
mse = mean(squaredError);
end
