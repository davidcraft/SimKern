function radiationLinePlot(algs,algsBad,expInfo,classificationBoolean)
for i_algs = 1:length(algs)
    nnResult(i_algs,:) = algs(i_algs).nn.perfMetric;
    linSvmResult(i_algs,:) = algs(i_algs).linSvm.perfMetric;
    rbfSvmResult(i_algs,:) = algs(i_algs).rbfSvm.perfMetric;
    rfResult(i_algs,:) = algs(i_algs).rf.perfMetric;
    skSvmResult(i_algs,:) = algs(i_algs).skSvm.perfMetric;
    skRfResult(i_algs,:) = algs(i_algs).skRf.perfMetric;
    skNnResult(i_algs,:) = algs(i_algs).skNn.perfMetric;
end

for i_algs = 1:length(algsBad)
    nnResultBad(i_algs,:) = algsBad(i_algs).nn.perfMetric;
    linSvmResultBad(i_algs,:) = algsBad(i_algs).linSvm.perfMetric;
    rbfSvmResultBad(i_algs,:) = algsBad(i_algs).rbfSvm.perfMetric;
    rfResultBad(i_algs,:) = algsBad(i_algs).rf.perfMetric;
    skSvmResultBad(i_algs,:) = algsBad(i_algs).skSvm.perfMetric;
    skRfResultBad(i_algs,:) = algsBad(i_algs).skRf.perfMetric;
    skNnResultBad(i_algs,:) = algsBad(i_algs).skNn.perfMetric;
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
myBlue = [55 126 184] ./255;
myRed  = [228 26 28] ./255;
myGreen = [77 175 74] ./255;
myDarkGrey = [100 100 100] ./255;
myLightGrey = [150 150 150] ./255;
myGrey = [125 125 125] ./255;


%% find best naive alg
[maxVal,maxInd] = max([median(linSvmResult);median(rbfSvmResult);median(rfResult)]);

if mode(maxInd) == 1
    bestNaive = linSvmResult;
elseif mode(maxInd) == 2
    bestNaive = rbfSvmResult;
elseif mode(maxInd) == 3
    bestNaive = rfResult;
else
     error('Oops.')
end

%% find best sk alg
if (mean(median(skSvmResult) > median(skRfResult)) > 0.5)
    bestSk = skSvmResult;
else
    bestSk = skRfResult;
end


%% find best sk alg bad
if (mean(median(skSvmResultBad) > median(skRfResultBad)) > 0.5)
    bestSkBad = skSvmResultBad;
else
    bestSkBad = skRfResultBad;
end

%% line figure radiation
figure
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

line(fitx,fita,'Color',myRed,'LineWidth',2);
scatter(xvals,a,'filled','MarkerEdgeColor',myRed,'MarkerFaceColor',myRed,'LineWidth',2);
line(fitx,fitb,'Color',myGreen,'LineWidth',2);
scatter(xvals,b,'MarkerEdgeColor',myGreen,'MarkerFaceColor',myGreen,'LineWidth',2);
line(fitx,fitc,'Color',myGreen,'LineWidth',2,'LineStyle','--');
scatter(xvals,c,'MarkerEdgeColor',myGreen,'MarkerFaceColor',myGreen,'LineWidth',2);

xlabel('Training Samples')
if classificationBoolean
    ylabel('Accuracy')
else
    ylabel('R^2')
end

text(50,0.77,{'Higher' 'quality' 'kernel'},'Color',myGreen,'FontSize',12,'FontWeight','bold')
text(250,0.62,{'Lower' 'quality' 'kernel'},'Color',myGreen,'FontSize',12,'FontWeight','bold')
end