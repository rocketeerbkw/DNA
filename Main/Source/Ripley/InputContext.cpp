// InputContext.cpp: implementation of the CInputContext class.
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
#include "RipleyServer.h"
#include "CGI.h"
#include "InputContext.h"
#include "ProfileConnection.h"
#include "dynamiclists.h"


#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CInputContext::CInputContext() 
	: 
	m_pCGI(NULL)
{
	// No further initialisation
}

void CInputContext::SetCgi(CGI* pCGI)
{
	m_pCGI = pCGI;
}

CInputContext::~CInputContext()
{

}

/*********************************************************************************

	bool CInputContext::GetParamString(const TDVCHAR *pName, TDVString &sResult, int iIndex)
																			 ,
	Author:		Jim Lynn, Kim Harries, Oscar Gillesbie, Shim Young, Sean Solle
	Created:	17/02/2000
	Inputs:		pName - parameter name to fetch
				iIndex - optional index to show which parameter to get from
					muliples with the same name
	Outputs:	sResult - string containing the result (if present)
	Returns:	true if the parameter exists, false if not found
	Purpose:	Look at the request and finds the named parameter, putting the
				value in the output parameter sResult

*********************************************************************************/

bool CInputContext::GetParamString(const TDVCHAR *pName, CTDVString &sResult, int iIndex, bool bPrefix, CTDVString* pParamName)
{
	return m_pCGI->GetParamString(pName, sResult, iIndex, bPrefix, pParamName);
}

/*********************************************************************************

	int CInputContext::GetParamInt(const TDVCHAR *pName, int iIndex)

	Author:		Jim Lynn, Kim Harries, Oscar Gillesbie, Shim Young, Sean Solle
	Created:	17/02/2000
	Inputs:		pName - name of parameter to look for
				iIndex - optional index indicating which parameter to get from
					muliples with the same name
	Outputs:	-
	Returns:	integer representation of the parameter value
	Purpose:	Looks for the named parameter and returns its integer value.
				Returns zero in the error case.

*********************************************************************************/

int CInputContext::GetParamInt(const TDVCHAR *pName, int iIndex)
{
	return m_pCGI->GetParamInt(pName, iIndex);
}

/*********************************************************************************

	bool CInputContext::ParamExists(const TDVCHAR* pName, int iIndex)

	Author:		Kim Harries
	Created:	16/03/2000
	Inputs:		pName - name of the paramter for which we are looking.
				iIndex - optional index indicating which parameter to check for the
					existence of from multiples with the same name
	Outputs:	-
	Returns:	true if the parameter exists, false otherwise
	Purpose:	Examines the request string to see if it conatins a parameter of the
				given name.

*********************************************************************************/

bool CInputContext::ParamExists(const TDVCHAR* pName, int iIndex)
{
	return m_pCGI->ParamExists(pName, iIndex);
}

/*********************************************************************************

	bool CInputContext::GetCommand(CTDVString& sResult)

	Author:		Jim Lynn
	Created:	23/02/2000
	Inputs:		-
	Outputs:	sResult - contains command name on return
	Returns:	true if a command was found, false if no command was found
	Purpose:	Gets the command specified in the request. Tells the server 
				which command to execute (like Display or Register).

*********************************************************************************/

/*********************************************************************************

	int CInputContext::GetParamCount(const TDVCHAR* pName = NULL)

	Author:		Kim Harries
	Created:	21/11/2000
	Inputs:		pName - case insensitive name of parameter to count the
					number of occurences of
	Outputs:	-
	Returns:	The total number of parameters with that name
	Purpose:	Counts the total number of parameters in the query string with the
				given name. If pName is NULL (the default value) then counts the
				total number of parameters.

*********************************************************************************/

int CInputContext::GetParamCount(const TDVCHAR* pName)
{
	return m_pCGI->GetParamCount(pName);
}

bool CInputContext::GetCommand(CTDVString& sResult)
{
	return m_pCGI->GetCommand(sResult);
}

bool CInputContext::GetStylesheetHomePath(CTDVString &sResult)
{
	return m_pCGI->GetStylesheetHomePath(sResult);
}

bool CInputContext::GetHomePath(CTDVString& sResult)
{
	return m_pCGI->GetHomePath(sResult);
}

bool CInputContext::GetRipleyServerPath(CTDVString& sResult)
{
	return m_pCGI->GetRipleyServerPath(sResult);
}

static const char* GetMimeExtension(const char* pMime)
{
	return CGI::GetMimeExtension(pMime);
}

/*********************************************************************************

	bool CInputContext::GetDefaultSkin(CTDVString& sSkinName)

	Author:		Kim Harries
	Created:	25/05/2000
	Inputs:		-
	Outputs:	sSkinName - the name of the default skin specified in the config file
	Returns:	true if successful, false otherwise
	Purpose:	Puts the value for the default skin name from the config file into
				the sSkinName output variable.

*********************************************************************************/

bool CInputContext::GetDefaultSkin(CTDVString& sSkinName)
{
	return m_pCGI->GetDefaultSkin(sSkinName);
}

/*********************************************************************************

	CUser* CInputContext::GetCurrentUser()

	Author:		Kim Harries
	Created:	02/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	A pointer to the the current viewing user, or NULL if this is
				impossible for some reason.
	Purpose:	Returns a pointer to the current viewer, i.e. a CUser object
				that represents all the info about the user that is associated
				with the current request. Returns NULL if the user is not logged 
				in to the current service. Which is different from them being
				signed in.

*********************************************************************************/

CUser* CInputContext::GetCurrentUser()
{
	return m_pCGI->GetCurrentLoggedInUser();
}

/*********************************************************************************
CUser* CInputContext::GetSignedinUser() 
Author:		Igor Loboda
Created:	16/02/2005
Returns:	A pointer to the the current signed in user. Note, the user might
			not be logged in or event registered for a dna site.
*********************************************************************************/
CUser* CInputContext::GetSignedinUser() 
{ 
	return m_pCGI->GetCurrentUser(); 
}

/*********************************************************************************

	CProfileApi* CInputContext::GetProfileApi()

	Author:		Dharmesh Raithatha
	Created:	9/11/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	the profile api instance. The caller must not delete this pointer
				it remains the property of the CGI object. The Api should be 
				initialised and the service should be set. However if there was an error
				in initialisation or setting the service name you will still be able to 
				get the profile api instance. However calls will fail.

*********************************************************************************/

CProfileConnection* CInputContext::GetProfileConnection()
{
	return m_pCGI->GetProfileConnection();
}


bool CInputContext::GetDomainName(CTDVString &sResult)
{
	return m_pCGI->GetDomainName(sResult);
}

bool CInputContext::GetSiteRootURL(int iSiteID,CTDVString& sSiteRootURL)
{
	return m_pCGI->GetSiteRootURL(iSiteID, sSiteRootURL);
}

bool CInputContext::GetParsingErrors(const TDVCHAR *pText, CTDVString *pErrorString, CTDVString *pErrorLine, int *piLineNo, int *piCharNo)
{
	return m_pCGI->GetParsingErrors(pText, pErrorString, pErrorLine, piLineNo, piCharNo);
}

bool CInputContext::GetEmail(int iEmailType, CTDVString& sEmail, int iSiteID)
{
	return m_pCGI->GetEmail(iEmailType, sEmail, iSiteID);
}

/*********************************************************************************

	bool CInputContext::GetClientAddr(CTDVString &sResult)

	Author:		Adam Cohen-Rose
	Created:	08/08/2000
	Inputs:		-
	Outputs:	sResult - contains IP address of client on exit
	Returns:	true if client IP found, false otherwise
	Purpose:	Gets the (dotted quad) IP address of the client making the request.

*********************************************************************************/

bool CInputContext::GetClientAddr(CTDVString& sResult)
{
	return m_pCGI->GetClientAddr(sResult);
}

bool CInputContext::SendMail(const TDVCHAR* pEmail, const TDVCHAR* pSubject, const TDVCHAR* pBody, const TDVCHAR* pFromAddress, const TDVCHAR* pFromName, const bool bInsertLineBreaks)
{
	return m_pCGI->SendMail(pEmail, pSubject, pBody, pFromAddress, pFromName, bInsertLineBreaks);
}

bool CInputContext::SendMailOrSystemMessage(const TDVCHAR* pEmail, const TDVCHAR* pSubject, const TDVCHAR* pBody, const TDVCHAR* pFromAddress, const TDVCHAR* pFromName, const bool bInsertLineBreaks, int piUserID, int piSiteID)
{
	return m_pCGI->SendMailOrSystemMessage(pEmail, pSubject, pBody, pFromAddress, pFromName, bInsertLineBreaks, piUserID, piSiteID);
}

bool CInputContext::SendDNASystemMessage(int piUserID, int piSiteID, const TDVCHAR* pBody)
{
	return m_pCGI->SendDNASystemMessage(piUserID, piSiteID, pBody);
}

bool CInputContext::GetSkin(CTDVString* oSkinName)
{
	return m_pCGI->GetSkin(oSkinName);
}

bool CInputContext::GetSkinSet( CTDVString* pSkinSet )
{
    return m_pCGI->GetSkinSet( pSkinSet);
}

bool CInputContext::GetPreModerationState()
{
	return m_pCGI->GetPreModerationState();
}

bool CInputContext::ChangeSite(int iSiteID)
{
	return m_pCGI->ChangeSite(iSiteID);
}

int CInputContext::GetSiteID()
{
	return m_pCGI->GetSiteID();
}

int CInputContext::GetModClassID()
{
	return m_pCGI->GetModClassID();
}

int CInputContext::GetThreadOrder()
{
	return m_pCGI->GetThreadOrder();
}
int CInputContext::GetAllowRemoveVote()
{
	return m_pCGI->GetAllowRemoveVote();
}

int CInputContext::GetIncludeCrumbtrail()
{
	return m_pCGI->GetIncludeCrumbtrail();
}

int CInputContext::GetAllowPostCodesInSearch()
{
	return m_pCGI->GetAllowPostCodesInSearch();
}

bool CInputContext::IsSiteClosed(int iSiteID, bool &bSiteClosed)
{
	return m_pCGI->IsSiteClosed(iSiteID, bSiteClosed);
}

bool CInputContext::IsSiteEmergencyClosed(int iSiteID, bool &bEmergencyClosed)
{
	return m_pCGI->IsSiteEmergencyClosed(iSiteID, bEmergencyClosed);
}

bool CInputContext::GetSiteScheduleAsXMLString(int iSiteID, CTDVString& sXML)
{
	return m_pCGI->GetSiteScheduleAsXMLString(iSiteID,sXML);
}

bool CInputContext::SetSiteIsEmergencyClosed(int iSiteID, bool bEmergencyClosed)
{
	return m_pCGI->SetSiteIsEmergencyClosed(iSiteID,bEmergencyClosed);
}

bool CInputContext::IsForumATopic(int m_SiteID, int iForumID)
{
	return m_pCGI->IsForumATopic(m_SiteID, iForumID);
}

int CInputContext::GetThreadEditTimeLimit()
{
	return m_pCGI->GetThreadEditTimeLimit();
}

bool CInputContext::GetNoAutoSwitch()
{
	return m_pCGI->GetNoAutoSwitch();
}

bool CInputContext::GetNameOfSite(int iSiteID, CTDVString *oName)
{
	return m_pCGI->GetNameOfSite(iSiteID, oName);
}

CTDVString CInputContext::GetNameOfCurrentSite()
{
	return m_pCGI->GetNameOfCurrentSite();
}

bool CInputContext::GetShortName(CTDVString& sShortName, int iSiteID)
{
	return m_pCGI->GetShortName(sShortName, iSiteID);
}

bool CInputContext::GetSiteListAsXML(CTDVString *oXML, int iMode)
{
	return m_pCGI->GetSiteListAsXML(oXML, iMode);
}

CTDVString CInputContext::GetSiteAsXML(int iSiteID, int iMode)
{
	return m_pCGI->GetSiteAsXML(iSiteID,iMode);
}

bool CInputContext::MakeCUDRequest(const TDVCHAR* pRequest, CTDVString* oResponse)
{
	return m_pCGI->MakeCUDRequest(pRequest, oResponse);
}

void CInputContext::SiteDataUpdated()
{
	m_pCGI->SiteDataUpdated();
}

void CInputContext::GroupDataUpdated()
{
	TDVASSERT(m_pCGI, "CInputContext::GroupDataUpdated() Unexpected NULL CGI");
	m_pCGI->GroupDataUpdated();
}

void CInputContext::UserGroupDataUpdated(int iUserID)
{
	m_pCGI->UserGroupDataUpdated(iUserID);
}

bool CInputContext::Signal(const TDVCHAR *pURL)
{
	return m_pCGI->Signal(pURL);
}

bool CInputContext::SetSkin(const TDVCHAR* pSkin)
{
	return m_pCGI->SetSkin(pSkin);
}

bool CInputContext::SaveUploadedSkin(const TDVCHAR *pSkinName, const TDVCHAR *pFileName, const TDVCHAR *pParamName, bool bCreateNew, CTDVString *oErrors)
{
	return m_pCGI->SaveUploadedSkin(pSkinName, pFileName, pParamName, bCreateNew, oErrors);
}

bool CInputContext::DoesCurrentSkinUseFrames()
{
	return m_pCGI->DoesCurrentSkinUseFrames();
}

bool CInputContext::DoesSkinExistInSite(int iSiteID, const TDVCHAR *pSkinName)
{
	return m_pCGI->DoesSkinExistInSite(iSiteID, pSkinName);
}

bool CInputContext::DoesKeyArticleExist(int iSiteID, const TDVCHAR *pArticleName)
{
	return m_pCGI->DoesKeyArticleExist(iSiteID, pArticleName);
}

int CInputContext::GetReviewForumID(int iSiteID, const TDVCHAR *pForumName)
{
	return m_pCGI->GetReviewForumID(iSiteID, pForumName);
}

int CInputContext::GetAutoMessageUserID(int iSiteID)
{
	return m_pCGI->GetAutoMessageUserID(iSiteID);
}

bool CInputContext::GetUserName(CTDVString *oName)
{
	return m_pCGI->GetUserName(oName);
}

bool CInputContext::CanUserMoveToSite(int iCurrentSiteID, int iNewSiteID)
{
	return m_pCGI->CanUserMoveToSite(iCurrentSiteID, iNewSiteID);
}

bool CInputContext::IsSiteUnmoderated(int iSiteID)
{
	return m_pCGI->IsSiteUnmoderated(iSiteID);
}

bool CInputContext::IsSitePassworded(int iSiteID)
{
	return m_pCGI->IsSitePassworded(iSiteID);
}

bool CInputContext::IsCurrentSiteMessageboard()
{
	return m_pCGI->IsCurrentSiteMessageboard();
}

bool CInputContext::IsCurrentSiteEmailAddressFiltered()
{
	return m_pCGI->IsCurrentSiteEmailAddressFiltered();
}

bool CInputContext::IsSystemMessagesOn(int ipSiteID)
{
	return m_pCGI->IsSystemMessagesOn(ipSiteID);
}

bool CInputContext::DoesSiteUsePreModPosting(int ipSiteID)
{
	return m_pCGI->DoesSiteUsePreModPosting(ipSiteID);
}

bool CInputContext::DoesSiteUseArticleGuestBookForums(int iSiteID)
{
	return m_pCGI->DoesSiteUseArticleGuestBookForums(iSiteID);
}

bool CInputContext::IncludeUsersGuideEntryInPersonalSpace()
{
	return m_pCGI->IncludeUsersGuideEntryInPersonalSpace();
}

bool CInputContext::IncludeUsersGuideEntryForumInPersonalSpace()
{
	return m_pCGI->IncludeUsersGuideEntryForumInPersonalSpace();
}

bool CInputContext::IncludeJournalInPersonalSpace()
{
	return m_pCGI->IncludeJournalInPersonalSpace();
}

bool CInputContext::IncludeRecentPostsInPersonalSpace()
{
	return m_pCGI->IncludeRecentPostsInPersonalSpace();
}

bool CInputContext::IncludeRecentGuideEntriesInPersonalSpace()
{
	return m_pCGI->IncludeRecentGuideEntriesInPersonalSpace();
}

bool CInputContext::IncludeUploadsInPersonalSpace()
{
	return m_pCGI->IncludeUploadsInPersonalSpace();
}

bool CInputContext::IncludeWatchInfoInPersonalSpace()
{
	return m_pCGI->IncludeWatchInfoInPersonalSpace();
}

bool CInputContext::IncludeClubsInPersonalSpace()
{
	return m_pCGI->IncludeClubsInPersonalSpace();
}

bool CInputContext::IncludePrivateForumsInPersonalSpace()
{
	return m_pCGI->IncludePrivateForumsInPersonalSpace();
}

bool CInputContext::IncludeLinksInPersonalSpace()
{
	return m_pCGI->IncludeLinksInPersonalSpace();
}

bool CInputContext::IncludeTaggedNodesInPersonalSpace()
{
	return m_pCGI->IncludeTaggedNodesInPersonalSpace();
}

bool CInputContext::IncludePostcoderInPersonalSpace()
{
	return m_pCGI->IncludePostcoderInPersonalSpace();
}

bool CInputContext::IncludeNoticeboardInPersonalSpace()
{
	return m_pCGI->IncludeNoticeboardInPersonalSpace();
}

bool CInputContext::IncludeSiteOptionsInPersonalSpace()
{
	return m_pCGI->IncludeSiteOptionsInPersonalSpace();
}

bool CInputContext::IncludeRecentCommentsInPersonalSpace()
{
	return m_pCGI->IncludeRecentCommentsInPersonalSpace();
}

bool CInputContext::IncludeRecentArticlesOfSubscribedToUsersInPersonalSpace()
{
	return m_pCGI->IncludeRecentArticlesOfSubscribedToUsersInPersonalSpace();
}

void CInputContext::LogTimerEvent(const TDVCHAR* pMessage)
{
	m_pCGI->LogTimerEvent(pMessage);
}

void CInputContext::WriteInputLog( CTDVString type, CTDVString message)
{
    CTDVString error;
    error += "[" + type + "] ";
    error += message;
    m_pCGI->WriteInputLog(error);
}

void CInputContext::GetSiteConfig(CTDVString& sSiteConfig)
{
	m_pCGI->GetSiteConfig(sSiteConfig);
}

void CInputContext::GetTopics(CTDVString& sTopics)
{
	m_pCGI->GetTopics(sTopics);
}

void CInputContext::SetSiteConfig(const TDVCHAR* pSiteConfig)
{
	m_pCGI->SetSiteConfig(pSiteConfig);
}

bool CInputContext::GetIsInFastBuilderMode()
{
	return m_pCGI->GetIsInFastBuilderMode();
}

bool CInputContext::GetIsInPreviewMode()
{
	return m_pCGI->GetIsInPreviewMode();
}

bool CInputContext::GetTimeTransform()
{
	return m_pCGI->GetTimeTransform();
}

bool CInputContext::IsUserAllowedInPasswordedSite(int* pReason)
{
	return m_pCGI->IsUserAllowedInPasswordedSite(pReason);
}

bool CInputContext::GetCookieByName(const TDVCHAR* pCookieName, CTDVString& sCookieValue)
{
	return m_pCGI->GetCookieByName(pCookieName, sCookieValue);
}


bool CInputContext::GetParamFile(const TDVCHAR* pName, int iAvailableLength, 
	char* pBuffer, int& iLength, CTDVString& sMime)

{
	return m_pCGI->GetParamFile(pName, iAvailableLength, pBuffer, iLength, sMime);
}

const char* CInputContext::GetMimeExtension(const char* pMime)
{
	return CGI::GetMimeExtension(pMime);
}
bool CInputContext::GetNamedSectionMetadata(const char* pName, int& iLength, CTDVString& sMime)
{
	return m_pCGI->GetNamedSectionMetadata(pName, iLength, sMime);
}
/*********************************************************************************

	CStoredProcedure* CInputContext::CreateStoredProcedureObject()

	Author:		Jim Lynn
	Created:	25/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	A ptr to a StoredProcedure object pointing at the correct database
	Purpose:	Creates a new StoredProcedure object and passes it out to the caller.
				The SPobject points at the right database for this request (as
				determined by the config data) and *must* be deleted by the caller
				when they have finished with it.

*********************************************************************************/

CStoredProcedure* CInputContext::CreateStoredProcedureObject()
{
	return m_pCGI->CreateStoredProcedureObject();
}

bool CInputContext::CacheGetItem(const TDVCHAR *pCacheName, const TDVCHAR *pItemName, CTDVDateTime *pdExpires, CTDVString *oXMLText)
{
	return m_pCGI->CacheGetItem(pCacheName, pItemName, pdExpires, oXMLText);
}

bool CInputContext::CachePutItem(const TDVCHAR *pCacheName, const TDVCHAR *pItemName, const TDVCHAR* pText)
{
	return m_pCGI->CachePutItem(pCacheName, pItemName, pText);
}

bool CInputContext::InitialiseStoredProcedureObject(CStoredProcedure* pSP)
{
	return m_pCGI->InitialiseStoredProcedureObject(pSP);
}

bool CInputContext::InitialiseStoredProcedureObject(CStoredProcedureBase& sp)
{
	return m_pCGI->InitialiseStoredProcedureObject(sp);
}

bool CInputContext::ConvertPlainText(CTDVString* oResult, int MaxSmileyCount)
{
	return m_pCGI->ConvertPlainText(oResult, MaxSmileyCount);
}

bool CInputContext::GetParamsAsString(CTDVString& sResult, const TDVCHAR* pPrefix)
{
	return m_pCGI->GetParamsAsString(sResult,pPrefix);
}

bool CInputContext::GetParamsAsXML(CTDVString* pResult, const TDVCHAR* pPrefix)
{
	return m_pCGI->GetParamsAsXML(pResult,pPrefix);
}

void CInputContext::GetQueryHash(CTDVString& sHash)
{
	return m_pCGI->GetQueryHash(sHash);
}

/*********************************************************************************

	CProfileApi* CDatabaseConext::GetProfileApi()

	Author:		Dharmesh Raithatha
	Created:	9/11/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	the profile api instance. The caller must not delete this pointer
				it remains the property of the CGI object. The Api should be 
				initialised and the service should be set. However if there was an error
				in initialisation or setting the service name you will still be able to 
				get the profile api instance. However calls will fail.

*********************************************************************************/

bool CInputContext::PostcoderPlaceRequest(const TDVCHAR *pPlaceName, CTDVString &oResult)
{
	return m_pCGI->PostcoderPlaceRequest(pPlaceName, oResult);
}

bool CInputContext::PostcoderPlaceCookieRequest(const TDVCHAR *pPlaceName, CTDVString &oResult)
{
	return m_pCGI->PostcoderPlaceCookieRequest(pPlaceName, oResult);
}


/*********************************************************************************

	bool CInputContext::GetBBCUIDFromCookie(CTDVString& sBBCUID);

	Author:		Mark Howitt
	Created:	14/11/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Exposes the underlying CGI call

*********************************************************************************/

bool CInputContext::GetBBCUIDFromCookie(CTDVString& sBBCUID)
{
	return m_pCGI->GetBBCUIDFromCookie(sBBCUID);
}

CTDVString CInputContext::GetBBCUIDFromCookie()
{
	return m_pCGI->GetBBCUIDFromCookie();
}

bool CInputContext::RefreshProfanityList()
{
	return m_pCGI->RefreshProfanityList();
}

/*********************************************************************************

	bool CInputContext::IsUsersEMailVerified(bool bVerified)

		Author:		Mark Howitt
        Created:	21/09/2004
        Inputs:		-
        Outputs:	bVerified - A flag that takes the value of the email status
        Returns:	true if ok, false if not
        Purpose:	Gets the status of the users email

*********************************************************************************/
bool CInputContext::IsUsersEMailVerified(bool& bVerified)
{
	return m_pCGI->IsUsersEMailVerified(bVerified);
}

/*********************************************************************************

	bool CInputContext::GetSitesEMailAlertSubject(int iSiteID, CTDVString& sEmailSubject)

		Author:		Mark Howitt
        Created:	23/11/2004
        Inputs:		iSiteID - the site for which you want to get the subject for.
        Outputs:	sEmailSubject - the subject name for the given site.
        Returns:	true if ok, false if not
        Purpose:	Gets the subject for the emazil alert system emails.

*********************************************************************************/
bool CInputContext::GetSitesEMailAlertSubject(int iSiteID, CTDVString& sEmailSubject)
{
	return m_pCGI->GetSitesEMailAlertSubject(iSiteID,sEmailSubject);
}

bool CInputContext::GetEventAlertMessageUserID(int iSiteID, int& iUserID)
{
	return m_pCGI->GetEventAlertMessageUserID(iSiteID,iUserID);
}

/*********************************************************************************

	bool RefreshTopicLists(int iSiteID)

		Author:		Mark Howitt
        Created:	27/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CInputContext::RefreshTopicLists(int iSiteID)
{
	return m_pCGI->RefreshTopics();
}


/*********************************************************************************

	int CInputContext::GetSiteID(const TDVCHAR* pSiteName)

		Author:		Mark Neves
        Created:	15/02/2005
        Inputs:		pSiteName
        Outputs:	-
        Returns:	Site ID of site with name pSiteName
        Purpose:	Gets the site ID for a given site

*********************************************************************************/

int CInputContext::GetSiteID(const TDVCHAR* pSiteName)
{
	return m_pCGI->GetSiteID(pSiteName);
}

/*********************************************************************************

	bool CInputContext::GetUserGroups(CTDVString &sXML, int nUserID)

		Author:		James Pullicino
        Created:	11/04/2005
		Purpose:	Creates <GROUPS> element with groups for user

		SEE CUserGroups::GetUserGroups for full documentation

*********************************************************************************/

bool CInputContext::GetUserGroups(CTDVString &sXML, int nUserID, int nSiteID)
{
	TDVASSERT(m_pCGI->m_pUserGroups, "Unexpected NULL m_pCGI->m_pUserGroups");
	if(m_pCGI->m_pUserGroups == NULL)
	{
		// Safety first
		return false;
	}

	return m_pCGI->m_pUserGroups->GetUserGroups(sXML, nUserID, *this, nSiteID);
}

/*********************************************************************************

	bool CInputContext::GetDynamicLists(CTDVString &sXML, int nSiteID)

		Author:		James Pullicino
        Created:	19/07/2005
        Inputs:		SiteID	- ID of site to get lists for
        Outputs:	sXML	- <dynamic-lists> xml
        Returns:	-
        Purpose:	Gets dynamic list xml for site

*********************************************************************************/

bool CInputContext::GetDynamicLists(CTDVString &sXML, int nSiteID)
{
	TDVASSERT(m_pCGI->m_pDynamicLists, "Unexpected NULL m_pCGI->m_pDynamicLists");
	if(m_pCGI->m_pDynamicLists == NULL)
	{
		// Safety first
		return false;
	}

	return m_pCGI->m_pDynamicLists->GetDynamicListsXml(sXML, *this, nSiteID);
}

/*********************************************************************************

	void CInputContext::DynamicListsDataUpdated()

		Author:		James Pullicino
        Created:	29/07/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Refreshes the list of dynamic lists for all sites

*********************************************************************************/

void CInputContext::DynamicListsDataUpdated()
{
	TDVASSERT(m_pCGI, "CInputContext::DynamicListsDataUpdated() Unexpected NULL CGI");
	m_pCGI->DynamicListDataUpdated();
}


/*********************************************************************************

	CTDVString CInputContext::GetRipleyServerInfoXML()

		Author:		Mark Neves
        Created:	01/11/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

CTDVString CInputContext::GetRipleyServerInfoXML()
{
	return m_pCGI->GetRipleyServerInfoXML();
}

/*********************************************************************************

	CTDVString CInputContext::GetStatistics()

		Author:		Martin Robb
        Created:	20/01/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	- Returns Statistics Object - Records stats eg number of server busy msgs.

*********************************************************************************/
CRipleyStatistics* CInputContext::GetStatistics()
{
	return m_pCGI->GetStatistics();
}

/*********************************************************************************

	CTDVString CInputContext::GetParamFilePointer()

		Author:		Steven Francis
        Created:	16/11/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Wrapper for the CGI version of GetParamFilePointer

*********************************************************************************/

bool CInputContext::GetParamFilePointer(const TDVCHAR* pName,	const char** pBuffer, int& iLength, CTDVString& sMime, CTDVString *sFilename)
{
	return m_pCGI->GetParamFilePointer(pName, pBuffer, iLength, sMime, sFilename);
}

/*********************************************************************************

	CTDVString CInputContext::GetIPAddress()

		Author:		Mark Neves
        Created:	22/11/2005
        Inputs:		-
        Outputs:	-
        Returns:	IP Address of machine that initiated the request, or "" if none supplied
        Purpose:	-

*********************************************************************************/

CTDVString CInputContext::GetIPAddress()
{
	return m_pCGI->GetIPAddress();
}
bool CInputContext::GetFeedsCacheName(CTDVString& sFeedsCacheName, CTDVString& sFeedsCacheItemName)
{
	return m_pCGI->GetFeedsCacheName(sFeedsCacheName, sFeedsCacheItemName);
}
bool CInputContext::GetRequestFeedCacheFolderName(CTDVString& sFeedsCacheFolderName)
{
	return m_pCGI->GetRequestFeedCacheFolderName(sFeedsCacheFolderName);
}
bool CInputContext::GetRequestFeedCacheFileSuffix(CTDVString& sFeedsCacheFileSuffix)
{
	return m_pCGI->GetRequestFeedCacheFileSuffix(sFeedsCacheFileSuffix);
}
bool CInputContext::IsRequestForCachedFeed()
{
	return m_pCGI->IsRequestForCachedFeed();
}
bool CInputContext::IsRequestForRssFeed()
{
	return m_pCGI->IsRequestForRssFeed();
}
bool CInputContext::IsRequestForSsiFeed()
{
	return m_pCGI->IsRequestForSsiFeed();
}

CSiteOptions* CInputContext::GetSiteOptions()
{
	return m_pCGI->GetSiteOptions();
}

/*********************************************************************************

	CTDVString CInputContext::GetServerName(CTDVString* oServerName)

		Author:		Steven Francis
        Created:	06/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	Wrapper to return the server name
        Purpose:	-

*********************************************************************************/

CTDVString CInputContext::GetServerName(CTDVString* oServerName)
{
	return m_pCGI->GetServerName(oServerName);
}

/*********************************************************************************

	bool CInputContext::IsCurrentSiteURLFiltered()

		Author:		Steven Francis
        Created:	02/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	
        Purpose:	Wrapper to check site options to see if the current site is
					one that has to be URL filtered

*********************************************************************************/
bool CInputContext::IsCurrentSiteURLFiltered()
{
	return m_pCGI->IsCurrentSiteURLFiltered();
}

/*********************************************************************************

	bool CGI::RefreshAllowedURLList()

		Author:		Steven Francis
        Created:	02/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	bool
        Purpose:	Wrapper to CGI function that refreshes the in memory cached allowed URL list

*********************************************************************************/
bool CInputContext::RefreshAllowedURLList()
{
	return m_pCGI->RefreshAllowedURLList();
}

/*********************************************************************************

	bool CGI::GetAllowedURLList(int iSiteID, CTDVString& AllowedURLList)

		Author:		Steven Francis
        Created:	02/05/2006
        Inputs:		Site ID 
        Outputs:	AllowedURLList - list of allowed urls for that site
        Returns:	bool
        Purpose:	Gets the list of allowed urls for a site

*********************************************************************************/
bool const CInputContext::GetAllowedURLList(int iSiteID, CTDVString& AllowedURLList)
{
	return m_pCGI->GetAllowedURLList(iSiteID, AllowedURLList);
}

/*********************************************************************************

	bool CInputContext::DoesCurrentSiteAllowedMAExternalLinks()

		Author:		Steven Francis
        Created:	05/07/2006
        Inputs:		-
        Outputs:	-
        Returns:	
        Purpose:	Wrapper to check site options to see if the current site is
					one that allows media assets to contain external links

*********************************************************************************/
bool CInputContext::DoesCurrentSiteAllowedMAExternalLinks()
{
	return m_pCGI->DoesCurrentSiteAllowedMAExternalLinks();
}

/*********************************************************************************

	bool CInputContext::IsModerationSite(int iSiteID)

		Author:		James Conway
        Created:	12/07/2006
        Inputs:		-
        Outputs:	-
        Returns:	
        Purpose:	Wrapper to the CGI function to check if the given site is 
		            the moderation site.

*********************************************************************************/
bool CInputContext::IsModerationSite(int iSiteID)
{
	return m_pCGI->IsModerationSite(iSiteID); 
}

/*********************************************************************************

	bool CInputContext::GetMediaAssetFtpServer()

		Author:		Steve Francis
		Created:	12/07/2006
		Inputs:		- 
		Outputs:	-
		Returns:	-
		Purpose:	- Wrappers for theConfig global variable so it is not called
						anywhere else except for within CGI?

*********************************************************************************/
const char* CInputContext::GetMediaAssetFtpServer() const
{
	return m_pCGI->GetMediaAssetFtpServer();
}
/*********************************************************************************

	bool CInputContext::GetMediaAssetFtpUser()

		Author:		Steve Francis
		Created:	12/07/2006
		Inputs:		- 
		Outputs:	-
		Returns:	-
		Purpose:	- Wrappers for theConfig global variable so it is not called
						anywhere else except for within CGI?

*********************************************************************************/
const char* CInputContext::GetMediaAssetFtpUser() const
{
	return m_pCGI->GetMediaAssetFtpUser();
}
/*********************************************************************************

	bool CInputContext::GetMediaAssetFtpPassword()

		Author:		Steve Francis
		Created:	12/07/2006
		Inputs:		- 
		Outputs:	-
		Returns:	-
		Purpose:	- Wrappers for theConfig global variable so it is not called
						anywhere else except for within CGI?

*********************************************************************************/
const char* CInputContext::GetMediaAssetFtpPassword() const
{
	return m_pCGI->GetMediaAssetFtpPassword();
}
/*********************************************************************************

	bool CInputContext::GetMediaAssetFtpHomeDirectory()

		Author:		Steve Francis
		Created:	12/07/2006
		Inputs:		- 
		Outputs:	-
		Returns:	-
		Purpose:	- Wrappers for theConfig global variable so it is not called
						anywhere else except for within CGI?

*********************************************************************************/
const char* CInputContext::GetMediaAssetFtpHomeDirectory() const
{
	return m_pCGI->GetMediaAssetFtpHomeDirectory();
}
/*********************************************************************************

	bool CInputContext::GetMediaAssetUploadQueueLocalDir()

		Author:		Steve Francis
		Created:	12/07/2006
		Inputs:		- 
		Outputs:	-
		Returns:	-
		Purpose:	- Wrappers for theConfig global variable so it is not called
						anywhere else except for within CGI?

*********************************************************************************/
const char* CInputContext::GetMediaAssetUploadQueueLocalDir() const
{
	return m_pCGI->GetMediaAssetUploadQueueLocalDir();
}
/*********************************************************************************

	bool CInputContext::GetMediaAssetUploadQueueTmpLocalDir()

		Author:		Steve Francis
		Created:	12/07/2006
		Inputs:		- 
		Outputs:	-
		Returns:	-
		Purpose:	- Wrappers for theConfig global variable so it is not called
						anywhere else except for within CGI?

*********************************************************************************/
const char* CInputContext::GetMediaAssetUploadQueueTmpLocalDir() const
{
	return m_pCGI->GetMediaAssetUploadQueueTmpLocalDir();
}
/*********************************************************************************

	bool CInputContext::GetPostcoderCookieName()

		Author:		Steve Francis
		Created:	12/07/2006
		Inputs:		- 
		Outputs:	-
		Returns:	-
		Purpose:	- Wrappers for theConfig global variable so it is not called
						anywhere else except for within CGI?

*********************************************************************************/
const char* CInputContext::GetPostcoderCookieName() const
{
	return m_pCGI->GetPostcoderCookieName();
}
/*********************************************************************************

	bool CInputContext::GetPostcoderCookiePostcodeKey()

		Author:		Steve Francis
		Created:	12/07/2006
		Inputs:		- 
		Outputs:	-
		Returns:	-
		Purpose:	- Wrappers for theConfig global variable so it is not called
						anywhere else except for within CGI?

*********************************************************************************/
const char* CInputContext::GetPostcoderCookiePostcodeKey() const
{
	return m_pCGI->GetPostcoderCookiePostcodeKey();
}

/*********************************************************************************************************************

	bool CInputContext:: ()

		Author:		Steve Francis
		Created:	12/07/2006
		Inputs:		- 
		Outputs:	-
		Returns:	-
		Purpose:	- Wrappers for theConfig Image Library function so it is not called
						anywhere else except for within CGI?

**********************************************************************************************************************/
const char* CInputContext::GetImageLibraryPreviewImage() const { return m_pCGI->GetImageLibraryPreviewImage(); }
int CInputContext::GetImageLibraryMaxUploadBytes() const { return m_pCGI->GetImageLibraryMaxUploadBytes(); } 
const char* CInputContext::GetImageLibraryFtpServer() const { return m_pCGI->GetImageLibraryFtpServer(); } 
const char* CInputContext::GetImageLibraryFtpUser() const { return m_pCGI->GetImageLibraryFtpUser(); } 
const char* CInputContext::GetImageLibraryFtpPassword() const { return m_pCGI->GetImageLibraryFtpPassword(); } 
const char* CInputContext::GetImageLibraryFtpRaw() const { return m_pCGI->GetImageLibraryFtpRaw(); } 
const char* CInputContext::GetImageLibraryFtpPublic() const { return m_pCGI->GetImageLibraryFtpPublic(); } 
const char* CInputContext::GetImageLibraryAwaitingModeration() const { return m_pCGI->GetImageLibraryAwaitingModeration(); } 
const char* CInputContext::GetImageLibraryFailedModeration() const { return m_pCGI->GetImageLibraryFailedModeration(); } 
const char* CInputContext::GetImageLibraryTmpLocalDir() const { return m_pCGI->GetImageLibraryTmpLocalDir(); } 
const char* CInputContext::GetImageLibraryPublicUrlBase() const { return m_pCGI->GetImageLibraryPublicUrlBase(); } 
const char* CInputContext::GetImageLibraryRawUrlBase() const { return m_pCGI->GetImageLibraryRawUrlBase(); } 
const char* CInputContext::GetSiteRoot() const { return m_pCGI->GetSiteRoot(); } 

/*********************************************************************************************************************/

/*********************************************************************************

	bool CInputContext::DoesCurrentSiteAllowOwnerHiding()

		Author:		Steven Francis
        Created:	05/07/2006
        Inputs:		-
        Outputs:	-
        Returns:	
        Purpose:	Wrapper to check site options to see if the current site is
					one that allows the owners of an article to hide other users comments

*********************************************************************************/
bool CInputContext::DoesCurrentSiteAllowOwnerHiding()
{
	return m_pCGI->DoesCurrentSiteAllowOwnerHiding();
}

bool CInputContext::DoesSiteAllowOwnerHiding(int iSiteID)
{
	return m_pCGI->DoesSiteAllowOwnerHiding(iSiteID);
}

/*********************************************************************************

	bool CInputContext::DoesCurrentHaveDistressMsgAccount()

		Author:		Martin Robb
        Created:	19/09/2006
        Inputs:		- iSiteId - Site to check for siteoption
        Outputs:	- iUserId of user for sending distress messages.
        Returns:	
        Purpose:	- Returns true is site uses a distress message account.
					- This userId will be used for sending distress messages during moderation.

*********************************************************************************/
bool CInputContext::DoesSiteHaveDistressMsgUserId( int iSiteId, int& iUserId )
{
	return m_pCGI->DoesSiteHaveDistressMsgUserId(iSiteId, iUserId);
}

/*********************************************************************************

	bool CGI::DoesCurrentSiteHaveSiteOptionSet()

		Author:		Steven Francis
        Created:	15/08/2006
        Inputs:		-
        Outputs:	-
        Returns:	
        Purpose:	Wrapper to check whether the current site has the given SiteOption set

*********************************************************************************/
bool CInputContext::DoesCurrentSiteHaveSiteOptionSet(const TDVCHAR* pSection, const TDVCHAR* pName)
{
	return m_pCGI->DoesCurrentSiteHaveSiteOptionSet(pSection, pName);
}

/*********************************************************************************

	CTDVString CInputContext::GetCurrentSiteOptionString(const TDVCHAR* pSection, const TDVCHAR* pName)

		Author:		Mark Howitt
        Created:	20/06/2007
        Inputs:		pSection - The site option section the option belongs to
					pName - The name of the option you are wanting the value for.
        Outputs:	-
        Returns:	The value for the site option requested
        Purpose:	Wrapper to get the requested site option value

*********************************************************************************/
CTDVString CInputContext::GetCurrentSiteOptionString(const TDVCHAR* pSection, const TDVCHAR* pName)
{
	return m_pCGI->GetCurrentSiteOptionString(pSection, pName);
}

int CInputContext::GetSiteMinAge(int iSiteID)
{
	return m_pCGI->GetSiteMinAge(iSiteID);
}

int CInputContext::GetSiteMaxAge(int iSiteID)
{
	return m_pCGI->GetSiteMaxAge(iSiteID);
}

/*********************************************************************************

	int CInputContext::GetDefaultShow(int iSiteID)

		Author:		James Conway
        Created:	30/11/2006
        Inputs:		- iSiteId - Site to check for siteoption
        Outputs:	
        Returns:	Default show for the site.
        Purpose:	Gets the default number of posts to show on a page.

*********************************************************************************/
int CInputContext::GetDefaultShow( int iSiteId )
{
	return m_pCGI->GetDefaultShow(iSiteId);
}

/*********************************************************************************

	int CGI::GetCurrentSiteOptionInt(const TDVCHAR* pSection, const TDVCHAR* pName)

		Author:		Steve Francis
        Created:	03/08/2007
        Inputs:		pSection - The site option section the option belongs to
					pName - The name of the option you are wanting the value for.
        Outputs:	-
        Returns:	The value for the site option requested
        Purpose:	Gets the requested site option value int

*********************************************************************************/
int CInputContext::GetCurrentSiteOptionInt(const TDVCHAR* pSection, const TDVCHAR* pName)
{
	return m_pCGI->GetCurrentSiteOptionInt(pSection, pName);
}

/*********************************************************************************

	bool CInputContext::IsDateRangeInclusive(int iSiteID)

		Author:		James Conway
        Created:	13/08/2007
        Inputs:		- iSiteId - site to check 
        Outputs:	
        Returns:	True if site uses inclusive date ranges, false otherwise
        Purpose:	Check if date range is inclusive.

*********************************************************************************/
bool CInputContext::IsDateRangeInclusive( int iSiteId )
{
	return m_pCGI->IsDateRangeInclusive(iSiteId);
}

/*********************************************************************************

		Author:		Mark Howitt
		Created:	29/07/2008
		Inputs:		iSIteID - The id of the site you want to check against
		Returns:	True if the site uses Identity, false if it uses profileAPI
		Purpose:	Checks to see which signin system a given site uses

*********************************************************************************/
bool CInputContext::GetSiteUsesIdentitySignIn(int iSiteID)
{
	return m_pCGI->GetSiteUsesIdentitySignIn(iSiteID);
}