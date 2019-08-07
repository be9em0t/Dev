#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIvkeysConstants.au3>
#include <HotKey.au3>
#include <TrayConstants.au3>
#include <Misc.au3>
#include <Crypt.au3>
#include <ProcessConstants.au3>
#include <SecurityConstants.au3>
#include <MenuConstants.au3>
; #include <StructureConstants.au3>
#include <WinAPIHObj.au3>
; #include <WinAPIProc.au3>


; TODO: reposition inside screen
; TODO: ask yes no on Quit
; TODO: minimise some programs on ESC
; TODO: add cur <-> transcoder
; TODO: reposition, resize and rollup windows: WinGetPos. keep children in mind.
; TODO: cleanup autotype (menuA)

#RequireAdmin

; Opt( "GUICoordMode", 0)
; Opt("GUIOnEventMode", 1)
Opt("TrayMenuMode", 0)
Opt("TrayAutoPause", 0) ;0 = no pause, 1 = (default) pause. If there is no DefaultMenu no pause will occurs.
Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase

; --- Variables ----
Local $fScriptVersion = .6
Local $iTransBG=20 ; 
Local Const $iWinTransp = 160;

Global Const $AC_SRC_ALPHA = 1
Global Const $iLanguage = 0x0409
Global $bgImage 
Global $aCurInf
Global $iGuiTimeout = 0
Global Const $iPassTimeout = 50
Global $bRightClickState = False

Global $sKey, $sDataTxt

Global $iGuiHideTimeout = 50
Global $bFirstRun = True, $bGuiState = False
Global $hLastWin
Global Const $bShowBG = False
Global $iLowVal = 5, $iHighVal = 255, $iStepVal = 50, $iSleepVal = 5 ; Fade settings
Global Const $sGuiBRun = "c:\Ketarin\Tools\KP\KeePass.exe"
Global Const $sEditor = "c:\Ketarin\Data\VSCode\Code.exe"
Global Const $sPDFviewer = "c:\Ketarin\Data\SumatraPDF\SumatraPDF.exe"

Local $sIconTray = @ScriptDir & "\Resources\P-icon.ico"
Local $sIconTrayPause = @ScriptDir & "\Resources\Power - Shut Down.ico" ;Security Denied.ico"

If Not IsAdmin() Then MsgBox($MB_SYSTEMMODAL, "", "The script needs admin rights.")
; If IsAdmin() Then MsgBox($MB_SYSTEMMODAL, "", "The script running with admin rights.")

; ===============================================================================================================================
; NOTE: Hotkeys
; ===============================================================================================================================
; ; Assign Hotkey VirtualCode useng HotkeyUDF: https://autoit-script.ru/index.php?topic=296.0
;	; MS Virtual KeyCodes: https://docs.microsoft.com/en-us/windows/desktop/inputdev/virtual-key-codes
; ; Needs Admin Elevation to work everywhere
_HotKey_Assign(BitOR($CK_WIN, $VK_OEM_3), "ShowGUI", BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))

; Toggle Keyboard Language
_HotKey_Assign($VK_F15, "langNext", BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))

; Window Capture
_HotKey_Assign(BitOR($CK_WIN, $VK_INSERT), "_MenuXnVCaptWindow", BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))
_HotKey_Assign(BitOR($CK_WIN, $CK_ALT, $VK_INSERT), "_MenuXnVCaptScreen", BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))
_HotKey_Assign(BitOR($CK_WIN, $CK_SHIFT, $VK_INSERT), "_MenuSnip", BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))

; Window Manipulation
_HotKey_Assign(BitOR($CK_WIN, $CK_SHIFT, 0x57), "_HotkeyWinTransp", BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))

; Block weird Win-keyboard hotkeys: Ctrl+Win+Space, Ctrl+Shift+Win+Space
;+#W:: ; Toggle Trasnparent Win
;+#T:: ; Toggle Topmost

GUIPopBuild()

Func ShowGUI()
	$hLastWin = WinGetHandle("")
	Local $aMPos = MouseGetPos()
	WinMove($hGUIbg, "", $aMPos[0], $aMPos[1])
	WinMove($hGUIbuttA, "", ($aMPos[0]+1), ($aMPos[1]+1))
	WinMove($hGUIbuttB, "", ($aMPos[0]+$iWidth+2), ($aMPos[1]+1))
	WinMove($hGUIbuttC, "", ($aMPos[0]+1), ($aMPos[1]+$iHeight+2))
	WinMove($hGUIbuttD, "", ($aMPos[0]+$iWidth+2), ($aMPos[1]+$iHeight+2))

	GUISetState(@SW_SHOWNORMAL, $hGUIbg)
	GUISetState(@SW_SHOWNORMAL, $hGUIbuttA)
	GUISetState(@SW_SHOWNORMAL, $hGUIbuttB)
	GUISetState(@SW_SHOWNORMAL, $hGUIbuttC)
	GUISetState(@SW_SHOWNORMAL, $hGUIbuttD)

	FadeGuiABCD($iLowVal, $iHighVal, $iStepVal, $iSleepVal)

	$iGuiTimeout = 0
	$bGuiState = True
	$bRightClickState = False
EndFunc	; ==> ShowGUI

Func HideGUI()
	FadeGuiABCD($iHighVal, $iLowVal, ($iStepVal * -1), ($iSleepVal * 5))

	GUISetState(@SW_HIDE, $hGUIbg)
	GUISetState(@SW_HIDE, $hGUIbuttA)
	GUISetState(@SW_HIDE, $hGUIbuttB)
	GUISetState(@SW_HIDE, $hGUIbuttC)
	GUISetState(@SW_HIDE, $hGUIbuttD)

	$iGuiTimeout = 0
	$bGuiState = False
	WinActivate($hLastWin)
EndFunc ; ==> HideGUI

; ===============================================================================================================================
; PopupGUI
; ===============================================================================================================================

Func GUIPopBuild()
	_GDIPlus_Startup()
	; ; button images - must be the same size
	$pngSrcA = @ScriptDir & "\Resources\Icon1.png"
		Global Const $gImageA = _GDIPlus_ImageLoadFromFile($pngSrcA)
	$pngSrcA1 = @ScriptDir & "\Resources\Icon1a.png"
		Global Const $gImageA1 = _GDIPlus_ImageLoadFromFile($pngSrcA1)
	$pngSrcB = @ScriptDir & "\Resources\Icon2.png"
		Global Const $gImageB = _GDIPlus_ImageLoadFromFile($pngSrcB)
	$pngSrcB1 = @ScriptDir & "\Resources\Icon2a.png"
		Global Const $gImageB1 = _GDIPlus_ImageLoadFromFile($pngSrcB1)
	$pngSrcC = @ScriptDir & "\Resources\Icon3.png"
		Global Const $gImageC = _GDIPlus_ImageLoadFromFile($pngSrcC)
	$pngSrcC1 = @ScriptDir & "\Resources\Icon3a.png"
		Global Const $gImageC1 = _GDIPlus_ImageLoadFromFile($pngSrcC1)
	$pngSrcD = @ScriptDir & "\Resources\Icon4.png"
		Global Const $gImageD = _GDIPlus_ImageLoadFromFile($pngSrcD)
	$pngSrcD1 = @ScriptDir & "\Resources\Icon4a.png"
		Global Const $gImageD1 = _GDIPlus_ImageLoadFromFile($pngSrcD1)
	Global $iWidth = _GDIPlus_ImageGetWidth($gImageA)
	Global $iHeight = _GDIPlus_ImageGetHeight($gImageA)

	; background PNG
	$pngSrcBG = @ScriptDir & "\Resources\bg.png"
	$bgImage = _GDIPlus_ImageLoadFromFile($pngSrcBG)
	$ibgWidth = _GDIPlus_ImageGetWidth($bgImage)
	$ibgHeight = _GDIPlus_ImageGetHeight($bgImage)

	; Create Main Layered Window at Mouse Position
	Local $aMPos = MouseGetPos()
	; Global Const $hGUIbg = GUICreate("BgGui", $ibgWidth, $ibgHeight, $aMPos[0], $aMPos[1], $WS_POPUP, $WS_EX_LAYERED)
	Global Const $hGUIbg = GUICreate("BgGui", $ibgWidth, $ibgHeight, $aMPos[0], $aMPos[1], $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOOLWINDOW) )
	Global Const $idMaskA = GUICtrlCreateLabel("", 0,0, $ibgWidth/2,$ibgHeight/2)
	Global Const $idMaskB = GUICtrlCreateLabel("", $ibgWidth/2,0, $ibgWidth/2,$ibgHeight/2)
	Global Const $idMaskC = GUICtrlCreateLabel("", 0,$ibgHeight/2, $ibgWidth/2,$ibgHeight/2)
	Global Const $idMaskD = GUICtrlCreateLabel("", $ibgWidth/2,$ibgHeight/2, $ibgWidth/2,$ibgHeight/2)
	If $bShowBG Then
		_SetBitmap($hGUIbg, $bgImage, 0) 
	EndIf

	GUISetState()
	; GUISetState($GUI_DISABLE, $hGUIbg)
	WinSetOnTop($hGUIbg, "", 1)
	If $bShowBG Then
		_SetBitmap($hGUIbg, $bgImage, $iTransBG) ; NOTE: disable if no BG
	EndIf


	; Create button child GUIs
	Global Const $hGUIbuttA = GUICreate("ButtonA", $iWidth, $iHeight, ($aMPos[0]+1), ($aMPos[1]+1), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	_SetBitmap($hGUIbuttA, $gImageA, 255)
	Global $ContextA = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
	ContextMenuA()
	GUISetState()

	Global Const $hGUIbuttB = GUICreate("ButtonB", $iWidth, $iHeight, ($aMPos[0]+$iWidth+2), ($aMPos[1]+1), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	_SetBitmap($hGUIbuttB, $gImageB, 255)
	GUISetState()

	Global Const $hGUIbuttC = GUICreate("ButtonC", $iWidth, $iHeight, ($aMPos[0]+1), ($aMPos[1]+$iHeight+2), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	_SetBitmap($hGUIbuttC, $gImageC, 255)
	Global $ContextC = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
	ContextMenuC()
	GUISetState()

	Global Const $hGUIbuttD = GUICreate("ButtonD", $iWidth, $iHeight, ($aMPos[0]+$iWidth+2), ($aMPos[1]+$iHeight+2), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	_SetBitmap($hGUIbuttD, $gImageD, 255)
	Global $ContextD = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
	ContextMenuD()
	GUISetState()
	
	If $bFirstRun = True Then
		$bFirstRun = False
		HideGUI()
	EndIf

; ---- Tray Menu ----
	TraySetToolTip("b9Misc AutoIt, ver. " & $fScriptVersion) ; Set the tray menu tooltip with information about the icon index.
	TraySetIcon($sIconTray, 0) ; Set the tray menu icon using the shell32.dll and the random index number.

	Local $idAbout = TrayCreateItem("About")
	Local $idRestart = TrayCreateItem("Restart")
	; Local $idExit = TrayCreateItem("Exit")
	; TrayCreateItem("") ; Create a separator line.

	TraySetPauseIcon($sIconTrayPause, 0) ; Set the pause icon. This will flash on and off when the tray menu is selected and the script is paused.
	TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.
	TraySetClick(BitOR($TRAY_CLICK_PRIMARYDOWN, $TRAY_CLICK_SECONDARYDOWN)) ; Show the tray menu when the mouse if hovered over the tray icon.

; --- Message Events ------
	Local $aMsg = 0
	While 1			
		$aMsg = GUIGetMsg($GUI_EVENT_ARRAY)

		Switch $aMsg[0]
			Case $GUI_EVENT_CLOSE	; Exit
				; ToolTip($aMsg[0])
				HideGUI()
			Case $GUI_EVENT_PRIMARYDOWN ; Leftclick
					Switch $aMsg[1]
						Case $hGUIbuttA	
							Opt('GUIOnEventMode', 1)
							TrackPopupMenu($hGUIbuttA, GUICtrlGetHandle($ContextA), MouseGetPos(0), MouseGetPos(1))																			
						Case $hGUIbuttB	
							_MenuKP()
							HideGUI()
						Case $hGUIbuttC	
							Opt('GUIOnEventMode', 1)
							TrackPopupMenu($hGUIbuttC, GUICtrlGetHandle($ContextC), MouseGetPos(0), MouseGetPos(1))						
						Case $hGUIbuttD	
							Opt('GUIOnEventMode', 1)
							TrackPopupMenu($hGUIbuttD, GUICtrlGetHandle($ContextD), MouseGetPos(0), MouseGetPos(1))						
					EndSwitch
			Case $GUI_EVENT_SECONDARYDOWN ; Rightclick
					ToolTip("RightClick" & $aMsg[0])
			Case $GUI_EVENT_NONE ; Mouseover on Idle
					If $bGuiState Then
							$aCurInf = GUIGetCursorInfo($hGUIbg)
							If $aCurInf[4] = 0 Then
								_SetBitmap($hGUIbuttA, $gImageA, 255)
								_SetBitmap($hGUIbuttB, $gImageB, 255)
								_SetBitmap($hGUIbuttC, $gImageC, 255)
								_SetBitmap($hGUIbuttD, $gImageD, 255)
								$iGuiTimeout = $iGuiTimeout + 1
								if $iGuiTimeout > $iGuiHideTimeout Then 
										HideGUI()
								EndIf
							ElseIf $aCurInf[4] = $idMaskA Then 
								_SetBitmap($hGUIbuttA, $gImageA1, 255)
								_SetBitmap($hGUIbuttB, $gImageB, 255)
								_SetBitmap($hGUIbuttC, $gImageC, 255)
								_SetBitmap($hGUIbuttD, $gImageD, 255)
							ElseIf $aCurInf[4] = $idMaskB Then 
								_SetBitmap($hGUIbuttA, $gImageA, 255)
								_SetBitmap($hGUIbuttB, $gImageB1, 255)
								_SetBitmap($hGUIbuttC, $gImageC, 255)
								_SetBitmap($hGUIbuttD, $gImageD, 255)
							ElseIf $aCurInf[4] = $idMaskC Then 
								_SetBitmap($hGUIbuttA, $gImageA, 255)
								_SetBitmap($hGUIbuttB, $gImageB, 255)
								_SetBitmap($hGUIbuttC, $gImageC1, 255)
								_SetBitmap($hGUIbuttD, $gImageD, 255)
							ElseIf $aCurInf[4] = $idMaskD Then 
								_SetBitmap($hGUIbuttA, $gImageA, 255)
								_SetBitmap($hGUIbuttB, $gImageB, 255)
								_SetBitmap($hGUIbuttC, $gImageC, 255)
								_SetBitmap($hGUIbuttD, $gImageD1, 255)
							Else
								$iGuiTimeout = 0
							EndIf										
					EndIf					
		EndSwitch

		Switch TrayGetMsg()
			Case $idAbout ; Display a message box about the AutoIt version and installation path of the AutoIt executable.
				MsgBox($MB_SYSTEMMODAL, "", _ 
					"b9Misc AutoIt, ver. " & $fScriptVersion & @CRLF & _
					"AutoIt ver.: " & @AutoItVersion & @CRLF & _
					"Install Path: " & StringLeft(@AutoItExe, StringInStr(@AutoItExe, "\", $STR_NOCASESENSEBASIC, -1) - 1)) ; Find the folder of a full path.
			Case $idRestart
				_MenuRestart()		
		EndSwitch

	WEnd

; GDI+ Release resources
	_GDIPlus_ImageDispose($bgImage)
	_GDIPlus_ImageDispose($gImageA)
	_GDIPlus_ImageDispose($gImageB)
	_GDIPlus_Shutdown()
EndFunc ; => GUIPopBuild

; ===============================================================================================================================
; NOTE: Functions 
; ===============================================================================================================================

; === CONTEXT MENU FUNCTIONS ====
Func TrackPopupMenu($hWnd, $hMenu, $x, $y)
    DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "uint", $TPM_RIGHTBUTTON, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
		Sleep(30)
		HideGUI()
		Opt('GUIOnEventMode', 0)
EndFunc   ;==>TrackPopupMenu

; --- ContextMenu A menu functions---
Func ContextMenuA()
	GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "_MenuRightClick")
	; Global $Context = GUICtrlCreateContextMenuA(GUICtrlCreateDummy()) ; this should attach to respective GUI
	Global $mnuEmailOutlook = GUICtrlCreateMenuItem("Begemot O", $ContextA)
		GUICtrlSetOnEvent(-1, '_MenuBgmO_Multi')
	Global $mnuEmailOutlook = GUICtrlCreateMenuItem("Wolan O", $ContextA)
		GUICtrlSetOnEvent(-1, '_MenuWdO_Multi')
	Global $mnuEmailGmail = GUICtrlCreateMenuItem("Begemot G", $ContextA)
		GUICtrlSetOnEvent(-1, '_MenuBgmG_Multi')
	Global $mnuKeta = GUICtrlCreateMenuItem("Keta", $ContextA)
		GUICtrlSetOnEvent(-1, '_MenuKeta')
	Global $mnuKeta = GUICtrlCreateMenuItem("Steam", $ContextA)
		GUICtrlSetOnEvent(-1, '_MenuSteam')
	Global $mnuKeta = GUICtrlCreateMenuItem("Pull", $ContextA)
		GUICtrlSetOnEvent(-1, '_MenuPull_Multi')
	Global $mnuSeparator = GUICtrlCreateMenuItem("", $ContextA) ; Create a separator line
	Global $mnuTimeYMD = GUICtrlCreateMenuItem("Clipboard YearMonthDay", $ContextA)
		GUICtrlSetOnEvent(-1, '_MenuTimeYMD')
	Global $mnuTimeYMD = GUICtrlCreateMenuItem("Clipboard DayMonthYear", $ContextA)
		GUICtrlSetOnEvent(-1, '_MenuTimeDMY')
	Global $mnuTime_D_M_Y = GUICtrlCreateMenuItem("Clipboard Day-Month-Year", $ContextA)
		GUICtrlSetOnEvent(-1, '_MenuTimeD_M_Y')
			Global $submenuScriptA = GUICtrlCreateMenu("Keys", $ContextA) ; Is created before "?" menu	
			Global $mnuTxtGen = GUICtrlCreateMenuItem("Pass2Text", $submenuScriptA)
				GUICtrlSetOnEvent(-1, '_MenuTxtGen')
			Global $mnuPassGen = GUICtrlCreateMenuItem("Text2Pass", $submenuScriptA)
				GUICtrlSetOnEvent(-1, '_MenuPassGen')
			Global $mnuPassAsk = GUICtrlCreateMenuItem("Input Key", $submenuScriptA)
				GUICtrlSetOnEvent(-1, '_MenuKeyAsk')
EndFunc

Func _MenuKeta()
	WinActivate($hLastWin)
	Sleep(30)
	Local $sData = _MenuTxtGen("0x751142BAB1384C544BE8")
	Send($sData, $SEND_RAW)
EndFunc

Func _MenuSteam()
	WinActivate($hLastWin)
	Sleep(30)
	Local $sData = _MenuTxtGen("0x5C3800F5A46C75057BE51D8C")
	Send($sData, $SEND_RAW)
EndFunc

Func _MenuTxtGen($sData = 0)
	HideGUI()
	If $sKey = "" Then _MenuKeyAsk()
	If Not IsDeclared("sData") then 
		$sData = InputBox("Squirrel Question", "Input Encrypted String", "", "*", -1, -1, Default, Default, -1)
	  $vReturn = BinaryToString(_Crypt_DecryptData($sData, $sKey, $CALG_RC4))
		ClipPut ( $vReturn )
		MsgBox(0, "Text", $vReturn, 0)
		ClipPut ( "" )
	Else
		$vReturn = BinaryToString(_Crypt_DecryptData($sData, $sKey, $CALG_RC4))
		Return $vReturn
	EndIf
EndFunc

Func _MenuPassGen()
	HideGUI()
	If $sKey = "" Then _MenuKeyAsk()
	$sData = InputBox("Squirrel Question", "Input Text", "", "*", -1, -1, Default, Default, -1)
	$vReturn = _Crypt_EncryptData($sData, $sKey, $CALG_RC4)
	ClipPut ( $vReturn )
	MsgBox(0, "Data to paste", $vReturn, 8)
	ClipPut ( "" )
EndFunc

Func _MenuKeyAsk()
	HideGUI()
	If not $sKey Then
		Global $sKey = InputBox("Squirrel Question", "Key:", "", "*", -1, -1, Default, Default, -1)
	Else
		MsgBox(0, "Key", "No need now for this")
	EndIf
EndFunc

Func _MenuBgmO_Multi()	;09 - TAB key, 1B - ESC key
	HideGUI()
	WinActivate($hLastWin)
	Sleep(10)
	Send("be9em0t@outlook.com")
	Local $i = $iPassTimeout
	While 1
			$i = $i - 1
		Select
			Case $i < 0
				ToolTip("")
				Return
			Case _IsPressed ("09")				
				; Send("{TAB}")
				Sleep(10)
				Local $sData = _MenuTxtGen("0x7D4842EDB103760651")
				Send($sData, $SEND_RAW)
				ToolTip("")
				Return
			Case _IsPressed ("1B")
				ToolTip("")
				Return
			Case Else
				ToolTip($i)
	EndSelect
		; Avoid high CPU usage.
		Sleep(60)
	WEnd
EndFunc   ;==>_MenuBgmO_Multi

Func _MenuWdO_Multi()	;09 - TAB key, 1B - ESC key
	HideGUI()
	WinActivate($hLastWin)
	Sleep(10)
	Send("wo1and@outlook.com")
	Local $i = $iPassTimeout
	While 1
			$i = $i - 1
		Select
			Case $i < 0
				ToolTip("")
				Return
			Case _IsPressed ("09")				
				; Send("{TAB}")
				Sleep(10)
				Local $sData = _MenuTxtGen("0x210C59BEA0685F2B5C9B")
				Send($sData, $SEND_RAW)
				ToolTip("")
				Return
			Case _IsPressed ("1B")
				ToolTip("")
				Return
			Case Else
				ToolTip($i)
	EndSelect
		; Avoid high CPU usage.
		Sleep(60)
	WEnd
EndFunc   ;==>_MenuWdO_Multi

Func _MenuBgmG_Multi()	;09 - TAB key, 1B - ESC key
	HideGUI()
	Switch $bRightClickState
		Case False
				WinActivate($hLastWin)
				Sleep(10)
				Send("be9em0t@gmail.com")
				Local $i = $iPassTimeout
				While 1
						$i = $i - 1
					Select
						Case $i < 0
							ToolTip("")
							Return
						Case _IsPressed ("09")				
							; Send("{TAB}")
							Sleep(10)
							Local $sData = _MenuTxtGen("0x654906E4B11B4F084B")
							Send($sData, $SEND_RAW)
							ToolTip("")
							Return
						Case _IsPressed ("1B")
							ToolTip("")
							Return
						Case Else
							ToolTip($i)
				EndSelect
					; Avoid high CPU usage.
					Sleep(60)
				WEnd
		Case True
				Sleep(10)
				Local $sData = _MenuTxtGen("0x654906E4B11B4F084B")
				Send($sData, $SEND_RAW)
				ToolTip("")
	EndSwitch
EndFunc   ;==>_MenuBgmG_Multi


Func _MenuPull_Multi()	;09 - TAB key, 1B - ESC key
	HideGUI()
	WinActivate($hLastWin)
	Sleep(10)
	Send("dunevv")
	Local $i = $iPassTimeout
	While 1
			$i = $i - 1
		Select
			Case $i < 0
				ToolTip("")
				Return
			Case _IsPressed ("09")				
				; Send("{TAB}")
				Sleep(10)
				Local $sData = _MenuTxtGen("0x5E3954E4902F455757")
				Send($sData, $SEND_RAW)
				ToolTip("")
				Return
			Case _IsPressed ("1B")
				ToolTip("")
				Return
			Case Else
				ToolTip($i)
	EndSelect
		; Avoid high CPU usage.
		Sleep(60)
	WEnd
EndFunc   ;==>_pull_Multi

Func _MenuTimeYMD()
	WinActivate($hLastWin)
	Sleep(60)
	ClipPut(@YEAR & @MON & @MDAY)
	; Send(@YEAR & @MON & @MDAY)
EndFunc
Func _MenuTimeDMY()
	WinActivate($hLastWin)
	Sleep(60)
	ClipPut(@MDAY & @MON & @YEAR )
	; Send(@MDAY & @MON & @YEAR )
EndFunc
Func _MenuTimeD_M_Y()
	WinActivate($hLastWin)
	Sleep(60)
	ClipPut("_" & @YEAR & "_" &  @MON & "_" & @MDAY)
	; Send("_" & @YEAR & "_" &  @MON & "_" & @MDAY)
EndFunc
; --- ContextMenu C menu functions---
Func ContextMenuC()
	GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "_MenuRightClick")
	; Global $Context = GUICtrlCreateContextMenuA(GUICtrlCreateDummy()) ; this should attach to respective GUI
	Global $mnuSnip = GUICtrlCreateMenuItem("Snipping (Sh+Win+Ins)", $ContextC)
		GUICtrlSetOnEvent(-1, '_MenuSnip')
	Global $mnuSeparatorC = GUICtrlCreateMenuItem("", $ContextC) ; Create a separator line
	Global $mnuWinTransp = GUICtrlCreateMenuItem("Toggle Transparency (Sh+Win+W)", $ContextC)
		GUICtrlSetOnEvent(-1, '_MenuWinTransp')

	; Global $mnuActivate = GUICtrlCreateMenuItem("Window Activate", $ContextC)
	; 	GUICtrlSetOnEvent(-1, '_MenuActivate')
	; Rollup
	; TrayMin
	; OnTop
	; NotOnTop
	; Window Resize >
	; 	> Set Capture BG
	; 	> Restore Background
EndFunc

; Func _MenuActivate()
; 	; Local $iPID = ShellExecute("c:\Ketarin\Tools\AutoIt\Au3Info_x64.exe", "")
; 	MsgBox($MB_OK, "AutoIt", "Window Activate")
; EndFunc

; --- ContextMenu D menu functions---
Func ContextMenuD()
	GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "_MenuRightClick")
	Global $mnuTest = GUICtrlCreateMenuItem("&Test", $ContextD)
		GUICtrlSetOnEvent(-1, '_MenuTest')
	Global $mnuSeparator = GUICtrlCreateMenuItem("", $ContextD) ; Create a separator line
			Global $submenuScript = GUICtrlCreateMenu("S&cript", $ContextD) ; Is created before "?" menu
			Global $mnuAu3Info = GUICtrlCreateMenuItem("&Au3Info", $submenuScript)
				GUICtrlSetOnEvent(-1, '_MenuAu3Info')
			Global $mnuHelp = GUICtrlCreateMenuItem("AutoIt &Help", $submenuScript)
				GUICtrlSetOnEvent(-1, '_MenuAutoItHelp')
			Global $mnuEditScript = GUICtrlCreateMenuItem("&Edit Script", $submenuScript)
				GUICtrlSetOnEvent(-1, '_MenuEditScript')
	Global $mnuSeparator = GUICtrlCreateMenuItem("", $ContextD) ; Create a separator line
	Global $mnuRestart = GUICtrlCreateMenuItem("&Restart", $ContextD)
		GUICtrlSetOnEvent(-1, '_MenuRestart')
	Global $mnuQuit = GUICtrlCreateMenuItem("&Quit", $ContextD)
		GUICtrlSetOnEvent(-1, '_MenuQuit')
EndFunc ;==> ContextMenuD Gui

Func _MenuTest()
	MsgBox(0,"",$bRightClickState)
EndFunc

Func _MenuRightClick()
	$bRightClickState = True
EndFunc


Func _MenuSnip()
  _RunNonElevated("snippingtool.exe" & " ")
	WinWaitActive("Snipping Tool", "", 5)
	Send("^N")
EndFunc

Func _MenuXnVCaptWindow()
  _RunNonElevated("c:\Ketarin\Design\Xnview\XnView\xnview.exe" & " -capture=window")
EndFunc

Func _MenuXnVCaptScreen()
  _RunNonElevated("c:\Ketarin\Design\Xnview\XnView\xnview.exe" & " -capture=desktop")
EndFunc

Func _MenuWinTransp()
	ToggleTrans(0)
EndFunc

Func _HotkeyWinTransp()
	ToggleTrans(1)
EndFunc


Func ToggleTrans($iMode)
    Local $hWnd, $hLast, $trans ;, $hWnd2 

		If $iMode = 0 then ; 0 for mouse location and 1 for active window
			Local $tStruct = DllStructCreate($tagPOINT) ; Create a structure that defines the point to be checked.
			DllStructSetData($tStruct, "x", MouseGetPos(0))
			DllStructSetData($tStruct, "y", MouseGetPos(1))
			$hWnd = _WinAPI_WindowFromPoint($tStruct)
		ElseIf $iMode = 1 Then
    	$hWnd = WinGetHandle("")
		Else 
			MsgBox(0, "b9Misc", "Wrong handle")
			Exit
		EndIf

    Do
        $hLast = $hWnd
        $hWnd = _WinAPI_GetParent($hLast)
    Until $hWnd = 0
    $hWnd = $hLast
    $trans = WinGetTrans($hWnd)
    If $trans < 255 And $trans >= 0 Then
        WinSetTrans($hWnd, "", 255) ; Make fully opaque
    Else
        WinSetTrans($hWnd, "", $iWinTransp) ; Make window semi-transparent (luminosity scale is logarithmic)
    EndIf

EndFunc

Func WinGetTrans($sTitle, $sText = "")
    Local $hWnd = WinGetHandle($sTitle, $sText)
    If Not $hWnd Then Return -1
    Local $val = DllStructCreate("int")
    Local $aRet = DllCall("user32.dll", "int", "GetLayeredWindowAttributes", "hwnd", $hWnd, "ulong_ptr", 0, "int_ptr", DllStructGetPtr($val), "ulong_ptr", 0)
    If @error Or Not $aRet[0] Then Return -1
    Return DllStructGetData($val, 1)
EndFunc

Func _MenuKP()
		If Not ProcessExists("keepass.exe") Then
			_RunNonElevated($sGuiBRun)
		Else
			WinActivate("KeePass")
		EndIf
EndFunc

Func _MenuAu3Info()
	Local $iPID = ShellExecute("c:\Ketarin\Tools\AutoIt\Au3Info_x64.exe", "") ; run elevated

EndFunc

Func _MenuAutoItHelp()
	_RunNonElevated($sPDFviewer & " " & "c:\Ketarin\Tools\AutoIt\AutoIt.chm")
EndFunc

Func _MenuEditScript()
	; Local $iPID = ShellExecute("c:\Ketarin\Data\VSCode\Code.exe", "d:\Work\OneDrive\Dev\AutoIt\b9Misc\b9Misc.au3")
  _RunNonElevated($sEditor & " " & @ScriptFullPath)
EndFunc

Func _MenuPause()
	While 1
		Sleep(100) ; An idle loop.
	WEnd
EndFunc   ;==>Example

Func _MenuQuit()
		Exit
EndFunc

; Restart your program
; Author UP_NORTH

Func _MenuRestart()
    If @Compiled = 1 Then
        Run( FileGetShortName(@ScriptFullPath))
    Else
        Run( FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
    EndIf
    Exit
EndFunc

; === LANGUAGE KBD LAYOUT FUNCTIONS ====
Func langNext() ; uses the Hotkey UDF
  $hGUIlang = GUICreate("GuiLang", 1, 1, @DesktopWidth-1, @DesktopHeight-1, $WS_POPUP, $WS_EX_TOOLWINDOW)
  GUISetState(@SW_SHOW)
	Sleep(60)
	  _WinAPI_ActivateKeyboardLayout($HKL_NEXT)
  GUIDelete($hGUIlang)
EndFunc

; === GUI CALL/FADE FUNCTIONS ====
Func FadeGuiABCD(ByRef $iLowVal, ByRef $iHighVal, ByRef $iStepVal, ByRef $iSleepVal)
	_GDIPlus_Startup()
	For $i = $iLowVal To $iHighVal Step $iStepVal
			_SetBitmap($hGUIbuttA, $gImageA, $i)
			_SetBitmap($hGUIbuttB, $gImageB, $i)
			_SetBitmap($hGUIbuttC, $gImageC, $i)
			_SetBitmap($hGUIbuttD, $gImageD, $i)
	    Sleep($iSleepVal)
	Next
	_GDIPlus_Shutdown()
EndFunc

Func FadeGuiA(ByRef $iLowVal, ByRef $iHighVal, ByRef $iStepVal, ByRef $iSleepVal)
	_GDIPlus_Startup()
	For $i = $iLowVal To $iHighVal Step $iStepVal
			_SetBitmap($hGUIbuttA, $gImageA, $i)
	    Sleep($iSleepVal)
	Next
	_GDIPlus_Shutdown()
EndFunc

Func FadeGuiB(ByRef $iLowVal, ByRef $iHighVal, ByRef $iStepVal, ByRef $iSleepVal)
	_GDIPlus_Startup()
	For $i = $iLowVal To $iHighVal Step $iStepVal
			_SetBitmap($hGUIbuttB, $gImageB, $i)
			Sleep($iSleepVal)
	Next
	_GDIPlus_Shutdown()
EndFunc

Func FadeGuiC(ByRef $iLowVal, ByRef $iHighVal, ByRef $iStepVal, ByRef $iSleepVal)
	_GDIPlus_Startup()
	For $i = $iLowVal To $iHighVal Step $iStepVal
			_SetBitmap($hGUIbuttC, $gImageC, $i)
	    Sleep($iSleepVal)
	Next
	_GDIPlus_Shutdown()
EndFunc

Func FadeGuiD(ByRef $iLowVal, ByRef $iHighVal, ByRef $iStepVal, ByRef $iSleepVal)
	_GDIPlus_Startup()
	For $i = $iLowVal To $iHighVal Step $iStepVal
			_SetBitmap($hGUIbuttD, $gImageD, $i)
	    Sleep($iSleepVal)
	Next
	_GDIPlus_Shutdown()
EndFunc

Func FadeGuiBG(ByRef $iLowVal, ByRef $iHighVal, ByRef $iStepVal, ByRef $iSleepVal)
	_GDIPlus_Startup()
	For $i = $iLowVal To $iHighVal Step $iStepVal
	    _SetBitmap($hGUIbg, $bgImage, $i)
	    Sleep($iSleepVal)
	Next
	_GDIPlus_Shutdown()
EndFunc

; === OTHER FUNCTIONS ====
Func OKButton()
    ; Note: At this point @GUI_CtrlId would equal $iOKButton
    MsgBox("GUI Event", "You selected OK!")
EndFunc   ;==>OKButton

; ===============================================================================================================================
; _SetBitmap Function
; ===============================================================================================================================
Func _SetBitmap($hGUI, $gImage, $iOpacity)
	Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend

	$hScrDC = _WinAPI_GetDC(0)
	$hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($gImage)
	$hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
	$tSize = DllStructCreate($tagSIZE)
	$pSize = DllStructGetPtr($tSize)
	DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($gImage))
	DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($gImage))
	$tSource = DllStructCreate($tagPOINT)
	$pSource = DllStructGetPtr($tSource)
	$tBlend = DllStructCreate($tagBLENDFUNCTION)
	$pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, "Alpha", $iOpacity)
	DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
	_WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
	_WinAPI_ReleaseDC(0, $hScrDC)
	_WinAPI_SelectObject($hMemDC, $hOld)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>_SetBitmap

; ===============================================================================================================================
; Run Non-Elevated Function
; ===============================================================================================================================

Func _RunNonElevated($sCommandLine = "")
    If Not IsAdmin() Then Return Run($sCommandLine) ; if current process is run non-elevated then just Run new one.

    ; Structures needed for creating process
    Local $tSTARTUPINFO = DllStructCreate($tagSTARTUPINFO)
    Local $tPROCESS_INFORMATION = DllStructCreate($tagPROCESS_INFORMATION)

    ; Process handle of some process that's run non-elevated. For example "Explorer"
    Local $hProcess = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, 0, ProcessExists("explorer.exe"))

    ; If successful
    If $hProcess Then
        ; Token...
        Local $hTokOriginal = _Security__OpenProcessToken($hProcess, $TOKEN_ALL_ACCESS)
        ; Process handle is no longer needed. Close it
        _WinAPI_CloseHandle($hProcess)
        ; If successful
        If $hTokOriginal Then
            ; Duplicate the original token
            Local $hTokDuplicate = _Security__DuplicateTokenEx($hTokOriginal, $TOKEN_ALL_ACCESS, $SECURITYIMPERSONATION, $TOKENPRIMARY)
            ; Close the original token
            _WinAPI_CloseHandle($hTokOriginal)
            ; If successful
            If $hTokDuplicate Then
                ; Create process with this new token
                _Security__CreateProcessWithToken($hTokDuplicate, 0, $sCommandLine, 0, @ScriptDir, $tSTARTUPINFO, $tPROCESS_INFORMATION)

                ; Close that token
                _WinAPI_CloseHandle($hTokDuplicate)
                ; Close get handles
                _WinAPI_CloseHandle(DllStructGetData($tPROCESS_INFORMATION, "hProcess"))
                _WinAPI_CloseHandle(DllStructGetData($tPROCESS_INFORMATION, "hThread"))
                ; Return PID of newly created process
                Return DllStructGetData($tPROCESS_INFORMATION, "ProcessID")
            EndIf
        EndIf
    EndIf
EndFunc   ;==>_RunNonElevated
