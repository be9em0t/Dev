#include <GDIPlus.au3>
#include <GuiConstantsEx.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
; #include <ButtonConstants.au3>
; #include <Array.au3>
#include <GuiMenu.au3>
#include <WinAPIError.au3>

#include <APILocaleConstants.au3>
#include <APISysConstants.au3>
#include <StaticConstants.au3>
#include <WinAPILocale.au3>
#include <WinAPISys.au3>

#include <HotKey.au3>
#include <WinAPIvkeysConstants.au3>


#RequireAdmin

Opt('GUIOnEventMode', 1)
Opt("TrayMenuMode", 3)
    
Global Const $AC_SRC_ALPHA = 1
Global Const $iLanguage = 0x0409
Global $hGUIbg, $hGUIbuttA, $hGUIbuttB, $hGUIbuttC, $hGUIbuttD, $g_hImage
; AutoItSetOption ( "GUICoordMode", 0)

Local $fScripVersion = .2
Local $posX = -1, $posY = -1, $iTransBG=20 ; TODO: transparency of PopUp
Local $sIconTray = @ScriptDir & "\Resources\P-icon.ico"
TraySetToolTip("b9Misc AutoIt, ver. " & $fScripVersion) ; Set the tray menu tooltip with information about the icon index.
TraySetIcon($sIconTray, 0) ; Set the tray menu icon using the shell32.dll and the random index number.

$pngSrcA = @ScriptDir & "\Icon1.png"
$pngSrcA1 = @ScriptDir & "\Icon1a.png"
$pngSrcB = @ScriptDir & "\Icon2.png"
$pngSrcB1 = @ScriptDir & "\Icon2a.png"
$pngSrcC = @ScriptDir & "\Icon3.png"
$pngSrcC1 = @ScriptDir & "\Icon3a.png"
$pngSrcD = @ScriptDir & "\Icon4.png"
$pngSrcD1 = @ScriptDir & "\Icon4a.png"
$pngSrcBG = @ScriptDir & "\bg.png"

If Not IsAdmin() Then MsgBox($MB_SYSTEMMODAL, "", "The script needs admin rights.")
; If IsAdmin() Then MsgBox($MB_SYSTEMMODAL, "", "The script running with admin rights.")

; ===============================================================================================================================
; NOTE: Hotkeys
; ===============================================================================================================================

; HotKeySet("#`", "ShowGUI") ; Win+` - PopUI
; HotKeySet("#{F2}", "langNext") ; Win+` - PopUI

; ; Assign Hotkey VirtualCode useng HotkeyUDF: https://autoit-script.ru/index.php?topic=296.0
; ; Needs Admin Elevation to work everywhere
_HotKey_Assign(BitOR($CK_WIN, $VK_OEM_3), "ShowGUI", BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))
_HotKey_Assign($VK_F15, "langNext", BitOR($HK_FLAG_DEFAULT, $HK_FLAG_EXTENDEDCALL))

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

While 1	; FIXME: need to cleanup all While-s
    Sleep(100)
WEnd

; === LANGUAGE KBD LAYOUT FUNCTIONS ====
Func langNext() ; uses the Hotkey UDF
  $hGUIlang = GUICreate("GuiLang", 48, 48, -1, -1, $WS_POPUP, $WS_EX_TOOLWINDOW)
  GUISetState(@SW_SHOW)

  _WinAPI_ActivateKeyboardLayout($HKL_NEXT)

	; $allwindows = WinList()
	; For $i = 1 to $allwindows[0][0]
	; 		If IsVisible($allwindows[$i][1]) Then
	; 		  _WinAPI_ActivateKeyboardLayout($HKL_NEXT)
	; 		EndIf
	; Next

  GUIDelete($hGUIlang)
EndFunc

; Func IsVisible($handle)
;     If BitAnd( WinGetState($handle), 2 ) Then 
;         Return 1
;     Else
;         Return 0
;     EndIf
; EndFunc

Func ShowGUI()

	$iWinExists = WinExists ( $hGUIbg )
	If NOT $hGUIbg Then
		; MsgBox($MB_SYSTEMMODAL, "", " GUIbg null " & $iWinExists & " " & $hGUIbg)
		GUIPopBuild()
	ElseIf $iWinExists == 0 Then
		; MsgBox($MB_SYSTEMMODAL, "", " GUIbg but WinExists=0 " & $iWinExists & " " & $hGUIbg)
		GUIPopBuild()
	EndIf
					; MsgBox($MB_OK, "", $posX & " | " & $posY)

_WinAPI_SetKeyboardLayout($hGUIbg, $iLanguage)

EndFunc	; ==> ShowGUI

; ===============================================================================================================================
; PopupGUI
; ===============================================================================================================================

Func GUIPopBuild()
Local $aMPos = MouseGetPos()
$posX = $aMPos[0]
$posY = $aMPos[1]

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
	Global $ContextA = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
	ContextMenuA()
	GUISetState()

	$hGUIbuttB = GUICreate("ButtonB", $iWidth, $iHeight, ($aWinGetPos[0]+$iWidth+2), ($aWinGetPos[1]+1), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	SetBitmap($hGUIbuttB, $hImageB, 255)
	GUISetState()

	$hGUIbuttC = GUICreate("ButtonC", $iWidth, $iHeight, ($aWinGetPos[0]+1), ($aWinGetPos[1]+$iHeight+2), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	SetBitmap($hGUIbuttC, $hImageC, 255)
	Global $ContextC = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
	ContextMenuC()
	GUISetState()

	$hGUIbuttD = GUICreate("ButtonD", $iWidth, $iHeight, ($aWinGetPos[0]+$iWidth+2), ($aWinGetPos[1]+$iHeight+2), $WS_POPUP, $WS_EX_LAYERED, $hGUIbg)
	SetBitmap($hGUIbuttD, $hImageD, 255)
	Global $ContextD = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
	ContextMenuD()
	GUISetState()

	; GUIRegisterMsg($WM_LBUTTONDBLCLK, "WM_LBUTTONDBLCLK")
	GUIRegisterMsg($WM_LBUTTONDOWN, "WM_LBUTTONDOWN")

	While 1 ; FIXME: Add ESC option
			If GUIGetMsg() = $GUI_EVENT_CLOSE then 
				GUIDelete($hGUIbg)
				Return
			EndIf	

			$iWinExists = WinExists ( $hGUIbg )
			If $iWinExists == 0 Then
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
; NOTE: Functions 
; ===============================================================================================================================

; === LEFT MOUSE CLICK FUNCTIONS ===
Func WM_LBUTTONDOWN($hWnd, $iMsg, $iParam, $lParam)
	#forceref $hWnd, $iMsg, $iParam, $lParam  	
	Switch $hWnd
		Case $hGUIbuttA
					TrackPopupMenu($hGUIbuttA, GUICtrlGetHandle($ContextA), MouseGetPos(0), MouseGetPos(1))
		Case $hGUIbuttB
				; Normally should not fire because of our WM_COMMAND function
				; MsgBox($MB_SYSTEMMODAL, "Info", "Button B pressed")
				Local $iPID = ShellExecute("C:\Ketarin\Tools\KeePass\KeePass.exe", "")  				; TODO: bring to front if already open
				; ToolTip($iPID)
		Case $hGUIbuttC
				; MsgBox($MB_SYSTEMMODAL, "Info", "Button C pressed")
				TrackPopupMenu($hGUIbuttC, GUICtrlGetHandle($ContextC), MouseGetPos(0), MouseGetPos(1))
		Case $hGUIbuttD
				TrackPopupMenu($hGUIbuttD, GUICtrlGetHandle($ContextD), MouseGetPos(0), MouseGetPos(1))
	EndSwitch
	; GUIDelete($hGUIbg)
EndFunc ;==> WM_LBUTTONDOWN

; === CONTEXT MENU FUNCTIONS ====
Func TrackPopupMenu($hWnd, $hMenu, $x, $y)
    DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
		Sleep(30)
		GUIDelete($hGUIbg)
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
	; Local $iPID = ShellExecute("c:\Ketarin\Tools\AutoIt\Au3Info_x64.exe", "")
	MsgBox($MB_OK, "AutoIt", @ScriptDir)
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

; === OTHER FUNCTIONS ====
Func OKButton()
    ; Note: At this point @GUI_CtrlId would equal $iOKButton
    MsgBox("GUI Event", "You selected OK!")
EndFunc   ;==>OKButton

; Func WM_LBUTTONDBLCLK($hWnd, $iMsg, $iParam, $lParam)
; 	#forceref $hWnd, $iMsg, $iParam, $lParam
; 	; SetBitmap($g_hGUI2, $g_hImage, GUICtrlRead($g_idSlider))  
;   MsgBox($MB_OK, "Blah", "Icon!" + $hWnd)
; EndFunc   ;==>WM_HSCROLL

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


