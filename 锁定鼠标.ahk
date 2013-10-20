;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AHK版本：		1.0.48.5
; 语言：		中文
; 适用平台：	WinXp/NT
; 作者：		海盗 <healthlolicon@gmail.com>
; 脚本类型：	程序
; 脚本功能：	锁定鼠标
;
; 已知缺陷：	ctrl+l锁定鼠标，ctrl+q输入密码解锁
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Persistent
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
;~ Menu, Tray, NoStandard

Gosub,Lock
Return

Lock:
^l::
BlockInput,MouseMove
CustomColor = EEAA99 ; 可以是任何 RGB 值，他将用于后面的透明设置
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow ; +ToolWindow 可以避免在任务栏显示按钮，并且不会出现在 alt-tab 菜单中
Gui, Color, %CustomColor%
Gui, Font, s32 ; 选择32号字体
Gui, Add, Text, cLime, 鼠 标 锁 定 状 态 ; XX & YY 可以用来让窗体自动调整大小
; 使指定颜色的像素变得透明，并且使字体本身透明度为150
WinSet, TransColor, %CustomColor% 150
YY:=A_ScreenHeight/2
XX:=A_ScreenWidth/2-200
Gui, Show, x%XX% y%YY% NoActivate ; 不激活窗体避免改变当前激活的窗口
Return

^q::
InputBox,password,%A_Space%,%A_Space%,HIDE,250,120
If password = password
{
	BlockInput,MouseMoveOff
	Gui, destroy
	}
Else if password = exitapp
	ExitApp
Return

$SC15B::
Return

~r::
if A_PriorHotkey=$SC15B
	if A_TimeSincePriorHotkey<1000
		send,#r
Return
