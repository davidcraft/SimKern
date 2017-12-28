library(BoolNet)

original_working_dir <- getwd()
setwd("..")
parent <- getwd()
setwd(original_working_dir)

path_to_boolean_file <- paste(parent, "/SampleDataFiles/booleanModel.txt", sep = "")
network <- loadNetwork(path_to_boolean_file)

s = vector()

#mutations
s[1] = $discrete(-1,0,1), name=AKT1$
s[2] = $discrete(-1,0,1), name=AKT2$
s[3] = $discrete(-1,0,1), name=CDH1$
s[4] = $discrete(-1,0,1), name=CTNNB1$
s[5] = $discrete(-1,0,1), name=ERK$
s[6] = $discrete(-1,0,1), name=NICD$
s[7] = $discrete(-1,0,1), name=p53$
s[8] = $discrete(-1,0,1), name=SNAI2$
s[9] = $discrete(-1,0,1), name=TGFbeta$
s[10] = $discrete(-1,0,1), name=TWIST1$

#externel inputs to the network
s[11] = $boolean(.5), name=B_DNAdamage$
s[12] = $boolean(.5), name=B_ECM$

network <- fixGenes( network, "AKT1", s[1])
network <- fixGenes( network, "AKT2", s[2])
network <- fixGenes( network, "CDH1", s[3])
network <- fixGenes( network, "CTNNB1", s[4])
network <- fixGenes( network, "ERK", s[5])
network <- fixGenes( network, "NICD", s[6])
network <- fixGenes( network, "p53", s[7])
network <- fixGenes( network, "SNAI2", s[8])
network <- fixGenes( network, "TGFbeta", s[9])
network <- fixGenes( network, "TWIST1", s[10])

initState = list(rep(1, 32))

#adjust initial state to mutational status:
initState[[1]][1]= s[1]
initState[[1]][2]= s[2]
initState[[1]][3]= s[3]
initState[[1]][5]= s[4]
initState[[1]][7]= s[5]
initState[[1]][12]= s[6]
initState[[1]][14]= s[7]
initState[[1]][19]= s[8]
initState[[1]][20]= s[9]
initState[[1]][21]= s[10]

initState[[1]][31]= s[11]
initState[[1]][32]= s[12]


attr <- getAttractors(network, method = "chosen", startStates = initState )

attrSeq <- getAttractorSequence(attr, 1)

if (all(attrSeq[ , 26] == 1)){
  print(1)
} else if (all(attrSeq[ , 30]== 1)) {
  print(2)
} else {
  print(0)
}