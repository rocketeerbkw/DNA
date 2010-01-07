// UserPageBuilder.h: interface for the CUserPageBuilder class.
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


#if !defined(AFX_USERPAGEBUILDER_H__0CC07E82_EE07_11D3_86F8_00A024998768__INCLUDED_)
#define AFX_USERPAGEBUILDER_H__0CC07E82_EE07_11D3_86F8_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "WholePage.h"
#include "PageUI.h"
#include "User.h"
#include "GuideEntry.h"
#include "Forum.h"
#include "PostList.h"
#include "ArticleList.h"
#include "CommentsList.h"
#include "ArticleSubscriptionList.h"
/*
	class CUserPageBuilder

	Author:		Kim Harries
	Created:	28/02/2000
	Modified:	15/03/2000
	Inherits:	CXMLBuilder
	Purpose:	Builds the XML for a user page based on the request info from
				the CGI request, accessed through the given input context. To do
				this it will most likely require access to the database via a
				database context, but in some cases this may not be necessary.

*/

class CUserPageBuilder : public CXMLBuilder  
{
public:
	CUserPageBuilder(CInputContext& inputContext);
	virtual ~CUserPageBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
	bool CreatePageTemplate(CWholePage* pPage);
	bool CreateUserInterface(CUser* pViewer, CUser& Owner, CGuideEntry& pMasthead, CPageUI &Interface);
	bool CreatePageOwner(int iUserID, CUser& Owner);
	bool CreatePageArticle(int iUserID, CUser& PageOwner, CGuideEntry& Masthead);
	bool CreatePageForum(CUser* pViewer, CGuideEntry& Article, CForum& PageForum);
	bool CreateJournal(CUser& PageOwner, CUser* pViewer, CForum& Journal);
	bool CreateRecentPosts(CUser& PageOwner, CUser* pViewer, CPostList& RecentPosts);
	bool CreateRecentArticles(CUser& PageOwner, CArticleList& Articles);
	bool CreateRecentApprovedArticles(CUser& PageOwner, CArticleList& Articles);
	bool CreateRecentComments(CUser& PageOwner, CUser* pViewer, CCommentsList& RecentComments);
	bool CreateSubscribedToUsersRecentArticles(CUser& PageOwner, int iSiteID, CArticleSubscriptionList& SubscribedUsersArticles);

	bool AddClubsUserBelongsTo(CWholePage* pPage,int iUserID);
};

#endif // !defined(AFX_USERPAGEBUILDER_H__0CC07E82_EE07_11D3_86F8_00A024998768__INCLUDED_)
