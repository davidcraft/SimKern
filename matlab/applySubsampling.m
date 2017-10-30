function [subsampledTrainData,subsampledValidationData,subsampledTestData] = applySubsampling(trainData,validationData,testData,splitRatio,classificationBoolean)
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