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
    case 'ckNn'
        numeroTestSamples = size(testData.sm,1);
        for i_testSamples = 1:numeroTestSamples
            [~,maxInd]= max(testData.sm(i_testSamples,:));
            predictions(i_testSamples,1) = bestModel.outcome(maxInd); % bestModel contains subsampledTrainData
        end
        
    case 'nn'
        % bestModel contains subsampledTrainData
        [nnInd] = knnsearch(bestModel.dummycodedFeatures,testData.dummycodedFeatures);
        predictions = bestModel.outcome(nnInd);
end

if classificationBoolean
    perfMetric = computeAccuracy(testData.outcome,predictions);
else
    perfMetric = computeRSquared(testData.outcome,predictions);
end



end