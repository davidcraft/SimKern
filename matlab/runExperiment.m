function [algs,hps,expInfo] = runExperiment(...
    unstandardizedFeatures,outcome,sm,splitRatios,classificationBoolean,...
    subsamplingRatios,categoricalIndices,numeroTrees,debuggingBoolean,iterationNumber,numeroReps,randSeedSplitting,randSeedSubsampling)
% this function runs an analysis as outlined in Figure X of the manuscript.
% INPUTS:
% unstandardizedFeatures: a matrix of features (rows are samples, columns
% are features)
% outcome: a vector of outcomes(continuous for regression, integral for
% classification)
% sm: a similarity matrix (square matrix with length equal to the number of
% samples in the variable unstandardizedFeatures)
% splitRatios: a vector with 3 values (positive, summing up to 1)
% describing how much of the samples should be allocated to
% training, validation, and testing
% classificationBoolean: a boolean that is true if it is a classification
% problem and false if it is a regression problem
% subsamplingRatios: a vector with values between 0 and 1. it has one entry
% for each time you want to train all models with a random subsample of
% the training set with the provided percentage of the training data
% categoricalIndices: a vector of logicals indicating which variables in
% standardizedFeatures are categorical features
% numeroTrees: the number of trees learned by rf and custom kernel rf
% debuggingBoolean: a boolean which is true if you want to use a smaller
% grid to search the hyperparameter space
% OUTPUTS:
% a struct for each classifier containing information for each instance of the
% subsampling loop:
% .bestModel: the model selected in hyperparameter tuning (learned on the
% trainig data and selected based on evaluation on the validation data)
% .best[name of hyperparameter]: the chosen hyperparameter values after
% evaluation on the validation data
% .bestTuningPerfMetric: the performance metric for the chosen model on the
% validation set (the best in hyperparameter tuning)
% .perfMetric: the performance metric on the test set

% see .m files of functions for code annotations
[features] = standardizeFeatures(unstandardizedFeatures,categoricalIndices);
[dummycodedFeatures] = dummycodeCategoricalFeatures(features,categoricalIndices);
rng(randSeedSplitting)
[trainData,validationData,testData] = splitData(features,dummycodedFeatures,sm,outcome,splitRatios,classificationBoolean);

% repeat hyperparameter tuning and evaluation on test set for each
% subsampling iteration of the trainingset
for i_subsampling = 1:numel(subsamplingRatios)
    disp(['Simulation iteration ' num2str(iterationNumber) ' of ' num2str(numeroReps) '. ' 'Subsampling iteration ' num2str(i_subsampling) ' of ' num2str(numel(subsamplingRatios)) '.'])
    rng(randSeedSubsampling(i_subsampling))
    [subsampledTrainData,subsampledValidationData,subsampledTestData] = applySubsampling(trainData,validationData,testData,subsamplingRatios(i_subsampling),classificationBoolean);
    
    if debuggingBoolean
        %% fewer hyperparameters
        % all svms
        cValues = 10.^[-2 0 5];
        epsilonValues = [0.01 0.1 0.2];
        % rbf svm
        gammaValues = 10.^[-5 -1 1];
        % rfs (rf and custom kernel rf)
        n = numel(subsampledTrainData.outcome); % number of training samples
        p = size(subsampledTrainData.features,2); %number of features
        pCk = n; % number of rows/columns in similarity matrix
        mValuesNaive = [1 floor(sqrt(p)) p];
        mValuesCk = [1 floor(sqrt(pCk)) pCk];
        maxSplitsValues = floor([0.05 0.5 1] * n);
        maxSplitsValues = min(maxSplitsValues,n-1);
        maxSplitsValues = max(maxSplitsValues,1);
    else
        %% hyperparameters
        % all svms
        cValues = 10.^[-12:1:12];
        %         epsilonValues = [10.^[-8:1:-2] 0.05 0.1 0.15 0.25 0.5 0.75 1];
%         epsilonValues = [10.^[-3:1:-2] 0.1:0.1:1 1];
        epsilonValues = [10.^[-5:1:-1] 0.25 0.5 0.75 1];
        % rbf svm
        gammaValues = 10.^[-15:1:1];
        % rfs (rf and custom kernel rf)
        n = numel(subsampledTrainData.outcome); % number of training samples
        p = size(subsampledTrainData.features,2); %number of features
        pCk = n; % number of rows/columns in similarity matrix
        mValuesNaive = [1 floor((1 + sqrt(p))/2) floor(sqrt(p)) floor((sqrt(p) + p)/2) p];
        mValuesCk = [1 floor((1 + sqrt(pCk))/2) floor(sqrt(pCk)) floor((sqrt(pCk) + pCk)/2) pCk];
        maxSplitsValues = floor([0.05 0.1 0.2 0.3 0.4 0.5 0.75 1] * n);
        maxSplitsValues = min(maxSplitsValues,n-1);
        maxSplitsValues = max(maxSplitsValues,1);
        
        
        %% hyperparameters
        % all svms
        %         cValues = 10.^[-2:5];
        %         epsilonValues = [0.01 0.05 0.1 0.15 0.2];
        %         % rbf svm
        %         gammaValues = 10.^[-5:1];
        %         % rfs (rf and custom kernel rf)
        %         n = numel(subsampledTrainData.outcome); % number of training samples
        %         p = size(subsampledTrainData.features,2); %number of features
        %         pCk = n; % number of rows/columns in similarity matrix
        %         mValuesNaive = [1 floor((1 + sqrt(p))/2) floor(sqrt(p)) floor((sqrt(p) + p)/2) p];
        %         mValuesCk = [1 floor((1 + sqrt(pCk))/2) floor(sqrt(pCk)) floor((sqrt(pCk) + pCk)/2) pCk];
        %         maxSplitsValues = floor([0.05 0.1 0.2 0.3 0.4 0.5 0.75 1] * n);
        %         maxSplitsValues = min(maxSplitsValues,n-1);
        %         maxSplitsValues = max(maxSplitsValues,1);
    end
    %% choosing model with best HPs on validation data
    if classificationBoolean
        [rf.bestModel{i_subsampling},rf.bestM(i_subsampling),rf.bestMaxSplits(i_subsampling),rf.bestTuningPerfMetric(i_subsampling),rf.trainPredictions{i_subsampling},rf.validationPredictions{i_subsampling}] = tuneRfClassificationHyperparameters(subsampledTrainData,subsampledValidationData,mValuesNaive,maxSplitsValues,categoricalIndices,numeroTrees);
        disp(['Tuned RF: m = ' num2str(rf.bestM(i_subsampling)) ', maxSplits = ' num2str(rf.bestMaxSplits(i_subsampling)) ' with accuracy = ' num2str(rf.bestTuningPerfMetric(i_subsampling)) '.'])
        [linSvm.bestModel{i_subsampling},linSvm.bestC(i_subsampling),linSvm.bestTuningPerfMetric(i_subsampling),linSvm.trainPredictions{i_subsampling},linSvm.validationPredictions{i_subsampling}] = tuneLinSvmClassificationHyperparameters(subsampledTrainData,subsampledValidationData,cValues);
        disp(['Tuned linSVM: C = ' num2str(linSvm.bestC(i_subsampling)) ' with accuracy = ' num2str(linSvm.bestTuningPerfMetric(i_subsampling)) '.'])
        [rbfSvm.bestModel{i_subsampling},rbfSvm.bestC(i_subsampling),rbfSvm.bestGamma(i_subsampling),rbfSvm.bestTuningPerfMetric(i_subsampling),rbfSvm.trainPredictions{i_subsampling},rbfSvm.validationPredictions{i_subsampling}] = tuneRbfSvmClassificationHyperparameters(subsampledTrainData,subsampledValidationData,cValues,gammaValues);
        disp(['Tuned rbfSVM: C = ' num2str(rbfSvm.bestC(i_subsampling)) ', gamma = ' num2str(rbfSvm.bestGamma(i_subsampling)) ' with accuracy = ' num2str(rbfSvm.bestTuningPerfMetric(i_subsampling)) '.'])
        [ckSvm.bestModel{i_subsampling},ckSvm.bestC(i_subsampling),ckSvm.bestTuningPerfMetric(i_subsampling),ckSvm.trainPredictions{i_subsampling},ckSvm.validationPredictions{i_subsampling}] = tuneCkSvmClassificationHyperparameters(subsampledTrainData,subsampledValidationData,cValues);
        disp(['Tuned ckSVM: C = ' num2str(ckSvm.bestC(i_subsampling)) ' with accuracy = ' num2str(ckSvm.bestTuningPerfMetric(i_subsampling)) '.'])
        [ckRf.bestModel{i_subsampling},ckRf.bestM(i_subsampling),ckRf.bestMaxSplits(i_subsampling),ckRf.bestTuningPerfMetric(i_subsampling),ckRf.trainPredictions{i_subsampling},ckRf.validationPredictions{i_subsampling}] = tuneCkRfClassificationHyperparameters(subsampledTrainData,subsampledValidationData,mValuesCk,maxSplitsValues,categoricalIndices,numeroTrees);
        disp(['Tuned ckRF: m = ' num2str(ckRf.bestM(i_subsampling)) ', maxSplits = ' num2str(ckRf.bestMaxSplits(i_subsampling)) ' with accuracy = ' num2str(ckRf.bestTuningPerfMetric(i_subsampling)) '.'])
    else
        [rf.bestModel{i_subsampling},rf.bestM(i_subsampling),rf.bestMaxSplits(i_subsampling),rf.bestTuningPerfMetric(i_subsampling),rf.trainPredictions{i_subsampling},rf.validationPredictions{i_subsampling}] = tuneRfRegressionHyperparameters(subsampledTrainData,subsampledValidationData,mValuesNaive,maxSplitsValues,categoricalIndices,numeroTrees);
        disp(['Tuned RF: m = ' num2str(rf.bestM(i_subsampling)) ', maxSplits = ' num2str(rf.bestMaxSplits(i_subsampling)) ' with R^2 = ' num2str(rf.bestTuningPerfMetric(i_subsampling)) '.'])
        [linSvm.bestModel{i_subsampling},linSvm.bestC(i_subsampling),linSvm.bestEpsilon(i_subsampling),linSvm.bestTuningPerfMetric(i_subsampling),linSvm.trainPredictions{i_subsampling},linSvm.validationPredictions{i_subsampling}] = tuneLinSvmRegressionHyperparameters(subsampledTrainData,subsampledValidationData,cValues,epsilonValues);
        disp(['Tuned linSVM: C = ' num2str(linSvm.bestC(i_subsampling)) ', epsilon = ' num2str(linSvm.bestEpsilon(i_subsampling)) ' with R^2 = ' num2str(linSvm.bestTuningPerfMetric(i_subsampling)) '.'])
        [rbfSvm.bestModel{i_subsampling},rbfSvm.bestC(i_subsampling),rbfSvm.bestGamma(i_subsampling),rbfSvm.bestEpsilon(i_subsampling),rbfSvm.bestTuningPerfMetric(i_subsampling),rbfSvm.trainPredictions{i_subsampling},rbfSvm.validationPredictions{i_subsampling}] = tuneRbfSvmRegressionHyperparameters(subsampledTrainData,subsampledValidationData,cValues,gammaValues,epsilonValues);
        disp(['Tuned rbfSVM: C = ' num2str(rbfSvm.bestC(i_subsampling)) ', gamma = ' num2str(rbfSvm.bestGamma(i_subsampling)) ', epsilon = ' num2str(rbfSvm.bestEpsilon(i_subsampling)) ' with R^2 = ' num2str(rbfSvm.bestTuningPerfMetric(i_subsampling)) '.'])
        [ckSvm.bestModel{i_subsampling},ckSvm.bestC(i_subsampling),ckSvm.bestEpsilon(i_subsampling),ckSvm.bestTuningPerfMetric(i_subsampling),ckSvm.trainPredictions{i_subsampling},ckSvm.validationPredictions{i_subsampling}] = tuneCkSvmRegressionHyperparameters(subsampledTrainData,subsampledValidationData,cValues,epsilonValues);
        disp(['Tuned ckSVM: C = ' num2str(ckSvm.bestC(i_subsampling)) ', epsilon = ' num2str(ckSvm.bestEpsilon(i_subsampling)) ' with R^2 = ' num2str(ckSvm.bestTuningPerfMetric(i_subsampling)) '.'])
        [ckRf.bestModel{i_subsampling},ckRf.bestM(i_subsampling),ckRf.bestMaxSplits(i_subsampling),ckRf.bestTuningPerfMetric(i_subsampling),ckRf.trainPredictions{i_subsampling},ckRf.validationPredictions{i_subsampling}] = tuneCkRfRegressionHyperparameters(subsampledTrainData,subsampledValidationData,mValuesCk,maxSplitsValues,categoricalIndices,numeroTrees);
        disp(['Tuned ckRF: m = ' num2str(ckRf.bestM(i_subsampling)) ', maxSplits = ' num2str(ckRf.bestMaxSplits(i_subsampling)) ' with R^2 = ' num2str(ckRf.bestTuningPerfMetric(i_subsampling)) '.'])
    end
    %% predicting on test data
    % choose correct string for console output
    if classificationBoolean
        perfMetricString = 'accuracy';
    else
        perfMetricString = 'R^2';
    end
    
    nn.bestModel{i_subsampling} = subsampledTrainData;
    [nn.perfMetric(i_subsampling),nn.testPredictions{i_subsampling}] = predictTestData(subsampledTestData,nn.bestModel{i_subsampling},'nn',classificationBoolean);
    disp(['NN test ' perfMetricString ' = ' num2str(nn.perfMetric(i_subsampling)) '.' ])
    
    [rf.perfMetric(i_subsampling),rf.testPredictions{i_subsampling}] = predictTestData(subsampledTestData,rf.bestModel{i_subsampling},'rf',classificationBoolean);
    disp(['RF test ' perfMetricString ' = ' num2str(rf.perfMetric(i_subsampling)) '.' ])
    
    [linSvm.perfMetric(i_subsampling),linSvm.testPredictions{i_subsampling}] = predictTestData(subsampledTestData,linSvm.bestModel{i_subsampling},'linSvm',classificationBoolean);
    disp(['linSVM test ' perfMetricString ' = ' num2str(linSvm.perfMetric(i_subsampling)) '.' ])
    
    [rbfSvm.perfMetric(i_subsampling),rbfSvm.testPredictions{i_subsampling}] = predictTestData(subsampledTestData,rbfSvm.bestModel{i_subsampling},'rbfSvm',classificationBoolean);
    disp(['rbfSVM test ' perfMetricString ' = ' num2str(rbfSvm.perfMetric(i_subsampling)) '.' ])
    
    [ckSvm.perfMetric(i_subsampling),ckSvm.testPredictions{i_subsampling}] = predictTestData(subsampledTestData,ckSvm.bestModel{i_subsampling},'ckSvm',classificationBoolean);
    disp(['ckSVM test ' perfMetricString ' = ' num2str(ckSvm.perfMetric(i_subsampling)) '.' ])
    
    [ckRf.perfMetric(i_subsampling),ckRf.testPredictions{i_subsampling}] = predictTestData(subsampledTestData,ckRf.bestModel{i_subsampling},'ckRf',classificationBoolean);
    disp(['ckRF test ' perfMetricString ' = ' num2str(ckRf.perfMetric(i_subsampling)) '.' ])
    
    ckNn.bestModel{i_subsampling} = subsampledTrainData;
    [ckNn.perfMetric(i_subsampling),ckNn.testPredictions{i_subsampling}] = predictTestData(subsampledTestData,ckNn.bestModel{i_subsampling},'ckNn',classificationBoolean);
    disp(['ckNN test ' perfMetricString ' = ' num2str(ckNn.perfMetric(i_subsampling)) '.' ])
    
    expInfo.numeroTrainSamples(i_subsampling) = numel(subsampledTrainData.outcome);
    expInfo.numeroValidationSamples(i_subsampling) = numel(subsampledValidationData.outcome);
    expInfo.numeroTestSamples(i_subsampling) = numel(subsampledTestData.outcome);
    
    expInfo.subsampledTrainData{i_subsampling} = subsampledTrainData;
    expInfo.subsampledValidationData{i_subsampling} = subsampledValidationData;
    expInfo.subsampledTestData{i_subsampling} = subsampledTestData;
    
end

expInfo.trainData = trainData;
expInfo.validationData = validationData;
expInfo.testData = testData;
expInfo.randSeedSplitting = randSeedSplitting;
expInfo.randSeedSubsampling = randSeedSubsampling;

% linSvm = NaN; % if you want to remove linSvm
% store hyperparameters in struct to pass outside the function
hps.cValues = cValues;
hps.epsilonValues = epsilonValues;
hps.gammaValues = gammaValues;
hps.mValuesNaive = mValuesNaive;
hps.mValuesCk = mValuesCk;
hps.maxSplits = maxSplitsValues;

algs.nn = nn;
algs.linSvm = linSvm;
algs.rbfSvm = rbfSvm;
algs.rf = rf;
algs.skSvm = ckSvm;
algs.skRf = ckRf;
algs.skNn = ckNn;


end