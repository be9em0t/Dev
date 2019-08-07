#!python2

#Usage:
#In Total Commander set button "...CopyCurrentToMulti.py" with parameters "%P " "%T " (note the spaces before trailing ")
# Copy the contents of current folder (panel) to all folders in the opposite panel


#import Tkinter, tkMessageBox, tkFileDialog #tkSimpleDialog, 
import os, subprocess, time, sys, shutil, ConfigParser
import errno, re
from distutils.dir_util import copy_tree


currdir = os.getcwd()

def copyContentsToMulti(sourceRoot, targetRoot):
    for root, dirs, files in os.walk(targetRoot, topdown=True):
        if (root == targetRoot):
            for name in dirs:
                targetName = os.path.join(root, name)
                print(targetName)
                copy_tree(sourceRoot, targetName)


#print "source " + sys.argv[1]
#print "\ntarget " + sys.argv[2]
sourceDir = sys.argv[1]
targetDir = sys.argv[2]  #r"c:\Work\OneDrive\Work\TomTom\scenes\SCRIPT test\TestTarget"
#print sourceDir + "\n" + targetDir
copyContentsToMulti(sourceDir, targetDir)

raw_input("\nFinished. Press Enter...")
