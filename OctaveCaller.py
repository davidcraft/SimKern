import os
import subprocess
import csv

class OctaveCaller(object):
    def __init__(self,file_name,output_file_name,cmd_path = '/Applications/Octave.app/Contents/Resources/usr/bin/octave -q'):
        self.file_name = file_name
        self.output_file_name = output_file_name
        self.cmd_path = cmd_path

    def callOctave(self):
        self.outputs = []
        for mfile in self.file_name:
            #might want to change dir by using os.chdir(r'/Users/zhaoqiwang/Desktop')
            cmd = self.cmd_path + ' '+ mfile
            proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
            (out, err) = proc.communicate()
            output = int(out)
            self.outputs.append(output)
        return self.outputs

    def writeOutputFile(self):
        with open(self.output_file_name , 'w') as csvfile:
            print(self.outputs)
            outputs_writer = csv.writer(csvfile)
            outputs_writer.writerow(self.outputs)

#test:
# x = OctaveCaller(['myApoCall.m'],'outfile.csv')
# print(x.callOctave())
#
# x.writeOutputFile()
