Menu, Tray, Icon, c:\Work\OneDrive\Documents Vla\begemotUI\Icons\[Replacements]\Autohotkey.ico, 0

;; Middle Mouse click Titlebar
CoordMode, Mouse

~MButton::
 MouseGetPos, X, Y, ID
 If (IsOverTitleBar(X,Y,ID))
  MsgBox, Title bar!
return

IsOverTitleBar(x, y, hWnd) { 
 SendMessage, 0x84,, (x & 0xFFFF) | (y & 0xFFFF) << 16,, ahk_id %hWnd% 
 if ErrorLevel in 2,3,8,9,20,21 
  return true 
 else 
  return false 
}


/* Mouse double-click
~LButton:: 
If (A_TimeSincePriorHotkey<400) and (A_PriorHotkey="~LButton")
 MsgBox You double Left clicked on something 
Return

~RButton:: 
If (A_TimeSincePriorHotkey<400) and (A_PriorHotkey="~RButton")
 MsgBox You double Right clicked on something 
Return
*/

/* Simple double-tab
~n::
KeyWait n ;and use keywait on keys that autorepeat when held
If (A_TimeSincePriorHotkey<400) and (A_PriorHotkey="~n") 
 MsgBox You double n pressed
Return
*/


/* Press, Hold and Double-Tap
~Ctrl:: 

KeyWait Ctrl, T.3

If ErrorLevel

 {

 MsgBox You Held Ctrl

 KeyWait Ctrl ;wait for n to be released so a hold then a single dosen't count as a double

 Return

 }

KeyWait Ctrl, D T.3

If !ErrorLevel

 MsgBox You Double pressed Ctrl

Return
*/