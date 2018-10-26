function twoKernelLinePlot(algs,algsBad,expInfo,classificationBoolean,titleName,subplotStyleBoolean,goodKernelLabelPos,badKernelLabelPos,titlePos)
myFontsize = 12;
myLinewidth = 3;

[nnResult,linSvmResult,rbfSvmResult,rfResult,skSvmResult,skRfResult,skNnResult] = getAlgPerformanceFromStruct(algs);

[nnResultBad,linSvmResultBad,rbfSvmResultBad,rfResultBad,skSvmResultBad,skRfResultBad,skNnResultBad] = getAlgPerformanceFromStruct(algsBad);

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


%% find best sk alg bad
[bestSkBad,bestSkBadLabel] = findBestSkPerformance(skSvmResultBad,skRfResultBad);

%% line figure radiation
if ~subplotStyleBoolean
figure('Units','inches',...
    'Position',[0 0 4 4],...
    'PaperPositionMode','auto')
end
hold on
grid on

a = median(bestNaive);
b = median(bestSk);
c = median(bestSkBad);

xvals = numeroTrainSamples;
fitx = linspace(min(xvals),max(xvals),100);
fita = interp1(xvals,a,fitx,'pchip');
fitb = interp1(xvals,b,fitx,'pchip');
fitc = interp1(xvals,c,fitx,'pchip');

line(fitx,fita,'Color',myRed,'LineWidth',myLinewidth);
scatter(xvals,a,'filled','MarkerEdgeColor',myRed,'MarkerFaceColor',myRed,'LineWidth',myLinewidth);
line(fitx,fitb,'Color',myGreen,'LineWidth',myLinewidth);
scatter(xvals,b,'MarkerEdgeColor',myGreen,'MarkerFaceColor',myGreen,'LineWidth',myLinewidth);
line(fitx,fitc,'Color',myGreen,'LineWidth',myLinewidth,'LineStyle','--');
scatter(xvals,c,'MarkerEdgeColor',myGreen,'MarkerFaceColor',myGreen,'LineWidth',myLinewidth);

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

text(badKernelLabelPos(1),badKernelLabelPos(2),{'\textbf{Lower}' '\textbf{quality}' '\textbf{kernel}'},'Color',myGreen,...
    'FontUnits','points',...
    'Interpreter','latex',...
    'FontWeight','normal',...
    'FontSize',2/3 * myFontsize,...
    'FontName','Times')

text(goodKernelLabelPos(1),goodKernelLabelPos(2),{'\textbf{Higher}' '\textbf{quality}' '\textbf{kernel}'},'Color',myGreen,...
    'FontUnits','points',...
    'Interpreter','latex',...
    'FontWeight','normal',...
    'FontSize',2/3 * myFontsize,...
    'FontName','Times')

%% add model name
[myX,myY] = axxy2figxy(gca,titlePos(1),titlePos(2));    
dim = [myX myY 0.001 0.001];
annotation('textbox',dim,'String',titleName,'FitBoxToText','on', ...
             'BackgroundColor',[5/6 5/6 5/6],'Interpreter','Latex','Color',[0 0 0]);

%% report best models
disp('-------------')
disp('Two kernel model line plot:')
disp(['Best Naive algorithm: ' bestNaiveLabel])
disp(['Best Simkern algorithm: ' bestSkLabel])
disp(['Best Bad Simkern algorithm: ' bestSkBadLabel])
disp('-------------')
end