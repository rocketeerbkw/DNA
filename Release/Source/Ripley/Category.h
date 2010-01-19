// Category.h: interface for the CCategory class.
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


#if !defined(AFX_CATEGORY_H__72E65451_0B0E_11D4_8A52_00104BF83D2F__INCLUDED_)
#define AFX_CATEGORY_H__72E65451_0B0E_11D4_8A52_00104BF83D2F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "threadsearchphrase.h"

class CDNAIntArray;
typedef std::map<int, SEARCHPHRASELIST> ArticleKeyPhrases;

class CCategory : public CXMLObject  
{
public:
	static const int MAX_CLOSE_ROWS;
	static const int SORT_LASTUPDATED;
	static const int MAX_ARTICLE_ROWS;

	//static const int FILTER_ON_THREAD;
	enum CATEGORYTYPEFILTER { NONE, TYPEDARTICLE, THREAD, USER };

public:
	bool GetCategoryAncestry(int iNodeID, CTDVString& sAncestryXML);
	bool GetRelatedClubs(int ih2g2id, CTDVString& sRelatedClubsXML);
	bool GetRelatedArticles(int ih2g2ID, CTDVString& sRelatedNodesXML);
	int Geth2g2ID() const { return m_h2g2ID; }
	int GetNodeID() const { return m_NodeID; }
	int GetiMemberCrumbTrails() const { return m_iMemberCrumbTrails; }
	const char* GetNodeName() const { return m_NodeName; }
	bool GetArticleCrumbTrail(int ih2g2ID);
	bool GetUserCrumbTrail (int iUserID);
	bool GetClubCrumbTrail(int iClubID);
	bool InitialiseViaNodeID(int iNodeID, int iSiteID=1, CATEGORYTYPEFILTER Type = NONE, int iArticleTypeFilter=0, int iShow=0, int iSkip=0);
	bool InitialiseViaH2G2ID(int iH2G2ID, int iSiteID=1);
	
	CCategory(CInputContext& inputContext);
	virtual ~CCategory();

private:
	bool Initialise(int iNodeID,bool bIDIsNodeID, int iSiteID, CATEGORYTYPEFILTER Type = NONE, int iArticleTypeFilter=0, int iShow=0, int iSkip=0);
	bool GetCrumbTrail(CStoredProcedure& SP, CTDVString& sCrumbs);

	int m_h2g2ID;
	int m_NodeID;
	int m_iBaseLine;
	int m_iMemberCrumbTrails;
	CTDVString m_NodeName;

public:
	bool GetSubjectMembersForNodeID(int iNodeID, CTDVString& sXML);
	bool GetArticleMembersForNodeID(int iNodeID, CTDVString& sXML, int* pRows = NULL,  int iType=0, int iShow=MAX_ARTICLE_ROWS, int iSkip=0);
	bool GetClubMembersForNodeID(int iNodeID, CTDVString& sXML, int* pRows = NULL, int iShow=0, int iSkip=0);
	bool GetNoticesForNodeID(int iNodeID, CTDVString& sXML, int iShow = 0, int iSkip = 0 );
	bool GetUsersForNodeID(int iNodeID, CTDVString& sXML, int iShow = 0, int iSkip = 0 );

	bool GetNodeAliasMembersForNodeID(int iNodeID, CTDVString& sXML);
	bool SetSortOrderForNodeMembers(CXMLTree* pTree, const TDVCHAR* sParentTagName);
	bool GetDetailsForNodes(CDNAIntArray& NodeArray, const TCHAR* psTagName = NULL);

protected:
	bool GetHierarchyCloseMembers(CStoredProcedure& SP, int iNodeId, 
		int iMaxRows, CTDVString& sXML);
	void CreateHierarchyDetailsXML(CStoredProcedure& SP, CTDVString& sXML);
	bool AddClubMemberXML(CStoredProcedure& SP, bool bAddStrippedName, CTDVString& sXML, bool& bMovedToNextRec);
	bool AddArticleMemberXML(CStoredProcedure& SP, CTDVString& sXML, ArticleKeyPhrases& articleKeyPhraseMap);
public:
	bool GetHierarchyName( const int iNode, CTDVString& sCategoryName);
};

#endif // !defined(AFX_CATEGORY_H__72E65451_0B0E_11D4_8A52_00104BF83D2F__INCLUDED_)
