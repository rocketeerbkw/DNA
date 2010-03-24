/******************************************************************************
class:	CProfanityAdmin

This class manages the PROFANITYADMIN xml element. It will be able to generate: 
	- Current site the filter is being viewed for (SITE)
	  See class CSite
	  OR
      Current group the filter is being viewed for (PROFANITYGROUP)
	  See class CProfanityGroup
	- A list of profanity groups (PROFANITYGROUPLIST)
	  See class CProfanityGroupList
	- A list of profanities for the current site or the current group (PROFANITYLIST)
	  See class CProfanityList

This class also contains the necessary functions for interacting with the database to:
	- Add, update and delete profanity groups
	- Add, update and delete profanities

Design decisions:
	- This module has no knowledge of the input context, instead it acts on 
	  parameters passed in from the builder. It will create a PROFANITYADMIN node 
	  when Create() is called and then all subsequent calls will add items inside it.
******************************************************************************/

#if !defined(AFX_PROFANITYADMIN_H__674B8B9E_F698_4F90_AA14_2767E45FCF7D__INCLUDED_)
#define AFX_PROFANITYADMIN_H__674B8B9E_F698_4F90_AA14_2767E45FCF7D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "ProfanityGroup.h"
#include "ProfanityList.h"

class CProfanityAdmin  : public CXMLObject
{
public:
	CProfanityAdmin(CInputContext& inputContext);
	virtual ~CProfanityAdmin();

	bool Create(const TDVCHAR* pAction);

	void AddInsideSelf(const TDVCHAR* pXML);
	void AddInsideSelf(CXMLObject* objectToAdd);
#if 0
	// Profanities
	//
	bool ShowSiteFilter(const int iSiteId, const TDVCHAR* pSiteName);
	bool AddSiteProfanityList(const int iSiteId);
	bool AddGroupOrSiteDetails(const int iId, const bool bIsSite, const TDVCHAR* pSiteName = NULL);
	bool AddProfanity(const int iGroupId, const int iSiteId, const TDVCHAR* pProfanity, 
				const int iProfanityRating, const TDVCHAR* pProfanityReplacement);
	bool UpdateProfanity(const int iProfanityId, const int iGroupId, const int iSiteId, const TDVCHAR* pProfanity, 
				const int iProfanityRating, const TDVCHAR* pProfanityReplacement);
	bool DeleteProfanity(const int iProfID);
	bool AddProfanityInfoTag(const TDVCHAR* pContainerText, const int iProfanityId, 
				const TDVCHAR* pProfanity, const int iRating = 0, const TDVCHAR* pReplacement = NULL,
				const int iGroupId = -1, const int iSiteId = -1);
	void ShowDuplicateProfanityError(CStoredProcedure& SP);

	// Profanity Groups
	//
	bool ShowGroupList();
	bool ShowGroupFilter(const int iGroupId);
	bool AddCurrentGroupDetails(const int iGroupId);
	bool AddCurrentGroupDetails(const int iGroupId, bool bReturnInfo, CTDVString& sGroupName, CTDVString& sGroupSites);
	bool AddCurrentSiteDetails(const int iSiteId, const TDVCHAR* pSiteName);
//	bool AddGroup(const TDVCHAR* pGroupName, const TDVCHAR* pGroupSites);
//	bool UpdateGroup(const int iGroupId, const TDVCHAR* pGroupName, const TDVCHAR* pGroupSites);
//	bool SetSiteListForGroup(CStoredProcedure& SP, CProfanityGroup& profanityGroup, const int iGroupId, const TDVCHAR* pGroupSites);
//	bool DeleteGroup(const int iGroupId);
	bool AddGroupAndCompleteSiteList(const int iGroupId, const TDVCHAR* sGroupName, const TDVCHAR* sGroupSites);
	bool AddCompleteSiteList(const TDVCHAR* pExcludeSites = NULL);
#endif
	bool ProcessProfanities(void);
	bool AddProfanities(void);
	bool ImportProfanityList(void);

protected:
	void Clear();

	CProfanityList m_profanityList;
};


/*********************************************************************************
inline void CProfanityAdmin::AddInsideSelf(const TDVCHAR* pXML)
Author:		David van Zijl
Created:	15/08/2004
Purpose:	Adds string to top PROFANITYADMIN node
*********************************************************************************/

inline void CProfanityAdmin::AddInsideSelf(const TDVCHAR* pXML)
{
	AddInside("PROFANITYADMIN", pXML);
}


/*********************************************************************************
inline void AddInsideSelf(const TDVCHAR* pXML)
Author:		David van Zijl
Created:	15/08/2004
Purpose:	Adds string to top PROFANITYADMIN node
*********************************************************************************/

inline void CProfanityAdmin::AddInsideSelf(CXMLObject* objectToAdd)
{
	AddInside("PROFANITYADMIN", objectToAdd);
}

#endif // !defined(AFX_PROFANITYADMIN_H__674B8B9E_F698_4F90_AA14_2767E45FCF7D__INCLUDED_)
