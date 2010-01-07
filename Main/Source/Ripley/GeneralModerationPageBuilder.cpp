// GeneralModerationPageBuilder.cpp: implementation of the CGeneralModerationPageBuilder class.
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
#include "GeneralModerationPageBuilder.h"
#include "WholePage.h"
#include "GuideEntry.h"
#include "TDVAssert.h"

#if defined (_ADMIN_VERSION)

/*********************************************************************************

	CGeneralModerationPageBuilder::CGeneralModerationPageBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	19/02/2001
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CGeneralModerationPageBuilder object.

*********************************************************************************/

CGeneralModerationPageBuilder::CGeneralModerationPageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext),
	m_pSP(NULL),
	m_sCommand(""),
	m_sURL(""),
	m_iModID(0),
	m_RefereeList(inputContext)
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************

	CGeneralModerationPageBuilder::~CGeneralModerationPageBuilder()

	Author:		Kim Harries
	Created:	19/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CGeneralModerationPageBuilder::~CGeneralModerationPageBuilder()
{
	// make sure SP is deleted
	delete m_pSP;
	m_pSP = NULL;
}

/*********************************************************************************

	CWholePage* CGeneralModerationPageBuilder::Build()

	Author:		Kim Harries
	Created:	19/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this frame
	Purpose:	Constructs the XML for the general moderation page depending upon
				which frame is required.

*********************************************************************************/

bool CGeneralModerationPageBuilder::Build(CWholePage* pPage)
{
	CTDVString	sFrameType;

	// get the type of frame we are building
	if (!m_InputContext.GetParamString("Frame", sFrameType))
	{
		sFrameType = "FormFrame";
	}
	// then build the appropriate XML
	if (sFrameType.CompareText("TopFrame"))
	{
		return BuildTopFrame(pPage);
	}
	else if (sFrameType.CompareText("FormFrame"))
	{
		return BuildFormFrame(pPage);
	}
	else
	{
		return BuildTopFrame(pPage);
	}
	// should never reach here, but if we do return NULL to indicate failure
	return false;
}

/*********************************************************************************

	CWholePage* CGeneralModerationPageBuilder::BuildTopFrame()

	Author:		Kim Harries
	Created:	19/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this frame
	Purpose:	Constructs the XML for the general moderation pages top frame - i.e.
				the one that will contain the other frames.

*********************************************************************************/

bool CGeneralModerationPageBuilder::BuildTopFrame(CWholePage* pWholePage)
{
	InitPage(pWholePage, "MODERATION-TOP-FRAME", true);
	bool		bSuccess = true;

	// get the viewing user
	CUser* pViewer = m_InputContext.GetCurrentUser();
	// do an error page if not an editor or moderator
	// otherwise proceed with the process recommendation page
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsModerator()))
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", 
			"<ERROR TYPE='NOT-EDITOR'>You cannot perform moderation unless you are logged in as an Editor or Moderator.</ERROR>");
	}
	else
	{
		CTDVString	sXML = "";
		CTDVString	sEscapedURL;
		CTDVString	sNext = "Process";
		int			iReferrals = 0;

		// get a ModID from the request if it is there
		m_iModID = m_InputContext.GetParamInt("ModID");
		// if we have been given a page URL as a parameter then get it
		if (!m_InputContext.GetParamString("URL", m_sURL))
		{
			// if not then default to not found gif
			m_sURL = "h2g2/guide/skins/Alabaster/images/notfound.gif";
		}
		// are we doing referrals?
		iReferrals = m_InputContext.GetParamInt("Referrals");
		sEscapedURL = m_sURL;
		// make sure URL is escaped before going in XML
		CXMLObject::EscapeAllXML(&sEscapedURL);
		sXML << "<MODERATION-FRAME MOD-ID='" << m_iModID << "' URL='" << sEscapedURL << "' REFERRALS='" << iReferrals << "'>";
		if (m_InputContext.ParamExists("Next"))
		{
			m_InputContext.GetParamString("Next", sNext);
			sXML << "<NEXT>" << sNext << "</NEXT>";
		}
		sXML << "</MODERATION-FRAME>";
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", sXML);
	}
	TDVASSERT(bSuccess, "CGeneralModerationPageBuilder::BuildTopFrame() failed");
	return bSuccess;
}

/*********************************************************************************

	CWholePage* CGeneralModerationPageBuilder::BuildFormFrame()

	Author:		Kim Harries
	Created:	19/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this frame
	Purpose:	Constructs the XML for the general moderation pages form frame - this
				is the frame at the bottom of the page containing the moderation form.

*********************************************************************************/

bool CGeneralModerationPageBuilder::BuildFormFrame(CWholePage* pWholePage)
{
	InitPage(pWholePage, "MODERATION-FORM-FRAME", true);
	bool bSuccess = true;

	// get the viewing user
	CUser* pViewer = m_InputContext.GetCurrentUser();
	// do an error page if not an editor or moderator
	// otherwise proceed with the process recommendation page
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsModerator()))
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", 
			"<ERROR TYPE='NOT-EDITOR'>You cannot perform moderation unless you are logged in as an Editor or Moderator.</ERROR>");
	}
	else
	{
		// find out what command
		if (m_InputContext.ParamExists("Done"))
		{
			m_sCommand = "Done";
		}
		else
		{
			m_sCommand = "Next";
		}
		// first process any submission that may have been made
		bSuccess = bSuccess && ProcessSubmission(pViewer);
		if (bSuccess && m_sCommand.CompareText("Next"))
		{
			// then create the XML for the form to be displayed
			CTDVString	sFormXML = "";
			bSuccess = bSuccess && CreateForm(pViewer, &sFormXML);
			// insert the form XML into the page
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", sFormXML);

			CTDVString sSiteXML;
			bSuccess = bSuccess && m_InputContext.GetSiteListAsXML(&sSiteXML, 2);
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", sSiteXML);

			bSuccess = bSuccess && m_RefereeList.FetchTheList();
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", &m_RefereeList);
		}
		else // if a successful 'Done' request then redirect to the Moderation Home Page
		if (bSuccess)
		{
			CTDVString sRedirect;
			if (m_InputContext.ParamExists("newstyle"))
			{
				sRedirect = "<REDIRECT-TARGET><REDIRECT-TO>Moderate?newstyle=1</REDIRECT-TO>";
			}
			else
			{
				sRedirect = "<REDIRECT-TARGET><REDIRECT-TO>Moderate</REDIRECT-TO>";
			}
			sRedirect << "<REDIRECT-TO-TARGET>_top</REDIRECT-TO-TARGET></REDIRECT-TARGET>";
			pWholePage->AddInside("H2G2", sRedirect);
			pWholePage->SetPageType("REDIRECT-TARGET");
		}

	}
	// make sure any unneeded objects are deleted then return the success value
	TDVASSERT(bSuccess, "CGeneralModerationPageBuilder::BuildFormFrame() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CGeneralModerationPageBuilder::ProcessSubmission(CUser* pViewer)

	Author:		Kim Harries
	Created:	22/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Processes any submission of moderation decisions made

*********************************************************************************/

bool CGeneralModerationPageBuilder::ProcessSubmission(CUser* pViewer)
{
	bool bSuccess = true;
	// if we have a decision then process it
	int			iStatus = 0;
	int			iReferTo = 0;
	CTDVString	sNotes;

	// get an SP object if we haven't already
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if we still have no SP then die like the pigs we are
	if (m_pSP == NULL)
	{
		return false;
	}
	// get all the relevant data on the decision
	m_iModID = m_InputContext.GetParamInt("ModID");
	iStatus = m_InputContext.GetParamInt("Decision");
	iReferTo = m_InputContext.GetParamInt("ReferTo");
	if (!m_InputContext.GetParamString("Notes", sNotes))
	{
		sNotes = "";
	}
	// then do an update for this moderation item if we have a ModID
	if (m_iModID > 0)
	{
		bSuccess = bSuccess && m_pSP->UpdateGeneralModeration(m_iModID, 
			iStatus, sNotes, iReferTo, pViewer->GetUserID());
	}
	return bSuccess;
}

/*********************************************************************************

	bool CGeneralModerationPageBuilder::CreateForm(CUser* pViewer, CTDVString* psFormXML)

	Author:		Kim Harries
	Created:	22/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Creates the XML for the form on the general moderation page.

*********************************************************************************/

bool CGeneralModerationPageBuilder::CreateForm(CUser* pViewer, CTDVString* psFormXML)
{
	TDVASSERT(psFormXML != NULL, "NULL psFormXML in CGeneralModerationPageBuilder::CreateForm(...)");
	// fail if no output variable given
	if (psFormXML == NULL)
	{
		return false;
	}

	CTDVString	sEscapedURL;
	CTDVString	sMessageXML = "";
	CTDVString	sNotes;
	CTDVString	sComplaintText;
	CTDVString	sCorrespondenceEmail;
	CTDVString	sShowType;
	int			iComplainantID = 0;
	int			iModID = 0;
	int			iEntryID = 0;
	int			iStatus = 0;
	int			iReferrals = 0;
	int			iSiteID = 0;
	bool		bSuccess = true;

	// get an SP object if we haven't already
	if (m_pSP == NULL)
	{
		m_pSP = m_InputContext.CreateStoredProcedureObject();
	}
	// if we still have no SP then die like the pigs we are
	if (m_pSP == NULL)
	{
		return false;
	}
	// see if we are processing referrals or not
	iReferrals = m_InputContext.GetParamInt("Referrals");
	// fetch the next article for moderation from the queue
	bSuccess = bSuccess && m_pSP->FetchNextGeneralModerationBatch(pViewer->GetUserID(), iReferrals);
	// build the XML
	if (bSuccess)
	{
		if (m_pSP->IsEOF())
		{
			// no data so put in an appropriate message
			sMessageXML = "<MESSAGE TYPE='EMPTY-QUEUE'>There are no more complaints of this type waiting to be processed at this time.</MESSAGE>";
		}
		else
		{
			iModID = m_pSP->GetIntField("ModID");
			iSiteID = m_pSP->GetIntField("SiteID");
			iStatus = m_pSP->GetIntField("Status");
			if (m_pSP->FieldExists("URL"))
			{
				m_pSP->GetField("URL", m_sURL);
			}
			else
			{
				m_sURL = "";
			}
			sEscapedURL = m_sURL;
			if (m_pSP->FieldExists("Notes"))
			{
				m_pSP->GetField("Notes", sNotes);
			}
			else
			{
				sNotes = "";
			}
			iComplainantID = m_pSP->GetIntField("ComplainantID");
			if (m_pSP->FieldExists("ComplaintText"))
			{
				m_pSP->GetField("ComplaintText", sComplaintText);
			}
			else
			{
				sComplaintText = "";
			}
			if (m_pSP->FieldExists("CorrespondenceEmail"))
			{
				m_pSP->GetField("CorrespondenceEmail", sCorrespondenceEmail);
			}
			else
			{
				sCorrespondenceEmail = "";
			}
		}
		
		// now build the form XML
		*psFormXML = "";
		*psFormXML << "<GENERAL-MODERATION-FORM REFERRALS='" << iReferrals << "'>";
		*psFormXML << sMessageXML;
		// url must be escaped before going in the form
		CXMLObject::EscapeAllXML(&sEscapedURL);
		*psFormXML << "<URL>" << sEscapedURL << "</URL>";
		*psFormXML << "<MODERATION-ID>" << iModID << "</MODERATION-ID>";
		*psFormXML << "<MODERATION-STATUS>" << iStatus << "</MODERATION-STATUS>";
		CXMLObject::EscapeAllXML(&sNotes);
		*psFormXML << "<NOTES>" << sNotes << "</NOTES>";
		*psFormXML << "<COMPLAINANT-ID>" << iComplainantID << "</COMPLAINANT-ID>";
		CXMLObject::EscapeAllXML(&sCorrespondenceEmail);
		*psFormXML << "<CORRESPONDENCE-EMAIL>" << sCorrespondenceEmail << "</CORRESPONDENCE-EMAIL>";
		CXMLObject::EscapeAllXML(&sComplaintText);
		*psFormXML << "<COMPLAINT-TEXT>" << sComplaintText << "</COMPLAINT-TEXT>";
		*psFormXML << "<SITEID>" << iSiteID << "</SITEID>";
		*psFormXML << "</GENERAL-MODERATION-FORM>";
	}
	return bSuccess;
}


#endif // _ADMIN_VERSION
