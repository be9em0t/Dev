#!python2

#Usage:
#In Total Commander set button "...TT_LM_ImageDir.py" with parameters "%P " "%T " (note the spaces before trailing ")
#select for source dir an existing directory containing the images saved from Photoshop  (i.e. "~\Desktop\")
#select for target dir an existing LM Image folder

import os, sys, shutil

sourceDir = ((sys.argv[1]).rstrip()).rstrip("\\") #r"c:\Work\OneDrive\Work\TomTom\scenes\2016\Script Image Dir\desktop" 
targetDir = ((sys.argv[2]).rstrip()).rstrip("\\")  #r"c:\Work\OneDrive\Work\TomTom\scenes\2016\Script Image Dir\image" 
# sourceDir = r"c:\Users\vla\Desktop" 
# targetDir = r"c:\Work\OneDrive\Work\TomTom\scenes\2016\kor_gsn_2016_2017_01_05_Delivery\kor_gsn_2016\kor_gsn_2016\kor_gsn_031\image" 
errLvl = 0

# Get LM name from path
targSplit = targetDir.split("\\")
print targSplit
stringLMname = targSplit[ len(targSplit) -2 ]
listSourceCheck = ["1.jpg", "2.jpg", "3.jpg","info.jpg", "screenshot.jpg"] 
listTargetCheck = ["dsc_1.jpg", "dsc_2.jpg", "info.jpg", (stringLMname + ".jpg"), (stringLMname) + "_screenshot.jpg"]

listSourceFiles = []
listTargetFiles = []

print ("==========")
print("sourceDir: " + sourceDir)
print("targetDir: " + targetDir)
print("LM Name: " + stringLMname)
print ("==========")

### custom Command Line input routine
def GetUserInput(question, y, n):
    userChoice = 0
    print question
    userStr = raw_input()
    if userStr in n:
        userChoice=0
    elif userStr in y:
        userChoice=1
    else:
        userChoice=2
    return userChoice

### Bail out on source / target error
def bailOutCheck():
   global errLvl
   if errLvl == 1:
      print "============="
      print "I quit in desperation :("
      input("Press Enter to Exit...")
      sys.exit()
      #  r = GetUserInput("Errors found. Exit script, Yes/No?",["y","Y","yes","YES"],["n","N","no","NO"])
      #  if r==1:
         #   sys.exit()

# Get a list of source dir files
for filename in os.listdir(sourceDir):
   listSourceFiles.append(filename)

# Get a list of target dir files
for filename in os.listdir(targetDir):
   listTargetFiles.append(filename)

if len(listTargetFiles) <> 5:
   print "Wrong number of files in target directory"
   input("Press Enter to Exit...")
   sys.exit()



# Verify that checkList exists in list
def listCheck(checkList, listContents):
   global errLvl
   for item in checkList:
      if not (item in listContents):
         errLvl = 1
         print item + " is missing!"

# Verify correct files exist in source and target dirs
listCheck(listSourceCheck, listSourceFiles)
listCheck(listTargetCheck, listTargetFiles)

bailOutCheck()
# Move source files to target dir, rename and overwrite

# Move files
def listMove(checkList, listContents):
   global errLvl
   for item in checkList:
      if (item == listSourceCheck[0]):    #1.jpg
         srcFile = os.path.join(sourceDir, item)    #"\"" + sourceDir + "\\" + item + "\""
         tgtFile = os.path.join(targetDir, listTargetCheck[0])    #"\"" + targetDir + "\\" + item + "\""
         shutil.move(srcFile, tgtFile)
	   #shutil.copy(srcFile, tgtFile)
         # print "copy " + srcFile + " to " + tgtFile
      elif (item == listSourceCheck[1]):    #2.jpg
         srcFile = os.path.join(sourceDir, item)    #"\"" + sourceDir + "\\" + item + "\""
         tgtFile = os.path.join(targetDir, listTargetCheck[1])    #"\"" + targetDir + "\\" + item + "\""
         shutil.move(srcFile, tgtFile)
         # print "copy " + srcFile + " to " + tgtFile
      elif (item == listSourceCheck[2]):    #3.jpg
         srcFile = os.path.join(sourceDir, item)    #"\"" + sourceDir + "\\" + item + "\""
         tgtFile = os.path.join(targetDir, listTargetCheck[3])    #"\"" + targetDir + "\\" + item + "\""
         shutil.move(srcFile, tgtFile)
         # print "copy " + srcFile + " to " + tgtFile
      elif (item == listSourceCheck[3]):    #info.jpg
         srcFile = os.path.join(sourceDir, item)    #"\"" + sourceDir + "\\" + item + "\""
         tgtFile = os.path.join(targetDir, item)    #"\"" + targetDir + "\\" + item + "\""
         shutil.move(srcFile, tgtFile)
         # print "copy " + srcFile + " to " + tgtFile
      elif (item == listSourceCheck[4]):    #screenshot.jpg
         srcFile = os.path.join(sourceDir, item)    #"\"" + sourceDir + "\\" + item + "\""
         tgtFile = os.path.join(targetDir, listTargetCheck[4])    #"\"" + targetDir + "\\" + item + "\""
         shutil.move(srcFile, tgtFile)
         # print "copy " + srcFile + " to " + tgtFile

listMove(listSourceCheck, listSourceFiles)

# def moveFile(src, tgt):
#    srcFile = sourceDir + "\\" + src
#    tgtFile = targetDir + "\\" + tgt
#    shutil.copy(srcFile, tgtFile)

   # copyTarget = directoryJV + r"\200x216\psd\\" + os.path.basename(p)[0:15] + ".psd"
   # os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))






# print (str(len(listSourceFiles)) + " : " + str(listSourceFiles))
# print (str(len(listTargetFiles)) + " : " + str(listSourceFiles))