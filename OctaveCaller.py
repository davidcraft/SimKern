import os
import subprocess
import csv

class OctaveCaller(object):


    def __init__(self, caller_file_name, output_file_name, cmd_path = '/Applications/Octave.app/Contents/Resources/usr/bin/octave -q'):
        self.caller_file_name = caller_file_name
        self.output_file_name = output_file_name
        self.cmd_path = cmd_path

    def callOctave(self):
        work_dir = os.getcwd()
        #might want to change dir by using os.chdir(r'/Users/zhaoqiwang/Desktop')
#       os.chdir(r'/GenomeFiles')
        cmd = self.cmd_path + ' '+ self.caller_file_name
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True, universal_newlines=True)
        (out, err) = proc.communicate()
        print(out)

        output = out.strip().split("\n")
        output = [int(i) for i in output]
        return output

    def writeOutputFile(self):
        output = self.callOctave()
        with open(self.output_file_name , 'w') as csvfile:
            outputs_writer = csv.writer(csvfile)
            outputs_writer.writerow(output)

#test:
x = OctaveCaller('myApoCall.m', 'outfile.csv')
print(x.callOctave())
x.writeOutputFile()
