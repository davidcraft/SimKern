function [bestModel,bestM,bestMaxSplits] = tuneRfClassificationHyperparameters(trainData,validationData,mValues,maxSplitsValues,categoricalIndices,numeroTrees)
numCategories = 25;
[mGrid,maxSplitsGrid] = ndgrid(mValues,maxSplitsValues);
for i_m = 1:numel(mValues)
    for i_maxSplits = 1:numel(maxSplitsValues)
        
        % train RF
        
        rfModel{i_m,i_maxSplits} = TreeBagger(numeroTrees,trainData.features,trainData.outcome,'Method','classification', ...
            'NumPredictorsToSample',mGrid(i_m,i_maxSplits),'MaxNumSplits',maxSplitsGrid(i_m,i_maxSplits),'CategoricalPredictors',categoricalIndices,'MaxNumCategories',numCategories);
        
        %use RF for prediction for testing set:
        baggerPredictions = predict(rfModel{i_m,i_maxSplits},validationData.features);
        predictions{i_m,i_maxSplits} = cellfun(@str2num,baggerPredictions);
        %compute performance metric
        %     [rSquared(i_c)] = computeRSquared(validationData.outcome,predictions{i_c})
        [accuracy(i_m,i_maxSplits)] = computeAccuracy(validationData.outcome,predictions{i_m,i_maxSplits});
    end
end
% find model with best performance metric
[~ ,maxInd] = max(accuracy(:));
% return best C & model
bestM = mGrid(maxInd);
bestMaxSplits = maxSplitsGrid(maxInd);
bestModel = rfModel{maxInd};

end