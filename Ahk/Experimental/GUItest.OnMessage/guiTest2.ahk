; #NoTrayIcon
; Menu, Tray, Icon, %A_ScriptDir%\b9MiscRes\P-icon.ico, 0
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

CustomColor = Fuchsia  ; Can be any RGB color (it will be made transparent below).
Gui, Color, %CustomColor%
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow ; Make the GUI window the last found window for use by the line below.
WinSet, TransColor, %CustomColor% 250

global ImgButt1 = "ImgButt1"
global ImgButt2 = "ImgButt2"
global ImgButt3 = "ImgButt3"
global Act1 = "Act1"
global Act2 = "Act2"
global Act3 = "Act3"

; Main
  PrepareMainUi()

#`::
  ShowMainUi()
return

#Ins::
  Run, "c:\Ketarin\Design\Xnview\XnView\xnview.exe" "-capture=window"
return

!#Ins::
  Run, "c:\Ketarin\Design\Xnview\XnView\xnview.exe" "-capture=desktop"
return

PrepareMainUi(){
Gui, Add, Picture, x0 y0 w48 h48 vImgButt1 0x100 , C:\Work\OneDrive\Dev\Ahk\Experimental\GUItest2\orange.png
Gui, Add, Picture, x50 y0 w48 h48 vImgButt2 0x100, C:\Work\OneDrive\Dev\Ahk\Experimental\GUItest2\green.png
Gui, Add, Picture, x100 y0 w48 h48 vImgButt3 0x100, C:\Work\OneDrive\Dev\Ahk\Experimental\GUItest2\blue.png
Gui, Add, Picture, x0 y50 w0 h0 , C:\Work\OneDrive\Dev\Ahk\Experimental\GUItest2\underInactive.png
Gui, Add, Picture, x50 y50 w0 h0 , C:\Work\OneDrive\Dev\Ahk\Experimental\GUItest2\underInactive.png
Gui, Add, Picture, x100 y50 w0 h0 , C:\Work\OneDrive\Dev\Ahk\Experimental\GUItest2\underInactive.png
Gui, Add, Picture, x0 y50 w0 h0 vAct1 , C:\Work\OneDrive\Dev\Ahk\Experimental\GUItest2\underActive.png
Gui, Add, Picture, x50 y50 w0 h0 vAct2 , C:\Work\OneDrive\Dev\Ahk\Experimental\GUItest2\underActive.png
Gui, Add, Picture, x100 y50 w0 h0 vAct3 , C:\Work\OneDrive\Dev\Ahk\Experimental\GUItest2\underActive.png
}

ShowMainUi(){
  ButtsInitial()
  Gui, Show
  SetTimer, TestHover , On
}

TestHover(){
    OnMessage(0x200 , "MOUSEOVER")
}

MOUSEOVER()
{
  If %A_GuiControl% {
      SetTimer, TestHover , Off
      SetTimer, OffHover , On
      OnHover()
      }
}

OnHover(){
  ; ToolTip %A_GuiControl%
      If (%A_GuiControl% = %ImgButt1%) {
        GuiControl, Show, Act1
        GuiControl, Hide, Act2
        GuiControl, Hide, Act3
      }     
      Else If (%A_GuiControl% = %ImgButt2%) {
        GuiControl, Hide, Act1
        GuiControl, Show, Act2
        GuiControl, Hide, Act3
      }
      Else If (%A_GuiControl% = %ImgButt3%) {
        GuiControl, Hide, Act1
        GuiControl, Hide, Act2
        GuiControl, Show, Act3
      }     
      Else If (%A_GuiControl% = "") {
        Sleep, 20
      }
      Else {
        ListVars
        Pause
        ToolTip Wrong...
      }
}

OffHover(){
  ButtsInitial()
  Sleep, 1000
  Gui, Cancel
  SetTimer, OffHover , Off
}

GuiClose:
  ExitApp
Return

ButtsInitial(){
  GuiControl, Hide, Act1
  GuiControl, Hide, Act2
  GuiControl, Hide, Act3
}


GuiEscape:
; GuiClose:
; ButtonCancel:
ExitApp  ; All of the above labels will do this.