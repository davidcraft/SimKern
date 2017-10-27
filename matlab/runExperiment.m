function [linSvm,rbfSvm,rf,ckSvm,ckRf] = runExperiment(unstandardizedFeatures,classes,sm,splitRatios,classificationBoolean,subsamplingRatios,categoricalIndices)
addpath('C:\Users\timo.deist\Documents\sim0sim1\code\matlab\libsvm-3.22\windows')
[features] = standardizeFeatures(unstandardizedFeatures,categoricalIndices);
[dummycodedFeatures] = dummycodeCategoricalFeatures(features,categoricalIndices);
[trainData,validationData,testData] = splitData(features,dummycodedFeatures,sm,classes,splitRatios,classificationBoolean);
for i_subsampling = 1:numel(subsamplingRatios)
    display(['Subsampling iteration ' num2str(i_subsampling) ' of ' num2str(numel(subsamplingRatios)) '.'])
    [subsampledTrainData,subsampledValidationData,subsampledTestData] = applySubsampling(trainData,validationData,testData,subsamplingRatios(i_subsampling),classificationBoolean);
    
    %% hyperparameters (fewer)
    % all svm
    cValues = 10.^[-2 0 5];
    epsilonValues = [0.01 0.1 0.2];
    % rbfsvm
    gammaValues = 10.^[-5 0 1];
    % rf
    n = numel(subsampledTrainData.classes);
    p = size(subsampledTrainData.features,2);
    mValues = [1 floor(sqrt(p)) p];
    maxSplitsValues = floor([0.05 0.5 1] * n);
    maxSplitsValues = min(maxSplitsValues,n-1);
    maxSplitsValues = max(maxSplitsValues,1);
    
    %% hyperparameters
    %     % all svm
    %     cValues = 10.^[-2:5];
    %     epsilonValues = [0.01 0.05 0.1 0.15 0.2];
    %     % rbfsvm
    %     gammaValues = 10.^[-5:1];
    %     % rf
    %     n = numel(subsampledTrainData.classes);
    %     p = size(subsampledTrainData.features,2);
    %     mValues = [1 floor((1 + sqrt(p))/2) floor(sqrt(p)) floor((sqrt(p) + p)/2) p];
    %     maxSplitsValues = floor([0.05 0.1 0.2 0.3 0.4 0.5 0.75 1] * n);
    %     maxSplitsValues = min(maxSplitsValues,n-1);
    %     maxSplitsValues = max(maxSplitsValues,1);
    
    %% differentiate between classification and regression
    if classificationBoolean
        % RF
        [rf.bestModel{i_subsampling},rf.bestM(i_subsampling),rf.bestMaxSplits(i_subsampling)] = tuneRfClassificationHyperparameters(subsampledTrainData,subsampledValidationData,mValues,maxSplitsValues,categoricalIndices);
        [rf.perfMetric(i_subsampling)] = predictTestDataWithRfClassification(subsampledTestData,rf.bestModel{i_subsampling});
        % linear SVM
        [linSvm.bestModel{i_subsampling},linSvm.bestC{i_subsampling}] = tuneLinSvmClassificationHyperparameters(subsampledTrainData,subsampledValidationData,cValues);
        [linSvm.perfMetric(i_subsampling)] = predictTestDataWithSvmClassification(subsampledTestData,linSvm.bestModel{i_subsampling});
%         linSvm = NaN; % used when commenting linSvm
        % rbf SVM
        [rbfSvm.bestModel{i_subsampling},rbfSvm.bestC(i_subsampling),rbfSvm.bestGamma(i_subsampling)] = tuneRbfSvmClassificationHyperparameters(subsampledTrainData,subsampledValidationData,cValues,gammaValues);
        [rbfSvm.perfMetric(i_subsampling)] = predictTestDataWithSvmClassification(subsampledTestData,rbfSvm.bestModel{i_subsampling});
        % custom kernel SVM
        [ckSvm.bestModel{i_subsampling},ckSvm.bestC{i_subsampling}] = tuneCkSvmClassificationHyperparameters(subsampledTrainData,subsampledValidationData,cValues);
        [ckSvm.perfMetric(i_subsampling)] = predictTestDataWithCkSvmClassification(subsampledTestData,ckSvm.bestModel{i_subsampling});
        %custom kernel RF
        [ckRf.bestModel{i_subsampling},ckRf.bestM(i_subsampling),ckRf.bestMaxSplits(i_subsampling)] = tuneCkRfClassificationHyperparameters(subsampledTrainData,subsampledValidationData,mValues,maxSplitsValues,categoricalIndices);
        [ckRf.perfMetric(i_subsampling)] = predictTestDataWithCkRfClassification(subsampledTestData,ckRf.bestModel{i_subsampling});
    else
        % RF
        [rf.bestModel{i_subsampling},rf.bestM(i_subsampling),rf.bestMaxSplits(i_subsampling)] = tuneRfRegressionHyperparameters(subsampledTrainData,subsampledValidationData,mValues,maxSplitsValues,categoricalIndices);
        [rf.perfMetric(i_subsampling)] = predictTestDataWithRfRegression(subsampledTestData,rf.bestModel{i_subsampling});
        % linear SVM
        [linSvm.bestModel{i_subsampling},linSvm.bestC{i_subsampling},linSvm.bestEpsilon{i_subsampling}] = tuneLinSvmRegressionHyperparameters(subsampledTrainData,subsampledValidationData,cValues,epsilonValues);
        [linSvm.perfMetric(i_subsampling)] = predictTestDataWithSvmRegression(subsampledTestData,linSvm.bestModel{i_subsampling});
%         linSvm = NaN; % used when commenting linSvm
        % rbf SVM
        [rbfSvm.bestModel{i_subsampling},rbfSvm.bestC(i_subsampling),rbfSvm.bestGamma(i_subsampling),rbfSvm.bestEpsilon(i_subsampling)] = tuneRbfSvmRegressionHyperparameters(subsampledTrainData,subsampledValidationData,cValues,gammaValues,epsilonValues);
        [rbfSvm.perfMetric(i_subsampling)] = predictTestDataWithSvmRegression(subsampledTestData,rbfSvm.bestModel{i_subsampling});
        % custom kernel SVM
        [ckSvm.bestModel{i_subsampling},ckSvm.bestC{i_subsampling},ckSvm.bestEpsilon{i_subsampling}] = tuneCkSvmRegressionHyperparameters(subsampledTrainData,subsampledValidationData,cValues,epsilonValues);
        [ckSvm.perfMetric(i_subsampling)] = predictTestDataWithCkSvmRegression(subsampledTestData,ckSvm.bestModel{i_subsampling});
        %custom kernel RF
        [ckRf.bestModel{i_subsampling},ckRf.bestM(i_subsampling),ckRf.bestMaxSplits(i_subsampling)] = tuneCkRfRegressionHyperparameters(subsampledTrainData,subsampledValidationData,mValues,maxSplitsValues,categoricalIndices);
        [ckRf.perfMetric(i_subsampling)] = predictTestDataWithCkRfRegression(subsampledTestData,ckRf.bestModel{i_subsampling});
    end
end

end