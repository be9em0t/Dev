#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIvkeysConstants.au3>
#include <HotKey.au3>
#include <TrayConstants.au3>

#include <ProcessConstants.au3>
#include <SecurityConstants.au3>
; #include <StructureConstants.au3>
#include <WinAPIHObj.au3>
; #include <WinAPIProc.au3>


; TODO: reposition inside screen
; TODO: ask yes no on Quit
; TODO: minimise some programs on ESC

#RequireAdmin

; Opt( "GUICoordMode", 0)
; Opt("GUIOnEventMode", 1)
Opt("TrayMenuMode", 0)
Opt("TrayAutoPause", 0) ;0 = no pause, 1 = (default) pause. If there is no DefaultMenu no pause will occurs.
Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase

Local $fScriptVersion = .4
Local $iTransBG=20 ; 
    
Global Const $AC_SRC_ALPHA = 1
Global Const $iLanguage = 0x0409
Global $bgImage 
Global $aCurInf
Global $iCounter = 0
Global $iGuiHideTimeout = 50
Global $bFirstRun = True, $bGuiState = False
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
; ; Needs Admin Elevation to work everywhere
_HotKey_Assign(BitOR($CK_WIN, $VK_OEM_3), "ShowGUI", BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))
_HotKey_Assign($VK_F15, "langNext", BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))

_HotKey_Assign(BitOR($CK_SHIFT, $CK_CONTROL, $VK_D), "ShowGUI", BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))
_HotKey_Assign(BitOR($CK_SHIFT, $CK_CONTROL, $CK_ALT, $VK_D), "HideGUI", BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))

; _HotKey_Assign(BitOR($CK_WIN, $VK_OEM_3), "ShowGUI", BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))

; #Ins:: ; Win+Ins - Window Capture
  ; Run, "c:\Ketarin\Design\Xnview\XnView\xnview.exe" "-capture=window"
; !#Ins:: ; Alt+Win+Ins - FullScreen Capture
  ; Run, "c:\Ketarin\Design\Xnview\XnView\xnview.exe" "-capture=desktop"
;^#Ins::send {LWinDown}}{ShiftDown}s{ShiftUp}{LWinUp} ; Shift+Win+Ins - SnippingTool Window Capture
  ; Run, "c:\Windows\System32\SnippingTool.exe /clip"

;f15:: ; Capslock - Switch Lnguages. (Need to set Capslock to F15 first)
; Block weird Win-keyboard hotkeys: Ctrl+Win+Space, Ctrl+Shift+Win+Space
;+#W:: ; Toggle Trasnparent Win
;+#T:: ; Toggle Topmost

GUIPopBuild()

Func ShowGUI()
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

	$iCounter = 0
	$bGuiState = True
EndFunc	; ==> ShowGUI

Func HideGUI()
	FadeGuiABCD($iHighVal, $iLowVal, ($iStepVal * -1), ($iSleepVal * 5))

	GUISetState(@SW_HIDE, $hGUIbg)
	GUISetState(@SW_HIDE, $hGUIbuttA)
	GUISetState(@SW_HIDE, $hGUIbuttB)
	GUISetState(@SW_HIDE, $hGUIbuttC)
	GUISetState(@SW_HIDE, $hGUIbuttD)

	$iCounter = 0
	$bGuiState = False
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
	TrayCreateItem("") ; Create a separator line.
	; Local $idPause = TrayCreateItem("Pause")
	; Local $idExit = TrayCreateItem("Exit")

	TraySetPauseIcon($sIconTrayPause, 0) ; Set the pause icon. This will flash on and off when the tray menu is selected and the script is paused.
	TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.
	TraySetClick(BitOR($TRAY_CLICK_PRIMARYDOWN, $TRAY_CLICK_SECONDARYDOWN)) ; Show the tray menu when the mouse if hovered over the tray icon.
; ---

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
			Case $GUI_EVENT_NONE ; Idle
					If $bGuiState Then
							$aCurInf = GUIGetCursorInfo($hGUIbg)
							If $aCurInf[4] = 0 Then
								_SetBitmap($hGUIbuttA, $gImageA, 255)
								_SetBitmap($hGUIbuttB, $gImageB, 255)
								_SetBitmap($hGUIbuttC, $gImageC, 255)
								_SetBitmap($hGUIbuttD, $gImageD, 255)
								$iCounter = $iCounter + 1
								if $iCounter > $iGuiHideTimeout Then 
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
								$iCounter = 0
							EndIf										
					EndIf					
		EndSwitch

		Switch TrayGetMsg()
		Case $idAbout ; Display a message box about the AutoIt version and installation path of the AutoIt executable.
			MsgBox($MB_SYSTEMMODAL, "", _ 
				"b9Misc AutoIt, ver. " & $fScriptVersion & @CRLF & _
				"AutoIt ver.: " & @AutoItVersion & @CRLF & _
				"Install Path: " & StringLeft(@AutoItExe, StringInStr(@AutoItExe, "\", $STR_NOCASESENSEBASIC, -1) - 1)) ; Find the folder of a full path.

		; Case $idPause ; Exit the loop.
		; 		_MenuPause()
		; 		; _MenuQuit()
		; 		ExitLoop

		; Case $idExit ; Exit the loop.
		; 		_MenuQuit()
		; 		ExitLoop
	EndSwitch

	WEnd

	; Release resources
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
    DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
		Sleep(30)
		HideGUI()
		Opt('GUIOnEventMode', 0)
EndFunc   ;==>TrackPopupMenu

; --- ContextMenu A menu functions---
Func ContextMenuA()
	; Global $Context = GUICtrlCreateContextMenuA(GUICtrlCreateDummy()) ; this should attach to respective GUI
	Global $mnuEmailOutlook = GUICtrlCreateMenuItem("be9em0t &Outlook", $ContextA)
		GUICtrlSetOnEvent(-1, '_MenuBgmOutlook')
	Global $mnuEmailGmail = GUICtrlCreateMenuItem("be9em0t &Gmail", $ContextA)
		GUICtrlSetOnEvent(-1, '_MenuBgmGmail')
	Global $mnuKeta = GUICtrlCreateMenuItem("&Keta", $ContextA)
		GUICtrlSetOnEvent(-1, '_MenuKeta')
EndFunc

Func _MenuBgmOutlook()
	; Local $iPID = ShellExecute("c:\Ketarin\Tools\AutoIt\Au3Info_x64.exe", "")
	MsgBox($MB_OK, "AutoIt", "fill begemot")
EndFunc
Func _MenuBgmGmail()
	; Local $iPID = ShellExecute("c:\Ketarin\Tools\AutoIt\Au3Info_x64.exe", "")
	MsgBox($MB_OK, "AutoIt", "fill gmail")
EndFunc
Func _MenuKeta()
	; Local $iPID = ShellExecute("c:\Ketarin\Tools\AutoIt\Au3Info_x64.exe", "")
	MsgBox($MB_OK, "AutoIt", "fill keta")
EndFunc

; --- ContextMenu C menu functions---
Func ContextMenuC()
	; Global $Context = GUICtrlCreateContextMenuA(GUICtrlCreateDummy()) ; this should attach to respective GUI
	Global $mnuActivate = GUICtrlCreateMenuItem("Window Activate", $ContextC)
		GUICtrlSetOnEvent(-1, '_MenuActivate')
	; Rollup
	; TrayMin
	; OnTop
	; NotOnTop
	; Window Resize >
	; 	> Set Capture BG
	; 	> Restore Background
EndFunc

Func _MenuActivate()
	; Local $iPID = ShellExecute("c:\Ketarin\Tools\AutoIt\Au3Info_x64.exe", "")
	MsgBox($MB_OK, "AutoIt", "Window Activate")
EndFunc

; --- ContextMenu D menu functions---
Func ContextMenuD()
	Global $mnuTest = GUICtrlCreateMenuItem("&Test", $ContextD)
		GUICtrlSetOnEvent(-1, '_MenuTest')
	Global $mnuSeparator = GUICtrlCreateMenuItem("", $ContextD) ; Create a separator line
			Global $submenuScript = GUICtrlCreateMenu("S&cript", $ContextD) ; Is created before "?" menu
			; Global $submnuTest1 = GUICtrlCreateMenuItem("Test1", $submenuStart)
			Global $mnuAu3Info = GUICtrlCreateMenuItem("&Au3Info", $submenuScript)
				GUICtrlSetOnEvent(-1, '_MenuAu3Info')
			; Global $mnuSubmenu = GUICtrlCreateMenuItem("&Exit", $ContextD)
			Global $mnuHelp = GUICtrlCreateMenuItem("AutoIt &Help", $submenuScript)
				GUICtrlSetOnEvent(-1, '_MenuAutoItHelp')
			Global $mnuEditScript = GUICtrlCreateMenuItem("&Edit Script", $submenuScript)
				GUICtrlSetOnEvent(-1, '_MenuEditScript')
			; Global $mnuReloadScript = GUICtrlCreateMenuItem("&Exit", $ContextD)
	Global $mnuSeparator = GUICtrlCreateMenuItem("", $ContextD) ; Create a separator line
	Global $mnuQuit = GUICtrlCreateMenuItem("&Quit", $ContextD)
		GUICtrlSetOnEvent(-1, '_MenuQuit')
EndFunc ;==> ContextMenuD Gui

Func _MenuTest()
    ; _RunNonElevated('"' & @AutoItExe & '" /AutoIt3ExecuteLine  "MsgBox(4096, ''RunNonElevated'', ''IsAdmin() = '' & "IsAdmin()" & '', PID = '' & "@AutoItPID")"')
  _RunNonElevated($sEditor & " c:\Ketarin\Data\temp\c5395\chr\History.txt")

	; Run("cmd.exe")
	; 	MsgBox($MB_OK, "AutoIt", "Exists" )
	; EndIf
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
