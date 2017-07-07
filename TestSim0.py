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
from ThirdPartyProgramCaller import ThirdPartyProgramCaller

#f = open('Testing/TFiles/apopOctaveTest.m.t','r')
f = open('Testing/SampleDataFiles/apopOctaveTest.m.t', 'r')
file_type = 'm'
file_processing_service = FileProcessingService(f, 'm', 10, os.getcwd())
fileList = file_processing_service.createGenomePermutations()

test = ThirdPartyProgramCaller(os.getcwd(), file_type)
# test.callOctave()
test.callThirdPartyProgram()


#TESTING Sim1
f = open('Testing/SampleDataFiles/apopOctaveTest.m.t', 'r')
file_processing_service = FileProcessingService(f, 'm', 10, os.getcwd())
GenomeFileList = file_processing_service.createGenomePermutations()
run_simulation_readGenome = open(os.getcwd()+ '/sim1/run_simulation_readGenome.m.u')
R = 20
sim1_processing = FileProcessingService(run_simulation_readGenome,'m',R,os.getcwd())
#TODO - where are these
sim1_processing.createGenomePermutations()