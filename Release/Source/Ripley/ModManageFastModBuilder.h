// ModerateHomePageBuilder.h: interface for the CModManageFastModBuilder class.
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


#if defined (_ADMIN_VERSION)

#if !defined(AFX_MODMANGEFASTMODBUILDER_H__362D595F_01BC_11D5_873E_00A024998768__INCLUDED_)
#define AFX_MODMANGEFASTMODBUILDER_H__362D595F_01BC_11D5_873E_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CInputContext;
class CTDVString;
class CWholePage;

/*
class CModManageFastModBuilder
Author:		Igor Loboda
Created:	15/07/2005
Inherits:	CXMLBuilder
Purpose:	Builds the XML for the fast mod management page
*/

class CModManageFastModBuilder : public CXMLBuilder  
{
	public:
		CModManageFastModBuilder(CInputContext& inputContext);
		bool Build(CWholePage* pPage);

	protected:
		bool ProcessSubmission(int& iRecordsUpdated);
		bool GetTopicsXml(CTDVString& sXml);
		bool GetFastModSitesXml(CWholePage* pPage);
		bool GetAllRefereeSitesXml(int& iFirstSiteId, CTDVString& sFirstSiteName, 
			CTDVString& sXml);
		bool UpdateFastMod(int iForumId, bool bFastMod);
		bool DoUpdate(int& iRecordsUpdated);
		bool BuildPage(CWholePage& page, int iRecordsUpdated);
		bool GetManageFastModXml(int iRecordsUpdated, CTDVString& sXml);
		bool CheckUserCanManageFastModForSite();

	protected:
		int m_iSiteId;
		//CTDVString m_sSiteName;
};

#endif // !defined(AFX_MODMANGEFASTMODBUILDER_H__362D595F_01BC_11D5_873E_00A024998768__INCLUDED_)

#endif // _ADMIN_VERSION
