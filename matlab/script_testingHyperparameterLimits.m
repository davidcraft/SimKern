%% c
x = hps(2).cValues;
for ii = 1: numeroReps
    disp(['Repetition: ' num2str(ii)])
    disp('linSvm')
    y = algs(ii).linSvm.bestC;
    [bla] = checkHyperparameterLimits(x,y);
    disp('rbfSvm')
    y = algs(ii).rbfSvm.bestC;
    [bla] = checkHyperparameterLimits(x,y);
    disp('skSvm')
    y = algs(ii).skSvm.bestC;
    [bla] = checkHyperparameterLimits(x,y);
end
% c max for rbfsvm: radiation; flowering; boolean (only once); network
%% epsilon
x = hps(2).epsilonValues;
for ii = 1: numeroReps
    disp(['Repetition: ' num2str(ii)])
    disp('linSvm')
    y = algs(ii).linSvm.bestEpsilon;
    [bla] = checkHyperparameterLimits(x,y);
    disp('rbfSvm')
    y = algs(ii).rbfSvm.bestEpsilon;
    [bla] = checkHyperparameterLimits(x,y);
    disp('skSvm')
    y = algs(ii).skSvm.bestEpsilon;
    [bla] = checkHyperparameterLimits(x,y);
end
% epsilon min and max (mostly min) for all svms
%% gamma
x = hps(2).gammaValues;
for ii = 1: numeroReps
    disp(['Repetition: ' num2str(ii)])
    disp('rbfSvm')
    y = algs(ii).rbfSvm.bestGamma;
    [bla] = checkHyperparameterLimits(x,y);
end
% touches min twice at subsample 1 (network)
%% max splits
x = hps(2).maxSplits;
for ii = 1: numeroReps
    disp(['Repetition: ' num2str(ii)])
    disp('rf')
    y = algs(ii).rf.bestMaxSplits;
    [bla] = checkHyperparameterLimits(x,y);
    y = algs(ii).skRf.bestMaxSplits;
    [bla] = checkHyperparameterLimits(x,y);
end

%% m values naive

x = hps(2).mValuesNaive;
for ii = 1: numeroReps
    disp(['Repetition: ' num2str(ii)])
    disp('rf')
    y = algs(ii).rf.bestM;
    [bla] = checkHyperparameterLimits(x,y);
end

%% m values sk
x = hps(2).mValuesCk;
for ii = 1: numeroReps
    disp(['Repetition: ' num2str(ii)])
    disp('rf')
    y = algs(ii).skRf.bestM;
    [bla] = checkHyperparameterLimits(x,y);
end


