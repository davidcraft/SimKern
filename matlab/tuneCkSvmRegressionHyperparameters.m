function [bestModel,bestC,bestEpsilon,bestRSquared,trainPredictions,validationPredictions] = tuneCkSvmRegressionHyperparameters(trainData,validationData,cValues,epsilonValues)
numeroTrainSamples = numel(trainData.outcome);
numeroValidationSamples = numel(validationData.outcome);
[cGrid,epsilonGrid] = ndgrid(cValues,epsilonValues);
for i_c = 1:numel(cValues)
    for i_epsilon = 1:numel(epsilonValues)
        % trainSvm & store model
        
        inputString = ['-s 3 -t 4 -c ' num2str(cGrid(i_c,i_epsilon)) ' -p ' num2str(epsilonGrid(i_c,i_epsilon)) ' -q'];
        [customKernelSvmModel{i_c,i_epsilon}] = svmtrain(trainData.outcome, [(1:numeroTrainSamples)' trainData.sm], inputString);
        % testSvm on validation data
        [predictions{i_c,i_epsilon}] = svmpredict(zeros(size(validationData.outcome,1),size(validationData.outcome,2)),[(1:numeroValidationSamples)' validationData.sm],customKernelSvmModel{i_c,i_epsilon},'-q');
        
        %compute performance metric
        [rSquared(i_c,i_epsilon)] = computeRSquared(validationData.outcome,predictions{i_c,i_epsilon});
    end
end
% find model with best performance metric
[bestRSquared,maxInd] = max(rSquared(:));
% return best C & model
bestC = cGrid(maxInd);
bestEpsilon = epsilonGrid(maxInd);
bestModel = customKernelSvmModel{maxInd};
validationPredictions = predictions{maxInd};

% compute train predictions for selected model
[trainPredictions] = svmpredict(zeros(size(trainData.outcome,1),size(trainData.outcome,2)),[(1:numeroTrainSamples)' trainData.sm],bestModel,'-q');
end