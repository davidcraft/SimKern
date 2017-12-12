library(BoolNet)

original_working_dir <- getwd()
setwd("..")
parent <- getwd()
setwd(original_working_dir)

path_to_boolean_file <- paste(parent, "/SIM0BooleanNetwork.txt", sep = "")
network <- loadNetwork(path_to_boolean_file)

#first set initial state to all 1s.
initState = list(rep(1, 32))

#then vary the initial state.
#SIM0 == > INITIAL CONDITIONS vary from person to person:
initState[[1]][1]=   $boolean(.5), name=AKT1$    
initState[[1]][2]=   $boolean(.5), name=AKT2$    
initState[[1]][3]=   $boolean(.5), name=CDH1$
initState[[1]][4]=   $boolean(.5), name=CDH2$    
initState[[1]][5]=   $boolean(.5), name=CTNNB1$
initState[[1]][6]=   $boolean(.5), name=DKK1$  
initState[[1]][7]=   $boolean(.5), name=ERK$
initState[[1]][8]=   $boolean(.5), name=GF$
initState[[1]][9]=   $boolean(.5), name=miR200$
initState[[1]][10]=   $boolean(.5), name=miR203$
initState[[1]][11]=   $boolean(.5), name=miR34$     
initState[[1]][12]=  $boolean(.5), name=NICD$
initState[[1]][13]=   $boolean(.5), name=p21$
initState[[1]][14]=  $boolean(.5), name=p53$     
initState[[1]][15]=   $boolean(.5), name=p63$
initState[[1]][16]=   $boolean(.5), name=p73$
initState[[1]][17]=   $boolean(.5), name=SMAD$
initState[[1]][18]=   $boolean(.5), name=SNAI1$     
initState[[1]][19]=  $boolean(.5), name=SNAI2$   
initState[[1]][20]=  $boolean(.5), name=TGFbeta$ 
initState[[1]][21]=  $boolean(.5), name=TWIST1$ 
initState[[1]][22]=   $boolean(.5), name=VIM$
initState[[1]][23]=   $boolean(.5), name=ZEB1$
initState[[1]][24]=   $boolean(.5), name=ZEB2$
initState[[1]][25]=   $boolean(.5), name=CellCycleArrest$
initState[[1]][26]=   $boolean(.5), name=Apoptosis$
initState[[1]][27]=   $boolean(.5), name=EMT$
initState[[1]][28]=   $boolean(.5), name=Invasion$
initState[[1]][29]=   $boolean(.5), name=Migration$
initState[[1]][30]=   $boolean(.5), name=Metastasis$     
#AND external inputs to the network
initState[[1]][31]= $boolean(.5), name=B_DNAdamage$
initState[[1]][32]= $boolean(.5), name=B_ECM$

#could also add mutations into sim0 to make the problem harder


attr <- getAttractors(network, method = "chosen", startStates = initState )

attrSeq <- getAttractorSequence(attr, 1)

if (all(attrSeq$Apoptosis == 1)){
  print(1)
} else if (all(attrSeq$Metastasis== 1)) {
  print(2)
} else {
  print(0)
}