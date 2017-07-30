# SIM1

### INTRODUCTION

SIM1 is the simulation environment where a large number of simulations are run for each member of
a given population in order to compute similarity scores for machine learning. Given a total number of
genomes in a population, the SIM1 program will run a set amount of simulations for each of the genomes.

### REQUIREMENTS

The SIM1 framework currently supports R, Octave, and MATLAB as a viable simulation engine.
In the simulation engine, the user must specify which model-specific parameters are to be changed to produce a
number of trial simulations of the system in question. For each of these trials, another set of genomic variables are
swapped out, producing a set of simulations equal to (number_of_trials * number_of_genomes).

### FRAMEWORK

The SIM0 framework was written in Python 3.6. For those favoring UNIX/LINUX systems, the framework
does allow for command-line input by the user.

### USER CHANGES

The user must create a sample file of the desired simulation for the SIM0 framework. The supported
file third party programs for running these simulations and their corresponding file types are:

PROGRAM             FILE EXTENSION
MATLAB              m
Octave              octave
R                   r

Note: The third party program binary MUST be in the user's path to run the simulation properly. For
example, if running R, typing "R" into the command prompt should open the program.


In the simulation file, the user should change model-specific parameters from singular values
to randomly chosen values derived from a number of discrete and continuous probability distributions
provided. This is performed by placing desired changeable parameters between two dollar signs.

Examples:

`coefficient_1 = 0.757` -> `coefficient_1 = $gauss(0.757,0.12),name=coefficient_1$`

`coefficient_2 = 0.123` -> 'coefficient_2 = $gauss(0.123,0.414),name=coefficient_2$`

The supported probability distributions and their parameters are given below:

    DISTRIBUTION            SYNTAX                              EXAMPLE
    discrete                discrete(values...)                 $discrete(1,2,3,4),name=discrete_coefficient$
    normal/gaussian         gauss(mu,theta)                     $gauss(0,1),name=gaussian_coefficient$
    uniform                 uniform(min,max)                    $uniform(-1,1),name=uniform_coefficient$
    gamma                   gamma(k,theta)                      $gamma(1, .1),name=gamma_coefficient$
    log normal              lognormal(mu,theta)                 $lognormal(0,1),name=lognormal_coefficient$
    binomial                binomial(n,p)                       $binomial(100,.5),name=binomial_coefficient$
    poisson                 poisson(k,lambda)                   $poisson(0,1),poisson_coefficient$
    boolean (R files only)  boolean(probability_of_zero)        $boolean(.2),name=boolean_coefficient$
    mutate (R files only)   mutate(node,knockout,overexpress)   $mutate("mutation",.2,.5),name=mutation_coefficient$

These files also support the syntax $val$ and $val,name=coefficient_name$, both of which default to a
gaussian distribution with std.deviation .1. For example:

$5$ is the same as writing: $gauss(5,.1),name=coefficient1$
$5,name=gaussian_coefficient$ is the same as writing: $gauss(5,.1),name=gaussian_coefficient$

Finally, at some point in the beginning of the simulation file there should be a line declaring the variables which
change by genome, and a line referencing a genome_key file. This genome file will contain the already calculated
coefficients which will vary by genome, a separate set of coefficients than the ones which vary by trial.
The output for SIM0 is a good example of these different genome key files. Using Octave as an example:

global Gs6 Gt2 Gd12
genome1_key %This genome_key file will have the declarations for the above global variables, Gs6, Gt2, Gd12.

The genome1_key line will automatically be replaced as the genome files are cycled through and processed.


### RUNNING SIM1

Once the framework is located and placed into an appropriate depository, the user can initiate SIM1 by 
the following prompt (assuming the path is defined as well):

`python "__main__.py"`

A menu will appear in the command window. To immediately run the SIM1 environment, enter the following four
arguments into the command line:

`python __main__.py path/to/simulation_file number_of_genomes number_of_trials output_path`

`path/to/simulation_file` -> file of simulation with '$my_param$' inputted previously by user
`number_of_genomes` -> integral number of total network simulations
`number_of_trials` -> integral number of total network simulations of each of the genomic family members
`output_path` -> output path that saves the network simulations in new directory

SIM1 will then return a matrix of dimensions (number_of_genomes x number_of_trials) with elements either 0 or 1.
If any of the simulations produce questionable values or fail to run, a value of -1 will appear instead of a 0 or 1.
The resulting list/matrix can then be used for machine learning using any choice of software.

Finally a support vector machines classifier model will then be produced. Details of this model
will be expressed on the command line.

### OUTPUT FILES
In addition to the returned classification list/array, a new directory named `GenomeFiles` will be created
containing the different files pertaining to each classification. Each file title will have the form `triali_genomej`,
where 1 < i < number_of_genomes and 1 < j < number_of_trials.
The contents of each file will contain a list of parameters pertaining to each classification.

For example, using MATLAB with 10 genomes and 5 simulation trials:
50 Files total will be created:
trail1_genome1.m
...
...
trial5_genome10.m

Each one of these files should return a 0 or 1, the result of which will be used to analyze these genomes by support
vector machines.
