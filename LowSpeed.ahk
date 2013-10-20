;低流量自动关机
;
;
;参考信息：
;简单的实时网络流量显示——by wz520
;http://ahk.5d6d.com/viewthread.php?tid=2780
;

#Persistent
#NoEnv

; 简单的实时网络流量显示


;设置
dwIndex:=2
Times:=0
Speed=10
Time=10
;设置结束

sizeofIFROW=860
VarSetCapacity(ifrow, sizeofIFROW, 0)
VarSetCapacity(bdescr, 256, 0) ;网络连接的说明信息
NumPut(dwIndex, ifrow, 512)

pGetIfEntry:=DllCall("GetProcAddress", uint
		, hModule := DllCall("LoadLibrary", str, "Iphlpapi")
		, str, "GetIfEntry") ;获取函数地址提高性能
if(!pGetIfEntry)
{
	MsgBox, 获取 Iphlpapi.dll\GetIfEntry 函数地址失败
	ExitApp, 1
}

OnExit, FreeDll

OlddwInOctets=0
OlddwOutOctets=0
DownSpeed=0
UpSpeed=0

switch=0
menu,tray,NoStandard
menu,tray,add,设置,setting
menu,tray,default,设置
menu,tray,add,开始,switch
menu,tray,add,退出,exit
menu,tray,tip,低流量自动关机
SetWorkingDir %A_ScriptDir%
Gui:
Gui=1
Gui, Add, Text, x6 y10 w50 h20 , 网速低于
Gui, Add, Edit,x66 y10 w50 h20 gS,
gui, add, UpDown,Range0-65535 vSpeed,%Speed%
Gui, Add, Text, x126 y10 w40 h20 , (KB/s)
Gui, Add, Text, x6 y40 w50 h20 , 并持续
Gui, Add, Edit, x66 y40 w50 h20 gT,
gui, add, UpDown,Range0-240 vTime,%Time%
Gui, Add, Text, x126 y40 w40 h20 , (Min)
Gui, Add, CheckBox, x6 y70 w170 h20 gRun vRun, 开机启动
Gui,+ToolWindow
Gui, Show, w195, 低流量自动关机
Return

GuiClose:
Gui,destroy
Gui=0
Return
exit:
ExitApp

Run:
GuiControlGet,Run
if Run
	RegWrite,REG_SZ,HKCU,Software\Microsoft\Windows\CurrentVersion\Run,低流量自动关机,%A_ScriptFullPath%
Else
	RegDelete,HKCU,Software\Microsoft\Windows\CurrentVersion\Run,低流量自动关机
Return

setting:
if Gui=0
	Gosub,gui
Return

S:
GuiControlGet,Speed
Return
T:
GuiControlGet,Time
Return

switch:
menu,tray,ToggleCheck,开始
if switch=0
	SetTimer, SpeedCheck, 1000
Else
	SetTimer, SpeedCheck, off
switch:=!switch
return

SpeedCheck:
Gosub,watchNetSpeed
SetFormat, float, 0.2
SpeedNow:=DownSpeed/1024
menu,tray,tip,低流量自动关机`n当前速度：%SpeedNow% KB/s
if (Time=0 && Speed=0)
	Return
if SpeedNow<Speed
{
	Times++
	If Times=1
		FirstTime:=A_Now
	Else
	{
			last:=A_Now
			EnvSub, last, %FirstTime%,Minutes
			if last>=%Time%
				Shutdown, 8
;~ 				MsgBox,关机
	}
}
Else
	Times=0
Return

watchNetSpeed:
	errcode:=DllCall(pGetIfEntry, uint, &ifrow, uint)
	if(errcode!=0)
	{
		SetTimer, watchNetSpeed, Off
		MsgBox, % GetErrorMessage(errcode)
		ExitApp, errcode
	}
	dwInOctets:=NumGet(ifrow,552) ;已接收字节
	dwOutOctets:=NumGet(ifrow,576) ;已发送字节
	if(OlddwInOctets=0 && OlddwOutOctets=0) ;为了检测是否第一次运行此Timer
	{
		;获取网络接口的说明信息。
		;貌似AHK不能直接 地址+偏移量 获得字符串，所以用了个C函数。
		DllCall( "MSVCRT\strcpy", str, bDescr, uint, (&ifrow)+604 )
	}
	else
	{
		DownSpeed:=dwInOctets-OlddwInOctets
		UpSpeed:=dwOutOctets-OlddwOutOctets
;~ 		ToolTip,
;~ 		(LTrim
;~ 			网络连接：%bDescr%
;~ 			已接收数据：%dwInOctets% 字节
;~ 			已发送数据：%dwOutOctets% 字节
;~ 			下载速度：%DownSpeed% 字节/秒
;~ 			上传速度：%UpSpeed% 字节/秒
;~ 		)
	}
	OlddwInOctets:=dwInOctets
	OlddwOutOctets:=dwOutOctets
	return

FreeDll:
	DllCall("FreeLibrary", uint, hModule)
	ExitApp

;根据错误码返回错误信息。
GetErrorMessage(ErrorCode)
{
  VarSetCapacity(ErrorMsg, 256, 0)

  ;#define FORMAT_MESSAGE_FROM_SYSTEM     0x00001000
  DLLCall("FormatMessage","UInt",0x1000
    ,"UInt",0,"UInt",ErrorCode,"UInt",0,"Str"
    ,ErrorMsg,"Uint", 256, "UInt", 0)

  StringReplace, ErrorMsg, ErrorMsg, `r`n, , All ;删除换行

  return ErrorMsg
}
