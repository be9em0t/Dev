#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

F3::                           ; Я назначил на F3, но это понятно, кому как удобно
if(ExposedOpened==""){                    ;Флаг открытых Exposed
WinGet, id, list,,, Program Manager              ;Создаю массив id с открытыми окнами
numwin=0                               ;Счётчик окон, которые я буду использовать
Loop, %id%
{
    this_id := id%A_Index%
   WinGetTitle, this_title, ahk_id %this_id%      
                             ;Получаю title текущего в цикле окна, а затем отсеиваю ненужные.
                             ;Я не знаю, как лучше сделать, чем просто назвать,те, которые мне не надо. Если кто придумает способ лучше моего, это было бы здорово
 if(this_title!="Пуск"&&this_title!="Raspisanie"&&this_title!="Custom Calendar"&&this_title!="System Controls"&&this_title!=""&&this_title!="        QIP        ")
{
numwin++     
                             ;Сохраняю массив позиций, размеров и названий окон: wind - названия, windx и windy - позиции, windw и windh - размеры
   WinGetPos, this_x, this_y, this_w, this_h, ahk_id %this_id%
wind%numwin%=%this_title%
windx%numwin%=%this_x%
windy%numwin%=%this_y%
windw%numwin%=%this_w%
windh%numwin%=%this_h%

}
}
if(numwin>1&&numwin<10){       
                             ;Я работаю с количеством окон от 2 до 9 включительно.
                             ;Это связанно с тем, как я считаю координаты и размер новых окон, а делаю я это очень очень криво. опять же, любая помощь - это здорово
Loop %numwin%
{
                                ;Собственно кривым образом, зависящим от количества окон (кстати, я не нашёл свитча он есть тут вообще?), считаю новую позицию окон
if(numwin==2){
    new_x:=((A_ScreenWidth/2)*(A_Index-1))+10
    new_y:=10
    new_w:=(A_ScreenWidth-30)/2
    new_h:=(A_Screenheight)-20
    if(windw%A_Index%<new_w)
    new_w:=windw%A_Index%
    if(windh%A_Index%<new_h)
    new_h:=windh%A_Index%
}
if(numwin==3){
    new_x:=((A_ScreenWidth/3)*(A_Index-1))+10
    new_y:=10
    new_w:=(A_ScreenWidth-40)/3
    new_h:=(A_Screenheight)-20
    if(windw%A_Index%<new_w)
    new_w:=windw%A_Index%
    if(windh%A_Index%<new_h)
    new_h:=windh%A_Index%
}
if(numwin==4){
    if(A_Index<3){
        new_x:=((A_ScreenWidth/2)*(A_Index-1))+10
        new_y:=10
    }
    else{
        new_x:=((A_ScreenWidth/2)*(A_Index-3))+10
        new_y:=(A_Screenheight/2)+10
    }
    new_w:=(A_ScreenWidth-30)/2
    new_h:=(A_Screenheight-30)/2
    if(windw%A_Index%<new_w)
    new_w:=windw%A_Index%
    if(windh%A_Index%<new_h)
    new_h:=windh%A_Index%
}
if(numwin==5||numwin==6){
    if(A_Index<4){
        new_x:=((A_ScreenWidth/3)*(A_Index-1))+10
        new_y:=10
    }
    else{
        new_x:=((A_ScreenWidth/3)*(A_Index-4))+10
        new_y:=(A_Screenheight/2)+10
    }
    new_w:=(A_ScreenWidth-40)/3
    new_h:=(A_Screenheight-30)/2
    if(windw%A_Index%<new_w)
    new_w:=windw%A_Index%
    if(windh%A_Index%<new_h)
    new_h:=windh%A_Index%
}
if(numwin==7||numwin==8||numwin==9){
    if(A_Index<4){
        new_x:=((A_ScreenWidth/3)*(A_Index-1))+10
        new_y:=10
    }
    else if(A_Index<7){
        new_x:=((A_ScreenWidth/3)*(A_Index-4))+10
        new_y:=(A_Screenheight/3)+10
    }
    else{
    new_x:=((A_ScreenWidth/3)*(A_Index-7))+10
    new_y:=((A_Screenheight/3)*2)+10
    }
    new_w:=(A_ScreenWidth-40)/3
    new_h:=(A_Screenheight-40)/3
    if(windw%A_Index%<new_w)
    new_w:=windw%A_Index%
    if(windh%A_Index%<new_h)
    new_h:=windh%A_Index%
}
the_t:=wind%A_Index%
WinMove, %the_t%, , new_x, new_y , new_w, new_h               ;Двигаю окно (Видимо, одну из этих строк можно убрать)
}
ExposedOpened:="yes"       ;Ставлю флаг и хоткеи на все кнопки мыши
Hotkey, MButton, ChooseTheWindow, On
Hotkey, LButton, ChooseTheWindow, On
Hotkey, RButton, ChooseTheWindow, On
}
}
else{                                   ;Функция, когда флаг ExposedOpened чему-нибудь равен (в данном случае "yes") 
Loop %numwin%{
the_t:=wind%A_Index%
the_x:=windx%A_Index%
the_y:=windy%A_Index%
the_w:=windw%A_Index%
the_h:=windh%A_Index%
;Ставлю окна на место. (Опять же, видимо можно было обойтись без the_t)
WinMove, %the_t%, , the_x, the_y , the_w, the_h
}
ExposedOpened:=""                             ;Флаг на место, хоткеи убрать
Hotkey, MButton, ChooseTheWindow, Off
Hotkey, LButton, ChooseTheWindow, Off
Hotkey, RButton, ChooseTheWindow, Off
}
return

ChooseTheWindow:
MouseGetPos, , , the_win_id                          ;Определение над каким окном (получаю идентификатор его) находится мышь
Send, {F3}                                          ;Мне показалось, что это самый простой способ поставить всё на место
WinActivate, ahk_id %the_win_id%                     ;Активировать выбранное окно
return