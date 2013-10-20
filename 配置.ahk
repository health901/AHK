Gosub,read
Gui, Add, Text, x16 y21 w90 h20 , 宽带连接名称：
Gui, Add, Text, x16 y51 w90 h20 , 发送邮件地址:
Gui, Add, Text, x16 y81 w90 h20 , 发送邮件密码:
Gui, Add, Text, x16 y111 w90 h20 , 发送邮件服务器:
Gui, Add, Text, x16 y141 w90 h20 , 接受邮件地址:
Gui, Add, Edit, x116 y21 w120 h20 vAdslName,%AdslName%
Gui, Add, Edit, x116 y51 w120 h20 vemail_form,%email_form%
Gui, Add, Edit, x116 y81 w120 h20 vemail_password Password,%email_password%
Gui, Add, Edit, x116 y111 w120 h20 vemail_server,%email_server%
Gui, Add, Edit, x116 y141 w120 h20 vemail_to,%email_to%
Gui, Add, Button, x66 y171 w100 h30 gSetting, 配置
Gui, Show, h211 w247, 配置
Return

GuiClose:
ExitApp

Read:
RegRead,AdslName,HKLM,Software\AutoAdsl,AdslName
RegRead,email_form,HKLM,Software\AutoAdsl,email_form
RegRead,email_password,HKLM,Software\AutoAdsl,email_password
RegRead,email_server,HKLM,Software\AutoAdsl,email_server
RegRead,email_to,HKLM,Software\AutoAdsl,email_to
Return

Setting:
Gui,submit
Gui,destroy
RegWrite,REG_SZ,HKLM,Software\AutoAdsl,AdslName,%AdslName%
RegWrite,REG_SZ,HKLM,Software\AutoAdsl,email_form,%email_form%
RegWrite,REG_SZ,HKLM,Software\AutoAdsl,email_password,%email_password%
RegWrite,REG_SZ,HKLM,Software\AutoAdsl,email_server,%email_server%
RegWrite,REG_SZ,HKLM,Software\AutoAdsl,email_to,%email_to%
ExitApp
Return