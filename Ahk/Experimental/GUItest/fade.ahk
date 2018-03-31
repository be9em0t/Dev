#NoEnv

#Persistent

#SingleInstance force

SetTitleMatchMode, 2

DetectHiddenWindows,On

Gui,+LastFound -border +AlwaysOnTop +ToolWindow -Caption

Gui,Color,yellow

Gui,Font, s20, Consolas

Gui,Add,Text, cWhite +center 0x1 vPeriod, Beauty sleep

Gui,Show ,y0 NoActivate, ScreenMask325

WinSet, Transparent, 0, ScreenMask325

loop, {

	Fade("in","ScreenMask325",5,220)

	Fade("out","ScreenMask325",5,220)

	}

Return

$F5::reload

Fade(Type="",WinTitle="",Speed=1,Trans=250) {

	if Type = In

		loop, %Trans% {

			WinSet, Transparent, %A_Index%, %WinTitle%

			sleep, %Speed%

			}

	If Type = Out

		loop, %Trans% {

			WinSet, Transparent, % Trans - A_Index, %WinTitle%

			sleep, %Speed%

			}

	}

