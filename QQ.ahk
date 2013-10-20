;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AHK版本：		1.0.48.5
; 语言：		中文
; 适用平台：	WinXp/NT
; 作者：		海盗 <healthlolicon@gmail.com>
; 脚本类型：
; 脚本功能：	禁止其他QQ号使用QQ
;
; 已知缺陷：
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#NoEnv
#Persistent
#SingleInstance off
#NoTrayIcon
;~ #Include, I:\AutoHotKey\Lib\
SendMode Input
SetWorkingDir %A_ScriptDir%
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DefaultQQ=407498134	;;;;;;此处是设置默认QQ号
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
run "C:\Program Files\Tencent\QQ2010\Bin\QQ.exe", , , NewPID	;引号内2010版QQ路径
SetTimer,checkQQnum,500
SetTimer,ExitApp,60000
Return

checkQQnum:
WinWait, ahk_class TXGuiFoundation ahk_pid %NewPID%
WinGet, NewHWND, ID, ahk_class TXGuiFoundation ahk_pid %NewPID%
WinGet, control_list, ControlList, ahk_class TXGuiFoundation ahk_pid %NewPID%
Loop, parse, control_list, `n
{
        If (A_LoopField <> "Edit1")
			QQnum = %A_LoopField%
}
ControlGetText,qq,%QQnum%,ahk_id %NewHWND%
IfNotInString,DefaultQQ,%qq%
{
Process,close,%NewPID%
SetTimer,exit,2500
MsgBox,16,Oops!,请使用[腾讯QQ08]
run "C:\Program Files\Tencent\QQ\QQ.exe"						;08版QQ路径，若无，清空此行
ExitApp
}
Return

exit:
run "C:\Program Files\Tencent\QQ\QQ.exe"						;08版QQ路径，若无，清空此行
exitapp:
ExitApp
Return