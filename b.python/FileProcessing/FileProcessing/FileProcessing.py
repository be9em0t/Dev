#!python2

#TODO
# in TotalCommander
# Copy the contents of current folder (panel) to all folders in the opposite panel

#import Tkinter, tkMessageBox, tkFileDialog #tkSimpleDialog, 
import os, subprocess, time, sys, shutil, ConfigParser
import errno, re
from distutils.dir_util import copy_tree


currdir = os.getcwd()

def checkDirFiles(dir, fileList=[]):
    #print len(fileList)
    for file in fileList: 
        file = os.path.normpath(dir + "\\" + file)
        #print file
        if (os.path.exists(file)) == False:
            return False
            #tkMessageBox.showinfo(title="TT AutoExport", message="File " + file + "\ndoes not exist!")
            #sys.exit()
    return True


def walkFiles(startdir, filetype): #filetype ".bmp"
    for dirname, dirnames, filenames in os.walk('.'):
        ## print path to all subdirectories first.
        for subdirname in dirnames:
            print(os.path.join(dirname, subdirname))

        ## do for all filenames.
        #for filename in filenames:
        #    extension = os.path.splitext(filename)[1]
        #    if filetype in filename:
        #        file = os.path.join(dirname, filename)
        #        print(file) + " -> " + currdir
        #        #shutil.copy2(file, currdir)

        #    #if extension == filetype:
        #    #    file = os.path.join(dirname, filename)
        #    #    print(file) + "->" + "."
        #    #    #shutil.copy2(name, ".")

def walkCurrentDir(startdir):
    for root, dirs, files in os.walk(startdir, topdown=True):
        if (root == startdir):
            #print root
            for name in dirs:
                print(os.path.join(root, name))
                copy_tree(name, targetDir)
                #shutil.copytree(name, targetDir, ignore=None)
        #for name in files:
        #    print(os.path.join(root, name))
        #for name in dirs:
        #    print(os.path.join(root, name))

#=========== copy source to multiple targets ===========
def copyContentsToMulti(sourceRoot, targetRoot):
    for root, dirs, files in os.walk(targetRoot, topdown=True):
        if (root == targetRoot):
            for name in dirs:
                targetName = os.path.join(root, name)
                print(targetName)
                copy_tree(sourceRoot, targetName)

print "source " + sys.argv[1]
print "\ntarget " + sys.argv[2]
sourceDir = sys.argv[1]
targetDir = sys.argv[2]  #r"c:\Work\OneDrive\Work\TomTom\scenes\SCRIPT test\TestTarget"
print sourceDir + "\n" + targetDir
copyContentsToMulti(sourceDir, targetDir)
#===========

#print currdir
#walkFiles(currdir, ".jpg")
#walkCurrentDir(currdir)

#print  len(sys.argv)
#print sys.argv


raw_input("\nFinished. Press Enter...")



####Soure dir parsing
#for root, dirs, files in os.walk(sourceDir):
#    path = root.split('/')
#    print os.path.abspath(root) 
#    for file in files:
#        #extension = os.path.splitext(file)[1]
#        #print extension
#        print os.path.abspath(file)

##template: dir structure parsing
for root, dirs, files in os.walk(sourceDir):
    path = root.split('/')
    print os.path.abspath(root) 
    for file in files:
        #extension = os.path.splitext(file)[1]
        #print extension
        print os.path.abspath(file)


        #print "Path_Source: " + path + " | Dir: " + os.path.join(path,dir)
        #print path
        
