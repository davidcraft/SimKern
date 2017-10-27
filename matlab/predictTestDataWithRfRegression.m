function [rSquared] = predictTestDataWithRfRegression(testData,bestModel)

% predict test data
baggerPredictions = predict(bestModel,testData.features);
predictions = baggerPredictions;
%compute performance metric
[rSquared] = computeRSquared(testData.outcome,predictions);

end