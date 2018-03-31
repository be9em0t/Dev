#NoEnv
#SingleInstance Force
 
OnMessage(0x200, "MouseMove")
 
Gui, Margin, 50, 50
Gui, Add, Picture,  Icon8 vMyPic1 +0x0100, %A_WinDir%\System32\shell32.dll
Gui, Add, Picture,  Icon22 vMyPic2 +0x0100, %A_WinDir%\System32\shell32.dll
Gui, Show,, test
 
Return
 
MouseMove(wParam, lParam, Msg, hWnd)
{
    static shown, Overlay_id

    Gui, %A_Gui%: +HwndhGui
    
    if (hwnd = Overlay_id) ; return if mouse over overlay gui
        return
    
    if ((A_GuiControl = "MyPic1") || (A_GuiControl = "MyPic2")) and (!shown)
        {
            
            shown := true
            GuiControlGet, %A_GuiControl%, Pos
            
            X := %A_GuiControl%x
            Y := %A_GuiControl%y
            w := %A_GuiControl%w
            h := %A_GuiControl%h
            
            VarSetCapacity(POINT, 8, 0)
            NumPut(X, POINT, 0, "Int")
            NumPut(Y, POINT, 4, "Int")
            DllCall("User32.dll\ClientToScreen", "Ptr", hGui, "Ptr", &POINT)
            X := NumGet(POINT, 0, "Int")
            Y := NumGet(POINT, 4, "Int")
            
            DetectHiddenWindows on
            Gui, 2: Color, FFFFFF
            Gui, 2: +hwndOverlay_id +owner%hGui%
            WinSet, Transparent, 100, ahk_id %Overlay_id%
            Gui, 2: -Caption +ToolWindow
            Gui, 2: show, x%x% y%y% h%h% w%w% NA
            DetectHiddenWindows off

        }
        else
        {
            Gui, 2:Destroy
            shown := false
        }
}