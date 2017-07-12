import os
import subprocess
import csv
import re
from SupportedFileTypes import SupportedFileTypes


class ThirdPartyProgramCaller(object):

    OUTPUT_FILE_NAME = 'Sim0Output.csv'

    def __init__(self, files_directory, file_type, file_list):
        self.files_directory = files_directory
        self.file_type = file_type
        self.file_list = file_list

    def callThirdPartyProgram(self):
        if self.file_type == SupportedFileTypes.MATLAB:
            return self.writeOutputFileForOctave()
        elif self.file_type == SupportedFileTypes.R:
            return self.writeOutputFileForR()
        else:
            return []

    def writeOutputFileForOctave(self):
        current_directory = os.getcwd()
        directory_of_files = self.files_directory + "/GenomeFiles"
        self.changeWorkingDirectory(directory_of_files)
        outputs=[]
        for file in self.file_list:
            result= self.callOctave(directory_of_files, file)
            outputs.append(result)
        with open(self.OUTPUT_FILE_NAME, 'w') as csv_file:
            try:
                outputs_writer = csv.writer(csv_file)
                outputs_writer.writerow(outputs)
            finally:
                csv_file.close()
        self.changeWorkingDirectory(current_directory)
        return outputs

    def writeOutputFileForR(self):
        current_directory = os.getcwd()
        directory_of_files = self.files_directory + "/GenomeFiles"
        self.changeWorkingDirectory(directory_of_files)
        outputs = []
        for file in self.file_list:
            result = self.callR(directory_of_files, file)
            outputs.append(result)
        with open(self.OUTPUT_FILE_NAME, 'w') as csv_file:
            try:
                outputs_writer = csv.writer(csv_file)
                outputs_writer.writerow(outputs)
            finally:
                csv_file.close()
        self.changeWorkingDirectory(current_directory)
        return outputs

    def changeWorkingDirectory(self, new_directory):
        os.chdir(new_directory)

    def callOctave(self, directory_of_file, callFile):
        cmd = 'octave -q ' + directory_of_file + "/" + callFile
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True, universal_newlines=True)
        (out, err) = proc.communicate()
        print(out)

        output = out.strip().split("\n")
        try:
            output = [int(i) for i in output]
        except ValueError as valueError:
            print(valueError.message)  # TODO: setup logging for this class.
            output = [int(-1)]

        return output[0]

    def callR(self, directory_of_file, callFile):
        cmd = 'Rscript ' + directory_of_file + "/" + callFile
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True, universal_newlines=True)
        (out, err) = proc.communicate()
        pos = out.index("]")
        output = out[pos + 2]
        print(output)
        return int(output)

    def getSim1Responses(self):
        current_directory = os.getcwd()
        directory_of_files = self.files_directory  + "/GenomeFiles"
        self.changeWorkingDirectory(directory_of_files)
        outputs = []
        for file in self.file_list:
            result = self.callOctave(directory_of_files, file)
            outputs.append(result)
        self.changeWorkingDirectory(current_directory)
        return outputs
