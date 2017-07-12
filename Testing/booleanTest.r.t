library(BoolNet)

network <- loadNetwork("~/PycharmProjects/scrap/booleanTestNetwork.txt")

$mutate(p53, .2, .2), name= Mp53$

$mutate(VIM, .3, .8), name= MVIM$

attr <- getAttractors(network, method = "chosen", startStates = list(c(0, 0, $boolean(.3), name= ss3$,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $boolean(.57), name= ss14$,
0, 0, 0, 0, 0, 0, $boolean(.8), name= ss21$, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)))

attrSeq <- getAttractorSequence(attr, 1)

if (all(attrSeq[ , 30] == 1)){
  print(0)
} else {
  print(1)
}