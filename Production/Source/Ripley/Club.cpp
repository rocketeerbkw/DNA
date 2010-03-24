// Club.cpp: implementation of the CClub class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "User.h"
#include "Club.h"
#include "InputContext.h"
#include "ExtraInfo.h"
#include "GuideEntry.h"
#include "VotePageBuilder.h"
#include "Category.h"
#include "Link.h"
#include "ProfanityFilter.h"
#include "TDVAssert.h"
#include "ModerationStatus.h"
#include "TagItem.h"
#include "ArticleMember.h"
#include "ClubMember.h"
#include "EventQueue.h"
#include "StoredProcedure.h"
#include "ImageLibrary.h"
#include "UploadedImage.h"
#include "Config.h"
#include "DnaUrl.h"
#include "URLFilter.h"
#include "EmailAddressFilter.h"
#include "ArticleEditForm.h"

static const char* NOPREVIEWPICTURE = NULL;
static const char* KEEPTHEPICTURE = NULL;
//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CClub::CClub(CInputContext& inputContext)
:
CXMLObject(inputContext),
m_iClubID(0),
m_ih2g2ID(0),
m_iOwnerTeamID(0),
m_iMemberTeamID(0),
m_iJournalID(0),
m_iForumID(0),
m_iSiteID(1),
m_iClubForumType(0),
m_iStatus(ClubStatus::OPEN),
m_bInitialised(false),
m_PermissionUser(0),
m_PermissionClub(0),
m_iHidden(0),
m_iGuideStatus(0),
m_iClubType(CGuideEntry::TYPECLUB),
m_bCanAutoJoinMember(false),
m_bCanAutoJoinOwner(false),
m_bCanBecomeMember(false),
m_bCanBecomeOwner(false),
m_bCanApproveMembers(false),
m_bCanApproveOwners(false),
m_bCanDemoteOwners(false),
m_bCanDemoteMembers(false),
m_bCanViewActions(false),
m_bCanView(false),
m_bCanEdit(false),
m_iProfanityTriggered(0),
m_iNonAllowedURLTriggered(0)
{

}

CClub::~CClub()
{

}

/*********************************************************************************

	bool CClub::Initialise(int iID, bool bIDIsClubID, bool bEditing = false)

	Author:		Dharmesh Raithatha
	Created:	5/12/2003
	Inputs:		iID - The ClubId or h2g2ID that you want to initialise
	Outputs:	-
	Returns:	true if successfully got info about the club. false otherwise
	Purpose:	Given the club id or the club's h2g2id this method will initialise the club and
				create the xml tree with this information.

*********************************************************************************/

bool CClub::Initialise(int iID, bool bIDIsClubID, bool bShowHidden)
{
	Clean();

	//Get the Club information from the database

	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		return SetDNALastError("Club","InitStoredProcedure","Failed to initialise the Stored Procedure");
	}

	bool bSuccess = false;

	bool bOK = false;
	if (bIDIsClubID)
	{
		bOK = mSP.FetchClubDetailsViaClubID(iID,bSuccess);
	}
	else
	{
		bOK = mSP.FetchClubDetailsViaH2G2ID(iID,bSuccess);
	}

	if (!bOK)
	{
		return SetDNALastError("Club","database","An Error occurred while accessing the database");
	}

	if (!bSuccess)
	{
		return SetDNALastError("Club","Parameter","The ClubID was invalid");
	}

	m_iClubID = mSP.GetIntField("ClubID");
	m_ih2g2ID = mSP.GetIntField("h2g2ID");
	m_iOwnerTeamID = mSP.GetIntField("OwnerTeam");
	m_iMemberTeamID = mSP.GetIntField("MemberTeam");
	m_iForumID = mSP.GetIntField("ClubForum");
	m_iJournalID = mSP.GetIntField("Journal");
	m_iSiteID = mSP.GetIntField("SiteID");
	m_iStatus = mSP.GetIntField("Status");
	m_iClubForumType = mSP.GetIntField("ClubForumType");
	mSP.GetField("Name",m_sName);
	m_dDateCreated = mSP.GetDateField("DateCreated");
	m_iHidden = mSP.GetIntField("Hidden");
	m_iGuideStatus = mSP.GetIntField("GuideStatus");

	//Clubs last updated is the most recent of the club, club's guide entry and clubs forum.
	CTDVDateTime dclublastupdated = mSP.GetDateField("ClubLastUpdated");
	CTDVDateTime darticlelastupdated = mSP.GetDateField("ArticleLastUpdated");
	CTDVDateTime dclubforumlastupdated = mSP.GetDateField("ClubForumLastUpdated");
	m_dLastUpdated = dclublastupdated > darticlelastupdated ? dclublastupdated : darticlelastupdated;
	m_dLastUpdated = dclubforumlastupdated > m_dLastUpdated ? dclubforumlastupdated : m_dLastUpdated;

	mSP.GetField("bodytext",m_sGuideML);

	// Get the type of club we're dealing with
	m_iClubType = mSP.GetIntField("Type");

	//if (IsDeleted())
	//{
	//	return SetDNALastError("Club","ClubDeleted","The club has been deleted");
//	}

	if (m_iClubForumType == 0)
	{
		// When the club forum type is 0, assume this means that a value has yet to be 
		// set against the club explicitly
		// In this case make the club have the guest book style, if the site deems it so
		if (m_InputContext.DoesSiteUseArticleGuestBookForums(m_InputContext.GetSiteID()))
		{
			m_iClubForumType = 1;
		}
	}

	CUser* pViewer = m_InputContext.GetCurrentUser();

	// Are we going to show hidden information?
	int iOriginalHiddenStatus = m_iHidden;
	if (bShowHidden && IsUserAllowedToEditClub(m_InputContext.GetCurrentUser(), m_iClubID) )
	{
		// If the user is allowed to edit the club, reset the hidden state to 0,
		// ensuring they will be able to see the club content
		m_iHidden = 0;
	}

	CTDVString sDateCreated,sLastUpdated;
	if (!CreateDateXML("DATECREATED",m_dDateCreated,sDateCreated))
	{
		sDateCreated.Empty();
	}

	if (!CreateDateXML("LASTUPDATED",m_dLastUpdated,sLastUpdated))
	{
		sLastUpdated.Empty();
	}


	CTDVString sRelatedMembersXML;
	if (!CreateRelatedMembersXML(m_iClubID,sRelatedMembersXML))
	{
		sRelatedMembersXML.Empty();
	}
		
	CTDVString sXML;
	sXML << "<CLUBINFO ID='" << m_iClubID << "' STATUS='";
	
	if (m_iStatus == OPEN)
	{
		sXML << "OPEN'>";
	}
	else if (m_iStatus == CLOSED)
	{
		sXML << "CLOSED'>";
	}
	else
	{
		sXML << "NOSTATUS'>";
	}

	CTDVString sName(m_sName);
	if (m_iHidden != 0)
	{
		if ( m_iHidden == CStoredProcedure::HIDDENSTATUSUSERHIDDEN )
			sName = "User Hidden.";
		else
			sName = "Hidden pending moderation";
	}

	sXML << "<NAME>" << sName << "</NAME>";
	sXML << "<H2G2ID ID='" << m_ih2g2ID << "'/>";
	sXML << "<FORUM ID='" << m_iForumID << "' TYPE='" << m_iClubForumType << "'/>";
	sXML << "<OWNERTEAM ID='" << m_iOwnerTeamID << "'/>";
	sXML << "<MEMBERTEAM ID='" << m_iMemberTeamID << "'/>";
	sXML << "<SITEID ID='" << m_iSiteID << "'/>";
	sXML << "<JOURNAL ID='" << m_iJournalID << "'/>";

	//If overriding hidden status with showhidden include actual hidden status too.
	if ( bShowHidden )
		sXML << "<HIDDEN " << "ORIGINALHIDDENSTATUS=""" << iOriginalHiddenStatus << """>" << m_iHidden << "</HIDDEN>";
	else if ( m_iHidden > 0 )
		sXML << "<HIDDEN>" << m_iHidden << "</HIDDEN>";

	sXML << sRelatedMembersXML;
	sXML << sDateCreated;
	sXML << sLastUpdated;

	CCategory Cat(m_InputContext);
	if (Cat.GetClubCrumbTrail(m_iClubID))
	{
		CTDVString sCrumbTrailXML;
		Cat.GetAsString(sCrumbTrailXML);
		sXML << sCrumbTrailXML;
	}

	sXML << "</CLUBINFO>";

	if (!CreateFromXMLText(sXML))
	{
		delete m_pTree;
		m_pTree = NULL;
		return SetDNALastError("Club","XML","Failed to generate XML");
	}
	
	m_bInitialised = true;
	return true;
}


/*********************************************************************************

	bool CClub::InitialiseViaClubID(int iClubID, bool bEditing = false)

	Author:		Mark Neves
	Created:	04/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Allows a club to be initialised via club ID

*********************************************************************************/

bool CClub::InitialiseViaClubID(int iClubID, bool bShowHidden)
{
	return Initialise(iClubID,true,bShowHidden);
}

/*********************************************************************************

	bool CClub::InitialiseViaH2G2ID(int ih2g2ID, bool bEditing = false)

	Author:		Mark Neves
	Created:	04/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Allows a club to be initialised via h2g2 ID

*********************************************************************************/

bool CClub::InitialiseViaH2G2ID(int ih2g2ID, bool bShowHidden)
{
	return Initialise(ih2g2ID,false,bShowHidden);
}

/*********************************************************************************

	bool CClub::CreateRelatedMembersXML(int iClubID,CTDVString& sRelatedMembersXML)

	Author:		Mark Neves
	Created:	15/07/2003
	Inputs:		iClubID = the club you're interested in
	Outputs:	sRelatedMembersXML contains the XML
	Returns:	true if sRelatedMembersXML contains valid XML, false otherwise
	Purpose:	Builds a <RELATEDMEMBERS> structure for this club
				If the function returns false, do not use the returned XML, as it
				is not guaranteed to be valid.

*********************************************************************************/

bool CClub::CreateRelatedMembersXML(int iClubID,CTDVString& sRelatedMembersXML)
{
	sRelatedMembersXML = "<RELATEDMEMBERS>";

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("Club","InitStoredProcedure","Failed to initialise the Stored Procedure");
	}

	bool bSuccess = false;
	if (!SP.GetClubsInRelatedHierarchiesOfClub(iClubID,bSuccess))
	{
		return SetDNALastError("Club","GetClubsInRelatedHierarchies","Failed in GetClubsInRelatedHierarchies");
	}

	if (bSuccess)
	{
		sRelatedMembersXML << "<RELATEDCLUBS>";
		CClubMember clubMember(m_InputContext);

		while (!SP.IsEOF())
		{
			CTDVString sName;
			SP.GetField("Name",sName);
			EscapeXMLText(&sName);

			// Populate the CClubMember object
			//
			clubMember.Clear();
			clubMember.SetClubId( SP.GetIntField("ClubID") );
			clubMember.SetName( sName );
			clubMember.SetExtraInfo( SP.GetIntField("type") );

			bool bMovedToNextRec = false;
			clubMember.GetAsXML( SP, sRelatedMembersXML, bMovedToNextRec);
			if (bMovedToNextRec == false)
			{
				SP.MoveNext();			
			}
		}
		sRelatedMembersXML << "</RELATEDCLUBS>";
	}

	if (!SP.GetArticlesInRelatedHierarchiesOfClub(iClubID,bSuccess))
	{
		return SetDNALastError("Club","GetArticlesInRelatedHierarchiesOfClub","Failed in GetArticlesInRelatedHierarchiesOfClub");
	}

	if (bSuccess)
	{
		sRelatedMembersXML << "<RELATEDARTICLES>";
		CArticleMember articleMember(m_InputContext);

		while (!SP.IsEOF())
		{
			CTDVString sName, sExtraInfo;
			SP.GetField("subject", sName);
			SP.GetField("extrainfo", sExtraInfo);

			articleMember.Clear();
			articleMember.SetH2g2Id( SP.GetIntField("h2g2id") );
			articleMember.SetName( sName );
			articleMember.SetStatus( SP.GetIntField("status") );
			articleMember.SetExtraInfo( sExtraInfo, SP.GetIntField("type") );
			articleMember.GetAsXML(sRelatedMembersXML);

			SP.MoveNext();
		}
		sRelatedMembersXML << "</RELATEDARTICLES>";
	}

	sRelatedMembersXML << "</RELATEDMEMBERS>";

	return true;
}

/*********************************************************************************

	void CClub::SetLabel(const TDVCHAR* sLabel)

	Author:		Dharmesh Raithatha
	Created:	5/12/2003
	Inputs:		sLabel - label that you want to set the Club too
	Outputs:	-
	Returns:	-
	Purpose:	Set the label if you want the Club to have a unique name that you
				can then use in the xsl. This information is not stored in the
				database. It is done this way so that the Club can control how 
				its information is displayed

*********************************************************************************/

void CClub::SetLabel(const TDVCHAR* sLabel)
{
	m_sLabel = sLabel;
}

/*********************************************************************************

	void CClub::Clean()

	Author:		Dharmesh Raithatha
	Created:	5/13/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Cleans the object so that it can be reinitialised

*********************************************************************************/

void CClub::Clean()
{
	Destroy();
	m_bInitialised = false;
}

/*********************************************************************************

	bool CClub::PerformAction(int iClubID, CUser *pUser, int iActionUserID, int iActionType)

	Author:		Jim Lynn
	Created:	14/05/2003
	Inputs:		iClubID - ID of the club
				pUser - Viewing User (or NULL if unregistered)
				iActionUserID - ID of the user who is the subject of this action
				iActionType - one of:	1.	Join as a member
										2.	Join as an owner
										3.	Invite to be member
										4.	Invite to be owner
										5.	Owner resigns to member
										6.	Owner resigns completely
										7.	Member resigns completely
										8.	Owner demotes Owner to member
										9.	Owner removes Owner completely
										10.	Owner removes Member completely
	Outputs:	-
	Returns:	true if succeeded, false if failed
	Purpose:	Will perform a given action on the club - a user asking to join, or an owner removing a user, 
				for example.
				These are all the 'initiating' actions - which will create an action and possibly (depending on 
				permissions) complete it. There will be a separate method, CompleteAction, which will handle
				incomplete actions.

*********************************************************************************/

bool CClub::PerformAction(int iClubID, CUser *pUser, int iActionUserID, ActionType iActionType, const int iSiteID)
{
	if (pUser == NULL)
	{
		return SetDNALastError("Club","unregisteredaction","You cannot perform this action without being registered");
	}

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("Club","database","There was a problem accessing the database");
	}

	// Can the current user do anything?
	
	int iUserID = pUser->GetUserID();
	
	/*
	 	<CLUBACTIONRESULT CLUBID='3' ACTIONID='12345' ACTIONTYPE='joinmember' RESULT=''stored|complete|declined|failed'>
			<DATEREQUESTED><DATE.../></DATEREQUESTED>
			<DATECOMPLETED><DATE.../></DATECOMPLETED>
			<ACTIONUSER><USER><USERID>45345</USERID><USERNAME>Zarquon</USERNAME></USER></ACTIONUSER>
			<COMPLETEUSER><USER><USERID>113234</USERID><USERNAME>Fred</USERNAME></USER></COMPLETEUSER>
			<CLUBNAME>Some name here</CLUBNAME>
		</CLUBACTIONRESULT>	
	 */

	SP.PerformClubAction(iClubID, iUserID, iActionUserID, iActionType, iSiteID);
	CTDVString sXML;
	bool bSuccess = SP.GetBoolField("Success");
	int iActionID = SP.GetIntField("ActionID");
	int iActionResult = SP.GetIntField("ActionResult");
	sXML << "<CLUBACTIONRESULT";
	sXML << " CLUBID='" << iClubID << "'";
	sXML << " ACTIONID='" << iActionID << "'";
	CTDVString sActionName;
	SP.GetField("ActionName", sActionName);
	sXML << " ACTIONTYPE='" << sActionName << "'";
	if (bSuccess)
	{
		if (iActionResult == 0) 
		{
			sXML << " RESULT='stored'";
		}
		else if (iActionResult == 1) 
		{
			sXML << " RESULT='complete'";
		}
		else if (iActionResult == 2) 
		{
			sXML << " RESULT='declined'";
		}
	}
	else
	{
		sXML << " RESULT='failed'";
		CTDVString sError;
		SP.GetField("Reason", sError);
		sXML << " ERROR='" << sError << "'";
	}
	// close off the opening tag
	sXML << ">";

	// Now do each of the fields if they are there	CTDVDateTime dDate;
	CTDVDateTime dDate;
	CTDVString sTemp;
	if (SP.FieldExists("DateRequested") && !SP.IsNULL("DateRequested"))
	{
		dDate = SP.GetDateField("DateRequested");
		dDate.GetAsXML(sTemp, true);
		sXML << "<DATEREQUESTED>" << sTemp << "</DATEREQUESTED>";
		sTemp.Empty();
	}
	if (SP.FieldExists("DateCompleted") && !SP.IsNULL("DateCompleted"))
	{
		dDate = SP.GetDateField("DateRequested");
		dDate.GetAsXML(sTemp, true);
		sXML << "<DATECOMPLETED>" << sTemp << "</DATECOMPLETED>";
		sTemp.Empty();
	}
	if (SP.FieldExists("UserID") && !SP.IsNULL("UserID")) 
	{
		CTDVString sUserXML;
		if(!CreateUserBlock(sUserXML, "ACTIONUSER", SP))
		{
			TDVASSERT(false, "Failed to create user block");
		}
		else
		{
			sXML += sUserXML;
		}
	}
	if (SP.FieldExists("OwnerID") && !SP.IsNULL("OwnerID")) 
	{
		CTDVString sUserXML;
		if(!CreateUserBlock(sUserXML, "COMPLETEUSER", SP))
		{
			TDVASSERT(false, "Failed to create user block");
		}
		else
		{
			sXML += sUserXML;
		}
	}
	if (SP.FieldExists("ClubName") && !SP.IsNULL("ClubName")) 
	{
		SP.GetField("ClubName", sTemp);
		EscapeXMLText(&sTemp);
		sXML << "<CLUBNAME>" << sTemp << "</CLUBNAME>";
		sTemp.Empty();
	}
	sXML << "</CLUBACTIONRESULT>";
	CreateFromXMLText(sXML);

	return true;
}

bool CClub::CompleteAction(int iActionID, CUser* pUser, int iActionResult)
{
	if (pUser == NULL)
	{
		return SetDNALastError("Club","unregisteredaction","You cannot perform this action without being registered");
	}

	if (iActionResult < 1 || iActionResult > 2) 
	{
		return SetDNALastError("Club","unregisteredaction","You cannot perform this action without being registered");
	}

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("Club","database","There was a problem accessing the database");
	}

	// Can the current user do anything?
	
	int iUserID = pUser->GetUserID();
	SP.CompleteClubAction(iActionID, iUserID, iActionResult);
	CTDVString sXML;
	CTDVString sErrorMsg;
	bool bSuccess = SP.GetBoolField("Success");
	if(!bSuccess)
	{
		SP.GetField("Reason", sErrorMsg);
	}
	iActionResult = SP.GetIntField("ActionResult");
	int iClubID = SP.GetIntField("ClubID");
	sXML << "<CLUBACTIONRESULT";
	sXML << " CLUBID='" << iClubID << "'";
	sXML << " ACTIONID='" << iActionID << "'";
	CTDVString sActionName;
	SP.GetField("ActionName", sActionName);
	sXML << " ACTIONTYPE='" << sActionName << "'";
	if (bSuccess)
	{
		if (iActionResult == 0) 
		{
			sXML << " RESULT='stored'";
		}
		else if (iActionResult == 1) 
		{
			sXML << " RESULT='complete'";
		}
		else if (iActionResult == 2) 
		{
			sXML << " RESULT='declined'";
		}
	}
	else
	{
		sXML << " RESULT='failed'";
		CTDVString sError;
		SP.GetField("Reason", sError);
		sXML << " ERROR='" << sError << "'";
	}
	// close off the opening tag
	sXML << ">";

	// Now do each of the fields if they are there
	CTDVDateTime dDate;
	CTDVString sTemp;
	if (!SP.IsNULL("DateRequested"))
	{
		dDate = SP.GetDateField("DateRequested");
		dDate.GetAsXML(sTemp, true);
		sXML << "<DATEREQUESTED>" << sTemp << "</DATEREQUESTED>";
		sTemp.Empty();
	}
	if (!SP.IsNULL("DateCompleted"))
	{
		dDate = SP.GetDateField("DateCompleted");
		dDate.GetAsXML(sTemp, true);
		sXML << "<DATECOMPLETED>" << sTemp << "</DATECOMPLETED>";
		sTemp.Empty();
	}
	if (!SP.IsNULL("UserID"))
	{
		CTDVString sUserXML;
		if(!CreateUserBlock(sUserXML, "ACTIONUSER", SP))
		{
			TDVASSERT(false, "Failed to create user block");
		}
		else
		{
			sXML += sUserXML;
		}
	}
	if (!SP.IsNULL("OwnerID")) 
	{
		CTDVString sUserXML;
		if(!CreateUserBlock(sUserXML, "COMPLETEUSER", SP))
		{
			TDVASSERT(false, "Failed to create user block");
		}
		else
		{
			sXML += sUserXML;
		}
	}
	if (!SP.IsNULL("ClubName")) 
	{
		SP.GetField("ClubName", sTemp);
		EscapeXMLText(&sTemp);
		sXML << "<CLUBNAME>" << sTemp << "</CLUBNAME>";
		sTemp.Empty();
	}
	sXML << "</CLUBACTIONRESULT>";
	CreateFromXMLText(sXML);

	return true;
}

/*********************************************************************************

	bool CClub::GetClubActionList(int iClubID, CUser *pUser, int iSkip, int iShow)

	Author:		Jim Lynn
	Created:	21/05/2003
	Inputs:		iClubID - ID of the club
				pUser - pointer to the current user
				iSkip - number of items to skip
				iShow - Number of items to show
	Outputs:	-
	Returns:	true if succeeded, false if failed (user can't see the list, for example)
	Purpose:	Gets a list of actions associated with the particular club.

*********************************************************************************/

bool CClub::GetClubActionList(int iClubID, CUser *pUser, int iSkip, int iShow)
{
	if (iClubID <= 0)
	{
		return false;
	}

	// Limit number shown
	if (iShow > 200)
	{
		iShow = 200;
	}

	// Can the current user do anything with requests in this club?
	GetClubPermissions(pUser->GetUserID(), iClubID);

	if (!m_bCanViewActions && !pUser->GetIsEditor())
	{
		return false;
	}
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	SP.GetClubActionList(iClubID);
	int iNumActions = 0;
	if (!SP.IsEOF())
	{
		iNumActions = SP.GetIntField("NumActions");
	}
	
	if (iSkip > 0) 
	{
		SP.MoveNext(iSkip);
	}

	CTDVString sXML = "<CLUBACTIONLIST CLUBID='";
	sXML << iClubID << "'";
	sXML << " SKIPTO='" << iSkip << "'";
	sXML << " COUNT='" << iShow << "'";
	sXML << " TOTALACTIONS='" << iNumActions << "'>";
	CTDVString sTemp;
	while (!SP.IsEOF() && iShow > 0) 
	{
		sXML << "<CLUBACTION CLUBID='" << iClubID << "'";
		SP.GetField("ActionName", sTemp);
		sXML << " ACTIONTYPE='" << sTemp << "'";
		int iActionID = SP.GetIntField("ActionID");
		sXML << " ACTIONID='" << iActionID << "'";
		int iActionResult = SP.GetIntField("ActionResult");
		if (iActionResult == 0) 
		{
			sXML << " RESULT='stored'";
		}
		else if (iActionResult == 1) 
		{
			sXML << " RESULT='complete'";
		}
		else if (iActionResult == 2) 
		{
			sXML << " RESULT='declined'";
		}
		sXML << ">";
		CTDVDateTime dDate;
		if (!SP.IsNULL("DateRequested"))
		{
			dDate = SP.GetDateField("DateRequested");
			dDate.GetAsXML(sTemp, true);
			sXML << "<DATEREQUESTED>" << sTemp << "</DATEREQUESTED>";
			sTemp.Empty();
		}
		if (!SP.IsNULL("DateCompleted"))
		{
			dDate = SP.GetDateField("DateCompleted");
			dDate.GetAsXML(sTemp, true);
			sXML << "<DATECOMPLETED>" << sTemp << "</DATECOMPLETED>";
			sTemp.Empty();
		}
		if (!SP.IsNULL("UserID"))
		{
			CTDVString sUserXML;
			if(!CreateUserBlock(sUserXML, "ACTIONUSER", SP))
			{
				TDVASSERT(false, "Failed to create user block");
			}
			else
			{
				sXML += sUserXML;
			}
		}
		if (!SP.IsNULL("OwnerID"))
		{
			CTDVString sUserXML;
			if(!CreateUserBlock(sUserXML, "COMPLETEUSER", SP))
			{
				TDVASSERT(false, "Failed to create user block");
			}
			else
			{
				sXML += sUserXML;
			}
		}
		if (!SP.IsNULL("ClubName")) 
		{
			SP.GetField("ClubName", sTemp);
			EscapeXMLText(&sTemp);
			sXML << "<CLUBNAME>" << sTemp << "</CLUBNAME>";
			sTemp.Empty();
		}
		sXML << "</CLUBACTION>";

		iShow--;
		SP.MoveNext();
	}
	sXML << "</CLUBACTIONLIST>";
	CreateFromXMLText(sXML);
	
	return true;
}

bool CClub::GetUserActionList(int iUserID, int iSkip, int iShow)
{
	// Limit number shown
	if (iShow > 200)
	{
		iShow = 200;
	}

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	SP.GetUserActionList(iUserID);
	int iNumActions = 0;
	if (!SP.IsEOF())
	{
		iNumActions = SP.GetIntField("NumActions");
	}
	
	if (iSkip > 0) 
	{
		SP.MoveNext(iSkip);
	}

	CTDVString sXML = "<USERCLUBACTIONLIST USERID='";
	sXML << iUserID << "'";
	sXML << " SKIPTO='" << iSkip << "'";
	sXML << " COUNT='" << iShow << "'";
	sXML << " TOTALACTIONS='" << iNumActions << "'>";
	CTDVString sTemp;
	while (!SP.IsEOF() && iShow > 0) 
	{
		int iClubID = SP.GetIntField("ClubID");
		sXML << "<CLUBACTION CLUBID='" << iClubID << "'";
		int iSiteID = SP.GetIntField("SiteID");
		sXML << " SITEID='" << iSiteID << "'";
		SP.GetField("ActionName", sTemp);
		sXML << " ACTIONTYPE='" << sTemp << "'";
		int iActionID = SP.GetIntField("ActionID");
		sXML << " ACTIONID='" << iActionID << "'";
		int iActionResult = SP.GetIntField("ActionResult");
		if (iActionResult == 0) 
		{
			sXML << " RESULT='stored'";
		}
		else if (iActionResult == 1) 
		{
			sXML << " RESULT='complete'";
		}
		else if (iActionResult == 2) 
		{
			sXML << " RESULT='declined'";
		}
		sXML << ">";
		CTDVDateTime dDate;
		if (!SP.IsNULL("DateRequested"))
		{
			dDate = SP.GetDateField("DateRequested");
			dDate.GetAsXML(sTemp, true);
			sXML << "<DATEREQUESTED>" << sTemp << "</DATEREQUESTED>";
			sTemp.Empty();
		}
		if (!SP.IsNULL("DateCompleted"))
		{
			dDate = SP.GetDateField("DateCompleted");
			dDate.GetAsXML(sTemp, true);
			sXML << "<DATECOMPLETED>" << sTemp << "</DATECOMPLETED>";
			sTemp.Empty();
		}
		if (!SP.IsNULL("UserID")) 
		{
			CTDVString sUserXML;
			if(!CreateUserBlock(sUserXML, "ACTIONUSER", SP))
			{
				TDVASSERT(false, "Failed to create user block");
			}
			else
			{
				sXML += sUserXML;
			}
		}
		if (!SP.IsNULL("OwnerID")) 
		{
			CTDVString sUserXML;
			if(!CreateUserBlock(sUserXML, "COMPLETEUSER", SP))
			{
				TDVASSERT(false, "Failed to create user block");
			}
			else
			{
				sXML += sUserXML;
			}
		}
		if (!SP.IsNULL("ClubName")) 
		{
			SP.GetField("ClubName", sTemp);
			EscapeXMLText(&sTemp);
			sXML << "<CLUBNAME>" << sTemp << "</CLUBNAME>";
			sTemp.Empty();
		}
		sXML << "</CLUBACTION>";

		iShow--;
		SP.MoveNext();
	}
	sXML << "</USERCLUBACTIONLIST>";
	CreateFromXMLText(sXML);
	
	return true;

}

/*********************************************************************************

	bool CreateClub(bool& bCreatedClub, CDNAIntArray& NodeArray)

	Author:		Dharmesh Raithatha
	Created:	5/28/2003
	Inputs:		
	Outputs:	bCreatedClub - if the club was created successfully
				sSearchQuery - a searchquery for classifying the club
				iClubID - ClubID of created club
	Returns:	true if processed, false otherwise
	Purpose:	Creates the club using the multistep process. Required fields
				are 'body' and 'title' and 'open' which defaults to 1 if not present

*********************************************************************************/

bool CClub::CreateClub(int &iClubID, bool& bCreatedClub, CDNAIntArray& NodeArray, bool& bProfanityFound, bool& bNonAllowedURLsFound, bool& bEmailAddressFound )
{
	bCreatedClub = false;

	CUser* pUser = m_InputContext.GetCurrentUser();

	if (pUser == NULL)
	{
		return SetDNALastError("CreateClub","NoUser","No logged in user");
	}
	
	CMultiStep Multi(m_InputContext, "CLUB");
	
	Multi.AddRequiredParam("title");
	Multi.AddRequiredParam("body");
	Multi.AddRequiredParam("open","1");

	if (!Multi.ProcessInput())
	{
		return SetDNALastError("CreateClub","CreateFailed","Failed to create the club");
	}

	CTDVString sXML;
	if (Multi.ReadyToUse())
	{
		int iOpen = 0;
		Multi.GetRequiredValue("open",iOpen);

		CTDVString sImageName;
		if (!UploadImageIfSubmitted(sImageName))
		{
			return SetDNALastError("CreateClub", "ImageUploadFailed", "Image upload failed");
		}

		CTDVString sTitle, sGuideML;
		bool ok = GetDataFromMultiStep(Multi,sTitle, 
			(sImageName.IsEmpty() ? KEEPTHEPICTURE : (const char*) sImageName), 
			NOPREVIEWPICTURE, sGuideML);

		if (ok)
		{
			CExtraInfo extra;
			if (!extra.Create(CGuideEntry::TYPECLUB))
			{
				return SetDNALastError("CreateClub","ClubExtraInfoFailed","Failed to create extrainfo for club due bad element");
			}

			extra.GenerateAutoDescription(sGuideML);

			//TODO: Route Profanity filter flows through club creation process.
			// Check the user input for profanities!
			CTDVString sProfanity;
			CProfanityFilter ProfanityFilter(m_InputContext);
			CProfanityFilter::FilterState filterState  = 
				ProfanityFilter.CheckForProfanities(sTitle + " " + sGuideML, &sProfanity);

			if (filterState == CProfanityFilter::FailBlock)
			{
				bProfanityFound = true;

				int iProfanityTriggered = m_InputContext.GetParamInt("profanitytriggered");
				//check if the profanity filter has been triggered before
				if (iProfanityTriggered > 0)
				{
				}
				iProfanityTriggered = 1;
				return false;
			}
			else if (filterState == CProfanityFilter::FailRefer)
			{
				bProfanityFound = true;
			}
			//------------------------------------------------------------------------------

			if(m_InputContext.IsCurrentSiteURLFiltered() && !(pUser->GetIsEditor() || pUser->GetIsNotable()))
			{
				CURLFilter oURLFilter(m_InputContext);
				CURLFilter::FilterState URLFilterState = oURLFilter.CheckForURLs(sTitle + " " + sGuideML);
				if (URLFilterState == CURLFilter::Fail)
				{
					bNonAllowedURLsFound = true;
					//return immediately - these don't get submitted
					return false;
				}
			}

			//Filter for email addresses.
			if ( m_InputContext.IsCurrentSiteEmailAddressFiltered() && !(pUser->GetIsEditor() || pUser->GetIsNotable()))
			{
				CEmailAddressFilter emailfilter;
				if ( emailfilter.CheckForEmailAddresses(sTitle + " " + sGuideML) )
				{
					//SetDNALastError("CForum::PostToForum","EmailAddressFilter","Email Address Found.");
					bEmailAddressFound = true;
					return false;
				}
			}

			int iH2G2ID = 0;
			const int iSiteID = m_InputContext.GetSiteID();
			CStoredProcedure SP;
			m_InputContext.InitialiseStoredProcedureObject(&SP);
			if (!SP.CreateNewClub(sTitle,pUser->GetUserID(),iOpen,iSiteID,sGuideML,extra,iClubID,iH2G2ID,m_iOwnerTeamID))
			{
				return SetDNALastError("CreateClub","CreateClubFailed","Failed to Create the club in database");
			}

			bool bFoundDuplicate = (SP.GetIntField("FoundDuplicate") > 0);

			bCreatedClub = true;

			CGuideEntry ClubGuide(m_InputContext);
			bool bOk = ClubGuide.Initialise(iH2G2ID,iSiteID,NULL,true,true,true,false);

			// Check to make sure we actually managed to update ok
			if (!bOk)
			{
				return SetDNALastError("CreateClub","InitFailed","Failed To Initialise Club's guide entry");
			}

			// Setup the moderation notes.
			CTDVString sModeration = _T("New Club");
			

			bool bNeedToHide = false;
			if (!pUser->GetIsEditor() && bProfanityFound)
			{
				// We need to Hide the Article for moderation
				bNeedToHide = true;
				sModeration << " - Profanity = '" << sProfanity << "'";
			}

			//add to moderation queue
			int iModId;
			if (!ClubGuide.QueueForModeration(
				bProfanityFound ? CStoredProcedure::MOD_TRIGGER_PROFANITY : 
					CStoredProcedure::MOD_TRIGGER_AUTO, 
				sModeration, &iModId))
			{
				return SetDNALastError("CreateClub","QueueFailed","Failed to queue article for moderation");
			}

			if (bNeedToHide)
			{
				ClubGuide.MakeHidden(3, iModId, 
					bProfanityFound ? CStoredProcedure::MOD_TRIGGER_PROFANITY : 
						CStoredProcedure::MOD_TRIGGER_AUTO);
			}

			// Create a new vote for the club. If we found a duplicate, don't bother!
			CVote ClubVote(m_InputContext);
			int iVoteID = 0;
			if (!bFoundDuplicate)
			{
				CTDVDateTime sClosingDate;
				if (!ClubVote.CreateVote(CVotePageBuilder::VOTETYPE_CLUB,sClosingDate,m_iOwnerTeamID,true))
				{
					return SetDNALastError("CreateClub","CreateVoteFailed","Failed to create a vote for the club");
				}
				iVoteID = ClubVote.GetVoteID();
				ClubVote.AddVoteToClubTable(iVoteID,iClubID);
			}
			else
			{
				GetVoteIDForClubID(iClubID,iVoteID);
			}
			
			GetClubVoteDetails(iClubID,iVoteID,sXML);

			// Check to see if we've been asked to tag this article to any nodes?
			if (NodeArray.GetSize() > 0)
			{
				// Get the tagitem object to do the tagging!
				CTagItem TagItem(m_InputContext);
				CEventQueue EQ(m_InputContext);
				TagItem.InitialiseItem(iClubID,CGuideEntry::TYPECLUB,iSiteID,pUser);
				bool bOk = true;
				for (int i = 0; i < NodeArray.GetSize() && bOk; i++)
				{
					// Tag the nodes, but don't fail if it already exists!
					bOk = bOk && TagItem.AddTagItemToNode(NodeArray.GetAt(i),false);
				}

				// Check the ok flag
				TDVASSERT(bOk,"Failed to tag items to selected nodes");
			}
		}
		else
		{
			CopyDNALastError("CreateClub",Multi);
			Multi.SetToCancelled();
		}
	}

	Multi.GetAsXML(sXML);
	CreateFromXMLText(sXML);

	return true;
}


/*********************************************************************************

	bool CClub::GetDataFromMultiStep(CMultiStep& Multi, CTDVString& sTitle, CTDVString& sGuideML)

	Author:		Mark Neves
	Created:	02/12/2003
	Inputs:		Multi	- the multistep object containing the user's input
	Outputs:	sTitle	- the title (escaped)
				sGuideML- the GuideML for the body
	Returns:	true if ok, false otherwise
	Purpose:	Does the necessary processing for the club multistep object

				sTitle is escaped, as this can't contain XML
				sGuildeML contains a <GUIDE> tag containing tags for the rest of the club params

				It can return false in the following circumstances:
					- any of the multiinput params fails validation (if specified in _msxml)
					- If sGuideML would contain GuideML that doesn't parse

				Multi.GetLastError...() functions can be called to find out what happened

*********************************************************************************/

bool CClub::GetDataFromMultiStep(CMultiStep& Multi, CTDVString& sTitle, 
	const char* pPicture, const char* pPreviewPicture, CTDVString& sGuideML)
{
	if (pPicture)
	{
		Multi.SetElementValue("picturename", pPicture);
	}

	bool ok = Multi.GetRequiredValue("title",sTitle);
	if (ok)
	{
//		CXMLObject::EscapeXMLText(&sTitle);
		sGuideML = "<GUIDE>";
		ok = ok && Multi.GetRequiredAsXML("BODY", sGuideML);
		ok = ok && Multi.GetAllElementsAsXML(sGuideML);
		if (pPreviewPicture)
		{
			CTDVString sPreviewPicture = pPreviewPicture;
			CXMLObject::EscapeXMLText(&sPreviewPicture);
			sGuideML << "<PICTUREPREVIEW>" << sPreviewPicture << "</PICTUREPREVIEW>";
		}

		sGuideML << "</GUIDE>";
	}

	return ok;
}


/*********************************************************************************

	bool CClub::PreviewClub(CTDVString& sTitle, CTDVString& sGuideML)

	Author:		Mark Neves
	Created:	09/10/2003
	Inputs:		
	Outputs:	sTitle	= the title
				sGuideML= the GuideML for the club
	Returns:	true if ok, 
				false otherwise, and the GetLastError...() methods can be used to find out why
	Purpose:	Does all the processing necessary for previewing the club
				Fills the object with the correct Multi-step XML

				If there are parse errors in the body XML, SetDNALastError() will have been
				called to record the parse errors

*********************************************************************************/

bool CClub::PreviewClub(CTDVString& sTitle, CTDVString& sGuideML)
{
	CUser* pUser = m_InputContext.GetCurrentUser();

	if (pUser == NULL)
	{
		return false;
	}
	
	CMultiStep Multi(m_InputContext, "CLUB-PREVIEW");
	
	Multi.AddRequiredParam("title");
	Multi.AddRequiredParam("body");
	Multi.AddRequiredParam("open","1");

	if (!Multi.ProcessInput())
	{
		return SetDNALastError("PreviewClub","BadParams","Failed process input");
	}

	bool ok = GetDataFromMultiStep(Multi,sTitle, KEEPTHEPICTURE, 
		IsImageSubmitted() ? m_InputContext.GetImageLibraryPreviewImage() 
		: NOPREVIEWPICTURE, sGuideML);
	
	if (!ok)
	{
		CopyDNALastError("CreateClub",Multi);
	}

	CTDVString sXML;
	Multi.SetToCancelled();
	Multi.GetAsXML(sXML);

	CreateFromXMLText(sXML);

	return ok;
}


bool CClub::GetClubPermissions(int iUserID, int iClubID)
{
	if (m_PermissionUser != iUserID || m_PermissionClub != iClubID) 
	{
		m_PermissionClub = iClubID;
		m_PermissionUser = iUserID;
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		SP.GetClubPermissions(iUserID, iClubID, m_bCanAutoJoinMember, m_bCanAutoJoinOwner, m_bCanBecomeMember, m_bCanBecomeOwner, m_bCanApproveMembers, m_bCanApproveOwners, m_bCanDemoteMembers, m_bCanDemoteOwners, m_bCanViewActions, m_bCanView, m_bCanEdit);
	}
	return true;
}



/*********************************************************************************

	bool CClub::UpdateClub(const CTDVString& sTitle, const CTDVString& sBodyText,const CExtraInfo& NewExtraInfo)

	Author:		Mark Neves
	Created:	01/08/2003
	Inputs:		sTitle		 = the title (or name) of the club
				sBodyText	 = The main body text for the club's article
				NewExtraInfo = Contains extra info items to add to the club
	Outputs:	-
	Returns:	true if ok, false otherwise
	Purpose:	Updates the club information in the database.

				If the club already has extra info items supplied by NewExtraInfo, they are replaced
				by the ones in NewExtraInfo

				The club's auto description field in extra info is regenerated

				if the club needs to be queued for moderation, it is done here

*********************************************************************************/

bool CClub::UpdateClub(const CTDVString& sTitle,const CTDVString& sBodyText,const CExtraInfo& NewExtraInfo)
{
	bool bSuccess = false;

	if (m_iClubID == 0)
	{
		return SetDNALastError("UpdateClub","BadClubID","This club has not been initialised");
	}

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{	
		return SetDNALastError("UpdateClub","DBError","Unable to initialise SP");
	}

	if (!SP.FetchClubDetailsViaClubID(m_iClubID,bSuccess))
	{
		return SetDNALastError("UpdateClub","NoDetails","Unable to FetchClubDetails");
	}

	int h2g2ID = SP.GetIntField("h2g2ID");

	CExtraInfo ClubExtraInfo;
	if (!SP.FetchGuideEntryExtraInfo(h2g2ID,ClubExtraInfo))
	{
		return SetDNALastError("UpdateClub","NoExtraInfo","Unable to FetchGuideEntryExtraInfo");
	}

	ClubExtraInfo.ReplaceMatchingItems(NewExtraInfo);

	ClubExtraInfo.GenerateAutoDescription(sBodyText);

	CUser* pViewer = m_InputContext.GetCurrentUser();

	// The SP needs to know if it must also change the editor field in GuideEntries
	// when an edit is done (for moderation purposes)
	// Don't if the viewing user is a site editor or su
	bool bChangeEditor = true;
	if (pViewer->GetIsEditor())
	{
		bChangeEditor = false;
	}

	if(m_InputContext.IsCurrentSiteURLFiltered() && !(pViewer->GetIsEditor() || pViewer->GetIsNotable()))
	{
		CURLFilter oURLFilter(m_InputContext);
		CURLFilter::FilterState URLFilterState = oURLFilter.CheckForURLs(sTitle + " " + sBodyText);
		if (URLFilterState == CURLFilter::Fail)
		{
			return SetDNALastError("UpdateClub", "NonAllowedURLFound", "A non allowed URL has been found in the entry.");
		}
	}

	//Filter for email addresses.
	if ( m_InputContext.IsCurrentSiteEmailAddressFiltered() && !(pViewer->GetIsEditor() || pViewer->GetIsNotable()))
	{
		CEmailAddressFilter emailfilter;
		if ( emailfilter.CheckForEmailAddresses(sTitle + " " + sBodyText) )
		{
			SetDNALastError("CForum::PostToForum","EmailAddressFilter","Email Address Found.");
			return false;
		}
	}

	
	if (SP.BeginUpdateClub(m_iClubID,pViewer->GetUserID(), bChangeEditor))
	{
		bSuccess  = SP.ClubUpdateTitle(sTitle);
		bSuccess = bSuccess && SP.ClubUpdateBodyText(sBodyText);
		bSuccess = bSuccess && SP.ClubUpdateExtraInfo(ClubExtraInfo);

		if (bSuccess)
		{
			if (!SP.DoUpdateClub(bSuccess))
			{
				return SetDNALastError("UpdateClub","UpdateFailed","Unable to update club");
			}

			// Setup the moderation notes.
			CTDVString sModeration = _T("Club edit");

			// Check the user input for profanities!
			CTDVString sProfanity;
			CProfanityFilter ProfanityFilter(m_InputContext);
			CProfanityFilter::FilterState filterState = 
				ProfanityFilter.CheckForProfanities(sTitle + " " + sBodyText, &sProfanity);

			bool bProfanitiesFound = false;

			if (filterState == CProfanityFilter::FailBlock)
			{
				bProfanitiesFound = true;	
			}
			else if (filterState == CProfanityFilter::FailRefer)
			{
				bProfanitiesFound = true;
			}
            
			bProfanitiesFound = pViewer->GetIsImmuneFromModeration(h2g2ID) && bProfanitiesFound;

			bool bNeedHide = false;
			if (bProfanitiesFound)
			{
				// We need to Hide the Article for moderation
				bNeedHide = true;
				sModeration << " - Profanity = '" << sProfanity << "'";
			}

			if (bSuccess)
			{
				bool bSiteModerated		= !(m_InputContext.IsSiteUnmoderated(m_iSiteID));
				bool bUserModerated		= pViewer->GetIsPreModerated() || pViewer->GetIsPostModerated();
				bool bArticleModerated	= CGuideEntry::IsArticleModerated(m_InputContext,h2g2ID);
				bool bIsArticleInModeration	= CGuideEntry::IsArticleInModeration(m_InputContext,h2g2ID);
				
				int iModId = 0;
				if (bSiteModerated || bUserModerated || bArticleModerated || bIsArticleInModeration || bProfanitiesFound)
				{
					bSuccess = CGuideEntry::QueueForModeration(m_InputContext, h2g2ID, 
						bProfanitiesFound ? CStoredProcedure::MOD_TRIGGER_PROFANITY :
							CStoredProcedure::MOD_TRIGGER_AUTO, 
						sModeration, &iModId);
					if (!bSuccess)
					{
						SetDNALastError("UpdateClub","ModError","Unable to queue club for moderation");
					}
				}

				if (bNeedHide)
				{
					if (!SP.HideArticle(h2g2ID / 10, 3, iModId,
						bProfanitiesFound ? CStoredProcedure::MOD_TRIGGER_PROFANITY :
							CStoredProcedure::MOD_TRIGGER_AUTO,
						pViewer->GetUserID()))
					{
						return SetDNALastError("UpdateClub","UpdateFailed",
							"Unable to update club");
					}
				}

			}
		}
	}
	
	return bSuccess;
}

/*********************************************************************************

	bool CClub::GetNumberOfMembers(int iTeamID, int iInPastNumberOfDays,
								   CTDVString &sTotalMembers, CTDVString &sNewMembers)

	Author:		Mark Howitt
	Created:	29/08/2003
	Inputs:		iTeamID - The ID of the team in which you want to find the members
				iInPastNumberOfDays - The number of past days to check for new members.
	Outputs:	sTotalMembers - The variable that will receive the total number of members.
				sNewMembers - The variable that receives the value of new members.
	Returns:	true if everything ok, false if not!
	Purpose:	Retruns the number of new and total members for a given club

*********************************************************************************/

bool CClub::GetNumberOfMembers(int iTeamID, int iInPastNumberOfDays,
							   CTDVString &sTotalMembers, CTDVString &sNewMembers)
{
	// Setup the store procedure
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// Get the number of total members and new members joined in the last couple of days
	if (!SP.GetNumberOfTeamMembers(iTeamID, iInPastNumberOfDays))
	{
		return false;
	}

	// Get the values from the results
	bool bOk = SP.GetField("TotalMembers",sTotalMembers);
	bOk = bOk && SP.GetField("NewMembers",sNewMembers);

	// Return ok
	return bOk;
}

/*********************************************************************************

	bool CClub::GetUsersStatusForClub(int iUserID, int iClubID, CTDVString &sStatus, CTDVString& sRole)

	Author:		Mark Howitt
	Created:	01/09/2003
	Inputs:		iUserID - The ID of the user you want to check the status of.
				iClubID - the Id of the club you want to check against
	Outputs:	sStatus - a return value which will currently hold "Supporter" or "Owner" depending
							on wether the user is an owner or not.
				sRole - A returen value which holds the users current role in the club.
	Returns:	true if everything ok, false if not!
	Purpose:	Gets the users status and role in the club

*********************************************************************************/

bool CClub::GetUsersStatusForClub(int iUserID, int iClubID, CTDVString &sStatus, CTDVString& sRole)
{
	// Check to see if we're checking for a valid club and user id
	if (iClubID < 0 || iUserID < 0)
	{
		return false;
	}

	// Setup the store procedure
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// First check to see if the user is a member of the given club
	bool bIsInMembersTeam = false;
	if (!SP.IsUserInTeamMembersOfClub(iUserID, iClubID, bIsInMembersTeam))
	{
		return false;
	}

	// Set up the status depending on the result
	if (bIsInMembersTeam)
	{
		sStatus = "Supporter";
	}
	else
	{
		// If the user isn't in the members team, then they can't be an owner so just return
		return true;
	}

	// Set the role based on the value in the TeamMembers table
	SP.GetField("role",sRole);

	// Now check to see if the user is an owner of the given club
	bool bIsInOwnersTeam = false;
	if (!SP.IsUserInOwnerMembersOfClub(iUserID, iClubID, bIsInOwnersTeam))
	{
		sStatus.Empty();
		sRole.Empty();
		return false;
	}

	// If the user id is found in the Owner Members, then set the return value
	if (bIsInOwnersTeam)
	{
		sStatus = "Owner";
	}

	return true;
}

/*********************************************************************************

	bool CClub::GetAllPendingAndCompletedActionsForClub(int iClubID, CTDVString &sActionsXML,
														int& iPending, int& iCompleted)

	Author:		Mark Howitt
	Created:	01/09/2003
	Inputs:		iClubID - The ID of the club which you want to get all the actions for.
	Outputs:	sActionsXML - The return value which holds the actions information in XML format.
				iPending - The number of pending actions found.
				iCompleted - The number of completed actions found.
	Returns:	true if everything ok, false if not!
	Purpose:	Gets the pending and completed actions for a given club and returns the xml
				to be inserted into the tree.

*********************************************************************************/

bool CClub::GetAllPendingAndCompletedActionsForClub(int iClubID, CTDVString &sActionsXML,
													int& iPending, int& iCompleted)
{
	// Check to see if we're checking for a valid club
	if (iClubID < 0)
	{
		return false;
	}

	// Setup the store procedure
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetClubActionList(iClubID))
	{
		return false;
	}

	sActionsXML << "<ACTIONS>";
	CTDVString sPendingActionsXML = "<PENDING>";
	CTDVString sCompletedActionsXML = "<COMPLETED>";

	// Zip through the results, putting them into the xml
	while (!SP.IsEOF())
	{
		// Get the common values from the sql call
		CTDVString sActionName;
		SP.GetField("ActionName",sActionName);
		CXMLObject::EscapeXMLText(&sActionName);
		CTDVString sActionOwner;
		SP.GetField("ActionUserName",sActionOwner);
		CXMLObject::EscapeXMLText(&sActionOwner);
		CTDVString sOwnerID;
		SP.GetField("UserID",sOwnerID);

		// Now check to see what type of result the action had
		int iActionResult = SP.GetIntField("ActionResult");
		if(iActionResult == 0)
		{
			// We've got a pending action type
			// Get the name of the action and the person who did it
			sPendingActionsXML << "<ACTION NAME='" << sActionName << "'>";
			sPendingActionsXML << "<OWNER>" << sActionOwner << "</OWNER>";
			sPendingActionsXML << "<OWNERID>" << sOwnerID << "</OWNERID>";

			// Now get the time the action was done
			CTDVDateTime tDateRequested = SP.GetDateField("DateRequested");
			CTDVString sDateRequested;
			tDateRequested.GetRelativeDate(sDateRequested);
			sPendingActionsXML << "<POSTDATE>" << sDateRequested << "</POSTDATE>";

			// Close the action
			sPendingActionsXML << "</ACTION>";

			// Increment the pending actions
			iPending++;
		}
		else
		{
			//Anything else is either Completed or Rejected which will be treated in the same way.
			// Get the name of the action and the person who did it
			sCompletedActionsXML << "<ACTION NAME='" << sActionName << "'>";
			sCompletedActionsXML << "<OWNER>" << sActionOwner << "</OWNER>";
			sCompletedActionsXML << "<OWNERID>" << sOwnerID << "</OWNERID>";

			// Now get the time the action was done
			CTDVDateTime tDateCompleted = SP.GetDateField("DateCompleted");
			CTDVString sDateCompleted;
			tDateCompleted.GetRelativeDate(sDateCompleted);
			sCompletedActionsXML << "<POSTDATE>" << sDateCompleted << "</POSTDATE>";

			// Close the action
			sCompletedActionsXML << "</ACTION>";

			// Increment the pending actions
			iCompleted++;
		}

		// Get the next item
		SP.MoveNext();
	}

	// Tidy up and return
	sPendingActionsXML << "</PENDING>";
	sCompletedActionsXML << "</COMPLETED>";
	sActionsXML << sPendingActionsXML << sCompletedActionsXML;
	sActionsXML << "</ACTIONS>";
	return true;
}

bool CClub::CanUserEditClub(int iUserID, int iClubID)
{
	GetClubPermissions(iUserID, iClubID);
	return m_bCanEdit;
}

bool CClub::GetAllEditableClubs(int iUserID)
{
	if (iUserID <= 0)
	{
		return false;
	}
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	
	SP.GetAllEditableClubs(iUserID);
	CTDVString sXML;

	sXML << "<EDITABLECLUBS USERID='" << iUserID << "'>\n";

	while (!SP.IsEOF()) 
	{
		CTDVString sName;
		int iClubID = SP.GetIntField("ClubID");
		int iSiteID = SP.GetIntField("SiteID");
		SP.GetField("Name", sName);
		EscapeXMLText(&sName);
		sXML << "<CLUB CLUBID='" << iClubID << "' SITEID='" << iSiteID << "'>";
		sXML << "<NAME>" << sName << "</NAME>";
		sXML << "</CLUB>\n";
		SP.MoveNext();
	}
	sXML << "</EDITABLECLUBS>";
	CreateFromXMLText(sXML);
	return true;
}

bool CClub::GetEditableClubLinkGroups(int iUserID)
{
	if (iUserID <= 0) 
	{
		return false;
	}
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.GetEditableClubLinkGroups(iUserID);
	CTDVString sXML;
	sXML << "<CLUBLINKGROUPS>\n";
	int iPrevClubID = 0;

	while (!SP.IsEOF()) 
	{
		CTDVString sLinkGroup;
		int iClubID = SP.GetIntField("ClubID");
		int iCount = SP.GetIntField("TotalGroups");
		SP.GetField("Type", sLinkGroup);
		EscapeXMLText(&sLinkGroup);
		if (iClubID != iPrevClubID) 
		{
			if (iPrevClubID != 0) 
			{
				sXML << "</CLUB>\n";
			}
			sXML << "<CLUB CLUBID='" << iClubID << "'>\n";
			iPrevClubID = iClubID;
		}
		sXML << "<GROUP COUNT='" << iCount << "'>";
		sXML << sLinkGroup << "</GROUP>";
		SP.MoveNext();
	}
	if (iPrevClubID != 0) 
	{
		sXML << "</CLUB>\n";
	}
	sXML << "</CLUBLINKGROUPS>\n";
	CreateFromXMLText(sXML);
	return true;
}

bool CClub::GetAllPostsForClubForum(int iForumID, CTDVString& sClubPostsXML, int& iTotalThreads, int& iNewThreads)
{
	// Check to see if we're checking for a valid Forum
	if (iForumID < 0)
	{
		return false;
	}

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetThreadListForForum(iForumID))
	{
		return false;
	}

	bool bSuccess = true;
	sClubPostsXML << "<CLUBPOSTS>";

	while (!SP.IsEOF()) 
	{
		iTotalThreads += SP.GetIntField("Cnt");
		iNewThreads += SP.GetIntField("New");

		CTDVString sThreadID;
		SP.GetField("ThreadID",sThreadID);
		sClubPostsXML << "<POST ID='" << sThreadID << "'>";

		CTDVString sSubject;
		SP.GetField("Subject",sSubject);
		sClubPostsXML << "<SUBJECT>" << sSubject << "</SUBJECT>";

		CTDVString sForumID;
		SP.GetField("ForumID",sForumID);
		sClubPostsXML << "<FORUMID>" << sForumID << "</FORUMID>";
		
		// Initialise the XML Builder and get the users details
		InitialiseXMLBuilder(&sClubPostsXML, &SP);
		bSuccess = bSuccess && AddDBXMLTag("UserName");
		bSuccess = bSuccess && AddDBXMLTag("Title",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("Area",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("FirstNames",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("LastName",NULL,false);
		bSuccess = bSuccess && AddDBXMLTag("SiteSuffix",NULL,false);
		sClubPostsXML << "</POST>";

		SP.MoveNext();
	}

	sClubPostsXML << "</CLUBPOSTS>";
	return true;
}

bool CClub::DoesUserBelongToClub(int iUserID, int iClubID, bool &bUserBelongs)
{
	if (iUserID < 0 || iClubID < 0)
	{
		return false;
	}

	// Now check to make sure the current user belongs to the club
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.CheckUserBelongsToClub(iUserID,iClubID,bUserBelongs))
	{
		return false;
	}

	return true;
}

bool CClub::UpdateUsersRole(int iUserID, CTDVString &sRole)
{
	if (iUserID <= 0 || m_iClubID <= 0 || sRole.IsEmpty())
	{
		return false;
	}

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.UpdateUsersRole(iUserID,m_iClubID,sRole))
	{
		return false;
	}

	return true;
}

bool CClub::GetVoteIDForClubID(int iClubID, int &iVoteID)
{
	if (iClubID < 0)
	{
		return false;
	}

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetVoteIDFromClubID(iClubID))
	{
		return false;
	}

	iVoteID = SP.GetIntField("VoteID");
	return true;
}

bool CClub::GetClubVoteDetails(int iClubID, int iVoteID, CTDVString& sXML)
{
	// Setup the club vote info
	sXML << "<VOTE TYPE='CLUB'>";
	
	CTDVString sBBCUID;
	m_InputContext.GetBBCUIDFromCookie(sBBCUID);
	CUser* pViewer = m_InputContext.GetCurrentUser();




	if (iVoteID == 0)
	{
		if (!GetVoteIDForClubID(iClubID,iVoteID) || iVoteID == 0)
		{
			SetDNALastError("Club","GetClubVoteDetails","Failed to get valid vote id");
			sXML << "</VOTE>";
			return false;
		}
	}


	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if(pViewer != NULL)
	{
		SP.HasUserAlreadyVoted(iVoteID, pViewer->GetUserID(), sBBCUID);
		int iExistingUserVote = SP.GetIntField("AlreadyVoted");
		sXML << "<EXISTING-USER-VOTE>" << iExistingUserVote << "</EXISTING-USER-VOTE>";
	}

	// Get the vote id and name for the club
	sXML << "<VOTEID>" << iVoteID << "</VOTEID>";
	sXML << "<VOTENAME>";
	if (iVoteID > 0)
	{
		bool bSuccess = false;
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		if (!SP.GetVoteDetails(iVoteID,bSuccess))
		{
			SetDNALastError("Club","GetClubVoteDetails","Failed to get vote name from stored procedure");
			sXML << "</VOTENAME></VOTE>";
			return false;
		}

		if (bSuccess)
		{
			CTDVString sVoteName;
			SP.GetField("VoteName",sVoteName);
			CXMLObject::EscapeXMLText(&sVoteName);
			sXML << sVoteName;
		}
	}
	sXML << "</VOTENAME>";

	// Now get the response values for the vote
	int iVisible = 0;
	int iHidden = 0;

	
	// Yes Votes
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetNumberOfVotesWithResponse(iVoteID,1,iVisible,iHidden))
	{
		SetDNALastError("Club","GetClubVoteDetails","Failed to get vote info from stored procedure");
		sXML << "</VOTE>";
		return false;
	}

	sXML << "<RESPONSE1>";
	sXML << "<VISIBLE>" << iVisible << "</VISIBLE>";
	sXML << "<HIDDEN>" << iHidden << "</HIDDEN>";
	sXML << "</RESPONSE1>";

	// No Votes
	if (!SP.GetNumberOfVotesWithResponse(iVoteID,0,iVisible,iHidden))
	{
		SetDNALastError("Club","GetClubVoteDetails","Failed to get vote info from stored procedure");
		sXML << "</VOTE>";
		return false;
	}
	sXML << "<RESPONSE2>";
	sXML << "<VISIBLE>" << iVisible << "</VISIBLE>";
	sXML << "<HIDDEN>" << iHidden << "</HIDDEN>";
	sXML << "</RESPONSE2>";

	sXML << "</VOTE>";

	return true;
}

/*********************************************************************************

	bool CClub::UpdateClubModerationStatus(int iClubID, int iNewStatus)

	Author:		Mark Neves
	Created:	18/09/2003
	Inputs:		iClubID = club id
				iNewStatus = new status
	Outputs:	-
	Returns:	true if OK, false otherwise
	Purpose:	Updates the club's moderation statue

*********************************************************************************/

bool CClub::UpdateClubModerationStatus(int iClubID, int iNewStatus)
{
	return CClub::UpdateClubModerationStatus(m_InputContext, iClubID, iNewStatus);
}


/*********************************************************************************

	static bool CClub::UpdateClubModerationStatus(CInputContext& inputContext, int iClubID, int iNewStatus)

	Author:		Mark Neves
	Created:	18/09/2003
	Inputs:		iClubID = club id
				iNewStatus = new status
	Outputs:	-
	Returns:	true if OK, false otherwise
	Purpose:	Updates the club's moderation statue

*********************************************************************************/

bool CClub::UpdateClubModerationStatus(CInputContext& inputContext, int iClubID, int iNewStatus)
{
	CStoredProcedure SP;
	if (!inputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	return SP.UpdateClubModerationStatus(iClubID,iNewStatus);
}


/*********************************************************************************

	int CClub::GetClubModerationStatus()

	Author:		Mark Neves
	Created:	22/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	the moderation status for this club
	Purpose:	Reads the club's moderation status from the database

*********************************************************************************/

int CClub::GetClubModerationStatus()
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	int iModerationStatus = 0;
	SP.GetClubModerationStatus(m_iClubID,iModerationStatus);
	return iModerationStatus;
}

/*********************************************************************************

	bool CClub::IsUserInOwnerMembersOfClub(int iUserID, int iClubID)

	Author:		Mark Neves
	Created:	22/09/2003
	Inputs:		iUserID = a user id
				iClubID = the Club ID
	Outputs:	-
	Returns:	true if the user is an owner, false otherwise
	Purpose:	Finds out from the database if the user is an owner of this club,
				i.e. the user belongs to the club's Owner team

*********************************************************************************/

bool CClub::IsUserInOwnerMembersOfClub(int iUserID, int iClubID)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	bool bIsInOwnersTeam = false;
	SP.IsUserInOwnerMembersOfClub(iUserID, iClubID, bIsInOwnersTeam);
	return bIsInOwnersTeam;
}

/*********************************************************************************

	bool CClub::IsUserInTeamMembersOfClub(int iUserID, int iClubID)

	Author:		Mark Neves
	Created:	22/09/2003
	Inputs:		iUserID = a user id
				iClubID = the club ID
	Outputs:	-
	Returns:	true if the user is an owner, false otherwise
	Purpose:	Finds out from the database if the user is a member of this club,
				i.e. the user belongs to the club's Member team

*********************************************************************************/

bool CClub::IsUserInTeamMembersOfClub(int iUserID, int iClubID)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	bool bIsInMembersTeam = false;
	SP.IsUserInTeamMembersOfClub(iUserID, iClubID, bIsInMembersTeam);
	return bIsInMembersTeam;
}

/*********************************************************************************

	bool CClub::IsUserAllowedToEditClub(CUser* pUser, int iClubID)

	Author:		Mark Neves
	Created:	22/09/2003
	Inputs:		pUser = ptr to the user in question
				iClubID = the club id
	Outputs:	-
	Returns:	true if user is allowed to edit the club, false otherwise
	Purpose:	Finds out if the user is allowed to edit the club.

				Editors, Moderators and Superusers can always edit clubs.

				Otherwise the user has to belong to the club's owner team

*********************************************************************************/

bool CClub::IsUserAllowedToEditClub(CUser* pUser, int iClub)
{
	bool bAllowedToEdit = false;

	if (pUser != NULL)
	{
		if (pUser->GetIsEditor() || pUser->GetIsModerator() || pUser->GetIsSuperuser())
		{
			// If user is priviledged enough, allow them to edit the club
			bAllowedToEdit = true;
		}
		else
		{
			// If the user is an owner, allow them to edit the club
			bAllowedToEdit = IsUserInOwnerMembersOfClub(pUser->GetUserID(), iClub);
		}
	}

	return bAllowedToEdit;
}

/*********************************************************************************

	void CClub::GetTextFromGuideML(const CTDVString& sGuideML, CTDVString& sResult)

	Author:		Mark Neves
	Created:	13/10/2003
	Inputs:		sGuideML = the Guide ML to parse
	Outputs:	sResult = the Guide ML within the BODY tag
	Returns:	-
	Purpose:	Extracts the Guide ML within the BODY tag of the provided GuideML string.

				This should be moved to CXMLObject, and "BODY" should be parameterised.

*********************************************************************************/

void CClub::GetTextFromGuideML(const CTDVString& sGuideML, CTDVString& sResult)
{
	sResult.Empty();

	CXMLTree * pTree = CXMLTree::Parse(sGuideML);
	if (pTree != NULL)
	{
		CXMLTree* pBody = pTree->FindFirstTagName("BODY");
		if (pBody != NULL)
		{
			CXMLTree* pNode = pBody->GetFirstChild();
			while (pNode != NULL)
			{
				pNode->OutputXMLTree(sResult);
				pNode = pNode->GetNextSibling();
			}
		}
		delete pTree;
	}
}

bool CClub::IsImageSubmitted()
{
	return (m_InputContext.GetParamInt("picture_size") > 0);
}

bool CClub::UploadImageIfSubmitted(CTDVString& sImageName)
{
	if (IsImageSubmitted())
	{
		CImageLibrary imageLibrary(m_InputContext);
		CUploadedImage image(m_InputContext);
		if (imageLibrary.Upload("picture", image) != CImageLibrary::ERR_OK)
		{
			return false;
		}

		sImageName = image.GetFileName();
		return true;
	}
	else
	{
		return true;
	}
}

/*********************************************************************************

	bool CClub::EditClub(CMultiStep& Multi, int iClubID)

	Author:		Mark Neves
	Created:	13/10/2003
	Inputs:		
				iClubID		  - the club in question
	Outputs:	Multi		  - filled from the input context
	Returns:	true if ok, false otherwise
	Purpose:	Handles the editing of the club via the input context

				If the club is ready to be editied, the club's information is updated in the database

				If there are parse errors in the body XML, sErrorCode is set to "ParseError" and
				sErrorMess contains the "<PARSEERRORS>" XML block

*********************************************************************************/

bool CClub::EditClub(CMultiStep& Multi, int iClubID)
{
	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	if (pViewingUser == NULL)
	{
		return SetDNALastError("EditClub","NoUser","No logged in user");
	}

	if (!InitialiseViaClubID(iClubID, true))
	{
		return false;		
	}

	if (!IsUserAllowedToEditClub(pViewingUser, iClubID))
	{
		return SetDNALastError("EditClub","AccessDenied","User doesn't have permissions to edit club");
	}

	CTDVString sImageName;
	if (!UploadImageIfSubmitted(sImageName))
	{
		return SetDNALastError("EditClub", "ImageUploadFailed", "Image upload failed");
	}

	CTDVString sTitle, sGuideML;
	if (!GetMultiStepInput(Multi, 
		(sImageName.IsEmpty() ? NULL : (const char*)sImageName), NULL, sTitle,sGuideML))
	{
		return false;
	}

	if (ErrorReported())
	{
		Multi.SetToCancelled();
	}

	if (Multi.ReadyToUse())
	{
		CExtraInfo ExtraInfo(m_iClubType);
		if (!UpdateClub(sTitle,sGuideML,ExtraInfo))
		{
			return false;
		}
	}

	return true;
}


/*********************************************************************************

	bool CClub::EditClubPreview(CMultiStep& Multi, CTDVString& sTitle, CTDVString& sGuideML)

	Author:		Mark Neves
	Created:	13/10/2003
	Inputs:		
				iClubID			- the club id in question
	Outputs:	Multi			- a filled in multistep object
	Returns:	true if ok, false otherwise
	Purpose:	Handles the previewing of the Edit Club process

				If there are parse errors in the body XML, sErrorCode is set to "ParseError" and
				sErrorMess contains the "<PARSEERRORS>" XML block

*********************************************************************************/

bool CClub::EditClubPreview(int iClubID, CMultiStep& Multi, CTDVString& sTitle, CTDVString& sGuideML)
{
	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	if (pViewingUser == NULL)
	{
		return SetDNALastError("EditClubPreview","NoUser","No logged in user");
	}

	if (!IsUserAllowedToEditClub(pViewingUser, iClubID))
	{
		return SetDNALastError("EditClubPreview","AccessDenied","User doesn't have permissions to edit club");
	}

	if (!GetMultiStepInput(Multi, NULL, m_InputContext.GetImageLibraryPreviewImage(), 
		sTitle,sGuideML))
	{
		return false;
	}

	Multi.SetToCancelled();

	return true;
}


/*********************************************************************************

	bool CClub::GetMultiStepInput(CMultiStep& Multi,CTDVString& sTitle, CTDVString& sGuideML)

	Author:		Mark Neves
	Created:	13/10/2003
	Inputs:		
	Outputs:	Multi	 - contains the filled in Multistep object
				sTitle	 - the new title of the club
				sGuideML - the new body text
	Returns:	true if ok, false otherwise
	Purpose:	Centralises the processesing of the params on the URL

				It updates the Multistep object so it contains the params it needs,

				If the Multistep is not ready to use AND empty, it ensures it contains the current
				state of the club ready for editing

*********************************************************************************/

bool CClub::GetMultiStepInput(CMultiStep& Multi, const char* pPicture,
	const char* pPreviewPicture, CTDVString& sTitle, CTDVString& sGuideML)
{
	Multi.AddRequiredParam("title");
	Multi.AddRequiredParam("body");
		
	if (!Multi.ProcessInput())
	{
		return SetDNALastError("GetMultiStepInput", "InputError", 
			"Failed to process the input parameters");
	}

	if (Multi.ReadyToUse())
	{
		bool ok = GetDataFromMultiStep(Multi, sTitle, pPicture, pPreviewPicture, sGuideML);

		if (!ok)
		{
			CopyDNALastError("CClub",Multi);
			Multi.SetToCancelled();
		}
	}
	else
	{
		CTDVString sBodyText;
		Multi.GetRequiredValue("body",sBodyText);
		if (sBodyText.IsEmpty())
		{
			GetName(sTitle);
			Multi.SetRequiredValue("TITLE",sTitle);

			GetGuideML(sGuideML);
			bool ok =  Multi.FillElementsFromXML(sGuideML);
			ok = ok && Multi.FillRequiredFromXML(sGuideML);

			if (!ok)
			{
				CopyDNALastError("CClub",Multi);
				Multi.SetToCancelled();
			}
		}
	}

	return true;
}

/*********************************************************************************

	bool CClub::IsDeleted()

	Author:		Mark Neves
	Created:	22/10/2003
	Inputs:		-
	Outputs:	-
	Returns:	true if deleted, false otherwise
	Purpose:	A club is deleted if it's associated article is deleted

				Initialise() must be called before calling this function

*********************************************************************************/

bool CClub::IsDeleted()
{
	return (m_iGuideStatus == 7);
}


/*********************************************************************************

	bool CClub::AddLink(CUser* pUser, const TDVCHAR* pDestType,int iDestID,const TDVCHAR* pRelationship)

	Author:		Mark Neves
	Created:	04/02/2004
	Inputs:		pUser		= the user adding the link
				pDestType	= the type of thing you are linking to
				iDestID		= the id of thing you are linking to
				pRelationship = the relationship (empty if no particular relationship)
	Outputs:	-
	Returns:	true if OK, false otherwise
	Purpose:	Adds a link to the link table for this club, linking to the destination object specified.
				The club object will contain the result of the link in it's CLUBINFO XML.

*********************************************************************************/

bool CClub::AddLink(CUser* pUser, const TDVCHAR* pDestType,int iDestID,const TDVCHAR* pRelationship, 
	const TDVCHAR* pUrl, const TDVCHAR* pTitle, const TDVCHAR* pDescription)
{
	if (pUser == NULL)
	{
		TDVASSERT(false,"NULL user ptr");
		return false;
	}

	int iTeamID = 0;
	int iUserID = pUser->GetUserID();
	int iClubID = GetClubID();
	if (IsUserInOwnerMembersOfClub(iUserID, iClubID))
	{
		iTeamID = GetOwnerTeamID();
	}
	else if (IsUserInTeamMembersOfClub(iUserID, iClubID))
	{
		iTeamID = GetMemberTeamID();
	}
	else
	{
		pUser->GetTeamID(&iTeamID);
	}

	CTDVString sLinkGroup;	// Deliberately empty strings

	CLink Link(m_InputContext);
	Link.ClipPageToClub(m_iClubID, pDestType, iDestID, pTitle,
		pDescription, sLinkGroup,iTeamID,pRelationship, pUrl, iUserID);

	// Just add the Link result inside the CLUBINFO block.
	// The result of the linking (good or bad) will be represented by the Link's XML
	AddInside("CLUBINFO",&Link);

	return true;
}


/*********************************************************************************

	bool CClub::CreateUserBlock(CTDVString & sXML, CTDVString sUserType, CStoredProcedure & SP)

		Author:		James Pullicino
        Created:	18/04/2005

        Inputs:		sUserType can be one of (case insensitive): 
					"ACTIONUSER" "COMPLETEUSER"

					sXML must be empty string

					SP must be valid

        Outputs:	On success, sXML will contain user block xml
        Returns:	true on success 
        Purpose:	Creates user block xml for clubs

*********************************************************************************/

bool CClub::CreateUserBlock(CTDVString & sXML, CTDVString sUserType, CStoredProcedure & SP)
{
	// This is for safety
	if(!sXML.IsEmpty())
	{
		TDVASSERT(false, "CArticleList::CreateUserBlock() sXML parameter must be empty string");
		return false;
	}

	// Field names
	CTDVString fldUserID, fldUserName, fldFirstNames, fldLastName, fldArea, fldStatus, fldTaxonomyNode, fldJournal, fldActive, fldSitesuffix, fldTitle;

	// Figure out field names
	// (There must be a more efficient way to do this, but leave like this
	// for now since it offers better flexibility and clarity)
	sUserType.MakeUpper();
	if(sUserType.CompareText("ACTIONUSER"))			// ACTIONUSER
	{
		fldUserID = "UserID";
		fldUserName = "ActionUserName";
		fldFirstNames = "ActionFirstNames";
		fldLastName = "ActionLastName";
		fldArea = "ActionArea";
		fldStatus = "ActionStatus";
		fldTaxonomyNode = "ActionTaxonomyNode";
		fldJournal = "ActionJournal";
		fldActive = "ActionActive";
		fldSitesuffix = "ActionSiteSuffix";
		fldTitle = "ActionTitle";
	}
	else if(sUserType.CompareText("COMPLETEUSER"))	// COMPLETEUSER
	{
		fldUserID = "OwnerID";
		fldUserName = "OwnerUserName";
		fldFirstNames = "OwnerFirstNames";
		fldLastName = "OwnerLastName";
		fldArea = "OwnerArea";
		fldStatus = "OwnerStatus";
		fldTaxonomyNode = "OwnerTaxonomyNode";
		fldJournal = "OwnerJournal";
		fldActive = "OwnerActive";
		fldSitesuffix = "OwnerSiteSuffix";
		fldTitle = "OwnerTitle";
	}
	else										// UKNOWN
	{
		TDVASSERT(false, "Uknown user type parameter passed");
		return false;
	}

	// Build user block xml
	sXML << "<" << sUserType << "><USER>";		// Open <USERTYPE><USER>

	// <USERID>
	int iUserID = 0;
	if (SP.FieldExists(fldUserID))
	{
		iUserID = SP.GetIntField(fldUserID);
		sXML << "<USERID>" << iUserID << "</USERID>";
	}

	// <USERNAME>
	if (SP.FieldExists(fldUserName))
	{
		CTDVString sFieldVal;
		if(SP.GetField(fldUserName, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<USERNAME>" << sFieldVal << "</USERNAME>";
		}
	}
	
	// <FIRSTNAMES>
	if (SP.FieldExists(fldFirstNames))
	{
		CTDVString sFieldVal;
		if(SP.GetField(fldFirstNames, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<FIRSTNAMES>" << sFieldVal << "</FIRSTNAMES>";
		}
	}

	// <LASTNAME>
	if (SP.FieldExists(fldLastName))
	{
		CTDVString sFieldVal;
		if(SP.GetField(fldLastName, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<LASTNAME>" << sFieldVal << "</LASTNAME>";
		}
	}

	// <AREA>
	if (SP.FieldExists(fldArea))
	{
		CTDVString sFieldVal;
		if(SP.GetField(fldArea, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<AREA>" << sFieldVal << "</AREA>";
		}
	}

	// <STATUS>
	if (SP.FieldExists(fldStatus))
	{
		sXML << "<STATUS>" << SP.GetIntField(fldStatus) << "</STATUS>";
	}

	// <TAXONOMYNODE>
	if (SP.FieldExists(fldTaxonomyNode))
	{
		sXML << "<TAXONOMYNODE>" << SP.GetIntField(fldTaxonomyNode) << "</TAXONOMYNODE>";
	}

	// <JOURNAL>
	if (SP.FieldExists(fldJournal))
	{
		sXML << "<JOURNAL>" << SP.GetIntField(fldJournal) << "</JOURNAL>";
	}

	// <ACTIVE>
	if (SP.FieldExists(fldActive))
	{
		sXML << "<ACTIVE>" << SP.GetIntField(fldActive) << "</ACTIVE>";
	}

	// <SITESUFFIX>
	if (SP.FieldExists(fldSitesuffix))
	{
		CTDVString sFieldVal;
		if(SP.GetField(fldSitesuffix, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<SITESUFFIX>" << sFieldVal << "</SITESUFFIX>";
		}
	}

	// <TITLE>
	if (SP.FieldExists(fldTitle))
	{
		CTDVString sFieldVal;
		if(SP.GetField(fldTitle, sFieldVal))
		{
			EscapeXMLText(&sFieldVal);
			sXML << "<TITLE>" << sFieldVal << "</TITLE>";
		}
	}

	// <GROUPS>
	CTDVString sGroupsXML;
	if(!m_InputContext.GetUserGroups(sGroupsXML, iUserID))
	{
		TDVASSERT(false, "m_InputContext.GetUserGroups failed");
		// Don't fail. User tag will simply have no groups tag.
	}
	else
	{
		// Append
		sXML += sGroupsXML;
	}
	

	sXML << "</USER></" << sUserType << ">";	// Close </USER></USERTYPE>

	return true;
}

/*********************************************************************************

	bool CClub::AddUrl(const TDVCHAR* sUrl, const TDVCHAR* sTitle, const TDVCHAR* sDescription)

		Author:		James Pullicino/Igor
        Created:	15/06/2005
        Inputs:		sUrl: URL to clip/link.
        Outputs:	-
        Returns:	bool
        Purpose:	Clips a URL to a club. Identifies URL as internal or external.

*********************************************************************************/

bool CClub::AddUrl(const TDVCHAR* sUrl, const TDVCHAR* sTitle, const TDVCHAR* sDescription, const TDVCHAR* sRelationship)
{
	// The user must be logged in before we can do this!
	CUser* pUser = m_InputContext.GetCurrentUser();
	if (pUser == NULL)
	{
		return false;
	}

	// Identify URL and add as link
	CDnaUrl url(m_InputContext);
	url.Initialise(sUrl);

	if (url.IsExternal())
	{
		if (!AddLink(pUser, url.GetTypeName(), 0, sRelationship, url.GetUrl(), sTitle, sDescription))
		{
			TDVASSERT(false, "CClub::AddUrl AddLink() failed");
			return SetDNALastError("CClub::AddUrl", "AddLinkFailed", "Failed to add link");
		}
	}
	else if (!url.IsUnknown())
	{
		if (!AddLink(pUser, url.GetTypeName(),url.GetTargetId(), sRelationship, NULL, sTitle, sDescription))
		{
			TDVASSERT(false, "CClub::AddUrl AddLink() failed");
			return SetDNALastError("CClub::AddUrl", "AddLinkFailed", "Failed to add link");
		}
	}

	return true;
}

bool CClub::UnDelete( )
{
	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	if (pViewingUser == NULL)
	{
		SetDNALastError("EditClub","NoUser","No logged in user");
		return false;
	}

	if ( !m_bInitialised )
	{
		SetDNALastError("CClub","MakeHidden","Not Initialised.");
		return false;
	}

	if ( !IsUserAllowedToEditClub(pViewingUser,m_iClubID) )
	{
		SetDNALastError("CClub","MakeHidden","User Not Authorised");
		return false;
	}

	CArticleEditForm article(m_InputContext);
	if ( !article.CreateFromArticle(m_ih2g2ID, m_InputContext.GetCurrentUser()) )
	{
		SetDNALastError("CClub","UnDelete","Unable to initialise clubs article");
		return false;
	}

	if ( !article.UndeleteArticle(m_InputContext.GetCurrentUser()) )
	{
		SetDNALastError("CClub","UnDelete","Unable to initialise clubs article");
		return false;
	}

	//Need to re-initialise details.
	return Initialise(m_iClubID,true,true);
}

bool CClub::Delete()
{
	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	if (pViewingUser == NULL)
	{
		SetDNALastError("EditClub","NoUser","No logged in user");
		return false;
	}

	if ( !m_bInitialised )
	{
		SetDNALastError("CClub","MakeHidden","Not Initialised.");
		return false;
	}

	if ( !IsUserAllowedToEditClub(pViewingUser,m_iClubID) )
	{
		SetDNALastError("CClub","MakeHidden","User Not Authorised");
		return false;
	}

	CArticleEditForm article(m_InputContext);
	if ( !article.CreateFromArticle(m_ih2g2ID, m_InputContext.GetCurrentUser()) )
	{
		SetDNALastError("CClub","Delete","Unable to initialise clubs article");
		return false;
	}

	if ( !article.DeleteArticle(m_InputContext.GetCurrentUser()) )
	{
		SetDNALastError("CClub","Delete","Unable to initialise clubs article");
		return false;
	}

	//Need to re-initialise details.
	return Initialise(m_iClubID,true,true);

}