#TT autoExport
#2016, mocapi
#ver 1.0

#TODO: checkbox to move ot copy source files from scenes folder
#TODO: get source files from Max folders, not from scenes
#TODO: check out-of-lod2_png-folder behavior (missing error)

import Tkinter, tkMessageBox, tkFileDialog #tkSimpleDialog, 
import os, subprocess, time, sys, shutil, ConfigParser
import errno, re

#get the scrip directory, so we know where our settings are
scriptDir = os.path.dirname(os.path.abspath(__file__))

#initialise Tkinter
root = Tkinter.Tk()
root.iconbitmap(scriptDir + "\\box.ico")
#root.withdraw() #use to hide tkinter window
root.title("TT AutoExport")
#root.geometry("600x400")
ws = root.winfo_screenwidth() # width of the screen
hs = root.winfo_screenheight() # height of the screen
w=700
h=400
x = (ws/2) - (w/2)
y = (hs/2) - (h/2)
root.geometry('%dx%d+%d+%d' % (w, h, x, y))
Force = Tkinter.IntVar()

# First get some basic settings
def configRead(section, option):
    config = ConfigParser.RawConfigParser()
    try:
        #print scriptDir + '\\autohex.ini'
        #config.read(os.path.dirname(os.path.abspath(__file__)) + '\\autohex.ini')
        config.read(scriptDir + '\\autohex.ini')
    except  :
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Settings file autohex.ini missing!")
        sys.exit()
    try:
        value = config.get(section, option)
    except  :
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Value " + option + " or section " + section + " missing in autohex.ini file!")
        sys.exit()
    return value;

def configWrite(section, option, value):
    config = ConfigParser.RawConfigParser()
    #config.read(os.path.dirname(os.path.abspath(__file__)) + '\\autohex.ini')
    config.read(scriptDir + '\\autohex.ini')
    config.set(section, option, value)
    #with open(os.path.dirname(os.path.abspath(__file__)) + '\\autohex.ini', "wb") as configfile:
    with open(scriptDir + '\\autohex.ini', "wb") as configfile:
        config.write(configfile)
    return;

#==Initialization=======
currdir = os.getcwd()
#currdir = r"c:\Work\OneDrive\Work\TomTom\scenes\~[SCRIPT]  space\rus_mow_2016_2016_01_22_Delivery\rus_mow_2016\rus_mow_2016\rus_mow_026\model\lod2_png"

emeditorDir = configRead("general", "emeditordir")
imgmagickDir = configRead("general", "imgmagick") 
forceState = configRead("general", "force")


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


def getSourcePaths(currdir):    
    path_list = currdir.split(os.sep)
    #shortDir - sourcePaths[0] 
    #maxDir - sourcePaths[1]
    #LMname - sourcePaths[2]
    #LMfolder - sourcePaths[3]
    #scenesDir - sourcePaths[4]
    #modelDir - sourcePaths[5]

    sourcePaths = ["..\\", "", "", path_list[len(path_list)-1], "", ""]              

    findSubstr1 = "_Delivery"
    findSubstr2 = "_Redelivery"
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

    if sourcePaths[4] == "":
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops, scenes directory not found!\nPlease start inside 'lod2_png' directory.")
        sys.exit()

    if sourcePaths[2] == "":
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops, not a Delivery directory!\nPlease start inside 'lod2_png' directory.")
        sys.exit()

    if sourcePaths[5] == "":
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops, model directory not found!\nPlease start inside 'lod2_png' directory.")
        sys.exit()

    sourcePaths[1] = (sourcePaths[1].rstrip("\\") + "_3d_source" + "\\" + sourcePaths[2] + "\\")

    return sourcePaths

#get source images and the MAX file
def getSourceFiles(maxDir):
    #print maxDir
    try:
        #print(path)
        fileList = os.listdir(maxDir)
        if len(fileList) < 3:
            tkMessageBox.showinfo(title="TT AutoExport", message="Oops, sources missing!\nOnly " + str(len(fileList)) + " files found")
            sys.exit()
        elif len(fileList) > 3:
            tkMessageBox.showinfo(title="TT AutoExport", message="Oops, too many sources!\n" + str(len(fileList)) + " files found")
            sys.exit()
        else:
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
                    tkMessageBox.showinfo(title="TT AutoExport", message="Wrong file type found: " + x)

    except OSError as exception:
        if exception.errno != errno.EEXIST:
            raise
            print exception.message
    return sourceFiles;

sourcePaths = getSourcePaths(currdir)
shortDir = sourcePaths[0] 
maxDir = sourcePaths[1]
LMname = sourcePaths[2]
LMfolder = sourcePaths[3]
scenesDir = sourcePaths[4]
modelDir = sourcePaths[5]

#print shortDir  
#print maxDir 
#print LMname 
#print LMfolder 
#print scenesDir 
#print modelDir

sourceFiles = getSourceFiles(maxDir)
maxFile = sourceFiles[0]
image2048 = sourceFiles[1]
image512 = sourceFiles[2]
#print maxFile 
#print currdir
#print modelDir + "lod2_png"

                  
def fileDirSelect(filetype1, filetype2, title, testResult):
    fileSelect = tkFileDialog.askopenfilename(parent=root, initialdir=currdir, filetypes=[(filetype1, filetype2)] ,title=title)
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
def exportLod2png():
    print "===Operation: Export LOD2==="

    os.chdir(modelDir + "\lod2_png") #set lod2_png as current dir
#copy 2048 image from source
    source1 = maxDir + image2048
    target1 = currdir + "\\" + LMname + ".png"

    try: #copy here 2048 png
        shutil.copy2(source1, target1)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod2_png", message="Oops! Couldn't copy 2048x2048 image file!")
        sys.exit()

#copy freshly exported obj.wrl file
    source2 = scenesDir + "lod2.obj"
    source3 = scenesDir + "lod2.wrl"
    target23 = currdir + "\\" 

    try: #copy here lod2.obj and lod2.wrl
        shutil.copy2(source2, target23)
        shutil.copy2(source3, target23)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod2_png", message="Oops! Couldn't copy obj/wrl files!")
        sys.exit()

#copy headers to the freshly exported obj/wrl files
    emed = emeditorDir + "\\EmEditor.exe"
    source4 = "lod2.obj"
    source5 = "lod2.wrl"
    source6 = LMname + ".obj" 
    source7 = LMname + ".wrl"
    if Force.get() == 0:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\\TT_copy02.jsee" + "\"" 
    else:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\\TT_copy02_force.jsee" + "\"" 
    res = subprocess.call(emed + " " + source4 + " " + source5 + " " + source6 + " " + source7 + " " + macro)        
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
def exportLod2jpg():
    print "===Operation: Export LOD2 JPG==="

# check lod2png is ready
    check = checkDirFiles(modelDir + "lod2_png",[LMname + ".png", LMname + ".obj", LMname + ".wrl", LMname + ".mtl"])
    if check  == False:
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Lod2_png not ready.\n We need it as a source for Lod2_jpg")
        sys.exit()

# convert 2048 png as jpg
    source1 = "\"" + modelDir + "lod2_png" + "\\" + LMname + ".png" + "\""
    target1 = "\"" + modelDir + "lod2_jpg" + "\\" + LMname + ".jpg" + "\"" 
    imgmagickExe = "\"" + imgmagickDir + "\convert.exe" + "\""

    res = subprocess.call(imgmagickExe + " " + source1 + " -fill magenta -opaque none -quality 100 " + target1, shell=True)        
    if res != 0:
        tkMessageBox.showinfo(title="TT AutoExport - lod2_jpg", message="Oops! Couldn't convert 2048 png to jpg!")
        sys.exit()

# copy the obj/wr;/mtl files
    source2 = modelDir + "lod2_png" + "\\" + LMname + ".obj"
    source3 = modelDir + "lod2_png" + "\\" + LMname + ".wrl" 
    source4 = modelDir + "lod2_png" + "\\" + LMname + ".mtl" 
    target234 = modelDir + "lod2_jpg" + "\\" 
    try: #copy here lod2.obj and lod2.wrl
        shutil.copy2(source2, target234) #shutil deal correctly with spaces in filenames
        shutil.copy2(source3, target234)
        shutil.copy2(source4, target234)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod2_jpg", message="Oops! Couldn't copy obj/wrl/mtl files!")
        sys.exit()

# replace png with jpg in files
    emed = os.path.normpath("\"" + emeditorDir + "\\EmEditor.exe" + "\"") 
    source5 = "\"" + modelDir + "lod2_jpg" + "\\" + LMname + ".obj" + "\""
    source6 = "\"" + modelDir + "lod2_jpg" + "\\" + LMname + ".wrl" + "\""
    source7 = "\"" + modelDir + "lod2_jpg" + "\\" + LMname + ".mtl" + "\""

    if Force.get() == 0:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\TT_PNG2JPG.jsee" + "\"" 
    else:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\TT_PNG2JPG_force.jsee" + "\"" 

    res = subprocess.call(emed + " " + source5 + " " + source6 + " " + source7 + " " + macro)
    if res != 0:
        tkMessageBox.showinfo(title="TT AutoExport - lod2_jpg", message="Oops! Couldn't excute EmEditor properly!")
        sys.exit()

#export lod1png
def exportLod1png():
    print "===Operation: Export LOD1 PNG==="
# check lod2png is ready
    check = checkDirFiles(modelDir + "lod2_png",[LMname + ".png", LMname + ".obj", LMname + ".wrl", LMname + ".mtl"])
    print check
    if check  == False:
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Lod2_png not ready.\n We need it as a source for Lod1_png")
        sys.exit()

    # copy 512 png from source
    source1 = maxDir + image512
    target1 = modelDir + "lod1_png" + "\\" + LMname + ".png"

    try: #copy here 512 png
        shutil.copy2(source1, target1)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod1_png", message="Oops! Couldn't copy 512x512 image file!")
        sys.exit()

# copy new obj/wr;/mtl files
    source2 = scenesDir + "lod1.obj"
    source3 = scenesDir + "lod1.wrl"
    source4 = modelDir + "lod2_png" + "\\" + LMname + ".mtl" 
    target234 = modelDir + "lod1_png" + "\\" 

    try: #copy here lod2.obj and lod2.wrl
        shutil.copy2(source2, target234)
        shutil.copy2(source3, target234)
        shutil.copy2(source4, target234)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod1_png", message="Oops! Couldn't copy obj/wrl/mtl files!")
        sys.exit()

#copy headers to the freshly exported obj/wrl files
    emed = os.path.normpath("\"" + emeditorDir + "\\EmEditor.exe" + "\"") 
    source5 = "\"" + modelDir + "lod2_png" + "\\" + LMname + ".obj" + "\""
    source6 = "\"" + modelDir + "lod2_png" + "\\" + LMname + ".wrl" + "\""
    target5 = "\"" + modelDir + "lod1_png" + "\\" + "lod1.obj" + "\""
    target6 = "\"" + modelDir + "lod1_png" + "\\" + "lod1.wrl" + "\""
    if Force.get() == 0:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\\TT_copy02.jsee" + "\"" 
    else:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\\TT_copy02_force.jsee" + "\"" 
    
    res = subprocess.call(emed + " " + source5 + " " + source6 + " " + target5 + " " + target6 + " " + macro)
    if res != 0:
        tkMessageBox.showinfo(title="TT AutoExport - lod1_png", message="Oops! Couldn't excute EmEditor properly!")
        sys.exit()

# rename obj.wrl files
    source5 = modelDir + "lod1_png" + "\\" + "lod1.obj" 
    source6 = modelDir + "lod1_png" + "\\" + "lod1.wrl" 
    target5= modelDir + "lod1_png" + "\\" + LMname + ".obj" 
    target6 = modelDir + "lod1_png" + "\\" + LMname + ".wrl"
    try: #rename wrl and obj files
        shutil.move(source5, target5) #shutil deals with spaces in paths
        shutil.move(source6, target6)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod1_png", message="Oops! Couldn't rename obj/wrl files!")
        sys.exit()

#export lod1jpg
def exportLod1jpg():
    print "===Operation: Export LOD1 JPG==="
# check lod1png is ready
    check = checkDirFiles(modelDir + "lod1_png",[LMname + ".png", LMname + ".obj", LMname + ".wrl", LMname + ".mtl"])
    print check
    if check  == False:
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Lod1_png not ready.\n We need it as a source for Lod1_jpg")
        sys.exit()
# convert 512 png as jpg
    source1 = "\"" + modelDir + "lod1_png" + "\\" + LMname + ".png" + "\""
    target1 = "\"" + modelDir + "lod1_jpg" + "\\" + LMname + ".jpg" + "\"" 
    imgmagickExe = "\"" + imgmagickDir + "\convert.exe" + "\""

    res = subprocess.call(imgmagickExe + " " + source1 + " -fill magenta -opaque none -quality 100 " + target1, shell=True)        
    if res != 0:
        tkMessageBox.showinfo(title="TT AutoExport - lod1_jpg", message="Oops! Couldn't convert 512x512 png to jpg!")
        sys.exit()

# copy the obj/wr;/mtl files
    source2 = modelDir + "lod1_png" + "\\" + LMname + ".obj"
    source3 = modelDir + "lod1_png" + "\\" + LMname + ".wrl" 
    source4 = modelDir + "lod1_png" + "\\" + LMname + ".mtl" 
    target234 = modelDir + "lod1_jpg" + "\\" 
    try: #copy here lod1.obj and lod1.wrl
        shutil.copy2(source2, target234) #shutil deals correctly with spaces in filenames
        shutil.copy2(source3, target234)
        shutil.copy2(source4, target234)
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod1_jpg", message="Oops! Couldn't copy obj/wrl/mtl files!")
        sys.exit()

# replace png with jpg in files
    emed = os.path.normpath("\"" + emeditorDir + "\\EmEditor.exe" + "\"") 
    source5 = "\"" + modelDir + "lod1_jpg" + "\\" + LMname + ".obj" + "\""
    source6 = "\"" + modelDir + "lod1_jpg" + "\\" + LMname + ".wrl" + "\""
    source7 = "\"" + modelDir + "lod1_jpg" + "\\" + LMname + ".mtl" + "\""
    if Force.get() == 0:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\TT_PNG2JPG.jsee" + "\"" 
    else:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\TT_PNG2JPG_force.jsee" + "\"" 
    
    res = subprocess.call(emed + " " + source5 + " " + source6 + " " + source7 + " " + macro)
    if res != 0:
        tkMessageBox.showinfo(title="TT AutoExport - lod1_jpg", message="Oops! Couldn't excute EmEditor properly!")
        sys.exit()

#export lod3
def exportLod3():
    print "===Operation: Export LOD3==="
# check lod2png is ready
    check = checkDirFiles(modelDir + "lod2_png", [LMname + ".wrl"])
    if check  == False:
        tkMessageBox.showinfo(title="TT AutoExport", message="Oops! Lod2_png not ready.\n We need it as a source for Lod3")
        sys.exit()

#copy fresh lod3
# copy the obj/wr;/mtl files
    source1 = scenesDir + "lod3.wrl"
    target1 = modelDir + "lod3" + "\\" 
    try: #copy here lod3.wrl
        shutil.copy2(source1, target1) #shutil deals correctly with spaces in filenames
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod3", message="Oops! Couldn't copy wrl file!")
        sys.exit()

#emeditor copy header
#copy headers to the freshly exported obj/wrl files
    emed = os.path.normpath("\"" + emeditorDir + "\\EmEditor.exe" + "\"") 
    source2 = "\"" + modelDir + "lod2_png" + "\\" + LMname + ".wrl" + "\""
    target2 = "\"" + modelDir + "lod3" + "\\" + "lod3.wrl" + "\""
    if Force.get() == 0:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\\TT_copy02.jsee" + "\"" 
    else:
        macro = "/act /mf " + "\"" + emeditorDir + "\\Macros\\TT_copy02_force.jsee" + "\"" 
    res = subprocess.call(emed + " " + source2 + " " + target2 + " " + macro)
    if res != 0:
        tkMessageBox.showinfo(title="TT AutoExport - lod3", message="Oops! Couldn't excute EmEditor properly!")
        sys.exit()

#rename file
    source3 = modelDir + "lod3" + "\\" + "lod3.wrl"
    target3 = modelDir + "lod3" + "\\" + LMname + ".wrl"
    try: #rename wrl and obj files
        shutil.move(source3, target3) #shutil deals with spaces in paths
    except:
        tkMessageBox.showinfo(title="TT AutoExport - lod3", message="Oops! Couldn't rename wrl file!")
        sys.exit()

# MAIN UI
def callbackCancel():
    print "Cancelled"
    root.destroy()
    sys.exit()

def callbackExportAll():
    exportLod2png()
    exportLod2jpg()
    exportLod1png()
    exportLod1jpg()
    exportLod3()
    #tkMessageBox.showinfo(title="TT AutoExport", message="Ok")
    root.destroy()
    sys.exit()

def callbackExportCurrent():
    exportLodCurrent()
    root.destroy()

def callbackForceTogggle():
    state = Force.get()
    configWrite("general", "force", str(state))
    #root.destroy()

def callbackSetEmEditor():
    selected = fileDirSelect("Exe files", "*.exe", "Please select EmEditor.exe", "EmEditor.exe")
    configWrite("general", "emeditordir", selected)
    root.destroy()

def callbackSetImgMagick():
    selected = fileDirSelect("Exe files", "*.exe", "Please select ImageMagick Convert.exe", "convert.exe")
    configWrite("general", "imgmagick", selected)
    root.destroy()


#first frame
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
lbl6a = Tkinter.Label(frame1export, justify=Tkinter.LEFT, text="Exporting from: ")
lbl6a.pack(side=Tkinter.LEFT)
lbl6b = Tkinter.Label(frame1export, fg="#007ACC", anchor=Tkinter.W, justify=Tkinter.LEFT, text=LMfolder)
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
 
#lbl50 = Tkinter.Label(lblFrameOptions, text="Options Frame\n")
#lbl50.pack()

check1Force = Tkinter.Checkbutton(lblFrameOptions, text="Silent Mode", variable=Force, command=callbackForceTogggle)
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
