Gui, Add, Text, x5 y5 w100 vVar1 0x100, 1
Gui, Add, Text, y+5 w100 vVar2 0x100, 2
Gui, Add, Text, y+5 w100 vVar3 0x100, 3
Gui, Add, Picture, x5 y5 w48 h48 vImgButt1 0x100, C:\Work\OneDrive\Dev\Ahk\Experimental\GUItest2\orange.png
Gui, Add, Edit, y+5 w100 r1 vE1,
Gui, Show, ,
OnMessage(WM_MOUSEMOVE := 0x200, "Go")
Return

Go()
{
	GuiControl , , Edit1, %A_GuiControl%
  ToolTip, %A_GuiControl%
}