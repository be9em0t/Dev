#!python2

#Usage:
#In Total Commander set button "...TT_IconPopulate.py" with parameters "%P " "%T " (note the spaces before trailing ")
#select for source dir an existing max+png+bmp dir (i.e. Cartagena)
#select for target dir a correctly named delivery folder (i.e. c:\Work\OneDrive\Work\TomTom\scenes\[icons]\col_ctg_2012_2012_07_02 Icons Delivery)
#The script will ask for city name and create delivery subfolders automatically

import os, sys, shutil

sourceDir = ((sys.argv[1]).rstrip()).rstrip("\\") #r"c:\Work\BATCH\cartagena test\cartagena\\" #
targetDir = ((sys.argv[2]).rstrip()).rstrip("\\")  #r"c:\Work\OneDrive\Work\TomTom\scenes\[icons]\col_ctg_2012_2012_07_02 Icons Delivery\\"  #
stateCode = "STATECODE" #user input
cityName = "CITYNAME" #user input
sourceBMPs = []
testEmpty = []
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
 
### routine to convert pathnames with spaces into enclosed with "" pathnames
def genLongName(inPathName):
    outPathName = "\"" + inPathName + "\""
    return outPathName

### target check part1
for path, dirs, files in os.walk(targetDir):
    for dir in dirs:
        testEmpty.append(dir)
    for file in files:
        testEmpty.append(file)

### target check part2
if len(testEmpty) > 0:
    raw_input("\nTarget Directory not empty. Exiting...")
    sys.exit()

### Source parse
for path, dirs, files in os.walk(sourceDir):
    for file in files:
        filename = os.path.splitext(file)[0]
        extension = os.path.splitext(file)[1]
        if filename[6:11] == " copy" and extension == ".bmp":
            sourceBMPs.append(os.path.join(path, file))

### Read the StateCode
statePath, stateFileName = os.path.split(sourceBMPs[0])
statePathList = statePath.split(os.sep)
stateCode = (statePathList[len(statePathList)-1])[0:3]

### Get User Input for CityName
cityName = raw_input("Type the City_Name, or X for exit: ")
if cityName == "X" or cityName == "x":
    print  "User exit"
    sys.exit()
elif len(cityName) < 1 :
    print  "City_Name too short. Exiting..."
    raw_input("\nFinished. Press Enter...")
    sys.exit()
else:
    cityName = cityName.lower()


### Copy and Rename BMPs to target folders
dir32 = targetDir + "\\" + cityName + "\\landmarkicon_01_bmp32x32\\" + stateCode + "\\" + cityName
dir64 = targetDir + "\\" + cityName + "\\landmarkicon_01_bmp64x64\\" + stateCode + "\\" + cityName
dir80 = targetDir + "\\" + cityName + "\\landmarkicon_01_bmp80x80\\" + stateCode + "\\" + cityName

for bmpFile in sourceBMPs:
    bmpPath, bmpFileName = os.path.split(bmpFile)
    bmpPathList = bmpPath.split(os.sep)
    JVname = bmpPathList[len(bmpPathList)-1]
    iconFolder32 = dir32 + "\\" + JVname
    iconFolder64 = dir64 + "\\" + JVname
    iconFolder80 = dir80 + "\\" + JVname

    if not os.path.exists(iconFolder32):
        os.makedirs(iconFolder32)
        os.makedirs(iconFolder64)
        os.makedirs(iconFolder80)

    if "32x32" in bmpFileName:
        copySource = bmpFile
        copyTarget = os.path.join(iconFolder32 + "\\" + JVname + "_32x32.bmp")
        os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))
    elif "64x64" in bmpFileName:
        copySource = bmpFile
        copyTarget = os.path.join(iconFolder64 + "\\" + JVname + "_64x64.bmp")
        os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))
    elif "80x80" in bmpFileName:
        copySource = bmpFile
        copyTarget = os.path.join(iconFolder80 + "\\" + JVname + "_80x80.bmp")
        os.system ("copy %s %s" % (genLongName(copySource), genLongName(copyTarget)))
    else:
        raw_input("\nUnrecognised BMP source file. Exiting...")
        sys.exit()




