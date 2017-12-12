function [output] = checkHyperparameterLimits(x,y)
[minX,minXInd] = min(x);
[maxX,maxXInd] = max(x);
[minY,minYInd] = min(y);
[maxY,maxYInd] = max(y);

if minY == minX
    disp(['Touches min at subsample ' num2str(minYInd) '.'])
end
if maxY == maxX
    disp(['Touches max at subsample ' num2str(maxYInd) '.'])
end

output = 1;

end