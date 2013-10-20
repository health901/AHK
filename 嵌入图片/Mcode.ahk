/*
   分配内存，写入机器码
   http://www.autohotkey.com/forum/viewtopic.php?p=135302#135302
   AHK MCode machine langage injector - v1.0
   Recommanded fileName : MCode.ahk
   Author : LHdx 2008/02
   Permission is granted to use copy for commercial or non commercial use provided credit to author remains in source code.

   WARNING : depending on your usage of this wrapper, you *might* have to check shell32.dll version. It is not done directly in this code
             to reduce overhead.

   USE AT YOUR OWN RISKS !

   Base reference : http://www.autohotkey.com/forum/viewtopic.php?t=21172

   Usage : MCode(Destination variable, Source hexa code as string)
   Returns the number of encoded bytes.
*/

MCode(ByRef pDestination, pCodeHexa) {
   Static lMcode
   VarSetCapacity(pDestination, StrLen(pCodeHexa) // 2)
   If (lMcode)
      Return DllCall(&lMcode, "Str", pCodeHexa, "UInt", &pDestination, "cdecl UInt")
   lMcode:="608B7424248B7C242833C9FCAC08C074243C397604245F2C072C30C0E0048AE0AC08C074103C397604245F2C072C3008E0AA41EBD7894C241C61C3"
   Loop % StrLen(lMcode)//2
      NumPut("0x" . SubStr(lMcode,2*A_Index-1,2), lMcode, A_Index-1, "UChar")
   Return DllCall(&lMcode, "Str", pCodeHexa, "UInt", &pDestination, "cdecl UInt")
}

/*
00401050  /$ 60             PUSHAD
00401051  |. 8B7424 24      MOV ESI,DWORD PTR SS:[ESP+24]
00401055  |. 8B7C24 28      MOV EDI,DWORD PTR SS:[ESP+28]
00401059  |. 33C9           XOR ECX,ECX
0040105B  |. FC             CLD
0040105C  |> AC             LODS BYTE PTR DS:[ESI]
0040105D  |> 08C0           OR AL,AL
0040105F  |. 74 24          JE SHORT hex2bin2.00401085
00401061  |. 3C 39          CMP AL,39
00401063  |. 76 04          JBE SHORT hex2bin2.00401069
00401065  |. 24 5F          AND AL,5F
00401067  |. 2C 07          SUB AL,7
00401069  |> 2C 30          SUB AL,30
0040106B  |. C0E0 04        SHL AL,4
0040106E  |. 8AE0           MOV AH,AL
00401070  |. AC             LODS BYTE PTR DS:[ESI]
00401071  |. 08C0           OR AL,AL
00401073  |. 74 10          JE SHORT hex2bin2.00401085
00401075  |. 3C 39          CMP AL,39
00401077  |. 76 04          JBE SHORT hex2bin2.0040107D
00401079  |. 24 5F          AND AL,5F
0040107B  |. 2C 07          SUB AL,7
0040107D  |> 2C 30          SUB AL,30
0040107F  |. 08E0           OR AL,AH
00401081  |. AA             STOS BYTE PTR ES:[EDI]
00401082  |. 41             INC ECX
00401083  |.^EB D7          JMP SHORT hex2bin2.0040105C
00401085  |> 894C24 1C      MOV DWORD PTR SS:[ESP+1C],ECX
00401089  |. 61             POPAD
0040108A  \. C3             RETN


60 8B 74 24 24 8B 7C 24 28 33 C9 FC AC 08 C0 74 24 3C 39 76 04 24 5F 2C 07 2C 30 C0 E0 04 8A E0
AC 08 C0 74 10 3C 39 76 04 24 5F 2C 07 2C 30 08 E0 AA 41 EB D7 89 4C 24 1C 61 C3
*/