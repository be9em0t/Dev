; #NoTrayIcon
Menu, Tray, Icon, %A_ScriptDir%\b9MiscRes\P-icon.ico, 0
Menu, Tray, Tip, LangSwitch - CapsLock `nTransp - Shift+Win+W `nTopmost - Shift+Win+T `nTraymin - Win+H `nScreenCap - Win+Ins 
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

; Verify the correct path to include scripts
; #Include d:\Work\OneDrive\Dev\Ahk\Includes 
#Include %A_ScriptDir%\Includes
#IncludeAgain, ToolTipOpt.ahk
#IncludeAgain, Gdip_All.ahk
#IncludeAgain, GDIpHelper.ahk


; Run c:\Work\OneDrive\Dev\Ahk\Experimental\TrayMin\traymin.ahk
;ExitApp 

global MouseX, MouseY
global PopUIw := 96, PopUIh := 96
global PopOffsetX := PopUIw//2 , PopOffsetY := PopUIh//2
global TimerHide := 1200, AnimSpeed := 40, AnimSteps := 4
global CustomColor := "Fuchsia"  ; Can be any RGB color (it will be made transparent below).
global LangName
global TranspWin := 150

MouseTipUpdateInterval := 10

; === Main ===
Gosub, popupUIPrepare
Gosub, menu1QuadPrepare
Gosub, menu3QuadPrepare
Gosub, menu4QuadPrepare
GoSub languageList

; popupUI
#`::
  Gosub ShowUIFade
return

; Screen Capture
#Ins::
  Run, "c:\Ketarin\Design\Xnview\XnView\xnview.exe" "-capture=window"
return
!#Ins::
  Run, "c:\Ketarin\Design\Xnview\XnView\xnview.exe" "-capture=desktop"
return
^#Ins::send {LWinDown}}{ShiftDown}s{ShiftUp}{LWinUp}
  ; Run, "c:\Windows\System32\SnippingTool.exe /clip"
return

f15:: ; Switch Lnguages. (Need to set Capslock to F15 firs)
  LanguageNext()
  Sleep, 20
  LanguageTip()
Return

; Block weird Win-keyboard hotkeys
^#space::

^+#space::
return

+#W::
  Gosub ToggleTranspWin
return

+#T::
  GoSub ToggleTopmost
return

; Prepare PopupMainUI
popupUIPrepare:
Gui, Color, %CustomColor%
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow ; Make the GUI window the last found window for use by the line below.
WinSet, TransColor, %CustomColor% 0

; Gui, Font, s18, Arial ; Set a large font size (32-point).
; Gui, Add, Text, vMyText cRed -Border, XXXXX YYYYY  ; XX & YY serve to auto-size the window.
; Gui, Add, Button, gMsgTest Default, Ok
Gui, Add, Picture, gMenu1Show x0 y0 w48 h-1 AltSubmit, %A_ScriptDir%\b9MiscRes\a.png
Gui, Add, Picture, gMenu2RunKP x48 y0 w48 h-1 AltSubmit, %A_ScriptDir%\b9MiscRes\b.png
Gui, Add, Picture, gMenu3Show x0 y48 w48 h-1 AltSubmit, %A_ScriptDir%\b9MiscRes\c.png
Gui, Add, Picture, gMenu4Show x48 y48 w48 h-1 AltSubmit, %A_ScriptDir%\b9MiscRes\d.png
return

; === popupUI Menus ===
menu1QuadPrepare:
Menu, Menu1quad, Add, begemot Gmail, PopMenuHandler
Menu, Menu1quad, Add, begemot Outlook, PopMenuHandler
Menu, Menu1quad, Add, keta, PopMenuHandler
Menu, Menu1quad, Add  ; Add a separator line.
Menu, Menu1quad, Add, Run PowePro, PopMenuHandler
return

menu3QuadPrepare:
Menu, Menu3quad, Add, Activate, PopMenuHandler
Menu, Menu3quad, Add, Rollup, PopMenuHandler
Menu, Menu3quad, Add, TrayMin, PopMenuHandler
Menu, Menu3quad, Add, OnTop, PopMenuHandler
Menu, Menu3quad, Add, NotOnTop, PopMenuHandler
  Menu, SubmenuQ3-1, Add, Set Capture BG, PopMenuHandler
  Menu, SubmenuQ3-1, Add, Restore Background, PopMenuHandler
    Menu, Menu3quad, Add  ; Add a separator line.
  Menu, Menu3quad, Add, Window Resize, :SubmenuQ3-1
return

menu4QuadPrepare:
Menu, Menu4quad, Add, AHK Spy, PopMenuHandler
Menu, Menu4quad, Add, WindowInfo, PopMenuHandler
Menu, Menu4quad, Add, Test Info, PopMenuHandler
    Menu, Menu4quad, Add  ; Add a separator line.
  Menu, SubmenuQ4-1, Add, Run PowePro, PopMenuHandler
  Menu, SubmenuQ4-1, Add, Item2, PopMenuHandler
Menu, Menu4quad, Add, Unfinished, :SubmenuQ4-1
  Menu, SubmenuQ4-2, Add, AHK Help, PopMenuHandler  ; Add another menu item beneath the submenu.
  Menu, SubmenuQ4-2, Add, Edit Script, PopMenuHandler
  Menu, SubmenuQ4-2, Add, Reload Script, PopMenuHandler  ; Add another menu item beneath the submenu.
  Menu, SubmenuQ4-2, Add, Quit, PopMenuHandler  ; Add another menu item beneath the submenu.
Menu, Menu4quad, Add, Script Options, :SubmenuQ4-2
return

; === PopupUI subroutines ===
PopMenuHandler:
Gosub HideUIFade
if (A_ThisMenuItem = "begemot Gmail") {
  Send, {AltDown}{Tab}{AltUp}
  Sleep, 100
  Send, be9em0t@gmail.com
}
Else if (A_ThisMenuItem = "begemot Outlook"){
  Send, {AltDown}{Tab}{AltUp}
  Sleep, 100
  Send, be9em0t@outlook.com
}
Else if (A_ThisMenuItem = "keta"){
  Send, {AltDown}{Tab}{AltUp}
  Sleep, 100
  Send, chu5aca3r@
}
Else if (A_ThisMenuItem = "Run PowePro") {
  run c:\Ketarin\Tools\PowerPro\Powerpro.exe
  ; Goto HideUIFade
}
Else if (A_ThisMenuItem = "Activate") {
  Goto ActivateWinUM
}
Else if (A_ThisMenuItem = "AHK Spy"){
  Run c:\Ketarin\Tools\Autohotkey\WinSpy\WinSpy.ahk
}
Else if (A_ThisMenuItem = "WindowInfo"){
  MsgBox, "Scriptdir: " %A_ScriptDir% "Script HWIND abd Name" %A_ScriptHwnd% %A_ScriptName%
}
Else if (A_ThisMenuItem = "AHK Help"){
  ; SplitPath, A_AhkPath,, helpPath
  ; helpPath = %helpPath%\AutoHotkey.chm
  Run https://autohotkey.com/docs/AutoHotkey.htm
}
Else if (A_ThisMenuItem = "Edit Script"){
  Run Code.exe %A_ScriptFullPath%
}
Else if (A_ThisMenuItem = "Reload Script") {
  Reload
}
Else if (A_ThisMenuItem = "Quit") {
  ExitApp
}
Else {
  MsgBox Command not found.
}
return

ToggleTranspWin:
  WinGet, currentTransparency, Transparent, A
  if (currentTransparency = 150)
    {
      WinSet, Transparent, OFF, A
    }
  else
    {
      WinSet, Transparent, 150, A
    }
return

ShowUIFade:
  MouseGetPos, MouseX, MouseY
  WidthLimit := A_ScreenWidth - PopUIw
  HeightLimit := A_ScreenHeight - PopUIh
  if (MouseX > (WidthLimit  + PopOffsetX))
    MouseX := WidthLimit
  else if (MouseX < (PopOffsetX))
    MouseX := 0
  else
    MouseX := MouseX - PopOffsetX 
  if (MouseY > (HeightLimit  + PopOffsetY))
    MouseY := HeightLimit
  else if (MouseY < (PopOffsetY))
    MouseY := 0
  else
    MouseY := MouseY - PopOffsetY 

  ; Tooltip %MouseX% %MouseY%
  
  TranspValue = 0
  TranspStep := 255//AnimSteps
  WinSet, TransColor, %CustomColor% TranspValue, popUI
  Gui, Show, X%MouseX% Y%MouseY% W%PopUIw% H%PopUIh% NoActivate, popUI
  Loop, %AnimSteps% {
      TranspValue := TranspValue + TranspStep
      WinSet, TransColor, %CustomColor% %TranspValue%, popUI
      Sleep, %AnimSpeed%
  }
  WinSet, TransColor, %CustomColor% 250, popUI
  Sleep, %AnimSpeed% 
  SetTimer, MouseOverRect, %TimerHide%
return

HideUIFade:
  SetTimer, MouseOverRect, Off
  TranspValue = 255
  TranspStep := 255//AnimSteps
  Loop, %AnimSteps% {
      TranspValue := TranspValue - TranspStep
      WinSet, TransColor, %CustomColor% %TranspValue%, popUI
      Sleep, %AnimSpeed%
  }
  WinSet, TransColor, %CustomColor% 0, popUI
  Gui, Cancel
return

Menu1Show:
  Menu, Menu1quad, Show  ; i.e. press the Win-Z hotkey to show the menu.
return

Menu2RunKP:
  run, "C:\Ketarin\Tools\KeePass\KeePass.exe"
return

Menu3Show:
  Menu, Menu3quad, Show  ; i.e. press the Win-Z hotkey to show the menu.
return

Menu4Show:
  Menu, Menu4quad, Show  ; i.e. press the Win-Z hotkey to show the menu.
return


; === Universal Subroutines ===
MouseOverRect:
	MouseGetPos MouseXtmp, MouseYtmp
  if !(MouseXtmp >= MouseX AND MouseXtmp < MouseX + PopUIw AND MouseYtmp >= MouseY AND MouseYtmp < MouseY + PopUIh) 
    Gosub HideUIFade
return

ActivateWinUM:
  MouseGetPos,,, WinUMID
  WinActivate, ahk_id %WinUMID%
return

ToggleTopmost:
  WinGet, currentWindow, ID, A
  WinGet, ExStyle, ExStyle, ahk_id %currentWindow%
  if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
  {
    Winset, AlwaysOnTop, off, ahk_id %currentWindow%
    SplashImage,, x0 y0 b fs12, OFF always on top.
    Sleep, 1500
    SplashImage, Off
  }
  else
  {
    WinSet, AlwaysOnTop, on, ahk_id %currentWindow%
    SplashImage,,x0 y0 b fs12, ON always on top.
    Sleep, 1500
    SplashImage, Off
  }
return


; === LANGUAGE ROUTINES ===
; Language list - leave empty string to disable tooltip
languageList:
FBFE = BG Vla
0436 = Afrikaans
041c = Albanian
0401 = Arabic_Saudi_Arabia
0801 = Arabic_Iraq
0c01 = Arabic_Egypt
0401 = Arabic_Saudi_Arabia
0801 = Arabic_Iraq
0c01 = Arabic_Egypt
1001 = Arabic_Libya
1401 = Arabic_Algeria
1801 = Arabic_Morocco
1c01 = Arabic_Tunisia
2001 = Arabic_Oman
2401 = Arabic_Yemen
2801 = Arabic_Syria
2c01 = Arabic_Jordan
3001 = Arabic_Lebanon
3401 = Arabic_Kuwait
3801 = Arabic_UAE
3c01 = Arabic_Bahrain
4001 = Arabic_Qatar
042b = Armenian
042c = Azeri_Latin
082c = Azeri_Cyrillic
042d = Basque
0423 = Belarusian
0402 = Bulgarian
0403 = Catalan
0404 = Chinese_Taiwan
0804 = Chinese_PRC
0c04 = Chinese_Hong_Kong
1004 = Chinese_Singapore
1404 = Chinese_Macau
041a = Croatian
0405 = Czech
0406 = Danish
0413 = Dutch_Standard
0813 = Dutch_Belgian
0409 = ; English_United_States
0809 = English_United_Kingdom
0c09 = English_Australian
1009 = English_Canadian
1409 = English_New_Zealand
1809 = English_Irish
1c09 = English_South_Africa
2009 = English_Jamaica
2409 = English_Caribbean
2809 = English_Belize
2c09 = English_Trinidad
3009 = English_Zimbabwe
3409 = English_Philippines
0425 = Estonian
0438 = Faeroese
0429 = Farsi
040b = Finnish
040c = French_Standard
080c = French_Belgian
0c0c = French_Canadian
100c = French_Swiss
140c = French_Luxembourg
180c = French_Monaco
0437 = Georgian
0407 = German_Standard
0807 = German_Swiss
0c07 = German_Austrian
1007 = German_Luxembourg
1407 = German_Liechtenstein
0408 = Greek
040d = Hebrew
0439 = Hindi
040e = Hungarian
040f = Icelandic
0421 = Indonesian
0410 = Italian_Standard
0810 = Italian_Swiss
0411 = Japanese
043f = Kazakh
0457 = Konkani
0412 = Korean
0426 = Latvian
0427 = Lithuanian
042f = Macedonian
043e = Malay_Malaysia
083e = Malay_Brunei_Darussalam
044e = Marathi
0414 = Norwegian_Bokmal
0814 = Norwegian_Nynorsk
0415 = Polish
0416 = Portuguese_Brazilian
0816 = Portuguese_Standard
0418 = Romanian
0419 = Russian
044f = Sanskrit
081a = Serbian_Latin
0c1a = Serbian_Cyrillic
041b = Slovak
0424 = Slovenian
040a = Spanish_Traditional_Sort
080a = Spanish_Mexican
0c0a = Spanish_Modern_Sort
100a = Spanish_Guatemala
140a = Spanish_Costa_Rica
180a = Spanish_Panama
1c0a = Spanish_Dominican_Republic
200a = Spanish_Venezuela
240a = Spanish_Colombia
280a = Spanish_Peru
2c0a = Spanish_Argentina
300a = Spanish_Ecuador
340a = Spanish_Chile
380a = Spanish_Uruguay
3c0a = Spanish_Paraguay
400a = Spanish_Bolivia
440a = Spanish_El_Salvador
480a = Spanish_Honduras
4c0a = Spanish_Nicaragua
500a = Spanish_Puerto_Rico
0441 = Swahili
041d = Swedish
081d = Swedish_Finland
0449 = Tamil
0444 = Tatar
041e = Thai
041f = Turkish
0422 = Ukrainian
0420 = Urdu
0443 = Uzbek_Latin
0843 = Uzbek_Cyrillic
042a = Vietnamese
return

LanguageNext(){
PostMessage WM_INPUTLANGCHANGEREQUEST:=0x50, INPUTLANGCHANGE_FORWARD:=0x2,,, % (hWndOwn := DllCall("GetWindow", Ptr, hWnd:=WinExist("A"), UInt, GW_OWNER := 4, Ptr)) ? "ahk_id" hWndOwn : "ahk_id" hWnd
}


LanguageTip(){
  SetFormat, Integer, H
  lang := DllCall("GetKeyboardLayout", Int,DllCall("GetWindowThreadProcessId", int,WinActive("A"), Int,0))
  ; Clipboard := lang
  SetFormat, Integer, D

  shortLang = % SubStr(lang, -3)
  LangName := %shortLang% 

  if LangName 
    GoSub LangShowMouseTip
  Else
    GoSub LangHideMouseTip  
}

LangShowMouseTip:
  SetTimer, LangShowMouseTip, %MouseTipUpdateInterval%
  ; CoordMode Mouse, Relative
  MouseGetPos, mXpos, mYpos
  ; ToolTip, %mXpos% %mYpos%
  ToolTipColor("Red", "Black")
  ToolTip, %LangName% ;, mXpos + 20, mYpos - 30
return

LangHideMouseTip:
  SetTimer, LangShowMouseTip, Off
  Tooltip,
return
