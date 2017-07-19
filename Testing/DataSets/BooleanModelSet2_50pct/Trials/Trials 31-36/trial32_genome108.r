library(BoolNet)

network <- loadNetwork("~/PycharmProjects/scrap/simplifiedBooleanNetwork.txt")

source("~/PycharmProjects/scrap/GenomeFiles/genome108_key.r")

if (M_CDH1 == 0) {
	fixGenes(network, "Ecadh", 0)
} else if (M_CDH1 == 1) {
	fixGenes(network, "Ecadh", 1)
}





fixGenes( network, "TGFb_pthw", 0)

fixGenes( network, "ERK_pthw", 0)



fixGenes( network, "WNT_pthw", 1)



fixGenes( network, "AKT2", 0)





attr <- getAttractors(network, method = "chosen", startStates = list(c(B_AKT1, B_AKT2, 1,
1,
B_ERK, B_GF, 0,
B_NICD, B_p53, 1,
0,
0,
0, 0, B_EMT, B_Invasion, B_Migration, 0, 1, 1)))

attrSeq <- getAttractorSequence(attr, 1)

if (all(attrSeq[ , 14] == 1)){
  print(0)
} else {
  print(1)
}