

#NoEnv
;- example time and date
formattime,x,L1053,dddden 'den' d MMMM - yyyy kl. hh:mm
msgbox,%x%

!l::
; ;- Your keyboard is =
; ; method 1
; SetFormat, Integer, H
; aac1:= % DllCall("GetKeyboardLayout", Int,DllCall("GetWindowThreadProcessId", int,WinActive("A"), Int,0))
; msgbox,AAC1=%aac1%
; SetFormat, Integer, D

; method 2
VarSetCapacity(kbd, 9)
if DllCall("GetKeyboardLayoutName", uint, &kbd)
  msgbox, % kbd
Return


;- EXAMPLE = CHANGE KEYBOARD
;-------- https://autohotkey.com/boards/viewtopic.php?f=6&t=18519 ---
;- example-1 ctrl+2 > US
^1::SetDefaultKeyboard(0x0406) ; Danish
^2::SetDefaultKeyboard(0x0409) ; English (USA)
^3::SetDefaultKeyboard(0x0809) ; English (UK)
^4::SetDefaultKeyboard(0x0411) ; Japanese
^5::SetDefaultKeyboard(0x0408) ; Greek
^6::SetDefaultKeyboard(0x0807) ; swiss german
^7::SetDefaultKeyboard(0x7C04) ; chinese traditional
^8::SetDefaultKeyboard(0x0004) ; chinese simplified
^9::SetDefaultKeyboard(0x0C04) ; chinese HK
return

;- example-2  = toggle F4 > dansk or english-US
$F4::
V++
M:=mod(V,2)
if M=1
   SetDefaultKeyboard(0x0406) ; Danish
else
   SetDefaultKeyboard(0x0409) ; english-US
return

SetDefaultKeyboard(LocaleID){
	Global
	SPI_SETDEFAULTINPUTLANG := 0x005A
	SPIF_SENDWININICHANGE := 2

	Lan := DllCall("LoadKeyboardLayout", "Str", Format("{:08x}", LocaleID), "Int", 0)
	VarSetCapacity(Lan%LocaleID%, 4, 0)
	NumPut(LocaleID, Lan%LocaleID%)
	DllCall("SystemParametersInfo", "UInt", SPI_SETDEFAULTINPUTLANG, "UInt", 0, "UPtr", &Lan%LocaleID%, "UInt", SPIF_SENDWININICHANGE)

	WinGet, windows, List
	Loop %windows% {
		PostMessage 0x50, 0, %Lan%, , % "ahk_id " windows%A_Index%
	}
}
;=====================================================