// ClubPageBuilder.cpp: implementation of the CClubPageBuilder class.
//

/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.



URLS For Builder - 

/C1 - Club?id=1 

The builder will attempt to display the club with the given id

/C0?action=new&title="blah"&body="blah"&finish="yes"

Creates the club given the title and body and finish=yes. 
This uses the DNA multistep process.

*/

#include "stdafx.h"
#include "ClubPageBuilder.h"
#include "Club.h"
#include "GuideEntry.h"
#include "Team.h"
#include "Forum.h"
#include "Search.h"
#include "EditCategory.h"
#include "Multistep.h"
#include "Link.h"
#include "Category.h"
#include "./CurrentClubs.h"
#include ".\EMailAlertList.h"
#include "Config.h"
#include "polls.h"
#include "EMailAlertGroup.h"
#include "ForumPostEditForm.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CClubPageBuilder::CClubPageBuilder(CInputContext& inputContext)
: m_pViewingUser(NULL), m_pPage(NULL), CXMLBuilder(inputContext),
m_bErrorMessageReported(false)
{
}

CClubPageBuilder::~CClubPageBuilder()
{

}

/*********************************************************************************

	CWholePage* CClubPageBuilder::Build()

	Author:		Dharmesh Raithatha
	Created:	5/29/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CClubPageBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	if (!InitPage(m_pPage, "CLUB", true))
	{
		return false;
	}

	ProcessParams();

	return true;
}


/*********************************************************************************

	bool CClubPageBuilder::ProcessParams()

	Author:		Mark Neves
	Created:	12/11/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/
CWholePage* CClubPageBuilder::ProcessParams()
{
	CClub TheClub(m_InputContext);
	bool bDisplayClub = true;
	int iClubID = m_InputContext.GetParamInt("id");
	

	m_pViewingUser = m_InputContext.GetCurrentUser();
	const int iSiteID = m_InputContext.GetSiteID();
	bool bEditing = false;
	bool bErrorNoUser = false;

	if (m_InputContext.ParamExists("action"))
	{
		// You can't perform any action unless a user is logged in
		if (m_pViewingUser)
		{	
			int iUserID = m_InputContext.GetParamInt("userid");
            
			CTDVString sAction;
			m_InputContext.GetParamString("action", sAction);

			// If we're not an editor, check to make sure that the site is open
			if (!m_pViewingUser->GetIsEditor())
			{
				// We can't do anything if the site is closed and we're not an editor
				bool bSiteClosed = false;
				if (!m_InputContext.IsSiteClosed(m_InputContext.GetSiteID(),bSiteClosed))
				{
					// Put the error into the page and return
					SetDNALastError("CClubPageBuilder::ProcessParams","FailedToGetSiteOpenDetails","Failed To Get Site Open Details!!!");
					m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
					return m_pPage;
				}
				if (bSiteClosed)
				{
					// Put the error into the page and return
					SetDNALastError("CClubPageBuilder::ProcessParams","SiteClosed","Site is closed!!!");
					m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
					return m_pPage;
				}
			}

			// create a new club - this handles no user
			if (sAction.CompareText("new"))
			{
				// Check to see if we've been given any nodes to tag to?
				CDNAIntArray NodeArray;

				// Check to see if we've got at least one node id. Just return if we don't
				if (m_InputContext.ParamExists("node"))
				{
					// Get the list of nodes from the Input
					int iNodeID = 0;
					for (int i = 0; i < m_InputContext.GetParamCount("node"); i++)
					{
						iNodeID = m_InputContext.GetParamInt("node",i);
						if (iNodeID > 0)
						{
							// Add the node to the array
							NodeArray.Add(iNodeID);
						}
					}

					// Get the tagitem object to get the node details and add them to the XML
					CCategory Cat(m_InputContext);
					Cat.GetDetailsForNodes(NodeArray,"TAGGINGNODES");
					m_pPage->AddInside("H2G2",&Cat);
				}

				// Check to see if we've creating or previewing?
				if (m_InputContext.ParamExists("preview"))
				{
					CTDVString sGuideML, sTitle;
					bool bSuccess = TheClub.PreviewClub(sTitle,sGuideML);

					m_pPage->AddInside("H2G2",&TheClub);
					DisplayClubPreview(0,sTitle,sGuideML);
					if (!bSuccess)
					{
						m_pPage->AddInside("H2G2",TheClub.GetLastErrorAsXMLString());
					}
				}
				else
				{
					bool bCreatedClub = false;
					int iNewClubID = 0;
					bool bProfanityFound = false;
					bool bNonAllowedURLsFound = false;
					bool bEmailAddressFound = false;
					
					bool bSuccess = TheClub.CreateClub(iNewClubID, bCreatedClub, NodeArray, bProfanityFound, bNonAllowedURLsFound, bEmailAddressFound );
					
					if (!bSuccess)
					{
						if (bProfanityFound)
						{
							int iProfanityTriggered = m_InputContext.GetParamInt("profanitytriggered");
							if (iProfanityTriggered > 0)
							{
								m_pPage->Redirect("G?action=new");
								return m_pPage;
							}
							return ErrorMessage("CreateClub","Unable to create Club - Profanity Found.");
						}
						else if (bNonAllowedURLsFound)
						{
							int iNonAllowedURLsTriggered = m_InputContext.GetParamInt("nonallowedurltriggered");
							if (iNonAllowedURLsTriggered > 0)
							{
								m_pPage->Redirect("G?action=new");
								return m_pPage;
							}
							return ErrorMessage("CreateClub","Unable to create Club - Non Allowed URL Found.");
						}
						else if ( bEmailAddressFound )
						{
							int iEmailAddressTriggered = m_InputContext.GetParamInt("nonallowedemailtriggered");
							if (iEmailAddressTriggered > 0)
							{
								m_pPage->Redirect("G?action=new");
								return m_pPage;
							}
							return ErrorMessage("CreateClub","Unable to create Club - Email Address Found.");
						}
						else
						{
							m_pPage->Redirect("G?action=new");
							return m_pPage;
						}
					}
					
					m_pPage->AddInside("H2G2",&TheClub);

					//Add the club information if it was created
					if (bCreatedClub)
					{
						//if there is a search query then search the hierarchy and return the list of matching nodes
						if (m_InputContext.ParamExists("searchtax"))
						{
							CTDVString sSearchQuery;
							m_InputContext.GetParamString("searchtax",sSearchQuery);

							CSearch Search(m_InputContext);
							
							if (Search.InitialiseHierarchySearch(sSearchQuery, m_InputContext.GetSiteID(), 0, 10))
							{
								m_pPage->AddInside("H2G2",&Search);
							}
						}
						DisplayClub(iNewClubID, TheClub);

						// Check for the redirect param
						if (iNewClubID > 0 && m_InputContext.ParamExists("redirect"))
						{
							// Get the redirect
							CTDVString sRedirect;
							m_InputContext.GetParamString("redirect",sRedirect);

							// Make sure we unescape it!
							sRedirect.Replace("%26","&");
							sRedirect.Replace("%3F","?");

							// Check to see if we're trying to go to the tagitem page, if so add the club info
							int iTagItem = sRedirect.FindText("tagitem");
							if (iTagItem > -1)
							{
								// Now add the new threadid on the end of the redirect, so the page knows!
								// check for the question mark. If it has then use the '&' before adding the params
								((sRedirect.GetLength() - iTagItem) > 7 && sRedirect[iTagItem + 7] == '?') ? sRedirect << "&" : sRedirect << "?";
								sRedirect << "tagitemid=" << iNewClubID << "&s_clubid=" << iNewClubID;
							}

							// Add the redirect to the page
							m_pPage->Redirect(sRedirect);
						}
					}
					else
					{
						m_pPage->AddInside("H2G2",TheClub.GetLastErrorAsXMLString());
					}
				}
			}
			else if (sAction.CompareText("rolechange"))
			{
				// Check to see if we're trying to change a users role
				CTDVString sRoleChange;
				m_InputContext.GetParamString("rolechange",sRoleChange);
				if (!sRoleChange.IsEmpty())
				{
					// The club id param is named differently for the Rold Change feature
					iClubID = m_InputContext.GetParamInt("clubid");
					if (TheClub.InitialiseViaClubID(iClubID))
					{
						// Ok, update the users role before we continue to build the page.
						if (!TheClub.UpdateUsersRole(m_pViewingUser->GetUserID(), sRoleChange))
						{
							TDVASSERT(false, "Failed to update users role");
						}
					}
					else
					{
						TDVASSERT(false, "Failed to initialise the club");
					}
				}
			}
			else if (sAction.CompareText("process")) 
			{
				int iActionID = m_InputContext.GetParamInt("actionid");
				int iParamcount = 0;
				while (m_InputContext.ParamExists("actionid", iParamcount)) 
				{
					iActionID = m_InputContext.GetParamInt("actionid", iParamcount);
					int iResult = m_InputContext.GetParamInt("result", iParamcount);
					if (TheClub.CompleteAction(iActionID, m_pViewingUser, iResult)) 
					{
						m_pPage->AddInside("H2G2",&TheClub);
					}
					iParamcount++;
				}
			}
			else if (sAction.CompareText("edit"))
			{
				if (m_InputContext.ParamExists("editpreview"))
				{
					if (!HandleEditClubPreview(iClubID))
					{
						return ErrorMessage("Club","Failed to preview edit club");
					}
					bDisplayClub = false;
				}
				// HandleEditClub() will update the bEditing flag
				else if (!HandleEditClub(iClubID, bEditing))
				{
					if (HasErrorBeenReported())
					{
						return m_pPage;
					}
					else
					{
						return ErrorMessage("Club","Edit club failed");
					}
				}
			}
			else if (sAction.CompareText("classify"))
			{
				ClassifyClubInHierarchy(iClubID);
			}
			else if (sAction.CompareText("joinmember"))
			{
				int iActionUserID = m_pViewingUser->GetUserID();
				if(iUserID && m_pViewingUser->GetIsSuperuser())
				{
					iActionUserID = iUserID;
				}

				if (TheClub.PerformAction(iClubID,m_pViewingUser, iActionUserID,CClub::ACTION_JOINMEMBER, iSiteID))
				{
					m_pPage->AddInside("H2G2",&TheClub);
				}
				else
				{
					return ErrorMessage("ClubAction","Failed to perform action");
				}
			}
			else if (sAction.CompareText("joinowner"))
			{
				int iActionUserID = m_pViewingUser->GetUserID();
				if(iUserID && m_pViewingUser->GetIsSuperuser())
				{
					iActionUserID = iUserID;
				}
				
				if (TheClub.PerformAction(iClubID,m_pViewingUser, iActionUserID,CClub::ACTION_JOINOWNER, iSiteID))
				{
					m_pPage->AddInside("H2G2",&TheClub);
				}
				else
				{
					return ErrorMessage("ClubAction","Failed to perform action");
				}
			}
			else if (sAction.CompareText("invitemember"))
			{
				if (TheClub.PerformAction(iClubID,m_pViewingUser, iUserID,CClub::ACTION_INVITEMEMBER, iSiteID))
				{
					m_pPage->AddInside("H2G2",&TheClub);
				}
				else
				{
					return ErrorMessage("ClubAction","Failed to perform action");
				}
			}
			else if (sAction.CompareText("inviteowner"))
			{
				if (TheClub.PerformAction(iClubID,m_pViewingUser, iUserID ,CClub::ACTION_INVITEOWNER, iSiteID))
				{
					m_pPage->AddInside("H2G2",&TheClub);
				}
				else
				{
					return ErrorMessage("ClubAction","Failed to perform action");
				}
			}
			else if (sAction.CompareText("ownerresignsmember"))
			{
				int iActionUserID = m_pViewingUser->GetUserID();
				if(iUserID && m_pViewingUser->GetIsSuperuser())
				{
					iActionUserID = iUserID;
				}
				
				if (TheClub.PerformAction(iClubID,m_pViewingUser, iActionUserID,CClub::ACTION_OWNERTOMEMBER, iSiteID))
				{
					m_pPage->AddInside("H2G2",&TheClub);
				}
				else
				{
					return ErrorMessage("ClubAction","Failed to perform action");
				}
			}
			else if (sAction.CompareText("ownerresignscompletely"))
			{
				int iActionUserID = m_pViewingUser->GetUserID();
				if(iUserID && m_pViewingUser->GetIsSuperuser())
				{
					iActionUserID = iUserID;
				}

				if (TheClub.PerformAction(iClubID,m_pViewingUser, iActionUserID,CClub::ACTION_OWNERRESIGNS, iSiteID))
				{
					m_pPage->AddInside("H2G2",&TheClub);
				}
				else
				{
					return ErrorMessage("ClubAction","Failed to perform action");
				}
			}
			else if (sAction.CompareText("memberresigns"))
			{
				int iActionUserID = m_pViewingUser->GetUserID();
				if(iUserID && m_pViewingUser->GetIsSuperuser())
				{
					iActionUserID = iUserID;
				}

				if (TheClub.PerformAction(iClubID,m_pViewingUser, iActionUserID,CClub::ACTION_MEMBERRESIGNS, iSiteID))
				{
					m_pPage->AddInside("H2G2",&TheClub);
				}
				else
				{
					return ErrorMessage("ClubAction","Failed to perform action");
				}
			}
			else if (sAction.CompareText("demoteownertomember"))
			{
				if (TheClub.PerformAction(iClubID,m_pViewingUser, iUserID ,CClub::ACTION_OWNERDEMOTESOWNER, iSiteID))
				{
					m_pPage->AddInside("H2G2",&TheClub);
				}
				else
				{
					return ErrorMessage("ClubAction","Failed to perform action");
				}
			}
			else if (sAction.CompareText("removeowner"))
			{
				if (TheClub.PerformAction(iClubID,m_pViewingUser, iUserID ,CClub::ACTION_OWNERREMOVESOWNER, iSiteID))
				{
					m_pPage->AddInside("H2G2",&TheClub);
				}
				else
				{
					return ErrorMessage("ClubAction","Failed to perform action");
				}
			}
			else if (sAction.CompareText("removemember"))
			{
				if (TheClub.PerformAction(iClubID,m_pViewingUser, iUserID ,CClub::ACTION_OWNERREMOVESMEMBER, iSiteID))
				{
					m_pPage->AddInside("H2G2",&TheClub);
				}
				else
				{
					return ErrorMessage("ClubAction","Failed to perform action");
				}
			}
			else if (sAction.CompareText("UpdateClubModerationStatus"))
			{
				if (m_pViewingUser->GetIsEditor() || m_pViewingUser->GetIsSuperuser())
				{
					int iNewStatus = m_InputContext.GetParamInt("status");
					TheClub.UpdateClubModerationStatus(iClubID,iNewStatus);
				}
			}
			else if (sAction.CompareText("AddLink"))
			{
				if (!TheClub.IsInitialised())
				{
					if (!TheClub.InitialiseViaClubID(iClubID))
					{
						return ErrorMessage(TheClub.GetLastErrorCode(),TheClub.GetLastErrorMessage());
					}
				}

				if (!AddLink(TheClub,m_pViewingUser))
				{
					return ErrorMessage("ClubAddLink","Error adding a link");
				}
			}
			else if ( sAction.CompareText("Delete") )
			{
				if (!TheClub.IsInitialised())
				{
					if (!TheClub.InitialiseViaClubID(iClubID))
					{
						return ErrorMessage(TheClub.GetLastErrorCode(),TheClub.GetLastErrorMessage());
					}
				}
				if ( !TheClub.Delete() )
					return ErrorMessage(TheClub.GetLastErrorCode(), TheClub.GetLastErrorMessage());
				else
					m_pPage->AddInside("H2G2","<MESSAGE TYPE='HIDE-OK'>Club deleted successfully</MESSAGE>");
			}
			else if ( sAction.CompareText("UnDelete") )
			{
				if (!TheClub.IsInitialised())
				{
					if (!TheClub.InitialiseViaClubID(iClubID))
					{
						return ErrorMessage(TheClub.GetLastErrorCode(),TheClub.GetLastErrorMessage());
					}
				}

				if ( !TheClub.UnDelete() )
					return ErrorMessage(TheClub.GetLastErrorCode(), TheClub.GetLastErrorMessage());
				else
					m_pPage->AddInside("H2G2","<MESSAGE TYPE='UNHIDE-OK'>Club restored successfully</MESSAGE>");

			}
			else if(sAction.CompareText("AddUrl"))
			{
				// Make sure we have an ID
				if(!iClubID)
				{
					return ErrorMessage("BadParamID", "The ID parameter is missing or invalid");
				}

				// Extract url param (required)
				CTDVString sUrl;
				if(!m_InputContext.GetParamString("addurl", sUrl))
				{
					return ErrorMessage("BadParamADDURL", "The ADDURL parameter is missing or invalid");
				}

				// Extract title, descripton and relationship optional parameters
				CTDVString sTitle, sDescription, sRelationship;
				m_InputContext.GetParamString("addurltitle", sTitle);
				m_InputContext.GetParamString("addurldescription", sDescription);
				m_InputContext.GetParamString("addurlrelationship", sRelationship);

				// Init club
				CClub club(m_InputContext);
				if(!club.InitialiseViaClubID(iClubID))
				{
					TDVASSERT(false, "CClubPageBuilder::ProcessParams() TheClub.InitialiseViaClubID() failed");
					return ErrorMessage(club.GetLastErrorCode(), club.GetLastErrorMessage());
				}

				// Add url
				if(!club.AddUrl(sUrl, sTitle, sDescription, sRelationship))
				{
					TDVASSERT(false, "CClubBuilder::ProcessParams() club.AddUrl() failed");
					return ErrorMessage(club.GetLastErrorCode(), club.GetLastErrorMessage());
				}

				// Proceed to display club
			}
		}
		// there is an action but there is viewing user
		else
		{
			bErrorNoUser = true;
		}
	}

	if (bErrorNoUser)
	{
		return ErrorMessage("NoUser","Tried to perform an action with no user logged in");
	}

	//there is no action but there is an id > 0 means we are just displaying the club
	if (iClubID > 0 && bDisplayClub)
	{
		DisplayClub(iClubID, TheClub, bEditing);
		if (m_InputContext.ParamExists("clip"))
		{
			CTDVString sURL;
			CTDVString sName;
			sURL << "G" << iClubID;
			TheClub.GetName(sName);
			if (sName.GetLength() == 0) 
			{
				sName = sURL;
			}
			
			bool bPrivate = m_InputContext.GetParamInt("private") > 0;
			CLink Link(m_InputContext);
			if ( Link.ClipPageToUserPage("club", iClubID, sName, NULL, m_pViewingUser, bPrivate ) )
				m_pPage->AddInside("H2G2", &Link);
		}
		m_pPage->AddInside("H2G2",&TheClub);
		
	}

	if (iClubID > 0 && m_pViewingUser != NULL)
	{
		TheClub.GetClubActionList(iClubID, m_pViewingUser, 0,200 );
		m_pPage->AddInside("H2G2", &TheClub);
	}

    CTDVString sRedirect;
	if (m_InputContext.GetParamString("redirect",sRedirect))
	{
		m_pPage->Redirect(sRedirect);
	}

	//TODO: only unless redirect ?
	CTDVString sImagesRoot = "<IMGROOT>";
	sImagesRoot << m_InputContext.GetImageLibraryPublicUrlBase() << "</IMGROOT>";
	m_pPage->AddInside("H2G2", sImagesRoot);

	return m_pPage;
}

/*********************************************************************************

	bool CClubPageBuilder::HandleEditClub(int iClubID, bool& bEditing)

	Author:		Mark Neves
	Created:	01/08/2003
	Inputs:		iClubID = the club ID
	Outputs:	-
	Returns:	true if handled OK, false otherwise
	Purpose:	The user has either started to edit a club, or has finished editing the club.
				This function handles the whole operation

*********************************************************************************/

bool CClubPageBuilder::HandleEditClub(int iClubID,bool& bEditing)
{
	bEditing = true;

	CMultiStep Multi(m_InputContext, "CLUB-EDIT");

	CClub Club(m_InputContext);
	if (!Club.EditClub(Multi, iClubID))
	{
		ErrorMessage(Club.GetLastErrorCode(),Club.GetLastErrorMessage());
		return false;
	}

	if (Club.ErrorReported())
	{
		m_pPage->AddInside("H2G2",Club.GetLastErrorAsXMLString());
	}

	m_pPage->AddInside("H2G2", Multi.GetAsXML());

	return true;
}


/*********************************************************************************

	bool CClubPageBuilder::HandleEditClubPreview(int iClubID)

	Author:		Mark Neves
	Created:	09/10/2003
	Inputs:		iClubID = the club to preview
	Outputs:	-
	Returns:	true if OK, false otherwise
	Purpose:	Handles the preview of the club during editing

				It outputs the Multistep XML for the club, but makes sure the 
				multistep is "cancelled", so that it's not committed yet
				It also outputs a <CLUBBODYPREVIEW> tag, containing a slightly modified
				version of the body GuideML suitable for preview

*********************************************************************************/

bool CClubPageBuilder::HandleEditClubPreview(int iClubID)
{
	CMultiStep Multi(m_InputContext, "CLUB-EDIT-PREVIEW");

	CTDVString sTitle, sGuideML;
	CClub Club(m_InputContext);
	if (!Club.EditClubPreview(iClubID, Multi, sTitle, sGuideML))
	{
		m_pPage->AddInside("H2G2",Club.GetLastErrorAsXMLString());
		return false;
	}

	if (Club.ErrorReported())
	{
		m_pPage->AddInside("H2G2",Club.GetLastErrorAsXMLString());
	}		

	DisplayClubPreview(iClubID, sTitle, sGuideML);

	Multi.SetToCancelled();

	m_pPage->AddInside("H2G2", Multi.GetAsXML());

	return true;
}


/*********************************************************************************

	CWholePage* CClubPageBuilder::DisplayClub(int iClubID, CClub& mClub, bool bEditing = false)

	Author:		Dharmesh Raithatha
	Created:	07/02/2001
	Inputs:		- iClubID = 0, if no param passed in then it will try to get the
				id from the inputcontext
	Outputs:	-
	Returns:	Returns the page for Displaying a club
	Purpose:	Displays the Club page
*********************************************************************************/

CWholePage* CClubPageBuilder::DisplayClub(int iClubID, CClub& mClub, bool bEditing )
{
	
	//Club

	if (iClubID == 0)
	{
		iClubID = m_InputContext.GetParamInt("id");
	}
	
	if (iClubID < 1)
	{
		return ErrorMessage("ClubID", "Invalid Club Id");
	}

	//CClub mClub(m_InputContext);
	
	if (!mClub.IsInitialised())
	{
		if (!mClub.InitialiseViaClubID(iClubID))
		{
			return ErrorMessage(mClub.GetLastErrorCode(),mClub.GetLastErrorMessage());
		}
	}
	
	// Are we going to show hidden information?
	bool bIsUserAllowedToEditClub = mClub.IsUserAllowedToEditClub(m_pViewingUser,iClubID);
	bool bShowHidden = bEditing &&  bIsUserAllowedToEditClub;

	// If we want to show hidden club details, it's not safe to either read the club data from
	// the cache, nor to subsequently put it back into the cache
	bool bSafeToCache = !bShowHidden;
	
	int ih2g2ID = mClub.GetArticleID();
 
	CGuideEntry mDescription(m_InputContext);

	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	bool bSuccess = mDescription.Initialise(ih2g2ID,m_InputContext.GetSiteID(), pViewingUser, true,true,true,bSafeToCache,bShowHidden);

	if (bSuccess == NULL)
	{
		return ErrorMessage("ClubArticle","Unable to initialise the Article");
	}

	//Owner Team Members

	int iOwnerTeamID = 0;
	
	iOwnerTeamID = mClub.GetOwnerTeamID();

	CTeam mOwnerTeam(m_InputContext);
	
	mOwnerTeam.SetType("OWNER");

	if (!mOwnerTeam.GetAllTeamMembers(iOwnerTeamID))
	{
		return ErrorMessage("OwnerInit","Unable to initialise the Owners group");
	}

	//Member Team Members

	int iMemberTeamID = 0;
	iMemberTeamID = mClub.GetMemberTeamID();
	
	CTeam mMemberTeam(m_InputContext);
	
	mMemberTeam.SetType("MEMBER");

	if (!mMemberTeam.GetAllTeamMembers(iMemberTeamID))
	{
		return ErrorMessage("MemberInit","Unable to initialise the Members group");
	}

	// Insert the SitesList
	CTDVString sSiteXML;
	m_InputContext.GetSiteListAsXML(&sSiteXML);
	bSuccess = bSuccess && m_pPage->AddInside("H2G2", sSiteXML);

	//Journal 

	int iJournalID = 0;
	iJournalID = mClub.GetJournalID();

	CForum mJournal(m_InputContext);

	int iShow = 20;
	int iSkip = 0;

	if (!mJournal.GetJournal(m_pViewingUser,iJournalID,iShow, iSkip, bIsUserAllowedToEditClub ))
	{
		return ErrorMessage("Journal","Failed to initialise the Journal");
	}

	bSuccess = bSuccess && m_pPage->AddInside("H2G2","<CLUB></CLUB>") &&
					//put the journal in first as clubinfo also has a journal
					//tag - be careful of ordering.
					m_pPage->AddInside("/H2G2/CLUB","<JOURNAL></JOURNAL>") &&
					m_pPage->AddInside("/H2G2/CLUB",&mClub) && 
					m_pPage->AddInside("/H2G2/CLUB",&mDescription) &&
					m_pPage->AddInside("/H2G2/CLUB","<POPULATION></POPULATION>") &&
					m_pPage->AddInside("/H2G2/CLUB/POPULATION",&mOwnerTeam) &&
					m_pPage->AddInside("/H2G2/CLUB/POPULATION",&mMemberTeam) &&
					m_pPage->AddInside("/H2G2/CLUB/JOURNAL",&mJournal);
	 
	int iClubForumType = mClub.GetClubForumType();	// 1 = single thread, 0 = normal forum
	
	if (iClubForumType == 0)
	{
		int iThreadOrder = m_InputContext.GetThreadOrder();
		bSuccess = bSuccess && mJournal.GetThreadList(m_pViewingUser, mClub.GetForumID(), 2, 0, 0, false, iThreadOrder);
	}
	else
	{
		bSuccess = bSuccess && mJournal.GetPostsInForum(m_pViewingUser, mClub.GetForumID(), 2,0);
	}
	CTDVString sClubForumTag;
	sClubForumTag << "<CLUBFORUM TYPE='" << iClubForumType << "'/>";
	bSuccess = bSuccess && m_pPage->AddInside("CLUB", sClubForumTag);
	bSuccess = bSuccess && m_pPage->AddInside("CLUBFORUM", &mJournal);

	CTDVString sClubVote;
	mClub.GetClubVoteDetails(iClubID,0,sClubVote);
	bSuccess = bSuccess && m_pPage->AddInside("CLUB",sClubVote);

	CLink Link(m_InputContext);
	CTDVString sLinkGroup;
	bool bShowPrivateClubLinks = false;
	if (m_pViewingUser != NULL)
	{
		bShowPrivateClubLinks = m_pViewingUser->GetIsEditor() || mClub.IsUserInTeamMembersOfClub(m_pViewingUser->GetUserID(),iClubID);
	}
	Link.GetClubLinks(iClubID, sLinkGroup, bShowPrivateClubLinks);
	m_pPage->AddInside("CLUB", &Link);

	CCurrentClubs UMC(m_InputContext);
	if (UMC.CreateList(m_pViewingUser,true))
	{
		m_pPage->AddInside("CLUB",&UMC);
	}

	// If we have a user, lets check their subscription for the category
	if (m_pViewingUser != NULL)
	{
		// Get the users subsciption status for this category
		CEmailAlertList EMailAlert(m_InputContext);
		if (EMailAlert.GetUserEMailAlertSubscriptionForClubArticleAndForum(m_pViewingUser->GetUserID(),iClubID))
		{
			m_pPage->AddInside("H2G2",&EMailAlert);
		}
	}

	// State whether user has any group alerts on this club
	if(m_pViewingUser != NULL)
	{
		CEMailAlertGroup EMailAlertGroup(m_InputContext);
		int iGroupID = 0;

		if(!EMailAlertGroup.HasGroupAlertOnItem(iGroupID, m_pViewingUser->GetUserID(), m_InputContext.GetSiteID(), CEmailAlertList::IT_CLUB, iClubID))
		{
			TDVASSERT(false, "CClubPageBuilder::DisplayClub() EMailAlertGroup.HasGroupAlert failed");
		}
		else if(iGroupID != 0)
		{
			// Put XML
			CTDVString sGAXml;
			sGAXml << "<GROUPALERTID>" << iGroupID << "</GROUPALERTID>";
			
			if(!m_pPage->AddInside("CLUB", sGAXml))
			{
				TDVASSERT(false, "CClubPageBuilder::DisplayClub() m_pPage->AddInside failed");
			}	
		}
	}

	// Add Polls
	CPolls polls(m_InputContext);
	if(!polls.MakePollList(iClubID, CPoll::ITEMTYPE_CLUB))
	{
		TDVASSERT(false, "CClubPageBuilder::DisplayClub() MakePollList failed");
	}
	else
	{
		if(!m_pPage->AddInside("CLUB", &polls))
		{
			TDVASSERT(false, "CClubPageBuilder::DisplayClub() AddInside failed");
		}
	}

	// Create and add <dynamic-lists> to page
	CTDVString sDyanmicListsXml;
	if(!m_InputContext.GetDynamicLists(sDyanmicListsXml, m_InputContext.GetSiteID()))
	{
		TDVASSERT(false, "CClubPageBuilder::Build() m_InputContext.GetDynamicLists failed");
	}
	else
	{
		if(!m_pPage->AddInside("CLUB", sDyanmicListsXml))
		{
			TDVASSERT(false, "CClubPageBuilder::Build() m_pPage->AddInside failed");
		}
	}

	if (!bSuccess)
	{
		return ErrorMessage("XML","Failed to build the XML");
	}


	return m_pPage;
}

/*********************************************************************************

	CWholePage* CClubPageBuilder::DisplayClubPreview(int iClubID, const CTDVString& sTitle, const CTDVString& sGuideML)

	Author:		Mark Neves
	Created:	03/12/2003
	Inputs:		iClubID = the club ID that you are previewing (supply 0 if it doesn't exist yet)
				sTitle = the title of the club
				sGuideML = the guide body for the club
	Outputs:	-
	Returns:	the page object containing the <CLUB> structure
	Purpose:	"Displays" a club in the page for preview only.
				It copes with new clubs that are yet to be inserted into the DB, as well as existing DBs.
				At the moment, the only data worth inserting is the title, the guide body,
				and the ID if it has one, which is perfectly adequate for preview purposes

*********************************************************************************/

CWholePage* CClubPageBuilder::DisplayClubPreview(int iClubID, const CTDVString& sTitle, const CTDVString& sGuideML)
{
	CExtraInfo ExtraInfo(CGuideEntry::TYPECLUB);
	CGuideEntry Guide(m_InputContext);
	Guide.CreateFromData(m_pViewingUser,0,sTitle,sGuideML,ExtraInfo,1,m_InputContext.GetSiteID(),0);

	m_pPage->AddInside("H2G2","<CLUB></CLUB>");
	m_pPage->AddInside("CLUB",&Guide);

	CTDVString sClubID;
	sClubID << "<CLUBINFO ID='" << iClubID << "' />";
	m_pPage->AddInside("CLUB",sClubID);
	 
	return m_pPage;
}

/*********************************************************************************

	CWholePage* CClubPageBuilder::ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg)

	Author:		Dharmesh Raithatha
	Created:	5/23/2003
	Inputs:		sType - type of error
				sMsg - Defualt message
	Outputs:	-
	Returns:	whole xml page with error
	Purpose:	default error message

*********************************************************************************/

CWholePage* CClubPageBuilder::ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg)
{

	InitPage(m_pPage, "CLUB", true);

	CTDVString sError = "<ERROR TYPE='";
	sError << sType << "'>" << sMsg << "</ERROR>";

	m_pPage->AddInside("H2G2", sError);

	m_bErrorMessageReported = true;

	return m_pPage;
}

bool CClubPageBuilder::HasErrorBeenReported()
{
	return m_bErrorMessageReported;
}

/*********************************************************************************
	bool CClubPageBuilder::ClassifyClubInHierarchy(int iClubID)
	Author:		Dharmesh Raithatha
	Created:	7/15/2003
	Inputs:		iClubID - the club that you want to store in the taxononmy
	Outputs:	-
	Returns:	-
	Purpose:	Classifies the club in the hierarchy
*********************************************************************************/

bool CClubPageBuilder::ClassifyClubInHierarchy(int iClubID)
{
	int iNodeCount = 0;
	CEditCategory EditCategory(m_InputContext);
	bool bSuccess = false;
	while (m_InputContext.ParamExists("nodeid",iNodeCount)) 
	{
		int iNodeID = 0;
		iNodeID = m_InputContext.GetParamInt("nodeid",iNodeCount);
		if (iNodeID > 0)
		{
			EditCategory.AddNewClub(iClubID,iNodeID,iNodeID,bSuccess);
		}

		iNodeCount++;
	}

	return true;
}


/*********************************************************************************

	bool CClubPageBuilder::AddLink(CClub& Club, CUser* pUser)

	Author:		Mark Neves
	Created:	04/02/2004
	Inputs:		Club = ref to the club you want to add a link to
				pUser = who are ya?  huh?
	Outputs:	-
	Returns:	true if OK, false otherwise
	Purpose:	Adds a link to the given club
				Looks for this URL params:
				"response": the response to a "support or oppose question" (optional)
				"destinationType" : the type of thing your linking to
				"destinationID": the id of thing your linking to

*********************************************************************************/

bool CClubPageBuilder::AddLink(CClub& Club, CUser* pUser)
{
	if (!Club.IsInitialised())
	{
		TDVASSERT(false,"Uninitialised club");
		return false;
	}

	if (pUser == NULL)
	{
		TDVASSERT(false,"NULL user ptr");
		return false;
	}

	CTDVString sRelationship;
	if (m_InputContext.ParamExists("response"))
	{
		// a "response" param means this link came after a vote, so work out the relationship
		int iResponse = m_InputContext.GetParamInt("response");
		switch (iResponse)
		{
			case 0 :
				sRelationship = "oppose";
				break;
			case 1 :
				sRelationship = "support";
				break;
			// the default is to leave the sRelationship string empty
		}
	}

	CTDVString sDestType;
	m_InputContext.GetParamString("destinationType",sDestType);
	int iDestID = m_InputContext.GetParamInt("destinationID");

	Club.AddLink(pUser,sDestType,iDestID,sRelationship, NULL, NULL, NULL);
	// No need to do any more.  The result of the link operation will be inside
	// CLUBINFO/CLIP tag, and will also state success or failure.

	return true;
}
