#Usage:
#In Total Commander set button "...RenMultipleDirs.py" with parameter "%P "  (note the spaces before trailing ")
# searches subdirs for directory named DIR_TO_PROCESS 
# moves its contents one level up 
# deletes directory DIR_TO_PROCESS


#import Tkinter, tkMessageBox, tkFileDialog #tkSimpleDialog, 
import os, subprocess, time, sys, shutil, ConfigParser
import errno, re
import distutils.dir_util


currdir = os.getcwd()
DIR_TO_PROCESS = "320x240"
sourceDir = ((sys.argv[1]).rstrip()).rstrip("\\") 
# targetDir = ((sys.argv[2]).rstrip()).rstrip("\\")  #r"c:\Work\OneDrive\Work\TomTom\scenes\SCRIPT test\2DJVLOD\FolderStructure" 


def moveLevelUp(sourceRoot):
  for root, dirs, files in os.walk(sourceRoot, topdown=True):
    for dir in dirs:
      if (dir == DIR_TO_PROCESS):
        dirName = os.path.join(root, dir)
        print dirName + " | " + dirName.rstrip(DIR_TO_PROCESS)
        distutils.dir_util.copy_tree((dirName), dirName.rstrip(DIR_TO_PROCESS))
        distutils.dir_util.remove_tree((dirName))


moveLevelUp(sourceDir)

raw_input("\nFinished. Press Enter...")
