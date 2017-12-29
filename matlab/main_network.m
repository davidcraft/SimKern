clear
clc
tic
% load libsvm
addpath('C:\Users\timo.deist\Documents\sim0sim1\code\matlab\libsvm-3.22\windows')
%% read in data

%read full similarity matrix
f = '..\SimKernModels\NetworkFlow\DataReadyForML\Sim1SimilarityMatrixfinal.csv';
sm =  csvread(f);

%xfile needed for RF and normnal SVMs, but not used by custom kernel SVM
xfile = '..\SimKernModels\NetworkFlow\DataReadyForML\Sim0GenomesMatrix.csv';
unstandardizedFeatures = csvread(xfile);

yfile = '..\SimKernModels\NetworkFlow\DataReadyForML\Sim0Output.csv';
y=csvread(yfile);
outcome = y';


%% experiment parameters
splitRatios = [0.5 0.25 0.25];
subsamplingRatios = [0.1 0.25 0.5 0.75 1];
categoricalIndices = false(1,size(unstandardizedFeatures,2));
debuggingBoolean = false; % set to true if you want to use fewer hyperparameters to speed up the process
classificationBoolean = true;
numeroTrees = 100; % number of trees for all RFs
numeroReps = 5;
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
pathToMatFile = ['../../data/network_' timeStamp];
save(pathToMatFile)