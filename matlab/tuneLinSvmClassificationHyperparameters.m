function [bestModel,bestC,bestAccuracy,trainPredictions,validationPredictions] = tuneLinSvmClassificationHyperparameters(trainData,validationData,cValues)
%NOTE: code structure is different than for algorithms with multiple
% hyperparameters! e.g., no grid. Compare tuneRbfSvmClassificationHyperparameters()
for i_c = 1:numel(cValues)
    % trainSvm & store model
    inputString = ['-s 0 -t 0 -c ' num2str(cValues(i_c)) ' -q'];
    [linSvmModel{i_c}] = svmtrain(trainData.outcome, trainData.dummycodedFeatures, inputString);
    % testSvm on validation data
    [predictions{i_c}] = svmpredict(zeros(size(validationData.outcome,1),size(validationData.outcome,2)),validationData.dummycodedFeatures,linSvmModel{i_c},'-q');
    
    %compute performance metric
    [accuracy(i_c)] = computeAccuracy(validationData.outcome,predictions{i_c});
end
% find model with best performance metric
[bestAccuracy,maxInd] = max(accuracy);
% return best C & model
bestC = cValues(maxInd);
bestModel = linSvmModel{maxInd};
validationPredictions = predictions{maxInd};

% compute train predictions for selected model
[trainPredictions] = svmpredict(zeros(size(trainData.outcome,1),size(trainData.outcome,2)),trainData.dummycodedFeatures,bestModel,'-q');

end