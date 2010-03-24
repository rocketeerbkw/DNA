// Notice.cpp: implementation of the CNotice class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "Notice.h"
#include "InputContext.h"
#include "TDVAssert.h"
#include "VotePageBuilder.h"
#include "Forum.h"
#include "ForumPostEditForm.h"
#include "PostCoder.h"
#include "XMLTree.h"
#include "StoredProcedure.h"
#include "polls.h"
#include "pollnoticeboard.h"
#include ".\tagitem.h"
#include ".\Eventqueue.h"
#include ".\notice.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CNotice::CNotice(CInputContext& inputContext) :
				 CXMLObject(inputContext),
				 m_iThreadID(0),m_sType(""),m_iUserID(0),m_sTitle(""),
				 m_sBody(""),m_tPostedDate(NULL),m_tEventDate(NULL),
				 m_iVoteID(0),m_iHiddenSupporters(0),m_iVisibleSupporters(0),
				 m_iPostID(0),m_iUserTaxNode(0),m_sTaxNodeName(""),m_sUsersPostCode(""),
				 m_sUserName(""), m_iForumID(0)
{

}

CNotice::~CNotice()
{
}

/*********************************************************************************

	bool CNotice::CreateNewNotice(int iNodeID, int iSiteID, CUser* pUser,
								  CTDVString &sType, CTDVString &sTitle,
								  CTDVString &sBody, CTDVString& sEventDate)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		NodeID of the noticeboard
				SiteID of the noticeboard to post to
				pUser - a Pointer to the user who is creating the notice
				sType - the type of notice being posted
				sTitle, sBody - the title and body of the new notice
				sEventDate - The date when the event or alert is to go off.
				TagNodeArray - A list of nodes you want to automatically tag the notice to.
	Returns:	true if posted ok, false if not
	Purpose:	Creates the notice from the given inputs and posts it to the
				Notice Board Forum

*********************************************************************************/

bool CNotice::CreateNewNotice(int iNodeID, int iSiteID, CUser* pUser, CTDVString &sType, CTDVString &sTitle, CTDVString &sBody, CTDVString& sEventDate, CDNAIntArray& TagNodeArray, int& iThreadID, bool* pbProfanityFound, bool* pbNonAllowedURLsFound, bool* pbEmailAddressFound )
{
	// Check to make sure that the site or user are not in premod, and that the site option 'processpremod' is 0
	// Posting notices will not work correct otherwise!!!
	if ((pUser->GetIsPreModerated() || m_InputContext.GetPreModerationState()) && m_InputContext.DoesSiteUsePreModPosting(iSiteID))
	{
		TDVASSERT(false,"Cannot post notices to a premod site with PreModPostings siteoption set!!!");
		return false;
	}

	// Check the user
	if (pUser == NULL)
	{
		TDVASSERT(false,"User Not Logged In!");
		return false;
	}

	// Check the user id
	int iUserID = pUser->GetUserID();
	if (iUserID == 0)
	{
		TDVASSERT(false,"User Not Logged In!");
		return false;
	}
	// Check to see if the user is an editor
	if (sType.CompareText("alert") && (!pUser->GetIsBBCStaff() && !pUser->GetIsEditor() && !pUser->GetIsSuperuser()))
	{
		TDVASSERT(false,"User Not Authorised to add Events");
		return false;
	}

	// Check to make sure we've got a valid nodeid
	if (iNodeID <= 0)
	{
		TDVASSERT(false,"Invalid NodeID given to create notice!");
		return false;
	}

	// Get the forumid for the node
	int iForumID = 0;
	if (!GetForumDetailsForNodeID(iNodeID,iSiteID,iForumID))
	{
		TDVASSERT(false,"Failed to get the forumid for the given nodeid!");
		return false;
	}

	// Get the new ThreadID
	iThreadID = 0;
	int iPostID = 0;
	CTDVDateTime tDate;

	// Now post to the forum
	bool bOk = false;

	CForum NoticeForum(m_InputContext);
	if (sEventDate.IsEmpty())
	{
		bOk = NoticeForum.PostToForum(pUser,iForumID,0,0,sTitle,sBody,1,&iThreadID,&iPostID,sType, NULL, pbProfanityFound, 0, iNodeID, NULL, false, NULL, false, 0, pbNonAllowedURLsFound, NULL, NULL, pbEmailAddressFound );
	}
	else
	{
		bOk = NoticeForum.PostToForum(pUser,iForumID,0,0,sTitle,sBody,1,&iThreadID,&iPostID,sType,sEventDate, pbProfanityFound, 0, iNodeID, NULL, false, NULL, false, 0, pbNonAllowedURLsFound, NULL, NULL, pbEmailAddressFound );
	}

	if (!bOk)
	{
		if ( pbProfanityFound && *pbProfanityFound == true)
		{
			return false;
		}
		else if ( pbNonAllowedURLsFound && *pbNonAllowedURLsFound == true)
		{
			return false;
		}
		else if ( pbEmailAddressFound && *pbEmailAddressFound == true )
		{
			return false;
		}
		else
		{
			TDVASSERT(false,"Failed to post to journal!");
			return false;
		}
	}

	// Check to see what type of notice we've just posted.
	// If it's a notice notice, then we need to supply a vote with it!
	if (sType.CompareText("notice"))
	{
		// Check to see if we've got a duplicate vote for this notice board. If not create a new one
		int iVoteID = 0;
		if (!GetVoteIDForNotice(iThreadID,iVoteID))
		{
			return SetDNALastError("CNotice::CreateNewNotice","FailedCheckingForVote","Failed checking for voteid");
		}

		// Did we find a vote? If not create it!
		if (iVoteID == 0)
		{
			CVote NoticeVote(m_InputContext);
			iVoteID = NoticeVote.CreateVote(CVotePageBuilder::VOTETYPE_NOTICE,tDate,iUserID,true);
			if (iVoteID > 0)
			{
				// Now add the vote to the threadvotes table.
				if (!NoticeVote.AddVoteToThreadTable(iVoteID,iThreadID))
				{
					TDVASSERT(false,"Failed to add a new vote to the threadvotes table!");
					return false;
				}
			}
		}
	
		// Code to create poll with new classes
		// Leave commented or we'll be creating two entries
		// when its uncommented, be sure to remove code above!!
		//CPollNoticeBoard poll(m_InputContext);
		//poll.CreateNewPoll();
		//poll.LinkPollWithItem(iThreadID, CPoll::ITEMTYPE_NOTICE);

	}

	// Check to see if we've been asked to tag this article to any nodes?
	if (TagNodeArray.GetSize() > 0)
	{
		// Get the tagitem object to do the tagging!
		CTagItem TagItem(m_InputContext);
		CEventQueue EQ(m_InputContext);
		TagItem.InitialiseFromThreadId(iThreadID,iSiteID,pUser);
		bool bOk = true;
		for (int i = 0; i < TagNodeArray.GetSize() && bOk; i++)
		{
			// Tag the nodes, but don't fail if it already exists!
			bOk = bOk && TagItem.AddTagItemToNode(TagNodeArray.GetAt(i),false);
		}

		// Check the ok flag
		TDVASSERT(bOk,"Failed to tag items to selected nodes");
	}

	// Now create some XML that states how it all went!
	return CreateActionXML("ADDNOTICE",iThreadID,iForumID,sType);
}

/*********************************************************************************

	bool CNotice::EditNotice(int iNodeID, int iSiteID, CUser* pUser,
								  CTDVString &sType, CTDVString &sTitle,
								  CTDVString &sBody, CTDVString& sEventDate)

	Author:		Martin Robb
	Created:	05/05/2006
	Inputs:		NodeID of the noticeboard
				SiteID of the noticeboard to post to
				pUser - a Pointer to the user who is creating the notice
				sType - the type of notice being posted
				sTitle, sBody - the title and body of the new notice
				sEventDate - The date when the event or alert is to go off.
				TagNodeArray - A list of nodes you want to automatically tag the notice to.
	Returns:	true if posted ok, false if not
	Purpose:	Creates the notice from the given inputs and posts it to the
				Notice Board Forum

*********************************************************************************/

bool CNotice::EditNotice(int iPostID, int iThreadId, int iForumId, CTDVString sType, CUser* pUser, CTDVString &sTitle, CTDVString &sBody, CTDVString& sEventDate, bool& bProfanityFound, bool& bNonAllowedURLsFound, bool& bEmailAddressFound )
{
	// Check the user
	if (pUser == NULL)
	{
		TDVASSERT(false,"User Not Logged In!");
		return false;
	}

	// Check the user id
	int iUserID = pUser->GetUserID();
	if (iUserID == 0)
	{
		TDVASSERT(false,"User Not Logged In!");
		return false;
	}

	// Now post to the forum
	bool bOk = false;
	bProfanityFound = false;
	bNonAllowedURLsFound = false;

	CForumPostEditForm NoticeForum(m_InputContext);
	NoticeForum.SetPostID(iPostID);

	if ( !NoticeForum.CheckUserCanEditRecentPost() )
	{
		SetDNALastError("CNotice::EditNotice","EditNotice","User does not have permission to edit post");
		return false;
	}
	
	CForumPostEditForm::PostUpdateError err;
	if ( !NoticeForum.ValidatePostDetails(sTitle,sBody,err) )
	{
		CopyDNALastError("CNotice::EditNotice",NoticeForum);
		return false;
	}

	if ( !NoticeForum.ProcessForumPostUpdate( pUser, sTitle, sBody, sEventDate,  true, false, false ) )
	{
		SetDNALastError("CNotice::EditNotice","EditNotice","Failed to uypdate notice");
		return false;
	}
	

	// Now create some XML that states how it all went!
	return CreateActionXML("EDITNOTICE",iThreadId, iForumId, sType);
}


/*********************************************************************************

	bool CNotice::CreateActionXML(int iThreadID, int iForumID, const TDVCHAR* psNoticeType)
		
		Author:		Mark Howitt
        Created:	05/05/2005
        Inputs:		iThreadID - The Id of the new thread created
					iForumID - The ForumID that the thread belongs to
					psType - the Type of notice that was just created
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Creates the XML and creates the Node Tree for the current action

*********************************************************************************/
bool CNotice::CreateActionXML(CTDVString sAction, int iThreadID, int iForumID, const TDVCHAR* psNoticeType)
{
	// Create the XML
	CDBXMLBuilder XML;
	CTDVString sXML;
	XML.Initialise(&sXML);
	XML.OpenTag(sAction);
	XML.AddIntTag("THREADID",iThreadID);
	XML.AddIntTag("FORUMID",iForumID);
	XML.AddTag("TYPE",psNoticeType);
	XML.CloseTag(sAction);

	// Now create the tree
	return CreateFromXMLText(sXML);
}

/*********************************************************************************

	bool CNotice::Initialise( SP, sXML)

	Author:		Martin Robb
	Created:	17/02/05
	Inputs:		Stored Procedure for initialisation
	Outputs:	Created XML
	Returns:	false on serious error
	Purpose:	Creates XML for a notice, given a stored procedure defining the required fields.
*********************************************************************************/
bool CNotice::Initialise(CStoredProcedure& SP, CTDVString& sXML)
{
	if ( SP.IsEOF() )
	{
		return false;
	}

	// Get all the details from the result!
	m_iThreadID = SP.GetIntField("ThreadID");
	m_iUserID = SP.GetIntField("UserID");
	SP.GetField("Type",m_sType);
	SP.GetField("Subject",m_sTitle);
	SP.GetField("text",m_sBody);
	m_tPostedDate = SP.GetDateField("DatePosted");
	m_tEventDate = SP.GetDateField("EventDate");
	m_iPostID = SP.GetIntField("EntryID");
	m_iUserID = SP.GetIntField("UserID");
	SP.GetField("UserName",m_sUserName);
	m_iUserTaxNode = SP.GetIntField("TaxonomyNode");
	SP.GetField("PostCode",m_sUsersPostCode);
	SP.GetField("DisplayName",m_sTaxNodeName);
	m_iForumID = SP.GetIntField("ForumID");

	// FORUMID
	sXML << "<FORUMID>" << m_iForumID << "</FORUMID>";

	// THREADID
	sXML << "<THREADID>" << m_iThreadID << "</THREADID>";

	// POSTID
	sXML << "<POSTID>" << m_iPostID << "</POSTID>";

	//wrap user information is user block
	sXML << "<USER>";
	
	// USERID
	sXML << "<USERID>" << m_iUserID << "</USERID>";
	
	// USER NAME
	sXML << "<USERNAME>" << m_sUserName << "</USERNAME>";

	// USER TAX NODE
	sXML << "<USERTAXNODE>" << m_iUserTaxNode << "</USERTAXNODE>";
	
	// USER TAX NODE NAME
	EscapeXMLText(&m_sTaxNodeName);
	sXML << "<TAXNODENAME>" << m_sTaxNodeName << "</TAXNODENAME>";
	
	// USER TITLE
	CTDVString sTitle;
	if (!SP.IsNULL("Title"))
	{
		SP.GetField("Title",sTitle);
		EscapeXMLText(&sTitle);
		sXML << "<TITLE>" << sTitle << "</TITLE>";
	}
	
	// USER AREA
	CTDVString sArea;
	if (!SP.IsNULL("Area"))
	{	
		SP.GetField("Area",sArea);
		EscapeXMLText(&sArea);
		sXML << "<AREA>" << sArea << "</AREA>";
	}

	// USER FIRSTNAMES
	CTDVString sFirstNames;
	if (!SP.IsNULL("FirstNames"))
	{
		SP.GetField("FirstNames",sFirstNames);
		EscapeXMLText(&sFirstNames);
		sXML << "<FIRSTNAMES>" << sFirstNames << "</FIRSTNAMES>";
	}

	// USER LASTNAME
	CTDVString sLastName;
	if (!SP.IsNULL("LastName"))
	{
		SP.GetField("LastName",sLastName);
		EscapeXMLText(&sLastName);
		sXML << "<LASTNAME>" << sLastName << "</LASTNAME>";
	}

	// USER SITESUFFIX
	CTDVString sSiteSuffix;
	if (!SP.IsNULL("SiteSuffix"))
	{
		SP.GetField("SiteSuffix",sSiteSuffix);
		EscapeXMLText(&sSiteSuffix);
		sXML << "<SITESUFFIX>" << sSiteSuffix << "</SITESUFFIX>";
	}

	// USER STATUS
	if(!SP.IsNULL("Status"))
	{
		int nStatus = SP.GetIntField("Status");
		sXML << "<STATUS>" << nStatus << "</STATUS>";
	}

	// USER TAXONOMYNODE
	if(!SP.IsNULL("TaxonomyNode"))
	{
		int nTaxonomyNode = SP.GetIntField("TaxonomyNode");
		sXML << "<TAXONOMYNODE>" << nTaxonomyNode << "</TAXONOMYNODE>";
	}

	// USER JOURNAL
	if(!SP.IsNULL("Journal"))
	{
		int nJournal = SP.GetIntField("Journal");
		sXML << "<JOURNAL>" << nJournal << "</JOURNAL>";
	}

	// ACTIVE
	if(!SP.IsNULL("Active"))
	{
		int nActive = SP.GetIntField("Active");
		sXML << "<ACTIVE>" << nActive << "</ACTIVE>";
	}

	// Groups
	CTDVString sGroups;
	if(!m_InputContext.GetUserGroups(sGroups, m_iUserID))
	{
		TDVASSERT(false, "Failed to get user groups");
	}
	else
	{
		sXML += sGroups;
	}

	sXML << "</USER>";

	// TITLE
	EscapeXMLText(&m_sTitle);
	sXML << "<TITLE>" << m_sTitle << "</TITLE>";

	// BODY
	sXML << m_sBody;

	// POSTED DATE
	sXML << "<DATEPOSTED>";
	if (m_tPostedDate != 0)
	{
		CTDVString sPostedDate;
		m_tPostedDate.GetAsXML(sPostedDate,true);
		sXML << sPostedDate;
	}
	sXML << "</DATEPOSTED>";
	
	// CLOSING DATE
	sXML << "<DATECLOSING>";
	if (m_tEventDate != 0)
	{
		CTDVString sEventDate;
		m_tEventDate.GetAsXML(sEventDate,true);
		sXML << sEventDate;
	}
	sXML << "</DATECLOSING>";

	sXML << "<THREADPOSTCOUNT>" << SP.GetIntField("ThreadPostCount") << "</THREADPOSTCOUNT>";
		

	return true;
}

/*********************************************************************************

	bool CNotice::GetNoticeFromThreadID(int iThreadID, int iForumID, CTDVString& sXML)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		ThreadID - The notice threadid to find
				iForumID - The noticeboard forum to search in
				sXML - A string to take the XML of the notice if found
	Returns:	true if found and setup ok, false if not found or some other error occures
	Purpose:	Tries to find a notice given the a threadid and forumid to look in

*********************************************************************************/

bool CNotice::GetNoticeFromThreadID(int iThreadID, int iForumID, CTDVString& sXML)
{
	// Check the ThreadID and iForumID are valid
	if (iThreadID == 0 || iForumID == 0)
	{
		TDVASSERT(false,"Invalid Thread or iForumID given : CNotice::CreateNoticeFromThreadID");
		return false;
	}

	// Now get the details for the notice from the database
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.ForumGetNoticeInfo(iForumID,iThreadID))
	{
		TDVASSERT(false,"Failed to get the thread details : CNotice::CreateNoticeFromThreadID");
		return false;
	}

	// Make sure we found something!
	if (SP.IsEOF())
	{
		TDVASSERT(false,"No Thread found for given ID : CNotice::CreateNoticeFromThreadID");
		return false;
	}

	// Check type to see if we're looking at an event or alert
	CTDVString sType;
	SP.GetField("Type",sType);
	bool bIsAnEvent = sType.CompareText("event") || sType.CompareText("alert");
	if (bIsAnEvent)
	{
		sXML << "<EVENTS><EVENT TYPE='" << sType << "'>";
	}
	else
	{
		sXML << "<NOTICES><NOTICE TYPE='" << sType << "'>";
	}

	//Create XML for the notice.
	bool bok = Initialise(SP,sXML);


	// Find vote details from the threadid and voteid
	bok = bok && GetNumberOfSupportersForNotice(m_iThreadID,m_iVoteID,m_iVisibleSupporters,m_iHiddenSupporters);
				
	// NUMBER OF SUPPORTS
	sXML << "<NOTICEVOTES>";
	if (m_iVoteID > 0)
	{
		sXML << "<VOTEID>" << m_iVoteID << "</VOTEID>";
		sXML << "<VISIBLE>" << m_iVisibleSupporters << "</VISIBLE>";
		sXML << "<HIDDEN>" << m_iHiddenSupporters << "</HIDDEN>";
	}
	sXML << "</NOTICEVOTES>";
	
	// Make sure we close with the correct
	if (bIsAnEvent)
	{
		sXML << "</EVENT></EVENTS>";
	}
	else
	{
		sXML << "</NOTICE></NOTICES>";
	}

	return bok;
}


/*********************************************************************************

	bool CNotice::GetNumberOfSupportersForNotice(int iThreadID, int& iVoteID, int &iVisible, int &iHidden)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		iThreadID - The threaid of the notice you want to find the votes for
				iVoteID - A Return value of the voteid for the thread
				iVisible - A return value of the number of visible supporters
				iHidden - A return of the number of hidden supporters
	Returns:	true if found and setup ok, false if not found or some other error occures
	Purpose:	Gets the voting information of a given thread.

*********************************************************************************/

bool CNotice::GetNumberOfSupportersForNotice(int iThreadID, int& iVoteID, int &iVisible, int &iHidden)
{
	// Now get the vote from the threadsvote table
	if (!GetVoteIDForNotice(iThreadID,iVoteID))
	{
		return SetDNALastError("CNotice::GetNumberOfSupportersForNotice","FailedToGetVoteID","Could not find voteid for notice!");
	}

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (iVoteID == 0 || !SP.GetNumberOfVotesWithResponse(iVoteID,1,iVisible,iHidden))
	{
		TDVASSERT(false, "Failed to get the votes for the thread");
		//return false; - Not a serious error.
	}
	return true;
}

/*********************************************************************************

	bool CNotice::GetNodeIDFromThreadID(int iThreadID, int iSiteID, int &iNodeID)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		iThreadID - The threaid of the notice you want to find the votes for
				iSiteID - The site id whcih the thread belongs to
				iNodeID - The return value of the nose that the thread belongs to
	Returns:	true if found and setup ok, false if not found or some other error occures
	Purpose:	Gets the NodeID for a given ThreadID

*********************************************************************************/

bool CNotice::GetNodeIDFromThreadID(int iThreadID, int iSiteID, int &iNodeID)
{
	// Check to make sure we've got a vlaid threadid to check for
	if (iThreadID <= 0)
	{
		TDVASSERT(false,"invalid thread id given!");
		return false;
	}

	// Now get the nodeid from the threadid
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetNodeIDForThreadID(iThreadID,iSiteID))
	{
		TDVASSERT(false, "Failed to get the vote for the thread!");
		return false;
	}

	// Make sure we found something
	if (!SP.IsEOF())
	{
		// Get the node id that the thread belongs to
		iNodeID = SP.GetIntField("NodeID");
	}

	return true;
}

/*********************************************************************************

	bool CNotice::GetForumDetailsForNodeID(int iNodeID, int iSiteID, int &iForumID, CTDVString* pForumName)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		iNodeID - The Node which contains the forum
				iSiteID - The site id to look in
				iForumID - The return value of the forum
				pForumName - A String which will recieve the forum name
	Returns:	true if found and setup ok, false if not found or some other error occures
	Purpose:	Gets the details for a forum on a given node.

*********************************************************************************/

bool CNotice::GetForumDetailsForNodeID(int iNodeID, int iSiteID, int &iForumID, CTDVString* pForumName)
{
	// Chekc to make sure we've got a valid nodeid
	if (iNodeID <= 0)
	{
		TDVASSERT(false,"Invalid nodeid given!");
		return false;
	}

	// Now get tje forumid for the nodeid
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetForumDetailsFromNodeID(iNodeID,iSiteID))
	{
		TDVASSERT(false,"Failed To Get ForumID for node");
		return false;
	}

	if ( SP.FieldExists("ForumID") )
	{

		iForumID = SP.GetIntField("ForumID");
		if (pForumName != NULL)
		{
			SP.GetField("Subject",*pForumName);
		}
	}

	return true;
}

/*********************************************************************************

	bool CNotice::GetLocalNoticeBoardForPostCode(CTDVString& sPostCodeToFind, int iSiteID, CTDVString &sXML, CTDVString& sPostCoderXML)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		sPostCode - The postcode to check for the notice board
				iSiteID - The Site id to look in
				sXML - A string to take the XML for the function.
	Returns:	true if found and setup ok, false if not found or some other error occures
	Purpose:	Finds a matching Postcode and then gets all the details for the noticeboard
				at that local.

*********************************************************************************/

bool CNotice::GetLocalNoticeBoardForPostCode(CTDVString& sPostCodeToFind, int iSiteID, CTDVString &sXML, CTDVString& sPostCoderXML)
{
	// Get the details for the requested postcode.
	int iTaxNode = 0;
	CTDVString sPostCode, sPostCodeXML;
	int iRes = GetDetailsForPostCodeArea(sPostCodeToFind,iSiteID,iTaxNode,sPostCode,sPostCoderXML);
	if ( iRes == CNotice::PR_POSTCODENOTFOUND)
	{
		sXML << "<NOTICEBOARD>CouldNotMatchPostCode</NOTICEBOARD>";
		return true;
	}
	else if (iRes == CNotice::PR_REQUESTTIMEOUT)
	{
		sXML << "<NOTICEBOARD>PostCodeRequestTimedOut</NOTICEBOARD>";
		return true;
	}
	
	// Check to make sure the user has already picked a post code
	if (iTaxNode == 0)
	{
		sXML << "<NOTICEBOARD>UserHasNoTaxonomyNodeDefined</NOTICEBOARD>";
		return true;
	}

	// Now get the forumid for the node
	int iForumID = 0;
	if (!GetForumDetailsForNodeID(iTaxNode,iSiteID,iForumID))
	{
		TDVASSERT(false,"Failed to get the forumid for the given node!");
		return false;
	}

	// Check the cache to see if we've already got their details!
	if (CheckAndCreateFromCachedPage(iTaxNode,iForumID,iSiteID,sXML))
	{
		// We've got a cached version!
		return true;
	}

	// Now get the Notices and events in the users local area
	sXML << "<NOTICEBOARD NODEID='" << iTaxNode << "' ISUSERSPOSTCODE='0'>";
	if (!GetNoticeBoardPosts(iForumID,iSiteID,sXML,0))
	{
		TDVASSERT(false,"Failed getting the users local notices");
		return false;
	}
	if (!GetFutureEventsForNode(iTaxNode,iForumID,iSiteID,sXML,0))
	{
		TDVASSERT(false,"Failed getting the users local events");
		return false;
	}
	sXML << "</NOTICEBOARD>";

	// Now cache the results.
	if(!CreateNewCachePage(iTaxNode,iSiteID,sXML))
	{
		TDVASSERT(false,"Failed to create a cache page!");
	}

	// Finally replace the requested postcode with the matching valid one
	sPostCodeToFind = sPostCode;

	// return ok
	return true;
}

/*********************************************************************************

	bool CNotice::GetLocalNoticeBoardForUser(CUser *pUser, int iSiteID, bool bUsersPostsOnly, CTDVString &sXML)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		pUser - A pointer to the user we're tryingto get the noticeboard for
				iSiteID - The Site id to look in
				bUsersPostsOnly - A flag to state wether to get all notices or
								  just the ones the user has created.
				sXML - A string to take the XML for the function.
	Returns:	true if found and setup ok, false if not found or some other error occures
	Purpose:	Gets the details for a forum on a given node.

*********************************************************************************/

bool CNotice::GetLocalNoticeBoardForUser(CUser *pUser, int iSiteID, bool bUsersPostsOnly, CTDVString &sXML)
{
	// Check the pointer
	if (pUser == NULL)
	{
		TDVASSERT(false,"No user given");
		return false;
	}

	// Now get the users details
	int iTaxNode = 0;
	if (!pUser->GetTaxonomyNode(&iTaxNode))
	{
		TDVASSERT(false,"Failed to get taxonomy node from user info");
		return false;
	}

	// Check to make sure the user has already picked a post code
	if (iTaxNode == 0)
	{
		sXML << "<NOTICEBOARD>UserHasNoTaxonomyNodeDefined</NOTICEBOARD>";
		return true;
	}

	// Now get the forumid for the node
	int iForumID = 0;
	if (!GetForumDetailsForNodeID(iTaxNode,iSiteID,iForumID))
	{
		TDVASSERT(false,"Failed to get the forumid for the given node!");
		return false;
	}

	// Check to make sure the user has already picked a post code
	if ( iForumID == 0 )
	{
		sXML << "<NOTICEBOARD>UserHasNoNoticeboardForThisSite</NOTICEBOARD>";
		return true;
	}

	// Check the cache to see if we've already got their details!
	if (!bUsersPostsOnly && CheckAndCreateFromCachedPage(iTaxNode,iForumID,iSiteID,sXML))
	{
		// We've got a cached version!
		return true;
	}

	// Now get the Notices and events in the users local area
	sXML << "<NOTICEBOARD NODEID='" << iTaxNode << "' ISUSERSPOSTCODE='1'>";
	if (!GetNoticeBoardPosts(iForumID,iSiteID,sXML,bUsersPostsOnly ? pUser->GetUserID() : 0))
	{
		TDVASSERT(false,"Failed getting the users local notices");
		return false;
	}
	if (!GetFutureEventsForNode(iTaxNode,iForumID,iSiteID,sXML,bUsersPostsOnly ? pUser->GetUserID() : 0))
	{
		TDVASSERT(false,"Failed getting the users local events");
		return false;
	}
	sXML << "</NOTICEBOARD>";

	// Now cache the results.
	if(!bUsersPostsOnly && !CreateNewCachePage(iTaxNode,iSiteID,sXML))
	{
		TDVASSERT(false,"Failed to create a cache page!");
	}

	// return ok
	return true;
}

/*********************************************************************************

	bool CNotice::GetAllNoticesForNodeID(int iNodeID, int iSiteID, CTDVString &sXML, int iPostForUserID)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		iNodeID - The node to get the noticeboard details for.
				iSiteID - The Site id to look in
				sXML - A string to take the XML for the function.
				iPostForUserID - A user ID which is used to get all notices for that user only
	Returns:	true if found and setup ok, false if not found or some other error occures
	Purpose:	Gets All the notices for a given node id

*********************************************************************************/

bool CNotice::GetNoticeBoardPosts( int iForumID, int iSiteID, CTDVString &sXML, int iPostForUserID)
{

	// Check to make sure we've got a valid forum id
	if (iForumID <= 0)
	{
		TDVASSERT(false,"Invalid forumid given!");
		return false;
	}

	// Now get all the threads for this forum
	// Now get all the threads for this notice board
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.ForumGetNoticeBoardPosts(iForumID) || iForumID <= 0)
	{
		// This is ok, it just means no one has posted a notice yet!
		return true;
	}

	CTDVString sNotices;
	InitialiseXMLBuilder(&sNotices, &SP);
	bool bSuccess = OpenXMLTag("NOTICES");

	// Go through the list adding them to the xml
	CTDVString sType;
	int iUserID = 0;
	int iThreadID = 0;
	int iPostID = 0;
	CTDVString sUsersPostCode;
	CTDVString sUserName;
	CTDVString sPostedDate;
	CTDVString sEventDate;
	CTDVDateTime tPostedDate;
	CTDVDateTime tEventDate;
	CTDVString sTitle;
	CTDVString sBody;
	CTDVString sTaxNodeName;
	int iUserTaxNode = 0;
	int iNoOfSupporters = 0;
	bool bDoInclude = true;

	int iNoOfThreads = SP.GetIntField("ThreadCount");

	while (iNoOfThreads > 0 && !SP.IsEOF())
	{
		// Get the details for the current notice.
		SP.GetField("Type",sType);

		// USERID
		iUserID = SP.GetIntField("UserID");

		// Check to see if we're just getting the notices that the user has posted.
		bDoInclude = true;
		if (iPostForUserID > 0)
		{
			bDoInclude = (iUserID == iPostForUserID);
		}

		// Only insert threads of known types!
		if (!sType.IsEmpty() && bDoInclude)
		{
			bSuccess = bSuccess && OpenXMLTag("NOTICE",true);
			bSuccess = bSuccess && AddXMLAttribute("TYPE",sType,true);

			bSuccess = bSuccess && AddDBXMLIntTag("ForumID");
			bSuccess = bSuccess && AddDBXMLIntTag("ThreadID",NULL,true,&iThreadID);
			bSuccess = bSuccess && AddDBXMLIntTag("EntryID","POSTID");

			bSuccess = bSuccess && OpenXMLTag("USER");
			bSuccess = bSuccess && AddXMLIntTag("USERID",iUserID);
			bSuccess = bSuccess && AddDBXMLTag("UserName");
			bSuccess = bSuccess && AddDBXMLTag("TaxonomyNode","USERTAXNODE",false);
			bSuccess = bSuccess && AddDBXMLTag("DisplayName","TAXNODENAME",false);
			bSuccess = bSuccess && AddDBXMLTag("Title",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("Area",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("FirstNames",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("LastName",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("SiteSuffix",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("Status",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("Journal",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("Active",NULL,false);

			// Groups
			CTDVString sGroups;
			if(!m_InputContext.GetUserGroups(sGroups, iUserID))
			{
				TDVASSERT(false, "Failed to get user groups");
			}
			else
			{
				sNotices += sGroups;
			}

			bSuccess = bSuccess && CloseXMLTag("USER");

			bSuccess = bSuccess && AddDBXMLTag("Subject","TITLE");
			bSuccess = bSuccess && AddDBXMLTag("Text","",true,false);
			bSuccess = bSuccess && AddDBXMLDateTag("DatePosted",NULL,true,true);
			bSuccess = bSuccess && AddDBXMLDateTag("EventDate","DATECLOSING",false,true);
			bSuccess = bSuccess && AddDBXMLIntTag("ThreadPostCount");

			if (sType.CompareText("notice"))
			{
				// NUMBER OF SUPPORTS
				bSuccess = bSuccess && OpenXMLTag("NOTICEVOTES");
				int iVisible = 0;
				int iHidden = 0;
				int iVoteID = 0;
				if (GetNumberOfSupportersForNotice(iThreadID,iVoteID,iVisible,iHidden) && iVoteID > 0)
				{
					bSuccess = bSuccess && AddXMLIntTag("VOTEID",iVoteID);
					bSuccess = bSuccess && AddXMLIntTag("VISIBLE",iVisible);
					bSuccess = bSuccess && AddXMLIntTag("HIDDEN",iHidden);
				}
				bSuccess = bSuccess && CloseXMLTag("NOTICEVOTES");

				// Add poll-list xml
				CPolls polls(m_InputContext);
				if(!polls.MakePollList(iThreadID, CPoll::ITEMTYPE_NOTICE))
				{
					TDVASSERT(false, "CNotice::GetAllNoticesForNodeID() MakePollList failed");
				}
				else
				{
					CTDVString sPollListXML;
					if(!polls.GetAsString(sPollListXML))
					{
						TDVASSERT(false, "CNoticeBoardBuilder::Build() polls.GetAsString failed");
					}

					sNotices += sPollListXML;
				}

			}

			bSuccess = bSuccess && CloseXMLTag("NOTICE");

			// Check to see if we had problems getting the info from the database
			if (!bSuccess)
			{
				TDVASSERT(false,"Problems getting Event information from database!");
			}
		}

		// Get the next thread
		SP.MoveNext();
	}
	
	CloseXMLTag("NOTICES");

	// If everything is ok, then return the results
	sXML << sNotices;
	return true;
}

/*********************************************************************************

	bool CNotice::GetFutureEventsForNode(int iNodeID, int iSiteID, CTDVString &sXML, int iPostForUserID)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		iNodeID - The node to get the noticeboard details for.
				iSiteID - The Site id to look in
				sXML - A string to take the XML for the function.
				iPostForUserID - A user ID which is used to get all notices for that user only
	Returns:	true if found and setup ok, false if not found or some other error occures
	Purpose:	Gets All the future events for a given node

*********************************************************************************/

bool CNotice::GetFutureEventsForNode(int iNodeID, int iForumID, int iSiteID, CTDVString &sXML, int iPostForUserID)
{
	// Check to make sure we've got a valid node id
	if (iNodeID <= 0)
	{
		TDVASSERT(false,"Invalid nodeid given!");
		return false;
	}

	// Check to make sure we've got a valid forum id
	if (iForumID <= 0)
	{
		TDVASSERT(false,"Invalid forumid given!");
		return false;
	}

	// Now get all the threads for this forum
	// Now get all the threads for this notice board
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.GetAllEventsInTheNextNumberOfDays(iForumID))
	{
		TDVASSERT(false,"Failed to get the events list!");
		return false;			
	}

	// Go through the list adding them to the xml
	CTDVString sType;
	int iUserID = 0;
	int iThreadID = 0;
	int iPostID = 0;
	CTDVString sUserName;
	CTDVString sUsersPostCode;
	CTDVDateTime tPostedDate;
	CTDVDateTime tEventDate;
	CTDVString sTitle;
	CTDVString sBody;
	CTDVString sTaxNodeName;
	int iUserTaxNode = 0;
	bool bDoInclude = true;

	InitialiseXMLBuilder(&sXML, &SP);
	bool bSuccess = OpenXMLTag("EVENTS");

	// Go through all the results putting them into the XML
	while (!SP.IsEOF() && bSuccess)
	{
		// USERID
		iUserID = SP.GetIntField("UserID");

		bDoInclude = true;
		if (iPostForUserID > 0)
		{
			bDoInclude = (iUserID == iPostForUserID);
		}

		// Get the details for the current notice.
		SP.GetField("Type",sType);

		// Only insert threads of known types!
		if (!sType.IsEmpty() && (sType.CompareText("event") || sType.CompareText("alert")) && bDoInclude)
		{
			// Setup the event XML
			bSuccess = bSuccess && OpenXMLTag("EVENT",true);
			bSuccess = bSuccess && AddXMLAttribute("TYPE",sType,true);
			bSuccess = bSuccess && AddDBXMLIntTag("ThreadID");
			bSuccess = bSuccess && AddDBXMLIntTag("EntryID","POSTID");

			// Setup the User Details
			bSuccess = bSuccess && OpenXMLTag("USER");
			bSuccess = bSuccess && AddXMLIntTag("USERID",iUserID);
			bSuccess = bSuccess && AddDBXMLTag("UserName");
			
			// Both are needed for consistency. If possible depricate USERTAXNODE
			bSuccess = bSuccess && AddDBXMLTag("TaxonomyNode","USERTAXNODE",false);
			bSuccess = bSuccess && AddDBXMLTag("TaxonomyNode",NULL,false);

			bSuccess = bSuccess && AddDBXMLTag("DisplayName","TAXNODENAME",false);
			bSuccess = bSuccess && AddDBXMLTag("Title",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("Area",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("FirstNames",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("LastName",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("SiteSuffix",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("Status",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("Journal",NULL,false);
			bSuccess = bSuccess && AddDBXMLTag("Active",NULL,false);

			// Get user groups
			CTDVString sGroups;
			if(!m_InputContext.GetUserGroups(sGroups, iUserID))
			{
				TDVASSERT(false, "Failed to get user groups");
			}
			else
			{
				sXML += sGroups;
			}

			bSuccess = bSuccess && CloseXMLTag("USER");
			bSuccess = bSuccess && AddDBXMLTag("Subject","TITLE");
			bSuccess = bSuccess && AddDBXMLTag("Text","",false,false);
			bSuccess = bSuccess && AddDBXMLDateTag("DatePosted",NULL,true,true);
			bSuccess = bSuccess && AddDBXMLDateTag("EventDate","DATECLOSING",false,true);
			bSuccess = bSuccess && CloseXMLTag("EVENT");
		}

		// Get the next thread
		SP.MoveNext();
	}

	// If everything is ok, then return the results
	bSuccess && CloseXMLTag("EVENTS");

	// Check to see if we had problems getting the info from the database
	TDVASSERT(bSuccess,"Problems getting Event information from database!");
	return bSuccess;
}

/*********************************************************************************

	bool CNotice::GetDetailsForPostCodeArea(CTDVString &sPlace, int iSiteID,
						int& iNodeID, CTDVString& sPostCode, CTDVString& sPostCodeXML)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		sPlace - The postcode to check for.
				iSiteID - The Site id to look in
				iNodeID - The return value for the found node associated with the postcode.
				sPostCode - The real postcode for the matching search.
				sPostCodeXML - The XML returned back for the successful postcode search.
	Returns:	true if found and setup ok, false if not found or some other error occures
	Purpose:	Gets the local info details for a given postcode.

*********************************************************************************/

int CNotice::GetDetailsForPostCodeArea(CTDVString &sPlace, int iSiteID, int& iNodeID, CTDVString& sPostCode, CTDVString& sPostCodeXML)
{
	int iReturn = PR_REQUESTOK;
	// Create a new postcoder object
	CPostcoder Postcoder(m_InputContext);
	bool bGotPostcode = false;

	// Check to make sure we've been given a valid postcode to find
	if (sPlace.GetLength() > 0)
	{
		// Try to get a place request for the code
		bool bRequestOk = Postcoder.MakePlaceRequest(sPlace, bGotPostcode);
		if (bRequestOk) 
		{
			if (bGotPostcode) 
			{
				// We got a valid postcode, now get the details for it
				CTDVString sAuthID,sArea;
				bGotPostcode = Postcoder.PlaceHitPostcode(sPostCode, sAuthID, sArea, iNodeID);

				// If we got the postcode match the get the XML for the postcode.
				if (bGotPostcode)
				{
					bGotPostcode = Postcoder.GetAsString(sPostCodeXML);
				}
			}
			else
			{
				iReturn = PR_POSTCODENOTFOUND;
			}
		}
		else
		{
			iReturn = PR_REQUESTTIMEOUT;
		}
		
	}

	//TDVASSERT(bGotPostcode, "Could not match given postcode!");
	return iReturn;
}

/*********************************************************************************

	bool CNotice::CheckAndCreateFromCachedPage(int iNodeID, int iForumID,
						int iSiteID, CTDVString& sXML)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		iNodeID - the node that you want to check the cache for
				iForumID - The forum ID for the cache.
				iSiteID - The Site id to look in
				sXML - a return string which will hold the cached XML
	Returns:	true if found and setup ok, false if not found or some other error occures
	Purpose:	Checks to see if there is a cached version of the noticeboard and
				that it's upto date and then returns the XML for it.

*********************************************************************************/

bool CNotice::CheckAndCreateFromCachedPage(int iNodeID, int iForumID, int iSiteID, CTDVString& sXML)
{
	// Check to see if we can use the cache!
	CTDVString sCacheName = "NB";
	sCacheName << iNodeID << "-" << iSiteID << ".txt";

	// Get the most recent dates for the threads
	CTDVDateTime dLastDate;
	CTDVString sPosts;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.CacheGetMostRecentThreadDate(iForumID, &dLastDate))
	{
		TDVASSERT(false,"Stored Procedure CacheGetMostRecentThreadDate Failed!");
		return false;
	}
	SP.Release();

	// Now check to see if we the dates are newer and set the gotcache flag.
	bool bGotCache = false;
	bGotCache = CacheGetItem("NoticeBoards", sCacheName, &dLastDate, &sPosts);

	// If we got a cached version, use it
	if (bGotCache)
	{
		bGotCache = CreateFromXMLText(sPosts);
		TDVASSERT(bGotCache,"CNotice::Failed to Create XML From text!");
		if (bGotCache)
		{
			bGotCache = UpdateRelativeDates();
			TDVASSERT(bGotCache,"CNotice::Failed to Update relative dates!");
			bGotCache = GetAsString(sXML);
		}
	}

	return bGotCache;
}

/*********************************************************************************

	bool CNotice::CreateNewCachePage(int iNodeID, int iSiteID, CTDVString &sXML)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		iNodeID - the node that you want to create the cache for
				iForumID - The forum ID for the cache.
				iSiteID - The Site id to look in
				sXML - a return string which will hold the cached XML
	Returns:	true if found and setup ok, false if not found or some other error occures
	Purpose:	Checks to see if there is a cached version of the noticeboard and
				that it's upto date and then returns the XML for it.

*********************************************************************************/

bool CNotice::CreateNewCachePage(int iNodeID, int iSiteID, CTDVString &sXML)
{
	CTDVString sCacheName = "NB";
	sCacheName << iNodeID << "-" << iSiteID << ".txt";

	Destroy();
	bool bOk = CreateFromXMLText(sXML);
	if (bOk)
	{
		CTDVString StringToCache;
		bOk = GetAsString(StringToCache);
		if (bOk)
		{
			bOk = CachePutItem("NoticeBoards", sCacheName, StringToCache);
		}
	}
	return bOk;
}


/*********************************************************************************

	bool CNotice::GetNoticeBoardForNode(int iNodeID, int iSiteID, bool bIncludeNotices)

	Author:		Mark Howitt
	Created:	03/12/2003
	Inputs:		iNodeID - the node for the noticeboard you want to get
				iSIteID - the site on which the node lives
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Gets the noticeboard given a taxonomy nodeid.

*********************************************************************************/

bool CNotice::GetNoticeBoardForNode(int iNodeID, int iSiteID, bool bIncludeNotices)
{
	// Check the variables
	if (iNodeID == 0 || iSiteID == 0)
	{
		TDVASSERT(false,"No Node or Site ID Given!");
		return false;
	}

	// Now get the forumid for the node
	int iForumID = 0;
	if (!GetForumDetailsForNodeID(iNodeID,iSiteID,iForumID))
	{
		TDVASSERT(false,"Failed to get the forumid for the given node!");
		return false;
	}

	// Now get the Notices and events in the users local area
	CTDVString sXML;
	sXML << "<NOTICEBOARD NODEID='" << iNodeID << "'>";

	if (bIncludeNotices)
	{
		if (!GetNoticeBoardPosts(iForumID,iSiteID,sXML,false))
		{
			TDVASSERT(false,"Failed getting the users local notices");
			return false;
		}
		if (!GetFutureEventsForNode(iNodeID,iForumID,iSiteID,sXML,false))
		{
			TDVASSERT(false,"Failed getting the users local events");
			return false;
		}
	}
	sXML << "</NOTICEBOARD>";

	// Now create the XML Tree, making sure we delete any previous trees.
	Destroy();
	return CreateFromXMLText(sXML);
}

/*********************************************************************************

	bool CNotice::GetVoteIDForNotice(int iThreadID, int &iVoteID)

	Author:		Mark Howitt
	Created:	06/01/2004
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CNotice::GetVoteIDForNotice(int iThreadID, int &iVoteID)
{
	// Check to make sure we've gotr a vaslid threadid
	if (iThreadID <= 0)
	{
		TDVASSERT(false,"invalid thread id given for finding the thread vote");
		return false;
	}

	// Now get the vote from the threadsvote table
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetVoteIDForThreadID(iThreadID))
	{
		TDVASSERT(false, "Failed to get the vote for the thread!");
		return false;
	}

	// Check to make sure we got something back
	if (!SP.IsEOF())
	{
		iVoteID = SP.GetIntField("VoteID");
	}

	return true;
}
