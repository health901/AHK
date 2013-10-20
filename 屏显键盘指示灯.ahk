;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AHK版本：		1.0.48.5
; 语言：		中文
; 适用平台：	WinXp/NT
; 作者：		海盗 <healthlolicon@gmail.com>
; 脚本类型：	软件
; 脚本功能：	屏显键盘指示灯，在屏幕角落显示Caps、Scroll、Num锁状态。
;				For 雷柏无线键鼠套以及其他键盘无指示灯用户。
; 已知缺陷：
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Persistent
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
Menu, Tray, NoStandard
Menu, Tray, Add,反馈,email
Menu, Tray, Add,设置,setting
Menu, Tray, Add,退出,exit
Menu, Tray, Tip, 屏显键盘指示灯(LockTip)
;~ Menu, Tray, Add,reload,reload
;------------------------------------------------------------------
Gosub,iniread
pos:
If pos=1						;↖
{
	posx := -30
	posy :=
	checked = 左上
	}
Else If pos=2					;↗
{
	posx :=A_ScreenWidth - 170
	posy :=
	checked = 右上
	}
Else If pos=3					;↙
{
	posx := -30
	posy :=A_ScreenHeight - 120
	checked = 左下
	}
Else If pos=4					;↘
{
	posx :=A_ScreenWidth - 170
	posy :=A_ScreenHeight - 120
	checked = 右下
	}
Color:
Colorhex =0x%Color%
SetFormat, INTEGER, H
CustomColor := Colorhex-1 ; 可以是任何 RGB 值，他将用于后面的透明设置
SetFormat, INTEGER, D
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow ; +ToolWindow 可以避免在任务栏显示按钮，并且不会出现在 alt-tab 菜单中
Gui, Color, %CustomColor%
Gui, Font, s32 ; 选择32号字体
Gui, Add, Text, vNum_Lock c%Color%, ○
GetKeyState,Lock,NumLock,T
If Lock=D
	GuiControl,,Num_Lock,●
Gui, Add, Text, xp+40 vCaps_Lock c%Color%, ○
GetKeyState,Lock,CapsLock,T
If Lock=D
	GuiControl,,Caps_Lock,●
Gui, Add, Text, xp+40  vScroll_Lock c%Color%, ○
GetKeyState,Lock,ScrollLock,T
If Lock=D
	GuiControl,,Scroll_Lock,●
; 使指定颜色的像素变得透明，并且使字体本身透明度为150
;~ Gui, Font, s20
;~ Gui, Add, Text,xp-70 yp+38 c%Color%,NL
;~ Gui, Add, Text,xp+41 c%Color%,CL
;~ Gui, Add, Text,xp+41 c%Color%,SL
WinSet, TransColor, %CustomColor% %TransColor%
Gui, Show, x%posx% y%posy% NoActivate
Return

;--------------------------------------------------------------------------------
~ScrollLock::
GetKeyState,Lock,ScrollLock,T
If Lock=D
	GuiControl,,Scroll_Lock,●
Else
	GuiControl,,Scroll_Lock,○
Return

~CapsLock::
GetKeyState,Lock,CapsLock,T
If Lock=D
	GuiControl,,Caps_Lock,●
Else
	GuiControl,,Caps_Lock,○
Return

~NumLock::
GetKeyState,Lock,NumLock,T
If Lock=D
	GuiControl,,Num_Lock,●
Else
	GuiControl,,Num_Lock,○
Return

;-----------------------------------------------------------------------------
setting:
Gui, 2:Add, GroupBox, x16 y11 w140 h100 , 指示灯位置
Gui, 2:Add, Radio, x26 y31 w50 h20 vpos, 左上
Gui, 2:Add, Radio, x96 y31 w50 h20 , 右上
Gui, 2:Add, Radio, x26 y71 w50 h20 , 左下
Gui, 2:Add, Radio, x96 y71 w50 h20 checked, 右下
Gui, 2:Add, GroupBox, x176 y11 w180 h100 , 指示灯颜色
Gui, 2:Add, Text, x196 y31 w84 h19 , 16进制RGB值
Gui, 2:Add, Edit,vColor x196 y81 w130 h20,%Color%
Gui, 2:Font, underline
Gui, 2:Add, Text, x196 y56 w90 h20 gweb cRed, 查看参考
Gui, 2:Font, norm
; Generated using SmartGUI Creator 4.0
GuiControl,2:,%checked%,1
Gui, 2:Add, GroupBox, x16 y120 w340 h70 , 透明度
Gui, 2:Add, Edit,xp+20 yp+25
Gui, 2:Add, UpDown, vTransColor  Range0-255,%TransColor%
Gui, 2:Add, Text, xp+150 yp+5,(0～255之间整数,默认值150)
Gui, 2:Show, h194 w369, 设置
Return

2GuiClose:
Gui,2:Submit
Gosub,iniwrite
Reload
return

IniRead:
IniRead, TransColor,  LockTip.ini, 设置,TransColor, 150
IniRead, pos, LockTip.ini, 设置, Position, 4
IniRead, Color, LockTip.ini, 设置, Color, 0000FF
Return
IniWrite:
If TransColor>255
	TransColor=255
If TransColor<0
	TransColor=0
IniWrite, %TransColor%,  LockTip.ini, 设置,TransColor
IniWrite, %pos%, LockTip.ini, 设置, Position
Gosub,ColorCheck
If OK
	IniWrite, %Color%, LockTip.ini, 设置, Color
Return

ColorCheck:
Color :=RegExReplace(Color,"[^0-9a-fA-F]","")
If StrLen(Color)=6
	OK=1
Return
;-----------------------------------------------------------------------------
web:
Run,http://www.wahart.com.hk/rgb.htm
Return

email:
Run, mailto:heathlolicon@gmail.com?subject=报告BUG、反馈建议（LockTip）
Return

exit:
ExitApp
Return

;~ Reload:
;~ Reload
;~ Return