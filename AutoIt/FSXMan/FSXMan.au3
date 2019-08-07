#include <MsgBoxConstants.au3>
#include <TrayConstants.au3>

#RequireAdmin

Opt("TrayMenuMode", 2)
Opt("TrayAutoPause", 0) ;0 = no pause, 1 = (default) pause. If there is no DefaultMenu no pause will occurs.
Opt("WinTitleMatchMode", 2) ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase

; --- Variables ----
Local $fScriptVersion = .1
Local $sIconTray = @ScriptDir & "\Resources\planeBlu.ico"
Local $sIconTrayAlert = @ScriptDir & "\Resources\planeRed.ico"
Local $sIconTrayPause = @ScriptDir & "\Resources\planeNeg.ico" ;Security Denied.ico"
Global $hAtcWind
Global $iSleepTimer = 1000
Global $hTimer = TimerInit() ; Begin the timer and store the handle in a variable.
Global $bPauseFlag = False
Global $bATCSeenFlag = False

; HotKeySet("+!d", "FsxPause")

AtcTray()
Sleep(200)
GetFSX()

; ---- initialization ----
Func GetFSX()
  $hAtcWind = WinWait("[TITLE:ATC Menu; CLASS:FS98FLOAT]", "", 1)
  If ($hAtcWind = 0) Then
    $iAnswer = MsgBox($MB_RETRYCANCEL,"","No FSX found.")
    Switch ($iAnswer)
      Case 4 ;retry
        GetFSX()
      Case Else
        MsgBox(0,"FSX Manager", "Closing FSX Manager." & @CRLF & "Bye!")
        Exit
    EndSwitch
  Else
    ; MsgBox(0,"FSX Manager", "FSX Ready")
    AtcWindowWait()
  EndIf  
EndFunc ;==> GetFSX

Func AtcWindowWait()
	While 1
    Switch TrayGetMsg()
      Case $idDefaultWinSize
        FSXSize(1042, 786)
      Case $idLargeWinSize
        FSXSize(1428, 1038)
      Case Else
      Local $bResult = AtcEvent()
    EndSwitch

		; Sleep($iSleepTimer) ; An idle loop.
	WEnd
EndFunc   ;==> AtcWindowWait

Func FsxPause()
    ; ControlSend ( "Microsoft Flight Simulator X", "", "[ClassNN:FS98CHILD2]", "^p" ) 
    ; Sleep(7000)

  ; If $bPauseFlag = False Then
  ;   ControlSend ( "Microsoft Flight Simulator X", "", "[ClassNN:FS98CHILD2]", "p" ) 
  ;   $bPauseFlag = True
  ;   $hTimer = TimerInit()
  ; Else
  ;   Local $fDiff = TimerDiff($hTimer)    
  ;   If  $fDiff > 7000 Then
  ;     $bPauseFlag = False
  ;     $hTimer = TimerInit()
  ;   EndIf
  ; EndIf
  Return True
EndFunc

Func AtcEvent()
  Local $iState = WinGetState ($hAtcWind)

  If ($iState = 5) Then
    $iSleepTimer=1000
    ; ToolTip("ATC inactive: " & $iState & " " & $iSleepTimer)
    ToolTip("")
    TraySetIcon($sIconTray, 0) ; Set the tray menu icon
  ElseIf ($iState = 0) Then
    TraySetIcon($sIconTrayPause, 0) ; Set the tray menu icon
    ; ToolTip("")
    MsgBox(0, "", "Lost Connection. Exiting.")
    EXIT
  Else
    $iSleepTimer=10
    ; ToolTip("ATC Active: " & $iState & " " & $iSleepTimer)
    TraySetIcon($sIconTrayAlert, 0) ; Set the tray menu icon
    Local $bResult = FsxPause()
    ToolTip("ATC")
    Return True
  EndIf
EndFunc ;==> AtcEvent

Func FSXSize($iWidth, $iHeight)
    #forceref $iWidth, $iHeight
    Local $hWnd = WinWait("[CLASS:FS98MAIN]")
    ; WinMove($hWnd, "", 865, 214, 1042, 786) ; Original
    ; WinMove($hWnd, "", 0, 0, 1280, 930) ; 1.25 scale
    ; WinMove($hWnd, "", 0, 0, 1428, 1038) ; 1.395 scale
    $iLeft = @DesktopWidth - $iWidth + 6
    $iTop = 0
    WinMove($hWnd, "", $iLeft, $iTop, $iWidth,	$iHeight) ; 1.395 scale
EndFunc   ;==>Resize

Func AtcTray()
  ; ---- Tray Menu ----
  TraySetToolTip("FSX Manager AutoIt, ver. " & $fScriptVersion) ; Set the tray menu tooltip with information about the icon index.
  TraySetIcon($sIconTray, 0) ; Set the tray menu icon

  Global $idDefaultWinSize = TrayCreateItem("Default Window - LongPress")
  Global $idLargeWinSize = TrayCreateItem("Large Window - LongPress")

  TraySetPauseIcon($sIconTrayPause, 0) ; Set the pause icon. This will flash on and off when the tray menu is selected and the script is paused.
  TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.
  TraySetClick(BitOR($TRAY_CLICK_PRIMARYDOWN, $TRAY_CLICK_SECONDARYDOWN)) ; Show the tray menu when the mouse if hovered over the tray icon.

  ; While 1
  ;   Switch TrayGetMsg()
  ;     Case $idDefaultWinSize
  ;       FSXSize(1042, 786)
  ;     Case $idLargeWinSize
  ;       FSXSize(1428, 1038)
  ;   EndSwitch
  ; WEnd
EndFunc ;==> AtcTray
