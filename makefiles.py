#!/usr/bin/env python
import numpy as np
import pandas as pd
import os
import sys
import subprocess
from shutil import copyfile

os.chdir("slurm_changes/src/plugins/select/linear")
print(os.getcwd())
copyfile('Makefile', 'Makefile_default')
copyfile('Makefile', 'Makefile_greedy')
copyfile('Makefile', 'Makefile_bal')
copyfile('Makefile', 'Makefile_ada')

default = open('Makefile_default','w+')
greedy = open('Makefile_greedy','w+')
bal = open('Makefile_bal','w+')
ada = open('Makefile_ada','w+')
makefile= open('Makefile','r')

line = makefile.readline()
while line:
    try:
        data = line.split()
        if data[0] !='CFLAGS':
            default.write(line)
            greedy.write(line)
            bal.write(line)
            ada.write(line)

        else:
            if data[-1] == '-fno-strict-aliasing':
                default.write(line)
                greedy.write(line.rstrip()+" -DJOBAWARE\n")
                bal.write(line.rstrip()+" -DJOBAWARE1\n")
                ada.write(line.rstrip()+" -DJOBAWARE2\n")
            else:
                default.write(line.rstrip().rsplit(' ', 1)[0]+"\n")
                greedy.write(line.rstrip().rsplit(' ', 1)[0]+" -DJOBAWARE\n")
                bal.write(line.rstrip().rsplit(' ', 1)[0]+" -DJOBAWARE1\n")
                ada.write(line.rstrip().rsplit(' ', 1)[0]+" -DJOBAWARE2\n")
    except:
        default.write(line)
        greedy.write(line)
        bal.write(line)
        ada.write(line)
   
    line = makefile.readline()

default.close()
greedy.close()
bal.close()
ada.close()
makefile.close()
