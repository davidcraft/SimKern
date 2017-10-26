function [accuracy] = predictTestDataWithRfClassification(testData,bestModel)

% predict test data
baggerPredictions = predict(bestModel,testData.features);
predictions = cellfun(@str2num,baggerPredictions);
%compute performance metric
[accuracy] = computeAccuracy(testData.classes,predictions);

end