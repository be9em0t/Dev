#!python2

#TT autoExport
#2016, mocapi
#ver 1.5

#done check for icon availability
#done check for ini file availability and content
#done: checkbox to move ot copy source files from scenes folder
#done: get source files from Max folders, not from scenes
#done: check out-of-lod2_png-folder behavior (missing error)

import Tkinter, tkMessageBox, tkFileDialog #tkSimpleDialog, 
import os, subprocess, time, sys, shutil, ConfigParser
import errno, re

#get the scrip directory, so we know where our settings are
scriptDir = os.path.dirname(os.path.abspath(__file__))

#initialise Tkinter
root = Tkinter.Tk()
#root.withdraw() #use to hide tkinter window
root.title("TT AutoExport")
ws = root.winfo_screenwidth() # width of the screen
hs = root.winfo_screenheight() # height of the screen
w=700
h=400
x = (ws/2) - (w/2)
y = (hs/2) - (h/2)
root.geometry('%dx%d+%d+%d' % (w, h, x, y))
if (os.path.exists(scriptDir + "\\TT_AutoHexPort.ico")):
    root.iconbitmap(scriptDir + "\\TT_AutoHexPort.ico")
    #tkMessageBox.showinfo(title="TT AutoExport", message="File " + (scriptDir + "\\TT_AutoHexPort.ico") + "\ndoes not exist!")
Force = Tkinter.IntVar()
SameAsMax = Tkinter.IntVar()

# First get some basic settings
# Test for ini file
if (os.path.exists(scriptDir + '\\autohex.ini')) == False:
    tkMessageBox.showinfo(title="TT AutoExport", message="File autohex.ini not found!")
    sys.exit()
# write settings function
def configWrite(section, option, value):
    config = ConfigParser.RawConfigParser()
    config.read(scriptDir + '\\autohex.ini')
    config.set(section, option, value)
    with open(scriptDir + '\\autohex.ini', "wb") as configfile:
        config.write(configfile)
    return;
# read settings function
def configRead(section, option):
    config = ConfigParser.RawConfigParser()
    try:
        config.read(scriptDir + '\\autohex.ini')
    except  :
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Settings file autohex.ini missing!")
        sys.exit()
    try:
        value = config.get(section, option)
    except  :
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Value " + option + " or section " + section + " missing in autohex.ini file!\nDefault value created.")
        configWrite(section, option, "0")
        sys.exit()
    return value;


#==Initialization=======
initdir = os.getcwd()
#initdir = r"c:\Work\OneDrive\Work\TomTom\scenes\Singapore\Redelivery\sgp_sgp_2015_2016_02_18_batch3 Redelivery2\sgp_sgp_2015\sgp_sgp_2015\sgp_sgp_259\model\lod3"

emeditorDir = configRead("general", "emeditordir")
imgmagickDir = configRead("general", "imgmagick") 
forceState = configRead("general", "force")
sameState = configRead("general", "sameasmax")

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

def checkDir(dir):
    if (os.path.isdir(dir)) == False:
        tkMessageBox.showinfo(title="TT AutoExport", message="Folder\n " + dir + "\ndoes not exist!")
        sys.exit()
                    
def checkFile(file):
    if (os.path.exists(file)) == False:
        tkMessageBox.showinfo(title="TT AutoExport", message="File " + file + "\ndoes not exist!")
        sys.exit()

def getSourcePaths(initdir):    
    path_list = initdir.split(os.sep)
    #shortDir - sourcePaths[0] 
    #maxDir - sourcePaths[1]
    #LMname - sourcePaths[2]
    #startfolder - sourcePaths[3]
    #scenesDir - sourcePaths[4]
    #modelDir - sourcePaths[5]

    sourcePaths = ["..\\", "", "", path_list[len(path_list)-1], "", ""]              

    
    findSubstr1 = "Delivery"
    findSubstr2 = "Redelivery"
    #initdirLower = initdir.lower()
    #print initdirLower.count(findSubstr1.lower()) + initdirLower.count(findSubstr2.lower())
    if (initdir.count(findSubstr1) + initdir.count(findSubstr2) != 1):
        result = tkMessageBox.askyesno("TT AutoExport", "Weird Delivery directory name!\n\n" + initdir + "\n\nDo you want to continue?", default=tkMessageBox.YES)
        if result == False:
            sys.exit()
        
    #if not (findSubstr1 in initdir) or (findSubstr2 in initdir):
    #    tkMessageBox.showinfo(title="TT AutoExport", message="Oops, not a Delivery directory!.\nPlease start anywhere inside 'model' directory...\n" + initdir)
    #    sys.exit()

    for x in range(len(path_list)):
        if (findSubstr1 in path_list[x]) or (findSubstr2 in path_list[x]):
            for y in range(len(path_list)-x):
                        sourcePaths[0] = sourcePaths[0] + path_list[x+y] + "\\" 
            for z in range(x+3):
                        sourcePaths[1] = sourcePaths[1] + path_list[z] + "\\"         
            sourcePaths[2] = path_list[x+3]

    findString = "scenes"
    for a in range(len(path_list)):
        if (findString == path_list[a]):
            for r in range(a+1):
                sourcePaths[4] = sourcePaths[4] + path_list[r] + "\\"         

    findString = "model"
    for a in range(len(path_list)):
        if (findString == path_list[a]):
            for r in range(a+1):
                sourcePaths[5] = sourcePaths[5] + path_list[r] + "\\"         

    if sourcePaths[2] == "":
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops, not a Delivery directory!\nPlease start anywhere inside 'model' directory..")
        sys.exit()

    if sourcePaths[4] == "":
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops, scenes directory not found!\nPlease start anywhere inside 'model' directory....")
        sys.exit()

    if sourcePaths[5] == "":
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops, model directory not found!\nPlease start anywhere inside 'model' directory.....")
        sys.exit()

    sourcePaths[1] = (sourcePaths[1].rstrip("\\") + "_3d_source" + "\\" + sourcePaths[2] + "\\")
    sourcePaths[3] = path_list[ len(path_list)-1 ]

    return sourcePaths

#get source images and the MAX file
def getSourceFiles():
    # source folder for obj/wrl according to ini file
    if sameState == "1":
        objwrlDir = maxDir
    elif sameState == "0":
        objwrlDir = scenesDir
    else:
        tkMessageBox.showinfo(title="TT AutoExport", message="Undefined source folder option.")
    print objwrlDir

    try:    #check max and images
        fileList = os.listdir(maxDir)
        if len(fileList) < 3:
            tkMessageBox.showinfo(title="TT AutoExport", message="Oops, sources missing in .max folder!\nOnly " + str(len(fileList)) + " files found")
            sys.exit()
        elif len(fileList) > 3 :
            if sameState == "0":
                tkMessageBox.showinfo(title="TT AutoExport", message="Oops, too many sources in .max folder!\n" + str(len(fileList)) + " files found")
                #sys.exit()
        else:
            print "ok"
        sourceFiles = ["","",""]
        for x in fileList:             
            fileParts = x.split(os.extsep)
            # sourceFiles[0] = max
            # sourceFiles[1] = 2048 png
            # sourceFiles[2] = 512 png
            if fileParts[1] == "max":
                sourceFiles[0] = x
            elif fileParts[1] == "png":
                if "2048" in fileParts[0]:  
                    sourceFiles[1] = x
                elif "512" in fileParts[0]:  
                    sourceFiles[2] = x
                else:
                    tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Wrong PNG names!")
                    sys.exit()
            else:
                if sameState == "0":
                    tkMessageBox.showinfo(title="TT AutoExport", message="Wrong file type found: " + x)
    except OSError as exception:
        if exception.errno != errno.EEXIST:
            raise
            print exception.message

    try:    #check obj and wrl        
        fileList = os.listdir(objwrlDir)
        exportFiles = []
        for x in fileList:             
            fileParts = x.split(os.extsep)
            if len(fileParts) == 2:
                if fileParts[1] == "obj" or fileParts[1] == "wrl":
                    exportFiles.append(x)
        print len(exportFiles)
        if len(exportFiles) > 5:
            tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Too many .obj and .wrl files in folder\n" + objwrlDir)
            sys.exit()
        elif len(exportFiles) < 5:
            tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Not all .obj and .wrl files available in folder\n" + objwrlDir)
            #sys.exit()


    except OSError as exception:
        if exception.errno != errno.EEXIST:
            raise
            print exception.message
    return sourceFiles;

sourcePaths = getSourcePaths(initdir)
shortDir = sourcePaths[0] 
maxDir = sourcePaths[1]
LMname = sourcePaths[2]
startfolder = sourcePaths[3]
scenesDir = sourcePaths[4]
modelDir = sourcePaths[5]

#print shortDir  
#print maxDir 
#print LMname 
#print startfolder 
#print scenesDir 
#print modelDir

# source folder for obj/wrl according to ini file
if sameState == "1":
    objwrlDir = maxDir
elif sameState == "0":
    objwrlDir = scenesDir
else:
    tkMessageBox.showinfo(title="TT AutoExport", message="Undefined source folder option.")

# start source file check routine
sourceFiles = getSourceFiles() 

maxFile = sourceFiles[0]
image2048 = sourceFiles[1]
image512 = sourceFiles[2]


                  
def fileDirSelect(filetype1, filetype2, title, testResult):
    fileSelect = tkFileDialog.askopenfilename(parent=root, initialdir=initdir, filetypes=[(filetype1, filetype2)] ,title=title)
    if len(fileSelect) > 0:
         #this is with wrong slashes
        if os.path.basename(fileSelect) == testResult:
            print os.path.dirname(fileSelect) 
            return os.path.dirname(fileSelect) ;            
        else:
            tkMessageBox.showinfo(title="TT AutoExport", message="Oops, you selected\n" + os.path.basename(fileSelect) + "\nThis does not seem to be " + testResult +".")
            sys.exit()

#===LOD EXPORTS========================

#export lod2png
def exportLod2png(objwrlDir):
    print "===Operation: Export LOD2==="
    targetLOD = "lod2_png"
    targetDir = modelDir + targetLOD + "\\" 
#copy 2048 image from source
    source1 = maxDir + image2048
    target1 = targetDir + LMname + ".png"

    try: #copy here 2048 png
        shutil.copy2(source1, target1)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod2_png", message="Oops! Couldn't copy 2048x2048 image file!")
        sys.exit()

#copy freshly exported obj.wrl file
    source2 = objwrlDir + "lod2.obj"
    source3 = objwrlDir + "lod2.wrl"

    try: #copy here lod2.obj and lod2.wrl
        shutil.copy2(source2, targetDir)
        shutil.copy2(source3, targetDir)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod2_png", message="Oops! Couldn't copy obj/wrl files!")
        sys.exit()

#copy headers to the freshly exported obj/wrl files
    emed = emeditorDir + "\\EmEditor.exe"
    source4 = targetDir + "lod2.obj"
    source5 = targetDir + "lod2.wrl"
    source6 = targetDir + LMname + ".obj" 
    source7 = targetDir + LMname + ".wrl"
    if Force.get() == 0:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\\TT_copy02.jsee" + "\"" 
    else:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\\TT_copy02_force.jsee" + "\"" 
    res = subprocess.call(emed + " " + "\"" + source4 + "\"" + " " + "\"" + source5 + "\"" + " " + "\"" + source6 + "\"" + " " + "\"" + source7 + "\"" + " " + macro)        
    if res != 0:
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Couldn't excute EmEditor properly!")
        sys.exit()
    
    try: #rename wrl and obj files
        shutil.move(source4, source6) #shutil deals with spaces in paths
        shutil.move(source5, source7)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod2_png", message="Oops! Couldn't rename obj/wrl files")
        sys.exit()

    #sys.exit()
    return;

#export lod2jpg
def exportLod2jpg(objwrlDir):
    print "===Operation: Export LOD2 JPG==="
    targetLOD = "lod2_jpg"
    targetDir = modelDir + targetLOD + "\\" 
# check lod2png is ready
    check = checkDirFiles(modelDir + "lod2_png",[LMname + ".png", LMname + ".obj", LMname + ".wrl", LMname + ".mtl"])
    if check  == False:
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Lod2_png not ready.\n We need it as a source for Lod2_jpg")
        sys.exit()

# convert 2048 png as jpg
    source1 = modelDir + "lod2_png\\" + LMname + ".png"
    target1 = targetDir + LMname + ".jpg" 
    imgmagickExe = "\"" + imgmagickDir + "\convert.exe" + "\""

    res = subprocess.call(imgmagickExe + " " + "\"" + source1 + "\"" + " -fill magenta -opaque none -quality 100 " + "\""  + target1 +"\"", shell=True)        
    if res != 0:
        tkMessageBox.showinfo(title="TT AutoExport - lod2_jpg", message="Oops! Couldn't convert 2048 png to jpg!")
        sys.exit()

# copy the obj/wr;/mtl files
    source2 = modelDir + "lod2_png" + "\\" + LMname + ".obj"
    source3 = modelDir + "lod2_png" + "\\" + LMname + ".wrl" 
    source4 = modelDir + "lod2_png" + "\\" + LMname + ".mtl" 
    try: #copy here lod2.obj and lod2.wrl
        shutil.copy2(source2, targetDir) #shutil deal correctly with spaces in filenames
        shutil.copy2(source3, targetDir)
        shutil.copy2(source4, targetDir)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod2_jpg", message="Oops! Couldn't copy obj/wrl/mtl files!")
        sys.exit()

# replace png with jpg in files
    emed = os.path.normpath("\"" + emeditorDir + "\\EmEditor.exe" + "\"") 
    source5 = "\"" + targetDir + LMname + ".obj" + "\""
    source6 = "\"" + targetDir + LMname + ".wrl" + "\""
    source7 = "\"" + targetDir + LMname + ".mtl" + "\""

    if Force.get() == 0:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\TT_PNG2JPG.jsee" + "\"" 
    else:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\TT_PNG2JPG_force.jsee" + "\"" 

    res = subprocess.call(emed + " " + source5 + " " + source6 + " " + source7 + " " + macro)
    if res != 0:
        tkMessageBox.showinfo(title="TT AutoExport - lod2_jpg", message="Oops! Couldn't excute EmEditor properly!")
        sys.exit()

#export lod1png
def exportLod1png(objwrlDir):
    print "===Operation: Export LOD1 PNG==="
    targetLOD = "lod1_png"
    targetDir = modelDir + targetLOD + "\\" 
# check lod2png is ready
    check = checkDirFiles(modelDir + "lod2_png",[LMname + ".png", LMname + ".obj", LMname + ".wrl", LMname + ".mtl"])
    print check
    if check  == False:
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Lod2_png not ready.\n We need it as a source for Lod1_png")
        sys.exit()

    # copy 512 png from source
    source1 = maxDir + image512
    target1 = targetDir + LMname + ".png"

    try: #copy here 512 png
        shutil.copy2(source1, target1)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod1_png", message="Oops! Couldn't copy 512x512 image file!")
        sys.exit()

# copy new obj/wr;/mtl files
    source2 = objwrlDir + "lod1.obj"
    source3 = objwrlDir + "lod1.wrl"
    source4 = modelDir + "lod2_png" + "\\" + LMname + ".mtl" 

    try: #copy here lod2.obj and lod2.wrl
        shutil.copy2(source2, targetDir)
        shutil.copy2(source3, targetDir)
        shutil.copy2(source4, targetDir)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod1_png", message="Oops! Couldn't copy obj/wrl/mtl files!")
        sys.exit()

#copy headers to the freshly exported obj/wrl files
    emed = os.path.normpath("\"" + emeditorDir + "\\EmEditor.exe" + "\"") 
    source5 = "\"" + modelDir + "lod2_png" + "\\" + LMname + ".obj" + "\""
    source6 = "\"" + modelDir + "lod2_png" + "\\" + LMname + ".wrl" + "\""
    target5 = "\"" + targetDir + "lod1.obj" + "\""
    target6 = "\"" + targetDir + "lod1.wrl" + "\""
    if Force.get() == 0:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\\TT_copy02.jsee" + "\"" 
    else:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\\TT_copy02_force.jsee" + "\"" 
    
    res = subprocess.call(emed + " " + source5 + " " + source6 + " " + target5 + " " + target6 + " " + macro)
    if res != 0:
        tkMessageBox.showinfo(title="TT AutoExport - lod1_png", message="Oops! Couldn't excute EmEditor properly!")
        sys.exit()

# rename obj.wrl files
    source5 = targetDir + "lod1.obj" 
    source6 = targetDir + "lod1.wrl" 
    target5 = targetDir + LMname + ".obj" 
    target6 = targetDir + LMname + ".wrl"
    try: #rename wrl and obj files
        shutil.move(source5, target5) #shutil deals with spaces in paths
        shutil.move(source6, target6)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod1_png", message="Oops! Couldn't rename obj/wrl files!")
        sys.exit()

#export lod1jpg
def exportLod1jpg(objwrlDir):
    print "===Operation: Export LOD1 JPG==="
    targetLOD = "lod1_jpg"
    targetDir = modelDir + targetLOD + "\\" 
# check lod1png is ready
    check = checkDirFiles(modelDir + "lod1_png",[LMname + ".png", LMname + ".obj", LMname + ".wrl", LMname + ".mtl"])
    print check
    if check  == False:
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Lod1_png not ready.\n We need it as a source for Lod1_jpg")
        sys.exit()
# convert 512 png as jpg
    source1 = "\"" + modelDir + "lod1_png" + "\\" + LMname + ".png" + "\""
    target1 = "\"" + targetDir + LMname + ".jpg" + "\"" 
    imgmagickExe = "\"" + imgmagickDir + "\convert.exe" + "\""
       
    res = subprocess.call(imgmagickExe + " " + source1 + " -fill magenta -opaque none -quality 100 " + target1, shell=True)        
    if res != 0:
        tkMessageBox.showinfo(title="TT AutoExport - lod1_jpg", message="Oops! Couldn't convert 512x512 png to jpg!")
        sys.exit()

# copy the obj/wr;/mtl files
    source2 = modelDir + "lod1_png" + "\\" + LMname + ".obj"
    source3 = modelDir + "lod1_png" + "\\" + LMname + ".wrl" 
    source4 = modelDir + "lod1_png" + "\\" + LMname + ".mtl" 
    try: #copy here lod1.obj and lod1.wrl
        shutil.copy2(source2, targetDir) #shutil deals correctly with spaces in filenames
        shutil.copy2(source3, targetDir)
        shutil.copy2(source4, targetDir)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod1_jpg", message="Oops! Couldn't copy obj/wrl/mtl files!")
        sys.exit()

# replace png with jpg in files
    emed = os.path.normpath("\"" + emeditorDir + "\\EmEditor.exe" + "\"") 
    source5 = "\"" + targetDir + LMname + ".obj" + "\""
    source6 = "\"" + targetDir + LMname + ".wrl" + "\""
    source7 = "\"" + targetDir + LMname + ".mtl" + "\""
    if Force.get() == 0:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\TT_PNG2JPG.jsee" + "\"" 
    else:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\TT_PNG2JPG_force.jsee" + "\"" 
    
    res = subprocess.call(emed + " " + source5 + " " + source6 + " " + source7 + " " + macro)
    if res != 0:
        tkMessageBox.showinfo(title="TT AutoExport - lod1_jpg", message="Oops! Couldn't excute EmEditor properly!")
        sys.exit()

#export lod3
def exportLod3(objwrlDir):
    print "===Operation: Export LOD3==="
    targetLOD = "lod3"
    targetDir = modelDir + targetLOD + "\\" 
# check lod2png is ready
    check = checkDirFiles(modelDir + "lod2_png", [LMname + ".wrl"])
    if check  == False:
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Lod2_png not ready.\n We need it as a source for Lod3")
        sys.exit()
        
# copy fresh lod3
# copy the obj/wr;/mtl files
    source1 = objwrlDir + "lod3.wrl"
    #target1 = modelDir + "lod3" + "\\" 
    try: #copy here lod3.wrl
        shutil.copy2(source1, targetDir) #shutil deals correctly with spaces in filenames
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod3", message="Oops! Couldn't copy wrl file!")
        sys.exit()

#emeditor copy header
#copy headers to the freshly exported obj/wrl files
    emed = os.path.normpath("\"" + emeditorDir + "\\EmEditor.exe" + "\"") 
    source2 = "\"" + modelDir + "lod2_png" + "\\" + LMname + ".wrl" + "\""
    target2 = "\"" + targetDir + "lod3.wrl" + "\""
    if Force.get() == 0:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\\TT_copy02.jsee" + "\"" 
    else:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\\TT_copy02_force.jsee" + "\"" 
    res = subprocess.call(emed + " " + source2 + " " + target2 + " " + macro)
    if res != 0:
        tkMessageBox.showinfo(title="TT AutoExport - lod3", message="Oops! Couldn't excute EmEditor properly!")
        sys.exit()

#rename file
    source3 = targetDir + "lod3.wrl"
    target3 = targetDir + LMname + ".wrl"
    try: #rename wrl and obj files
        shutil.move(source3, target3) #shutil deals with spaces in paths
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod3", message="Oops! Couldn't rename wrl file!")
        sys.exit()

def exportLodCurrent():
    tkMessageBox.showinfo(title="TT AutoExport", message="Furry kittens ate this option.\n Try another button.")


# MAIN UI
def callbackCancel():
    print "Cancelled"
    root.destroy()
    sys.exit()

def callbackExportAll():
# select source folder for obj/wrl
    if SameAsMax.get() == 1:
        objwrlDir = maxDir
    elif SameAsMax.get() == 0:
        objwrlDir = scenesDir
    else:
        tkMessageBox.showinfo(title="TT AutoExport", message="Undefined source folder option.")

    exportLod2png(objwrlDir)
    exportLod2jpg(objwrlDir)
    exportLod1png(objwrlDir)
    exportLod1jpg(objwrlDir)
    exportLod3(objwrlDir)
    root.destroy()
    sys.exit()

def callbackExportCurrent():
    exportLodCurrent()
    #root.destroy()
    #sys.exit()

def callbackForceTogggle():
    state = Force.get()
    configWrite("general", "force", str(state))
    #root.destroy()

def callbackSameAsMaxTogggle():
    state = SameAsMax.get()
    configWrite("general", "sameasmax", str(state))
    #root.destroy()

def callbackSetEmEditor():
    selected = fileDirSelect("Exe files", "*.exe", "Please select EmEditor.exe", "EmEditor.exe")
    configWrite("general", "emeditordir", selected)
    root.destroy()

def callbackSetImgMagick():
    selected = fileDirSelect("Exe files", "*.exe", "Please select ImageMagick Convert.exe", "convert.exe")
    configWrite("general", "imgmagick", selected)
    root.destroy()


#first frame - info about source files
padLeft = 148
lblFrameSource = Tkinter.LabelFrame(root, text="Source files")                                  #Frame
lblFrameSource.pack(fill="both", expand="yes", padx=10, pady=10)

frame1folder = Tkinter.Frame(lblFrameSource, padx=padLeft)
frame1folder.pack(side=Tkinter.TOP, fill=Tkinter.X)
lbl10a = Tkinter.Label(frame1folder, anchor=Tkinter.W, justify=Tkinter.LEFT, text="Current Folder:")
lbl10a.pack(fill=Tkinter.X)
lbl10b = Tkinter.Label(lblFrameSource, fg="#007ACC", bg="#FFF29D", text=shortDir)
lbl10b.pack(fill=Tkinter.X)

frame1lm = Tkinter.Frame(lblFrameSource, padx=padLeft)
frame1lm.pack(side=Tkinter.TOP, fill=Tkinter.X)
lbl5a = Tkinter.Label(frame1lm, justify=Tkinter.LEFT, text="Landmark: ")
lbl5a.pack(side=Tkinter.LEFT)
lbl5b = Tkinter.Label(frame1lm, fg="#007ACC", anchor=Tkinter.W, justify=Tkinter.LEFT, text=LMname)
lbl5b.pack(side=Tkinter.LEFT, fill=Tkinter.X, expand=True)

frame1export = Tkinter.Frame(lblFrameSource, padx=padLeft)
frame1export.pack(side=Tkinter.TOP, fill=Tkinter.X)
lbl6a = Tkinter.Label(frame1export, justify=Tkinter.LEFT, text="Started from: ")
lbl6a.pack(side=Tkinter.LEFT)
lbl6b = Tkinter.Label(frame1export, fg="#007ACC", anchor=Tkinter.W, justify=Tkinter.LEFT, text=startfolder)
lbl6b.pack(side=Tkinter.LEFT, fill=Tkinter.X, expand=True)

frame1max = Tkinter.Frame(lblFrameSource, padx=padLeft)
frame1max.pack(side=Tkinter.TOP, fill=Tkinter.X)
lbl20a = Tkinter.Label(frame1max, justify=Tkinter.LEFT, text="3DS Max source file: ")
lbl20a.pack(side=Tkinter.LEFT)
lbl20b = Tkinter.Label(frame1max, fg="#007ACC", anchor=Tkinter.W, justify=Tkinter.LEFT, text=maxFile)
lbl20b.pack(side=Tkinter.LEFT, fill=Tkinter.X, expand=True)

frame2png = Tkinter.Frame(lblFrameSource, padx=padLeft)
frame2png.pack(side=Tkinter.TOP, fill=Tkinter.X)
lbl30a = Tkinter.Label(frame2png, justify=Tkinter.LEFT, text="2048 source image: ")
lbl30a.pack(side=Tkinter.LEFT, expand=False)
lbl30b = Tkinter.Label(frame2png, fg="#007ACC", anchor=Tkinter.W, justify=Tkinter.LEFT, text=image2048)
lbl30b.pack(side=Tkinter.LEFT, fill=Tkinter.X, expand=True)

frame3png = Tkinter.Frame(lblFrameSource, padx=padLeft)
frame3png.pack(side=Tkinter.TOP, fill=Tkinter.X)
lbl40a = Tkinter.Label(frame3png, justify=Tkinter.LEFT, text="512 source image:  ")
lbl40a.pack(side=Tkinter.LEFT)
lbl40b = Tkinter.Label(frame3png, fg="#007ACC", anchor=Tkinter.W, justify=Tkinter.LEFT, text=image512)
lbl40b.pack(side=Tkinter.LEFT, fill=Tkinter.X, expand=True)


#second frame
lblFrameOptions = Tkinter.LabelFrame(root, text="Options")
lblFrameOptions.pack(fill="both", expand="yes", padx=10, pady=10)
 

check2Same = Tkinter.Checkbutton(lblFrameOptions, text="Search for source .obj and .wrl files in .max folder", variable=SameAsMax, command=callbackSameAsMaxTogggle, height = 1)
check2Same.pack()
if sameState == "1":
    check2Same.select()
elif sameState == "0":
    check2Same.deselect()
else:
    configWrite("general", "sameasmax", "0")

check1Force = Tkinter.Checkbutton(lblFrameOptions, text="Silent Mode", variable=Force, command=callbackForceTogggle, height = 2)
check1Force.pack()
if forceState == "1":
    check1Force.select()
elif forceState == "0":
    check1Force.deselect()
else:
    configWrite("general", "force", "0")

buttonframe1 = Tkinter.Frame(lblFrameOptions, padx=96)
buttonframe1.pack( side = Tkinter.TOP, fill=Tkinter.X )
buttonframe2 = Tkinter.Frame(lblFrameOptions, padx=96)
buttonframe2.pack( side = Tkinter.TOP, fill=Tkinter.X )

b1ExportAll = Tkinter.Button(buttonframe1, text="Populate All LOD Folders", command=callbackExportAll, padx=34)
b1ExportAll.pack(side=Tkinter.LEFT )

b2ExportCurrent = Tkinter.Button(buttonframe1, text="Export Only Current Folder", command=callbackExportCurrent, padx=34)
b2ExportCurrent.pack(side=Tkinter.RIGHT)

b3Settings = Tkinter.Button(buttonframe2, text="Set EmEditor", command=callbackSetEmEditor, padx=34)
b3Settings.pack(side=Tkinter.LEFT)

b4Settings = Tkinter.Button(buttonframe2, text="Set ImgageMagick", command=callbackSetImgMagick, padx=34)
b4Settings.pack(side=Tkinter.RIGHT)

b2Cancel = Tkinter.Button(root, text="Cancel", command=callbackCancel)
b2Cancel.pack(side=Tkinter.TOP, fill=Tkinter.X)

Tkinter.mainloop()
