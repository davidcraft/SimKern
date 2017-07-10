# SIM0

# INTRODUCTION
SIM0 is defined as a simulation enviornment that produces a data set similar to an
experimental data set that can be used for machine learning. Appliciable to complex
networks that exhibit certain dynamics, SIM0 will create a specified number of datasets
based upon model-specific parameter variation. 

# REQUIREMENTS
The SIM0 framework currently supports MATLAB and Octave as viable simulation engines. We have not
yet extended the framework to consider logical or qualitative simulation engines.
In the simulation engine, the user must specify which model-specific parameters are to be altered by
placing dollar signs at the start and end of the parameter definition. The user has a choice of a number of
discrete and continuous probability distributions that can be used to generate a given number of different 
models.

Example (MATLAB): my_param = 0.5 -> $my_param = normrnd(0.5,0.1)$ - Normally distributed parameter with mean 0.5 and standard 
deviation 0.1.

# FRAMEWORK
The SIM0 framework was written in Python 3.6 and tested using Octave. For those favoring UNIX/LINUX systems, the framework
does allow for command-line input by the user. 




