// HierarchyTree.cpp: implementation of the CHierarchyTree class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "HierarchyTree.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CHierarchyTree::CHierarchyTree(CInputContext& inputContext)
:
CXMLObject(inputContext)
{

}

CHierarchyTree::~CHierarchyTree()
{
}


/*********************************************************************************

	bool CHierarchyTree::GetHierarchyTree(const int iSiteID, const int iRequestedNode)

	Author:		Nick Stevenson
	Created:	18/09/2003
	Inputs:		iSiteID -the site id
				iRequestedNode = the id of the node defining the subtree required
	Outputs:	-
	Returns:	true|false
	Purpose:	Generates an XML Tree expressing the taxonomy data set for the
				given node id, belonging to iSiteID. 
				Returns true is success. 

*********************************************************************************/

bool CHierarchyTree::GetHierarchyTree(const int iSiteID, const int iRequestedNode)
{
	if(iRequestedNode <= 0 || iSiteID <= 0)
	{
		//bad value. RequestedNode must have a value greater than zero
		//iRequestedNode = 0;
		SetDNALastError("HierarchyTree","Incorrect Param","RequestedNode param must have a value greater than zero");
		return false;
	}

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetHierarchyByTreeLevelAndParent(iSiteID))
	{
		SetDNALastError("HierarchyTree","Database","An Error Occurred while accessing the database");
		return false;
	}

	// Check the cache first
	if( CheckAndCreateFromCachedPage(iRequestedNode) )
	{
		return true;
	}

	// Calculate an estimate of the buffer size required to hold the XML version of the hierarchy 
	int nPreCacheSize = SP.GetIntField("count")*256;

	bool bOK = false;

	CMapWordToPtr XMLTreeMap;
	CXMLTree* pHierarchyTree = GenerateHierarchyTree(SP,XMLTreeMap);

	if (pHierarchyTree != NULL)
	{
		CXMLTree* pNode = FindInMap(iRequestedNode,XMLTreeMap);

		if (pNode != NULL)
		{
			// Create a string big enough for the hierarchy.  This improves the performance greatly
			CTDVString sCacheContent;
			sCacheContent.EnsureAvailable(nPreCacheSize);

			// Create the cache page for this node
			sCacheContent << "<HIERARCHY>";
			pNode->OutputXMLTree(sCacheContent);
			sCacheContent << "</HIERARCHY>";
			CreateNewCachePage(iRequestedNode,sCacheContent);

			// Move the portion of the tree we require from the one generated by GenerateHierarchyTree
			// into this object's tree
			CreateFromXMLText("<HIERARCHY/>");
			CXMLTree* pInsertNode = m_pTree->FindFirstTagName("HIERARCHY");
			pNode->DetachNodeTree();
			pInsertNode->AddChild(pNode);

			bOK = true;
		}

		// Delete the remaining parts of the tree
		delete pHierarchyTree;
		pHierarchyTree = NULL;
	}

	return bOK;
}


/*********************************************************************************

	CXMLTree* CHierarchyTree::GenerateHierarchyTree(CStoredProcedure& SP,CMapWordToPtr& XMLTreeMap)

	Author:		Nick Stevenson
	Created:	03/10/2003
	Inputs:		SP = stored proc object containing the hierarchy node record set
					 in ascending TreeLevel order
	Outputs:	XMLTreeMap - a map of pointers to all nodes added thus far
	Returns:	Ptr to the root of the CXMLTree
	Purpose:	This builds a CXMLTree of all the hierarchy nodes in the record set defined by SP.
				Each node is added to XMLTreeMap, keyed in NodeID, for speedy referencing
				The root of the tree is returned

				NOTE: If it finds a node that references a parent that doesn't exist, it is skipped,
				      as the node is not a descendant of root node.

*********************************************************************************/

CXMLTree* CHierarchyTree::GenerateHierarchyTree(CStoredProcedure& SP,CMapWordToPtr& XMLTreeMap)
{
	XMLTreeMap.RemoveAll();
	CXMLTree* pRoot = NULL;

	while (!SP.IsEOF())
	{
		int iNodeID			= SP.GetIntField("NodeID");
		int iNodeParentID	= SP.GetIntField("ParentID");
		int iTypeID			= SP.GetIntField("Type");
  		CTDVString sDisplayName;
		SP.GetField("DisplayName", sDisplayName);
		EscapeXMLText(&sDisplayName);

		if (XMLTreeMap.IsEmpty())
		{
			// The map is empty, so this is the first node in the list, therefore it's the root
			pRoot = GenerateNode(iNodeID, iNodeParentID, sDisplayName, iTypeID);
			XMLTreeMap.SetAt(iNodeID,pRoot);
		}
		else
		{
			// The parent should be present in the map
			CXMLTree* pParent = FindInMap(iNodeParentID,XMLTreeMap);

			if (pParent != NULL)
			{
				CXMLTree* pNode = GenerateNode(iNodeID, iNodeParentID, sDisplayName, iTypeID);
				XMLTreeMap.SetAt(iNodeID,pNode);
				pParent->AddChild(pNode);
			}
			else
			{
				// In this case the node has a parent that's missing, therefore is not a
				// descendant of the root.
				CTDVString sMess;
				sMess << "Hierarchy node not linked to root: ID=" << iNodeID << ", ID of missing parent=" << iNodeParentID;
				TDVASSERT(false,sMess);
			}
		}

		SP.MoveNext();
	}

	return pRoot;
}

/*********************************************************************************

	CXMLTree* CHierarchyTree::FindInMap(int iNodeID, const CMapWordToPtr& XMLTreeMap)

	Author:		Nick Stevenson
	Created:	03/10/2003
	Inputs:		iNodeID -the id of the node required
	Outputs:	XMLTreeMap -reference to list of parent nodes in the xml tree
	Returns:	XMLTree expressing the node with the given node id
	Purpose:	Scans the list of XMLTree nodes seeking a node with the given id.
				if exists, node is returned, else NULL

*********************************************************************************/

CXMLTree* CHierarchyTree::FindInMap(int iNodeID, const CMapWordToPtr& XMLTreeMap)
{
	void* pNode = NULL;

	if (XMLTreeMap.Lookup(iNodeID,pNode))
	{
		return (CXMLTree*)pNode;
	}
	
	return NULL;
}


/*********************************************************************************

	CXMLTree* CHierarchyTree::GenerateNode(int iNodeID, int iParentID, const CTDVString& sDisplayName, const int iTypeID)

	Author:		Nick Stevenson
	Created:	03/10/2003
	Inputs:		iNodeID		-node id 
				iParentID	-parent id of node
				sDisplayName -name of the node
	Outputs:	-
	Returns:	XMLTree		-Node expressed as XMLTree
	Purpose:	Constructs string expressing node data in XML format and parses it
				into an CXMLTree which is returned.

*********************************************************************************/

CXMLTree* CHierarchyTree::GenerateNode(int iNodeID, int iParentID, const CTDVString& sDisplayName, const int iTypeID)
{
	CTDVString sNodeXML;

	sNodeXML << "<NODE ID='" << iNodeID << "' PARENTID='" << iParentID << "'";
	sNodeXML << "TYPE='" << iTypeID << "'>";
	sNodeXML << "<NAME>" << sDisplayName << "</NAME>";
	sNodeXML << "</NODE>";

	return CXMLTree::ParseForInsert(sNodeXML);
}


/*********************************************************************************

	bool CHierarchyTree::CreateNewCachePage(CXMLTree* pNode)

	Author:		Nick Stevenson
	Created:	08/10/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CHierarchyTree::CreateNewCachePage(int iNodeID,CTDVString& sXML)
{
    CTDVString sCacheName = "HT";

    sCacheName << iNodeID << ".txt";

    CachePutItem("HierarchyTree", sCacheName, sXML);

    return true;
}

/*********************************************************************************

	bool CHierarchyTree::CheckAndCreateFromCachedPage(int iNodeID)

	Author:		Nick Stevenson
	Created:	08/10/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CHierarchyTree::CheckAndCreateFromCachedPage(int iNodeID)
{
	// Check to see if we can use the cache!
	CTDVString sCacheName = "HT";
	sCacheName << iNodeID << ".txt";

	CTDVDateTime dLastDate;
	CTDVString sCacheContent;
	CStoredProcedure SP;
	
	m_InputContext.InitialiseStoredProcedureObject(&SP);


	SP.CacheGetHierarchyMostRecentUpdateTime(&dLastDate);

	bool bGotCache = false;

	bGotCache = CacheGetItem("HierarchyTree", sCacheName, &dLastDate, &sCacheContent);   //!!!!!!!!!!                             

	if (bGotCache)
	{
		bGotCache = CreateFromXMLText(sCacheContent);

		TDVASSERT(bGotCache,"CHierarchyTree::Failed to Create XML From text!");
	}

	return bGotCache;
}
