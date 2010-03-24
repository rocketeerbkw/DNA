// EditPostPageBuilder.cpp: implementation of the CEditPostPageBuilder class.
//
//////////////////////////////////////////////////////////////////////

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
#include "EditPostPageBuilder.h"
#include "WholePage.h"
#include "PageUI.h"
#include "TDVAssert.h"
#include "ProfanityFilter.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CEditPostPageBuilder::CEditPostPageBuilder(CInputContext& inputContext)
	Author:		Kim Harries
	Created:	16/02/2001
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CEditPostPageBuilder object.

*********************************************************************************/

CEditPostPageBuilder::CEditPostPageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext),
	m_ForumPostEditForm(inputContext),
	m_sCommand("View")
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************

	CEditPostPageBuilder::~CEditPostPageBuilder()

	Author:		Kim Harries
	Created:	16/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CEditPostPageBuilder::~CEditPostPageBuilder()
{
}

/*********************************************************************************

	CWholePage* CEditPostPageBuilder::Build()

	Author:		Kim Harries
	Created:	16/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the moderation home page.

*********************************************************************************/

bool CEditPostPageBuilder::Build(CWholePage* pWholePage)
{
	CUser*			pViewer = NULL;
	bool			bSuccess = true;
	// allocate memory for objects - must catch any exceptions thrown by new
	// get the viewing user
	pViewer = m_InputContext.GetCurrentUser();
	// initialise the whole page object and set the page type
	bSuccess = InitPage(pWholePage, "EDIT-POST",false);
	// do an error page if not an editor or moderator
	// otherwise proceed with the processing
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsModerator()))
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit forum postings unless you are logged in as an Editor.</ERROR>");
	}
	else
	{
		CTDVString	sFormXML = "";
		// get the command and post ID parameters, if any

		if (m_InputContext.ParamExists("Update"))
		{
			m_sCommand = "Update";
		}
		else if (m_InputContext.ParamExists("Cancel"))
		{
			m_sCommand = "Cancel";
		}
		else if (m_InputContext.ParamExists("ListBBCUIDUsers"))
		{
			m_sCommand = "ListBBCUIDUsers";
		}
		else
		{
			m_sCommand = "View";
		}

		// Get the postid and setup EditForm if the id is not 0
		int iPostID = m_InputContext.GetParamInt("PostID");

		// If the postid is 0, check to see if we were called using a modid
		if (iPostID == 0 && m_InputContext.ParamExists("modid"))
		{
			// Check to see if the post is in the PreModPostings table.
			// If so, create it and get the postid
			int iModID = m_InputContext.GetParamInt("modid");
			CStoredProcedure SP;
			if (m_InputContext.InitialiseStoredProcedureObject(&SP) && SP.CheckPreModPostingExists(iModID,true) && !SP.IsEOF())
			{
				// Get the id of the post it just created
				iPostID = SP.GetIntField("postid");
			}
			else
			{
				// Put an error into the page
				SetDNALastError("CEditPostPageBuilder::Build","FailedToCreatePreModPostingEntryFromModID","Failed to create PreModPosting Entry From ModID!!!");
				pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
			}
		}

		// Use the post id to set up the form
		m_ForumPostEditForm.SetPostID( iPostID );
		if (iPostID > 0)
		{
			bSuccess = bSuccess && ProcessSubmission(pViewer);
		}

		// create the XML for the form
		bSuccess = bSuccess && m_ForumPostEditForm.Build();

		// and insert it into the page
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", &m_ForumPostEditForm);
		if (m_ForumPostEditForm.ErrorReported())
		{
			pWholePage->AddInside("H2G2", m_ForumPostEditForm.GetLastErrorAsXMLString());
		}
	}
	// make sure any unneeded objects are deleted then return the success value
	TDVASSERT(bSuccess, "CEditPostPageBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CEditPostPageBuilder::ProcessSubmission(CUser* pViewer)

	Author:		Kim Harries
	Created:	16/02/2001
	Inputs:		pViewer
	Outputs:	-
	Returns:	true if successful
	Purpose:	Processes any form submission.

*********************************************************************************/

bool CEditPostPageBuilder::ProcessSubmission(CUser* pViewer)
{
	TDVASSERT(pViewer != NULL, "NULL pViewer in CEditPostPageBuilder::ProcessSubmission(...)");
	// fail if no viewing user
	if (pViewer == NULL)
	{
		return false;
	}
	CTDVString	sSubject = "";
	CTDVString	sText = "";
	bool		bSuccess = true;

	if (m_sCommand.CompareText("Update"))
	{
		// if an update command then update the post
		// first get the new subject and text
		bSuccess = bSuccess && m_InputContext.GetParamString("Subject", sSubject);
		bSuccess = bSuccess && m_InputContext.GetParamString("Text", sText);
		// now call the update SP
		bSuccess = bSuccess && m_ForumPostEditForm.ProcessForumPostUpdate(pViewer,sSubject, sText, NULL, false, false, true);

		if(pViewer->GetIsEditor())
		{
			// finally hide or unhide post if requested
			bool bHidePost = m_InputContext.ParamExists("HidePost");

			if (bHidePost)
			{
				bSuccess = bSuccess && m_ForumPostEditForm.HidePost();
			}
			else
			{
				bSuccess = bSuccess && m_ForumPostEditForm.UnhidePost();
			}
		}

		// if successful then put in a message to that effect
		if (bSuccess)
		{
			m_ForumPostEditForm.AddStatusMessage("<MESSAGE TYPE='UPDATE-OK'>Post updated successfully</MESSAGE>");
		}
	}
	else if (m_sCommand.CompareText("Cancel"))
	{
		m_ForumPostEditForm.Cancel();
	}
	else if (m_sCommand.CompareText("ListBBCUIDUsers"))
	{
		if(pViewer->GetIsSuperuser())
		{
			m_ForumPostEditForm.IncludeUserPostDetailsViaBBCUID();
		}
	}
	return bSuccess;
}

#endif // _ADMIN_VERSION
