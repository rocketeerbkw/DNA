// Vote.cpp: implementation of the CVote class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "Vote.h"
#include "TDVAssert.h"
#include "VotePageBuilder.h"
#include "StoredProcedure.h"
#include "Notice.h"


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CVote::CVote(CInputContext& inputContext):
CXMLObject(inputContext),
m_iVoteID(0),
m_sVoteName(""),
m_iType(0),
m_dCreatedDate(NULL),
m_dClosingDate(NULL),
m_bIsYesNoVoting(true),
m_iOwnerID(0)
{
}

CVote::~CVote()
{
}


/*********************************************************************************

	void CVote::ClearVote()

	Author:		Mark Howitt
	Created:	05/09/2003
	Inputs:		
	Outputs:	
	Returns:	
	Purpose:	Clears the votes data

*********************************************************************************/

void CVote::ClearVote()
{
	m_iVoteID = 0;
	m_sVoteName.Empty();
	m_iType = 0;
	m_dCreatedDate = NULL;
	m_dClosingDate = NULL;
	m_bIsYesNoVoting = true;
	m_iOwnerID = 0;
}

/*********************************************************************************

	void CVote::ResetVote()

	Author:		Mark Howitt
	Created:	05/09/2003
	Inputs:		
	Outputs:	
	Returns:	
	Purpose:	Resets the vote object and also changes to Database pointer if required.

*********************************************************************************/

void CVote::ResetVote()
{
	ClearVote();
}

/*********************************************************************************

	int CVote::CreateVote(int iType, CTDVDateTime &dClosingDate, int iOwnerID, bool bUseYesNoVoting)

	Author:		Mark Howitt
	Created:	05/09/2003
	Inputs:		sName - The name of the new vote.
				iType - The type of the vote. This defines if it lives on a club, article ..
				dClosingDate - The date at which the voting stops. Can be NULL which means no closing date
				bUseYesNoVoting - This flag determines if your using simple Yes No voting.
				iOwnerId - The owner of the vote. This is OnwerMembers form Clubs for club votes!
	Outputs:	
	Returns:	The new VoteID for the created vote. 0 if the creation failed!
	Purpose:	Gets the pending and completed actions for a given club and returns the xml
				to be inserted into the tree.

*********************************************************************************/

int CVote::CreateVote(int iType, CTDVDateTime &dClosingDate, int iOwnerID, bool bUseYesNoVoting)
{
	// Ensure the vote is clear before we start
	ClearVote();

	// Now create the vote with the given info
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.CreateNewVote(m_iVoteID,iType,dClosingDate,bUseYesNoVoting,iOwnerID))
	{
		TDVASSERT(false, "No stored procedure created");
		return 0;
	}

	// Setup the member variables from the stored procedure results.
	m_iVoteID = SP.GetIntField("VoteID");
	m_iType = iType;
	m_dCreatedDate = SP.GetDateField("DateCreated");
	m_dClosingDate = dClosingDate;
	m_bIsYesNoVoting = bUseYesNoVoting;
	m_iOwnerID = iOwnerID;

	// Return the unique vote id
	return m_iVoteID;
}

/*********************************************************************************

	bool CVote::GetVote(int iVoteID)

	Author:		Mark Howitt
	Created:	05/09/2003
	Inputs:		iVoteID - The ID of the vote you want to get the details for.
	Outputs:	
	Returns:	true if details found. false if something failed
	Purpose:	Gets and Populates the Vote given a VoteID

*********************************************************************************/

bool CVote::GetVote(int iVoteID)
{
	// Make sure the vote id is valid
	if (iVoteID <= 0)
	{
		return false;
	}

	// Now call the stored procedure
	bool bSuccess = false;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetVoteDetails(iVoteID,bSuccess))
	{
		TDVASSERT(false, "No stored procedure created");
		return false;
	}

	if (!bSuccess)
	{
		TDVASSERT(false, "GetVote() - VoteID was invalid!");
		return false;
	}

	// Clear the vote and setup from the result set
	ClearVote();
	m_iVoteID = SP.GetIntField("VoteID");
	SP.GetField("VoteName",m_sVoteName);
	m_iType = SP.GetIntField("Type");
	m_dCreatedDate = SP.GetDateField("DateCreated");
	m_dClosingDate = SP.GetDateField("ClosingDate");
	m_bIsYesNoVoting = SP.GetIntField("YesNoVoting") > 0 ? true : false;
	m_iOwnerID = SP.GetIntField("OwnerID");

	return true;
}

/*********************************************************************************

	bool CVote::GetAllUsersWithResponse(int iVoteID, int iResponse)

		Author:		Mark Howitt
        Created:	20/05/2004
        Inputs:		iVoteID - The ID of the vote you want to get the users for.
					iResponse - The Response to match for.
        Outputs:	
        Returns:	true if ok, false if not
        Purpose:	Gets all the users who have voted on a given vote with a given response.

*********************************************************************************/
bool CVote::GetAllUsersWithResponse(int iVoteID, int iResponse)
{
	// Get all the current users who have already voted with the same result
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetAllVotingUsersWithReponse(iVoteID,iResponse,m_InputContext.GetSiteID()))
	{
		return SetDNALastError("CVote","FailedGettingUsersForVote","Failed to get the users alreay voted");
	}

	// Setup some local variables
	CTDVString sVisibleUsers;
	int iHiddenUsers = 0;
	int iVisibleUsers = 0;
	bool bOk = true;

	// Go through the results adding the data to the XML
	while (bOk && !SP.IsEOF())
	{
		// Get the user ID
		int iUserID = SP.GetIntField("UserID");
		if (iUserID == 0)
		{
			// We've got a anonymous user! These are always hidden!
			iHiddenUsers++;
		}
		else
		{
			// Check to see if the user wanted to be hidden
			if (SP.GetIntField("Visible") > 0)
			{
				// Enter the users details
				InitialiseXMLBuilder(&sVisibleUsers, &SP);
				bOk = bOk && OpenXMLTag("USER");
				bOk = bOk && AddDBXMLIntTag("USERID");
				bOk = bOk && AddDBXMLTag("USERNAME");
				bOk = bOk && AddDBXMLTag("TITLE",NULL,false);
				bOk = bOk && AddDBXMLTag("FIRSTNAMES",NULL,false);
				bOk = bOk && AddDBXMLTag("LASTNAME",NULL,false);
				bOk = bOk && AddDBXMLTag("SITESUFFIX",NULL,false);
				bOk = bOk && AddDBXMLTag("AREA",NULL,false);
				
				bOk = bOk && AddDBXMLIntTag("STATUS", NULL, false);
				bOk = bOk && AddDBXMLIntTag("TAXONOMYNODE", NULL, false);
				bOk = bOk && AddDBXMLIntTag("ACTIVE");
				bOk = bOk && AddDBXMLIntTag("JOURNAL", NULL, false);

				//get the groups to which this user belongs to 		
				CTDVString sGroupXML;		
				bOk = bOk && m_InputContext.GetUserGroups(sGroupXML, iUserID);
				sVisibleUsers = sVisibleUsers + sGroupXML;

				bOk = bOk && CloseXMLTag("USER");
				TDVASSERT(bOk,"CVote::GetAllUsersWithResponse - Problems getting visible user details!");
				iVisibleUsers++;
			}
			else
			{
				// Hidden user, just increment the count
				iHiddenUsers++;
			}
		}

		// Check to see if we're ok
		if (!bOk)
		{
			return SetDNALastError("CVote","FailedGettingVotingUsers","Failed to get the current voting users");
		}

		// Get the next entry
		SP.MoveNext();
	}

	if (bOk)
	{
		// Add the hidden users
		// Initialise the XML Builder
		CTDVString sXML;
		InitialiseXMLBuilder(&sXML);
		bOk = OpenXMLTag("VotingUsers", true);
		bOk = bOk && AddXMLIntAttribute("response", iResponse, true);
		bOk = bOk && OpenXMLTag("VisibleUsers",true);
		bOk = bOk && AddXMLIntAttribute("Count",iVisibleUsers,true);
		bOk = bOk && AddXMLTag("",sVisibleUsers);
		bOk = bOk && CloseXMLTag("VisibleUsers");
		bOk = bOk && OpenXMLTag("HiddenUsers",true);
		bOk = bOk && AddXMLIntAttribute("Count",iHiddenUsers,true);
		bOk = bOk && CloseXMLTag("HiddenUsers");
		bOk = bOk && CloseXMLTag("VotingUsers");

		// Now create the tree
		bOk = bOk && CreateFromXMLText(sXML,NULL,true);
	}

	return bOk;
}


/*********************************************************************************

	bool CVote::AddResponceToVote(int iVoteID, int iUserID, CTDVString& sBBCUID,
						int iResponse, bool bVisible, int iThreadID)

	Author:		Mark Howitt
	Created:	05/09/2003
	Inputs:		iVoteID - The ID of the vote you want to add a response to
				iUserID - the id of the user adding a response
				sBBCID - The BBCID for the user. Can be empty if not known
				iResponse - The actual response 
				bVisible - a flag to say if the user wants to be anonymous
				iThreadID - A ThreadID of a notice if voting on notices.
	Outputs:	
	Returns:	true if details found. false if something failed
	Purpose:	Adds a users response to a given vote.
				The ThreadID is defaulted to 0 and if not zero then this function
				assumes that we are adding votes to the threadvotes.

*********************************************************************************/

bool CVote::AddResponceToVote(int iVoteID, int iUserID, CTDVString& sBBCUID,
							  int iResponse, bool bVisible, int iThreadID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if(!SP.AddResponseToVote(iVoteID, iUserID, sBBCUID, iResponse, bVisible, m_InputContext.GetSiteID(), iThreadID ))
	{
		return SetDNALastError("CVote","FailedToAddResponse","Failed to add response to vote");
	}

	return true;
}

/*********************************************************************************

	bool CVote::GetObjectIDFromVoteID(int iVoteID, int iType, int& iObjectID)

	Author:		Mark Howitt
	Created:	05/09/2003
	Inputs:		iVoteID - The ID of the vote you want to add a response to
				iType - The type of object you want to get the id of.
					The different types can be found in the enum in VotePageBuilder.h
	Outputs:	iObjectID - A return id of the object found.
	Returns:	true if details found. false if something failed
	Purpose:	Gets the object id from the voteid

*********************************************************************************/

bool CVote::GetObjectIDFromVoteID(int iVoteID, int iType, int& iObjectID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.GetObjectIDFromVoteID(iType,iVoteID))
	{
		TDVASSERT(false, "No stored procedure created");
		return false;
	}

	// Get the ClubID and return 
	iObjectID = SP.GetIntField("ObjectID");
	return (iObjectID > 0) ? true : false;
}

/*********************************************************************************

	bool CVote::AddVoteToClubTable(int iVoteID, int iClubID, CTDVString* psClubName)

	Author:		Mark Howitt
	Created:	05/09/2003
	Inputs:		iVoteID - The ID of the vote you want to add to the club table
				iClubID - the id of the club to add the vote to
	Outputs:	
	Returns:	true if details found. false if something failed
	Purpose:	Adds a vote to the clubsvotes table.

*********************************************************************************/

bool CVote::AddVoteToClubTable(int iVoteID, int iClubID, CTDVString* psClubName)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.AddVoteToClubTable(iClubID,iVoteID))
	{
		TDVASSERT(false, "No stored procedure created");
		return false;
	}

	if (psClubName != NULL)
	{
		SP.GetField("Name",*psClubName);
	}

	return true;
}

/*********************************************************************************

	bool CVote::AddVoteToThreadTable(int iVoteID, int iThreadID)

	Author:		Mark Howitt
	Created:	28/10/2003
	Inputs:		iVoteID - The id of the vote you are adding
				iThreadID - The Id of the thread you're trying to add to.
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Adds a new vote to the threadsvote table

*********************************************************************************/

bool CVote::AddVoteToThreadTable(int iVoteID, int iThreadID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.AddVoteToThreadVoteTable(iThreadID,iVoteID))
	{
		TDVASSERT(false,"Failed to add a new vote to the threadvotes table!");
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CVote::IsVoteClosed(bool &bClosed)

	Author:		Mark Howitt
	Created:	28/10/2003
	Inputs:		-
	Outputs:	bClosed - The flag that gets set to the status of the vote.
	Returns:	true if ok, false if not
	Purpose:	Checks to see if a given vote is closed or not

*********************************************************************************/

bool CVote::IsVoteClosed(bool &bClosed)
{
	if (m_dCreatedDate == NULL)
	{
		TDVASSERT(false, "Dates not setup!");
		return false;
	}
	else if (m_dClosingDate == NULL || m_dClosingDate < m_dCreatedDate)
	{
		// The vote never closes
		bClosed = false;
	}
	else
	{
		// Check to see if the current date is greater than the closing.
		// If so, the vote is closed!
		bClosed = m_dClosingDate < m_dClosingDate.GetCurrentTime() ? true : false;
	}

	return true;
}

/*********************************************************************************

	bool CVote::HasUserAlreadyVoted(int iVoteID, int iUserID, CTDVString& sBBCUID, bool& bAlreadyVoted)

	Author:		Mark Howitt
	Created:	12/01/2004
	Inputs:		iVoteID - the id of the vote you want to check against.
				iUserID - the id of the user you want to check for - Can be 0 for Non-Signed in users.
				sBBCUID - the UID for the current user.
	Outputs:	bAlreadyVoted - a flag that gets set to say wether the user
				has already voted.
	Returns:	true if ok, false if not
	Purpose:	Checks to see if the user with a given ID and BBCUID has voted before.

*********************************************************************************/

bool CVote::HasUserAlreadyVoted(int iVoteID, int iUserID, CTDVString& sBBCUID, bool& bAlreadyVoted)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.HasUserAlreadyVoted(iVoteID,iUserID,sBBCUID))
	{
		return SetDNALastError("CVote","FailedCheckingMultipleVote","Failed checking multiple voting");
	}

	// Set the result and return
	bAlreadyVoted = SP.GetIntField("AlreadyVoted") > 0 ? true : false;
	return true;
}

/*********************************************************************************

	bool CVote::IsUserAuthorisedToCreateVote(int iItemID, int iVoteType, int iUserID, bool &bIsAuthorised)

	Author:		Mark Howitt
	Created:	23/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CVote::IsUserAuthorisedToCreateVote(int iItemID, int iVoteType, int iUserID, bool &bIsAuthorised)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.IsUserAuthorisedToCreateVote(iItemID,iVoteType,iUserID))
	{
		TDVASSERT(false, "No stored procedure created");
		return false;
	}

	// Set the result and return
	bIsAuthorised = SP.GetIntField("IsAuthorised") > 0 ? true : false;
	return true;
}

/*********************************************************************************

	bool CVote::RemoveUsersVote(int iVoteID, int iUserID)

		Author:		Mark Howitt
        Created:	06/08/2004
        Inputs:		iVoteID - The ID of the vote you want to remove the vote on.
					iUserID - The Users id to remove the vote for.
        Outputs:	-
        Returns:	true if we removed the user, false if not.
        Purpose:	Removes the user vote for a given vote id

*********************************************************************************/
bool CVote::RemoveUsersVote(int iVoteID, int iUserID)
{
	// Setup the stored procedure and try to remove the given user
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.RemoveUsersVote(iVoteID,iUserID))
	{
		return SetDNALastError("CVote::RemoveUsersVote","ProcedureFailed","Procedure failed");
	}

	// Create the small bit of XML
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	bool bOk = OpenXMLTag("REMOVEVOTE");
	bOk = bOk && AddDBXMLIntTag("Removed");
	bOk = bOk && AddXMLIntTag("VoteID",iVoteID);
	bOk = bOk && AddXMLIntTag("UserID",iUserID);
	bOk = bOk && CloseXMLTag("REMOVEVOTE");

	// return the verdict
	return bOk && CreateFromXMLText(sXML);
}

/*********************************************************************************

	bool Cvote::GetVotesCastByUser( int iUserID, int iSiteID)

		Author:		DE
        Created:	11/05/2005
        Inputs:		-iUser : id of the user whose votes are to be obtained
						-iSiteID : the id of the site - usually 16 for ican
        Outputs:	-true if successful, false otherwise
        Returns:	-returns a resultset containing details of all the threads and clubs a user 
						-has voted for. In Ican these translates as Notices and Campaigns 
        Purpose:	-Get all the items a user has voted for

*********************************************************************************/
bool CVote::GetVotesCastByUser( int iUserID, int iSiteID)
{
	//Setup the stored procedure and try to remove the given user
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	bool bOk = true;

	bOk = bOk && SP.GetVotesCastByUser(iUserID,iSiteID);
	if (!bOk)
	{
		return SetDNALastError("CVote::GetVotesCastByUser","ProcedureFailed","Failed to get the Votes cast by user");
	}

	// Create the XML fragment
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);

	
	//open enclosing tag
	bOk = bOk && OpenXMLTag("VOTEITEMS");

	// Go through the results adding the data to the XML
	while (bOk && !SP.IsEOF())
	{
		CTDVString sType;
		int iObjectID=0;
		int iVoteID=0;

		bOk = bOk && OpenXMLTag("VOTEITEM");
			bOk = bOk && AddDBXMLIntTag("OBJECTID",NULL, true, &iObjectID);
			bOk = bOk && AddDBXMLIntTag("VOTEID",NULL, true, &iVoteID);
			bOk = bOk && AddDBXMLIntTag("FORUMID");
			bOk = bOk && AddDBXMLIntTag("RESPONSE");
			bOk = bOk && AddDBXMLTag("TITLE");
			bOk = bOk && AddDBXMLTag("TYPE",NULL, false, true, &sType);
			bOk = bOk && AddDBXMLDateTag("DATEVOTED", NULL, false);
			bOk = bOk && AddDBXMLDateTag("DATECREATED", NULL, false);
			bOk = bOk && AddDBXMLIntTag("CREATORID", NULL, false);
			bOk = bOk && AddDBXMLTag("CREATORUSERNAME", NULL, false);

			int iVisible = 0;
			int iHidden = 0;							

			iVisible = 0;
			iHidden = 0;			

			sType.MakeLower();
			if(sType.CompareText("notice"))
			{
				CNotice oNotice(m_InputContext);				
				
				// NUMBER OF SUPPORTS				
				bOk = bOk && OpenXMLTag("NOTICEVOTES");					
				if (oNotice.GetNumberOfSupportersForNotice(iObjectID,iVoteID,iVisible,iHidden) && iVoteID > 0)
				{					
					bOk = bOk && AddXMLIntTag("VISIBLE",iVisible);
					bOk = bOk && AddXMLIntTag("HIDDEN",iHidden);					
				}
				else
				{
					SetDNALastError("CVote::GetVotesCastByUser","ProcedureFailed","Failed to get the Number of supporters for Notice");															
				}
				bOk = bOk && CloseXMLTag("NOTICEVOTES");		
			}

			if(sType.CompareText("club"))
			{
				iVisible = 0;
				iHidden = 0;			

				CStoredProcedure SP;
				m_InputContext.InitialiseStoredProcedureObject(&SP);

				// Yes Votes
				m_InputContext.InitialiseStoredProcedureObject(&SP);
				bOk = bOk && OpenXMLTag("CLUBYESVOTES");									
				if (SP.GetNumberOfVotesWithResponse(iVoteID,1,iVisible,iHidden))
				{					
					bOk = bOk && AddXMLIntTag("VISIBLE",iVisible);
					bOk = bOk && AddXMLIntTag("HIDDEN",iHidden);	
				}
				else
				{
					SetDNALastError("CVote::GetVotesCastByUser","ProcedureFailed","Failed to get the number of yes votes with response");										
				}
				bOk = bOk && CloseXMLTag("CLUBYESVOTES");		

				// No Votes
				bOk = bOk && OpenXMLTag("CLUBNOVOTES");									
				if (SP.GetNumberOfVotesWithResponse(iVoteID,0,iVisible,iHidden))
				{
					bOk = bOk && AddXMLIntTag("VISIBLE",iVisible);
					bOk = bOk && AddXMLIntTag("HIDDEN",iHidden);	
				}
				else
				{
					SetDNALastError("Club","GetClubVoteDetails","Failed to get the number of no votes with response");									
				}
				bOk = bOk && CloseXMLTag("CLUBNOVOTES");		
			}			

		bOk = bOk && CloseXMLTag("VOTEITEM");

		// Check to see if we're ok
		if (!bOk)
		{
			return SetDNALastError("CVote","GetVotesCastByUser","Failed to get the current voting items");
		}

		// Get the next entry
		SP.MoveNext();		
	}
	
	//close enclosing tag
	bOk = bOk && CloseXMLTag("VOTEITEMS");

	//create xml fragment
	bOk = bOk && CreateFromXMLText(sXML);

	// return the verdict
	return bOk;
}