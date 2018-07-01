; #NoTrayIcon
; Menu, Tray, Icon, %A_ScriptDir%\b9MiscRes\P-icon.ico, 0
Menu, Tray, Tip, LangSwitch - Win+Caps `nTransp - Shift+Win+W `nTopmost - Shift+Win+T `nTraymin - Win+H `nScreenCap - Win+Ins 
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

EnvGet, OneDriveVar, OneDrive
MsgBox, %OneDriveVar%

includeOne = %OneDriveVar%\Dev\Ahk\Includes\ToolTipOpt.ahk
MsgBox, %includeOne%


; V := "C:\TEMP"
; O := OneDriveVar
; FileAppend, test 16, %O%\MyFile16.log   ;C:\TEMP\MyFile16.log  Doesn't seem to matter how many extra \
; FileAppend, test 16, %OneDriveVar%\Dev\Ahk\Includes\MyFile16.log   ;C:\TEMP\MyFile16.log  Doesn't seem to matter how many extra \
MsgBox ErrorLevel=%ErrorLevel%              ;FileAppend test for error. 0=SUCCESS, 1=FAIL

#include includeOne
