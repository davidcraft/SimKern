function [rSquared] = predictTestDataWithSvmRegression(testData,bestModel)

% predict test data
[predictions] = svmpredict(zeros(size(testData.outcome,1),size(testData.outcome,2)),testData.dummycodedFeatures,bestModel,'-q');

%compute performance metric
[rSquared] = computeRSquared(testData.outcome,predictions);

end