import os
import subprocess

class OctaveCaller(object):
    def __init__(self,file_name,output_file_name):
        self.file_name = file_name
        self.output_file_name = output_file_name

    def callOctave(self):
        for mfile in range(len(self.file_name))
            #might want to change dir by using os.chdir(r'/Users/zhaoqiwang/Desktop')
            cmd = '/Applications/Octave.app/Contents/Resources/usr/bin/octave -q myApoCall.m'
            proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
            (out, err) = proc.communicate()
            int(out)

#output goes to stdout:
#cmd = 'octave -q myApoCall.m'
#or if you want to write a file instead, called myout.txt for example, use:
cmd = '/Applications/Octave.app/Contents/Resources/usr/bin/octave -q myApoCall.m > myout.txt'

#cmd1 = 'open /Users/zhaoqiwang/Desktop/test.m -a Octave'
os.system(cmd)

