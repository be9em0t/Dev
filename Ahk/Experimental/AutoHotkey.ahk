; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.

; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.


; Menu, Tray, Icon, c:\Work\OneDrive\Documents Vla\begemotUI\Icons\app_vla.icl, 18
;====startup=====
;Run %A_AHKPath% "c:\Users\be9em\Documents\NoClose.ahk"
#Include c:\Users\be9em\Documents\NoClose.ahk

;====Examples===============
#z::Run www.autohotkey.com

^!n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return


^!#n::
Run, notepad.exe
WinWait, Untitled - Notepad, , 3
if ErrorLevel
{
    MsgBox, WinWait timed out.
    return
}
else
    WinMinimize  ; Minimize the window found by WinWait.
return

;=============================

;;invoke Maya Outliner Rollup script
;Run %A_ScriptDir%\AHKRollOutliner.ahk

;Exit the startup script
ExitApp

;Nothing below this line is executed
;================================================================================

;====Middle mouse - Back======
;; middle mouse button - up a folder in explorer
;#IfWinActive, ahk_class CabinetWClass
;~MButton::Send !{Up} 
;#IfWinActive

; middle mouse button - up a folder in Maya - need to limit to file browser
;#IfWinActive, ahk_class QWidget
;~MButton::Send {Backspace} 
;#IfWinActive
 

;====Win+Space===========
; disable ctrl+shift+win+space
^+#space::
Keywait LWin
SendInput ^{Space}
return

; disable shift+win+space
+#space::
Keywait LWin
SendInput ^{Space}
return

; disable ctrl+win+space
^#space::
Keywait LWin
SendInput ^{Space}
return

;; disable win+space
;#space::
;Keywait LWin
;SendInput ^{Space}
;return

;; disable win+` (tablet mode), use as language switch
;#`::
;Keywait LWin
;SendInput ^{Space}
;return


;;======Rollup=======
;~Mbutton::
;
;Delay = 20 ;set time to hold middle button before window moves here
;
;HowLong = 0 
;
;Loop 
;{ 
;HowLong ++ 
;Sleep, 10 
;GetKeyState, MButton, MButton, P 
;IfEqual, MButton, U, Break 
;} 
;IfLess, HowLong, %Delay%, Return 
;
;
;WinGetTitle, OutputVar, A ;Gets the windows title
;
;winactivate ; activates the window
;
;WinRestore, %OutputVar%
;
;IfEqual, OutputVar, Outliner, {
;	MsgBox, Rollup activated %OutputVar%
;	}


;;=====Test Double Click=====
;~RButton::
;if (A_PriorHotkey == A_ThisHotkey AND A_TimeSincePriorHotkey < 350){
;
;	WinGetTitle, OutputVar, A ;Gets the windows title
;	winactivate ; activates the window
;	WinRestore, %OutputVar%
;	IfEqual, OutputVar, Outliner, {
;		MsgBox, Rollup activated %OutputVar%
;		}
;	}
;
;;   Msgbox You double clicked!
;return


;========long pres test========
;~LButton::
;KeyWait,LButton
;if A_TimeSinceThisHotkey >= 850 ; in milliseconds.
;MsgBox,Long Keypress.
;else
;MsgBox,Short Keypress.
;return

;#IfWinActive, Outliner ; 
;~o Up::
;   If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500)
;   MsgBox Double ooo
;Return

;~LButton::
;If (A_TimeSincePriorHotkey < 400 and A_TimeSincePriorHotkey !=-1)
;MsgBox % A_TimeSincePriorHotkey
;Return

;;========long pres test========
;~LButton::
;WinGetTitle, WinTitleVar, A ;Gets the windows title
;
;SetTimer, check, -500
;return
;
;check:
;
;;MouseGetPos, , , id
;;WinGetTitle, title, ahk_id %id%
;;;WinGetClass, class, ahk_id %id%
;;IfEqual, %title%, Outliner, {
;;	MsgBox, Were over %OutputVar%
;;	}
;
;GetKeyState, LState, LButton
;if LState = D
;	WinGetTitle, Title, A
;	MsgBox, The active window is "%Title%"
;
;	;MsgBox, %LState% title
;return
;
