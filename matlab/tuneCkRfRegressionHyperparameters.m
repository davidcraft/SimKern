function [bestModel,bestM,bestMaxSplits] = tuneCkRfRegressionHyperparameters(trainData,validationData,mValues,maxSplitsValues,categoricalIndices,numeroTrees)
numCategories = 25;
[mGrid,maxSplitsGrid] = ndgrid(mValues,maxSplitsValues);
for i_m = 1:numel(mValues)
    for i_maxSplits = 1:numel(maxSplitsValues)
        
        % train RF
        
        rfModel{i_m,i_maxSplits} = TreeBagger(numeroTrees,trainData.sm,trainData.outcome,'Method','regression', ...
            'NumPredictorsToSample',mGrid(i_m,i_maxSplits),'MaxNumSplits',maxSplitsGrid(i_m,i_maxSplits),'CategoricalPredictors',false(1,size(trainData.sm,2)),'MaxNumCategories',numCategories);
        
        %use RF for prediction for testing set:
        baggerPredictions = predict(rfModel{i_m,i_maxSplits},validationData.sm);
        predictions{i_m,i_maxSplits} = baggerPredictions;
        %compute performance metric
        [rSquared(i_m,i_maxSplits)] = computeRSquared(validationData.outcome,predictions{i_m,i_maxSplits});
    end
end
% find model with best performance metric
[~ ,maxInd] = max(rSquared(:));
% return best C & model
bestM = mGrid(maxInd);
bestMaxSplits = maxSplitsGrid(maxInd);
bestModel = rfModel{maxInd};

end