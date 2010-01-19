// PolliCanClub.cpp
// James Pullicino
// 26th Jan 2005
// Implementation for CPolliCanClub

#include "stdafx.h"
#include "tdvassert.h"
#include "PollNoticeBoard.h"
#include "vote.h"
#include "notice.h"
#include "votepagebuilder.h"

CPollNoticeBoard::CPollNoticeBoard(CInputContext& inputContext, int nPollID) :
	CPoll(inputContext, nPollID)
{}

CPollNoticeBoard::~CPollNoticeBoard()
{}


/*********************************************************************************

	bool CPollNoticeBoard::Vote()

		Author:		James Pullicino
        Created:	31/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Handles voting for ican notice boards

*********************************************************************************/

bool CPollNoticeBoard::Vote()
{
	// Create with VOTING-PAGE element as root
	CTDVString sXML;
	sXML << "<" << GetRootElement() << "></" << GetRootElement() << ">";
	if(!CreateFromXMLText(sXML, 0, true))
	{
		TDVASSERT(false, "CPolliCanClub::Vote() CreateFromXMLText failed");
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
			sXML << "<OBJECT TYPE='NOTICE' ID='" << m_iObjectID << "'/>";

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

	bool CPollNoticeBoard::internalVote()

		Author:		James Pullicino
        Created:	31/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	This code is in its own function rather than in Vote() function
					simply so that i can check return value from vote and add the
					OBJECT element.

*********************************************************************************/

bool CPollNoticeBoard::internalVote(int & m_iObjectID)
{
	// The following code was taken from CVotePageBuilder::GetCommonInfo(bool)
	// It was modified slightly to work in new context.

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

	int m_iUserID;

	// Get the current user
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	m_iUserID = 0;
	if (pViewingUser)
	{
		// Get the id of the current viewing user
		m_iUserID = pViewingUser->GetUserID();
	}

	CTDVString m_sBBCUID;

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
			TDVASSERT(false, "CPolliCanClub::Vote() SP.GetUserDetailsFromID failed");
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
		}
	}

	// Close
	bOk = bOk && XML.CloseTag("USER");

	CVote m_CurrentVote(m_InputContext);
	
	int m_iVoteID;
	int m_iResponse;
	
	if (bOk)
	{
		

		// First get the vote ID
		m_iVoteID = GetPollID();

		// Now setup the Vote Object
		if (!m_CurrentVote.GetVote(m_iVoteID))
		{
			TDVASSERT(false, "CPolliCanClub::Vote() m_CurrentVote.GetVote failed");
			if(!AddErrorElement(GetRootElement(), ERRORCODE_BADPOLLID, "InvalidVoteID"))
			{
				TDVASSERT(false, "CPolliCanClub::Vote() AddErrorElement failed");
				return false;
			}

			return false;
		}

		// We know type is notice
		int m_iType = CVotePageBuilder::VOTETYPE_NOTICE;
		sXML.Empty();
		sXML << "<VOTETYPE>" << m_iType << "</VOTETYPE>";
		bOk = bOk && AddInside(GetRootElement(),sXML);

		// First check to see if the user has already voted!
		// If the user id is 0 then we need to do a cookie check!
		bool bAlreadyVoted = false;
		if (!m_CurrentVote.HasUserAlreadyVoted(m_iVoteID,m_iUserID,m_sBBCUID,bAlreadyVoted))
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

		bool m_bVoteClosed;

		// Check to see if the current vote is closed?
		m_bVoteClosed = false;
		if (!m_CurrentVote.IsVoteClosed(m_bVoteClosed))
		{
			TDVASSERT(false, "CPolliCanClub::Vote() m_CurrentVote.IsVoteClosed failed");
			if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::Vote() m_CurrentVote.IsVoteClosed failed"))
			{
				TDVASSERT(false, "CPolliCanClub::Vote() AddErrorElement failed");
				return false;
			}
			
			return false;
		}

		sXML.Empty();
		sXML << "<VOTECLOSED>" << m_bVoteClosed << "</VOTECLOSED>";
		bOk = bOk && AddInside(GetRootElement(),sXML);

		CTDVString m_sVoteName;

		// Get the details from the vote
		m_CurrentVote.GetVoteName(m_sVoteName);
		sXML.Empty();
		sXML << "<VOTEID>" << m_iVoteID << "</VOTEID>";
		bOk = bOk && AddInside(GetRootElement(),sXML);

		sXML.Empty();
		sXML << "<VOTENAME>" << m_sVoteName << "</VOTENAME>";
		bOk = bOk && AddInside(GetRootElement(),sXML);

		// Get the club id for the vote
		m_iObjectID = 0;
		if (!m_CurrentVote.GetObjectIDFromVoteID(m_iVoteID,m_iType,m_iObjectID))
		{
			TDVASSERT(false, "CPolliCanClub::Vote() m_CurrentVote.GetObjectIDFromVoteID failed");
			if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPolliCanClub::Vote() m_CurrentVote.GetObjectIDFromVoteID failed"))
			{
				TDVASSERT(false, "CPolliCanClub::Vote() AddErrorElement failed");
				return false;
			}
			
			return false;
		}

		int m_iThreadID;

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
		bOk = bOk && AddInside(GetRootElement(),sXML);

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

		m_iResponse = m_InputContext.GetParamInt("response");
		sXML.Empty();
		sXML << "<RESPONSE>" << m_iResponse << "</RESPONSE>";
		bOk = bOk && AddInside(GetRootElement(),sXML);

		CTDVDateTime m_tDateCreated;

		// Now get the date the vote was created
		CTDVString sDate;
		m_CurrentVote.GetCreatedDate(m_tDateCreated);
		m_tDateCreated.GetRelativeDate(sDate);
		sXML.Empty();
		sXML << "<DATECREATED>" << sDate << "</DATECREATED>";
		bOk = bOk && AddInside(GetRootElement(),sXML);

		CTDVDateTime m_tClosingDate;

		// Now get the closing date for the vote
		sDate.Empty();
		m_CurrentVote.GetClosingDate(m_tClosingDate);
		if (m_tClosingDate != NULL)
		{
			sDate << (-m_tClosingDate.DaysElapsed());
		}
		sXML.Empty();
		sXML << "<CLOSINGDATE>" << sDate << "</CLOSINGDATE>";
		bOk = bOk && AddInside(GetRootElement(),sXML);
	}

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
		if (!m_CurrentVote.HasUserAlreadyVoted(m_iVoteID,m_iUserID,m_sBBCUID,bAlreadyVoted))
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
			if (!m_CurrentVote.AddResponceToVote(m_iVoteID,m_iUserID,m_sBBCUID,m_iResponse,m_bShowUser,m_iThreadID))
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
	if (!m_CurrentVote.GetAllUsersWithResponse(m_iVoteID,m_iResponse))
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

	bool CPollNoticeBoard::RemoveVote()

		Author:		James Pullicino
        Created:	01/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Remove users vote

*********************************************************************************/

bool CPollNoticeBoard::RemoveVote()
{
	// Create with VOTING-PAGE element as root
	CTDVString sXML;
	sXML << "<" << GetRootElement() << "></" << GetRootElement() << ">";
	if(!CreateFromXMLText(sXML, 0, true))
	{
		TDVASSERT(false, "CPollNoticeBoard::RemoveVote() CreateFromXMLText failed");
		return false;
	}

	if (m_InputContext.GetAllowRemoveVote() != 1)
	{
		if(!AddErrorElement(GetRootElement(), ERRORCODE_ACCESSDENIED, "Votes cannot be removed for this site"))
		{
			TDVASSERT(false, "CPollNoticeBoard::internalRemoveVote() AddErrorElement failed");
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
			TDVASSERT(false, "CPollNoticeBoard::internalRemoveVote() AddErrorElement failed");
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
			TDVASSERT(false, "CPollNoticeBoard::internalRemoveVote() AddErrorElement failed");
			return false;
		}

		return true;
	}

	CVote m_CurrentVote(m_InputContext);

	// Now revome the vote for the user in the given vote.
	if (!m_CurrentVote.RemoveUsersVote(iVoteID,iUserID))
	{
		TDVASSERT(false, "CPollNoticeBoard::internalRemoveVote() m_CurrentVote.RemoveUsersVote failed");

		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPollNoticeBoard::internalRemoveVote() m_CurrentVote.RemoveUsersVote failed"))
		{
			TDVASSERT(false, "CPollNoticeBoard::internalRemoveVote() AddErrorElement failed");
			return false;
		}

		return false;
	}

	// Now insert the vote XML, and return the verdict!
	if(!AddInside(GetRootElement(),&m_CurrentVote))
	{
		TDVASSERT(false, "CPollNoticeBoard::internalRemoveVote() AddInside failed");
		
		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPollNoticeBoard::internalRemoveVote() AddInside failed"))
		{
			TDVASSERT(false, "CPollNoticeBoard::internalRemoveVote() AddInside failed");
			return false;
		}

		return false;
	}

	return true;
}

/*********************************************************************************

	bool CPollNoticeBoard::LinkPoll(int nItemID, ItemType nItemType)

		Author:		James Pullicino
        Created:	01/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Links nb poll with a notice board

*********************************************************************************/

bool CPollNoticeBoard::LinkPoll(int nItemID, ItemType nItemType)
{
	// Sanity check
	if(nItemType != CPoll::ITEMTYPE_NOTICE)
	{
		TDVASSERT(false, "CPollNoticeBoard::LinkPoll() Invalid item type. Expected something else");
		return false;
	}

	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "CPollNoticeBoard::LinkPoll() m_InputContext.InitialiseStoredProcedureObject failed");
		return false;
	}

	if (!SP.AddVoteToThreadVoteTable(nItemID, GetPollID()))
	{
		TDVASSERT(false,"CPollNoticeBoard::LinkPoll() SP.AddVoteToThreadVoteTable failed");
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CPollNoticeBoard::LoadCurrentUserVote(int & nUserVote)

		Author:		James Pullicino
        Created:	03/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Loads currently logged on users vote, or vote of user with
					bbcuid if not logged in.

*********************************************************************************/

bool CPollNoticeBoard::LoadCurrentUserVote(int & nUserVote)
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