function [trainData,validationData,testData] = splitData(features,dummycodedFeatures,sm,outcome,splitRatios,classificationBoolean)
% this function splits features, dummycodedFeatures, sm, and outcome
% into training, validation, and test data and places the data into
% structs. The splitting uses the split ratios provided by the variable 
% splitRatios. If the variable classificationBoolean is true, the
% distribution of classes is approximately preserved in all three splits.

%% first split the data into training data and  'valiation+test' data (splitB)
[splitTrainInd,splitBInd] = splitSamples(outcome,splitRatios(1),classificationBoolean);
trainData.features = features(splitTrainInd,:);
trainData.dummycodedFeatures = dummycodedFeatures(splitTrainInd,:);
trainData.sm = sm(splitTrainInd,splitTrainInd);
trainData.outcome = outcome(splitTrainInd);

% place the validation/test part into another struct splitB
splitB.features = features(splitBInd,:);
splitB.dummycodedFeatures = dummycodedFeatures(splitBInd,:);
splitB.sm = sm(splitBInd,splitTrainInd); % only similarity with respect to the training samples is stored
splitB.outcome = outcome(splitBInd);

%% split 'validation+test' data (splitB) into validation and test
% convert ratios of full data to the ratio for the remaining data;
newSplitRatio = splitRatios(2)/(splitRatios(2) + splitRatios(3));

[splitValidationInd,splitTestInd] = splitSamples(splitB.outcome,newSplitRatio,classificationBoolean);
validationData.features = splitB.features(splitValidationInd,:);
validationData.dummycodedFeatures = splitB.dummycodedFeatures(splitValidationInd,:);
validationData.sm = splitB.sm(splitValidationInd,:);
validationData.outcome = splitB.outcome(splitValidationInd);

testData.features = splitB.features(splitTestInd,:);
testData.dummycodedFeatures = splitB.dummycodedFeatures(splitTestInd,:);
testData.sm = splitB.sm(splitTestInd,:);
testData.outcome = splitB.outcome(splitTestInd);
end