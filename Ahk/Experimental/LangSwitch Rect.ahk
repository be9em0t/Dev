Menu, Tray, Icon, c:\Work\OneDrive\Documents Vla\begemotUI\Icons\[Replacements]\Language.ico, 0

; SCRIPT SHOULD ALWAYS BE LAUNCHED WHILE IN DEFAULT LANGUAGE (EN)

; ===================================
; Draw rectange to mark Language mode

; Box_Init - Creates the necessary GUIs.
; C - The color of the box.
Box_Init(C="FF0000") {
  ; Added WS_EXTENDED_TRANSPARENT to make the overlay click-through
  Gui,+E0x20 +ToolWindow -Caption +AlwaysOnTop +LastFound
  ; Set window to 50% transparency
  WinSet,Transparent,128
  Gui,Color, % C
}


; Box_Draw - Draws a box on the screen using 4 GUIs.
; X - The X coord.
; Y - The Y coord.
; W - The width of the box.
; H - The height of the box.
Box_Draw(X, Y, W, H, O="I") {
  ; No longer adding to the height since using only a single rectangle
  If(W < 0)
    X += W, W *= -1
  If(H < 0)
    Y += H, H *= -1
  ; Removed the options and calculation for the border (T and O) since it no
  ; longer applies. Now the drawing dimensions are completely straight-forward.
  Gui, Show, % "x" X " y" Y " w" W " h" H " NA"
}

; Box_Destroy - Destoyes the 4 GUIs.
Box_Destroy() {
  Gui,Destroy
}

; Box_Hide - Hides the GUI.
Box_Hide() {
  Gui,Hide
}

; Initialize the script and overlay
#SingleInstance,force
SetBatchLines, -1
SetWinDelay, -1
Box_Init("FF0000")

; Get the rectangle size based on Taskbar dimensions
; WinGetPos,,,,h, ahk_class Shell_TrayWnd
; yPad := 29, xPad := 9
; guiW := guiH := 200
; guiX := A_ScreenWidth-guiW-xPad
; guiY := A_ScreenHeight-guiH-h-yPad
; gui, show, x%guiX% y%guiY% w%guiW% h%guiH%, Guigui
WinGetPos,Xrec,Yrec,WidthRec,HeightRec, ahk_class Shell_TrayWnd
sleep, 1000
; By preceding any parameter with "% ", it becomes an expression. In the following example,
; math is performed, a pseudo-array element is accessed, and a function is called.  All these
; items are concatenated via the "." operator to form a single string displayed by MsgBox:
; MsgBox, Tray at  %X% %Y% %Width% %Height%

!#F11::
  Box_Draw(Xrec,Yrec,WidthRec,HeightRec)
Return

+!#F11::
  Box_Hide()
Return


; ===============
; Language Switch

$~F15::LangSwitch(1)
$~F15 up::LangSwitch(2)

LangSwitch( iKeyDownUp=0 )
{
	static tickLast
	IfEqual,iKeyDownUp,1
	{	tickLast=%A_TickCount%
		return
	}
	IfEqual,iKeyDownUp,2
		If( A_TickCount-tickLast>200 )
			return

	HKL:=DllCall("GetKeyboardLayout", "uint",GetThreadOfWindow(), "uint")

	HKLnum:=DllCall("GetKeyboardLayoutList","uint",0,"uint",0)
	VarSetCapacity( HKLlist, HKLnum*4, 0 )
	DllCall("GetKeyboardLayoutList","uint",HKLnum,"uint",&HKLlist)
	loop,%HKLnum%
	{	if( NumGet( HKLlist, (A_Index-1)*4 ) = HKL )
		{	HKL:=NumGet( HKLlist, mod(A_Index,HKLnum)*4 )
			break
		}
	}
	ControlGetFocus,ctl,A
	SendMessage,0x50,0,HKL,%ctl%,A ;WM_INPUTLANGCHANGEREQUEST

	; ;show traytip
	; LOCALE_SENGLANGUAGE=0x1001
	; LOCALE_SENGCOUNTRY=0x1002
	; VarSetCapacity( sKbd, 260, 0 )
	; VarSetCapacity( sCountry, 260, 0 )
	; DllCall("GetLocaleInfo","uint",HKL>>16,"uint",LOCALE_SENGLANGUAGE, "str",sKbd, "uint",260)
	; DllCall("GetLocaleInfo","uint",HKL & 0xFFFF,"uint",LOCALE_SENGCOUNTRY, "str",sCountry, "uint",260)
	; traytip,%sKbd%,%sCountry%
	; Sleep 30
	; Box_Draw(Xrec,Yrec,WidthRec,HeightRec)
	; SetTimer,REMOVE_TOOLTIP,500 ;0.5 second
	; return
	; REMOVE_TOOLTIP:
	; Box_Hide()
	; SetTimer,REMOVE_TOOLTIP,off
	; traytip
	; return
}

;returns first thread for the <processID>
;sets optional <List> to pipe | separated thread list for the <processID>
GetProcessThreadOrList( processID, byRef list="" )
{
	;THREADENTRY32 {
	THREADENTRY32_dwSize=0 ; DWORD
	THREADENTRY32_cntUsage = 4	;DWORD
	THREADENTRY32_th32ThreadID = 8	;DWORD
	THREADENTRY32_th32OwnerProcessID = 12	;DWORD
	THREADENTRY32_tpBasePri = 16	;LONG
	THREADENTRY32_tpDeltaPri = 20	;LONG
	THREADENTRY32_dwFlags = 24	;DWORD
	THREADENTRY32_SIZEOF = 28

	TH32CS_SNAPTHREAD=4

	hProcessSnap := DllCall("CreateToolhelp32Snapshot","uint",TH32CS_SNAPTHREAD, "uint",0)
	ifEqual,hProcessSnap,-1, return

	VarSetCapacity( thE, THREADENTRY32_SIZEOF, 0 )
	NumPut( THREADENTRY32_SIZEOF, thE )

	ret=-1

	if( DllCall("Thread32First","uint",hProcessSnap, "uint",&thE ))
		loop
		{
			if( NumGet( thE ) >= THREADENTRY32_th32OwnerProcessID + 4)
				if( NumGet( thE, THREADENTRY32_th32OwnerProcessID ) = processID )
				{	th := NumGet( thE, THREADENTRY32_th32ThreadID )
					IfEqual,ret,-1
						ret:=th
					list .=  th "|"
				}
			NumPut( THREADENTRY32_SIZEOF, thE )
			if( DllCall("Thread32Next","uint",hProcessSnap, "uint",&thE )=0)
				break
		}

	DllCall("CloseHandle","uint",hProcessSnap)
	StringTrimRight,list,list,1
	return ret
}

; Returns thread owning specified window handle
; default = Active window
GetThreadOfWindow( hWnd=0 )
{
	IfEqual,hWnd,0
		hWnd:=WinExist("A")
	DllCall("GetWindowThreadProcessId", "uint",hWnd, "uintp",id)
	GetProcessThreadOrList(  id, threads )
	IfEqual,threads,
		return 0
	CB:=RegisterCallback("GetThreadOfWindowCallBack","Fast")
	lRet=0
	lParam:=hWnd
	loop,parse,threads,|
	{	NumPut( hWnd, lParam )
		DllCall("EnumThreadWindows", "uint",A_LoopField, "uint",CB, "uint",&lParam)
		if( NumGet( lParam )=true )
		{	lRet:=A_LoopField
			break
		}
	}
	DllCall("GlobalFree", "uint", CB)
	return lRet
}

GetThreadOfWindowCallBack( hWnd, lParam )
{
	IfNotEqual,hWnd,% NumGet( 0+lParam )
		return true
	NumPut( true, 0+lParam )
	return 0
}

