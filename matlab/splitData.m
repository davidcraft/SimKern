function [trainData,validationData,testData] = splitData(features,dummycodedFeatures,sm,classes,splitRatios,classificationBoolean)
[splitTrainInd,splitBInd] = splitSamples(classes,splitRatios(1),classificationBoolean);
trainData.features = features(splitTrainInd,:);
trainData.dummycodedFeatures = dummycodedFeatures(splitTrainInd,:);
trainData.sm = sm(splitTrainInd,splitTrainInd);
trainData.classes = classes(splitTrainInd);

% place the validation/test part into another struct splitB
splitB.features = features(splitBInd,:);
splitB.dummycodedFeatures = dummycodedFeatures(splitBInd,:);
splitB.sm = sm(splitBInd,splitTrainInd);
splitB.classes = classes(splitBInd);

%% split splitB into validation and test
% convert ratios of full data to the ratio for the remaining data;
newSplitRatio = splitRatios(2)/(splitRatios(2) + splitRatios(3));

[splitValidationInd,splitTestInd] = splitSamples(splitB.classes,newSplitRatio,classificationBoolean);
validationData.features = splitB.features(splitValidationInd,:);
validationData.dummycodedFeatures = splitB.dummycodedFeatures(splitValidationInd,:);
validationData.sm = splitB.sm(splitValidationInd,:);
validationData.classes = splitB.classes(splitValidationInd);

testData.features = splitB.features(splitTestInd,:);
testData.dummycodedFeatures = splitB.dummycodedFeatures(splitTestInd,:);
testData.sm = splitB.sm(splitTestInd,:);
testData.classes = splitB.classes(splitTestInd);
end