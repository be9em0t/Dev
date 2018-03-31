Menu, Tray, Icon, c:\Work\OneDrive\Documents Vla\begemotUI\Icons\[Replacements]\Autohotkey.ico, 0

#Warn
#NoEnv
#SingleInstance force
SetTitleMatchMode 2

EvaluateProcess()

#F12::DisableCloseButton(WinExist("A"))
+#F12::RedrawSysmenu(WinExist("A"))
^+#F12::EvaluateProcess()

Return

EvaluateProcess(){
pEXE := "code.exe"   
pRun := "c:\Ketarin\Data\VSCode\Code.exe"

;^x::
;msgbox Evaluating Process
Process, exist, % pEXE   ;Check if program is running 

nPID := ErrorLevel       ;Sets ErrorLevel to the PID 0 if not exist         
;MsgBox %ErrorLevel%

If (!nPID){
    Run, % pRun ,,, nPID ;If not exist run and store PID
;    msgbox Process not running
	DisableCloseButton(WinExist("A"))
           }      
WinActivate, % "ahk_pid " nPID 
WinWait, % "ahk_pid " nPID 
WinGet, hwnd, ID, % "ahk_pid " nPID
;Msgbox 0x40000,, % "nPID: " nPID " hwnd: " hwnd
 hSysMenu:=DllCall("GetSystemMenu","Int",hwnd,"Int",FALSE)
 nCnt:=DllCall("GetMenuItemCount","Int",hSysMenu)
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-1,"Uint","0x400")
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-2,"Uint","0x400")
 DllCall("DrawMenuBar","Int",hwnd)
Return
}

DisableCloseButton(hWnd="") {
 If hWnd=
    hWnd:=WinExist("A")
 hSysMenu:=DllCall("GetSystemMenu","Int",hWnd,"Int",FALSE)
 nCnt:=DllCall("GetMenuItemCount","Int",hSysMenu)
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-1,"Uint","0x400")
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-2,"Uint","0x400")
 DllCall("DrawMenuBar","Int",hWnd)
Return ""
}


RedrawSysMenu(hWnd="") {
 If hWnd=
    hWnd:=WinExist("A")
 DllCall("GetSystemMenu","Int",hWnd,"Int",TRUE)
 DllCall("DrawMenuBar","Int",hWnd)
Return ""
}

Return