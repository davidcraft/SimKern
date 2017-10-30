function [linSvm,rbfSvm,rf,ckSvm,ckRf] = runExperiment(unstandardizedFeatures,outcome,sm,splitRatios,classificationBoolean,subsamplingRatios,categoricalIndices)
addpath('C:\Users\timo.deist\Documents\sim0sim1\code\matlab\libsvm-3.22\windows')
[features] = standardizeFeatures(unstandardizedFeatures,categoricalIndices);
[dummycodedFeatures] = dummycodeCategoricalFeatures(features,categoricalIndices);
[trainData,validationData,testData] = splitData(features,dummycodedFeatures,sm,outcome,splitRatios,classificationBoolean);
for i_subsampling = 1:numel(subsamplingRatios)
    display(['Subsampling iteration ' num2str(i_subsampling) ' of ' num2str(numel(subsamplingRatios)) '.'])
    [subsampledTrainData,subsampledValidationData,subsampledTestData] = applySubsampling(trainData,validationData,testData,subsamplingRatios(i_subsampling),classificationBoolean);
    
    %% hyperparameters (fewer)
%     % all svm
%     cValues = 10.^[-2 0 5];
%     epsilonValues = [0.01 0.1 0.2];
%     % rbf svm
%     gammaValues = 10.^[-5 -1 1];
%     % rf
%     n = numel(subsampledTrainData.outcome); % number of trianing samples
%     p = size(subsampledTrainData.features,2); %number of features
%     pCk = n; % number of rows/columns in similarity matrix
%     mValuesNaive = [1 floor(sqrt(p)) p];
%     mValuesCk = [1 floor(sqrt(pCk)) pCk];
%     maxSplitsValues = floor([0.05 0.5 1] * n);
%     maxSplitsValues = min(maxSplitsValues,n-1);
%     maxSplitsValues = max(maxSplitsValues,1);
%     
    %% hyperparameters
    % all svm
    cValues = 10.^[-2:5];
    epsilonValues = [0.01 0.05 0.1 0.15 0.2];
    % rbf svm
    gammaValues = 10.^[-5:1];
    % rf
    n = numel(subsampledTrainData.outcome); % number of trianing samples
    p = size(subsampledTrainData.features,2); %number of features
    pCk = n; % number of rows/columns in similarity matrix
    mValuesNaive = [1 floor((1 + sqrt(p))/2) floor(sqrt(p)) floor((sqrt(p) + p)/2) p];
    mValuesCk = [1 floor((1 + sqrt(pCk))/2) floor(sqrt(pCk)) floor((sqrt(pCk) + pCk)/2) pCk];
    maxSplitsValues = floor([0.05 0.1 0.2 0.3 0.4 0.5 0.75 1] * n);
    maxSplitsValues = min(maxSplitsValues,n-1);
    maxSplitsValues = max(maxSplitsValues,1);
    
    %% choosing model with best HPs on validation data
    if classificationBoolean
        [rf.bestModel{i_subsampling},rf.bestM(i_subsampling),rf.bestMaxSplits(i_subsampling)] = tuneRfClassificationHyperparameters(subsampledTrainData,subsampledValidationData,mValuesNaive,maxSplitsValues,categoricalIndices);
        [linSvm.bestModel{i_subsampling},linSvm.bestC{i_subsampling}] = tuneLinSvmClassificationHyperparameters(subsampledTrainData,subsampledValidationData,cValues);
%         linSvm = NaN; % used when commenting linSvm
        [rbfSvm.bestModel{i_subsampling},rbfSvm.bestC(i_subsampling),rbfSvm.bestGamma(i_subsampling)] = tuneRbfSvmClassificationHyperparameters(subsampledTrainData,subsampledValidationData,cValues,gammaValues);
        [ckSvm.bestModel{i_subsampling},ckSvm.bestC{i_subsampling}] = tuneCkSvmClassificationHyperparameters(subsampledTrainData,subsampledValidationData,cValues);
        [ckRf.bestModel{i_subsampling},ckRf.bestM(i_subsampling),ckRf.bestMaxSplits(i_subsampling)] = tuneCkRfClassificationHyperparameters(subsampledTrainData,subsampledValidationData,mValuesCk,maxSplitsValues,categoricalIndices);
    else
        [rf.bestModel{i_subsampling},rf.bestM(i_subsampling),rf.bestMaxSplits(i_subsampling)] = tuneRfRegressionHyperparameters(subsampledTrainData,subsampledValidationData,mValuesNaive,maxSplitsValues,categoricalIndices);
        [linSvm.bestModel{i_subsampling},linSvm.bestC{i_subsampling},linSvm.bestEpsilon{i_subsampling}] = tuneLinSvmRegressionHyperparameters(subsampledTrainData,subsampledValidationData,cValues,epsilonValues);
        % linSvm = NaN; % used when commenting linSvm
        [rbfSvm.bestModel{i_subsampling},rbfSvm.bestC(i_subsampling),rbfSvm.bestGamma(i_subsampling),rbfSvm.bestEpsilon(i_subsampling)] = tuneRbfSvmRegressionHyperparameters(subsampledTrainData,subsampledValidationData,cValues,gammaValues,epsilonValues);
        [ckSvm.bestModel{i_subsampling},ckSvm.bestC{i_subsampling},ckSvm.bestEpsilon{i_subsampling}] = tuneCkSvmRegressionHyperparameters(subsampledTrainData,subsampledValidationData,cValues,epsilonValues);
        [ckRf.bestModel{i_subsampling},ckRf.bestM(i_subsampling),ckRf.bestMaxSplits(i_subsampling)] = tuneCkRfRegressionHyperparameters(subsampledTrainData,subsampledValidationData,mValuesCk,maxSplitsValues,categoricalIndices);
    end    
    %% predicting on test data
    [rf.perfMetric(i_subsampling)] = predictTestData(subsampledTestData,rf.bestModel{i_subsampling},'rf',classificationBoolean);
    [linSvm.perfMetric(i_subsampling)] = predictTestData(subsampledTestData,linSvm.bestModel{i_subsampling},'linSvm',classificationBoolean);
%     linSvm = NaN; % used when commenting linSvm
    [rbfSvm.perfMetric(i_subsampling)] = predictTestData(subsampledTestData,rbfSvm.bestModel{i_subsampling},'rbfSvm',classificationBoolean);
    [ckSvm.perfMetric(i_subsampling)] = predictTestData(subsampledTestData,ckSvm.bestModel{i_subsampling},'ckSvm',classificationBoolean);
    [ckRf.perfMetric(i_subsampling)] = predictTestData(subsampledTestData,ckRf.bestModel{i_subsampling},'ckRf',classificationBoolean);
end

end