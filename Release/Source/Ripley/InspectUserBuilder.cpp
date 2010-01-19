// InspectUserBuilder.cpp: implementation of the CInspectUserBuilder class.
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
#include "InspectUserBuilder.h"
#include "WholePage.h"
#include "PageUI.h"
#include "GuideEntry.h"
#include "TDVAssert.h"
#include "Forum.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CInspectUserBuilder::CInspectUserBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	28/03/2001
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CInspectUserBuilder object.

*********************************************************************************/

CInspectUserBuilder::CInspectUserBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext),
	m_pSP(NULL),
	m_pViewer(NULL),
	m_User(inputContext),
	m_sCommand("View"),
	m_sErrorXML(""),
	m_sMessageXML(""),
	m_iUserID(0)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************

	CInspectUserBuilder::~CInspectUserBuilder()

	Author:		Kim Harries
	Created:	28/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CInspectUserBuilder::~CInspectUserBuilder()
{
	// make sure member objects are deleted
	delete m_pSP;
	m_pSP = NULL;
}

/*********************************************************************************

	CWholePage* CInspectUserBuilder::Build()

	Author:		Kim Harries
	Created:	28/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the page allowing staff to inspect a user.

*********************************************************************************/

bool CInspectUserBuilder::Build(CWholePage* pWholePage)
{
	bool			bSuccess = true;
	// get the viewing user
	m_pViewer = m_InputContext.GetCurrentUser();
	// initiliase the whole page object and set the page type
	bSuccess = InitPage(pWholePage, "INSPECT-USER",true);

	// do an error page if not an editor
	if (m_pViewer == NULL || !m_pViewer->GetIsEditor())
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot inspect users unless you are logged in as an Editor.</ERROR>");
	}
	else
	{
		// get parameters from the URL
		// if fetching a new users details then we get a different parameter value from the query
		if (m_InputContext.ParamExists("FetchUser"))
		{
			m_iUserID = m_InputContext.GetParamInt("FetchUserID");
		}
		else if (m_InputContext.ParamExists("UserID"))
		{
			m_iUserID = m_InputContext.GetParamInt("UserID");
		}
		else if (m_InputContext.ParamExists("ID"))
		{
			m_iUserID = m_InputContext.GetParamInt("ID");
		}
		else
		{
			m_iUserID = 0;
		}
		// if no user ID given, then default to the viewing user
		if (m_iUserID == 0)
		{
			m_iUserID = m_pViewer->GetUserID();
		}
		// now get the user who we are inspecting
		m_User.SetSiteID(m_InputContext.GetSiteID());
		if (m_User.CreateFromID(m_iUserID, false))
		{
			// display full data on this user
			m_User.SetEverythingVisible();
			// process any submission and then fetch details on this user
			CTDVString	sFormXML = "";
			// first process any submission that may have been made
			bSuccess = bSuccess && ProcessSubmission();
			// then create the XML for the form to be displayed
			bSuccess = bSuccess && CreateForm(&sFormXML);
			// insert the form XML into the page
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", sFormXML);
			// insert sites list
			CTDVString sSiteXML;
			bSuccess = bSuccess && m_InputContext.GetSiteListAsXML(&sSiteXML, 1);
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", sSiteXML);

			// See if we've been asked to find matching accounts for this user!
			if (m_sCommand.CompareText("FindMatchingDetails"))
			{
				// We want to find matching account for the users first, last names and email
				CTDVString sMatchingAccounts;
				if (m_User.GetMatchingUserAccounts(sMatchingAccounts))
				{
					bSuccess = bSuccess && pWholePage->AddInside("H2G2",sMatchingAccounts);
				}
				else
				{
					bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='MATCHING-ACCOUNTS'>Failed while finding matching user accounts.</ERROR>");
				}
			}
		}
		else
		{
			// couldn't get user so give an error page
			bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='INVALID-USERID'>No user exists with the user ID supplied in the request.</ERROR>");
		}
	}
	TDVASSERT(bSuccess, "CInspectUserBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CInspectUserBuilder::ProcessSubmission()

	Author:		Kim Harries
	Created:	28/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Processes any submission of this page.

*********************************************************************************/

bool CInspectUserBuilder::ProcessSubmission()
{
	CTDVString	sUserName;
	CTDVString	sFirstNames;
	CTDVString	sLastName;
	CTDVString	sEmailAddress;
	CTDVString	sPassword;
	CTDVString  sTitle;
	CTDVString  sSiteSuffix;
	int			iStatus = 0;
	CTDVString	sScoutInterval;
	int			iScoutQuota = 0;
	int			iSubQuota = 0;
	bool		bSuccess = true;

	// first find out the command type
	if (m_InputContext.ParamExists("cmd"))
	{
		m_InputContext.GetParamString("cmd", m_sCommand);
	}
	else
	if (m_InputContext.ParamExists("FetchUser") || m_InputContext.ParamExists("Refresh"))
	{
		// if fetching new details then never do anything until they have been viewed
		m_sCommand = "View";
	}
	else if (m_InputContext.ParamExists("CreateUserGroup"))
	{
		m_sCommand = "CreateUserGroup";
	}
	else if (m_InputContext.ParamExists("DeactivateAccount"))
	{
		m_sCommand = "DeactivateAccount";
	}
	else if (m_InputContext.ParamExists("ReactivateAccount"))
	{
		m_sCommand = "ReactivateAccount";
	}
	else if (m_InputContext.ParamExists("ClearBBCDetails"))
	{
		m_sCommand = "ClearBBCDetails";
	}
	else if (m_InputContext.ParamExists("UpdateDetails"))
	{
		m_sCommand = "UpdateDetails";
	}
	else if (m_InputContext.ParamExists("UpdateGroups"))
	{
		m_sCommand = "UpdateGroups";
	}
	else if (m_InputContext.ParamExists("UpdateScoutInfo"))
	{
		m_sCommand = "UpdateScoutInfo";
	}
	else if (m_InputContext.ParamExists("UpdateSubInfo"))
	{
		m_sCommand = "UpdateSubInfo";
	}
	else
	{
		m_sCommand = "View";
	}
	// get an SP object if we haven't already
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if we still have no SP then die like the pigs we are
	if (m_pSP == NULL)
	{
		return false;
	}
	// set message XML and error XML to blank
	m_sMessageXML = "";
	m_sErrorXML = "";
	// process each one in the appropriate manner
	if (m_sCommand.CompareText("DeactivateAccount"))
	{
		if (!m_pSP->DeactivateAccount(m_iUserID))
		{
			// only show any kind of message if the update failed
			m_sErrorXML << "<ERROR TYPE='DEACTIVATION-FAILED'>Failed to deactivate account!</ERROR>";
		}
		else
		{
			// if successful then destroy the user object and re-load the data for this user
			// this ensures data is up to date
			m_User.Destroy();
			m_User.CreateFromID(m_iUserID);
		}
	}
	else if (m_sCommand.CompareText("ReactivateAccount"))
	{
		if (!m_pSP->ReactivateAccount(m_iUserID))
		{
			// only show any kind of message if the update failed
			m_sErrorXML << "<ERROR TYPE='ACTIVATION-FAILED'>Failed to activate account!</ERROR>";
		}
		else
		{
			// if successful then destroy the user object and re-load the data for this user
			// this ensures data is up to date
			m_User.Destroy();
			m_User.CreateFromID(m_iUserID);
		}
	}
	else if (m_sCommand.CompareText("ClearBBCDetails"))
	{
		if (!m_pSP->ClearBBCDetails(m_iUserID))
		{
			// only show any kind of message if the update failed
			m_sErrorXML << "<ERROR TYPE='CLEAR-BBC-FAILED'>Failed to clear this users BBC login details!</ERROR>";
		}
		else
		{
			// if successful then destroy the user object and re-load the data for this user
			// this ensures data is up to date
			m_User.Destroy();
			m_User.CreateFromID(m_iUserID);
		}
	}
	else if (m_sCommand.CompareText("UpdateDetails"))
	{
		// fetch the new user details from the request
		// and set each new value in the user object if it is present
		if (m_InputContext.GetParamString("UserName", sUserName))
		{
			m_User.SetUsername(sUserName);
		}
		if (m_InputContext.GetParamString("EmailAddress", sEmailAddress))
		{
			m_User.SetEmail(sEmailAddress);
		}
		if (m_InputContext.GetParamString("FirstNames", sFirstNames))
		{
			m_User.SetFirstNames(sFirstNames);
		}
		if (m_InputContext.GetParamString("LastName", sLastName))
		{
			m_User.SetLastName(sLastName);
		}
		if (m_InputContext.GetParamString("Password", sPassword))
		{
			m_User.SetPassword(sPassword);
		}
		iStatus = m_InputContext.GetParamInt("Status");
		if (iStatus > 0)
		{
			m_User.SetStatus(iStatus);
		}
		if (m_InputContext.GetParamString("Title",sTitle))
		{
			m_User.SetTitle(sTitle);
		}
		if (m_InputContext.GetParamString("SiteSuffix",sSiteSuffix))
		{
			m_User.SetSiteSuffix(sSiteSuffix);
		}
		// call the update method to store these values
		if (!m_User.UpdateDetails())
		{
			// if the update failed then put in some error XML
			m_sErrorXML << "<ERROR TYPE='UPDATE-DETAILS-FAILED'>Failed to update this users details!</ERROR>";
		}
	}
	else if (m_sCommand.CompareText("CreateUserGroup"))
	{
		const CTDVString	sValidFirstChar = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_";
		const CTDVString	sValidChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-.";
		CTDVString	sNewGroupName = "";

		m_InputContext.GetParamString("NewGroupName", sNewGroupName);
		if (sNewGroupName.GetLength() == 0)
		{
			// if no group name was supplied then give an error
			m_sErrorXML << "<ERROR TYPE='NO-NEW-GROUPNAME'>You did not supply a name for the new group you wish to create!</ERROR>";
		}
		else if (sNewGroupName.GetLength() > 50)
		{
			// if no group name was supplied then give an error
			m_sErrorXML << "<ERROR TYPE='GROUPNAME-TOO-LONG'>Unable to create new user group: group name supplied was longer than 50 characters.</ERROR>";
		}
		else
		{
			CTDVString	sReason = "";
			TDVCHAR		ch;
			int			i = 1;
			bool		bOK = true;

			// check that there are no invalid characters in the name - it has to meet the
			// rules for being a valid XML tag name since it will be output as one
			ch = sNewGroupName.GetAt(0);
			// check first char is a letter or underscore
			if (sValidFirstChar.Find(ch) < 0)
			{
				bOK = false;
				sReason = "group name started with an invalid character";
			}
			else if (sNewGroupName.Left(3).CompareText("xml"))
			{
				// name mustn't start with the letters 'xml' in any combination of upper or lower case
				bOK = false;
				sReason << "group name started with \'xml\'";
			}
			else
			{
				// check every other char is a letter, digit, underscore, hyphen or period
				while (bOK && i < sNewGroupName.GetLength())
				{
					ch = sNewGroupName.GetAt(i);
					if (sValidChars.Find(ch) < 0)
					{
						bOK = false;
						sReason = "group name contains an invalid character";
					}
					i++;
				}
			}
			// if name is okay then try to add it
			if (bOK)
			{
				bOK = bOK && m_pSP->CreateNewUserGroup(m_pViewer->GetUserID(), sNewGroupName);
				// check for success
				bOK = bOK && m_pSP->GetIntField("Success");
				// if this failed it will be because the group name already exists
				if (!bOK)
				{
					sReason = "group name already exists";
				}
				else
				{
					// Send signal to other servers to refresh groups cache
					CTDVString signal = "/Signal?action=recache-groups";
					if(!m_InputContext.Signal(signal))
					{
						TDVASSERT(false, "Failed to signal recache groups");
					}

					// Refresh local groups cache. Signal also reaches local
					// server, but only if local ip is in config file, and I
					// don't like relying on config file. So update cache anyway. 
					//

					//m_InputContext.GroupDataUpdated();
				}
			}
			// if something wrong then provide an error message
			if (!bOK)
			{
				m_sErrorXML << "<ERROR TYPE='GROUPNAME-INVALID'>Unable to create new user group: " << sReason << ".</ERROR>";
			}
		}
	}
	else if (m_sCommand.CompareText("UpdateGroups"))
	{
		CTDVString	sGroupName;
		int			iParams = m_InputContext.GetParamCount("GroupsMenu");

		// first clear this users group list
		// and then add in all their new groups
		m_User.ClearGroupMembership();
		// read each group name passed as a parameter and set the user object to be a member of that group
		for (int i = 0; i < iParams; i++)
		{
			m_InputContext.GetParamString("GroupsMenu", sGroupName, i);
			sGroupName.MakeUpper();
			m_User.SetIsGroupMember(sGroupName, true);
		}
		// then update the user
		// call the update method to store these values
		if (!m_User.UpdateDetails())
		{
			// if the update failed then put in some error XML
			m_sErrorXML << "<ERROR TYPE='UPDATE-GROUPS-FAILED'>Failed to update this users group membership!</ERROR>";
		}
		else
		{
			// Send signal to other servers to refresh groups cache
			CTDVString signal = "/Signal?action=recache-groups";
			signal << "&userid=" << m_iUserID;
			signal << "&siteid=" << m_InputContext.GetSiteID();
			if(!m_InputContext.Signal(signal))
			{
				TDVASSERT(false, "Failed to signal recache groups");
			}

			// Refresh local groups cache. Signal also reaches local
			// server, but only if local ip is in config file, and I
			// don't like relying on config file. So update cache anyway. 
			//

			//m_InputContext.GroupDataUpdated();
		}
	}
	else if (m_sCommand.CompareText("UpdateScoutInfo"))
	{
		m_InputContext.GetParamString("ScoutInterval", sScoutInterval);
		iScoutQuota = m_InputContext.GetParamInt("ScoutQuota");
		if (!m_pSP->UpdateScoutDetails(m_iUserID, iScoutQuota, sScoutInterval))
		{
			// if the update failed then put in some error XML
			m_sErrorXML << "<ERROR TYPE='SCOUT-UPDATE'>Failed to update this users scout info!</ERROR>";
		}
	}
	else if (m_sCommand.CompareText("UpdateSubInfo"))
	{
		iSubQuota = m_InputContext.GetParamInt("SubQuota");
		if (!m_pSP->UpdateSubDetails(m_iUserID, iSubQuota))
		{
			// if the update failed then put in some error XML
			m_sErrorXML << "<ERROR TYPE='SUB-UPDATE'>Failed to update this users sub editor info!</ERROR>";
		}
	}
	else if (m_sCommand.CompareText("MoveToSite"))
	{
/*
	MoveToSite is no longer valid with per-site personal spaces
		int iNewSiteID = m_InputContext.GetParamInt("SitesList");
		int iJournalID = m_InputContext.GetParamInt("moveObjectID");

		if (!CForum::MoveToSite(m_InputContext, iJournalID, iNewSiteID))
		{
			// if the update failed then put in some error XML
			m_sErrorXML << "<ERROR TYPE='MOVE-TO-SITE'>Failed to move journal!</ERROR>";
			bSuccess = false;
		}
*/
	}
	else if (m_sCommand.CompareText("UpdateJournalModerationStatus"))
	{
		if (m_pViewer->GetIsEditor() || m_pViewer->GetIsSuperuser())
		{
			int iNewStatus = m_InputContext.GetParamInt("status");

			if (!m_pSP->UpdateUserJournalModerationStatus(m_iUserID,iNewStatus))
			{
				// if the update failed then put in some error XML
				m_sErrorXML << "<ERROR TYPE='USER-JOURNAL-MOD-STATUS-UPDATE'>Failed to update the moderation status of the user's journal!</ERROR>";
			}
		}
	}
	else if (m_sCommand.CompareText("UpdateArticleModerationStatus"))
	{
		if (m_pViewer->GetIsEditor() || m_pViewer->GetIsSuperuser())
		{
			int iNewStatus = m_InputContext.GetParamInt("status");

			if (!CGuideEntry::UpdateArticleModerationStatus(m_InputContext,m_User.GetMasthead(),iNewStatus))
			{
				// if the update failed then put in some error XML
				m_sErrorXML << "<ERROR TYPE='USER-ARTICLE-MOD-STATUS-UPDATE'>Failed to update the moderation status of the user's article!</ERROR>";
			}
		}
	}

	return bSuccess;
}

/*********************************************************************************

	bool CInspectUserBuilder::CreateForm(CTDVString* psFormXML)

	Author:		Kim Harries
	Created:	28/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Creates the XML for the form on the inspect user page.

*********************************************************************************/

bool CInspectUserBuilder::CreateForm(CTDVString* psFormXML)
{
	TDVASSERT(psFormXML != NULL, "NULL psFormXML in CInspectUserBuilder::CreateForm(...)");
	// fail if no output variable given
	if (psFormXML == NULL)
	{
		return false;
	}
	// get an SP object if we haven't already
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if we still have no SP then die like the pigs we are
	if (m_pSP == NULL)
	{
		return false;
	}
	// make sure we also have a CArticleList object
	// - we can reuse this object multiple times for any article lists we need
	// without needing to delete it or its contents externally
	CArticleList ArticleList(m_InputContext);

	CTDVString	sGroupsListXML;
	CTDVString	sGroupName;
	CTDVString	sUserXML;
	CTDVString	sTemp;
	bool		bSuccess = true;

	// fetch the list of available groups
	bSuccess = bSuccess && m_pSP->FetchUserGroupsList();
	sGroupsListXML = "<GROUPS-LIST>";
	while (!m_pSP->IsEOF())
	{
		m_pSP->GetField("Name", sGroupName);
		sGroupsListXML << "<GROUP NAME='" << sGroupName << "' ID='";
		sGroupName.MakeUpper();
		sGroupsListXML << sGroupName << "'/>";
		m_pSP->MoveNext();
	}
	sGroupsListXML << "</GROUPS-LIST>";

	bSuccess = bSuccess && m_User.GetAsString(sUserXML);
	// intialise form
	*psFormXML = "";
	*psFormXML << "<INSPECT-USER-FORM>";
	*psFormXML << sGroupsListXML;
	*psFormXML << sUserXML;

	// Add the user's article's moderation status
	int iMastHead = m_User.GetMasthead();
	int iMastHeadModerationStatus = 0;
	m_pSP->GetArticleModerationStatus(iMastHead,iMastHeadModerationStatus);
	*psFormXML << "<ARTICLE-INFO>";
	*psFormXML << "<MODERATIONSTATUS ID='" << iMastHead << "'>";
	*psFormXML << iMastHeadModerationStatus;
	*psFormXML << "</MODERATIONSTATUS>";
	*psFormXML << "</ARTICLE-INFO>";

	// put journal sited id information
	int iJournalID;
	if (m_User.GetJournal(&iJournalID) && iJournalID > 0)
	{
		int iJournalSiteID;
		CForum forum(m_InputContext);
		bSuccess = bSuccess && forum.GetForumSiteID(iJournalID,0, iJournalSiteID);

		int iModerationStatus = 0;
		bSuccess = bSuccess && CForum::GetForumModerationStatus(m_InputContext, 
													iJournalID, iModerationStatus);
		*psFormXML << "<JOURNAL-INFO>";
		*psFormXML << "<SITEID>" << iJournalSiteID << "</SITEID>";
		*psFormXML << "<MODERATIONSTATUS ID='" << iJournalID << "'>";
		*psFormXML << iModerationStatus << "</MODERATIONSTATUS>";
		*psFormXML << "</JOURNAL-INFO>";
	}

	// do scout data if user is scout
	if (m_User.GetIsScout() || m_User.GetIsEditor())
	{
		CTDVString	sInterval = "month";
		int			iQuota = 3;
		int			iTotalRecommendations = 0;
		int			iRecommendationsLastInterval = 0;

		*psFormXML << "<SCOUT-INFO>";
		// first get the basic scout info, e.g. quota etc.
		bSuccess = bSuccess && m_pSP->FetchScoutStats(m_iUserID);
		if (bSuccess && !m_pSP->IsEOF())
		{
			if (!m_pSP->IsNULL("Quota"))
			{
				iQuota = m_pSP->GetIntField("Quota");
			}
			if (!m_pSP->IsNULL("Interval"))
			{
				m_pSP->GetField("Interval", sInterval);
			}
			iTotalRecommendations = m_pSP->GetIntField("TotalRecommendations");
			iRecommendationsLastInterval = m_pSP->GetIntField("RecommendationsLastInterval");
			// put the data in the XML
			*psFormXML << "<QUOTA>" << iQuota << "</QUOTA>";
			*psFormXML << "<INTERVAL>" << sInterval << "</INTERVAL>";
			*psFormXML << "<TOTAL-RECOMMENDATIONS>" << iTotalRecommendations << "</TOTAL-RECOMMENDATIONS>";
			*psFormXML << "<RECOMMENDATIONS-LAST-INTERVAL>" << iRecommendationsLastInterval << "</RECOMMENDATIONS-LAST-INTERVAL>";
		}
		// then get info on the scouts recent recommendations
		// if a different interval from this users default one is specified in the query then use this
		CTDVString	sShowRecommendationsPeriod = sInterval;
		if (m_InputContext.ParamExists("RecommendationsPeriod"))
		{
			m_InputContext.GetParamString("RecommendationsPeriod", sShowRecommendationsPeriod);
		}
		// make sure any existing list is destroyed first
		bSuccess = bSuccess && ArticleList.Destroy();
		// create the list then insert its XML into the form
		bSuccess = bSuccess && ArticleList.CreateScoutRecommendationsList(m_iUserID, sShowRecommendationsPeriod, 1);
		// insert the contents into our XML output
		// TODO: would be better to insert this object after parsing the form XML
		bSuccess = bSuccess && ArticleList.GetAsString(sTemp);
		if (bSuccess)
		{
			*psFormXML << sTemp;
		}
		*psFormXML << "</SCOUT-INFO>";
	}
	// do sub data if user is a sub
	if (m_User.GetIsSub() || m_User.GetIsEditor())
	{
		int	iQuota = 4;
		int	iCurrentAllocations = 0;
		int	iSubbedEntries = 0;

		*psFormXML << "<SUB-INFO>";
		bSuccess = bSuccess && m_pSP->FetchSubEditorStats(m_iUserID);
		if (bSuccess && !m_pSP->IsEOF())
		{
			if (!m_pSP->IsNULL("Quota"))
			{
				iQuota = m_pSP->GetIntField("Quota");
			}
			iCurrentAllocations = m_pSP->GetIntField("CurrentAllocations");
			iSubbedEntries = m_pSP->GetIntField("SubbedEntries");
			*psFormXML << "<QUOTA>" << iQuota << "</QUOTA>";
			*psFormXML << "<CURRENT-ALLOCATIONS>" << iCurrentAllocations << "</CURRENT-ALLOCATIONS>";
			*psFormXML << "<TOTAL-SUBBED>" << iSubbedEntries << "</TOTAL-SUBBED>";
		}
		// then get info on the subs recent entries
		CTDVString	sSubAllocationsPeriod = "month";
		if (m_InputContext.ParamExists("SubAllocationsPeriod"))
		{
			m_InputContext.GetParamString("SubAllocationsPeriod", sSubAllocationsPeriod);
		}
		// make sure any existing list is destroyed first
		bSuccess = bSuccess && ArticleList.Destroy();
		// create the list then insert its XML into the form
		bSuccess = bSuccess && ArticleList.CreateSubsEditorsAllocationsList(m_iUserID, sSubAllocationsPeriod, 1);
		// insert the contents into our XML output
		// TODO: would be better to insert this object after parsing the form XML
		sTemp = "";
		bSuccess = bSuccess && ArticleList.GetAsString(sTemp);
		if (bSuccess)
		{
			*psFormXML << sTemp;
		}
		*psFormXML << "</SUB-INFO>";
	}
	// put any error and message XML into the form before closing the tag
	*psFormXML << m_sMessageXML;
	*psFormXML << m_sErrorXML;
	*psFormXML << "</INSPECT-USER-FORM>";

	return bSuccess;
}

#endif // _ADMIN_VERSION
