clear
clc
close all

[pathToPlottingFolder,pathToDataFolder,pathToLibSvmFolder,pathToMatlab2TikzFolder] = loadMyPaths();

addpath(pathToMatlab2TikzFolder)
%% flowering data with noisy kernels (un-biased and biased)
dataDump = load(fullfile(pathToDataFolder,'flowering_noise_better_light'));

algsBetter = dataDump.algs;
expInfoBetter = dataDump.expInfo;
hpsBetter = dataDump.hps;
classificationBoolean = dataDump.classificationBoolean;

dataDump = load(fullfile(pathToDataFolder,'flowering_noise_worse_light'));
algsBad = dataDump.algs;
expInfoBad = dataDump.expInfo;
hpsBad = dataDump.hps;


dataDump = load(fullfile(pathToDataFolder,'flowering_noise_nominal_light'));
algsNominal = dataDump.algs;
expInfoNominal = dataDump.expInfo;
hpsNominal = dataDump.hps;

dataDump = load(fullfile(pathToDataFolder,'flowering_noise_biased_light'));
algsBiased = dataDump.algs;
expInfoBiased = dataDump.expInfo;
hpsBiased = dataDump.hps;

boxPlotLabels = {'Gaussian(1,0.1)','Gaussian(1,0.2)','Gaussian(1,0.4)','Biased SimKern','Standard ML'};
linePlotLabels = {'SimKern, Gaussian(1,0.1)','Baseline SimKern, Gaussian(1,0.2)','SimKern, Gaussian(1,0.4)','Biased SimKern','Standard ML'};
saveBoolean = true;
legendOn = false;
%% subplot (line plot on the left, box plot on the right)
figure('Position', [676 309 900 578]);
subplotStyleBoolean = true;
sph = subplot(1,2,1);
titleName = 'Flowering model (noise experiments)';
floweringNoiseLinePlot(algsBetter,algsBad,algsNominal,algsBiased,expInfoBetter,classificationBoolean,titleName,subplotStyleBoolean,linePlotLabels)

sph = subplot(1,2,2);
floweringNoiseBoxPlot(algsBetter,algsBad,algsNominal,algsBiased,expInfoBetter,classificationBoolean,titleName,subplotStyleBoolean,boxPlotLabels);
set(gcf,'PaperOrientation','landscape')

if saveBoolean
    print(fullfile(pathToPlottingFolder,'floweringNoiseSubplots.pdf'),'-dpdf')
end
%% combination plot (boxplot inside line plot)
close all
subplotStyleBoolean = false;
titleName = 'Flowering model, noise experiments';
floweringNoiseCombinationPlot(algsBetter,algsBad,algsNominal,algsBiased,expInfoBetter,classificationBoolean,titleName,subplotStyleBoolean,linePlotLabels,boxPlotLabels)
if saveBoolean
    print(fullfile(pathToPlottingFolder,'floweringNoiseCombinedPlot.eps'),'-depsc2')
    print(fullfile(pathToPlottingFolder,'floweringNoiseCombinedPlot.pdf'),'-dpdf')
    print(fullfile(pathToPlottingFolder,'floweringNoiseCombinedPlot.png'),'-dpng','-r300')
end
%% gaussian boxplot
close all
subplotStyleBoolean = false;
titleName = 'Flowering model, noise experiments';
floweringNoiseBoxPlot(algsBetter,algsBad,algsNominal,algsBiased,expInfoBetter,classificationBoolean,titleName,subplotStyleBoolean,boxPlotLabels);
if saveBoolean
    print(fullfile(pathToPlottingFolder,'floweringNoiseBoxplot.eps'),'-depsc2')
    print(fullfile(pathToPlottingFolder,'floweringNoiseBoxplot.pdf'),'-dpdf')
    print(fullfile(pathToPlottingFolder,'floweringNoiseBoxplot.png'),'-dpng','-r300')
end

%% Standard ML + gaussian line plot
close all
subplotStyleBoolean = false;
titleName = 'Flowering model (noise experiments)';
floweringNoiseLinePlot(algsBetter,algsBad,algsNominal,algsBiased,expInfoBetter,classificationBoolean,titleName,subplotStyleBoolean,linePlotLabels)
if saveBoolean
    print(fullfile(pathToPlottingFolder,'floweringNoiseLine.eps'),'-depsc2')
    print(fullfile(pathToPlottingFolder,'floweringNoiseLine.pdf'),'-dpdf')
    print(fullfile(pathToPlottingFolder,'floweringNoiseLine.png'),'-dpng','-r300')
end
%% boxplots per kernel (gaussians)
close all
subplotStyleBoolean = false;
titleName = 'Flowering model (less noise)';
genericBoxplot(algsBetter,expInfoBetter,classificationBoolean,titleName,subplotStyleBoolean,legendOn)
if saveBoolean
    print(fullfile(pathToPlottingFolder,'floweringBox_betterNoise.eps'),'-depsc2')
    print(fullfile(pathToPlottingFolder,'floweringBox_betterNoise.pdf'),'-dpdf')
    print(fullfile(pathToPlottingFolder,'floweringBox_betterNoise.png'),'-dpng','-r300')
end
close all
subplotStyleBoolean = false;
titleName = 'Flowering model (more noise)';
genericBoxplot(algsBad,expInfoBad,classificationBoolean,titleName,subplotStyleBoolean,legendOn)
if saveBoolean
    print(fullfile(pathToPlottingFolder,'floweringBox_badNoise.eps'),'-depsc2')
    print(fullfile(pathToPlottingFolder,'floweringBox_badNoise.pdf'),'-dpdf')
    print(fullfile(pathToPlottingFolder,'floweringBox_badNoise.png'),'-dpng','-r300')
end
close all
subplotStyleBoolean = false;
titleName = 'Flowering model (baseline noise)';
genericBoxplot(algsNominal,expInfoNominal,classificationBoolean,titleName,subplotStyleBoolean,legendOn)
if saveBoolean
    print(fullfile(pathToPlottingFolder,'floweringBox_nominalNoise.eps'),'-depsc2')
    print(fullfile(pathToPlottingFolder,'floweringBox_nominalNoise.pdf'),'-dpdf')
    print(fullfile(pathToPlottingFolder,'floweringBox_nominalNoise.png'),'-dpng','-r300')
end
%% biased noise is deactivated because it does not have the naive algorithms (nn, linSsvm,rbfSvm,rf) and then genericBoxplot() crashes
% close all
% subplotStyleBoolean = false;
% titleName = 'Flowering model, biased noise';
% genericBoxplot(algsBiased,expInfoBiased,classificationBoolean,titleName,subplotStyleBoolean)
% if saveBoolean
%     print(fullfile(pathToPlottingFolder,'floweringBox_biasedNoise.eps'),'-depsc2')
%     print(fullfile(pathToPlottingFolder,'floweringBox_biasedNoise.pdf'),'-dpdf')
%     print(fullfile(pathToPlottingFolder,'floweringBox_biasedNoise.png'),'-dpng','-r300')
% end