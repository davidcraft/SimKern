function [bestModel,bestC,bestGamma,bestEpsilon,bestRSquared,trainPredictions,validationPredictions] = tuneRbfSvmRegressionHyperparameters(trainData,validationData,cValues,gammaValues,epsilonValues)

[cGrid,gammaGrid,epsilonGrid] = ndgrid(cValues,gammaValues,epsilonValues);
for i_c = 1:numel(cValues)
    for i_gamma = 1:numel(gammaValues)
        for i_epsilon = 1:numel(epsilonValues)
            
            % trainSvm & store model
            inputString = ['-s 3 -t 2 -c ' num2str(cGrid(i_c,i_gamma,i_epsilon)) ' -g ' num2str(gammaGrid(i_c,i_gamma,i_epsilon)) ' -p ' num2str(epsilonGrid(i_c,i_gamma,i_epsilon)) ' -q'];
            [svmModel{i_c,i_gamma,i_epsilon}] = svmtrain(trainData.outcome, trainData.dummycodedFeatures, inputString);
            % testSvm on validation data
            [predictions{i_c,i_gamma,i_epsilon}] = svmpredict(zeros(size(validationData.outcome,1),size(validationData.outcome,2)),validationData.dummycodedFeatures,svmModel{i_c,i_gamma,i_epsilon},'-q');
            
            %compute performance metric
            [rSquared(i_c,i_gamma,i_epsilon)] = computeRSquared(validationData.outcome,predictions{i_c,i_gamma,i_epsilon});
        end
    end
end
% find model with best performance metric
[bestRSquared,maxInd] = max(rSquared(:));
% return best C & model
bestC = cGrid(maxInd);
bestGamma = gammaGrid(maxInd);
bestEpsilon = epsilonGrid(maxInd);
bestModel = svmModel{maxInd};
validationPredictions = predictions{maxInd};

% compute train predictions for selected model
[trainPredictions] = svmpredict(zeros(size(trainData.outcome,1),size(trainData.outcome,2)),trainData.dummycodedFeatures,bestModel,'-q');
end