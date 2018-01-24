#TT Folder System Creation
#2016, mocapi
#ver 1.0

import Tkinter, tkFileDialog, tkSimpleDialog
import os, time, sys, shutil
import errno, re

#initialise Tkinter
root = Tkinter.Tk()
root.withdraw() #use to hide tkinter window

# First get directory to create in
currdir = os.getcwd()
deliveryDirSelect = tkFileDialog.askdirectory(parent=root, initialdir=currdir, title='Please select a directory')
if len(deliveryDirSelect) > 0:
    print "You selected root folder \n" + deliveryDirSelect    #this is with wrong slashes

# Create Folder Safely
def makeDir(path):
    try:
        #print(path)
        os.makedirs(path)
    except OSError as exception:
        if exception.errno != errno.EEXIST:
            raise
            print exception.message

# create necessary files from scratch
def createFile(filepath, filename, txtContent):    
    file = open(os.path.join(filepath, filename), "w")
    file.write(txtContent.encode('utf8'))
    file.close()

def createXls(filepath, cityname):
    shutil.copy2('SourceFiles/template.xls', os.path.join(filepath, cityname + ".xls"))

def createUtmZ(currentDir, baseFolder, utmZ, LMdataList):
    filename="utmzone_" + baseFolder[4:7] + ".txt"
    content = "LM-ID|UTMZone\n"
    for x in range(len(LMdataList)):
       content += LMdataList[x][0] + "|" + utmZ + "\n"
    content = content[0:len(content)-1]
    createFile(currentDir, filename, content)

def createVersionFile(currentDir, baseFolder, today, LMid):
    filename=LMid + "_version.txt"
    content = LMid + "\n" + "\nVERSION 1.0\n\n" + today + "\n\n" + """LOD1:
- LOD1_JPG: VRML (wrl) / OBJ (obj, mtl) with Texturatlas (jpg)
- LOD1_PNG: VRML (wrl) / OBJ (obj, mtl) with Texturatlas (png)

LOD2:
- LOD2_JPG: VRML (wrl) / OBJ (obj, mtl) with Texturatlas (jpg)
- LOD2_PNG: VRML (wrl) / OBJ (obj, mtl) with Texturatlas (png)

LOD3:
- LOD3: VRML (wrl) with Textures (png and jpg)

Image:
- front and back photos
- one image showing front and back merged together
- screnshot image (building and entrypoint from 3dsMax)
- info image"""
    createFile(currentDir, filename, content)
        
def createImages(filepath, LMid):
    shutil.copy2('SourceFiles/dsc_1.jpg', os.path.join(filepath, "dsc_1.jpg"))
    shutil.copy2('SourceFiles/dsc_2.jpg', os.path.join(filepath, "dsc_2.jpg"))
    shutil.copy2('SourceFiles/info.jpg', os.path.join(filepath, "info.jpg"))
    shutil.copy2('SourceFiles/lmname_screenshot.jpg', os.path.join(filepath, LMid + "_screenshot.jpg"))
    shutil.copy2('SourceFiles/lmname.jpg', os.path.join(filepath, LMid + ".jpg"))

def createEntrypoint(currentDir, LMid, LMcoord):
    filename=LMid + ".entrypoint"    
    content = re.sub(' +','\n',LMcoord)
    createFile(currentDir, filename, content)

def createMTL(currentDir, LMid):
    filename=LMid + ".mtl"
    content = "newmtl texture_" + LMid + "_png\n" + """  Ns 26.4
  d 1
  illum 2
  Kd 1.0 1.0 1.0
  Ka 0.2 0.2 0.2
  Ks 0 0 0
  map_Kd """ + LMid + ".png" 
    createFile(currentDir, filename, content)

def createOBJ(currentDir, utmZ, LMid, LMcoord):
    filename=LMid + ".obj"
    content = '''# Exported by Chaosgroup LTD
# entrypoint(WGS84):  ''' + LMcoord + '\n# utm zone: WGS84UTM_ZONE_' + utmZ.upper() + '''
mtllib ''' + LMid + '''.mtl
#

# 627 texture coords

usemtl texture_''' + LMid + '''_png

s off
'''
    createFile(currentDir, filename, content)

def createWRL(currentDir, utmZ, LMid, LMcoord):
    filename=LMid + ".wrl"
    degree_sign = u'\N{DEGREE SIGN}'
    content = '''#VRML V2.0 utf8 
WorldInfo { 
 title "''' + LMid + '''"
 info [ 
    "Exported by Chaosgroup LTD", 
    "entrypoint(WGS84): ''' + LMcoord + '''",
    "utm zone: WGS84UTM_ZONE_''' + utmZ.upper() + '''"
 ] 
} 

DirectionalLight {
    on TRUE
    intensity 0.8
    color 1 1 1
    direction 0 -1 -1 # South, 45''' + degree_sign + '''
}
DirectionalLight {
    on TRUE
    intensity 0.5
    color 1 1 1
    direction 1 0 0 # West
}
DirectionalLight {
    on TRUE
    intensity 0.4
    color 1 1 1
    direction 0 0 1 # North
}
DirectionalLight {
    on TRUE
    intensity 0.5
    color 1 1 1
    direction -4 -1 0 # East, 14''' + degree_sign + '''
}
 
    Shape {
      appearance Appearance {
        material Material {
          diffuseColor 1 1 1}
        texture ImageTexture {
          url "''' + LMid +'''.png"
        }
      }
'''
    createFile(currentDir, filename, content)


# Create LM Data List
def createLMdataList(lmString, coordinatesString):
    # Cleanup LM string
    lmString = re.sub(' +','',lmString)    #remove spaces
    lmString = re.sub('\n+','\n',lmString)  #replace multiple \n
    lmString = re.sub('^\n+','',lmString)  #replace leading \n
    lmString = re.sub('\n+$','',lmString)  #replace trailing \n
    lmList = lmString.split("\n")

    # Cleanup coordinates string
    coordinatesString = re.sub(' +',' ',coordinatesString)  #replace multiple spaces with one
    coordinatesString = re.sub('\n+','\n',coordinatesString)  #replace multiple \n
    coordinatesString = re.sub('^ +','',coordinatesString)  #remove leading spaces
    coordinatesString = re.sub(' +$','',coordinatesString)  #remove  trailing spaces
    coordinatesString = re.sub('^\n+','',coordinatesString)  #remove leading \n
    coordinatesString = re.sub('\n+$','',coordinatesString)  #remove trailing \n   
    coordinatesString = re.sub('\t+',' ',coordinatesString)    #replace tabs with space
    coordinatesString = re.sub(' +',' ',coordinatesString)  #replace multiple spaces with one
    coordinatesList = coordinatesString.split("\n")

    if len(lmList) != len(coordinatesList):
        print "Houston, we have a problem!\nNumber of LM Ids (", len(lmList), ") does not match the number of coordinates supplied (", len(coordinatesList), ")."
    else:
        tempLMdata=[None, None]
        LMdataList=[tempLMdata] * len(lmList)
        for x in range(len(lmList)):
                tempLMdata=[(lmList[x]).strip(),(coordinatesList[x]).strip()]
                LMdataList[x] = tempLMdata
        return LMdataList;

# Create folder structure
def createFolders(parentFolder, baseFolder, utmZ, cityname, LMdataList):
    print ">> Start Creating Folders <<"
    today = time.strftime("%Y-%m-%d", time.gmtime())
    todayName = time.strftime("_%Y_%m_%d_Delivery", time.gmtime())

    # Create the base folders
    exportBase = parentFolder + "\\" + baseFolder + todayName + "\\" + baseFolder + "\\" + baseFolder
    sourceBase = parentFolder + "\\" + baseFolder + todayName + "\\" + baseFolder + "\\" + baseFolder + "_3d_source"
    makeDir(parentFolder + "\\" + baseFolder + todayName)                                                           # make base folder - mys_aos_2015_2016_xx_xx_Delivery
    makeDir(parentFolder + "\\" + baseFolder + todayName + "\\" + baseFolder)                                       # make subbase folder - mys_aos_2015
    currentDir = parentFolder + "\\" + baseFolder + todayName + "\\" + baseFolder + "\\" + baseFolder
    makeDir(currentDir)                                     # make export folder - mys_aos_2015
    createXls(currentDir, cityname)                         # create excel
    createUtmZ(currentDir, baseFolder, utmZ, LMdataList)    # create utmzone
    makeDir(parentFolder + "\\" + baseFolder + todayName + "\\" + baseFolder + "\\" + baseFolder + "_3d_source")    # make source folder - mys_aos_2015_3d_source

    # Create LM folders for each landmark
    for x in range(len(LMdataList)):
        makeDir(sourceBase + "\\" + LMdataList[x][0])       #LM folder in source folder
        currentDir = exportBase + "\\" + LMdataList[x][0]
        makeDir(currentDir)                                 #LM folder in export folder
        createVersionFile(currentDir, baseFolder, today, LMdataList[x][0]) # create version file
        currentDir = exportBase + "\\" + LMdataList[x][0] + "\image"
        makeDir(currentDir)
        createImages(currentDir, LMdataList[x][0])  # create Images
        currentDir = exportBase + "\\" + LMdataList[x][0] + "\model"
        makeDir(currentDir)
        createEntrypoint(currentDir, LMdataList[x][0], LMdataList[x][1])  # create entrypoint
        makeDir(exportBase + "\\" + LMdataList[x][0] + "\model\lod1_jpg")
        makeDir(exportBase + "\\" + LMdataList[x][0] + "\model\lod1_png")
        makeDir(exportBase + "\\" + LMdataList[x][0] + "\model\lod2_jpg")
        currentDir = exportBase + "\\" + LMdataList[x][0] + "\model\lod2_png"
        makeDir(currentDir)
        createMTL(currentDir, LMdataList[x][0])  # create mtl file
        coord = (LMdataList[x][1]).replace(" ", " deg ") + " deg"
        createOBJ(currentDir, utmZ, LMdataList[x][0], coord)  # create obj template with coordinates
        createWRL(currentDir, utmZ, LMdataList[x][0], coord)  # create wrl template with coordinates
        makeDir(exportBase + "\\" + LMdataList[x][0] + "\model\lod3")
        makeDir(exportBase + "\\" + LMdataList[x][0] + "\shp")
    print ">>> Finished <<<"

# MAIN GUI - Get info to create folder structure and xecute
def callbackBok():
    baseName = os.path.normpath((e1.get()).strip())
    utmZ = os.path.normpath((e2.get()).strip())
    cityname = os.path.normpath((e3.get()).strip())
    lmString = T.get(1.0,Tkinter.END)  
    coordinatesString = T2.get(1.0,Tkinter.END)  
    parentFolder = deliveryDirSelect
    LMdataList = createLMdataList(lmString.lower(), coordinatesString)
    createFolders(parentFolder.lower(), baseName.lower(), utmZ.lower(), cityname.lower(), LMdataList)
    root.destroy()
    sys.exit()
    
def callbackCancel():
    print "Cancelled"
    root.destroy()
    sys.exit()

root = Tkinter.Tk()
root.title("TT Create Export Directory")
root.geometry("300x400")

e1 = Tkinter.Entry(root)
#e1.insert(Tkinter.END, "BaseName (mys_ktn_2015)")
e1.insert(Tkinter.END, "cou_cit_2017")
e1.focus_set()
e1.pack(fill=Tkinter.X)

e2 = Tkinter.Entry(root)
#e2.insert(Tkinter.END, "UTM Zone (47n)")
e2.insert(Tkinter.END, "UTM_Zone")
e2.pack(fill=Tkinter.X)

e3 = Tkinter.Entry(root)
#e3.insert(Tkinter.END, "city name (alor_cetar)")
e3.insert(Tkinter.END, "full_city_name")
e3.pack(fill=Tkinter.X)

T = Tkinter.Text(root, height=8, width=30)
#T.insert(Tkinter.END, "LM list\n(mys_ktn_001)\n(mys_ktn_002)\n")
T.insert(Tkinter.END, "cou_sit_001\ncou_sit_002 \ncou_sit_003")
ScrollBar = Tkinter.Scrollbar(T)
ScrollBar.config(command=T.yview)
T.config(yscrollcommand=ScrollBar.set)
ScrollBar.pack(side=Tkinter.RIGHT, fill=Tkinter.Y)
T.pack(expand=Tkinter.YES, fill=Tkinter.BOTH)

T2 = Tkinter.Text(root, height=8, width=30)
#T2.insert(Tkinter.END, "LM coordinates")
T2.insert(Tkinter.END, "100.00 -5.00\n100.00 -5.00\n100.00 -5.00\n")
ScrollBar2 = Tkinter.Scrollbar(T2)
ScrollBar2.config(command=T2.yview)
T2.config(yscrollcommand=ScrollBar2.set)
ScrollBar2.pack(side=Tkinter.RIGHT, fill=Tkinter.Y)
T2.pack(expand=Tkinter.YES, fill=Tkinter.BOTH)

b1Ok = Tkinter.Button(root, text="Create folder structure", command=callbackBok)
b1Ok.pack(side=Tkinter.TOP, fill=Tkinter.X)

b2Test = Tkinter.Button(root, text="Cancel", command=callbackCancel)
b2Test.pack(side=Tkinter.TOP, fill=Tkinter.X)

Tkinter.mainloop()

