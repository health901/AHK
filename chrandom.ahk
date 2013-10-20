/*
函数功能：生成一个指定长度的随机字符串（字符仅包括0-9a-zA-Z）
语法：
string:=chrandom(Digit="12")
string：生成的随机字串
Digit：字串位数,若省略，默认生成12位字符串
*/
string:=chrandom(32)
MsgBox,% string


chrandom(Digit="16")
{
	loop,%Digit%
	{
		random,chrtype,1,3
		if chrtype=1
			random,chr,asc("0"),asc("9") ;48,57
		Else if chrtype=2
			random,chr,asc("A"),asc("Z") ;65,90
		Else
			random,chr,asc("a"),asc("z") ;97,122
		string:= string . chr(chr)
	}
	return string
}

/*
Next：
Type=1、2、4、8
3=2+1
5=4+1
7=4+2+1

count=1
loop
{
	Num%A_index%:=Mod(Num,2)
	is6:=Mod(Num,6)
	if Num%a_index%=0
	{
		Num%a_index%:=num
		break
	}
	num-=Num%a_index%
	if num=0
		break
	count++
}

1: num1=1
2: num1=2
3: num1=1,num2=2
4: num1=4
5: num1=1,num2=4
6: num1=6 × 。。。。。
7: num1=1,num2=6 ×
8: num1=8

Oh Fuck！
something wrong。。。。
*/