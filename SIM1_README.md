# SIM1

### INTRODUCTION

SIM1 is the simulation enviornment where a large number of simulations are run for each member of 
a given population in order to compute similarity scores for machine learning. Given a total number of K
genomes in a population, the user will run a total number of R simulations for each of the K genomes. 

### REQUIREMENTS

The SIM1 framework currently supports MATLAB and Octave as viable simulation engines. We have not yet extended the framework to consider logical or qualitative simulation engines. In the simulation engine, the user must specify which model-specific parameters are to be changed to produce a total number of K simulations of the system in question. For each of the K simulations, we will further simulate each member a total number of R times. 

### FRAMEWORK

The SIM1 framework was written in Python 3.6 and tested using Octave. For those favoring UNIX/LINUX systems, the framework does allow for command-line input by the user.

### USER CHANGES

The user must create a text file of the desired simulation for the SIM0 framework. We have denoted this text file by adding the ".u" after the simulation file:

(MATLAB/Octave): `my_simulation.m` -> `my_simulation.m.u`

In the simulation text file, the user should change model-specific parameters from singular values to randomly chosen values derived from a number of discrete and continuous probability distributions provided.

Example(s) (MATLAB):

`my_param_1 = 0.757` -> `$my_param_1 = normrnd(0.757,0.12)$`

`my_param_2 = 0.123` -> `$my_param_2 = gamrnd(0.123,0.414)$`

### RUNNING SIM1

Once the framework is located and placed into an appropriate depository, the user can initiate SIM1 by 
the following prompt (assuming the path is defined as well):

`python2.7 "__main__.py"`

A menu will appear in the command window. To immeadiately run the SIM0 enviornment, enter the following four arguments into the command line:

`my_simulation.m.t,K,R,my_path`

`my_simulation.m.t` -> text file of simulation with '$my_param$' inputted previously by user
`K` -> integral number of total network simulations
`R` -> integral number of total network simulations of each of the K family members
`my_path` -> output path that saves the K network simulations

SIM1 will then return a list/matrix of dimensions K-by-R with elements either 0 or 1. If any of the simulations produce questionable values or fail to run, a value of -1 will appear instead of a 0 or 1. The resulting list/matrix can then be used for machine learning using any choice of software.


### OUTPUT FILES
In addition to the returned classificaiton list/array, a new directory named `GenomeFiles` will be created containing the KxR different files pertaining to each classiciation. Each file will have the form `gij.m`, where 1 < i < K and 1 < j < R.
The contents of each file will contain a list of parameters pertaining to each classification. For example:

`g12.m`
```MATLAB
my_param_1 = 0.748;
my_param_2 = 0.366;
```
