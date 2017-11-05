function [standardizedData] = standardizeFeatures(data,categoricalIndices)
% this function rescales and shifts all continuous variables onto the
% interval [0,1] by subtracting the minimal value and dividing by the
% range(max - min).
% categorical variables remain unchanged
continuousIndicies = ~categoricalIndices;
%% rescaling x
dataMin = min(data(:,continuousIndicies));
dataMax = max(data(:,continuousIndicies));
standardizedData = data;
standardizedData(:,continuousIndicies) = bsxfun(@minus,standardizedData(:,continuousIndicies),dataMin);
standardizedData(:,continuousIndicies) = bsxfun(@times,standardizedData(:,continuousIndicies),1./(dataMax - dataMin));
end
