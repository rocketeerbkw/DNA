// TagItem.cpp: implementation of the CTagItem class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "TagItem.h"
#include "StoredProcedure.h"
#include "Category.h"
#include "GuideEntry.h"
#include "TDVAssert.h"
#include "Club.h"
#include ".\tagitem.h"
#include "EventQueue.h"
#include "Forum.h"

#include <set>

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CTagItem::CTagItem(CInputContext& inputContext):
CXMLObject(inputContext), m_iItemID(0), m_iItemType(0), m_iThreadID(0), m_iUserID(0),
m_pViewingUser(NULL), m_bIsInitialised(true), m_iSiteID(0)
{
}

CTagItem::~CTagItem()
{
}

bool CTagItem::InitialiseFromThreadId( int iThreadID, int iSiteID, CUser* pViewingUser, const CTDVString* const psSubject, bool bGetTagLimits)
{
	// First things first make sure things are clean!
	m_iItemID = 0;
	m_iItemType = 0;
	m_iThreadID = 0;
	m_iUserID = 0;
	m_sSubject.Empty();
	m_pViewingUser = NULL;
	m_sXML.Empty();
	m_bIsInitialised = false;
	m_Limits.RemoveAll();
	m_mNodesTaggedToDetails.clear();

	// Now set the member variables
	m_iThreadID = iThreadID;
	m_pViewingUser = pViewingUser;
	m_iSiteID = iSiteID;

	// Check to see if we've been given the threads subject, if not try to obtain it from the database
	if (psSubject == NULL)
	{
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(SP);
		if ( !SP.GetThreadDetails(m_iThreadID) )
		{
			return SetDNALastError("CTagItem::InitialiseFromThreadId","FailedToGetPostDetails","Failed to get Post details!");
		}
		
		if ( !SP.IsEOF() )
		{
			SP.GetField("FirstSubject", m_sSubject);
		}
	}
	else
	{
		// Put the passed in subject into the member subject
		m_sSubject = *psSubject;
	}

	// Make sure the subject is escaped correctly
	EscapeEverything(&m_sSubject);

	// Now add the item details into the objects xml
	m_sItemDetails << "<ITEM ID='" << m_iThreadID << "' TYPE='" << "THREAD" << "' SUBJECT='" << m_sSubject << "'/>";
	
	// Set the m_bIsInitialised flag to true as we are!
	m_bIsInitialised = true;

	// Get the tag limmit information if required
	if (bGetTagLimits)
	{
        // Get the site limits for this item type
		GetTagLimitsForThread();
	}
	
	// Return ok
	return true;
}

bool CTagItem::InitialiseFromUserId( int iUserID, int iSiteID, CUser* pViewingUser )
{
	// First things first make sure things are clean!
	m_iItemID = 0;
	m_iItemType = 0;
	m_iThreadID = 0;
	m_sSubject.Empty();
	m_pViewingUser = NULL;
	m_sXML.Empty();
	m_bIsInitialised = false;
	m_Limits.RemoveAll();
	m_mNodesTaggedToDetails.clear();

	// Now set the member variables
	m_iUserID = iUserID;
	m_pViewingUser = pViewingUser;
	m_iSiteID = iSiteID;

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);;
	if ( !SP.GetUserDetailsFromID(iUserID, iSiteID ) )
	{
		return SetDNALastError("CTagItem","FailedToGetUserDetails","Failed to get User details!");
	}
	if ( !SP.IsEOF() )
	{
		SP.GetField("Username",m_sSubject);
	}

	// Make sure the subject is escaped correctly
	EscapeEverything(&m_sSubject);

	// Now add the item details into the objects xml
	m_sItemDetails << "<ITEM ID='" << m_iUserID << "' TYPE='" << "USER" << "' SUBJECT='" << m_sSubject << "'/>";
	
	// Set the m_bIsInitialised flag to true as we are!
	m_bIsInitialised = true;

	// Get the site limits for this item type
	GetTagLimitsForUser();
	
	// Return ok
	return true;
}

bool CTagItem::InitialiseItem( int iItemID, int iItemType, int iSiteID, CUser* pViewingUser )
{
	// First things first make sure things are clean!
	m_iThreadID = 0;
	m_iUserID = 0;
	m_iItemID = 0;
	m_iItemType = 0;
	m_sSubject.Empty();
	m_pViewingUser = NULL;
	m_sXML.Empty();
	m_bIsInitialised = false;
	m_Limits.RemoveAll();
	m_mNodesTaggedToDetails.clear();

	// Check to make sure we've been given valid params
	if (iItemType == 0)
	{
		return SetDNALastError("CTagItem","NoTypeIDGiven","No type given for item!");
	}
	else if (iItemID == 0)
	{
		return SetDNALastError("CTagItem","NoItemIDGiven","No ID given for item!");
	}

	// Now set the member variables
	m_iItemID = iItemID;
	m_iItemType = iItemType;
	m_pViewingUser = pViewingUser;
	m_iSiteID = iSiteID;

	// Put the items detail into the XML
	if (CGuideEntry::IsTypeOfUserPage(m_iItemType) && pViewingUser != NULL)
	{
		// We're a users page, so just get the user name
		pViewingUser->GetUsername(m_sSubject);
	}
	else if (CGuideEntry::IsTypeOfClub(m_iItemType))
	{
		// We're a club, get the clubs subject
		CClub Club(m_InputContext);
		if (!Club.InitialiseViaClubID(m_iItemID))
		{
			return SetDNALastError("CTagItem","FailedToGetClubDetails","Failed to get club details!");
		}
		Club.GetName(m_sSubject);
	}
	else if (CGuideEntry::IsTypeOfArticle(m_iItemType))
	{
		// We're an article, find it's subject
		CGuideEntry Guide(m_InputContext);
		if (!Guide.Initialise(m_iItemID,m_iSiteID))
		{
			return SetDNALastError("CTagItem","FailedToGetArticleDetails","Failed to get Article details!");
		}
		Guide.GetSubject(m_sSubject);
	}
	else
	{
		return SetDNALastError("CTagItem","InvalidTypeGiven","Don't know what type we're trying to initialise!");
	}
	
	// Make sure the subject is escaped correctly
	EscapeEverything(&m_sSubject);

	// Now add the item details into the objects xml
	m_sItemDetails << "<ITEM ID='" << m_iItemID << "' TYPE='" << m_iItemType << "' SUBJECT='" << m_sSubject << "'/>";
	
	// Set the m_bIsInitialised flag to true as we are!
	m_bIsInitialised = true;

	// Get the site limits for this item type
	GetTagLimitsForItem(m_iItemType);
	
	// Return ok
	return true;
}

/*********************************************************************************

	bool CTagItem::GetAllNodesTaggedForItem(int iItemID, int iTypeID, bool bCreateXML)

	Author:		Mark Howitt
	Created:	16/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CTagItem::GetAllNodesTaggedForItem(bool bCreateXML)
{
	// Check to make sure we're initialised before calling this function!
	if (!m_bIsInitialised)
	{
		return SetDNALastError("CTagItem","ObjectNotInitialised","Call InitialiseItem before calling this function!");
	}

	// Create the Base object to insert the info into
	if (bCreateXML && (!Destroy() || !CreateFromCacheText("<TAGGEDNODES></TAGGEDNODES>")))
	{
		return SetDNALastError("CTagItem","FailedToCreateTree","Failed to create tagitem Tree");
	}

	// Setup the StroedProcedure object
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	CTDVString sTagItem, sNodeName, sTypeCount;

	// Reset the reference count for the limits.
	for (int i = 0; i < m_Limits.GetSize(); i++)
	{
		m_Limits[i].ResetReferenceCount();
	}
	
	if ( m_iThreadID > 0 ) 
	{
		//Get Nodes Thread is already tagged to.
		if ( !SP.GetAllNodesThatNoticeBoardPostBelongsTo(m_iThreadID) )
			return SetDNALastError("CTagItem","FailedToFindNodes","Failed finding tagged nodes for thread.");
	}
	else if ( m_iUserID > 0 )
	{
		//Get Nodes User is tagged to.
		if ( !SP.GetAllNodesThatUserBelongsTo( m_iUserID ) )
			return SetDNALastError("CTagItem","FailedToFindNodes","Failed finding tagged nodes for user.");
	}
	else if ( !SP.GetAllNodesThatItemBelongsTo(m_iItemID,m_iItemType) )
	{
		//Get Nodes Typed Article is already tagged to.
		return SetDNALastError("CTagItem","FailedToFindNodes","Failed finding tagged nodes");
	}

	// Zip through the results
	m_mNodesTaggedToDetails.clear();
	while (!SP.IsEOF())
	{
		// Get the nodes details
		int iNodeID = SP.GetIntField("NodeID");
		int iNodeType = SP.GetIntField("Type");
		int iSiteID = SP.GetIntField("SiteID");
		SP.GetField("DisplayName",sNodeName);
		int iNodeCount =  SP.GetIntField("NodeMembers");
		CXMLObject::EscapeEverything(&sNodeName);

		m_mNodesTaggedToDetails[iNodeID] = CHierarchyNodeDetails(iNodeID,iNodeType,iSiteID,sNodeName);

		// Check for validity
		if (bCreateXML)
		{
			sTagItem << GenerateTagNodeXML(iNodeID,sNodeName,iNodeType, iNodeCount);
			AddInside("TAGGEDNODES",sTagItem);
		}

		// Update the limits
		for (int i = 0; i < m_Limits.GetSize(); i++)
		{
			if (m_Limits[i].GetNodeType() == iNodeType && m_Limits[i].GetSiteID() == iSiteID)
			{
				m_Limits[i].AddTagReference();
			}
		}

		// Get the next result
		SP.MoveNext();
		sTagItem.Empty();
	}

	// Put the limit info into the XML if any
	if (bCreateXML && m_Limits.GetSize() > 0)
	{
		AddInside("TAGGEDNODES","<TAGLIMITS></TAGLIMITS>");
		CTDVString sTagLimits;
		CTDVString sDescription;
		for (int i = 0; i < m_Limits.GetSize(); i++)
		{
			if (m_Limits[i].GetSiteID() == m_iSiteID)
			{
				sTagLimits = "<ITEMLIMIT ";
				sTagLimits << "NODETYPE='" << m_Limits[i].GetNodeType() << "' ";
				if (m_Limits[i].GetTagLimit() >= 0)
				{
					sTagLimits << "LIMIT='" << m_Limits[i].GetTagLimit() << "' ";
				}
				sTagLimits << "COUNT='" << m_Limits[i].GetTotalTagged() << "'/>";
				AddInside("TAGLIMITS",sTagLimits);
			}
		}
	}

	// return ok
	return true;
}

/*********************************************************************************

	bool CTagItem::GetNodesUserHasTaggedTo()

		Author:		Mark Neves
        Created:	16/11/2004
        Inputs:		-
        Outputs:	-
        Returns:	true if OK, false otherwise
        Purpose:	Creates a <USERTAGGEDNODES> XML structure the encapsulates all the nodes
					the user has ever tagged content to.

*********************************************************************************/

bool CTagItem::GetNodesUserHasTaggedTo()
{
	if (m_pViewingUser == NULL)
	{
		// If no viewing user, just return without doing anything
		return true;
	}

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// Get all the nodes
	if (!SP.GetUserHierarchyNodes(m_pViewingUser->GetUserID(),m_iSiteID))
	{
		return SetDNALastError("CTagItem","FailedToFindNodes","Failed finding tagged nodes");
	}

	// Zip through the results
	CTDVString sUserTaggedNodesXML = "<USERTAGGEDNODES>";
	while (!SP.IsEOF())
	{
		CTDVString sNodeName;

		// Get the nodes details
		int iNodeID = SP.GetIntField("NodeID");
		int iNodeType = SP.GetIntField("Type");
		SP.GetField("DisplayName",sNodeName);
		int iNodeCount =  SP.GetIntField("NodeMembers");
		CXMLObject::EscapeEverything(&sNodeName);

		sUserTaggedNodesXML << GenerateTagNodeXML(iNodeID,sNodeName,iNodeType, iNodeCount);

		// Get the next result
		SP.MoveNext();
	}
	sUserTaggedNodesXML << "</USERTAGGEDNODES>";

	if ((!Destroy() || !CreateFromCacheText(sUserTaggedNodesXML)))
	{
		return SetDNALastError("CTagItem","FailedToCreateTree","Failed to create tagitem Tree");
	}

	return true;
}

/*********************************************************************************

	CTDVString CTagItem::GenerateTagNodeXML(int iNodeID, CTDVString& sNodeName, int iNodeType,  int iNodeCount)

		Author:		Mark Neves
        Created:	16/11/2004
        Inputs:		Some node details
        Outputs:	-
        Returns:	The XML for the given node details
        Purpose:	Centralises the generation of the XML for a NODE tag.

*********************************************************************************/

CTDVString CTagItem::GenerateTagNodeXML(int iNodeID, CTDVString& sNodeName, int iNodeType, int iNodeCount)
{
	CTDVString sTagItem;
	if (iNodeID > 0)
	{
		sTagItem << "<NODE ID='" << iNodeID << "' NAME='" << sNodeName << "' TYPE='" << iNodeType << "' NODECOUNT='" << iNodeCount<< "'>";
		CTDVString sCat;
		CCategory Cat(m_InputContext);
		if (Cat.GetCategoryAncestry(iNodeID,sCat))
		{
			sTagItem << sCat;
		}
		sTagItem << "</NODE>";
	}
	return sTagItem;
}

/*********************************************************************************

	bool CTagItem::CheckUserIsAuthorised()

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		-
	Outputs:	-
	Returns:	true if the user is authorised, false if not or something goes wron!
	Purpose:	Checks to make sure the user is authorised to do actions on
				the given item.

*********************************************************************************/
bool CTagItem::CheckUserIsAuthorised()
{
	// Check to make sure we have a valid user!
	if (m_pViewingUser == NULL)
	{
		return false;
	}

	// Check to see if the user is an editor or super user
	bool bIsAuthorised = m_pViewingUser->GetIsEditor();

	// If they're not, then check to see if they are the author or editor of the item.
	if (!bIsAuthorised)
	{
		if ( m_iItemType > 0 && m_iItemID > 0 )
		{
			// Check the database to see if the user is authorised to do actions on this item
			CStoredProcedure SP;
			m_InputContext.InitialiseStoredProcedureObject(&SP);
			if (CGuideEntry::IsTypeOfUserPage(m_iItemType))
			{
				if (!SP.GetUserDetailsFromID(m_pViewingUser->GetUserID(),m_iSiteID))
				{
					return SetDNALastError("CTagItem::CheckUserIsAuthorised","FailedToCheckUserAuthorisation","Failed Checking User Authorisation!");
				}

				// Get the result and return
				bIsAuthorised = (SP.GetIntField("MastHead") == m_iItemID);
			}
			else
			{
				if (!SP.IsUserAuthorisedForItem(m_iItemType,m_iItemID,m_pViewingUser->GetUserID()))
				{
					return SetDNALastError("CTagItem::CheckUserIsAuthorised","FailedToCheckUserAuthorisation","Failed Checking User Authorisation!");
				}
				// Get the result and return
				bIsAuthorised = !SP.IsEOF();
			}
		}
		else if ( m_iThreadID > 0 )
		{
			//Find out if user created thread.
			CStoredProcedure SP;
			m_InputContext.InitialiseStoredProcedureObject(&SP);
			if ( !SP.IsUserAuthorisedForThread(m_iThreadID, m_pViewingUser->GetUserID(), bIsAuthorised) )
			{
				return SetDNALastError("CTagItem::CheckUserIsAuthorised","FailedToCheckUserAuthorisation","Failed Checking User Authorisation!");
			}
		}
		else if ( m_iUserID > 0 )
		{
			//User is authorised to tag themselves.
			bIsAuthorised = (m_iUserID == m_pViewingUser->GetUserID());
		}
		else
		{
			return SetDNALastError("CTagItem::CheckUserIsAuthorised","FailedToCheckUserAuthorisation","Failed Checking User Authorisation!");
		}
	}

	return bIsAuthorised;
}

/*********************************************************************************

	bool CTagItem::AddTagItemToNodeInternal(int iNodeID, bool bRaiseDuplicateError, bool bCheckAuthorisation, CTDVString& sXML)
	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		iNodeID - The Node you want to add to
				bCheckAuthorisation - check user is allowed to do this
	Outputs:	sResult - A string to take the result XML.
	Returns:	true if everything went ok, false if not
	Purpose:	Added the give item to the requested node

*********************************************************************************/

bool CTagItem::AddTagItemToNodeInternal(int iNodeID, bool bCheckAuthorisation, CTDVString& sXML)
{
	// Check to make sure we're initialised before calling this function!
	if (!m_bIsInitialised)
	{
		return SetDNALastError("CTagItem","ObjectNotInitialised","Call InitialiseItem before calling this function!");
	}

	// Make sure the current user is allowed to do this action if we are asked to!
	if (bCheckAuthorisation)
	{
		if (!CheckUserIsAuthorised()) 
		{
			SetDNALastError("CTagItem::AddTagItemToNodeInternal","User not Authorised","User not Authorised.");
			return false;
		}
	}

	// Check to see if the item already exists
	CTDVString sTemp;
	CTDVString sNodeName;
	CTDVString sObjectName;
	bool bAlreadyExists = false;
	bool bOk = true;

	// Setup a stored procedure object
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// Check to see if the limit has been reached for tagging
	int iNodeType = 0;
	int iSiteID = 0;
	if (!SP.GetHierarchyNodeDetailsViaNodeID(iNodeID,NULL,NULL,NULL,NULL,NULL,NULL,NULL,&iNodeType,&iSiteID))
	{
		return SetDNALastError("CTagItem","FailedToGetNodeDetails","Failed to get node details!");
	}

	// Check the limit for this node type
	for (int i = 0; i < m_Limits.GetSize(); i++)
	{
		// If we find a match and the limit is reached, return now!
		if (m_Limits[i].GetNodeType() == iNodeType && m_Limits[i].GetSiteID() == iSiteID && m_Limits[i].GetLimitReached())
		{
			sXML << "<ACTION RESULT='AddFailed' REASON='TaggingLimitReached' NODE='" << iNodeID << "'/>";
			return true;
		}
	}

	// Try and add the item to the node.
	bool bSuccess = false;
	
	int iViewingUserID  = m_pViewingUser->GetUserID();
	if ( CGuideEntry::IsTypeOfClub(m_iItemType) )
	{
		bOk = SP.AddClubToHierarchy(iNodeID, m_iItemID, iViewingUserID, bSuccess);
	}
	else if (CGuideEntry::IsTypeOfArticle(m_iItemType) || CGuideEntry::IsTypeOfUserPage(m_iItemType))
	{
		//Tag Article to node.
		bOk = SP.AddArticleToHierarchy(iNodeID,m_iItemID, iViewingUserID, bSuccess);
	}
	else if ( m_iThreadID > 0  )
	{
		//Add A NoticeBoard Post to the Hierarchy - currently the only forum type that can be tagged to a node
		bOk = SP.AddThreadToHierarchy(iNodeID, m_iThreadID,  iViewingUserID, bSuccess);
	}
	else if ( m_iUserID > 0 )
	{
		//Tag a user to the hierarchy.
		bOk = SP.AddUserToHierarchy(iNodeID, m_iUserID,  iViewingUserID, bSuccess);
	}
	else
	{
		sTemp = "AddFailed REASON=UnknownTypeID";
		bOk = false;
	}


	//Build up a string specifying status of operation.
	if ( bOk )
	{
		SP.GetField("ObjectName",sObjectName);
		SP.GetField("NodeName",sNodeName);
		if ( bSuccess )
		{
			sTemp = "AddSucceeded' REASON='None";
		}
		else
		{
			//Unable to add - could be due to duplicate - raise as error only if requested.
			if ( SP.GetIntField("Duplicate") )
			{
					sTemp = "AddFailed' REASON='ItemAlreadyExists";
			}
			else
			{
				sTemp = "AddFailed' REASON='FailedGettingParentInfo";
			}
		}
	}
	else
	{
		//Error condition
		sTemp << "AddFailed' REASON='FailedGettingParentInfo";
	}

	// Make sure the result strings are escaped properly
	CXMLObject::EscapeEverything(&sObjectName);
	CXMLObject::EscapeEverything(&sNodeName);
	sXML << "<ACTION RESULT='" << sTemp << "' NODE='" << iNodeID << "' NODENAME='" << sNodeName << "' OBJECTNAME='" << sObjectName << "'/>";

	return bOk;
}

/*********************************************************************************

	bool CTagItem::AddTagItemToNode(int iNodeID, bool bFailIfAlreadyExists, bool bCheckAuthorisation)

		Author:		Mark Neves
        Created:	10/12/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	See AddTagItemToNodeInternal() for details

					This just does a CreateFromXMLText() at the end.

*********************************************************************************/

bool CTagItem::AddTagItemToNode(int iNodeID, bool bCheckAuthorisation)
{
	CTDVString sXML;
	bool bOk = AddTagItemToNodeInternal(iNodeID, bCheckAuthorisation,sXML);

	// Create and return the verdict!
	m_sXML = sXML;
	Destroy();
	CreateFromXMLText(m_sXML);
	return bOk;
}

/*********************************************************************************

	bool CTagItem::RemovedTagedItemFromNode(int iItemID, int iTypeID, int iNodeID,
						CTDVString& sResult)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		iItemID - The items ID to remove
				iTypeID - The type of item you're removing
				iNodeID - The Node you want to remove from
	Outputs:	sResult - A string to take the result XML.
	Returns:	true if everything went ok, false if not
	Purpose:	Removes the given item from the requested node.

*********************************************************************************/

bool CTagItem::RemovedTagedItemFromNode(int iNodeID)
{
	// Check to make sure we're initialised before calling this function!
	if (!m_bIsInitialised)
	{
		SetDNALastError("CTagItem","ObjectNotInitialised","Call InitialiseItem before calling this function!");
		return false;
	}

	if (!CheckUserIsAuthorised())
	{
		return false;
	}

	// Check to see if the item already exists
	CTDVString sObjectName;
	CTDVString sNodeName;
	CTDVString sTemp;
	bool bOk = true;
	bool bAlreadyExists = false;

	// Now call the storedprocedure to remove the tag
	bool bSuccess = false;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// Make sure we call the correct stored procedure for the item type.
	if ( m_iThreadID )
	{
		bOk = SP.DeleteThreadFromHierarchy(m_iThreadID,iNodeID,bSuccess);
		if ( !bOk || !bSuccess )
		{
			sTemp << "RemoveFailed' REASON='FailedToRemoveFromNode";
		}
	}
	else if ( m_iUserID )
	{
		bOk = SP.DeleteUserFromHierarchy(m_iUserID,iNodeID,bSuccess);
		if ( !bOk || !bSuccess )
		{
			sTemp << "RemoveFailed' REASON='FailedToRemoveFromNode";
		}
	}
	else if (CGuideEntry::IsTypeOfClub(m_iItemType))
	{
		bOk = SP.DeleteClubFromHierarchy(m_iItemID,iNodeID,bSuccess);
		if ( !bOk || !bSuccess )
		{
			sTemp << "RemoveFailed' REASON='FailedToRemoveFromNode";
		}
	}
	else if (CGuideEntry::IsTypeOfArticle(m_iItemType) || CGuideEntry::IsTypeOfUserPage(m_iItemType))
	{
		bOk = SP.DeleteArticleFromHierarchy(m_iItemID,iNodeID,bSuccess);
		if ( !bOk || !bSuccess )
		{
			sTemp << "RemoveFailed' REASON='FailedToRemoveFromNode";
		}
	}
	else
	{
		sTemp << "RemoveFailed' REASON='UnknownTypeID";
		bOk = false;
	}

	// If everything went ok, get the names from the results.
	if (bOk)
	{
		SP.GetField("NodeName",sNodeName);
		SP.GetField("ObjectName",sObjectName);
	}

	if ( bOk && bSuccess )
	{
		sTemp << "RemoveSucceeded' REASON='None";
	}

	// Make sure the strings are escaped properly
	CXMLObject::EscapeEverything(&sObjectName);
	CXMLObject::EscapeEverything(&sNodeName);
	m_sXML << "<ACTION RESULT='" << sTemp << "' NODE='" << iNodeID << "' NODENAME='" << sNodeName << "' OBJECTNAME='" << sObjectName << "'/>";

	// Create and return the verdict!
	Destroy();
	CreateFromXMLText(m_sXML);
	return bOk;
}


/*********************************************************************************
bool CTagItem::RemoveFromAllNodes(const char* pNodeType)

Author:		Igor Loboda
Created:	14/05/2003
Inputs:		pNodeType - type of a node (like "Location", see hierarchynodetypes table
Returns:	true if everything went ok, false if not
Purpose:	Removes the item from all the nodes of a given type
			Creates XML indicating the nodes removed.
*********************************************************************************/

bool CTagItem::RemoveFromAllNodes(const char* pNodeType)
{
	CTDVString sXML;

	// Check to make sure we're initialised before calling this function!
	if (!m_bIsInitialised)
	{
		SetDNALastError("CTagItem", "ObjectNotInitialised", 
			"Call InitialiseItem before calling this function!");
		return false;
	}

	//if (!pNodeType)
//	{
//		SetDNALastError("CTagItem::RemoveFromAllNodes", "NotImplemented", 
//			"Not implemented for given node type.");
//		return false;
//	}

	if (!CheckUserIsAuthorised())
	{
		return false;
	}

	CStoredProcedure sp;
	if (CGuideEntry::IsTypeOfArticle(m_iItemType) || CGuideEntry::IsTypeOfUserPage(m_iItemType))
	{
		m_InputContext.InitialiseStoredProcedureObject(&sp);
 		if ( !sp.DeleteArticleFromAllNodes(m_iItemID, m_iSiteID, pNodeType) )
		{
			SetDNALastError("TagItem::RemoveFromAllNodes","RemoveFromAllNodes","Failed to remove article from hierarchy");
		}
	}
	else if ( CGuideEntry::IsTypeOfClub( m_iItemType ) )
	{
		m_InputContext.InitialiseStoredProcedureObject(&sp);
 		if ( !sp.DeleteClubFromAllNodes(m_iItemID, m_iSiteID ) )
		{
			SetDNALastError("TagItem::RemoveFromAllNodes","RemoveFromAllNodes","Failed to remove article from hierarchy");
		}
	}
	else if ( m_iThreadID > 0 )
	{
		m_InputContext.InitialiseStoredProcedureObject(&sp);
		if ( !sp.DeleteThreadFromAllNodes(m_iThreadID, m_iSiteID ) )
		{
			SetDNALastError("TagItem::RemoveFromAllNodes","RemoveFromAllNodes","Failed to remove article from hierarchy");
		}
	}
	else if(m_iUserID > 0)
	{
		m_InputContext.InitialiseStoredProcedureObject(&sp);
 		if ( !sp.DeleteUserFromAllNodes(m_iUserID, m_iSiteID, pNodeType) )
		{
			SetDNALastError("TagItem::RemoveFromAllNodes","RemoveFromAllNodes","Failed to remove article from hierarchy");
		}
	}
	else
	{
		TDVASSERT(false, "not implemented");
		SetDNALastError("CTagItem", "NotImplemented", "not implemented for this entry type");
	}

	if ( ErrorReported() )
	{
		sXML << "<ACTION RESULT='RemoveFromAllNodesFailed' REASON='FailedToRemoveAllNodes'/>";
		CreateFromXMLText(m_sXML);
		return false;
	}

	CTDVString sNodeName;
	CTDVString sObjectName;
	sXML = "<REMOVEFROMALLNODES>";
	sXML << "<RESULTS>";
	while ( !sp.IsEOF() )
	{
		sp.GetField("ObjectName", sObjectName);
		sp.GetField("NodeName", sNodeName);

		// Make sure the strings are escaped properly
		CXMLObject::EscapeEverything(&sObjectName);
		CXMLObject::EscapeEverything(&sNodeName);
		sXML << "<ACTION RESULT='RemoveFromAllNodesSucceeded' REASON='None' NODENAME='" << sNodeName << "' OBJECTNAME='" << sObjectName << "'/>";
		sp.MoveNext();
	}
	sXML << "</RESULTS></REMOVEFROMALLNODES>";
	CreateFromXMLText(sXML);
	return true;
}


/*********************************************************************************

	bool CTagItem::MovedTagedItemFromSourceToDestinationNode(int iNodeFrom, int iNodeTo, TagLimitArray& Limits)

	Author:		Mark Howitt
	Created:	5/10/2003
	Inputs:		iItemID - The items ID to remove
				iTypeID - The type of item you're removing
				iNodeFrom - The Node you want to remove from
				iNodeTo - The Node you want to Add to.
	Outputs:	sResult - A string to take the result XML.
	Returns:	true if everything went ok, false if not
	Purpose:	Moves a given item from one node to another node.

*********************************************************************************/

bool CTagItem::MovedTagedItemFromSourceToDestinationNode(int iNodeFrom, int iNodeTo)
{
	// Check to make sure we're initialised before calling this function!
	if (!m_bIsInitialised)
	{
		return SetDNALastError("CTagItem","ObjectNotInitialised","Call InitialiseItem before calling this function!");
	}

	if (!CheckUserIsAuthorised())
	{
		return false;
	}

	// Now call the storedprocedure to move the tag
	CTDVString sNodeName;
	CTDVString sObjectName;
	CTDVString sTemp;
	bool bSuccess = false;
	bool bOk = true;

	// Setup a stored procedure object
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// Check to see if the limit has been reached for tagging
	int iNodeType = 0;
	int iSiteID = 0;
	if (!SP.GetHierarchyNodeDetailsViaNodeID(iNodeTo,NULL,NULL,NULL,NULL,NULL,NULL,NULL,&iNodeType,&iSiteID))
	{
		return SetDNALastError("CTagItem","FailedToGetNodeDetails","Failed to get node details!");
	}

	// Check the limit for this node type
	for (int i = 0; i < m_Limits.GetSize(); i++)
	{
		// If we find a match and the limit is reached, return now!
		if (m_Limits[i].GetNodeType() == iNodeType && m_Limits[i].GetSiteID() == iSiteID && m_Limits[i].GetLimitReached())
		{
			m_sXML << "<ACTION RESULT='AddFailed' REASON='TaggingLimitReached' NODE='" << iNodeFrom << "'/>";
			Destroy();
			return CreateFromXMLText(m_sXML);
		}
	}

	// Now check to make sure the user is able to add items to the destination
	if (!SP.CanUserAddToNode(iNodeTo,bSuccess) || !bSuccess)
	{
		sTemp << "MoveFailed' REASON='UserNotAllowedToAdd";
		bOk = false;
	}

	// If we're ok, try to move the item
	if (bOk)
	{
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		if ( m_iThreadID > 0 ) 
		{
			if ( !SP.MoveThreadFromSourceToDestinationNode(m_iThreadID, iNodeFrom, iNodeTo, bSuccess) || !bSuccess )
			{
				sTemp << "MoveFailed' REASON='FailedToMoveItem";
				bOk = false;
			}
		} 
		else if ( m_iUserID > 0 )
		{
			if ( !SP.MoveUserFromSourceToDestinationNode(m_iUserID,iNodeFrom,iNodeTo,bSuccess) || !bSuccess )
			{
				sTemp << "MoveFailed' REASON='FailedToMoveItem";
				bOk = false;
			}
			
		}
		else 
		{
			if ( !SP.MoveItemFromSourceToDestinationNode(m_iItemID,m_iItemType,iNodeFrom,iNodeTo,bSuccess) || !bSuccess )
			{
				sTemp << "MoveFailed' REASON='FailedToMoveItem";
				bOk = false;
			}
		}

		if ( bOk )
		{
			SP.GetField("NodeName",sNodeName);
			SP.GetField("ObjectName",sObjectName);
		}

		if (CGuideEntry::IsTypeOfUserPage(m_iItemType))
		{
			sObjectName = "UserPage";
		}
	}

	if (bOk)
	{
		// notify subscribers to category
		CUser* pUser = m_InputContext.GetCurrentUser();
		int iEventUserID = pUser != NULL ? pUser->GetUserID() : 0;
		CEventQueue EQ(m_InputContext);
		bOk = bOk && EQ.AddToEventQueue(EQ.ET_CATEGORYARTICLETAGGED, m_iUserID, m_iItemID, CEmailAlertList::IT_H2G2, iNodeTo, CEmailAlertList::IT_NODE); 

		sTemp << "MoveSucceeded' REASON='None";
	}

	// Make sure we escape the strings
	CXMLObject::EscapeEverything(&sObjectName);
	CXMLObject::EscapeEverything(&sNodeName);
	m_sXML << "<ACTION RESULT='" << sTemp << "' NODEFROM='" << iNodeFrom << "' NODENAMEFROM='" << sNodeName << "' NODETO='" << iNodeTo << "' OBJECTNAME='" << sObjectName << "'/>";

	// Create and return the verdict!
	Destroy();
	CreateFromXMLText(m_sXML);
	return bOk;
}

/*********************************************************************************

	bool CTagItem::GetTagLimitsForItem(int iType)

	Author:		Mark Howitt
	Created:	17/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Gets the limits for the item on a particular site.
				The results contain NodeType, Limit and a Description

*********************************************************************************/

bool CTagItem::GetTagLimitsForItem(int iType)
{
	// Setup some local varaibles
	CTDVString sDescription;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// Remove everthing from the limits varaible
	m_Limits.RemoveAll();

	// Call the procedure
	if (SP.GetTagLimitsForItem(iType))
	{
		// Now get the limit info
		while (!SP.IsEOF())
		{
			// Get the type, limit and description
			int iNodeType = SP.GetIntField("NodeType");
			int iLimit = SP.GetIntField("Limit");
			int iSiteID = SP.GetIntField("SiteID");
			SP.GetField("Description",sDescription);

			// Add the limits to the list
			m_Limits.Add(CTagLimits(iNodeType,iLimit,sDescription,iSiteID));

			// Get the next result
			SP.MoveNext();
		}
	}

	// Return ok
	return true;
}

bool CTagItem::GetTagLimitsForThread()
{
	// Setup some local varaibles
	CTDVString sDescription;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// Remove everthing from the limits varaible
	m_Limits.RemoveAll();

	// Call the procedure
	if (SP.GetTagLimitsForThread())
	{
		// Now get the limit info
		while (!SP.IsEOF())
		{
			// Get the type, limit and description
			int iNodeType = SP.GetIntField("NodeType");
			int iLimit = SP.GetIntField("Limit");
			int iSiteID = SP.GetIntField("SiteID");
			SP.GetField("Description",sDescription);

			// Add the limits to the list
			m_Limits.Add(CTagLimits(iNodeType,iLimit,sDescription,iSiteID));

			// Get the next result
			SP.MoveNext();
		}
	}

	// Return ok
	return true;
}

bool CTagItem::GetTagLimitsForUser()
{
	// Setup some local varaibles
	CTDVString sDescription;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	// Remove everthing from the limits varaible
	m_Limits.RemoveAll();

	// Call the procedure
	if (SP.GetTagLimitsForUser())
	{
		// Now get the limit info
		while (!SP.IsEOF())
		{
			// Get the type, limit and description
			int iNodeType = SP.GetIntField("NodeType");
			int iLimit = SP.GetIntField("Limit");
			int iSiteID = SP.GetIntField("SiteID");
			SP.GetField("Description",sDescription);

			// Add the limits to the list
			m_Limits.Add(CTagLimits(iNodeType,iLimit,sDescription,iSiteID));

			// Get the next result
			SP.MoveNext();
		}
	}

	// Return ok
	return true;
}

/*********************************************************************************

	bool CTagItem::SetTaggingLimitsForItem(CUser* pUser, const int iItemType, const int iNodeType,
										   const int iLimit, const int iSiteID)

	Author:		Mark Howitt
	Created:	12/01/2004
	Inputs:		iItemType - The type of item you want to set the limit for.
				iNodeType - The type of node you want to set the limit for.
				iLimit - The limit for the item you are setting.
				iSiteID - The Site that the limit belongs to.
	Outputs:	-
	Returns:	true if set correctly, false if not!
	Purpose:	Sets the tagging limit for a given type of item on a given site.

*********************************************************************************/

bool CTagItem::SetTaggingLimitsForItem(CUser* pUser, const int iItemType, const int iNodeType,
										const int iLimit, const int iSiteID)
{
	// Check the params
	if (pUser == NULL || iItemType <= 0 || iNodeType <= 0 || iSiteID <= 0)
	{
		return SetDNALastError("CTagItem::SetTaggingLimitsForItem","InvalidParams","Invalid params passed in");
	}

	// Check to make sure the user is a power users
	if (!pUser->GetIsEditor() && !pUser->GetIsSuperuser())
	{
		return SetDNALastError("CTagItem::SetTaggingLimitsForItem","UserNotAuthorised","User is not allowed to set limits!");
	}

	// Setup the stored procedure
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.SetTagLimitForItem(iItemType,iNodeType,iLimit,iSiteID))
	{
		return SetDNALastError("CTagItem::SetTaggingLimitsForItem","FailedSettingLmits","Failed to set the limits for item!");
	}

	// Return ok
	return true;
}

/*********************************************************************************

	bool CTagItem::SetTaggingLimitsForThread(CUser* pUser, const int iNodeType,
										   const int iLimit, const int iSiteID)

	Author:		Martin Robb
	Created:	15/04/2005
	Inputs:		iNodeType - The type of node you want to set the limit for.
				iLimit - The limit for the item you are setting.
				iSiteID - The Site that the limit belongs to.
	Outputs:	-
	Returns:	true if set correctly, false if not!
	Purpose:	Sets the tagging limit for a given type of item on a given site.

*********************************************************************************/

bool CTagItem::SetTaggingLimitsForThread(CUser* pUser, const int iNodeType, const int iLimit, const int iSiteID)
{
	// Check the params
	if (pUser == NULL || iNodeType <= 0 || iSiteID <= 0)
	{
		return SetDNALastError("CTagItem::SetTaggingLimitsForThread","InvalidParams","Invalid params passed in");
	}

	// Check to make sure the user is a power users
	if (!pUser->GetIsEditor() && !pUser->GetIsSuperuser())
	{
		return SetDNALastError("CTagItem::SetTaggingLimitsForThread","UserNotAuthorised","User is not allowed to set limits!");
	}

	// Setup the stored procedure
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.SetTagLimitForThread(iNodeType,iLimit,iSiteID))
	{
		return SetDNALastError("CTagItem::SetTaggingLimitsForThread","FailedSettingLmits","Failed to set the limits for item!");
	}

	// Return ok
	return true;
}

/*********************************************************************************
	bool CTagItem::SetTagLimitsForUser(CUser* pUser, const int iNodeType, const int iLimit, const int iSiteID)

	Author:		Martin Robb
	Created:	04/05/2005
	Inputs:		- Current User, Target NodeType, Limit, Site 
	Outputs:	-
	Returns:	- True on success
	Purpose:	- Set the tagging limits for users 

*********************************************************************************/
bool CTagItem::SetTaggingLimitsForUser(CUser* pUser, const int iNodeType, const int iLimit, const int iSiteID)
{
	// Check the params
	if (pUser == NULL || iNodeType <= 0 || iSiteID <= 0)
	{
		return SetDNALastError("CTagItem::SetTaggingLimitsForUser","InvalidParams","Invalid params passed in");
	}

	// Check to make sure the user is a power users
	if (!pUser->GetIsEditor() && !pUser->GetIsSuperuser())
	{
		return SetDNALastError("CTagItem::SetTaggingLimitsForUser","UserNotAuthorised","User is not allowed to set limits!");
	}

	// Setup the stored procedure
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.SetTagLimitForUser(iNodeType,iLimit,iSiteID))
	{
		return SetDNALastError("CTagItem::SetTaggingLimitsForUser","FailedSettingLmits","Failed to set the limits for item!");
	}

	// Return ok
	return true;


}

/*********************************************************************************

	bool CTagItem::GetTagLimitInfo(const int iSiteID)

	Author:		Mark Howitt
	Created:	12/01/2004
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CTagItem::GetTagLimitInfo(const int iSiteID)
{
	// Create the Base object to insert the info into
	if (!Destroy() || !CreateFromCacheText("<SITE-TAGLIMITS></SITE-TAGLIMITS>"))
	{
		return SetDNALastError("CTagItem::GetTagLimitInfo","FailedToCreateTree","Failed to create tagitem Tree");
	}

	// Setup the stored procedure
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetTagLimitsForSite(iSiteID))
	{
		return SetDNALastError("CTagItem::SetTaggingLimitsForItem","FailedSettingLmits","Failed to set the limits for item!");
	}
	
	// Go through the results putting them into the object
	std::set<int> threadlimits;
	std::set<int> userlimits;
	while (!SP.IsEOF())
	{
		int iItemType = -1;
		int iNodeType = 0;
		int iLimit = -1;
		CTDVString sName;
		CTDVString sXML;

		// Get the values for the current result
		if (!SP.IsNULL("NodeType"))
		{
			iNodeType = SP.GetIntField("NodeType");
		}

		if ( !SP.IsNULL("Limit") )
		{
			iLimit = SP.GetIntField("Limit");
		}

		SP.GetField("Description",sName);
		CXMLObject::EscapeEverything(&sName);

		CTDVString sType;
		SP.GetField("Type",sType);
		if ( sType == "THREAD" )
		{
			sXML = " <SITELIMIT TYPE='";
			sXML << "THREAD" << "' LIMIT='" << iLimit << "' NODETYPE='" << iNodeType << "' NODENAME='" << sName << "'/>";
			AddInside("SITE-TAGLIMITS",sXML);
		}
		if ( sType == "USER" )
		{
			sXML = " <SITELIMIT TYPE='";
			sXML << "USER" << "' LIMIT='" << iLimit << "' NODETYPE='" << iNodeType << "' NODENAME='" << sName << "'/>";
			AddInside("SITE-TAGLIMITS",sXML);
		}

		if ( sType == "TYPEDARTICLE" )
		{
			//Add Article Limits XML, A value of -1 indicates that no limits have been found for this hierarchy type.
			iItemType = SP.GetIntField("ArticleType");
			sXML = "<SITELIMIT TYPE='TYPEDARTICLE' ARTICLETYPE='";
			sXML << iItemType << "' LIMIT='" << iLimit << "' NODETYPE='" << iNodeType << "' NODENAME='" << sName << "'/>";
			AddInside("SITE-TAGLIMITS",sXML);
		}

		// Get the next result
		SP.MoveNext();
	}

	return true;
}


/*********************************************************************************

	bool CTagItem::AddTagItemToMultipleNodes(CDNAIntArray& NodeArray)

		Author:		Mark Neves
        Created:	10/12/2004
        Inputs:		NodeArray = array of node IDs to tag to
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Tags the item to all the nodes in the array.  Nodes in the array
					which correspond to nodes the item is already tagged to are ignored.

					If one or more of the nodes is not taggable to because it violates the tag
					limits, NO nodes are tagged, just an error is inserted into the XML.

					If no tag limits are violated, it attempts to tag to all the nodes.  It produces
					an XML structure called <TAGMULTIPLENODES> that can be examined for 
					the success of this operation.

*********************************************************************************/

bool CTagItem::AddTagItemToMultipleNodes(CDNAIntArray& NodeArray)
{
	// Create an array of node ids that does NOT contain the nodes the item is already tagged to
	CDNAIntArray FilteredNodeArray;
	for (int i=0;i < NodeArray.GetSize();i++)
	{
		int iNodeID = NodeArray.GetAt(i);
		if (m_mNodesTaggedToDetails.find(iNodeID) == m_mNodesTaggedToDetails.end())
		{
			FilteredNodeArray.Add(iNodeID);
		}
	}

	CreateFromXMLText("<TAGMULTIPLENODES></TAGMULTIPLENODES>");

	if (!FilteredNodeArray.IsEmpty())
	{
		CTDVString sXML;
		bool bLimitsOK = CheckLimitsForMultipleNodes(FilteredNodeArray,sXML);
		AddInside("TAGMULTIPLENODES",sXML);

		if (!bLimitsOK)
		{
			sXML = "<ACTION RESULT='AddMultipleFailed' REASON='TaggingLimitReached'/>";
		}
		else
		{
			sXML = "<RESULTS>";
			for (int i=0;i < FilteredNodeArray.GetSize();i++)
			{
				AddTagItemToNodeInternal(FilteredNodeArray.GetAt(i),true,sXML);
				if (ErrorReported())
				{
					return false;
				}
			}
			sXML << "</RESULTS>";
		}

		AddInside("TAGMULTIPLENODES",sXML);
	}

	return true;
}

/*********************************************************************************

	bool CTagItem::CheckLimitsForMultipleNodes(CDNAIntArray& NodeArray,CTDVString& sXML)

		Author:		Mark Neves
        Created:	10/12/2004
        Inputs:		NodeArray = list of node IDs
					sXML = gets stuffed full of XML
        Outputs:	-
        Returns:	true = no tag limits will be violated if item is tagged to them
					false = one or more nodes can't be tagged to because of limit violation
        Purpose:	Checks the limits of the nodes passed in for this item.

					It generates a <NODETAGCOUNTS> XML structure that details the nodes
					in the array, what type they are, how many nodes of that type are
					being asked to be tagged to, how many spaces are left, and if the
					tag limit has been reached

					The return value is a flag to indicate whether they are all OK,
					or one or more would fail due to limit violation

*********************************************************************************/

bool CTagItem::CheckLimitsForMultipleNodes(CDNAIntArray& NodeArray,CTDVString& sXML)
{
	CTDVString sNodeDetailsXML;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	map<int,CHierarchyNodeDetails> mNodeDetails;
	GetMultipleHierarchyNodeDetails(NodeArray,&mNodeDetails);

	map<int,int> mNumNodesToAdd;

	// Calculate how many of each type we want to add
	for (int i=0;i< NodeArray.GetSize();i++)
	{
		int iType = mNodeDetails[NodeArray.GetAt(i)].m_iType;
		mNumNodesToAdd[iType] = mNumNodesToAdd[iType]+1;
	}

	bool bAnyLimitsReached = false;

	CDBXMLBuilder XMLBuilder;
	XMLBuilder.Initialise(&sXML);
	XMLBuilder.OpenTag("NODETAGCOUNTS");
	for (int i=0;i< NodeArray.GetSize();i++)
	{
		int iNodeID = NodeArray.GetAt(i);
		int iType = mNodeDetails[iNodeID].m_iType;
		int iSiteID = mNodeDetails[iNodeID].m_iSiteID;
		int iNumToAdd = mNumNodesToAdd[iType];
		int iRemainingSpace = GetRemainingTagSpace(iType,iSiteID);
		int iLimitReached = int(iRemainingSpace < iNumToAdd);

		XMLBuilder.OpenTag("NODE",true);
		XMLBuilder.AddIntAttribute("NODEID",iNodeID);
		XMLBuilder.AddAttribute("NAME",mNodeDetails[iNodeID].sDisplayName);
		XMLBuilder.AddIntAttribute("NUMTOADD",iNumToAdd);
		XMLBuilder.AddIntAttribute("REMAININGSPACE",iRemainingSpace);
		XMLBuilder.AddIntAttribute("LIMITREACHED",iLimitReached,true);
		XMLBuilder.CloseTag("NODE");

		if (iLimitReached > 0)
		{
			bAnyLimitsReached = true;
		}
	}
	XMLBuilder.CloseTag("NODETAGCOUNTS");

	// Return true only if we haven't hit any tag limits
	return (!bAnyLimitsReached);
}


/*********************************************************************************

	int CTagItem::GetRemainingTagSpace(int iType,int iSiteID)

		Author:		Mark Neves
        Created:	10/12/2004
        Inputs:		iType = the type of node
					iSiteID = the site ID
        Outputs:	-
        Returns:	The remaining space for the give type for the site
					If it can't find details for that type, it returns a big
					number as there are no limits for this type!
        Purpose:	Helper function for working out remaining tag space.

*********************************************************************************/

int CTagItem::GetRemainingTagSpace(int iType,int iSiteID)
{
	for (int i=0;i < m_Limits.GetSize();i++)
	{
		if (m_Limits[i].GetNodeType() == iType && m_Limits[i].GetSiteID() == iSiteID)
		{
			return m_Limits[i].GetRemainingSpace();
		}
	}

	// Return a big number as their are no limits for this type, but his is the only way to convey this!
	return 9999999;
}

/*********************************************************************************

	bool CTagItem::GetMultipleHierarchyNodeDetails(CDNAIntArray& NodeArray,map<int,CHierarchyNodeDetails>* pmNodeDetails)

		Author:		Mark Neves
        Created:	10/12/2004
        Inputs:		NodeArray = the array of nodes we want details about
					pmNodeDetails = the map to put the details in
        Outputs:	-
        Returns:	true if OK, false if it was given silly inputs
        Purpose:	Calls the database to retrieve Node Hierarchy details for
					the list of nodes in the array.

*********************************************************************************/

bool CTagItem::GetMultipleHierarchyNodeDetails(CDNAIntArray& NodeArray,map<int,CHierarchyNodeDetails>* pmNodeDetails)
{
	if (NodeArray.IsEmpty() || pmNodeDetails == NULL)
	{
		return false;
	}

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	int i = 0;
	while (i < NodeArray.GetSize())
	{
		if (!SP.GetMultipleHierarchyNodeDetails(NodeArray,i))
		{
			return SetDNALastError("CTagItem","FAILEDGETMULTIPLEHIERARCYNODEDETAILS","Unable to get multiple hierarchy node details");
		}

		if (SP.IsEOF())
		{
			TDVASSERT(false, "CTagItem: GetMultipleHierarchyNodeDetails() returned EOF");
			break;	// Need this in case no results are returned with given set of node IDs
		}

		while (!SP.IsEOF())
		{
			CTDVString sDisplayName;
			SP.GetField("displayname",sDisplayName);
			CXMLObject::EscapeXMLText(&sDisplayName);
			
			int iNodeID = SP.GetIntField("nodeid");
			int iType = SP.GetIntField("type");
			int iSiteID = SP.GetIntField("siteid");
			(*pmNodeDetails)[iNodeID] = CHierarchyNodeDetails(iNodeID,iType,iSiteID,sDisplayName);

			i++;
			SP.MoveNext();
		}
	}

	return true;
}
