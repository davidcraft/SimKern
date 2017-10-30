function [perfMetric] = predictTestData(testData,bestModel,modelType,classificationBoolean)

switch modelType
    case {'linSvm','rbfSvm'}
        % fill first input with zeros (instead of outcomes) because we don't want libsvm to
        % predict accuracy for us
        [predictions] = svmpredict(zeros(size(testData.outcome,1),size(testData.outcome,2)),testData.dummycodedFeatures,bestModel,'-q');
    case 'rf'
        if classificationBoolean
            baggerPredictions = predict(bestModel,testData.features);
            predictions = cellfun(@str2num,baggerPredictions);
        else
            baggerPredictions = predict(bestModel,testData.features);
            predictions = baggerPredictions;
        end
    case 'ckSvm'
        numeroTestSamples = numel(testData.outcome);
        % fill first input with zeros (instead of outcomes) because we don't want libsvm to
        % predict accuracy for us
        [predictions] = svmpredict(zeros(size(testData.outcome,1),size(testData.outcome,2)),[(1:numeroTestSamples)' testData.sm],bestModel,'-q');    
    case 'ckRf'
        if classificationBoolean
            baggerPredictions = predict(bestModel,testData.sm);
            predictions = cellfun(@str2num,baggerPredictions);
        else
            baggerPredictions = predict(bestModel,testData.sm);
            predictions = baggerPredictions;
        end
end

if classificationBoolean
    perfMetric = computeAccuracy(testData.outcome,predictions);
else
    perfMetric = computeRSquared(testData.outcome,predictions);
end



end