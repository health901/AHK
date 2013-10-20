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


objWMIService :=ComObjGet("winmgmts:\\.\root\cimv2")
;获取网卡信息
colNetAdapter:= objWMIService.ExecQuery("Select * from Win32_NetworkAdapter where NetEnabled=true")
for objNetAdapter in colNetAdapter
{
	Name:=objNetAdapter.Name
	Mac:=objNetAdapter.MACAddress
}

StringReplace,Name_,Name,#,_,all
StringReplace,Name_,Name_,(,[,all
StringReplace,Name_,Name_,),],all
WQL:="Select * from Win32_PerfRawData_Tcpip_NetworkInterface where Name='" . Name_ . "'"

;~ OlddwInOctets=0
;~ OlddwOutOctets=0
;~ DownSpeed=0
;~ UpSpeed=0
Time_1 := A_TickCount
BytesReceivedNew=0
BytesSentNew=0

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
Else
	WinActivate,低流量自动关机
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
{
	SetTimer, SpeedCheck, off
	menu,tray,tip,低流量自动关机
	}
switch:=!switch
return

SpeedCheck:
Critical
Gosub,NetSpeed
menu,tray,tip,低流量自动关机`n当前速度：%Speed_Received% KB/s
if (Time=0 && Speed=0)
	Return
if (Speed_Received<Speed)
{
	Times++
	If Times=1
		FirstTime:=A_Now
	Else
	{
			last:=A_Now
			EnvSub, last, %FirstTime%,Minutes
			TrayTip,,低于%Speed%kb/s`n持续了 %last%分钟
			if (last>=Time)
				Shutdown,12
	}
}
Else
{
	TrayTip
	Times=0
}
Return

NetSpeed:
;获取流量信息
colPerfRawData:= objWMIService.ExecQuery(WQL)
for objPerfRawData in colPerfRawData
{
	BytesReceivedOld:=BytesReceivedNew
	BytesReceivedNew:=objPerfRawData.BytesReceivedPerSec
	BytesSentOld:=BytesSentNew
	BytesSentNew:=objPerfRawData.BytesSentPerSec
}
Time_2 := A_TickCount
Speed_Received:=(BytesReceivedNew-BytesReceivedOld)/(Time_2-Time_1)/1024*1000
Speed_Sent:=(BytesSentNew-BytesSentOld)/(Time_2-Time_1)/1024*1000
Time_1:=Time_2
Return
