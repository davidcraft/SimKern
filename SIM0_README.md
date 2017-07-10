# SIM0

# INTRODUCTION
SIM0 is defined as a simulation enviornment that produces a data set similar to an
experimental data set that can be used for machine learning. Appliciable to complex
networks that exhibit certain dynamics, SIM0 will create a specified number of datasets
based upon model-specific parameter variation. In order to run machine learning, each dataset will be classified as a binary
value (0 or 1) based upon specific network dynamics. 

# REQUIREMENTS
The SIM0 framework currently supports MATLAB and Octave as viable simulation engines. We have not
yet extended the framework to consider logical or qualitative simulation engines.
In the simulation engine, the user must specify which model-specific parameters are to be changed to produce a total number
of K simulations of the system in question.

# FRAMEWORK
The SIM0 framework was written in Python 3.6 and tested using Octave. For those favoring UNIX/LINUX systems, the framework
does allow for command-line input by the user. 

# USER CHANGES
The user must create a text file of the desired simulation for the SIM0 framework. We have denoted this text file by 
adding the ".t" after the simulation file:

(MATLAB/Octave): my_simulation.m -> my_simulation.m.t

In the simulation text file, the user should change model-specific parameters from singular values to randomly chosen
values derived from a number of discrete and continuous probability distributions provided. 

Example (MATLAB): my_param = 0.757 -> $my_param = normrnd(0.757,0.12)$






