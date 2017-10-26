function [dummycodedData] = dummycodeCategoricalFeatures(data,categoricalIndices)
% dummy code the categorical features and put them at the front of the
% feature matrix
% dummycodedData(:,categoricalIndices) = dummyvar(data(:,categoricalIndices));
dummycodedFeatures = dummyvar(data(:,categoricalIndices));
dummycodedData = [dummycodedFeatures data(:,~categoricalIndices)];

end