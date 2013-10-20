;
; AHK版本: 		B:1.0.48.5
;				L:1.1.3.0
; 语言:			中文/English
; 平台:			Win7
; 作者:			海盗 <healthlolicon@gmail.com>
;
;
;
;

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%  ;
Gui, Add, Edit, x2 y0 w240 h70 vUnix,
Gui, Add, Button, x2 y70 w240 h30 gtrans, ↑Unix↑↓Human↓
Gui, Add, Edit, x2 y100 w240 h90 vhuman,
; Generated using SmartGUI Creator 4.0
Gui, Show, x127 y87 h196 w251, 转换
Return

GuiClose:
ExitApp

trans:
GuiControlGet,Unix
GuiControlGet,Human
if(Unix)
{
	time:=Time_Unix2human(Unix)
	GuiControl,,human,% time
}Else{
	time:=Time_human2unix(human)
	GuiControl,,unix,% time
	}
Return