// CurrentClubs.cpp: implementation of the CCurrentClubs class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "CurrentClubs.h"
#include "Club.h"
#include "User.h"
#include "tdvassert.h"
#include "StoredProcedure.h"
#include "xmlstringutils.h"
#include <algorithm>
//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CCurrentClubs::CCurrentClubs(CInputContext& inputContext) : CXMLObject(inputContext)
{

}

CCurrentClubs::~CCurrentClubs()
{

}

/*********************************************************************************

	bool CCurrentClubs::CreateList(CUser* pViewingUser, bool bSummaryOnly)

		Author:		Mark Howitt
        Created:	22/07/2004
        Inputs:		iUserID - The id of the user you want to get the info for.
					bSummaryOnly - If this is set, then only the bare minimum
						is returned. This is mainly used for adding info to other pages.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Returns a list of all the clubs that the user either owns or
					belongs to. Also included in the info is the clubs activity,
					new members, total members, actions and users roles.

*********************************************************************************/
bool CCurrentClubs::CreateList(int iUserID, bool bSummaryOnly)
{
	// Create a User Object from the given userid
	CUser ViewingUser(m_InputContext);
	if (!ViewingUser.CreateFromID(iUserID))
	{
		return SetDNALastError("CCurrentClubs::CreateList","FailedToCreateUserFromUserID","Failed to create user from userid!");
	}
	
	// Now call the main function with the user object
	return CreateList(&ViewingUser,bSummaryOnly);
}


/*********************************************************************************

	bool CCurrentClubs::CreateList(CUser* pViewingUser, bool bSummaryOnly)

		Author:		Mark Howitt
        Created:	22/07/2004
        Inputs:		pViewingUser - A pointer to the veiwing user that you want
						to get the club info for.
					bSummaryOnly - If this is set, then only the bare minimum
						is returned. This is mainly used for adding info to other pages.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Returns a list of all the clubs that the user either owns or
					belongs to. Also included in the info is the clubs activity,
					new members, total members, actions and users roles.

*********************************************************************************/
bool CCurrentClubs::CreateList(CUser* pViewingUser, bool bSummaryOnly)
{
	// Check to make sure we've been given a valid user!
	if (pViewingUser == NULL)
	{
		// No worries! just return ok
		CreateFromXMLText("<USERMYCLUBS>UserNotLoggedIn</USERMYCLUBS>");
		return true;
	}

	// Now find out what clubs the user belongs to.
	CStoredProcedure SP;
	bool bOk = m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!bOk || !SP.GetAllClubsThatUserBelongsTo(pViewingUser->GetUserID()))
	{
		return SetDNALastError("CCurrentClubs::CreateList","FailedToGetAllClubs","Failed getting all the users clubs");
	}

	// Seup the base xml string
	int iClubID = 0;
	bool bHideName = false;
	CTDVString sXML = "<USERMYCLUBS>";

	// See if we want a summary only?
	if (bSummaryOnly)
	{
		// Initialise the XML Builder
		InitialiseXMLBuilder(&sXML,&SP);
		bOk = OpenXMLTag("CLUBSSUMMARY");
		while (bOk && !SP.IsEOF())
		{
			// Put the basic info for each club into the xml
			bOk = bOk && OpenXMLTag("CLUB",true);
			bOk = bOk && AddDBXMLIntAttribute("CLUBID","ID",true,true,&iClubID);

			// Check to see if we are required to hide the name of hidden clubs?
			bHideName = SP.GetIntField("HIDDEN") > 0;
			bHideName = bHideName && !pViewingUser->HasSpecialEditPermissions(SP.GetIntField("h2g2id"));
			if (bHideName)
			{
				CClub CurrentClub(m_InputContext);
				bHideName = bHideName && !CurrentClub.CanUserEditClub(pViewingUser->GetUserID(),iClubID);
			}

			// Are we hidding or not?
			if (bHideName)
			{
				bOk = bOk && AddXMLTag("NAME","Hidden");
			}
			else
			{
				bOk = bOk && AddDBXMLTag("NAME");
			}

			bOk = bOk && AddDBXMLIntTag("SITEID");

			//Add standard Article status description to XML
			CTDVString sArticleStatusXML;
			bOk = bOk && CXMLStringUtils::AppendStatusTag(SP.GetIntField("ARTICLESTATUS"),sArticleStatusXML);
			bOk = bOk && AddXMLTag("ARTICLEINFO",sArticleStatusXML);

			bOk = bOk && AddDBXMLDateTag("DATECREATED",NULL,true,true);
			if (SP.GetIntField("OWNER") > 0)
			{
				bOk = bOk && AddXMLTag("MEMBERSHIPSTATUS","Owner");
			}
			else
			{
				bOk = bOk && AddXMLTag("MEMBERSHIPSTATUS","Supporter");
			}
			bOk = bOk && AddDBXMLIntTag("MEMBERSHIPCOUNT");
			bOk = bOk && AddDBXMLTag("EXTRAINFO","",false,false);
			bOk = bOk && AddDBXMLDateTag("LASTUPDATED",NULL,false,true);
			bOk = bOk && CloseXMLTag("CLUB");
			SP.MoveNext();
		}

		// Finally close the tag
		bOk = bOk && CloseXMLTag("CLUBSSUMMARY");
	}
	else
	{
		// Setup two string to hold the summary and review xml
		CTDVString sSummaryInfo = "<CLUBSSUMMARY>";
		CTDVString sReviewInfo = "<CLUBREVIEWS>";

		// Now setup the local variable required
		CClub CurrentClub(m_InputContext);
		int iForumID = 0;
		CTDVString sClubName;
		CTDVString sNewMembers;
		CTDVString sAllMembers;
		CTDVString sUsersStatus;
		CTDVString sUsersRole;
		int iTotalPosts = 0;
		int iNewPosts = 0;
		int iNewMembers = 0;
		int iPending = 0;
		int iCompleted = 0;
		bool bIsActive = 0;

		// Go through the results
		while (bOk && !SP.IsEOF())
		{	
			// Start by filling in the review XML
			InitialiseXMLBuilder(&sReviewInfo,&SP);
			bOk = bOk && OpenXMLTag("CLUB",true);
			bOk = bOk && AddDBXMLIntAttribute("CLUBID","ID",true,true,&iClubID);

			// Check to see if we are required to hide the name of hidden clubs?
			bHideName = SP.GetIntField("HIDDEN") > 0;
			bHideName = bHideName && !pViewingUser->HasSpecialEditPermissions(SP.GetIntField("h2g2id"));
			if (bHideName)
			{
				CurrentClub.InitialiseViaClubID(iClubID);
				bHideName = bHideName && !CurrentClub.CanUserEditClub(pViewingUser->GetUserID(),iClubID);
			}

			// Are we hidding or not?
			if (bHideName)
			{
				sClubName = "Hidden";
				bOk = bOk && AddXMLTag("NAME",sClubName);
			}
			else
			{
				bOk = bOk && AddDBXMLTag("NAME",NULL,true,true,&sClubName);
			}

			CTDVString sArticleStatusXML;
			bOk = bOk && CXMLStringUtils::AppendStatusTag(SP.GetIntField("ArticleStatus"),sArticleStatusXML);
			bOk = bOk && AddXMLTag("ARTICLEINFO",sArticleStatusXML);

			bOk = bOk && AddDBXMLIntTag("SITEID");
			bOk = bOk && AddDBXMLDateTag("DATECREATED",NULL,true,true);
			bOk = bOk && AddDBXMLDateTag("LASTUPDATED",NULL,false,true);

			// Now get the current users role and status within the club
			bOk = bOk && AddDBXMLTag("ROLE","CURRENTROLE",false);
			if (SP.GetIntField("OWNER") > 0)
			{
				bOk = bOk && AddXMLTag("MEMBERSHIPSTATUS","Owner");
			}
			else
			{
				bOk = bOk && AddXMLTag("MEMBERSHIPSTATUS","Supporter");
			}

			// Get all the member info
			bOk = bOk && OpenXMLTag("MEMBERS");
			bOk = bOk && AddDBXMLIntTag("MEMBERSHIPCOUNT","ALL");
			bOk = bOk && AddDBXMLIntTag("NEWMEMBERSCOUNT","NEW",true,&iNewMembers);
			bOk = bOk && CloseXMLTag("MEMBERS");

			// Now get the PostInfo
			iForumID = SP.GetIntField("ClubForum");
			bOk = bOk && CurrentClub.GetAllPostsForClubForum(iForumID,sReviewInfo,iTotalPosts,iNewPosts);
			bOk = bOk && OpenXMLTag("COMMENTS");
			bOk = bOk && AddXMLIntTag("NEW",iNewPosts);
			bOk = bOk && AddXMLIntTag("ALL",iTotalPosts);
			bOk = bOk && CloseXMLTag("COMMENTS");
			bOk = bOk && AddDBXMLTag("EXTRAINFO","",false,false);

			// Add all the pending and completed actions
			bOk = bOk && CurrentClub.GetAllPendingAndCompletedActionsForClub(iClubID,sReviewInfo,iPending,iCompleted);
			bOk = bOk && CloseXMLTag("CLUB");

			// Now do the summary part of the job
			InitialiseXMLBuilder(&sSummaryInfo,&SP);
			bOk = bOk && OpenXMLTag("CLUB",true);
			bOk = bOk && AddXMLIntAttribute("ID",iClubID,true);
			bOk = bOk && AddXMLTag("NAME",sClubName);
			bIsActive = (iPending > 0 || iNewPosts > 0 || iNewMembers > 0);
			bOk = bOk && AddXMLIntTag("ACTIVITY",bIsActive);
			bOk = bOk && AddDBXMLIntTag("SITEID");
			bOk = bOk && AddDBXMLTag("EXTRAINFO","",false,false);
			bOk = bOk && CloseXMLTag("CLUB");

			// Get the next entry
			SP.MoveNext();
		}

		sSummaryInfo << "</CLUBSSUMMARY>";
		sReviewInfo << "</CLUBREVIEWS>";

		// Insert the summary and review xml for all the clubs
		sXML << sSummaryInfo << sReviewInfo;
	}

	// Close the base xml and add it into the page tree
	sXML << "</USERMYCLUBS>";
	if (!bOk || !CreateFromXMLText(sXML))
	{
		return SetDNALastError("CCurrentClubs::CreateList","FailedCreatingXML","Failed to create the XML");
	}

	// If we're here, everything went ok!
	return true;
}

bool CCurrentClubs::VerifyUsersClubMembership(CUser* pViewingUser, const CTDVString sClubList, std::vector<int>& usersJoinedClubs)
{
	bool bResult = true;
	std::vector<int> clubList;

	CTDVString temp = sClubList;
	temp.Replace("G", "");
	CXMLStringUtils::SplitCsvIntoInts(temp, clubList);

	CStoredProcedure SP;
	bool bOk = m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!bOk || !SP.GetAllClubsThatUserBelongsTo(pViewingUser->GetUserID()))
	{
		return SetDNALastError("CCurrentClubs::VerifyUsersClubMembership","FailedToGetAllClubs","Failed getting all the users clubs");
	}

	while (bOk && !SP.IsEOF()) 
	{
		int clubID = SP.GetIntField("ClubID");
		std::vector<int>::iterator it =  std::find(clubList.begin(), clubList.end(), clubID);
		if (it != clubList.end()) 
		{
			usersJoinedClubs.push_back(clubID);
		}

		SP.MoveNext();
	}

	return bResult;
}