#NoTrayIcon
FileInstall,moe.jpg,%A_temp%\sayori.jpg,1
run,%A_temp%\sayori.jpg
InputBox,v,你完了,输入“我是猪”`n否则重启!,,150,150
If v=我是猪
	ExitApp
Else
{
	IfInString,v,你是猪
	{
	SetTimer,shutdown,5000
	MsgBox,48,TMD,丫活得不耐烦了？
	IfMsgBox, Ok
		Gosub,shutdown
	}
	Else
	{
		SetTimer,reboot,5000
		MsgBox,32,小样,不老老实听话？？
		IfMsgBox, Ok
			Gosub, reboot
	}
}
Return

shutdown:
;~ Shutdown,13
Return

reboot:
;~ Shutdown,6
Return
