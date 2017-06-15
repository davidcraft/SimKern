#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 15 11:08:55 2017

@author: taylorsorenson
"""

import numpy as np
import string 
#from Graph import *

#Function of Module: Reads in text file of Dif. Eqs., performing two main 
#functions 1) creating the nodes, edges and overall graph as well as 
#2)Setting up the differential equations to be solved

#Read in text file of parameters, making them all into variables (place into
#dictionary?)

def read_parameters(filename):
    '''Reads in a text file, containing the rate constants and other parameters
    needed for the Cell Cycle Diff Eq's
    
    Returns a dictionary (called parameters) with each key:values pair as the
    parameter_name:parameter_value. parameter_name is a string, parameter_value
    is a float
    '''
    variables, values, parameters = [], [], {}
    with open(filename, 'r') as f:
        data_lines = f.readlines()[9:]
        for line in data_lines:
            content = line.split(sep='=')
            variables.append(content[0])
            values.append(content[-1][:-2])
    values = list(map(float, values[:-1]))
    for i in range(len(values)):
        parameters[variables[i]] = values[i]
    return parameters #a dictionary mapping 

#parameters = read_parameters('cellcycleparameters.rtf')
#try:
#    i = read_parameters('ccinitcond.rtf')
#except:
#    print('someting wong')


def read_DE(filename):
    '''Reads in a text file containing the differential equation and variables
    found within a textfile
    '''
    pass

def read_init_cond(filename):
    '''
    '''
        
        
