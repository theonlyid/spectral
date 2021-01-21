"""
Python setup script that outputs Matlab.bat for running Matlab with anaconda dependencies.

Must be run with the Anaconda shell prompt. See README Appendix A1 for details.

@author: Ali Zaidi
@version: 0.1
"""

import os
import pytest
from shutil import which

a = which('conda.exe')
if a is None: print('Critical Error! Anaconda installation not found! Exiting...'); exit()
if 'Scripts' in a:
    path_val = os.path.split(a)
    conda_activate = os.path.join(path_val[0], 'activate.bat')
    if not os.path.isfile(conda_activate):
        print("Critical Error! \"activate.bat\" not found. exiting..."); exit()


b = which('matlab.exe')
if 'R2019b' in b:
    matpath = b
    if not os.path.isfile(matpath):
        print("Critical Error! Matlab R2019b not found, exiting..."); exit()

root_dir = os.getcwd()

pydir = which('python.exe')

# Write files to test.txt
with open('matlab.bat', 'w+') as f:
    f.write("call \"{}\"\n".format(conda_activate))
    f.write("start \"\" /D {} \"{}\"\n".format(root_dir, matpath))

print("\nPerforming diganostic tests...\n")
res = pytest.main()

if res==0:
    print("\nSuccess!\n".upper())
    print("Please copy the statement below to the clipboard:\n")
    print("pyversion(\"{}\")".format(pydir))
    print("\nRun Matlab using 'Matlab.bat', paste the command and press enter.\n")
else: print("Critical Error! Diagnostic test failed. Setup did not complete successfully.")