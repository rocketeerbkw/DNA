// EditCategory.h: interface for the EditCategory class.
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


#if !defined(AFX_EDITCATEGORY_H__3215DF1D_5F40_11D5_877E_00A024998768__INCLUDED_)
#define AFX_EDITCATEGORY_H__3215DF1D_5F40_11D5_877E_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLobject.h"

/** 
 * Class provides functionality for the CEditBuilder.
 * Functionality for adding, removing, deleting tagged articles, clubs etc  from the hierarchy. 
 * There is a degree of overlap with the CTagBuilder class which also performs the above tasks.
 **/
class CEditCategory : public CXMLObject 
{
public:
	CEditCategory(CInputContext& inputContext);
	virtual ~CEditCategory();
	bool Initialise(int iSiteID = 1);
	
	bool DoRenameSubject(int iNodeID,int &iDestinationNodeID,const TDVCHAR* pNewSubjectName);
	bool DoUpdateSynonyms(int iNodeID,const TDVCHAR* sSynonyms, int &iDestinationNodeID);
	bool InitialiseStoredProcedureObject(CStoredProcedure* pSP,const TDVCHAR* pFuncName);
	bool NavigateToSameCategory(int iCurrentNodeID,int &iDestinationNodeID);

	bool DoChangeDescription(int iNodeID,int &iDestinationNodeID,const TDVCHAR* pNewDescription);
	bool DoAddSubject(int iNodeId,int &iNewNodeId,const TDVCHAR* pNewSubject, int &iNewSubjectID);
	bool DoAddAlias(int iAliasID,int iNodeID,int &iDestinationNodeID);
	bool DoUpdateUserAdd(int iNodeID,int iUserAdd,int &iDestinationNodeID);
	bool StoreArticle(int iH2G2ID,int iNodeID,int iOldNodeID,int &iDestinationNodeID);
	bool StoreClub(int iClubID,int iNodeID,int iOldNodeID,int &iDestinationNodeID);
	bool AddNewArticle(int iH2G2ID,int iNodeID,int &iDestinationNodeID);
	bool AddNewClub(int iClubID,int iNodeID,int &iDestinationNodeID,bool &bSuccess);
	bool MoveSubject(int iActiveNode,int iNodeId,int &iNewNodeId);
	bool StoreAlias(int iAliasID,int iNewNodeID,int iOldNodeID, int &iDestinationNodeID);
	bool AddSubject(int iNodeId, int &iNewNodeId);
	bool ChangeDescription(int iNodeId, int &iNewNodeId);
	bool RenameSubject(int iNodeId, int &iNewNodeId);
	
	bool NavigateWithAlias(int iAliasID, int iCurrentNodeID, int iOriginalPosNodeID, int& iDestinationNodeID);
	bool NavigateWithArticle(int iH2G2ID, int iCurrentNodeID, int iOriginalPosNodeID, int& iDestinationNodeID);
	bool NavigateWithClub(int iClubID, int iCurrentNodeID, int iOriginalPosNodeID, int& iDestinationNodeID);
	bool NavigateWithThread(int iThreadID, int iCurrentNodeID,int iOriginalPosNodeID, int& iDestinationNodeID);
	bool NavigateWithUser( int iUserID, int iCurrentNodeID, int iOriginalPOsNodeID, int& iDestinationNodeID);
	bool NavigateWithSubject(int iActiveSubjectID,int iCurrentNodeID,int &iDestinationNodeID);
	
	bool DeleteArticle(int iActiveArticleID, int iNodeID, int &iDestinationNodeID);
	bool DeleteClub(int iActiveClubID, int iNodeID, int &iDestinationNodeID);
	bool DeleteSubject(int iActiveSubjectID, int iNodeID, int &iDestinationNodeID);
	bool DeleteAlias(int iAliasID, int iNodeID, int &iDestinationNodeID);

protected:
	CTDVString GenerateResultXML(bool bSuccess,const TDVCHAR* pReason);

	int m_iSiteID;

};

#endif // !defined(AFX_EDITCATEGORY_H__3215DF1D_5F40_11D5_877E_00A024998768__INCLUDED_)
