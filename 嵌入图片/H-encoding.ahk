; Find it here...
#include Ascii85.ahk

; Find it at http://www.autohotkey.com/forum/viewtopic.php?p=44718#44718
#include BinReadWrite.ahk

; Here starts the sample
; We need the following libraries :
;  - MCode : http://www.autohotkey.com/forum/viewtopic.php?p=180448#180448 or http://www.autohotkey.com/forum/viewtopic.php?p=135302#135302
;  - PhilLo's binary files routines : http://www.autohotkey.com/forum/viewtopic.php?p=44718#44718
;  - (of course) Ascii85

LineLength=70

; read PNG
VarSetCapacity(Input, 100000)
h:=OpenFileForRead("AutoHotkey_logo.png") ; file taken at http://www.autohotkey.com/docs/images/AutoHotkey_logo.gif
BinarySize:=ReadFromFile(h, Input, 0, FILE_BEGIN)
CloseFile(h)

; convert it
OutputSize:=Ascii85_AhkEncoder(Input, BinarySize, Output, LineLength)

; convert to enable AHK inlining
Ascii85_AhkEmbedParser(Output, Output)

; Write ASCII85 conversion of png
FileDelete, logo.asc
FileAppend, %Output%, logo.asc