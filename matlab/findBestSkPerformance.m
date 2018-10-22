function [bestSk,bestSkLabel] = findBestSkPerformance(skSvmResult,skRfResult)
% picks the best SimKern classifier(skSvm or skRf).
% To determine the best classifier, the the median test set performance
% is determined for each training data subsample. It is counted how often
% skSvm wins. If the ratio is more than 0.5 of the time, skSvm wins.
skSvmWinRatio = mean(median(skSvmResult) > median(skRfResult));
if (skSvmWinRatio > 0.5)
    bestSk = skSvmResult;
    bestSkLabel = 'simkern SVM';
else
    bestSk = skRfResult;
    bestSkLabel = 'simkern RF';
end

end