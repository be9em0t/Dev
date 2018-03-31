#NoEnv
#SingleInstance Force
 
OnMessage(0x200, "MouseMove")
 
Gui, Margin, 50, 50
Gui, Add, Picture,  Icon6 vMyPic1 +0x0100, %A_WinDir%\System32\shell32.dll
Gui, Add, Picture,  Icon22 vMyPic2 +0x0100, %A_WinDir%\System32\shell32.dll
Gui, Show,, testWindow
 
Return
 
MouseMove()
{
  GoSub WatchCursorTip
}
return

WatchCursor:
MouseGetPos, , , id, control
WinGetTitle, title, ahk_id %id%
WinGetClass, class, ahk_id %id%
; MsgBox, ahk_id %id%`nahk_class %class%`n%title%`nControl: %control%

If (title = "testWindow") { 
  MsgBox, %title%`nControl: %control%
}
return

WatchCursorTip:
MouseGetPos, , , id, control
WinGetTitle, title, ahk_id %id%
WinGetClass, class, ahk_id %id%
ToolTip, ahk_id %id%`nahk_class %class%`n%title%`nControl: %control%
return