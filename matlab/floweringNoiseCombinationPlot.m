function floweringNoiseCombinationPlot(algs,algsBad,algsNominal,algsBiased,expInfo,classificationBoolean,titleName,subplotStyleBoolean,linePlotLabels,boxPlotLabels)
myFontsize = 12;
myLinewidth = 3;

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


%% find best naive alg
[bestNaive,bestNaiveLabel] = findBestNaivePerformance(linSvmResult,rbfSvmResult,rfResult);
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
    fh = figure('Units','inches',...
        'Position',[0 0 4 4],...
        'PaperPositionMode','auto');
end
hold on
grid on

a = median(bestNaive);
b = median(bestSk);
c = median(bestSkBad);
d = median(bestSkNominal);
e = median(bestSkBiased);

xvals = numeroTrainSamples;
fitx = linspace(min(xvals),max(xvals),100);
fita = interp1(xvals,a,fitx,'pchip'); % naive
fitb = interp1(xvals,b,fitx,'pchip'); % better
fitc = interp1(xvals,c,fitx,'pchip'); % bad
fitd = interp1(xvals,d,fitx,'pchip'); % nominal
fite = interp1(xvals,e,fitx,'pchip'); % biased

fhNaive = line(fitx,fita,'Color',myRed,'LineWidth',myLinewidth);
scatter(xvals,a,'filled','MarkerEdgeColor',myRed,'MarkerFaceColor',myRed,'LineWidth',myLinewidth);
fhBetter = line(fitx,fitb,'Color',myGreen*1,'LineWidth',myLinewidth);
scatter(xvals,b,'MarkerEdgeColor',myGreen*1,'MarkerFaceColor',myGreen*1,'LineWidth',myLinewidth);
fhBad = line(fitx,fitc,'Color',myGreen*1,'LineWidth',myLinewidth,'LineStyle','--');
scatter(xvals,c,'MarkerEdgeColor',myGreen*1,'MarkerFaceColor',myGreen*1,'LineWidth',myLinewidth);
fhNominal = line(fitx,fitd,'Color',myGreen*1,'LineWidth',myLinewidth,'LineStyle','-.');
scatter(xvals,d,'MarkerEdgeColor',myGreen*1,'MarkerFaceColor',myGreen*1,'LineWidth',myLinewidth);
fhBiased = line(fitx,fite,'Color',myGreen*0.7,'LineWidth',myLinewidth,'LineStyle',':');
scatter(xvals,e,'MarkerEdgeColor',myGreen*0.7,'MarkerFaceColor',myGreen*0.7,'LineWidth',myLinewidth);

set(gca,...
    'Units','normalized',...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',myFontsize,...
    'FontName','Times')

% use latex font for ticklabels
set(gca,'TickLabelInterpreter','latex')

xlabel('Training Samples',...
    'Units','normalized',...
    'FontUnits','points',...
    'Interpreter','latex',...
    'FontWeight','normal',...
    'FontSize',myFontsize,...
    'FontName','Times')

if classificationBoolean
    ylabel('Accuracy',...
        'Units','normalized',...
        'FontUnits','points',...
        'Interpreter','latex',...
        'FontWeight','normal',...
        'FontSize',myFontsize,...
        'FontName','Times')
else
    ylabel('$R^2$',...
        'Units','normalized',...
        'FontUnits','points',...
        'Interpreter','latex',...
        'FontWeight','normal',...
        'FontSize',myFontsize,...
        'FontName','Times')
end

%% add model name
if subplotStyleBoolean
    [myX,myY] = axxy2figxy(gca,300,0.6);
else
    [myX,myY] = axxy2figxy(gca,204,0.4);
end
dim = [myX myY 0.001 0.001];
annotation('textbox',dim,'String',titleName,'FitBoxToText','on', ...
    'BackgroundColor',[5/6 5/6 5/6],'Interpreter','Latex','Color',[0 0 0]);

%% adjust axes 
axis([0 160 0.2 1]) % axis dimensions of main figure
set(fh,'Position',[0 0 18 8]); % adjust figure size
%% legend
legend([fhBetter fhNominal fhBad  fhBiased  fhNaive],linePlotLabels,'location','southeast')

%% add box subplot (manually aligned box with legend and just below the graphs)
axesPosition = [92.5 0.3125 30 0.55]; % absolute coordinates of axes
axesPositionRelative = axxy2figxy(axesPosition); % turn abs. into rel. coordinates for axes() function
rectanglePosition = axesPosition; % adjust rectangle position to make a nice frame
rectanglePosition(1) = axesPosition(1) - 5.5; % manual adjustments to align boxes and make a pretty frame
rectanglePosition(2) = axesPosition(2) - 0.10;
rectanglePosition(3) = axesPosition(3) + 11;
rectanglePosition(4) = axesPosition(4) + 0.15;

rectangle('Position',rectanglePosition,'FaceColor','w') % draw rectangle box around boxplot
axes('position', axesPositionRelative) % generate axes for box subplot inside rectangle
boxSubplot(bestNaive,bestSk,bestSkNominal,bestSkBad,bestSkBiased,myGreen,myRed,myFontsize,classificationBoolean,numeroTrainSamples,boxPlotLabels) % draw box subplot (local function, see below)

%% report best models
disp('-------------')
disp('Flowering noise experiment combined line/box plot:')
disp(['Best Naive algorithm: ' bestNaiveLabel])
disp(['Best Simkern algorithm: ' bestSkLabel])
disp(['Best Bad Simkern algorithm: ' bestSkBadLabel])
disp(['Best Nominal Simkern algorithm: ' bestSkNominalLabel])
disp(['Best Biased Simkern algorithm: ' bestSkBiasedLabel])
disp('-------------')
end

%% local functions
function boxSubplot(bestNaive,bestSk,bestSkNominal,bestSkBad,bestSkBiased,myGreen,myRed,myFontsize,classificationBoolean,numeroTrainSamples,boxPlotLabels)
hold on
grid on

subsampleChoice = 2; % choose which training data subsample you want to plot
fh = boxplot([bestSk(:,subsampleChoice),bestSkNominal(:,subsampleChoice),bestSkBad(:,subsampleChoice),bestSkBiased(:,subsampleChoice),bestNaive(:,subsampleChoice)],...
    'labels',...
    boxPlotLabels,...    
    'LabelOrientation',...     
    'inline',...
    'PlotStyle',...
    'compact',...
    'Boxstyle',...
    'filled',...
    'Colors',...
    [1*myGreen;1*myGreen;1*myGreen;0.7*myGreen;myRed]);

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

%% figure(?) settings
set(gca,...
    'Units','normalized',...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',myFontsize,...
    'FontName','Times')

% use latex font for yticklabels
set(gca,'TickLabelInterpreter','latex')

%% set the box size ('Widths' doesn't work with 'Boxstyle' 'filled')
myHandles = get(get(gca,'children'),'children');
myHandles2 = get(myHandles,'tag');
boxInd = strcmpi(myHandles2,'box');
box = myHandles(boxInd);
set(box,'linewidth',4);
%% set median and whisker size
medianInd = strcmpi(myHandles2,'Median');
medianLines = myHandles(medianInd);
set(medianLines,'linewidth',1);
whiskerInd = strcmpi(myHandles2,'Whisker');
whiskerLines = myHandles(whiskerInd);
set(whiskerLines,'linewidth',1);

%% set outlier color
myHandles = get(get(gca,'children'),'children');
myHandles2 = get(myHandles,'tag');
outlierInd = strcmpi(myHandles2,'Outliers');

    numeroAlgs = 5;
    outlierColors = [myRed;0.7*myGreen;1*myGreen;1*myGreen;1*myGreen]; % revert color order here!

firstOutlierInd = numeroAlgs * 1 + 1;
numeroOutliersHandles = numeroAlgs * 1;
for i_algo = 1:numeroAlgs % the number of algorithms per subsample
    [myHandles((firstOutlierInd) + (i_algo-1)).MarkerEdgeColor] = deal(outlierColors(i_algo,:));
end

%% y axis label
if classificationBoolean % if classification: accuracy
    ylabel('Accuracy',...
        'Units','normalized',...
        'FontUnits','points',...
        'Interpreter','latex',...
        'FontWeight','normal',...
        'FontSize',myFontsize,...
        'FontName','Times')
else % if not classification (i.e. regression): R2
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
    
end

