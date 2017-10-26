function [accuracy] = predictTestDataWithCkSvmClassification(testData,bestModel)
numeroTestSamples = numel(testData.classes);
% predict test data
[predictions] = svmpredict(zeros(size(testData.classes,1),size(testData.classes,2)),[(1:numeroTestSamples)' testData.sm],bestModel,'-q');

%compute performance metric
[accuracy] = computeAccuracy(testData.classes,predictions);

end