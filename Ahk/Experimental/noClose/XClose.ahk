
#F2::DisableCloseButton(WinExist("A"))
#F12::RedrawSysmenu(WinExist("A"))
#F11::RunCode()
Return

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


RunCode(){
    TaskManID := DllCall("FindWindowW", Str,"#32770", Str,"Task Manager" )
	msgbox, %TaskManID%
}


{
DetectHiddenWindows, On

Run, "c:\Ketarin\Data\VSCode\Code.exe",,Min,PID
WinWait, ahk_pid %PID%
DisableCloseButtonCode(WinExist())
}

DisableCloseButtonCode(hWnd) {
 hSysMenu:=DllCall("GetSystemMenu","Int",hWnd,"Int",FALSE)
 nCnt:=DllCall("GetMenuItemCount","Int",hSysMenu)
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-1,"Uint","0x400")
 DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-2,"Uint","0x400")
 DllCall("DrawMenuBar","Int",hWnd)
}