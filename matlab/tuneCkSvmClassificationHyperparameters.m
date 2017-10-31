function [bestModel,bestC,bestAccuracy] = tuneCkSvmClassificationHyperparameters(trainData,validationData,cValues)
numeroTrainSamples = numel(trainData.outcome);
numeroValidationSamples = numel(validationData.outcome);
for i_c = 1:numel(cValues)
    % trainSvm & store model
    
    inputString = ['-s 0 -t 4 -c ' num2str(cValues(i_c)) ' -q'];
    [customKernelSvmModel{i_c}] = svmtrain(trainData.outcome, [(1:numeroTrainSamples)' trainData.sm], inputString);
    % testSvm on validation data
    [predictions{i_c}] = svmpredict(zeros(size(validationData.outcome,1),size(validationData.outcome,2)),[(1:numeroValidationSamples)' validationData.sm],customKernelSvmModel{i_c},'-q');
    
    %compute performance metric
%     [rSquared(i_c)] = computeRSquared(validationData.outcome,predictions{i_c})
    [accuracy(i_c)] = computeAccuracy(validationData.outcome,predictions{i_c});
end
% find model with best performance metric
[bestAccuracy,maxInd] = max(accuracy);
% return best C & model
bestC = cValues(maxInd);
bestModel = customKernelSvmModel{maxInd};

end