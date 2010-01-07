// SiteData.cpp: implementation of the CSiteData class.
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
#include "SiteOptions.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSiteData::CSiteData(	const TDVCHAR* pSiteName, 
						int iSiteID, 
						int iThreadOrder,
						bool bPreModeration, 
						const TDVCHAR* pDefaultSkin, 
						bool bNoAutoSwitch,
						const TDVCHAR* pDescription,
						const TDVCHAR* pShortName,
						const TDVCHAR* pModeratorsEmail,
						const TDVCHAR* pEditorsEmail,
						const TDVCHAR* pFeedbackEmail,
						int iAutoMessageUserID,
						bool bPassworded,
						bool bUnmoderated,
						bool bArticleGuestBookForums,
						const TDVCHAR* pSiteConfig,
						const TDVCHAR* psEMailAlertSubject,
						int iThreadEditTimeLimit,
						int iEventAlertMessageUserID,
						int iAllowRemoveVote,
						int iIncludeCrumbtrail,
						int iAllowPostCodesInSearch,
						bool bQueuePostings,
						bool bSiteEmergencyClosed,
						int iMinAge,
						int iMaxAge,
						const TDVCHAR* pSSOService,
						bool bIsKidsSite,
						bool bUseIdentitySignIn,
						const TDVCHAR* pSkinSet,
						const TDVCHAR* psIdentityPolicy
						)
						: 
						m_SiteName(pSiteName), 
						m_SiteID(iSiteID),
						m_SSOService(pSSOService),
						m_ThreadOrder(iThreadOrder),
						m_AllowRemoveVote(iAllowRemoveVote),
						m_bPreModeration(bPreModeration),
						m_DefaultSkin(pDefaultSkin),
						m_bNoAutoSwitch(bNoAutoSwitch),
						m_Description(pDescription),
						m_ShortName(pShortName),
						m_ModeratorsEmail(pModeratorsEmail),
						m_EditorsEmail(pEditorsEmail),
						m_FeedbackEmail(pFeedbackEmail),
						m_AutoMessageUserID(iAutoMessageUserID),
						m_bPassworded(bPassworded),
						m_bUnmoderated(bUnmoderated),
						m_bArticleGuestBookForums(bArticleGuestBookForums),
						m_sSiteConfig(pSiteConfig),
						m_sEMailAlertSubject(psEMailAlertSubject),
						m_ThreadEditTimeLimit(iThreadEditTimeLimit),
						m_iEventAlertMessageUserID(iEventAlertMessageUserID), 
						m_IncludeCrumbtrail(iIncludeCrumbtrail),
						m_AllowPostCodesInSearch(iAllowPostCodesInSearch),
						m_bQueuePostings(bQueuePostings),
						m_bSiteEmergencyClosed(bSiteEmergencyClosed),
						m_iMinAge(iMinAge),
						m_iMaxAge(iMaxAge),
						m_bIsKidsSite(bIsKidsSite),
						m_bUseIdentitySignIn(bUseIdentitySignIn),
						m_SkinSet(pSkinSet),
						m_sIdentityPolicy(psIdentityPolicy)
{

}

CSiteData::CSiteData(const CSiteData& Other)
{
	//Default - Default generated one would do!
	*this = Other;
	/*
	m_SiteName = Other.m_SiteName;
	m_SiteID = Other.m_SiteID;
	m_bPreModeration = Other.m_bPreModeration;
	m_DefaultSkin = Other.m_DefaultSkin;
	m_bNoAutoSwitch = Other.m_bNoAutoSwitch;
	m_Description = Other.m_Description;
	m_ShortName = Other.m_ShortName;
	m_ModeratorsEmail = Other.m_ModeratorsEmail;
	m_EditorsEmail = Other.m_EditorsEmail;
	*/
}

//Default assignement operator - Default generated one would do too.
const CSiteData& CSiteData::operator=(const CSiteData& Other)
{
	m_SiteName = Other.m_SiteName;
	m_SiteID = Other.m_SiteID;
	m_bPreModeration = Other.m_bPreModeration;
	m_DefaultSkin = Other.m_DefaultSkin;
	m_bNoAutoSwitch = Other.m_bNoAutoSwitch;
	m_Description = Other.m_Description;
	m_ShortName = Other.m_ShortName;
	m_ModeratorsEmail = Other.m_ModeratorsEmail;
	m_EditorsEmail = Other.m_EditorsEmail;
	m_FeedbackEmail = Other.m_FeedbackEmail;
	m_AutoMessageUserID = Other.m_AutoMessageUserID;
	m_bPassworded = Other.m_bPassworded;
	m_bUnmoderated = Other.m_bUnmoderated;
	m_bArticleGuestBookForums = Other.m_bArticleGuestBookForums;
	m_sSiteConfig = Other.m_sSiteConfig;
	m_ThreadOrder = Other.m_ThreadOrder;
	m_sEMailAlertSubject = Other.m_sEMailAlertSubject;
	m_iEventAlertMessageUserID = Other.m_iEventAlertMessageUserID;
	m_ThreadEditTimeLimit = Other.m_ThreadEditTimeLimit;
	m_AllowRemoveVote = Other.m_AllowRemoveVote;
	m_sTopicsXML = Other.m_sTopicsXML;
	m_IncludeCrumbtrail = Other.m_IncludeCrumbtrail;
	m_AllowPostCodesInSearch = Other.m_AllowPostCodesInSearch;
	m_bQueuePostings = Other.m_bQueuePostings;
	m_bSiteEmergencyClosed = Other.m_bSiteEmergencyClosed;
	m_SSOService = Other.m_SSOService;
	m_bIsKidsSite = Other.m_bIsKidsSite,
	m_bUseIdentitySignIn = Other.m_bUseIdentitySignIn;
	m_SkinSet = Other.m_SkinSet;
	m_sIdentityPolicy = Other.m_sIdentityPolicy;
	return *this;
}

CSiteData::~CSiteData()
{
	SKINMAP::iterator MapIt;
	for (MapIt = m_SkinMap.begin(); MapIt != m_SkinMap.end();MapIt++)
	{
		CSkinDetails* pd = (*MapIt).second;
		delete (*MapIt).second;
	}
	m_SkinMap.clear();
	m_ForumMap.clear();
	m_ArticleMap.clear();
}

int CSiteData::GetAutoMessageUserID() const
{
	return m_AutoMessageUserID;
}

int CSiteData::GetSiteID()
{
	return m_SiteID;
}

int CSiteData::GetThreadOrder()
{
	return m_ThreadOrder;
}

int CSiteData::GetAllowRemoveVote()
{
	return m_AllowRemoveVote;
}
int CSiteData::GetIncludeCrumbtrail()
{
	return m_IncludeCrumbtrail;
}
int CSiteData::GetAllowPostCodesInSearch()
{
	return m_AllowPostCodesInSearch;
}

int CSiteData::GetThreadEditTimeLimit()
{
	return m_ThreadEditTimeLimit;
}

bool CSiteData::GetPreModeration()
{
	return m_bPreModeration;
}

bool CSiteData::GetDefaultSkin(CTDVString *oName)
{
	*oName = m_DefaultSkin;
	return true;
}

bool CSiteData::AddSkin(const TDVCHAR *pSkinName, const TDVCHAR *pSkinDescription, bool bUseFrames)
{
	CSkinDetails* pDetails = new CSkinDetails(pSkinName, pSkinDescription, bUseFrames);
	CTDVString sName = pSkinName;
	sName.MakeUpper();
	m_SkinMap[sName] = pDetails;
	return true;
}

/*********************************************************************************

	bool CSiteData::SkinExists(const TDVCHAR *pSkinName)

	Author:		Jim Lynn
	Created:	19/07/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Does the named skin exist in this site?

*********************************************************************************/

bool CSiteData::SkinExists(const TDVCHAR *pSkinName)
{
	CTDVString sName = pSkinName;
	sName.MakeUpper();
	if (m_SkinMap[sName] != NULL)
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool CSiteData::GetSiteName(CTDVString *oName)
{
	*oName = m_SiteName;
	return true;
}

bool CSiteData::GetNoAutoSwitch()
{
	return m_bNoAutoSwitch;
}


bool CSiteData::GetAsXMLString(CTDVString *oXML, int iMode)
{
	*oXML << "<SITE ID='" << m_SiteID << "'>";

	if (iMode == 1)
	{
		*oXML << "<NAME>" << m_SiteName << "</NAME>";
		*oXML << "<DESCRIPTION>" << m_Description << "</DESCRIPTION>";
		*oXML << "<SHORTNAME>" << m_ShortName << "</SHORTNAME>";
	}
	else
	if (iMode == 2)
	{
		*oXML << "<NAME>" << m_SiteName << "</NAME>";
		*oXML << "<SHORTNAME>" << m_ShortName << "</SHORTNAME>";
		*oXML << "<PREMODERATION>" << m_bPreModeration << "</PREMODERATION>";
		*oXML << "<OFFSITELINKS>" << !m_bNoAutoSwitch << "</OFFSITELINKS>";
	}
	*oXML << "</SITE>";
	return true;
}

bool CSiteData::GetDescription(CTDVString *oDescription)
{
	*oDescription = m_Description;
	return true;
}

bool CSiteData::GetShortName(CTDVString *oName)
{
	*oName = m_ShortName;
	return true;
}

bool CSiteData::GetSSOService(CTDVString *pSSOService)
{
	if ( pSSOService == NULL )
		return false;

	*pSSOService = m_SSOService;
	return true;
}

bool CSiteData::GetSkinUseFrames(const TDVCHAR *pSkinName)
{
	CTDVString sName = pSkinName;
	sName.MakeUpper();
	if (m_SkinMap[sName] != NULL)
	{
		return m_SkinMap[sName]->GetUseFrames();
	}
	else
	{
		return false;
	}
}

bool CSiteData::AddArticle(const TDVCHAR *pName)
{
	CTDVString sName = pName;
	sName.MakeUpper();
	m_ArticleMap[sName] = 1;
	return true;
}

bool CSiteData::AddReviewForum(const TDVCHAR *pForumName, int iForumID)
{
	CTDVString sName = pForumName;
	sName.MakeUpper();
	m_ForumMap[sName] = iForumID;
	return true;
}

int CSiteData::GetReviewForumID(const TDVCHAR *pName)
{
	CTDVString sName = pName;
	sName.MakeUpper();
	if (m_ForumMap.find(sName) != m_ForumMap.end())
	{
		return m_ForumMap[sName];
	}
	else
	{
		return 0;
	}
}

bool CSiteData::DoesArticleExist(const TDVCHAR *pName)
{
	ARTICLEMAP::iterator MapIt;
	CTDVString sName = pName;
	sName.MakeUpper();
	if (m_ArticleMap.find(sName) != m_ArticleMap.end())
	{
		return true;
	}
	else
	{
		return false;
	}

}

/*********************************************************************************

	bool CSiteData::GetEmail(int iEmailType, CTDVString* pEmail)

	Author:		Igor Loboda
	Created:	22/02/2002
	Inputs:		iEmailType - type of email address to return. see EMAIL_.. constants
	Outputs:	pEmail - moderators email for this site
	Returns:	-
	Purpose:	Returns email of requested type

*********************************************************************************/
bool CSiteData::GetEmail(int iEmailType, CTDVString& pEmail) const
{
	switch (iEmailType)
	{
		case EMAIL_MODERATORS:
			pEmail = m_ModeratorsEmail;
		break;
		case EMAIL_EDITORS:
			pEmail = m_EditorsEmail;
		break;
		case EMAIL_FEEDBACK:
			pEmail = m_FeedbackEmail;
		break;
	}
	return true;
}

/*********************************************************************************

	CTDVString CSiteData::GetTopicsXML()

	Author:		Igor Loboda
	Created:	22/02/2002
	Inputs:		iEmailType - type of email address to return. see EMAIL_.. constants
	Outputs:	pEmail - moderators email for this site
	Returns:	-
	Purpose:	Returns email of requested type

*********************************************************************************/
bool CSiteData::GetTopicsXML( CTDVString* psSource ) const
{
	*psSource = m_sTopicsXML;
	return true;
}

/*********************************************************************************

	CTDVString CSiteData::GetTopicsXML()

	Author:		Igor Loboda
	Created:	22/02/2002
	Inputs:		iEmailType - type of email address to return. see EMAIL_.. constants
	Outputs:	pEmail - moderators email for this site
	Returns:	-
	Purpose:	Returns email of requested type

*********************************************************************************/
bool CSiteData::SetTopicsXML( const CTDVString* psTopics )
{
	m_sTopicsXML = *psTopics;
	return true;
}

/*********************************************************************************

	void CSiteData::GetSiteDetails(CSiteData* pData, 
								CTDVString* psSiteName, bool *pbPreMod, 
								CTDVString* psSkin, bool* pbNoAutoSwitch, 
								CTDVString* psDescription, CTDVString* psShortName, 
								CTDVString* psModeratorsEmail,
								CTDVString* psEditorsEmail, 
								CTDVString* psFeedbackEmail,
								int* piAutoMessageUserID,
								bool* pbPassworded)
	Author:		Igor Loboda
	Created:	22/02/2002
	History:	03/04/2002	DR	Added piAutoMessageUserID
	Inputs:		-
	Outputs:	site details
	Returns:	-
	Purpose:	returns all site information from this object

*********************************************************************************/
void CSiteData::GetSiteDetails( int* piSiteID, CTDVString* psSiteName, bool *pbPreMod, 
								CTDVString* psSkin, bool* pbNoAutoSwitch, 
								CTDVString* psDescription, CTDVString* psShortName, 
								CTDVString* psModeratorsEmail,
								CTDVString* psEditorsEmail, 
								CTDVString* psFeedbackEmail,
								int* piAutoMessageUserID,
								bool* pbPassworded, bool* pbUnmoderated, bool* pbArticleGuestBookForums,
								CTDVString* psSiteConfig, int* piThreadOrder, CTDVString* psEMailAlertSubject,
								int* piThreadEditTimeLimit, int* piEventAlertMessageUserID, int* piAllowRemoveVote, int* piIncludeCrumbtrail, 
								int* piAllowPostCodesInSearch, bool* pbQueuePostings, bool* pbSiteEmergencyClosed, CTDVString* psSSOService )
{
	if (piSiteID)
	{
		*piSiteID = GetSiteID();
	}

	if (psSiteName)
	{
		GetSiteName(psSiteName);
	}
	
	if (pbPreMod)
	{
		*pbPreMod = GetPreModeration();
	}

	if (psSkin)
	{
		GetDefaultSkin(psSkin);
	}

	if (pbNoAutoSwitch)
	{
		*pbNoAutoSwitch = GetNoAutoSwitch();
	}

	if (psDescription)
	{
		GetDescription(psDescription);
	}

	if (psShortName)
	{
		GetShortName(psShortName);
	}

	if (psModeratorsEmail)
	{
		GetEmail(EMAIL_MODERATORS, *psModeratorsEmail);
	}

	if (psEditorsEmail)
	{
		GetEmail(EMAIL_EDITORS, *psEditorsEmail);
	}

	if (psFeedbackEmail)
	{
		GetEmail(EMAIL_FEEDBACK, *psFeedbackEmail);
	}

	if (piAutoMessageUserID)
	{
		*piAutoMessageUserID = GetAutoMessageUserID();
	}

	if (pbPassworded)
	{
		*pbPassworded = IsSitePassworded();
	}
	
	if (pbUnmoderated)
	{
		*pbUnmoderated = IsSiteUnmoderated();
	}
	
	if (pbArticleGuestBookForums)
	{
		*pbArticleGuestBookForums = DoesSiteUseArticleGuestBookForums();
	}
	
	if (psSiteConfig)
	{
		GetSiteConfig(psSiteConfig);
	}
	
	if (piThreadOrder)
	{
		*piThreadOrder = GetThreadOrder();
	}

	if (psEMailAlertSubject != NULL)
	{
		GetEMailAlertSubject(*psEMailAlertSubject);
	}

	if (piThreadEditTimeLimit)
	{
		*piThreadEditTimeLimit = GetThreadEditTimeLimit();
	}

	if (piEventAlertMessageUserID != NULL)
	{
		*piEventAlertMessageUserID = GetEventAlertMessageUserID();
	}

	if(piAllowRemoveVote != NULL)
	{
		*piAllowRemoveVote = GetAllowRemoveVote();
	}

	if(piIncludeCrumbtrail != NULL)
	{
		*piIncludeCrumbtrail = GetIncludeCrumbtrail();
	}

	if(piAllowPostCodesInSearch != NULL)
	{
		*piAllowPostCodesInSearch = GetAllowPostCodesInSearch();
	}

	if (pbQueuePostings != NULL)
	{
		*pbQueuePostings = GetQueuePostings();
	}

	if (pbSiteEmergencyClosed != NULL)
	{
		*pbSiteEmergencyClosed = IsSiteEmergencyClosed();
	}

	if ( psSSOService != NULL )
	{
		GetSSOService(psSSOService);
	}
}


bool CSiteData::IsSitePassworded()
{
	return m_bPassworded;
}

bool CSiteData::IsSiteUnmoderated()
{
	return m_bUnmoderated;
}

bool CSiteData::DoesSiteUseArticleGuestBookForums()
{
	return m_bArticleGuestBookForums;
}

bool CSiteData::GetSiteConfig(CTDVString* psSiteConfig)
{
	if (psSiteConfig != NULL)
	{
		*psSiteConfig = m_sSiteConfig;
		return true;
	}
	return false;
}

bool CSiteData::GetEMailAlertSubject(CTDVString& sEmailAlertSubject)
{
	sEmailAlertSubject = m_sEMailAlertSubject;
	return true;
}

int CSiteData::GetEventAlertMessageUserID()
{
	return m_iEventAlertMessageUserID;
}

bool CSiteData::GetQueuePostings()
{
	return m_bQueuePostings;
}

/*********************************************************************************

	int CSiteData::GetMinAge()

		Author:		Mark Neves
		Created:	25/09/2006
		Inputs:		-
		Outputs:	-
		Returns:	the min age for this site
		Purpose:	Gets the min age for people accessing this site, as defined in the SSO db.

*********************************************************************************/

int CSiteData::GetMinAge()
{
	return m_iMinAge;
}

/*********************************************************************************

	int CSiteData::GetMaxAge()

		Author:		Mark Neves
		Created:	25/09/2006
		Inputs:		-
		Outputs:	-
		Returns:	-
		Purpose:	Gets the max age for people accessing this site, as defined in the SSO db.

*********************************************************************************/

int CSiteData::GetMaxAge()
{
	return m_iMaxAge;
}

void CSiteData::SetMinMaxAge(int minAge, int maxAge)
{
	m_iMinAge = minAge;
	m_iMaxAge = maxAge;
}

/*********************************************************************************

	int CSiteData::GetMaxAge()

		Author:		Mark Howitt
		Created:	08/07/2008
		Returns:	True if the site is a kids site.
		Purpose:	Checks to see if this site is a kids site. 16 or under.

*********************************************************************************/
bool CSiteData::GetIsKidsSite()
{
	return m_bIsKidsSite;
}

/*********************************************************************************

	int CSiteData::GetMaxAge()

		Author:		Mark Howitt
		Created:	08/07/2008
		Inputs:		bIsKidsSite - A flag to state whether or not that this site is a kids site.
		Purpose:	Sets the sites IsKidSite flag

*********************************************************************************/
void CSiteData::SetIsKidsSite(bool bIsKidsSite)
{
	m_bIsKidsSite = bIsKidsSite;
}

/*********************************************************************************

	int CSiteData::GetMaxAge()

		Author:		Mark Howitt
		Created:	08/07/2008
		Returns:	True if the site uses the Identity sign in system, false if it uses SSO
		Purpose:	Checks to see what system the site uses to sign users in with

*********************************************************************************/
bool CSiteData::GetUseIdentitySignIn()
{
	return m_bUseIdentitySignIn;
}

/*********************************************************************************

	int CSiteData::GetMaxAge()

		Author:		Mark Howitt
		Created:	08/07/2008
		Inputs:		bUseIdentity - A flag that states whether or not that this site should
						use Identity to sign users in. Setting it to false will revert back to SSO
		Purpose:	Sets the sign in system that the site should use to sign users in with.

*********************************************************************************/
void CSiteData::SetUseIdentitySignIn(bool bUseIdentity)
{
	m_bUseIdentitySignIn = bUseIdentity;
}

/*********************************************************************************

	void CSiteData::SetSiteIdentityPolicy(const TDVCHAR* psIdentityPolicy)

		Author:		Mark HOwitt
		Created:	14/10/2008
		Inputs:		The new Identity Policy that the site should use
		Purpose:	Sets the sites Identity policy uri

*********************************************************************************/
void CSiteData::SetSiteIdentityPolicy(const TDVCHAR* psIdentityPolicy)
{
	m_sIdentityPolicy = psIdentityPolicy;
}

/*********************************************************************************

	CTDVString CSiteData::GetSiteIdentityPolicy()

		Author:		Mark Howitt
		Created:	14/10/2008
		Returns:	The Indetity policy uri for this site

*********************************************************************************/
CTDVString CSiteData::GetSiteIdentityPolicy()
{
	return m_sIdentityPolicy;
}

/*********************************************************************************

	bool CSiteData::IsSiteEmergencyClosed()

		Author:		Mark Howitt
		Created:	20/07/2006
		Returns:	true if the site is emergency closed, false if not
		Purpose:	Returns the emergency open or closed status of the site

*********************************************************************************/
bool CSiteData::IsSiteEmergencyClosed()
{
	return m_bSiteEmergencyClosed;
}

/*********************************************************************************

	void CSiteData::SetSiteEmergencyClosed(bool bEmergencyClosed)

		Author:		Mark Howitt
		Created:	21/07/2006
		Inputs:		bEmergencyClosed - the new emergency status for the site
		Outputs:	-
		Returns:	-
		Purpose:	Sets the sites emergency closed status

*********************************************************************************/
void CSiteData::SetSiteEmergencyClosed(bool bEmergencyClosed)
{
	m_bSiteEmergencyClosed = bEmergencyClosed;
}

/*********************************************************************************

	bool CSiteData::AddSiteTopicsOpenCloseTime(int iDayWeek, int iHour, int iMinute, int iClosed)

		Author:		Mark Howitt
		Created:	20/07/2006
		Inputs:		-
		Outputs:	-
		Returns:	-
		Purpose:	-

*********************************************************************************/
bool CSiteData::AddSiteOpenCloseTime(int iDayWeek, int iHour, int iMinute, int iClosed)
{
	CSiteOpenCloseTime SiteOpenCloseTime(iDayWeek, iHour, iMinute, iClosed);

	m_OpenCloseTimes.push_back(SiteOpenCloseTime);

	return true;
}

/*********************************************************************************

	bool CSiteData::GetSiteScheduledClosed(CTDVDateTime dDate)

		Author:		Mark Howitt
		Created:	20/07/2006
		Inputs:		-
		Outputs:	-
		Returns:	-
		Purpose:	-

*********************************************************************************/
bool CSiteData::GetSiteScheduledClosed(CTDVDateTime dDate)
{
	bool bScheduledEventAlreadyHappened = false;

	int iOpenCloseTimesSize = m_OpenCloseTimes.size();

	if (iOpenCloseTimesSize == 0)
	{
		// No scheduled closures. 
		return false; 
	}

	for (int i = 0; i < iOpenCloseTimesSize; i++)
	{
		CSiteOpenCloseTime& siteOpenCloseTime = m_OpenCloseTimes.at(i);
		siteOpenCloseTime.HasAlreadyHappened(dDate, bScheduledEventAlreadyHappened);
		if (bScheduledEventAlreadyHappened)
		{
			if (siteOpenCloseTime.GetClosed() == 1)
			{
				// The last scheduled event closed topics on this site.
				return true; 
			}
			else 
			{
				// The last scheduled event opened topics on this site. 
				return false; 
			}
		}
	}

	// no opening/closing time has passed yet so get the first one in the array.
	CSiteOpenCloseTime& siteOpenCloseTime = m_OpenCloseTimes.at(0);
	if (siteOpenCloseTime.GetClosed() == 1)
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool CSiteData::AddTopicForum(int iForumID)
{
	m_TopicForums.push_back(iForumID);

	return true; 
}

bool CSiteData::IsForumATopic(int iForumID)
{
	for (unsigned int i = 0; i < m_TopicForums.size(); i++)
	{
		if (iForumID == m_TopicForums.at(i))
		{
			return true; 
		}
	}
	return false;
}

/*********************************************************************************

	bool CSiteData::GetSiteScheduleAsXMLString(CTDVString& sXML)

		Author:		Mark Howitt
		Created:	20/07/2006
		Inputs:		-
		Outputs:	-
		Returns:	-
		Purpose:	-

*********************************************************************************/
bool CSiteData::GetSiteScheduleAsXMLString(CTDVString& sXML)
{
	CTDVString sTempXML; 

	int iOpenCloseTimesSize = m_OpenCloseTimes.size();

	if (iOpenCloseTimesSize == 0)
	{
		// No scheduled closures. 
		return true; 
	}

	for (int i = 0; i < iOpenCloseTimesSize; i++)
	{
		CSiteOpenCloseTime& siteOpenCloseTime = m_OpenCloseTimes.at(i);
		siteOpenCloseTime.GetAsXMLString(sTempXML); 
		sXML << sTempXML; 
	}

	return true; 
}

bool CSiteData::GetSkinSet(CTDVString* pSkinSet)
{
    *pSkinSet = m_SkinSet;
	return true; 
}

/*********************************************************************************

	CTDVString CSiteData::GetSiteInfomationXML(CGI* pCGI)

		Author:		Mark Howitt
		Created:	23/07/2008
		Returns:	The XML information for the site
		Purpose:	Gets the site information as XML. This contains sitename, ssoservice,
						minage, maxage, siteoptions... This is found on every page.

*********************************************************************************/
CTDVString CSiteData::GetSiteInfomationXML(CGI* pCGI)
{
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML);
	XML.OpenTag("SITE", true);
	XML.AddIntAttribute("ID",m_SiteID,true);
	XML.AddTag("NAME",m_SiteName);
	XML.AddTag("SSOSERVICE",m_SSOService);
	XML.AddIntTag("IDENTITYSIGNIN",m_bUseIdentitySignIn ? 1 : 0);
	XML.AddTag("IDENTITYPOLICY",m_sIdentityPolicy);
	XML.AddIntTag("MINAGE",m_iMinAge);
	XML.AddIntTag("MAXAGE",m_iMaxAge);
	int iModStatus = m_bPreModeration ? 2 : 1;
	if (iModStatus != 2 && m_bUnmoderated)
	{
		iModStatus = 0;
	}
	XML.AddIntTag("MODERATIONSTATUS",iModStatus);
	XML.OpenTag("OPENCLOSETIMES");
	GetSiteScheduleAsXMLString(sXML);
	XML.CloseTag("OPENCLOSETIMES");
	XML.OpenTag("SITECLOSED",true);
	XML.AddIntAttribute("EMERGENCYCLOSED", m_bSiteEmergencyClosed ? 1 : 0);
	bool bScheduledClosed = GetSiteScheduledClosed(COleDateTime::GetCurrentTime());
	XML.AddIntAttribute("SCHEDULEDCLOSED", bScheduledClosed ? 1 : 0, true);
	XML.CloseTag("SITECLOSED",bScheduledClosed || m_bSiteEmergencyClosed ? "1" : "0");
	CSiteOptions* pSiteOptions = pCGI->GetSiteOptions();
	if (pSiteOptions != NULL)
	{
		pSiteOptions->CreateXML(m_SiteID, sXML);
	}
	XML.CloseTag("SITE");

	// Return the XML
	return sXML;
}