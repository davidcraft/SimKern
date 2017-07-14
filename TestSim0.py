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

def sim0test():
    #f = open('Testing/TFiles/apopOctaveTest.m.t','r')
    f = open('Testing/SampleDataFiles/sen.m.t', 'r')
    file_type = 'm'
    file_processing_service = FileProcessingService(f, 'm', 80, os.getcwd())
    fileList = file_processing_service.createGenomes()
    return fileList
    ProgramCaller = ThirdPartyProgramCaller(os.getcwd() + '/GenomeFiles', 'genome6.m')
    output = ProgramCaller.callOctave()
    ProgramCaller.callThirdPartyProgram()
    print(output)


#TESTING Sim1
def sim1test():
    dot_u_file = open('Testing/SampleDataFiles/sen.m.t', 'r')
    Sim1file_processing_service = Sim1FileProcessingService(dot_u_file, 'm', 10, 6,path = os.getcwd())
    Sim1FileList = Sim1file_processing_service.createTrialFiles()
    # run_simulation_readGenome = open(os.getcwd() + '/sim1/run_simulation_readGenome.m.u')
    octave_caller = ThirdPartyProgramCaller('GenomeFiles','m',Sim1FileList)
    Sim1Outputs = octave_caller.getSim1Responses()
    dot_u_file.close()



if __name__ == '__main__':
    sim0test()
    # sim1test()


