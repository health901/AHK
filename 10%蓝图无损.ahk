;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AHK版本：		1.0.48.5
; 语言：		中文
; 适用平台：	WinXp/NT
; 作者：		海盗 <healthlolicon@gmail.com>
; 脚本类型：
; 脚本功能：
;
; 已知缺陷：
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Gui, Add, Text, x6 y11 w180 h20 , 10`%初始损耗系数蓝图无损计算
Gui, Add, Text, x6 y41 w90 h20 , 最大材料数目:
Gui, Add, Edit, x106 y41 w80 h20 Number vMaterial gCalculate,
Gui, Add, Edit, x6 y81 w180 Disabled vResult, 无损次数:
; Generated using SmartGUI Creator 4.0
Gui, Show, x131 y91 h122 w195, 无损
Return

GuiClose:
ExitApp

Calculate:
GuiControlGet,Material
Loop
{
	A:=Round(Material/1.1)*(0.1/(1+A_index-1))
	if A<0.5
	{
		Times:=A_Index-1
		Break
	}
}
GuiControl,,Result,无损次数:%Times%次
Return
