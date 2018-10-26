clear
clc
close all

figure('Position', [676 309 1199 771]);

[pathToPlottingFolder,pathToDataFolder,pathToLibSvmFolder,pathToMatlab2TikzFolder] = loadMyPaths();

%% radiation line (with bad kernel) and boxplot
dataDump = load(fullfile(pathToDataFolder,'radiationBetter_light'));

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

dataDump = load(fullfile(pathToDataFolder,'radiation_light'));
algsBad = dataDump.algs;
expInfoBad = dataDump.expInfo;
hpsBad = dataDump.hps;


myRed  = [217 95 2] ./255;
myGreen = [27 158 119] ./255;

fig2Boolean = true;
legendOn = false;
clf
subplot(2,2,[1 2])
genericBoxplot(algs,expInfo,classificationBoolean,'Radiation model',fig2Boolean,legendOn)

subplot(2,2,3)
radiationLinePlot(algs,algsBad,expInfo,classificationBoolean,'Radiation model',fig2Boolean)

%% load flowering data
dataDump = load(fullfile(pathToDataFolder,'flowering_light'));

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;


subplot(2,2,4)
genericLinePlot(algs,expInfo,classificationBoolean,'Flowering time model',fig2Boolean)

set(gcf,'PaperOrientation','landscape')
print(fullfile(pathToPlottingFolder,'mainResultsFig.pdf'),'-dpdf')