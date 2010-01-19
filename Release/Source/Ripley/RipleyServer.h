/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/

#if !defined(AFX_RIPLEYSERVER_H__03E3D463_E4A0_11D3_89E5_00104BF83D2F__INCLUDED_)
#define AFX_RIPLEYSERVER_H__03E3D463_E4A0_11D3_89E5_00104BF83D2F__INCLUDED_

// RIPLEYSERVER.H - Header file for your Internet Server
//    RipleyServer Extension

#include "resource.h"
#include "Ripley.h"
#pragma warning(disable:4786)
#include <map>

using namespace std ;

class CRipleyServerExtension 
{
	public:
		CRipleyServerExtension();
		~CRipleyServerExtension();

	// Overrides
		// ClassWizard generated virtual function overrides
			// NOTE - the ClassWizard will add and remove member functions here.
			//    DO NOT EDIT what you see in these blocks of generated code !
		//{{AFX_VIRTUAL(CRipleyServerExtension)
		public:
		//virtual BOOL GetExtensionVersion(HSE_VERSION_INFO* pVer);
		//virtual int CallFunction(CHttpServerContext* pCtxt, LPTSTR pszQuery, LPTSTR pszCommand);
		//}}AFX_VIRTUAL
		//virtual BOOL TerminateExtension(DWORD dwFlags);

		// TODO: Add handlers for your commands here.
		// For example:

		//void Default(CHttpServerContext* pCtxt);

		static bool IsShuttingDown() { return m_bIsShuttingDown; }
		//DECLARE_PARSE_MAP()

        static DWORD WINAPI HttpExtensionProc(EXTENSION_CONTROL_BLOCK *pECB);
        //static BOOL WINAPI GetExtensionVersion(HSE_VERSION_INFO *pVer);

		//{{AFX_MSG(CRipleyServerExtension)
		//}}AFX_MSG

	protected:
		const char* GetConfigFileName( );
		bool InitFromConfigFile(EXTENSION_CONTROL_BLOCK* pECB,  CTDVString& sConfigFileError );

        bool InitialiseRequest(EXTENSION_CONTROL_BLOCK* pECB, const TDVCHAR* pRequestData);

		CTDVString GetRipleyServerInfoXML(const TDVCHAR* pFileName);
		void GetDLLVersion(const TDVCHAR* pFileName, CTDVString& sVersion);

	    void ServerTooBusy(EXTENSION_CONTROL_BLOCK* pECB);

		bool UseHTMLCache(CGI& ThisRequest);

	private:
		CRipley m_Ripley;
		CGI m_MasterCgi;
		CTDVString m_sConfigFileName;
		CRITICAL_SECTION m_oCriticalSectionObjectForConfig;
		LONG m_RunningRequests;
        bool m_bInitialisedFromConfigFile;

		static bool m_bIsShuttingDown;

        static void WriteContext(EXTENSION_CONTROL_BLOCK* pECB, const TDVCHAR* pszFormat);
        static void WriteHeaders(EXTENSION_CONTROL_BLOCK* pECB, const TDVCHAR* pszFormat);

};


//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_RIPLEYSERVER_H__03E3D463_E4A0_11D3_89E5_00104BF83D2F__INCLUDED)
