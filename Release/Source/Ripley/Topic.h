#pragma once
#include "xmlobject.h"
#include "StoredProcedure.h"

class CTopic : public CXMLObject
{
public:
	enum eTopicStatus
	{
		TS_LIVE = 0,
		TS_PREVIEW,
		TS_DELETED,
		TS_ARCHIVE 
	};

	struct topicInfo
	{
		CTDVString editKey;
		int iTopicLinkID;
		int iTopicID;
	};

public:
	CTopic(CInputContext& inputContext);
	virtual ~CTopic(void);

public:
	bool CreateXMLForTopic();
	bool CreateTopic(int& iTopicID, int iSiteID, int iEditorID, const TDVCHAR* psTitle, const TDVCHAR* psText, CTopic::eTopicStatus TopicStatus, int  iTopicLinkID, bool bIgnoreDuplicates); 
	bool EditTopic(int iTopicID, int iSiteID, int iEditorID, const TDVCHAR* psTitle, const TDVCHAR* psText, CTopic::eTopicStatus TopicStatus,  int iStyle, const TDVCHAR* sEditKey, bool& bEditKeyClash); 
	bool GetTopicsForSiteID(int iSiteID, CTopic::eTopicStatus TopicStatus, bool bIncludeArchivedTopics = false);
	bool GetTopicDetails(int iTopicID);
	bool DeleteTopic(int iTopicID);
	bool MoveTopicPositionally(int iTopicID, int iDirection, const TDVCHAR* sEditKey, bool& bEditKeyClash);
	bool GetTopicTitle(int iTopicID, CTDVString& sTitle);
	bool GetNumberOfTopicsForSiteID(int iSiteID, int& iNumTopics, CTopic::eTopicStatus TopicStatus = TS_PREVIEW);
	bool MakePreviewTopicActiveForSite(const int iSiteID, int iTopicID, int iEditorID);
	bool MakePreviewTopicsActiveForSite(const int iSiteID, int iEditorID);
	bool GetTopicForumIDs(const int iSiteID, CDNAIntArray& ForumIDs, CTopic::eTopicStatus TopicStatus = TS_PREVIEW);
	bool CheckAndGetBoardPromoForTopic(int iForumID, int& iBoardPromoID);
	bool UnArchiveTopic(int iTopicID, int iUserID);

public:
	bool GetTopicText(CTDVString& sText, bool bMakeEditable = false);
	bool GetTopicTitle(CTDVString& sTitle);
	bool GetTopicTextStyle(int& iType);
	bool GetTopicEditKey(CTDVString& sEditKey);
	bool GetTopicID(int& iTopicID);

	bool GetTopicLinkIDAndEditKeyForTopicIDOnSite(int iTopicID, int iSiteID, CTDVString& editKey, int& topicLinkID, int& iLinkTopicElementID, CTDVString& topicElementEditKey);

private:
	CTDVString m_sTitle;
	CTDVString m_sText;
	CTDVString m_sEditKey;
	CList<topicInfo> m_siteTopicIDs;

	int m_iTopicListSiteID;
	int m_iTopicID;
	int m_iTextStyle;
	bool m_bValidTopic;

	bool GetTopicDetailsFromDatabase(int iTopicID, CStoredProcedure& SP);
};
