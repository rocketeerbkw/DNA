// UserComplaintPageBuilder.cpp: implementation of the CUserComplaintPageBuilder class.
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
#include "UserComplaintPageBuilder.h"
#include "TDVString.h"
#include "InputContext.h"
#include "OutputContext.h"
#include "InputContext.h"
#include "PageUI.h"
#include "WholePage.h"
#include "StoredProcedure.h"
#include "TDVAssert.h"
#include "MediaAssetModController.h"
#include "EmailAddressFilter.h"
#include "SiteOptions.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CUserComplaintPageBuilder::CUserComplaintPageBuilder(CInputContext& inputContext)

	Author:		Kim Harries
	Created:	07/02/2001
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CUserComplaintPageBuilder object.

*********************************************************************************/

CUserComplaintPageBuilder::CUserComplaintPageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext),
	m_pSP(NULL),
	m_sCommand("View"),
	m_sType("Unspecified"),
	m_sURL(""),
	m_sModerationReference(""),
	m_ih2g2ID(0),
	m_iUserID(0),
	m_iPostID(0),
	m_iModID(0)
{
	// no further contruction required
}

/*********************************************************************************

	CUserComplaintPageBuilder::~CUserComplaintPageBuilder()

	Author:		Kim Harries
	Created:	07/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor for the CUserComplaintPageBuilder class.

*********************************************************************************/

CUserComplaintPageBuilder::~CUserComplaintPageBuilder()
{
	// make sure SP is deleted
	delete m_pSP;
	m_pSP = NULL;
}

/*********************************************************************************

	CWholePage* CUserComplaintPageBuilder::Build()

	Author:		Kim Harries
	Created:	07/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	ptr to a CWholePage containing the XML data, NULL for failure
	Purpose:	???

*********************************************************************************/

bool CUserComplaintPageBuilder::Build(CWholePage* pWholePage)
{
	CUser*	pViewer = NULL;
	bool	bSuccess = true;
	bool	bEmailBanned = false;

	// get the viewing user
	pViewer = m_InputContext.GetCurrentUser();
	// if registered then we will want their email address
	if (pViewer != NULL)
	{
		pViewer->SetIDNameEmailVisible();

		// Check to see if the users email is banned
		bEmailBanned = pViewer->GetIsBannedFromComplaints();
	}

	// initiliase the whole page object and set the page type
	bSuccess = InitPage(pWholePage, "USER-COMPLAINT",true);

	// first get any details about the type of complaint
	if (!m_InputContext.GetParamString("Type", m_sType))
	{
		// try to figure out complaint type from other parameters
		if (m_InputContext.ParamExists("h2g2ID"))
		{
			m_sType = "ARTICLE";
		}
		else if (m_InputContext.ParamExists("PostID"))
		{
			m_sType = "POST";
		}
		else if (m_InputContext.ParamExists("URL"))
		{
			m_sType = "GENERAL";
		}
		else if (m_InputContext.ParamExists("MAID"))
		{
			m_sType = "MEDIAASSET";
		}
		else
		{
			m_sType = "UNKOWN";
		}
	}
	// get url parameters
	m_ih2g2ID = m_InputContext.GetParamInt("h2g2ID");
	m_iPostID = m_InputContext.GetParamInt("PostID");
	m_iMediaAssetID = m_InputContext.GetParamInt("MAID");
	
	m_InputContext.GetParamString("URL", m_sURL);
	// find out any command parameter from the url
	if (m_InputContext.ParamExists("Submit"))
	{
		m_sCommand = "Submit";
	}
	else
	{
		m_sCommand = "View";
	}

	CTDVString sXML = "";

	// Check to see if we're banned from complaining with this email
	if (bEmailBanned)
	{
		CreateBannedComplaintsXML(sXML);
	}
	else
	{
		// first process complaint submission, if any
		bSuccess = bSuccess && ProcessSubmission(pViewer, sXML);
		
		if (m_sCommand.CompareText("Submit") && bSuccess)
		{
			// if the submission has been successfully processed display a message
			sXML << "<USER-COMPLAINT-FORM TYPE='" << m_sType << "'>";
			sXML << "<MESSAGE TYPE='SUBMIT-SUCCESSFUL'>Your complaint was successfully submitted.</MESSAGE>";
			sXML << "<MODERATION-REFERENCE MOD-ID='" << m_iModID << "'>" << m_sModerationReference << "</MODERATION-REFERENCE>";
			sXML << "</USER-COMPLAINT-FORM>";
		}
		else if (m_sCommand.CompareText("View"))
		{
			// build the submission form
			bSuccess = bSuccess && CreateForm(pViewer, &sXML);
		}
	}

	// then add the form XML into the page
	bSuccess = pWholePage->AddInside("H2G2", sXML);

	// make sure any unneeded objects are deleted then return the success value
	TDVASSERT(bSuccess, "CUserComplaintPageBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CUserComplaintPageBuilder::ProcessSubmission(CUser* pViewer, CTDVString& sXML)

	Author:		Kim Harries
	Created:	07/02/2001
	Inputs:		pViewer - the viewing user (also the complainant)
	Outputs:	-
	Returns:	true for success
	Purpose:	Processes any submission of a complaint

*********************************************************************************/
bool CUserComplaintPageBuilder::ProcessSubmission(CUser* pViewer, CTDVString& sXML)
{
	bool	bSuccess = true;
	bool	bPostHidden = false;

	// check if there is a submission to process first
	if (m_sCommand.CompareText("Submit"))
	{
		// get an SP object if we haven't already
		if (m_pSP == NULL)
		{
			m_pSP = m_InputContext.CreateStoredProcedureObject();
		}
		
		if (m_pSP == NULL)
		{
			return false;
		}

		// must get the correspondence email address and complaint text
		CTDVString	sCorrespondenceEmail;
		CTDVString	sComplaintText;

		m_InputContext.GetParamString("EmailAddress", sCorrespondenceEmail);

		if (IsEMailBannedFromComplaining(sCorrespondenceEmail))
		{
			CreateBannedComplaintsXML(sXML);
			return true;
		}

		int countParams = m_InputContext.GetParamCount("ComplaintText");
		for (int i=0; i < countParams; i++)
		{
			CTDVString parmValue;
			m_InputContext.GetParamString("ComplaintText",parmValue, i);
			if (i > 0)
			{
				sComplaintText << "\r\n";
			}
			sComplaintText << parmValue;
		}

		// get the complaintant's user ID if they have one
		int	iComplainantID = 0;

		if (pViewer != NULL)
		{
			iComplainantID = pViewer->GetUserID();
		}
		// process differently depending on type of complaint
		if (m_sType.CompareText("ARTICLE"))
		{
			if (!(m_ih2g2ID > 0))
			{
				// complaint submitted without context.
				sXML << CreateErrorXML("NOARTICLEID","The submitted complaint did not include an article id. A complaint can not be processed without contextual information.");
				return false;
			}
			else if ( sComplaintText.IsEmpty() )
			{
				sXML << CreateErrorXML("NOREASON","Please re-submit your complaint, the submitted complaint did not include a complaint reason.");
				return false;
			}
            else if (  !pViewer || !m_InputContext.DoesCurrentSiteHaveSiteOptionSet("General","IsKidsSite" ) )
            {
                //Check email address if not kids site and no user.
                CEmailAddressFilter emailfilter;
                if ( !emailfilter.CheckForEmailAddresses(sCorrespondenceEmail) )
                {
				    sXML << CreateErrorXML("NOEMAIL","Please re-submit your complaint, the submitted complaint did not include a valid correspondence email address.");
				    return false;
                }
			}

			bSuccess = bSuccess && m_pSP->RegisterArticleComplaint(iComplainantID, m_ih2g2ID, sCorrespondenceEmail, sComplaintText, m_InputContext.GetIPAddress(),m_InputContext.GetBBCUIDFromCookie());
			m_sModerationReference = "A";

			int iMediaAssetID = 0;
			CTDVString	sMediaAssetMimeType="";
			if(!m_pSP->IsEOF())
			{
				iMediaAssetID = m_pSP->GetIntField("MediaAssetID");
				if (iMediaAssetID > 0)
				{
                    m_pSP->GetField("MimeType", sMediaAssetMimeType);
				}
			}
			if (iMediaAssetID > 0)
			{
				CMediaAssetModController oMediaAssetModController(m_InputContext);
				oMediaAssetModController.Requeue(iMediaAssetID, sMediaAssetMimeType, true);
			}

		}
		else if (m_sType.CompareText("POST"))
		{
			if (!(m_iPostID > 0))
			{
				// complaint submitted without context.
				sXML << CreateErrorXML("NOPOSTID","The submitted complaint did not include a post id. Complaints can not be processed without contextual information.");
				return false;
			}
			else if ( sComplaintText.IsEmpty() )
			{
				sXML << CreateErrorXML("NOREASON","Please re-submit your complaint, the submitted complaint did not include a complaint reason.");
				return false;
			}
            else if (  !pViewer || !m_InputContext.DoesCurrentSiteHaveSiteOptionSet("General","IsKidsSite" ) )
            {
                //Check email address if not kids site and no user.
                CEmailAddressFilter emailfilter;
                if ( !emailfilter.CheckForEmailAddresses(sCorrespondenceEmail) )
                {
				    sXML << CreateErrorXML("NOEMAIL","Please re-submit your complaint, the submitted complaint did not include a valid correspondence email address.");
				    return false;
                }
			}

			bSuccess = bSuccess && m_pSP->RegisterPostingComplaint(iComplainantID, m_iPostID, sCorrespondenceEmail, sComplaintText, m_InputContext.GetIPAddress(),m_InputContext.GetBBCUIDFromCookie());
			m_sModerationReference = "P";

			//Check for Hidden
			if( bSuccess && pViewer && pViewer->GetIsEditor() && (m_InputContext.GetParamInt(_T("HidePost")) > 0) )
			{
				CStoredProcedure	SP;
				bSuccess = m_InputContext.InitialiseStoredProcedureObject(&SP);
				if ( bSuccess )
				{
					bSuccess = bPostHidden =  SP.HidePost(m_iPostID,CStoredProcedure::HIDDENSTATUSCOMPLAINT);
				}
			}
		}
		else if (m_sType.CompareText("MEDIAASSET"))
		{
			CTDVString	sMimeType;

			m_InputContext.GetParamString("MimeType", sMimeType);
			if (!(m_iMediaAssetID > 0))
			{
				// complaint submitted without context.
				sXML << CreateErrorXML("NOMEDIAASSETID","The submitted complaint did not include a media asset id. Complaints can not be processed without contextual information.");
				return false;
			}
			if (sMimeType.IsEmpty())
			{
				// complaint submitted without context.
				sXML << CreateErrorXML("NOMIMETYPE","The submitted complaint did not include the mimetype of the media asset.");
				return false;
			}
            else if ( sComplaintText.IsEmpty() )
			{
				sXML << CreateErrorXML("NOREASON","Please re-submit your complaint, the submitted complaint did not include a complaint reason. ");
				return false;
			}
			else if (  !pViewer || !m_InputContext.DoesCurrentSiteHaveSiteOptionSet("General","IsKidsSite" ) )
            {
                //Check email address if not kids site and no user.
                CEmailAddressFilter emailfilter;
                if ( !emailfilter.CheckForEmailAddresses(sCorrespondenceEmail) )
                {
				    sXML << CreateErrorXML("NOEMAIL","Please re-submit your complaint, the submitted complaint did not include a valid correspondence email address.");
				    return false;
                }
			}

			bSuccess = bSuccess && m_pSP->QueueMediaAssetForModeration(m_iMediaAssetID, m_InputContext.GetSiteID(), iComplainantID, sCorrespondenceEmail, sComplaintText);
			m_sModerationReference = "MA";

		}
		else
		{
			if (m_sURL.IsEmpty())
			{
				sXML << CreateErrorXML("NOURL","The submitted complaint did not include a url. Complaints can not be processed without contextual information.");
				return false;
			}
			else if ( sComplaintText.IsEmpty() )
			{
				sXML << CreateErrorXML("NOREASON","Please re-submit your complaint, the submitted complaint did not include a complaint reason. ");
				return false;
			}
            else if (  !pViewer || !m_InputContext.DoesCurrentSiteHaveSiteOptionSet("General","IsKidsSite" ) )
            {
                //Check email address if not kids site.
                CEmailAddressFilter emailfilter;
                if ( !emailfilter.CheckForEmailAddresses(sCorrespondenceEmail) )
                {
				    sXML << CreateErrorXML("NOEMAIL","Please re-submit your complaint, the submitted complaint did not include a correspondence email address.");
				    return false;
                }
			}
			bSuccess = bSuccess && m_pSP->RegisterGeneralComplaint(iComplainantID, m_sURL, sCorrespondenceEmail, sComplaintText, m_InputContext.GetSiteID(), m_InputContext.GetIPAddress(),m_InputContext.GetBBCUIDFromCookie());
			m_sModerationReference = "G";
		}

		// if successful then get the moderation ID and build the moderation reference
		// and send an email to the feedback address
		if (bSuccess)
		{
			m_iModID = m_pSP->GetIntField("ModID");
			m_sModerationReference << m_iModID;

			CTDVString	sFromAddress = "";
			CTDVString	sFromName = "";
			CTDVString	sEmailSubject = "";
			CTDVString	sEmailText = "";

			if (pViewer == NULL)
			{
				// if we have an email address use this as the from name, else use anonymous
				if (sCorrespondenceEmail.GetLength() > 0)
				{
					sFromName = sCorrespondenceEmail;
				}
				else
				{
					sFromName = "Anonymous";
				}
			}
			else
			{
				// if we have a registered user then use their nickname as the from name if they have one
				pViewer->GetUsername(sFromName);

				// if they have set no username then user Researcher XXX format
				if (sFromName.GetLength() == 0)
				{
					sFromName << "Researcher " << pViewer->GetUserID();
				}
				else
				{
					sFromName << " (U" << pViewer->GetUserID() << ")";
				}

				if ( pViewer->GetIsEditor() )
				{
					sFromName << " (Editor)";
				}
			}
			// if we have a correspondence email use it as the from address, else
			// set it to an arbitrary value
			if (sCorrespondenceEmail.GetLength() > 0)
			{
				sFromAddress = sCorrespondenceEmail;
			}
			else
			{
				sFromAddress = "Anonymous";
			}
			// set the email subject and text
			sEmailSubject << "Complaint from " << sFromName;
			sEmailText << "Complaint from: " << sFromName << "\r\n";
			sEmailText << "Moderation Reference: " << m_sModerationReference << "\r\n";
			if (m_sType.CompareText("ARTICLE"))
			{
				sEmailSubject << " about Entry A" << m_ih2g2ID;
				sEmailText << "Complaint about Entry A" << m_ih2g2ID;
			}
			else if (m_sType.CompareText("POST"))
			{
				sEmailSubject << " about Post " << m_iPostID;
				sEmailText << "Complaint about Post " << m_iPostID;
				if ( bPostHidden )
				{
					sEmailSubject << " (HIDDEN)";
					sEmailText << " (HIDDEN)";
				}
			}
			else if (m_sType.CompareText("MEDIAASSET"))
			{
				sEmailSubject << " about MediaAsset MA" << m_iMediaAssetID;
				sEmailText << "Complaint about MediaAsset MA" << m_iMediaAssetID;
			}
			else
			{
				sEmailSubject << " about page " << m_sURL;
				sEmailText << "Complaint about page " << m_sURL;
			}
			sEmailText << "\r\n\r\n";
			sEmailText << sComplaintText;

			CTDVString sModeratorsEmail;
			m_InputContext.GetEmail(EMAIL_MODERATORS, sModeratorsEmail, m_InputContext.GetSiteID());
			SendMail(sModeratorsEmail, sEmailSubject, sEmailText, sFromAddress, sFromName);
		}
	}
	return bSuccess;
}

/*********************************************************************************

	bool CUserComplaintPageBuilder::CreateForm(CUser* pViewer, CTDVString* psFormXML)

	Author:		Kim Harries
	Created:	07/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Creates the XML for the form on the moderate article page.

*********************************************************************************/

bool CUserComplaintPageBuilder::CreateForm(CUser* pViewer, CTDVString* psFormXML)
{
	TDVASSERT(psFormXML != NULL, "NULL psFormXML in CUserComplaintPageBuilder::CreateForm(...)");
	// fail if no output variable given
	if (psFormXML == NULL)
	{
		return false;
	}

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

	CTDVString		sText;
	CTDVString		sSubject;
	CTDVString		sAuthorName;
	CTDVDateTime	dtDateCreated;
	int				iEntryID = 0;
	int				iAuthorID = 0;
	int				iThreadID = 0;
	int				iForumID = 0;
	int				iStatus = 0;
	bool			bHidden = false;

	*psFormXML = "";
	*psFormXML << "<USER-COMPLAINT-FORM TYPE='" << m_sType << "'>";

	// get specific details and add them to the form
	if (m_sType.CompareText("ARTICLE"))
	{
		if (!(m_ih2g2ID > 0))
		{
			// complaint submitted without context.
			*psFormXML << "<ERROR TYPE='NOARTICLEID'>The submitted complaint did not include an article id. Complaints can not be processed without contextual information.</ERROR>";
		}
		else 
		{
			bSuccess = bSuccess && m_pSP->FetchArticleDetails(m_ih2g2ID / 10);
			m_pSP->GetField("Subject", sSubject);
			m_pSP->GetField("EditorName", sAuthorName);
			dtDateCreated = m_pSP->GetDateField("DateCreated");
			iEntryID = m_pSP->GetIntField("EntryID");
			iAuthorID = m_pSP->GetIntField("Editor");
			iStatus = m_pSP->GetIntField("Status");
			bHidden = !m_pSP->IsNULL("Hidden");

			*psFormXML << "<ENTRY-ID>" << iEntryID << "</ENTRY-ID>";
			*psFormXML << "<H2G2-ID>" << m_ih2g2ID << "</H2G2-ID>";

			// don't show author or subject if article is already hidden
			if (bHidden)
			{
				*psFormXML << "<MESSAGE TYPE='ALREADY-HIDDEN'/>";
			}
			else if (iStatus == 7)
			{
				*psFormXML << "<MESSAGE TYPE='DELETED'/>";
			}
			else
			{
				*psFormXML << "<AUTHOR><USER>";
				*psFormXML << "<USERID>" << iAuthorID << "</USERID>";
				*psFormXML << "<USERNAME>" << sAuthorName << "</USERNAME>";
				*psFormXML << "</USER></AUTHOR>";
				*psFormXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
			}
		}
	}
	else if (m_sType.CompareText("POST"))
	{
		if (!(m_iPostID > 0))
		{
			// complaint submitted without context.
			*psFormXML << "<ERROR TYPE='NOPOSTID'>The submitted complaint did not include a post id. Complaints can not be processed without contextual information.</ERROR>";
		}
		else 
		{
			bSuccess = bSuccess && m_pSP->FetchPostDetails(m_iPostID);
			m_pSP->GetField("Subject", sSubject);
			iThreadID = m_pSP->GetIntField("ThreadID");
			iForumID = m_pSP->GetIntField("ForumID");
			iAuthorID = m_pSP->GetIntField("UserID");
			m_pSP->GetField("UserName", sAuthorName);
			bHidden = !m_pSP->IsNULL("Hidden");

			bool bCanRead = true;
			bool bCanWrite = true;
			if (pViewer != NULL) 
			{
				m_pSP->GetThreadPermissions(pViewer->GetUserID(), iThreadID, bCanRead, bCanWrite);
			}
			else
			{
				m_pSP->GetThreadPermissions(0, iThreadID, bCanRead, bCanWrite);
			}

			*psFormXML << "<POST-ID>" << m_iPostID << "</POST-ID>";
			*psFormXML << "<THREAD-ID>" << iThreadID << "</THREAD-ID>";
			*psFormXML << "<FORUM-ID>" << iForumID << "</FORUM-ID>";
			// don't show subject and author if post is already hidden
			if (bHidden || !bCanRead)
			{
				*psFormXML << "<MESSAGE TYPE='ALREADY-HIDDEN'/>";
			}
			else
			{
				*psFormXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
				*psFormXML << "<AUTHOR><USER>";
				*psFormXML << "<USERID>" << iAuthorID << "</USERID>";
				*psFormXML << "<USERNAME>" << sAuthorName << "</USERNAME>";
				*psFormXML << "</USER></AUTHOR>";
			}
		}
	}
	else if (m_sType.CompareText("GENERAL"))
	{
		// for general complaints the only info we have is the URL
		if (m_sURL.IsEmpty())
		{
			// complaint submitted without context.
			*psFormXML << "<ERROR TYPE='NOURL'>The submitted complaint did not include a url. Complaints can not be processed without contextual information.</ERROR>";
		}
		else
		{
			*psFormXML << "<URL>" << m_sURL << "</URL>";
		}
	}
	else if (m_sType.CompareText("MEDIAASSET"))
	{
		if (!(m_iMediaAssetID > 0))
		{
			// complaint submitted without context.
			*psFormXML << "<ERROR TYPE='NOMEDIAASSETID'>The submitted complaint did not include a media asset id. Complaints can not be processed without contextual information.</ERROR>";
		}
		else 
		{
			CTDVString		sMimeType;

			bSuccess = bSuccess && m_pSP->GetMediaAsset(m_iMediaAssetID, m_InputContext.GetSiteID());
			m_pSP->GetField("Caption", sSubject);
			dtDateCreated = m_pSP->GetDateField("DateCreated");
			iAuthorID = m_pSP->GetIntField("OwnerID");
			iStatus = m_pSP->GetIntField("Status");
			m_pSP->GetField("MimeType", sMimeType);

			*psFormXML << "<MEDIAASSET-ID>" << m_iMediaAssetID << "</MEDIAASSET-ID>";

			*psFormXML << "<OWNER><USER>";
			*psFormXML << "<USERID>" << iAuthorID << "</USERID>";
			*psFormXML << "</USER></OWNER>";
			*psFormXML << "<CAPTION>" << sSubject << "</CAPTION>";
			*psFormXML << "<MIMETYPE>" << sMimeType << "</MIMETYPE>";
			*psFormXML << "<STATUS>" << iStatus << "</STATUS>";
		}
	}
	else if (m_sType.CompareText("UNKOWN"))
	{
		// for unkown complaints without a context return an erro
		*psFormXML << "<ERROR TYPE='UNKOWNCOMPLAINT'>No complaint context supplied.</ERROR>";
	}
	*psFormXML << "</USER-COMPLAINT-FORM>";
	return bSuccess;
}

/*********************************************************************************

	bool CUserComplaintPageBuilder::IsEMailBannedFromComplaining(CTDVString sEmail)

		Author:		Mark Howitt
		Created:	10/12/2007
		Inputs:		sEmail - The email address that you want to check to see if it is banned
		Outputs:	-
		Returns:	True if the email is banned from being used for complaining, false if not
		Purpose:	Checks to see if the given email address for the complaint is in the banned emails list

*********************************************************************************/
bool CUserComplaintPageBuilder::IsEMailBannedFromComplaining(CTDVString& sEmail)
{
	// Setup some locals
	bool bIsBanned = false;
	CStoredProcedure SP;

	// Create the storedprocedure
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (SP.IsEmailBannedFromComplaints(sEmail))
	{
		bIsBanned = SP.GetIntField("IsBanned") > 0;
	}

	// Return the virdict
	return bIsBanned;
}

/*********************************************************************************

	void CUserComplaintPageBuilder::CreateBannedComaplaintsXML(CTDVString& sXML)

		Author:		Mark HOwitt
		Created:	11/12/2007
		Inputs:		sXML - The string that will take the xml for the banned from comaplints information
		Outputs:	-
		Returns:	-
		Purpose:	Adds the XML Block for the banned from complaints error

*********************************************************************************/
void CUserComplaintPageBuilder::CreateBannedComplaintsXML(CTDVString& sXML)
{
	sXML << "<USER-COMPLAINT-FORM TYPE='" << m_sType << "'>";
	if (m_sType == "ARTICLE")
	{
		sXML << "<H2G2-ID>" << m_ih2g2ID << "</H2G2-ID>";
	}
	else if (m_sType == "POST")
	{
		sXML << "<POST-ID>" << m_iPostID << "</POST-ID>";
	}
	else if (m_sType == "GENERAL")
	{
		sXML << "<URL>" << m_sURL << "</URL>";
	}

	sXML << "<ERROR TYPE='EMAILNOTALLOWED'>Not allowed to complain via email.</ERROR>";
	sXML << "</USER-COMPLAINT-FORM>";
}

/*********************************************************************************

	void CUserComplaintPageBuilder::CreateErrorXML(CTDVString& sXML)

		Author:		Martin Robb
		Created:	29/04/2008
		Inputs:		errtype - Error Type
					err - Error text
		Outputs:	-
		Returns:	-
		Purpose:	Returns the XML Block for the banned from complaints error

*********************************************************************************/
CTDVString CUserComplaintPageBuilder::CreateErrorXML(CTDVString errtype, CTDVString err)
{
	CTDVString sXML;
	sXML << "<USER-COMPLAINT-FORM TYPE='" << m_sType << "'>";
	sXML << "<ERROR TYPE='" + errtype + "'>";
	sXML << err;
	sXML << "</ERROR>";
	sXML << "</USER-COMPLAINT-FORM>";
	return sXML;
}