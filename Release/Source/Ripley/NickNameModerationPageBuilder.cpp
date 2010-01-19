// NickNameModerationPageBuilder.cpp: implementation of the CNickNameModerationPageBuilder class.
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
#include "NickNameModerationPageBuilder.h"
#include "SiteData.h"
#include "WholePage.h"
#include "TDVAssert.h"
#include "./emailtemplate.h"

#include "ModerateNickNamesBuilder.h" //Newer Bulder for newstyle=1 parameter.

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CNickNameModerationPageBuilder::CNickNameModerationPageBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CNickNameModerationPageBuilder object.

*********************************************************************************/

CNickNameModerationPageBuilder::CNickNameModerationPageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext),
	m_pSP(NULL),
	m_sCommand("View")
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************

	CNickNameModerationPageBuilder::~CNickNameModerationPageBuilder()

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CNickNameModerationPageBuilder::~CNickNameModerationPageBuilder()
{
	// make sure SP is deleted
	delete m_pSP;
	m_pSP = NULL;
}

/*********************************************************************************

	CWholePage* CNickNameModerationPageBuilder::Build()

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the page allowing staff to moderate nicknames
				The newstyle=1 parameter will divert XML creation / processing to alternative builder.

*********************************************************************************/

bool CNickNameModerationPageBuilder::Build(CWholePage* pWholePage)
{
	//Allow new builder to co-exist with current and sharing the same url ModerateNickNames
	if ( m_InputContext.GetParamInt("newstyle") == 1)
	{
		CModerateNickNamesBuilder newbuilder(m_InputContext);
		return newbuilder.Build(pWholePage);
	}


	InitPage(pWholePage, "MODERATE-NICKNAMES", true);
	bool bSuccess = true;
	// get the viewing user
	CUser* pViewer = NULL;
	pViewer = m_InputContext.GetCurrentUser();
	// add the viewing users details if we have them
	if (pViewer != NULL)
	{
		bSuccess = bSuccess && pWholePage->AddInside("VIEWING-USER", pViewer);
	}
	// do an error page if not an editor or moderator
	// otherwise proceed with the process recommendation page
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsModerator()))
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot perform moderation unless you are logged in as an Editor or Moderator.</ERROR>");
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
			CTDVString	sFormXML = "";
			// then create the XML for the form to be displayed
			bSuccess = bSuccess && CreateForm(pViewer, &sFormXML);
			// insert the form XML into the page
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", sFormXML);
		}
		else // if a successful 'Done' request then redirect to the Moderation Home Page
		if (bSuccess)
		{
			pWholePage->Redirect("Moderate");
		}
	}
	// make sure any unneeded objects are deleted then return the success value
	TDVASSERT(bSuccess, "CNickNameModerationPageBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CNickNameModerationPageBuilder::ProcessSubmission(CUser* pViewer)

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Processes any submission of moderation decisions made

*********************************************************************************/

bool CNickNameModerationPageBuilder::ProcessSubmission(CUser* pViewer)
{
	bool	bSuccess = true;
	bool	bEmailSentOK = false;
	// if the command involves a submission then proceed
	CTDVString	sEmailSubject;
	CTDVString	sEmailText;
	CTDVString	sOldNickname;
	CTDVString	sUserID;
	CTDVString	sUsersEmail;
	int			iNumberOfNicknames = 0;
	int			iUserID = 0;
	int			iModID = 0;
	int			iStatus = 0;
	int			i = 0;

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
	// first get the total number of User IDs in the submission
	// - there should be an equal number of all the other parameters
	iNumberOfNicknames = m_InputContext.GetParamCount("UserID");
	// need to do an update for each of the nicknames that has been moderated
	// so go through all the appropriate parameters in the URL and process them
	i = 0;
	while (i < iNumberOfNicknames && bSuccess)
	{
		// get the UserID and corresponding decision
		iUserID = m_InputContext.GetParamInt("UserID", i);
		iModID = m_InputContext.GetParamInt("ModID", i);
		if (!m_InputContext.GetParamString("UserName", sOldNickname, i))
		{
			sOldNickname = "Unknown";
		}
		// currently only passing or failing are allowed
		if (m_InputContext.GetParamInt("Pass", i) == 1)
		{
			// passed status is 3, as per other moderation
			iStatus = 3;
		}
		else
		{
			// failed status is 4
			iStatus = 4;
		}
		// then do an update for this nicknames
		bSuccess = bSuccess && m_pSP->UpdateNicknameModeration(iModID, iStatus);
		// fetch the users email address
		bSuccess = bSuccess && m_pSP->GetField("EmailAddress", sUsersEmail);
		// if nickname was failed and reset then inform the user
		if (iStatus == 4)
		{
			// first get the overall email template
			int iThisSiteID = m_InputContext.GetSiteID();
			CEmailTemplate m_Email(m_InputContext);
			bSuccess = bSuccess && m_Email.FetchEmailText(iThisSiteID, "NicknameResetEmail", sEmailSubject, sEmailText);
			CXMLObject::UnEscapeXMLText(&sEmailSubject);
			CXMLObject::UnEscapeXMLText(&sEmailText);
			// get user ID in a string
			sUserID = "";
			sUserID << iUserID;
			// do any necessary substitutions
			sEmailSubject.Replace("++**nickname**++", sOldNickname);
			sEmailText.Replace("++**nickname**++", sOldNickname);
			sEmailSubject.Replace("++**userid**++", sUserID);
			sEmailText.Replace("++**userid**++", sUserID);
			// then send the email
			CTDVString m_ModeratorsEmail;
			m_InputContext.GetEmail(EMAIL_MODERATORS, m_ModeratorsEmail, iThisSiteID);
			CTDVString m_SiteShortName;
			m_InputContext.GetShortName(m_SiteShortName, iThisSiteID);
			bEmailSentOK = SendMailOrSystemMessage(sUsersEmail, sEmailSubject, sEmailText, 
				m_ModeratorsEmail, m_SiteShortName, false, iUserID, iThisSiteID);
		}
		i++;
	}
	return bSuccess;
}

/*********************************************************************************

	bool CNickNameModerationPageBuilder::CreateForm(CUser* pViewer, CTDVString* psFormXML)

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Creates the XML for the form on the moderate article page.

*********************************************************************************/

bool CNickNameModerationPageBuilder::CreateForm(CUser* pViewer, CTDVString* psFormXML)
{
	TDVASSERT(psFormXML != NULL, "NULL psFormXML in CNickNameModerationPageBuilder::CreateForm(...)");
	// fail if no output variable given
	if (psFormXML == NULL)
	{
		return false;
	}

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

	// if we are fetching the next batch then do so, otherwise simply fetch
	// any posts that are currently locked by this user (hopefully none)
	bool bSuccess = m_pSP->FetchNextNicknameModerationBatch(pViewer->GetUserID());

	// now build the form XML
	CTDVString sSiteName;
	CDBXMLBuilder XML;
	XML.Initialise(psFormXML,m_pSP);
	bSuccess = bSuccess && XML.OpenTag("NICKNAME-MODERATION-FORM");

	// create an appropriate message if there are no results
	if (m_pSP->IsEOF())
	{
		bSuccess = bSuccess && XML.OpenTag("MESSAGE",true);
		bSuccess = bSuccess && XML.AddAttribute("TYPE","EMPTY-QUEUE",true);
		bSuccess = bSuccess && XML.CloseTag("MESSAGE");
	}

	// Get each nickname in turn if there are any
	int iSiteID = 0;
	while (!m_pSP->IsEOF())
	{
		bSuccess = bSuccess && XML.OpenTag("NICKNAME");
		bSuccess = bSuccess && XML.DBAddIntTag("ModID","MODERATION-ID");
		bSuccess = bSuccess && XML.OpenTag("USER");
		bSuccess = bSuccess && XML.DBAddTag("USERNAME");
		bSuccess = bSuccess && XML.DBAddTag("FIRSTNAMES",NULL,false);
		bSuccess = bSuccess && XML.DBAddTag("LASTNAME",NULL,false);
		bSuccess = bSuccess && XML.DBAddTag("SITESUFFIX",NULL,false);
		bSuccess = bSuccess && XML.DBAddIntTag("USERID");
		bSuccess = bSuccess && XML.CloseTag("USER");
		bSuccess = bSuccess && XML.DBAddIntTag("SITEID",NULL,true,&iSiteID);
		bSuccess = bSuccess && m_InputContext.GetShortName(sSiteName,iSiteID);
		bSuccess = bSuccess && XML.AddTag("SITENAME",sSiteName);
		bSuccess = bSuccess && XML.DBAddIntTag("STATUS","MODERATION-STATUS");
		bSuccess = bSuccess && XML.CloseTag("NICKNAME");
		m_pSP->MoveNext();
	}
	bSuccess = bSuccess && XML.CloseTag("NICKNAME-MODERATION-FORM");

	// return the result
	return bSuccess;
}


#endif // _ADMIN_VERSION
