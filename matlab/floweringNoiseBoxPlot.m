function floweringNoiseBoxPlot(algs,algsBad,algsNominal,algsBiased,expInfo,classificationBoolean,titleName,subplotStyleBoolean,boxPlotLabels)
myFontsize = 12;
myLinewidth = 3;
includeNaiveBoolean = true;
% extract relevant performance data
[nnResult,linSvmResult,rbfSvmResult,rfResult,skSvmResult,skRfResult,skNnResult] = getAlgPerformanceFromStruct(algs);
[nnResultBad,linSvmResultBad,rbfSvmResultBad,rfResultBad,skSvmResultBad,skRfResultBad,skNnResultBad] = getAlgPerformanceFromStruct(algsBad);
[nnResultNominal,linSvmResultNominal,rbfSvmResultNominal,rfResultNominal,skSvmResultNominal,skRfResultNominal,skNnResultNominal] = getAlgPerformanceFromStruct(algsNominal);

%% biased kernel data misses the naive algorithms, so getAlgPerformance() doesn't work
for i_algs = 1:length(algsBiased)
    %     nnResultBiased(i_algs,:) = algsNominal(i_algs).nn.perfMetric;
    %     linSvmResultBiased(i_algs,:) = algsNominal(i_algs).linSvm.perfMetric;
    %     rbfSvmResultBiased(i_algs,:) = algsNominal(i_algs).rbfSvm.perfMetric;
    %     rfResultBiased(i_algs,:) = algsNominal(i_algs).rf.perfMetric;
    skSvmResultBiased(i_algs,:) = algsBiased(i_algs).skSvm.perfMetric;
    skRfResultBiased(i_algs,:) = algsBiased(i_algs).skRf.perfMetric;
    skNnResultBiased(i_algs,:) = algsBiased(i_algs).skNn.perfMetric;
end

%%
numeroSubsamples = numel(expInfo(1).numeroTrainSamples);

numeroTrainSamples = expInfo(1).numeroTrainSamples;
numeroValidationSamples = expInfo(1).numeroValidationSamples(1);
numeroTestSamples = expInfo(1).numeroTestSamples(1);

% error check
if numel(unique(expInfo(1).numeroValidationSamples)) ~= 1 || numel(unique(expInfo(1).numeroTestSamples)) ~= 1 ...
        || any(expInfo(1).numeroTrainSamples ~= expInfo(2).numeroTrainSamples)
    error('Data splitting wrong.')
end
% colors
myRed  = [217 95 2] ./255;
myGreen = [27 158 119] ./255;

%% find best algorithms
%% find best naive alg
[bestNaive,bestNaiveLabel] = findBestNaivePerformance(linSvmResult,rbfSvmResult,rfResult); % unused in boxplot

%% find best sk alg
[bestSk,bestSkLabel] = findBestSkPerformance(skSvmResult,skRfResult);

%% find best sk alg bad
[bestSkBad,bestSkBadLabel] = findBestSkPerformance(skSvmResultBad,skRfResultBad);

%% find best sk alg nominal
[bestSkNominal,bestSkNominalLabel] = findBestSkPerformance(skSvmResultNominal,skRfResultNominal);

%% find best sk alg biased
[bestSkBiased,bestSkBiasedLabel] = findBestSkPerformance(skSvmResultBiased,skRfResultBiased);

%% plotting
if ~subplotStyleBoolean
figure('Units','inches',...
    'Position',[0 0 4 6],...
    'PaperPositionMode','auto');
end
hold on
grid on

subsampleChoice = 2;
if includeNaiveBoolean
fh = boxplot([bestSk(:,subsampleChoice),bestSkNominal(:,subsampleChoice),bestSkBad(:,subsampleChoice),bestSkBiased(:,subsampleChoice),bestNaive(:,subsampleChoice)],...
    'labels',...
    boxPlotLabels,...    
    'LabelOrientation',...     
    'inline',...
    'PlotStyle',...
    'traditional',...
    'Boxstyle',...
    'filled',...
    'Colors',...
    [1*myGreen;1*myGreen;1*myGreen;0.7*myGreen;myRed]);
else
    fh = boxplot([bestSk(:,subsampleChoice),bestSkNominal(:,subsampleChoice),bestSkBad(:,subsampleChoice),bestSkBiased(:,subsampleChoice)],...
    'labels',...
    boxPlotLabels,...    
    'LabelOrientation',...     
    'inline',...
    'PlotStyle',...
    'tradiational',...
    'Boxstyle',...
    'filled',...
    'Colors',...
    [1*myGreen;1*myGreen;1*myGreen;0.7*myGreen]);
end
% Find all text boxes and set font size and interpreter (LATEX doesnt work
% with LabelOrientation inline because matlab uses text() to create xticks in boxplot)
set(findobj(gca,'Type','text'),'FontSize', myFontsize)
set(findobj(gca,'Type','text'),'Interpreter','latex')

% move all xtick labels (which are text boxes) down by a bit (because latex
% font is longer)
textObj = findobj(gca,'Type','text');
for i_text = 1:length(textObj)
    textObj(i_text).Position(2) = -5;
    textObj(i_text).HorizontalAlignment = 'right';
end


set(gca,...
    'Units','normalized',...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',myFontsize,...
    'FontName','Times')

% use latex font for yticklabels
set(gca,'TickLabelInterpreter','latex')

% set the box size ('Widths' doesn't work with 'Boxstyle' 'filled')
myHandles = get(get(gca,'children'),'children');
myHandles2 = get(myHandles,'tag');
boxInd = strcmpi(myHandles2,'box');
box = myHandles(boxInd);
set(box,'linewidth',4);
% set median and whisker size
medianInd = strcmpi(myHandles2,'Median');
medianLines = myHandles(medianInd);
set(medianLines,'linewidth',1);
whiskerInd = strcmpi(myHandles2,'Whisker');
whiskerLines = myHandles(whiskerInd);
set(whiskerLines,'linewidth',1);

% set outlier color
myHandles = get(get(gca,'children'),'children');
myHandles2 = get(myHandles,'tag');
outlierInd = strcmpi(myHandles2,'Outliers');
if includeNaiveBoolean
        numeroAlgs = 5;
    outlierColors = [myRed;0.7*myGreen;1*myGreen;1*myGreen;1*myGreen]; % reverse color order here!
else
        numeroAlgs = 4;
    outlierColors = [0.7*myGreen;1*myGreen;1*myGreen;1*myGreen]; % reverse color order here!
end


firstOutlierInd = numeroAlgs * 1 + 1;
numeroOutliersHandles = numeroAlgs * 1;
for i_algo = 1:numeroAlgs % the number of algorithms per subsample
    [myHandles((firstOutlierInd) + (i_algo-1)).MarkerEdgeColor] = deal(outlierColors(i_algo,:));
end

% y axis label
if classificationBoolean
    ylabel('Accuracy',...
        'Units','normalized',...
        'FontUnits','points',...
        'Interpreter','latex',...
        'FontWeight','normal',...
        'FontSize',myFontsize,...
        'FontName','Times')
else
    ylabel('$R^{2}$',...
        'Units','normalized',...
        'FontUnits','points',...
        'Interpreter','latex',...
        'FontWeight','normal',...
        'FontSize',myFontsize,...
        'FontName','Times')
end

%% title
    title(['Trained on ' num2str(numeroTrainSamples(subsampleChoice)) ' samples'],...
        'Units','normalized',...
        'FontUnits','points',...
        'Interpreter','latex',...
        'FontWeight','normal',...
        'FontSize',myFontsize,...
        'FontName','Times')

%% report best models
disp('-------------')
disp('Flowing noise experiment box plot:')
disp(['Best Naive algorithm: ' bestNaiveLabel]) % unused in boxplot
disp(['Best Simkern algorithm: ' bestSkLabel])
disp(['Best Bad Simkern algorithm: ' bestSkBadLabel])
disp(['Best Nominal Simkern algorithm: ' bestSkNominalLabel])
disp(['Best Biased Simkern algorithm: ' bestSkBiasedLabel])
disp('-------------')

end