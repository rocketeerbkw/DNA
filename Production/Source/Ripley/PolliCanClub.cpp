// PolliCanClub.cpp
// James Pullicino
// 26th Jan 2005
// Implementation for CPolliCanClub

#include "stdafx.h"
#include "tdvassert.h"
#include "PolliCanClub.h"
#include "vote.h"
#include "club.h"
#include "dnaurl.h"
#include "votepagebuilder.h"
#include "link.h"
#include "polls.h"

CPolliCanClub::CPolliCanClub(CInputContext& inputContext, int nPollID) :
	CPoll(inputContext, nPollID)
{}

CPolliCanClub::~CPolliCanClub()
{}


/*********************************************************************************

	bool CPolliCanClub::Vote()

		Author:		James Pullicino
        Created:	26/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Handles voting for ican clubs

*********************************************************************************/

bool CPolliCanClub::Vote()
{
	if (AddRootXml() == false)
	{
		return false;
	}

	// Do voting
	int m_iObjectID;
	if(!internalVote(m_iObjectID))
	{
		// Handle failure
		if (m_iObjectID > 0)
		{
			CTDVString sXML;
			sXML << "<OBJECT TYPE='CLUB' ID='" << m_iObjectID << "'/>";

			if(!AddInside(GetRootElement(),sXML))
			{
				TDVASSERT(false, "CPolliCanClub::Vote() AddInside failed");

				if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::Vote() AddInside failed"))
				{
					TDVASSERT(false, "CPolliCanClub::Vote() AddErrorElement failed");
					return false;
				}

				return false;
			}
		}
		
		return false;
	}

	return true;
}


/*********************************************************************************

	bool CPolliCanClubVote::internalVote()

		Author:		James Pullicino
        Created:	26/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	This code is in its own function rather than in Vote() function
					simply so that i can check return value from vote and add the
					OBJECT element.

*********************************************************************************/

bool CPolliCanClub::internalVote(int & m_iObjectID)
{
	// The following code was taken from CVotePageBuilder::GetCommonInfo(bool)
	// It was modified slightly to work in new context.
	int m_iUserID;
	if (GetCommonInfo(m_iObjectID, m_iUserID) == false)
	{
		return false;
	}

	// Choose action
	bool bFinish = m_InputContext.ParamExists("userstatustype");

	CTDVString sAction;
	sAction << "<ACTION>" << (bFinish ? "finish" : "add") << "</ACTION>";
	
	// Add ACTION element
	if(!AddInside(GetRootElement(), sAction))
	{
		TDVASSERT(false, "CPolliCanClub::Vote() AddInside failed");
		return false;
	}


	// Get the users response
	if (!m_InputContext.ParamExists("response"))
	{
		if(!AddErrorElement(GetRootElement(), ERRORCODE_BADPARAMS, "Missing 'response' parameter"))
		{
			TDVASSERT(false, "CPolliCanClub::Vote() AddErrorElement failed");
			return false;
		}

		return true;
	}
        
	int m_iResponse = m_InputContext.GetParamInt("response");
	CTDVString sXML;
	sXML << "<RESPONSE>" << m_iResponse << "</RESPONSE>";
	bool bOk = AddInside(GetRootElement(),sXML);

	// Set the error message if something went wrong.
	if (!bOk)
	{
		TDVASSERT(false, "CPolliCanClub::Vote() There was an error generating the XML");
		
		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "There was an error generating the XML"))
		{
			TDVASSERT(false, "CPolliCanClub::Vote() AddErrorElement failed");
			return false;
		}

		return false;
	}

	// We have a userstatustype, which means that its time to register
	// the vote
	if(bFinish)
	{
		bool m_bShowUser;

		// Set the showuser flag
		if (m_iUserID > 0)
		{
			m_bShowUser = m_InputContext.GetParamInt("userstatustype") > 0 ? true : false;
		}
		else
		{
			m_bShowUser = false;
		}
        
		bool bAlreadyVoted = false;
		CVote m_CurrentVote(m_InputContext);
		
		// Get the UID For the current user.
		CTDVString m_sBBCUID;
		m_InputContext.GetBBCUIDFromCookie(m_sBBCUID);
		if (!m_CurrentVote.HasUserAlreadyVoted(GetPollID(),m_iUserID,m_sBBCUID,bAlreadyVoted))
		{
			TDVASSERT(false, "CPolliCanClub::Vote() m_CurrentVote.HasUserAlreadyVoted failed");
			
			if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::Vote() m_CurrentVote.HasUserAlreadyVoted failed"))
			{
				TDVASSERT(false, "CPolliCanClub::Vote() AddErrorElement failed");
				return false;
			}

			return false;
		}

		if (!bAlreadyVoted)
		{
			int m_iThreadID = 0;

			// Add the response
			if (!m_CurrentVote.AddResponceToVote(GetPollID(),m_iUserID,m_sBBCUID,m_iResponse,m_bShowUser,m_iThreadID))
			{
				TDVASSERT(false, "CPolliCanClub::Vote() m_CurrentVote.AddResponceToVote failed");
				
				if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::Vote() m_CurrentVote.AddResponceToVote failed"))
				{
					TDVASSERT(false, "CPolliCanClub::Vote() AddErrorElement failed");
					return false;
				}

				return false;
			}
		}
	}

	// Now get all the users who voted with the same Response
	CVote m_CurrentVote(m_InputContext);
	if (!m_CurrentVote.GetAllUsersWithResponse(GetPollID(),m_iResponse))
	{
		TDVASSERT(false, "CPolliCanClub::Vote() m_CurrentVote.GetAllUsersWithResponse failed");

		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::Vote() m_CurrentVote.GetAllUsersWithResponse failed"))
		{
			TDVASSERT(false, "CPolliCanClub::Vote() AddErrorElement failed");
			return false;
		}

		return false;
	}

	if(!AddInside(GetRootElement(),&m_CurrentVote))
	{
		TDVASSERT(false, "CPolliCanClub::Vote() AddInside failed");

		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::Vote() AddInside failed"))
		{
			TDVASSERT(false, "CPolliCanClub::Vote() AddErrorElement failed");
			return false;
		}
	}

	return true;
}

/*********************************************************************************
bool CPolliCanClub::AddUserXml(int iUserId)
Author:		Igor Loboda
Created:	28/04/2005
Inputs:		iUserId - user id
Purpose:	adds <USER> element to xml		
*********************************************************************************/

bool CPolliCanClub::AddUserXml(int iUserId)
{
	CStoredProcedure SP;
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML,&SP);

	// Start with the USER info
	bool bOk = XML.OpenTag("USER");
	bOk = bOk && XML.AddIntTag("USERID", iUserId);

	if (bOk)
	{
		// Get the user name if we have a valid UserID
		if (iUserId > 0)
		{
			m_InputContext.InitialiseStoredProcedureObject(&SP);
			if (!SP.GetUserDetailsFromID(iUserId,m_InputContext.GetSiteID()))
			{
				TDVASSERT(false, "CPolliCanClub::AddUserXml SP.GetUserDetailsFromID failed");
			}
			else
			{
				CTDVString m_sUserName;

				bOk = bOk && XML.DBAddTag("USERNAME",NULL,true,true,&m_sUserName);
				bOk = bOk && XML.DBAddTag("AREA",NULL,false);
				bOk = bOk && XML.DBAddTag("TITLE",NULL,false);
				bOk = bOk && XML.DBAddTag("FIRSTNAMES",NULL,false);
				bOk = bOk && XML.DBAddTag("LASTNAME",NULL,false);
				bOk = bOk && XML.DBAddTag("SITESUFFIX",NULL,false);
				bOk = bOk && XML.DBAddTag("STATUS",NULL,false);
				bOk = bOk && XML.DBAddTag("TAXONOMYNODE",NULL,false);
				bOk = bOk && XML.DBAddTag("JOURNAL",NULL,false);
				bOk = bOk && XML.DBAddTag("ACTIVE",NULL,false);

				// Groups
				CTDVString sGroups;
				if(!m_InputContext.GetUserGroups(sGroups, iUserId))
				{
					TDVASSERT(false, "Failed to get user groups");
				}
				else
				{
					sXML += sGroups;
				}
			}
		}

		// Close
		if (XML.CloseTag("USER") == false)
		{
			bOk = false;
		}
	}

	// Add USER element
	if(!AddInside(GetRootElement(), sXML))
	{
		TDVASSERT(false, "CPolliCanClub::AddUserXml() AddInside failed");
		return false;
	}

	return true;
}

/*********************************************************************************
bool CPolliCanClub::GetCommonInfo(int& iObjectId, int& iUserId)
Author:		Igor Loboda
Created:	28/04/2005
Purpose:	puts generic information about the vote into the xml	
*********************************************************************************/

bool CPolliCanClub::GetCommonInfo(int& iObjectId, int& iUserId)
{
	// Set the error message if something went wrong.
	if (RealGetCommonInfo(iObjectId, iUserId) == false)
	{
		TDVASSERT(false, 
			"CPolliCanClub::GetCommonInfo() There was an error generating the XML");
		
		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, 
			"There was an error generating the XML"))
		{
			TDVASSERT(false, "CPolliCanClub::GetCommonInfo() AddErrorElement failed");
		}

		return false;
	}

	return true;
}

/*********************************************************************************
bool CPolliCanClub::RealGetCommonInfo(int& iObjectId, int& iUserId)
Author:		Igor Loboda
Created:	28/04/2005
Returns:	false if fails. 
Purpose:	puts generic information about the vote into the xml	
*********************************************************************************/

bool CPolliCanClub::RealGetCommonInfo(int& m_iObjectID, int& m_iUserID)
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
	CTDVString m_sBBCUID;
	m_InputContext.GetBBCUIDFromCookie(m_sBBCUID);
	
	// Initialise the XML Builder ready to create the XML
	if (AddUserXml(m_iUserID) == false)
	{
		return false;
	}

	CVote m_CurrentVote(m_InputContext);
	if (!m_CurrentVote.GetVote(GetPollID()))
	{
		TDVASSERT(false, "CPolliCanClub::Vote() m_CurrentVote.GetVote failed");
		if(!AddErrorElement(GetRootElement(), ERRORCODE_BADPOLLID, "InvalidVoteID"))
		{
			TDVASSERT(false, "CPolliCanClub::Vote() AddErrorElement failed");
			return false;
		}

		return false;
	}

	// We know type is POLLTYPE_CLUB
	int m_iType = POLLTYPE_CLUB;
	CTDVString sXML;
	sXML << "<VOTETYPE>" << m_iType << "</VOTETYPE>";
	bool bOk = AddInside(GetRootElement(),sXML);

	// First check to see if the user has already voted!
	// If the user id is 0 then we need to do a cookie check!
	bool bAlreadyVoted = false;
	if (!m_CurrentVote.HasUserAlreadyVoted(GetPollID(),m_iUserID,m_sBBCUID,bAlreadyVoted))
	{
		TDVASSERT(false, "CPolliCanClub::Vote() m_CurrentVote.HasUserAlreadyVoted failed");
		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::Vote() m_CurrentVote.HasUserAlreadyVoted failed"))
		{
			TDVASSERT(false, "CPolliCanClub::Vote() AddErrorElement failed");
			return false;
		}

		return false;
	}

	sXML.Empty();
	sXML << "<ALREADYVOTED>" << bAlreadyVoted << "</ALREADYVOTED>";
	bOk = bOk && AddInside(GetRootElement(),sXML);

	// Check to see if the current vote is closed?
	bool m_bVoteClosed = false;
	if (!m_CurrentVote.IsVoteClosed(m_bVoteClosed))
	{
		TDVASSERT(false, "CPolliCanClub::Vote() m_CurrentVote.IsVoteClosed failed");
		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, 
			"CPolliCanClub::Vote() m_CurrentVote.IsVoteClosed failed"))
		{
			TDVASSERT(false, "CPolliCanClub::Vote() AddErrorElement failed");
		}
		
		return false;
	}

	sXML.Empty();
	sXML << "<VOTECLOSED>" << m_bVoteClosed << "</VOTECLOSED>";
	bOk = bOk && AddInside(GetRootElement(),sXML);

	// Get the details from the vote
	sXML.Empty();
	sXML << "<VOTEID>" << GetPollID() << "</VOTEID>";
	bOk = bOk && AddInside(GetRootElement(),sXML);

	sXML.Empty();
	CTDVString m_sVoteName;
	m_CurrentVote.GetVoteName(m_sVoteName);
	sXML << "<VOTENAME>" << m_sVoteName << "</VOTENAME>";
	bOk = bOk && AddInside(GetRootElement(),sXML);

	// Get the club id for the vote
	m_iObjectID = 0;
	if (!m_CurrentVote.GetObjectIDFromVoteID(GetPollID(),m_iType,m_iObjectID))
	{
		TDVASSERT(false, "CPolliCanClub::Vote() m_CurrentVote.GetObjectIDFromVoteID failed");
		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::Vote() m_CurrentVote.GetObjectIDFromVoteID failed"))
		{
			TDVASSERT(false, "CPolliCanClub::Vote() AddErrorElement failed");
			return false;
		}
		
		return false;
	}

	sXML.Empty();
	sXML << "<OBJECT TYPE='CLUB' ID='" << m_iObjectID << "'/>";
	bOk = bOk && AddInside(GetRootElement(),sXML);

	// Get the Club OwnerID
	CClub Club(m_InputContext);
	if (Club.InitialiseViaClubID(m_iObjectID) == false)
	{
		return false;
	}
	
	int m_iOwnerID = Club.GetOwnerTeamID();

	CTDVString sDate;

	// Now get the date the vote was created
	CTDVDateTime m_tDateCreated;
	m_CurrentVote.GetCreatedDate(m_tDateCreated);
	m_tDateCreated.GetRelativeDate(sDate);
	sXML.Empty();
	sXML << "<DATECREATED>" << sDate << "</DATECREATED>";
	bOk = bOk && AddInside(GetRootElement(),sXML);

	// Now get the closing date for the vote
	sDate.Empty();
	CTDVDateTime m_tClosingDate;
	m_CurrentVote.GetClosingDate(m_tClosingDate);
	if (m_tClosingDate != NULL)
	{
		sDate << (-m_tClosingDate.DaysElapsed());
	}
	sXML.Empty();
	sXML << "<CLOSINGDATE>" << sDate << "</CLOSINGDATE>";
	bOk = bOk && AddInside(GetRootElement(),sXML);

	return bOk;
}

/*********************************************************************************

	bool CPolliCanClub::RemoveVote()

		Author:		James Pullicino
        Created:	31/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Removes a users vote (original code from CVotePageBuilder::RemoveUserVote)

*********************************************************************************/

bool CPolliCanClub::RemoveVote()
{
	if (AddRootXml() == false)
	{
		return false;
	}

	if (m_InputContext.GetAllowRemoveVote() != 1)
	{
		if(!AddErrorElement(GetRootElement(), ERRORCODE_ACCESSDENIED, "Votes cannot be removed for this site"))
		{
			TDVASSERT(false, "CPolliCanClub::internalRemoveVote() AddErrorElement failed");
			return false;
		}

		return true;
	}

	// Set the action flag
	AddInside(GetRootElement(),"<ACTION>removeuservote</ACTION>");

	// Get the basic info
	CUser* pUser = m_InputContext.GetCurrentUser();
	if (pUser == NULL)
	{
		if(!AddErrorElement(GetRootElement(), ERRORCODE_NEEDUSER, "User not logged in"))
		{
			TDVASSERT(false, "CPolliCanClub::internalRemoveVote() AddErrorElement failed");
			return false;
		}

		return true;
	}

	// Get the voteid from the url
	int iVoteID = GetPollID();
	int iUserID = m_InputContext.GetParamInt("userid");
	
	// Check to see if the user is an editor or not
	if (  ( pUser->GetUserID() != iUserID  ) && !pUser->GetIsEditor() && !pUser->GetIsSuperuser() )
	{
		// We can't do anything if we're not an editor!
		if(!AddErrorElement(GetRootElement(), ERRORCODE_ACCESSDENIED, "Not authorised"))
		{
			TDVASSERT(false, "CPolliCanClub::internalRemoveVote() AddErrorElement failed");
			return false;
		}

		return true;
	}

	CVote m_CurrentVote(m_InputContext);

	// Now revome the vote for the user in the given vote.
	if (!m_CurrentVote.RemoveUsersVote(iVoteID,iUserID))
	{
		TDVASSERT(false, "CPolliCanClub::internalRemoveVote() m_CurrentVote.RemoveUsersVote failed");

		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::internalRemoveVote() m_CurrentVote.RemoveUsersVote failed"))
		{
			TDVASSERT(false, "CPolliCanClub::internalRemoveVote() AddErrorElement failed");
			return false;
		}

		return false;
	}

	// Now insert the vote XML, and return the verdict!
	if(!AddInside(GetRootElement(),&m_CurrentVote))
	{
		TDVASSERT(false, "CPolliCanClub::internalRemoveVote() AddInside failed");
		
		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::internalRemoveVote() AddInside failed"))
		{
			TDVASSERT(false, "CPolliCanClub::internalRemoveVote() AddInside failed");
			return false;
		}

		return false;
	}

	// Get redirect URL
	CTDVString sRedirectURL;
	if(m_InputContext.GetParamString("s_redirectto",sRedirectURL))
	{
		SetRedirectURL(sRedirectURL);
	}

	return true;
}



/*********************************************************************************

	bool CPolliCanClub::SubmitURL()

		Author:		James Pullicino
        Created:	31/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	For club votes, identifies the club from the vote id, takes the value of
					"url" cgi parameter, tries to identify the url and then clip it
					to the club. Code taken from CVotePageBuilder::SubmitUrl() (igor loboda).

*********************************************************************************/
/* moved to CClub and CClubBuilder jamesp 15/june/05
bool CPolliCanClub::SubmitURL()
{
	// The user must be logged in before we can do this!
	CUser* pUser = m_InputContext.GetCurrentUser();
	if (pUser == NULL)
	{
		return false;
	}

	if (AddRootXml() == false)
	{
		return false;
	}

	int m_iVoteID;

	m_iVoteID = GetPollID();

	CVote m_CurrentVote(m_InputContext);

	int iClubId = 0;
	if (!m_CurrentVote.GetObjectIDFromVoteID(m_iVoteID, CVotePageBuilder::VOTETYPE_CLUB, iClubId))
	{
		TDVASSERT(false, "CPolliCanClub::SubmitURL() m_CurrentVote.GetObjectIDFromVoteID failed");
		
		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::SubmitURL() m_CurrentVote.GetObjectIDFromVoteID failed"))
		{
			TDVASSERT(false, "CPolliCanClub::SubmitURL() AddErrorElement failed");
			return false;
		}

		return false;
	}

	// Get the Club OwnerID
	CClub club(m_InputContext);
	if (!club.InitialiseViaClubID(iClubId))
	{
		TDVASSERT(false, "CPolliCanClub::SubmitURL() club.InitialiseViaClubID failed");

		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::SubmitURL() club.InitialiseViaClubID failed"))
		{
			TDVASSERT(false, "CPolliCanClub::SubmitURL() AddErrorElement failed");
			return false;
		}
		
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
			if (!club.AddLink(m_InputContext.GetCurrentUser(), url.GetTypeName(), 0, 
				sRelationship, url.GetUrl(), sTitle, sDescription))
			{
				TDVASSERT(false, "CPolliCanClub::SubmitURL() club.AddLink failed");

				if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::SubmitURL() club.AddLink failed"))
				{
					TDVASSERT(false, "CPolliCanClub::SubmitURL() AddErrorElement failed");
					return false;
				}

				return false;
			}
		}
		else if (!url.IsUnknown())
		{
			if (!club.AddLink(m_InputContext.GetCurrentUser(), url.GetTypeName(), 
				url.GetTargetId(), sRelationship, NULL, sTitle, sDescription))
			{
				TDVASSERT(false, "CPolliCanClub::SubmitURL() club.AddLink failed");

				if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::SubmitURL() club.AddLink failed"))
				{
					TDVASSERT(false, "CPolliCanClub::SubmitURL() AddErrorElement failed");
					return false;
				}

				return false;
			}
		}
	}

	CTDVString sRedirect;
	sRedirect << "G" << club.GetClubID();
	SetRedirectURL(sRedirect);

	return true;
}*/


/*********************************************************************************

	bool CPolliCanClub::DispatchCommand(const CTDVString & sCmd)

		Author:		James Pullicino
        Created:	01/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	adds support for addurl parameter

*********************************************************************************/

bool CPolliCanClub::DispatchCommand(const CTDVString & sCmd)
{
	/*	Moved to CClubBuilder - jamesp 15/june/05
	if(sCmd.CompareText("addurl"))	// ADDURL
	{
		if(!SubmitURL())
		{
			TDVASSERT(false, "CPoll::DispatchCommand() SubmitURL failed");
			return false;
		}

		return true;
	}
	else */
	
	if(sCmd.CompareText("view"))
	{
		return ViewVote();
	}
    
	// Base class will process rest of supported commands
	return CPoll::DispatchCommand(sCmd);
}

/*********************************************************************************
bool CPolliCanClub::AddRootXml()
Author:		Igor Loboda
Created:	28/04/2005
Purpose:	adds xml element returned by GetRootElement. 
			Currently <VOTING-PAGE>.	
*********************************************************************************/

bool CPolliCanClub::AddRootXml()
{
	CTDVString sXML;
	sXML << "<" << GetRootElement() << "></" << GetRootElement() << ">";
	if(!CreateFromXMLText(sXML, 0, true))
	{
		TDVASSERT(false, "CPolliCanClub::AddRootXml() CreateFromXMLText failed");
		return false;
	}

	return true;
}

/*********************************************************************************
bool CPolliCanClub::ViewVote()
Author:		Igor Loboda
Created:	27/04/05
Returns:	true on success
Purpose:	puts vote details, list of links, list of users voted
*********************************************************************************/

bool CPolliCanClub::ViewVote()
{
	if (AddRootXml() == false)
	{
		return false;
	}

	// Get the basic info
	int iClubId;
	int iUserId;
	if (GetCommonInfo(iClubId, iUserId) == false)
	{
		return false;
	}

	// Now get all the users who voted with the same Response
	if (!AddClubLinksXml(iClubId))
	{
		return false;
	}

	if (!AddPollXml())
	{
		return false;
	}

	//This is not optimal, but will give ican team opportunity to
	//see the xml and to decide on it. If they are happy with the
	//xml a new methods could be added to CVote returning the
	//same xml as these two calls combined

	CVote m_CurrentVote(m_InputContext);

	// Now get all the users who voted with Response 1
	if (!m_CurrentVote.GetAllUsersWithResponse(GetPollID(), 1))
	{
		AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, 
			m_CurrentVote.GetLastErrorMessage());
		return false;
	}

	if (AddInside(GetRootElement(),&m_CurrentVote) == false)
	{
		return false;
	}

	// Now get all the users who voted with Response 0
	if (!m_CurrentVote.GetAllUsersWithResponse(GetPollID(), 0))
	{
		AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, 
			m_CurrentVote.GetLastErrorMessage());
		return false;
	}


	return AddInside(GetRootElement(),&m_CurrentVote);
}

/*********************************************************************************
bool CPolliCanClub::AddPollXml()
Author:		Igor Loboda
Created:	27/04/05
Returns:	true on success
Purpose:	puts <POLL> element on the page
*********************************************************************************/

bool CPolliCanClub::AddPollXml()
{
	CPolls polls(m_InputContext);
	CPoll *pPoll = polls.GetPoll(GetPollID());
	if(!pPoll)
	{
		TDVASSERT(false, "CPolls::MakePollList() GetPoll returned 0");
		return false;
	}

	bool bRet = true;

	// Make poll XML
	CPoll::PollLink pl(GetPollID(), false);
	if(!pPoll->MakePollXML(pl))
	{
		TDVASSERT(false, "CPolls::MakePollList() pPoll->MakePoll failed");
		bRet = false;
	}
	else
	{
		// Add poll xml to this object			
		if(!AddInside(GetRootElement(), pPoll))
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
bool CPolliCanClub::AddPollXml()
Author:		Igor Loboda
Created:	27/04/05
Returns:	true on success
Purpose:	puts <CLUBLINKS> element on the page
*********************************************************************************/

bool CPolliCanClub::AddClubLinksXml(int iClubId)
{
	CLink Link(m_InputContext);
	bool bShowPrivateClubLinks = false;
	CUser* pUser = m_InputContext.GetCurrentUser();
	if (pUser != NULL)
	{
		CClub club(m_InputContext);
		bShowPrivateClubLinks = pUser->GetIsEditor() 
			|| club.IsUserInTeamMembersOfClub(pUser->GetUserID(), iClubId);
	}
	Link.GetClubLinks(iClubId, NULL, bShowPrivateClubLinks);
	return AddInside(GetRootElement(), &Link);
}

/*********************************************************************************

	bool CPolliCanClub::LinkPoll(int nItemID, ItemType nItemType)

		Author:		James Pullicino
        Created:	01/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Links club poll with club

*********************************************************************************/

bool CPolliCanClub::LinkPoll(int nItemID, ItemType nItemType)
{
	// Sanity check
	if(nItemType != CPoll::ITEMTYPE_CLUB)
	{
		TDVASSERT(false, "CPolliCanClub::LinkPoll() Invalid item type. Expected something else");
		return false;
	}

	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "CPolliCanClub::LinkPoll() m_InputContext.InitialiseStoredProcedureObject failed");
		return false;
	}

	if (!SP.AddVoteToClubTable(nItemID, GetPollID()))
	{
		TDVASSERT(false,"CPolliCanClub::LinkPoll() SP.AddVoteToClubTable failed");
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CPolliCanClub::LoadCurrentUserVote(int & nUserVote)

		Author:		James Pullicino
        Created:	02/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Loads currently logged on users vote, or vote of user with
					bbcuid if not logged in.

*********************************************************************************/

bool CPolliCanClub::LoadCurrentUserVote(int & nUserVote)
{
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "CPoll::LoadCurrentUserVote m_InputContext.InitialiseStoredProcedureObject failed");
		return false;
	}

	int nPollID = GetPollID();

	// Check what user voted (if we have a user...)
	CUser* pUser = m_InputContext.GetCurrentUser();
	
	if(pUser)  // User logged in
	{
		if(!SP.GetUserVotes(nPollID, pUser->GetUserID()))
		{
			TDVASSERT(false, "CPoll::LoadCurrentUserVote SP.GetUserVotes failed");
			return false;
		}
	}
	else	// User not logged in
	{
		CTDVString sBBCUID;
        if(!m_InputContext.GetBBCUIDFromCookie(sBBCUID))
		{
			TDVASSERT(false, "CPolliCanClub::LoadCurrentUserVote() m_InputContext.GetBBCUIDFromCookie failed");
			return false;
		}

		if(!SP.GetBBCUIDVotes(nPollID, sBBCUID))
		{
			TDVASSERT(false, "CPoll::LoadCurrentUserVote GetBBCUIDVotes failed");
			return false;
		}
	}

	// Read in user vote (if we have one!)
	if(!SP.IsEOF())
	{
		nUserVote = SP.GetIntField("Response");
	}
	else
	{
		// User has not voted
		nUserVote = -1;
	}

	return true;	
}

/*********************************************************************************
bool CPolliCanClub::LoadPollResults(resultsMap& pollResults, int& nUserVote)
Author:		Igor Loboda
Created:	21/04/2005
Inputs:		pollResults - adds links number to option attributes map
			nUserVote - not used
*********************************************************************************/

bool CPolliCanClub::LoadPollResults(resultsMap& pollResults, int& nUserVote)
{
	if (!CPoll::LoadPollResults(pollResults, nUserVote))
	{
		return false;
	}

	// Load number of links per support/opposition
	CStoredProcedure sp;
	if(!m_InputContext.InitialiseStoredProcedureObject(&sp))
	{
		TDVASSERT(false, "CPolliCanClub::LoadPollProperties() InitialiseStoredProcedureObject failed");
		return false;
	}

	if(!sp.GetVoteLinksTotals(GetPollID()))
	{
		TDVASSERT(false, "CPolliCanClub::LoadPollResults() SP.GetVoteLinksTotals() failed");
		return false;
	}

	// Go through results adding them to map
	while(!sp.IsEOF())
	{
		CTDVString sRelationship; 
		sp.GetField("relationship", sRelationship);
		CTDVString sLinksN;
		sp.GetField("linksn", sLinksN);

		int iResponse = sRelationship == "support" ? 1 : 0;
		pollResults.Add(UserStatus(1), iResponse, "linksn", sLinksN);
		sp.MoveNext();
	}

	return true;
}