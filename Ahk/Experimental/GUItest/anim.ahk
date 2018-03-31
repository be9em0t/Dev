#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Gui, Margin, 0,0
Gui +LastFound
GUI_ID:=WinExist() 
Gui,Show,w400 h300 Hide, Animated Window ( Fade-In / Fade-Out )
DllCall("AnimateWindow","UInt",GUI_ID,"Int",500,"UInt","0xa0000")
Return

GuiEscape:
GuiClose:
  DllCall("AnimateWindow","UInt",GUI_ID,"Int",500,"UInt","0x90000")
  ExitApp
Return