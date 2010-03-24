// PostList.h: interface for the CPostList class.
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


#if !defined(AFX_POSTLIST_H__68E5A3F5_F413_11D3_86FA_00A024998768__INCLUDED_)
#define AFX_POSTLIST_H__68E5A3F5_F413_11D3_86FA_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "User.h"
/*
	class CPostList

	Author:		Kim Harries
	Created:	08/03/2000
	Inherits:	CXMLObject
	Purpose:	Encapsulates the XML representation for a list of posts. Can
				represent an arbitrary list of posts, but provides create methods
				to allow the creation of commonly required lists such as a users
				most recent posts, or the most recent posts on a users list of
				subscribed forums.

*/

class CPostList : public CXMLObject  
{
public:
	bool MarkAllRead(int iUserID);
	bool RemovePrivatePosts(bool bShowPrivate);
	CPostList(CInputContext& inputContext);
	virtual ~CPostList();

	bool CreateRecentPostsList(CUser* pViewer, int iUserID, int iMaxNumber = 10, int iSkip = 0, int iPostType = 0);
	bool CreateRecentPostsList2(CUser* pViewer, int iUserID, int iMaxNumber = 10, int iSkip = 0, int iPostType = 0);
	bool CreateSubscribedForumsRecentPostsList(int iUserID);
	bool Initialise();
};

#endif // !defined(AFX_POSTLIST_H__68E5A3F5_F413_11D3_86FA_00A024998768__INCLUDED_)
