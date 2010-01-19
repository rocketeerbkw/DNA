// ArticleEditForm.h: interface for the CArticleEditForm class.
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


#if !defined(AFX_ARTICLEEDITFORM_H__1C2EEB22_5A62_11D4_8710_00A024998768__INCLUDED_)
#define AFX_ARTICLEEDITFORM_H__1C2EEB22_5A62_11D4_8710_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "AuthorList.h"
#include "InputContext.h"
#include "TDVString.h"

#include "polls.h"
#include <vector>

#include "Locations.h"

// The following are used to define what kind of permissions an
// article has. I used strings because they need to be passed back
// and forth in forms and urls (make more sense than numbers)
#define ARTICLE_CANEDIT_MEONLY "me"
#define ARTICLE_CANEDIT_ALL "all"
#define ARTICLE_CANEDIT_USERLIST "userlist"
#define ARTICLE_CANEDIT_TEAMLIST "teamlist"

class CArticleEditForm : public CXMLObject  
{
public:
	int GetSiteID();
	virtual int GetHiddenState();
	virtual bool MakeHidden(int iModId, int iTriggerId);
	virtual bool MakeUnhidden(int iModId, int iTriggerId);
	CArticleEditForm(CInputContext& inputContext);
	virtual ~CArticleEditForm();

	virtual bool GetContentsOfTag(const TDVCHAR* pName, CTDVString* oContents);
	virtual bool GetAsString(CTDVString& sResult);
	virtual bool AddInside(const TDVCHAR* pTagName, CXMLObject* pObject);
	virtual bool AddInside(const TDVCHAR* pTagName, const TDVCHAR* pXMLText);
	virtual bool RemoveTag(const TDVCHAR* pTagName);
	virtual bool RemoveTagContents(const TDVCHAR* pTagName);
	virtual bool IsEmpty();
	virtual bool Destroy();
	virtual bool DoesTagExist(const TDVCHAR* pNodeName);	// Check whether named node exists in the object

	virtual bool CreateFromArticle(int ih2g2ID, CUser* pViewer);
	virtual bool CreateFromArticle(const TDVCHAR* pArticleName, CUser* pViewer);
	virtual bool CreateFromData(int ih2g2ID, int iFormat, int iStatus, int iEditorID, bool bIsMasthead, const TDVCHAR* pSubject, const TDVCHAR* pContent, int iHidden, int iSiteID,
								int iSubmittable, bool bArchive, bool bChangeArchive, bool bHasPreviewFunction = true, bool bHasAddEntryFunction = false, bool bHasUpdateFunction = true, bool bHasReformatFunction = true,
								bool bHasDeleteFunction = true, bool bHasConsiderFunction = false, bool bHasUnconsiderFunction = false, bool bHasHideFunction = false,
								bool bHasRemoveResearchersFunction = false, bool bHasAddResearchersFunction = false, bool bHasChangeSubmittableFunction = false,
								bool bHasMoveToSiteFunction = false, bool bPreProcessed = false,  std::vector<POLLDATA>* pvecPollTypes = NULL, const TDVCHAR* locationsXML = NULL);
	// getters
	virtual int GetH2G2ID();
	virtual int GetFormat();
	virtual int GetStatus();
	virtual int GetEditorID();
	virtual bool GetPreProcessed();
	virtual bool GetSubject(CTDVString *pSubject);
	virtual bool GetContent(CTDVString *pContent);
	virtual bool IsMasthead();
	virtual bool HasPreviewFunction();
	virtual bool HasAddEntryFunction();
	virtual bool HasUpdateFunction();
	virtual bool HasReformatFunction();
	virtual bool HasDeleteFunction();
	virtual bool HasConsiderFunction();
	virtual bool HasUnconsiderFunction();
	virtual bool HasHideFunction();
	virtual bool HasChangeSubmittableFunction();
	virtual bool HasRemoveResearchersFunction();
	virtual bool HasAddResearchersFunction();
//	virtual bool HasEditPermission(int iUserID);
	virtual bool HasEditPermission(CUser* pUser);
	virtual bool HasMoveToSiteFunction();
	// setters
	virtual bool Seth2g2ID(int ih2g2ID);
	virtual bool SetFormat(int iFormat);
	virtual bool SetStatus(int iStatus);
	virtual bool SetEditorID(int iEditorID);
	virtual bool SetSubject(const TDVCHAR* pSubject);
	virtual bool SetContent(const TDVCHAR* pContent);
	virtual bool SetIsMasthead(bool bIsMasthead);
	virtual bool SetHasPreviewFunction(bool bHasPreviewFunction);
	virtual bool SetHasAddEntryFunction(bool bHasAddEntryFunction);
	virtual bool SetHasUpdateFunction(bool bHasUpdateFunction);
	virtual bool SetHasReformatFunction(bool bHasReformatFunction);
	virtual bool SetHasDeleteFunction(bool bHasDeleteFunction);
	virtual bool SetHasConsiderFunction(bool bHasConsiderFunction);
	virtual bool SetHasUnconsiderFunction(bool bHasUnconsiderFunction);
	virtual bool SetHasHideFunction(bool bHasHideFunction);
	virtual bool SetHasChangeSubmittableFunction(bool bHasChangeSubmittableFunction);
	virtual bool SetHasRemoveResearchersFunction(bool bHasRemoveResearchersFunction);
	virtual bool SetHasAddResearchersFunction(bool bHasAddResearchersFunction);
	virtual bool SetHasMoveToSiteFunction(bool bHasMoveToSiteFunction);
	void SetDefaultPermissions(bool bDefaultCanRead, bool bDefaultCanWrite, bool bDefaultCanChangePermissions);
	virtual bool MakeToBeConsidered();
	virtual bool MakePublicUserEntry();
	virtual bool MakeNotForReview();
	virtual bool MakeForReview();

	virtual bool SetAction(const TDVCHAR* pAction);
	virtual bool GetAction(CTDVString* oAction);

	// researcher list functions
	void InitialiseResearcherList(int iH2G2ID, int iEditorID);
	bool GenerateResearcherListForGuide();
	virtual bool AddResearcher(int iUserID);
	virtual bool RemoveResearcher(int iUserID);
	bool ClearResearcherList();
	bool SetNewResearcherList(const TDVCHAR* pList);
	bool CommitResearcherList();

	virtual bool DeleteArticle(CUser* pDeletingUser);
	virtual bool UndeleteArticle(CUser* pUndeletingUser);
	virtual bool UpdateEntry(CUser* pUpdatingUser, bool& bProfanityFound, bool& bNonAllowedURLsFound, bool& bEmailAddressFound,bool bUpdateDateCreated = false );
	virtual bool AddEditHistory(CUser* pUser, int iEditType, const TDVCHAR* pReason);
	//virtual bool QueueForModeration(int iTriggerId, const TDVCHAR* pcNotes = NULL);
	virtual int  GetArticleModerationStatus();
	virtual bool IsArticleModerated();
	virtual int IsArticleInModeration();

	virtual bool IsArticleInReviewForum(int& iReviewForumID);
	virtual bool MoveToSite(int iNewSiteID);
	virtual bool HasEditPermission(CUser* pUser, int iH2G2ID, bool bAlreadyKnowPermissions = false, 
		int iStatus = 0, bool bCanWrite = false);
	bool HasChangePermissionsPermission(CUser* pUser, bool bCanChangePermissions);
	const TDVCHAR* DivineWhoCanEdit(const int iH2G2ID, bool bDefaultCanWrite);
	void SetEntryLocations(CUser* pUser, int ih2g2id);

protected:
	CAuthorList m_AuthorList;
	CTDVString	m_Subject;
	CTDVString	m_Content;
	int			m_h2g2ID;
	int			m_Format;
	int			m_Status;
	int			m_EditorID;
	bool		m_IsMasthead;
	bool		m_HasPreviewFunction;
	bool		m_HasAddEntryFunction;
	bool		m_HasUpdateFunction;
	bool		m_HasReformatFunction;
	bool		m_HasDeleteFunction;
	bool		m_HasConsiderFunction;
	bool		m_HasUnconsiderFunction;
	bool		m_HasHideFunction;
	bool		m_HasRemoveResearchersFunction;
	bool		m_HasAddResearchersFunction;
	bool		m_HasChangeSubmittableFunction;
	bool		m_HasMoveToSiteFunction;
	bool		m_IsEmpty;
	int			m_HiddenState;
	int			m_SiteID;
	int			m_Submittable;
	CTDVString	m_Action;
	bool		m_bArchive;	// True if the article has a read-only forum
	bool		m_bChangeArchive;	// false if the edit should leave the state unchanged
	bool		m_bCanRead;
	bool		m_bCanWrite;
	bool		m_bCanChangePermissions;
	bool		m_bDefaultCanRead;
	bool		m_bDefaultCanWrite;
	bool		m_bDefaultCanChangePermissions;
	bool		m_bPreProcessed;
	int			m_iProfanityTriggered;
	int			m_iNonAllowedURLsTriggered;
	int			m_iEmailAddressTriggered;

	std::vector<POLLDATA> m_vecPollTypes;

	CLocations  m_Locations;
	CTDVString  m_LocationsXML;

	virtual bool CreateFromXMLText(const TDVCHAR* xmlText, CTDVString* pErrorReport = NULL);
	virtual CXMLTree* ExtractTree();
	virtual bool UpdateRelativeDates();
	virtual bool SetSubmittable(int value);
};

#endif // !defined(AFX_ARTICLEEDITFORM_H__1C2EEB22_5A62_11D4_8710_00A024998768__INCLUDED_)
