// TagItem.h: interface for the CTagItem class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_TAGITEM_H__8D5BD573_35C8_4CE4_B3FB_22F629C2825E__INCLUDED_)
#define AFX_TAGITEM_H__8D5BD573_35C8_4CE4_B3FB_22F629C2825E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "DNAArray.h"
#include <afxtempl.h>
#include <map>
using namespace std;

class CTagLimits
{
public:
	CTagLimits(const int iType = 0, const int iLimit = 0, const TDVCHAR* pDescription = NULL/* CTDVString sDescription = ""*/, const int iSiteID = 0)
		: m_iNodeType(0), m_iTagLimit(0), m_iTotalTagged(0), m_sDescrition(""), m_iSiteID(0)
		{ m_iNodeType = iType, m_iTagLimit = iLimit, m_sDescrition = pDescription/*sDescription*/, m_iSiteID = iSiteID; }

public:
	int	 GetNodeType() { return m_iNodeType; }
	int	 GetTagLimit() { return m_iTagLimit;	}
	int	 GetTotalTagged() { return m_iTotalTagged; }
	int  GetSiteID() { return m_iSiteID; }
	void GetLimitDescription(CTDVString& sDescription) { sDescription = m_sDescrition; }
	bool GetLimitReached() { return m_iTotalTagged >= m_iTagLimit; }
	int  GetRemainingSpace() {return m_iTagLimit - m_iTotalTagged; }
	void AddTagReference() { m_iTotalTagged++; }
	void ResetReferenceCount() { m_iTotalTagged = 0; }
	
private:
	int m_iTagLimit;
	int m_iNodeType;
	int m_iTotalTagged;
	int m_iSiteID;
	CTDVString m_sDescrition;
};

typedef CArray<CTagLimits,CTagLimits&> TagLimitArray;


class CHierarchyNodeDetails
{
public:
	CHierarchyNodeDetails() { m_iNodeID = m_iType = m_iSiteID = 0; }
	CHierarchyNodeDetails(int iNodeID,int iType, int iSiteID,const TCHAR* pName)
	{
		m_iNodeID = iNodeID;
		m_iType = iType;
		m_iSiteID = iSiteID;
		sDisplayName = pName;
	}

	int m_iNodeID;
	int m_iType;
	int m_iSiteID;
	CTDVString sDisplayName;
};


class CTagItem : public CXMLObject  
{
public:
	CTagItem(CInputContext& inputContext);
	virtual ~CTagItem();
	bool InitialiseItem( int iItemID, int iItemType, int iSiteID, CUser* pViewingUser);
	bool InitialiseFromThreadId( int iThreadID, int iSiteID, CUser* pViewingUser, const CTDVString* const psSubject = NULL, bool bGetTagLimits = true);
	bool InitialiseFromUserId( int iUserId, int iSiteID, CUser* pViewingUser);

public:
	bool GetTagLimitInfo(const int iSiteID);
	bool SetTaggingLimitsForItem(CUser* pUser, const int iItemType, const int iNodeType, const int iLimit, const int iSiteID);
	bool GetTagLimitsForItem(int iType);
	
	bool SetTaggingLimitsForThread(CUser* pUser, const int iNodeType, const int iLimit, const int iSiteID);
	bool GetTagLimitsForThread();

	bool SetTaggingLimitsForUser(CUser* pUser, const int iNodeType, const int iLimit, const int iSiteID);
	bool GetTagLimitsForUser();

	bool MovedTagedItemFromSourceToDestinationNode(int iNodeFrom, int iNodeTo);
	bool RemovedTagedItemFromNode(int iNodeID);
	bool AddTagItemToNode(int iNodeID, bool bCheckAuthorisation = true);
	
	void GetItemDetailsXML(CTDVString& sItemDetailsXML) { sItemDetailsXML = m_sItemDetails; }
	
	bool GetAllNodesTaggedForItem(bool bCreateXML = true);
	bool RemoveFromAllNodes(const char* pNodeType = NULL);
	bool GetNodesUserHasTaggedTo();
	bool AddTagItemToMultipleNodes(CDNAIntArray& NodeArray);

protected:
	bool CheckUserIsAuthorised();
	CTDVString GenerateTagNodeXML(int iNodeID, CTDVString& sNodeName, int iNodeType, int iNodeCount);
	bool CheckLimitsForMultipleNodes(CDNAIntArray& NodeArray,CTDVString& sXML);
	int GetRemainingTagSpace(int iType,int iSiteID);
	bool GetMultipleHierarchyNodeDetails(CDNAIntArray& NodeArray,map<int,CHierarchyNodeDetails>* pmNodeDetails);

	bool AddTagItemToNodeInternal(int iNodeID, bool bCheckAuthorisation, CTDVString& sXML);

protected:

	//Typed Article for tagging
	int m_iItemID;
	int m_iItemType;

	//Thread ID/Notice for tagging
	int m_iThreadID;

	//User ID for tagging
	int m_iUserID;
	
	int m_iSiteID;

	CTDVString m_sSubject;
	CTDVString m_sXML;
	CTDVString m_sItemDetails;
	CUser* m_pViewingUser;
	bool m_bIsInitialised;
	TagLimitArray m_Limits;

	map<int,CHierarchyNodeDetails> m_mNodesTaggedToDetails;
};

#endif // !defined(AFX_TAGITEM_H__8D5BD573_35C8_4CE4_B3FB_22F629C2825E__INCLUDED_)
