// GuideEntry.cpp: implementation of the CGuideEntry class.
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
#include "category.h"
#include "Forum.h"
#include "GuideEntry.h"
#include "TDVAssert.h"
#include "ReviewForum.h"
#include "ModerationStatus.h"
#include "AuthorList.h"
#include "XMLStringUtils.h"
#include ".\Topic.h"
#include ".\MessageBoardPromo.h"


#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CGuideEntry::CGuideEntry(CInputContext& inputContext) :
	CPageBody(inputContext), m_h2g2ID(0), m_EntryID(0), m_Style(0), m_Status(0), m_HiddenState(0),
		m_SiteID(0), m_Submittable(0), m_iTypeID(0), m_iModerationStatus(MODERATIONSTATUS_UNDEFINED),
		m_iOriginalHiddenStatus(0), m_bEditing(false), m_bPreProcessed(false), m_iTimeInterval(-1),
		m_Locations(inputContext)
{

}

CGuideEntry::~CGuideEntry()
{

}

/*********************************************************************************

	bool CGuideEntry::Initialise(int h2g2ID, bool bShowEntryData, bool bShowPageAuthors, bool bShowReferences, bool bSafeToCache, bShowHidden)

	Author:		Jim Lynn, Kim Harries, Oscar Gillespie
	Created:	06/03/2000
	Modified:	23/03/2000
	Inputs:		h2g2ID - ID of the guide entry to get the data from
				bShowEntryData - ???
				bShowPageAuthors - true if the page authors are to be visible
					content for this object.
				bShowReferences - true if the references associated with the guide
					entry are to be visible content for this object.
				bSafeToCache - true if the result can be cached
				bShowHidden - true if hidden articles should be shown anyway.
	Outputs:	-
	Returns:	true if initialisation was successful, false if not.
	Purpose:	Initialises the object from the database or cache with the data
				for the entry with the specified h2g2ID. The various flags determine
				how much of the actual data will be visible to users of the object,
				i.e. which parts will be exposed as XML when the object is asked
				for its contents.

*********************************************************************************/

bool CGuideEntry::Initialise(int h2g2ID, int iSiteID, CUser* pViewingUser, 
							 bool bShowEntryData, bool bShowPageAuthors, bool bShowReferences, bool bSafeToCache, bool bShowHidden, bool bProfanityTriggered /*=false*/, bool bNonAllowedURLsTriggered /*=false*/)
{
	m_SiteID = iSiteID;
	
	CTDVString cachename = "A";
	cachename << h2g2ID << "-" << bShowEntryData << "-" << bShowPageAuthors << "-" << bShowReferences << ".txt";
	
	bool bSuccess = true;
	bool bFailGracefully = false;

	int iEditorID	= 0;
	int iForumID	= 0;
	int iTopicID	= 0;
	int iBoardPromoID = 0;
	CTDVString sSubject;
	CTDVString sBody;
	CTDVString sEditorName;
	CTDVDateTime dtDateCreated;
	CTDVDateTime dtLastUpdated;
	bool bValid = true;

	bValid = IsValidChecksum(h2g2ID);
	if (bValid)
	{
		// create a stored procedure to access the database
		CStoredProcedure SP;
		bSuccess = bSuccess && m_InputContext.InitialiseStoredProcedureObject(&SP);

		// Check the cache to see if the item is already cached
		// First get the dirty date - anything before this time is dirty
		// Also get the list of users with entries in GuideEntryPermissions
		//   - the cached version might need its permissions changed
		if (bSuccess && bSafeToCache)
		{
			CTDVDateTime dExpires;
			SP.CacheGetArticleInfo(h2g2ID, &dExpires, &iTopicID, &iBoardPromoID);

			CTDVString sXML;
			if (CacheGetItem("articles",cachename, &dExpires, &sXML))
			{
				// CreateFromCacheText might fail if e.g. the cached text
				// is garbled somehow, in which case proceed with getting
				// the entry from the DB
				if (CreateFromCacheText(sXML))
				{
/*
					// Now check to see if we've got a topic!
					if (iTopicID > 0)
					{
						// It's a topic article!
						AddInside("ARTICLE","<TOPICPAGE>1</TOPICPAGE>");

						// Add the board promo info if we have one
						if (iBoardPromoID > 0)
						{
							CMessageBoardPromo Promo(m_InputContext);
							if (Promo.GetBoardPromoDetails(iBoardPromoID))
							{
								// Insert the promo into the page
								AddInside("ARTICLE",&Promo);
							}
						}
					}

*/
					ChangeArticleXMLPermissionsForUser(pViewingUser);
					UpdateRelativeDates();
					return true;
				}
			}
		}
		
		// if got here then proceed with getting the article from the DB
		if (bSuccess)
		{
			int iLocationCount = 0;
			// fetch all the lovely intellectual property from the database
			bSuccess = SP.FetchGuideEntry(h2g2ID, m_h2g2ID, m_EntryID, iEditorID, iForumID, m_Status, m_Style, dtDateCreated, sSubject, sBody, m_HiddenState, m_SiteID, m_Submittable, m_ExtraInfo, m_iTypeID, m_iModerationStatus, dtLastUpdated, m_bPreProcessed, m_bDefaultCanRead, m_bDefaultCanWrite, m_bDefaultCanChangePermissions, iTopicID, iBoardPromoID, m_DateRangeStart, m_DateRangeEnd, m_iTimeInterval,
				iLocationCount);

			if (iLocationCount)
			{
				m_Locations.GetEntryLocations(m_h2g2ID);	
			}

			// Make sure we keep a record of the original hidden status
			m_iOriginalHiddenStatus = m_HiddenState;

			// Override the state of the hidden flag if necessary
			if (bShowHidden)
			{
				m_HiddenState = 0;
			}

			// For caching purposes, use the article default permissions
			m_bCanRead = m_bDefaultCanRead;
			m_bCanWrite = m_bDefaultCanWrite;
			m_bCanChangePermissions = m_bDefaultCanChangePermissions;
		}

		if (!bSuccess)
		{
			// eek... that didn't work... why hasn't anyone written this entry yet!?
			bFailGracefully = true;
		}
	}
	
	if (bSuccess)
	{
		m_ExtraInfo.SetType(m_iTypeID);
	}

	// if either invalid checksum or data was got okay from DB then call the
	// BuildTreeFromData method to build an xml tree
	if (bSuccess)
	{
		// TODO: test the status change has worked in this instance
		bSuccess = BuildTreeFromData(NULL, h2g2ID, iEditorID, iForumID, m_Style, m_Status, m_iModerationStatus, dtDateCreated, sSubject, sBody,
									 bShowEntryData, bShowPageAuthors, bShowReferences, m_SiteID, m_Submittable, m_ExtraInfo, dtLastUpdated, m_bPreProcessed,
									 m_DateRangeStart, m_DateRangeEnd, m_iTimeInterval, 0.0, 0.0, bProfanityTriggered, bNonAllowedURLsTriggered);
	}
	// TODO: this is a hack to fix NULL style fields in DB
	if (m_Style == 0)
	{
		m_Style = 2;
	}

	if (bFailGracefully)
	{
		// well... we can try to give a page explaining that the entry isn't in the database

		CTDVString sBluffXML = "";
		sBluffXML << "<ARTICLE>";
		sBluffXML << "<GUIDE><BODY><NOENTRYYET/></BODY></GUIDE>";
		sBluffXML << "</ARTICLE>";
		bSuccess = CXMLObject::CreateFromXMLText(sBluffXML);
		bSafeToCache = false;
		m_Status = 0;
	}

	// Now check to see if we've got a topic!
	if (iTopicID > 0)
	{
		// It's a topic article!
		AddInside("ARTICLE","<TOPICPAGE>1</TOPICPAGE>");

		// Add the board promo info if we have one
		if (iBoardPromoID > 0)
		{
			CMessageBoardPromo Promo(m_InputContext);
			if (Promo.GetBoardPromoDetails(iBoardPromoID))
			{
				// Insert the promo into the page
				AddInside("ARTICLE",&Promo);
			}
		}
	}

	if (bSuccess && bSafeToCache && m_Status != 7)
	{
		CTDVString StringToCache;
		//GetAsString(StringToCache);
		CreateCacheText(&StringToCache);
		CachePutItem("articles", cachename, StringToCache);
	}

	// Fetch specific permissions for this user if they're in the GuideEntryPermissions
	// table. Make sure you do this AFTER the page has been cached!
	// That way it will have been cached with default permissions
	ChangeArticleXMLPermissionsForUser(pViewingUser);

	if (!bSuccess)
	{
		// make sure no tree created if something failed
		delete m_pTree;
		m_pTree = NULL;
	}
	// how did we do?
	return (bSuccess || bFailGracefully);
}

/*********************************************************************************

	bool CGuideEntry::Initialise(const TDVCHAR* pArticleName, int iSiteID, const CUser* pViewingUser, 
							 bool bShowEntryData, bool bShowPageAuthors, bool bShowReferences, bool bSafeToCache)

	Author:		Oscar Gillespie, Kim Harries
	Created:	08/03/2000
	Modified:	23/03/2000
	Inputs:		pArticleName - the name of the article to lookup
				bShowEntryData - ???
				bShowPageAuthors - true if the page authors are to be visible
					content for this object.
				bShowReferences - true if the references associated with the guide
					entry are to be visible content for this object.
	Outputs:	-
	Returns:	true if initialisation was successful, false if not.
	Purpose:	Initialises the object from the database or cache with the data
				for the entry with the specified name. The various flags determine
				how much of the actual data will be visible to users of the object,
				i.e. which parts will be exposed as XML when the object is asked
				for its contents.

*********************************************************************************/

bool CGuideEntry::Initialise(const TDVCHAR* pArticleName, int iSiteID, CUser* pViewingUser, 
							 bool bShowEntryData, bool bShowPageAuthors, bool bShowReferences, bool bSafeToCache)
{
	// TODO - this code seems awfully familiar, some brave person should maybe 
	// refactor these two Initialise() methods into 1 internal one

	bool bSuccess = true;

	// create a stored procedure to access the database
	CStoredProcedure SP;
	bSuccess = bSuccess && m_InputContext.InitialiseStoredProcedureObject(&SP);

	CTDVString cachename = "AN";
	cachename << "-" << iSiteID << "-" << pArticleName << "-" << bShowEntryData << "-" << bShowPageAuthors << "-" << bShowReferences << ".txt";
	
	// but if we're ok then get the article details from the DB
	int iEditorID	= 0;
	int iForumID	= 0;
	CTDVString sSubject;
	CTDVString sBody;
	CTDVString sEditorName;
	CTDVDateTime dtDateCreated;
	CTDVDateTime dtLastUpdated;

	bool bPreProcessed = true;

	// Check the cache to see if the item is already cached
	// First get the dirty date - anything before this time is dirty
	if (bSuccess && bSafeToCache)
	{
		CTDVDateTime dExpires;
		SP.CacheGetKeyArticleDate(pArticleName, iSiteID, &dExpires);
		CTDVString sXML;
		if (CacheGetItem("namedarticles",cachename, &dExpires, &sXML))
		{
			// CreateFromCacheText might fail if e.g. the cached text
			// is garbled somehow, in which case proceed with getting
			// the entry from the DB
			if (CreateFromCacheText(sXML))
			{
				ChangeArticleXMLPermissionsForUser(pViewingUser);
				UpdateRelativeDates();
				return true;
			}
		}
	}

	// if here then proceed with getting article from the DB
	if (bSuccess)
	{
		// TODO: fetch guide entry should also get the user name/date created?
		m_SiteID = iSiteID; //so that we pass it on the the SP
		int iLocationCount = 0;
		bSuccess = SP.FetchGuideEntry(pArticleName, m_h2g2ID, m_EntryID, iEditorID, iForumID, m_Status, m_Style, dtDateCreated, sSubject, sBody, 
							m_HiddenState, m_SiteID,m_Submittable,m_ExtraInfo, m_iTypeID, m_iModerationStatus, dtLastUpdated, bPreProcessed, 
							m_bDefaultCanRead, m_bDefaultCanWrite, m_bDefaultCanChangePermissions, m_DateRangeStart, m_DateRangeEnd, m_iTimeInterval,
							iLocationCount);
		
		// For caching purposes, use the article default permissions
		m_bCanRead = m_bDefaultCanRead;
		m_bCanWrite = m_bDefaultCanWrite;
		m_bCanChangePermissions = m_bDefaultCanChangePermissions;
	}

	// Keep the original status of the hidden flag
	m_iOriginalHiddenStatus = m_HiddenState;

	m_ExtraInfo.SetType(m_iTypeID);

	// call the BuildTreeFromData method to build an xml tree
	if (bSuccess)
	{
		float latitude = 0.0, longitude = 0.0;
		// TODO: test the status change has worked in this instance
		bSuccess = BuildTreeFromData(NULL, m_h2g2ID, iEditorID, iForumID, m_Style, m_Status, m_iModerationStatus, dtDateCreated, sSubject, sBody,
			bShowEntryData, bShowPageAuthors, bShowReferences, m_SiteID, m_Submittable, m_ExtraInfo, dtLastUpdated, bPreProcessed, m_DateRangeStart, m_DateRangeEnd, m_iTimeInterval,
			latitude, longitude);
		if (bSuccess && bShowEntryData)
		{
			CTDVString sNameXML = "<NAME>";
			sNameXML << pArticleName << "</NAME>";
			AddInside("ARTICLEINFO", sNameXML);
		}
	}

	if (bSuccess)
	{
		CTDVString StringToCache;
		//GetAsString(StringToCache);
		CreateCacheText(&StringToCache);
		CachePutItem("namedarticles", cachename, StringToCache);
	}

	// Fetch specific permissions for this user if they're in the GuideEntryPermissions
	// table. Make sure you do this AFTER the page has been cached!
	// That way it will have been cached with default permissions
	ChangeArticleXMLPermissionsForUser(pViewingUser);

	if (!bSuccess)
	{
		// make sure no tree created if something failed
		delete m_pTree;
		m_pTree = NULL;
	}
	// how did we do?
	return bSuccess;
}


/*********************************************************************************

	bool CGuideEntry::CreateFromData(CUser* pAuthor, int ih2g2ID, const TDVCHAR* pSubject, const TDVCHAR* pContent, int iStyle,
									 bool bShowEntryData, bool bShowPageAuthors, bool bShowReferences)

	Author:		Kim Harries
	Created:	24/03/2000
	Inputs:		pAuthor = the user who is the editor of this entry
				ih2g2ID - ID of the entry
				pSubject - subject for the entry
				pBody - body of the entry
				iStyle - format style for the entry
				bShowEntryData - ???
				bShowPageAuthors - true if the page authors are to be visible
					content for this object.
				bShowReferences - true if the references associated with the guide
					entry are to be visible content for this object.
	Outputs:	-
	Returns:	true if successful, false if not
	Purpose:	Creates a CGuideEntry object that should represent an existing entry
				but takes the values given as parameters instead of getting the values
				from the database. This is useful during form processing when you
				need an object to store the entries state without updating it in the
				database, for example.

	Notes:		Content should match the format style type, which means that plain
				text entries should not have GUIDE and BODY tags around them, whereas
				GuideML entries _must_ have them.

				No changes take place in the database until UpdateEntry is called,
				at which point it will check that the user attmpting the update
				actually has permission on this entry.

*********************************************************************************/

bool CGuideEntry::CreateFromData(CUser* pAuthor, int ih2g2ID, const TDVCHAR* pSubject, const TDVCHAR* pContent, CExtraInfo &ExtraInfo,int iStyle, int iSiteID,
								 int iSubmittable,bool bShowEntryData, bool bShowPageAuthors, bool bShowReferences, bool bIsPreProcessed, CDateRangeValidation* pDateRangeVal)
{
	// TODO: check this

	TDVASSERT(pAuthor != NULL, "CGuideEntry::CreateFromData(...) called with NULL pAuthor");
	TDVASSERT(m_pTree == NULL, "CGuideEntry::CreateFromData(...) called with non-NULL tree");

	if (pAuthor == NULL)
	{
		return false;
	}
	// allow this method to be called on already initialised objects, but flag
	// an assert report as a warning
	if (m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
	// make sure this is either a valid h2g2ID or is zero for a new entry
	if (ih2g2ID != 0 && !IsValidChecksum(ih2g2ID))
	{
		TDVASSERT(false, "Invalid h2g2ID in CGuideEntry::CreateFromData(...)");
		return false;
	}

	CTDVString sSubject = pSubject;
	CTDVString sBody	= pContent;
	int iEditorID		= 0;
	int iTypeID			= 0;
	bool bSuccess		= true;

	// must have the editor ID for a new entry otherwise we don't know who
	// is responsible for it
	bSuccess = pAuthor->GetUserID(&iEditorID);
	TDVASSERT(bSuccess, "Could not get editor ID in CGuideEntry::CreateFromData(...)");

	m_h2g2ID = ih2g2ID;
	m_EntryID = ih2g2ID / 10;
	m_Style = iStyle;
	m_SiteID = iSiteID;
	m_Submittable = iSubmittable;
	// TODO: is this okay to use this to represent having no status?
	m_Status = 0;
	m_ExtraInfo = ExtraInfo;

	// As we are creating the article here, the moderation status is undefined
	// The article's moderation status will only change after it has been created
	m_iModerationStatus = MODERATIONSTATUS_UNDEFINED;

	CTDVDateTime dtDateCreated = CTDVDateTime::GetCurrentTime();
	CTDVDateTime dtLastUpdated = CTDVDateTime::GetCurrentTime();

	CTDVDateTime dtRangeStart;
	CTDVDateTime dtRangeEnd;
	int iTimeInterval = -1;
	if (pDateRangeVal)
	{
		dtRangeStart = pDateRangeVal->GetStartDate();
		dtRangeEnd = pDateRangeVal->GetEndDate();
		iTimeInterval = pDateRangeVal->GetTimeInterval();
	}

	// now build the xml tree for the new article from the data provided
	// use the BuildTreeFromData method for this
	if (bSuccess)
	{
		// calling this with zero for the h2g2ID should be fine because it will
		// know that this means it is a new entry
		// TODO: check this works okay
 		// TODO: test the status change has worked in this instance
		float latitude = 0.0, longitude = 0.0;
		bSuccess = BuildTreeFromData(pAuthor, m_h2g2ID, iEditorID, 0, m_Style, m_Status, m_iModerationStatus, dtDateCreated, sSubject, sBody,
									 bShowEntryData, bShowPageAuthors, bShowReferences, m_SiteID, m_Submittable,m_ExtraInfo, dtLastUpdated, bIsPreProcessed,
									 dtRangeStart, dtRangeEnd, iTimeInterval, latitude, longitude);//,iTypeID);
	}
	// make sure tree is deleted if something went wrong
	if (!bSuccess)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
	return bSuccess;
}

/*********************************************************************************

	bool CGuideEntry::HasEditPermission(CUser* pUser)

	Author:		Kim Harries
	Created:	03/04/2000
	Inputs:		pUser - ptr to a user object
	Outputs:	-
	Returns:	true if the user with this ID has edit permission on this article,
				false if not
	Purpose:	Determines if the given user has edit permission on the guide entry
				represented by this object.

*********************************************************************************/

bool CGuideEntry::HasEditPermission(CUser* pUser)
{
	TDVASSERT(pUser != NULL, "CGuideEntry::HasEditPermission(...) called with NULL user");

	// NULL user pointer represents a non-registered user or an error, so no edit permissions
	if (pUser == NULL)
	{
		return false;
	}
	// Guide Entry is editable if it is a valid article, the user is the same as the
	// editor, and the status of the entry is either 2, 3, 4, or 7 => i.e. it is a
	// user entry that is private or public, or is awaiting consideration or has been
	// deleted

	// only give editors edit permission on all entries on the admin version
	// give moderators edit permission if they have entry locked for moderation
#if defined (_ADMIN_VERSION)
	if (pUser->HasSpecialEditPermissions(GetH2G2ID()))
	{
		return true;
	}
#endif // _ADMIN_VERSION
	
	bool bEditable = false;
	if (IsValidChecksum(m_h2g2ID))
	{
		if (m_Status == 1 && pUser->IsUserInGroup("Guardian"))
		{
			bEditable = true;
		}
		if (GetEditorID() == pUser->GetUserID())
		{
			if (m_Status > 1 && m_Status < 5 || m_Status == 7)
			{
				bEditable = true;
			}
		}
	}
	return bEditable;
}

/*********************************************************************************

	bool CGuideEntry::MakeHidden(int iHiddenStatus = 1)

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		iHiddenStatus - 1 = Removed (Default)
								2 = Refered
								3 = PreModeration
	Outputs:	-
	Returns:	true if successful
	Purpose:	Hides this Entry.

*********************************************************************************/

bool CGuideEntry::MakeHidden(int iHiddenStatus, int iModId, int iTriggerId)
{
	TDVASSERT(!IsEmpty(), "CGuideEntry::MakeHidden() called on empty object");

	if (IsEmpty())
	{
		return false;
	}
	// otherwise run the SP to hide the article
	CStoredProcedure SP;
	bool bSuccess = true;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}
	// all okay, so proceed
	bSuccess = bSuccess && SP.HideArticle(GetH2G2ID() / 10, iHiddenStatus,
		iModId, iTriggerId, m_InputContext.GetCurrentUser() == NULL ? 0 :
		m_InputContext.GetCurrentUser()->GetUserID());
	// if successful then set the member variable too
	if (bSuccess)
	{
		m_HiddenState = iHiddenStatus;
	}

	return bSuccess;
}

/*********************************************************************************

	bool CGuideEntry::MakeUnhidden()

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Unhides this Entry.

*********************************************************************************/

bool CGuideEntry::MakeUnhidden(int iModId, int iTriggerId)
{
	TDVASSERT(!IsEmpty(), "CGuideEntry::MakeUnhidden() called on empty object");

	if (IsEmpty())
	{
		return false;
	}
	// otherwise run the SP to unhide the article
	CStoredProcedure SP;
	bool bSuccess = true;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}
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

/*********************************************************************************

	bool CGuideEntry::CheckIsSubEditor(CUser* pUser)

	Author:		Kim Harries
	Created:	04/12/2000
	Inputs:		pUser - ptr to a user object
	Outputs:	-
	Returns:	true if the user is currently subbing this entry, false otherwise.
	Purpose:	Determines if the given user is currently subbing this entry. Will
				return false if the user *was* the sub for this entry, but the entry
				has already been submitted back to the editors.

*********************************************************************************/

bool CGuideEntry::CheckIsSubEditor(CUser* pUser)
{
	TDVASSERT(pUser != NULL, "CGuideEntry::CheckIsSubEditor(...) called with NULL user");
	// can't be the sub if you don't exist
	if (pUser == NULL)
	{
		return false;
	}
	bool	bIsSub = false;
	// must have edit permission if you are subbing an entry
	if (this->HasEditPermission(pUser))
	{
		CStoredProcedure SP;
		// if no SP then will return false
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			return false;
		}

		// otherwise call the special method for determining if user is the sub
		bIsSub = SP.CheckIsSubEditor(pUser->GetUserID(), m_EntryID);
	}
	// return the result
	return bIsSub;
}

/*********************************************************************************

	bool CGuideEntry::CheckIsSubEditor(CUser* pUser)

	Author:		Kim Harries
	Created:	04/12/2000
	Inputs:		pUser - ptr to a user object
	Outputs:	-
	Returns:	true if the user is currently subbing this entry, false otherwise.
	Purpose:	Determines if the given user is currently subbing this entry. Will
				return false if the user *was* the sub for this entry, but the entry
				has already been submitted back to the editors.

*********************************************************************************

bool CGuideEntry::CheckIsSubEditor(int iUserID)
{
	bool	bIsSub = false;
	// must have edit permission if you are subbing an entry
	if (this->HasEditPermission(iUserID))
	{
		CStoredProcedure*	pSP = m_InputContext.CreateStoredProcedureObject();
		// if no SP then will return false
		if (pSP != NULL)
		{
			// otherwise call the special method for determining if user is the sub
			bIsSub = pSP->CheckIsSubEditor(iUserID, m_EntryID);
		}
		// delete the SP
		delete pSP;
		pSP = NULL;
	}
	// return the result
	return bIsSub;
}
*/

/*********************************************************************************

	int CGuideEntry::GetForumID()

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	the ID if found, or zero if not found or htis entry does not yet
				have a forum associated with it.
	Purpose:	Gets the forum ID for this entry by searching through the internal
				xml tree representation. If it cannot be found it will return zero.

	Note:		Since this returns zero both if there is an error of some sort, or
				there simply isn't a forum, then some other method (e.g. IsEmpty())
				should be used to check if the object is empty.

*********************************************************************************/

int CGuideEntry::GetForumID()
{
	TDVASSERT(m_pTree != NULL, "CGuideEntry::GetForumID(...) called with NULL tree");

	// if this is NULL then return zero for error
	if (m_pTree == NULL)
	{
		return 0;
	}

	// TODO: if the forum ID has not been fetched from DB yet then should do this
	CXMLTree* pTemp = NULL;
	// if pTemp ends up NULL at any point then the tree does not contain
	// the forum ID information, so fail
	// first find the node for the FORUMID tag
	pTemp = m_pTree->FindFirstTagName("FORUMID", 0, false);
	if (pTemp != NULL)
	{
		// if okay then get the first child of this tag - i.e. the text node
		pTemp = pTemp->GetFirstChild();
	}
	if (pTemp != NULL)
	{
		// now extract the number as an integer from its text representation
		return atoi((const TDVCHAR*) pTemp->GetText());
	}
	else
	{
		return 0;
	}
}

/*********************************************************************************

	int CGuideEntry::GetH2G2ID()

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	the h2g2ID of this entry, or zero if there is an error or this
				entry does not have an ID yet because it has not yet been entered
				into the DB.
	Purpose:	Gets the h2g2 ID for this entry. If this object currently has no
				tree (i.e. is empty) then it will return zero. If this GuideEntry
				object has not been added to the DB yet and hence does not have
				an ID then this will return zero.

*********************************************************************************/

int CGuideEntry::GetH2G2ID()
{
	TDVASSERT(m_pTree != NULL, "CGuideEntry::GetH2G2ID(...) called with NULL tree");

	if (m_pTree == NULL)
	{
		return 0;
	}
	return m_h2g2ID;
}


/*********************************************************************************

	bool CGuideEntry::GetSubject(CTDVString& sSubject)

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		-
	Outputs:	sSubject - a string copy of the subject of this entry, in its native
					format, i.e. plain text without the escape sequences. If no
					subject found an empty string is given. If an error occurs the
					string is left unchanged.
	Returns:	true if successful, false otherwise.
	Purpose:	Gets the subject for this guide entry in its plain text format, without
				any XML escaping.

*********************************************************************************/

bool CGuideEntry::GetSubject(CTDVString& sSubject)
{
	TDVASSERT(m_pTree != NULL, "CGuideEntry::GetSubject(...) called with NULL tree");

	if (m_pTree == NULL)
	{
		return false;
	}

	CXMLTree* pTemp = NULL;
	// if pTemp ends up NULL at any point then the tree does not contain
	// a SUBJECT tag so something is wrong
	// first find the node for the SUBJECT tag

	pTemp = m_pTree->FindFirstTagName("ARTICLE");
	if (pTemp != NULL)
	{
		// if okay then get the first child of this tag - i.e. the text node
		pTemp = pTemp->GetFirstChild();
	}
	// search for a SUBJECT tag that is a direct child of the ARTICLE tag
	CTDVString sTagName;
	while (pTemp != NULL)
	{
		sTagName = pTemp->GetName();
		// if a subject tag found then get the text node within it
		// and exit loop, otherwise look at next sibling
		if (sTagName.CompareText("SUBJECT"))
		{
			pTemp = pTemp->GetFirstChild();
			break;
		}
		else
		{
			pTemp = pTemp->GetNextSibling();
		}
	}
	if (pTemp != NULL)
	{
		// now extract the actual text
		sSubject = pTemp->GetText();
		UnEscapeXMLText(&sSubject);
		return true;
	}
	else
	{
		TDVASSERT(false, "No <SUBJECT> tag found in CGuideEntry::GetSubject(...)");
		sSubject = "";
		return true;
	}
}


/*********************************************************************************

	bool CGuideEntry::GetBody(CTDVString& sBody)

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		-
	Outputs:	sBody - a string copy of the body of this entry in its native format,
				i.e. non-escaped plain text for a plain text entry, or proper XML
				for a GuideML entry including the GUIDE and BODY tags. If no GUIDE
				tag found an empty string is given. Will be left unchanged if an
				error occurs.
	Returns:	true if successful, false otherwise.
	Purpose:	Gets the body of this guide entry in its native format NOT the format
				that it is stored within this GuideEntry object. All content is stored
				within the GuideEntry object as proper XML, but when GetBody is called
				it reverses any escaping of special XML characters or other transformations
				that may have occurred.

*********************************************************************************/

bool CGuideEntry::GetBody(CTDVString& sBody)
{
	TDVASSERT(m_pTree != NULL, "CGuideEntry::GetBody(...) called with NULL tree");

	// an empty tree contains no body, as the saying goes
	if (m_pTree == NULL)
	{
		return false;
	}

	CXMLTree* pTemp = NULL;
	// if pTemp ends up NULL at any point then the tree does not contain
	// a body so something is wrong
	// body of the guide entry is everything inside the GUIDE section, but including
	// the GUIDE tag itself. This is a bit naff but thats how it seems to work
	pTemp = m_pTree->FindFirstTagName("GUIDE");
	if (pTemp != NULL)
	{
		// might as well stuff the output straight into our output parameter
		// since we have no idea whether it worked or not anyway
		pTemp->OutputXMLTree(sBody);
		// now reverse any transformations if necessary
		if (IsPlainText())
		{
			// remember everything is stored as XML/GuideML, so to get plain text
			// out we must reverse the process of converting it
			// this should also strip off the surrounding GUIDE and BODY tags
			CXMLObject::GuideMLToPlainText(&sBody);
		}
		else if (IsGuideML())
		{
			// do nothing as it is already in GuideML format
		}
		else if (IsHTML())
		{
			// TODO: strip off the GUIDE and BODY tags
			// TODO: remove any CDATA tag?
			CXMLObject::GuideMLToHTML(&sBody);
		}
		else
		{
			// this should never happen
			TDVASSERT(false, "Non-valid style format in CGuideEntry::GetBody(...)");
		}
	}
	else
	{
		// flag error, but give a empty string rather than failing
		TDVASSERT(false, "No <GUIDE> tag found in CGuideEntry::GetBody(...)");
		sBody = "";
	}
	// I love a function that always returns true, don't you?
	return true;
}

/*********************************************************************************

	int CGuideEntry::GetStyle()

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	the format style of this entry, or zero if there is an error or this
				entry does not have a style defined for it for some reason.
	Purpose:	Gets the style value for this entry. Generally the IsGuideML(), IsHTML()
				and IsPlainText() methods are probably more useful.

*********************************************************************************/

int CGuideEntry::GetStyle()
{
	TDVASSERT(m_pTree != NULL, "CGuideEntry::GetStyle(...) called with NULL tree");

	if (m_pTree == NULL)
	{
		return 0;
	}
	return m_Style;
}

/*********************************************************************************

	int CGuideEntry::GetStatus()

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	the status of this entry, or zero if there is an error or this
				entry does not have a status defined for it for some reason.
	Purpose:	Gets the status value for this entry.

*********************************************************************************/

int CGuideEntry::GetStatus()
{
	TDVASSERT(m_pTree != NULL, "CGuideEntry::GetStatus(...) called with NULL tree");

	if (m_pTree == NULL)
	{
		return 0;
	}
	return m_Status;
}

/*********************************************************************************

	int CGuideEntry::GetEditorID()

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	the ID of the editor of this entry, or zero if there is an error
				or this entry does not have an editor defined for it for some reason.
	Purpose:	Gets the editor ID for this entry.

*********************************************************************************/

int CGuideEntry::GetEditorID()
{
	TDVASSERT(m_pTree != NULL, "CGuideEntry::GetEditorID(...) called with NULL tree");

	if (m_pTree == NULL)
	{
		return 0;
	}
	
	CXMLTree* pParent = NULL;
	CXMLTree* pTemp = NULL;
	// if pTemp ends up NULL at any point then the tree does not contain
	// the editor ID information, so fail
	// must be careful to get the ID of the editor of *this* page, and also
	// not to accidentally get the ID of one of the researchers
	// first find the node for the USERID tag within USER, within EDITOR, within PAGEAUTHOR
	pParent = m_pTree->FindFirstTagName("PAGEAUTHOR");
	if (pParent != NULL)
	{
		pParent = pParent->FindFirstTagName("EDITOR", pParent);
	}
	if (pParent != NULL)
	{
		pTemp = pParent->FindFirstTagName("USERID", pParent);
	}
	if (pTemp != NULL)
	{
		// if okay then get the first child of this tag - i.e. the text node
		pTemp = pTemp->GetFirstChild();
	}
	if (pTemp != NULL)
	{
		// now extract the number as an integer from its text representation
		return atoi((const TDVCHAR*) pTemp->GetText());
	}
	else
	{
		// something went wrong, so return zero
		return 0;
	}
}

/*********************************************************************************

	bool CGuideEntry::IsGuideML()

	Author:		Kim Harries
	Created:	20/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if this is an entry in GuideML, false otherwise
	Purpose:	Tests object to see if it is a GuideML entry or not. An unitialised
				object will have the default style of zero, and hence will return false.

*********************************************************************************/

bool CGuideEntry::IsGuideML()
{
	return m_Style == 1;
}

bool CGuideEntry::IsPlainText()
{
	 return m_Style == 2;
}

bool CGuideEntry::IsHTML()
{
	return m_Style == 3;
}

/*********************************************************************************

	bool CGuideEntry::IsApproved()

	Author:		Kim Harries
	Created:	24/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if this is an entry is an approved entry, false if not
	Purpose:	Tests if the object has approved entry status. Simply a more
				convenient method than using GetStatus(), which requires the
				user of the object to know the correct status values.

*********************************************************************************/

bool CGuideEntry::IsApproved()
{
	return m_Status == 1;
}

bool CGuideEntry::IsToBeConsidered()
{
	return m_Status == 4;
}

bool CGuideEntry::IsDeleted()
{
	return m_Status == 7;
}

bool CGuideEntry::IsLocked()
{
	// TODO: is this right?
	return m_Status == 5 || m_Status == 8;
}

/*********************************************************************************

	bool CGuideEntry::IsSubmittableForPeerReview()

	Author:		Dharmesh Raithatha
	Created:	8/30/01
	Inputs:		-
	Outputs:	-
	Returns:	true if the guide entry can be submitted to the peer reviewprocess
	Purpose:	-

*********************************************************************************/

bool CGuideEntry::IsSubmittableForPeerReview()
{
	return m_Submittable == 1;
}

/*********************************************************************************

	bool CGuideEntry::IsSubmittableForPeerReview(int iSubmittable)

	Author:		Dharmesh Raithatha
	Created:	6/25/2003
	Inputs:		iSubmittable - value of a submittable flag that you want to check
				is valid or not
	Outputs:	-
	Returns:	true if the flag supplied has the value that is Submittable
	Purpose:	method hides the value that denotes submittable for review.

*********************************************************************************/

bool CGuideEntry::IsSubmittableForPeerReview(int iSubmittable)
{
	return iSubmittable == 1;
}

/*********************************************************************************

	bool CGuideEntry::SetSubject(const TDVCHAR* pSubject)

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		pSubject - the new subject for this guide entry
	Outputs:	-
	Returns:	true if the subject is successfully changed, false if not
	Purpose:	Sets the subject for the current object to the new value. No change
				will take place in the database until the UpdateEntry() method is
				called. IF a SUBJECT tag is not found then this will attempt to
				create one and only fail if this is not possible.

	Note:		This method performs the appropriate escaping of special XML characters
				so this should not be performed on the new subject beforehand.

*********************************************************************************/

bool CGuideEntry::SetSubject(const TDVCHAR* pSubject)
{
	TDVASSERT(m_pTree != NULL, "CGuideEntry::SetSubject(...) called with NULL tree");

	if (m_pTree == NULL)
	{
		return false;
	}

	CXMLTree* pTemp = NULL;
	// if pTemp ends up NULL at any point then the tree does not contain
	// a SUBJECT tag so something is wrong
	// first find the node for the SUBJECT tag
	pTemp = m_pTree->FindFirstTagName("SUBJECT");
	if (pTemp != NULL)
	{
		// if okay then get the first child of this tag - i.e. the text node
		pTemp = pTemp->GetFirstChild();
	}
	// perform the escaping now
	CTDVString sSubject = pSubject;
	EscapeXMLText(&sSubject);
	if (pTemp != NULL)
	{
		// if a subject tag was found then set the new text value for its content node
		return pTemp->SetText(sSubject);
	}
	else
	{
		// if no subject tag something is probably wrong so log an error
		// make an attempt to add a subject tag however
		TDVASSERT(false, "No <SUBJECT> tag found in CGuideEntry::SetSubject(...)");
		sSubject = "<SUBJECT>" + sSubject + "</SUBJECT>";
		return AddInside("ARTICLE", sSubject);
	}
}

/*********************************************************************************

	bool CGuideEntry::SetBody(const TDVCHAR* pBody)

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		pBody - the new body text for this guide entry
	Outputs:	-
	Returns:	true if the text is successfully changed, false if not
	Purpose:	Sets the body text for the current object to the new value. No change
				will take place in the database until the UpdateEntry() method is
				called.

*********************************************************************************/

bool CGuideEntry::SetBody(const TDVCHAR* pBody)
{
	TDVASSERT(m_pTree != NULL, "CGuideEntry::SetBody(...) called with NULL tree");

	if (m_pTree == NULL)
	{
		return false;
	}

	CTDVString sBody = pBody;
	CXMLTree* pTemp = NULL;
	// find and destroy the current body, i.e. the GUIDE tag and all its children
	// aren't we merciless?
	pTemp = m_pTree->FindFirstTagName("GUIDE");
	if (pTemp != NULL)
	{
		pTemp->DetachNodeTree();
		delete pTemp;
		pTemp = NULL;
	}
	else
	{
		// if couldn't find tag log an error but continue with trying to put
		// the new body in
		TDVASSERT(false, "No GUIDE tag found in CGuideEntry::SetBody(...)");
	}
	// now do any necessary conversions on the new body text
	if (IsPlainText())
	{
		// plain text must be converted to GuideML first
		// this includes putting the GUIDE and BODY tags around it
		PlainTextToGuideML(&sBody);
	}
	else if (IsGuideML())
	{
		// TODO: error-check the parsing here?
		// do nothing as new body should already have the GUIDE and BODY tags round it
	}
	else if (IsHTML())
	{
		// TODO: if we handle HTML is this correct?
		// TODO: this should go in a HTMLToGuideML method in XMLObject really
		sBody.Replace("]]>", "]]&gt;");
		sBody = "<GUIDE><BODY><PASSTHROUGH><![CDATA[" + sBody + "]]></PASSTHROUGH></BODY></GUIDE>";
	}
	else
	{
		TDVASSERT(false, "CGuideEntry::SetBody(...) called on GuideEntry with no style");
	}
	// use the AddInside method to insert the new xml into the tree
	return AddInside("ARTICLE", sBody);
}

/*********************************************************************************

	bool CGuideEntry::SetStyle(int iStyle)

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		iStyle - the new value for the style of this entry
	Outputs:	-
	Returns:	true if the style is successfully changed, false if not
	Purpose:	Sets the style value for the current object to the new value. No
				change will take place in the database until the UpdateEntry()
				method is called.

	Note:		This method will automatically reformat the content in the new style.
				e.g. if going from GuideML to plain text it will perform all the
				standard conversions and XML escapes that are normally performed on
				a plain text entry. Likewise going from plain text to GuideML will
				treat any tags in the text as such.

*********************************************************************************/

bool CGuideEntry::SetStyle(int iStyle)
{
	// TODO: check that this always works okay

	TDVASSERT(m_pTree != NULL, "CGuideEntry::SetStyle(...) called with NULL tree");
	TDVASSERT(iStyle > 0, "CGuideEntry::SetStyle(...) called with non-positive style");

	if (m_pTree == NULL)
	{
		return false;
	}
	// if new style is the same as old just return true
	if (iStyle == m_Style)
	{
		return true;
	}

	CTDVString sBody;
	bool bSuccess = true;

	// use the GetBody and SetBody methods because this way any appropriate
	// conversions will take place
	// get the body in its current native format
	bSuccess = GetBody(sBody);
	if (bSuccess)
	{
		int temp = m_Style;

		m_Style = iStyle;
		// after changing the style set the body again and this will do any conversions
		// TODO: if going from plain text to GuideML should we be adding GUIDE and
		// BODY tags?
		bSuccess = SetBody(sBody);
		if (!bSuccess)
		{
			// change back if didn't work and nothing is changed
			m_Style = temp;
		}
	}
	return bSuccess;
}

/*********************************************************************************

	bool CGuideEntry::SetStatus(int iStatus)

	Author:		Kim Harries
	Created:	23/03/2000
	Inputs:		iStatus - the new value for the status of this entry
	Outputs:	-
	Returns:	true if the status is successfully changed, false if not
	Purpose:	Sets the status value for the current object to the new value. No
				change will take place in the database until the UpdateEntry()
				method is called.

*********************************************************************************/

bool CGuideEntry::SetStatus(int iStatus)
{
	TDVASSERT(m_pTree != NULL, "CGuideEntry::SetStatus(...) called with NULL tree");
	TDVASSERT(iStatus > 0, "CGuideEntry::SetStatus(...) called with non-positive status");

	if (m_pTree == NULL)
	{
		return false;
	}
	// TODO: any checking for valid changes?
	m_Status = iStatus;
	return true;
}

bool CGuideEntry::MakeGuideML()
{
	return SetStyle(1);
}

bool CGuideEntry::MakePlainText()
{
	return SetStyle(2);
}

bool CGuideEntry::MakeHTML()
{
	return SetStyle(3);
}

bool CGuideEntry::MakeApproved()
{
	return SetStatus(1);
}

bool CGuideEntry::MakeCancelled()
{
	return SetStatus(7);
}

bool CGuideEntry::MakeToBeConsidered()
{
	return SetStatus(4);
}

bool CGuideEntry::MakePublicUserEntry()
{
	return SetStatus(3);
}

bool CGuideEntry::MakeSubmittable()
{
	m_Submittable = 1;
	return true;
}

bool CGuideEntry::MakeUnSubmittable()
{
	m_Submittable = 0;
	return true;
}

/*********************************************************************************

	bool CGuideEntry::BuildTreeFromData(CUser* pAuthor, int ih2g2ID, int iForumID, int iStyle, int iStatus, int iModerationStatus,
									CTDVDateTime& pDateCreated, const TDVCHAR* pSubject, const TDVCHAR* pBody,
									bool bShowEntryData, bool bShowPageAuthors, bool bShowReferences, 
									CExtraInfo& ExtraInfo) // , int iTeamID)

	Author:		Kim Harries, Oscar Gillespie
	Created:	23/03/2000
	Modified:	5/09/2000 (added the iStatus argument)
	Inputs:		TODO: ???
	Outputs:	-
	Returns:	??? 
	Purpose:	??? Fancy doing this bit Kim?

*********************************************************************************/

bool CGuideEntry::BuildTreeFromData(CUser* pAuthor, int ih2g2ID, int iEditorID, int iForumID, int iStyle, int iStatus, int iModerationStatus,
									CTDVDateTime& pDateCreated, const TDVCHAR* pSubject, const TDVCHAR* pBody,
									bool bShowEntryData, bool bShowPageAuthors, bool bShowReferences, int iSiteID, int iSubmittable,
									CExtraInfo& ExtraInfo, CTDVDateTime& dLastUpdated, bool bIsPreProcessed,
									CTDVDateTime& dtRangeStart, CTDVDateTime& dtRangeEnd, int iTimeInterval, 
									float latitude, float longitude,
									bool bProfanityTriggered, bool bNonAllowedURLsTriggered /*= false*/)
{
	// TODO: different behaviour if a new entry?

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	CTDVString sSubject = pSubject;
	CTDVString sBody = pBody;
	CTDVString sArticle = ""; // this string is going to hold the XML for the GuideEntry
	CTDVString sEditorName;
	bool bShowAlternativeEntries = false;
	bool bSuccess = true;

	int iCalcCheck = 0;
	int iCheckDigit = 0;
	CTDVString sh2g2ID = "";

	// all output must be in XML (GuideML) so do conversions now
	// do appropriate escaping of subject and body before building the tree
	// these will need to be undone if these sections are extracted from the object
	CXMLObject::MakeSubjectSafe(&sSubject);
	if (IsPlainText())
	{
		// plain text must be escaped and converted into xml
		PlainTextToGuideML(&sBody);
	}
	else if (IsGuideML())
	{
		// should not need to do anything
		TDVASSERT(sBody.Find("<GUIDE>") >= 0, "No GUIDE tag found in GuideML body in CGuideEntry::BuildTreeFromData(...)");

		// Check to see if we're dealing with preprocessed articles
		if (bIsPreProcessed)
		{
			// Now see if we're editing or displaying
			if (m_bEditing)
			{
				// REPLACE BRs WITH RETURNS
				sBody.Replace("<BR />","\r\n");
			}
		}
		else
		{
			// NOT Preprocessed, but check to see if we're diplaying ( NOT Editing! )
			if (!m_bEditing)
			{
				// Replace all the returns with BR Tags
				if (!CXMLObject::ReplaceReturnsWithBreaks(sBody))
				{
					TDVASSERT(false,"Failed to replace returns with breaks!");
				}
			}
		}
	}
	else if (IsHTML())
	{
		// TODO: any transformation? => put in CDATA section?
		// TODO: should really be a method in XMLObject
		sBody = "<GUIDE><BODY><PASSTHROUGH><![CDATA[" + sBody + "]]></PASSTHROUGH></BODY></GUIDE>";
	}
	else
	{
		// this should never happen of course
		TDVASSERT(false, "No valid style specified in CGuideEntry::BuildTreeFromData(...)");
		bSuccess = false;
	}
	// if h2g2ID is zero then this is a new entry, so don't try to validate its ID
	// => must avoid trying to show alternative entries for a new entry!
	if (ih2g2ID != 0)
	{
		// check if this is a valid h2g2ID
		bSuccess = IsValidChecksum(ih2g2ID, &iCalcCheck, &iCheckDigit, &sh2g2ID);
		bShowAlternativeEntries = !bSuccess;
	}

	if (bSuccess)
	{
		// Create the basic ARTICLE structure
		sArticle << "<ARTICLE";
		sArticle << " CANREAD=\"" << (m_bCanRead ? 1 : 0) << "\"";
		sArticle << " CANWRITE=\"" << (m_bCanWrite ? 1 : 0) << "\"";
		sArticle << " CANCHANGEPERMISSIONS=\"" << (m_bCanChangePermissions ? 1 : 0) << "\"";
		sArticle << " DEFAULTCANREAD=\"" << (m_bDefaultCanRead ? 1 : 0) << "\"";
		sArticle << " DEFAULTCANWRITE=\"" << (m_bDefaultCanWrite ? 1 : 0) << "\"";
		sArticle << " DEFAULTCANCHANGEPERMISSIONS=\"" << (m_bDefaultCanChangePermissions? 1 : 0) << "\"";
		sArticle << " PROFANITYTRIGGERED='" << (bProfanityTriggered?1:0) <<"'";
		sArticle << " NONALLOWEDURLSTRIGGERED='" << (bNonAllowedURLsTriggered?1:0) <<"'";
		sArticle << ">\n";

		CTDVString sTemp;
		CTDVDateTime dtDefaultDate;
		
		if (!(dtDefaultDate == dtRangeStart))
		{
			sArticle << "<DATERANGESTART>";
			dtRangeStart.GetAsXML(sTemp);
			sArticle << sTemp;
			sArticle << "</DATERANGESTART>";
		}
		
		if (!(dtDefaultDate == dtRangeEnd))
		{
			sArticle << "<DATERANGEEND>";
			// Take a day from the end date as stored in the database for UI purposes. 
			// E.g. User submits a date range of 01/09/1980 to 02/09/1980. They mean for this to represent 2 days i.e. 01/09/1980 00:00 - 03/09/1980 00:00. 
			// This gets stored in the database but for display purposes we subtract a day from the database end date to return the 
			// original dates submitted by the user inorder to match their expectations.
			COleDateTimeSpan dInterval(1, 0, 0, 0);
			dtRangeEnd = dtRangeEnd - dInterval; 
			dtRangeEnd.GetAsXML(sTemp);
			dtRangeEnd.GetAsXML(sTemp);
			sArticle << sTemp;
			sArticle << "</DATERANGEEND>";
		}
		
		if (iTimeInterval != -1)
		{
			sArticle << "<TIMEINTERVAL>";
			sArticle << iTimeInterval;
			sArticle << "</TIMEINTERVAL>";
		}
		

		sArticle << "<ARTICLEINFO>\n";
		
		if (bShowEntryData)
		{
			// The status of an entry is entry data. obviously.
			// We will only express whether the guideentry is edited (approved) or not for the time being
			
			CXMLStringUtils::AppendStatusTag(iStatus,sArticle);

			// this only gets output if the bShowEntryData parameter is true
			sArticle << "<H2G2ID>" << ih2g2ID << "</H2G2ID>";

			if (iStatus == 3)
			{
				//add the submittable property

				CTDVString sSubmittableXML;

				if (CreateSubmittableXML(ih2g2ID, iSubmittable, sSubmittableXML))
				{
					sArticle << sSubmittableXML;
				}

				//add the recommend entry property
				if (RecommendEntry(ih2g2ID))
				{
					sArticle << "<RECOMMENDENTRY/>";
				}
			}
		}
		//this one gets output regardless of parameters :)

		sArticle << "<FORUMID>" << iForumID << "</FORUMID>";
		sArticle << "<SITE><ID>" << iSiteID << "</ID></SITE>";
		sArticle << "<SITEID>" << iSiteID << "</SITEID>";

		if (m_HiddenState > 0)
		{
			sArticle << "<HIDDEN>" << m_HiddenState << "</HIDDEN>";
		}

		sArticle << "<MODERATIONSTATUS ID='" << ih2g2ID << "'>";
		sArticle << iModerationStatus;
		sArticle << "</MODERATIONSTATUS>";

		if (bShowPageAuthors)
		{
			// Create CAuthorList object
			//
			CAuthorList authorList(m_InputContext);
			authorList.SetArticleType(CAuthorList::ARTICLE);
			authorList.Seth2g2ID(ih2g2ID);
			authorList.SetEditorID(iEditorID);

			if ( authorList.GenerateList() )
			{
				CTDVString sResearcherXML;
				authorList.GetListAsString(sResearcherXML);					
				sArticle << "<PAGEAUTHOR>" << sResearcherXML << "</PAGEAUTHOR>";
			}

			CTDVString sDateCreated = "";
			pDateCreated.GetAsXML(sDateCreated, true);

			sArticle << "<DATECREATED>";
			sArticle << sDateCreated;
			sArticle << "</DATECREATED>";

			CTDVString sLastUpdated = "";
			dLastUpdated.GetAsXML(sLastUpdated, true);

			sArticle << "<LASTUPDATED>";
			sArticle << sLastUpdated;
			sArticle << "</LASTUPDATED>";

			//sArticle << "<";

			
			
		}

		sArticle << "<RELATEDMEMBERS></RELATEDMEMBERS>";

		sArticle << "<PREPROCESSED>" << bIsPreProcessed << "</PREPROCESSED>";
        
		sArticle << "</ARTICLEINFO>\n";
		// finish wrapping up and entering the article info... and put in the article subject
		if (m_HiddenState > 0)
		{
			sArticle << "<SUBJECT>Article Pending Moderation</SUBJECT>";
		}
		else
		{
			sArticle << "<SUBJECT>" << sSubject << "</SUBJECT>";
		}
		// dump the article text XML through to the GuideEntry XML
		// TODO: no difference between different style types here?
		if (m_HiddenState > 0)
		{
			sArticle << "<GUIDE><BODY>This article has been hidden pending moderation</BODY></GUIDE>";
		}
		else
		{
			sArticle << sBody;
		}

		//extrainfo added
		if (ExtraInfo.IsCreated())
		{
			// We only want the hidden version of the extra info when the article is hidden
			bool bHiddenVersion = (m_HiddenState != 0);

			CTDVString sExtraInfo;
			ExtraInfo.GetInfoAsXML(sExtraInfo,bHiddenVersion);
			sArticle << sExtraInfo;
		}

		if(m_InputContext.DoesCurrentSiteHaveSiteOptionSet("GuideEntries", "IncludeBookmarkCount"))
		{
			int iBookmarkCount = 0;
			if (SP.GetBookmarkCount(ih2g2ID, &iBookmarkCount))
			{
				sArticle << "<BOOKMARKCOUNT>";
				sArticle << iBookmarkCount;
				sArticle << "</BOOKMARKCOUNT>";
			}			
		}

		sArticle << "</ARTICLE>";
	}

	if (bShowAlternativeEntries)
	{
		// if we enter this part of the code it is because we failed to find the article
		// the user was looking for so we can
		TDVASSERT(sArticle.IsEmpty(), "Trying to show alternative articles failed because a string reserved for it got tainted.");
		// and also
		TDVASSERT(!bSuccess, "bSuccess got confused in GuideEntry::Initialise() :( ");

		// we'll try to find a bunch of valid entries that they could hae been looking for

		// Assume: One digit wrong/one digit missing/one digit added/two digits transposed

		int iDifference = iCalcCheck - iCheckDigit;
		int iInsertDigit = iDifference;

		if (iDifference < 0)
		{
			// this digit should be in the range 0 to 9 so if it's gone negative it ought to be 10 more
			iDifference += 10;
		}

		// start building an invalid article block
		sArticle << "<ARTICLE><GUIDE><BODY>";
		sArticle << "<INVALIDARTICLE>";
		sArticle << "<SUGGESTEDALTERNATIVES>";

		int iCount = 0;
		for (iCount = 0; iCount < sh2g2ID.GetLength(); iCount++)
		{
			// At each position, see what we can do
			// The checksum position must be treated somewhat differently
			// for insertion and substitution
			// transposition will never affect checksumming
		
			// See what happens if we insert a character before this digit

			// try putting there difference digit into the h2g2id
			CTDVString sProposedh2g2IDWithInsert = "";
			sProposedh2g2IDWithInsert << sh2g2ID.Left(iCount);
			sProposedh2g2IDWithInsert << iDifference;
			sProposedh2g2IDWithInsert << sh2g2ID.Mid(iCount);
			
			int iProposedh2g2IDWithInsert = atoi(sProposedh2g2IDWithInsert);

			CTDVString sEntrySubject = "";

			if (SP.GetEntrySubjectFromh2g2ID(iProposedh2g2IDWithInsert, sEntrySubject))
			{
				sArticle << "<LINK H2G2=\"";
				sArticle << iProposedh2g2IDWithInsert;
				sArticle << "\">";

				CXMLObject::EscapeXMLText(&sEntrySubject);					
				sArticle << sEntrySubject;
				sArticle << "</LINK>";
			}
	
			if (iCount < sh2g2ID.GetLength() -1)
			{
				// We're looking at a non-check digit
				// First correct the wrong digit.
				// my $digit = substr($id,$i,1);

				// make sure we don't get caught out by pants ascii values
				CTDVString sWhichDigit = "";
				sWhichDigit = sh2g2ID.GetAt(iCount);
				int iPotentialDigit = atoi(sWhichDigit);

				iPotentialDigit += iDifference;

				if (iPotentialDigit < 0)
				{
					iPotentialDigit += 10;
				}
				else
				if (iPotentialDigit > 9)
				{
					iPotentialDigit -= 10;
				}

				CTDVString sPotentialDigit = "";
				sPotentialDigit << iPotentialDigit;

				CTDVString sProposedh2g2IDWithSwap = "";
				sProposedh2g2IDWithSwap << sh2g2ID;
				sProposedh2g2IDWithSwap.SetAt(iCount, sPotentialDigit.GetAt(0));

				int iProposedh2g2IDWithSwap = atoi(sProposedh2g2IDWithSwap);

				CTDVString sEntrySubject = "";

				if (SP.GetEntrySubjectFromh2g2ID(iProposedh2g2IDWithSwap, sEntrySubject))
				{
					sArticle << "<LINK H2G2=\"";
					sArticle << sProposedh2g2IDWithSwap;
					sArticle << "\">";

					CXMLObject::EscapeXMLText(&sEntrySubject);					
					sArticle << sEntrySubject;
					sArticle << "</LINK>";
				}
			}
			else
			{
				// we're looking at a check digit
				// substitute the valid check digit
			
				CTDVString sProposedh2g2IDWithCheckChanged = "";
				sProposedh2g2IDWithCheckChanged << sh2g2ID;

				CTDVString sCalcCheck = "";
				sCalcCheck << iCalcCheck;
				sProposedh2g2IDWithCheckChanged.SetAt(iCount , sCalcCheck.GetAt(0));

				int iProposedh2g2IDWithCheckChanged = atoi(sProposedh2g2IDWithCheckChanged);

				CTDVString sEntrySubject = "";

				if (SP.GetEntrySubjectFromh2g2ID(iProposedh2g2IDWithCheckChanged, sEntrySubject))
				{
					sArticle << "<LINK H2G2=\"";
					sArticle << iProposedh2g2IDWithCheckChanged;
					sArticle << "\">";

					CXMLObject::EscapeXMLText(&sEntrySubject);					
					sArticle << sEntrySubject;
					sArticle << "</LINK>";
				}

				// and in case they left off the check digit
				// add a valid one onto the end
			
				CTDVString sProposedh2g2IDWithCheckAdded = "";
				sProposedh2g2IDWithCheckAdded << sh2g2ID;

				CTDVString sNewEntryID = sh2g2ID;
				int iTestID = atoi(sNewEntryID);
				int iAppropriateDigit = 0;
				int iTempID = iTestID;

				while (iTempID > 0)
				{
					iAppropriateDigit += iTempID % 10;
					iTempID = static_cast<int>(iTempID / 10);
				}
				iAppropriateDigit = iAppropriateDigit % 10;
				iAppropriateDigit = 9 - iAppropriateDigit;

				sProposedh2g2IDWithCheckAdded << iAppropriateDigit;

				int iProposedh2g2IDWithCheckAdded = atoi(sProposedh2g2IDWithCheckAdded);

				// this was already defined in this scope
				sEntrySubject = "";

				if (SP.GetEntrySubjectFromh2g2ID(iProposedh2g2IDWithCheckAdded, sEntrySubject))
				{
					sArticle << "<LINK H2G2=\"";
					sArticle << iProposedh2g2IDWithCheckAdded;
					sArticle << "\">";

					CXMLObject::EscapeXMLText(&sEntrySubject);
					sArticle << sEntrySubject;
					sArticle << "</LINK>";
				}
			}
		}		
		
		sArticle << "</SUGGESTEDALTERNATIVES>";
		sArticle << "</INVALIDARTICLE>";
		sArticle << "</BODY></GUIDE></ARTICLE>";

		
		// we have something valid to output actually so we can put bSuccess back to true
		bSuccess = true;
	}

	if (bSuccess)
	{
		// if we're still powering along then form ourselves into a proper XMLObject
		bSuccess = CXMLObject::CreateFromXMLText(sArticle);
		if (bSuccess)
		{
			CCategory Cat(m_InputContext);
			if (Cat.GetArticleCrumbTrail(ih2g2ID))
			{
				AddInside("ARTICLEINFO", &Cat);
			}

			// Mark Howitt 21/08/03 - Added all the other related articles for this one
			CTDVString sRelatedXML;
			if (Cat.GetRelatedClubs(ih2g2ID,sRelatedXML))
			{
				AddInside("RELATEDMEMBERS", sRelatedXML);
			}

			sRelatedXML.Empty();
			if (Cat.GetRelatedArticles(ih2g2ID,sRelatedXML))
			{
				AddInside("RELATEDMEMBERS", sRelatedXML);
			}

			if (bShowReferences && m_HiddenState == 0)
			{
				// parse the article text into a tree so we can turn links into fun link element bits
				// for the article info section
				sArticle = "";
				sArticle << "<REFERENCES>"; // do we only put references tag in if bShowReferences is true?

				long lErrCount = 0; // an integer that will store the number of parsing errors

				// ok... try to parse the flat XML article into a tree
				CXMLTree* pArticleTextTree = m_pTree;
				int iHrefIndex = 0;

				// if the tree isn't null then the Parse function must have worked
				if (pArticleTextTree != NULL)
				{
					// pLinkTree is always a subtree of the big article tree.
					// it is used to hold the current Link tag as we iterate over the article tree
					CXMLTree* pLinkTree = NULL;				
					pLinkTree = pArticleTextTree->FindFirstTagName("LINK", pArticleTextTree, false);

					// flags to monitor if we need to create corresponding sections or not
					bool bEntryFound = false;
					bool bUserFound = false;

					// a string that has XML to represent any offsite link added as we go along
					CTDVString soffsiteRef = "";
					CTDVString sEntriesRef = "";
					CTDVString sUsersRef = "";

					// this is a flag that monitors the success of operations using link-related stored procedures
					bool bLinkScrutinySuccess = true;

					// get a couple of stored procedure objects which will be used solely for
					// finding out what h2g2 and bio links are actually pointing to
					CStoredProcedure EntrySP;
					CStoredProcedure UserSP;

					if (!m_InputContext.InitialiseStoredProcedureObject(&EntrySP) || !m_InputContext.InitialiseStoredProcedureObject(&UserSP))
					{
						// if construction failed then we're not doing well
						bLinkScrutinySuccess = false;
					}

					if (!EntrySP.BeginFetchArticleSubjects() || !UserSP.BeginFetchUserNames())
					{
						// there shouldn't be any reason why these SPs should start whining
						TDVASSERT(false, "A fetch articlesubjects/username SP refused to start");
						bLinkScrutinySuccess = false;
					}

					int iArticleCount = 0;
					int iUserCount = 0;
					
					while (pLinkTree != NULL)
					{
						// with each link we find in the GuideEntry
						// attempt to work out which kind of link this is by seeing
						// if we can get the value of a particular attribute
						CTDVString sAttrVal = "";

						// if we're able to get the attribute of the tag successfully and
						// it's at least 2 characters long then we can inspect the target safely
						// (the target will either be something like A562 or U52 in which case
						// it clearly needs to be at least 2 characters long (something like U2 is fine)
						// or it could be a href but again that would need to be pretty long)
						if ((pLinkTree->GetAttribute("H2G2", sAttrVal) || pLinkTree->GetAttribute("DNAID", sAttrVal)) && sAttrVal.GetLength() > 1)
						{					
							if (bLinkScrutinySuccess) 
							{
								CTDVString sEntryType = sAttrVal.GetAt(0);
								// find out what sort of entry they're pointing to
								
								sAttrVal = sAttrVal.Mid(1);
								// This turns the "A12345" style value into a "12345" style value							

								if (sEntryType.CompareText("U"))
								{
									// looks like they wanted to link to a user page... ok then

									// turn the String representing a link target into an integer
									int iUserID = atoi(sAttrVal);

									// tell the stored procedure to get ready to deal with another user ID
									bLinkScrutinySuccess = UserSP.AddUserID(iUserID);
									iUserCount++;
									if (iUserCount >= 90)
									{
										FetchBatchOfUsernames(&UserSP, &sUsersRef);
										iUserCount = 0;
									}

									// yes, we _are_ going to make an users subsection in the references section
									bUserFound = true;
								}
								else if (sEntryType.CompareText("A") || sEntryType.CompareText("P") )
								{
									// this is either an Ax or Px link so it is referencing and article.

									// turn the String representing a link target into an integer
									int iEntryID = atoi(sAttrVal);

									// tell the stored procedure to get ready to deal with another article ID
									bLinkScrutinySuccess = EntrySP.AddArticleID(iEntryID);
									iArticleCount++;
									if (iArticleCount > 90)
									{
										FetchBatchOfArticlenames(&EntrySP, &sEntriesRef);
										iArticleCount = 0;
									}

									// yes, we _are_ going to make an entries subsection in the references section
									bEntryFound = true;
								}
							}
						}
						else if (pLinkTree->GetAttribute("BIO", sAttrVal))
						{
							if (bLinkScrutinySuccess && !sAttrVal.IsEmpty())
							{
								sAttrVal = sAttrVal.Mid(1); 
								// This turns the "U12345" style value into a "12345" style value						

								// turn the String representing a link target into an integer
								int iUserID = atoi(sAttrVal);

								// tell the stored procedure to get ready to deal with another user ID
								bLinkScrutinySuccess = UserSP.AddUserID(iUserID);
								iUserCount++;
								if (iUserCount >= 90)
								{
									FetchBatchOfUsernames(&UserSP, &sUsersRef);
									iUserCount = 0;
								}
							}

							// yes, we _are_ going to make an users subsection in the references section
							bUserFound = true;
						}
						else if (pLinkTree->GetAttribute("HREF", sAttrVal))
						{										
							
							//Set an attribute using iHrefIndex so we can match back
							pLinkTree->SetAttribute("UINDEX",iHrefIndex);
							
							// use the text they give us ;)
							// This is in the "http://www.monkeybagel.com" form (could maybe do some validation)
							CTDVString sTitle = "";
							if (!pLinkTree->GetAttribute("TITLE",sTitle))
							{
								pLinkTree->GetTextContents(sTitle);
							}
							MakeSubjectSafe(&sTitle);
							MakeSubjectSafe(&sAttrVal);

							// Now create an external link block
							soffsiteRef << "<EXTERNALLINK UINDEX='" << iHrefIndex << "'>";
							soffsiteRef << "<OFFSITE>" << sAttrVal << "</OFFSITE>";
							soffsiteRef << "<TITLE>" << sTitle << "</TITLE>";     
							soffsiteRef << "</EXTERNALLINK>";

							iHrefIndex++;
						}
						pLinkTree = pLinkTree->FindNextTagNode("LINK", pArticleTextTree);
					}
				
					// put the sections that we managed to get properly into the references part
					if (bEntryFound && bLinkScrutinySuccess)
					{
						// pass a string into the Entry stored procedure to get a block
						// of formatted XML holding the h2g2 links section
						if (iArticleCount > 0)
						{
							FetchBatchOfArticlenames(&EntrySP, &sEntriesRef);
						}
						CTDVString sEntriesBlock;
						sEntriesBlock << "<ENTRIES>" << sEntriesRef << "</ENTRIES>";
						// and put it into the article XML
						sArticle << sEntriesBlock;
					}
					if (bUserFound && bLinkScrutinySuccess)
					{
						if (iUserCount > 0)
						{
							FetchBatchOfUsernames(&UserSP, &sUsersRef);
						}

						// pass a string into the Users stored procedure to get a block
						// of formatted XML holding the h2g2 bio links section
						CTDVString sUsersBlock;
						sUsersBlock << "<USERS>" << sUsersRef << "</USERS>";
						// and put it into the article XML
						sArticle << sUsersBlock;
					}
					if (!soffsiteRef.IsEmpty())
					{
						// now if there are any offsite links of note then add to the article XML
						sArticle << "<EXTERNAL>" << soffsiteRef << "</EXTERNAL>";
					}
					// ok... finished with these two
				} 
				sArticle << "</REFERENCES>";
				// finish wrapping up and entering the references part
				AddInside("ARTICLEINFO", sArticle);

				if (m_Locations.HasLocations())
				{
					AddInside("ARTICLE", &m_Locations);
				}
			} 
		}
	}

	// make sure tree is deleted if something went wrong
	if (!bSuccess)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
	// how did we do?
	return bSuccess;
}


/*********************************************************************************

	bool CGuideEntry::GetH2G2IDFromString(TDVCHAR* sH2G2ID,int* iH2G2ID)

	Author:		Dharmesh Raithatha
	Created:	2/6/02
	Inputs:		sH2G2ID - either A***** or a****** or ******
	Outputs:	iH2G2ID - value to fill
	Returns:	true if a value was extracted and is a valid checksum, false otherwise
	Purpose:	Given a h2g2id string of the form A12345 or 12345, it returns the 
				int if it is a valid h2g2id

*********************************************************************************/

bool CGuideEntry::GetH2G2IDFromString(const CTDVString& sH2G2ID,int* iH2G2ID)
{
	if (sH2G2ID.IsEmpty())
	{
		return false;
	}

	CTDVString sID = sH2G2ID;

	if (sID.GetAt(0) == 'A' || sID.GetAt(0) == 'a')
	{ 
		sID.RemoveLeftChars(1);
	}


	*iH2G2ID = atoi(sID);

	return IsValidChecksum(*iH2G2ID);
}

/*********************************************************************************

	bool CGuideEntry::IsValidChecksum(int ih2g2ID, int* piCalcCheck, int* piCheckDigit, CTDVString* psh2g2ID)

	Author:		Oscar Gillespie, Kim Harries
	Created:	23/03/2000
	Inputs:		ih2g2ID - the ID to check the validity of
	Outputs:	TODO: explain these and what they are useful for
				piCalcCheck - ???
				piCheckDigit - ???
				psh2g2ID - ???
	Returns:	true if h2g2ID has a valid checksum, i.e. is a valid entry, false
				if not
	Purpose:	Determines if the h2g2ID is a valid one or not by examining its
				checksum digit.

*********************************************************************************/

bool CGuideEntry::IsValidChecksum(int ih2g2ID, int* piCalcCheck, int* piCheckDigit, CTDVString* psh2g2ID)
{
	TDVASSERT(ih2g2ID > 0, "CGuideEntry::IsValidChecksum(...) called with non-positive h2g2ID");

	// check that h2g2ID is a valid checksum
	CTDVString sh2g2ID = "";
	CTDVString sCheckDigit;
	CTDVString sEntryID;
	int iCalcCheck = 0;
	int iCheckDigit = 0;
	int iTestID = 0;
	int iTempID = 0;

	sh2g2ID << ih2g2ID;
	sCheckDigit = sh2g2ID.Right(1);
	iCheckDigit = atoi(sCheckDigit);
	// TODO: explain this more thoroughly
	sEntryID = sh2g2ID.TruncateRight(1);
	iTestID = atoi(sEntryID);
	iCalcCheck = 0;
	iTempID = iTestID;
	while (iTempID > 0)
	{
		iCalcCheck += iTempID % 10;
		iTempID = static_cast<int>(iTempID / 10);
	}
	iCalcCheck = iCalcCheck % 10;
	iCalcCheck = 9 - iCalcCheck;

	// now assign the calculated values to the output parameters if they were provided
	if (piCalcCheck != NULL)
	{
		*piCalcCheck = iCalcCheck;
	}
	if (piCheckDigit != NULL)
	{
		*piCheckDigit = iCheckDigit;
	}
	if (psh2g2ID != NULL)
	{
		*psh2g2ID = sh2g2ID;
	}
	// finally return the success value
	if (iCalcCheck != iCheckDigit)
	{
		// if they supplied an invalid check digit at the end of the article
		return false;
	}
	else
	{
		return true;
	}
}

/*********************************************************************************

	CXMLTree* CGuideEntry::FindBodyTextNode()

	Author:		Kim Harries
	Created:	25/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	ptr to the text node in the internal tree that contains the text
				for the body tag in the XML, or NULL if it can't find one
	Purpose:	Helper function to find the text of the body tag in the XML.

*********************************************************************************/

CXMLTree* CGuideEntry::FindBodyTextNode()
{
	// if tree is NULL then obviously no body
	if (m_pTree == NULL)
	{
		return NULL;
	}
	CXMLTree* pTemp = NULL;
	// if pTemp ends up NULL at any point then the tree does not contain a BODY tag
	// first find the node for the BODY tag
	pTemp = m_pTree->FindFirstTagName("BODY");
	if (pTemp != NULL)
	{
		// if okay then get the first child of this tag - i.e. the text node
		pTemp = pTemp->GetFirstChild();
	}
	// return what we found or NULL
	return pTemp;
}


bool CGuideEntry::AddEditHistory(CUser *pUser, int iEditType, const TDVCHAR *pReason)
{
	int iUserID;
	pUser->GetUserID(&iUserID);
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create stored procedure");
		return false;
	}

	SP.AddEditHistory(m_h2g2ID, iUserID, iEditType, pReason);
	return true;
}

/*********************************************************************************
	bool CGuideEntry::QueueForModeration(int iModTriggerId, CTDVCHAR* pcNotes)

	Author:		Kim Harries
	Created:	15/02/2001
	Inputs:		pcNotes
	Outputs:	-
	Returns:	true if successful
	Purpose:	Places this entry in the queue for moderation.

*********************************************************************************/

bool CGuideEntry::QueueForModeration(int iTriggerId, const TDVCHAR* pcNotes, 
	int* pModId)
{
	TDVASSERT(!IsEmpty(), "CGuideEntry::QueueForModeration(...) called on empty object");

	if (IsEmpty())
	{
		return false;
	}

	return QueueForModeration(m_InputContext, m_h2g2ID, iTriggerId, pcNotes, pModId);
}

/*********************************************************************************

	static bool CGuideEntry::QueueForModeration(int ih2g2ID, const TDVCHAR* pcNotes)

	Author:		Mark Neves
	Created:	18/09/2003
	Inputs:		ih2g2ID
				pcNotes
	Outputs:	-
	Returns:	true if OK, false otherwise
	Purpose:	Static function for easy access from other places

*********************************************************************************/

bool CGuideEntry::QueueForModeration(CInputContext& inputContext,int ih2g2ID, 
	int iTriggerId, const TDVCHAR* pcNotes, int* pModId)
{
	CStoredProcedure SP;
	if (!inputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to initialise a SP in CGuideEntry::QueueForModeration(...)");
		return false;
	}

	bool	bSuccess = true;

	bSuccess = bSuccess && SP.QueueArticleForModeration(ih2g2ID, iTriggerId,
		inputContext.GetCurrentUser() == NULL ? 0 : 
			inputContext.GetCurrentUser()->GetUserID(),
		pcNotes, pModId);

	return bSuccess;
}


/*********************************************************************************

	bool CGuideEntry::CreateCacheText(CTDVString* pCacheText)

	Author:		Kim Harries
	Created:	30/08/2000
	Inputs:		-
	Outputs:	pCacheText - text representing the full data for this object, enabling
					it to be cached safely without loss of information.
	Returns:	true if successful, false if not.
	Purpose:	Provides a method that guarantees producing a representation of the
				objects data suitable for storage in the cache. Must ensure that all
				necessary internal data is placed within the output variable. The
				default behaviour is to use the GetAsString method, but for some
				subclasses this may not be appropriate and these should override this
				method.

	Note:		CreateCacheText and CreateFromCacheText do not necessarily have to
				store the data in XML form, though this is by far the most obvious
				way inwhich to do it.

*********************************************************************************/

bool CGuideEntry::CreateCacheText(CTDVString* pCacheText)
{
	TDVASSERT(pCacheText != NULL, "pCacheText NULL in CGuideEntry::CreateCacheText(...)");
	CTDVString	sXML;

	if (pCacheText == NULL)
	{
		return false;
	}

	// simply store member variables in order on a seperate line before
	// the XML representation of the tree

	// NB!! If you change the list of parameters in any way, be sure to change the
	// value of CGuideEntry::CACHEVERSION, so that old cached articles are discarded

	*pCacheText << CGuideEntry::CACHEMAGICWORD << "\n";
	*pCacheText << CGuideEntry::CACHEVERSION   << "\n";
	*pCacheText << m_h2g2ID << "\n";
	*pCacheText << m_Style << "\n";
	*pCacheText << m_Status << "\n";
	*pCacheText << m_SiteID << "\n";
	*pCacheText << m_Submittable << "\n";
	*pCacheText << m_iTypeID << "\n";
	if (GetAsString(sXML))
	{
		*pCacheText << sXML;
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CGuideEntry::CreateFromCacheText(const TDVCHAR* pCacheText)

	Author:		Kim Harries
	Created:	30/08/2000
	Inputs:		-
	Outputs:	pCacheText - text representing the full data from which to create
					this object, enabling it to be created with all necessary
					information in place.
	Returns:	true if successful, false if not.
	Purpose:	Provides a method that guarantees that all necessary initialisations
				are done on the object when retrieving it from the cache. Must make
				sure that all member variables are set appropriately and the tree, if
				any, is built. Default behaviour is to use the CreateFromXMLText
				method to generate a tree from the XML text, but for subclasses
				that use member variables this may not be appropriate.

*********************************************************************************/

bool CGuideEntry::CreateFromCacheText(const TDVCHAR* pCacheText)
{
	// use parse string variant as it is more efficient at stripping left chars
	CTDVParseString	sText = pCacheText;
	CTDVString		sError;
	int				ih2g2ID = 0;
	int				iStyle = 0;
	int				iStatus = 0;
	int				iSiteID = 0;
	int				iSubmittable = 0;
	int				iVarsRead = 0;
	int				iPos = 0;
	int				iTypeID = 0;
	bool			bSuccess = false;

	int iMagicWord = 0;
	int iCacheVersion = 0;

	iVarsRead = sscanf(sText, "%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n", &iMagicWord, &iCacheVersion, &ih2g2ID, &iStyle, &iStatus, &iSiteID, &iSubmittable, &iTypeID);
	if (iVarsRead == 8)
	{
		if (iMagicWord == CGuideEntry::CACHEMAGICWORD && iCacheVersion == CGuideEntry::CACHEVERSION)
		{
			// all values read okay, so set the member variables
			m_h2g2ID = ih2g2ID;
			m_EntryID = m_h2g2ID / 10;
			m_Style = iStyle;
			m_Status = iStatus;
			m_SiteID = iSiteID;
			m_Submittable = iSubmittable;
			m_iTypeID = iTypeID;

			bSuccess = true;
		}
	}

	// find the position of the first tag and strip away anything before it
	// i.e. all the data for member variables
	if (bSuccess)
	{
		iPos = sText.Find('<');
		if (iPos < 0)
		{
			bSuccess = false;
		}
		else
		{
			sText.RemoveLeftChars(iPos);
		}
	}
	
	// now create the XML tree from the XML that is left
	if (bSuccess)
	{
		bSuccess = CreateFromXMLText(sText, &sError);
	}

	// Now get the Extra Info for the article and create the new extrainfo object
	// At the same time extract the DefaultCanRead, DefaultCanWrite and DefaultCanChangePermissions values
	if (bSuccess)
	{
		// Make sure we get the extrainfo for the article and NOT Related articles!!!
		CXMLTree* pArticle = m_pTree->FindFirstTagName("ARTICLE");
		if (pArticle != NULL)
		{
			CTDVString sPermission;

			pArticle->GetAttribute("DEFAULTCANREAD", sPermission);
			m_bDefaultCanRead = (atoi(sPermission) == 1);

			pArticle->GetAttribute("DEFAULTCANWRITE", sPermission);
			m_bDefaultCanWrite = (atoi(sPermission) == 1);

			pArticle->GetAttribute("DEFAULTCANCHANGEPERMISSIONS", sPermission);
			m_bDefaultCanChangePermissions = (atoi(sPermission) == 1);

			// Find the extrainfo inside the article
			CXMLTree* pExtra = pArticle->GetFirstChild(CXMLTree::T_NODE);
			while (pExtra != NULL && pExtra->GetName() != "EXTRAINFO")
			{
				pExtra = pExtra->GetNextSibling();
			}

			if (pExtra != NULL)
			{
				// Set ExtraInfo for the Tree.
				CTDVString sExtraInfo;
				pExtra->OutputXMLTree(sExtraInfo);
				m_ExtraInfo.Create(m_iTypeID,sExtraInfo);
			}
		}
	}

	// check that no parsing errors occurred
	if (sError.GetLength() > 0)
	{
		bSuccess = false;
	}
	return bSuccess;
}


int CGuideEntry::GetHiddenState()
{
	return m_HiddenState;
}

bool CGuideEntry::FetchBatchOfUsernames(CStoredProcedure *pSP, CTDVString *oString)
{
	CTDVString sTemp;
	pSP->GetUserNames(sTemp);
	*oString << sTemp;
	pSP->BeginFetchUserNames();
	return true;
}

bool CGuideEntry::FetchBatchOfArticlenames(CStoredProcedure *pSP, CTDVString *oString)
{
	CTDVString sTemp;
	pSP->GetArticleSubjects(sTemp);
	*oString << sTemp;
	pSP->BeginFetchArticleSubjects();
	return true;

}

/*********************************************************************************

	int CGuideEntry::GetSiteID()

	Author:		Jim Lynn
	Created:	24/07/2001
	Inputs:		-
	Outputs:	-
	Returns:	Site ID of the article
	Purpose:	Gives the SiteID of the current article, or 0 if no valid site is 
				found

*********************************************************************************/

int CGuideEntry::GetSiteID()
{
	return m_SiteID;
}

/*********************************************************************************

	int CGuideEntry::GetLocations()

	Author:		Steve Francis
	Created:	06/02/2008
	Inputs:		-
	Outputs:	-
	Returns:	Locations associated with the article
	Purpose:	Gives the Locations of the current article

*********************************************************************************/

CTDVString CGuideEntry::GetLocationsXML()
{
	CTDVString LocationsXML;
	m_Locations.GetAsString(LocationsXML);
	return LocationsXML;
}

/*********************************************************************************

	bool CGuideEntry::CreateSubmittableXML(CTDVString& sXML)

	Author:		Dharmesh Raithatha
	Created:	8/30/01
	Inputs:		-
	Outputs:	The XML for the SubmittableXML used in the entry data
	Returns:	true if successful, false otherwise
	Purpose:	Uses the current guide entry to create XML that contains the 
				information about whether the guideentry is submittable to 
				peer review or not. If the entry is already present in a review 
				forum then it will provide the information of where it is
	Notes:		Should make it submittable if the current user is the author
				However as this prevents caching, the logic is kept in the stylesheet
*********************************************************************************/

bool CGuideEntry::CreateSubmittableXML(int iH2G2ID, int iSubmittable, CTDVString& sXML)
{
	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		return false;
	}
	//if it is in a review forum then display the information regardless of state
	if (mSP.FetchReviewForumMemberDetails(iH2G2ID))
	{
		int iForumID = mSP.GetIntField("ForumID");
		int iThreadID = mSP.GetIntField("ThreadID");
		int iPostID = mSP.GetIntField("PostID");
		int iReviewForumID = mSP.GetIntField("ReviewForumID");

		CReviewForum mReviewForum(m_InputContext);
		if (mReviewForum.InitialiseViaReviewForumID(iReviewForumID))
		{
			
			CTDVString sReviewForumXML;
			mReviewForum.GetAsXMLString(sReviewForumXML);

			sXML << "<SUBMITTABLE TYPE='IN'>";
			sXML << sReviewForumXML;
			sXML << "<FORUM ID='" << iForumID << "'/>";
			sXML << "<THREAD ID='" << iThreadID << "'/>";
			sXML << "<POST ID='" << iPostID << "'/>";
			sXML << "</SUBMITTABLE>";
		}
		else
		{
			return false;
		}
	}
	else if (!IsSubmittableForPeerReview(iSubmittable))
	{
		sXML << "<SUBMITTABLE TYPE='NO'/>"; 
	}
	else
	{
			sXML << "<SUBMITTABLE TYPE='YES'/>";
	}

	return true;
}

bool CGuideEntry::RecommendEntry(int iH2G2ID)
{
	TDVASSERT(iH2G2ID > 0,"invalid h2g2id in CGuideEntry::RecommendEntry");

	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		return false;
	}

	if (mSP.FetchReviewForumMemberDetails(iH2G2ID))
	{
		int iReviewForumID = mSP.GetIntField("ReviewForumID");
		CTDVDateTime dDateEntered = mSP.GetDateField("DateEntered");
		CTDVDateTime dDateNow = CTDVDateTime::GetCurrentTime();

		CReviewForum mReviewForum(m_InputContext);
		if (mReviewForum.InitialiseViaReviewForumID(iReviewForumID))
		{
			if (mReviewForum.IsRecommendable())
			{
				int iIncubateTime = mReviewForum.GetIncubateTime();

				if (dDateEntered.DaysElapsed() >= iIncubateTime)
				{
					return true;
				}
			}
			
		}
	}

	return false;

}


/*********************************************************************************

	CXMLTree* CGuideEntry::ExtractTree()

	Author:		Igor Loboda
	Created:	9/5/2002
	Inputs:		-
	Outputs:	-
	Returns:	article as XML tree 
	Purpose:	Processes SITEFILTER tag. SITEFILTER subtrees which do not conform
				to the condition are removed from the output tree.
*********************************************************************************/
CXMLTree* CGuideEntry::ExtractTree()
{
	CXMLTree* tree = CPageBody::ExtractTree();
	if (tree == NULL)
	{
		return tree;
	}

	CTDVString sSiteName;
	m_InputContext.GetNameOfSite(m_InputContext.GetSiteID(), &sSiteName);

	CXMLTree* pNode = tree->FindFirstTagName("SITEFILTER",NULL,false);
	while (pNode != NULL)
	{
		bool bSiteInList = false;
		CXMLTree* pSites = pNode->FindFirstTagName("SITE",pNode);
		while (pSites != NULL)
		{
			CTDVString sSite;
			pSites->GetAttribute("NAME", sSite);
			if (sSite.CompareText(sSiteName))
			{
				bSiteInList = true;
				break;
			}
			pSites = pSites->FindNextTagNode("SITE", pNode);
		}

		CTDVString sExclude;
		pNode->GetAttribute("EXCLUDE", sExclude);
		bool bExclude = sExclude.CompareText("1");

		CXMLTree* pNodeToDelete = pNode;
		pNode = pNode->FindNextTagNode("SITEFILTER");

		if ((bExclude && bSiteInList) || (!bExclude && !bSiteInList))
		{
			pNodeToDelete->DetachNodeTree();
			delete pNodeToDelete;
		}
	}
	return tree;
}

/*********************************************************************************

	void CGuideEntry::GetExtraInfo(CExtraInfo& ExtraInfo)

	Author:		Dharmesh Raithatha
	Created:	6/26/2003
	Inputs:		-
	Outputs:	-
	Returns:	false if not initialised
	Purpose:	returns the ExtraInfo

*********************************************************************************/

bool CGuideEntry::GetExtraInfo(CExtraInfo& ExtraInfo)
{
	if (m_pTree == NULL)
	{
		return false;
	}

	ExtraInfo = m_ExtraInfo;

	return true;
}

/*********************************************************************************

	bool CGuideEntry::UpdateExtraInfoEntry(CExtraInfo& Extra)
	
	Author:		Mark Howitt
	Created:	18/08/2003
	Inputs:		Extra - The extrainfo object to update
	Outputs:	-
	Returns:	success bool
	Purpose:	calls the BeginUpdateArticle stored procedures to update extra
				info only

*********************************************************************************/

bool CGuideEntry::UpdateExtraInfoEntry(CExtraInfo& Extra)
{
	TDVASSERT(m_h2g2ID > 0,"Calling UpdateExtraInfoEntry() with uninitialised GuideEntry object!");

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	bool bSuccess = SP.BeginUpdateArticle(m_h2g2ID);
	bSuccess = bSuccess && SP.ArticleUpdateExtraInfo(Extra);

	if (bSuccess)
	{
		bSuccess = SP.DoUpdateArticle();
	}

	return bSuccess;
}

/*********************************************************************************

	bool CGuideEntry::UpdateBody(const CTDVString& sBodyText)

	Author:		Mark Neves
	Created:	27/11/2003
	Inputs:		sBodyText = the new body text for the guide
	Outputs:	-
	Returns:	true if OK, false otherwise
	Purpose:	updates the body text in the database for this guide

*********************************************************************************/

bool CGuideEntry::UpdateBody(const CTDVString& sBodyText)
{
	TDVASSERT(m_h2g2ID > 0,"Calling UpdateBody() with uninitialised GuideEntry object!");

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	bool bSuccess = SP.BeginUpdateArticle(m_h2g2ID);
	bSuccess = bSuccess && SP.ArticleUpdateBody(sBodyText);

	if (bSuccess)
	{
		CUser* pViewer = m_InputContext.GetCurrentUser();

		bSuccess = SP.DoUpdateArticle(true, pViewer->GetUserID());
	}

	return bSuccess;
}

/*********************************************************************************

	bool CGuideEntry::UpdateType(int iType)

	Author:		Mark Neves
	Created:	12/12/2003
	Inputs:		iType = the type value
	Outputs:	-
	Returns:	true if OK, false otherwise
	Purpose:	updates the type value in the database for this article

*********************************************************************************/

bool CGuideEntry::UpdateType(int iType)
{
	TDVASSERT(m_h2g2ID > 0,"Calling UpdateType() with uninitialised GuideEntry object!");

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	bool  bOK =  SP.BeginUpdateArticle(m_h2g2ID);
	bOK = bOK && SP.ArticleUpdateType(iType);

	CUser* pViewer = m_InputContext.GetCurrentUser();
	bOK = bOK && SP.DoUpdateArticle(1, pViewer->GetUserID());

	return bOK;
}

/*********************************************************************************

	bool CGuideEntry::UpdateStatus(int iStatus)

	Author:		Mark Neves
	Created:	15/12/2003
	Inputs:		iStatus = the status value
	Outputs:	-
	Returns:	true if OK, false otherwise
	Purpose:	updates the Status value in the database for this article

*********************************************************************************/

bool CGuideEntry::UpdateStatus(int iStatus)
{
	TDVASSERT(m_h2g2ID > 0,"Calling UpdateStatus() with uninitialised GuideEntry object!");

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	bool  bOK =  SP.BeginUpdateArticle(m_h2g2ID);
	bOK = bOK && SP.ArticleUpdateStatus(iStatus);
	bOK = bOK && SP.DoUpdateArticle();

	return bOK;
}

// Static Type Member Functions
bool CGuideEntry::IsTypeOfArticle(const int iTypeID)
{
	return (iTypeID >= TYPEARTICLE && iTypeID <= TYPEARTICLE_RANGEEND);
}

bool CGuideEntry::IsTypeOfClub(const int iTypeID)
{
	return (iTypeID >= TYPECLUB && iTypeID <= TYPECLUB_RANGEEND);
}

bool CGuideEntry::IsTypeOfReviewForum(const int iTypeID)
{
	return (iTypeID >= TYPEREVIEWFORUM && iTypeID <= TYPEREVIEWFORUM_RANGEEND);
}

bool CGuideEntry::IsTypeOfUserPage(const int iTypeID)
{
	return (iTypeID >= TYPEUSERPAGE && iTypeID <= TYPEUSERPAGE_RANGEEND);
}

bool CGuideEntry::IsTypeOfCategoryPage(const int iTypeID)
{
	return (iTypeID >= TYPECATEGORYPAGE && iTypeID <= TYPECATEGORYPAGE_RANGEEND);
}

// Member Type Functions
bool CGuideEntry::IsTypeOfArticle()
{
	return (m_iTypeID >= TYPEARTICLE && m_iTypeID <= TYPEARTICLE_RANGEEND);
}

bool CGuideEntry::IsTypeOfClub()
{
	return (m_iTypeID >= TYPECLUB && m_iTypeID <= TYPECLUB_RANGEEND);
}

bool CGuideEntry::IsTypeOfReviewForum()
{
	return (m_iTypeID >= TYPEREVIEWFORUM && m_iTypeID <= TYPEREVIEWFORUM_RANGEEND);
}

bool CGuideEntry::IsTypeOfUserPage()
{
	return (m_iTypeID >= TYPEUSERPAGE && m_iTypeID <= TYPEUSERPAGE_RANGEEND);
}

bool CGuideEntry::IsTypeOfCategoryPage()
{
	return (m_iTypeID >= TYPECATEGORYPAGE && m_iTypeID <= TYPECATEGORYPAGE_RANGEEND);
}

int CGuideEntry::GetType()
{
	return m_iTypeID;
}

/*********************************************************************************

	int CGuideEntry::GetArticleModerationStatus()

	Author:		Mark Neves
	Created:	16/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Gets an article's moderation status

*********************************************************************************/

int CGuideEntry::GetArticleModerationStatus()
{
	return GetArticleModerationStatus(m_InputContext, m_h2g2ID);
}

/*********************************************************************************

	static int CGuideEntry::GetArticleModerationStatus(CInputContext& inputContext, int ih2g2id)

	Author:		Mark Neves
	Created:	18/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Static function for getting an article's moderation status

*********************************************************************************/

int CGuideEntry::GetArticleModerationStatus(CInputContext& inputContext, int ih2g2id)
{
	CStoredProcedure SP;
	if (!inputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP in CGuideEntry::GetArticleModerationStatus");
		return false;
	}

	int iModerationStatus = 0;
	SP.GetArticleModerationStatus(ih2g2id, iModerationStatus);
	return iModerationStatus;
}

/*********************************************************************************

	bool CGuideEntry::IsArticleModerated()

	Author:		Mark Neves
	Created:	16/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	To find out if an article is moderated

*********************************************************************************/

bool CGuideEntry::IsArticleModerated()
{
	return IsArticleModerated(m_InputContext, m_h2g2ID);
}

/*********************************************************************************

	static bool CGuideEntry::IsArticleModerated(CInputContext& inputContext, int h2g2id)

	Author:		Mark Neves
	Created:	18/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Statci function to find out if an article is moderated

*********************************************************************************/

bool CGuideEntry::IsArticleModerated(CInputContext& inputContext, int h2g2id)
{
	int iModerationStatus = GetArticleModerationStatus(inputContext, h2g2id);

	bool bModerated = (iModerationStatus == MODERATIONSTATUS_POSTMODERATED || 
					   iModerationStatus == MODERATIONSTATUS_PREMODERATED);

	return bModerated;
}
/*********************************************************************************

	bool CGuideEntry::IsArticleInModeration()

	Author:		James Conway
	Created:	30/04/2008
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	To find out if an article in moderation

*********************************************************************************/

int CGuideEntry::IsArticleInModeration()
{
	return IsArticleInModeration(m_InputContext, m_h2g2ID);
}

/*********************************************************************************

	static bool CGuideEntry::IsArticleInModeration(CInputContext& inputContext, int h2g2id)

	Author:		James Conway
	Created:	30/04/2008
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Static function to find out if an article is in moderation

*********************************************************************************/

int CGuideEntry::IsArticleInModeration(CInputContext& inputContext, int h2g2id)
{
	CStoredProcedure SP;
	if (!inputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP in CArticleEditForm::IsArticleInModeration");
		return false;
	}

	int isArticleInModeration = 0;
	SP.IsArticleInModeration(h2g2id, isArticleInModeration);
	return isArticleInModeration;
}

/*********************************************************************************

	bool CGuideEntry::UpdateArticleModerationStatus(int iNewStatus)

	Author:		Mark Neves
	Created:	17/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Allows you to update an article's moderation status

*********************************************************************************/

bool CGuideEntry::UpdateArticleModerationStatus(int iNewStatus)
{
	if (CGuideEntry::UpdateArticleModerationStatus(m_InputContext, m_h2g2ID, iNewStatus))
	{
		m_iModerationStatus = iNewStatus;

		// If there's been a MODERATIONSTATUS node already added to the tree
		// make sure we update its value
		CXMLTree* pNode = m_pTree->FindFirstTagName("MODERATIONSTATUS");
		if (pNode != NULL)
		{
			CXMLTree* pTextChild = pNode->GetFirstChild(CXMLTree::T_TEXT);
			if (pTextChild != NULL)
			{
				CTDVString sNewValue(iNewStatus);
				pTextChild->SetText(sNewValue);
			}
		}

		return true;
	}

	return false;
}

/*********************************************************************************

	static bool CGuideEntry::UpdateArticleModerationStatus(CInputContext& inputContext, int ih2g2id, int iNewStatus)

	Author:		Mark Neves
	Created:	17/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Static function that allows you to update an article's moderation status

*********************************************************************************/

bool CGuideEntry::UpdateArticleModerationStatus(CInputContext& inputContext, int ih2g2id, int iNewStatus)
{
	CStoredProcedure SP;
	if (!inputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	return SP.UpdateArticleModerationStatus(ih2g2id,iNewStatus);
}


/*********************************************************************************

	bool CGuideEntry::PutArticleIntoPreMod(CTDVString &sReason)

	Author:		Mark Howitt
	Created:	10/02/2004
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/
/*IL: I've commented this method out as it is not used. Otherwise
I'd have to change the method to add to article moderation log that
the article was made hidden.

bool CGuideEntry::PutArticleIntoPreMod(CTDVString &sReason)
{
	// Queue, update moderation status and hide the guide entry.
	bool bOk = QueueForModeration(sReason);
	bOk = bOk && UpdateArticleModerationStatus(MODERATIONSTATUS_PREMODERATED);
	bOk = bOk && MakeHidden(3);
	return bOk;
}
*/


/*********************************************************************************

	bool CGuideEntry::GetCurrentGuideEntryBatchIDs(CDNAIntArray& EntryIDList, int& iFirstInBatch, int& iBatchStatus, CTDVDateTime* p_dMoreRecentThan)

		Author:		Nick Stevenson
        Created:	30/07/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CGuideEntry::GetCurrentGuideEntryBatchIDs(CDNAIntArray& EntryIDList, int& iFirstInBatch, int& iBatchStatus, CTDVDateTime* p_dMoreRecentThan)
{

	// Create the stored procedure and fail if we couldn't get it
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		//return ErrorMessage("Initialise Stored Procedure", "Failed to create stored procedure object in CIDifDocBuilder::Build()");
		TDVASSERT(false, "Failed to create stored procedure object in CGuideEntry::GetH2G2IDsInBatch()");
		return false;
	}

	// Get the result from the stored procedure
	SP.GetCurrentGuideEntryBatchIDs(iFirstInBatch, p_dMoreRecentThan);

	bool bBatchData = false;
	while(!SP.IsEOF())
	{
		if(!bBatchData)
		{
			iBatchStatus = SP.GetIntField("BatchStatus");
			iFirstInBatch= SP.GetIntField("BatchFirst");

			if(iBatchStatus > 0)
			{
				// we've don't have entries in the returning set so break out
				break;
			}
			bBatchData = true;
		}

		// else we have some entries to deal with
		EntryIDList.Add(SP.GetIntField("H2G2ID"));
		SP.MoveNext();
	}

	return true;
}


/*********************************************************************************
bool CGuideEntry::ChangeArticleXMLPermissionsForUser(CUser* pViewingUser)

Author:		David van Zijl
Created:	04/10/2004
Inputs:		pViewingUser - viewing user or NULL if you don't want to fetch permissions
Outputs:	-
Returns:	false if critical error or current viewing user not in GuideEntryPermissions 
			table, true otherwise
Purpose:	Changes the CANREAD, CANWRITE and CANCHANGEPERMISSIONS attributes
			of the ARTICLE xml element depending on the settings for the current
			viewing user
*********************************************************************************/

bool CGuideEntry::ChangeArticleXMLPermissionsForUser(CUser* pViewingUser)
{
	if (pViewingUser == NULL)
	{
		return true;
	}

	// Always give permissions to editors and superusers
	//
	if (pViewingUser->GetIsEditor() || pViewingUser->GetIsSuperuser())
	{
		m_bCanRead = true;
		m_bCanWrite = true;
		m_bCanChangePermissions = true;
	}
	else
	{
		CStoredProcedure SP;
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			TDVASSERT(false, "CGuideEntry::ChangeArticleXMLPermissionsForUser - failed to initialise SP object");
			return false;
		}

		bool bUserFound = false;
		if (SP.GetArticlePermissionsForUser(m_h2g2ID, pViewingUser->GetUserID(), bUserFound, m_bCanRead, m_bCanWrite, m_bCanChangePermissions) 
			&& bUserFound)
		{
			// Great, permissions set
		}
		else
		{
			// User not found
			return false;
		}
	}

	// Update ARTICLE node to have correct permissions for this user
	//
	CXMLTree* pNode = m_pTree->FindFirstTagName("ARTICLE");
	if (pNode == NULL)
	{
		TDVASSERT(false, "CGuideEntry::ChangeArticleXMLPermissionsForUser - No ARTICLE node found!");
		return false;
	}

	if (m_bCanRead)
	{
		pNode->SetAttribute("CANREAD","1");
	}
	else
	{
		pNode->SetAttribute("CANREAD","0");
	}
	if (m_bCanWrite)
	{
		pNode->SetAttribute("CANWRITE","1");
	}
	else
	{
		pNode->SetAttribute("CANWRITE","0");
	}
	if (m_bCanChangePermissions)
	{
		pNode->SetAttribute("CANCHANGEPERMISSIONS","1");
	}
	else
	{
		pNode->SetAttribute("CANCHANGEPERMISSIONS","0");
	}

	return true;
}

/*********************************************************************************

	static bool CGuideEntry::GetGuideEntryOwner(CInputContext& inputContext, int ih2g2id, int &iOwnerID)

	Author:		Steven Francis
	Created:	27/07/2006
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Static function for getting the Owner ID of a Guide Entry

*********************************************************************************/

bool CGuideEntry::GetGuideEntryOwner(CInputContext& inputContext, int ih2g2id, int &iOwnerID, int &iForumID)
{
	CStoredProcedure SP;
	if (!inputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "Failed to create SP in CGuideEntry::GetGuideEntryOwner");
		return false;
	}

	if (SP.FetchGuideEntry(ih2g2id))
	{
		iOwnerID = SP.GetIntField("Editor");
		iForumID = SP.GetIntField("ForumID");
		return true;
	}
	
	return false;
}

/*********************************************************************************

	CTDVDateTime CGuideEntry::GetDateRangeStart()

		Author:		Mark Neves
		Created:	12/02/2007
		Inputs:		-
		Outputs:	-
		Returns:	The DateRangeStart value for this guide entry
		Purpose:	-

*********************************************************************************/

CTDVDateTime CGuideEntry::GetDateRangeStart()
{
	return m_DateRangeStart;
}

/*********************************************************************************

	CTDVDateTime CGuideEntry::GetDateRangeEnd()

		Author:		Mark Neves
		Created:	12/02/2007
		Inputs:		-
		Outputs:	-
		Returns:	The DateRangeStart value for this guide entry
		Purpose:	-

*********************************************************************************/

CTDVDateTime CGuideEntry::GetDateRangeEnd()
{
	return m_DateRangeEnd;
}

/*********************************************************************************

	CTDVDateTime CGuideEntry::GetTimeInterval()

		Author:		Mark Neves
		Created:	12/02/2007
		Inputs:		-
		Outputs:	-
		Returns:	The TimeInterval value for this guide entry
		Purpose:	-

*********************************************************************************/

int CGuideEntry::GetTimeInterval()
{
	return m_iTimeInterval;
}

/*********************************************************************************

	bool CGuideEntry::HasDateRange()

		Author:		Mark Neves
		Created:	12/02/2007
		Inputs:		-
		Outputs:	-
		Returns:	True if a date range has been defined for this guide entry
		Purpose:	-

*********************************************************************************/

bool CGuideEntry::HasDateRange()
{
	// This GuideEntry does not have a date range defined for it if the start date
	// equals the default date
	CTDVDateTime dtDefaultDate;
	return m_DateRangeStart != dtDefaultDate;
}
