#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 29 15:04:29 2017

@author: taylorsorenson
"""

#TESTING Sim0
    
from FileProcessingService import FileProcessingService 
from OctaveCaller import OctaveCaller 

#f = open('Testing/TFiles/apopOctaveTest.m.t','r')
f = open('apopOctaveTest.m.t','r')
FileProcess = FileProcessingService(f,'MAT',10)
fileList = FileProcess.handleOctaveOrMATLABFile()

test = OctaveCaller('mCallFile.m','Sim0Output.csv')
test.callOctave()
test.writeOutputFile()