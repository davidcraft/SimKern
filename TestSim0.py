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
