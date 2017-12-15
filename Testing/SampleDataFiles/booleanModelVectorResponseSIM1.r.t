library(BoolNet)


original_working_dir <- getwd()
setwd("..")
parent <- getwd()
setwd(original_working_dir)

path_to_boolean_file <- paste(parent, "/SampleDataFiles/booleanModel.txt", sep = "")
network <- loadNetwork(path_to_boolean_file)

path_to_key_files <- paste(parent, "/GenomeFiles/genome1_key.r", sep="")
source(path_to_key_files)

if (v1!=-1){
    fixGenes(network, "AKT1", v1)
}
if (v2!=-1){
    fixGenes(network, "AKT2", v2)
}
if (v3!=-1){
    fixGenes(network, "CDH1", v3)
}
if (v4!=-1){
    fixGenes(network, "CTNNB1", v4)
}
if (v5!=-1){
    fixGenes(network, "NICD", v5)
}
if (v6!=-1){
    fixGenes(network, "p53", v6)
}
if (v7!=-1){
    fixGenes(network, "SNAI2", v7)
}
if (v8!=-1){
    fixGenes(network, "TGFbeta", v8)
}


attr <- getAttractors(network, method = "chosen", startStates = list(c($boolean(.5), name=v1$,
$boolean(.5), name=v2$,
$boolean(.5), name=v3$,
$boolean(.5), name=v4$,
$boolean(.5), name=v5$,
$boolean(.5), name=v6$,
$boolean(.5), name=v7$,
$boolean(.5), name=v8$,
$boolean(.5), name=v9$,
$boolean(.5), name=v10$,
$boolean(.5), name=v11$,
$boolean(.5), name=v12$,
$boolean(.5), name=v13$,
$boolean(.5), name=v14$,
$boolean(.5), name=v15$,
$boolean(.5), name=v16$,
$boolean(.5), name=v17$,
$boolean(.5), name=v18$,
$boolean(.5), name=v19$,
$boolean(.5), name=v20$)))

attrSeq <- getAttractorSequence(attr, 1)

attrSeq <- getAttractorSequence(attr, 1)

response<-matrix(0, nrow=1, ncol=20)

#Return vector representation of average of result data frame.
average <- c("")
for (row in attrSeq) {
  average <- c(average, mean(row))
}
average <- c(average, "")

paste(average, collapse="%avg%")
