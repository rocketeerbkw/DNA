#pragma once
#include ".\xmlobject.h"
#include ".\StoredProcedure.h"

class CFrontPageElement : public CXMLObject
{
public:
	enum eElementType
	{
		ET_VOID = -1,
		ET_TOPIC = 0,
		ET_TEXTBOX,
		ET_BOARDPROMO
	};
protected:
	//Force derivation
	CFrontPageElement(CInputContext& inputContext, eElementType ElementType, const TDVCHAR* psElementTagName);
	virtual ~CFrontPageElement(void);
public:
	enum eElementStatus
	{
		ES_LIVE = 0,
		ES_PREVIEW,
		ES_DELETED,
		ES_LIVEARCHIVED,
		ES_PREVIEWARCHIVED
	};

	enum eElementParam
	{
		EV_TITLE = 0,
		EV_TEXT,
		EV_TOPICID,
		EV_TEMPLATETYPE,
		EV_TEXTBOXTYPE,
		EV_TEXTBORDERTYPE,
		EV_FRONTPAGEPOSITION,
		EV_ELEMENTSTATUS,
		EV_LINKID,
		EV_IMAGENAME,
//		EV_USENUMBEROFPOSTS, // No longer used by any of the elements
		EV_ELEMENTID,
		EV_SITEID,
		EV_FRONTPAGEELEMENTTYPE,
		EV_IMAGEWIDTH,
		EV_IMAGEHEIGHT,
		EV_IMAGEALTTEXT
	};

protected:
	CTDVString m_LastActionXML;
	eElementType m_eFrontPageElementType;
	CTDVString m_sElementTagName;
	int m_iElementID;

	int m_iTextBoxType;
	int m_iTextBoarderType;

private:
	CTDVString			m_sTitle;
	CTDVString			m_sText;
	CTDVString			m_sImageName;
	CTDVString			m_sImageAltText;
	CTDVString			m_sEditKey;
	int					m_iTopicID;
	int					m_iTemplateType;
	int					m_iFrontPagePosition;
	int					m_iElementStatus;
	int					m_iLinkID;
	int					m_iSiteID;
	int					m_iImageWidth;
	int					m_iImageHeight;
	int					m_iElementLinkID;
	int					m_iForumPostCount;
	bool				m_bUseNoOfPosts;
	int					m_iEditorID;
	CTDVDateTime		m_dDateCreated;
	CTDVDateTime		m_dLastUpdated;	

	bool m_bHaveStartedUpdate;
	int m_iUpdateElementID;
	CStoredProcedure m_SP;

public:
	CTDVString GetElementsLastActionXML();
	bool CreateXMLForCurrentState(void);

private:
	bool BeginElementUpdate( int iElementID );
	bool MakePreviewItemActive(int iElementID,int iEditorID);

protected:
	virtual bool GetElementValue(eElementParam ElementParam, int& iValue, int iElementID = 0);
	bool GetElementValue(eElementParam ElementParam, CTDVString& sValue, int iElementID = 0);

	bool SetElementValue(int iElementID, int iValue, bool bCommitChanges, eElementParam ElementParam, int iUserID, const TDVCHAR* psEditKey, bool bApplyTemplateToAllInSite = false);
	bool SetElementValue(int iElementID, const TDVCHAR* psValue, bool bCommitChanges, eElementParam ElementParam, int iUserID, const TDVCHAR* psEditKey);

	bool CommitElementChanges(int iUserID, const TDVCHAR* psEditKey,CTDVString* psNewEditKey = NULL);

	bool GetElementDetails(int iElementID);
	bool GetElementsForSiteID(int iSiteID, eElementStatus ElementStatus, int iActiveElementID = 0);

	bool CreateNewElement(eElementStatus ElementStatus, int iSiteID, int iEditorID, int &iNewElementID, CTDVString& sEditKey, int iFrontPagePos = 0, int iElementLinkID = 0);
	bool DeleteElement( int iElementID, int iUserID );
	bool MakeElementsActiveForSite(int iSiteID, int iEditorID, int iElementID = 0);

	bool GetNumberOfFrontPageElementsForSiteID(int iSiteID, CFrontPageElement::eElementStatus ElementStatus, int& iNumElements);

	void SetElementsLastActionXML(const TDVCHAR* psActionXML);

	virtual bool GetElementDetailsFromDatabase(CStoredProcedure& SP);

	bool CreateXMLForElement(CDBXMLBuilder& XML, int iActiveElementID = 0);

	//Allow Specialised classes to insert XML for their elements specific to their class - Do nothing a s a default.
	virtual bool CreateInternalXMLForElement(CDBXMLBuilder& XML) { return true; }
};
