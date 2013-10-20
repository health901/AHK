#NoTrayIcon
#SingleInstance,Ignore
result:=DllCall("Wininet.dll\InternetGetConnectedState", Str,0x43, Int,0 )
if result
	Goto,Speed
Gosub,UserRead
Gui, Add, Text, x16 y21 w60 h20 , 宽带账号：
Gui, Add, Edit, x86 y21 w120 h20 vID, %ID%
Gui, Add, Text, x16 y61 w60 h20 , 宽带密码：
Gui, Add, Edit, x86 y61 w120 h20 Password vPassword ,
Gui, Add, CheckBox, x16 y91 w140 h20 vRemeber, 记住密码
Gui, Add, Button, x46 y121 w100 h30 gDial, 拨号
Gui, Show,h165 w217, 宽带连接
if remeber
{
	GuiControl,,Remeber,1
	GuiControl,,Password,%password%
	}
Return

GuiClose:
ExitApp



Dial:
GuiControlGet,ID
GuiControlGet,Password
GuiControlGet,Remeber
Gosub,UserWrite
Gosub,SettingRead
Runwait,%ComSpec% /c "RASDIAL %AdslName% %ID% %Password% >%A_Temp%\New.adsl",,hide,PID
FileRead,Message,%A_Temp%\New.adsl
SplashTextOn,250,120,拨号中...,%Message%
Sleep,1000
Process,Exist,PID
if errorlevel=0
{
	SplashTextOff
	FileDelete,%A_Temp%\New.adsl
	Gui,1:destroy
	Sleep,5000
	SendMail(email_form,email_password,email_server,email_to)
	ExitApp
	}
Return


UserRead:
RegRead,ID,HKLM,Software\AutoAdsl,ID
if errorlevel
	Return
RegRead,Password,HKLM,Software\AutoAdsl,Password
RegRead,remeber,HKLM,Software\AutoAdsl,remeber
Return

UserWrite:
RegWrite,REG_SZ,HKLM,Software\AutoAdsl,ID,%ID%
RegWrite,REG_SZ,HKLM,Software\AutoAdsl,Password,%Password%
RegWrite,REG_SZ,HKLM,Software\AutoAdsl,remeber,%remeber%
Return

SettingRead:
RegRead,AdslName,HKLM,Software\AutoAdsl,AdslName
RegRead,email_form,HKLM,Software\AutoAdsl,email_form
RegRead,email_password,HKLM,Software\AutoAdsl,email_password
RegRead,email_server,HKLM,Software\AutoAdsl,email_server
RegRead,email_to,HKLM,Software\AutoAdsl,email_to
Return

Speed:
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

Gui, 2:Add, GroupBox, x6 y11 w210 h90 , 总流量
Gui, 2:Add, GroupBox, x6 y111 w210 h90 , 当前速率
Gui, 2:Add, Text, x16 y31 w190 vSend, 已发送:0(字节)
Gui, 2:Add, Text, x16 y61 w190  vReceive, 已接收:0(字节)
Gui, 2:Add, Text, x16 y141 w190 vUpload, 上传:0(KB/S)
Gui, 2:Add, Text, x16 y171 w184  vDownload, 下载:0(KB/S)
Gui, 2:Show,h227 w226, 网络活动状态
Gosub,reflesh
SetTimer,reflesh,1000
Return

2Guiclose:
ExitApp
Return

reflesh:
Gosub,watchNetSpeed
SetFormat, float, 0.2
DownSpeedK:=DownSpeed/1024
UpSpeedK:=UpSpeed/1024
Guicontrol,2:,Send,已发送:%dwOutOctets%(字节)
Guicontrol,2:,receive,已接受:%dwinOctets%(字节)
Guicontrol,2:,Upload,上传:%UpSpeedK%(KB/S)
Guicontrol,2:,Download,下载:%DownSpeedK%(KB/S)
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

SendMail(from,pass,server,to)
{
	StringSplit,Server_,server,:
	RunWait,%comspec% /c "ipconfig >%A_Temp%\ipconfig.adsl",,Hide
	FileRead,IpAll,%A_Temp%\ipconfig.adsl
	FileDelete,%A_Temp%\ipconfig.adsl
	Pos:=RegExMatch(IPALL,"IP Address",ip)
	Pos++
	Pos:=RegExMatch(IPALL,"IP Address",ip,pos)
	Pos++
	ip=
	RegExMatch(IPALL,"(\d{1,3}\.){3}\d{1,3}",ip,pos)
	IPfile:=chrandom(8)
	FileAppend,%IP%,%A_temp%\%IPfile%.txt
	runwait,%comspec% /c "blat -install %Server_1% %form% AutoSend %Server_2%", ,Hide
	runwait,%comspec% /c "blat %A_temp%\%IPfile%.txt -to %to%  -s "IP" -u %from% -pw %pass%", ,Hide
	FileDelete,%A_temp%\%IPfile%.txt
;~ 	String = -t %to% -s IP地址 -body %IP% -base64 -f %from% -server %server% -u %from% -p %pass%
;~ 	message:=DllCall("blat.dll\Send", "Str", String)
;~ 	return message
	}