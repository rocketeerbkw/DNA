// ForumPageBuilder.h: interface for the CForumPageBuilder class.
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


#if !defined(AFX_FORUMPAGEBUILDER_H__4245227A_EE0E_11D3_BD68_00A02480D5F4__INCLUDED_)
#define AFX_FORUMPAGEBUILDER_H__4245227A_EE0E_11D3_BD68_00A02480D5F4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "Forum.h"

class CForumPageBuilder : public CXMLBuilder  
{
public:

	CForumPageBuilder(CInputContext& inputContext);

	virtual ~CForumPageBuilder();
	virtual bool Build(CWholePage*  pPage);

	virtual bool IsRequestHTMLCacheable();
	virtual CTDVString GetRequestHTMLCacheFolderName();
	virtual CTDVString GetRequestHTMLCacheFileName();

protected:
	bool BuildAllInOnePage(CWholePage* pPage);
	bool BuildSubscribePage(CWholePage* pPage);
	bool BuildMoreThreadsFrame(CWholePage* pPage);
	bool BuildPostHeadersPage(CWholePage* pPage);
	bool BuildMultiPostsPage(CWholePage* pPage, CForum& TitleForum, int iForumType, int iObjectID, CTDVString& sForumTitle, int iSiteID);
	bool BuildThreadsPage(CWholePage* pPage, CForum& TitleForum, int iForumType, int iObjectID, CTDVString& sForumTitle, int iSiteID);
	bool BuildFrameTitle(CWholePage* pPage);
	bool BuildFrameMessages(CWholePage* pPage);
	bool BuildFrameThreads(CWholePage* pPage);
	bool BuildFrameSide(CWholePage* pPage);
	bool BuildFrameTop(CWholePage* pPage);

	bool ErrorMessage(CWholePage* pPage, const TDVCHAR* sType, const TDVCHAR* sMsg);

	bool UseGuestBookForumStyle(int iForumType);
};

#endif // !defined(AFX_FORUMPAGEBUILDER_H__4245227A_EE0E_11D3_BD68_00A02480D5F4__INCLUDED_)
