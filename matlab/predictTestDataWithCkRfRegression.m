function [rSquared] = predictTestDataWithCkRfRegression(testData,bestModel)

% predict test data
baggerPredictions = predict(bestModel,testData.sm);
predictions = baggerPredictions;
%compute performance metric
[rSquared] = computeRSquared(testData.classes,predictions);

end