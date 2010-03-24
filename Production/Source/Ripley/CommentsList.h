// CommentsList.h: interface for the CPostList class.
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


#if !defined(AFX_COMMENTLIST_H__D2F0B15_DE8C_49e0_B6A1_61B1D7193A9F__INCLUDED_)
#define AFX_COMMENTLIST_H__D2F0B15_DE8C_49e0_B6A1_61B1D7193A9F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "User.h"
/*
	class CCommentsList

	Author:		Steven Francis
	Created:	15/06/2007
	Inherits:	CXMLObject
	Purpose:	Encapsulates the XML representation for a list of comments. Can
				represent an arbitrary list of comments, but provides create methods
				to allow the creation of commonly required lists such as a users
				most recent comments.

*/

class CCommentsList : public CXMLObject  
{
public:
	CCommentsList(CInputContext& inputContext);
	virtual ~CCommentsList();

	bool CreateRecentCommentsList(CUser* pViewer, int iUserID, int iSkip = 0, int iMaxNumber = 10);
	bool Initialise();
};

#endif // !defined(AFX_COMMENTLIST_H__D2F0B15_DE8C_49e0_B6A1_61B1D7193A9F__INCLUDED_)
