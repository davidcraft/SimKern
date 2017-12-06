# SIM0

### INTRODUCTION
SIM0 is defined as a simulation environment that produces a data set similar to an
experimental data set which can be used for machine learning. SIM0 will create a specified number
of files based upon model-specific parameter variation.

### REQUIREMENTS
The SIM0 framework successfully handles R, Octave and MATLAB as viable simulation engines.
In the simulation engine, the user must specify which model-specific parameters are to be changed to
produce a total number of K simulations of the system in question.

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


### RUNNING SIM0
The user can initiate SIM0 by the following prompt:

`python "__main__.py"`

A menu will appear in the command window. Type "0" to select SIM0. The menu will then request 3
parameters: the path of the simulation file, the number of genomes to simulate, and output path

To immediately run the SIM0 environment, call the __main__.py file with three arguments:

`python __main__.py path/to/simulation_file number_of_genomes output_path`

`path/to/simulation_file` -> text file of simulation with '$my_param$' inputted previously by user

`number_of_genomes` -> integral number of total network simulations

`output_path` -> output path that saves the network simulations. Cannot be root.

### OUTPUT FILES
SIM0 will then return a classification list/array of of length equal to the input number_of_genomes
with elements corresponding to the results from the third party program calls.

In addition to the returned classification list/array, a new directory named
`GenomeFiles` will be created containing the different files pertaining to each classification.
Each produced genome also contains a key file which will detail the coefficients replaced for each.

For example, using MATLAB with 50 genomes created:
100 Files total will be created:
50 of which will be the modified simulation file and have the form `genomei.m`,
50 of which will be _key files detailing the replaced coefficients and have the form genomei_key.m
In each case 0 < i <= 50.

