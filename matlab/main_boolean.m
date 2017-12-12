clear
clc
tic

% load libsvm
addpath('')
%% read in data

%read full similarity matrix
f = '..\SimKernModels\Boolean\DataReadyForML\Sim1SimilarityMatrixfinal.csv';
sm =  csvread(f);

%xfile needed for RF and normnal SVMs, but not used by custom kernel SVM
xfile = '..\SimKernModels\Boolean\DataReadyForML\Sim0GenomesMatrix.csv';
unstandardizedFeatures = csvread(xfile);

yfile = '..\SimKernModels\Boolean\DataReadyForML\Sim0Output.csv';
y=csvread(yfile);
outcome = y';


%% experiment parameters
splitRatios = [0.5 0.25 0.25];
subsamplingRatios = [0.1 0.2 0.5 0.75 1];
categoricalIndices = false(1,size(unstandardizedFeatures,2));
debuggingBoolean = false; % set to true if you want to use fewer hyperparameters to speed up the process
classificationBoolean = true;
numeroTrees = 100; % number of trees for all RFs
numeroReps = 10;
%% the actual experiment
for i_reps = 1:numeroReps
[nn(i_reps),linSvm(i_reps),rbfSvm(i_reps),rf(i_reps),skSvm(i_reps),skRf(i_reps),skNn(i_reps),hyperparameters(i_reps)] = runExperiment(unstandardizedFeatures,...
    outcome,sm,splitRatios,classificationBoolean,subsamplingRatios,...
    categoricalIndices,numeroTrees,debuggingBoolean,i_reps,numeroReps);
end
totalRunningTime = toc
%% plotting
boxplottingSimKernelResults(nn,rbfSvm,rf,skSvm,linSvm,skRf,skNn,classificationBoolean,subsamplingRatios,splitRatios,outcome);

%% save results with time stamp
timeStamp = datetime('now');
timeStamp = datestr(timeStamp);
timeStamp = strrep(timeStamp,':','_');
timeStamp = strrep(timeStamp,'-','_');
timeStamp = strrep(timeStamp,' ','_');
pathToMatFile = ['../../data/boolean_' timeStamp];
 save(pathToMatFile)