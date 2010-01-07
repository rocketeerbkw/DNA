// ProcessRecommendationPageBuilder.cpp: implementation of the CProcessRecommendationPageBuilder class.
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
#include "ProcessRecommendationPageBuilder.h"
#include "ProcessRecommendationForm.h"
#include "WholePage.h"
#include "PageUI.h"
#include "ArticleList.h"
#include "TDVAssert.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CProcessRecommendationPageBuilder::CProcessRecommendationPageBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	24/11/2000
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CProcessRecommendationPageBuilder object.

*********************************************************************************/

CProcessRecommendationPageBuilder::CProcessRecommendationPageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
	// no further construction required
}

/*********************************************************************************

	CProcessRecommendationPageBuilder::~CProcessRecommendationPageBuilder()

	Author:		Kim Harries
	Created:	24/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CProcessRecommendationPageBuilder::~CProcessRecommendationPageBuilder()
{
}

/*********************************************************************************

	CWholePage* CProcessRecommendationPageBuilder::Build()

	Author:		Kim Harries
	Created:	24/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the recommendation processing page, and processes
				requests to accept or reject scout recommendations.

*********************************************************************************/

bool CProcessRecommendationPageBuilder::Build(CWholePage* pWholePage)
{
	CUser*		pViewer = NULL;
	int			iRecommendationID = 0;
	CTDVString	sComments = "";
	CTDVString	sMode = "";
	CTDVString	sCommand = "";
	CTDVString	sScoutEmail = "";
	CTDVString	sScoutEmailSubject = "";
	CTDVString	sScoutEmailText = "";
	CTDVString	sAuthorEmail = "";
	CTDVString	sAuthorEmailSubject = "";
	CTDVString	sAuthorEmailText = "";
	bool		bAcceptButton = true;
	bool		bRejectButton = true;
	bool		bCancelButton = true;
	bool		bFetchButton = true;
	bool		bSuccess = true;

	CProcessRecommendationForm Form(m_InputContext);

	// get the viewing user
	pViewer = m_InputContext.GetCurrentUser();
	// initiliase the whole page object and set the page type
	bSuccess = InitPage(pWholePage, "PROCESS-RECOMMENDATION",true);
	// do an error page if not an editor
	// otherwise proceed with the process recommendation page
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot process a recommendation unless you are logged in as an Editor.</ERROR>");
	}
	else
	{
		// if there are ID and comments parameters then get them
		iRecommendationID = m_InputContext.GetParamInt("RecommendationID");
		m_InputContext.GetParamString("Comments", sComments);
		// get any parameters providing the default email details
		m_InputContext.GetParamString("ScoutEmail", sScoutEmail);
		m_InputContext.GetParamString("ScoutEmailSubject", sScoutEmailSubject);
		m_InputContext.GetParamString("ScoutEmailText", sScoutEmailText);
		m_InputContext.GetParamString("AuthorEmail", sAuthorEmail);
		m_InputContext.GetParamString("AuthorEmailSubject", sAuthorEmailSubject);
		m_InputContext.GetParamString("AuthorEmailText", sAuthorEmailText);
		// also get any parameters saying which functionality should be present
		if (m_InputContext.ParamExists("Accept"))
		{
			bAcceptButton = (m_InputContext.GetParamInt("Accept") != 0);
		}
		if (m_InputContext.ParamExists("Reject"))
		{
			bRejectButton = (m_InputContext.GetParamInt("Reject") != 0);
		}
		if (m_InputContext.ParamExists("Cancel"))
		{
			bCancelButton = (m_InputContext.GetParamInt("Cancel") != 0);
		}
		if (m_InputContext.ParamExists("Fetch"))
		{
			bFetchButton = (m_InputContext.GetParamInt("Fetch") != 0);
		}
		// check if we are submitting a decision or just fetching the details
		if (m_InputContext.GetParamString("cmd", sCommand))
		{
			CTDVString	sTempScoutAddress;
			CTDVString	sTempScoutSubject;
			CTDVString	sTempScoutText;
			CTDVString	sTempAuthorAddress;
			CTDVString	sTempAuthorSubject;
			CTDVString	sTempAuthorText;
			bool		bUpdateOK = true;
			
			//for sending email
			CTDVString sEditorsEmail;
			CTDVString sSiteShortName;
			m_InputContext.GetEmail(EMAIL_EDITORS, sEditorsEmail);
			m_InputContext.GetShortName(sSiteShortName);

			// either accept or reject recommendation, or cancel the operation
			// or fetch another recommendation to decide
			if (sCommand.CompareText("Accept"))
			{
				bSuccess = bSuccess && m_InputContext.ParamExists("h2g2ID");
				int ih2g2ID_Old = m_InputContext.GetParamInt("h2g2ID");
				// if submit successful then this also returns the default email address, subject and text for the email to send to the scout
				bSuccess = bSuccess && Form.SubmitAccept(pViewer, ih2g2ID_Old,iRecommendationID, sComments, &bUpdateOK, &sTempScoutAddress, &sTempAuthorAddress, &sTempScoutSubject, &sTempScoutText, &sTempAuthorSubject, &sTempAuthorText);
				// if update was okay then send acceptance mail to scout, otherwise provide an error report
				if (bUpdateOK)
				{
				
					// send emails to the scout and author
					// only use the default values if not overidden already by request parameters
					if (sScoutEmail.IsEmpty())
					{
						sScoutEmail = sTempScoutAddress;
					}
					if (sScoutEmailSubject.IsEmpty())
					{
						sScoutEmailSubject = sTempScoutSubject;
					}
					if (sScoutEmailText.IsEmpty())
					{
						sScoutEmailText = sTempScoutText;
					}
					/*bSuccess = bSuccess &&*/ 
					SendMail(sScoutEmail, sScoutEmailSubject, sScoutEmailText, 
						sEditorsEmail, sSiteShortName);
					// now do the authors email
					if (sAuthorEmail.IsEmpty())
					{
						sAuthorEmail = sTempAuthorAddress;
					}
					if (sAuthorEmailSubject.IsEmpty())
					{
						sAuthorEmailSubject = sTempAuthorSubject;
					}
					if (sAuthorEmailText.IsEmpty())
					{
						sAuthorEmailText = sTempAuthorText;
					}
					/*bSuccess = bSuccess && */ 
					SendMail(sAuthorEmail, sAuthorEmailSubject, sAuthorEmailText, 
						sEditorsEmail, sSiteShortName);
				}
			}
			else if (sCommand.CompareText("Reject"))
			{
				bSuccess = bSuccess && Form.SubmitReject(pViewer, iRecommendationID, sComments, &bUpdateOK, &sTempScoutAddress, &sTempScoutSubject, &sTempScoutText);
				// if update was okay then send acceptance mail to scout, otherwise provide an error report
				if (bUpdateOK)
				{
					// only use the default values if not overidden already by request parameters
					if (sScoutEmail.IsEmpty())
					{
						sScoutEmail = sTempScoutAddress;
					}
					if (sScoutEmailSubject.IsEmpty())
					{
						sScoutEmailSubject = sTempScoutSubject;
					}
					if (sScoutEmailText.IsEmpty())
					{
						sScoutEmailText = sTempScoutText;
					}
					bSuccess = bSuccess && SendMail(sScoutEmail, 
						sScoutEmailSubject, sScoutEmailText, 
						sEditorsEmail, sSiteShortName);
				}
			}
			else if (sCommand.CompareText("Cancel"))
			{
				// a cancel request should never actually be received, so log an error
				TDVASSERT(false, "Cancel request received in CProcessRecommendationPageBuilder::Build()");
				bSuccess = false;
			}
			else if (sCommand.CompareText("Fetch"))
			{
				CTDVString	sFetchID = "0";
				int			iEntryID = 0;
				// get the entry id from the request and try to create the form for the
				// recommendation associated with this entry
				m_InputContext.GetParamString("FetchID", sFetchID);
				if (sFetchID.GetLength() > 0 && !isdigit(sFetchID[0]))
				{
					sFetchID = sFetchID.Mid(1);
				}
				iEntryID = atoi(sFetchID) / 10;
				bSuccess = bSuccess && Form.CreateFromEntryID(pViewer, iEntryID, sComments);
			}
			else
			{
				TDVASSERT(false, "Invalid decision parameter in CProcessRecommendationPageBuilder::Build()");
				bSuccess = false;
			}
		}
		else
		{
			// assume command is a view command otherwise
			if (iRecommendationID > 0)
			{
				// CreateFromRecommendationID will return an error code in the XML if required
				bSuccess = bSuccess && Form.CreateFromRecommendationID(pViewer, iRecommendationID, sComments, bAcceptButton, bRejectButton, bCancelButton, bFetchButton);
			}
			else
			{
				// TODO: blank form only makes sense if it has a fetch method
				bSuccess = bSuccess && Form.CreateBlankForm(pViewer);
			}
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
	TDVASSERT(bSuccess, "CProcessRecommendationPageBuilder::Build() failed");
	return bSuccess;
}

#endif // _ADMIN_VERSION
