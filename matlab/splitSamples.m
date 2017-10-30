function [splitAInd,splitBInd] = splitSamples(outcome,splitARatio,stratificationBoolean)
numeroSamples = length(outcome);
numeroSamplesSplitA = floor(splitARatio * numeroSamples);
numeroSamplesSplitB = numeroSamples - numeroSamplesSplitA;


if stratificationBoolean
    classLabels = unique(outcome);
    indNumbering = 1:numeroSamples;
    splitAInd = [];
    splitBInd = [];
    % iteratively add sample indices for a specific class to each split
    for i_classes = 1:numel(classLabels)
        ind{i_classes} = indNumbering(outcome == classLabels(i_classes));
        [subsplitAInd,subsplitBInd] = splitSamples(ind{i_classes},splitARatio,0); % this is silly
        splitAInd = [splitAInd ind{i_classes}(subsplitAInd)];
        splitBInd = [splitBInd ind{i_classes}(subsplitBInd)];
    end
else
    % just randomly sample for splitA and place the rest in splitB
    splitAInd = randsample(numeroSamples,numeroSamplesSplitA);
    splitBInd = setdiff(1:numeroSamples,splitAInd)';
end

end