%% c
x = hyperparameters(2).cValues;
for ii = 1: numeroReps
    disp(['Repetition: ' num2str(ii)])
    disp('linSvm')
    y = linSvm(ii).bestC;
    [bla] = checkHyperparameterLimits(x,y);
    disp('rbfSvm')
    y = rbfSvm(ii).bestC;
    [bla] = checkHyperparameterLimits(x,y);
    disp('skSvm')
    y = skSvm(ii).bestC;
    [bla] = checkHyperparameterLimits(x,y);
end

%% epsilon
x = hyperparameters(2).epsilonValues;
for ii = 1: numeroReps
    disp(['Repetition: ' num2str(ii)])
    disp('linSvm')
    y = linSvm(ii).bestEpsilon;
    [bla] = checkHyperparameterLimits(x,y);
    disp('rbfSvm')
    y = rbfSvm(ii).bestEpsilon;
    [bla] = checkHyperparameterLimits(x,y);
    disp('skSvm')
    y = skSvm(ii).bestEpsilon;
    [bla] = checkHyperparameterLimits(x,y);
end

%% gamma
x = hyperparameters(2).gammaValues;
for ii = 1: numeroReps
    disp(['Repetition: ' num2str(ii)])
    disp('rbfSvm')
    y = rbfSvm(ii).bestGamma;
    [bla] = checkHyperparameterLimits(x,y);
end

%% max splits
x = hyperparameters(2).maxSplits;
for ii = 1: numeroReps
    disp(['Repetition: ' num2str(ii)])
    disp('rf')
    y = rf(ii).bestMaxSplits;
    [bla] = checkHyperparameterLimits(x,y);
    y = skRf(ii).bestMaxSplits;
    [bla] = checkHyperparameterLimits(x,y);
end

%% m values naive

x = hyperparameters(2).mValuesNaive;
for ii = 1: numeroReps
    disp(['Repetition: ' num2str(ii)])
    disp('rf')
    y = rf(ii).bestM;
    [bla] = checkHyperparameterLimits(x,y);
end

%% m values sk
x = hyperparameters(2).mValuesCk;
for ii = 1: numeroReps
    disp(['Repetition: ' num2str(ii)])
    disp('rf')
    y = skRf(ii).bestM;
    [bla] = checkHyperparameterLimits(x,y);
end


