;====startup=====

;----- Common settings -----
#SingleInstance force
StringCaseSense On
AutoTrim OFF
Process Priority,,High
SetWinDelay 0
SetKeyDelay -1
SetBatchLines -1

;----- Your autoexecute commands -----
;...

;----- Included scripts - direct variant-----
;Run %A_AHKPath% "c:\Users\be9em\Documents\NoClose.ahk"
;Run, %A_MyDocuments%\MyScript2.ahk
;#Include c:\Ketarin\Tools\Autohotkey\Scripts\CodeNoX.ahk
#Include c:\Ketarin\Tools\Autohotkey\Scripts\RollUp.ahk

/*
;----- Included scripts - Gosub variant-----
GoSub SKeySetup
GoSub PariSetup
GoSub ClockSetup
GoSub ClipPadSetup

SKeySetup:
#Include c:\t\AutoHotKey\SKey.ahk

PariSetup:
#Include c:\t\AutoHotKey\pari.ahk

ClockSetup:
#Include c:\t\AutoHotKey\Clock.ahk

ClipPadSetup:
#Include c:\t\AutoHotKey\ClipPad.ahk
*/

;----- Shared subroutines, functions -----
;...