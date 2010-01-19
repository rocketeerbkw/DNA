// GuideEntry.h: interface for the CGuideEntry class.
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


#if !defined(AFX_GUIDEENTRY_H__F323B0B3_F34A_11D3_8A11_00104BF83D2F__INCLUDED_)
#define AFX_GUIDEENTRY_H__F323B0B3_F34A_11D3_8A11_00104BF83D2F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "PageBody.h"
#include "User.h"
#include "TDVString.h"	// Added by ClassView
#include "ExtraInfo.h"
#include "DateRangeValidation.h"
#include "Locations.h"
// TODO: is it actually helpful to derived from CPageBody or not?

class CDNAIntArray;

class CGuideEntry : public CPageBody  
{
public:
	//bool PutArticleIntoPreMod(CTDVString& sReason);

	enum
	{
		TYPEARTICLE					= 1,
		TYPEARTICLE_RANGEEND		= 1000,

		TYPECLUB					= 1001,
		TYPECLUB_RANGEEND			= 2000,

		TYPEREVIEWFORUM				= 2001,
		TYPEREVIEWFORUM_RANGEEND	= 3000,

		TYPEUSERPAGE				= 3001,
		TYPEUSERPAGE_RANGEEND		= 4000,

		TYPECATEGORYPAGE			= 4001,
		TYPECATEGORYPAGE_RANGEEND	= 5000,
	};

	int GetSiteID();
	bool FetchBatchOfArticlenames(CStoredProcedure* pSP, CTDVString* oString);
	bool FetchBatchOfUsernames(CStoredProcedure* pSP, CTDVString* oString);
	virtual int GetHiddenState();
	virtual bool MakeHidden(int iHiddenStatus, int iModId, int iTriggerId);
	virtual bool MakeUnhidden(int iModId, int iTriggerId);

	int GetOriginalHiddenStatus(void) { return m_iOriginalHiddenStatus; }

	virtual bool AddEditHistory(CUser* pUser, int iEditType, const TDVCHAR* pReason);
	virtual bool QueueForModeration(int iTriggerId, const TDVCHAR* pcNotes, int* pModId);
	static  bool QueueForModeration(CInputContext& inputContext, int ih2g2ID, 
		int iTriggerId, const TDVCHAR* pcNotes, int* pModId);
	// TODO: check if need to override any CPageBody methods?

	CGuideEntry(CInputContext& inputContext);
	virtual ~CGuideEntry();
	
	static bool IsValidChecksum(int ih2g2ID, int* piCalcCheck = NULL, int* piCheckDigit = NULL, CTDVString* psh2g2ID = NULL);
	static bool GetH2G2IDFromString(const CTDVString& sH2G2ID,int* iH2G2ID);
	
	// TODO: do we need an empty initialiser?
	virtual bool Initialise(int h2g2ID, int iSiteID, CUser* pViewingUser = NULL, 
		bool bShowEntryData = false, bool bShowPageAuthors = false, bool bShowReferences = false, bool bSafeToCache = false, bool bShowHidden = false, bool bProfanityTriggered = false, bool bNonAllowedURLsTriggered = false);
	virtual bool Initialise(const TDVCHAR* pArticleName, int iSiteID, CUser* pViewingUser = NULL, 
		bool bShowEntryData = false, bool bShowPageAuthors = false, bool bShowReferences = false, bool bSafeToCache = false);

	virtual bool CreateFromData(CUser* pAuthor, int ih2g2ID, const TDVCHAR* pSubject, const TDVCHAR* pContent, CExtraInfo &ExtraInfo, int iStyle, int iSiteID,int iSubmittable,
								bool bShowEntryData = false, bool bShowPageAuthors = false, bool bShowReferences = false, bool bIsPreProcessed = false, CDateRangeValidation* pDateRangeVal = 0);

	bool IsTypeOfArticle();
	bool IsTypeOfClub();
	bool IsTypeOfReviewForum();
	bool IsTypeOfUserPage();
	bool IsTypeOfCategoryPage();

	static bool IsTypeOfArticle(const int iTypeID);
	static bool IsTypeOfClub(const int iTypeID);
	static bool IsTypeOfReviewForum(const int iTypeID);
	static bool IsTypeOfUserPage(const int iTypeID);
	static bool IsTypeOfCategoryPage(const int iTypeID);

	int GetType();

	// updates the entry in the DB, or adds it if it is a new entry
	bool UpdateExtraInfoEntry(CExtraInfo& Extra);
	bool UpdateBody(const CTDVString& sBodyText);
	bool UpdateType(int iType);
	bool UpdateStatus(int iStatus);

	// does this user have edit permission?
	virtual bool HasEditPermission(CUser* pUser);
	// check if user is currently subbing this entry
	virtual bool CheckIsSubEditor(CUser* pUser);
//	virtual bool CheckIsSubEditor(int iUserID);

	virtual bool GetSubject(CTDVString& sSubject);
	virtual bool GetBody(CTDVString& sBody);
//	virtual bool GetContent(CTDVString& sContent);
//	virtual bool GetEditorName(CTDVString& sEditor);
//	virtual bool GetDateCreated(CTDVDateTime& dDateCreated);
	virtual int GetForumID();
	virtual int GetH2G2ID();
	virtual int GetStyle();
	virtual int GetStatus();
	virtual int GetEditorID();
	virtual bool GetExtraInfo(CExtraInfo& ExtraInfo);
	//virtual bool SetExtraInfo(const CExtraInfo& ExtraInfo);
	bool GetCanRead();
	bool GetCanWrite();
	bool GetCanChangePermissions();
	bool GetDefaultCanRead();
	bool GetDefaultCanWrite();
	bool GetDefaultCanChangePermissions();
	bool GetIsPreProcessed() { return m_bPreProcessed; }

	virtual bool IsPlainText();
	virtual bool IsGuideML();
	virtual bool IsHTML();
	// TODO: may need others
	virtual bool IsApproved();
	virtual bool IsToBeConsidered();
	virtual bool IsDeleted();
	virtual bool IsLocked();
	virtual bool IsSubmittableForPeerReview();

	virtual bool SetSubject(const TDVCHAR* pSubject);
	virtual bool SetBody(const TDVCHAR* pBody);
//	virtual bool SetContent(const TDVCHAR* pContent);
	virtual bool SetStyle(int iStyle);
	virtual bool SetStatus(int iStatus);
	// TODO: is this needed?
//	virtual bool SetEditor(CTDVString& sEditor);

	// TODO: are these setters useful?
	virtual bool MakeGuideML();
	virtual bool MakePlainText();
	virtual bool MakeHTML();
	virtual bool MakeApproved();
	virtual bool MakeCancelled();
	virtual bool MakeToBeConsidered();
	virtual bool MakePublicUserEntry();
	virtual bool MakeSubmittable();
	virtual bool MakeUnSubmittable();
	virtual bool RecommendEntry(int iH2G2ID);

	enum
	{	
		CACHEMAGICWORD = 0xDEAFABBA, 
		CACHEVERSION   = 1
	};

	int			GetArticleModerationStatus();
	static int	GetArticleModerationStatus(CInputContext& inputContext, int ih2g2id);
	bool		IsArticleModerated();
	static bool	IsArticleModerated(CInputContext& inputContext, int h2g2id);
	bool		UpdateArticleModerationStatus(int iNewStatus);
	static bool UpdateArticleModerationStatus(CInputContext& inputContext, int ih2g2id, int iNewStatus);
	int			IsArticleInModeration();
	static int	IsArticleInModeration(CInputContext& inputContext, int h2g2id);

	bool		GetCurrentGuideEntryBatchIDs(CDNAIntArray& EntryIDList, int& iFirstInBatch, int& iBatchStatus, CTDVDateTime* p_dMoreRecentThan);

	void		SetEditMode(bool bEditMode = true) { m_bEditing = bEditMode; }

	static bool GetGuideEntryOwner(CInputContext& inputContext, int ih2g2id, int &iOwnerID, int &iForumID);

	bool		 HasDateRange();
	CTDVDateTime GetDateRangeStart();
	CTDVDateTime GetDateRangeEnd();
	int			 GetTimeInterval();

	CTDVString GetLocationsXML();

protected:
	int		m_h2g2ID;
	int		m_EntryID;
	int		m_Style;
	int		m_Status;
	int		m_HiddenState;
	int		m_SiteID;
	int		m_Submittable;
	int		m_iTypeID;
	int		m_iModerationStatus;
	int		m_iOriginalHiddenStatus;
	bool	m_bEditing;
	bool	m_bDefaultCanRead;
	bool	m_bDefaultCanWrite;
	bool	m_bDefaultCanChangePermissions;
	bool	m_bCanRead;
	bool	m_bCanWrite;
	bool	m_bCanChangePermissions;
	bool	m_bPreProcessed;

	CTDVDateTime m_DateRangeStart;
	CTDVDateTime m_DateRangeEnd;
	int			 m_iTimeInterval;

	CExtraInfo m_ExtraInfo;
	CLocations m_Locations;

	virtual bool CreateCacheText(CTDVString* pCacheText);
	virtual bool CreateFromCacheText(const TDVCHAR* pCacheText);
	virtual bool BuildTreeFromData(CUser* pAuthor, int ih2g2ID, int iEditorID, int iForumID, int iStyle, int iStatus, int iModerationStatus,
								   CTDVDateTime& pDateCreated, const TDVCHAR* pSubject, const TDVCHAR* pBody,
								   bool bShowEntryData, bool bShowPageAuthors, bool bShowReferences, int iSiteID, int iSubmittable,CExtraInfo& ExtraInfo,
								   CTDVDateTime& dLastUpdated, bool bIsPreProcessed,
								   CTDVDateTime& dtRangeStart, CTDVDateTime& dtRangeEnd, int iTimeInterval,
								   float latitude, float longitude,
								   bool bProfanityTriggered = false, bool bNonAllowedURLsTriggered = false);
	virtual CXMLTree* FindBodyTextNode();
	virtual bool CreateSubmittableXML(int iH2G2ID, int iSubmittable,CTDVString& sXML);
	virtual bool IsSubmittableForPeerReview(int iSubmittable);
	CXMLTree* ExtractTree();
	bool ChangeArticleXMLPermissionsForUser(CUser* pViewingUser);
};



inline bool CGuideEntry::GetCanRead()
{
	return m_bCanRead;
}

inline bool CGuideEntry::GetCanWrite()
{
	return m_bCanWrite;
}

inline bool CGuideEntry::GetCanChangePermissions()
{
	return m_bCanChangePermissions;
}

inline bool CGuideEntry::GetDefaultCanRead()
{
	return m_bDefaultCanRead;
}

inline bool CGuideEntry::GetDefaultCanWrite()
{
	return m_bDefaultCanWrite;
}

inline bool CGuideEntry::GetDefaultCanChangePermissions()
{
	return m_bDefaultCanChangePermissions;
}

#endif // !defined(AFX_GUIDEENTRY_H__F323B0B3_F34A_11D3_8A11_00104BF83D2F__INCLUDED_)
