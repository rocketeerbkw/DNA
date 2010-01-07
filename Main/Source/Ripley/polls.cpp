// Implementation of CPolls
// James Pullicino
// 10th Jan 2005
#include "stdafx.h"
#include "tdvassert.h"

#include "polls.h"
#include "poll.h"

#include "pollcontentrating.h"	// ContentRating poll
#include "pollicanclub.h"		// iCan club
#include "pollnoticeboard.h"	// iCan notice boards

CPolls::~CPolls()
{
	// nothing to do
}

CPolls::CPolls(CInputContext& inputContext)
: CXMLObject(inputContext)
{
}


/*********************************************************************************

	bool CPolls::MakePollList(int nItemID, CPoll::PollType pollType)

		Author:		James Pullicino
        Created:	20/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Populates object with POLL-LIST xml

*********************************************************************************/

bool CPolls::MakePollList(int nItemID, CPoll::ItemType nItemType)
{
	// Add root xml
	if(!CreateFromXMLText("<POLL-LIST></POLL-LIST>", 0, true))
	{
		TDVASSERT(false, "CPolls::MakePollList() CreateFromXMLText failed");
		return false;
	}
	
	// Load polllinks properties for this item
	PollLinks pollLinks;
	if(!LoadPollLinks(pollLinks, nItemID, nItemType))
	{
		TDVASSERT(false, "CPolls::MakePollList() LoadPollLinks failed");
		return false;
	}

	// Generate XML for each poll that links to item
	PollLinks::iterator it = pollLinks.begin();
	while(it != pollLinks.end())
	{
		CPoll *pPoll = GetPoll(it->GetPollID());
		if(!pPoll)
		{
			TDVASSERT(false, "CPolls::MakePollList() GetPoll returned 0");
			// Continue with next poll			
		}
		else
		{
			// Make poll XML
			if(!pPoll->MakePollXML(*it))
			{
				TDVASSERT(false, "CPolls::MakePollList() pPoll->MakePoll failed");
				// Continue with next poll
			}
			else
			{
				// Add poll xml to this object			
				if(!AddInside("POLL-LIST", pPoll))
				{
					TDVASSERT(false, "CPolls::MakePollList() AddInside failed");
				}
			}

			// Done with poll
			delete pPoll;
		}

		it++;	// Next poll
	}

	return true;
}

/*********************************************************************************

	CPoll * CPolls::GetPoll(int nPollID, CPoll::PollType pollType = CPoll::POLLTYPE_UNKNOWN)

		Author:		James Pullicino
        Created:	20/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	Pointer to a newly created poll, or 0 on failure
        
		Purpose:	Creates an instance of a poll. Poll is created with
					new operator and has to be deleted by client using
					delete.

					NOTE: Don't forget to delete returned pointer!

*********************************************************************************/

CPoll * CPolls::GetPoll(int nPollID, CPoll::PollType pollType)
{
	int nResponseMin = -1;
	int nResponseMax = -1;
	bool bAllowAnonymousRating = false;
	if ( nPollID >= 0 && !LoadPollDetails(nPollID, pollType, nResponseMin, nResponseMax, bAllowAnonymousRating) )
	{
		//SetDNALastError("CPolls::GetPoll",GetPoll","Invalid poll ID");
		TDVASSERT(false, "CPolls::GetPoll() LoadPollType failed");

		// Add XML error element
		CTDVString sXML;
		sXML << "<VOTING-PAGE><ERROR code='" << int(CPoll::ERRORCODE_BADPOLLID) << "'>";
		sXML << "<DESCRIPTION>Invalid poll id</DESCRIPTION>";
		sXML << "</ERROR></VOTING-PAGE>";

		if(!CreateFromXMLText(sXML, 0, true))
		{
			TDVASSERT(false, "CPolls::GetPoll() CreateFromXMLText failed");
			return 0;
		}
		return NULL;
	}

	CPoll *pPoll = 0;

	// Create poll depending on type
	switch(pollType)
	{
		case CPoll::POLLTYPE_CONTENTRATING:
		
			pPoll = new CPollContentRating(m_InputContext, nPollID);
			break;

		case CPoll::POLLTYPE_CLUB:
			
			pPoll = new CPolliCanClub(m_InputContext, nPollID);
			break;

		case CPoll::POLLTYPE_NOTICE:
			
			pPoll = new CPollNoticeBoard(m_InputContext, nPollID);	
			break;

		default:

			TDVASSERT(false, "CPolls::GetPoll() Unknown poll type");
	}

	if ( pPoll && !(nResponseMin == -1 && nResponseMax == -1) )
	{
		pPoll->SetResponseMinMax( nResponseMin, nResponseMax );
	}

	if ( pPoll && bAllowAnonymousRating)
	{
		pPoll->SetAllowAnonymousRating(bAllowAnonymousRating);
	}

	// come on party pPoll
	return pPoll;
}


/*********************************************************************************

	bool CPolls::LoadPollLinks(PollLinks & pollLinks, int nItemID, CPoll::ItemType nItemType)

		Author:		James Pullicino
        Created:	19/01/2005
        Inputs:		-
        
		Outputs:	vector of poll links. pollLinks is cleared before being populated

					Override if you want to add polls to the list. Don't forget to
					call this base function first.

        Returns:	-
        Purpose:	Loads all poll links from database

*********************************************************************************/

bool CPolls::LoadPollLinks(PollLinks & pollLinks, int nItemID, CPoll::ItemType nItemType)
{
	// Start with empty list
	pollLinks.clear();

	// Init stored procedure object
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to Initialise Stored Procedure Object");
		return false;
	}

	// Load poll IDs from poll mapping table	
	if(!SP.GetPagePolls(nItemID, nItemType))
	{
		TDVASSERT(false, "Failed to Execute stored procedure GetPagePolls");
		return false;
	}

	// Load records into vector
	while(!SP.IsEOF())
	{
		// Push back poll ID and hidden flag
		pollLinks.push_back(CPoll::PollLink(SP.GetIntField("VoteID"),
			SP.GetBoolField("Hidden") ? true:false));
		SP.MoveNext();
	}

	// Load old polls
	if(nItemType == CPoll::ITEMTYPE_CLUB)
	{
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		if (!SP.GetVoteIDFromClubID(nItemID))
		{
			TDVASSERT(false, "CPolls::LoadPollLinks() SP.GetVoteIDFromClubID failed");
		}
		else if(!SP.IsEOF())
		{
			int iVoteID = SP.GetIntField("VoteID");
			pollLinks.push_back(CPoll::PollLink(iVoteID, false));
		}
	}

	if(nItemType == CPoll::ITEMTYPE_NOTICE)
	{
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		if (!SP.GetVoteIDForThreadID(nItemID))
		{
			TDVASSERT(false, "CPolls::LoadPollLinks() SP.GetVoteIDFromClubID failed");
		}
		else if(!SP.IsEOF())
		{
			int iVoteID = SP.GetIntField("VoteID");
			pollLinks.push_back(CPoll::PollLink(iVoteID, false));
		}
	}


	return true;
}


/*********************************************************************************

	bool CPolls::LoadPollDetails(int nPollID, CPoll::PollType& pollType, int& nResponseMin, int& nResponseMax, bool& bAllowAnonymousRating)

		Author:		James Pullicino
        Created:	20/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Loads poll type from database

*********************************************************************************/

bool CPolls::LoadPollDetails(int nPollID, CPoll::PollType & pollType, int& nResponseMin, int& nResponseMax, bool& bAllowAnonymousRating )
{
 	// Validate poll id
	if(nPollID < 1)
	{
		TDVASSERT(false, "CPolls::LoadPollType() invalid parameter nPollID");
		return false;
	}

	// Get poll type from database
	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "CPolls::LoadPollType() m_InputContext.InitialiseStoredProcedureObject failed");
		return false;
	}

	// We could create a specialized SP that will only select poll type, but its
	// not worth the coding effort at this point. Use GetPollDetails instead.
	if (!SP.GetPollDetails(nPollID))
	{
		TDVASSERT(false, "CPolls::LoadPollType() SP.GetPollDetails failed");
		return false;
	}

	// Check if we found the poll
	if (SP.IsEOF())
	{
		TDVASSERT(false, "CPolls::LoadPollType() Poll not found");
		return false;
	}
	
	// Minimum allowed response value if defined.
	pollType = static_cast<CPoll::PollType>(SP.GetIntField("Type")); 
	nResponseMin = -1;
	if ( SP.FieldExists("ResponseMin") && !SP.IsNULL("ResponseMin") ) 
	{
		nResponseMin = SP.GetIntField("ResponseMin");
	}
	
	// Maximum allowed response value
	nResponseMax = -1;
	if ( SP.FieldExists("ResponseMax") && !SP.IsNULL("ResponseMax") ) 
	{
		nResponseMax = SP.GetIntField("ResponseMax");
	}

	bAllowAnonymousRating = false;
	if ( SP.FieldExists("AllowAnonymousRating") && !SP.IsNULL("AllowAnonymousRating") ) 
	{
		bAllowAnonymousRating = SP.GetBoolField("AllowAnonymousRating");
	}

	return true;
}