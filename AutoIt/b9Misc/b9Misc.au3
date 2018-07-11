#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIvkeysConstants.au3>
#include <HotKey.au3>

; TODO: reposition inside screen
; TODO: bring program to front if already open
; TODO: Make tray menu useful

#RequireAdmin

; Opt( "GUICoordMode", 0)
; Opt("GUIOnEventMode", 1)
Opt("TrayMenuMode", 3)
    
Global Const $AC_SRC_ALPHA = 1
Global Const $iLanguage = 0x0409
Global $bgImage 
Global $aCurInf
Global $iCounter = 0
Global $iGuiHideTimeout = 50
Global $bFirstRun = True, $bGuiState = False
Global Const $bShowBG = False
Global $iLowVal = 5, $iHighVal = 255, $iStepVal = 50, $iSleepVal = 5 ; Fade settings

Local $fScriptVersion = .2
Local $iTransBG=20 ; 
Local $sIconTray = @ScriptDir & "\Resources\P-icon.ico"
TraySetToolTip("b9Misc AutoIt, ver. " & $fScriptVersion) ; Set the tray menu tooltip with information about the icon index.
TraySetIcon($sIconTray, 0) ; Set the tray menu icon using the shell32.dll and the random index number.

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
	$pngSrcA = @ScriptDir & "\Icon1.png"
		Global Const $gImageA = _GDIPlus_ImageLoadFromFile($pngSrcA)
	$pngSrcA1 = @ScriptDir & "\Icon1a.png"
		Global Const $gImageA1 = _GDIPlus_ImageLoadFromFile($pngSrcA1)
	$pngSrcB = @ScriptDir & "\Icon2.png"
		Global Const $gImageB = _GDIPlus_ImageLoadFromFile($pngSrcB)
	$pngSrcB1 = @ScriptDir & "\Icon2a.png"
		Global Const $gImageB1 = _GDIPlus_ImageLoadFromFile($pngSrcB1)
	$pngSrcC = @ScriptDir & "\Icon3.png"
		Global Const $gImageC = _GDIPlus_ImageLoadFromFile($pngSrcC)
	$pngSrcC1 = @ScriptDir & "\Icon3a.png"
		Global Const $gImageC1 = _GDIPlus_ImageLoadFromFile($pngSrcC1)
	$pngSrcD = @ScriptDir & "\Icon4.png"
		Global Const $gImageD = _GDIPlus_ImageLoadFromFile($pngSrcD)
	$pngSrcD1 = @ScriptDir & "\Icon4a.png"
		Global Const $gImageD1 = _GDIPlus_ImageLoadFromFile($pngSrcD1)
	Global $iWidth = _GDIPlus_ImageGetWidth($gImageA)
	Global $iHeight = _GDIPlus_ImageGetHeight($gImageA)

	; background PNG
	$pngSrcBG = @ScriptDir & "\bg.png"
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
		SetBitmap($hGUIbg, $bgImage, 0) 
	EndIf

	GUISetState()
	; GUISetState($GUI_DISABLE, $hGUIbg)
	WinSetOnTop($hGUIbg, "", 1)
	If $bShowBG Then
		SetBitmap($hGUIbg, $bgImage, $iTransBG) ; NOTE: disable if no BG
	EndIf


	; Create button child GUIs
	Global Const $hGUIbuttA = GUICreate("ButtonA", $iWidth, $iHeight, ($aMPos[0]+1), ($aMPos[1]+1), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	SetBitmap($hGUIbuttA, $gImageA, 255)
	Global $ContextA = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
	ContextMenuA()
	GUISetState()

	Global Const $hGUIbuttB = GUICreate("ButtonB", $iWidth, $iHeight, ($aMPos[0]+$iWidth+2), ($aMPos[1]+1), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	SetBitmap($hGUIbuttB, $gImageB, 255)
	GUISetState()

	Global Const $hGUIbuttC = GUICreate("ButtonC", $iWidth, $iHeight, ($aMPos[0]+1), ($aMPos[1]+$iHeight+2), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	SetBitmap($hGUIbuttC, $gImageC, 255)
	Global $ContextC = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
	ContextMenuC()
	GUISetState()

	Global Const $hGUIbuttD = GUICreate("ButtonD", $iWidth, $iHeight, ($aMPos[0]+$iWidth+2), ($aMPos[1]+$iHeight+2), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	SetBitmap($hGUIbuttD, $gImageD, 255)
	Global $ContextD = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
	ContextMenuD()
	GUISetState()
	
	If $bFirstRun = True Then
		$bFirstRun = False
		HideGUI()
	EndIf

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
							Local $iPID = ShellExecute("C:\Ketarin\Tools\KeePass\KeePass.exe", "")  				
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
								SetBitmap($hGUIbuttA, $gImageA, 255)
								SetBitmap($hGUIbuttB, $gImageB, 255)
								SetBitmap($hGUIbuttC, $gImageC, 255)
								SetBitmap($hGUIbuttD, $gImageD, 255)
								$iCounter = $iCounter + 1
								if $iCounter > $iGuiHideTimeout Then 
										HideGUI()
								EndIf
							ElseIf $aCurInf[4] = $idMaskA Then 
								SetBitmap($hGUIbuttA, $gImageA1, 255)
								SetBitmap($hGUIbuttB, $gImageB, 255)
								SetBitmap($hGUIbuttC, $gImageC, 255)
								SetBitmap($hGUIbuttD, $gImageD, 255)
							ElseIf $aCurInf[4] = $idMaskB Then 
								SetBitmap($hGUIbuttA, $gImageA, 255)
								SetBitmap($hGUIbuttB, $gImageB1, 255)
								SetBitmap($hGUIbuttC, $gImageC, 255)
								SetBitmap($hGUIbuttD, $gImageD, 255)
							ElseIf $aCurInf[4] = $idMaskC Then 
								SetBitmap($hGUIbuttA, $gImageA, 255)
								SetBitmap($hGUIbuttB, $gImageB, 255)
								SetBitmap($hGUIbuttC, $gImageC1, 255)
								SetBitmap($hGUIbuttD, $gImageD, 255)
							ElseIf $aCurInf[4] = $idMaskD Then 
								SetBitmap($hGUIbuttA, $gImageA, 255)
								SetBitmap($hGUIbuttB, $gImageB, 255)
								SetBitmap($hGUIbuttC, $gImageC, 255)
								SetBitmap($hGUIbuttD, $gImageD1, 255)
							Else
								$iCounter = 0
							EndIf										
					EndIf					
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

	MsgBox($MB_OK, "AutoIt", $iStepVal & " x " & ($iStepVal*-1) )
EndFunc

Func _MenuAu3Info()
	Local $iPID = ShellExecute("c:\Ketarin\Tools\AutoIt\Au3Info_x64.exe", "")

EndFunc

Func _MenuAutoItHelp()
	Local $iPID = ShellExecute("c:\Ketarin\Tools\AutoIt\AutoIt.chm", "c:\Ketarin\Tools\AutoIt\")
EndFunc

Func _MenuEditScript()
	Local $iPID = ShellExecute("c:\Ketarin\Data\VSCode\Code.exe", "d:\Work\OneDrive\Dev\AutoIt\b9Misc\b9Misc.au3")
EndFunc

Func _MenuQuit()
		Exit ; TODO: ask yes no
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
			SetBitmap($hGUIbuttA, $gImageA, $i)
			SetBitmap($hGUIbuttB, $gImageB, $i)
			SetBitmap($hGUIbuttC, $gImageC, $i)
			SetBitmap($hGUIbuttD, $gImageD, $i)
	    Sleep($iSleepVal)
	Next
	_GDIPlus_Shutdown()
EndFunc

Func FadeGuiA(ByRef $iLowVal, ByRef $iHighVal, ByRef $iStepVal, ByRef $iSleepVal)
	_GDIPlus_Startup()
	For $i = $iLowVal To $iHighVal Step $iStepVal
			SetBitmap($hGUIbuttA, $gImageA, $i)
	    Sleep($iSleepVal)
	Next
	_GDIPlus_Shutdown()
EndFunc

Func FadeGuiB(ByRef $iLowVal, ByRef $iHighVal, ByRef $iStepVal, ByRef $iSleepVal)
	_GDIPlus_Startup()
	For $i = $iLowVal To $iHighVal Step $iStepVal
			SetBitmap($hGUIbuttB, $gImageB, $i)
			Sleep($iSleepVal)
	Next
	_GDIPlus_Shutdown()
EndFunc

Func FadeGuiC(ByRef $iLowVal, ByRef $iHighVal, ByRef $iStepVal, ByRef $iSleepVal)
	_GDIPlus_Startup()
	For $i = $iLowVal To $iHighVal Step $iStepVal
			SetBitmap($hGUIbuttC, $gImageC, $i)
	    Sleep($iSleepVal)
	Next
	_GDIPlus_Shutdown()
EndFunc

Func FadeGuiD(ByRef $iLowVal, ByRef $iHighVal, ByRef $iStepVal, ByRef $iSleepVal)
	_GDIPlus_Startup()
	For $i = $iLowVal To $iHighVal Step $iStepVal
			SetBitmap($hGUIbuttD, $gImageD, $i)
	    Sleep($iSleepVal)
	Next
	_GDIPlus_Shutdown()
EndFunc

Func FadeGuiBG(ByRef $iLowVal, ByRef $iHighVal, ByRef $iStepVal, ByRef $iSleepVal)
	_GDIPlus_Startup()
	For $i = $iLowVal To $iHighVal Step $iStepVal
	    SetBitmap($hGUIbg, $bgImage, $i)
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
; SetBitMap Function
; ===============================================================================================================================
Func SetBitmap($hGUI, $gImage, $iOpacity)
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
EndFunc   ;==>SetBitmap


