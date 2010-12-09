// MoveThreadForm.cpp: implementation of the CMoveThreadForm class.
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
#include "MoveThreadForm.h"
#include "InputContext.h"
#include "GuideEntry.h"
#include "User.h"
#include "TDVAssert.h"
#include "Forum.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CMoveThreadForm::CMoveThreadForm(CInputContext& inputContext) :
	CXMLObject(inputContext),
	m_pSP(NULL),
	m_InputContext(inputContext)
{
	// no further construction required
}

CMoveThreadForm::~CMoveThreadForm()
{
	// make sure SP is deleted
	delete m_pSP;
	m_pSP = NULL;
}

/*********************************************************************************

	bool CMoveThreadForm::CreateBlankForm(CUser* pViewer, bool bMoveButton, bool bCancelButton, bool bFetchButton, bool bUndoButton)

	Author:		Kim Harries
	Created:	20/12/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Creates the XML for a blank thread moving form.

*********************************************************************************/

bool CMoveThreadForm::CreateBlankForm(CUser* pViewer, bool bMoveButton, bool bCancelButton, bool bFetchButton, bool bUndoButton)
{
	TDVASSERT(m_pTree == NULL, "CMoveThreadForm::CreateBlankForm() called with non-NULL m_pTree");

	// if object is not empty then simply delete the existing tree rather than failing
	if (m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
	// build the XML for all the basic elements required
	CTDVString	sFormXML = "<MOVE-THREAD-FORM>";

	sFormXML << "<FUNCTIONS>";
	if (bMoveButton)
	{
		sFormXML << "<MOVE/>";
	}
	if (bFetchButton)
	{
		sFormXML << "<FETCH/>";
	}
	if (bCancelButton)
	{
		sFormXML << "<CANCEL/>";
	}
	if (bUndoButton)
	{
		sFormXML << "<UNDO/>";
	}
	sFormXML << "</FUNCTIONS>";
	sFormXML << "</MOVE-THREAD-FORM>";
	// create the XML tree from this text
	return CXMLObject::CreateFromXMLText(sFormXML);
}

/*********************************************************************************

	bool CMoveThreadForm::CreateFromThreadAndForumIDs(CUser* pViewer, int iThreadID, const TDVCHAR* pcDestinationID, const TDVCHAR* pcPostContent, bool bMoveButton, bool bCancelButton, bool bFetchButton, bool bUndoButton)

	Author:		Kim Harries
	Created:	20/12/2000
	Inputs:		pViewer - the user doing the move
				iThreadID - id of the thread to move
				pcDestinationID - id of the forum, article or user page to move it to
				bMoveButton - is the move button present?
				bCancelButton - is the cancel button present?
				bFetchButton - is the fetch button present?
				bUndoButton - is the undo button present?
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Creates the form for moving the given thread to the given destination.

*********************************************************************************/

bool CMoveThreadForm::CreateFromThreadAndForumIDs(CUser* pViewer, int iThreadID, const TDVCHAR* pcDestinationID, const TDVCHAR* pcPostContent, bool bMoveButton, bool bCancelButton, bool bFetchButton, bool bUndoButton)
{
	int		iForumID = 0;
	bool	bSuccess = true;
	// need to analyse the destination ID provided
	if (ExtractForumID(pcDestinationID, &iForumID))
	{
		// then call the other CreateFromThreadAndForumIDs method with this ID
		bSuccess = bSuccess && CreateFromThreadAndForumIDs(pViewer, iThreadID, iForumID, pcPostContent, bMoveButton, bCancelButton, bFetchButton, bUndoButton);
	}
	else
	{
		// if extracting forum ID failed then create a forum using a forum ID of zero
		bSuccess = bSuccess && CreateFromThreadAndForumIDs(pViewer, iThreadID, 0, pcPostContent, bMoveButton, bCancelButton, bFetchButton, bUndoButton);
	}
	// then return success value
	return bSuccess;
}

/*********************************************************************************

	bool CMoveThreadForm::CreateFromThreadAndForumIDs(CUser* pViewer, int iThreadID, int iForumID, const TDVCHAR* pcPostContent, bool bMoveButton, bool bCancelButton, bool bFetchButton, bool bUndoButton)

	Author:		Kim Harries
	Created:	20/12/2000
	Inputs:		pViewer - the user doing the move
				iThreadID - id of the thread to move
				iForumID - id of the forum to move it to
				bMoveButton - is the move button present?
				bCancelButton - is the cancel button present?
				bFetchButton - is the fetch button present?
				bUndoButton - is the undo button present?
	Outputs:	-
	Returns:	true for success or false for failure
	Purpose:	Creates the form for moving the given thread to the given forum.

*********************************************************************************/

bool CMoveThreadForm::CreateFromThreadAndForumIDs(CUser* pViewer, int iThreadID, int iForumID, const TDVCHAR* pcPostContent, bool bMoveButton, bool bCancelButton, bool bFetchButton, bool bUndoButton)
{
	TDVASSERT(pViewer != NULL && pViewer->GetIsEditor(), "CMoveThreadForm::CreateFromThreadAndForumIDs(...) called with NULL user or non-editor");

	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		return false;
	}

	// create the SP if we don't already have one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if the ptr is still NULL then fail horribly
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Failed to create SP in CMoveThreadForm::CreateFromThreadAndForumIDs(...)");
		return false;
	}
	// if object is not empty then simply delete the existing tree rather than failing
	if (m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
	// now proceed to fetch the details on the relevant forums
	CTDVString		sFormXML = "<MOVE-THREAD-FORM>";
	CTDVString		sPostContent = pcPostContent;
	CTDVString		sThreadSubject;
	CTDVString		sOldForumTitle;
	CTDVString		sNewForumTitle;
	int				iOldForumID = 0;
	bool			bSuccess = true;

	// call the SP
	bSuccess = bSuccess && m_pSP->FetchThreadMoveDetails(iThreadID, iForumID);
	// get the fields returned
	iOldForumID = m_pSP->GetIntField("OldForumID");
	m_pSP->GetField("ThreadSubject", sThreadSubject);
	m_pSP->GetField("OldForumTitle", sOldForumTitle);
	m_pSP->GetField("NewForumTitle", sNewForumTitle);

	CXMLObject::EscapeXMLText(&sThreadSubject);
	CXMLObject::EscapeXMLText(&sOldForumTitle);
	CXMLObject::EscapeXMLText(&sNewForumTitle);

	sFormXML << "<THREAD-ID>" << iThreadID << "</THREAD-ID>";
	sFormXML << "<THREAD-SUBJECT>" << sThreadSubject << "</THREAD-SUBJECT>";
	sFormXML << "<OLD-FORUM-ID>" << iOldForumID << "</OLD-FORUM-ID>";
	sFormXML << "<NEW-FORUM-ID>" << iForumID << "</NEW-FORUM-ID>";
	sFormXML << "<OLD-FORUM-TITLE>" << sOldForumTitle << "</OLD-FORUM-TITLE>";
	sFormXML << "<NEW-FORUM-TITLE>" << sNewForumTitle << "</NEW-FORUM-TITLE>";
	sFormXML << "<POST-CONTENT>" << sPostContent << "</POST-CONTENT>";
	sFormXML << "<FUNCTIONS>";
	if (bMoveButton)
	{
		sFormXML << "<MOVE/>";
	}
	if (bCancelButton)
	{
		sFormXML << "<CANCEL/>";
	}
	if (bFetchButton)
	{
		sFormXML << "<FETCH/>";
	}
	if (bUndoButton)
	{
		sFormXML << "<UNDO/>";
	}
	sFormXML << "</FUNCTIONS>";

	// Get the Title for the Forum. This could contain the List of possible forums to move to
	CForum TempForum(m_InputContext);
	if (TempForum.GetTitle(iForumID,iThreadID))
	{
		TempForum.GetAsString(sFormXML);
	}

	sFormXML << "</MOVE-THREAD-FORM>";

	// create the XML tree from this text
	return CXMLObject::CreateFromXMLText(sFormXML);
}

/*********************************************************************************

	bool CMoveThreadForm::MoveThread(CUser* pViewer, int iThreadID, const TDVCHAR* pcDestinationID, const TDVCHAR* pcPostContent, bool* pbUpdateOK, bool bMoveButton, bool bCancelButton, bool bFetchButton, bool bUndoButton)

	Author:		Kim Harries
	Created:	09/01/2001
	Inputs:		pViewer - the user doing the move
				iThreadID - id of the thread to move
				pcDestinationID - id of the forum, article, or user page to move it to
	Outputs:	pbUpdateOkay - stores whether the move was successful or not
	Returns:	true for success or false for failure
	Purpose:	Moves the given thread from its current forum to the one specified.
				Also creates the form XML indicating whether or not the move was
				successful.

*********************************************************************************/

bool CMoveThreadForm::MoveThread(CUser* pViewer, int iThreadID, const TDVCHAR* pcDestinationID, const TDVCHAR* pcPostContent, bool* pbUpdateOK, bool bMoveButton, bool bCancelButton, bool bFetchButton, bool bUndoButton)
{
	int		iForumID = 0;
	bool	bSuccess = true;
	// need to analyse the destination ID provided
	if (ExtractForumID(pcDestinationID, &iForumID))
	{
		// then call the other MoveThread method with this ID
		bSuccess = bSuccess && MoveThread(pViewer, iThreadID, iForumID, pcPostContent, pbUpdateOK, bMoveButton, bCancelButton, bFetchButton, bUndoButton);
	}
	else
	{
		// if extracting forum ID failed then create a form using forum ID of zero
		// and provide some kind of error message
		bSuccess = bSuccess && CreateFromThreadAndForumIDs(pViewer, iThreadID, 0, pcPostContent);
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", "<SUCCESS>0</SUCCESS>");
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", "<ERROR TYPE='INVALID-DESTINATION'>The destination specified was invalid</ERROR>");
	}
	// then return success value
	return bSuccess;
}

/*********************************************************************************

	bool CMoveThreadForm::MoveThread(CUser* pViewer, int iThreadID, int iForumID, const TDVCHAR* pcPostContent, bool* pbUpdateOK, bool bMoveButton, bool bCancelButton, bool bFetchButton, bool bUndoButton)

	Author:		Kim Harries
	Created:	20/12/2000
	Inputs:		pViewer - the user doing the move
				iThreadID - id of the thread to move
				iForumID - id of the forum to move it to
	Outputs:	pbUpdateOkay - stores whether the move was successful or not
	Returns:	true for success or false for failure
	Purpose:	Moves the given thread from its current forum to the one specified.
				Also creates the form XML indicating whether or not the move was
				successful.

*********************************************************************************/

bool CMoveThreadForm::MoveThread(CUser* pViewer, int iThreadID, int iForumID, const TDVCHAR* pcPostContent, bool* pbUpdateOK, bool bMoveButton, bool bCancelButton, bool bFetchButton, bool bUndoButton)
{
	TDVASSERT(pViewer != NULL && pViewer->GetIsEditor(), "CMoveThreadForm::MoveThread(...) called with NULL user or non-editor");

	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		return false;
	}

	// create the SP if we don't already have one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if the ptr is still NULL then fail horribly
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Failed to create SP in CMoveThreadForm::MoveThread(...)");
		return false;
	}

	CTDVString	sPostContent = pcPostContent;
	CTDVString	sThreadSubject;
	CTDVString	sOldForumTitle;
	CTDVString	sNewForumTitle;
	int			iOldForumID = 0;
	CTDVString	sXML;
	int			iPostID = 0;
	bool		bUpdateOK = true;
	bool		bSuccess = true;


	if (DoesMoveInvolveReviewForum(*pViewer,iThreadID,iForumID, *m_pSP))
	{
		return true;
	}

	// call the SP to do the move
	bSuccess = bSuccess && m_pSP->MoveThread(iThreadID, iForumID);
	// find if the update was successful
	bUpdateOK = m_pSP->GetBoolField("Success");
	// if we have an output variable then set it value
	if (pbUpdateOK != NULL)
	{
		*pbUpdateOK = bUpdateOK;
	}
	// get the titles of the forums moved from and to
	m_pSP->GetField("OldForumTitle", sOldForumTitle);
	m_pSP->GetField("NewForumTitle", sNewForumTitle);
	m_pSP->GetField("ThreadSubject", sThreadSubject);
	iOldForumID = m_pSP->GetIntField("OldForumID");
	// if update worked then also post to the thread saying it has been moved
	// don't post though if thread was junked
	if (bUpdateOK && iForumID != 1 && iOldForumID !=1)
	{
		CTDVString	sSubject;
		CTDVString	sBody;

		sSubject = "Thread Moved";
		sBody = "Editorial Note: This conversation has been moved from '";
		sBody << sOldForumTitle << "' to '" << sNewForumTitle << "'.";
		if (sPostContent.GetLength() > 0)
		{
			sBody << "\n\n" << sPostContent;
		}
		int iAutoMessageUserID = 294;
		iAutoMessageUserID = m_InputContext.GetAutoMessageUserID(m_InputContext.GetSiteID());
		bSuccess = bSuccess && m_pSP->PostToEndOfThread(iAutoMessageUserID, iThreadID, sSubject, sBody, &iPostID);
	}
	// add XML for the forum titles
	// first create the XML for a blank form
	// don't show undo button if the move failed
	if (bUpdateOK)
	{
		bUndoButton = true;
	}
	else
	{
		bUndoButton = false;
	}
	bSuccess = bSuccess && CreateBlankForm(pViewer, bMoveButton, bCancelButton, bFetchButton, bUndoButton);
	// add success flag
	if (*pbUpdateOK)
	{
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", "<SUCCESS>1</SUCCESS>");
	}
	else
	{
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", "<SUCCESS>0</SUCCESS>");
		// if failed because destination was the same as current location
		// then indicate this in an error message
		if (iForumID == iOldForumID)
		{
			bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", "<ERROR TYPE='SAME-FORUM'>Destination was the same as current location</ERROR>");
		}
	}
	CXMLObject::EscapeXMLText(&sThreadSubject);
	CXMLObject::EscapeXMLText(&sOldForumTitle);
	CXMLObject::EscapeXMLText(&sNewForumTitle);

	// add the XML for the thread and forum IDs
	sXML = "";
	sXML << "<THREAD-ID>" << iThreadID << "</THREAD-ID>";
	bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
	sXML = "";
	sXML << "<OLD-FORUM-ID>" << iOldForumID << "</OLD-FORUM-ID>";
	bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
	sXML = "";
	sXML << "<NEW-FORUM-ID>" << iForumID << "</NEW-FORUM-ID>";
	bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
	// add the XML for the titles of the old and new forums
	sXML = "";
	sXML << "<THREAD-SUBJECT>" << sThreadSubject << "</THREAD-SUBJECT>";
	bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
	sXML = "";
	sXML << "<OLD-FORUM-TITLE>" << sOldForumTitle << "</OLD-FORUM-TITLE>";
	bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
	sXML = "";
	sXML << "<NEW-FORUM-TITLE>" << sNewForumTitle << "</NEW-FORUM-TITLE>";
	bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
	sXML = "";
	sXML << "<AUTO-POST-ID>" << iPostID << "</AUTO-POST-ID>";
	bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
	sXML = "";
	sXML << "<POST-CONTENT>" << sPostContent << "</POST-CONTENT>";
	bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
	// no need to delete m_pSP as this is done in the destructor
	return bSuccess;
}

/*********************************************************************************

	bool CMoveThreadForm::UndoThreadMove(CUser* pViewer, int iThreadID, bool* pbUpdateOK)

	Author:		Kim Harries
	Created:	09/01/2001
	Inputs:		pViewer - the user doing the move
				iThreadID - id of the thread to move back
				iPostID - id of the automatic post made during the move
	Outputs:	pbUpdateOkay - stores whether the undo was successful or not
	Returns:	true for success or false for failure
	Purpose:	Undoes the move of the given thread from and returns it to its
				original forum, also removing the automatic posting that is appended
				to the end of the thread when it is moved. Also creates the form
				XML indicating whether or not the undo was successful.

*********************************************************************************/

bool CMoveThreadForm::UndoThreadMove(CUser* pViewer, int iThreadID, int iPostID, bool* pbUpdateOK)
{
	TDVASSERT(pViewer != NULL && pViewer->GetIsEditor(), "CMoveThreadForm::UndoThreadMove(...) called with NULL user or non-editor");

	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		return false;
	}
	// create the SP if we don't already have one
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if the ptr is still NULL then fail horribly
	if (m_pSP == NULL)
	{
		TDVASSERT(false, "Failed to create SP in CMoveThreadForm::UndoThreadMove(...)");
		return false;
	}

	bool	bSuccess = true;
	// call the SP to do the move
	bSuccess = bSuccess && m_pSP->UndoThreadMove(iThreadID, iPostID);
	// if we have an output variable then set it value
	if (pbUpdateOK != NULL)
	{
		*pbUpdateOK = m_pSP->GetBoolField("Success");
	}
	// add XML for the forum titles
	CTDVString	sThreadSubject;
	CTDVString	sCurrentForumTitle;
	CTDVString	sOriginalForumTitle;
	int			iCurrentForumID = 0;
	int			iOriginalForumID = 0;
	CTDVString	sXML;
	// get the titles of the forums moved from and to
	m_pSP->GetField("CurrentForumTitle", sCurrentForumTitle);
	m_pSP->GetField("OriginalForumTitle", sOriginalForumTitle);
	m_pSP->GetField("ThreadSubject", sThreadSubject);
	iCurrentForumID = m_pSP->GetIntField("CurrentForumID");
	iOriginalForumID = m_pSP->GetIntField("OriginalForumID");
	// now create the XML for the form
	bSuccess = bSuccess && CreateBlankForm(pViewer);
	// add success flag
	if (*pbUpdateOK)
	{
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", "<SUCCESS>1</SUCCESS>");
	}
	else
	{
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", "<SUCCESS>0</SUCCESS>");
	}

	CXMLObject::EscapeXMLText(&sThreadSubject);
	CXMLObject::EscapeXMLText(&sCurrentForumTitle);
	CXMLObject::EscapeXMLText(&sOriginalForumTitle);

	// add the XML for the thread and forum IDs
	sXML = "";
	sXML << "<THREAD-ID>" << iThreadID << "</THREAD-ID>";
	bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
	sXML = "";
	sXML << "<OLD-FORUM-ID>" << iCurrentForumID << "</OLD-FORUM-ID>";
	bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
	sXML = "";
	sXML << "<NEW-FORUM-ID>" << iOriginalForumID << "</NEW-FORUM-ID>";
	bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
	// add the XML for the titles of the old and new forums
	sXML = "";
	sXML << "<THREAD-SUBJECT>" << sThreadSubject << "</THREAD-SUBJECT>";
	bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
	sXML = "";
	sXML << "<OLD-FORUM-TITLE>" << sCurrentForumTitle << "</OLD-FORUM-TITLE>";
	bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
	sXML = "";
	sXML << "<NEW-FORUM-TITLE>" << sOriginalForumTitle << "</NEW-FORUM-TITLE>";
	bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
	// no need to delete m_pSP as this is done in the destructor
	return bSuccess;
}

/*********************************************************************************

	bool CMoveThreadForm::ExtractForumID(const TDVCHAR* pcDestinationID, int* piForumID)

	Author:		Kim Harries
	Created:	09/01/2001
	Inputs:		pcDestinationID - the destination forum, article or user page ID
	Outputs:	piForumID - the forum ID associated with that destination
	Returns:	true for success or false for failure
	Purpose:	Extracts the relevant forum ID, if any, for the given forum, article
				or user page. If the string is badly formed or there is no relevant
				forum it return false for failure and sets the piForumID output variable
				to zero.

*********************************************************************************/

bool CMoveThreadForm::ExtractForumID(const TDVCHAR* pcDestinationID, int* piForumID)
{
	TDVASSERT(piForumID != NULL, "NULL piForumID output variable in CMoveThreadForm::ExtractForumID(...)");

	CTDVString	sDestinationID = pcDestinationID;
	int			iLength = sDestinationID.GetLength();
	int			iForumID = 0;
	bool		bSuccess = true;

	// turn the string to all upper case for convenience
	sDestinationID.MakeUpper();
	// can't extract an ID if there is nothing there
	if (iLength == 0)
	{
		bSuccess = false;
	}
	// find out what sort of ID we have been given
	if (bSuccess && sDestinationID.GetAt(0) == 'F')
	{
		// need at least one digit after the prefix
		if (iLength > 1)
		{
			// just strip off the prefix and we have the forum ID
			iForumID = atoi(sDestinationID.Mid(1));
		}
		if (iForumID <= 0)
		{
			bSuccess = false;
		}
	}
	else
	{
		// create the SP if we don't already have one
		if (m_pSP == NULL)
		{
			m_pSP = m_InputContext.CreateStoredProcedureObject();
		}
		// if the ptr is still NULL then fail horribly
		if (m_pSP == NULL)
		{
			TDVASSERT(false, "Failed to create SP in CMoveThreadForm::ExtractForumID(...)");
			bSuccess = false;
		}
		// now get the forum id depending on whether it is a userpage or an article
		// will first need to get the h2g2ID
		int	ih2g2ID = 0;
		// if a user number then first we need to find if they have a masthead
		if (bSuccess && sDestinationID.GetAt(0) == 'U' && iLength > 1)
		{
			// a user ID
			int	iUserID = atoi(sDestinationID.Mid(1));

			// get the users details
			bSuccess = bSuccess && m_pSP->GetUserFromUserID(iUserID);
			// get the h2g2ID for that users homepage
			if (bSuccess)
			{
				ih2g2ID = m_pSP->GetIntField("Masthead");
			}
		}
		else if (bSuccess)
		{
			// assume an article ID
			// if there is an A prefix then strip it off
			if (sDestinationID.GetAt(0) == 'A')
			{
				sDestinationID = sDestinationID.Mid(1);
			}
			// need at least one digit
			if (sDestinationID.GetLength() > 0)
			{
				// what's left should be the h2g2ID
				ih2g2ID = atoi(sDestinationID);
			}
			else
			{
				bSuccess = false;
			}
		}
		// some dummy parameters are needed
		int				iEntryID, iEditorID, iStatus, iStyle;
		CTDVDateTime	dtDateCreated;
		CTDVDateTime	dtLastUpdated;
		CTDVString		sSubject, sText;
		int				iHidden		= 0;
		int				iSiteID		= 0;
		int				iSubmittable= 0;
		int				iTypeID		= 0;
		int				iModerationStatus = 0;
		bool			bIsPreProcessed = true;
		bool			bCanRead, bCanWrite, bCanChangePermissions;
		int				iTopicID = 0;
		int				iBoardPromoID = 0;
		CTDVDateTime dtRangeStartDate;
		CTDVDateTime dtRangeEndDate;
		int iRangeInterval = 0;

		CExtraInfo ExtraInfo;
		// check if we have a sensible h2g2ID
		bSuccess = bSuccess && CGuideEntry::IsValidChecksum(ih2g2ID);
		int iLocationCount = 0;
		bSuccess = bSuccess && m_pSP->FetchGuideEntry(ih2g2ID, ih2g2ID, iEntryID, iEditorID, iForumID, iStatus, iStyle, dtDateCreated, sSubject, sText, iHidden, iSiteID, iSubmittable, ExtraInfo, iTypeID, iModerationStatus, dtLastUpdated, bIsPreProcessed, bCanRead, bCanWrite, bCanChangePermissions, iTopicID, iBoardPromoID, dtRangeStartDate, dtRangeEndDate, iRangeInterval,
			iLocationCount);
	}
	// if forum ID is zero then fail
	if (iForumID <= 0)
	{
		bSuccess = false;
	}
	// now set the ouput variable if provided
	if (piForumID != NULL)
	{
		if (bSuccess)
		{
			*piForumID = iForumID;
		}
		else
		{
			*piForumID = 0;
		}
	}
	// return the success value
	return bSuccess;
}

/*********************************************************************************

	bool CMoveThreadForm::DoesMoveInvolveReviewForum(CUser& mViewer,int iThreadID,int iDestinationForumID, CStoredProcedure& mSP)

	Author:		Dharmesh Raithatha
	Created:	10/4/01
	Inputs:		mViewer - a the current user
				iThreadID - the thread that wants to be moved
				iDestinationForumID - the destinationForum
				mSP - A valid Stored Procedure object
	Outputs:	-
	Returns:	true if the destination or the original forum is a review forum 
	Purpose:	checks if a review forum is where the thread originated from or is the destination
				and creates a correct form with the appropriate error message

*********************************************************************************/

bool CMoveThreadForm::DoesMoveInvolveReviewForum(CUser& mViewer,int iThreadID,int iDestinationForumID, CStoredProcedure& mSP)
{
	
	//Forum where the thread currently is
	int iOldForumID = 0;
	int iReviewForumID = 0;
	bool bSuccess = true;

	if (!mSP.GetForumFromThreadID(iThreadID,&iOldForumID))
	{
		bSuccess = bSuccess && CreateBlankForm(&mViewer, false, true, false, false);
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", "<SUCCESS>0</SUCCESS>");
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", "<ERROR TYPE='BadForum'>Can't Find Original Forum For Thread</ERROR>");
		return bSuccess;
	}

	if (mSP.IsForumAReviewForum(iOldForumID,&iReviewForumID))
	{
		bSuccess = bSuccess && CreateBlankForm(&mViewer, false, true, false, false);
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", "<SUCCESS>0</SUCCESS>");
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", "<ERROR TYPE='FROMREVIEW'>Please move the thread out of the review forum</ERROR>");
		CTDVString sXML = "";
		sXML << "<THREAD-ID>" << iThreadID << "</THREAD-ID>";
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
		sXML = "";
		sXML << "<OLD-FORUM-ID>" << iOldForumID << "</OLD-FORUM-ID>";
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
		sXML = "";
		sXML << "<NEW-FORUM-ID>" << 0 << "</NEW-FORUM-ID>";
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);

		return bSuccess;
	}

	if (mSP.IsForumAReviewForum(iDestinationForumID,&iReviewForumID))
	{
		bSuccess = bSuccess && CreateBlankForm(&mViewer, false, true, true, false);
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", "<SUCCESS>0</SUCCESS>");
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", "<ERROR TYPE='TOREVIEW'>You cannot move a thread to a review forum.</ERROR>");
		CTDVString sXML = "";
		sXML << "<THREAD-ID>" << iThreadID << "</THREAD-ID>";
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
		sXML = "";
		sXML << "<OLD-FORUM-ID>" << iOldForumID << "</OLD-FORUM-ID>";
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
		sXML = "";
		sXML << "<NEW-FORUM-ID>" << 0 << "</NEW-FORUM-ID>";
		bSuccess = bSuccess && AddInside("MOVE-THREAD-FORM", sXML);
		return bSuccess;
	}

	return false;
	
}

#endif // _ADMIN_VERSION
