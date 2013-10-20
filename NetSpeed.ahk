;
; AHK版本: 		L:1.1.3.0
; 语言:			中文/English
; 平台:			Win7
; 作者:			海盗 <healthlolicon@gmail.com>
; 脚本类型:		软件
; 功能:			WIN7可用的实时流量监控
; 参考:			http://msdn.microsoft.com/en-us/library/aa394216%28v=VS.85%29.aspx
;				http://msdn.microsoft.com/en-us/library/aa394340%28v=VS.85%29.aspx
;				http://ahk.5d6d.com/forum-43-1.html
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

Gui, Add, Text, x12 y10  , 网卡:%Name%
Gui, Add, Text, x12 y30  , MAC地址:%Mac%
Gui, Add, Text, x12 y50 w80  , 下载速度:
Gui, Add, Text, x102 y50 w100  vSpeed_Received,%Speed_Received%
Gui, Add, Text, x212 y50 w100   , KB/S
Gui, Add, Text, x12 y70 w80 h30 , 上传速度:
Gui, Add, Text, x102 y70 w100   vSpeed_Sent,%Speed_Sent%
Gui, Add, Text, x212 y70 w100   , KB/S
Gui, Show,  w326, 流量监控
Time_1 := A_TickCount
BytesReceivedNew=0
BytesSentNew=0
SetTimer,Speed,1000
Return

Speed:
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
Gosub,Refresh
Return

Refresh:
GuiControl,,Speed_Sent,%Speed_Sent%
GuiControl,,Speed_Received,%Speed_Received%
Return

GuiClose:
ExitApp