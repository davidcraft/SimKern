function [splitAInd,splitBInd] = splitSamples(outcome,splitARatio,stratificationBoolean)
% this function returns indicies for the variable outcome (a vector) to
% create two splits (splitA and splitB) approximating the user-provided
% variable splitARatio (i.e., floor(splitARatio * number of samples) ).
% If the variable stratificationBoolean is true, each
% split contains (approximately) the same distribution of values as in the
% variable outcome.
% When stratifying, the splits are only 'approximate' because the splitting
% is repeated for each unique value in outcome. Repeating the operation
% floor(splitARatio * number of samples) for each unique value can cause
% a deviation from the intended splitARatio if the number of unique values
% is large.

numeroSamples = length(outcome);
numeroSamplesSplitA = round(splitARatio * numeroSamples);
numeroSamplesSplitB = numeroSamples - numeroSamplesSplitA;

% for stratification, do random subsamples for each unique value in the
% variable outcome (treat each unique value as a 'class')
if stratificationBoolean
    classLabels = unique(outcome);
    indNumbering = 1:numeroSamples;
    splitAInd = [];
    splitBInd = [];
    % iteratively add sample indices for a specific class to each split
    for i_classes = 1:numel(classLabels)
        % ensure that splitA has exactly splitARatio * numeroSamples samples by padding the set with the last class
        if i_classes < numel(classLabels)
            ind{i_classes} = indNumbering(outcome == classLabels(i_classes));
            [subsplitAInd,subsplitBInd] = splitSamples(ind{i_classes},splitARatio,0); % this recursion is silly
            splitAInd = [splitAInd ind{i_classes}(subsplitAInd)];
            splitBInd = [splitBInd ind{i_classes}(subsplitBInd)];
        else
            ind{i_classes} = indNumbering(outcome == classLabels(i_classes));
            numeroSamplesLastClass = numel(ind{i_classes});
            numeroSamplesSplitALastClass = numeroSamplesSplitA - numel(splitAInd);
            subsplitAInd = randsample(numeroSamplesLastClass,numeroSamplesSplitALastClass);
            subsplitBInd = setdiff(1:numeroSamplesLastClass,subsplitAInd)';
            splitAInd = [splitAInd ind{i_classes}(subsplitAInd)];
            splitBInd = [splitBInd ind{i_classes}(subsplitBInd)];
            
        end
    end
    
else
    % without stratification: just randomly sample for splitA and place the rest in splitB
    splitAInd = randsample(numeroSamples,numeroSamplesSplitA);
    splitBInd = setdiff(1:numeroSamples,splitAInd)';
end

end