function [subsampledTrainData,subsampledValidationData,subsampledTestData] = applySubsampling(trainData,validationData,testData,splitRatio,classificationBoolean)
% this function subsamples the training data given the splitRatio and
% removes the rest of the training data. if classificationBoolean is true, 
% the subsampling is stratified for each unique value in trainData.outcome.
% since the similarity matrices for
% validation and test data are with respect to the training samples, the
% columns corresponding to the now-deleted training samples are also
% removed.

[splitAInd,splitBInd] = splitSamples(trainData.outcome,splitRatio,classificationBoolean);
subsampledTrainData.features = trainData.features(splitAInd,:);
subsampledTrainData.dummycodedFeatures = trainData.dummycodedFeatures(splitAInd,:);
subsampledTrainData.sm = trainData.sm(splitAInd,splitAInd); % only keep the similarity within the subsampled training data
subsampledTrainData.outcome = trainData.outcome(splitAInd);

%% only keep the similarity with respect to the subsampled training data
subsampledValidationData = validationData;
subsampledValidationData.sm = subsampledValidationData.sm(:,splitAInd);  

subsampledTestData = testData;
subsampledTestData.sm = subsampledTestData.sm(:,splitAInd);
end