;
; AHK版本: 		B:1.0.48.5 L:1.0.92.0
; 语言:			中文/English
; 平台:			Win7
; 作者:			海盗 <healthlolicon@gmail.com>
;
;
;
;

#NoEnv
#NoTrayIcon
SendMode Input
SetWorkingDir %A_ScriptDir%  ;
#Include CodeXchange.ahk
#include Link.ahk


;#Default
XL_ERROR_FAIL=0x10000000
XL_ERROR_FILE_DONT_EXIST:=XL_ERROR_FAIL+17		;文件不存在
XL_ERROR_UNSPORTED_PROTOCOL:=XL_ERROR_FAIL+2	;不支持的协议


Status=下载未开始
Percent=0
Gui, Add, Text, x12 y20 w310 h30 , 下载测试：迅雷客户端（17.4M）
Gui, Add, Text, x12 y20 w310 h30 vStatusText, 状态：%Status%
Gui, Add, Progress, x12 y90 w300 h30 vMyProgress, 0
Gui, Add, Text, x313 y98 w25 h30 vPercentText, %Percent%`%
Gui, Add, Button, x342 y20 w60 h30 gDownLoad, 下载
Gui, Add, Button, x412 y90 w60 h30 gStop, 取消
Gui, Add, Button, x412 y20 w60 h30 gPause, 暂停
Gui, Add, Button, x342 y90 w60 h30 gContinue, 恢复
Gui, Add, Button, x342 y140 w130 h30 gDownload_form_tdfile, 导入未完成的下载
Gui, Add, Text, x12 y140 w170 h20 vSpeed, 下载速度:0 kb/s
Gui,show,,迅雷SDK测试
trayicon("AutoHotKey.exe",0)
Return

OnExit:
GuiClose:
trayicon("AutoHotKey.exe",1)
if hMoule!=0
	Gosub,Stop
ExitApp

DownLoad:
;加载dll
hModule := DllCall("LoadLibrary", "str", "XLDownload.dll")
DllCall("XLDownload\XLInitDownloadEngine")
;;隐藏迅雷托盘图标
Sleep,1000
trayicon("AutoHotKey.exe",0)
;下载
sUrl:=thunder_url_encode("http://down.sandai.net/thunder7/Thunder7.1.6.2194.exe")
;;专有链接转换
IfInString,sUrl,thunder://
	sUrl:=thunder_url_decode(surl)
Else IfInString,sUrl,flashget://
	sUrl:=flashget_url_decode(surl)
Else IfInString,surl,qqdl://
	surl:=qqdl_url_decode(surl)

sfile=C:\Users\Robin\Desktop\XL.exe
Ansi2Unicode(sUrl, url, 0)
Ansi2Unicode(sFile, File, 0)

DllCall("XLDownload\XLURLDownloadToFile","str",file,"str",URL,"Str",0,"intP",TaskID)
Time_1:=A_TickCount
Download_New=0
SetTimer,Query,1000
Return

;;;从td文件载入未完成的下载
Download_form_tdfile:
FileSelectFile,sTdfile,1,%A_ScriptDir%,,迅雷临时数据文件(*.td)
;加载dll
hModule := DllCall("LoadLibrary", "str", "XLDownload.dll")
DllCall("XLDownload\XLInitDownloadEngine")
;;隐藏迅雷托盘图标
Sleep,1000
trayicon("AutoHotKey.exe",0)

Ansi2Unicode(sTdfile,Tdfile, 0)
rtn:=DllCall("XLDownload\XLContinueTaskFromTdFile","str",tdfile,"intP",TaskID)
if (rtn=XL_ERROR_FILE_DONT_EXIST)
{
	Gosub,stop
	MsgBox,对应的cfg文件缺失
	Return
}
Else if (rtn=XL_ERROR_UNSPORTED_PROTOCOL)
{
	Gosub,stop
	MsgBox,SDK版本太低或未安装迅雷
	Return
}
Else if rtn<>0
	Return
Time_1:=A_TickCount
Download_New=0
SetTimer,Query,2000
;下载
Return


;查询进度
Query:
retn:=DllCall("XLDownload\XLQueryTaskInfo","int",TaskID,"intP",TaskStatus,"Uint64P",FileSize,"Uint64P",RecvSize)
if retn=0
{
	if TaskStatus=0
		Status=已经建立连接
	Else if TaskStatus=2
		Status=开始下载
	Else if TaskStatus=10
		Status=暂停
	Else if TaskStatus=11
	{
		SetTimer,Query,off
		Status=成功下载
		GuiControl,,StatusText,状态：%Status%
		Goto,Stop
		}
	Else if TaskStatus=12
		Status=下载失败
	Else
		Status=未知
	}
GuiControl,,StatusText,状态：%Status%
Download_Old:=Download_New
Download_New:=RecvSize
Time_2:=A_TickCount
Speed:=(Download_New-Download_Old)/(Time_2-Time_1)/1024*1000
Time_1:=Time_2
Percent:=RecvSize*100//FileSize
GuiControl,,Speed,%Speed% KB/s
GuiControl,,PercentText,%Percent%`%
GuiControl,,MyProgress,%Percent%
Return

;暂停
Pause:
DllCall("XLDownload\XLPauseTask","int",TaskID,"IntP",NewTaskID)
TaskID:=NewTaskID
Return

;恢复
Continue:
SetTimer,Query,1000
DllCall("XLDownload\XLContinueTask","int",TaskID)
Return

;取消
Stop:
SetTimer,Query,off
GuiControl,,StatusText,状态：取消下载
GuiControl,,PercentText,0`%
GuiControl,,MyProgress,0
DllCall("XLDownload\XLStopTask","int",TaskID)
DllCall("XLDownload\XLUninitDownloadEngine")
DllCall("FreeLibrary", "UInt", hModule)
Return
