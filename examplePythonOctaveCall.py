# import os
# #output goes to stdout:
# #cmd = 'octave -q myApoCall.m'
# #or if you want to write a file instead, called myout.txt for example, use:
# cmd = '/Applications/Octave.app/Contents/Resources/usr/bin/octave -q myApoCall.m > myout.txt'
# #cmd1 = 'open /Users/zhaoqiwang/Desktop/test.m -a Octave'
# os.system(cmd)

import subprocess
cmd = '/Applications/Octave.app/Contents/Resources/usr/bin/octave -q myApoCall.m'
proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
(out, err) = proc.communicate()
print ("octave output:", int(out))