;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AHK版本:		1.0.48.5
; 语言:			中文
; 适用平台:		WinXp/NT
; 作者:			海盗 <healthlolicon@gmail.com>
; 脚本类型:		应用程序
; 脚本功能:		快速打开光标高亮的文件夹路径，文件，链接以及注册表
; 参考:			AHK 快餐店\8.快速进入注册表.ahk中定位注册表的方法
; 已知缺陷:		只能识别Http，ftp，及www开头的Url
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
Menu, Tray, NoStandard
Menu, Tray, Add, 退出


^q::
ClipboardOld :=Clipboard
Clipboard =
send ^c
clipwait
If ErrorLevel
    return
Path :=Clipboard
Clipboard :=ClipboardOld
StringReplace, Path, Path, ＼,　\, All
StringRight, LastChar, Path, 1
if LastChar = \ || /
    StringTrimRight, Path, Path, 1

KeyWordPos :=RegExMatch(Path, "HKEY")									; 是否为注册表
If (KeyWordPos=1)
{
	RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, 我的电脑\%Path%
																		; 将Path写入注册表中表示最后打开位置的项
	WinClose, 注册表编辑器											; 关闭原来的注册表窗口,如果有的话
	Run, regedit
	}
Else																	; 使用If-Else优化过程，平均查找次数为2次
{
	KeyWordPos :=RegExMatch(Path, "(http:|ftp:|www)")				; 是否为链接
	If (KeyWordPos=1)
	{
		Path :=RegExReplace(Path, "[^a-zA-Z0-9:\.\?/\-_%]", "")
		Run, %Path%
		}
	Else
	{
		KeyWordPos :=RegExMatch(Path, "\w:")							; 查找盘符位置
		If (KeyWordPos=1)
		{
			Run, %Path%
			}
		}
	}
Return


退出:
ExitApp
Return