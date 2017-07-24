library(BoolNet)

original_working_dir <- getwd()
setwd("..")
parent <- getwd()
setwd(original_working_dir)

path_to_boolean_file <- paste(parent, "/SampleDataFiles/booleanModel.txt", sep = "")
network <- loadNetwork(path_to_boolean_file)

bogus_syntax_check_2 <- 5.033881489932603
bogus_syntax_check_1 <- 5.254665928884685




fixGenes( network, "NICD", 0)







attr <- getAttractors(network, method = "chosen", startStates = list(c(0,
1,
0,
1,
1,
1,
1,
0,
1,
1,
0,
1,
0,
0,
1,
1,
1,
1,
1,
1,
1,
1,
0,
0,
0, 0, 0,
1,
0,
0, 1, 1)))

attrSeq <- getAttractorSequence(attr, 1)

if (all(attrSeq[ , 26] == 1)){
  print(0)
} else {
  print(1)
}
