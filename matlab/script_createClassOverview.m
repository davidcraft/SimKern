clear
clc
tic
% load libsvm
[pathToPlottingFolder,pathToDataFolder,pathToLibSvmFolder,pathToMatlab2TikzFolder] = loadMyPaths();
addpath(pathToLibSvmFolder)
%% load classification datasets
yfile = '..\SimKernModels\Radiation\DataReadyForML\Sim0Output.csv';
yRadiation = csvread(yfile);

yfile = '..\SimKernModels\NetworkFlow\DataReadyForML\Sim0Output.csv';
yNetwork = csvread(yfile);

yfile = '..\SimKernModels\Boolean\DataReadyForML\Sim0Output.csv';
yBoolean = csvread(yfile);


x = tabulate(yRadiation);
freq{1} = x(:,3)';
% freq(1,:) = x(:,3)';
x = tabulate(yBoolean);
% freq(2,:) = x(:,3)';
freq{2} = x(:,3)';
x = tabulate(yNetwork);
% freq(3,:) = x(:,3)';
freq{3} = x(:,3)';

outputTable = zeros(3,4);
outputTable(1,:) = freq{1};
outputTable(2,1:3) = freq{2};
outputTable(3,1:3) = freq{3};

% figure
% hold on
% histogram(yRadiation)
% histogram(yNetwork)
% histogram(yBoolean)
% legend
