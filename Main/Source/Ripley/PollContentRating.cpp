// pollcontentrating.cpp
// Implementation for content rating poll class
// James Pullicino
// 20th Jan 2005

#include "stdafx.h"
#include "TDVAssert.h"
#include "User.h"
#include "pollcontentrating.h"

CPollContentRating::CPollContentRating(CInputContext& inputContext, int nPollID)
: CPoll(inputContext, nPollID)
{

}

CPollContentRating::~CPollContentRating()
{

}

/*********************************************************************************

	bool CPollContentRating::Vote()

		Author:		James Pullicino
        Created:	25/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Adds users vote to database
		Parameters:	"response" - Option Index that is user's vote

*********************************************************************************/

bool CPollContentRating::Vote()
{
	// Create with VOTING-PAGE element as root
	CTDVString sXML;
	sXML << "<" << GetRootElement() << "></" << GetRootElement() << ">";
	if(!CreateFromXMLText(sXML, 0, true))
	{
		TDVASSERT(false, "CPollContentRating::Vote() CreateFromXMLText failed");
		return false;
	}

	// Get redirect URL
	CTDVString sRedirectURL;
	if(!m_InputContext.GetParamString("s_redirectto",sRedirectURL) 
		|| sRedirectURL.IsEmpty())
	{
		// Skin must set s_redirectto for content rating polls
		TDVASSERT(false, "CPollContentRating::Vote() 's_redirectto' parameter not found.");
		
		if(!AddErrorElement(GetRootElement(), ERRORCODE_BADPARAMS, "'s_redirectto' not set by skin"))
		{
			TDVASSERT(false, "CPollContentRating::Vote() AddErrorElement failed");
			return false;
		}

		return true;
	}

	// Initialise the UserID
	int nUserID = 0;
	CTDVString sBBCUID;

	// Get User
	CUser *pUser = m_InputContext.GetCurrentUser();
	
	// Check PollID
	int nPollID = GetPollID();
	if(nPollID < 1)
	{
		TDVASSERT(false, "CPollContentRating::Vote() Invalid Poll ID");
		
		AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_BADPOLLID, "Invalid PollID");
		SetRedirectURL(sRedirectURL);

		return false;
	}

	if (!m_bAllowAnonymousRating) //Normal way needs to be logged in to vote
	{

		if(!pUser)	// Not logged in?
		{
			AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_NEEDUSER, "User not logged in");
			SetRedirectURL(sRedirectURL);

			return true;
		}

		if(!pUser->GetUserID(&nUserID))
		{
			TDVASSERT(false, "CPollContentRating::Vote() pUser->GetUserID failed");
			
			AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_UNSPECIFIED, "CPollContentRating::Vote() pUser->GetUserID failed");
			SetRedirectURL(sRedirectURL);
			
			return false;
		}
	}
	else //Anonymous rating
	{
		// Get the UID For the current user.
		m_InputContext.GetBBCUIDFromCookie(sBBCUID);

		if(pUser)	// If logged in get the user id?
		{
			if(!pUser->GetUserID(&nUserID))
			{
				TDVASSERT(false, "CPollAnonymousContentRating::Vote() Anonymous Rating pUser->GetUserID failed");
				
				AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_UNSPECIFIED, "CPollContentRating::Vote() Anonymous Rating pUser->GetUserID failed");
				SetRedirectURL(sRedirectURL);
				
				return false;
			}
		}
	}

	// Don't allow page author to vote
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// Get article id
	std::vector<int> vecArticleIDs;
	if(!SP.PollGetItemIDs(vecArticleIDs, GetPollID(), (int)CPoll::ITEMTYPE_ARTICLE))
	{
		TDVASSERT(false, "CPollContentRating::Vote() SP.PollGetItemIDs failed");

		AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_UNSPECIFIED, "CPollContentRating::Vote() SP.PollGetItemIDs failed");
		SetRedirectURL(sRedirectURL);

		return false;
	}

	// Check whether poll is linked with an article
	if(!vecArticleIDs.empty())
	{
		// CR polls can only be linked to a single article
		TDVASSERT(vecArticleIDs.size()==1, "ContentRating poll is linked to more than one article. Using first one.");

		int nAuthorID = 0;
		if(!SP.PollGetArticleAuthorID(nAuthorID, vecArticleIDs[0]))
		{
			TDVASSERT(false, "CPollContentRating::Vote() SP.PollGetArticleAuthorID failed");
			return false;
		}

		// Do author check
		if(nAuthorID == nUserID)
		{
			AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_AUTHORCANNOTVOTE, "Page author cannot vote on his article");
			SetRedirectURL(sRedirectURL);
			return true;	// Not a failure, just don't let him vote
		}
	}

	// Get users response
	int nResponse = m_InputContext.GetParamInt("response");

	// Check response
	if(nResponse < 0)
	{
		AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_BADPARAMS, "Invalid 'response' parameter");
		SetRedirectURL(sRedirectURL);
		return true;
	}

	//If limits defined - check within limits.
	if ( m_nResponseMin >= 0 && nResponse < m_nResponseMin )
	{
		AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_BADPARAMS, "Invalid 'response' parameter");
		SetRedirectURL(sRedirectURL);
		return true;
	}

	if ( m_nResponseMax >= 0 && nResponse > m_nResponseMax ) 
	{
		AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_BADPARAMS, "Invalid 'response' parameter");
		SetRedirectURL(sRedirectURL);
		return true;
	}

	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if(!m_bAllowAnonymousRating)
	{
		// Call stored procedure to update database
		if (!SP.PollContentRatingVote(nPollID, nUserID, nResponse))
		{
			TDVASSERT(false, "CPollContentRating::Vote() SP.PollContentRatingVote failed");
			
			AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_UNSPECIFIED, "Failed to save vote to database");
			SetRedirectURL(sRedirectURL);

			return false;
		}
	}
	else //Anonymous Rating
	{
		// Call stored procedure to update database
		if (!SP.PollAnonymousContentRatingVote(nPollID, nUserID, nResponse, sBBCUID))
		{
			TDVASSERT(false, "CPollContentRating::Vote() SP.AnonymousPollContentRatingVote failed");
			
			AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_UNSPECIFIED, "Failed to save vote to database");
			SetRedirectURL(sRedirectURL);

			return false;
		}
	}

	// Redirect back to page where poll resides
	SetRedirectURL(sRedirectURL);

	return true;
}

/*********************************************************************************

	void CPollContentRating::AddPollErrorCodeToURL(CTDVString & sURL, ErrorCode Code, const TDVCHAR * pDescription)

		Author:		James Pullicino
        Created:	25/01/2005
        Inputs:		pDescription is not actually used. This is intentional since it can
					be dangerous since it comes from URL.
        Outputs:	-
        Returns:	-
        Purpose:	Helper function to add PollErrorCode parameter to a URL

*********************************************************************************/

void CPollContentRating::AddPollErrorCodeToURL(CTDVString & sURL, ErrorCode Code, const TDVCHAR * pDescription)
{
	// Add PollErrorCode param
	CTDVString sErrorParam;	CTDVString sSep;
	
	if(sURL.ReverseFind('?') != -1) sSep = "&";	else sSep = "?";

	sErrorParam << sSep << "PollErrorCode=" << int(Code);

	sURL += sErrorParam;
}

/*********************************************************************************

	bool CPollContentRating::UnhandledCommand(const CTDVString & sCmd)

		Author:		James Pullicino
        Created:	25/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Called when cmd parameter is not recognised. Will redirect.

*********************************************************************************/

bool CPollContentRating::UnhandledCommand(const CTDVString & sCmd)
{
	// Get redirect URL
	CTDVString sRedirectURL;
	if(!m_InputContext.GetParamString("s_redirectto",sRedirectURL) 
		|| sRedirectURL.IsEmpty())
	{
		// Skin must set s_redirectto for content rating polls
		TDVASSERT(false, "CPollContentRating::Vote() 's_redirectto' parameter not found.");
		
		if(!AddErrorElement(GetRootElement(), ERRORCODE_UNSPECIFIED, "'s_redirectto' not set by skin"))
		{
			TDVASSERT(false, "CPollContentRating::UnhandledCommand() AddErrorElement failed");
			return false;
		}

		return false;
	}

	AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_UNKNOWNCMD);
	SetRedirectURL(sRedirectURL);

	return true;
}

/*********************************************************************************

	bool CPollContentRating::RemoveVote()

		Author:		James Pullicino
        Created:	31/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Removes users vote. Not supported.

*********************************************************************************/

bool CPollContentRating::RemoveVote()
{
	TDVASSERT(false, "CPollContentRating::RemoveVote() function not supported for content rating polls");

	// Create with VOTING-PAGE element as root
	CTDVString sXML;
	sXML << "<" << GetRootElement() << "></" << GetRootElement() << ">";
	if(!CreateFromXMLText(sXML, 0, true))
	{
		TDVASSERT(false, "CPollContentRating::RemoveVote() CreateFromXMLText failed");
		return false;
	}

	// Get redirect URL
	CTDVString sRedirectURL;
	if(!m_InputContext.GetParamString("s_redirectto",sRedirectURL) 
		|| sRedirectURL.IsEmpty())
	{
		// Skin must set s_redirectto for content rating polls
		TDVASSERT(false, "CPollContentRating::RemoveVote() 's_redirectto' parameter not found.");
		
		if(!AddErrorElement(GetRootElement(), ERRORCODE_BADPARAMS, "'s_redirectto' not set by skin"))
		{
			TDVASSERT(false, "CPollContentRating::RemoveVote() AddErrorElement failed");
			return false;
		}

		return true;
	}
	
	// Add error
	AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_BADPARAMS, "remove vote not supported in content rating polls");
	SetRedirectURL(sRedirectURL);

	return true;
}

/*********************************************************************************

	bool CPollContentRating::HidePoll(bool bHide, int nItemID,  ItemType nItemType)

		Author:		James Pullicino
        Created:	04/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Hides poll, redirects.

*********************************************************************************/

bool CPollContentRating::HidePoll(bool bHide, int nItemID,  ItemType nItemType)
{
	// Create with VOTING-PAGE element as root
	CTDVString sXML;
	sXML << "<" << GetRootElement() << "></" << GetRootElement() << ">";
	if(!CreateFromXMLText(sXML, 0, true))
	{
		TDVASSERT(false, "CPollContentRating::HidePoll() CreateFromXMLText failed");
		return false;
	}

	// Get redirect URL
	CTDVString sRedirectURL;
	if(!m_InputContext.GetParamString("s_redirectto",sRedirectURL) 
		|| sRedirectURL.IsEmpty())
	{
		// Skin must set s_redirectto for content rating polls
		TDVASSERT(false, "CPollContentRating::HidePoll() 's_redirectto' parameter not found.");
		
		if(!AddErrorElement(GetRootElement(), ERRORCODE_BADPARAMS, "'s_redirectto' not set by skin"))
		{
			TDVASSERT(false, "CPollContentRating::HidePoll() AddErrorElement failed");
			return false;
		}

		return true;
	}

	// Check access
	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		// Redirect with error
		AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_ACCESSDENIED, "Must be editor");
		SetRedirectURL(sRedirectURL);
		return true;
	}

	// Let base class do the work
	if(!CPoll::HidePoll(bHide, nItemID, nItemType))
	{
		// Redirect with error
		AddPollErrorCodeToURL(sRedirectURL, ERRORCODE_UNSPECIFIED, "CPollContentRating::HidePoll() CPoll::HidePoll failed");
		SetRedirectURL(sRedirectURL);
		return false;
	}

    // Redirect
	SetRedirectURL(sRedirectURL);
	return true;
}

/*********************************************************************************

	bool CPollContentRating::LinkPoll(int nItemID, ItemType nItemType)

		Author:		James Pullicino
        Created:	21/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	false on fail or if a link already exists for this poll
        Purpose:	Links a poll with an item. Limits to one poll per item.

*********************************************************************************/

bool CPollContentRating::LinkPoll(int nItemID, ItemType nItemType)
{
	// First make sure that we're not already linked to an item
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	std::vector<int> vecItemIDs;
	if (!SP.PollGetItemIDs(vecItemIDs, GetPollID()))
	{
		TDVASSERT(false, "CPollContentRating::LinkPoll() SP.PollGetItemIDs failed");
		return false;
	}

	// If we have ids, we have been linked
	if(!vecItemIDs.empty())
	{
		TDVASSERT(false, "CPollContentRating::LinkPoll() A link for this poll already exists");
		return false;
	}

	// Let base handle the rest
	if(!CPoll::LinkPoll(nItemID, nItemType))
	{
		TDVASSERT(false, "CPollContentRating::LinkPoll() CPoll::LinkPoll failed");
		return false;
	}

	return true;
}

/*********************************************************************************

	void CPollContentRating::SetContentRatingStatistics(int nVoteCount, double dblAverageRating)

		Author:		James Pullicino
        Created:	10/03/2005
        Inputs:		VoteCount and AverageRating
        Outputs:	-
        Returns:	-
        Purpose:	Set Statistics for this poll

*********************************************************************************/

void CPollContentRating::SetContentRatingStatistics(int nVoteCount, double dblAverageRating)
{
	// Convert to string
	CTDVString sVoteCount;
	sVoteCount << nVoteCount;

	CTDVString  sAvgRating;
	sAvgRating << dblAverageRating;

	// Add stats
	SetPollStatistic("votecount", sVoteCount);
	SetPollStatistic("averagerating", sAvgRating);
}