#!python2

import Tkinter
import tkMessageBox




tkMessageBox.askyesno("Delete", "Are You Sure?", icon='warning')
if 'yes':
    print "Pressed yes"
else:
    print "Not Yet"

sys.exit()

top = Tkinter.Tk()

def deleteme():
    tkMessageBox.askyesno("Delete", "Are You Sure?", icon='warning')
    if 'yes':
        print "Deleted"
    else:
        print "I'm Not Deleted Yet"

B1 = Tkinter.Button(top, text = "Delete", command = deleteme)
B1.pack()
top.mainloop()