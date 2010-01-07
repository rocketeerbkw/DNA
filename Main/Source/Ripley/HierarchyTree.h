// HierarchyTree.h: interface for the CTeam class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_HIERARCHYTREE_H__674B8B9E_F698_4F90_AA14_2767E45FCF7D__INCLUDED_)
#define AFX_HIERARCHYTREE_H__674B8B9E_F698_4F90_AA14_2767E45FCF7D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "TDVAssert.h"
#include "User.h"

class CHierarchyTree : public CXMLObject
{
public:
	CHierarchyTree(CInputContext& inputContext);
	virtual ~CHierarchyTree();

	bool GetHierarchyTree(const int iSiteID, const int iRequestedNode);

protected:
	
	CXMLTree* GenerateHierarchyTree(CStoredProcedure& SP,CMapWordToPtr& XMLTreeList);
	CXMLTree* FindInMap(int iNodeID, const CMapWordToPtr& XMLTreeList);
	CXMLTree* GenerateNode(int iNodeID, int iParentID, const CTDVString& sDisplayName, const int iTypeID);
	bool CreateNewCachePage(int iNodeID, CTDVString& sXML);
	bool CheckAndCreateFromCachedPage(int iNodeID);
};

#endif // !defined(AFX_HIERARCHYTREE_H__674B8B9E_F698_4F90_AA14_2767E45FCF7D__INCLUDED_)

