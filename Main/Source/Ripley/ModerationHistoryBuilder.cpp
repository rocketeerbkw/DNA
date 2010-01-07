// ModerationHistoryBuilder.cpp: implementation of the CModerationHistoryBuilder class.
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
#include "ModerationHistoryBuilder.h"
#include "ModerateHomePageBuilder.h"
#include "GuideEntry.h"
#include "Forum.h"
#include "WholePage.h"
#include "TDVAssert.h"

#if defined (_ADMIN_VERSION)

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CModerationHistoryBuilder::CModerationHistoryBuilder(CInputContext& inputContext)
																			 ,
	Author:		Kim Harries
	Created:	15/03/2001
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CModerationHistoryBuilder object.

*********************************************************************************/

CModerationHistoryBuilder::CModerationHistoryBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext),
	m_pSP(NULL),
	m_ih2g2ID(0),
	m_iPostID(0),
	m_bValidID(false)
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************

	CModerationHistoryBuilder::~CModerationHistoryBuilder()

	Author:		Kim Harries
	Created:	15/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CModerationHistoryBuilder::~CModerationHistoryBuilder()
{
	// delete the SP
	delete m_pSP;
	m_pSP = NULL;
}

/*********************************************************************************

	CWholePage* CModerationHistoryBuilder::Build()

	Author:		Kim Harries
	Created:	15/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML for this page
	Purpose:	Constructs the XML for the article moderation history page.

*********************************************************************************/

bool CModerationHistoryBuilder::Build(CWholePage* pWholePage)
{
	CUser*			pViewer = NULL;
	bool			bSuccess = true;

	// get the viewing user
	pViewer = m_InputContext.GetCurrentUser();
	// initiliase the whole page object and set the page type
	bSuccess = InitPage(pWholePage, "MODERATION-HISTORY",false);

	// do an error page if not an editor or moderator
	// otherwise proceed with the process recommendation page
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsModerator()))
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot perform moderation unless you are logged in as an Editor or a Moderator.</ERROR>");
	}
	else
	{
		CTDVString	sXML = "";

		CTDVString sh2g2ID, sPostID;
		m_InputContext.GetParamString("h2g2ID",sh2g2ID);
		// get the h2g2ID from the request
		m_bValidID = CGuideEntry::GetH2G2IDFromString(sh2g2ID,&m_ih2g2ID);
		// likewise any post ID

		m_InputContext.GetParamString("PostID",sPostID);

		CForum::GetPostIDFromString(sPostID,&m_iPostID);

		if (m_InputContext.ParamExists("Reference"))
		{
			CTDVString sReference;
			m_InputContext.GetParamString("Reference",sReference);
			bool bProcessedReference = ProcessReferenceNumber(sReference);
		}

		// if we have been given an h2g2 ID and it is not valid then show an error message
		if (!m_bValidID && m_ih2g2ID > 0 && m_iPostID <= 0)
		{
			sXML << "<ERROR TYPE='INVALID-H2G2ID'>The Entry ID entered is not valid.</ERROR>";
			bSuccess = bSuccess && pWholePage->AddInside("H2G2", sXML);
			sXML = "";
		}
		// create the XML for the history of this articles moderation
		bSuccess = bSuccess && CreateHistoryXML(&sXML);
		// insert XML into the page
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", sXML);
	}
	// make sure any unneeded objects are deleted then return the success value
	TDVASSERT(bSuccess, "CModerationHistoryBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CModerationHistoryBuilder::ProcessReferenceNumber(const CTDVString& sReference)

	Author:		Dharmesh Raithatha
	Created:	2/21/02
	Inputs:		sReference - complaint reference beginning with A or P
	Outputs:	-
	Returns:	true if the value of m_ih2g2Id or m_PostID was changed
	Purpose:	Find what the sReference is referring to and sets that value

*********************************************************************************/

bool CModerationHistoryBuilder::ProcessReferenceNumber(const CTDVString& sReference)
{

	if (m_ih2g2ID > 0 || m_iPostID > 0)
	{
		return false;
	}

	if (sReference.IsEmpty())
	{
		return false;
	}

	bool bIsArticle = false;
	bool bIsPost = false;

	if (sReference.GetAt(0) == 'A' || sReference.GetAt(0) == 'a')
	{
		bIsArticle = true;
	}
	else if (sReference.GetAt(0) == 'P' || sReference.GetAt(0) == 'p')
	{
		bIsPost = true;
	}

	if (bIsArticle || bIsPost)
	{		
		CTDVString sNumber = sReference;
		sNumber.RemoveLeftChars(1);
		int iModID = atoi(sNumber);

		if (iModID > 0)
		{
			CStoredProcedure mSP;
			if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
			{
				return false;
			}

			if (bIsArticle)
			{
				int ih2g2ID = 0;
				if (mSP.GetArticleModDetailsFromModID(iModID))
				{
					ih2g2ID = mSP.GetIntField("h2g2ID");
					
					if (ih2g2ID > 0)
					{
						m_ih2g2ID = ih2g2ID;
						m_bValidID = true;
						return true;
					}
				}
				return false;
			}
			else if (bIsPost)
			{
				int iPostID = 0;
				if (mSP.GetThreadModDetailsFromModID(iModID))
				{
					iPostID = mSP.GetIntField("PostID");
					
					if (iPostID > 0)
					{
						m_iPostID = iPostID;
						return true;
					}
				}
				return false;
			}

			return false;
		}
	}

	return false;
}

/*********************************************************************************

	bool CModerationHistoryBuilder::CreateHistoryXML(CTDVString* psXML)

	Author:		Kim Harries
	Created:	15/03/2001
	Inputs:		-
	Outputs:	psXML - the string to store the XML
	Returns:	-
	Purpose:	Creates the XML representing this articles moderation history.

*********************************************************************************/

bool CModerationHistoryBuilder::CreateHistoryXML(CTDVString* psXML)
{
	if (psXML == NULL)
	{
		TDVASSERT(false, "CModerationHistoryBuilder::CreateHistoryXML((...) called with NULL psXML");
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

	int				iModID = 0;
	int				iStatus = 0;
	CTDVDateTime	dtDateQueued;
	CTDVDateTime	dtDateLocked;
	CTDVDateTime	dtDateReferred;
	CTDVDateTime	dtDateCompleted;
	int				iLockedByID = 0;
	int				iReferredByID = 0;
	bool			bIsComplaint = false;
	int				iComplainantID = 0;
	int				iEditorID = 0;
	int				iNewItem = 0;
	CTDVString		sEditorName;
	CTDVString		sLockedByName;
	CTDVString		sReferredByName;
	CTDVString		sComplainantName;
	CTDVString		sComplainantEmail;
	CTDVString		sNotes;
	CTDVString		sComplaintText;
	CTDVString		sSubject;
	CTDVString		sCorrespondenceEmail;
	CTDVString		sTemp;
	CTDVString		sComplainantBBCUID;
	CTDVString      sComplainantIPAddress;
	bool			bGotHistory = false;
	bool			bSuccess = true;

	*psXML = "";
	// check if whether we have an entry ID, post ID or neither
	if (m_ih2g2ID > 0)
	{
		*psXML << "<MODERATION-HISTORY TYPE='ARTICLE' H2G2ID='" << m_ih2g2ID << "'>";
		// only get the history if we know this is a valid ID
		if (m_bValidID)
		{
			// call that funky stored procedure
			bSuccess = bSuccess && m_pSP->FetchArticleModerationHistory(m_ih2g2ID);
			bGotHistory = bSuccess;
		}
	}
	else if (m_iPostID > 0)
	{
		// call that funky stored procedure
		bSuccess = bSuccess && m_pSP->FetchPostModerationHistory(m_iPostID);
		bGotHistory = bSuccess;
		if (bSuccess)
		{
			if (!m_pSP->IsEOF())
			{
				int iForumID = m_pSP->GetIntField("ForumID");
				int iThreadID = m_pSP->GetIntField("ThreadID");

				*psXML << "<MODERATION-HISTORY TYPE='POST' POSTID='" << m_iPostID  
					<< "'FORUMID='" << iForumID << "' THREADID='" << iThreadID << "'>";
			}
			else
			{
				*psXML << "<MODERATION-HISTORY>";
			}
		}
	}
	else
	{
		// put in an empty tag if no details
		*psXML << "<MODERATION-HISTORY>";
	}
	// if we have got some history then fill in the details
	if (bGotHistory)
	{
		if (!m_pSP->IsEOF())
		{
			m_pSP->GetField("Subject", sSubject);
			iEditorID = m_pSP->GetIntField("EditorID");
			CXMLObject::EscapeAllXML(&sSubject);
			m_pSP->GetField("EditorName", sEditorName);
			CXMLObject::EscapeAllXML(&sEditorName);
			*psXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
			*psXML << "<EDITOR>";
			if (iEditorID > 0)
			{
				*psXML << "<USER>";
				*psXML << "<USERID>" << iEditorID << "</USERID>";
				*psXML << "<USERNAME>" << sEditorName << "</USERNAME>";
				*psXML << "</USER>";
			}
			*psXML << "</EDITOR>";
		}
		// get the data on each moderation item
		while (!m_pSP->IsEOF())
		{
			iModID = m_pSP->GetIntField("ModID");
			// if we don't have a mod ID there is no moderation for this item
			if (iModID > 0)
			{
				iStatus = m_pSP->GetIntField("Status");
				dtDateQueued = m_pSP->GetDateField("DateQueued");
				dtDateLocked = m_pSP->GetDateField("DateLocked");
				dtDateReferred = m_pSP->GetDateField("DateReferred");
				dtDateCompleted = m_pSP->GetDateField("DateCompleted");
				iLockedByID = m_pSP->GetIntField("LockedBy");
				iReferredByID = m_pSP->GetIntField("ReferredBy");
				bIsComplaint = !m_pSP->IsNULL("ComplainantID");
				iComplainantID = m_pSP->GetIntField("ComplainantID");
				iNewItem = m_pSP->GetIntField("NewItem");
				m_pSP->GetField("LockedByName", sLockedByName);
				m_pSP->GetField("ReferredByName", sReferredByName);
				m_pSP->GetField("ComplainantName", sComplainantName);
				m_pSP->GetField("ComplainantEmail", sComplainantEmail);
				m_pSP->GetField("CorrespondenceEmail", sCorrespondenceEmail);
				m_pSP->GetField("Notes", sNotes);
				m_pSP->GetField("ComplaintText", sComplaintText);
				m_pSP->GetField("IPAddress", sComplainantIPAddress);
				m_pSP->GetField("BBCUID", sComplainantBBCUID);
				// do XML escaping on any data that needs it
				CXMLObject::EscapeAllXML(&sNotes);
				CXMLObject::EscapeAllXML(&sComplaintText);
				CXMLObject::EscapeAllXML(&sLockedByName);
				CXMLObject::EscapeAllXML(&sReferredByName);
				CXMLObject::EscapeAllXML(&sComplainantName);
				CXMLObject::EscapeAllXML(&sComplainantEmail);
				CXMLObject::EscapeAllXML(&sCorrespondenceEmail);
				// wrap up that data in XML
				*psXML << "<MODERATION>";
				*psXML << "<MODERATION-ID>" << iModID << "</MODERATION-ID>";
				*psXML << "<MODERATION-STATUS>" << iStatus << "</MODERATION-STATUS>";
				//*psXML << "<LEGACY>" << ((iNewItem != 0)?0:1) << "</LEGACY>";
				*psXML << "<COMPLAINT>" << (int)bIsComplaint << "</COMPLAINT>";
				*psXML << "<LOCKED-BY>";
				if (iLockedByID > 0)
				{
					*psXML << "<USER>";
					*psXML << "<USERID>" << iLockedByID << "</USERID>";
					*psXML << "<USERNAME>" << sLockedByName << "</USERNAME>";
					*psXML << "</USER>";
				}
				*psXML << "</LOCKED-BY>";
				*psXML << "<REFERRED-BY>";
				if (iReferredByID > 0)
				{
					*psXML << "<USER>";
					*psXML << "<USERID>" << iReferredByID << "</USERID>";
					*psXML << "<USERNAME>" << sReferredByName << "</USERNAME>";
					*psXML << "</USER>";
				}
				*psXML << "</REFERRED-BY>";
				*psXML << "<COMPLAINANT>";
				if (bIsComplaint || iComplainantID > 0)
				{
					*psXML << "<USER>";
					*psXML << "<USERID>" << iComplainantID << "</USERID>";
					*psXML << "<USERNAME>" << sComplainantName << "</USERNAME>";
					*psXML << "<EMAIL>" << sComplainantEmail << "</EMAIL>";
					*psXML << "<CORRESPONDENCE-EMAIL>" << sCorrespondenceEmail << "</CORRESPONDENCE-EMAIL>";
					*psXML << "</USER>";
				}

				if ( m_InputContext.GetCurrentUser() && m_InputContext.GetCurrentUser()->GetIsSuperuser() )
				{
					*psXML << "<IPADDRESS>"  << sComplainantIPAddress << "</IPADDRESS>";
					*psXML << "<BBCUID>" << sComplainantBBCUID << "</BBCUID>";
				}
				*psXML << "</COMPLAINANT>";
				sTemp = "";
				if (dtDateQueued.GetYear() > 1900)
				{
					dtDateQueued.GetAsXML(sTemp);
				}
				*psXML << "<DATE-QUEUED>" << sTemp << "</DATE-QUEUED>";
				sTemp = "";
				if (dtDateLocked.GetYear() > 1900)
				{
					dtDateLocked.GetAsXML(sTemp);
				}
				*psXML << "<DATE-LOCKED>" << sTemp << "</DATE-LOCKED>";
				sTemp = "";
				if (dtDateReferred.GetYear() > 1900)
				{
					dtDateReferred.GetAsXML(sTemp);
				}
				*psXML << "<DATE-REFERRED>" << sTemp << "</DATE-REFERRED>";
				sTemp = "";
				if (dtDateCompleted.GetYear() > 1900)
				{
					dtDateCompleted.GetAsXML(sTemp);
				}
				*psXML << "<DATE-COMPLETED>" << sTemp << "</DATE-COMPLETED>";
				*psXML << "<COMPLAINT-TEXT>" << sComplaintText << "</COMPLAINT-TEXT>";
				*psXML << "<NOTES>" << sNotes << "</NOTES>";
				*psXML << "</MODERATION>";
			}
			m_pSP->MoveNext();
		}
	}
	*psXML << "</MODERATION-HISTORY>";

	return bSuccess;
}

#endif // _ADMIN_VERSION
