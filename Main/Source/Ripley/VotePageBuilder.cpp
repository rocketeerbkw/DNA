// VotePageBuilder.cpp: implementation of the CVotePageBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "VotePageBuilder.h"
#include "TDVAssert.h"
#include "RegisterObject.h"
#include "Club.h"
#include "GuideEntry.h"
#include "Notice.h"
#include "XMLBuilder.h"
#include "StoredProcedure.h"
#include "DnaUrl.h"
#include "polls.h"
#include "poll.h"
#include "link.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CVotePageBuilder::CVotePageBuilder(CInputContext& inputContext):
				  CXMLBuilder(inputContext),m_pPage(NULL),m_CurrentVote(inputContext),
				  m_sVoteName(""), m_sUserName(""), m_tDateCreated(NULL), m_tClosingDate(NULL),
				  m_iVoteID(0), m_iObjectID(0), m_iResponse(0), m_bShowUser(true), m_bSimpleYesNo(true),
				  m_bVoteClosed(false), m_iType(0), m_iUserID(0), m_sBBCUID(""), m_iOwnerID(0),
				  m_iThreadID(0)
{
}

CVotePageBuilder::~CVotePageBuilder()
{
}

/*********************************************************************************

	CWholePage* CVotePageBuilder::Build()

	Author:		Mark Howitt
	Created:	26/08/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Creates the voting pages

	URL Inputs :-

	Action			- "Add" for add responce
					  "Create" to get the create vote page
					  "New" to create and process a new vote
					  "Finish" to display final page.
					  "view" to view a given vote
	VoteID			- The ID of the voting poll for the vote
	Type			- The Type of object the vote belongs to
	ObjectID		- The page ID which the vote lives on. This is used to 
					  navigate back to the page after finishing or canceling.
	Response		- The actual Response from the vote. "0" = Against "1" = For.
	ShowUser		- A Flag to state wether the user has requested to be
					  hidden or shown in the supporters table.
	VoteName		- The name of a new vote.
	ClosingDate		- A Date of when a vote is to close.
	UseYesNo		- A flag to see if we want a simple yes no voting system

*********************************************************************************/
bool CVotePageBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	// Create and initialize the page
	if (!InitPage(m_pPage, "VOTE", true))
	{
		TDVASSERT(false, "FailedToBuildVotePage");
		return false;
	}

	// Make sure the Vote member is clean and set to the correct Context
	m_CurrentVote.ResetVote(/*m_InputContext*/);

	// Setup the XML
	m_pPage->AddInside("H2G2","<VOTING-PAGE></VOTING-PAGE>");

	// Get the action from the url
	CTDVString sAction;
	m_InputContext.GetParamString("action",sAction);
	if (sAction.IsEmpty())
	{
		TDVASSERT(false, "No Action given!");
		m_pPage->SetError("NoActionGiven");
		return true;
	}

	// Now check which action we are doing and call the corisponding function
	bool bOk = false;
	if (sAction.CompareText("add"))
	{
		// We are trying to add a responce to a vote
		bOk = AddResponce();
	}
	else if (sAction.CompareText("finish"))
	{
		// We've voted, now display the finish page
		bOk = FinishPage();
	}
	else if(sAction.CompareText("new"))
	{
		// We're trying to create the new vote
		bOk = CreateNewVote();
	}
	else if(sAction.CompareText("create"))
	{
		// We're trying to setup a new vote
		bOk = CreateVotePage();
	}
	else if(sAction.CompareText("view"))
	{
		// We're trying to create the new vote
		bOk = ViewVote();
	}
	else if(sAction.CompareText("removeuservote"))
	{
		// We're trying to create the new vote
		bOk = RemoveUserVote();
	}
	else if(sAction.CompareText("addurl"))
	{
		bOk = SubmitUrl();
	}
	else
	{
		// Whats the action?
		m_pPage->SetError("InvalidAction");
	}

	// Check for error and then Close and return the page
	if (!bOk)
	{
		CTDVString sXML;
		if (m_iObjectID > 0)
		{
			sXML << "<OBJECT TYPE='";
			if (m_iType == VOTETYPE_CLUB)
			{
				sXML << "CLUB";
			}
			else if (m_iType == VOTETYPE_NOTICE)
			{
				sXML << "NOTICE";
			}
			else
			{
				sXML << "UNKNOWN";
			}
			sXML << "' ID='" << m_iObjectID << "'/>";
		}
		m_pPage->AddInside("VOTING-PAGE",sXML);
	}
	else
	{
		// Redirect
		CheckAndUseRedirectIfGiven(pPage);
	}

	return true;
}

/*********************************************************************************

	bool CVotePageBuilder::GetCommonInfo(bool bGetVoteInfo)

		Author:		Mark Howitt
        Created:	21/05/2004
        Inputs:		bGetVoteInfo - A flag that when true includes the info 
					on the current vote id
					bNeedResponseInfo - true to include <RESPONSE> element.
						response cgi parameter must be set
        Outputs:	-
        Returns:	-
        Purpose:	Gets all the common information on the current vote.

*********************************************************************************/
bool CVotePageBuilder::GetCommonInfo(bool bGetVoteInfo, bool bNeedResponseInfo)
{
	// Get the current user
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	m_iUserID = 0;
	if (pViewingUser)
	{
		// Get the id of the current viewing user
		m_iUserID = pViewingUser->GetUserID();
	}

	// Get the UID For the current user.
	m_InputContext.GetBBCUIDFromCookie(m_sBBCUID);
	
	// Initialise the XML Builder ready to create the XML
	CStoredProcedure SP;
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);

	// Start with the USER info
	bool bOk = XML.OpenTag("USER");
	bOk = bOk && XML.AddIntTag("USERID",m_iUserID);

	// Get the user name if we have a valid UserID
	if (m_iUserID > 0)
	{
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		if (!SP.GetUserDetailsFromID(m_iUserID,m_InputContext.GetSiteID()))
		{
			TDVASSERT(false, "Failed to find user name from id");
		}
		else
		{
			bOk = bOk && XML.DBAddTag("USERNAME",NULL,true,true,&m_sUserName);
			bOk = bOk && XML.DBAddTag("FIRSTNAMES",NULL,false);
			bOk = bOk && XML.DBAddTag("LASTNAME",NULL,false);
			bOk = bOk && XML.DBAddTag("AREA",NULL,false);
			bOk = bOk && XML.DBAddTag("TITLE",NULL,false);			
			bOk = bOk && XML.DBAddTag("SITESUFFIX",NULL,false);			
			bOk = bOk && XML.DBAddIntTag("JOURNAL", NULL, false);				
			bOk = bOk && XML.DBAddIntTag("STATUS", NULL, false);
			bOk = bOk && XML.DBAddIntTag("TAXONOMYNODE", NULL, false);
			bOk = bOk && XML.DBAddIntTag("ACTIVE");		

			//get the groups to which this user belongs to 		
			CTDVString sGroupXML;		
			bOk = bOk && m_InputContext.GetUserGroups(sGroupXML, m_iUserID);
			sXML = sXML + sGroupXML;
		}
	}

	// Close and add to the page
	bOk = bOk && XML.CloseTag("USER");
	bOk = bOk && m_pPage->AddInside("VOTING-PAGE",sXML);

	// Check to if we require vote info
	if (bOk && bGetVoteInfo)
	{
		// First get the vote ID
		m_iVoteID = m_InputContext.GetParamInt("voteid");

		// Now setup the Vote Object
		if (!m_CurrentVote.GetVote(m_iVoteID))
		{
			m_pPage->SetError("InvalidVoteID"); 
			return false;
		}

		// Get the type from the url
		m_iType = m_InputContext.GetParamInt("type");
		sXML.Empty();
		sXML << "<VOTETYPE>" << m_iType << "</VOTETYPE>";
		bOk = bOk && m_pPage->AddInside("VOTING-PAGE",sXML);

		// First check to see if the user has already voted!
		// If the user id is 0 then we need to do a cookie check!
		bool bAlreadyVoted = false;
		if (!m_CurrentVote.HasUserAlreadyVoted(m_iVoteID,m_iUserID,m_sBBCUID,bAlreadyVoted))
		{
			m_pPage->SetError("FailedCheckingAlreadyVoted"); 
			return false;
		}

		sXML.Empty();
		sXML << "<ALREADYVOTED>" << bAlreadyVoted << "</ALREADYVOTED>";
		bOk = bOk && m_pPage->AddInside("VOTING-PAGE",sXML);

		// Check to see if the current vote is closed?
		m_bVoteClosed = false;
		if (!m_CurrentVote.IsVoteClosed(m_bVoteClosed))
		{
			m_pPage->SetError("DontKnowIfVoteClosed"); 
			return false;
		}

		sXML.Empty();
		sXML << "<VOTECLOSED>" << m_bVoteClosed << "</VOTECLOSED>";
		bOk = bOk && m_pPage->AddInside("VOTING-PAGE",sXML);

		// Get the details from the vote
		m_CurrentVote.GetVoteName(m_sVoteName);
		sXML.Empty();
		sXML << "<VOTEID>" << m_iVoteID << "</VOTEID>";
		bOk = bOk && m_pPage->AddInside("VOTING-PAGE",sXML);

		sXML.Empty();
		sXML << "<VOTENAME>" << m_sVoteName << "</VOTENAME>";
		bOk = bOk && m_pPage->AddInside("VOTING-PAGE",sXML);

		// Get the club id for the vote
		m_iObjectID = 0;
		if (!m_CurrentVote.GetObjectIDFromVoteID(m_iVoteID,m_iType,m_iObjectID))
		{
			m_pPage->SetError("InvalidObjectID");
			return false;
		}

		// Output the correct type of XML
		if (m_iType == VOTETYPE_CLUB)
		{
			sXML.Empty();
			sXML << "<OBJECT TYPE='CLUB' ID='" << m_iObjectID << "'/>";
			bOk = bOk && m_pPage->AddInside("VOTING-PAGE",sXML);

			// Get the Club OwnerID
			CClub Club(m_InputContext);
			Club.InitialiseViaClubID(m_iObjectID);
			m_iOwnerID = Club.GetOwnerTeamID();
		}
		else if (m_iType == VOTETYPE_NOTICE)
		{
			// Get the NodeID from the ThreadID
			// Copy the Object id passed in through th eurl into the threadid varaible as the objectid
			// is actually the threadid for the notice being voted on.
			m_iThreadID = m_iObjectID;
			CNotice Notice(m_InputContext);
			Notice.GetNodeIDFromThreadID(m_iThreadID,m_InputContext.GetSiteID(),m_iObjectID);
			CTDVString sPostCode;
			m_InputContext.GetParamString("postcode",sPostCode);
			sXML.Empty();
			sXML << "<OBJECT TYPE='NOTICE' ID='" << m_iObjectID << "' POSTCODE='" << sPostCode << "'/>";
			bOk = bOk && m_pPage->AddInside("VOTING-PAGE",sXML);
		}
		else
		{
			m_pPage->SetError("InvalidObjectID");
			return false;
		}

		if (bNeedResponseInfo)
		{
			// Get the users response
			if (!m_InputContext.ParamExists("response"))
			{
				m_pPage->SetError("NoResponse");
				return false;
			}
			m_iResponse = m_InputContext.GetParamInt("response");
			sXML.Empty();
			sXML << "<RESPONSE>" << m_iResponse << "</RESPONSE>";
			bOk = bOk && m_pPage->AddInside("VOTING-PAGE",sXML);
		}

		// Now get the date the vote was created
		CTDVString sDate;
		m_CurrentVote.GetCreatedDate(m_tDateCreated);
		m_tDateCreated.GetRelativeDate(sDate);
		sXML.Empty();
		sXML << "<DATECREATED>" << sDate << "</DATECREATED>";
		bOk = bOk && m_pPage->AddInside("VOTING-PAGE",sXML);

		// Now get the closing date for the vote
		sDate.Empty();
		m_CurrentVote.GetClosingDate(m_tClosingDate);
		if (m_tClosingDate != NULL)
		{
			sDate << (-m_tClosingDate.DaysElapsed());
		}
		sXML.Empty();
		sXML << "<CLOSINGDATE>" << sDate << "</CLOSINGDATE>";
		bOk = bOk && m_pPage->AddInside("VOTING-PAGE",sXML);
	}

	// Set the error message if something went wrong.
	if (!bOk)
	{
		m_pPage->SetError("FailedAddingXMLToPage");
	}

	// Return Ok
	return bOk;
}

/*********************************************************************************

	bool CVotePageBuilder::AddResponce()

		Author:		Mark Howitt
        Created:	20/05/2004
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Adds the users response to the vote

*********************************************************************************/
bool CVotePageBuilder::AddResponce()
{
	// Set the action flag
	m_pPage->AddInside("VOTING-PAGE","<ACTION>add</ACTION>");

	// Get the basic info
	if (!GetCommonInfo(true))
	{
		return false;
	}

	// Now get all the users who voted with the same Response
	if (!m_CurrentVote.GetAllUsersWithResponse(m_iVoteID,m_iResponse))
	{
		m_pPage->SetError(m_CurrentVote.GetLastErrorMessage()); 
		return false;
	}

	// Now insert the vote XML, and return the verdict!
	return m_pPage->AddInside("VOTING-PAGE",&m_CurrentVote);
}

/*********************************************************************************

	bool CVotePageBuilder::FinishPage()

		Author:		Mark Howitt
        Created:	20/05/2004
        Inputs:		-
        Outputs:	-
        Returns:	true if everything ok, false if not
        Purpose:	Adds the users response to the vote and returns all the current
					Users with the same response.

*********************************************************************************/
bool CVotePageBuilder::FinishPage()
{
	// Set the action flag
	m_pPage->AddInside("VOTING-PAGE","<ACTION>finish</ACTION>");

	// Get the basic info
	if (!GetCommonInfo(true))
	{
		return false;
	}

	// Get the showuser flag
	if (m_iUserID > 0 && m_InputContext.ParamExists("showuser"))
	{
		m_bShowUser = m_InputContext.GetParamInt("showuser") > 0 ? true : false;
	}
	else
	{
		m_bShowUser = false;
	}

	bool bAlreadyVoted = false;
	if (!m_CurrentVote.HasUserAlreadyVoted(m_iVoteID,m_iUserID,m_sBBCUID,bAlreadyVoted))
	{
		m_pPage->SetError(m_CurrentVote.GetLastErrorMessage());
		return false;
	}

	if (!bAlreadyVoted)
	{
		// Add the response
		if (!m_CurrentVote.AddResponceToVote(m_iVoteID,m_iUserID,m_sBBCUID,m_iResponse,m_bShowUser,m_iThreadID))
		{
			m_pPage->SetError(m_CurrentVote.GetLastErrorMessage());
			return false;
		}
	}

	// Now get all the users who voted with the same Response
	if (!m_CurrentVote.GetAllUsersWithResponse(m_iVoteID,m_iResponse))
	{
		m_pPage->SetError(m_CurrentVote.GetLastErrorMessage());
		return false;
	}

	// Now insert the vote XML, and return the verdict!
	return m_pPage->AddInside("VOTING-PAGE",&m_CurrentVote);
}


/*********************************************************************************
bool CVotePageBuilder::SubmitUrl()
Author:		Igor Loboda
Created:	14/01/2005
Returns:	true - was able to clip given url, otherwise false. For non 
			club votes - always false.
Purpose:	For club votes, identifies the club from the vote id, takes the value of
			"url" cgi parameter, tries to identify the url and then clip it
			to the club.			
*********************************************************************************/

bool CVotePageBuilder::SubmitUrl()
{
	m_iType = m_InputContext.GetParamInt("type");
	if (m_iType != VOTETYPE_CLUB)
	{
		m_pPage->SetError("NotSupported");
		return false;
	}

	// The user must be logged in before we can do this!
	CUser* pUser = m_InputContext.GetCurrentUser();
	if (pUser == NULL)
	{
		m_pPage->SetError("UserNotLoggedIn");
		return false;
	}
		
	m_iVoteID = m_InputContext.GetParamInt("voteid");

	int iClubId = 0;
	if (!m_CurrentVote.GetObjectIDFromVoteID(m_iVoteID, m_iType, iClubId))
	{
		m_pPage->SetError("InvalidObjectID");
		return false;
	}

	// Get the Club OwnerID
	CClub club(m_InputContext);
	if (!club.InitialiseViaClubID(iClubId))
	{
		m_pPage->SetError(club.GetLastErrorMessage());
		return false;
	}

	CTDVString sRelationship;
	if (m_InputContext.ParamExists("response"))
	{
		switch (m_InputContext.GetParamInt("response"))
		{
			case 0 :
				sRelationship = "oppose";
			break;

			case 1 :
				sRelationship = "support";
			break;
		}
	}


	CTDVString sUrl;
	if (m_InputContext.GetParamString("url", sUrl))
	{		
		CTDVString sTitle;
		m_InputContext.GetParamString("title", sTitle);
		CTDVString sDescription;
		m_InputContext.GetParamString("description", sDescription);

		CDnaUrl url(m_InputContext);
		url.Initialise(sUrl);
		if (url.IsExternal())
		{
			if (!club.AddLink(m_InputContext.GetCurrentUser(), url.GetTypeName(), 0, sRelationship, 
				url.GetUrl(), sTitle, sDescription))
			{
				m_pPage->SetError(club.GetLastErrorMessage());
				return false;
			}
		}
		else if (!url.IsUnknown())
		{
			if (!club.AddLink(m_InputContext.GetCurrentUser(), url.GetTypeName(), url.GetTargetId(), 
				sRelationship, NULL, sTitle, sDescription))
			{
				m_pPage->SetError(club.GetLastErrorMessage());
				return false;
			}
		}
	}

	CTDVString sRedirect = "<REDIRECT-TO>";
	sRedirect << "G" << club.GetClubID() << "</REDIRECT-TO>";
	m_pPage->SetPageType("REDIRECT");
	return m_pPage->AddInside("H2G2", sRedirect);
}

/*********************************************************************************

	bool CVotePageBuilder::CreateNewVote()

		Author:		Mark Howitt
        Created:	20/05/2004
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Creates a new vote for a given club or noticeboard

*********************************************************************************/
bool CVotePageBuilder::CreateNewVote()
{
	// Set the action flag
	m_pPage->AddInside("VOTING-PAGE","<ACTION>new</ACTION>");

	// The user must be logged in before we can do this!
	CUser* pUser = m_InputContext.GetCurrentUser();
	if (pUser == NULL)
	{
		m_pPage->SetError("UserNotLoggedIn");
		return false;
	}

	// Get the basic info
	if (!GetCommonInfo(false))
	{
		return false;
	}

	// First check the Objectid to atach the vote to.
	m_iObjectID = m_InputContext.GetParamInt("objectid");
	if (m_iObjectID <= 0)
	{
		m_pPage->SetError("NoObjectID");
		return false;
	}

	// Get the type from the url
	m_iType = m_InputContext.GetParamInt("type");

	// Check to make sure the current user is the owner of the club or that they are an editor
	bool bIsAllowed = pUser->GetIsEditor() || pUser->GetIsSuperuser();
	if (!bIsAllowed)
	{
		// Check to see if the user is a member of a club or thread owner
		m_CurrentVote.IsUserAuthorisedToCreateVote(m_iObjectID,m_iType,pUser->GetUserID(),bIsAllowed);
		if (!bIsAllowed)
		{
			m_pPage->SetError("UserNotAuthorised");
			return false;
		}
	}

	// Get the closing date for the vote
	int iDay = m_InputContext.GetParamInt("day");
	int iMonth = m_InputContext.GetParamInt("month");
	int iYear = m_InputContext.GetParamInt("year");
	m_tClosingDate = NULL;
	CTDVString sDate;
	if (iDay > 0 && iMonth > 0 && iYear > 0)
	{
		m_tClosingDate.SetDate(iYear,iMonth,iDay);
	}

	if (m_tClosingDate > m_tClosingDate.GetCurrentTime())
	{
		sDate << (-m_tClosingDate.DaysElapsed());
	}

	// Now see if we want to do a simple yes no vote
	m_bSimpleYesNo = m_InputContext.GetParamInt("useyesno") > 0 ? true : false;

	// Now create the new object
	m_iVoteID = m_CurrentVote.CreateVote(m_iType,m_tClosingDate,m_iOwnerID,m_bSimpleYesNo);

	// Make sure the vote id is valid!
	if (m_iVoteID <= 0)
	{
		m_pPage->SetError("FailedToCreateVote");
		return false;
	}

	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML);
	XML.AddIntTag("VOTEID",m_iVoteID);
	XML.OpenTag("OBJECT",true);
	if (m_iType == VOTETYPE_CLUB)
	{
		XML.AddAttribute("TYPE","CLUB");
	}
	else if (m_iType == VOTETYPE_NOTICE)
	{
		XML.AddAttribute("TYPE","NOTICE");
	}
	XML.AddIntAttribute("ID",m_iObjectID,true);
	XML.CloseTag("OBJECT");
	XML.AddTag("CLOSINGDATE",sDate);
	m_CurrentVote.GetCreatedDate(m_tDateCreated);
	XML.AddDateTag("CREATEDDATE",m_tDateCreated,true);

	// Now upsate the ClubVotes table with the new vote
	m_CurrentVote.AddVoteToClubTable(m_iVoteID,m_iObjectID,&m_sVoteName);
	XML.AddTag("VOTENAME",m_sVoteName);

	// Put the XML into the page and return
	return m_pPage->AddInside("VOTING-PAGE",sXML);
}

/*********************************************************************************

	bool CVotePageBuilder::CreateVotePage()

		Author:		Mark Howitt
        Created:	20/05/2004
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Just gets the common info for now. NOT USED!!!!

*********************************************************************************/
bool CVotePageBuilder::CreateVotePage()
{
	// Setup the create page info
	m_pPage->AddInside("VOTING-PAGE","<ACTION>create</ACTION>");

	// Get the basic info
	if (!GetCommonInfo(false))
	{
		return false;
	}

	return true;
}

/*********************************************************************************
bool CVotePageBuilder::ViewVote()
Author:		Igor Loboda
Created:	27/04/05
Returns:	true on success
Purpose:	puts vote details, list of links, list of users voted
*********************************************************************************/

bool CVotePageBuilder::ViewVote()
{
	// Get the basic info
	if (!GetCommonInfo(true, false))
	{
		return false;
	}

	if (m_iType == VOTETYPE_CLUB)
	{
		// Now get all the users who voted with the same Response
		if (!AddClubLinksXml())
		{
			return false;
		}

		if (!AddPollXml())
		{
			return false;
		}
	}

	//This is not optimal, but will give ican team opportunity to
	//see the xml and to decide on it. If they are happy with the
	//xml a new methods could be added to CVote returning the
	//same xml as these two calls combined

	// Now get all the users who voted with Response 1
	if (!m_CurrentVote.GetAllUsersWithResponse(m_iVoteID, 1))
	{
		m_pPage->SetError(m_CurrentVote.GetLastErrorMessage()); 
		return false;
	}
	if (m_pPage->AddInside("VOTING-PAGE",&m_CurrentVote) == false)
	{
		return false;
	}

	// Now get all the users who voted with Response 0
	if (!m_CurrentVote.GetAllUsersWithResponse(m_iVoteID, 0))
	{
		m_pPage->SetError(m_CurrentVote.GetLastErrorMessage()); 
		return false;
	}


	return m_pPage->AddInside("VOTING-PAGE",&m_CurrentVote);
}

/*********************************************************************************
bool CVotePageBuilder::AddPollXml()
Author:		Igor Loboda
Created:	27/04/05
Returns:	true on success
Purpose:	puts <POLL> element on the page
*********************************************************************************/

bool CVotePageBuilder::AddPollXml()
{
	CPolls polls(m_InputContext);
	CPoll *pPoll = polls.GetPoll(m_iVoteID);
	if(!pPoll)
	{
		TDVASSERT(false, "CPolls::MakePollList() GetPoll returned 0");
		return false;
	}

	bool bRet = true;

	// Make poll XML
	CPoll::PollLink pl(m_iVoteID, false);
	if(!pPoll->MakePollXML(pl))
	{
		TDVASSERT(false, "CPolls::MakePollList() pPoll->MakePoll failed");
		bRet = false;
	}
	else
	{
		// Add poll xml to this object			
		if(!m_pPage->AddInside("VOTING-PAGE", pPoll))
		{
			TDVASSERT(false, "CPolls::MakePollList() AddInside failed");
			bRet = false;
		}
	}

	// Done with poll
	delete pPoll;

	return bRet;
}

/*********************************************************************************
bool CVotePageBuilder::AddPollXml()
Author:		Igor Loboda
Created:	27/04/05
Returns:	true on success
Purpose:	puts <CLUBLINKS> element on the page
*********************************************************************************/

bool CVotePageBuilder::AddClubLinksXml()
{
	CLink Link(m_InputContext);
	bool bShowPrivateClubLinks = false;
	CUser* pUser = m_InputContext.GetCurrentUser();
	if (pUser != NULL)
	{
		CClub club(m_InputContext);
		bShowPrivateClubLinks = pUser->GetIsEditor() 
			|| club.IsUserInTeamMembersOfClub(pUser->GetUserID(), m_iObjectID);
	}
	Link.GetClubLinks(m_iObjectID, NULL, bShowPrivateClubLinks);
	return m_pPage->AddInside("VOTING-PAGE", &Link);
}

/*********************************************************************************

	bool CVotePageBuilder::RemoveUserVote()

		Author:		Mark Howitt
        Created:	06/08/2004
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Removes a users vote from a given vote.

*********************************************************************************/
bool CVotePageBuilder::RemoveUserVote()
{

	if (m_InputContext.GetAllowRemoveVote() != 1)
	{
		m_pPage->SetError("Votes cannot be removed for this site"); 
		return false;
	}

	// Set the action flag
	m_pPage->AddInside("VOTING-PAGE","<ACTION>removeuservote</ACTION>");

	// Get the basic info
	CUser* pUser = m_InputContext.GetCurrentUser();
	if (pUser == NULL)
	{
		// We can't do anything if we're not logged in!
		m_pPage->SetError("UserNotLoggedIn");
		return false;
	}

	// Get the voteid from the url
	int iVoteID = m_InputContext.GetParamInt("voteid");
	int iUserID = m_InputContext.GetParamInt("userid");
	
	// Check to see if the user is an editor or not
	if (  ( pUser->GetUserID() != iUserID  ) && !pUser->GetIsEditor() && !pUser->GetIsSuperuser() )
	{
		// We can't do anything if we're not an editor!
		m_pPage->SetError("UserNotAuthorised");
		return false;
	}


	// Now revome the vote for the user in the given vote.
	if (!m_CurrentVote.RemoveUsersVote(iVoteID,iUserID))
	{
		m_pPage->SetError(m_CurrentVote.GetLastErrorMessage()); 
		return false;
	}

	// Now insert the vote XML, and return the verdict!
	return m_pPage->AddInside("VOTING-PAGE",&m_CurrentVote);
}