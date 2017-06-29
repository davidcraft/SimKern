import os
#output goes to stdout:
#cmd = 'octave -q myApoCall.m'
#or if you want to write a file instead, called myout.txt for example, use:
cmd = 'octave -q myApoCall.m > myout.txt'
os.system(cmd)

