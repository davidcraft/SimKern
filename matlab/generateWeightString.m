function [weightString] = generateWeightString(trainData)
% This function generates part of the full input string for libSVM such
% that the resulting classification model compensates for unbalanced
% classes.

[uniqueOutcomeValues,ia,ic] = unique(trainData.outcome,'stable'); % find unqiue outcome values but keep order of outcome values in outcome vector

% for each unique value
for i_value = 1:numel(uniqueOutcomeValues)
% count the number of samples with this outcome
outcomeOccurence(i_value) = sum(trainData.outcome == uniqueOutcomeValues(i_value)); 

% % % % another way to compute weights
% % % weightVector(i_value) = C/(2*outcomeOccurence(i_value));

% assign 1/(the number of occurences) as the weight 
weightVector(i_value) = 1/(outcomeOccurence(i_value)^4);

% construct weight option per class
stringCell{i_value} = [' -w' num2str(uniqueOutcomeValues(i_value)) ' ' num2str(weightVector(i_value))];
end
% create full weight string
weightString = cat(2,stringCell{:});
end