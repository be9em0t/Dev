from Tkinter import *
import os, sys, psutil
import pyuipc

#Check if FSX is running 
#"notepad.exe" in [psutil.Process(i).name for i in psutil.get_pid_list()]

for proc in psutil.process_iter():
    try:
        pinfo = proc.as_dict(attrs=['pid', 'name'])
    except psutil.NoSuchProcess:
        pass
    else:
        print(pinfo)

os.system("pause")
sys.exit()
