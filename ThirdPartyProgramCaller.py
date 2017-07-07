import os
import subprocess
import csv
from SupportedFileTypes import SupportedFileTypes


class ThirdPartyProgramCaller(object):

    OUTPUT_FILE_NAME = 'Sim0Output.csv'

    def __init__(self, files_directory, file_type):
        self.files_directory = files_directory
        self.file_type = file_type

    def callThirdPartyProgram(self):
        if self.file_type == SupportedFileTypes.MATLAB:
            return self.writeOutputFileForOctave()
        else:
            return []

    def writeOutputFileForOctave(self):
        current_directory = os.getcwd()
        directory_of_m_call_file = self.files_directory + "/GenomeFiles"
        self.changeWorkingDirectory(directory_of_m_call_file)
        output = self.callOctave(directory_of_m_call_file)
        with open(self.OUTPUT_FILE_NAME, 'w') as csv_file:
            try:
                outputs_writer = csv.writer(csv_file)
                outputs_writer.writerow(output)
            finally:
                csv_file.close()
        self.changeWorkingDirectory(current_directory)
        return output

    def changeWorkingDirectory(self, new_directory):
        os.chdir(new_directory)

    def callOctave(self, directory_of_mCallFile, callFile):
        cmd = 'octave -q ' + directory_of_mCallFile + "/" + callFile
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True, universal_newlines=True)
        (out, err) = proc.communicate()
        print(out)

        output = out.strip().split("\n")
        try:
            output = [int(i) for i in output]
        except ValueError as valueError:
            print(valueError.message) # TODO: setup logging for this class.
            output = []

        return output