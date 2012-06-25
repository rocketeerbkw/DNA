#if !defined(AFX_H2G2FILTER_H__DAAFA047_C04C_11D2_804F_00609753E9AE__INCLUDED_)
#define AFX_H2G2FILTER_H__DAAFA047_C04C_11D2_804F_00609753E9AE__INCLUDED_

// H2G2FILTER.H - Header file for your Internet Server
//    h2g2 filter

#include "resource.h"

#define	URL_BUFFER_SIZE 1024

/////////////////////////////////////////////////////////////////////////////
// CH2g2Filter 
//
// See h2g2filter.cpp for the implementation of this class
//


class CH2g2Filter : public CHttpFilter
{
public:
	CH2g2Filter();
	~CH2g2Filter();

// Overrides
	// ClassWizard generated virtual function overrides
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//{{AFX_VIRTUAL(CH2g2Filter)
	public:
	virtual BOOL GetFilterVersion(PHTTP_FILTER_VERSION pVer);
	virtual DWORD OnPreprocHeaders(CHttpFilterContext* pCtxt, PHTTP_FILTER_PREPROC_HEADERS pHeaderInfo);
	virtual DWORD OnEndOfNetSession(CHttpFilterContext* pCtxt);
	virtual DWORD OnUrlMap(CHttpFilterContext* pfc, PHTTP_FILTER_URL_MAP pUrlMap);
	//}}AFX_VIRTUAL

	//{{AFX_MSG(CH2g2Filter)
	//}}AFX_MSG

//	virtual DWORD OnLog(CHttpFilterContext* pCtxt, PHTTP_FILTER_LOG pLog);


protected:

	// Member variables.

	HANDLE m_hEventLog;
	HKEY m_RegKeyRoot;
	HKEY m_RegKeyPrefixes;
	HKEY m_RegKeyExtensions;
	HKEY m_RegKeyUnCookied;
	HKEY m_RegKeyTimeToLive;

	char m_pSuffixes[URL_BUFFER_SIZE];
	BOOL m_bKeepAuditTrail;

	// Member functions.

	BOOL EventLog( LPCTSTR lpString, WORD wEventType = EVENTLOG_INFORMATION_TYPE);
	char* CopyAsFarAs(char* pDest, char* pStart, char* pEnd);
	char* CopyMatching(char* pDest, char* pSrc, char* pMatches);
	char* CopyNonMatching(char* pDest, char* pSrc, char* pMatches);
	
	BOOL CheckForCachedFiles(char* pDestURL, char* pPrefix, char* pNumericID, BOOL bCookie);
	

};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_H2G2FILTER_H__DAAFA047_C04C_11D2_804F_00609753E9AE__INCLUDED)
