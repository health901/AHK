/*
CP_ACP   = 0
CP_OEMCP = 1
CP_MACCP = 2
CP_UTF7  = 65000
CP_UTF8  = 65001
*/

Ansi2Oem(sString)
{
   Ansi2Unicode(sString, wString, 0)
   Unicode2Ansi(wString, zString, 1)
   Return zString
}

Oem2Ansi(zString)
{
   Ansi2Unicode(zString, wString, 1)
   Unicode2Ansi(wString, sString, 0)
   Return sString
}

Ansi2UTF8(sString)
{
   Ansi2Unicode(sString, wString, 0)
   Unicode2Ansi(wString, zString, 65001)
   Return zString
}

UTF82Ansi(zString)
{
   Ansi2Unicode(zString, wString, 65001)
   Unicode2Ansi(wString, sString, 0)
   Return sString
}

Ansi2Unicode(ByRef sString, ByRef wString, CP = 0)
{
     nSize := DllCall("MultiByteToWideChar"
      , "Uint", CP
      , "Uint", 0
      , "Uint", &sString
      , "int",  -1
      , "Uint", 0
      , "int",  0)

   VarSetCapacity(wString, nSize * 2)

   DllCall("MultiByteToWideChar"
      , "Uint", CP
      , "Uint", 0
      , "Uint", &sString
      , "int",  -1
      , "Uint", &wString
      , "int",  nSize)
}

Unicode2Ansi(ByRef wString, ByRef sString, CP = 0)
{
     nSize := DllCall("WideCharToMultiByte"
      , "Uint", CP
      , "Uint", 0
      , "Uint", &wString
      , "int",  -1
      , "Uint", 0
      , "int",  0
      , "Uint", 0
      , "Uint", 0)

   VarSetCapacity(sString, nSize)

   DllCall("WideCharToMultiByte"
      , "Uint", CP
      , "Uint", 0
      , "Uint", &wString
      , "int",  -1
      , "str",  sString
      , "int",  nSize
      , "Uint", 0
      , "Uint", 0)
}
UrlUnEscape(url)                ; URL×Ö·û´®½âÂë
{
   VarSetCapacity(newUrl,500,0),pcche:=500
   DllCall("shlwapi\UrlUnescapeA", Str,url, Str,newUrl, UIntP,pcche, UInt,0x10000000)
   Return newUrl
}
UrlEncode(String)               ; URL×Ö·û´®±àÂë
{
   OldFormat := A_FormatInteger
   SetFormat, Integer, H

   Loop, Parse, String
   {
      if A_LoopField is alnum
      {
         Out .= A_LoopField
         continue
      }
      Hex := SubStr( Asc( A_LoopField ), 3 )
      Out .= "%" . ( StrLen( Hex ) = 1 ? "0" . Hex : Hex )
   }

   SetFormat, Integer, %OldFormat%

   return Out
}