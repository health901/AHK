// TestProject2Dlg.cpp : 实现文件
//

#include "stdafx.h"
#include "Demo.h"
#include "DemoDlg.h"
#include ".\DemoDlg.h"
#include "./Export.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// 对话框数据
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
END_MESSAGE_MAP()


// CTestProject2Dlg 对话框



CTestProject2Dlg::CTestProject2Dlg(CWnd* pParent /*=NULL*/)
	: CDialog(CTestProject2Dlg::IDD, pParent)
	, m_lTaskId(0)
	, m_bDownloading(FALSE)
	, m_strUrl(_T(""))
	, m_strRefUrl(_T(""))
	, m_strPath(_T(""))
	, m_strFileName(_T(""))
	, m_uTimerIdForQuery(1)
	, m_uElapseForQuery(1000)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CTestProject2Dlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_EDIT_URL, m_strUrl);
	DDX_Text(pDX, IDC_EDIT_REFER_URL, m_strRefUrl);
	DDX_Text(pDX, IDC_EDIT_FILE_PATH, m_strPath);
	DDX_Text(pDX, IDC_EDIT_FILE_NAME, m_strFileName);
	DDX_Control(pDX, IDC_PROGRESS1, m_ctrlProgress);
	DDX_Control(pDX, IDC_TEXT_PROGRESS, m_textProgress);
}

BEGIN_MESSAGE_MAP(CTestProject2Dlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDOK, OnBnClickedOk)
	ON_BN_CLICKED(IDCANCEL, OnBnClickedCancel)
	ON_BN_CLICKED(IDC_BUTTON_OPEN_FILE_DIALOG, OnBnClickedButtonOpenFileDialog)
	ON_BN_CLICKED(IDC_BUTTON_DOWNLOAD, OnBnClickedButtonDownload)
	ON_BN_CLICKED(IDC_BUTTON_STOP, OnBnClickedButtonStop)
	ON_WM_TIMER()
	ON_BN_CLICKED(IDC_BUTTON_PAUSE, OnBnClickedButtonPause)
	ON_BN_CLICKED(IDC_BUTTON_CONTINUE, OnBnClickedButtonContinue)
END_MESSAGE_MAP()


// CTestProject2Dlg 消息处理程序

BOOL CTestProject2Dlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// 将\“关于...\”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// 设置此对话框的图标。当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

	// TODO: 在此添加额外的初始化代码
	XLInitDownloadEngine();

	CWnd * pWndContinue = GetDlgItem(IDC_BUTTON_CONTINUE);
	CWnd * pWndPause    = GetDlgItem(IDC_BUTTON_PAUSE);
	CWnd * pWndStop     = GetDlgItem(IDC_BUTTON_STOP);
	pWndContinue->EnableWindow(FALSE);
	pWndPause->EnableWindow(FALSE);
	pWndStop->EnableWindow(FALSE);
	
	return TRUE;  // 除非设置了控件的焦点，否则返回 TRUE
}

void CTestProject2Dlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CTestProject2Dlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标显示。
HCURSOR CTestProject2Dlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CTestProject2Dlg::OnBnClickedOk()
{
	if ( !m_bDownloading )
	{
		OnBnClickedButtonDownload();
	}
}

void CTestProject2Dlg::OnBnClickedCancel()
{
	XLUninitDownloadEngine();
	EndDialog(IDCANCEL);
}

void CTestProject2Dlg::OnBnClickedButtonOpenFileDialog()
{
	UpdateData();

	::CoInitialize(NULL);

	ITEMIDLIST * pidl = NULL;
	TCHAR pszDir[MAX_PATH*2] = {0};

	BROWSEINFO   bi;
	bi.hwndOwner = this->m_hWnd;
	bi.iImage = 0;
	bi.lParam = 0;
	bi.pidlRoot = NULL;
	bi.lpfn = NULL;
	bi.lpszTitle = _T("选择保存路径");
	bi.pszDisplayName = pszDir;
	bi.ulFlags = BIF_STATUSTEXT | BIF_USENEWUI | BIF_RETURNONLYFSDIRS;//BIF_DONTGOBELOWDOMAIN | BIF_USENEWUI | BIF_VALIDATE;
	pidl = ::SHBrowseForFolder(&bi);

	if ( pidl )
	{
		ZeroMemory(pszDir, sizeof(TCHAR)*MAX_PATH*2);
		if ( TRUE == ::SHGetPathFromIDList(pidl, pszDir) )
		{
			m_strPath = pszDir;
			if ( m_strPath.GetAt(m_strPath.GetLength()-1) != _T('\\') )
			{
				m_strPath += _T('\\');
			}
			UpdateData(FALSE);
		}
		CoTaskMemFree(pidl);
	}

	::CoUninitialize();
}

void CTestProject2Dlg::OnBnClickedButtonDownload()
{
	if ( m_bDownloading )
	{
		OnBnClickedButtonStop();
	}

	UpdateData();
	CString strSavePath = m_strPath + m_strFileName;
    
 	m_bDownloading = 0==XLURLDownloadToFile(strSavePath, m_strUrl, m_strRefUrl, m_lTaskId);
 
	KillTimer(m_uTimerIdForQuery);
 	if ( m_bDownloading )
 	{
 		SetTimer(m_uTimerIdForQuery, m_uElapseForQuery, NULL);
		m_ctrlProgress.SetPos(0);
		CWnd * pWndContinue = GetDlgItem(IDC_BUTTON_CONTINUE);
		CWnd * pWndPause    = GetDlgItem(IDC_BUTTON_PAUSE);
		CWnd * pWndStop     = GetDlgItem(IDC_BUTTON_STOP);
		pWndContinue->EnableWindow(FALSE);
		pWndPause->EnableWindow(TRUE);
		pWndStop->EnableWindow(TRUE);
 	}
}

void CTestProject2Dlg::OnBnClickedButtonStop()
{
	if ( !m_bDownloading )
	{
		return;
	}

	XLStopTask(m_lTaskId);
	m_lTaskId = 0;
	m_bDownloading = FALSE;
	CWnd * pWndContinue = GetDlgItem(IDC_BUTTON_CONTINUE);
	CWnd * pWndPause    = GetDlgItem(IDC_BUTTON_PAUSE);
	CWnd * pWndStop     = GetDlgItem(IDC_BUTTON_STOP);
	pWndContinue->EnableWindow(FALSE);
	pWndPause->EnableWindow(FALSE);
	pWndStop->EnableWindow(FALSE);
	KillTimer(m_uTimerIdForQuery);
}

void CTestProject2Dlg::OnTimer(UINT nIDEvent)
{

	LONG  lTaskStatus = -1;
	ULONGLONG  ullFileSize = 0;
	ULONGLONG  ullRecvSize = 0;

	if ( m_bDownloading && 0==XLQueryTaskInfo(m_lTaskId, &lTaskStatus, &ullFileSize, &ullRecvSize) )
	{
		if ( ullFileSize )
		{
			// 修改进度
			UINT     uProgress = (UINT)(100*double(ullRecvSize)/double(ullFileSize));
			m_ctrlProgress.SetPos(uProgress);

			// 修改文字
			TCHAR    szBuffer[20] = {'\0'}; 
			double   douRecvsize  = double(ullRecvSize);

			douRecvsize /= (double)0x100000;
			_stprintf(szBuffer, _T("%.2f"), douRecvsize);

			CString  strRecvsize(szBuffer);
			strRecvsize += _T("MB");
			m_textProgress.SetWindowText(strRecvsize);
		}

		if ( lTaskStatus == 11 )
		{
			KillTimer(m_uTimerIdForQuery);
			OnBnClickedButtonStop();
			m_lTaskId = 0;
			m_bDownloading = FALSE;

			::MessageBox(m_hWnd, _T("下载完成"), _T("成功"), MB_OK);
		}

		if ( lTaskStatus == 12 || lTaskStatus == 10 )
		{
			KillTimer(m_uTimerIdForQuery);
			OnBnClickedButtonStop();
			m_lTaskId = 0;
			m_bDownloading = FALSE;

			CString  strMsg;
			strMsg.Format(_T(", 任务状态：%d"), lTaskStatus);
			strMsg = CString(_T("下载失败，请稍候重试")) + strMsg;

			::MessageBox(m_hWnd, strMsg, _T("失败"), MB_OK);
		}
	}
	CDialog::OnTimer(nIDEvent);
}

void CTestProject2Dlg::OnBnClickedButtonPause()
{
	if ( !m_bDownloading )
	{
		return;
	}

	DWORD  dwRet = XLPauseTask(m_lTaskId, m_lTaskId);
	CWnd * pWndContinue = GetDlgItem(IDC_BUTTON_CONTINUE);
	CWnd * pWndPause    = GetDlgItem(IDC_BUTTON_PAUSE);
	CWnd * pWndStop     = GetDlgItem(IDC_BUTTON_STOP);

	if ( 0 == dwRet )
	{
		pWndContinue->EnableWindow(TRUE);
		pWndPause->EnableWindow(FALSE);
		pWndStop->EnableWindow(FALSE);
	}
	else
	{
		pWndContinue->EnableWindow(FALSE);
		pWndPause->EnableWindow(FALSE);
		pWndStop->EnableWindow(FALSE);
	}

	m_bDownloading = false;
	KillTimer(m_uTimerIdForQuery);
}

void CTestProject2Dlg::OnBnClickedButtonContinue()
{
	if ( m_bDownloading )
	{
		return;
	}

	if ( 0 == XLContinueTask(m_lTaskId) )
	{
		m_bDownloading = true;
		SetTimer(m_uTimerIdForQuery, m_uElapseForQuery, NULL);

		CWnd * pWndContinue = GetDlgItem(IDC_BUTTON_CONTINUE);
		CWnd * pWndPause    = GetDlgItem(IDC_BUTTON_PAUSE);
		CWnd * pWndStop     = GetDlgItem(IDC_BUTTON_STOP);
		pWndContinue->EnableWindow(FALSE);
		pWndPause->EnableWindow(TRUE);
		pWndStop->EnableWindow(TRUE);
	}
}
