;
; AHK版本:		B:1.0.48.5
;				L:1.1.3.0
; 语言:			中文/English
; 平台:			Win7
; 作者:			海盗 <healthlolicon@gmail.com>
; 类型:
; 功能:			获取系统信息
;
;

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%  ;
;~ http://msdn.microsoft.com/en-us/library/windows/desktop/ms724958%28v=vs.85%29.aspx
VarSetCapacity(structSysInfo,36)
DllCall("GetNativeSystemInfo",Uint,&structSysInfo)
wProcessorArchitectur	:= Numget(structSysInfo,0,"Short")
wReserved				:= Numget(structSysInfo,2,"Short")
dwPageSize				:= Numget(structSysInfo,4)
/*
  LPVOID    lpMinimumApplicationAddress;		8-11
  LPVOID    lpMaximumApplicationAddress;		12-15
  DWORD_PTR dwActiveProcessorMask;				16-19
*/
dwNumberOfProcessors	:= Numget(structSysInfo,20)
dwProcessorType			:= Numget(structSysInfo,24)
dwAllocationGranularity	:= Numget(structSysInfo,28)			;虚拟内存空间的粒度(Windows都是65536)
wProcessorLevel			:= Numget(structSysInfo,32,"Short")
wProcessorRevision		:= Numget(structSysInfo,34,"Short")
;处理数据
ProcessorArchitectur := wProcessorArchitectur=0 ? "32-bit (x86) System " : wProcessorArchitectur=9 ? "64-bit (x64 AMD or Intel)" : wProcessorArchitectur=6 ? "Intel Itanium-based" : "Unknown System"
SetFormat,integer,H
Model := wProcessorRevision >> 8
SetFormat,integer,d
Stepping := wProcessorRevision&0xFF
;
MsgBox,% "CPU体系结构: " ProcessorArchitectur "`n页大小: " dwPageSize " byte`nCPU数目: " dwNumberOfProcessors "`nCPU等级: " wProcessorLevel "`nCPU型号: " Model "`n步进: " Stepping