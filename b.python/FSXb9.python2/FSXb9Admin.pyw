#!python2

#install psutil, pywin32, pyuipc-0.3.win32-py2.7

#ToDo
#2. Check if FSX is running, and launch if not.
#4. speed sim until paused
#5 ATC aircraft label 3130 (12 char)

from Tkinter import *
import os, sys, time, tkMessageBox
import psutil, win32gui, win32con, win32process
import pyuipc

#get the script directory, set global vars
scriptDir = os.path.dirname(os.path.abspath(__file__))
statePaused = 0
stateOverspeed = 0
stateATC = 0
fuelLow = 3000
stateFuel = 0
statePushback = 3
#stateLoad
#stateSave

# First get some basic settings
# Test for ini file
if (os.path.exists(scriptDir + '\\FSXb9.ini')) == False:
    tkMessageBox.showinfo(title="FSX.b9", message="File FSXb9.ini not found!")
    sys.exit()
# write settings function
def configWrite(section, option, value):
    config = ConfigParser.RawConfigParser()
    config.read(scriptDir + '\\FSXb9.ini')
    config.set(section, option, value)
    with open(scriptDir + '\\FSXb9.ini', "wb") as configfile:
        config.write(configfile)
    return;
# read settings function
def configRead(section, option):
    config = ConfigParser.RawConfigParser()
    try:
        config.read(scriptDir + '\\FSXb9.ini')
    except  :
        tkMessageBox.showinfo(title="FSX.b9", message="Oops! Settings file FSXb9.ini missing!")
        sys.exit()
    try:
        value = config.get(section, option)
    except  :
        tkMessageBox.showinfo(title="FSX.b9", message="Oops! Value " + option + " or section " + section + " missing in FSXb9.ini file!\nDefault value created.")
        configWrite(section, option, "0")
        sys.exit()
    return value;

#Proc to check if FSX is running 
def fsxRunningCheck():
    for proc in psutil.process_iter():
        try:
            procinfo = proc.as_dict(attrs=['pid', 'name'])            
        except psutil.NoSuchProcess:
            pass
        else:
            if procinfo["name"] == "fsx.exe":
                fsxProc = procinfo
                return fsxProc 

def enumHandler(hwnd, lParam):
    global stateATC
    if win32gui.IsWindowVisible(hwnd):        
        if 'ATC Menu' in win32gui.GetWindowText(hwnd):
            #win32gui.MoveWindow(hwnd, 0, 0, 760, 500, True)
            stateATC=1

#Proc to check if ATC window is open and pause if FSX out of focus
def atcCheck():
    global stateATC
    stateATC = 0
    win32gui.EnumWindows(enumHandler, None)
    if stateATC == 1:
        lblAtc.config(bg=clrDarkRoot, fg=clrBlue) # = Label(lblFramePause, text ="ATC", bg=clrDark, fg=clrBlue)
        if fsxFocusCheck() == None:
            pauseOn()
    else:
        lblAtc.config(fg=clrDarkRoot) # = Label(lblFramePause, text ="ATC", bg=clrDark, fg=clrBlue)

#Proc to react for Overspeed and pause if FSX out of focus
def overspeedCheck():
    global stateOverspeed
    win32gui.EnumWindows(enumHandler, None)
    if stateOverspeed == 1:
        lblOverspeed.config(bg=clrWhite, fg=clrOrange) 
        if fsxFocusCheck() == None:
            pauseOn()
    else:
        lblOverspeed.config(fg=clrDarkRoot) 

#Proc to react on Low Fuel 
def fuelCheck():
    global stateFuel
    win32gui.EnumWindows(enumHandler, None)
    if  stateFuel == 1:
        lblFuel.config(bg=clrDarkRoot, fg=clrOrange) 
    else:
        lblFuel.config(bg=clrDark, fg=clrDarkRoot) 

def pauseOn():
    pyuipc.write([(0x0262, "h", 1)])

def pauseToggle():
    global statePaused
    if statePaused == 1:
        newState = 0
    else:
        newState = 1
    pyuipc.write([(0x0262, "h", newState)])

def fsxFocusCheck():
    if (win32process.GetWindowThreadProcessId(win32gui.GetForegroundWindow()))[1] == fsxProc["pid"]:
        return 1

def windowEnumerationHandler(hwnd, top_windows):
    top_windows.append((hwnd, win32gui.GetWindowText(hwnd)))
 
def fsx2front(): 
    if __name__ == "__main__":
        results = []
        top_windows = []
        win32gui.EnumWindows(windowEnumerationHandler, top_windows)
        for i in top_windows:
            if "microsoft flight simulator x with wideserver" in i[1].lower():
                print i
                win32gui.ShowWindow(i[0],win32con.SW_RESTORE)
                win32gui.SetForegroundWindow(i[0])
                # win32gui.BringWindowToTop(i[0])
                # win32gui.SetActiveWindow(i[0])
                # win32gui.ShowWindow(i[0],5)
                break
        
def pyUIPCtest():
    print "Not implemented yet"

def pushbackToggle():
    global statePushback
    if statePushback == 3:
        newState = 0
        btnPushback.config(bg=clrOrange)
    else:
        newState = 3
        btnPushback.config(bg=clrBlue)
        btnPushL.config(bg=clrBlue)
        btnPushR.config(bg=clrBlue)
    pyuipc.write([(0x31F4, "h", newState)])

def pushbackLeft():
    pyuipc.write([(0x31F4, "d", 1)])
    btnPushL.config(bg=clrOrange) 

def pushbackRight():
    pyuipc.write([(0x31F4, "d", 2)])
    btnPushR.config(bg=clrOrange) 

def fsxRun():
    filepath = r'c:\Program Files (x86)\Steam\steamapps\common\FSX\fsx.exe'
    os.startfile(filepath)


# FSXb9 GUI
def GUIBuild():
    global root
    root = Tk()   #(screenName=":0.0")
    root.iconbitmap('py.ico')
    root.title("FSX b9")
  

    # GUI Variables
    rootW = 360 # width for the Tk root
    rootH = 130 # height for the Tk root
    screenW = root.winfo_screenwidth() # width of the screen
    screenH = root.winfo_screenheight() # height of the screen
    rootX = (screenW/2) - (rootW/2)
    rootY = (screenH/2) - (rootH/2) #(hs/2) - (h/2)

    tkRelief= FLAT #FLAT RAISED SUNKEN GROOVE RIDGE
    global clrBlue
    global clrGray
    global clrWhite
    global clrDark
    global clrDarkRoot
    global clrOrange
    clrBlue = "#3998d6"
    clrGray = "Gray"
    clrOrange = "#e04d05"
    clrWhite = "#dddddd"
    clrDark = "#333333" #"#535353"
    clrDarkRoot ="#252525"
    tkButtHeight = 20
    tkButtWidth = 95
    tkMarginL=8
    tkMarginT=10

    # set window position and size
    root.geometry('%dx%d+%d+%d' % (rootW, rootH, rootX, rootY))

    root.configure(bg = clrDarkRoot)
    #root.wm_minsize(50,50)
    ##root.withdraw()
    #root.geometry("+250+250")
    #root.lift()%
    #root.wm_attributes("-topmost", True)
    #root.wm_attributes("-disabled", True)
    #root.wm_attributes("-transparentcolor", "white")
    #root.overrideredirect(True)

    #Frames
    lblFramePause = LabelFrame(root, text="FSX pause", relief=tkRelief, bg = clrDark, fg = clrWhite)
    lblFrameMission = LabelFrame(root, text="FSX mission", relief=tkRelief, bg = clrDark, fg = clrWhite)
    lblFramePause.pack(anchor=NE,  expand=FALSE)
    lblFrameMission.pack(anchor=NE, expand=FALSE)
    lblFramePause.place(relheight=.91, relwidth=.46, relx=.03, rely=.05)
    lblFrameMission.place(relheight=.91, relwidth=.46, relx=.515, rely=.05)

    # Buttons
    global lblAtc
    global lblOverspeed
    global lblFuel
    global btnPaused
    global btnFuel
    global btnFSX2front
    global btnLoad
    global btnSave
    global btnPushback
    global btnPushL
    global btnPushR


    btnPaused = Button(lblFramePause, text ="pause", command=pauseToggle, relief=tkRelief, bg=clrBlue)
    lblAtc = Label(lblFramePause, text ="ATC", bg=clrDark, fg=clrDarkRoot)
    lblOverspeed = Label(lblFramePause, text ="OVERSPEED", bg=clrDark, fg=clrDarkRoot)
    lblFuel = Label(lblFramePause, text ="FUEL LOW", bg=clrDark, fg=clrDarkRoot)
    #btnFuel = Button(lblFramePause, text ="fuel", command=pyUIPCtest, relief=tkRelief, bg=clrBlue)
    btnFSX2front = Button(lblFramePause, text ="2Front", command=fsx2front, relief=tkRelief, bg=clrBlue)
    btnSave = Button(lblFrameMission, text ="save", command=pyUIPCtest, relief=tkRelief, bg=clrBlue)
    btnLoad = Button(lblFrameMission, text ="load", command=pyUIPCtest, relief=tkRelief, bg=clrBlue)
    btnPushback = Button(lblFrameMission, text ="Pushback", command=pushbackToggle, relief=tkRelief, bg=clrBlue)
    btnPushL = Button(lblFrameMission, text ="Pushback L", command=pushbackLeft, relief=tkRelief, bg=clrBlue)
    btnPushR = Button(lblFrameMission, text ="Pushback R", command=pushbackRight, relief=tkRelief, bg=clrBlue)

    btnPaused.pack()
    lblAtc.pack()
    lblOverspeed.pack()
    lblFuel.pack()
    btnFSX2front.pack()
    btnSave.pack()
    btnLoad.pack()
    btnPushback.pack()
    btnPushL.pack()
    btnPushR.pack()
    btnPaused.place(height=tkButtHeight, relwidth=.9, x=tkMarginL, y=tkMarginT)
    lblAtc.place(height=tkButtHeight, x=(2*tkMarginL)+tkButtWidth, y=tkButtHeight+(tkMarginT*2))
    lblOverspeed.place(height=tkButtHeight, x=tkMarginL, y=tkButtHeight+(tkMarginT*2))
    lblFuel.place(height=tkButtHeight, x=tkMarginL, y=(tkButtHeight*2)+(tkMarginT*3))
    btnFSX2front.place(height=tkButtHeight, x=(2*tkMarginL)+tkButtWidth, y=(tkButtHeight*2)+(tkMarginT*3))
    btnSave.place(height=tkButtHeight, width=tkButtWidth*.7, x=tkMarginL, y=tkMarginT)
    btnLoad.place(height=tkButtHeight, width=tkButtWidth*.7, x=(tkMarginL*4) + (tkButtWidth/2), y=tkMarginT)
    btnPushback.place(height=tkButtHeight, relwidth=.9, x=tkMarginL, y=tkButtHeight+(tkMarginT*2))
    btnPushL.place(height=tkButtHeight, width=tkButtWidth*.7, x=tkMarginL, y=(tkButtHeight*2)+(tkMarginT*3))
    btnPushR.place(height=tkButtHeight, width=tkButtWidth*.7, x=(tkMarginL*4) + (tkButtWidth/2), y=(tkButtHeight*2)+(tkMarginT*3))


def UpdateUI():
    global statePaused
    global stateOverspeed
    global statePushback
    if statePaused == 1:
        btnPaused.config(text="Paused", bg=clrOrange)
    else:
        btnPaused.config(text="Running", bg=clrBlue)

global skipCycle
skipCycle=0
def readFSUIPC():
    global statePaused
    global stateOverspeed
    global statePushback
    updateRoot = False
    #read paused and overspeed states
    read = pyuipc.read([(0x0264, "H"),])    #is FSX paused?
    if read != statePaused:
        statePaused = read[0]
        updateRoot = True
    read = pyuipc.read([(0x036D, "H"),]) #is overspeed warning On?
    if read != stateOverspeed:
        stateOverspeed = read[0]
        updateRoot = True
    # read fuel quantity every Nth cycle
    global fuelLow
    global skipCycle
    global stateFuel
    skipCycle += 1
    if skipCycle == 3:
        skipCycle = 0
        read = pyuipc.read([(0x126C, "u"),]) #offsets 1264 and 126C - Total Fuel in Gallons and Total Fuel Weight in Pounds
        if read[0] < fuelLow and stateFuel == 0:
            stateFuel = 1
            fuelCheck()
            updateRoot = True
        elif read[0] >= fuelLow and stateFuel == 1:
            stateFuel = 0
            fuelCheck()
            updateRoot = True
        else:
            pass
    #read pushback states
    read = pyuipc.read([(0x31F0, "d"),]) #31F0 4 Pushback status (FS2002+).3=off, 0=pushing back, 1=pushing back, tail to swing to left (port), 2=pushing back, tail to swing to right (starboard)
    if statePushback != read[0]:
            statePushback = read[0]
            updateRoot = True
            btnPushback.config(bg=clrBlue) 
            btnPushL.config(bg=clrBlue) 
            btnPushR.config(bg=clrBlue) 
            if read[0] == 3:
                pass
            elif read[0] == 0:
                btnPushback.config(bg=clrOrange) 
            elif read[0] == 1:
                btnPushL.config(bg=clrOrange) 
            elif read[0] == 2:
                btnPushR.config(bg=clrOrange) 
            else:
                pass

    #update tk.root window if necessary
    if updateRoot == True:
        overspeedCheck()        
        UpdateUI()

fsxProc = fsxRunningCheck()
if fsxProc == None:
    tkMessageBox.showinfo(title="FSX.b9", message="FSX not running.")

else:
    pyuipc.open(8) #connect to FSX uipc                
    GUIBuild()


def clock():
    readFSUIPC()
    atcCheck()
    root.after(2000, clock) # run itself again after 1000 ms

## run first time
clock()
root.mainloop()

#os.system("pause")
#root.destroy()
sys.exit()
