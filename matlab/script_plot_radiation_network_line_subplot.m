clear
clc
close all

[pathToPlottingFolder,pathToDataFolder,pathToLibSvmFolder,pathToMatlab2TikzFolder] = loadMyPaths();

%addpath(pathToMatlab2TikzFolder)
%% radiation line good and bad kernels
subplotStyleBoolean = true;
dataDump = load(fullfile(pathToDataFolder,'radiationBetter_light'));

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

dataDump = load(fullfile(pathToDataFolder,'radiation_light'));
algsBad = dataDump.algs;
expInfoBad = dataDump.expInfo;
hpsBad = dataDump.hps;
titleName = 'Radiation model';

subplot(1,2,1)
goodKernelLabel = {'\textbf{Higher}' '\textbf{quality}' '\textbf{kernel}'};
goodKernelLabelPos = [400,0.825];
badKernelLabel = {'\textbf{Lower}' '\textbf{quality}' '\textbf{kernel}'};
badKernelLabelPos = [400,0.725];
titlePos = [200 0.6];
twoKernelLinePlot(algs,algsBad,expInfo,classificationBoolean,titleName,subplotStyleBoolean,goodKernelLabel,badKernelLabel,goodKernelLabelPos,badKernelLabelPos,titlePos)
%% network line less noise and more noise kernels
clear
subplotStyleBoolean = true;
[pathToPlottingFolder,pathToDataFolder,pathToLibSvmFolder,pathToMatlab2TikzFolder] = loadMyPaths();

dataDump = load(fullfile(pathToDataFolder,'networkEasierScalar_light'));
algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;


dataDump = load(fullfile(pathToDataFolder,'networkHarderScalar_light'));
algsBad = dataDump.algs;
expInfoBad = dataDump.expInfo;
hpsBad = dataDump.hps;
titleName = 'Network flow model';

subplot(1,2,2)
goodKernelLabel = {'\textbf{Less}' '\textbf{noise}'};
goodKernelLabelPos = [15,0.955];
badKernelLabel = {'\textbf{More}' '\textbf{noise}'};
badKernelLabelPos = [15,0.825];
titlePos = [17 0.75];
twoKernelLinePlot(algs,algsBad,expInfo,classificationBoolean,titleName,subplotStyleBoolean,goodKernelLabel,badKernelLabel,goodKernelLabelPos,badKernelLabelPos,titlePos)


print(fullfile(pathToPlottingFolder,'radiationNetworkLineSubplot.eps'),'-depsc2')
print(fullfile(pathToPlottingFolder,'radiationNetworkLineSubplot.pdf'),'-dpdf')
print(fullfile(pathToPlottingFolder,'radiationNetworkLineSubplot.png'),'-dpng','-r300')
