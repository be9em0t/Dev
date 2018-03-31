#NoTrayIcon
#SingleInstance, Force



If !TaskManID := DllCall("FindWindowA", Str,"#32770", Str,"Task Manager" ) {
    Run, taskmgr.exe,,
    While ! TaskManID := DllCall("FindWindowA", Str,"#32770", Str,"Task Manager" )
     Sleep 20
} Else {
    TaskManID := DllCall("FindWindowA", Str,"#32770", Str,"Task Manager" )
;	msgbox, TaskManID
    WinHide, ahk_id %TaskManID%
}
DisableCloseButton( TaskManID )
Return ;                                                  // End of auto-execute section /

;ExitApp


^!Del:: ; Ctrl+Alt+Del will toggle Hide/Show state for 'Task Manager'
DllCall( "ShowWindow"
    , UInt, TaskManID := DllCall("FindWindowA", Str,"#32770", Str,"Task Manager" )
    , UInt, !DllCall( "IsWindowVisible", UInt,TaskManID ) )
Return

^!x::ExitApp, % DllCall( "ShowWindow", UInt,TaskManID, UInt,1 )

DisableCloseButton( hWnd ) {
 hSysMenu := DllCall( "GetSystemMenu", UInt,hWnd, Int,0 )
 nCnt := DllCall( "GetMenuItemCount", UInt,hSysMenu )
 DllCall( "RemoveMenu", UInt,hSysMenu, UInt,nCnt-1, UInt,0x400 )
 DllCall( "RemoveMenu", UInt,hSysMenu, UInt,nCnt-2, UInt, 0x400 )
 DllCall( "DrawMenuBar", UInt,hWnd )
}