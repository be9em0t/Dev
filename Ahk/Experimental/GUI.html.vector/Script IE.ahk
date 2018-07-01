
	coordmode, mouse, screen
	mousegetpos theX, theY
	Gui destroy ; destroy previously opened gui, prevent duplicate
	
	Gui add, activeX, w100 h90 vTest, shell.explorer
	test.silent := true
	test.navigate("d:\Work\OneDrive\Dev\Ahk\Experimental\GUI.vector\Untitled.html")
	Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  
	CustomColor = 555555 
	Gui, Color, %CustomColor%
	WinSet, TransColor, %CustomColor% 255 
	while test.readyState != 4 or test.busy
	    sleep 100
	
	;test := test.document.getElementById("div1") ; this method will fail... WHY WHY!
	ComObjConnect(test, "test_") 
	Gui, Show, x%theX% y%theY%, htmgui_tester 
	
    test_BeforeNavigate2(test, theUrl) {
    ; beforeNavigate2 will use 1st parameter "test" Object and 2nd parameter "url" for processing.
    ; check  http://msdn.microsoft.com/en-us/library/aa752085 for more events and parameters they support.
    	test.Stop() ; prevent navigating and do something else below this script:
        if (InStr(theUrl,"myapp://")==1) { 
        ; ensures BeforeNavigate2 event received theUrl that contain "myapp://" 
        ; either fired by href from "a" link tag or window.location("") from javascript will produce BeforeNavigate2 event
            stuff := SubStr(theUrl,Strlen("myapp://")) ;get stuff after "myapp://"
            if InStr(stuff,"msgbox/cool"){
                MsgBox ,,,Five!! 1,0.1
                MsgBox ,,,Five!! 2,0.2
                MsgBox ,,,Five!! 3,0.3
                MsgBox ,,,Five!! 4,0.4
                MsgBox ,,,Five!! 5,0.5
            }else if InStr(stuff,"msgbox/woah")
                soundbeep
            else if InStr(stuff,"msgbox/js"){
                SoundPlay, %A_WinDir%\Media\tada.wav
                sleep 3000
            }
        }

	Gui destroy
        SetTitleMatchMode RegEx
        WinActivate, i).*autohotkey.ahk.*
    }

return