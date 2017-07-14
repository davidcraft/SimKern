from FileProcessingService import FileProcessingService
from ThirdPartyProgramCaller import ThirdPartyProgramCaller
from svmRunner import runSvm

def runSim0WithSVM(file, file_type, num_genomes, path, kernel_type, pct_train):
    file_processor = FileProcessingService(file, file_type, num_genomes, path)
    [genome_file_list, genomes_matrix] = file_processor.createGenomes()
    program_caller = ThirdPartyProgramCaller(path, file_type, genome_file_list)
    responses = program_caller.callThirdPartyProgram()
    runSvm(responses, genomes_matrix, kernel_type, pct_train)
