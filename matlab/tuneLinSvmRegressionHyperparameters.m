function [bestModel,bestC,bestEpsilon] = tuneLinSvmRegressionHyperparameters(trainData,validationData,cValues,epsilonValues)

[cGrid,epsilonGrid] = ndgrid(cValues,epsilonValues);
for i_c = 1:numel(cValues)
    for i_epsilon = 1:numel(epsilonValues)
        % trainSvm & store model
        inputString = ['-s 3 -t 0 -c ' num2str(cGrid(i_c,i_epsilon)) ' -p ' num2str(epsilonGrid(i_c,i_epsilon))  ' -q'];
        [svmModel{i_c,i_epsilon}] = svmtrain(trainData.classes, trainData.dummycodedFeatures, inputString);
        % testSvm on validation data
        [predictions{i_c,i_epsilon}] = svmpredict(zeros(size(validationData.classes,1),size(validationData.classes,2)),validationData.dummycodedFeatures,svmModel{i_c,i_epsilon},'-q');
        
        %compute performance metric
        [rSquared(i_c,i_epsilon)] = computeRSquared(validationData.classes,predictions{i_c,i_epsilon});
    end
end
% find model with best performance metric
[~ ,maxInd] = max(rSquared(:));

% return best hyperparameters & model
bestC = cGrid(maxInd);
bestEpsilon = epsilonGrid(maxInd);
bestModel = svmModel{maxInd};

end