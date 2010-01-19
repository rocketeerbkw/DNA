// EditPostPageBuilder.h: interface for the CEditPostPageBuilder class.
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

/***********************************************************************
This is the post editor that site editors use and will allow editing of
any post, unlike CEditRecentPostBuilder which only allows owners of
a post to edit it within a specific time window.
***********************************************************************/

#if defined (_ADMIN_VERSION)

#if !defined(AFX_EDITPOSTPAGEBUILDER_H__346440F3_0332_11D5_873F_00A024998768__INCLUDED_)
#define AFX_EDITPOSTPAGEBUILDER_H__346440F3_0332_11D5_873F_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "InputContext.h"
#include "InputContext.h"
#include "WholePage.h"
#include "User.h"
#include "TDVString.h"
#include "ForumPostEditForm.h"

/*
	class CEditPostPageBuilder

	Author:		Kim Harries
	Created:	16/02/2001
	Inherits:	CXMLBuilder
	Purpose:	Builds the XML for the post editing page
*/

class CEditPostPageBuilder : public CXMLBuilder  
{
public:
	CEditPostPageBuilder(CInputContext& inputContext);
	virtual ~CEditPostPageBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
	CTDVString			m_sCommand;
	CForumPostEditForm m_ForumPostEditForm;

	bool ProcessSubmission(CUser* pViewer);
};

#endif // !defined(AFX_EDITPOSTPAGEBUILDER_H__346440F3_0332_11D5_873F_00A024998768__INCLUDED_)

#endif // _ADMIN_VERSION
