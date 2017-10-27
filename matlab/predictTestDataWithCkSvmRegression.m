function [rSquared] = predictTestDataWithCkSvmRegression(testData,bestModel)
numeroTestSamples = numel(testData.outcome);
% predict test data
[predictions] = svmpredict(zeros(size(testData.outcome,1),size(testData.outcome,2)),[(1:numeroTestSamples)' testData.sm],bestModel,'-q');

%compute performance metric
[rSquared] = computeRSquared(testData.outcome,predictions);

end