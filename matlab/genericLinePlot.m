function genericLinePlot(algs,expInfo,classificationBoolean,titleName,fig2Boolean)
myFontsize = 12;
myLinewidth = 3;

[nnResult,linSvmResult,rbfSvmResult,rfResult,skSvmResult,skRfResult,skNnResult] = getAlgPerformanceFromStruct(algs);

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
myBlue = [55 126 184] ./255;
% myRed  = [228 26 28] ./255;
% myGreen = [77 175 74] ./255;
myDarkGrey = [100 100 100] ./255;
myLightGrey = [150 150 150] ./255;
myGrey = [125 125 125] ./255;

myRed  = [217 95 2] ./255;
myGreen = [27 158 119] ./255;


%% find best naive alg
[bestNaive,bestNaiveLabel] = findBestNaivePerformance(linSvmResult,rbfSvmResult,rfResult);

%% find best sk alg
[bestSk,bestSkLabel] = findBestSkPerformance(skSvmResult,skRfResult);

%% line figure radiation
if ~fig2Boolean
figure('Units','inches',...
    'Position',[0 0 4 4],...
    'PaperPositionMode','auto')
end
hold on
grid on
a = median(bestNaive);
b = median(bestSk);

xvals = numeroTrainSamples;
fitx = linspace(min(xvals),max(xvals),100);
fita = interp1(xvals,a,fitx,'pchip');
fitb = interp1(xvals,b,fitx,'pchip');

line(fitx,fita,'Color',myRed,'LineWidth',myLinewidth);
scatter(xvals,a,'o','filled','MarkerEdgeColor',myRed,'MarkerFaceColor',myRed,'LineWidth',myLinewidth);
line(fitx,fitb,'Color',myGreen,'LineWidth',myLinewidth);
scatter(xvals,b,'o','filled','MarkerEdgeColor',myGreen,'MarkerFaceColor',myGreen,'LineWidth',myLinewidth);

set(gca,...
    'Units','normalized',...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',myFontsize,...
    'FontName','Times')

xlabel('Training Samples',...
    'Units','normalized',...
    'FontUnits','points',...
    'Interpreter','latex',...
    'FontWeight','normal',...
    'FontSize',myFontsize,...
    'FontName','Times')

% use latex font for ticklabels
set(gca,'TickLabelInterpreter','latex')

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

% add model name
if strcmp(titleName,'Flowering time model')
% horzPosTitle = 100;
% vertPosTitle = 0.3;
    if fig2Boolean
        horzPosTitle = 150;
    else
        horzPosTitle = 100;
    end
vertPosTitle = 0.325;
elseif strcmp(titleName,'Boolean cell model')
horzPosTitle = 200;
vertPosTitle = 0.75;
elseif strcmp(titleName,'Network flow model (easier kernel)')
% horzPosTitle = 12;
% vertPosTitle = 0.75;
horzPosTitle = 15;
vertPosTitle = 0.75;
elseif strcmp(titleName,'Network flow model (harder kernel)')
% horzPosTitle = 12;
% vertPosTitle = 0.75;
horzPosTitle = 15;
vertPosTitle = 0.75;
else
    error('Unknown title')
end
% curYLim = ylim;
% curXLim = xlim;
% horzPosTitle = 0.4 * curXLim(2);
% vertPosTitle = curYLim(1) + 0.25*(curYLim(2) - curYLim(1));
[myX,myY] = axxy2figxy(gca,horzPosTitle,vertPosTitle);
dim = [myX myY 0.001 0.001];
annotation('textbox',dim,'String',titleName,'FitBoxToText','on', ...
             'BackgroundColor',[5/6 5/6 5/6],'Interpreter','Latex','Color',[0 0 0]);


% text(horzPosTitle,vertPosTitle,titleName,'Color','k','FontSize',12,'FontWeight','bold','Interpreter','Latex','BackgroundColor',[5/6 5/6 5/6])
%% report best models
disp('-------------')
disp([titleName ' line plot:'])
disp(['Best Naive algorithm: ' bestNaiveLabel])
disp(['Best Simkern algorithm: ' bestSkLabel])
disp('-------------')

end