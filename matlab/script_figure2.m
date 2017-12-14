clear
clc
close all

%% radiation line (with bad kernel) and boxplot
dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\radiation_14_Dec_2017_18_28_25');

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\radiation_badKernel_14_Dec_2017_17_39_37');
algsBad = dataDump.algs;
expInfoBad = dataDump.expInfo;
hpsBad = dataDump.hps;

radiationLinePlot(algs,algsBad,expInfo,classificationBoolean)

saveas(gcf,'..\..\data\radiationLine.png')

radiationBoxplot(algs,expInfo,classificationBoolean)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 15 7]);
saveas(gcf,'..\..\data\radiationBox.png')

%% flowering line
clear
clc

dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\flowering_14_Dec_2017_20_24_55');

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

genericLinePlot(algs,expInfo,classificationBoolean)
saveas(gcf,'..\..\data\flowerLine.png')

%% network line
clear
clc

dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\network_14_Dec_2017_19_06_47');

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

genericLinePlot(algs,expInfo,classificationBoolean)
saveas(gcf,'..\..\data\networkLine.png')

%% boolean line

clear
clc

dataDump = load('C:\Users\timo.deist\Documents\sim0sim1\data\boolean_14_Dec_2017_19_23_29');

algs = dataDump.algs;
expInfo = dataDump.expInfo;
hps = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

genericLinePlot(algs,expInfo,classificationBoolean)
saveas(gcf,'..\..\data\booleanLine.png')