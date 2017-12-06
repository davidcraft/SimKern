library(BoolNet)

original_working_dir <- getwd()
setwd("..")
parent <- getwd()
setwd(original_working_dir)

path_to_boolean_file <- paste(parent, "/SampleDataFiles/booleanModel.txt", sep = "")
network <- loadNetwork(path_to_boolean_file)

$mutate(CTNNB1, 0, .304), name= M_CTNNB1$
$mutate(p53, .044, .304), name= M_p53$
$mutate(CDH1, .044, 0), name= M_CDH1$
$mutate(NICD, .044, .218), name= M_NICD$
$mutate(TGFbeta, 0.044, 0.130), name= M_TGFbeta$
$mutate(ERK, .044, 0.218), name= M_ERK$
$mutate(SNAI2, 0, .044), name= M_SNAI2$
$mutate(TWIST1, 0 , .044), name= M_TWIST1$
$mutate(AKT2, 0, .218), name= M_AKT2$
$mutate(AKT1, 0, .174), name= M_AKT1$

attr <- getAttractors(network, method = "chosen", startStates = list(c($boolean(0.5), name= B_AKT1$,
$boolean(0.5), name= B_AKT2$,
$boolean(0.5), name= B_CDH1$,
$boolean(0.5), name= B_CDH2$,
$boolean(0.5), name= B_CTNNB1$,
$boolean(0.5), name= B_DKK1$,
$boolean(0.5), name= B_ERK$,
$boolean(0.5), name= B_GF$,
$boolean(0.5), name= B_miR200$,
$boolean(0.5), name= B_miR203$,
$boolean(0.5), name= B_miR34$,
$boolean(0.5), name= B_NICD$,
$boolean(0.5), name= B_p21$,
$boolean(0.5), name= B_p53$,
$boolean(0.5), name= B_p63$,
$boolean(0.5), name= B_p73$,
$boolean(0.5), name= B_SMAD$,
$boolean(0.5), name= B_SNAI1$,
$boolean(0.5), name= B_SNAI2$,
$boolean(0.5), name= B_TGFbeta$,
$boolean(0.5), name= B_TWIST1$,
$boolean(0.5), name= B_VIM$,
$boolean(0.5), name= B_ZEB1$,
$boolean(0.5), name= B_ZEB2$,
0, 0, $boolean(0.5), name= B_EMT$,
$boolean(0.5), name= B_Invasion$,
$boolean(0.5), name= B_Migration$,
0, 1, $boolean(0.5), name= B_ECM$)))

attrSeq <- getAttractorSequence(attr, 1)

if (all(attrSeq[ , 26] == 1)){
  print(0)
} else {
  print(1)
}


#Return vector representation of average of result data frame.
average <- c("")
for (row in attrSeq) {
  average <- c(average, mean(row))
}
average <- c(average, "")

paste(average, collapse="%avg%")

