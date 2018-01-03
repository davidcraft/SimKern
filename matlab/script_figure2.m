clear
clc
close all
% addpath('C:\Users\timo.deist\Documents\matlab_functions\matlab2tikz\src')
%% radiation line (with bad kernel) and boxplot
dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\02012018\RadiationBetterKernel_light_29_Dec_2017_17_21_23');

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\02012018\Radiation_light_29_Dec_2017_17_21_21');
algsBad = dataDump.algs;
expInfoBad = dataDump.expInfo;
hpsBad = dataDump.hps;

radiationLinePlot(algs,algsBad,expInfo,classificationBoolean)
% matlab2tikz('..\..\data\radiationLine.tex')
print('..\..\data\radiationLine.eps','-depsc2')
print('..\..\data\radiationLine.pdf','-dpdf')
print('..\..\data\radiationLine.png','-dpng','-r300')

genericBoxplot(algs,expInfo,classificationBoolean)
% matlab2tikz('..\..\data\radiationBox.tex')
print('..\..\data\radiationBox.eps','-depsc2')
print('..\..\data\radiationBox.pdf','-dpdf')
print('..\..\data\radiationBox.png','-dpng','-r300')


%% flowering line
clear
dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\02012018\Flowering_light_29_Dec_2017_17_21_24');

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

genericLinePlot(algs,expInfo,classificationBoolean,'Flowering time model')
% matlab2tikz('..\..\data\floweringLine.tex')
print('..\..\data\floweringLine.eps','-depsc2')
print('..\..\data\floweringLine.pdf','-dpdf')
print('..\..\data\floweringLine.png','-dpng','-r300')

genericBoxplot(algs,expInfo,classificationBoolean)
% matlab2tikz('..\..\data\floweringBox.tex')
print('..\..\data\floweringBox.eps','-depsc2')
print('..\..\data\floweringBox.pdf','-dpdf')
print('..\..\data\floweringBox.png','-dpng','-r300')

%% network line
clear

dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\02012018\NetworkFlow_light_02_Jan_2018_10_00_12');

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

genericLinePlot(algs,expInfo,classificationBoolean,'Network flow model')
% matlab2tikz('..\..\data\networkLine.tex')
print('..\..\data\networkLine.eps','-depsc2')
print('..\..\data\networkLine.pdf','-dpdf')
print('..\..\data\networkLine.png','-dpng','-r300')

genericBoxplot(algs,expInfo,classificationBoolean)
% matlab2tikz('..\..\data\networkBox.tex')
print('..\..\data\networkBox.eps','-depsc2')
print('..\..\data\networkBox.pdf','-dpdf')
print('..\..\data\networkBox.png','-dpng','-r300')
%% boolean line
clear

dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\02012018\Boolean_light_29_Dec_2017_17_21_27');

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

genericLinePlot(algs,expInfo,classificationBoolean,'Boolean cell model')
% matlab2tikz('..\..\data\booleanLine.tex')
print('..\..\data\booleanLine.eps','-depsc2')
print('..\..\data\booleanLine.pdf','-dpdf')
print('..\..\data\booleanLine.png','-dpng','-r300')

genericBoxplot(algs,expInfo,classificationBoolean)
% matlab2tikz('..\..\data\booleanBox.tex')
print('..\..\data\booleanBox.eps','-depsc2')
print('..\..\data\booleanBox.pdf','-dpdf')
print('..\..\data\booleanBox.png','-dpng','-r300')

%% create legend
createLegend()
print('..\..\data\legend.eps','-depsc2')
print('..\..\data\legend.pdf','-dpdf')
print('..\..\data\legend.png','-dpng','-r300')