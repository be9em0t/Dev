
; #NoTrayIcon
Menu, Tray, Icon, c:\Work\OneDrive\Documents Vla\begemotUI\Icons\[Replacements]\P-icon.ico, 0
; Menu, Tray, Icon, c:\Work\OneDrive\Documents Vla\begemotUI\Icons\[More icons]\Skepticat.ico, 0
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; #SingleInstance Ignore
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

global MouseX
global MouseY
global PopUIw := 96
global PopUIh := 96
global TimerHide := 1200
global AnimSpeed := 10
global AnimSteps := 5


; Main
Gosub popupUIPrepare
Gosub menu1QuadPrepare
Gosub menu4QuadPrepare

#`::
  Gosub ShowUI
return

#Ins::
  Run, "c:\Ketarin\Design\Xnview\XnView\xnview.exe" "-capture=window"
return

!#Ins::
  Run, "c:\Ketarin\Design\Xnview\XnView\xnview.exe" "-capture=desktop"
return

; t::
; MouseOverRect()
; return

; PopupMainUI
popupUIPrepare:
CustomColor = Fuchsia  ; Can be any RGB color (it will be made transparent below).

Gui, Color, %CustomColor%
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow ; Make the GUI window the last found window for use by the line below.
WinSet, TransColor, %CustomColor% 254

; Gui, Font, s18, Arial ; Set a large font size (32-point).
; Gui, Add, Text, vMyText cRed -Border, XXXXX YYYYY  ; XX & YY serve to auto-size the window.
; Gui, Add, Button, gMsgTest Default, Ok
Gui, Add, Picture, gMenu1Show x0 y0 w48 h-1, %A_ScriptDir%\a.png
Gui, Add, Picture, grunProg x48 y0 w48 h-1, %A_ScriptDir%\b.png
Gui, Add, Picture, gHideUI x0 y48 w48 h-1, %A_ScriptDir%\c.png
Gui, Add, Picture, gMenu4Show x48 y48 w48 h-1, %A_ScriptDir%\d.png

; SetTimer, HideUI, 2500
; Gosub, HideUI  ; Make the first update immediate rather than waiting for the timer.

MouseGetPos, MouseX, MouseY
Gosub ShowUI
; Gui, Show, X%MouseX% Y%MouseY% W%PopUIw% H%PopUIh% NoActivate  
return

; Menu
; EXAMPLE #2: This is a working script that creates a popup menu that is displayed when the user presses the Win-Z hotkey.
menu1QuadPrepare:
; Create the popup menu by adding some items to it.
Menu, Menu1quad, Add, begemot Gmail, MenuHandlerPaste
Menu, Menu1quad, Add, begemot Outlook, MenuHandlerPaste
Menu, Menu1quad, Add  ; Add a separator line.

; Create another menu destined to become a submenu of the above menu.
Menu, Submenu1, Add, Item1, MenuHandler
Menu, Submenu1, Add, Item2, MenuHandler

; Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.
Menu, Menu1quad, Add, My Submenu, :Submenu1

Menu, Menu1quad, Add  ; Add a separator line below the submenu.
Menu, Menu1quad, Add, Item3, MenuHandler  ; Add another menu item beneath the submenu.
return  ; End of script's auto-execute section.

menu4QuadPrepare:
; Create the popup menu by adding some items to it.
Menu, Menu4quad, Add, Test Info, TestInfo
Menu, Menu4quad, Add, Item2, MenuHandler
Menu, Menu4quad, Add  ; Add a separator line.

; Create another menu destined to become a submenu of the above menu.
Menu, Submenu2, Add, Start PowerPro, MenuHandlerPPro
Menu, Submenu2, Add, Item2, MenuHandler

; Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.
Menu, Menu4quad, Add, My Submenu, :Submenu2

Menu, Menu4quad, Add  ; Add a separator line below the submenu.
Menu, Menu4quad, Add, Quit, MenuHandlerQuit  ; Add another menu item beneath the submenu.
return  ; End of script's auto-execute section.

; Function MouseOverRect
MouseOverRect()
{
	MouseGetPos MouseXtmp, MouseYtmp
  if !(MouseXtmp >= MouseX AND MouseXtmp < MouseX + PopUIw AND MouseYtmp >= MouseY AND MouseYtmp < MouseY + PopUIh) 
    Gosub HideUI
}

HideUI:
  Gui, Cancel
return

ShowUI:
  MouseGetPos, MouseX, MouseY
  PopUIwSlice := PopUIw // AnimSteps
  PopUIhSlice := PopUIh // AnimSteps
  PopUIwTmp := 0
  PopUIhTmp := 0
  Loop {
    PopUIwTmp := PopUIwTmp + PopUIwSlice
    PopUIhTmp := PopUIhTmp + PopUIhSlice
    Gui, Show, X%MouseX% Y%MouseY% W%PopUIwTmp% H%PopUIhTmp% NoActivate ; NoActivate avoids deactivating the currently active window.
    Sleep, %AnimSpeed%
  } Until PopUIwTmp >= PopUIw 

  Gui, Show, X%MouseX% Y%MouseY% W%PopUIw% H%PopUIh% NoActivate ; NoActivate avoids deactivating the currently active window.
  SetTimer, MouseOverRect, %TimerHide%
return

runProg:
  run, "C:\Ketarin\Tools\KeePass\KeePass.exe"
return

MsgTest:
MsgBox, The Label1 subroutine is now running.
return

Menu1Show:
  Menu, Menu1quad, Show  ; i.e. press the Win-Z hotkey to show the menu.
return

Menu4Show:
  Menu, Menu4quad, Show  ; i.e. press the Win-Z hotkey to show the menu.
return

MenuHandler:
  MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
return

TestInfo:
MsgBox, "Scriptdir: " %A_ScriptDir% "Script HWIND abd Name" %A_ScriptHwnd% %A_ScriptName%
return

MenuHandlerPaste:
if (A_ThisMenuItem = "begemot Gmail") {
  Send, {AltDown}{Tab}{AltUp}
  Sleep, 100
  Send, be9em0t@gmail.com
}
Else if (A_ThisMenuItem = "begemot Outlook"){
  Send, {AltDown}{Tab}{AltUp}
  Sleep, 100
  Send, be9em0t@outlook.com
}
Else {
  MsgBox You selected shit.
}
return

MenuHandlerPPro:
  run c:\Ketarin\Tools\PowerPro\Powerpro.exe
return

MenuHandlerQuit:
  ExitApp
return

#z::Menu, MyMenu, Show  ; i.e. press the Win-Z hotkey to show the menu.