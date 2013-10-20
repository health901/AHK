;
; AHK版本: 		B:1.0.48.5 L:1.0.92.0
; 语言:			中文/English
; 平台:			Win7
; 作者:			海盗 <healthlolicon@gmail.com>
; 类型:			函数
; 描述:			识别图像类型
;
;
;~ File=C:\Users\Robin\Desktop\Temp\甲抗YST一条龙扫高安.tif
File=C:\Users\Robin\Documents\壁纸\moe 58352 bondage errors extreme_content koku lactation naked nipples pussy uncensored.png
MsgBox,% GetImageTypeW(File)

GetImageTypeW(File)
{
	;Type 0 Unknow
	;Type 1 BMP		*.bmp
	;Type 2 JPEG	*.jpg *.jpeg
	;Type 3 PNG		*.png
	;Type 4 gif		*.gif
	;Type 5 TIFF	*.tif
	hFile:=FileOpen(File,"r")
	hFile.seek(0)
	Filehead_Hex:=hfile.ReadUint()
	hFile.Close()

	if FileHead_hex=0x474E5089			;小端  实际数据为 89 50 4E 47 下同	PNG文件头其实有8字节
		Type=3		;	png
	Else If FileHead_hex=0x38464947	;gif文件头6字节
		Type=4		;	gif
	Else
	{
		Filehead_hex&=0xFFFF
		If FileHead_hex=0x4D42			;BMP的文件头只有2字节
			Type=1		;	bmp
		Else if FileHead_hex=0xD8FF		;JPG文件头也只有2字节
			Type=2		;	jpg/jpeg
		Else If FileHead_hex=0x4949		;TIFF文件头2字节 II
			Type=5		;	tif
		Else If FileHead_hex=0x4D4D		;MM
			Type=5		;	tif
		Else
			Type=0		;	Unknow
		}
	Return,Type
	}
