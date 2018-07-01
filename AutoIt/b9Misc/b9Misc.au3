#include <GDIPlus.au3>
#include <GuiConstantsEx.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <ButtonConstants.au3>

Global Const $AC_SRC_ALPHA = 1
Global $hGUIbg, $hGUIbuttA, $hGUIbuttB, $hGUIbuttC, $hGUIbuttD, $g_hImage
; AutoItSetOption ( "GUICoordMode", 0)

Local $posX = -1, $posY = -1, $iTransBG=20

; ===============================================================================================================================
; PopupGUI
; ===============================================================================================================================
	$pngSrcA = @ScriptDir & "\Icon1.png"
	$pngSrcA1 = @ScriptDir & "\Icon1a.png"
	$pngSrcB = @ScriptDir & "\Icon2.png"
	$pngSrcB1 = @ScriptDir & "\Icon2a.png"
	$pngSrcC = @ScriptDir & "\Icon3.png"
	$pngSrcC1 = @ScriptDir & "\Icon3a.png"
	$pngSrcD = @ScriptDir & "\Icon4.png"
	$pngSrcD1 = @ScriptDir & "\Icon4a.png"
	$pngSrcBG = @ScriptDir & "\bg.png"

Func GUIPopBuild()
	_GDIPlus_Startup()
	; ; button images - must be the same size
	; $pngSrcA = @ScriptDir & "\Icon1.png"
		$hImageA = _GDIPlus_ImageLoadFromFile($pngSrcA)
	; $pngSrcA1 = @ScriptDir & "\Icon1a.png"
		$hImageA1 = _GDIPlus_ImageLoadFromFile($pngSrcA1)
	; $pngSrcB = @ScriptDir & "\Icon2.png"
		$hImageB = _GDIPlus_ImageLoadFromFile($pngSrcB)
	; $pngSrcB1 = @ScriptDir & "\Icon2a.png"
		$hImageB1 = _GDIPlus_ImageLoadFromFile($pngSrcB1)
	; $pngSrcC = @ScriptDir & "\Icon3.png"
		$hImageC = _GDIPlus_ImageLoadFromFile($pngSrcC)
	; $pngSrcC1 = @ScriptDir & "\Icon3a.png"
		$hImageC1 = _GDIPlus_ImageLoadFromFile($pngSrcC1)
	; $pngSrcD = @ScriptDir & "\Icon4.png"
		$hImageD = _GDIPlus_ImageLoadFromFile($pngSrcD)
	; $pngSrcD1 = @ScriptDir & "\Icon4a.png"
		$hImageD1 = _GDIPlus_ImageLoadFromFile($pngSrcD1)
	$iWidth = _GDIPlus_ImageGetWidth($hImageA)
	$iHeight = _GDIPlus_ImageGetHeight($hImageA)

	; background PNG
	; $pngSrcBG = @ScriptDir & "\bg.png"
	$bgImage = _GDIPlus_ImageLoadFromFile($pngSrcBG)
	$bgWidth = _GDIPlus_ImageGetWidth($bgImage)
	$bgHeight = _GDIPlus_ImageGetHeight($bgImage)

	; Create Main Layered Window
	$hGUIbg = GUICreate("BgGui", $bgWidth, $bgHeight, $posX, $posY, $WS_POPUP, $WS_EX_LAYERED)
	$idMaskA = GUICtrlCreateLabel("", 0,0, $bgWidth/2,$bgHeight/2)
	$idMaskB = GUICtrlCreateLabel("", $bgWidth/2,0, $bgWidth/2,$bgHeight/2)
	$idMaskC = GUICtrlCreateLabel("", 0,$bgHeight/2, $bgWidth/2,$bgHeight/2)
	$idMaskD = GUICtrlCreateLabel("", $bgWidth/2,$bgHeight/2, $bgWidth/2,$bgHeight/2)
	; SetBitmap($hGUIbg, $bgImage, 0) 

	GUISetState()
	; GUISetState($GUI_DISABLE, $hGUIbg)
	WinSetOnTop($hGUIbg, "", 1)
	; SetBitmap($hGUIbg, $bgImage, $iTransBG) ; NOTE: disable if no BG TODO: might clean up this when no bg is used
	$aWinGetPos = WinGetPos($hGUIbg)

	; Fade-in
	; For $i = 0 To 255 Step 10
	;     SetBitmap($hGUIbg, $bgImage, $i)
	;     Sleep(10)
	; Next

	; Create button child GUIs
	$hGUIbuttA = GUICreate("ButtonA", $iWidth, $iHeight, ($aWinGetPos[0]+1), ($aWinGetPos[1]+1), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	SetBitmap($hGUIbuttA, $hImageA, 255)
	GUISetState()

	$hGUIbuttB = GUICreate("ButtonB", $iWidth, $iHeight, ($aWinGetPos[0]+$iWidth+2), ($aWinGetPos[1]+1), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	SetBitmap($hGUIbuttB, $hImageB, 255)
	GUISetState()

	$hGUIbuttC = GUICreate("ButtonC", $iWidth, $iHeight, ($aWinGetPos[0]+1), ($aWinGetPos[1]+$iHeight+2), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	SetBitmap($hGUIbuttC, $hImageC, 255)
	GUISetState()

	$hGUIbuttD = GUICreate("ButtonD", $iWidth, $iHeight, ($aWinGetPos[0]+$iWidth+2), ($aWinGetPos[1]+$iHeight+2), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	SetBitmap($hGUIbuttD, $hImageD, 255)
	GUISetState()

	; GUIRegisterMsg($WM_LBUTTONDBLCLK, "WM_LBUTTONDBLCLK")
	GUIRegisterMsg($WM_LBUTTONDOWN, "WM_LBUTTONDOWN")

	While 1
			If GUIGetMsg() = $GUI_EVENT_CLOSE then 
				GUIDelete($hGUIbg)
				Return
			EndIf	

			$aCurInf = GUIGetCursorInfo($hGUIbg)

			If $aCurInf[4] = $idMaskA Then 
				SetBitmap($hGUIbuttA, $hImageA1, 255)
				SetBitmap($hGUIbuttB, $hImageB, 255)
				SetBitmap($hGUIbuttC, $hImageC, 255)
				SetBitmap($hGUIbuttD, $hImageD, 255)
				; ToolTip("You are over A" )
			ElseIf $aCurInf[4] = $idMaskB Then 
				SetBitmap($hGUIbuttA, $hImageA, 255)
				SetBitmap($hGUIbuttB, $hImageB1, 255)
				SetBitmap($hGUIbuttC, $hImageC, 255)
				SetBitmap($hGUIbuttD, $hImageD, 255)
				; ToolTip("You are over B" )
			ElseIf $aCurInf[4] = $idMaskC Then 
				SetBitmap($hGUIbuttA, $hImageA, 255)
				SetBitmap($hGUIbuttB, $hImageB, 255)
				SetBitmap($hGUIbuttC, $hImageC1, 255)
				SetBitmap($hGUIbuttD, $hImageD, 255)
				; ToolTip("You are over C" )
			ElseIf $aCurInf[4] = $idMaskD Then 
				SetBitmap($hGUIbuttA, $hImageA, 255)
				SetBitmap($hGUIbuttB, $hImageB, 255)
				SetBitmap($hGUIbuttC, $hImageC, 255)
				SetBitmap($hGUIbuttD, $hImageD1, 255)
				; ToolTip("You are over D" )
			Else
				SetBitmap($hGUIbuttA, $hImageA, 255)
				SetBitmap($hGUIbuttB, $hImageB, 255)
				SetBitmap($hGUIbuttC, $hImageC, 255)
				SetBitmap($hGUIbuttD, $hImageD, 255)
				; ToolTip("")
			EndIf
	WEnd

	; Release resources
	_GDIPlus_ImageDispose($bgImage)
	_GDIPlus_ImageDispose($hImageA)
	_GDIPlus_ImageDispose($hImageB)
	_GDIPlus_Shutdown()
EndFunc ; => GUIPopBuild


; ===============================================================================================================================
; Hotkeys
; ===============================================================================================================================

HotKeySet("+!`", "ShowGUI") ; Shift-Alt-`

While 1
    Sleep(100)
WEnd

Func ShowGUI()
	$iWinExists = WinExists ( $hGUIbg )
	If NOT $hGUIbg Then
		; MsgBox($MB_SYSTEMMODAL, "", " GUIbg null " & $iWinExists & " " & $hGUIbg)
		GUIPopBuild()
	ElseIf $iWinExists == 0 Then
		; MsgBox($MB_SYSTEMMODAL, "", " GUIbg but WinExists=0 " & $iWinExists & " " & $hGUIbg)
		GUIPopBuild()
	EndIf
EndFunc	; ==> ShowGUI

; Func HotKeyPressed()
;     Switch @HotKeyPressed ; The last hotkey pressed.
;         ; Case "{PAUSE}" ; String is the {PAUSE} hotkey.
;         ;     $g_bPaused = Not $g_bPaused
;         ;     While $g_bPaused
;         ;         Sleep(100)
;         ;         ToolTip('Script is "Paused"', 0, 0)
;         ;     WEnd
;         ;     ToolTip("")

;         ; Case "{ESC}" ; String is the {ESC} hotkey.
;         ;     Exit

;         Case "+!`" ; String is the Shift-Alt-` hotkey.
;             MsgBox($MB_SYSTEMMODAL, "", "This is a message.")
; 						GUIShow()

;     EndSwitch
; EndFunc   ;==>HotKeyPressed

; ===============================================================================================================================
; Functions
; ===============================================================================================================================

Func OKButton()
    ; Note: At this point @GUI_CtrlId would equal $iOKButton
    MsgBox("GUI Event", "You selected OK!")
EndFunc   ;==>OKButton

; Func WM_NCHITTEST($hWnd, $iMsg, $iParam, $lParam)
; 	#forceref $hWnd, $iMsg, $iParam, $lParam
; 	If ($hWnd = $g_hGUI2) And ($iMsg = $WM_NCHITTEST) Then Return $HTCAPTION
; EndFunc   ;==>WM_NCHITTEST

; Func WM_LBUTTONDBLCLK($hWnd, $iMsg, $iParam, $lParam)
; 	#forceref $hWnd, $iMsg, $iParam, $lParam
; 	; SetBitmap($g_hGUI2, $g_hImage, GUICtrlRead($g_idSlider))  
;   MsgBox($MB_OK, "Blah", "Icon!" + $hWnd)
; EndFunc   ;==>WM_HSCROLL

; === Left Mouse Click ==============================================
Func WM_LBUTTONDOWN($hWnd, $iMsg, $iParam, $lParam)
	#forceref $hWnd, $iMsg, $iParam, $lParam
  ; MsgBox($MB_OK, "NCLbutton", "Click! " & $hWnd)
	; ToolTip("You are here" )
  	
	Switch $hWnd
		Case $hGUIbuttA
				MsgBox($MB_SYSTEMMODAL, "Info", "Button A pressed")
				; GUISetState(@SW_HIDE, $hGUIbg)
		Case $hGUIbuttB
				; Normally should not fire because of our WM_COMMAND function
				; MsgBox($MB_SYSTEMMODAL, "Info", "Button B pressed")
				Local $iPID = Run("C:\Ketarin\Tools\KeePass\KeePass.exe", "")  				; TODO: bring to front if already open
				; ToolTip($iPID)
		Case $hGUIbuttC
				; Normally should not fire because of our WM_COMMAND function
				MsgBox($MB_SYSTEMMODAL, "Info", "Button C pressed")
		Case $hGUIbuttD
				; Normally should not fire because of our WM_COMMAND function
				MsgBox($MB_SYSTEMMODAL, "Info", "Button D pressed")
	EndSwitch
EndFunc   ; ==> WM_LBUTTONDOWN

; Func GUIShow()
; 	GUISetState(@SW_SHOW, $hGUIbg)
; EndFunc

; Func GUIHide()
; GUIDelete($hGUIbg)
; 	; GUISetState(@SW_HIDE, $hGUIbg)
; EndFunc


; ===============================================================================================================================
; SetBitMap Function
; ===============================================================================================================================
Func SetBitmap($hGUI, $hImage, $iOpacity)
	Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend

	$hScrDC = _WinAPI_GetDC(0)
	$hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	$hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
	$tSize = DllStructCreate($tagSIZE)
	$pSize = DllStructGetPtr($tSize)
	DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
	DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
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


