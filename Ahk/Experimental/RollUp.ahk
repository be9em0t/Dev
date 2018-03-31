Menu, Tray, Icon, c:\Work\OneDrive\Documents Vla\begemotUI\Icons\[Replacements]\Autohotkey.ico, 0
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse

; Set the height of a rolled up window here.  The operating system
; probably won't allow the title bar to be hidden regardless of
; how low this number is:
ws_MinHeight = 25

; This line will unroll any rolled up windows if the script exits
; for any reason:
OnExit, ExitSub
return  ; End of auto-execute section

#z::  ; Change this line to pick a different hotkey.
;Gosub, WindowID
Gosub, RollSub
Return

; Works only in certain Windows context
#IfWinActive, Scene Explorer
; Middle Mouse click Titlebar
~MButton::
 MouseGetPos, X, Y, ID
 If (IsOverTitleBar(X,Y,ID)) {
;	 MsgBox, Title bar!
	 Gosub, RollSub
	 }
return
#IfWinActive

; Works in any Window context
; Middle Mouse click Titlebar
~!MButton::
 MouseGetPos, X, Y, ID
 If (IsOverTitleBar(X,Y,ID)) {
;	 MsgBox, Title bar!
	 Gosub, RollSub
	 }
return

IsOverTitleBar(x, y, hWnd) { 
 SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd% 
 if ErrorLevel in 2,3,8,9,20,21 
  return true 
 else 
  return false 
}


; Below this point, no changes should be made unless you want to
; alter the script's basic functionality.
; Uncomment this next line if this subroutine is to be converted
; into a custom menu item rather than a hotkey.  The delay allows
; the active window that was deactivated by the displayed menu to
; become active again:

Sleep, 200

WindowID:
#IfWinActive, Untitled - Notepad ahk_class Notepad 

!F2::MsgBox,[color=red] This hotkey will work only if two conditions are true:`n1) if active window's title starts with Untitled - Notepad and`n2) if active window's class is Notepad[/color]

return
#IfWinActive	; turn off context sensitivity

RollSub:
WinGet, ws_ID, ID, A
Loop, Parse, ws_IDList, |
{
    IfEqual, A_LoopField, %ws_ID%
    {
        ; Match found, so this window should be restored (unrolled):
        StringTrimRight, ws_Height, ws_Window%ws_ID%, 0
        WinMove, ahk_id %ws_ID%,,,,, %ws_Height%
        StringReplace, ws_IDList, ws_IDList, |%ws_ID%
        return
    }
}
WinGetPos,,,, ws_Height, A
ws_Window%ws_ID% = %ws_Height%
WinMove, ahk_id %ws_ID%,,,,, %ws_MinHeight%
ws_IDList = %ws_IDList%|%ws_ID%
return

ExitSub:
Loop, Parse, ws_IDList, |
{
    if A_LoopField =  ; First field in list is normally blank.
        continue      ; So skip it.
    StringTrimRight, ws_Height, ws_Window%A_LoopField%, 0
    WinMove, ahk_id %A_LoopField%,,,,, %ws_Height%
}
ExitApp  ; Must do this for the OnExit subroutine to actually Exit the script.