// Info.h: interface for the CInfo class.
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


#if !defined(AFX_INFO_H__877A1B72_FE46_11D3_BD73_00A02480D5F4__INCLUDED_)
#define AFX_INFO_H__877A1B72_FE46_11D3_BD73_00A02480D5F4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"

class CInfo : public CXMLObject  
{
public:
	bool CreateRecentArticles(int iSiteID, int iSkip, int iShow);
	bool CreateRecentConversations(int iSiteID, int iSkip = 0, int iShow = 20);
	bool CreateTotalRegUsers();
	bool CreateTotalApprovedEntries(int iSiteID);
	bool CreateProlificPosters(int iSiteID);
	bool CreateEruditePosters(int iSiteID);
	bool CreateBlank();
	CInfo(CInputContext& inputContext);
	virtual ~CInfo();

	virtual bool Initialise(int siteID);

private:
	bool UseCacheFile(CTDVString& sCacheName);
	void Cache(CTDVString& sCacheName);
};

#endif // !defined(AFX_INFO_H__877A1B72_FE46_11D3_BD73_00A02480D5F4__INCLUDED_)
