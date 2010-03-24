// MoveThreadPageBuilder.cpp: implementation of the CMoveThreadPageBuilder class.
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
#include "MoveThreadPageBuilder.h"
#include "WholePage.h"
#include "PageUI.h"
#include "TDVAssert.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CMoveThreadPageBuilder::CMoveThreadPageBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	20/12/2000
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CMoveThreadPageBuilder object.

*********************************************************************************/

CMoveThreadPageBuilder::CMoveThreadPageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************

	CMoveThreadPageBuilder::~CMoveThreadPageBuilder()

	Author:		Kim Harries
	Created:	20/12/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CMoveThreadPageBuilder::~CMoveThreadPageBuilder()
{
}

/*********************************************************************************

	CWholePage* CMoveThreadPageBuilder::Build()

	Author:		Kim Harries
	Created:	20/12/2000
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the page allowing editors to move threads
				from one forum to another, and performs any move operation requested.

*********************************************************************************/

bool CMoveThreadPageBuilder::Build(CWholePage* pWholePage)
{
	CUser*		pViewer = NULL;
	CTDVString	sDestinationID;
	int			iThreadID = 0;
	CTDVString	sMode = "";
	CTDVString	sCommand = "";
	CTDVString	sPostContent = "";
	bool		bMoveButton = true;
	bool		bCancelButton = true;
	bool		bFetchButton = true;
	bool		bUndoButton = false;
	bool		bUpdateOK = false;
	bool		bSuccess = true;

	CMoveThreadForm Form(m_InputContext);
	
	// get the viewing user
	pViewer = m_InputContext.GetCurrentUser();
	// initiliase the whole page object and set the page type
	bSuccess = InitPage(pWholePage, "MOVE-THREAD",true);
	// do an error page if not an editor
	// otherwise proceed with the process recommendation page
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot move a thread unless you are logged in as an Editor.</ERROR>");
	}
	else
	{
		// get the thread id and destination id parameters, if any
		// destination ID could be a fourm ID, h2g2ID or user ID
		if (!m_InputContext.GetParamString("DestinationID", sDestinationID))
		{
			// default to F0 if nothing given
			sDestinationID = "F0";
		}
		// get auto post content from query if present
		m_InputContext.GetParamString("PostContent", sPostContent);
		iThreadID = m_InputContext.GetParamInt("ThreadID");
		// also get any parameters saying which functionality should be present
		if (m_InputContext.ParamExists("Move"))
		{
			bMoveButton = (m_InputContext.GetParamInt("Move") != 0);
		}
		if (m_InputContext.ParamExists("Cancel"))
		{
			bCancelButton = (m_InputContext.GetParamInt("Cancel") != 0);
		}
		if (m_InputContext.ParamExists("Fetch"))
		{
			bFetchButton = (m_InputContext.GetParamInt("Fetch") != 0);
		}
		if (m_InputContext.ParamExists("Undo"))
		{
			bUndoButton = (m_InputContext.GetParamInt("Undo") != 0);
		}
		// check what the command is
		if (!m_InputContext.GetParamString("cmd", sCommand))
		{
			// if no command given then assum a fetch command
			sCommand = "Fetch";
		}
		// either process the move request, cancel it, or fetch the details for a move
		if (sCommand.CompareText("Move"))
		{
			// perform the move if requested
			bSuccess = bSuccess && Form.MoveThread(pViewer, iThreadID, sDestinationID, sPostContent, &bUpdateOK, bMoveButton, bCancelButton, bFetchButton, bUndoButton);
		}
		else if (sCommand.CompareText("Undo"))
		{
			// can't just move the thread back as we need to undo the posting
			// that will have been made to the thread too
			// get the id of the auto post from the hidden field parameter in the URL
			int	iAutoPostID = m_InputContext.GetParamInt("AutoPostID");
			bSuccess = bSuccess && Form.UndoThreadMove(pViewer, iThreadID, iAutoPostID, &bUpdateOK);
		}
		else if (sCommand.CompareText("Cancel"))
		{
			// a cancel request should never actually be received, so log an error
			TDVASSERT(false, "Cancel request received in CMoveThreadPageBuilder::Build()");
			bSuccess = false;
		}
		else if (sCommand.CompareText("Fetch"))
		{
			// try to create the form for this move operation
			bSuccess = bSuccess && Form.CreateFromThreadAndForumIDs(pViewer, iThreadID, sDestinationID, sPostContent, bMoveButton, bCancelButton, bFetchButton, bUndoButton);
		}
		else
		{
			TDVASSERT(false, "Invalid decision parameter in CMoveThreadPageBuilder::Build()");
			bSuccess = false;
		}
		// if all okay then insert the form XML into the page
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", &Form);
		// now get the display mode parameter, if any
		m_InputContext.GetParamString("mode", sMode);
		if (sMode.GetLength() > 0)
		{
			bSuccess = bSuccess && pWholePage->SetAttribute("H2G2", "MODE", sMode);
		}
	}
	TDVASSERT(bSuccess, "CMoveThreadPageBuilder::Build() failed");
	return bSuccess;
}

#endif // _ADMIN_VERSION
