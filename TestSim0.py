#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 29 15:04:29 2017

@author: taylorsorenson
"""



#TODO: This test has been moved to ThirdPartyProgramCallerIT
#TESTING Sim0

import os
import time
from FileProcessingService import FileProcessingService
from Sim1FileProcessingService import Sim1FileProcessingService
from ThirdPartyProgramCaller import ThirdPartyProgramCaller

def sim0test():
    #f = open('Testing/TFiles/apopOctaveTest.m.t','r')
    f = open('Testing/SampleDataFiles/sen2.m.t', 'r')
    file_type = 'm'
    file_processing_service = FileProcessingService(f, 'm', 4, os.getcwd())
    fileList = file_processing_service.createGenomes()[0]
    ProgramCaller = ThirdPartyProgramCaller(os.getcwd(),'m',fileList)
    output = ProgramCaller.callThirdPartyProgram(False)
    return output


#TESTING Sim1
def sim1test():
    dot_u_file = open('Testing/SampleDataFiles/sen2.m.u', 'r')
    Sim1file_processing_service = Sim1FileProcessingService(dot_u_file, 'm', 4, 4,path = os.getcwd())
    Sim1FileList = Sim1file_processing_service.createTrialFiles()
    # run_simulation_readGenome = open(os.getcwd() + '/sim1/run_simulation_readGenome.m.u')
    octave_caller = ThirdPartyProgramCaller(os.getcwd(),'m',Sim1FileList)
    Sim1Outputs = octave_caller.callThirdPartyProgram(True)
    dot_u_file.close()
    return Sim1Outputs



if __name__ == '__main__':
    begin = time.time()
    print(sim0test())
    print(sim1test())
    end = time.time()
    print("Total time to run: ", (end-begin), 'seconds')
    # sim1test()


