#include Ascii85.ahk

; Find it at http://www.autohotkey.com/forum/viewtopic.php?p=44718#44718
#include BinReadWrite.ahk

LineLength=70			;设置每行长度

; 读取文件
VarSetCapacity(Input, 100000)
h:=OpenFileForRead("moeimouto.png") ; file taken at http://www.autohotkey.com/docs/images/AutoHotkey_logo.gif
BinarySize:=ReadFromFile(h, Input, 0, FILE_BEGIN)	; 文件大小
CloseFile(h)	; 关闭文件

; 计算转换后的文件长度
neededmemory := (BinarySize+3)/4*5 ; BIN（二进制）->ASCII85 转换所需长度
neededmemory += (neededmemory + LineLength - 1) / LineLength * 2 ; 增加CR/LF换行符所需长度
neededmemory += 5 ; 如果加入了Adobe前后缀"<~" "~>"和\0的话，加入这行

; 分配内存空间
VarSetCapacity(Output,neededmemory)

; 转换成ASCII85
OutputSize:=Ascii85_Encoder(&Input, BinarySize, &Output, LineLength)

; 加入'\0' 并告知AHK：文本的大小为0xFFFFFFFF
NumPut(0, Output, OutputSize, "char")
VarSetCapacity(Output, -1)

; 转换一些AHK里的敏感符号
Ascii85_AhkEmbedParser(Output, Output)

; 写入文件
FileDelete, logo.asc
FileAppend, %Output%, logo.asc