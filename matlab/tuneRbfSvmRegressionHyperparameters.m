function [bestModel,bestC,bestGamma,bestEpsilon] = tuneRbfSvmRegressionHyperparameters(trainData,validationData,cValues,gammaValues,epsilonValues)

[cGrid,gammaGrid,epsilonGrid] = ndgrid(cValues,gammaValues,epsilonValues);
for i_c = 1:numel(cValues)
    for i_gamma = 1:numel(gammaValues)
        for i_epsilon = 1:numel(epsilonValues)
            
            % trainSvm & store model
            inputString = ['-s 0 -t 2 -c ' num2str(cGrid(i_c,i_gamma)) ' -g ' num2str(gammaGrid(i_c,i_gamma)) ' -p ' num2str(epsilonGrid(i_c,i_gamma)) ' -q'];
            [svmModel{i_c,i_gamma,i_epsilon}] = svmtrain(trainData.classes, trainData.dummycodedFeatures, inputString);
            % testSvm on validation data
            [predictions{i_c,i_gamma,i_epsilon}] = svmpredict(zeros(size(validationData.classes,1),size(validationData.classes,2)),validationData.dummycodedFeatures,svmModel{i_c,i_gamma,i_epsilon},'-q');
            
            %compute performance metric
            [rSquared(i_c,i_gamma,i_epsilon)] = computeRSquared(validationData.classes,predictions{i_c,i_gamma,i_epsilon});
        end
    end
end
% find model with best performance metric
[~ ,maxInd] = max(rSquared(:));
% return best C & model
bestC = cGrid(maxInd);
bestGamma = gammaGrid(maxInd);
bestEpsilon = epsilonGrid(maxInd);
bestModel = svmModel{maxInd};

end