clear
clc
tic
% NOTES:

% TO DO
% - save final models separately to avoid massive .mat files
% - consider replacing R2 by MSE
% - consider incremental subsampling (always adding on top of the current
% set)
% - create outer loop that requires a path to data files for each rep

% load libsvm
addpath('C:\Users\timo.deist\Documents\sim0sim1\code\matlab\libsvm-3.22')
%% read in data

%read full similarity matrix
f = 'C:\Users\timo.deist\Documents\sim0sim1\data\flower\Sim1SimilarityMatrixfinal.csv';
sm =  csvread(f);

%xfile needed for RF and normnal SVMs, but not used by custom kernel SVM
xfile = 'C:\Users\timo.deist\Documents\sim0sim1\data\flower\Sim0GenomesMatrix.csv';
x = csvread(xfile);

%collapse the MUT vars into 1 [if MUT.knockdown, which is x(:,1),
%is 0, then there is no mutation, so just multiple this with the
%discrete 19 mutation types]
x = horzcat(x(:,1).*x(:,2),x(:,3:end));
unstandardizedFeatures = x;
% unstandardizedFeatures(:,1) = 1 + unstandardizedFeatures(:,1);

yfile = 'C:\Users\timo.deist\Documents\sim0sim1\data\flower\Sim0Output.csv';
y=csvread(yfile);
y=y';

%% if you want to turn the case into a ternary classification
outcome(y < quantile(y,1/3)) = 1;
outcome( (y >= quantile(y,1/3)) & (y < quantile(y,2/3)) ) = 2;
outcome(y >= quantile(y,2/3)) = 3;
outcome = outcome'; % libsvm expects column vectors
classificationBoolean = true;
%% if you want to turn the case into a binary classification
% outcome = (y>= median(y)) + 0;
% classificationBoolean = true;
%% if you want to use regression
% outcome = y; % regression
% classificationBoolean = false;
%% experiment parameters
splitRatios = [0.5 0.25 0.25];
subsamplingRatios = [0.2 0.4 0.6 0.8 1];
categoricalIndices = logical([1 zeros(1,size(unstandardizedFeatures,2) - 1)]);
%% the actual experiment
for i_reps = 1:1
[linSvm(i_reps),rbfSvm(i_reps),rf(i_reps),ckSvm(i_reps),ckRf(i_reps)] = runExperiment(unstandardizedFeatures,...
    outcome,sm,splitRatios,classificationBoolean,subsamplingRatios,...
    categoricalIndices);
end
totalRunningTime = toc
%% plotting
rbfResult = cat(1,rbfSvm(:).perfMetric);
rfResult = cat(1,rf(:).perfMetric);
ckResult = cat(1,ckSvm(:).perfMetric);
linResult = cat(1,linSvm(:).perfMetric);
ckRfResult = cat(1,ckRf(:).perfMetric);
clf
hold on

boxplot([linResult rbfResult rfResult ckResult ckRfResult],'position', [1 2 3 4 5 1.1 2.1 3.1 4.1 5.1 1.2 2.2 3.2 4.2 5.2 1.3 2.3 3.3 4.3 5.3 1.4 2.4 3.4 4.4 5.4],...
    'labels',{'lin' 'lin' 'lin' 'lin' 'lin' 'rbf' 'rbf' 'rbf' 'rbf' 'rbf' 'rf' 'rf' 'rf' 'rf' 'rf' 'ck' 'ck' 'ck' 'ck' 'ck' 'ckrf' 'ckrf' 'ckrf' 'ckrf' 'ckrf'})
xlabel('Subsampling ratio')
if classificationBoolean
    ylabel('Accuracy')
else
    ylabel('R^2')
end
line([1.7 1.7],[-100 100],'Color','k')
line([2.7 2.7],[-100 100],'Color','k')
line([3.7 3.7],[-100 100],'Color','k')
line([4.7 4.7],[-100 100],'Color','k')

 save('flower_1rep_dump')