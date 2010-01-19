// FailMessage.cpp: implementation of the CFailMessage class.
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
#include "InputContext.h"
#include "InputContext.h"
#include "MultiStep.h"
#include "SiteData.h"
#include "FailMessage.h"
#include "tdvassert.h"
#include "User.h"
#include "StoredProcedure.h"
#include "EmailTemplate.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CFailMessage::CFailMessage(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

CFailMessage::~CFailMessage()
{
}

/*********************************************************************************

	bool CFailMessage::Initialise()

	Author:		Mark Neves
	Created:	03/02/2004
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CFailMessage::Initialise()
{
	Destroy();
	return true;
}


/*********************************************************************************

	bool CFailMessage::Process(CInputContext& inputContext)

	Author:		Mark Neves
	Created:	03/02/2004
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CFailMessage::Process(CInputContext& inputContext)
{
	if (!Initialise())
	{
		return false;
	}

	CUser* pViewer = inputContext.GetCurrentUser();
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		return SetDNALastError("CFailMessage","UpdateConfig","You cannot fail a message unless you are logged in as an Editor");
	}

	CMultiStep Multi(m_InputContext, "FAILMESSAGE");
	Multi.AddRequiredParam("forumid");
	Multi.AddRequiredParam("threadid");
	Multi.AddRequiredParam("postid");
	Multi.AddRequiredParam("decision");
	Multi.AddRequiredParam("emailtype");
	Multi.AddRequiredParam("customtext");
	Multi.AddRequiredParam("emailtextpreview");
	Multi.AddRequiredParam("internalnotes");

	if (!Multi.ProcessInput())
	{
		return SetDNALastError("CFailMessage","Process","Failed to process input");
	}

	if (Multi.ErrorReported())
	{
		CopyDNALastError("CFailMessage",Multi);
	}

	bool bOK = true;

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	CTDVString sEmailType, sPostSubject, sPostText;
	CTDVString sAuthorEmailText, sAuthorEmailSubject;
	CTDVString sInsertText, sInternalNotes;
	CTDVString sCustomText;

	int iSiteID = 0;
	int iForumID = 0, iThreadID = 0, iPostID = 0;

	bool bGotParams = true;
	bGotParams = bGotParams && Multi.GetRequiredValue("forumid",iForumID);
	bGotParams = bGotParams && Multi.GetRequiredValue("threadid",iThreadID);
	bGotParams = bGotParams && Multi.GetRequiredValue("postid",iPostID);
	bGotParams = bGotParams && Multi.GetRequiredValue("emailtype",sEmailType);

	if (bGotParams)
	{
		if (SP.FetchPostDetails(iPostID))
		{
			iSiteID = SP.GetIntField("SiteID");
			bOK = bOK && SP.GetField("Subject", sPostSubject);
			bOK = bOK && SP.GetField("Text", sPostText);
		}
		else
		{
			SetDNALastError("CFailMessage","FetchPostError","Unable to fetch post",CTDVString(iPostID));
		}

		if (bOK)
		{
			// use new email template class
			CEmailTemplate m_Email(m_InputContext);

			//bOK = bOK && SP.FetchEmailText(iSiteID,"ContentRemovedEmail", &sAuthorEmailText, &sAuthorEmailSubject);
			//bOK = bOK && SP.FetchEmailText(iSiteID, sEmailType, &sInsertText, NULL);
			bOK = bOK && m_Email.FetchEmailText(iSiteID, "ContentRemovedEmail", sAuthorEmailSubject, sAuthorEmailText);
			bOK = bOK && m_Email.FetchInsertText(iSiteID, sEmailType, sInsertText);


			if (bOK)
			{
				Multi.GetRequiredValue("customtext",sCustomText);
				Multi.GetRequiredValue("internalnotes",sInternalNotes);

				// do any necessary translations
				CTDVString	sURL = "http://";
				CTDVString	sSiteRootURL;

				// construct the URL for the post
				inputContext.GetSiteRootURL(iSiteID,sSiteRootURL);
				sURL << sSiteRootURL << "F" << iForumID << "?Thread=" << iThreadID << "&post=" << iPostID;
				// first place the insert text before doing any of the other translations, so
				// that any place holders in the inserted text will also be translated
				sAuthorEmailText.Replace("++**inserted_text**++", sInsertText);
				if (!sCustomText.IsEmpty())
				{
					sAuthorEmailText.Replace("++**inserted_text**++", sCustomText);
				}
				// now do the other replacements
				sAuthorEmailSubject.Replace("++**content_type**++", "Posting");
				sAuthorEmailText.Replace("++**content_type**++", "Posting");
				sAuthorEmailText.Replace("++**add_content_method**++", "post it");
				sAuthorEmailText.Replace("++**content_url**++", sURL);
				sAuthorEmailSubject.Replace("++**content_subject**++", sPostSubject);
				sAuthorEmailText.Replace("++**content_subject**++", sPostSubject);
				sAuthorEmailText.Replace("++**content_text**++", sPostText);

				Multi.SetRequiredValue("emailtextpreview",sAuthorEmailText);
			}
		}
	}

	if (bOK && Multi.ReadyToUse())
	{
		int iComplainantID = pViewer->GetUserID();
		bOK = SP.RegisterPostingComplaint(iComplainantID, iPostID, sAuthorEmailText, sCustomText/*sComplaintText*/, m_InputContext.GetIPAddress(), m_InputContext.GetBBCUIDFromCookie());
		int iModID = SP.GetIntField("ModID");
		int iStatus = 4, iReferTo = 0;
		bOK = bOK && SP.LockPostModerationEntry(iModID,iComplainantID);
		bOK = bOK && SP.UpdatePostingsModeration(iForumID, iThreadID, iPostID, iModID, iStatus, sInternalNotes, 
						iReferTo, iComplainantID);

		CTDVString sAuthorsEmail;
		bOK = bOK && SP.GetField("AuthorsEmail", sAuthorsEmail);
		int iAuthorID = SP.GetIntField("AuthorID");

		CTDVString sModeratorsEmail, sSiteShortName;
		inputContext.GetEmail(EMAIL_MODERATORS, sModeratorsEmail, iSiteID);
		inputContext.GetShortName(sSiteShortName, iSiteID);

		bOK = bOK && inputContext.SendMailOrSystemMessage(sAuthorsEmail, sAuthorEmailSubject, 
					sAuthorEmailText, sModeratorsEmail, sSiteShortName, false, iAuthorID, iSiteID);
	}

	CTDVString sFailMessageXML;
	sFailMessageXML << "<FAILMESSAGE>";
	sFailMessageXML << Multi.GetAsXML();
	sFailMessageXML << "</FAILMESSAGE>";

	CreateFromXMLText(sFailMessageXML);

	if (ErrorReported())
	{
		AddInside("FAILMESSAGE",GetLastErrorAsXMLString());
	}

	return bOK;
}

