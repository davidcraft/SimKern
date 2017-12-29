clear
clc
close all
addpath('C:\Users\timo.deist\Documents\matlab_functions\matlab2tikz\src')
%% radiation line (with bad kernel) and boxplot
dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\radiation_29_Dec_2017_20_04_49');

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\radiation_badKernel_29_Dec_2017_20_14_51');
algsBad = dataDump.algs;
expInfoBad = dataDump.expInfo;
hpsBad = dataDump.hps;

radiationLinePlot(algs,algsBad,expInfo,classificationBoolean)
matlab2tikz('..\..\data\radiationLine.tex')
print('..\..\data\radiationLine.eps','-depsc2')
print('..\..\data\radiationLine.pdf','-dpdf')
print('..\..\data\radiationLine.png','-dpng','-r300')

radiationBoxplot(algs,expInfo,classificationBoolean)
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 15 7]);
matlab2tikz('..\..\data\radiationBox.tex')
print('..\..\data\radiationBox.eps','-depsc2')
print('..\..\data\radiationBox.pdf','-dpdf')
print('..\..\data\radiationBox.png','-dpng','-r300')


%% flowering line
clear
clc

dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\flowering_29_Dec_2017_01_14_30');

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

genericLinePlot(algs,expInfo,classificationBoolean,'Flowering time model')
matlab2tikz('..\..\data\floweringLine.tex')
print('..\..\data\floweringLine.eps','-depsc2')
print('..\..\data\floweringLine.pdf','-dpdf')
print('..\..\data\floweringLine.png','-dpng','-r300')

%% network line
clear
clc

dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\network_28_Dec_2017_23_00_28');

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

genericLinePlot(algs,expInfo,classificationBoolean,'Network flow model')
matlab2tikz('..\..\data\networkLine.tex')
print('..\..\data\networkLine.eps','-depsc2')
print('..\..\data\networkLine.pdf','-dpdf')
print('..\..\data\networkLine.png','-dpng','-r300')
%% boolean line

clear
clc

dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\boolean_28_Dec_2017_23_42_29');

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

genericLinePlot(algs,expInfo,classificationBoolean,'Boolean cell model')
matlab2tikz('..\..\data\booleanLine.tex')
print('..\..\data\booleanLine.eps','-depsc2')
print('..\..\data\booleanLine.pdf','-dpdf')
print('..\..\data\booleanLine.png','-dpng','-r300')
%% create legend
createLegend()
print('..\..\data\legend.eps','-depsc2')
print('..\..\data\legend.pdf','-dpdf')
print('..\..\data\legend.png','-dpng','-r300')