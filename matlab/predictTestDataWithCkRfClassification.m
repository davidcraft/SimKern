function [accuracy] = predictTestDataWithCkRfClassification(testData,bestModel)

% predict test data
baggerPredictions = predict(bestModel,testData.sm);
predictions = cellfun(@str2num,baggerPredictions);
%compute performance metric
[accuracy] = computeAccuracy(testData.classes,predictions);

end