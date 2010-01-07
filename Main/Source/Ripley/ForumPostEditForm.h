#ifndef _FORUMPOSTEDITFORM_H_
#define _FORUMPOSTEDITFORM_H_

/*********************************************************************************
class CForumPostEditForm : public CXMLObject

An edit form for editing posts. Used in 
EditPostPageBuilder (editors)
and 
EditRecentPostBuilder (owner of posts can edit within time window)
*********************************************************************************/

#include "XMLObject.h"
#include "TDVDateTime.h"
#include "StoredProcedure.h"


class CForumPostEditForm : public CXMLObject
{
public:
	CForumPostEditForm(CInputContext& inputContext);
	~CForumPostEditForm();

	enum PostUpdateError
	{
		NONE,
		TOOLONG,
		TOOMANYSMILIES,
		CONTAINSPROFANITIES,
		CONTAINSNONALLOWEDURLS,
		CONTAINSEMAILADDRESS,
		HIDDEN
	};

	// Accessors
	//
	void SetPostID(int iPostID);
	void AddStatusMessage(const TDVCHAR* sMessage);

	// Perform useful functions
	//
	bool ProcessForumPostUpdate(CUser* pUser, const TDVCHAR* pSubject, const TDVCHAR* pText, const TDVCHAR *pEventDate, bool bSetLastUpdated, bool bForceModerateAndHide, bool bIgnoreModeration);
	bool HidePost( int iHiddenStatus = CStoredProcedure::HIDDENSTATUSREMOVED );
	bool UnhidePost( );
	bool Cancel();
	void IncludeUserPostDetailsViaBBCUID() { m_bIncUserPostDetailsViaBBCUID = true; }

	// Generate XML
	//
	bool Build();

	// Other
	//
	bool LoadPostDetails(bool bForceFetch = false);
	bool CheckUserCanEditRecentPost();
	bool ValidatePostDetails(CTDVString sSubject, CTDVString sBody, PostUpdateError& errorType);

	int GetForumID() { return m_iForumID; }
	int GetUserId()		{ return m_iUserID; }
	int GetPostIndex() { return m_iPostIndex; }
	int GetSiteID() { return m_iSiteID; }
	//Preview Support.
	void SetPreviewSubject( const CTDVString& sSubject) { m_sSubject = sSubject; m_bPreview = true; }
	void SetPreviewText( const CTDVString& sText) { m_sText = sText; m_bPreview = true; }
private:
	bool AddUserPostDetailsViaBBCUIDXML();

	int m_iPostID;
	CTDVString m_sMessageXML;

	// Keep post details internally, this way we can load them once
	// and use the details across functions
	// Always call LoadPostDetails() before trying to use these!
	//
	bool m_bPreview;
	bool m_bHavePostDetails;
	bool m_bIncUserPostDetailsViaBBCUID;
	int m_iUserID;
	int m_iThreadID;
	int m_iForumID;
	int m_iHidden;
	int m_iPostIndex;
	CTDVString m_sSubject;
	CTDVString m_sText;
	CTDVString m_sUserName;
	CTDVString m_sTitle;
	CTDVString m_sArea;
	CTDVString m_sSiteSuffix;
	CTDVString m_sFirstNames;
	CTDVString m_sLastName;
	CTDVString m_IPAddress;
	CTDVString m_BBCUID;
	
	int m_nActive;
	int m_nJournal;
	int m_nTaxonomyNode;
	int m_nStatus;

	CTDVString m_sGroups;

	CTDVDateTime m_DateCreated;
	int m_iSiteID;
};


/*********************************************************************************
inline void CForumPostEditForm::SetPostID(int iPostID)
Author:		David van Zijl
Created:	10/11/2004
Purpose:	Sets internal value
*********************************************************************************/

inline void CForumPostEditForm::SetPostID(int iPostID)
{
	m_iPostID = iPostID;
}


/*********************************************************************************
inline void CForumPostEditForm::AddStatusMessage(const TDVCHAR* sMessage)
Author:		David van Zijl
Created:	10/11/2004
Purpose:	Appends to internal message string
*********************************************************************************/

inline void CForumPostEditForm::AddStatusMessage(const TDVCHAR* sMessage)
{
	m_sMessageXML << sMessage;
}

#endif
