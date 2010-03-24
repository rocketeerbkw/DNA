// Search.h: interface for the CSearch class.
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


#if !defined(AFX_SEARCH_H__E17310C8_00AD_11D4_BD75_00A02480D5F4__INCLUDED_)
#define AFX_SEARCH_H__E17310C8_00AD_11D4_BD75_00A02480D5F4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"

class CSearch : public CXMLObject  
{
public:
	CSearch(CInputContext& inputContext);
	virtual ~CSearch();

	bool InitialiseArticleSearch(const TDVCHAR* pcSearchString, int iShowApproved, int iShowNormal, int iShowSubmitted, const CTDVString* psUserGroups, int iSkip, int iShow, int iSiteID, int iCategory, int iSearcherID = 0, int iShowContentRatingData = 0, int iArticleType = 0, int iArticleStatus = 0);

	bool InitialiseForumSearch(const TDVCHAR* pcSearchString, const CTDVString* psUserGroups, int iSkip, int iShow, int iSiteID, int iCategory, int iForumID = 0, int iThreadID = 0, int iSearcherID = 0);
	
	bool InitialiseNameOrEmailSearch(const TDVCHAR* pcSearchString, int iSkip, int iShow, int iSearcherID, bool bAllowEmailSearch, int iSiteID = 0);
	
	bool InitialiseNewSearch(const TDVCHAR* pSearchWords, bool bShowApproved = true, bool bShowNormal = true, bool bShowSubmitted = true, int iSiteID = 1, bool bUseANDSearch = true, bool bPhraseSearch = false, int iShow = 20, int iSkip = 0, int iMaxResults = 500, int iCategory = 0);
	
	bool InitialiseHierarchySearch(const TDVCHAR* pSearchString, int iSiteID, int iSkip, int iShow );
private:
	void EscapeSearchTerm(CTDVString* pString);
	void RemoveNoiseWords(CTDVString* pString);
	bool CalculateSearchCondition(const TDVCHAR* pUnmodifiedSearch, const TDVCHAR* pModifiedSearch, CTDVString* psCondition);
	bool IsNoiseWord(const TDVCHAR* pWord);
	bool UseFastSearch();

};

#endif // !defined(AFX_SEARCH_H__E17310C8_00AD_11D4_BD75_00A02480D5F4__INCLUDED_)
