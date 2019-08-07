#!python2

#Usage:
#In Total Commander set button "...TT_JVLOD2_populate.py" with parameters "%P " "%T " (note the spaces before trailing ")
#select for source dir an existing directory containing the results from Photoshop Action (i.e. "c:\Work\BATCH\")
#select for target dir an empty folder

import os, sys, shutil

sourceDir = ((sys.argv[1]).rstrip()).rstrip("\\") #r"c:\Work\BATCH" 
targetDir = ((sys.argv[2]).rstrip()).rstrip("\\")  #r"c:\Work\OneDrive\Work\TomTom\scenes\SCRIPT test\2DJVLOD\FolderStructure" 

masterPSDs = [] # master PSDs (usually 2 for each JV)
masterJVs = [] # master JV folder (derived from master PSD names)
source200PSDs = []
source320PSDs = []
source200BMPs = []
source320BMPs = []
errLvl = 0

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

#r = GetUserInput("Yes/No?",["y","Y","yes","YES"],["n","N","no","NO"])
#print r

### routine to convert pathnames with spaces into enclosed with "" pathnames
def genLongName(inPathName):
    outPathName = "\"" + inPathName + "\""
    return outPathName


### Verify main source folders exist
for path,dirs,files in os.walk(sourceDir):
    if path == sourceDir:
        print dirs
        if '200' not in dirs: 
            print "Source Folder 200 missing\n"
            errLvl = 1
        elif '320' not in dirs: 
            print "Source Folder 320 missing\n"
            errLvl = 1
        elif '3dsceneMasters' not in dirs: 
            print "Source Folder 3dsceneMasters missing\n"
            errLvl = 1
        else:
            print "Source Folder seems OK\n"

### Verify target folder exists and is empty
print "Targetdir: " + targetDir
for path,dirs,files in os.walk(targetDir):
    errLvlTarg = 0
    if dirs:        
        print path + " not empty\n"
        errLvlTarg = 1
    if files:
        print path, 'has files\n'
        errLvlTarg = 1
    if errLvlTarg == 0:
        print "Target Folder seems OK\n"
    else:
        errLvl = 1
        break

### Bail out on source / target error
if errLvl == 1:
    r = GetUserInput("Errors found. Exit script, Yes/No?",["y","Y","yes","YES"],["n","N","no","NO"])
    if r==1:
        sys.exit()

### Parse source files
for path,dirs,files in os.walk(sourceDir):
    for filename in files:
        if path == sourceDir + r"\3dsceneMasters":
            ## check only correct files are present
            if len(filename) != 19:
                print "Wrong masterPSD filename length found in 3dsceneMasters Folder"
                raw_input("\nFinished. Press Enter...")
                sys.exit()
            if filename[15:19] != r".psd": 
                print filename[16:19] + " : Wrong file extension found in 3dsceneMasters Folder"
                raw_input("\nFinished. Press Enter...")
                sys.exit()
            ## Create list master PSDs and of JV folders
            masterPSDs.append(os.path.join(path, filename))
            if filename[7:13] not in masterJVs: 
                masterJVs.append(filename[7:13])

        if sourceDir + r"\200" in path:
            extension = os.path.splitext(filename)[1]
            if extension == ".psd":
                if len(filename) != 24:
                    print "Wrong PSD filename length found in 200 Folder"
                    raw_input("\nFinished. Press Enter...")
                    sys.exit()
                else:
                    source200PSDs.append(os.path.join(path, filename))
            elif extension == ".bmp":
                if len(filename) != 24:
                    print "Wrong BMP filename length found in 200 Folders"
                    raw_input("\nFinished. Press Enter...")
                    sys.exit()
                else:
                    source200BMPs.append(os.path.join(path, filename))

            else:
                print extension + " : Wrong file extension found in 200 Folder"
                raw_input("\nFinished. Press Enter...")
                sys.exit()

        if sourceDir + r"\320" in path:
            extension = os.path.splitext(filename)[1]
            if extension == ".psd":
                if len(filename) != 24:
                    print "Wrong PSD filename length found in 320 Folder"
                    raw_input("\nFinished. Press Enter...")
                    sys.exit()
                else:
                    source320PSDs.append(os.path.join(path, filename))
            elif extension == ".bmp":
                if len(filename) != 24:
                    print "Wrong BMP filename length found in 320 Folders"
                    raw_input("\nFinished. Press Enter...")
                    sys.exit()
                else:
                    source320BMPs.append(os.path.join(path, filename))

            else:
                print extension + " : Wrong file extension found in 320 Folder"
                raw_input("\nFinished. Press Enter...")
                sys.exit()


    ### Create master JV target folders from master PSDs
    for d in masterJVs:
        print d
        directoryJV = targetDir + "\\" + d
        if os.path.exists(directoryJV):
            print "\nFolder already exists, skipping:\n" + directoryJV
        else:       ### make target folders and copy files there
            os.makedirs(directoryJV + r"\2dsource")                     # make JV folder\2dsourceand populate with PSDs
            copyTarget = directoryJV + r"\2dsource"
            for p in masterPSDs:
                if d in p:
                    copySource = p 
                    os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))

            os.makedirs(directoryJV + r"\200x216\psd")                 # make JV folder\200x216\psd and populate with PSDs
            for p in source200PSDs:
                if d in p:
                    copySource = p 
                    copyTarget = directoryJV + r"\200x216\psd\\" + os.path.basename(p)[0:15] + ".psd"
                    os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))
            for p in source200BMPs:                                     # populate with BMPs JV folder\200x216\ 
                if d in p:
                    if "200\\d1" in p:                                   # d01 BMPS
                        copySource = p 
                        copyTarget = directoryJV + r"\200x216\\" + os.path.basename(p)[0:15] + "d01.bmp"
                        os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))
                    elif "200\\d2" in p:                                   # d01 BMPS
                        copySource = p 
                        copyTarget = directoryJV + r"\200x216\\" + os.path.basename(p)[0:15] + "d02.bmp"
                        os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))
                    elif "200\\n1" in p:                                   # d01 BMPS
                        copySource = p 
                        copyTarget = directoryJV + r"\200x216\\" + os.path.basename(p)[0:15] + "n01.bmp"
                        os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))
                    elif "200\\n2" in p:                                   # d01 BMPS
                        copySource = p 
                        copyTarget = directoryJV + r"\200x216\\" + os.path.basename(p)[0:15] + "n02.bmp"
                        os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))
                    else:
                        print p + " : Wrong day/night files found in 200 Folder"
                        raw_input("\nFinished. Press Enter...")
                        sys.exit()

            os.makedirs(directoryJV + r"\320x480\psd")                 # make JV folder\320x480\psd and populate with PSDs
            for p in source320PSDs:
                if d in p:
                    copySource = p 
                    copyTarget = directoryJV + r"\320x480\psd\\" + os.path.basename(p)[0:15] + ".psd"
                    os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))
            for p in source320BMPs:                                     # populate with BMPs JV folder\320x480\ 
                if d in p:
                    if "320\\d1" in p:                                   # d01 BMPS
                        copySource = p 
                        copyTarget = directoryJV + r"\320x480\\" + os.path.basename(p)[0:15] + "d01.bmp"
                        os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))
                    elif "320\\d2" in p:                                   # d01 BMPS
                        copySource = p 
                        copyTarget = directoryJV + r"\320x480\\" + os.path.basename(p)[0:15] + "d02.bmp"
                        os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))
                    elif "320\\n1" in p:                                   # d01 BMPS
                        copySource = p 
                        copyTarget = directoryJV + r"\320x480\\" + os.path.basename(p)[0:15] + "n01.bmp"
                        os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))
                    elif "320\\n2" in p:                                   # d01 BMPS
                        copySource = p 
                        copyTarget = directoryJV + r"\320x480\\" + os.path.basename(p)[0:15] + "n02.bmp"
                        os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))
                    else:
                        print p + " : Wrong day/night files found in 320 Folder"
                        raw_input("\nFinished. Press Enter...")
                        sys.exit()



raw_input("\nFinished. Press Enter...")
sys.exit()

