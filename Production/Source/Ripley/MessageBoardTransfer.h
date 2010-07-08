#pragma once
#include ".\xmlobject.h"
#include ".\MessageBoardPromo.h"

class CMessageBoardTransfer : public CXMLObject
{
public:
	CMessageBoardTransfer(CInputContext& inputContext);
	virtual ~CMessageBoardTransfer();

public:
	bool CreateBackupXML(int iSiteID);
	bool RestoreFromBackupXML(const TDVCHAR* pRestoreXML);

private:
	bool GetRestoreSiteID(CXMLTree* pTree,int& iSiteID);

	bool AddTopics(int iSiteID);
	bool AddFrontPage(int iSiteID);
	bool AddFrontPageTopicElements(int iSiteID);
	bool AddBoardPromos(int iSiteID);
	bool AddTextBoxes(int iSiteID);
	bool AddForumSchedule(int iSiteID);
	bool AddSiteConfig(int iSiteID);

	bool RestoreFrontPageXML(CXMLTree* pNode,int iSiteID, int iEditorID);
	bool RestoreTopicList(CXMLTree* pNode,int iSiteID,int iEditorID);
	bool RestoreTopicElementList(CXMLTree* pNode,int iSiteID, int iEditorID);
	bool RestoreBoardPromoList(CXMLTree* pNode,int iSiteID,int iEditorID);
	bool RestoreTextBoxList(CXMLTree* pNode,int iSiteID,int iEditorID);
	bool RestoreForumSchedules(CXMLTree* pNode,int iSiteID);
	bool RestoreSiteConfig(CXMLTree* pNode,int iSiteID);

	bool SetBoardPromoLocations(CMessageBoardPromo& BoardPromo,int iBoardPromoID,CXMLTree* pNode,const TDVCHAR* pEditKey,int iEditorID);

	int GetNodeInt(const TDVCHAR* pNodeName,CXMLTree* pRoot);
	CTDVString GetNodeText(const TDVCHAR* pNodeName,CXMLTree* pRoot);
	CTDVString GetNodeChildXML(const TDVCHAR* pNodeName,CXMLTree* pRoot);

	struct topicInfo
	{
		CTDVString editKey;
		CTDVString topicElementEditKey;
		int iTopicElementID;
		int iTopicID;
	};

	map<int,topicInfo> m_TopicInfo;

	map<int,int> m_mTopicIDMap;
};
