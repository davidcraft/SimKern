function radiationBoxplot(algs,expInfo,classificationBoolean)

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
myRed  = [228 26 28] ./255;
myGreen = [77 175 74] ./255;
myDarkGrey = [100 100 100] ./255;
myLightGrey = [150 150 150] ./255;
myGrey = [125 125 125] ./255;

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
skSvmLabels(:) = {'sim. SVM'};
skRfLabels = cell(1,numeroSubsamples);
skRfLabels(:) = {'sim. RF'};
skNnLabels = cell(1,numeroSubsamples);
skNnLabels(:) = {'sim. NN'};

plotLabels = [linSvmLabels rbfSvmLabels rfLabels skSvmLabels skRfLabels skNnLabels];

%
figure
hold on
grid on
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
    myGreen;myGreen;myGrey])

% set the box size ('Widths' doesn't work with 'Boxstyle' 'filled')
myHandles = get(get(gca,'children'),'children');
myHandles2 = get(myHandles,'tag');
boxInd = strcmpi(myHandles2,'box');
box = myHandles(boxInd);
set(box,'linewidth',8);
% set median and whisker size
medianInd = strcmpi(myHandles2,'Median');
medianLines = myHandles(medianInd);
set(medianLines,'linewidth',2);
whiskerInd = strcmpi(myHandles2,'Whisker');
whiskerLines = myHandles(whiskerInd);
set(whiskerLines,'linewidth',2);

h = zeros(3,1);
% h(1) = scatter(NaN,NaN,'o','filled','MarkerEdgeColor',myGreyRed,'MarkerFaceColor',myGreyRed);
h(1) = scatter(NaN,NaN,'o','filled','MarkerEdgeColor',myRed,'MarkerFaceColor',myRed);
h(2) = scatter(NaN,NaN,'o','filled','MarkerEdgeColor',myGreen,'MarkerFaceColor',myGreen);
h(3) = scatter(NaN,NaN,'o','filled','MarkerEdgeColor',myGrey,'MarkerFaceColor',myGrey);
legend(h,'No prior knowledge',...
    'With prior knowledge','NN with prior knowledge',...
    'Location','southeast');

curYLim = ylim;
vertPos = 1.01 * curYLim(2);
text(1.0,vertPos,['Trained on ' num2str(numeroTrainSamples(1)) ' samples'])
text(2.0,vertPos,['Trained on ' num2str(numeroTrainSamples(2)) ' samples'])
text(3.0,vertPos,['Trained on ' num2str(numeroTrainSamples(3)) ' samples'])
text(4.0,vertPos,['Trained on ' num2str(numeroTrainSamples(4)) ' samples'])
text(5.0,vertPos,['Trained on ' num2str(numeroTrainSamples(5)) ' samples'])

% xlabel('Subsampling ratio')
if classificationBoolean
    ylabel('Accuracy')
else
    ylabel('R^2')
end

for i_subsamples = 1:numeroSubsamples
    line([(i_subsamples + 0.875) (i_subsamples + 0.8395)],[-100 100],'Color','k')
end

end