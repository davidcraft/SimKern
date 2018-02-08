clear
clc
close all

[pathToPlottingFolder,pathToDataFolder,pathToLibSvmFolder,pathToMatlab2TikzFolder] = loadMyPaths();

addpath(pathToMatlab2TikzFolder)
%% radiation line (with bad kernel) and boxplot
fig2Boolean = false;
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
radiationLinePlot(algs,algsBad,expInfo,classificationBoolean,titleName,fig2Boolean)
% matlab2tikz(fullfile(pathToPlottingFolder,'radiationLine.tex'))
print(fullfile(pathToPlottingFolder,'radiationLine.eps'),'-depsc2')
print(fullfile(pathToPlottingFolder,'radiationLine.pdf'),'-dpdf')
print(fullfile(pathToPlottingFolder,'radiationLine.png'),'-dpng','-r300')

genericBoxplot(algs,expInfo,classificationBoolean,titleName,fig2Boolean)
% matlab2tikz(fullfile(pathToPlottingFolder,'radiationBox.tex'))
print(fullfile(pathToPlottingFolder,'radiationBox.eps'),'-depsc2')
print(fullfile(pathToPlottingFolder,'radiationBox.pdf'),'-dpdf')
print(fullfile(pathToPlottingFolder,'radiationBox.png'),'-dpng','-r300')


%% flowering line
clear
fig2Boolean = false;
[pathToPlottingFolder,pathToDataFolder,pathToLibSvmFolder,pathToMatlab2TikzFolder] = loadMyPaths();

dataDump = load(fullfile(pathToDataFolder,'Flowering_light'));

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;
titleName = 'Flowering time model';
genericLinePlot(algs,expInfo,classificationBoolean,titleName,fig2Boolean)
% matlab2tikz(fullfile(pathToPlottingFolder,'floweringLine.tex'))
print(fullfile(pathToPlottingFolder,'floweringLine.eps'),'-depsc2')
print(fullfile(pathToPlottingFolder,'floweringLine.pdf'),'-dpdf')
print(fullfile(pathToPlottingFolder,'floweringLine.png'),'-dpng','-r300')

genericBoxplot(algs,expInfo,classificationBoolean,titleName,fig2Boolean)
% matlab2tikz(fullfile(pathToPlottingFolder,'floweringBox.tex'))
print(fullfile(pathToPlottingFolder,'floweringBox.eps'),'-depsc2')
print(fullfile(pathToPlottingFolder,'floweringBox.pdf'),'-dpdf')
print(fullfile(pathToPlottingFolder,'floweringBox.png'),'-dpng','-r300')

%% network line - harder
clear
fig2Boolean = false;
[pathToPlottingFolder,pathToDataFolder,pathToLibSvmFolder,pathToMatlab2TikzFolder] = loadMyPaths();

dataDump = load(fullfile(pathToDataFolder,'networkHarderScalar_light'));

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;
titleName = 'Network flow model (harder kernel)';
genericLinePlot(algs,expInfo,classificationBoolean,titleName,fig2Boolean)
% matlab2tikz(fullfile(pathToPlottingFolder,'networkLine_harder.eps.tex'))
print(fullfile(pathToPlottingFolder,'networkLine_harder.eps'),'-depsc2')
print(fullfile(pathToPlottingFolder,'networkLine_harder.eps.pdf'),'-dpdf')
print(fullfile(pathToPlottingFolder,'networkLine_harder.eps.png'),'-dpng','-r300')

genericBoxplot(algs,expInfo,classificationBoolean,titleName,fig2Boolean)
% matlab2tikz(fullfile(pathToPlottingFolder,'networkBox_harder.eps.tex'))
print(fullfile(pathToPlottingFolder,'networkBox_harder.eps.eps'),'-depsc2')
print(fullfile(pathToPlottingFolder,'networkBox_harder.eps.pdf'),'-dpdf')
print(fullfile(pathToPlottingFolder,'networkBox_harder.eps.png'),'-dpng','-r300')

%% network line - easier
clear
fig2Boolean = false;
[pathToPlottingFolder,pathToDataFolder,pathToLibSvmFolder,pathToMatlab2TikzFolder] = loadMyPaths();

dataDump = load(fullfile(pathToDataFolder,'networkEasierScalar_light'));

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;
titleName = 'Network flow model (easier kernel)';
genericLinePlot(algs,expInfo,classificationBoolean,titleName,fig2Boolean)
% matlab2tikz(fullfile(pathToPlottingFolder,'networkLine_easier.tex'))
print(fullfile(pathToPlottingFolder,'networkLine_easier.eps'),'-depsc2')
print(fullfile(pathToPlottingFolder,'networkLine_easier.pdf'),'-dpdf')
print(fullfile(pathToPlottingFolder,'networkLine_easier.png'),'-dpng','-r300')

genericBoxplot(algs,expInfo,classificationBoolean,titleName,fig2Boolean)
% matlab2tikz(fullfile(pathToPlottingFolder,'networkBox_easier.tex'))
print(fullfile(pathToPlottingFolder,'networkBox_easier.eps'),'-depsc2')
print(fullfile(pathToPlottingFolder,'networkBox_easier.pdf'),'-dpdf')
print(fullfile(pathToPlottingFolder,'networkBox_easier.png'),'-dpng','-r300')

%% boolean line
clear
fig2Boolean = false;
[pathToPlottingFolder,pathToDataFolder,pathToLibSvmFolder,pathToMatlab2TikzFolder] = loadMyPaths();

dataDump = load(fullfile(pathToDataFolder,'Boolean_light'));

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;
titleName = 'Boolean cell model';
genericLinePlot(algs,expInfo,classificationBoolean,titleName,fig2Boolean)
% matlab2tikz(fullfile(pathToPlottingFolder,'booleanLine.tex'))
print(fullfile(pathToPlottingFolder,'booleanLine.eps'),'-depsc2')
print(fullfile(pathToPlottingFolder,'booleanLine.pdf'),'-dpdf')
print(fullfile(pathToPlottingFolder,'booleanLine.png'),'-dpng','-r300')

genericBoxplot(algs,expInfo,classificationBoolean,titleName,fig2Boolean)
% matlab2tikz(fullfile(pathToPlottingFolder,'booleanBox.tex'))
print(fullfile(pathToPlottingFolder,'booleanBox.eps'),'-depsc2')
print(fullfile(pathToPlottingFolder,'booleanBox.pdf'),'-dpdf')
print(fullfile(pathToPlottingFolder,'booleanBox.png'),'-dpng','-r300')

%% create legend
createLegend()
% matlab2tikz(fullfile(pathToPlottingFolder,'legend.tex'))
print(fullfile(pathToPlottingFolder,'legend.eps'),'-depsc2')
print(fullfile(pathToPlottingFolder,'legend.pdf'),'-dpdf')
print(fullfile(pathToPlottingFolder,'legend.png'),'-dpng','-r300')