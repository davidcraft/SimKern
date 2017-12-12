clear
clc
tic

% load libsvm
addpath('')
%% read in data

%read full similarity matrix
f = '..\SimKernModels\Flowering\DataReadyForML\Sim1SimilarityMatrixfinal.csv';
sm =  csvread(f);


xfile = '..\SimKernModels\Flowering\DataReadyForML\Sim0GenomesMatrix.csv';
x = csvread(xfile);
% collapse the MUT vars into 1 [if MUT.knockdown, which is x(:,1),
% is 0, then there is no mutation, so just multiple this with the
% discrete 19 mutation types]
x = horzcat(x(:,1).*x(:,2),x(:,3:end));
unstandardizedFeatures = x;

yfile = '..\SimKernModels\Flowering\DataReadyForML\Sim0Output.csv';
y=csvread(yfile);
outcome = y';


%% experiment parameters
splitRatios = [0.5 0.25 0.25];
subsamplingRatios = [0.1 0.2 0.5 0.75 1];
categoricalIndices = false(1,size(unstandardizedFeatures,2));
categoricalIndices(1) = true;
debuggingBoolean = false; % set to true if you want to use fewer hyperparameters to speed up the process
classificationBoolean = false;
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
pathToMatFile = ['../../data/flower_' timeStamp];
 save(pathToMatFile)