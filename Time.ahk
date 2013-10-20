;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AHK版本：		1.0.48.5
; 语言：		中文
; 适用平台：	WinXp/NT
; 作者：		海盗 <healthlolicon@gmail.com>
; 脚本类型：	Unix时间戳←→传统时间
; 脚本功能：
;
; 已知缺陷：
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Time_unix2human(time)
{
	human=19700101000000
	time-=((A_NowUTC-A_Now)//10000)*3600	;时差
	human+=%time%,Seconds
	return human
	}
Time_human2unix(time)
{
	time-=19700101000000,Seconds
	time+=((A_NowUTC-A_Now)//10000)*3600	;时差
	return time
	}