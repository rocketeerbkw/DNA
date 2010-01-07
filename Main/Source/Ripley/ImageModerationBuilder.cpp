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
#include "WholePage.h"
#include "PageUI.h"
#include "TDVAssert.h"
#include ".\imagemoderationbuilder.h"
#include "ImageModeration.h"
#include "ModerationEmail.h"
#include "UploadedObject.h"
#include "RefereeList.h"

#if defined (_ADMIN_VERSION)

const bool EMAIL_REFERRAL = true;
const bool EMAIL_NOT_REFERRAL = false;

CImageModerationBuilder::CEmailNameMap CImageModerationBuilder::m_AuthorEmailMap;
CImageModerationBuilder::CEmailNameMap CImageModerationBuilder::m_ComplainantEmailMap;

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CImageModerationBuilder::CImageModerationBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CImageModerationBuilder object.

*********************************************************************************/

CImageModerationBuilder::CImageModerationBuilder(CInputContext& inputContext) 
	:
	CXMLBuilder(inputContext),
	m_sCommand("View"),
	m_Image(inputContext),
	m_ImageModeration(inputContext),
	m_Email(inputContext)
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;

	if (!m_AuthorEmailMap.size())
	{
		m_AuthorEmailMap[CImageModeration::FAIL] = "ContentRemovedEmail";
		m_AuthorEmailMap[CImageModeration::FAILEDIT] = "ContentFailedAndEditedEmail";
	}

	if (!m_ComplainantEmailMap.size())
	{
		m_ComplainantEmailMap[CImageModeration::PASS] = "RejectComplaintEmail";
		m_ComplainantEmailMap[CImageModeration::FAIL] = "UpholdComplaintEmail";
		m_ComplainantEmailMap[CImageModeration::FAILEDIT] = "UpholdComplaintEditEntryEmail";
	}

}

/*********************************************************************************

	CImageModerationBuilder::~CImageModerationBuilder()

	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CImageModerationBuilder::~CImageModerationBuilder()
{
}

/*********************************************************************************

	CWholePage* CImageModerationBuilder::Build()

	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the page allowing staff to moderate forum postings.

*********************************************************************************/

bool CImageModerationBuilder::Build(CWholePage* pWholePage)
{
	InitPage(pWholePage, "IMAGE-MODERATION", true);
	bool bSuccess = true;

	// do an error page if not an editor or moderator
	// otherwise proceed with the process recommendation page
	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsModerator()))
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", 
			"<ERROR TYPE='NOT-EDITOR'>You cannot perform moderation "\
			"unless you are logged in as an Editor or Moderator.</ERROR>");
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
		ProcessSubmission(pViewer);

		if (m_sCommand.CompareText("Next"))
		{
			// then create the XML for the form to be displayed
			CTDVString	sFormXML = "";
			bSuccess = bSuccess && CreateForm(pViewer, sFormXML);
			// insert the form XML into the page
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", sFormXML);

			CTDVString sSiteXML;
			bSuccess = bSuccess && m_InputContext.GetSiteListAsXML(&sSiteXML, 2);
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", sSiteXML);

			CRefereeList refereeList(m_InputContext);
			bSuccess = bSuccess && refereeList.FetchTheList();
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", &refereeList);
		}
		else	//Done
		{
			// if a successful 'Done' request then redirect to the 
			//Moderation Home Page
			pWholePage->Redirect("Moderate");
		}
	}

	TDVASSERT(bSuccess, "CImageModerationBuilder::Build() failed");
	return bSuccess;
}


void CImageModerationBuilder::CFormParams::ReadFormParams(CInputContext& inputContext, int i)
{
	m_iImageId = inputContext.GetParamInt("ImageID", i);
	m_iModId = inputContext.GetParamInt("ModID", i);
	m_iStatus = inputContext.GetParamInt("Decision", i);
	m_iReferTo = inputContext.GetParamInt("ReferTo", i);
	m_iSiteId = inputContext.GetParamInt("SiteID", i);
	if (!inputContext.GetParamString("EmailType", m_sEmailType, i))
	{
		m_sEmailType = "";
	}
	if (!inputContext.GetParamString("CustomEmailText", m_sCustomText, i))
	{
		m_sCustomText = "";
	}
	if (!inputContext.GetParamString("Notes", m_sNotes, i))
	{
		m_sNotes = "";
	}
}


/*********************************************************************************

	bool CImageModerationBuilder::ProcessSubmission(CUser* pViewer)

	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Processes any submission of moderation decisions made

*********************************************************************************/

bool CImageModerationBuilder::ProcessSubmission(CUser* pViewer)
{
	// first get the total number of post IDs in the submission
	// - there should be an equal number of all the other parameters
	int iNumberOfImages = m_InputContext.GetParamCount("ImageID");

	for(int i = 0; i < iNumberOfImages; i++)
	{
		bool bSuccess = true;

		m_Form.ReadFormParams(m_InputContext, i);

		if (!ValidateParameters())
		{
			continue;
		}

		bSuccess = bSuccess && m_Image.Fetch(m_Form.m_iImageId);

		if (m_Form.m_iStatus == CImageModeration::UNREFER)
		{
			// unreferring is treated as a status, but is really a different kind of action
			bSuccess = bSuccess && m_ImageModeration.UnreferImage(m_Image,
				m_Form.m_iModId, m_Form.m_sNotes);
		}
		else
		{
			if (m_Form.m_sCustomText.GetLength() > 0)
			{
				m_Form.m_sNotes << "\r\n-----email insert------\r\n" 
					<< m_Form.m_sCustomText;
			}

			bSuccess = bSuccess && m_ImageModeration.ModerateImage(m_Image, 
				m_Form.m_iModId, m_Form.m_iStatus, m_Form.m_sNotes, 
				pViewer->GetUserID(), m_Form.m_iReferTo);

			if (!bSuccess)
			{
				m_sErrorXML << "<ERROR TYPE='MODERATION-FAILED'>Image library " \
					"failed to " 
					<< (m_Form.m_iStatus == CImageModeration::FAIL ? "reject " : "approve ") 
					<<  "the image " << m_Form.m_iImageId << "</ERROR>";
			}

			// send the appropriate emails to the author and/or complainant if necessary
			// first if failed and we have a reason (which we always should) 
			//send an explanation to the author
			if ((m_Form.m_iStatus == CImageModeration::FAIL 
				|| m_Form.m_iStatus == CImageModeration::FAILEDIT) 
				&& !m_Form.m_sEmailType.IsEmpty())
			{
				if(!EmailAuthor())
				{
					m_sErrorXML << "<ERROR TYPE='AUTHOR-EMAIL-FAILED'>Email " \
						"failed to be sent to author of failed item (ID=" 
						<< m_Form.m_iModId << "), email address " 
						<< m_ImageModeration.GetAuthorsEmail() << "</ERROR>";
				}
			}

			//second, if a complaint and either passed or failed, then let the 
			//complainant know the decision
			if (m_ImageModeration.GetComplainantsEmail()[0] && 
				(m_Form.m_iStatus == CImageModeration::PASS 
				|| m_Form.m_iStatus == CImageModeration::FAIL 
				|| m_Form.m_iStatus == CImageModeration::FAILEDIT))
			{
				if (!EmailComplainant())
				{
					m_sErrorXML << "<ERROR TYPE='COMPLAINANT-EMAIL-FAILED'>" \
						"Email failed to be sent to complainant for moderation item " \
						"(ID=" << m_Form.m_iModId << "), email address " << 
						m_ImageModeration.GetComplainantsEmail() << "</ERROR>";
				}
			}
		}
	}

	return true;
}

bool CImageModerationBuilder::EmailAuthor()
{
	CTDVString sModeratorsEmail;
	CTDVString sSiteShortName;
	m_InputContext.GetEmail(EMAIL_MODERATORS, sModeratorsEmail, m_Form.m_iSiteId);
	m_InputContext.GetShortName(sSiteShortName, m_Form.m_iSiteId);

	CSubst subst;
	GetEmailParams(EMAIL_REFERRAL, subst);

	CTDVString sAuthorEmailSubject;
	CTDVString sAuthorEmailText;
	m_Email.GetEmail(m_AuthorEmailMap[m_Form.m_iStatus], m_Form.m_iSiteId, 
		&subst, sAuthorEmailSubject, sAuthorEmailText);

	return SendMailOrSystemMessage(m_ImageModeration.GetAuthorsEmail(), 
		sAuthorEmailSubject, sAuthorEmailText, 
		sModeratorsEmail, sSiteShortName, false, m_ImageModeration.GetAuthorID(), m_Form.m_iSiteId);
}

bool CImageModerationBuilder::EmailComplainant()
{
	CTDVString sModeratorsEmail;
	CTDVString sSiteShortName;
	m_InputContext.GetEmail(EMAIL_MODERATORS, sModeratorsEmail, m_Form.m_iSiteId);
	m_InputContext.GetShortName(sSiteShortName, m_Form.m_iSiteId);

	CSubst subst;
	GetEmailParams(EMAIL_NOT_REFERRAL, subst);

	CTDVString sEmailSubject;
	CTDVString sEmailText;
	m_Email.GetEmail(m_ComplainantEmailMap[m_Form.m_iStatus], m_Form.m_iSiteId, 
		&subst, sEmailSubject, sEmailText);

	return SendMailOrSystemMessage(m_ImageModeration.GetAuthorsEmail(), 
		sEmailSubject, sEmailText, 
		sModeratorsEmail, sSiteShortName, false, m_ImageModeration.GetComplainantID(), m_Form.m_iSiteId);

}

const CSubst& CImageModerationBuilder::GetEmailParams(bool bReferral, CSubst& subst)
{
	subst.clear(); 

	if (bReferral)
	{
		if (m_Form.m_sEmailType.GetLength())
		{
			subst["+++**inserted_text**++"] = m_Form.m_sEmailType;
		}
		if (m_Form.m_sCustomText.GetLength())
		{
			subst["++**inserted_text**++"] = m_Form.m_sCustomText;
		}
	}
	else
	{
		CTDVString	sRefNumber = "P";
		sRefNumber << m_Form.m_iModId;
		subst["++**reference_number**++"] = sRefNumber;
	}

	subst["++**content_type**++"] = m_Image.GetTypeName();
	subst["++**content_subject**++"] = m_Image.GetTag();
	subst["++**content_text**++"] = "";
	subst["++**content_url**++"] = m_Image.GetPublicUrl();

	return subst;
}

/*********************************************************************************

	bool CImageModerationBuilder::CreateForm(CUser* pViewer, CTDVString& sFormXml)

	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Creates the XML for the form on the posts moderation page.

*********************************************************************************/

bool CImageModerationBuilder::CreateForm(CUser* pViewer, CTDVString& sFormXml)
{
	bool bShowComplaints = false;
	{
		CTDVString sShowType;
		if (m_InputContext.GetParamString("Show", sShowType))
		{
			bShowComplaints = sShowType.CompareText("complaints");
		}
	}

	sFormXml = "";

	bool bReferrals = (m_InputContext.GetParamInt("Referrals") > 0);

	return m_ImageModeration.GetModerationBatchXml(pViewer->GetUserID(), 
		m_sErrorXML, bShowComplaints, bReferrals, sFormXml);
}

bool CImageModerationBuilder::ValidateParameters()
{
	if (m_Form.m_iModId <= 0 || m_Form.m_iImageId <= 0)
	{
		m_sErrorXML << "<ERROR TYPE='MISSING-DATA'>There was some data missing "\
			"from the request: either the ModID or ImageID</ERROR>";
		return false;
	}

	if ((m_Form.m_iStatus == CImageModeration::FAIL 
		|| m_Form.m_iStatus == CImageModeration::FAILEDIT) 
		&& m_Form.m_sEmailType.IsEmpty())
	{
		// a failed posting was not given a reason
		m_sErrorXML << "<ERROR TYPE='MISSING-FAILURE-REASON'>No failure "\
			"reason was provided (MODID=" << m_Form.m_iModId << ")</ERROR>";
		return false;
	}

	return true;
}

#endif // _ADMIN_VERSION

