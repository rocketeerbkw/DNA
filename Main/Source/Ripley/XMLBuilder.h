// XMLBuilder.h: interface for the CXMLBuilder class.
//
//////////////////////////////////////////////////////////////////////

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



#if !defined(AFX_XMLBUILDER_H__03E3D46C_E4A0_11D3_89E5_00104BF83D2F__INCLUDED_)
#define AFX_XMLBUILDER_H__03E3D46C_E4A0_11D3_89E5_00104BF83D2F__INCLUDED_

#include "XMLObject.h"
#include "InputContext.h"		// added 28.2.2000 to prevent compiler errors, Kim.
#include "OutputContext.h"		// added 28.2.2000 to prevent compiler errors, Kim.
#include "WholePage.h"

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#define	USER_ANY 1
#define	USER_AUTHENTICATED 2
#define	USER_TESTER 4
#define	USER_MODERATOR 8
#define	USER_EDITOR 16
#define	USER_ADMINISTRATOR 32

class CXMLBuilder : public CXMLError
{
	public:
		CXMLBuilder(CInputContext& inputContext);

		bool ManageClippedLinks(CWholePage *pPage);
		
		virtual bool IsUserAuthorised();
		virtual bool AddSiteListToPage(CWholePage* pPage);

		// helper function to switch sites
		bool DoSwitchSites(CWholePage* pPage, const TDVCHAR* pURL, int iCurrentSiteID, int iContentSiteID, CUser** ppUser);
		
		// this is the proper constructor
		virtual ~CXMLBuilder();

		virtual bool Build(CWholePage* pPage);

		int m_AllowedUsers;

		// By default, all builders return callOK as the HTTP return code in a failure condition
		//virtual CHttpServer::errors GetHttpErrorCode() { return CHttpServer::callOK; }

		virtual bool IsRequestHTMLCacheable()				{ return false; }
		virtual CTDVString GetRequestHTMLCacheFolderName()	{ return CTDVString(""); }
		virtual CTDVString GetRequestHTMLCacheFileName()	{ return CTDVString(""); }

	protected:
		//CWholePage* CreateAndInitPage(const TDVCHAR* pPageName, bool bDefaultUI,bool* pbOK = NULL, bool bIncludeUser=true);
		bool InitPage(CWholePage* pPage, const TDVCHAR* pPageName, bool bDefaultUI, bool bIncludeUser=true);
		
		//Includes cached 'live topics - override for different behaviour.
		virtual bool AddTopicsToPage( CWholePage* pPage, bool bPreviewMode );

		virtual bool CreateSimplePage(CWholePage* pPage, const TDVCHAR* pSubject, const TDVCHAR* pBody);
		bool SendMail(const TDVCHAR* pEmail, const TDVCHAR* pSubject, const TDVCHAR* pBody, const TDVCHAR* pFromAddress = NULL, const TDVCHAR* pFromName = NULL, const bool bInsertLineBreaks = false);
		bool SendMailOrSystemMessage(const TDVCHAR* pEmail, const TDVCHAR* pSubject, const TDVCHAR* pBody, const TDVCHAR* pFromAddress = NULL, const TDVCHAR* pFromName = NULL, const bool bInsertLineBreaks = false, int piUserID = 0, int piSiteID = 0);
		CInputContext& m_InputContext;
		
	//	bool InitialiseUser();
	//	bool GetArticle(h2g2ID | keyname);

		virtual bool CheckAndUseRedirectIfGiven(CWholePage* pPage);

	private:
		CXMLBuilder();	// private to prevent it ever being called. No inplementation
};

#endif // !defined(AFX_XMLBUILDER_H__03E3D46C_E4A0_11D3_89E5_00104BF83D2F__INCLUDED_)
