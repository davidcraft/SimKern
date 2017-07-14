library(BoolNet)

network <- loadNetwork("~/PycharmProjects/scrap/booleanTestNetwork.txt")

$mutate(p53, .4, 0), name= Mp53$

$mutate(NICD, .15, .51), name= MNICD$

$mutate(ERK, 0, .62), name= MERK$

attr <- getAttractors(network, method = "chosen", startStates = list(c(0, 0, $boolean(.3), name= ss3$,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, $boolean(.57), name= ss14$,
0, $boolean(.63), name= ss16$,
0, 0, 0, 0, $boolean(.8), name= ss21$,
0, 0, 0, 0, 0, $boolean(.3), name= ss27$,
 0, 0, 0, $boolean(.5), name= ss31$,
  $boolean(.24),name= ss32$)))

attrSeq <- getAttractorSequence(attr, 1)

if (all(attrSeq[ , 30] == 1)){
  print(0)
} else {
  print(1)
}