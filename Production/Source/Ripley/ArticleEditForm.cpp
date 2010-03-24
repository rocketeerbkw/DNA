// ArticleEditForm.cpp: implementation of the CArticleEditForm class.
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
#include "ripleyserver.h"
#include "TDVAssert.h"
#include "ArticleEditForm.h"
#include "GuideEntry.h"
#include "UserList.h"
#include "ModerationStatus.h"
#include "ProfanityFilter.h"
#include "URLFilter.h"
#include "EmailAddressFilter.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CArticleEditForm::CArticleEditForm(CInputContext& inputContext) :
	CXMLObject(inputContext),
	m_AuthorList(inputContext),
	m_h2g2ID(0),
	m_Format(0),
	m_Status(0),
	m_EditorID(0),
	m_IsMasthead(false),
	m_HasPreviewFunction(false),
	m_HasAddEntryFunction(false),
	m_HasUpdateFunction(false),
	m_HasReformatFunction(false),
	m_HasDeleteFunction(false),
	m_HasConsiderFunction(false),
	m_HasUnconsiderFunction(false),
	m_HasHideFunction(false),
	m_HasRemoveResearchersFunction(false),
	m_HasAddResearchersFunction(false),
	m_HasChangeSubmittableFunction(false),
	m_HasMoveToSiteFunction(false),
	m_IsEmpty(true),
	m_HiddenState(0),
	m_SiteID(0),
	m_Submittable(1),
	m_Action(NULL),
	m_bArchive(false),
	m_bChangeArchive(false),
	m_bDefaultCanRead(false),
	m_bDefaultCanWrite(false),
	m_bDefaultCanChangePermissions(false),
	m_bPreProcessed(true),
	m_iProfanityTriggered(0),
	m_iNonAllowedURLsTriggered(0),
	m_iEmailAddressTriggered(0),
	m_Locations(inputContext)
{
	// no further initialisation
}

CArticleEditForm::~CArticleEditForm()
{
}

bool CArticleEditForm::GetContentsOfTag(const TDVCHAR* pName, CTDVString* oContents)
{
	// TODO: code
	TDVASSERT(false, "Non-implemented method CArticleEditForm::GetContentsOfTag(...) called");
	return false;
}

bool CArticleEditForm::GetAsString(CTDVString& sResult)
{
	TDVASSERT(!m_IsEmpty, "CArticleEditForm::GetAsString(...) called on empty object");

	// fail if object is designated empty, otherwise okay
	if (IsEmpty())
	{
		return false;
	}

	bool bPreModeration = false;
//	CStoredProcedure* pSP = m_InputContext.CreateStoredProcedureObject();
//	if (pSP != NULL)
//	{
		bPreModeration = m_InputContext.GetPreModerationState();
//	}
//	delete pSP;
//	pSP = NULL;

	// build the XML text based on the values of the member variables
	CTDVString	sSubject = m_Subject;
	CTDVString	sContent = m_Content;
	CTDVString	sResearchers = "";
	bool		bSuccess = true;

	// get the researcher list as a string
	bSuccess = bSuccess && m_AuthorList.GetAsString(sResearchers);
	// need to escape text before it goes in a form, so do it here
	CXMLObject::EscapeAllXML(&sSubject);
	CXMLObject::EscapeAllXML(&sContent);

	sResult = "";
	sResult << "<ARTICLE-EDIT-FORM PROFANITYTRIGGERED='" << m_iProfanityTriggered << "' NONALLOWEDURLSTRIGGERED='" << m_iNonAllowedURLsTriggered << "' NONALLOWEDEMAILSTRIGGERED='" << m_iEmailAddressTriggered << "'>";
	sResult << "<PERMISSIONS";
	sResult << " CANREAD=\"" << (m_bCanRead ? 1 : 0) << "\"";
	sResult << " CANWRITE=\"" << (m_bCanWrite ? 1 : 0) << "\"";
	sResult << " CANCHANGEPERMISSIONS=\"" << (m_bCanChangePermissions ? 1 : 0) << "\"";
	sResult << " DEFAULTCANREAD=\"" << (m_bDefaultCanRead ? 1 : 0) << "\"";
	sResult << " DEFAULTCANWRITE=\"" << (m_bDefaultCanWrite ? 1 : 0) << "\"";
	sResult << " DEFAULTCANCHANGEPERMISSIONS=\"" << (m_bDefaultCanChangePermissions? 1 : 0) << "\"";
	sResult << " />";
	sResult << "<HIDDEN>" << m_HiddenState << "</HIDDEN>";
	sResult << "<SUBMITTABLE>" << m_Submittable << "</SUBMITTABLE>";
	sResult << "<H2G2ID>" << m_h2g2ID << "</H2G2ID>";
	sResult << "<MASTHEAD>" << m_IsMasthead << "</MASTHEAD>";
	sResult << "<EDITORID>" << m_EditorID << "</EDITORID>";
	if (m_bArchive)
	{
		sResult << "<ARCHIVE>1</ARCHIVE>";
	}
	else
	{
		sResult << "<ARCHIVE>0</ARCHIVE>";
	}
	sResult << "<SITEID>" << m_SiteID << "</SITEID>";
	sResult << "<FORMAT>" << m_Format << "</FORMAT>";
	sResult << "<STATUS>" << m_Status << "</STATUS>";
	sResult << "<PREPROCESSED>" << m_bPreProcessed << "</PREPROCESSED>";
	sResult << "<SUBJECT>" << sSubject << "</SUBJECT>";
	sResult << "<CONTENT>" << sContent << "</CONTENT>";

	sResult << m_LocationsXML;

	if (m_Action.GetLength() > 0)
	{
		CTDVString sAction = m_Action;
		sAction.Replace("&","&amp;");
		sAction.Replace("<","&lt;");
		sAction.Replace(">","&gt;");
		sResult << "<ACTION>" << sAction << "</ACTION>\n";
	}

	if (bPreModeration)
	{
		sResult << "<PREMODERATION>1</PREMODERATION>";
	}
	sResult << "<RESEARCHERS>" << sResearchers << "</RESEARCHERS>";
	sResult << "<FUNCTIONS>";

	if (m_HasPreviewFunction)
	{
		sResult << "<PREVIEW/>";
	}
	if (m_HasAddEntryFunction)
	{
		sResult << "<ADDENTRY/>";
	}
	if (m_HasUpdateFunction)
	{
		sResult << "<UPDATE/>";
	}
	if (m_HasReformatFunction)
	{
		sResult << "<REFORMAT/>";
	}
	if (m_HasDeleteFunction)
	{
		sResult << "<DELETE/>";
	}
	if (m_HasConsiderFunction)
	{
		sResult << "<CONSIDER/>";
	}
	if (m_HasUnconsiderFunction)
	{
		sResult << "<UNCONSIDER/>";
	}
	if (m_HasHideFunction)
	{
		sResult << "<HIDE/>";
	}
	if (m_HasRemoveResearchersFunction)
	{
		sResult << "<REMOVE-RESEARCHERS/>";
	}
	if (m_HasAddResearchersFunction)
	{
		sResult << "<ADD-RESEARCHERS/>";
	}

	if (m_HasChangeSubmittableFunction)
	{
		sResult << "<CHANGE-SUBMITTABLE/>";
	}

	if (m_HasMoveToSiteFunction)
	{
		sResult << "<MOVE-TO-SITE/>";
	}

	sResult << "</FUNCTIONS>";
	sResult << "</ARTICLE-EDIT-FORM>";
	// all was okay
	return bSuccess;
}

bool CArticleEditForm::AddInside(const TDVCHAR* pTagName, CXMLObject* pObject)
{
	// TODO: code
	TDVASSERT(false, "Non-implemented method CArticleEditForm::AddInside(...) called");
	return false;
}

bool CArticleEditForm::AddInside(const TDVCHAR* pTagName, const TDVCHAR* pXMLText)
{
	// TODO: code
	TDVASSERT(false, "Non-implemented method CArticleEditForm::AddInside(...) called");
	return false;
}

bool CArticleEditForm::RemoveTag(const TDVCHAR* pTagName)
{
	// TODO: code
	TDVASSERT(false, "Non-implemented method CArticleEditForm::RemoveTag(...) called");
	return false;
}

bool CArticleEditForm::RemoveTagContents(const TDVCHAR* pTagName)
{
	// TODO: code
	TDVASSERT(false, "Non-implemented method CArticleEditForm::RemoveTagContents(...) called");
	return false;
}

bool CArticleEditForm::IsEmpty()
{
	return m_IsEmpty;
}

bool CArticleEditForm::Destroy()
{
	m_IsEmpty = true;
	return true;
}

bool CArticleEditForm::DoesTagExist(const TDVCHAR* pNodeName)
{
	// TODO: code
	TDVASSERT(false, "Non-implemented method CArticleEditForm::DoesTagExist(...) called");
	return false;
}

bool CArticleEditForm::CreateFromArticle(int ih2g2ID, CUser* pViewer)
{
	TDVASSERT(ih2g2ID > 0, "CArticleEditForm::CreateFromArticle(...) called with non-positive h2g2ID");
	TDVASSERT(pViewer != NULL, "CArticleEditForm::CreateFromArticle(...) called with NULL pViewer");

	int					iEntryID= 0;
	int					iForumID= 0;
	int					iTypeID	= 0;
	int					iModerationStatus = 0;
	CTDVDateTime		dtDateCreated;
	CTDVDateTime		dtLastUpdated;
	bool				bSuccess = (ih2g2ID > 0);
	int					iTopicID = 0;
	int					iBoardPromoID = 0;
	CTDVDateTime dtRangeStartDate;
	CTDVDateTime dtRangeEndDate;
	int iRangeInterval = 0;

	// if h2g2ID is sensible and SP created okay then try to fetch the entry
	if (bSuccess)
	{
		// get that funky Guide Entry
		CStoredProcedure	SP;
		bSuccess = m_InputContext.InitialiseStoredProcedureObject(&SP);

		CExtraInfo ExtraInfo;
		
		int iLocationCount = 0;
		bSuccess = bSuccess && SP.FetchGuideEntry(ih2g2ID, m_h2g2ID, iEntryID, m_EditorID, iForumID, m_Status, m_Format, dtDateCreated, m_Subject, m_Content, m_HiddenState, m_SiteID, m_Submittable, ExtraInfo, iTypeID, iModerationStatus, dtLastUpdated, m_bPreProcessed, m_bDefaultCanRead, m_bDefaultCanWrite, m_bDefaultCanChangePermissions, iTopicID, iBoardPromoID, dtRangeStartDate, dtRangeEndDate, iRangeInterval,
			iLocationCount);

		if (iLocationCount)
		{
			m_Locations.GetEntryLocations(m_h2g2ID);
			m_Locations.GetAsString(m_LocationsXML);
		}

		bool bUserFound = false;
		if (SP.GetArticlePermissionsForUser(ih2g2ID, pViewer->GetUserID(), bUserFound, m_bCanRead, m_bCanWrite, m_bCanChangePermissions) && bUserFound)
		{
			// Great, permissions already set in call to SP.GetArticlePermissionsForUser
		}
		else
		{
			// User default permissions
			m_bCanRead = m_bDefaultCanRead;
			m_bCanWrite = m_bDefaultCanWrite;
			m_bCanChangePermissions = m_bDefaultCanChangePermissions;
		}

		m_bArchive = false;
		if (pViewer != NULL && pViewer->GetIsEditor())
		{
			bSuccess = bSuccess && SP.GetArticleForumArchiveStatus(ih2g2ID, m_bArchive);
		}

	}
	// if style is null in the DB then m_Format will come out as zero, but
	// these entries are GuideML so set their format to 1
	if (bSuccess)
	{
		if (m_Format == 0)
		{
			m_Format = 1;
		}
	}
	// set each of the function flags appropriately
	// is this the viewers masthead?
	if (pViewer->GetMasthead() == m_h2g2ID)
	{
		m_IsMasthead = true;
	}
	else
	{
		m_IsMasthead = false;
	}
	// always have a preview, update, and reformat functions, but no add entry since
	// this is an existing entry by definition
	m_HasPreviewFunction = true;
	m_HasAddEntryFunction = false;
	m_HasUpdateFunction = true;
	m_HasReformatFunction = true;
	m_HasMoveToSiteFunction = pViewer->GetIsSuperuser();
	// if this is and existing entry which is not deleted nor a masthead
	// then have the delete function, else do not
	if (m_h2g2ID != 0 && m_Status != 7 && !m_IsMasthead)
	{
		m_HasDeleteFunction = true;
	}
	else
	{
		m_HasDeleteFunction = false;		
	}
	// no send for approval function currently
	m_HasConsiderFunction = false;
//	if (m_Status == 3)
//	{
//		m_HasConsiderFunction = true;
//	}
	// still have the unconsider button in case users want to take an entry off the queue
	// if this is a submitted entry
	if (m_Status > 3 && m_Status < 14 && m_Status != 7 && m_Status != 9 && m_Status != 10)
	{
		m_HasUnconsiderFunction = true;
	}
	else
	{
		m_HasUnconsiderFunction = false;
	}
	// can add and remove researchers for an existing article
	m_HasRemoveResearchersFunction = true;
	m_HasAddResearchersFunction = true;
	// now create the member variable storing the researchers list
	// first delete any existing object

	if (m_Status == 3 && !m_IsMasthead)
	{
		m_HasChangeSubmittableFunction = true;
	}
	else
	{
		m_HasChangeSubmittableFunction = false;
	}

	bSuccess = bSuccess && GenerateResearcherListForGuide();

	// if successful then object not empty, otherwise it is
	m_IsEmpty = !bSuccess;
	return bSuccess;
}

bool CArticleEditForm::CreateFromArticle(const TDVCHAR* pArticleName, CUser* pViewer)
{
	TDVASSERT(pArticleName != NULL, "CArticleEditForm::CreateFromArticle(...) called with NULL pArticleName");
	TDVASSERT(pViewer != NULL, "CArticleEditForm::CreateFromArticle(...) called with NULL pViewer");

	int					iEntryID = 0;
	int					iForumID = 0;
	int					iTypeID	 = 0;
	int					iModerationStatus = 0;
	CTDVDateTime		dtDateCreated;
	CTDVDateTime		dtLastUpdated;
	CTDVDateTime		dtRangeStart;
	CTDVDateTime		dtRangeEnd;
	int					iTimeInterval = -1;
	bool				bSuccess = (pArticleName != NULL);

	// if h2g2ID is sensible and SP created okay then try to fetch the entry
	if (bSuccess)
	{
		// get that funky Guide Entry
		m_SiteID = 1;	//TODO - get proper SiteID
		CStoredProcedure	SP;
		bSuccess = m_InputContext.InitialiseStoredProcedureObject(&SP);
		
		CExtraInfo ExtraInfo;
		
		int iLocationCount = 0;
		bSuccess = bSuccess && SP.FetchGuideEntry(pArticleName, m_h2g2ID, iEntryID, m_EditorID, iForumID, m_Status, m_Format, dtDateCreated, m_Subject, m_Content, m_HiddenState, m_SiteID, m_Submittable, ExtraInfo, iTypeID, iModerationStatus, dtLastUpdated, m_bPreProcessed, m_bDefaultCanRead, m_bDefaultCanWrite, m_bDefaultCanChangePermissions, dtRangeStart, dtRangeEnd, iTimeInterval,
			iLocationCount);

		if (iLocationCount)
		{
			m_Locations.GetEntryLocations(m_h2g2ID);	
			m_Locations.GetAsString(m_LocationsXML);
		}

		m_bArchive = false;
		if (pViewer != NULL && pViewer->GetIsEditor())
		{
			bSuccess = bSuccess && SP.GetArticleForumArchiveStatus(m_h2g2ID, m_bArchive);
		}

	}
	// set each of the function flags appropriately
	// is this the viewers masthead?
	if (pViewer->GetMasthead() == m_h2g2ID)
	{
		m_IsMasthead = true;
	}
	else
	{
		m_IsMasthead = false;
	}
	// always have a preview, update, and reformat functions, but no add entry since
	// this is an existing entry by definition
	m_HasPreviewFunction = true;
	m_HasAddEntryFunction = false;
	m_HasUpdateFunction = true;
	m_HasReformatFunction = true;
	m_HasMoveToSiteFunction = pViewer->GetIsSuperuser();
	// if this is and existing entry which is not deleted nor a masthead
	// then have the delete function, else do not
	if (m_h2g2ID != 0 && m_Status != 7 && !m_IsMasthead)
	{
		m_HasDeleteFunction = true;
	}
	else
	{
		m_HasDeleteFunction = false;		
	}
	// no send for approval function currently
	m_HasConsiderFunction = false;
//	if (m_Status == 3)
//	{
//		m_HasConsiderFunction = true;
//	}
	// still have the unconsider button in case users want to take an entry off the queue
	// if this is a submitted entry
	if (m_Status > 3 && m_Status < 14 && m_Status != 7 && m_Status != 9 && m_Status != 10)
	{
		m_HasUnconsiderFunction = true;
	}
	else
	{
		m_HasUnconsiderFunction = false;
	}
	// can add and remove researchers for an existing article
	m_HasRemoveResearchersFunction = true;
	m_HasAddResearchersFunction = true;
	
	bSuccess = GenerateResearcherListForGuide();

	// if successful then object not empty, otherwise it is
	m_IsEmpty = !bSuccess;
	return bSuccess;
}

bool CArticleEditForm::CreateFromData(int ih2g2ID, int iFormat, int iStatus, int iEditorID, bool bIsMasthead, const TDVCHAR* pSubject, const TDVCHAR* pContent, 
										int iHidden, int iSiteID,int iSubmittable, bool bArchive, bool bChangeArchive,
									  bool bHasPreviewFunction, bool bHasAddEntryFunction, bool bHasUpdateFunction, bool bHasReformatFunction,
									  bool bHasDeleteFunction, bool bHasConsiderFunction, bool bHasUnconsiderFunction, bool bHasHideFunction,
									  bool bHasRemoveResearchersFunction, bool bHasAddResearchersFunction, bool bHasChangeSubmittableFunction,
									  bool bHasMoveToSiteFunction, bool bPreProcessed, std::vector<POLLDATA>* pvecPollTypes, const TDVCHAR* locationsXML)
{
	TDVASSERT(ih2g2ID >= 0, "CArticleEditForm::CreateFromData(...) called with negative h2g2 ID");
	TDVASSERT(iFormat >= 0, "CArticleEditForm::CreateFromData(...) called with negative format");
	TDVASSERT(iStatus >= 0, "CArticleEditForm::CreateFromData(...) called with negative status");
	TDVASSERT(iEditorID >= 0, "CArticleEditForm::CreateFromData(...) called with negative editor ID");

	bool	bSuccess = true;

	m_h2g2ID = ih2g2ID;
	m_Format = iFormat;
	m_Status = iStatus;
	m_EditorID = iEditorID;
	m_IsMasthead = bIsMasthead;
	m_Subject = pSubject;
	m_Content = pContent;
	m_HiddenState = iHidden;
	m_SiteID = iSiteID;
	m_Submittable = iSubmittable;
	m_bArchive = bArchive;
	m_bChangeArchive = bChangeArchive;
	m_HasPreviewFunction = bHasPreviewFunction;
	m_HasAddEntryFunction = bHasAddEntryFunction;
	m_HasUpdateFunction = bHasUpdateFunction;
	m_HasReformatFunction = bHasReformatFunction;
	m_HasDeleteFunction = bHasDeleteFunction;
	m_HasConsiderFunction = bHasConsiderFunction;
	m_HasUnconsiderFunction = bHasUnconsiderFunction;
	m_HasHideFunction = bHasHideFunction;
	m_HasRemoveResearchersFunction = bHasRemoveResearchersFunction;
	m_HasAddResearchersFunction = bHasAddResearchersFunction;
	m_HasChangeSubmittableFunction = bHasChangeSubmittableFunction;
	m_HasMoveToSiteFunction = bHasMoveToSiteFunction;
	m_bPreProcessed = bPreProcessed;
	if ( pvecPollTypes )
	{
		m_vecPollTypes.assign(pvecPollTypes->begin(), pvecPollTypes->end());
	}

	if ( locationsXML )
	{
		m_LocationsXML = locationsXML;
	}

	m_IsEmpty = false;

	bSuccess = bSuccess && GenerateResearcherListForGuide();

	return bSuccess;
}

int CArticleEditForm::GetH2G2ID()
{
	if (IsEmpty())
	{
		return 0;
	}
	return m_h2g2ID;
}

int CArticleEditForm::GetFormat()
{
	if (IsEmpty())
	{
		return 0;
	}
	return m_Format;
}

bool CArticleEditForm::GetPreProcessed()
{
	return m_bPreProcessed;
}

int CArticleEditForm::GetStatus()
{
	if (IsEmpty())
	{
		return 0;
	}
	return m_Status;
}

int CArticleEditForm::GetEditorID()
{
	if (IsEmpty())
	{
		return 0;
	}
	return m_EditorID;
}

bool CArticleEditForm::GetSubject(CTDVString *pSubject)
{
	TDVASSERT(pSubject != NULL, "CArticleEditForm::GetSubject(...) called with NULL pSubject");
	// fail if no output variable supplied or object is empty
	if (pSubject == NULL || IsEmpty())
	{
		return false;
	}
	*pSubject = m_Subject;
	return true;
}

bool CArticleEditForm::GetContent(CTDVString *pContent)
{
	TDVASSERT(pContent != NULL, "CArticleEditForm::GetSubject(...) called with NULL pContent");
	// fail if no output variable supplied or object is empty
	if (pContent == NULL || IsEmpty())
	{
		return false;
	}
	*pContent = m_Content;
	return true;
}

bool CArticleEditForm::IsMasthead()
{
	if (IsEmpty())
	{
		return false;
	}
	return m_IsMasthead;
}

bool CArticleEditForm::HasPreviewFunction()
{
	if (IsEmpty())
	{
		return false;
	}
	return m_HasPreviewFunction;
}

bool CArticleEditForm::HasAddEntryFunction()
{
	if (IsEmpty())
	{
		return false;
	}
	return m_HasAddEntryFunction;
}

bool CArticleEditForm::HasUpdateFunction()
{
	if (IsEmpty())
	{
		return false;
	}
	return m_HasUpdateFunction;
}

bool CArticleEditForm::HasReformatFunction()
{
	if (IsEmpty())
	{
		return false;
	}
	return m_HasReformatFunction;
}

bool CArticleEditForm::HasDeleteFunction()
{
	if (IsEmpty())
	{
		return false;
	}
	return m_HasDeleteFunction;
}

bool CArticleEditForm::HasConsiderFunction()
{
	if (IsEmpty())
	{
		return false;
	}
	return m_HasConsiderFunction;
}

bool CArticleEditForm::HasUnconsiderFunction()
{
	if (IsEmpty())
	{
		return false;
	}
	return m_HasUnconsiderFunction;
}

bool CArticleEditForm::HasHideFunction()
{
	if (IsEmpty())
	{
		return false;
	}
	return m_HasHideFunction;
}

bool CArticleEditForm::HasRemoveResearchersFunction()
{
	if (IsEmpty())
	{
		return false;
	}
	return m_HasRemoveResearchersFunction;
}

bool CArticleEditForm::HasAddResearchersFunction()
{
	if (IsEmpty())
	{
		return false;
	}
	return m_HasAddResearchersFunction;
}

bool CArticleEditForm::HasChangeSubmittableFunction()
{
	if (IsEmpty())
	{
		return false;
	}
	return m_HasChangeSubmittableFunction;
}

bool CArticleEditForm::HasMoveToSiteFunction()
{
	if (IsEmpty())
	{
		return false;
	}
	return m_HasMoveToSiteFunction;
}

/*********************************************************************************

	bool CArticleEditForm::HasEditPermission(CUser* pUser)

	Author:		Dharmesh Raithatha
	Created:	9/2/2003
	Inputs:		pUser - ptr to a user object
	Outputs:	-
	Returns:	true if the user with this ID has edit permission on this article,
				false if not
	Purpose:	Determines if the given user has edit permission on the guide entry
				represented by this object.

*********************************************************************************/

bool CArticleEditForm::HasEditPermission(CUser* pUser)
{
	return HasEditPermission(pUser, m_h2g2ID);
}

/*********************************************************************************

	bool CArticleEditForm::HasEditPermission(CUser* pUser, int iH2G2ID, bool bAlreadyKnowPermissions = false, 
		int iStatus = 0, bool bCanWrite = false)

	Author:		Kim Harries, David van Zijl
	Created:	24/07/2000
	Inputs:		pUser - current viewing user
				iH2G2ID - article h2g2 id
	Outputs:	-
	Returns:	true if the viewing user has edit permission on this article,
				false if not
	Purpose:	Determines if the given user has edit permission on the guide entry
				represented by this h2g2 ID

*********************************************************************************/

bool CArticleEditForm::HasEditPermission(CUser* pUser, int iH2G2ID, bool bAlreadyKnowPermissions, 
										 int iStatus, bool bCanWrite)
{
	TDVASSERT(pUser != NULL, "CArticleEditForm::HasEditPermission(...) called with NULL user");

	// NULL user pointer represents a non-registered user or an error, so no edit permissions
	if (pUser == NULL)
	{
		return false;
	}

	if (!CGuideEntry::IsValidChecksum(iH2G2ID))
	{
		return false;
	}

	// Guide Entry is editable if it is a valid article, the user is the same as the
	// editor, and the status of the entry is either 2, 3, 4, or 7 => i.e. it is a
	// user entry that is private or public, or is awaiting consideration or has been
	// deleted
	
	// only give editors edit permission on all entries on the admin version
	// give moderators edit permission if they have the entry locked for moderation
	if (pUser->HasSpecialEditPermissions(iH2G2ID))
	{
		return true;
	}

	// Sometimes the permissions will already have been fetched prior to 
	// calling this (saves us a DB call)
	if (bAlreadyKnowPermissions)
	{
		if (bCanWrite && (iStatus > 1 && iStatus < 5 || iStatus == 7))
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	bool bUserFound = false;
	bool bCanRead = false;
	bCanWrite = false; // If we got this far, it wasn't passed to us so can happily re-use it
	bool bCanChangePermissions = false;

	if (SP.GetArticlePermissionsForUser(iH2G2ID, pUser->GetUserID(), bUserFound, bCanRead, bCanWrite, bCanChangePermissions))
	{
		iStatus = SP.GetIntField("status");
		if (bUserFound)
		{
			if (iStatus > 1 && iStatus < 5 || iStatus == 7)
			{
				return bCanWrite;
			}
		}
		// Check for Guardians
		if (iStatus == 1 && pUser->IsUserInGroup("Guardian"))
		{
			return true;
		}
	}

	// Else return the article default write permissions.
	// The article should have been fetched before calling this function
	// but if it wasn't then the default settings are false anyway (good)
	return m_bDefaultCanWrite;
}


/*********************************************************************************

	bool CArticleEditForm::HasChangePermissionsPermission(CUser* pUser, bool bCanChangePermissions)

	Author:		David van Zijl
	Created:	05/10/2004
	Inputs:		pUser - Viewing user
				bCanChangePermissions - value of CanChangePermissions for current
					user from CGuideEntry
	Outputs:	-
	Returns:	true if user can change permissions
	Purpose:	Returns the value of bCanChangePermissions except when the 
				viewing user is a SuperUser in which case it always returns true.

*********************************************************************************/

bool CArticleEditForm::HasChangePermissionsPermission(CUser* pUser, bool bCanChangePermissions)
{
	// NULL user pointer represents a non-registered user or an error, so no edit permissions
	if (pUser == NULL)
	{
		TDVASSERT(false, "CArticleEditForm::HasChangePermissionsPermission(...) called with NULL user");
		return false;
	}

	if (pUser->GetIsSuperuser())
	{
		return true;
	}

	return bCanChangePermissions;
}


/*********************************************************************************

	bool CArticleEditForm::MakeNotForReview()

	Author:		Dharmesh Raithatha
	Created:	10/19/01
	Inputs:		iH2G2ID - the article you want to change
	Outputs:	-
	Returns:	true if successful false otherwise
	Purpose:	Sets the current article to be insubmittable

*********************************************************************************/

bool CArticleEditForm::MakeNotForReview()
{
	return SetSubmittable(0);
}

/*********************************************************************************

	bool CArticleEditForm::MakeForReview()

	Author:		Dharmesh Raithatha
	Created:	10/19/01
	Inputs:		iH2G2ID - the article you want to change
	Outputs:	-
	Returns:	true if successful false otherwise
	Purpose:	Sets the current article to be submittable

*********************************************************************************/

bool CArticleEditForm::MakeForReview()
{
	return SetSubmittable(1);
}

/*********************************************************************************

	bool CArticleEditForm::SetSubmittable(int value)

	Author:		Dharmesh Raithatha
	Created:	10/19/01
	Inputs:		value - to set the submittable flag to
	Outputs:	-
	Returns:	true if successful, false otherwise
	Purpose:	Sets the submittable flag of the current article to the given value

*********************************************************************************/

bool CArticleEditForm::SetSubmittable(int value)
{
	TDVASSERT(!IsEmpty(), "CArticleEditForm::SetSubmittable called on empty object");
	TDVASSERT(value >=0,"CArticleEditForm::SetSubmittable value < 0");
	
	if (IsEmpty())
	{
		return false;
	}

	int iH2G2ID = GetH2G2ID();

	if (iH2G2ID <= 0)
	{
		return false;
	}

	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		TDVASSERT(false, "Failed to create SP in CArticleEditForm::MakeSubmittable");
		return false;
	}

	bool bSuccess = true;
	bSuccess = bSuccess && mSP.SetGuideEntrySubmittable(iH2G2ID,value);
	
	if (bSuccess)
	{
		m_Submittable = 0;
	}
	
	return bSuccess;
}


/*********************************************************************************

	bool CArticleEditForm::MakeHidden()

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Hides this Entry.

*********************************************************************************/

bool CArticleEditForm::MakeHidden(int iModId, int iTriggerId)
{
	TDVASSERT(!IsEmpty(), "CArticleEditForm::MakeHidden() called on empty object");

	if (IsEmpty())
	{
		return false;
	}
	// otherwise run the SP to hide the article
	CStoredProcedure	SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}
	bool				bSuccess = true;

	// all okay, so proceed
	bSuccess = bSuccess && SP.HideArticle(GetH2G2ID() / 10, 1, iModId, iTriggerId,
		m_InputContext.GetCurrentUser() == NULL ? 0 : 
			m_InputContext.GetCurrentUser()->GetUserID());
	// if successful then set the member variable too
	if (bSuccess)
	{
		m_HiddenState = 1;
	}
	return bSuccess;
}

/*********************************************************************************

	bool CArticleEditForm::MakeUnhidden()

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Unhides this Entry.

*********************************************************************************/

bool CArticleEditForm::MakeUnhidden(int iModId, int iTriggerId)
{
	TDVASSERT(!IsEmpty(), "CArticleEditForm::MakeUnhidden() called on empty object");

	if (IsEmpty())
	{
		return false;
	}
	// otherwise run the SP to unhide the article
	CStoredProcedure	SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	bool				bSuccess = true;

	// all okay, so proceed
	bSuccess = bSuccess && SP.UnhideArticle(GetH2G2ID() / 10, iModId, iTriggerId,
		m_InputContext.GetCurrentUser() == NULL ? 0 : 
			m_InputContext.GetCurrentUser()->GetUserID());
	// if successful then set the member variable too
	if (bSuccess)
	{
		m_HiddenState = 0;
	}
	return bSuccess;
}

bool CArticleEditForm::Seth2g2ID(int ih2g2ID)
{
	if (IsEmpty())
	{
		return false;
	}
	m_h2g2ID = ih2g2ID;
	return true;
}

bool CArticleEditForm::SetFormat(int iFormat)
{
	if (IsEmpty())
	{
		return false;
	}
	m_Format = iFormat;
	return true;
}

bool CArticleEditForm::SetStatus(int iStatus)
{
	if (IsEmpty())
	{
		return false;
	}
	m_Status = iStatus;
	return true;
}

bool CArticleEditForm::SetEditorID(int iEditorID)
{
	if (IsEmpty())
	{
		return false;
	}
	m_EditorID = iEditorID;
	return true;
}

bool CArticleEditForm::SetSubject(const TDVCHAR* pSubject)
{
	if (IsEmpty())
	{
		return false;
	}
	m_Subject = pSubject;
	return true;
}

bool CArticleEditForm::SetContent(const TDVCHAR* pContent)
{
	if (IsEmpty())
	{
		return false;
	}
	m_Content = pContent;
	return true;
}

bool CArticleEditForm::SetIsMasthead(bool bIsMasthead)
{
	if (IsEmpty())
	{
		return false;
	}
	m_IsMasthead = bIsMasthead;
	return true;
}

bool CArticleEditForm::SetHasPreviewFunction(bool bHasPreviewFunction)
{
	if (IsEmpty())
	{
		return false;
	}
	m_HasPreviewFunction = bHasPreviewFunction;
	return true;
}

bool CArticleEditForm::SetHasAddEntryFunction(bool bHasAddEntryFunction)
{
	if (IsEmpty())
	{
		return false;
	}
	m_HasAddEntryFunction = bHasAddEntryFunction;
	return true;
}

bool CArticleEditForm::SetHasUpdateFunction(bool bHasUpdateFunction)
{
	if (IsEmpty())
	{
		return false;
	}
	m_HasUpdateFunction = bHasUpdateFunction;
	return true;
}

bool CArticleEditForm::SetHasReformatFunction(bool bHasReformatFunction)
{
	if (IsEmpty())
	{
		return false;
	}
	m_HasReformatFunction = bHasReformatFunction;
	return true;
}

bool CArticleEditForm::SetHasDeleteFunction(bool bHasDeleteFunction)
{
	if (IsEmpty())
	{
		return false;
	}
	m_HasDeleteFunction = bHasDeleteFunction;
	return true;
}

bool CArticleEditForm::SetHasConsiderFunction(bool bHasConsiderFunction)
{
	if (IsEmpty())
	{
		return false;
	}
	m_HasConsiderFunction = bHasConsiderFunction;
	return true;
}

bool CArticleEditForm::SetHasUnconsiderFunction(bool bHasUnconsiderFunction)
{
	if (IsEmpty())
	{
		return false;
	}
	m_HasUnconsiderFunction = bHasUnconsiderFunction;
	return true;
}

bool CArticleEditForm::SetHasHideFunction(bool bHasHideFunction)
{
	if (IsEmpty())
	{
		return false;
	}
	m_HasHideFunction = bHasHideFunction;
	return true;
}

bool CArticleEditForm::SetHasChangeSubmittableFunction(bool bHasChangeSubmittableFunction)
{
	if (IsEmpty())
	{
		return false;
	}
	m_HasChangeSubmittableFunction = bHasChangeSubmittableFunction;
	return true;
}

bool CArticleEditForm::SetHasRemoveResearchersFunction(bool bHasRemoveResearchersFunction)
{
	if (IsEmpty())
	{
		return false;
	}
	m_HasRemoveResearchersFunction = bHasRemoveResearchersFunction;
	return true;
}

bool CArticleEditForm::SetHasAddResearchersFunction(bool bHasAddResearchersFunction)
{
	if (IsEmpty())
	{
		return false;
	}
	m_HasAddResearchersFunction = bHasAddResearchersFunction;
	return true;
}

bool CArticleEditForm::SetHasMoveToSiteFunction(bool bHasMoveToSiteFunction)
{
	if (IsEmpty())
	{
		return false;
	}
	m_HasMoveToSiteFunction = bHasMoveToSiteFunction;
	return true;
}

/*********************************************************************************

	bool CArticleEditForm::RemoveResearcher(int iUserID)

	Author:		Kim Harries
	Created:	05/01/2001
	Inputs:		iUserID - ID of the researcher to remove
	Outputs:	-
	Returns:	true if successful
	Purpose:	Removes the given researcher from the internal list of researchers for
				this entry. Update in the database will only occur when the objects
				update method is called.

*********************************************************************************/

bool CArticleEditForm::RemoveResearcher(int iUserID)
{
	// if the form is empty then fail
	if (IsEmpty())
	{
		return false;
	}
	// otherwise call the user lists remove method
	return m_AuthorList.RemoveUser(iUserID);
}

/*********************************************************************************

	bool CArticleEditForm::AddEditHistory(CUser *pUser, int iEditType, const TDVCHAR *pReason)

	Author:		Kim Harries
	Created:	24/07/2000
	Inputs:		pUser - user that did the edit
				iEditType - indicates the type of editing done
				pReason - gives additional inof concerning the reason for the edit
	Outputs:	-
	Returns:	true if the edit history info was added successfully
	Purpose:	Records an event in the edit history log in the database for the
				Guide Entry represented by the current insatnce.

*********************************************************************************/

bool CArticleEditForm::AddEditHistory(CUser *pUser, int iEditType, const TDVCHAR *pReason)
{
	TDVASSERT(!m_IsEmpty, "CArticleEditForm::AddEditHistory(...) called on empty object");
	TDVASSERT(pUser != NULL, "NULL pUser in CArticleEditForm::AddEditHistory(...)");

	int iUserID;

	// pUser should never be NULL, but if it is then put a user ID of zero rather than failing
	if (m_IsEmpty || pUser == NULL)
	{
		iUserID = 0;
	}
	else
	{
		pUser->GetUserID(&iUserID);
	}
	
	CStoredProcedure SP;
	
	if (m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		SP.AddEditHistory(m_h2g2ID, iUserID, iEditType, pReason);
		return true;
	}
	else
	{
		TDVASSERT(false, "Failed to create stored procedure");
		return false;
	}
}

/*********************************************************************************

	bool CArticleEditForm::QueueForModeration(int iTriggerId,
		const TDVCHAR* pcNotes)

	Author:		Kim Harries
	Created:	15/02/2001
	Inputs:		pcNotes
	Outputs:	-
	Returns:	true if successful
	Purpose:	Places this entry in the queue for moderation.

*********************************************************************************/
/*IL: duplicates CGuideEntry functionality
bool CArticleEditForm::QueueForModeration(int iTriggerId, const TDVCHAR* pcNotes)
{
	TDVASSERT(!IsEmpty(), "CArticleEditForm::QueueForModeration(...) called on empty object");

	if (IsEmpty())
	{
		return false;
	}

	CStoredProcedure SP;
	

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP in CArticleEditForm::QueueForModeration(...)");
		return false;
	}

	bool	bSuccess = true;

	bSuccess = bSuccess && SP.QueueArticleForModeration(m_h2g2ID, iModTriggerId,
		pUpdatingUser == NULL ? 
			CStoredProcedure::MOD_TRIGGERED_BY_NOUSER : pUpdatingUser->GetUserID(), 
		pcNotes);

	return bSuccess;
}
*/

/*********************************************************************************

	bool CArticleEditForm::UpdateEntry(CUser* pUpdatingUser)

	Author:		Kim Harries
	Created:	24/07/2000
	Inputs:		pUpdatingUser - the user doing the update
	Outputs:	-
	Returns:	true if the update was successful, false if an error occurred
				preventing the DB from being updated.
	Purpose:	Updates this guide entry object in the database, or if it is a new
				entry adds it to the database.

*********************************************************************************/

bool CArticleEditForm::UpdateEntry(CUser* pUpdatingUser, bool& bProfanityFound, bool& bNonAllowedURLsFound, bool& bEmailAddressFound, bool bUpdateDateCreated )
{
	TDVASSERT(!m_IsEmpty, "CArticleEditForm::UpdateEntry(...) called on empty object");
	TDVASSERT(pUpdatingUser != NULL, "CArticleEditForm::UpdateEntry() called with NULL user");

	if (m_IsEmpty || pUpdatingUser == NULL)
	{
		return false;
	}
	// if h2g2ID is zero we are creating a new entry, otherwise must make sure
	// we have edit permissions on the entry we are editing
	if (m_h2g2ID != 0 && !HasEditPermission(pUpdatingUser))
	{
		TDVASSERT(false, "Edit permissions failed in CArticleEditForm::UpdateEntry(...)");
		return false;
	}

	CStoredProcedure	SP;
	bool				bSuccess = (m_InputContext.InitialiseStoredProcedureObject(&SP));

	int iTypeID = 0;

	CTDVString sProfanity;

	// Check the user input for profanities - before updating the article.
	// Article will not be updated if there is a block profanity found.
	CProfanityFilter ProfanityFilter(m_InputContext);

	CProfanityFilter::FilterState filterState = 
		ProfanityFilter.CheckForProfanities(m_Subject + " " + m_Content, &sProfanity);

	if (filterState == CProfanityFilter::FailBlock)
	{
		//check if we've represented the content once before to warm of 
		//profanity filter violation
		bProfanityFound = true;
		if (m_iProfanityTriggered > 0)
		{
			bProfanityFound = true;
		}
		else
		{
			m_iProfanityTriggered = 1;
		}
		return false;
	}
	else if (filterState == CProfanityFilter::FailRefer)
	{
		bProfanityFound = true;
	}

	if(m_InputContext.IsCurrentSiteURLFiltered() && !(pUpdatingUser->GetIsEditor() || pUpdatingUser->GetIsNotable()))
	{
		CURLFilter oURLFilter(m_InputContext);
		CURLFilter::FilterState URLFilterState = oURLFilter.CheckForURLs(m_Subject + " " + m_Content);
		if (URLFilterState == CURLFilter::Fail)
		{				
			bNonAllowedURLsFound = true;
			m_iNonAllowedURLsTriggered = 1;

			//return immediately - these don't get submitted
			return false;
		}
	}

	//Filter for email addresses.
	if ( m_InputContext.IsCurrentSiteEmailAddressFiltered() && !(pUpdatingUser->GetIsEditor() || pUpdatingUser->GetIsNotable()))
	{
		CEmailAddressFilter emailfilter;
		if ( emailfilter.CheckForEmailAddresses(m_Subject + " " + m_Content) )
		{
			//SetDNALastError("CTypedArticleBuilder","EmailAddressFilter","Email Address Found.");
			bEmailAddressFound = true;
			m_iEmailAddressTriggered = 1;
			return false;
		}
	}

	// now either create a new article if ID is zero, or update the existing one if not
	if (bSuccess)
	{
		if (m_h2g2ID == 0)
		{
			// create a new article from the form data

			iTypeID = CGuideEntry::TYPEARTICLE;
			CExtraInfo ExtraInfo(iTypeID);
			CGuideEntry GuideEntry(m_InputContext);

			int iStatus = 3;

			//ExtraInfo TODO
			bSuccess = bSuccess && SP.CreateNewArticle(m_EditorID, m_Subject, m_Content, ExtraInfo, m_Format, m_SiteID, m_Submittable, iTypeID, iStatus, &m_h2g2ID, m_bPreProcessed, true, false, false, 0, 0);
			if (bSuccess)
			{
				// set status of current instance to match that of a new User
				// Entry (public) as it will be in the DB
				m_Status = 3;

				// Make sure that the researcher list update (below) has the correct h2g2ID
				m_AuthorList.Seth2g2ID(m_h2g2ID);
				m_AuthorList.SetEditorID(m_EditorID);

				// Create polls and link them to this page
				for (std::vector<POLLDATA>::iterator it = m_vecPollTypes.begin(); it != m_vecPollTypes.end(); ++it)
				{
					// Get poll	
					CPolls polls(m_InputContext);
					CPoll *pPoll = polls.GetPoll(-1, it->m_Type);
					CAutoDeletePtr<CPoll> autodelpoll(pPoll);

					if(!pPoll)
					{
						TDVASSERT(false, "CArticleEditForm::UpdateEntry() polls.GetPoll failed");
					}
					else
					{
						//set poll attributes.
						pPoll->SetResponseMinMax(it->m_ResponseMin, it->m_ResponseMax);

						//set anonymous rating poll attribute.
						pPoll->SetAllowAnonymousRating(it->m_AllowAnonymousRating);

						if(pPoll->CreateNewPoll())	// Create it
						{
							if(!pPoll->LinkPollWithItem(m_h2g2ID, CPoll::ITEMTYPE_ARTICLE))	// Link it
							{
								if ( pPoll->ErrorReported() )
								{
									CopyDNALastError("ARTICLEEDITFORM",*pPoll);
								}
								TDVASSERT(false, "Failed to link poll to types article");
							}
						}
						else
						{
							TDVASSERT(false, "Failed to create poll for typed article");
						}
					}
				}
			}

			//Users subscribed to this author should have their subscribed content updated.
			if ( m_InputContext.GetCurrentUser()->GetAcceptSubscriptions() )
				SP.AddArticleSubscription(m_h2g2ID);
		}
		else
		{
			// update existing article
			bSuccess = bSuccess && SP.BeginUpdateArticle(m_h2g2ID, m_EditorID);
			bSuccess = bSuccess && SP.ArticleUpdateSubject(m_Subject);
			bSuccess = bSuccess && SP.ArticleUpdateBody(m_Content);
			bSuccess = bSuccess && SP.ArticleUpdateEditorID(m_EditorID);
			bSuccess = bSuccess && SP.ArticleUpdateStyle(m_Format);
			bSuccess = bSuccess && SP.ArticleUpdateStatus(m_Status);
			bSuccess = bSuccess && SP.ArticleUpdateSubmittable(m_Submittable);
			bSuccess = bSuccess && SP.ArticleUpdatePreProcessed(m_bPreProcessed);
			if ( bUpdateDateCreated )
			{
				bSuccess = bSuccess && SP.ArticleUpdateDateCreated();
			}

			bSuccess = bSuccess && SP.DoUpdateArticle(false, 0);
		}

		if (m_bChangeArchive && pUpdatingUser != NULL && pUpdatingUser->GetIsEditor())
		{
			SP.SetArticleForumArchiveStatus(m_h2g2ID, m_bArchive);
		}

		bool bSiteModerated = !(m_InputContext.IsSiteUnmoderated(m_SiteID));
		bool bUserModerated  = pUpdatingUser->GetIsPreModerated() || pUpdatingUser->GetIsPostModerated();
		bool bArticleModerated	= IsArticleModerated();
		bool bArticleInModeration = IsArticleInModeration();
		bool bAutoSinBin = pUpdatingUser->GetIsAutoSinBin();

		// Queue, update moderation status and hide the guide entry.
		if (bSuccess && !pUpdatingUser->GetIsImmuneFromModeration(m_h2g2ID)
			&& (bSiteModerated || bUserModerated || bArticleModerated || bArticleInModeration || bProfanityFound || bAutoSinBin))
		{
            if ( bProfanityFound )
                sProfanity = "Profanity: '" + sProfanity + "'";
			int iModId;
			bSuccess = bSuccess && CGuideEntry::QueueForModeration(m_InputContext, 
				m_h2g2ID, CStoredProcedure::MOD_TRIGGER_AUTO, sProfanity,
				&iModId);
			//IL: commented this out as there was a conflict when I was merging and the call to MakeHidden
			//was commented out
			//bSuccess = bSuccess && MakeHidden(iModId, 
			//	CStoredProcedure::MOD_TRIGGER_PROFANITY);
		}
	}
	
	// This method is sometimes the final step after changing researchers
	// so make sure we update it now
	if (bSuccess)
	{
		bSuccess = bSuccess && CommitResearcherList();
	}
	return bSuccess;
}

/*********************************************************************************

	bool CArticleEditForm::DeleteArticle(CUser* pDeletingUser)

	Author:		Kim Harries
	Created:	24/07/2000
	Inputs:		pDeletingUser - the user that is attempting to delete this Entry
	Outputs:	-
	Returns:	true if the deletion was successful, false if an error occurred
				preventing the DB from being updated.
	Purpose:	Changes the status of the Guide Entry represented by the current
				instance to be 'deleted', if the deleting user has permission to
				edit this Entry.

*********************************************************************************/

bool CArticleEditForm::DeleteArticle(CUser* pDeletingUser)
{
	TDVASSERT(!m_IsEmpty, "CArticleEditForm::DeleteArticle(...) called on empty object");
	TDVASSERT(pDeletingUser != NULL, "CArticleEditForm::DeleteArticle(...) called with NULL pDeletingUser");

	if (m_IsEmpty || pDeletingUser == NULL)
	{
		return false;
	}
	// must check that Entry exists and user has edit permission also
	if (m_h2g2ID != 0 && !HasEditPermission(pDeletingUser))
	{
		TDVASSERT(false, "Edit permissions failed in CArticleEditForm::DeleteArticle(...)");
		return false;
	}
	// if okay then proceed to change Entrys status
	CStoredProcedure	SP;
	bool				bSuccess = (m_InputContext.InitialiseStoredProcedureObject(&SP));

	// just need to update the Entrys status to be 7 for a deleted entry
	bSuccess = bSuccess && SP.BeginUpdateArticle(m_h2g2ID);
	bSuccess = bSuccess && SP.ArticleUpdateStatus(7);
	bSuccess = bSuccess && SP.DoUpdateArticle();

	if (bSuccess)
	{
		// if successful then also change the status of the current instance to 'deleted'
		m_Status = 7;
	}
	return bSuccess;
}

/*********************************************************************************

	bool CArticleEditForm::UndeleteArticle(CUser* pUndeletingUser)

	Author:		Kim Harries
	Created:	24/07/2000
	Inputs:		pUndeletingUser - the user that is attempting to undelete this Entry
	Outputs:	-
	Returns:	true if the un-deletion was successful, false if an error occurred
				preventing the DB from being updated.
	Purpose:	Changes the status of the Guide Entry represented by the current
				instance to be 'User Entry (Public)' instead of 'deleted', if the
				deleting user has permission to edit this Entry. If the status is
				not 'deleted' then will make no change but will return true for
				success.

*********************************************************************************/

bool CArticleEditForm::UndeleteArticle(CUser* pUndeletingUser)
{
	TDVASSERT(!m_IsEmpty, "CArticleEditForm::DeleteArticle(...) called on empty object");
	TDVASSERT(pUndeletingUser != NULL, "CArticleEditForm::DeleteArticle(...) called with NULL pUndeletingUser");

	// fail is current instance is empty or no user provided
	if (m_IsEmpty || pUndeletingUser == NULL)
	{
		return false;
	}
	// must check that Entry exists and user has edit permission also
	if (m_h2g2ID != 0 && !HasEditPermission(pUndeletingUser))
	{
		TDVASSERT(false, "Edit permissions failed in CArticleEditForm::DeleteArticle(...)");
		return false;
	}
	// if entry hasn't been deleted succeed, but send a debug message
	if (m_Status != 7)
	{
		TDVASSERT(false, "CArticleEditForm::UndeleteArticle(...) called on non-deleted Entry");
		return true;
	}
	// if okay then proceed to change Entrys status
	CStoredProcedure	SP;
	bool				bSuccess = (m_InputContext.InitialiseStoredProcedureObject(&SP));

	// just need to update the Entrys status to be 3 for a User Entry (Public)
	bSuccess = bSuccess && SP.BeginUpdateArticle(m_h2g2ID);
	bSuccess = bSuccess && SP.ArticleUpdateStatus(3);
	bSuccess = bSuccess && SP.DoUpdateArticle();


	if (bSuccess)
	{
		// if successful then also change the status of the current instance to 'User Entry (Public)'
		m_Status = 3;
	}
	return bSuccess;
}

bool CArticleEditForm::MakeToBeConsidered()
{
	TDVASSERT(!m_IsEmpty, "CArticleEditForm::MakeToBeConsidered() called on empty object");

	if (m_IsEmpty)
	{
		return false;
	}
	m_Status = 4;
	return true;
}

bool CArticleEditForm::MakePublicUserEntry()
{
	TDVASSERT(!m_IsEmpty, "CArticleEditForm::MakePublicUserEntry() called on empty object");

	if (m_IsEmpty)
	{
		return false;
	}
	m_Status = 3;
	return true;
}

bool CArticleEditForm::CreateFromXMLText(const TDVCHAR* pXMLText, CTDVString* pErrorReport)
{
	// TODO: code
	TDVASSERT(false, "Non-implemented method CArticleEditForm::CreateFromXMLText(...) called");
	return false;
}

/*********************************************************************************

	CXMLTree* CArticleEditForm::ExtractTree()

	Author:		Kim Harries
	Created:	24/07/2000
	Inputs:		-
	Outputs:	-
	Returns:	pointer to root element node of an XML tree representing the XML
				for the current instance.
				Returns NULL if the object is empty.
	Purpose:	Extracts the XML as a tree from the XML object suitable for inserting into
				another XML object. In this implementation the object is *not* left
				empty because it does not use the internal CXMLTree pointer to store
				its data.

	Note:		The calling code becomes the owner of the tree returned,
				as is responsible for deleting it or otherwise disposing of it.

*********************************************************************************/

CXMLTree* CArticleEditForm::ExtractTree()
{
	// if object is empty then return NULL
	if (m_IsEmpty)
	{
		return NULL;
	}
	// use get as string to get a text representation of the XML for this object
	// => this is better than building it here as it avoids duplicating code
	// for dealing with what is visible and what is not etc.
	CXMLTree* pTempTree = NULL;
	CXMLTree* pFirstTagNode = NULL;
	CTDVString sText;
	bool bSuccess = this->GetAsString(sText);

	// if xml text was got successfully parse it into a temp tree and then extract
	// the first actual tag node, as this is what we really want to return a pointer to
	if (bSuccess)
	{
		// only care if parse is successfull or not, since it should never fail anyway
		pTempTree = CXMLTree::Parse(sText);
		if (pTempTree == NULL)
		{
			TDVASSERT(false, "Internal parse failed in CArticleEditForm::ExtractTree()");
			bSuccess = false;
		}
	}
	// if all okay then find the first tag node
	if (bSuccess)
	{
		pFirstTagNode = pTempTree;
		// Scan through the tree until we find a node of type T_NODE
		// because that's the root named node we want to extract
		while ((pFirstTagNode != NULL) && (pFirstTagNode->GetNodeType() != CXMLTree::T_NODE))
		{
			pFirstTagNode = pFirstTagNode->FindNext();
		}
		// if we successfully found a node, use it
		if (pFirstTagNode != NULL)
		{
			// Detach this node from the rest of the tree
			pFirstTagNode->DetachNodeTree();
		}
	}
	// Destroy the remaining bits of the tree => safe because the node
	// we want has been detached already, or if something went wrong we
	// must delete the entire temp tree anyhow
	delete pTempTree;
	pTempTree = NULL;
	// should be ptr to first tag node, or NULL if something bizarre went wrong
	return pFirstTagNode;
}

bool CArticleEditForm::UpdateRelativeDates()
{
	// TODO: code
	TDVASSERT(false, "Non-implemented method CArticleEditForm::UpdateRelativeDates(...) called");
	return false;
}

int CArticleEditForm::GetHiddenState()
{
	return m_HiddenState;
}

/*********************************************************************************

	bool CArticleEditForm::SetNewResearcherList(const TDVCHAR *pList)

	Author:		David van Zijl
	Created:	20/05/2004
	Inputs:		pList - CSV string containing the researchers we want to add
	Purpose:	Wrapper for actual call inside CAuthorList

*********************************************************************************/

bool CArticleEditForm::SetNewResearcherList(const TDVCHAR *pList)
{
	return m_AuthorList.SetNewResearcherList(pList);
}

/*********************************************************************************

	bool CArticleEditForm::AddResearcher(int iUserID)

	Author:		David van Zijl
	Created:	20/05/2004
	Inputs:		iUserID - ID of the researcher to add
	Purpose:	Wrapper for actual call inside CAuthorList

*********************************************************************************/

bool CArticleEditForm::AddResearcher(int iUserID)
{
	return m_AuthorList.AddResearcher(iUserID);
}

bool CArticleEditForm::IsArticleInReviewForum(int& iReviewForumID)
{
	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		TDVASSERT(false, "Failed to create SP in CArticleEditForm::MakeSubmittable");
		return false;
	}

	if (m_h2g2ID == 0 || m_SiteID == 0)
	{
		return false;
	}

	
	if (mSP.IsArticleInReviewForum(m_h2g2ID, m_SiteID, &iReviewForumID))
	{
		return true;
	}

	return false;

}

/*********************************************************************************

	bool CArticleEditForm::MoveToSite()

	Author:		Igor Loboda
	Created:	28/03/02
	Inputs:		iNewSiteID - id of the target site
	Outputs:	-
	Returns:	true if article moved to specified site or there is no need to move it.
	Purpose:	moves article and it's forums to the specified site.
*********************************************************************************/
bool CArticleEditForm::MoveToSite(int iNewSiteID)
{
	if (m_HasMoveToSiteFunction == false)
	{
		return false;
	}

	if (m_SiteID == iNewSiteID)
	{
		return true;
	}

	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		TDVASSERT(false, "Failed to create SP in CArticleEditForm::MoveToSite");
		return false;
	}

	return mSP.MoveArticleToSite(m_h2g2ID, iNewSiteID);
}

int CArticleEditForm::GetSiteID()
{
	return m_SiteID;
}

bool CArticleEditForm::GetAction(CTDVString* oAction)
{
	if (oAction != NULL)
	{
		*oAction = m_Action;
		return true;
	}
	else
	{
		return false;
	}
}

bool CArticleEditForm::SetAction(const TDVCHAR* pAction)
{
	if (pAction != NULL)
	{
		m_Action = pAction;
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	int CArticleEditForm::GetArticleModerationStatus()

	Author:		Mark Neves
	Created:	16/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	moderation status
	Purpose:	Returns the moderation status value for the article

*********************************************************************************/

int CArticleEditForm::GetArticleModerationStatus()
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP in CArticleEditForm::GetArticleModerationStatus");
		return false;
	}

	int iModerationStatus = 0;
	SP.GetArticleModerationStatus(m_h2g2ID, iModerationStatus);
	return iModerationStatus;
}

/*********************************************************************************

	int CArticleEditForm::IsArticleInModeration()

	Author:		James Conway
	Created:	19/04/2008
	Inputs:		-
	Outputs:	-
	Returns:	if article is in moderation system 
	Purpose:	Checks if article is in moderation system

*********************************************************************************/

int CArticleEditForm::IsArticleInModeration()
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP in CArticleEditForm::IsArticleInModeration");
		return false;
	}

	int isArticleInModeration = 0;
	SP.IsArticleInModeration(m_h2g2ID, isArticleInModeration);
	return isArticleInModeration;
}

/*********************************************************************************

	bool CArticleEditForm::IsArticleModerated()

	Author:		Mark Neves
	Created:	16/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	true if article is moderated
	Purpose:	-

*********************************************************************************/

bool CArticleEditForm::IsArticleModerated()
{
	int iModerationStatus = GetArticleModerationStatus();

	bool bModerated = (iModerationStatus == MODERATIONSTATUS_POSTMODERATED || 
					   iModerationStatus == MODERATIONSTATUS_PREMODERATED);

	return bModerated;
}

bool CArticleEditForm::CommitResearcherList()
{
	return m_AuthorList.CommitChanges();
}


/*********************************************************************************

	void CArticleEditForm::InitialiseResearcherList(int iH2G2ID, int iEditorID)

	Author:		David van Zijl
	Created:	03/11/2004
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Sets some internal values in CAuthorList

*********************************************************************************/

void CArticleEditForm::InitialiseResearcherList(int iH2G2ID, int iEditorID)
{
	m_AuthorList.SetArticleType(CAuthorList::ARTICLE_EDITFORM);
	m_AuthorList.Seth2g2ID(iH2G2ID);
	m_AuthorList.SetEditorID(iEditorID);
}


/*********************************************************************************

	bool CArticleEditForm::GenerateResearcherListForGuide()

	Author:		David van Zijl
	Created:	26/05/2004
	Inputs:		-
	Outputs:	-
	Returns:	true if researcher list created successfully
	Purpose:	Generates a researcher list for an edit form

*********************************************************************************/

bool CArticleEditForm::GenerateResearcherListForGuide()
{
	InitialiseResearcherList(m_h2g2ID, m_EditorID);
	return m_AuthorList.GenerateList();
}


/*********************************************************************************

	const TDVCHAR* CArticleEditForm::DivineWhoCanEdit(const int iH2G2ID, bool bDefaultCanWrite)

	Author:		David van Zijl
	Created:	05/10/2004
	Inputs:		iH2G2ID - h2g2 ID of current article
				bDefaultCanWrite - CanWrite value of the article (not current user)
	Outputs:	-
	Returns:	string defining type of edit permissions on this article
	Purpose:	Works out the current permissions on the article

*********************************************************************************/

const TDVCHAR* CArticleEditForm::DivineWhoCanEdit(const int iH2G2ID, bool bDefaultCanWrite)
{
	// For now this is nice and simple
	// bDefaultCanWrite = false means only editable by user
	// bDefaultCanWrite = true means editable by everybody
	// Will later have to extend to allow for more options, maybe by fetching permissions
	// and comparing results?
	if (bDefaultCanWrite)
	{
		return ARTICLE_CANEDIT_ALL;
	}
	else
	{
		return ARTICLE_CANEDIT_MEONLY;
	}
}


/*********************************************************************************

	void CArticleEditForm::SetDefaultPermissions(bool bDefaultCanRead, bool bDefaultCanWrite, bool bDefaultCanChangePermissions)

	Author:		David van Zijl
	Created:	05/10/2004
	Inputs:		bDefaultCanRead - new value for article permissions
				bDefaultCanWrite - new value for article permissions
				bDefaultCanChangePermissions - new value for article permissions
	Outputs:	-
	Returns:	-
	Purpose:	Sets internal default article permissions

*********************************************************************************/

void CArticleEditForm::SetDefaultPermissions(bool bDefaultCanRead, bool bDefaultCanWrite, bool bDefaultCanChangePermissions)
{
	m_bDefaultCanRead = bDefaultCanRead;
	m_bDefaultCanWrite = bDefaultCanWrite;
	m_bDefaultCanChangePermissions = bDefaultCanChangePermissions;
}

void CArticleEditForm::SetEntryLocations(CUser* pUser, int ih2g2id)
{
	CTDVString sLocationXML;
	m_InputContext.GetParamString("LocationXML", sLocationXML);

	CStoredProcedure	SP;
	bool				bSuccess = (m_InputContext.InitialiseStoredProcedureObject(&SP));

	if (bSuccess)
	{
		SP.AddEntryLocations(ih2g2id, pUser->GetUserID(), sLocationXML);
	}

}
