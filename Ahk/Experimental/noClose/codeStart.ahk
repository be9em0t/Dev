SetTitleMatchMode, 2
#IfWinActive, Visual Studio Code
!F4::Return
#IfWinActive


Run, Code.exe,,,PID
WinWait, ahk_pid %PID%
DisableCloseButton(WinExist())
WinMinimize

DisableCloseButton(hWnd) {
 hSysMenu:=DllCall("GetSystemMenu","Int",hWnd,"Int",FALSE)
 nCnt:=DllCall("GetMenuItemCount","Int",hSysMenu)
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-1,"Uint","0x400")
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-2,"Uint","0x400")
 DllCall("DrawMenuBar","Int",hWnd)
}


