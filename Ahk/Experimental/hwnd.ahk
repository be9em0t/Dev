#NoEnv
#SingleInstance force
SetTitleMatchMode 2

pRUN := "code.exe"   
pRunFull := "c:\Ketarin\Data\VSCode\Code.exe"

;^x::
Process, exist, % pRUN   ;Check if program is running 

nPID := ErrorLevel       ;Sets ErrorLevel to the PID 0 if not exist         

If (!nPID){
    Run, % pRunFull ,,, nPID ;If not exist run and store PID
;    msgbox Process not running
           }      
WinActivate, % "ahk_pid " nPID 
WinWait, % "ahk_pid " nPID 
WinGet, hwnd, ID, % "ahk_pid " nPID
Msgbox 0x40000,, % "nPID: " nPID " hwnd: " hwnd
Return

