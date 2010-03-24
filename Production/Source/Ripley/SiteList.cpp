// SiteList.cpp: implementation of the CSiteList class.
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


#include "stdafx.h"
#include "ripleyserver.h"
#include "SiteData.h"
#include "SiteList.h"
#include "HTMLTransformer.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSiteList::CSiteList()
{
	m_MaxSiteId = 0;
	InitializeCriticalSection(&m_criticalsection);
}

CSiteList::~CSiteList()
{
	SITENAMEMAP::iterator MapIt;
	for (MapIt = m_SiteMap.begin(); MapIt != m_SiteMap.end();MapIt++)
	{
		CSiteData* pd = (*MapIt).second;
		delete (*MapIt).second;
	}
	m_SiteMap.clear();
	m_SiteIDMap.clear();
	DeleteCriticalSection(&m_criticalsection);
}

/*********************************************************************************

	bool CSiteList::GetSiteDetails(const TDVCHAR *pName, int *piSiteID, bool *pbPreModeration, CTDVString *psDefaultSkin)

	Author:		Jim Lynn
	Created:	23/07/2001
	Inputs:		pName
	Outputs:	piSiteID - integer ID of site
				pbPreModeration - true if PM is on, false if it's off
				psDefaultSkin - name of default skin for the site
				bNoAutoSwitch - state of the noautoswitch flag
				psModeratorsEmail - moderators email for the site
				psEditorsEmail - editors email for the site
				psFeedbackEmail - feedback email for the site
	Returns:	true if site name found, false otherwise
	Purpose:	Looks up the site details for the named site and returns the
				standard ruleset for this site in variables.

*********************************************************************************/

bool CSiteList::GetSiteDetails(const TDVCHAR *pName, int *piSiteID, 
							   bool *pbPreModeration, CTDVString *psDefaultSkin, 
							   bool* bNoAutoSwitch, CTDVString* psDescription, 
							   CTDVString* psShortName, CTDVString* psModeratorsEmail,
							   CTDVString* psEditorsEmail, CTDVString* psFeedbackEmail,
							   int* piAutoMessageUserID, bool* pbPassworded, bool *pbUnmoderated,
							   bool* pbArticleGuestBookForums, CTDVString* psSiteConfig, int *piThreadOrder,
							   CTDVString* psEMailAlertSubject, int* piThreadEditTimeLimit, 
							   int* piEventAlertMessageUserID, int* piAllowRemoveUsers, int* piIncludeCrumbtrail,
							   int* piAllowPostCodesInSearch, bool* pbQueuePostings, bool* pbSiteEmergencyClosed,
							   CTDVString* pSSOService )
{
	Lock();
	CSiteData* pData = m_SiteMap[CTDVString(pName)];
	if (pData == NULL)
	{
		Unlock();
		return false;
	}
	pData->GetSiteDetails(piSiteID, NULL, pbPreModeration, psDefaultSkin,
						bNoAutoSwitch, psDescription, psShortName, psModeratorsEmail,
						psEditorsEmail, psFeedbackEmail,piAutoMessageUserID, pbPassworded,
						pbUnmoderated, pbArticleGuestBookForums, psSiteConfig,
						piThreadOrder, psEMailAlertSubject, piThreadEditTimeLimit, piEventAlertMessageUserID, piAllowRemoveUsers, 
						piIncludeCrumbtrail, piAllowPostCodesInSearch, pbQueuePostings, pbSiteEmergencyClosed,
						pSSOService );
	Unlock();
	return true;
}

/*********************************************************************************

	bool CSiteList::AddSiteDetails(const TDVCHAR *pName, int iSiteID, bool bPreModeration, const TDVCHAR *pDefaultSkin)

	Author:		Jim Lynn
	Created:	23/07/2001
	Inputs:		pName - name of site to add
				iSiteID - int ID of site
				bPreModeration - true if site is premoderated, false if not
				pDefaultSkin - name of the site's default skin
				bNoAutoSwitch - false if links to pages outside the current site will
								invisible switch to that site.
								true if viewing other sites in this skin will show an
								intermediate page (under site control) which can either give a 
								link to the page, or prevent access to it altogether.
				pModeratorsEmail - moderators email for the site
				pEditorsEmail - editors email for the site
				pFeedbackEmail - feedback email for the site
				int iAutoMessageUserID - AutoMessageUserID for the Site
	Outputs:	-
	Returns:	true if added, false if not - the site might already have been added
	Purpose:	Adds a new site and its details to the site list. Doesn't add any
				skin names to the site's skin list but it does specify the name of the default
				skin.

*********************************************************************************/

bool CSiteList::AddSiteDetails(const TDVCHAR *pName, int iSiteID, bool bPreModeration, 
							   const TDVCHAR *pDefaultSkin, bool bNoAutoSwitch, 
							   const TDVCHAR* pDescription, const TDVCHAR* pShortName,
							   const TDVCHAR* pModeratorsEmail,
							   const TDVCHAR* pEditorsEmail,
							   const TDVCHAR* pFeedbackEmail,
							   int iAutoMessageUserID, bool bPassworded, bool bUnmoderated,
							   bool bArticleGuestBookForums, const TDVCHAR* pSiteConfig, int iThreadOrder,
							   const TDVCHAR* psEMailAlertSubject,
							   int iThreadEditTimeLimit, int iEventAlertMessageUserID, int iAllowRemoveVote, int iIncludeCrumbtrail, 
							   int iAllowPostCodesInSearch, bool bQueuePostings, bool bSiteEmergencyClosed,
							   int iMinAge, int iMaxAge, const TDVCHAR* pSSOService, bool bIsKidsSite, bool bUseIdentitySignIn,
							   const TDVCHAR* pSkinSet, const TDVCHAR* psIdentityPolicy )
{
	Lock();
	if (m_SiteIDMap[iSiteID] != NULL)
	{
		TDVASSERT(false, "Attempt to insert same site twice");
		Unlock();
		return false;
	}
	try
	{
		CSiteData* pData = new CSiteData(pName, iSiteID, iThreadOrder, bPreModeration, pDefaultSkin, 
										bNoAutoSwitch, pDescription, pShortName,
										pModeratorsEmail, pEditorsEmail,
										pFeedbackEmail,iAutoMessageUserID, bPassworded,
										bUnmoderated, bArticleGuestBookForums,
										pSiteConfig, psEMailAlertSubject, iThreadEditTimeLimit, 
										iEventAlertMessageUserID, iAllowRemoveVote, iIncludeCrumbtrail,
										iAllowPostCodesInSearch, bQueuePostings, bSiteEmergencyClosed,
										iMinAge, iMaxAge, pSSOService, bIsKidsSite, bUseIdentitySignIn,
										pSkinSet, psIdentityPolicy );

		m_SiteMap[CTDVString(pName)] = pData;
		m_SiteIDMap[iSiteID] = pData;
		if (iSiteID > m_MaxSiteId)
		{
			m_MaxSiteId = iSiteID;
		}
		Unlock();
		return true;
	}
	catch(...)
	{
		Unlock();
		return false;
	}
}

int CSiteList::GetMaxSiteId()
{
	return m_MaxSiteId;
}

const void CSiteList::Lock()
{
	EnterCriticalSection(&m_criticalsection);
}

const void CSiteList::Unlock()
{
	LeaveCriticalSection(&m_criticalsection);
}

/*
void CSiteList::Copy(CSiteList &other)
{
	// Make sure the other one can't get destroyed while we read the data from it
	other.Lock();
	try
	{
		SITENAMEMAP::iterator MapIt;
		for (MapIt = other.m_SiteMap.begin(); MapIt != other.m_SiteMap.end();MapIt++)
		{
			CSiteData* pNew = new CSiteData(*((*MapIt).second));
			m_SiteMap[(*MapIt).first] = (*MapIt).second;
		}
	}
	catch(...)
	{
	}
	other.Unlock();
}

*/

void CSiteList::SwapData(CSiteList& other)
{
	Lock();
	other.Lock();
	m_SiteIDMap.swap(other.m_SiteIDMap);
	m_SiteMap.swap(other.m_SiteMap);
	other.Unlock();
	Unlock();
}


/*********************************************************************************

	bool CSiteList::AddSkinToSite(const TDVCHAR *pSiteName, const TDVCHAR* pSkinName, const TDVCHAR *pSkinDescription)

	Author:		Jim Lynn
	Created:	23/07/2001
	Inputs:		pSiteName - name of site we're adding a skin to
				pSkinName - name of skin we're adding to this site
				pSkinDescription - longer skin description for menus and dropdowns
	Outputs:	-
	Returns:	true if skin added, false if not (skin already exists or site does not exist)
	Purpose:	Adds a new skin name and description to the named site. Sites can have
				multiple skins, but only a skin known by the site can be used to 
				display that site's pages.

*********************************************************************************/

bool CSiteList::AddSkinToSite(const TDVCHAR *pSiteName, const TDVCHAR* pSkinName, const TDVCHAR *pSkinDescription, bool bUseFrames)
{
	Lock();
	CSiteData* pData = m_SiteMap[CTDVString(pSiteName)];
	if (pData == NULL)
	{
		Unlock();
		return false;
	}
	bool bSuccess = pData->AddSkin(pSkinName, pSkinDescription, bUseFrames);
	Unlock();
	return bSuccess;
}

/*********************************************************************************

	bool CSiteList::SkinExistsInSite(int iSiteID, const TDVCHAR *pSkinName)

	Author:		Jim Lynn
	Created:	19/07/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Given a SiteID, see if the named skin exists for that site

*********************************************************************************/

bool CSiteList::SkinExistsInSite(int iSiteID, const TDVCHAR *pSkinName)
{
	bool bResult;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		bResult = false;
	}
	else
	{
		// CTDVString sSkinName = CHTMLTransformer::GetRealSkinName(pSkinName);
		bResult = pData->SkinExists(pSkinName);
	}
	Unlock();
	return bResult;
}

bool CSiteList::GetSkinSet(int iSiteID, CTDVString* pSkinSet )
{
	bool bResult = false;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
    if ( pData )
    {
        bResult = pData->GetSkinSet(pSkinSet);
	}
	Unlock();
	return bResult;
}



bool CSiteList::Clear()
{
	Lock();
	SITENAMEMAP::iterator MapIt;
	for (MapIt = m_SiteMap.begin(); MapIt != m_SiteMap.end();MapIt++)
	{
		CSiteData* pd = (*MapIt).second;
		delete (*MapIt).second;
	}
	m_SiteMap.clear();
	m_SiteIDMap.clear();
	Unlock();
	return true;
}

bool CSiteList::GetSiteDetails(int iSiteID, CTDVString* psSiteName, bool* pbPreMod, 
							   CTDVString* psSkin, bool* pbNoAutoSwitch, 
							   CTDVString* psDescription, CTDVString* psShortName, 
							   CTDVString* psModeratorsEmail,
							   CTDVString* psEditorsEmail, CTDVString* psFeedbackEmail,
							   int *piAutoMessageUserID, bool* pbPassworded, bool* pbUnmoderated,
							   bool* pbArticleGuestBookForums, CTDVString* psSiteConfig, int iThreadOrder,
							   CTDVString* psEMailAlertSubject, int* piThreadEditTimeLimit, 
							   int* piEventAlertMessageUserID, int iAllowRemoveVote, int iIncludeCrumbtrail,
							   int iAllowPostCodesInSearch, bool bSiteEmergencyClosed, CTDVString* psSSOService )
{
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		Unlock();
		return false;
	}
	pData->GetSiteDetails(NULL, psSiteName, pbPreMod, psSkin, pbNoAutoSwitch, 
						psDescription, psShortName, psModeratorsEmail, psEditorsEmail,
						psFeedbackEmail,piAutoMessageUserID, pbPassworded, pbUnmoderated,
						pbArticleGuestBookForums, psSiteConfig, &iThreadOrder, psEMailAlertSubject, 
						piThreadEditTimeLimit, piEventAlertMessageUserID, &iAllowRemoveVote,
						&iIncludeCrumbtrail, &iAllowPostCodesInSearch, NULL, &bSiteEmergencyClosed, psSSOService );
	Unlock();
	return true;
}

bool CSiteList::GetNameOfSite(int iSiteID, CTDVString* oName)
{
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		Unlock();
		return false;
	}
	else
	{
		pData->GetSiteName(oName);
		Unlock();
		return true;
	}
}

/*********************************************************************************

	bool CSiteList::GetSSOService

	Author:		Martin Robb
	Created:	27/11/2006
	Inputs:		- iSiteId - siteid
	Outputs:	- SSOService for the siteid concerned.
	Returns:	-
	Purpose:	Gets the SSO Service for the site id. 
				A site may not necessarily have an exclusive SSO service.

*********************************************************************************/
bool CSiteList::GetSSOService(int iSiteID, CTDVString* pSSOService)
{
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		Unlock();
		return false;
	}
	else
	{
		pData->GetSSOService(pSSOService);
		Unlock();
		return true;
	}
}

/*********************************************************************************

	bool CSiteList::GetEmail(int iSiteID, int iEmailType, CTDVString& sEmail) const

	Author:		Igor Loboda
	Created:	22/02/2002
	Inputs:		iEmailType - email type id 
				iSiteID - site id
	Outputs:	sEmail - email of specified type for the specified site
	Returns:	-
	Purpose:	Given a SiteID and email type, gets the email

*********************************************************************************/
bool CSiteList::GetEmail(int iSiteID, int iEmailType, CTDVString& sEmail)
{
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		Unlock();
		return false;
	}
	else
	{
		pData->GetEmail(iEmailType, sEmail);
		Unlock();
		return true;
	}
}

/*********************************************************************************

	bool CSiteList::GetShortName(int iSiteID, CTDVString& sShortName) const

	Author:		Igor Loboda
	Created:	22/02/2002
	Inputs:		iEmailType - email type id 
				iSiteID - site id
	Outputs:	sEmail - email of specified type for the specified site
	Returns:	-
	Purpose:	Given a SiteID and email type, gets the email

*********************************************************************************/
bool CSiteList::GetShortName(int iSiteID, CTDVString& sShortName)
{
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		Unlock();
		return false;
	}
	else
	{
		pData->GetShortName(&sShortName);
		Unlock();
		return true;
	}
}

bool CSiteList::GetAsXMLString(CTDVString* oXML, int iMode)
{
	*oXML << "<SITE-LIST>";
	/*
		<SITE-LIST>
			<SITE ID="1">
				<NAME>h2g2</NAME>
				<DESCRIPTION>The Hitchhiker's Guide...</DESCRIPTION>
			</SITE>
			...
		</SITE-LIST>
	*/
	Lock();
	SITENAMEMAP::iterator MapIt;
	for (MapIt = m_SiteMap.begin(); MapIt != m_SiteMap.end();MapIt++)
	{
		CSiteData* pd = (*MapIt).second;
		if (pd != NULL)
		{
			pd->GetAsXMLString(oXML, iMode);
		}
	}
	*oXML << "</SITE-LIST>";
	Unlock();
	return true;
}

/*********************************************************************************

	bool CSiteList::GetSiteAsXMLString(int iSiteID, CTDVString& sXML, int iMode)

		Author:		Mark Neves
        Created:	15/02/2005
        Inputs:		iSiteID = the site
					iMode = 1 or 2 (changes content of XML slightly) 
        Outputs:	sXML contains the XML for the site
        Returns:	-
        Purpose:	Gets the site info as XML

					See CSiteData::GetAsXMLString() for more details

*********************************************************************************/

bool CSiteList::GetSiteAsXMLString(int iSiteID, CTDVString& sXML, int iMode)
{
	bool bResult = false;
	sXML.Empty();

	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		bResult = false;
	}
	else
	{
		bResult = pData->GetAsXMLString(&sXML,iMode);
	}
	Unlock();

	return bResult;
}

bool CSiteList::GetSkinUseFrames(int iSiteID, const TDVCHAR* pSkinName)
{
	bool bResult;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		bResult = false;
	}
	else
	{
		bResult = pData->GetSkinUseFrames(pSkinName);
	}
	Unlock();
	return bResult;
}

bool CSiteList::GetTopicsXML( int iSiteID, CTDVString& sSource )
{
	bool bSuccess = false;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if ( pData )
	{
		bSuccess = pData->GetTopicsXML(&sSource);
	}

	Unlock();
	return bSuccess;
}

bool CSiteList::SetTopicsXML( int iSiteID, const CTDVString& sSource )
{
	bool bSuccess = false;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if ( pData )
	{
		bSuccess = pData->SetTopicsXML(&sSource);
	}

	Unlock();
	return bSuccess;
}


bool CSiteList::AddArticle(int iSiteID, const TDVCHAR* pArticleName)
{
	bool bResult;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		bResult = false;
	}
	else
	{
		bResult = pData->AddArticle(pArticleName);
	}
	Unlock();
	return bResult;
}

bool CSiteList::AddReviewForum(int iSiteID, const TDVCHAR* pForumName, int iForumID)
{
	bool bResult;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		bResult = false;
	}
	else
	{
		bResult = pData->AddReviewForum(pForumName, iForumID);
	}
	Unlock();
	return bResult;
}

int CSiteList::GetReviewForumID(int iSiteID, const TDVCHAR* pForumName)
{
	int iResult;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		iResult = 0;
	}
	else
	{
		iResult = pData->GetReviewForumID(pForumName);
	}
	Unlock();
	return iResult;
}

/*********************************************************************************

	int CSiteList::GetAutoMessageUserID(int iSiteID)

	Author:		Dharmesh Raithatha
	Created:	03/04/2002
	Inputs:		iSiteID - site id
	Outputs:	
	Returns:	AutoMessageUserId or 0 if none found
	Purpose:	Given a SiteID gets the AutoMessageUserId  

*********************************************************************************/

int CSiteList::GetAutoMessageUserID(int iSiteID)
{
	int iResult;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		iResult = 0;
	}
	else
	{
		iResult = pData->GetAutoMessageUserID();
	}
	Unlock();
	return iResult;
}

bool CSiteList::DoesArticleExist(int iSiteID, const TDVCHAR* pArticleName)
{
	bool bResult;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		bResult = false;
	}
	else
	{
		bResult = pData->DoesArticleExist(pArticleName);
	}
	Unlock();
	return bResult;
}

bool CSiteList::GetIsSitePassworded(int iSiteID)
{
	bool bResult;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		bResult = false;
	}
	else
	{
		bResult = pData->IsSitePassworded();
	}
	Unlock();
	return bResult;
}

bool CSiteList::DoesSiteUseArticleGuestBookForums(int iSiteID)
{
	bool bResult;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		bResult = false;
	}
	else
	{
		bResult = pData->DoesSiteUseArticleGuestBookForums();
	}
	Unlock();
	return bResult;
}


bool CSiteList::GetNoAutoSwitch(int iSiteID)
{
	bool bResult;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		bResult = false;
	}
	else
	{
		bResult = pData->GetNoAutoSwitch();
	}
	Unlock();
	return bResult;
}

bool CSiteList::GetIsSiteUnmoderated(int iSiteID)
{
	bool bResult;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		bResult = false;
	}
	else
	{
		bResult = pData->IsSiteUnmoderated();
	}
	Unlock();
	return bResult;
}

/*********************************************************************************

	bool CSiteList::GetSiteEMailAlertSubject(int iSiteID, CTDVString& sEmailAlertSubject)

		Author:		Mark Howitt
        Created:	22/09/2004
        Inputs:		iSiteID - the ID of the site you what to get the email subject from
        Outputs:	psEMailAlertSubject - The string that will take the value
        Returns:	true if ok, false if not
        Purpose:	Gets the Subject for the email alert system for a given site

*********************************************************************************/
bool CSiteList::GetSiteEMailAlertSubject(int iSiteID, CTDVString& sEmailAlertSubject)
{
	// Lock the thread so we know we've got full control
	Lock();

	// Get the site data pointer for the given site and check for NULL!
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		Unlock();
		return false;
	}
	else
	{
		// Call the function, unlock and return
		bool bOk = pData->GetEMailAlertSubject(sEmailAlertSubject);
		Unlock();
		return bOk;
	}
}

bool CSiteList::GetEventAlertMessageUserID(int iSiteID, int& iUserID)
{
	// Lock the thread so we know we've got full control
	Lock();

	// Get the site data pointer for the given site and check for NULL!
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		Unlock();
		return false;
	}
	else
	{
		// Call the function, unlock and return
		iUserID = pData->GetEventAlertMessageUserID();
		Unlock();
		return true;
	}
}

/*********************************************************************************

	int CSiteList::GetSiteID(const TDVCHAR* pSiteName)

		Author:		Mark Neves
        Created:	15/02/2005
        Inputs:		const TDVCHAR* pSiteName
        Outputs:	-
        Returns:	The site ID of the site pSiteName, 0 if not found
        Purpose:	Finds the site ID, given the name of the site

*********************************************************************************/

int CSiteList::GetSiteID(const TDVCHAR* pSiteName)
{
	int iSiteID = 0;

	// Lock the thread so we know we've got full control
	Lock();

	// Get the site data pointer for the given site and check for NULL!
	CSiteData* pData = m_SiteMap[pSiteName];
	if (pData != NULL)
	{
		iSiteID = pData->GetSiteID();
	}

	Unlock();
	return iSiteID;
}

bool CSiteList::AddTopicForum(int iSiteID, int iForumID)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];

	if (pData == NULL)
	{
		return false;
	}
	else
	{
		return pData->AddTopicForum(iForumID);
	}
}

bool CSiteList::IsForumATopic(int iSiteID, int iForumID)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];

	if (pData == NULL)
	{
		return false;
	}
	else
	{
		return pData->IsForumATopic(iForumID);
	}
}

/*********************************************************************************

	bool CSiteList::AddSiteOpenCloseTime(int iSiteID, int iDayWeek, int iHour, int iMinute, int iClosed)

		Author:		Mark Howitt
		Created:	20/07/2006
		Inputs:		iSiteID - The site that you want to add the new schedule for.
					iDayWeek - The day of the week the event is for.
					iHour - The hour for the event.
					iMinute - The minute for the event.
					iClosed - The status the site will be in at this time. Closed or Open
		Outputs:	-
		Returns:	true if ok, false if not
		Purpose:	Adds a new open / close time for a given site

*********************************************************************************/
bool CSiteList::AddSiteOpenCloseTime(int iSiteID, int iDayWeek, int iHour, int iMinute, int iClosed)
{
	bool bResult = false;
	Lock();
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData != NULL)
	{
		bResult = pData->AddSiteOpenCloseTime(iDayWeek, iHour, iMinute, iClosed);
	}
	Unlock();
	return bResult;
}

/*********************************************************************************

	bool CSiteList::GetSiteScheduledClosed(int iSiteID, bool &bIsClosed)

		Author:		Mark Howitt
		Created:	20/07/2006
		Inputs:		iSiteID - The site that you want to get the schedule for.
		Outputs:	bIsClosed - The current closed status for the site
		Returns:	true if ok, false if not
		Purpose:	Gets the open / closed schedule for a given site.

*********************************************************************************/
bool CSiteList::GetSiteScheduledClosed(int iSiteID, bool &bIsClosed)
{
	CTDVDateTime dCurrentDate(COleDateTime::GetCurrentTime());
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		return false;
	}
	else
	{
		bIsClosed = pData->GetSiteScheduledClosed(dCurrentDate);
		return true;
	}
}

/*********************************************************************************

	bool CSiteList::GetSiteScheduleAsXMLString(int iSiteID, CTDVString& sXML)

		Author:		Mark Howitt
		Created:	20/07/2006
		Inputs:		iSiteID - The site that you want to get the XML Schedule for.
		Outputs:	sXML - A String that will contain the XML for the scheduled events
		Returns:	true if ok, false if not
		Purpose:	Gets the scheduled events for a given site in XML form.

*********************************************************************************/
bool CSiteList::GetSiteScheduleAsXMLString(int iSiteID, CTDVString& sXML)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		return false;
	}
	else
	{
		return pData->GetSiteScheduleAsXMLString(sXML);
	}
}

/*********************************************************************************

	bool CSiteList::IsSiteEmergencyClosed(int iSiteID, bool &bIsClosed)

		Author:		Mark Howitt
		Created:	21/07/2006
		Inputs:		iSiteID - The site that you want to know is emergency closed or not
		Outputs:	bIsClosed - Takes the current emergency closed status for the site.
		Returns:	true if ok, false if not
		Purpose:	Gets the emergency closed status for a given site

*********************************************************************************/
bool CSiteList::IsSiteEmergencyClosed(int iSiteID, bool &bIsClosed)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		return false;
	}
	else
	{
		bIsClosed = pData->IsSiteEmergencyClosed();
		return true;
	}
}

/*********************************************************************************

	bool CSiteList::SetSiteIsEmergencyClosed(int iSiteID, bool bEmergencyClosed)

		Author:		Mark Howitt
		Created:	21/07/2006
		Inputs:		iSIteID - the site that you want to set the emergency closed status for
					bEmergencyClosed - The new emergency closed satus for the site
		Outputs:	-
		Returns:	true if ok, false if not
		Purpose:	Sets the sites emergency closed status

*********************************************************************************/
bool CSiteList::SetSiteIsEmergencyClosed(int iSiteID, bool bEmergencyClosed)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		return false;
	}
	else
	{
		pData->SetSiteEmergencyClosed(bEmergencyClosed);
		return true;
	}
}

/*********************************************************************************

	int CSiteList::GetSiteMinAge(int iSiteID)

		Author:		Mark Neves
		Created:	25/09/2006
		Inputs:		iSiteID = the site id
		Outputs:	-
		Returns:	The min age for this site
		Purpose:	Gets the min age for people accessing this site, as defined in the SSO db.

*********************************************************************************/

int CSiteList::GetSiteMinAge(int iSiteID)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		return false;
	}
	else
	{
		return pData->GetMinAge();
	}
}

/*********************************************************************************

	int CSiteList::GetSiteMaxAge(int iSiteID)

		Author:		Mark Neves
		Created:	25/09/2006
		Inputs:		iSiteID = the site id
		Outputs:	-
		Returns:	The max age for this site
		Purpose:	Gets the max age for people accessing this site, as defined in the SSO db.

*********************************************************************************/

int CSiteList::GetSiteMaxAge(int iSiteID)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData == NULL)
	{
		return false;
	}
	else
	{
		return pData->GetMaxAge();
	}
}

void CSiteList::SetSiteMinMaxAge(int iSiteID, int minAge, int maxAge)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData != NULL)
	{
		pData->SetMinMaxAge(minAge, maxAge);
	}
}

void CSiteList::SetSiteUsesIdentitySignIn(int iSiteID, bool bUseIdentity)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData != NULL)
	{
		pData->SetUseIdentitySignIn(bUseIdentity);
	}
}

bool CSiteList::GetSiteUsesIdentitySignIn(int iSiteID)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData != NULL)
	{
		return pData->GetUseIdentitySignIn();
	}
	return false;
}

void CSiteList::SetSiteIdentityPolicy(int iSiteID, const TDVCHAR* psIdentityPolicy)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData != NULL)
	{
		pData->SetSiteIdentityPolicy(psIdentityPolicy);
	}
}

CTDVString CSiteList::GetSiteIdentityPolicy(int iSiteID)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData != NULL)
	{
		return pData->GetSiteIdentityPolicy();
	}
	return "";
}

void CSiteList::SetSiteIsKidsSite(int iSiteID, bool bIsKidsSite)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData != NULL)
	{
		pData->SetIsKidsSite(bIsKidsSite);
	}
}

bool CSiteList::GetSiteIsKidsSite(int iSiteID)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData != NULL)
	{
		return pData->GetIsKidsSite();
	}
	return false;
}

/*********************************************************************************

	CTDVString CSiteList::GetSiteInfomationXML(int iSiteID, CGI* pCGI)

		Author:		Mark Howitt
		Created:	23/07/2008
		Inputs:		iSiteID - The id of the site you want to get the Information for.
					pCGI - The current cgi object
		Returns:	The XML as a string
		Purpose:	Gets the site information as XML. This contains sitename, ssoservice,
						minage, maxage, siteoptions... This is found on every page.

*********************************************************************************/
CTDVString CSiteList::GetSiteInfomationXML(int iSiteID, CGI* pCGI)
{
	CSiteData* pData = m_SiteIDMap[iSiteID];
	if (pData != NULL)
	{
		return pData->GetSiteInfomationXML(pCGI);
	}
	return "";
}