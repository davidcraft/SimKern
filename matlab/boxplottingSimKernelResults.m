function boxplottingSimKernelResults(algs,expInfo,classificationBoolean,subsamplingRatios,splitRatios,outcome)
for i_algs = 1:length(algs)
    nnResult(i_algs,:) = algs(i_algs).nn.perfMetric;
    linSvmResult(i_algs,:) = algs(i_algs).linSvm.perfMetric;
    rbfSvmResult(i_algs,:) = algs(i_algs).rbfSvm.perfMetric;
    rfResult(i_algs,:) = algs(i_algs).rf.perfMetric;
    skSvmResult(i_algs,:) = algs(i_algs).skSvm.perfMetric;
    skRfResult(i_algs,:) = algs(i_algs).skRf.perfMetric;
    skNnResult(i_algs,:) = algs(i_algs).skNn.perfMetric;
end


numeroSubsamples = numel(subsamplingRatios);

% compute equal spacing between algorithm bars within a subsampling
% iteration
x = linspace(0,1,9);

nnLabels = cell(1,numeroSubsamples);
nnLabels(:) = {'nn'};
linSvmLabels = cell(1,numeroSubsamples);
linSvmLabels(:) = {'linSvm'};
rbfSvmLabels = cell(1,numeroSubsamples);
rbfSvmLabels(:) = {'rbfSvm'};
rfLabels = cell(1,numeroSubsamples);
rfLabels(:) = {'rf'};
skSvmLabels = cell(1,numeroSubsamples);
skSvmLabels(:) = {'skSvm'};
skRfLabels = cell(1,numeroSubsamples);
skRfLabels(:) = {'skRf'};
skNnLabels = cell(1,numeroSubsamples);
skNnLabels(:) = {'skNn'};


plotLabels = [nnLabels linSvmLabels rbfSvmLabels rfLabels skSvmLabels skRfLabels skNnLabels];

clf
hold on
grid on
boxplot([nnResult linSvmResult rbfSvmResult rfResult skSvmResult skRfResult skNnResult],...
    'PlotStyle','compact',...
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
    plotLabels)

xlabel('Subsampling ratio')
if classificationBoolean
    ylabel('Accuracy')
else
    ylabel('R^2')
end

for i_subsamples = 1:numeroSubsamples
    line([(i_subsamples+ 0.875) (i_subsamples+ 0.875)],[-100 100],'Color','k')
end


numeroTrainSamples = expInfo(1).numeroTrainSamples;
numeroValidationSamples = expInfo(1).numeroValidationSamples;
numeroTestSamples = expInfo(1).numeroTestSamples;

% title(['Subsampling ratios: ' num2str(subsamplingRatios,'%1g') ...
%     '. Training data:' num2str(numeroTrainSamples,'%1g') ...
%     '. Validation data = ' num2str(numeroValidationSamples,'%1g') ...
%     '. Test Data = ' num2str(numeroTestSamples,'%1g') '.'])
title({['Subsampling ratios: ' num2str(subsamplingRatios,'%1g') '.'], ...
    ['Training samples: ' num2str(numeroTrainSamples,'%1g') '.'],...
    ['Validation samples: ' num2str(numeroValidationSamples,'%1g') '.'], ...
    ['Test samples: ' num2str(numeroTestSamples,'%1g') '.']})

end