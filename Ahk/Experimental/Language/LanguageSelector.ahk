#NoEnv
CoordMode, Mouse, Screen

MouseTipUpdateInterval := 10
global langName

GoSub LanguageList

; Language list
; Leave empty string to disable tooltip
LanguageList:
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

f15::
  NextLang()
  Sleep, 20
  TestLang()
Return
  

NextLang(){
PostMessage WM_INPUTLANGCHANGEREQUEST:=0x50, INPUTLANGCHANGE_FORWARD:=0x2,,, % (hWndOwn := DllCall("GetWindow", Ptr, hWnd:=WinExist("A"), UInt, GW_OWNER := 4, Ptr)) ? "ahk_id" hWndOwn : "ahk_id" hWnd
}


TestLang(){
  SetFormat, Integer, H
  lang := DllCall("GetKeyboardLayout", Int,DllCall("GetWindowThreadProcessId", int,WinActive("A"), Int,0))
  ; Clipboard := lang
  SetFormat, Integer, D
  
  shortLang = % SubStr(lang, -3)
  langName := %shortLang% 
  ; MsgBox %langName%

if langName 
  GoSub ShowMouseTip
Else
  GoSub HideMouseTip  
}

ShowMouseTip:
  SetTimer, ShowMouseTip, %MouseTipUpdateInterval%
  ; CoordMode Mouse, Relative
  MouseGetPos, xpos, ypos
  ; ToolTip, %xpos% %ypos%
  ToolTip, %langName% ;, xpos + 5, ypos + 5
return

HideMouseTip:
  SetTimer, ShowMouseTip, Off
  Tooltip,
return
