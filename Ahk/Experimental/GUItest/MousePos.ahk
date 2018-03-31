#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

MouseOver(x1, y1, x2, y2)
{
	MouseGetPos xpos, ypos
	detected := xpos >= x1 AND xpos <= x2 AND ypos >= y1 AND ypos <= y2
	return detected
}

;; EXAMPLE USAGE, press and hold hotkey T to test mouse over rectangle area 100, 100 - 200, 200 ?

t::
if MouseOver(10, 10, 800, 800) 
tooltip Area Detected!
else tooltip Mouse NOT in Area
return

x::
ExitApp