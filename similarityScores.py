from __future__ import division

def computeSimilarityScores(responses):
    numGenomes = responses.__len__()
    numTrials = responses[1].__len__()
    kernel = range(numGenomes)
    for i in range(0, numGenomes):
        kernel[i] = range(numGenomes)
        kernel[i][i] = 1

    for i in range(0, numGenomes-1):
        for j in range(i+1, numGenomes):
            count = 0
            for k in range(0, numTrials):
                if responses[i][k] == responses[j][k]:
                    count = count + 1
            score = count / numTrials
            kernel[i][j] = score
            kernel[j][i] = score

    return kernel


responses = [[0,0,0],[1,0,1],[0,0,1]]
kernel = computeSimilarityScores(responses)
