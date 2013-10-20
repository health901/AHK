// TestProject2Dlg.h : 头文件
//

#pragma once
#include "afxcmn.h"
#include "afxwin.h"


// CTestProject2Dlg 对话框
class CTestProject2Dlg : public CDialog
{
// 构造
public:
	CTestProject2Dlg(CWnd* pParent = NULL);	// 标准构造函数

// 对话框数据
	enum { IDD = IDD_TESTPROJECT2_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV 支持


// 实现
protected:
	HICON m_hIcon;

	HMODULE m_hMod;

	// 生成的消息映射函数
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedOk();
	afx_msg void OnBnClickedCancel();
	afx_msg void OnBnClickedButtonOpenFileDialog();
	afx_msg void OnBnClickedButtonDownload();
	afx_msg void OnBnClickedButtonStop();
	afx_msg void OnTimer(UINT nIDEvent);

	LONG    m_lTaskId;
	BOOL    m_bDownloading;
	CString m_strUrl;
	CString m_strRefUrl;
	CString m_strPath;
	CString m_strFileName;
	CProgressCtrl m_ctrlProgress;

	UINT_PTR  m_uTimerIdForQuery;
	UINT      m_uElapseForQuery;
	CStatic m_textProgress;
	afx_msg void OnBnClickedButtonPause();
	afx_msg void OnBnClickedButtonContinue();
};
