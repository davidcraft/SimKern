clear
clc
tic
% load libsvm
[pathToPlottingFolder,pathToDataFolder,pathToLibSvmFolder,pathToMatlab2TikzFolder] = loadMyPaths();
addpath(pathToLibSvmFolder)
%% read in data

%read full similarity matrix
f = '..\SimKernModels\Flowering\DataReadyForML\noiseExperiments\Sim1worseSimMatrix.csv';
sm =  csvread(f);

%xfile needed for RF and normnal SVMs, but not used by custom kernel SVM
xfile = '..\SimKernModels\Flowering\DataReadyForML\noiseExperiments\Sim0GenomesMatrix.csv';
x = csvread(xfile);
% collapse the MUT vars into 1 [if MUT.knockdown, which is x(:,1),
% is 0, then there is no mutation, so just multiple this with the
% discrete 19 mutation types]
x = horzcat(x(:,1).*x(:,2),x(:,3:end));
unstandardizedFeatures = x;

yfile = '..\SimKernModels\Flowering\DataReadyForML\noiseExperiments\Sim0Output.csv';
y=csvread(yfile);
outcome = y';


%% experiment parameters
splitRatios = [0.5 0.25 0.25];
subsamplingRatios = [0.05 0.1 0.3 0.6 1];
categoricalIndices = false(1,size(unstandardizedFeatures,2));
categoricalIndices(1) = true;
debuggingBoolean = false; % set to true if you want to use fewer hyperparameters to speed up the process %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classificationBoolean = false;
numeroTrees = 100; % number of trees for all RFs
numeroReps = 10;
randSeedSplitting = 1:numeroReps;
randSeedSubsampling = 100 + reshape(1:(numeroReps*numel(subsamplingRatios)),numel(subsamplingRatios),numeroReps)';
%% the actual experiment
for i_reps = 1:numeroReps
    [algs(i_reps),hps(i_reps),expInfo(i_reps)] = runExperiment(unstandardizedFeatures,...
        outcome,sm,splitRatios,classificationBoolean,subsamplingRatios,...
        categoricalIndices,numeroTrees,debuggingBoolean,i_reps,numeroReps,randSeedSplitting(i_reps),randSeedSubsampling(i_reps,:));
end
totalRunningTime = toc
%% save results with time stamp
timeStamp = datetime('now');
timeStamp = datestr(timeStamp);
timeStamp = strrep(timeStamp,':','_');
timeStamp = strrep(timeStamp,'-','_');
timeStamp = strrep(timeStamp,' ','_');
pathToMatFile = fullfile(pathToDataFolder,'flowering_noise_worse');
save(pathToMatFile)

pathToMatFileLight = fullfile(pathToDataFolder,'flowering_noise_worse_light');

for i_reps = 1:numeroReps
    % remove bestModel field to decrease .mat file size
    algs(i_reps).nn = rmfield(algs(i_reps).nn,'bestModel');
    algs(i_reps).linSvm = rmfield(algs(i_reps).linSvm,'bestModel');
    algs(i_reps).rbfSvm = rmfield(algs(i_reps).rbfSvm,'bestModel');
    algs(i_reps).rf = rmfield(algs(i_reps).rf,'bestModel');
    algs(i_reps).skSvm = rmfield(algs(i_reps).skSvm,'bestModel');
    algs(i_reps).skRf = rmfield(algs(i_reps).skRf,'bestModel');
    algs(i_reps).skNn = rmfield(algs(i_reps).skNn,'bestModel');
end

% delete expInfo data fields to decrease .mat file size
    expInfo = rmfield(expInfo,'subsampledTrainData');
    expInfo = rmfield(expInfo,'subsampledValidationData');
    expInfo = rmfield(expInfo,'subsampledTestData');
    expInfo = rmfield(expInfo,'trainData');
    expInfo = rmfield(expInfo,'validationData');
    expInfo = rmfield(expInfo,'testData');

save(pathToMatFileLight)