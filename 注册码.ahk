
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AHK版本：		1.0.48.5
; 语言： 		中文
; 适用平台：	WinXp/NT
; 作者：   		海盗 <healthlolicon@gmail.com>
; 脚本类型：	软件
; 脚本功能：	软件保护，注册码、试用期限、次数演示
;
; 已知缺陷：
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SplitPath, A_WinDir,,,,,Root
Root:=Root . "\"
DriveGet,SerialNumber,Serial, %Root%  ;获取机器码
Serial:=MD5(SerialNumber,strlen(SerialNumber))  ;注册机！拷贝出去内联汇编就是一个keygen，所以破解难度都不大
;加密函数自己想办法，这里是示范，直接用一个MD5函数。
;高强度的加密可以在MD5基础上再进行操作，不要求能解密，注册只是一个验证机制，单向不可逆函数即可
RegRead,Times,HKCU,Software\MyProgram
If ErrorLevel
 Gosub,FirstTime
Else
 Gosub,Check
Return
FirstTime:
RegWrite,REG_DWORD,hkcu,Software\MyProgram,,3
Times=3
Goto,Check
Return
Check:
if Times<1
{
 MsgBox,0x40034,Error!,You Must Registe Now!`n前去注册？
 IfMsgBox,Yes
  Gosub,GuiRegister
 IfMsgBox,No
  Exitapp
 Return
  }
Else
{
 if Times=65535
  message=[注册版]
 Else
 {
  message:="[试用版-还可试用" . Times-1 "次]"
  Times--
  }
 RegWrite,REG_DWORD,hkcu,Software\MyProgram,,%Times%
 Goto,Gui
 }
Return
Gui:
Gui,add,Text,,Hello`,World!
Gui,Show,w500 h500,软件保护、注册演示 %message%
Gui,add,Button,x200 y200 w100 h100 gGuiRegister,注册
Return
GuiClose:
ExitApp
Return
GuiRegister:
Gui, 2:Add, Text, x16 y20 w60 h20 , 机器码：
Gui, 2:Add, Edit, x96 y20 w150 h20 Disabled, %SerialNumber%
Gui, 2:Add, Button, x256 y20 w80 h20 gCopy, 复制到剪切板
Gui, 2:Add, Text, x16 y50 w320 h30 , 复制机器码及订单号至邮箱XXX@XXX.COM获取注册码
Gui, 2:Add, Button, x106 y160 w130 h20 gReg, 注册
Gui, 2:Add, Text, x16 y90 w90 h20 , 输入注册码：
Gui, 2:Add, Edit, x16 y120 w70 h20 vE1 gE1,
Gui, 2:Add, Edit, x96 y120 w70 h20 vE2 gE2,
Gui, 2:Add, Edit, x176 y120 w70 h20 vE3 gE3,
Gui, 2:Add, Edit, x256 y120 w70 h20 vE4 gE4,
Gui, 2:Show, x248 y155 h195 w346, 注册
Return
2GuiClose:
Gui,2:Destroy
Return

Reg:
Code=
loop,4
{
GuiControlGet,E%A_index%
Code:=Code . E%a_index%
}
If Code=%Serial%
{
RegWrite,REG_DWORD,hkcu,Software\MyProgram,,65535
MsgBox,感谢您的注册，谢谢支持！
Gui,2:Destroy
Reload
}
Else
MsgBox,注册码错误，请检查
Return
E1:
GuiControlGet,E1
if strlen(E1)>8
{
;~  Send,{Tab}
 Guicontrol,Focus,E2
 StringTrimLeft,E2,E1,8
 stringleft,E1,E1,8
 Guicontrol,,E1,%E1%
 Guicontrol,,E2,%E2%
 Goto,E2
}
Return
E2:
GuiControlGet,E2
if strlen(E2)>8
{
;~  Send,{Tab}
 Guicontrol,Focus,E3
 StringTrimLeft,E3,E2,8
 stringleft,E2,E2,8
 Guicontrol,,E2,%E2%
 Guicontrol,,E3,%E3%
 Goto,E3
}
Return
E3:
GuiControlGet,E3
if strlen(E3)>8
{
;~  Send,{Tab}
 Guicontrol,Focus,E4
 StringTrimLeft,E4,E3,8
 stringleft,E3,E3,8
 Guicontrol,,E3,%E3%
 Guicontrol,,E4,%E4%
 Goto,E4
}
Return
E4:
GuiControlGet,E4
if strlen(E4)>8
{
 stringleft,E4,E4,8
 Guicontrol,,E4,%E4%
 }
Return
Copy:
Clipboard:=SerialNumber
Return
;///////MD5函数//////////////////////////////////////////////
MD5(ByRef Buf, L) {                                                   ; Binary buffer, Length in bytes
   Static P, Q, N, i, a,b,c,d, t, h0,h1,h2,h3, y = 0xFFFFFFFF
   h0 := 0x67452301, h1 := 0xEFCDAB89, h2 := 0x98BADCFE, h3 := 0x10325476
   N := ceil((L+9)/64)*64                                             ; padded length (100..separator, 8B length)
   VarSetCapacity(Q,N,0)                                              ; room for padded data
   P := &Q                                                            ; pointer
   DllCall("RtlMoveMemory", UInt,P, UInt,&Buf, UInt,L)                ; copy data
   DllCall("RtlFillMemory", UInt,P+L, UInt,1, UInt,0x80)              ; pad separator
   DllCall("ntdll.dll\RtlFillMemoryUlong",UInt,P+N-8,UInt,4,UInt,8*L) ; at end: length in bits < 512 MB
   Loop % N//64 {
      Loop 16
         i := A_Index-1, w%i% := *P | *(P+1)<<8 | *(P+2)<<16 | *(P+3)<<24, P += 4
      a := h0, b := h1, c := h2, d := h3
      Loop 64 {
         i := A_Index-1
         If i < 16
             f := (b & c) | (~b & d), g := i
         Else If i < 32
             f := (d & b) | (~d & c), g := 5*i+1 & 15
         Else If i < 48
             f := b ^ c ^ d,          g := 3*i+5 & 15
         Else
             f := c ^ (b | ~d),       g :=  7*i  & 15
         t := d, d := c, c := b
         b += rotate(a + f + k%i% + w%g%, r%i%) ; reduced to 32 bits later
         a := t
      }
      h0 := h0+a & y, h1 := h1+b & y, h2 := h2+c & y, h3 := h3+d & y
   }
   Return hex(h0) . hex(h1) . hex(h2) . hex(h3)
}
rotate(a,b) { ; 32-bit rotate a to left by b bits, bit32..63 garbage
   Return a << b | (a & 0xFFFFFFFF) >> (32-b)
}
hex(x) {      ; 32-bit little endian hex digits
   SetFormat Integer, HEX
   x += 0x100000000, x := SubStr(x,-1) . SubStr(x,8,2) . SubStr(x,6,2) . SubStr(x,4,2)
   SetFormat Integer, DECIMAL
   Return x
}
