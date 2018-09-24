

This program is designed to simulate permutations of genomes and analyze the results with machine learning algorithms.
This system can receive a file containing a series of differential equations, a network flow model, or a boolean
network which represents a cell or some other complex system. Once the permutations on this file are created, they are
run through a third party program (Matlab, Octave, or R) to record a scalar result for each permutation to be used in
standard machine learning models. This process is known as SIM0 and the permutations are referred to as genomes.

In a process known as SIM1, a separate set of permutations can be run on each of the genomes and after analyzing the
outputs, a similarity score can be determined between genomes. A similarity matrix is then built up, making it eligible
for kernelized machine learning.

The final part of both SIM0 and SIM1 is to perform machine learning with all of the data generated. During this process
a chart is generated to show the outcome of each.

All output for this program, including the result of each file for both SIM0 and SIM1, the corresponding similarity and
output matrices and the genome files created will be output to a directory chosen by the user.


In order to use this program to generate genome files and get the responses, several requirements must be met. The user
must have python version 3.6 installed on their machine. Type `python --version` on the command line to check. The user
also needs the binary of a third party program of their choice (Matlab, Octave, or R) in their path. For example, typing
`octave` on the command line should start that program. To start the program, simply run the \_\_main\_\_.py class.

python /PATH/TO/\_\_main\_\_.py

The following prompt should come up:


# Main Menu
```
Choose your task:

0: SIM0 - create K genomes
1: SIM1 - create R permutations of K genomes
2: Perform machine learning with existing SIM0 data
3: Perform machine learning with existing SIM1 data
4: Perform machine learning with both SIM0 and SIM1 data
Q: Quit
```
The necessary necessary inputs and a detailed explanation of the outputs for each menu option are detailed below.

## 0: SIM0 GENOME CREATION
Genome creation requires 4 inputs: a master SIM0 input file, an integer number of genomes to create, an existing output
folder, an expected response type for the files.

The SIM0 master file:
This is the file which will have various permutations created from it and must be created by the user. To create it,
take a Matlab or R file representing a model of some kind of system which returns a scalar output. Good examples include
a process within a cell or a flowering model. This file should have declarations of variables and values within it. For
example, in Matlab the line:
```
global_parameter=0.1;
```
would be assigning a value of 0.1 to the variable global_parameter. If global_parameter is a value that could be
important in determining the scalar output of the final result of a file, or would make a good candidate for a feature
in a machine learning model, it can be automatically permuted by using some rendition of the following syntax:
```
global_parameter=$gauss(.1,.01),name=global_param$;
```
The explicit value of this variable is instead assigned to a range of variables. In this case, it's a Gaussian spread
with a mean of 0.1 and a standard deviation of 0.01.

The supported probability distributions and their parameters are given below:

 |   DISTRIBUTION          |  SYNTAX                            |  EXAMPLE                                         |
 |-------------------------|------------------------------------|--------------------------------------------------|
 |   discrete              |  discrete(values...)               |  `$discrete(1,2,3,4),name=discrete_coefficient$` |
 |   normal/gaussian       |  gauss(mu,sigma)                   |  `$gauss(0,1),name=gaussian_coefficient$`        |
 |   uniform               |  uniform(min,max)                  |  `$uniform(-1,1),name=uniform_coefficient$`      | 
 |   gamma                 |  gamma(k,theta)                    |  `$gamma(1,.1),name=gamma_coefficient$`          |
 |   log normal            |  lognormal(mu,theta)               |  `$lognormal(0,1),name=lognormal_coefficient$`   |
 |   binomial              |  binomial(n,p)                     |  `$binomial(100,.5),name=binomial_coefficient$`  |
 |   poisson               |  poisson(k,lambda)                 |  `$poisson(0,1),poisson_coefficient$`            | 
 |   boolean (R files only)|  boolean(probability_of_zero)      |  `$boolean(.2),name=boolean_coefficient$`        |

These files also support the syntax $val$ and $val,name=coefficient_name$, both of which default to a
gaussian distribution with std.deviation .1. For example:

```
$5$
``` 
is the same as writing: 
```
$gauss(5,.1),name=coefficient1$
```
and
```
$5,name=gaussian_coefficient$
``` 
is the same as writing: 
```
$gauss(5,.1),name=gaussian_coefficient$
```

Once these important variables have had their explicit declarations replaced with this "dollar sign" syntax, save the
file in one of the following formats:

* ".R" for R files
* ".m" for Matlab files
* ".octave" for Octave files (.m files work in Octave, but the file extension allows the program to know which third party program to call).


Number of genomes to create:
This value (sometimes referred to as K) is the number of permutations to run on the SIM0 master file.


Existing output folder:
This value should be a string representing a path that already exists on the users computer. It must be the full path,
and does not accept shortcuts for home (~/) in the string itself. A folder named GenomeFiles will be created at this
location.


Expected Response Type:
This is the expected response type for the genomes created. For SIM0, only "float" (for regressors) and "int" (for
classifiers) are supported.



Outputs:
SIM0 will create 2K + 2 files, where K is the number of genomes. For each genome there is a version of the original SIM0
master file, with the variables replaced by actual values. So for example:

```
global_parameter=$gauss(.1,.01),name=global_param$;
```

might be replaced with:

```
global_parameter=0.105;
```

since 0.105 is within reason for the Gaussian distribution with a mean of .1 and a standard deviation of .01. Every
$$ syntax in the original file will be replaced with values according to the appropriate distribution, making a file
that can be run in the third party program corresponding to the original file extension. These K files are created and
run automatically, and their results recorded in a .CSV file called "Sim0Output.csv". There will also be a key file
created for each genome file. This key file is just a series of declarations of the assigned variables which will be
used in SIM1. Finally, all key files' values are combined into a CSV file called "Sim0GenomesMatrix.csv".

## 1: SIM1 SIMILARITY PERMUTATIONS
Permutations on existing genomes requires 5 inputs: a master SIM1 input file, an integer number of genomes that were
created in SIM0, an integer representing the number of trials to run on each genome, an existing output
folder, an expected response type for the files.

The SIM1 master file:
This should be a modification of the SIM0 master file except that an entirely different set of variables should be
permuted with the $$ syntax, and the original variables that were replaced with their genomic value as determined by
SIM0. To do this, load genome_key1 at the top of the file so all those values are defined in scope. Then just replace
the original $$ syntax with the originally chosen variable names. For example:
```
global_parameter=$gauss(.1,.01),name=global_param$;
```
would be replaced with:
```
global_parameter=global_param;
```
where global_param is already defined because genome_key1 was loaded at the top of the file. Then just permute a
separate set of variables.
```
other_coefficient=$discrete(1,2,3,4),name=discrete$
```
All of the same $$ syntaxes and file types that were supported in SIM0 are also supported for SIM1.


Number of genomes to create:
This value (sometimes referred to as K) is the number of genomes that were created in SIM0.


Number of trials to run:
This value (sometimes referred to as R) is the number of trials on each genome that should be run. This means R
different versions of each new $$ marked variable will be created, and then the genome_key1 will be swapped out K times
for each genome. R*K total trial by genome files will be created.


Existing output folder:
This value should be a string representing a path that already exists on the users computer. It must be the full path,
and does not accept shortcuts for home (~/) in the string itself. A folder named GenomeFiles will be created at this
location if it doesn't already exist.


Expected Response Type:
This is the expected response type for the genomes created. For SIM1, "float" (for regressors) and "int" (for
classifiers) are supported as well as "vector" for vector response types from a third party system.
//TODO: details on intricacies of vector responses and how a similarity matrix is made.


Outputs:
SIM0 will create R\*K + 1 files, where R is the number of trials and K is the number of genomes. Similar to SIM0 all
$$ have been replaced with real values, but now "genome_key1" has been replaced with the "genome_key2" all the way up
to k. All of these R*K files are created and run automatically, and their results used to create a similarity matrix.
For each genome, the similarity is measured by how many of the R trials return the same result. So if R is 10 and 7
of the trials return the same result when comparing two different genomes, the similarity score for those two genomes
will be 0.7. The similarity score is therefore in the range [0,1]. This similarity matrix is automatically saved as a
CSV file called "Sim1SimilarityMatrixfinal.csv".
//TODO: details on the incremental calculation of the similarity score.



## 2: SIM0 MACHINE LEARNING
To analyze the results of SIM0, 4 arguments are needed: a file Sim0Output.csv file expressing the third party program
results of SIM0, the accompanying Sim0GenomesMatrix file, 'REGRESSION' or 'CLASSIFICATION' for the type of analysis,
and a list of indices for categorical features in the Sim0GenomesMatrix.

Once these are submitted, categorical features will be one-hot encoded, splitting them out into individual binary
features. Then 3 machine learning algorithms will be run: Random Forest, Support Vector Machines (with linear
kernel) and Support Vector Machines (with radial basis function kernel). For all of these, hyperparameters are
optimized and the data is split in to training, testing, and validation groups. This will output a graph called
MachineLearningMultiBarPlot.png which shows the accuracy of each machine learning model over a range of different
training percentages.


## 3: SIM1 MACHINE LEARNING
To analyze the results of SIM1, 3 arguments are needed: a file Sim0Output.csv file expressing the third party program
results of SIM0, a Sim1SimilarityMatrix.csv file, and 'REGRESSION' or 'CLASSIFICATION' for the type of analysis..

Once these are submitted 1 machine learning algorithm will be run: Kernelized Support Vector Machines (with radial basis
function kernel). Hyperparameters are optimized and the data is split in to training, testing, and validation groups.
This will output a graph called MachineLearningMultiBarPlot.png which shows the accuracy of the machine learning model
over a range of different training percentages.




## 4: SIM0 SIM1 COMBINED MACHINE LEARNING
To analyze the results of SIM0 and SIM1 at the same time, 5 arguments are needed: a file Sim0Output.csv file expressing
the third party program results of SIM0, the accompanying Sim0GenomesMatrix file, a Sim1SimilarityMatrix.csv file,
and 'REGRESSION' or 'CLASSIFICATION' for the type of analysis, and a list of indices for categorical features in the
Sim0GenomesMatrix.

Once these are submitted, categorical features will be one-hot encoded, splitting them out into individual binary
features. Then 4 machine learning algorithms will be run: Random Forest, Support Vector Machines (with linear
kernel), Support Vector Machines (with radial basis function kernel), and Kernelized Support Vector Machines. For all of
these, hyperparameters are optimized and the data is split in to training, testing, and validation groups. This will
output a graph called MachineLearningMultiBarPlot.png which shows the accuracy of each machine learning model over a
range of different training percentages.




# Required citation:
(BibTex/LaTex):

@Article{Hunter:2007,
  Author    = {Hunter, J. D.},
  Title     = {Matplotlib: A 2D graphics environment},
  Journal   = {Computing In Science \& Engineering},
  Volume    = {9},
  Number    = {3},
  Pages     = {90--95},
  abstract  = {Matplotlib is a 2D graphics package used for Python
  for application development, interactive scripting, and
  publication-quality image generation across user
  interfaces and operating systems.},
  publisher = {IEEE COMPUTER SOC},
  doi = {10.1109/MCSE.2007.55},
  year      = 2007
}

