function boxplottingSimKernelResults(nn,rbfSvm,rf,skSvm,linSvm,skRf,skNn,classificationBoolean,subsamplingRatios,splitRatios,outcome)
nnResult = cat(1,nn(:).perfMetric); 
rbfResult = cat(1,rbfSvm(:).perfMetric);
rfResult = cat(1,rf(:).perfMetric);
skSvmResult = cat(1,skSvm(:).perfMetric);
% linResult = cat(1,nn(:).perfMetric); %%%%%%%%%%%%
linResult = cat(1,linSvm(:).perfMetric); %%%%%%%%%%%%
skRfResult = cat(1,skRf(:).perfMetric);
skNnResult = cat(1,skNn(:).perfMetric);

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
boxplot([nnResult linResult rbfResult rfResult skSvmResult skRfResult skNnResult],...
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


numeroTrainSamples = length(outcome) * splitRatios(1) * subsamplingRatios;
numeroValidationSamples = length(outcome) * splitRatios(2);
numeroTestSamples = length(outcome) * splitRatios(3);

% title(['Subsampling ratios: ' num2str(subsamplingRatios,'%1g') ...
%     '. Training data:' num2str(numeroTrainSamples,'%1g') ...
%     '. Validation data = ' num2str(numeroValidationSamples,'%1g') ...
%     '. Test Data = ' num2str(numeroTestSamples,'%1g') '.'])
title({['Subsampling ratios: ' num2str(subsamplingRatios,'%1g') '.'], ...
    ['Training samples: ' num2str(numeroTrainSamples,'%1g') '.'],...
    ['Validation samples: ' num2str(numeroValidationSamples,'%1g') '.'], ...
    ['Test samples: ' num2str(numeroTestSamples,'%1g') '.']})

end