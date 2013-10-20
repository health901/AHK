;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AHK版本：		1.0.48.5(www.autohotkey.com)
; 语言：		中文/Chinese
; 适用平台：	WinXp/NT
; 作者：		海盗 <healthlolicon@gmail.com>
; 脚本类型：	软件
; 脚本功能：	打开快捷方式所在目录-右键菜单/Open Shotcut's Folder via Context Menu
; 注意事项：
; 已知缺陷：
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#NoEnv
#NoTrayIcon
#SingleInstance off
SendMode Input
SetWorkingDir %A_ScriptDir%

if 1=
goto,Gui
FileGetShortcut,%1%,,dir
run,`"%dir%`"
exitapp

Gui:
Gui, Add, Button, x16 y11 w130 h30 gInstall, 安装(Install)
Gui, Add, Button, x16 y61 w130 h30 gUnInstall, 卸载(Uninstall)
Gui, Show, x319 y138 h109 w166, O
Return

GuiClose:
ExitApp

Install:
If A_IsCompiled
	command = `"%A_ScriptFullPath%`" `"`%1`"
Else
	command = `"%A_AhkPath%`" `"%A_ScriptFullPath%`" `"`%1`"
RegWrite,REG_SZ,HKCR,lnkfile\shell\OpenFolder,, 打开目录
RegWrite,REG_SZ,HKCR,lnkfile\shell\OpenFolder\Command,,%command%
Return

UnInstall:
RegDelete,HKCR,lnkfile\shell
return