clear
clc

% NOTES:
% - linear svm training takes much longer than rbf svm??
% - rbf svm regression predicts same value
% - categorical variables need to be >0 for dummy coding
% - currently, number of trees set to 50 (to make debugging faster)
% - currently, searching fewer hyperparameter values (to make debugging faster)

% TO DO
% - replace .classes by .outcome
% - replace .accuracy by .performanceMetric or .perfMetric
% - consider replacing R2 by MSE
% - consider incremental subsampling (always adding on top of the current
% set)
% - create outer loop that requires a path to data files for each rep
% - 

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

% if you want to turn the case into a ternary classification
classes(y < quantile(y,1/3)) = 1;
classes( (y >= quantile(y,1/3)) & (y < quantile(y,2/3)) ) = 2;
classes(y >= quantile(y,2/3)) = 3;
classes = classes'; % libsvm expects column vectors
% if you want to turn the case into a binary classification
% classes = (y>= median(y)) + 0;
% if you want to use regression
% classes = y; % regression

%% experiment parameters
splitRatios = [0.5 0.25 0.25];
subsamplingRatios = [0.2 0.4 0.6 0.8 1];
categoricalIndices = logical([1 zeros(1,size(unstandardizedFeatures,2) - 1)]);
classificationBoolean = true;
%%
for i_reps = 1:10
[linSvm(i_reps),rbfSvm(i_reps),rf(i_reps),ckSvm(i_reps),ckRf(i_reps)] = runExperiment(unstandardizedFeatures,...
    classes,sm,splitRatios,classificationBoolean,subsamplingRatios,...
    categoricalIndices);
end
%% plotting for a single run
% clf
% hold on
% % plot(subsamplingRatios,linSvm.accuracy,'k-*')
% plot(subsamplingRatios,rbfSvm.accuracy,'b-*')
% plot(subsamplingRatios,rf.accuracy,'g-*')
% plot(subsamplingRatios,ckSvm.accuracy,'r-*')
% xlabel('Subsampling ratio')
% if classificationBoolean
%     ylabel('Accuracy')
% else
%     ylabel('R^2')
% end
% legend('lin SVM','rbf SVM','rf','ck SVM')

%% plotting
rbfResult = cat(1,rbfSvm(:).accuracy);
rfResult = cat(1,rf(:).accuracy);
ckResult = cat(1,ckSvm(:).accuracy);
linResult = cat(1,linSvm(:).accuracy);
ckRfResult = cat(1,ckRf(:).accuracy);
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

