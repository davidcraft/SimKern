#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 29 15:04:29 2017

@author: taylorsorenson
"""
#TODO: This test has been moved to ThirdPartyProgramCallerIT
#TESTING Sim0

import os
from FileProcessingService import FileProcessingService
from Sim1FileProcessingService import Sim1FileProcessingService
from ThirdPartyProgramCaller import ThirdPartyProgramCaller

#f = open('Testing/TFiles/apopOctaveTest.m.t','r')
f = open('Testing/SampleDataFiles/rso.m.t', 'r')
file_type = 'm'
file_processing_service = FileProcessingService(f, 'm', 10, os.getcwd())
fileList = file_processing_service.createGenomes()

# test = ThirdPartyProgramCaller(os.getcwd(), file_type)
# # test.callOctave()
# test.callThirdPartyProgram()



#TESTING Sim1
dot_u_file = open('sim1/run_simulation_readGenome.m.u', 'r')
Sim1file_processing_service = Sim1FileProcessingService(dot_u_file, 'm', 10, 6,path = os.getcwd())
Sim1FileList = Sim1file_processing_service.createTrialFiles()
# run_simulation_readGenome = open(os.getcwd() + '/sim1/run_simulation_readGenome.m.u')
octave_caller = ThirdPartyProgramCaller('GenomeFiles','m',Sim1FileList)
Sim1Outputs = octave_caller.getSim1Responses()
dot_u_file.close()




