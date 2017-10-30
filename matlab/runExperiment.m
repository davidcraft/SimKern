function [linSvm,rbfSvm,rf,ckSvm,ckRf] = runExperiment(...
    unstandardizedFeatures,outcome,sm,splitRatios,classificationBoolean,...
    subsamplingRatios,categoricalIndices,numeroTrees,debuggingBoolean)

[features] = standardizeFeatures(unstandardizedFeatures,categoricalIndices);
[dummycodedFeatures] = dummycodeCategoricalFeatures(features,categoricalIndices);
[trainData,validationData,testData] = splitData(features,dummycodedFeatures,sm,outcome,splitRatios,classificationBoolean);
for i_subsampling = 1:numel(subsamplingRatios)
    display(['Subsampling iteration ' num2str(i_subsampling) ' of ' num2str(numel(subsamplingRatios)) '.'])
    [subsampledTrainData,subsampledValidationData,subsampledTestData] = applySubsampling(trainData,validationData,testData,subsamplingRatios(i_subsampling),classificationBoolean);
    
    if debuggingBoolean
        %% fewer hyperparameters
        % all svm
        cValues = 10.^[-2 0 5];
        epsilonValues = [0.01 0.1 0.2];
        % rbf svm
        gammaValues = 10.^[-5 -1 1];
        % rf
        n = numel(subsampledTrainData.outcome); % number of trianing samples
        p = size(subsampledTrainData.features,2); %number of features
        pCk = n; % number of rows/columns in similarity matrix
        mValuesNaive = [1 floor(sqrt(p)) p];
        mValuesCk = [1 floor(sqrt(pCk)) pCk];
        maxSplitsValues = floor([0.05 0.5 1] * n);
        maxSplitsValues = min(maxSplitsValues,n-1);
        maxSplitsValues = max(maxSplitsValues,1);
    else
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
    end
    %% choosing model with best HPs on validation data
    if classificationBoolean
        [rf.bestModel{i_subsampling},rf.bestM(i_subsampling),rf.bestMaxSplits(i_subsampling),rf.bestPerfMetric(i_subsampling)] = tuneRfClassificationHyperparameters(subsampledTrainData,subsampledValidationData,mValuesNaive,maxSplitsValues,categoricalIndices,numeroTrees);
        display(['Tuned RF: m = ' num2str(rf.bestM(i_subsampling)) ', maxSplits = ' num2str(rf.bestMaxSplits(i_subsampling)) ' with accuracy = ' num2str(rf.bestPerfMetric(i_subsampling)) '.'])
        [linSvm.bestModel{i_subsampling},linSvm.bestC(i_subsampling),linSvm.bestPerfMetric(i_subsampling)] = tuneLinSvmClassificationHyperparameters(subsampledTrainData,subsampledValidationData,cValues);
        display(['Tuned linSVM: C = ' num2str(linSvm.bestC(i_subsampling)) ' with accuracy = ' num2str(linSvm.bestPerfMetric(i_subsampling)) '.'])
        [rbfSvm.bestModel{i_subsampling},rbfSvm.bestC(i_subsampling),rbfSvm.bestGamma(i_subsampling),rbfSvm.bestPerfMetric(i_subsampling)] = tuneRbfSvmClassificationHyperparameters(subsampledTrainData,subsampledValidationData,cValues,gammaValues);
        display(['Tuned rbfSVM: C = ' num2str(rbfSvm.bestC(i_subsampling)) ', gamma = ' num2str(rbfSvm.bestGamma(i_subsampling)) ' with accuracy = ' num2str(rbfSvm.bestPerfMetric(i_subsampling)) '.'])
        [ckSvm.bestModel{i_subsampling},ckSvm.bestC(i_subsampling),ckSvm.bestPerfMetric(i_subsampling)] = tuneCkSvmClassificationHyperparameters(subsampledTrainData,subsampledValidationData,cValues);
        display(['Tuned ckSVM: C = ' num2str(ckSvm.bestC(i_subsampling)) ' with accuracy = ' num2str(ckSvm.bestPerfMetric(i_subsampling)) '.'])
        [ckRf.bestModel{i_subsampling},ckRf.bestM(i_subsampling),ckRf.bestMaxSplits(i_subsampling),ckRf.bestPerfMetric(i_subsampling)] = tuneCkRfClassificationHyperparameters(subsampledTrainData,subsampledValidationData,mValuesCk,maxSplitsValues,categoricalIndices,numeroTrees);
        display(['Tuned ckRF: m = ' num2str(ckRf.bestM(i_subsampling)) ', maxSplits = ' num2str(ckRf.bestMaxSplits(i_subsampling)) ' with accuracy = ' num2str(ckRf.bestPerfMetric(i_subsampling)) '.'])
    else
        [rf.bestModel{i_subsampling},rf.bestM(i_subsampling),rf.bestMaxSplits(i_subsampling),rf.bestPerfMetric(i_subsampling)] = tuneRfRegressionHyperparameters(subsampledTrainData,subsampledValidationData,mValuesNaive,maxSplitsValues,categoricalIndices,numeroTrees);
        display(['Tuned RF: m = ' num2str(rf.bestM(i_subsampling)) ', maxSplits = ' num2str(rf.bestMaxSplits(i_subsampling)) ' with R^2 = ' num2str(rf.bestPerfMetric(i_subsampling)) '.'])
        [linSvm.bestModel{i_subsampling},linSvm.bestC(i_subsampling),linSvm.bestEpsilon(i_subsampling),linSvm.bestPerfMetric(i_subsampling)] = tuneLinSvmRegressionHyperparameters(subsampledTrainData,subsampledValidationData,cValues,epsilonValues);
        display(['Tuned linSVM: C = ' num2str(linSvm.bestC(i_subsampling)) ', epsilon = ' num2str(linSvm.bestEpsilon(i_subsampling)) ' with R^2 = ' num2str(linSvm.bestPerfMetric(i_subsampling)) '.'])
        [rbfSvm.bestModel{i_subsampling},rbfSvm.bestC(i_subsampling),rbfSvm.bestGamma(i_subsampling),rbfSvm.bestEpsilon(i_subsampling),rbfSvm.bestPerfMetric(i_subsampling)] = tuneRbfSvmRegressionHyperparameters(subsampledTrainData,subsampledValidationData,cValues,gammaValues,epsilonValues);
        display(['Tuned rbfSVM: C = ' num2str(rbfSvm.bestC(i_subsampling)) ', gamma = ' num2str(rbfSvm.bestGamma(i_subsampling)) ', epsilon = ' num2str(rbfSvm.bestEpsilon(i_subsampling)) ' with R^2 = ' num2str(rbfSvm.bestPerfMetric(i_subsampling)) '.'])
        [ckSvm.bestModel{i_subsampling},ckSvm.bestC(i_subsampling),ckSvm.bestEpsilon(i_subsampling),ckSvm.bestPerfMetric(i_subsampling)] = tuneCkSvmRegressionHyperparameters(subsampledTrainData,subsampledValidationData,cValues,epsilonValues);
        display(['Tuned ckSVM: C = ' num2str(ckSvm.bestC(i_subsampling)) ', epsilon = ' num2str(ckSvm.bestEpsilon(i_subsampling)) ' with R^2 = ' num2str(ckSvm.bestPerfMetric(i_subsampling)) '.'])
        [ckRf.bestModel{i_subsampling},ckRf.bestM(i_subsampling),ckRf.bestMaxSplits(i_subsampling),ckRf.bestPerfMetric(i_subsampling)] = tuneCkRfRegressionHyperparameters(subsampledTrainData,subsampledValidationData,mValuesCk,maxSplitsValues,categoricalIndices,numeroTrees);
        display(['Tuned ckRF: m = ' num2str(ckRf.bestM(i_subsampling)) ', maxSplits = ' num2str(ckRf.bestMaxSplits(i_subsampling)) ' with R^2 = ' num2str(ckRf.bestPerfMetric(i_subsampling)) '.'])
    end
    %% predicting on test data
    [rf.perfMetric(i_subsampling)] = predictTestData(subsampledTestData,rf.bestModel{i_subsampling},'rf',classificationBoolean);
    if classificationBoolean
    display(['RF test accuracy = ' num2str(rf.perfMetric(i_subsampling)) '.' ])
    else
    display(['RF test R^2 = ' num2str(rf.perfMetric(i_subsampling)) '.' ])
    end
    [linSvm.perfMetric(i_subsampling)] = predictTestData(subsampledTestData,linSvm.bestModel{i_subsampling},'linSvm',classificationBoolean);
    if classificationBoolean
    display(['linSVM test accuracy = ' num2str(linSvm.perfMetric(i_subsampling)) '.' ])
    else
    display(['linSVM test R^2 = ' num2str(linSvm.perfMetric(i_subsampling)) '.' ])
    end
    [rbfSvm.perfMetric(i_subsampling)] = predictTestData(subsampledTestData,rbfSvm.bestModel{i_subsampling},'rbfSvm',classificationBoolean);
    if classificationBoolean
    display(['rbfSVM test accuracy = ' num2str(rbfSvm.perfMetric(i_subsampling)) '.' ])
    else
    display(['rbfSVM test R^2 = ' num2str(rbfSvm.perfMetric(i_subsampling)) '.' ])
    end
    [ckSvm.perfMetric(i_subsampling)] = predictTestData(subsampledTestData,ckSvm.bestModel{i_subsampling},'ckSvm',classificationBoolean);
    if classificationBoolean
    display(['ckSVM test accuracy = ' num2str(ckSvm.perfMetric(i_subsampling)) '.' ])
    else
    display(['ckSVM test R^2 = ' num2str(ckSvm.perfMetric(i_subsampling)) '.' ])
    end
    [ckRf.perfMetric(i_subsampling)] = predictTestData(subsampledTestData,ckRf.bestModel{i_subsampling},'ckRf',classificationBoolean);
    if classificationBoolean
    display(['ckRF test accuracy = ' num2str(ckRf.perfMetric(i_subsampling)) '.' ])
    else
    display(['ckRF test R^2 = ' num2str(ckRf.perfMetric(i_subsampling)) '.' ])
    end
end

end