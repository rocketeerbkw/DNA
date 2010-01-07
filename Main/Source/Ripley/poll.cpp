// Implementation for CPoll

#include "stdafx.h"
#include "tdvassert.h"
#include "tdvstring.h"
#include "tdvdatetime.h"
#include "User.h"

#include "poll.h"

#include <map>
#include <string>

/*********************************************************************************
	CPoll::CPoll(CInputContext& inputContext, long nPollID = -1)

		Author:		James Pullicino
        Created:	06/01/2005
        Inputs:		Database context, PollID (or -1 if this is a new poll)
         Purpose:	Constructs Poll object
*********************************************************************************/
CPoll::CPoll(CInputContext& inputContext, int nPollID) : m_nResponseMax(-1), m_nResponseMin(-1), m_bAllowAnonymousRating(false),
	CXMLObject(inputContext)
{ 
	m_nPollID = nPollID;
}


/*********************************************************************************

	bool CPoll::MakePollXML(const PollLink & pollLink)

		Author:		James Pullicino
        Created:	20/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Makes XML for poll. Used by CPolls::MakePollList

*********************************************************************************/

bool CPoll::MakePollXML(const PollLink & pollLink, bool bIncludePollResults)
{
	// Make a copy
	PollLink pl(pollLink);

	// Load properties for this poll
/*	if(!LoadPollProperties(pl.m_PollProperties))
	{
		TDVASSERT(false, "CPoll::MakePollXML() LoadPollProperties failed");
		return false;
	}
*/

	// Get poll type
	
	pl.m_PollProperties.m_PollType = GetPollType();

	if(bIncludePollResults)
	{
		// Load results for this poll
		if(!LoadPollResults(pl.GetPollResults(), pl.GetCurrentUserVote()))
		{
			TDVASSERT(false, "CPoll::MakePollXML() LoadPollResults failed");
			return false;
		}
	}

	// Finally, make poll xml
	if(!MakePoll(pl))
	{
		TDVASSERT(false, "CPoll::MakePollXML() MakePoll failed");
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CPoll::LoadPollResults(resultsMap & pollResults, int & nUserVote)

		Author:		James Pullicino
        Created:	19/01/2005
        Inputs:		-
        
		Outputs:	pollResults is first cleared, then populated with results for
					the required poll

					nUserVote set to current user vote, or -1 if user did not vote
					or no user is logged in

        Returns:	-
        Purpose:	Load results of all polls into pollResults vector

*********************************************************************************/

bool CPoll::LoadPollResults(resultsMap & pollResults, int & nUserVote)
{
	int nPollID = GetPollID();
	
	// Validate poll id
	if(nPollID < 1) 
	{
		TDVASSERT(false, "CPoll::LoadPollResults() Invalid parameter nPollID");	
		return false;
	}

	// Start from clean slate
	pollResults.clear();

	// Load poll results from database
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "CPoll::LoadPollProperties() m_InputContext.InitialiseStoredProcedureObject failed");
		return false;
	}

	if(!SP.GetPollResults(nPollID))
	{
		TDVASSERT(false, "CPoll::LoadPollResults() SP.GetPollResults() failed");
		return false;
	}

	// Go through results adding them to map
	while(!SP.IsEOF())
	{
		UserStatus userstatus = static_cast<UserStatus>(SP.GetIntField("Visible"));
		int response = SP.GetIntField("Response");
		CTDVString count;
		SP.GetField("count", count);
		pollResults.Add(userstatus, response, "count", count);

		// Next!
		SP.MoveNext();
	}

	// Get User Vote. Doing this inside the GetPollResults stored procedure would be more
	// efficient.
	if(!LoadCurrentUserVote(nUserVote))
	{
		TDVASSERT(false, "CPoll::LoadPollResults() LoadCurrentUserVote() failed");
		// Not a critical error
	}

	return true;
}

/*********************************************************************************
void CPoll::resultsMap::Add(const UserStatus& userStatus, int iResponse, 
	const char* pKey, const char* pValue)
Author:		Igor Loboda
Created:	21/04/2005
Inputs:		userStatus - user status (anonymous/signed in)
			iResponse - response index
			pKey - attribute name
			pValue - attribute value
Purpose:	Allows population of a map which is later used by the code which
			generates xml. Attribute keys and values will end up as <OPTION>
			element xml attributes (key="value")
*********************************************************************************/

void CPoll::resultsMap::Add(const UserStatus& userStatus, int iResponse, 
	const char* pKey, const char* pValue)
{
	if (find(userStatus) == end())
	{
		(*this)[userStatus] = optionsMap();
	}

	if ((*this)[userStatus].find(iResponse) == (*this)[userStatus].end())
	{
		(*this)[userStatus][iResponse] = COptionAttributes();
	}

	(*this)[userStatus][iResponse][pKey] = pValue;
}

/*********************************************************************************

	bool CPoll::MakePoll(CXMLObject & pollXML, const PollLink & pollLink)

		Author:		James Pullicino
        Created:	19/01/2005
        Inputs:		-
        Outputs:	This object is populated with <POLL> xml
        Returns:	-
        Purpose:	Makes XML for a single poll

*********************************************************************************/

bool CPoll::MakePoll(const PollLink & pollLink)
{
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML, NULL);

	// Open POLL tag
	if(!OpenXMLTag("POLL", true))
	{
		TDVASSERT(false, "CPoll::MakePoll() OpenXMLTag failed");
		return false;
	}

	// Add poll id
	if(!AddXMLIntAttribute("pollid", pollLink.GetPollID(), false))
	{
		TDVASSERT(false, "CPoll::MakePoll() AddXMLIntAttribute failed");
		return false;
	}

	// Add poll type
	if(!AddXMLIntAttribute("polltype", pollLink.GetPollType(), false))
	{
		TDVASSERT(false, "CPoll::MakePoll() AddXMLIntAttribute failed");
		return false;
	}

	//Poll limits 
	if ( m_nResponseMin >= 0 &&  !AddXMLIntAttribute("minresponse",m_nResponseMin,false) )
	{
		TDVASSERT(false, "CPoll::MakePoll() AddXMLIntAttribute failed");
		return false;
	}

	if ( m_nResponseMax >= 0 &&  !AddXMLIntAttribute("maxresponse",m_nResponseMax,false) )
	{
		TDVASSERT(false, "CPoll::MakePoll() AddXMLIntAttribute failed");
		return false;
	}

	if ( m_bAllowAnonymousRating == true &&  !AddXMLIntAttribute("anonymousrating", 1,false) )
	{
		TDVASSERT(false, "CPoll::MakePoll() AddXMLIntAttribute failed");
		return false;
	}

	// Add hidden attribute
	if(!AddXMLIntAttribute("hidden", pollLink.m_Hidden, true))
	{
		TDVASSERT(false, "CPoll::MakePoll() AddXMLIntAttribute failed");
		return false;
	}
	
	// Add poll results if we have any
	if(!pollLink.GetPollResults().empty())
	{
		// Open OPTION-LIST tag
		if(!OpenXMLTag("OPTION-LIST", false))
		{
			TDVASSERT(false, "CPoll::MakePoll() OpenXMLTag failed");
			return false;
		}

		// Add vote results //
		resultsMap::const_iterator itUserStatus = pollLink.GetPollResults().begin();
		//resultsMap::iterator itUserStatus = pollLink.m_PollProperties.m_Results.begin();

		while(itUserStatus != pollLink.GetPollResults().end())
		{
			// Open USERSTATUS tag
			if(!OpenXMLTag("USERSTATUS", true))
			{
				TDVASSERT(false, "CPoll::MakePoll() OpenXMLTag failed");
				return false;
			}

			// Add User Type attribute
			if(!AddXMLIntAttribute("type", itUserStatus->first, true))
			{
				TDVASSERT(false, "CPoll::MakePoll() AddXMLIntAttribute failed");
				return false;
			}

			// Add OPTION tags
			optionsMap::const_iterator itOptions = itUserStatus->second.begin();
			while(itOptions != itUserStatus->second.end())
			{
				// Open OPTION tag
				if(!OpenXMLTag("OPTION", true))
				{
					TDVASSERT(false, "CPoll::MakePoll() OpenXMLTag failed");
					return false; // cannot continue
				}
				
				// Add index attribute
				if(!AddXMLIntAttribute("index", itOptions->first, false))
				{
					TDVASSERT(false, "CPoll::MakePoll() AddXMLIntAttribute failed");
					return false;
				}

				const COptionAttributes& attr = itOptions->second;
				COptionAttributes::const_iterator attrNextIt = attr.begin();
				for (COptionAttributes::const_iterator attrIt = attr.begin();
					attrIt != attr.end(); attrIt++)
				{
					attrNextIt++;

					// Add attributes
					if(!AddXMLAttribute(attrIt->first.c_str(), 
						attrIt->second.c_str(), attrNextIt == attr.end()))
					{
						TDVASSERT(false, "CPoll::MakePoll() AddXMLIntAttribute");
						return false;
					}
				}

				// Close OPTION tag
				if(!CloseXMLTag("OPTION"))
				{
					TDVASSERT(false, "CPoll::MakePoll() CloseXMLTag failed");
					return false;
				}

				itOptions++;
			}

			// Close USERSTATUS tag
			if(!CloseXMLTag("USERSTATUS"))
			{
				TDVASSERT(false, "CPoll::MakePoll() CloseXMLTag failed");
				return false;
			}

			itUserStatus++;
		}

		// Close OPTION-LIST tag
		if(!CloseXMLTag("OPTION-LIST"))
		{
			TDVASSERT(false, "CPoll::MakePoll() CloseXMLTag failed");
			return false;
		}
	}


	// Add USER-VOTE tag which holds the currently logged on user's vote. If it is -1, it means
	// user has not voted. In that case, do not put tag. Skin will check for existence of tag to
	// determine whether user has voted or not

/*
	int nUserVote = -1;
	if(!LoadCurrentUserVote(nUserVote))
	{
		TDVASSERT(false, "CPoll::MakePoll() LoadCurrentUserVote failed");
		// Pretend that user has not voted
	}
	else 
*/

	// User Vote now comes as part of pollLink so theres no need to load it from
	// the database
	int nUserVote = pollLink.GetCurrentUserVote();
	if(nUserVote != -1)
	{
		// Open USER-VOTE tag
		if(!OpenXMLTag("USER-VOTE", true))
		{
			TDVASSERT(false, "CPoll::MakePoll() OpenXMLTag failed");
			return false;
		}
		
		// Add choice attribute
		if(!AddXMLIntAttribute("choice", nUserVote, true))
		{
			TDVASSERT(false, "CPoll::MakePoll() AddXMLIntAttribute failed");
			return false;
		}

		// Close USER-VOTE tag
		if(!CloseXMLTag("USER-VOTE"))
		{
			TDVASSERT(false, "CPoll::MakePoll() CloseXMLTag failed");
			return false;
		}
	}
	
	// Add statistics if we have any
	if(!m_Stats.empty())
	{
		// Open STATISTICS tag
		if(!OpenXMLTag("STATISTICS", true))
		{
			TDVASSERT(false, "CPoll::MakePoll() OpenXMLTag failed");
			return false;
		}

		// Add stats as attributes
		statisticsMap::const_iterator it = m_Stats.begin();
		while(it != m_Stats.end())
		{
			// Add attribute
			std::string sName = it->first;
			std::string sValue = it->second;

			if(!AddXMLAttribute(sName.c_str(), sValue.c_str(), ++it == m_Stats.end()))
			{
				TDVASSERT(false, "CPoll::MakePoll() AddXMLIntAttribute failed");
				return false;
			}
		}
	
		// Close STATISTICS tag
		if(!CloseXMLTag("STATISTICS"))
		{
			TDVASSERT(false, "CPoll::MakePoll() CloseXMLTag failed");
			return false;
		}
	}

	// Close POLL tag
	if(!CloseXMLTag("POLL"))
	{
		TDVASSERT(false, "CPoll::MakePoll() CloseXMLTag failed");
		return false;
	}
	
	// Create/Check XML
	if(!CreateFromXMLText(sXML, 0, true))
	{
		TDVASSERT(false, "CPoll::MakePoll() CreateFromXMLText failed");
		return false;
	}

	// Put error element if an error was passed on url
	if(m_InputContext.ParamExists("PollErrorCode"))
	{
		if(!AddErrorElement("POLL", (CPoll::ErrorCode)m_InputContext.GetParamInt("PollErrorCode")))
		{
			TDVASSERT(false, "CPoll::MakePoll() AddErrorElement failed");
			return false;
		}
	}

	return true;
}


/*********************************************************************************

	bool CPoll::LoadCurrentUserVote(int & nUserVote)

		Author:		James Pullicino
        Created:	19/01/2005
        Inputs:		-
        Outputs:	nUserVote is assigned the value of: 
						the users vote
						-1 if current user has not voted
						-1 if current user has not logged in
        Returns:	-
        Purpose:	Get vote for current user

*********************************************************************************/

bool CPoll::LoadCurrentUserVote(int & nUserVote)
{
	// Check what user voted (if we have a user...)
	CUser* pUser = m_InputContext.GetCurrentUser();
		
	if (!m_bAllowAnonymousRating)
	{
		if(!pUser)  // User not logged in
		{
			nUserVote = -1;
			return true;
		}
	}

	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "CPoll::LoadCurrentUserVote m_InputContext.InitialiseStoredProcedureObject failed");
		return false;
	}

	int nPollID = GetPollID();

	if (!m_bAllowAnonymousRating)
	{
		if(!SP.GetUserVotes(nPollID, pUser->GetUserID()))
		{
			TDVASSERT(false, "CPoll::LoadCurrentUserVote SP.GetUserVotes failed");
			return false;
		}
	}
	else
	{
		if(pUser)	// If logged in get the user id?
		{
			if(!SP.GetUserVotes(nPollID, pUser->GetUserID()))
			{
				TDVASSERT(false, "CPoll::LoadCurrentUserVote SP.GetUserVotes failed");
				return false;
			}
		}
		else
		{
			CTDVString sBBCUID = "";
			// Get the UID For the current user.
			m_InputContext.GetBBCUIDFromCookie(sBBCUID);
			if(!SP.GetBBCUIDVotes(nPollID, sBBCUID))
			{
				TDVASSERT(false, "CPoll::LoadCurrentUserVote SP.GetBBCUIDVotes failed");
				return false;
			}
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

	bool CPoll::ProcessParamsFromBuilder()

		Author:		James Pullicino
        Created:	24/01/2005
        Inputs:		-
        Outputs:	1) Object is filled with XML with results
					2) sRedirectTo is filled in with redirect url (if redirect is needed)
        Returns:	-
        Purpose:	Process URL input. Dispatch command
		
		Web inputs:	cmd - Command to execute

*********************************************************************************/

bool CPoll::ProcessParamsFromBuilder(CTDVString & sRedirectURL)
{
	// Get command
	CTDVString sCmd = "";
	m_InputContext.GetParamString("cmd",sCmd);

	// Dispatch it
	if(!DispatchCommand(sCmd))
	{
		TDVASSERT(false, "CPoll::ProcessParamsFromBuilder() DispatchCommand failed");

		// Add error xml
		CTDVString sXML;
		sXML << "<" << GetRootElement() << "></" << GetRootElement() << ">";
		
		if(!CreateFromXMLText(sXML, 0, true))
		{
			TDVASSERT(false, "CPoll::ProcessParamsFromBuilder() CreateFromXMLText failed");
			return false;
		}

		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "CPoll::ProcessParamsFromBuilder() DispatchCommand failed"))
		{
			TDVASSERT(false, "CPoll::ProcessParamsFromBuilder() AddErrorElement failed");
			return false;
		}

		// Set redirect url
		sRedirectURL = m_sRedirectURL;

		return false;
	}

    // Set redirect url
	sRedirectURL = m_sRedirectURL;

	return true;
}

/*********************************************************************************

	bool CPoll::DispatchCommand(const TDVString & sCmd)

		Author:		James Pullicino
        Created:	24/01/2005
        Inputs:		-
        Outputs:	-
        
		Returns:	If DispatchCommand returns false, contents of XML will
					be cleared and XML will be populated with ERROR tag.

        Purpose:	Dispatches commands to the correct function based
					on the sCmd paramater.

					Derived classes must override this function to add
					or extend commands. Do not forget to call base class
					function (this one), or other commands will not be
					processed.

		Commands:	VOTE
					REMOVEVOTE
					HIDEPOLL (obsolete, use CONFIG instead)
					UNHIDEPOLL (obsolete, use CONFIG instead)
					CONFIG

*********************************************************************************/

bool CPoll::DispatchCommand(const CTDVString & sCmd)
{
	if(sCmd.CompareText("vote"))	// VOTE
	{
		if(!Vote())
		{
			TDVASSERT(false, "CPoll::DispatchCommand() Vote failed");
			return false;
		}

		return true;
	}

	if(sCmd.CompareText("removevote"))	// REMOVEVOTE
	{
		if(!RemoveVote())
		{
			TDVASSERT(false, "CPoll::DispatchCommand() RemoveVote failed");
			return false;
		}

		return true;
	}

	if(sCmd.CompareText("config"))	// CONFIG
	{
		// Config command is meant to configure poll. For now
		// we only have hide/unhide config feature. In the 
		// future we may have more. When this happens it would
		// be wise to refactor code below making it more extendible.
		// E.g, throw it in a virtual Config() function.

		// See if we want to hide/unhide
		if(m_InputContext.ParamExists("hide"))
		{
			if(!HidePoll(m_InputContext.GetParamInt("hide")==0?false:true))
			{
				TDVASSERT(false, "CPoll::DispatchCommand() HidePoll failed");
				return false;
			}
		}

		return true;
	}

	// UN/HIDEPOLL are obsolete but kept for backwards compatibility
	// Use CONFIG command instead
	if(sCmd.CompareText("hidepoll"))	// HIDEPOLL
	{
		if(!HidePoll(true))
		{
			TDVASSERT(false, "CPoll::DispatchCommand() HidePoll failed");
			return false;
		}

		return true;
	}

	// UN/HIDEPOLL are obsolete but kept for backwards compatibility
	// Use CONFIG command instead
	if(sCmd.CompareText("unhidepoll"))	// UNHIDEPOLL
	{
		if(!HidePoll(false))
		{
			TDVASSERT(false, "CPoll::DispatchCommand() HidePoll failed");
			return false;
		}

		return true;
	}

	return UnhandledCommand(sCmd);
}


/*********************************************************************************

	bool CPoll::UnhandledCommand(const TDVString & sCmd)

		Author:		James Pullicino
        Created:	24/01/2005
        Inputs:		-
        Outputs:	Creates XML page with error
        Returns:	false if failed to add error element
        Purpose:	Called when DispatchCommand does not recognise cmd parameter

*********************************************************************************/

bool CPoll::UnhandledCommand(const CTDVString & sCmd)
{
	// Add error xml
	CTDVString sXML;
	sXML << "<" << GetRootElement() << "></" << GetRootElement() << ">";
	
	if(!CreateFromXMLText(sXML, 0, true))
	{
		TDVASSERT(false, "CPoll::UnhandledCommand() CreateFromXMLText failed");
		return false;
	}
	
	if(!AddErrorElement(GetRootElement(), ERRORCODE_UNKNOWNCMD, "Unknown cmd parameter"))
	{
		TDVASSERT(false, "CPoll::UnhandledCommand() AddErrorElement failed");
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CPoll::AddErrorElement(const TDVCHAR* pTagName,int nErrorCode,const TDVCHAR* pDebugString)

		Author:		James Pullicino
        Created:	24/01/2005
        Inputs:		pTagName	 - Where to insert (null to insert at root)
					nErrorCode	 - The error code
					pDebugString - Optional, description of error for debug purposes
        Outputs:	-
        Returns:	-
        Purpose:	Adds <ERROR> element to our xml

*********************************************************************************/

bool CPoll::AddErrorElement(const TDVCHAR* pTagName, ErrorCode nErrorCode,const TDVCHAR* pDebugString)
{
	// Create error XML
	CTDVString sXML;
	sXML << "<ERROR code='" << int(nErrorCode) << "'>" << "<DESCRIPTION>";
	if(pDebugString) sXML << pDebugString;
	sXML << "</DESCRIPTION></ERROR>";

	if(pTagName)	// Add inside
	{
		if(!AddInside(pTagName, sXML))
		{
			TDVASSERT(false, "CPoll::AddErrorElement() AddInside failed");
			return false;
		}
	}
	else			// Add at root
	{
		if(!CreateFromXMLText(sXML, 0, true))
		{
			TDVASSERT(false, "CPoll::AddErrorElement() CreateFromXMLText failed");
			return false;
		}
	}
	return true;
}


/*********************************************************************************

	bool CPoll::CreatePoll()

		Author:		James Pullicino
        Created:	01/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Create poll

*********************************************************************************/

bool CPoll::CreatePoll()
{
	// Create vote using sp
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "CPoll::CreateNewPoll() m_InputContext.InitialiseStoredProcedureObject failed");
		return false;
	}

	if (!SP.CreateNewVote(m_nPollID, GetPollType(), CTDVDateTime(), false, 0, m_nResponseMin, m_nResponseMax, m_bAllowAnonymousRating))
	{
		TDVASSERT(false, "CPoll::CreateNewPoll() SP.CreateNewVote failed");
		return false;
	}

	return true;
}

/*********************************************************************************
	bool	CPoll::CreateNewPoll();						

		Author:		James Pullicino
        Created:	06/01/2005
        Inputs:		-
        Outputs:	none
        Returns:	false if failed to create
        
		Purpose:	Creates new poll in the database. Does not link it to 
					any article. Call LinkPollWithItem for that.
					
					Poll must be constructed with an id of -1 or else func will
					fail.

*********************************************************************************/

bool CPoll::CreateNewPoll()
{
	if(m_nPollID != -1)
	{
		// Cannot create a new poll if it already has an id
		TDVASSERT(false, "CPoll::CreateNewPoll() Cannot create poll: it is already created (m_nPollID is not -1)");
		return false;
	}

	return CreatePoll();
}


/*********************************************************************************

	bool CPoll::LinkPoll(int nItemID, ItemType nItemType)

		Author:		James Pullicino
        Created:	01/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Link a poll with h2g2 item. Override to customise
					link creation.

*********************************************************************************/

bool CPoll::LinkPoll(int nItemID, ItemType nItemType)
{
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "CPoll::LinkPoll() m_InputContext.InitialiseStoredProcedureObject failed");
		return false;
	}

	if (!SP.LinkPollWithItem(m_nPollID, nItemID, nItemType))
	{
		TDVASSERT(false, "CPoll::LinkPoll() SP.LinkPollWithItem failed");
		return false;
	}
	
	return true;
}

/*********************************************************************************
	bool	CPoll::LinkPollWithItem(int nItemID, int nItemType);

		Author:		James Pullicino
        Created:	06/01/2005
        Inputs:		ItemID and Item Type
        Outputs:	-
        Returns:	false on error
        Purpose:	Link a poll with an item/article
*********************************************************************************/
bool CPoll::LinkPollWithItem(int nItemID, ItemType nItemType)
{
	// Poll must be created
	if(GetPollID() == -1)
	{
		TDVASSERT(false, "CPoll::LinkPollWithItem() Poll is not yet created");
		return false;
	}

	if ( !LinkPoll(nItemID, nItemType) )
	{
		SetDNALastError("CPoll::LinkPollWithItem","LinkPollWithItem","Unable to link poll with item");
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CPoll::HidePoll(bool bHide, bool &bRedirect, int nItemID, int nItemType)

		Author:		James Pullicino
        Created:	11/01/2005

        Inputs:		bHide		- true=hide, false=unhide
					nItemID		- ID of item this poll is attached to
					nItemType	- Type of item this poll is attached to

					Note: If both nItemID and nItemType are 0, poll will be hidden
					for all items that this poll is attached to

        Outputs:	bRedirect:	Set to true if page should be redirected
					XML:		Generates XML as a response

        Returns:	true if succeeded, false otherwise
        Purpose:	Allows users/editors to hide polls

*********************************************************************************/

bool CPoll::HidePoll(bool bHide, int nItemID, CPoll::ItemType nItemType)
{
	// Create with VOTING-PAGE element as root
	CTDVString sXML;
	sXML << "<" << GetRootElement() << "></" << GetRootElement() << ">";
	if(!CreateFromXMLText(sXML, 0, true))
	{
		TDVASSERT(false, "CPoll::HidePoll() CreateFromXMLText failed");
		return false;
	}

	// Call our stored proc to hide poll
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if(!SP.HidePoll(bHide, m_nPollID, nItemID, nItemType))
	{
		TDVASSERT(false, "CPoll::HidePoll() SP.HidePoll failed");
		if(!AddErrorElement(GetRootElement(), CPoll::ERRORCODE_UNSPECIFIED, "CPoll::HidePoll() SP.HidePoll failed"))
		{
			TDVASSERT(false, "CPoll::HidePoll() AddErrorElement failed");
			return false;
		}

		return false;
	}

	return true;
}


/*********************************************************************************

	CTDVString CPoll::GetRootElement()

		Author:		James Pullicino
        Created:	27/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Returns root element for post-voting page. Derived classes might want to change
					this, but its advised not to since it will create inconsistencies
					amongst poll schemas

*********************************************************************************/

const CTDVString CPoll::GetRootElement() const
{
	return ("VOTING-PAGE");
}

/*********************************************************************************

	void CPoll::SetPollStatistic(const char * szName, const char * szValue)

		Author:		James Pullicino
        Created:	09/03/2005
        Inputs:		szName		-	statistic name
					szValue		-	statistic value (set to null to remove statistic)
        Outputs:	-
        Returns:	-
        Purpose:	Poll statistics are put in the <STATISTICS> tag inside the poll xml
					Use this function to add, change and remove statistics

*********************************************************************************/

void CPoll::SetPollStatistic(const char * szName, const char * szValue)
{
	// No name, no game
	TDVASSERT(szName, "NULL szName parameter sent to SetPollStatistic() function");
	if(!szName) return;

	// Set, Clear or Add to statistics map
	if(!szValue) 	
	{
		// Clear if value is null
		m_Stats.erase(szValue);
	}
	else			
	{
		// Set/Add
		m_Stats[szName] = szValue;
	}
}

void CPoll::SetResponseMinMax( int iResponseMin, int iResponseMax)
{
	m_nResponseMin = iResponseMin;
	m_nResponseMax = iResponseMax;
}

void CPoll::SetAllowAnonymousRating( bool bAllowAnonymousRating)
{
	m_bAllowAnonymousRating = bAllowAnonymousRating;
}

/*********************************************************************************

	bool CPoll::LoadPollProperties(PollProperties & pollProperties)

		Author:		James Pullicino
        Created:	19/01/2005
        Inputs:		-
        Outputs:	Populates the poll property class
        Returns:	-
        Purpose:	Loads propeties of a poll from the database

*********************************************************************************/
/* removed, see header files for details
bool CPoll::LoadPollProperties(PollProperties & pollProperties)
{
	int nPollID = GetPollID();

	// Validate poll id
	if(nPollID < 1)
	{
		TDVASSERT(false, "CPoll::LoadPollProperties() invalid parameter nPollID");
		return false;
	}

	// Get poll type from database
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "CPoll::LoadPollProperties() m_InputContext.InitialiseStoredProcedureObject failed");
		return false;
	}

	if (!SP.GetPollDetails(nPollID))
	{
		TDVASSERT(false, "CPoll::LoadPollProperties() SP.GetPollDetails failed");
		return false;
	}

	// Check if we found the poll
	if (SP.IsEOF())
	{
		TDVASSERT(false, "CPoll::LoadPollProperties() Poll not found");
		return false;
	}
	
	// Get the type
	pollProperties.m_PollType = static_cast<CPoll::PollType>(SP.GetIntField("Type")); 

	return true;
}*/