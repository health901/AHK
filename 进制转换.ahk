;~ a=111
b=902030302010100000
;~ c=0XAD0
d:=system(B,"D","H")
c:=system(d,"h","d")

MsgBox,% d . "`n" . c  . "`n" .  system(b,"D","B")

Bin(x){		;dec-bin
   while x
      r:=1&x r,x>>=1
   return r
}
Dec(x){		;bin-dec
   b:=StrLen(x),r:=0
   loop,parse,x
      r|=A_LoopField<<--b
   return r
}
Dec_Hex(x)		;dec-hex
{
SetFormat, IntegerFast, hex
he := x
he += 0
he .= ""
SetFormat, IntegerFast, d
Return,he
}
Hex_Dec(x)
{
SetFormat, IntegerFast, d
de := x
de := de + 0
Return,de

}

system(x,InPutType="D",OutPutType="H"){
	if InputType=B
	{
		IF OutPutType=D
			r:=Dec(x)
		IF OutPutType=H
		{
			x:=Dec(x)
			r:=Dec_Hex(x)
		}
	}
	If InputType=D
	{
		IF OutPutType=B
			r:=Bin(x)
		If OutPutType=H
			r:=Dec_Hex(x)
	}
	If InputType=H
	{
		IF OutPutType=B
		{
			x:=Hex_Dec(x)
			r:=Bin(x)
		}
		If OutPutType=D
			r:=Hex_Dec(x)
	}
	Return,r
}
