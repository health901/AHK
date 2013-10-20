;
; AHK版本: 		L:1.1.3.0
; 语言:			中文/English
; 平台:			Win7
; 作者:			海盗 <healthlolicon@gmail.com>
; 类型:			程序
; 功能:
; 缺陷:			无法恢复一个程序内的多个窗口(比如SciTe打开多个脚本 只能恢复1个) 无法恢复WIN7库文件夹 无法恢复浏览器内页面
; 参考:			GoneIn60s:http://www.donationcoder.com/Software/Skrommel/#GoneIn60s
;				http://ahk.5d6d.com/thread-4597-1-1.html
;

#NoEnv
#SingleInstance Ignore
SendMode Input
SetWorkingDir %A_ScriptDir%  ;
CoordMode,Mouse,Screen
FileDelete,ReOpen.dat

Gosub,iniread

Menu,tray, NoStandard
Menu,tray,add,关于(&A),about
Menu,tray,add,
Menu,tray,add,恢复(&R),ReOpen
Menu,tray,add,设置(&S),setting
Menu,tray,add,退出(&E),Exit
Menu,tray,Disable,恢复(&R)

SysGet,SM_CYCAPTION,4
SysGet,SM_CXBORDER,5
SysGet,SM_CYBORDER,6
SysGet,SM_CXEDGE,45
SysGet,SM_CYEDGE,46
SysGet,SM_CXFIXEDFRAME,7
SysGet,SM_CYFIXEDFRAME,8
SysGet,SM_CXSIZEFRAME,32
SysGet,SM_CYSIZEFRAME,33
SysGet,SM_CXSIZE,30
SysGet,SM_CYSIZE,31

Count=0					;初始化关闭的窗口数


Loop
{
	Sleep,100
	MouseGetPos,mx,my,win
	WinGetPos,x,y,w,h,ahk_id %win%
	l:=x+w-SM_CXSIZEFRAME-SM_CXSIZE
	t:=y ;+SM_CYSIZEFRAME
	r:=x+w-SM_CXSIZEFRAME
	b:=y+SM_CYSIZE ;+SM_CYSIZEFRAME
	If (mx<l Or mx>r Or my<t Or my>b)
	{
		Hotkey,LButton,CLICK,Off
		ToolTip
		}
	Else
	{
		WinGet,program,ProcessName,ahk_id %win%
		if Checkbox_Process
			IfInString,ignore_process,%Program%
				Continue
		if (Program<>"explorer.exe" && Checkbox_exceptdir=1)
			Continue
		WinGetClass,class,ahk_id %win%
		Hotkey,LButton,CLICK,On
		ToolTip,范围内
	}
}
Return

Click:
WinGet,program,ProcessName,ahk_id %win%
if (program="explorer.exe" || program="iexplore.exe")  ;
{
	String:=GetForegroundWindowPath()
	if Checkbox_dir
		loop,parse,ignore_dir,;
			if (String=A_LoopField)
				String=
	}
Else
{
	WinGet,PID,PID,ahk_id %win%
	String:=GetCommandLine(PID)
}
if !strlen(String)
	Return
StringReplace,String,String,`",```",all
Count:=Save(Count,String)
if Count
	Menu,tray,Enable,恢复(&R)
Sleep,100
WinClose,ahk_id %win%
Return

!r::
ReOpen:
if !Count
	Return
Count:=Load(Count,outWinInfo)
IfInString,outWinInfo,`"
	Run,%outWinInfo%
Else
	Run,"%outWinInfo%"
if !Count
	Menu,tray,Disable,恢复(&R)
Return

Setting:
Gosub,iniread
Gui, Add, CheckBox, x15 y20  h30 gignore vCheckbox_exceptdir, 只恢复文件夹
Gui, Add, CheckBox, x15 y50  h20 vCheckbox_Process, 忽略以下进程(以回车或;分隔)
Gui, Add, Edit, x15 y90 w320 h150 vEdit_process,%ignore_process%
Gui, Add, CheckBox, x15 y250 h20 vCheckbox_Dir, 忽略以下文件夹(以回车或;分隔)
Gui, Add, Edit, x15 y280 w320 h150 vEdit_Dir,%ignore_dir%
Gui, Show, x125 y87 h450 w350, 设置
GuiControl,,Checkbox_exceptdir,%Checkbox_exceptdir%
GuiControl,,Checkbox_Process,%Checkbox_Process%
GuiControl,,Checkbox_dir,%Checkbox_dir%
Gosub,ignore
Return

GuiClose:
Gui,submit
Gui,destroy
Gosub,iniwrite
Return

IniRead:
IniRead,Checkbox_exceptdir,ReOpen.ini,Switch,Checkbox_exceptdir,0
IniRead,Checkbox_process,ReOpen.ini,Switch,Checkbox_proecess,1
IniRead,Checkbox_dir,ReOpen.ini,Switch,Checkbox_dir,1
IniRead,ignore_process,ReOpen.ini,Ignore,ignore_process,Autohotkey.exe;Autohotkey_Lw.exe;ReOpen.exe;
IniRead,ignore_dir,ReOpen.ini,Ignore,ignore_dir,C:/Users/Robin/Desktop;
Return

IniWrite:
IniWrite,%Checkbox_exceptdir%,ReOpen.ini,Switch,Checkbox_exceptdir
IniWrite,%Checkbox_process%,ReOpen.ini,Switch,Checkbox_process
IniWrite,%Checkbox_dir%,ReOpen.ini,Switch,Checkbox_dir
StringReplace,Edit_process,Edit_process,`r`n,;,all
StringReplace,Edit_process,Edit_process,`n,;,all
StringReplace,Edit_Dir,Edit_Dir,`r`n,;,all
StringReplace,Edit_Dir,Edit_Dir,`n,;,all
if (Strlen(Edit_process)>1 && Substr(Edit_process,0,1)<>";")
	Edit_process.=";"
if (Strlen(Edit_Dir)>1 && Substr(Edit_Dir,0,1)<>";")
	Edit_Dir.=";"
IniWrite,%Edit_process%,ReOpen.ini,Ignore,ignore_process
IniWrite,%Edit_dir%,ReOpen.ini,Ignore,ignore_dir
Gosub,iniread
Return


Ignore:
GuiControlGet,Checkbox_exceptdir
If Checkbox_exceptdir
{
	GuiControl,,Checkbox_Process,0
	GuiControl, Disable,Checkbox_Process
	GuiControl, Disable,Edit_Process
}
Else
{
	GuiControl, enable,Checkbox_Process
	GuiControl, enable,Edit_Process
	}
Return

About:
Gui, 2:Add, Text, ,联系作者：
Gui, 2:Font, underline
Gui, 2:Add, Text, ym cRed vHyperlink_mail gSendMail, healthlolicon@gmail.com
Gui, 2:Font, norm
Gui, 2:Add, Text, xm section,访问网站：
Gui, 2:Font, underline
Gui, 2:Add, Text, ys cBlue  vHyperlink_website gLaunchwebsite, www.autohotkey.net/~health901/
Gui, 2:Font, norm
Gui, 2:Add, Text,xm ,海盗<heath901@AHK>
Gui, 2:Add, Button, w50 xp+200 yp-5 Default, OK
hCursor:=DllCall("LoadCursor",UInt,0,UInt,32649)
onMessage(0x200,"WM_MOUSEMOVE")
Gui, 2:Show,,关于
return

2ButtonOK:
2GuiClose:
2GuiEscape:
Gui, 2:Destroy
Return

Launchwebsite:
RegRead,Browser,HKCR,http\shell\open\command
RegExMatch(Browser,"(?<="").+?(?="")",Browser)
Run,%Browser% http://www.autohotkey.net/~health901/
Return

SendMail:
Run mailto:healthlolicon@gmail.com
Return


Exit:
FileDelete,ReOpen.dat
ExitApp
Return

WM_MOUSEMOVE()
{
	IfInString,A_GuiControl,Hyperlink
	{
		global hCursor
		DllCall("SetCursor",UInt,hCursor)
	}
}

GetCommandLine(PID)				;获取进程路径
{
	objDataFiles :=ComObjGet("winmgmts:\\.\root\cimv2")
	colFiles := objDataFiles.execQuery("Select * from Win32_Process")
	For k In colFiles
		if (k.ProcessId=PID)
			return,k.commandline
}

GetForegroundWindowPath()		;获取文件夹路径
{
	Critical
	Obj:=ComObjCreate("Shell.Application")
;~ 	objWindows:=obj.Windows
;~ 	Loop,% objWindows.count
	for objIE in obj.Windows
	{
;~ 		ObjIE:=objWindows.Item(A_Index-1)
		ForegroundWindow:=DllCall("GetForegroundWindow")
		If (InStr(objie.FullName, "explorer.exe") && (objie.hwnd=ForegroundWindow))
			return, RegExReplace(RegExReplace(UrlUnEscape(objie.LocationURL),"file:///",""),"/","\")
		Else if (InStr(objie.FullName, "iexplore.exe") && (objie.hwnd=ForegroundWindow))
			return, """iexplore.exe""" " " objie.LocationURL
	}
	ObjRelease(Object(obj))
}
Save(Number,InputVar)			;保存关闭的窗口
{
	Number++
	FileAppend,, ReOpen.dat, Cp0
	IniWrite,%InputVar%,ReOpen.dat,windows,win%Number%
	Return,Number
}
Load(Number,ByRef OutputVar)	;载入关闭的窗口
{
	IniRead,OutputVar,ReOpen.dat,windows,win%Number%
	IniDelete,ReOpen.dat,windows,win%Number%
	StringReplace,OutPutvar,outputvar,```",`",all
	Number--
	Return,Number
}
UrlUnEscape(url)				;URL字符串解码
{
   VarSetCapacity(newUrl,500,0),pcche:=500
   DllCall("shlwapi\UrlUnescapeW", Str,url, Str,newUrl, UIntP,pcche, UInt,0x10000000)
   Return newUrl
}