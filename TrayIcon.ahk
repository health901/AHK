;
; AHK版本:		Basic
; 语言:			中文/English
; 平台:			Win7 (x64)
; 作者:			海盗 <healthlolicon@gmail.com>
; 类型:			函数
; 功能:			隐藏托盘图标
; 缺陷:			同进程的图标 无法区分(可以通过线程来区分),且只隐藏检索到的第一个(可以通过修改循环改进)
; 参考:			http://blog.csdn.net/hailongchang/article/details/3454569
;				http://msdn.microsoft.com/en-us/library/bb760476%28v=vs.85%29.aspx
;				http://msdn.microsoft.com/en-us/library/bb787319%28v=vs.85%29.aspx
;				etc...


/*
e.g.:
TrayIcon("QQ.exe",0)		;隐藏QQ
TrayIcon(-1,0,"ID")			;隐藏所有托盘图标


ID_or_PN:参见Cmd
Show:设置1显示图标,设置0隐藏图标,默认1
Cmd
	PN:ID_or_PN参数为要隐藏的托盘图标所属进程名
	ID:ID_or_PN参数为图标ID,设置-1隐藏/显示所有图标
*/

#NoEnv
DetectHiddenWindows, On
TrayIcon(ID_or_PN,Show=1,Cmd="PN")
{
	;<commctrl.h>
	;#define	WM_USER			0x400
	;#define	TB_HIDEBUTTON	(WM_USER+4)		0x404
	;#define	TB_GETBUTTON	(WM_USER+23)	0x417
	;#define	TB_BUTTONCOUNT	(WM_USER+24)	0x418
	;#define 	TB_GETBUTTONTEXTA	(WM_USER+45)0X42D
	;#define 	TB_GETBUTTONTEXTW	(WM_USER+75)
	WM_USER=0x400
	TB_HIDEBUTTON:=WM_USER+4
	TB_GETBUTTON:=WM_USER+23
	TB_BUTTONCOUNT:=WM_USER+24
	TB_GETBUTTONTEXTA:=WM_USER+45
	TB_GETBUTTONTEXTW:=WM_USER+75

	;;获取Shell_TrayWnd->TrayNotifyWnd->SysPager->ToolbarWindow32(Spy++)的窗口句柄
	hwnd:=DllCall("FindWindow",Str,"Shell_TrayWnd",int,0)
	hwnd:=DllCall("FindWindowEx",Uint,hwnd,Uint,0,str,"TrayNotifyWnd",int,0)
	hwndSysPager:=DllCall("FindWindowEx",Uint,hwnd,Uint,0,str,"SysPager",int,0)
	if (!hwndSysPager)
		hwnd:=DllCall("FindWindowEx",Uint,hwnd,Uint,0,str,"ToolbarWindow32",int,0)
	Else
		hwnd:=DllCall("FindWindowEx",Uint,hwndSysPager,Uint,0,str,"ToolbarWindow32",int,0)

	ButtonCount:=DllCall("SendMessage",Uint,hwnd,Uint,TB_BUTTONCOUNT,int,0,int,0)

;~ 	MsgBox,当前有%ButtonCount%个托盘图标

	if Cmd=PN
	{
		;;获取ToolbarWindow32的进程ID
		;;rtn 线程ID
		;;PID 进程ID
		rtn:=DllCall("GetWindowThreadProcessId",Uint,hwnd,UintP,PID)
		;;打开进程,获取句柄
		hProcess:=DllCall("OpenProcess",Uint,0x0008|0x0010|0x0020,int,0,Uint,PID)
		;在进程内分配一段内存
		lngAddress:=DllCall("VirtualAllocEx",Uint,hProcess,Int,0,Uint,0x4096,Uint,0x1000,Uint,0x04)

		Found=0
		Loop,% ButtonCount
		{
;~ 			DllCall("SendMessage",Uint,hwnd,Uint,TB_GETBUTTON,Uint,A_index-1,Uint,lngAddress)		;无效,只能生成第一个图标的信息,不解
			SendMessage, TB_GETBUTTON, A_Index - 1,lngAddress,ToolbarWindow321, ahk_class Shell_TrayWnd
			VarSetCapacity(info, 24)
			VarSetCapacity(Text, 24)
			DllCall("ReadProcessMemory",Uint,hProcess,Uint,lngAddress,Uint,&Text,Int,24,int,0)
			iBitmap		:= NumGet(Text, 0)
			idCommand	:= NumGet(Text, 4)
			Tmp			:= NumGet(Text, 8)		;	BYTE      fsState;
											;	BYTE      fsStyle;
											;	BYTE      bReserved[6];
			dwData		:= NumGet(Text, 16)
			iString		:= NumGet(Text, 20)
			/*
			x86(32位)系统使用这段代替上段
			http://msdn.microsoft.com/en-us/library/bb760476%28v=vs.85%29.aspx

			VarSetCapacity(Text, 20)
			DllCall("ReadProcessMemory",Uint,hProcess,Uint,lngAddress,Uint,&Text,Int,20,int,0)
			iBitmap		:= NumGet(Text, 0)
			idCommand	:= NumGet(Text, 4)
			Tmp			:= NumGet(Text, 8)		;	BYTE      fsState;
											;	BYTE      fsStyle;
											;	BYTE      bReserved[2];
			dwData		:= NumGet(Text, 12)
			iString		:= NumGet(Text, 16)
			*/
			DllCall("ReadProcessMemory", "Uint", hProcess, "Uint", dwData, "Uint", &info, "Uint", 24, "Uint", 0)
			hWnd  := NumGet(info, 0)
			uID   := NumGet(info, 4)
			nMsg  := NumGet(info, 8)
			hIcon := NumGet(info, 20)
			;获取维护当前窗口句柄的进程PID
			rtn:=DllCall("GetWindowThreadProcessId",Uint,hwnd,UintP,PID)		;rtn保存线程信息,可供进一步的区分图标
			;获取进程名,DetectHiddenWindows, On 检测隐藏窗口
			WinGet,ImageName,ProcessName,ahk_pid %PID%
			if (ImageName = ID_or_PN)
			{
				Found=1		;Found!
;~ 			MsgBox,% idcommand . " " . ImageName
				Break
			}
		}
		if Found
		{
			if show
				SendMessage, TB_HIDEBUTTON,idCommand,0,ToolbarWindow321, ahk_class Shell_TrayWnd
			Else
				SendMessage, TB_HIDEBUTTON,idCommand,1,ToolbarWindow321, ahk_class Shell_TrayWnd
		}
		DllCall("VirtualFreeEx",Uint,hProcess,UInt,lngAddress,Uint,0x4096,Uint,0x8000)	;MEM_RELEASE=0x8000
		DllCall("CloseHandle",Uint,hProcess)
	}
	Else if Cmd=ID
	{
		if ID_or_PN = -1
			Loop,% ButtonCount
			{
				if show
					SendMessage, TB_HIDEBUTTON,A_index-1,0,ToolbarWindow321, ahk_class Shell_TrayWnd
				Else
					SendMessage, TB_HIDEBUTTON,A_index-1,1,ToolbarWindow321, ahk_class Shell_TrayWnd
			}
		Else
		{
			if show
				SendMessage, TB_HIDEBUTTON,ID_or_PN,0,ToolbarWindow321, ahk_class Shell_TrayWnd
			Else
				SendMessage, TB_HIDEBUTTON,ID_or_PN,1,ToolbarWindow321, ahk_class Shell_TrayWnd
		}
	}
}

