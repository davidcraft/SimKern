function [dummycodedData] = dummycodeCategoricalFeatures(data,categoricalIndices)
% dummy code/one-hot encode the categorical features and put them at the front of the
% feature matrix.
% Note: for regression with a constant variable, one of the columns will have
% to be deleted for each variable in order to avoid rank deficiency/'the
% dummy variable trap'.

if any(categoricalIndices) % only apply dummy coding if there are categorical variables
    categoricalFeatures = data(:,categoricalIndices);
    
    if any(any(categoricalFeatures == 0)) % if categorical features contain 0s
        categoricalFeatures = categoricalFeatures + 1; % shift all categories by 1
    end
    
    dummycodedFeatures = dummyvar(categoricalFeatures);
    dummycodedData = [dummycodedFeatures data(:,~categoricalIndices)];
else % otherwise just copy the original data as output
    dummycodedData = data;
end
end