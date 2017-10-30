function [bestModel,bestC,bestGamma] = tuneRbfSvmClassificationHyperparameters(trainData,validationData,cValues,gammaValues)

[cGrid,gammaGrid] = ndgrid(cValues,gammaValues);
for i_c = 1:numel(cValues)
    for i_gamma = 1:numel(gammaValues)
        
        % trainSvm & store model
        inputString = ['-s 0 -t 2 -c ' num2str(cGrid(i_c,i_gamma)) ' -g ' num2str(gammaGrid(i_c,i_gamma)) ' -q'];
        [svmModel{i_c,i_gamma}] = svmtrain(trainData.outcome, trainData.dummycodedFeatures, inputString);
        % testSvm on validation data
        [predictions{i_c,i_gamma}] = svmpredict(zeros(size(validationData.outcome,1),size(validationData.outcome,2)),validationData.dummycodedFeatures,svmModel{i_c,i_gamma},'-q');
        
        %compute performance metric
        %     [rSquared(i_c)] = computeRSquared(validationData.outcome,predictions{i_c})
        [accuracy(i_c,i_gamma)] = computeAccuracy(validationData.outcome,predictions{i_c,i_gamma});
    end
end
% find model with best performance metric
[~ ,maxInd] = max(accuracy(:));
% return best C & model
bestC = cGrid(maxInd);
bestGamma = gammaGrid(maxInd);
bestModel = svmModel{maxInd};

end