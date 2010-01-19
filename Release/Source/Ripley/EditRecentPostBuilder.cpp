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

*/

#include "stdafx.h"
#include "EditRecentPostBuilder.h"
#include "GuideEntry.h"

CEditRecentPostBuilder::CEditRecentPostBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext),
	m_ForumPostEditForm(inputContext)
{
}

CEditRecentPostBuilder::~CEditRecentPostBuilder()
{
}

bool CEditRecentPostBuilder::Build(CWholePage* pPage)
{
	bool bSuccess = InitPage(pPage, "EDIT-RECENT-POST",false);

	CUser* pViewer = m_InputContext.GetCurrentUser();
	if ( !pViewer )
	{
		SetDNALastError("EditRecentPostBuilder", "NotLoggedIn", "User not logged in.");
		pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return true;
	}

	// Check to see if the site is closed
	bool bSiteClosed = false;
	if (!m_InputContext.IsSiteClosed(m_InputContext.GetSiteID(),bSiteClosed))
	{
		SetDNALastError("CEditRecentPostBuilder::Build", "FailedGettingSiteDetails", "Failed to get site details.");
		pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return true;
	}
	if (bSiteClosed && !pViewer->GetIsEditor())
	{
		SetDNALastError("CEditRecentPostBuilder::Build", "SiteClosed", "Site is currently closed!!!");
		pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return true;
	}

	// Initialise edit form
	//
	int iPostID = m_InputContext.GetParamInt("PostID");
	if (iPostID <= 0)
	{
		SetDNALastError("EditRecentPostBuilder", "INPUTPARAMS", "Please supply a valid PostID");
		pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return true;
	}

	// Get the Guide Entry details
	//
	int iH2G2ID = m_InputContext.GetParamInt("H2G2ID");

	bool bIsGuideEntryOwner = false;

	m_ForumPostEditForm.SetPostID( iPostID );
	if ( !m_ForumPostEditForm.LoadPostDetails() )
	{
		pPage->AddInside("H2G2",m_ForumPostEditForm.GetLastErrorAsXMLString());
		return true;
	}

	if (iH2G2ID > 0 && m_InputContext.DoesSiteAllowOwnerHiding(m_ForumPostEditForm.GetSiteID()))
	{
		int iOwnerID = 0;
		int iGuideEntryForumID = 0;
		//The Owner of the Guide Entry is trying to hide a post
		CGuideEntry::GetGuideEntryOwner(m_InputContext, iH2G2ID, iOwnerID, iGuideEntryForumID);
		bIsGuideEntryOwner = (pViewer->GetUserID() == iOwnerID && iGuideEntryForumID == m_ForumPostEditForm.GetForumID());
	}
	else
	{
		// Check user has permissions
		if (!m_ForumPostEditForm.CheckUserCanEditRecentPost())
		{
			SetDNALastError("EditRecentPostBuilder", "CANTEDIT", "Unable to edit post - Invalid permissions/post no longer editable.");
			pPage->AddInside("H2G2", GetLastErrorAsXMLString());
			return true;
		}
	}

	
	if (m_InputContext.ParamExists("Update"))
	{
		CTDVString sSubject, sText;
		bSuccess = bSuccess && m_InputContext.GetParamString("Subject", sSubject);
		bSuccess = bSuccess && m_InputContext.GetParamString("Text", sText);

		// Check content
		CForumPostEditForm::PostUpdateError errorType;
		if (m_ForumPostEditForm.ValidatePostDetails(sSubject, sText, errorType))
		{
			// Does it require premoderation?
			bool bForceModerateAndHide = false;
			if (errorType == CForumPostEditForm::CONTAINSPROFANITIES)
			{
				bForceModerateAndHide = true;
			}

			bSuccess = bSuccess && m_ForumPostEditForm.ProcessForumPostUpdate(pViewer,sSubject, sText, NULL, true, bForceModerateAndHide,false);

			if (bSuccess)
			{
				m_ForumPostEditForm.AddStatusMessage("<MESSAGE TYPE='UPDATE-OK'>Post updated successfully</MESSAGE>");
			}
		}
	}
	else if ( m_InputContext.ParamExists("Hide") )
	{
		//Hide the entire thread if user is author 
		if (m_ForumPostEditForm.GetUserId() == pViewer->GetUserID() || bIsGuideEntryOwner )
		{
			if ( m_ForumPostEditForm.HidePost(CStoredProcedure::HIDDENSTATUSUSERHIDDEN) )
				m_ForumPostEditForm.AddStatusMessage("<MESSAGE TYPE='HIDE-OK'>Post hidden successfully</MESSAGE>");
		}
		else
		{
			pPage->AddInside("H2G2",CreateErrorXMLString("EditRecentPostBuilder","Hide","User not author - Hide Failed."));
		}
	}
	else if ( m_InputContext.ParamExists("UnHide") )
	{
		//Allow UnHide if user is author.
		if (m_ForumPostEditForm.GetUserId() == pViewer->GetUserID() || bIsGuideEntryOwner)
		{
			if ( m_ForumPostEditForm.UnhidePost() )
				m_ForumPostEditForm.AddStatusMessage("<MESSAGE TYPE='UNHIDE-OK'>Post unhidden successfully</MESSAGE>");
		}
		else
		{
			pPage->AddInside("H2G2",CreateErrorXMLString("EditRecentPostBuilder","Hide","User not author - Hide Failed."));
		}
	}
	else if (m_InputContext.ParamExists("Cancel"))
	{
		m_ForumPostEditForm.Cancel();
	}
	else if ( m_InputContext.ParamExists("Preview") )
	{
		//Validate user-input and setup PostEditForm with preview data.
		CTDVString sSubject;
		CTDVString sText;
		CForumPostEditForm::PostUpdateError errorType;
		if ( !m_InputContext.GetParamString("Text", sText) || !m_InputContext.GetParamString("Subject",sSubject) )
		{
			SetDNALastError("CEditRecentPost::Build","Invalid Parameters","Invalid parameters provided for Preview");
			pPage->AddInside("H2G2",GetLastErrorAsXMLString());
		}
		else if ( m_ForumPostEditForm.ValidatePostDetails(sSubject, sText, errorType) )
		{
			m_ForumPostEditForm.SetPreviewSubject(sSubject);
			m_ForumPostEditForm.SetPreviewText(sText);
		}
	}

	if (m_ForumPostEditForm.Build())
	{
		pPage->AddInside("H2G2", &m_ForumPostEditForm);
	}

	// Add any errors
	if (m_ForumPostEditForm.ErrorReported())
	{
		pPage->AddInside("H2G2", m_ForumPostEditForm.GetLastErrorAsXMLString());
	}

	return true;
}
