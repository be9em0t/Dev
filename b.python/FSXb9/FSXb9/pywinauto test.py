#import pywinauto

#pwa_app = pywinauto.application.Application()

#w_handle = pywinauto.findwindows.find_windows(title=u'Skype\u2122\u200e - begem0t', class_name='tSkMainForm')[0]

#window = pwa_app.window_(handle=w_handle)

#window.Maximize()
#window.MenuItem(u'&Help->A&bout Skype').Select()

#---------

import pywinauto
import re

pwa_app = pywinauto.application.Application()
w_handle = pywinauto.findwindows.find_windows(title_re=u'Microsoft Flight.*', class_name='FS98MAIN')[0]
window = pwa_app.window_(handle=w_handle)
#window.Maximize()
window.SetFocus()
#window.MenuItem(u'&Help->A&bout Skype').Select()

