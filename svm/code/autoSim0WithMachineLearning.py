from __future__ import division
from FileProcessingService import FileProcessingService
from ThirdPartyProgramCaller import ThirdPartyProgramCaller
from svmRunner import runSvm
import os


def runSim0WithSVM(file, file_type, num_genomes, path, kernel_type, pct_train):
    file_processor = FileProcessingService(file, file_type, num_genomes, path)
    genome_file_list, genomes_matrix = file_processor.createGenomes()
    program_caller = ThirdPartyProgramCaller(path, file_type, genome_file_list)
    responses = program_caller.callThirdPartyProgram(False) #Note - a dictionary
    # por_success = sum(responses)/responses.__len__()
    por_success = sum(responses.values())/len(responses.values())
    print(str(100*por_success) + " percent 1s \n" + str(100*(1-por_success)) + " percent 0s")
    runSvm(responses.values, genomes_matrix, kernel_type, pct_train)
