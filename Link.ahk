;
; AHK版本: 		B:1.0.48.5
;				L:1.1.3.0
; 语言:			中文/English
; 平台:			Win7
; 作者:			海盗 <healthlolicon@gmail.com>
;
;
;
;

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%  ;
;////////////////////////////////////////////////////////
;~ url_endode:=Thunder_Url_Encode("http://www.z.com/1.zip")
;~ String:="原始链接: http://www.z.com/1.zip`n迅雷链接: " . url_endode
;~ url:=Thunder_Url_Decode("asdasdasdasd")
;~ if ErrorLevel
;~ 	String.="`nurl1迅雷链接不正确"
;~ Url:=Thunder_Url_Decode("thunder://asdasdasdasd")
;~ if ErrorLevel
;~ 	String.="`nurl2迅雷链接不正确"
MsgBox,% Thunder_Url_Decode("thunder://QUFodHRwOi8vY25jLXRodW5kZXIuZ29vZC5nZC8/RmlsZUlkPTIwNTI5NjMmb249Mi50eHQmY249NmQwNDJhYWItYjg2Ni00Mjg3LTg3MjgtNDg4MzQ2OGVmMjA5JnV0PTIwMTItNS03KzAlM2ExMSUzYTAwWlo=")
;~ if ErrorLevel
;~ 	String.="`nurl3迅雷链接不正确"
;~ Else
;~ 	String.="`nurl3: " . url
;~ MsgBox,% String

;~ MsgBox,% qqdl_url_decode("qqdl://aHR0cDovL3d3dy5mb3JlY2UubmV0L3dpbjcucmFy")
;~ MsgBox,% base64_encode("<?php phpinfo();?>")
;;;;迅雷专用链接;;;;;;;;
Thunder_Url_Encode(sUrl)
{
	Return,"thunder://" . base64_Encode("AA" . sUrl . "ZZ")
}
Thunder_Url_Decode(sThunder_url)
{
	StringLeft,sUrl_head,sThunder_url,10
	if (sUrl_head<>"thunder://")
	{
		ErrorLevel=1
		Return
	}
	StringTrimLeft,sThunder_url,sThunder_url,10
	sUrl_decoded:=base64_decode(sThunder_url)
	StringLeft,sUrl_A,sUrl_decoded,2
	StringRight,sUrl_Z,sUrl_decoded,2
	if (sUrl_A<>"AA" && sUrl_Z<>"ZZ")
	{
		ErrorLevel=1
		Return
	}
	StringTrimLeft,sUrl,sUrl_decoded,2
	StringTrimRight,sUrl,sUrl,2
	Return,sUrl
}

;;;;快车专用链接;;;;;;;;
flashget_url_Encode(sUrl)
{
	Return,"flashget://" . base64_Encode("[FLASHGET]" . sUrl . "[FLASHGET]") . "&health901"
	}
flashget_Url_Decode(sflashget_url)
{
	IfNotInString,sflashget_url,&
	{
		ErrorLevel=1
		Return
	}
	sflashget_url:=RegExReplace(sflashget_url,"&.*","")
	StringLeft,sUrl_head,sflashget_url,11
	if (sUrl_head<>"flashget://")
	{
		ErrorLevel=1
		Return
	}
	StringTrimLeft,sflashget_url,sflashget_url,11
	sUrl_decoded:=base64_decode(sflashget_url)
	StringLeft,sUrl_1,sUrl_decoded,10
	StringRight,sUrl_2,sUrl_decoded,10
	if (sUrl_1<>"[FLASHGET]" && sUrl_2<>"[FLASHGET]")
	{
		ErrorLevel=1
		Return
	}
	StringTrimLeft,sUrl,sUrl_decoded,10
	StringTrimRight,sUrl,sUrl,10
	Return,sUrl
}
;;;;QQ旋风专用链接;;;;;;
qqdl_url_Encode(sUrl)
{
	Return,"qqdl://" . base64_Encode(sUrl)
	}
qqdl_Url_Decode(sqqdl_url)
{
	StringLeft,sUrl_head,sqqdl_url,7
	if (sUrl_head<>"qqdl://")
	{
		ErrorLevel=1
		Return
	}
	StringTrimLeft,sqqdl_url,sqqdl_url,7
	Return,base64_decode(sqqdl_url)
}
;;;;RayFile专用链接;;;;;
fs2_Url_Decode(sfs2_url)
{
	StringLeft,sUrl_head,sfs2_url,9
	if (sUrl_head<>"fs2you://")
	{
		ErrorLevel=1
		Return
	}
	StringTrimLeft,sfs2_url,sfs2_url,9
	tmp:=base64_decode(sfs2_url)
	rtn:="http://" . RegExReplace(tmp,"\|\d+$","")
	return,rtn
	}