function genericBoxplot(algs,expInfo,classificationBoolean,titleName,fig2Boolean)
withNn = 1;

myFontsize = 12;
for i_algs = 1:length(algs)
    nnResult(i_algs,:) = algs(i_algs).nn.perfMetric;
    linSvmResult(i_algs,:) = algs(i_algs).linSvm.perfMetric;
    rbfSvmResult(i_algs,:) = algs(i_algs).rbfSvm.perfMetric;
    rfResult(i_algs,:) = algs(i_algs).rf.perfMetric;
    skSvmResult(i_algs,:) = algs(i_algs).skSvm.perfMetric;
    skRfResult(i_algs,:) = algs(i_algs).skRf.perfMetric;
    skNnResult(i_algs,:) = algs(i_algs).skNn.perfMetric;
end

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
myBlue = [55 126 184] ./255;
% myRed  = [228 26 28] ./255;
% myGreen = [77 175 74] ./255;
myDarkGrey = [50 50 50] ./255;
myLightGrey = [150 150 150] ./255;
myGrey = [125 125 125] ./255;

% % original color
myRed  = [217 95 2] ./255;
myGreen = [27 158 119] ./255;

% dlab color (color picked from webpage)
% myRed  = [242 151 44] ./255;
% myGreen = [27 70 132] ./255;

%% boxplot figure radiation
% compute equal spacing between algorithm bars within a subsampling
% iteration
x = linspace(0,1,8);

% create labels for algorithms in boxplot
nnLabels = cell(1,numeroSubsamples);
nnLabels(:) = {'NN'};
linSvmLabels = cell(1,numeroSubsamples);
linSvmLabels(:) = {'lin. SVM'};
rbfSvmLabels = cell(1,numeroSubsamples);
rbfSvmLabels(:) = {'RBF SVM'};
rfLabels = cell(1,numeroSubsamples);
rfLabels(:) = {'RF'};
skSvmLabels = cell(1,numeroSubsamples);
skSvmLabels(:) = {'simkern SVM'};
skRfLabels = cell(1,numeroSubsamples);
skRfLabels(:) = {'simkern RF'};
skNnLabels = cell(1,numeroSubsamples);
skNnLabels(:) = {'simkern NN'};

if withNn == 1
    plotLabels = [nnLabels linSvmLabels rbfSvmLabels rfLabels skSvmLabels skRfLabels skNnLabels];
else
    plotLabels = [linSvmLabels rbfSvmLabels rfLabels skSvmLabels skRfLabels skNnLabels];
end
if ~fig2Boolean
    figure('Units','inches',...
        'Position',[0 0 8 4],...
        'PaperPositionMode','auto')
end
hold on
grid on
if withNn == 1
    fh = boxplot([nnResult linSvmResult rbfSvmResult rfResult skSvmResult skRfResult skNnResult],...
        'FactorSeparator',1,...
        'position',...
        [1:numeroSubsamples ...
        x(2)+(1:numeroSubsamples)...
        x(3)+(1:numeroSubsamples) ...
        x(4)+(1:numeroSubsamples) ...
        x(5)+(1:numeroSubsamples),...
        x(6)+(1:numeroSubsamples),...
        x(7)+(1:numeroSubsamples)],...
        'labels',...
        plotLabels,...
        'LabelOrientation',...
        'inline',...
        'BoxStyle',...
        'filled',...
        'Colors',...
        [myDarkGrey;myRed;myRed;myRed;...
        myGreen;myGreen;myGrey]);
else
    % set(gca,'FontSize',20)
    fh = boxplot([linSvmResult rbfSvmResult rfResult skSvmResult skRfResult skNnResult],...
        'FactorSeparator',1,...
        'position',...
        [1:numeroSubsamples ...
        x(2)+(1:numeroSubsamples)...
        x(3)+(1:numeroSubsamples) ...
        x(4)+(1:numeroSubsamples) ...
        x(5)+(1:numeroSubsamples),...
        x(6)+(1:numeroSubsamples)],...
        'labels',...
        plotLabels,...
        'LabelOrientation',...
        'inline',...
        'BoxStyle',...
        'filled',...
        'Colors',...
        [myRed;myRed;myRed;...
        myGreen;myGreen;myGrey]);
end
% Find all text boxes and set font size and interpreter (LATEX doesnt work
% with LabelOrientation inline because matlab uses text() to create xticks in boxplot)
set(findobj(gca,'Type','text'),'FontSize',2/3 * myFontsize)
set(findobj(gca,'Type','text'),'Interpreter','latex')

% move all xtick labels (which are text boxes) down by a bit (because latex
% font is longer)
textObj = findobj(gca,'Type','text');
for i_text = 1:length(textObj)
    textObj(i_text).Position(2) = -5;%textObj(i_text).Position(2) + 40;
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

if withNn == 1
    numeroAlgs = 7;
    outlierColors = [myGrey;myGreen;myGreen;myRed;myRed;myRed;myDarkGrey];
else
    numeroAlgs = 6;
    outlierColors = [myGrey;myGreen;myGreen;myRed;myRed;myRed];
end
firstOutlierInd = numeroAlgs * numeroSubsamples + 1;
numeroOutliersHandles = numeroAlgs * numeroSubsamples;
for i_algo = 1:numeroAlgs % the number of algorithms per subsample
    [myHandles((firstOutlierInd) + [(i_algo- 1):numeroAlgs:(numeroOutliersHandles - 1)]).MarkerEdgeColor] = deal(outlierColors(i_algo,:));
end

if withNn == 1
    subsamplingMidpoint = x(4);
else
    subsamplingMidpoint = (x(3)+x(4))/2;
end



curYLim = ylim;

% make invisible title to get title height chosen by Matlab.
% manually setting the height leads to inconsistent results for different datasets
title('')
titleHandle = get(gca,'title');
vertPos = 0.005 + titleHandle.Position(2);
% vertPos = 1.015 * curYLim(2);
% vertPos = 0.015 + curYLim(2);
text(subsamplingMidpoint+1,vertPos,['Trained on ' num2str(numeroTrainSamples(1)) ' samples'],...
    'FontUnits','points',...
    'Interpreter','latex',...
    'FontWeight','normal',...
    'FontSize',2/3 * myFontsize,...
    'FontName','Times',...
    'HorizontalAlignment','center')
text(subsamplingMidpoint+2,vertPos,[num2str(numeroTrainSamples(2)) ' samples'],...
    'FontUnits','points',...
    'Interpreter','latex',...
    'FontWeight','normal',...
    'FontSize',2/3 * myFontsize,...
    'FontName','Times',...
    'HorizontalAlignment','center')
text(subsamplingMidpoint+3,vertPos,[num2str(numeroTrainSamples(3)) ' samples'],...
    'FontUnits','points',...
    'Interpreter','latex',...
    'FontWeight','normal',...
    'FontSize',2/3 * myFontsize,...
    'FontName','Times',....
    'HorizontalAlignment','center')
text(subsamplingMidpoint+4,vertPos,[num2str(numeroTrainSamples(4)) ' samples'],...
    'FontUnits','points',...
    'Interpreter','latex',...
    'FontWeight','normal',...
    'FontSize',2/3 * myFontsize,...
    'FontName','Times',...
    'HorizontalAlignment','center')
text(subsamplingMidpoint+5,vertPos,[num2str(numeroTrainSamples(5)) ' samples'],...
    'FontUnits','points',...
    'Interpreter','latex',...
    'FontWeight','normal',...
    'FontSize',2/3 * myFontsize,...
    'FontName','Times',...
    'HorizontalAlignment','center')

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

curYLim = ylim;
for i_subsamples = 1:(numeroSubsamples - 1)
    %     line([(i_subsamples + 0.8395) (i_subsamples + 0.8395)],[curYLim(1) curYLim(2)],'Color','k')
    % finds the exact middle between the last box of one subsample group
    % and the first box of the next subsample gro up and
    % plots a black line between those
    if withNn == 1
        midBetweenBoxes = 0.5 * ((i_subsamples + x(7) + (i_subsamples + 1) ));
    else
        midBetweenBoxes = 0.5 * ((i_subsamples + x(6) + (i_subsamples + 1) ));
    end
    line([midBetweenBoxes midBetweenBoxes],[curYLim(1) curYLim(2)],'Color','k')
end
%% add model name
curYLim = ylim;
if strcmp(titleName,'Radiation model')
    % horzPosTitle = 1;
    % vertPosTitle = 0.85;
    horzPosTitle = 1;
    vertPosTitle = 0.875;
elseif strcmp(titleName,'Flowering time model')
    % horzPosTitle = 1;
    % vertPosTitle = 0.9;
    horzPosTitle = 4.5;
    vertPosTitle = 0;
elseif strcmp(titleName,'Boolean cell model')
    horzPosTitle = 4.70;
    vertPosTitle = 0.65;
elseif strcmp(titleName,'Network flow model (easier kernel)')
    horzPosTitle = 3.75;
    vertPosTitle = 0.51;
elseif strcmp(titleName,'Network flow model (harder kernel)')
    % horzPosTitle = 3.75;
    % vertPosTitle = 0.5;
    horzPosTitle = 3.75;
    vertPosTitle = 0.51;
else
    error('Unknown title')
end

[myX,myY] = axxy2figxy(gca,horzPosTitle,vertPosTitle);
dim = [myX myY 0.001 0.001];
annotation('textbox',dim,'String',titleName,'FitBoxToText','on', ...
    'BackgroundColor',[5/6 5/6 5/6],'Interpreter','Latex','Color',[0 0 0]);
% text(horzPosTitle,vertPosTitle,titleName,'Color','k','FontSize',12,'FontWeight','bold','Interpreter','Latex','BackgroundColor',[5/6 5/6 5/6])
%% add legend if it is figure2
if fig2Boolean
%     hold on
    h(1) = scatter(NaN,NaN,'o','filled','MarkerEdgeColor',myDarkGrey,'MarkerFaceColor',myDarkGrey);
    h(2) = scatter(NaN,NaN,'o','filled','MarkerEdgeColor',myRed,'MarkerFaceColor',myRed);
    h(3) = scatter(NaN,NaN,'o','filled','MarkerEdgeColor',myGreen,'MarkerFaceColor',myGreen);
    h(4) = scatter(NaN,NaN,'o','filled','MarkerEdgeColor',myGrey,'MarkerFaceColor',myGrey);
    % h(1) = scatter(1,1,'o','filled','MarkerEdgeColor',myRed,'MarkerFaceColor',myRed);
    % h(2) = scatter(2,2,'o','filled','MarkerEdgeColor',myGreen,'MarkerFaceColor',myGreen);
    % h(3) = scatter(3,3,'o','filled','MarkerEdgeColor',myGrey,'MarkerFaceColor',myGrey);
%     axis off
    myLegend = legend(h,'NN without prior knowledge','No prior knowledge','With prior knowledge','NN with prior knowledge','Location','southwest');
    myLegend = legend(h,'Standard NN','Standard ML','SimKern ML','SimKern NN','Location','southeast');
    set(myLegend,'Interpreter','latex');
end

end