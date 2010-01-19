// SubEditorAllocationPageBuilder.cpp: implementation of the CSubEditorAllocationPageBuilder class.
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
#include "SiteData.h"
#include "SubEditorAllocationPageBuilder.h"
#include "SubAllocationForm.h"
#include "SubNotificationEmail.h"
#include "WholePage.h"
#include "PageUI.h"
#include "ArticleList.h"
#include "UserList.h"
#include "TDVAssert.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CSubEditorAllocationPageBuilder::CSubEditorAllocationPageBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	15/11/2000
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CSubEditorAllocationPageBuilder object.

*********************************************************************************/

CSubEditorAllocationPageBuilder::CSubEditorAllocationPageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************

	CSubEditorAllocationPageBuilder::~CSubEditorAllocationPageBuilder()

	Author:		Kim Harries
	Created:	15/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CSubEditorAllocationPageBuilder::~CSubEditorAllocationPageBuilder()
{
}

/*********************************************************************************

	CWholePage* CSubEditorAllocationPageBuilder::Build()

	Author:		Kim Harries
	Created:	15/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for a sub editor allocation page, and processes
				requests to allocate entries to subs.

*********************************************************************************/

bool CSubEditorAllocationPageBuilder::Build(CWholePage* pWholePage)
{
	CUser*					pViewer = NULL;
	CTDVString				sCommand;
	bool					bSuccess = true;

	CSubAllocationForm		Form(m_InputContext);

	// get the viewing user
	pViewer = m_InputContext.GetCurrentUser();
	// initiliase the whole page object and set the page type
	bSuccess = InitPage(pWholePage, "SUB-ALLOCATION",true);
	// do an error page if not an editor
	// otherwise proceed with the process recommendation page
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot allocate recommended entries to sub editors unless you are logged in as an Editor.</ERROR>");
	}
	else
	{
		// get the command from the request
		if (!m_InputContext.GetParamString("Command", sCommand))
		{
			// if no command then assume just viewing
			sCommand = "View";
		}
		// initialise the form object
		bSuccess = bSuccess && Form.Initialise();
		if (sCommand.CompareText("View"))
		{
			// do nothing for simple view requests
		}
		else if (sCommand.CompareText("NotifySubs"))
		{
			// if this is a notification request then send the notification emails
			bSuccess = bSuccess && SendNotificationEmails(Form);
		}
		else
		{
			// else process any submission of allocated entries
			bSuccess = bSuccess && ProcessAllocationSubmission(pViewer, sCommand, Form);
		}
		// after doing any processing requests get all the data for the form
		// now tell the form to get the other data it needs
		// - subs list, accepted recommendations list, and allocated recommendations list
		bSuccess = bSuccess && Form.InsertSubEditorList();
		bSuccess = bSuccess && Form.InsertAcceptedRecommendationsList();
		int iSkip = m_InputContext.GetParamInt("skip");
		int iShow = m_InputContext.GetParamInt("show");
		if (iShow <= 0)
		{
			iShow = 20;
		}
		bSuccess = bSuccess && Form.InsertAllocatedRecommendationsList(iShow, iSkip);
		bSuccess = bSuccess && Form.InsertNotificationStatus();
		// now add the form into the page
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", &Form);
	}
	TDVASSERT(bSuccess, "CSubEditorAllocationPageBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CSubEditorAllocationPageBuilder::ProcessAllocationSubmission(CUser* pViewer)

	Author:		Kim Harries
	Created:	21/11/2000
	Inputs:		pViewer - ptr to the viewing user object
	Outputs:	-
	Returns:	True if any submission was process successfully (or there was none),
				false if something went wrong
	Purpose:	Checks to see if there is a submission of entry allocations to subs
				in this request, and processes it if there is.

*********************************************************************************/

bool CSubEditorAllocationPageBuilder::ProcessAllocationSubmission(CUser* pViewer, const TDVCHAR* pcCommand, CSubAllocationForm& Form)
{
	TDVASSERT(pViewer != NULL, "NULL pViewer in CSubEditorAllocationPageBuilder::ProcessAllocationSubmission(...)");
//	TDVASSERT(m_pForm != NULL, "NULL m_pForm in CSubEditorAllocationPageBuilder::ProcessAllocationSubmission(...)");

	// must be an editor to use this page => should never get here if they aren't in any case
	if (pViewer == NULL || !pViewer->GetIsEditor())// || m_pForm == NULL)
	{
		return false;
	}
	CTDVString	sCommand = pcCommand;
	int			iSubID = 0;
	bool		bSuccess = true;

	// process any allocation submission requests appropriately
	if (sCommand.CompareText("AutoAllocate"))
	{
		int iNumberToAllocate = m_InputContext.GetParamInt("Amount");

		iSubID = m_InputContext.GetParamInt("SubID");
		// make sure we have a sub ID and a positive number of entries to allocate
		// if not then put some error XML in specifying the problem
		if (iSubID <= 0)
		{
			bSuccess = bSuccess && Form.AddErrorMessage("INVALID-SUBEDITOR-ID");
		}
		else if (iNumberToAllocate <= 0)
		{
			bSuccess = bSuccess && Form.AddErrorMessage("ZERO-AUTO-ALLOCATE");
		}
		else
		{
			// call the auto allocation method
			// this should add any error report XML if necessary
			bSuccess = bSuccess && Form.SubmitAutoAllocation(iSubID, iNumberToAllocate, pViewer->GetUserID());
		}
	}
	else if (sCommand.CompareText("Allocate"))
	{
		int		iTotalEntries = 0;
		int*	piEntryIDs = NULL;

		iSubID = m_InputContext.GetParamInt("SubID");
		iTotalEntries = m_InputContext.GetParamCount("EntryID");
		// check that we have some entries to allocate
		if (iTotalEntries > 0)
		{
			piEntryIDs = new int[iTotalEntries];
			// check memory allocation worked okay
			if (piEntryIDs == NULL)
			{
				bSuccess = false;
				TDVASSERT(false, "Memory allocation failed in CSubEditorAllocationPageBuilder::ProcessAllocationSubmission(...)");
			}
			else
			{
				// copy each entry ID parameter into the array
				for (int i = 0; i < iTotalEntries; i++)
				{
					piEntryIDs[i] = m_InputContext.GetParamInt("EntryID", i);
				}
			}
			// call the submit allocation method on the form
			// => this can add any relevant XML to the form if need be
			bSuccess = bSuccess && Form.SubmitAllocation(iSubID, pViewer->GetUserID(), NULL, piEntryIDs, iTotalEntries);
		}
		else
		{
			// if no entries then put some error XML in the form
			bSuccess = bSuccess && Form.AddErrorMessage("NO-ENTRIES-SELECTED");
		}
		// make sure the array is deleted
		delete piEntryIDs;
		piEntryIDs = NULL;
	}
	else if (sCommand.CompareText("Deallocate"))
	{
		int		iTotalEntries = 0;
		int*	piEntryIDs = NULL;

		iTotalEntries = m_InputContext.GetParamCount("DeallocateID");
		// check that we have some entries to allocate
		if (iTotalEntries > 0)
		{
			piEntryIDs = new int[iTotalEntries];
			// check memory allocation worked okay
			if (piEntryIDs == NULL)
			{
				bSuccess = false;
				TDVASSERT(false, "Memory allocation failed in CSubEditorAllocationPageBuilder::ProcessAllocationSubmission(...)");
			}
			else
			{
				// copy each entry ID parameter into the array
				for (int i = 0; i < iTotalEntries; i++)
				{
					piEntryIDs[i] = m_InputContext.GetParamInt("DeallocateID", i);
				}
			}
			// call the submit allocation method on the form
			// => this can add any relevant XML to the form if need be
			bSuccess = bSuccess && Form.SubmitDeallocation(pViewer->GetUserID(), piEntryIDs, iTotalEntries);
		}
		else
		{
			// if no entries then put some error XML in the form
			bSuccess = bSuccess && Form.AddErrorMessage("NO-ENTRIES-SELECTED");
		}
		// make sure the array is deleted
		delete piEntryIDs;
		piEntryIDs = NULL;
	}
	// return success value
	return bSuccess;
}

/*********************************************************************************

	bool CSubEditorAllocationPageBuilder::SendNotificationEmails(int* piTotalSent)

	Author:		Kim Harries
	Created:	28/11/2000
	Inputs:		-
	Outputs:	piTotalSent - total number of emails sent
	Returns:	True if emails sent okay, false if not
	Purpose:	Sends out an email containing a summary of the new allocations made
				to each sub editor.

*********************************************************************************/

bool CSubEditorAllocationPageBuilder::SendNotificationEmails(CSubAllocationForm& Form, int* piTotalSent)
{
	CUserList				Subs(m_InputContext);
	CSubNotificationEmail	SubEmail(m_InputContext);
	int*					piIDArray = NULL;
	int						iTotalIDs = 0;
	int						iSubID = 0;
	bool					bToSend = true;
	CTDVString				sEmailAddress;
	CTDVString				sEmailSubject;
	CTDVString				sEmailText;
	int						iTotalSent = 0;
	bool					bSuccess = true;

	// get a list of all the subs and then for each one build the appropriate
	// notification email (if any) and send it
	bSuccess = bSuccess && Subs.CreateSubEditorsList(100000);
	// get all the user IDs in an array
	bSuccess = bSuccess && Subs.GetUserIDs(&piIDArray, &iTotalIDs);
	// now loop through the IDs and create the email for each one
	if (bSuccess)
	{
		for (int i = 0; i < iTotalIDs; i++)
		{
			// get the next Subs ID
			iSubID = piIDArray[i];
			// create their notification email object
			bSuccess = bSuccess && SubEmail.CreateNotificationEmail(iSubID, &bToSend, &sEmailAddress, &sEmailSubject, &sEmailText);
			// if we have an email to send then send it
			if (bToSend)
			{
				CTDVString sEditorsEmail;
				CTDVString sSiteShortName;
				m_InputContext.GetEmail(EMAIL_EDITORS, sEditorsEmail);
				m_InputContext.GetShortName(sSiteShortName);
				bSuccess = bSuccess && SendMail(sEmailAddress, sEmailSubject, 
					sEmailText, sEditorsEmail, sSiteShortName);
				// increment emails sent counter
				if (bSuccess)
				{
					iTotalSent++;
				}
			}
			// Currently don't give summary of emails sent, but could extract
			// the XML at this point in order to do so
			// if something horrible has gone wrong then break out of loop
			if (!bSuccess)
			{
				break;
			}
		}
	}
	// put a very simple report inside the form
	if (bSuccess)
	{
		CTDVString	sReport = "";
		sReport << "<NOTIFICATIONS-SENT TOTAL='" << iTotalSent << "'/>";
		bSuccess = bSuccess && Form.AddInside("SUB-ALLOCATION-FORM", sReport);
	}
	else
	{
		bSuccess = Form.AddInside("SUB-ALLOCATION-FORM", "<ERROR TYPE='EMAIL-FAILURE'>An error occurred whilst trying to send emails</ERROR>");
	}
	// set the output parameter if it is given
	if (piTotalSent != NULL)
	{
		*piTotalSent = iTotalSent;
	}
	// delete all unneeded objects and return success value
	delete piIDArray;
	piIDArray = NULL;
	return bSuccess;
}

#endif // _ADMIN_VERSION
