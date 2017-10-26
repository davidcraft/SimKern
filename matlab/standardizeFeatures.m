function [standardizedData] = standardizeFeatures(data,categoricalIndices)
continuousIndicies = ~categoricalIndices;
%% rescaling x
dataMin = min(data(:,continuousIndicies));
dataMax = max(data(:,continuousIndicies));
standardizedData = data;
standardizedData(:,continuousIndicies) = bsxfun(@minus,standardizedData(:,continuousIndicies),dataMin);
standardizedData(:,continuousIndicies) = bsxfun(@times,standardizedData(:,continuousIndicies),1./(dataMax - dataMin));
end
