function [bestModel,bestC,bestEpsilon] = tuneCkSvmRegressionHyperparameters(trainData,validationData,cValues,epsilonValues)
numeroTrainSamples = numel(trainData.classes);
numeroValidationSamples = numel(validationData.classes);
[cGrid,epsilonGrid] = ndgrid(cValues,epsilonValues);
for i_c = 1:numel(cValues)
    for i_epsilon = 1:numel(epsilonValues)
        % trainSvm & store model
        
        inputString = ['-s 0 -t 4 -c ' num2str(cGrid(i_c,i_epsilon)) ' -p ' num2str(epsilonGrid(i_c,i_epsilon)) ' -q'];
        [customKernelSvmModel{i_c,i_epsilon}] = svmtrain(trainData.classes, [(1:numeroTrainSamples)' trainData.sm], inputString);
        % testSvm on validation data
        [predictions{i_c,i_epsilon}] = svmpredict(zeros(size(validationData.classes,1),size(validationData.classes,2)),[(1:numeroValidationSamples)' validationData.sm],customKernelSvmModel{i_c,i_epsilon},'-q');
        
        %compute performance metric
        [rSquared(i_c,i_epsilon)] = computeRSquared(validationData.classes,predictions{i_c,i_epsilon});
    end
end
% find model with best performance metric
[~ ,maxInd] = max(rSquared(:));
% return best C & model
bestC = cGrid(maxInd);
bestEpsilon = epsilonGrid(maxInd);
bestModel = customKernelSvmModel{maxInd};

end