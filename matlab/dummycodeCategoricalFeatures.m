function [dummycodedData] = dummycodeCategoricalFeatures(data,categoricalIndices)
% dummy code the categorical features and put them at the front of the
% feature matrix

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