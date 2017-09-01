import os
import subprocess
import csv
from SupportedFileTypes import SupportedFileTypes
import collections


class ThirdPartyProgramCaller(object):

    OUTPUT_FILE_NAME = 'Sim0Output.csv'

    def __init__(self, files_directory, file_type, file_list):
        self.files_directory = files_directory
        self.file_type = file_type
        self.file_list = file_list
        self.counter = 1

    def callThirdPartyProgram(self, should_write_sim0_output):
        current_directory = os.getcwd()
        directory_of_files = self.files_directory + "/GenomeFiles"
        self.changeWorkingDirectory(directory_of_files)
        outputs = collections.OrderedDict()
        for file in self.file_list:
            file_result = []
            if self.file_type == SupportedFileTypes.MATLAB:
                file_result = self.callMATLAB(directory_of_files, file)
            elif self.file_type == SupportedFileTypes.R:
                file_result = self.callR(directory_of_files, file)
            elif self.file_type == SupportedFileTypes.OCTAVE:
                file_result = self.callOctave(directory_of_files, file)
            outputs[file.split(".")[0]] = file_result
        if should_write_sim0_output:
            self.writeOutputFile(outputs)
        self.changeWorkingDirectory(current_directory)
        return outputs

    def writeOutputFile(self, outputs):
        output_list = []
        for file in outputs.keys():
            output_list.append(outputs[file])
        with open(self.OUTPUT_FILE_NAME, 'w') as csv_file:
            try:
                outputs_writer = csv.writer(csv_file)
                outputs_writer.writerow(output_list)
            finally:
                csv_file.close()

    def changeWorkingDirectory(self, new_directory):
        os.chdir(new_directory)

    def callOctave(self, directory_of_file, call_file):
        cmd = 'octave -q ' + directory_of_file + "/" + call_file
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True, universal_newlines=True)
        (out, err) = proc.communicate()
        print(out)

        output = out.strip().split("\n")
        try:
            output = [int(i) for i in output]
        except ValueError as valueError:
            print(valueError)  # TODO: setup logging for this class.
            output = [int(-1)]
        
        return output[0]

    def callMATLAB(self, directory_of_file, call_file):
        cmd = '/Applications/MATLAB_R2017a.app/bin/matlab -nojvm -nodisplay -nosplash -nodesktop <' + directory_of_file + "/" + call_file
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True, universal_newlines=True)
        (out, err) = proc.communicate()

        first=out.index("[")
        second=out.index("]")
        output=out[first+1:second]
        print(output+": "+str(100*self.counter/self.file_list.__len__())+"% complete")
        self.counter=self.counter+1
        return int(output)

    def callR(self, directory_of_file, call_file):
        cmd = 'Rscript ' + directory_of_file + "/" + call_file
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True, universal_newlines=True)
        (out, err) = proc.communicate()
        pos = out.index("]")
        output = out[pos + 2]
        print(output+": "+str(100*self.counter/self.file_list.__len__())+"% complete")
        self.counter=self.counter+1
        return int(output)


