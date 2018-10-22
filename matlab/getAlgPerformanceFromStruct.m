function [nnResult,linSvmResult,rbfSvmResult,rfResult,skSvmResult,skRfResult,skNnResult] = getAlgPerformanceFromStruct(algsIn)
% Get algorithm performances out of the struct 'algsIn' for use in plotting
for i_algs = 1:length(algsIn)
    nnResult(i_algs,:) = algsIn(i_algs).nn.perfMetric;
    linSvmResult(i_algs,:) = algsIn(i_algs).linSvm.perfMetric;
    rbfSvmResult(i_algs,:) = algsIn(i_algs).rbfSvm.perfMetric;
    rfResult(i_algs,:) = algsIn(i_algs).rf.perfMetric;
    skSvmResult(i_algs,:) = algsIn(i_algs).skSvm.perfMetric;
    skRfResult(i_algs,:) = algsIn(i_algs).skRf.perfMetric;
    skNnResult(i_algs,:) = algsIn(i_algs).skNn.perfMetric;
end
end