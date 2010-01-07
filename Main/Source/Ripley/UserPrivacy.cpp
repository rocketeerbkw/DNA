#include "stdafx.h"
#include ".\userprivacy.h"
#include ".\storedprocedure.h"
#include ".\User.h"
#include ".\PostCoder.h"
#include ".\TagItem.h"

CUserPrivacy::CUserPrivacy(CInputContext& inputContext) : 
	m_bHideLocation(false), m_bHideUserName(false), m_bInitialised(false),
		m_bUpdateStarted(false), CXMLObject(inputContext), m_bHideLocationUpdated(false), m_bHideUserNameUpdated(false)
{
}

CUserPrivacy::~CUserPrivacy(void)
{
}

/*********************************************************************************

	bool CUSerPrivacy::InitialiseUserPrivacyDetails(int iUserID = 0)

		Author:		Mark Howitt
        Created:	10/05/2006
        Inputs:		iUserID - This is the id of the user you want to initialise the
							UserPrivacy object with. If this is 0, then it will get the
							details from the current viewing user
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Initialises the Object with the given users privacy details.

*********************************************************************************/
bool CUserPrivacy::InitialiseUserPrivacyDetails(int iUserID)
{
	// Did we get given a userid?
	if (iUserID == 0)
	{
		// No! Get the details from the viewing user
		if (m_InputContext.GetCurrentUser() == NULL)
		{
			// Report the error!
			m_bInitialised = false;
			return SetDNALastError("CUserPrivacy::GetUserPrivacyDetails","UserNotLoggedIn","User Not Logged In!!!");
		}

		// Get the values into the member variables
		m_iCurrentUser = m_InputContext.GetCurrentUser()->GetUserID();
		m_bHideLocation = m_InputContext.GetCurrentUser()->GetIsUserLocationHidden();
		m_bHideUserName = m_InputContext.GetCurrentUser()->GetIsUserNameHidden();
	}
	else
	{
		// Set the member variable
		m_iCurrentUser = iUserID;

		// Get and initialise a storedprocedure
		CStoredProcedure SP;
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			// Report the error!
			m_bInitialised = false;
			return SetDNALastError("CUserPrivacy::GetUserPrivacyDetails","FailedToInitialiseStoredProcedure","Failed to Initialise Stored Procedure!!!");
		}

		// Now call the procedure and check to make sure we got something
		if (!SP.GetUserPrivacyDetails(iUserID) || SP.IsEOF())
		{
			// Report the error!
			m_bInitialised = false;
			return SetDNALastError("CUserPrivacy::GetUserPrivacyDetails","FailedToGetUserDetails","Failed to get the user details!!!");
		}

		// Get the values from the stored procedure
		m_bHideLocation = SP.GetIntField("HideLocation") > 0;
		m_bHideUserName = SP.GetIntField("HideUserName") > 0;
	}
	
	// Set the initialised flag
	m_bInitialised = true;
	return true;
}

/*********************************************************************************

	bool CUserPrivacy::GetUserPrivacyDetails()

		Author:		Mark Howitt
        Created:	02/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets the current settings as XML

*********************************************************************************/
bool CUserPrivacy::GetUserPrivacyDetails()
{
	// Check to make sure we've been initialised
	if (!m_bInitialised)
	{
		// Report the error!
		return SetDNALastError("CUserPrivacy::GetUserPrivacyDetails","NotInitialised","NOt Initialised!!!");
	}

	// Now create the XML
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML);
	bool bOk = XML.OpenTag("USERPRIVACYDETAILS",true);
	bOk = bOk && XML.AddIntAttribute("USERID",m_iCurrentUser,true);
	bOk = bOk && XML.AddIntTag("HideUserName",m_bHideUserName);
	bOk = bOk && XML.AddIntTag("HideLocation",m_bHideLocation);
	bOk = bOk && XML.CloseTag("USERPRIVACYDETAILS");

	// Now create the XML tree from the String
	if (!bOk || !CreateFromXMLText(sXML,NULL,true))
	{
		// Report the error!
		return SetDNALastError("CUserPrivacy::GetUserPrivacyDetails","FailedToCreateXML","Failed to create XML!!!");
	}

	// Return ok
	return true;
}

/*********************************************************************************

	bool CUserPrivacy::StartUpdate()

		Author:		Mark Howitt
        Created:	10/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Initialised the stored procedure for updating the users privacy settingings.

*********************************************************************************/
bool CUserPrivacy::StartUpdate()
{
	// Check to make sure the object has been initialsed
	if (!m_bInitialised)
	{
		// Report the error
		return SetDNALastError("CUserPrivacy::StartUpdate","NotInitialised","Not Initialised!!!");
	}

	// We're already doing an update ???????
	if (m_bUpdateStarted)
	{
		return true;
	}

	if (!m_InputContext.InitialiseStoredProcedureObject(m_SP))
	{
		// Report the error
		return SetDNALastError("CUserPrivacy::StartUpdate","FailedToInitialiseStoredProcedure","Failed to intialise storedprocedure!!!");
	}

	// Now start the update procedure with the user we want to update
	if (!m_SP.StartUserPrivacyUpdate(m_iCurrentUser))
	{
		// Report the error
		return SetDNALastError("CUserPrivacy::StartUpdate","FailedToStartUpdate","Failed to start update!!!");
	}

	// ReSet the member variable and return ok
	m_bUpdateStarted = true;
	m_bHideLocationUpdated = false;
	m_bHideUserNameUpdated = false;
	return true;
}

/*********************************************************************************

	bool CUserPrivacy::UpdateHideLocation(bool bHide)

		Author:		Mark Howitt
        Created:	10/05/2006
        Inputs:		bHide - A flag to state whether or not to hide the users location
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Sets the users hide location flag

*********************************************************************************/
bool CUserPrivacy::UpdateHideLocation(bool bHide)
{
	// Check to make sure that we're started the update
	if (!m_bUpdateStarted && !StartUpdate())
	{
		return false;
	}
	
	// Don't add the param if it's the same as the current!
	if (m_bHideLocation == bHide)
	{
		// It's the same, just return true
		return true;
	}

	// Pass the value to the storedprocedure
	m_bHideLocationUpdated = true;
	m_bHideLocation = bHide;
	return m_SP.UpdateUserPrivacyHideLocation(bHide);
}

/*********************************************************************************

	bool CUserPrivacy::UpdateHideUserName(bool bHide)

		Author:		Mark Howitt
        Created:	10/05/2006
        Inputs:		bHide - A flag to state whether or not to hide the users user name
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Sets the users hide user name flag

*********************************************************************************/
bool CUserPrivacy::UpdateHideUserName(bool bHide)
{
	// Check to make sure that we're started the update
	if (!m_bUpdateStarted && !StartUpdate())
	{
		return false;
	}

	// Don't add the param if it's the same as the current!
	if (m_bHideUserName == bHide)
	{
		// It's the same, just return true
		return true;
	}

	// Pass the value to the storedprocedure
	m_bHideUserNameUpdated = true;
	m_bHideUserName = bHide;
	return m_SP.UpdateUserPrivacyHideUserName(bHide);
}

/*********************************************************************************

	bool CUserPrivacy::CommitChanges()

		Author:		Mark Howitt
        Created:	10/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Commits the update changes to the database

*********************************************************************************/
bool CUserPrivacy::CommitChanges()
{
	// Check to make sure we've started the update
	if (!m_bUpdateStarted)
	{
		// Report the error
		return SetDNALastError("CUserPrivacy::CommitChages","UpdatedNotStarted","Update Not Started!!!");
	}


	// Setup the action result xml
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML);
	XML.OpenTag("ACTIONS");

	// Now commit the changes if something has changed
	if (m_bHideLocationUpdated || m_bHideUserNameUpdated)
	{
		if (!m_SP.CommitUserPrivacyUpdates())
		{
			// Report the error
			return SetDNALastError("CUserPrivacy::CommitChages","FailedToCommitChanges","Failed to commit user privacy details!!!");
		}

		// If the current users id is the same as m_iCurrentUser, then update their privacy details
		CUser* pViewingUser = m_InputContext.GetCurrentUser();
		if (pViewingUser != NULL && pViewingUser->GetUserID() == m_iCurrentUser)
		{
			// Update the users details
			pViewingUser->SetUsersLocationHidden(m_bHideLocation);
			pViewingUser->SetUsersUserNameHidden(m_bHideUserName);
		}

		// Now resync the users location if it's changed
		if (m_bHideLocationUpdated)
		{
			// Update the users tagged location
			if (!ResyncUsersLocation())
			{
				// Failed! Return false
				return false;
			}

			// Add the action tag
			XML.OpenTag("ACTION",true);
			XML.AddAttribute("NAME","LOCATION");
			XML.AddIntAttribute("VALUE",m_bHideLocation,true);
			XML.CloseTag("ACTION");
		}

		// Now resync the users username if it's changed
		if (m_bHideUserNameUpdated)
		{
			// Resync if we've unhid the the users username details
			// Make sure we only resync if the current user id matches the viewing user.
			// If an editor has unhidden another users username details, then these will be resync'd when that user next logs in!
			if (!m_bHideUserName && m_iCurrentUser == pViewingUser->GetUserID())
			{
				// Resync with SSO
				if (!ResyncUserDetails())
				{
					// Failed! Return false
					return false;
				}
			}

			// Add the action tag
			XML.OpenTag("ACTION",true);
			XML.AddAttribute("NAME","HIDEUSERNAME");
			XML.AddIntAttribute("VALUE",m_bHideUserName,true);
			XML.CloseTag("ACTION");
		}
	}
	else
	{
		// Nothing was need to be done!
		XML.OpenTag("ACTION",true);
		XML.AddAttribute("NAME","NONE");
		XML.AddIntAttribute("VALUE",0,true);
		XML.CloseTag("ACTION");
	}

	// Reset the updated started member variable, close the XML and return
	XML.CloseTag("ACTIONS");
	m_bUpdateStarted = false;
	return CreateFromXMLText(sXML,NULL,true);
}

/*********************************************************************************

	bool CUserPrivacy::ResyncUsersLocation()

		Author:		Mark Howitt
        Created:	10/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Removes or retags the user to their home location.
					Also Retrieves their Area if unhidding

*********************************************************************************/
bool CUserPrivacy::ResyncUsersLocation()
{
	// Get the current viewing user
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser == NULL)
	{
		// Report the error
		return SetDNALastError("CUserPrivacy::ResyncUsersLocation","UserNotLoggedIn","User not logged in!!!");
	}

	// Setup a new User Object.
	CUser OtherUser(m_InputContext);
	CUser* pCurrentUser = NULL;
	if (m_iCurrentUser != pViewingUser->GetUserID())
	{
		// Try to initialise the user object form the current user id
		if (!OtherUser.CreateFromID(m_iCurrentUser))
		{
			// Report the error
			return SetDNALastError("CUserPrivacy::ResyncUsersLocation","FailedToCreateCurrentUserFromID","Failed to create current user form id!!!");
		}

		// Now set the current user pointer to the new user
		pCurrentUser = &OtherUser;
	}
	else
	{
		// It's the same, so make the current user the same as the viewing
		pCurrentUser = pViewingUser;
	}

	// Get the users current taxonomy node
	int iTaggedNodeId = 0;
	CTagItem TagUser(m_InputContext);
	bool bTagOk = TagUser.InitialiseFromUserId(m_iCurrentUser,m_InputContext.GetSiteID(),pViewingUser);
	if (bTagOk && pCurrentUser->GetTaxonomyNode(&iTaggedNodeId))
	{
		// Now see if we wanted to unhide. If so, re-sync with postcoder!
		if (!m_bHideLocation)
		{
			// Sychronise!
			CTDVString sPostCode;
			if (pCurrentUser->GetPostcode(sPostCode) && !sPostCode.IsEmpty())
			{
				// Update the users details from the postcode. Put the Area back!
				CPostcoder PostCode(m_InputContext);
				bool bFoundPlace = false;
				bool bAreaOk = PostCode.MakePlaceRequest(sPostCode,bFoundPlace);
				if (bAreaOk && bFoundPlace)
				{
					// Setup some local variables;
					CTDVString sAuthorityID, sAuthorityName;
					int iNodeID = 0;
					bAreaOk = bAreaOk && PostCode.PlaceHitPostcode(sPostCode,sAuthorityID,sAuthorityName,iNodeID);

					// Update the users details with the new stuff
					bAreaOk = bAreaOk && pCurrentUser->SetArea(sAuthorityName);
					bAreaOk = bAreaOk && pCurrentUser->UpdateDetails();

					// Check for Errors!
					if (!bAreaOk)
					{
						// Put the error into the page
						SetDNALastError("CUserPrivacyBuilder::Build","FailedToUpdateUsersArea","Failed to update users area!!!");
					}
					else
					{
						// Now tag the user back to their home location
						bTagOk = bTagOk && TagUser.AddTagItemToNode(iNodeID,false);
					}
				}
			}
		}
		else if (iTaggedNodeId > 0) // If ok, they must of wanted to hide! Check to see if they are tagged!
		{
			// Remove the user from this location
			bTagOk = TagUser.RemovedTagedItemFromNode(iTaggedNodeId);
		}
	}

	// Check to see if we had error with the tagging, if so add them to the page
	if (!bTagOk)
	{
		// Get the last error from the tag object
		return SetDNALastError(TagUser.GetLastErrorObject(),TagUser.GetLastErrorCode(),TagUser.GetLastErrorMessage());
	}
	return true;
}

/*********************************************************************************

	bool CUserPrivacy::ResyncUserDetails()

		Author:		Mark Howitt
        Created:	10/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Resynchronises the user details from SSO

*********************************************************************************/
bool CUserPrivacy::ResyncUserDetails()
{
	// Get the current viewing user
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser == NULL)
	{
		// Report the error
		return SetDNALastError("CUserPrivacy::ResyncUsersLocation","UserNotLoggedIn","User not logged in!!!");
	}

	// Sychronise!
	if (!pViewingUser->SynchroniseWithProfile(true))
	{
		// Put the error into the page
		return SetDNALastError(pViewingUser->GetLastErrorObject(), pViewingUser->GetLastErrorCode(), pViewingUser->GetLastErrorMessage());
	}
	return true;
}
