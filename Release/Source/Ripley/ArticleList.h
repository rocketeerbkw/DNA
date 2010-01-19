// ArticleList.h: interface for the CArticleList class.
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


#if !defined(AFX_ARTICLELIST_H__2EA5D5D4_F4E3_11D3_86FB_00A024998768__INCLUDED_)
#define AFX_ARTICLELIST_H__2EA5D5D4_F4E3_11D3_86FB_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "StoredProcedure.h"

/*
	class CArticleList

	Author:		Kim Harries
	Created:	08/03/2000
	Inherits:	CXMLObject
	Purpose:	Encapsulates the XML representation for a list of articles. Can
				represent an arbitrary list of articles, but provides create methods
				to allow the creation of commonly required lists such as a users
				most recent guide entries.

*/

class CArticleList : public CXMLObject  
{
public:
	bool CreateCancelledArticlesList(int iUserID, int iMaxNumber, int iSkip, int iGuideType = 0);
	bool CreateRecentArticlesList(int iUserID, int iMaxNumber = 10, int iSkip = 0, int iSiteID = 0, int iGuideType = 0);
	bool CreateRecentApprovedArticlesList(int iUserID, int iMaxNumber = 10, int iSkip = 0, int iGuideType = 0);
	bool CreateRecentNormalAndApprovedArticlesList(int iUserID, int iMaxNumber, int iSkip, int iGuideType = 0);
	bool CreateUndecidedRecommendationsList(int iMaxNumber = 50, int iSkip = 0);
	bool CreateUnallocatedRecommendationsList(int iMaxNumber = 20, int iSkip = 0);
	bool CreateAllocatedRecommendationsList(int iMaxNumber = 20, int iSkip = 0);
	bool CreateScoutRecommendationsList(int iScoutID, const TDVCHAR* pcTimeUnit, int iNumberOfUnits);
	bool CreateSubsEditorsAllocationsList(int iSubID, const TDVCHAR* pcTimeUnit, int iNumberOfUnits);

	CArticleList(CInputContext& inputContext);
	virtual ~CArticleList();

	enum ArticleListType
	{
		ARTICLELISTTYPE_FIRST			  = 1,

		ARTICLELISTTYPE_APPROVED		  = 1,
		ARTICLELISTTYPE_NORMAL			  = 2,
		ARTICLELISTTYPE_CANCELLED		  = 3,
		ARTICLELISTTYPE_NORMALANDAPPROVED = 4,

		ARTICLELISTTYPE_LAST			  = 4	// Don't forget to update this!!!
	};

protected:
	CStoredProcedure*	m_pSP;

	bool CreateMostRecentList(int iUserID, int iMaxNumber, int iSkip, int iWhichType, int iSiteID = 0, int iGuideType = 0);
	
	// generic helper methods
	bool CreateList(int iMaxNumber = 10, int iSkip = 0);
	bool AddCurrentArticleToList();
	bool CreateUserBlock(CTDVString & sXML, CTDVString sUserType);
};

#endif // !defined(AFX_ARTICLELIST_H__2EA5D5D4_F4E3_11D3_86FB_00A024998768__INCLUDED_)
