;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AHK版本：		1.0.48.5
; 语言：		中文
; 适用平台：	WinXp/NT
; 作者：		海盗 <healthlolicon@gmail.com>
; 脚本类型：	软件
; 脚本功能：	自定义运行命令
;
; 已知缺陷：
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#NoEnv
#NoTrayIcon
#SingleInstance off
;~ #Include, I:\AutoHotKey\Lib\
SendMode Input

if 1=
goto,Gui
iniread,ToRun,%A_WinDir%\system32\Myrun.ini,HotStrings,%1%,%A_Space%
IfInString,ToRun,`%
run ,% ap(ToRun),,hide
Else
run,%Torun%
ExitApp

Gui:
Menu,MyContextMenu,Add,复制到剪切板,copy
Menu,MyContextMenu,Add,从列表中删除,delete
Menu,MyContextMenu,Add,清空当前列表,clear
Gui, color, 000000, 000000
Gui, Add, ListView, +BackgroundTrans x-1 y-1 w480 h230 -LV0x10  NoSort AltSubmit vMyrun cffffff, 快捷命令|要执行或打开的程序、文件、命令
LV_ModifyCol(1,130)
LV_ModifyCol(2,345)
Gui, Add, Text, +BackgroundTrans cffffff x10 y241 w90 h20 , 快捷命令
Gui, Add, Text, +BackgroundTrans cffffff x136 y241 w190 h20 , 要执行或打开的程序、文件、命令
Gui, Add, Text, +BackgroundTrans cffffff x350 y241 w120 h20 , 按Esc键关闭本窗口
Gui, Add, Edit, +BackgroundTrans cffffff x6 y266 w110 h20 vHotString ,
Gui, Add, Edit, +BackgroundTrans cffffff x136 y266 w220 h20 vCmd,
Gui, Add, Button, +BackgroundTrans x356 y266 w30 h20 gView, ...
Gui, Add, Button, +BackgroundTrans x396 y266 w70 h20 gAdd Default, 添加
Gui +LastFound
Gui, Show, , Myrun - 自定义运行命令
WinSet,  Transparent, 200 ,Myrun - 自定义运行命令
Gui,-Caption
Gui, Show, w476 h295
WinSet,redraw
Gosub,ini2list
Return

View:
FileSelectFile,Cmd,,,如果要选择文件夹，选该文件夹中任意文件后修改路径即可
GuiControl,,Cmd,%Cmd%
Return

ini2list:
IfNotExist,%A_WinDir%\system32\Myrun.ini
FileAppend,
(
[HotStrings]
`;MyRun配置文件
Setting=C:\WINDOWS\system32\MyRunSetting.ini
),%A_WinDir%\system32\Myrun.ini
FileRead,AllString,%A_WinDir%\system32\Myrun.ini
loop,Parse,AllString,`n,`r
{
    if a_index=1
        Continue
    if Strlen(A_loopfield)=0
        break
    StringSplit,List,A_loopfield,=
    LV_Add(0,List1,List2)
    }
Return

GuiContextMenu:
if A_GuiControl <> Myrun
	Return
Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
Return

Copy:
FocusedRowNumber := LV_GetNext(0, "F")
if not FocusedRowNumber
    return
LV_GetText(copy1, FocusedRowNumber, 1)
LV_GetText(copy2, FocusedRowNumber, 2)
Clipboard:= copy1 . a_space . copy2
Return

~delete::
delete:
RowNumber = 0
Loop
{
    RowNumber := LV_GetNext(RowNumber - 1)
    if not RowNumber
        break
    Lv_GetText(HotString2del,RowNumber,1)
    IniDelete, %A_WinDir%\system32\Myrun.ini, HotStrings , %HotString2del%
    LV_Delete(RowNumber)
}

return

Clear:
LV_Delete()
FileDelete,%A_WinDir%\system32\Myrun.ini
Return

Add:
IfNotExist,%A_WinDir%\system32\MyrunSetting.ini
FileAppend,
(
[Setting]
`;设置是否弹出警告框。1为否，0为是
DontWarnAgain=0
`;设置不弹出警告框的情况下的默认操作。1为覆盖，0为取消
DefaultButton=1
),%A_WinDir%\system32\MyrunSetting.ini
IniRead,DontWarn,%A_WinDir%\system32\MyrunSetting.ini,Setting,DontWarnAgain,0
IniRead,DefaultButton,%A_WinDir%\system32\MyrunSetting.ini,Setting,DefaultButton,1
GuiControlGet,HotString
GuiControlGet,Cmd
iniread,IsExist,%A_WinDir%\system32\Myrun.ini,HotStrings,%HotString%,%A_Space%
if Strlen(IsExist)<>0
{
    if DontWarn=0
    {
        Gui, 2:+owner1
        Gui, 2:color,C6E2FF,C6E2FF
        Gui, 2:Add, Text,+BackgroundTrans  x16 y12 w120 h30 , 已存在相同快捷命令`n%A_Space%是否覆盖？
        Gui, 2:Add, Button,+BackgroundTrans  x16 y51 w40 h20 gYes, 是
        Gui, 2:Add, Button,+BackgroundTrans  x86 y51 w40 h20 gNo, 否
        Gui, 2:Add, CheckBox,+BackgroundTrans  x16 y87 w140 h19 vDontWarnAgain,不再显示此警告框
        Gui, 2:Show,, 警告！
        WinSet,  Transparent,200,警告！
        Gui, 2:-Caption
        Gui, 2:Show, w153 h108
        Return
    }
    If DefaultButton
        Gosub,yes
    Else
        Gosub,No
}
Else
{
    LV_Add(0,HotString,Cmd)
    IniWrite,%Cmd%,%A_WinDir%\system32\Myrun.ini,HotStrings,%HotString%
    }
Return

Yes:
Gui,2:submit
Gui,2:destroy
IniWrite,%DontWarnAgain%,%A_WinDir%\system32\MyRunSetting.ini,Setting,DontWarnAgain
IniWrite,1,%A_WinDir%\system32\MyRunSetting.ini,Setting,DefaultButton
Gosub,Overlay
Return

No:
Gui,2:submit
Gui,2:destroy
IniWrite,%DontWarnAgain%,%A_WinDir%\system32\MyRunSetting.ini,Setting,DontWarnAgain
IniWrite,0,%A_WinDir%\system32\MyRunSetting.ini,Setting,DefaultButton
Return

Overlay:
gui,1:default
Loop % LV_GetCount()
{
    LV_GetText(RetrievedText, A_Index,2)
    if RetrievedText=%IsExist%
    LV_Delete(A_Index)
}
LV_Add(0,HotString,Cmd)
IniWrite,%Cmd%,%A_WinDir%\system32\Myrun.ini,HotStrings,%HotString%
Return

Esc::
GuiClose:
ExitApp

ap(relative)        ;转换为绝对路径 | thx to ashdisp
{
     splitPath,A_ScriptfullPath,,,,,ScriptDrive
     stringReplace,APPPath,relative,`%QLDir`%,% A_ScriptDir,All        ;自身目录
     stringReplace,APPPath,APPPath,`%WinDir`%,% A_Windir,All
     stringReplace,APPPath,APPPath,`%ProgramFiles`%,% A_ProgramFiles,All
     stringReplace,APPPath,APPPath,`%comspec`%,% comspec,All
     return APPPath
}