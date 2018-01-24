import win32gui

def enumHandler(hwnd, lParam):
    if win32gui.IsWindowVisible(hwnd):
        if 'Flight' in win32gui.GetWindowText(hwnd):
            #win32gui.MoveWindow(hwnd, 0, 0, 760, 500, True)
            print "exists"

win32gui.EnumWindows(enumHandler, None)


