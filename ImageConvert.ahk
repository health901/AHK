;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; AHK版本：		1.0.48.5
; 语言：		中文
; 适用平台：	WinXp/NT
; 作者：		海盗 <healthlolicon@gmail.com>
; 脚本类型：
; 脚本功能：	图片格式转换:jpg/png/bmp
; 参考：		http://www.autohotkey.com/forum/viewtopic.php?t=11860&postdays=0&postorder=asc&start=0
; 已知缺陷：	格式就这几个 本来还想加TIF，但是不常用，算了。GDIP能处理的格式不少，但是函数
;				源码还没看懂，于是只弄了这仨类型
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Include GDIplusWrapper.ahk
ImageConvert(sFrom="",sTo="")				;和上面的函数雷同，懒得整合了。反正都是Copy来加以修改的代码
{
	#GDIplus_mimeType_BMP = image/bmp
	#GDIplus_mimeType_JPG = image/jpeg
	#GDIplus_mimeType_GIF = image/gif
	#GDIplus_mimeType_PNG = image/png
	#GDIplus_mimeType_TIF = image/tiff
	#EncoderQuality = {1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}

	noParams = NONE

	SplitPath,sTo,,,sExtTo



	step = GDIplus_Start				;加载GDIP
	If (GDIplus_Start() != 0)
		Goto GDIplusError

;~ 	if sFrom=							;加载粘贴板   间歇性故障，不用这个函数来处理粘贴板图片
;~ 	{
;~ 		step = GDIplus_LoadBitmapFromClipboard
;~ 		If (GDIplus_LoadBitmapFromClipboard(bitmap) != 0)
;~ 			Goto GDIplusError
;~ 	}
;~ 	Else
;~ 	{
		step = GDIplus_LoadBitmap			;读取图片
		If (GDIplus_LoadBitmap(bitmap, sFrom) != 0)
			Goto GDIplusError
;~ 	}

	if sExtTo=jpg
	{
		step = GDIplus_GetEncoderCLSID for JPG
		If (GDIplus_GetEncoderCLSID(jpgEncoder, #GDIplus_mimeType_JPG) != 0)
			Goto GDIplusError

		GDIplus_InitEncoderParameters(jpegEncoderParams, 1)
		jpegQuality = 100	; 图片质量 0-100...
		step = GDIplus_AddEncoderParameter for JPG
		If (GDIplus_AddEncoderParameter(jpegEncoderParams, #EncoderQuality, jpegQuality) != 0)
			Goto GDIplusError

		step = GDIplus_SaveImage for JPG
		If (GDIplus_SaveImage(bitmap, sTo, jpgEncoder, jpegEncoderParams) != 0)
			Goto GDIplusError
			}


	Else If sExtTo=png
	{
		step = GDIplus_GetEncoderCLSID for PNG
		If (GDIplus_GetEncoderCLSID(pngEncoder, #GDIplus_mimeType_PNG) != 0)
			Goto GDIplusError

		step = GDIplus_SaveImage for PNG
		If (GDIplus_SaveImage(bitmap, sTo, pngEncoder, noParams) != 0)
			Goto GDIplusError
		}

	Else if sExtTo=bmp
	{
		step = GDIplus_GetEncoderCLSID for BMP
		If (GDIplus_GetEncoderCLSID(bmpEncoder, #GDIplus_mimeType_BMP) != 0)
			Goto GDIplusError

		step = GDIplus_SaveImage for BMP
		If (GDIplus_SaveImage(bitmap, sTo, bmpEncoder, noParams) != 0)
			Goto GDIplusError
	}

	GDIplus_DisposeImage(bitmap)

	Goto GDIplusEnd

	GDIplusError:
	If (#GDIplus_lastError != "")
		MsgBox 16, GDIplus Test, Error in %#GDIplus_lastError% (at %step%)
	GDIplusEnd:
		GDIplus_Stop()
}
