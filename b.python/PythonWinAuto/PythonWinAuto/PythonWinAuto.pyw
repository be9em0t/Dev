#from pywinauto import application
import pywinauto
#app = pywinauto.application.Application()
#app.Start_("Notepad.exe")
#app.Notepad.DrawOutline()
#app.Notepad.MenuSelect("Edit -> Replace")
#app.Replace.PrintControlIdentifiers()

#app = pywinauto.Application.connect(path = r"c:\FreePrograms\TCmd\TOTALCMD64.EXE")
app = pywinauto.Application.connect(title_re = "Total*", class_name = "TTOTAL_CMD")
print app
#app.MenuSelect("Configuration -> Options...")