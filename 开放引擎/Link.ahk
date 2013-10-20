;
; AHK版本: 		B:1.0.48.5
;				L:1.1.3.0
; 语言:			中文/English
; 平台:			Win7
; 作者:			海盗 <healthlolicon@gmail.com>
; 类型:			函数
; 功能:			迅雷,快车,QQ旋风链接加密解密
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
;~ url:=Thunder_Url_Decode("thunder://QUFodHRwOi8vZG93bjIubmV3eXgubmV0L3ByaXNvbnR5Y29vbjIuZXhlWlo=")
;~ if ErrorLevel
;~ 	String.="`nurl3迅雷链接不正确"
;~ Else
;~ 	String.="`nurl3: " . url
;~ MsgBox,% String

;~ MsgBox,% qqdl_url_decode("qqdl://aHR0cDovL3d3dy5mb3JlY2UubmV0L3dpbjcucmFy")
Clipboard:=thunder_url_decode("thunder://QUFodHRwOi8vbmVwdHVuZS5jdGRpc2suY29tOjgwODYvY2FjaGUvZGlzazEvJTVCQmVhdXR5bGVnJTVESEQxMDRfTmFuYS53bXY/Y3RwPTEyNS4xMTIuOTAuMjIzJmN0dD0xMzMyMzMwMDY1JmN0cz0wJmN0az1lYTV1TDBqQzhKWmN3NjNPT3Rkbkx3JmNoaz0yZDU2ZjExYjdhODdhOTM3MWRjZGZlMjY1NDVhOTM4Mi04NDM3MjAzNjMmZmlsZW5hbWU9JTVCQmVhdXR5bGVnJTVESEQxMDRfTmFuYS53bXZaWg==")
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