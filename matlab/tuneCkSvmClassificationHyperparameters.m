function [bestModel,bestC] = tuneCkSvmClassificationHyperparameters(trainData,validationData,cValues)
numeroTrainSamples = numel(trainData.classes);
numeroValidationSamples = numel(validationData.classes);
for i_c = 1:numel(cValues)
    % trainSvm & store model
    
    inputString = ['-s 0 -t 4 -c ' num2str(cValues(i_c)) ' -q'];
    [customKernelSvmModel{i_c}] = svmtrain(trainData.classes, [(1:numeroTrainSamples)' trainData.sm], inputString);
    % testSvm on validation data
    [predictions{i_c}] = svmpredict(zeros(size(validationData.classes,1),size(validationData.classes,2)),[(1:numeroValidationSamples)' validationData.sm],customKernelSvmModel{i_c},'-q');
    
    %compute performance metric
%     [rSquared(i_c)] = computeRSquared(validationData.classes,predictions{i_c})
    [accuracy(i_c)] = computeAccuracy(validationData.classes,predictions{i_c});
end
% find model with best performance metric
[~ ,maxInd] = max(accuracy);
% return best C & model
bestC = cValues(maxInd);
bestModel = customKernelSvmModel{maxInd};

end