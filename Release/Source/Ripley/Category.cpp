// Category.cpp: implementation of the CCategory class.
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


#include "stdafx.h"
#include "tdvassert.h"
#include "Category.h"
#include "ExtraInfo.h"
#include "GuideEntry.h"
#include ".\category.h"
#include "ArticleMember.h"
#include "ClubMember.h"
#include "XMLStringUtils.h"
#include "StoredProcedure.h"

#include "Forum.h"
#include "Notice.h"


const int CCategory::MAX_CLOSE_ROWS = 500;
const int CCategory::SORT_LASTUPDATED = 1;

const int CCategory::MAX_ARTICLE_ROWS = 500;
	

//Specify Filters outside the range of Typed Articles.
//const int CCategory::FILTER_ON_THREAD = -1;
//const int CCategory::FILTER_ON_USER = -2;

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CCategory::CCategory(CInputContext& inputContext) 
: CXMLObject(inputContext), m_iBaseLine(0)
{
	m_h2g2ID = 0;
}

CCategory::~CCategory()
{

}


bool CCategory::Initialise(int iID, bool bIDIsNodeID,  int iSiteID, CATEGORYTYPEFILTER Type, int iArticleType /*=0*/, int iShow /*=0*/, int iSkip/*=0*/)
{
	CStoredProcedure SP;
	
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "No stored procedure created");
		return false;
	}

	m_iMemberCrumbTrails = m_InputContext.GetIncludeCrumbtrail(); 

	CTDVString sDescription;
	CTDVString Synonyms;
	int iUserAdd = 0;
	int iParentID;
	int iTypeID;

	//if the nodeId is zero then we actually want the root for the given site
	if(bIDIsNodeID && iID == 0)
	{
		//get the proper nodeID from the table;
		if (!SP.GetRootNodeFromHierarchy(iSiteID,&iID))
		{
			TDVASSERT(false,"No rootnode for the given siteID");
			return false;
		}
	}

	bool bOK = false;

	if (bIDIsNodeID)
	{
		bOK = SP.GetHierarchyNodeDetailsViaNodeID(iID, &m_NodeName, &sDescription,
			&iParentID, &m_h2g2ID, &Synonyms, &iUserAdd, &m_NodeID, &iTypeID,
			NULL, &m_iBaseLine);
	}
	else
	{
		bOK = SP.GetHierarchyNodeDetailsViaH2G2ID(iID, &m_NodeName, &sDescription,
			&iParentID, &m_h2g2ID, &Synonyms, &iUserAdd, &m_NodeID, &iTypeID,
			NULL, &m_iBaseLine);
	}

	if (!bOK)
	{
		//just display the root
		return Initialise(0,true,iSiteID);
	}

	CTDVString sXML;

	// Make sure that we allocate enough space for all the xml that we're about to produce.
	// This speeds up all the string operations as it doesn't need to keep extending the buffer everytime it gets added to.
	sXML.EnsureAvailable(500000);
	if (iSiteID == 16)
	{
		// If we're actionnetwork, then we should make sure we've got a lot more space.
		// Action network categories contain a lot more than other sites, and a page can reach upto 4MB in size!
		sXML.EnsureAvailable(4000000);
	}


	CreateHierarchyDetailsXML(SP, sXML);
	if (!CreateFromXMLText(sXML))
	{
		return false;
	}

	//Add ancestry ( parents ) information for this Node
	GetCategoryAncestry(m_NodeID, sXML);
	AddInside("HIERARCHYDETAILS", sXML);

	//Get Child Nodes and create XML
	bool bHaveResults = true;
	SP.CatGetSubjects(m_NodeID,bHaveResults);
	sXML = "<MEMBERS>";
	CTDVString sSubNodes;
	int iLastNodeID = 0;
	int iRedirectNodeID = 0;
	CTDVString sRedirectNodeName = "";

	while (!SP.IsEOF())
	{
		int iCurNodeID = SP.GetIntField("NodeID");
		if (iCurNodeID != iLastNodeID)
		{
			if (iLastNodeID != 0)
			{
				if (!sSubNodes.IsEmpty())
				{
					sSubNodes << "</SUBNODES>";
				}
				sXML << sSubNodes << "</SUBJECTMEMBER>";
			}
			sXML << "<SUBJECTMEMBER>";
			sXML << "<NODEID>" << SP.GetIntField("NodeID") <<"</NODEID>";
			sXML << "<TYPE>" << SP.GetIntField("Type") << "</TYPE>";
			sXML << "<NODECOUNT>" << SP.GetIntField("NodeMembers") << "</NODECOUNT>";
			sXML << "<ARTICLECOUNT>" << SP.GetIntField("ArticleMembers") << "</ARTICLECOUNT>";
			sXML << "<ALIASCOUNT>" << SP.GetIntField("NodeAliasMembers") << "</ALIASCOUNT>";
			CTDVString sName;
			SP.GetField("DisplayName", sName);
			EscapeXMLText(&sName);
			sXML << "<NAME>" << sName << "</NAME>";

			// Check to see if the node has a redirected
			if (SP.FieldExists("RedirectNodeID") && !SP.IsNULL("RedirectNodeID"))
			{
				SP.GetField("RedirectNodeName",sRedirectNodeName);
				iRedirectNodeID = SP.GetIntField("RedirectNodeID");
				sXML << "<REDIRECTNODE ID='" << iRedirectNodeID << "'>" << sRedirectNodeName << "</REDIRECTNODE>";
			}

			CXMLStringUtils::AddStrippedNameXML(SP, "DisplayName", sXML);
			sSubNodes.Empty();
		}
		if (!SP.IsNULL("SubName"))
		{
			if (sSubNodes.IsEmpty())
			{
				sSubNodes << "<SUBNODES>";
			}

			CTDVString sSubNodeName;
			SP.GetField("SubName", sSubNodeName);
			EscapeXMLText(&sSubNodeName);

			sSubNodes << "<SUBNODE ID='" << SP.GetIntField("SubNodeID") << "'";
			sSubNodes << " TYPE='" << SP.GetIntField("SubNodeType") << "'";
			// Check to see if the node has a redirected
			if (SP.FieldExists("SubRedirectNodeID") && !SP.IsNULL("SubRedirectNodeID"))
			{
				SP.GetField("SubRedirectNodeName",sRedirectNodeName);
				EscapeEverything(&sRedirectNodeName);
				iRedirectNodeID = SP.GetIntField("SubRedirectNodeID");
				sSubNodes << " REDIRECTNODEID='" << iRedirectNodeID << "' REDIRECTNODENAME='" << sRedirectNodeName << "'";
			}
			sSubNodes << ">" << sSubNodeName << "</SUBNODE>";
		}

		iLastNodeID = iCurNodeID;

		SP.MoveNext();
	}
	if (iLastNodeID != 0)
	{
		if (!sSubNodes.IsEmpty())
		{
			sSubNodes << "</SUBNODES>";
		}
		sXML << sSubNodes << "</SUBJECTMEMBER>";
	}

	// Get Articles / Threads Tagged to Node.
	int iRows = 0;
	if ( (Type == NONE ) || (Type == TYPEDARTICLE && CGuideEntry::IsTypeOfArticle(iArticleType)) )
	{
		//If Show param not provided, return default max articles.
		if ( iShow == 0 )
		{
			iShow = MAX_ARTICLE_ROWS;
		}
		if (!GetArticleMembersForNodeID(m_NodeID, sXML, &iRows, iArticleType,  iShow,  iSkip ))
		{
			return false;
		}
	}

	//Get Clubs ( Campaigns )  tagged to this Node
	if ( (Type == NONE ) || (Type == TYPEDARTICLE && CGuideEntry::IsTypeOfClub(iArticleType)) )
	{
		if (!GetClubMembersForNodeID(m_NodeID, sXML, &iRows, iShow,  iSkip ))
		{
			return false;
		}
	}

	//Include Notice Board Posts tagged to this node.
	if ( Type == NONE || Type == THREAD )
	{
		if ( !GetNoticesForNodeID(m_NodeID, sXML) )
		{
			return false;
		}
	}

	//Include Notice Board Posts tagged to this node.
	if ( Type == NONE || Type == USER  )
	{
		if ( !GetUsersForNodeID(m_NodeID, sXML) )
		{
			return false;
		}
	}

	//Create the Skip and Show XML
	if ( iSkip > 0 )
	{
		sXML << "<COUNT>" << iShow << "</COUNT>";
		sXML << "<SKIP>" << iSkip << "</SKIP>";
		if ( iRows > (iShow + iSkip) )
		{
			sXML << "<MORE>" << 1 << "</MORE>";
		}
		else
		{
			sXML << "<MORE>" << 0 << "</MORE>";
		}
	}

	//Get the Aliases and create XML
	SP.GetHierarchyNodeAliases(m_NodeID,bHaveResults);
	sSubNodes.Empty();
	int nLastLinkNodeID = -1;
	while(!SP.IsEOF())
	{
		int nLinkNodeID = SP.GetIntField("LinkNodeID");
		if (nLinkNodeID != nLastLinkNodeID)
		{
			if (nLastLinkNodeID != -1)
			{
				if (!sSubNodes.IsEmpty())
				{
					sSubNodes << "</SUBNODES>";
				}
				sXML << sSubNodes << "</NODEALIASMEMBER>";
			}

			sXML << "<NODEALIASMEMBER>";
			sXML << "<LINKNODEID>" << SP.GetIntField("LinkNodeID") << "</LINKNODEID>";
			sXML << "<NODECOUNT>" << SP.GetIntField("NodeMembers") << "</NODECOUNT>";
			sXML << "<ARTICLECOUNT>" << SP.GetIntField("ArticleMembers") << "</ARTICLECOUNT>";
			sXML << "<ALIASCOUNT>" << SP.GetIntField("NodeAliasMembers") << "</ALIASCOUNT>";
			CTDVString sName;
			SP.GetField("DisplayName", sName);
			EscapeXMLText(&sName);
			sXML << "<NAME>" << sName << "</NAME>";
			CXMLStringUtils::AddStrippedNameXML(SP, "DisplayName", sXML);
			sSubNodes.Empty();
		}
		if (!SP.IsNULL("SubName"))
		{
			if (sSubNodes.IsEmpty())
			{
				sSubNodes << "<SUBNODES>";
			}

			CTDVString sSubNodeName;
			SP.GetField("SubName", sSubNodeName);
			EscapeXMLText(&sSubNodeName);

			sSubNodes << "<SUBNODE ID='" << SP.GetIntField("SubNodeID") << "'>" << sSubNodeName << "</SUBNODE>";
		}

		nLastLinkNodeID = nLinkNodeID;
		SP.MoveNext();
	}
	if (nLastLinkNodeID != -1)
	{
		if (!sSubNodes.IsEmpty())
		{
			sSubNodes << "</SUBNODES>";
		}
		sXML << sSubNodes << "</NODEALIASMEMBER>";
	}
	sXML << "</MEMBERS>";
	AddInside("HIERARCHYDETAILS", sXML);

	if (m_InputContext.DoesCurrentSiteHaveSiteOptionSet("Category", "IncludeCloseMembers"))
	{
		sXML = "";
		if (!GetHierarchyCloseMembers(SP, m_NodeID, MAX_CLOSE_ROWS - iRows, sXML))
		{
			return false;
		}
		AddInside("HIERARCHYDETAILS", sXML);
	}

	// Action network does not use the sort information, so don't do the sort.
	// Another reason for not doing this action is that it goes through 1.4 million iterations for 1598 items
	// and takes upto one minute to complete all for nothing!!!
	if ( iSiteID != 16)
	{
		if (!SetSortOrderForNodeMembers(m_pTree, "MEMBERS"))
		{
			return false;
		}
	}

	return true;
}



/*********************************************************************************

	bool CCategory::InitialiseViaNodeID(int iNodeID, int iSiteID)
	Author:		Mark Neves
	Created:	04/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Initialises the category given the NodeID

*********************************************************************************/

bool CCategory::InitialiseViaNodeID(int iNodeID, int iSiteID/*=1*/,  CATEGORYTYPEFILTER Type, int iArticleType/*=0*/, int iShow/*=0*/, int iSkip/*=0*/)
{
	return Initialise( iNodeID,true,iSiteID, Type, iArticleType, iShow, iSkip );
}

/*********************************************************************************

	bool CCategory::InitialiseViaH2G2ID(int iH2G2ID, int iSiteID)
	Author:		Mark Neves
	Created:	04/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Initialises the category given the associated H2G2ID

*********************************************************************************/

bool CCategory::InitialiseViaH2G2ID(int iH2G2ID,  int iSiteID /*=1*/)
{
	return Initialise(iH2G2ID,false,iSiteID);
}


/*********************************************************************************

	bool CCategory::GetArticleCrumbTrail(int ih2g2ID)

	Author:		Jim Lynn
	Created:	11/12/2001
	Inputs:		ih2g2ID - ID of article whose crumb trail(s) we want
	Outputs:	-
	Returns:	true if a trail found, false if none found
	Purpose:	Gets a crumb trail for the article. An article can appear
				in several categories at once. All crumb trails will be 
				retrieved in no particular order.

*********************************************************************************/

bool CCategory::GetArticleCrumbTrail(int ih2g2ID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.GetArticleCrumbTrail(ih2g2ID))
	{
		return false;
	}
	
	CTDVString sCrumbs;
	if (GetCrumbTrail(SP,sCrumbs))
	{
		CreateFromXMLText(sCrumbs);
	}

	return true;
}


/*********************************************************************************

	bool CCategory::GetUserCrumbTrail(int iUserID)

	Author:		Martin Robb
	Created:	10/08/2005
	Inputs:		iUserID - ID of user whose crumb trail(s) we want
	Outputs:	-
	Returns:	true if a trail found, false if none found
	Purpose:	Gets a crumb trail for the user. A user may be tagged to a number 
				of hiearchy nodes. All crumb trails will be 
				retrieved in no particular order.

*********************************************************************************/

bool CCategory::GetUserCrumbTrail(int iUserID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.GetUserCrumbTrail(iUserID))
	{
		return false;
	}
	
	CTDVString sCrumbs;
	if (GetCrumbTrail(SP,sCrumbs))
	{
		CreateFromXMLText(sCrumbs);
	}

	return true;
}

/*********************************************************************************

	bool CCategory::GetClubCrumbTrail(int iClubID)

	Author:		Mark Neves
	Created:	02/10/2003
	Inputs:		iClubID = club id
	Outputs:	-
	Returns:	true if ok, false otherwise
	Purpose:	Creates the XML defining the club crumbtrail, and initialises this object
				with it

*********************************************************************************/

bool CCategory::GetClubCrumbTrail(int iClubID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.GetClubCrumbTrail(iClubID))
	{
		return false;
	}
	
	CTDVString sCrumbs;
	if (GetCrumbTrail(SP,sCrumbs))
	{
		CreateFromXMLText(sCrumbs);
	}

	return true;
}

/*********************************************************************************

	bool CCategory::GetCrumbTrail(CStoredProcedure& SP, CTDVString& sCrumbs)

	Author:		Jim Lynn (extracted from GetArticleCrumbTrail() by Mark Neves)
	Created:	02/10/2003
	Inputs:		SP = object holding the crumb trail record set
	Outputs:	sCrumbs = the XML representation of the crumb trail
	Returns:	-
	Purpose:	General routine for creating crumb trail XML.

*********************************************************************************/

bool CCategory::GetCrumbTrail(CStoredProcedure& SP, CTDVString& sCrumbs)
{
	sCrumbs = "<CRUMBTRAILS>";
	bool bStartOfTrail = true;
	while (!SP.IsEOF())
	{
		if (bStartOfTrail)
		{
			sCrumbs << "<CRUMBTRAIL>";
			bStartOfTrail = false;
		}
		// put in the data for this trail entry
		CTDVString DisplayName;
		SP.GetField("DisplayName", DisplayName);
		int iMainNode = SP.GetIntField("MainNode");		// Actual node the article is in
		int iAncestorID = SP.GetIntField("NodeID");		// Ancestor node at this point in the trail
		int iTreeLevel = SP.GetIntField("TreeLevel");
		int iNodeType = SP.GetIntField("Type");
		EscapeXMLText(&DisplayName);
		sCrumbs << "<ANCESTOR><NODEID>" << iAncestorID << "</NODEID>";
		sCrumbs << "<NAME>" << DisplayName << "</NAME>";
		sCrumbs << "<TREELEVEL>" << iTreeLevel << "</TREELEVEL>";
		sCrumbs << "<NODETYPE>" << iNodeType << "</NODETYPE>";
		// Check to see if the node has a redirected
		if (SP.FieldExists("RedirectNodeID") && !SP.IsNULL("RedirectNodeID"))
		{
			CTDVString sDisplayName = "";
			SP.GetField("RedirectNodeName",sDisplayName);
			sCrumbs << "<REDIRECTNODE ID='" << SP.GetIntField("RedirectNodeID") << "'>" << sDisplayName << "</REDIRECTNODE>";
		}
		sCrumbs << "</ANCESTOR>";
		SP.MoveNext();
		if (!SP.IsEOF() && SP.GetIntField("TreeLevel") == 0)
		{
			sCrumbs << "</CRUMBTRAIL>";
			bStartOfTrail = true;
		}
	}
	sCrumbs << "</CRUMBTRAIL></CRUMBTRAILS>";
	return true;
}

/*********************************************************************************

	bool CCategory::GetRelatedArticles(int ih2g2ID)

	Author:		Mark Howitt
	Created:	20/08/2003
	Inputs:		ih2g2ID - ID of article to look for
	Outputs:	-
	Returns:	true if match found, false if not
	Purpose:	Gets all the related articles for a given article.
				This searches all nodes in which the article is referenced

*********************************************************************************/
bool CCategory::GetRelatedArticles(int ih2g2ID, CTDVString& sRelatedNodesXML)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetRelatedArticles(ih2g2ID))
	{
		return false;
	}

	// Setup the new Node. Zip through the Stored Procedure picking out the details.
	int iStatus = 0;
	CTDVString sExtraInfo;
	InitialiseXMLBuilder(&sRelatedNodesXML,&SP);
	bool bOk = OpenXMLTag("RELATEDARTICLES");

	CTDVString sArticleMembersXML;

	while (bOk && !SP.IsEOF())
	{
		ArticleKeyPhrases akp;
		bOk = bOk && AddArticleMemberXML(SP, sArticleMembersXML, akp);
		SP.MoveNext();
	}

	bOk = bOk && AddXMLTag("", sArticleMembersXML);
	bOk = bOk && CloseXMLTag("RELATEDARTICLES");

	return bOk;
}

bool CCategory::GetRelatedClubs(int ih2g2id, CTDVString &sRelatedClubsXML)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetRelatedClubs(ih2g2id))
	{
		return false;
	}

	// Setup the new Node. Zip through the Stored Procedure picking out the details.
	sRelatedClubsXML = "<RELATEDCLUBS>";

	while (!SP.IsEOF())
	{
		bool bMovedToNextRec = false;
		AddClubMemberXML(SP, false, sRelatedClubsXML, bMovedToNextRec);
		if ( bMovedToNextRec == false)
		{
			SP.MoveNext();
		}
	}

	// Tidy up and return
	sRelatedClubsXML << "</RELATEDCLUBS>";
	return true;
}


/*********************************************************************************
bool CCategory::GetCategoryAncestry(int iNodeID, CTDVString &sAncestryXML)
Inputs:		iNodeID - node id
Outputs:	sAncestryXML - resulting xml
Returns:	true on success
Purpose:	Builds <ANCESTRY> xml for given hierarchy node
*********************************************************************************/

bool CCategory::GetCategoryAncestry(int iNodeID, CTDVString &sAncestryXML)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	sAncestryXML.Empty();

	if (!SP.GetAncestry(iNodeID))
	{
		TDVASSERT(false,"Failed to getting the ancestry for the node!");
		return false;
	}

	if (!SP.IsEOF())
	{
		sAncestryXML = "<ANCESTRY>";
		while (!SP.IsEOF())
		{
			CTDVString sAncestorName;
			int iAncestorID = SP.GetIntField("AncestorID");
			SP.GetField("DisplayName",sAncestorName);
			EscapeXMLText(&sAncestorName);
			sAncestryXML << "<ANCESTOR><NODEID>" << iAncestorID << "</NODEID>";
			int iAncTypeID = SP.GetIntField("Type");
			sAncestryXML << "<TYPE>" << iAncTypeID<< "</TYPE>";
			sAncestryXML << "<NAME>" << sAncestorName << "</NAME>";
			int iTreeLevel = SP.GetIntField("TreeLevel");
			sAncestryXML << "<TREELEVEL>" << iTreeLevel << "</TREELEVEL>";
			// Check to see if the node has a redirected
			if (SP.FieldExists("RedirectNodeID") && !SP.IsNULL("RedirectNodeID"))
			{
				CTDVString sDisplayName = "";
				SP.GetField("RedirectNodeName",sDisplayName);
				sAncestryXML << "<REDIRECTNODE ID='" << SP.GetIntField("RedirectNodeID") << "'>" << sDisplayName << "</REDIRECTNODE>";
			}
			sAncestryXML << "</ANCESTOR>";
			SP.MoveNext();
		}
		sAncestryXML << "</ANCESTRY>";
	}

	return true;
}

/*********************************************************************************

	bool CCategory::GetSubjectMembersForNodeID(int iNodeID, CTDVString& sXML)

		Author:		Mark Howitt
        Created:	08/04/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CCategory::GetSubjectMembersForNodeID(int iNodeID, CTDVString& sXML)
{
	// Check the NodeID!
	if (iNodeID == 0)
	{
		return SetDNALastError("CCategory","NoNodeIDGiven","Illegal NodeID");
	}

	// Setup the StoredProcedure 
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CCategory","FailedToInitStoredProcedure","Failed to intialise Stored ComponentSP");
	}

	// Now get the list for the given list id
	bool bHaveResults = true;
	if (!SP.CatGetSubjects(iNodeID,bHaveResults))
	{
		return SetDNALastError("CCategory","CatGetSubjectsFailed","Failed getting subjects for category node");
	}

	// Setup the XMLBuilder with the xml string and procedure
	InitialiseXMLBuilder(&sXML,&SP);

	// Setup some local variables
	int iLastNodeID = 0, iCurNodeID= 0;
	bool bAddedSubNodes = false;
	bool bOk = true;
	CTDVString sSubNodeName;
	while (bOk && !SP.IsEOF())
	{
		// Get the current nodeid
		iCurNodeID = SP.GetIntField("NodeID");
		if (iCurNodeID != iLastNodeID)
		{
			if (iLastNodeID != 0)
			{
				if (bAddedSubNodes)
				{
					bOk = bOk && CloseXMLTag("SUBNODES");
					bAddedSubNodes = false;
				}
				bOk = bOk && CloseXMLTag("SUBJECTMEMBER");
			}

			bOk = bOk && OpenXMLTag("SUBJECTMEMBER");
			bOk = bOk && AddDBXMLIntTag("NODEID");
			bOk = bOk && AddDBXMLIntTag("TYPE");
			bOk = bOk && AddDBXMLIntTag("NODEMEMBERS","NODECOUNT");
			bOk = bOk && AddDBXMLIntTag("ARTICLEMEMBERS","ARTICLECOUNT");
			bOk = bOk && AddDBXMLIntTag("NODEALIASMEMBERS","ALIASCOUNT");
			bOk = bOk && AddDBXMLTag("DISPLAYNAME","NAME");
			if (bOk)
			{
				CXMLStringUtils::AddStrippedNameXML(SP, "DisplayName", sXML);
			}
			bOk = bOk && AddDBXMLIntTag("REDIRECTNODEID",NULL,false);
		}

		// Check to see if it's got any subnodes!
		if (!SP.IsNULL("SubName"))
		{
			// If we havn't opened the SUbnodes Tag, do so
			if (!bAddedSubNodes)
			{
				bAddedSubNodes = true;
				bOk = bOk && OpenXMLTag("SUBNODES");
			}
			bOk = bOk && OpenXMLTag("SUBNODE",true);
			bOk = bOk && AddDBXMLIntAttribute("SubNodeID","ID",true,false);
			bOk = bOk && AddDBXMLIntAttribute("SubNodeType","TYPE",true,true);
			SP.GetField("SubName", sSubNodeName);
			EscapeXMLText(&sSubNodeName);
			bOk = bOk && CloseXMLTag("SUBNODE",sSubNodeName);
		}

		// Set the last node and move to the next result
		iLastNodeID = iCurNodeID;
		SP.MoveNext();

		// Check to see if we've reached the end of the results and need to close the subnodes!
		if (SP.IsEOF() && iLastNodeID != 0)
		{
			if (bAddedSubNodes)
			{
                bOk = bOk && CloseXMLTag("SUBNODES");
			}
			bOk = bOk && CloseXMLTag("SUBJECTMEMBER");
		}
	}

	return bOk;
}

/*********************************************************************************

	bool CCategory::GetArticleMembersForNodeID(int iNodeID, CTDVString& sXML, int* pRows, int iType, int iShow, int iSkip )

		Author:		Mark Howitt
        Created:	08/04/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CCategory::GetArticleMembersForNodeID(int iNodeID, CTDVString& sXML, int* pRows/*=NULL*/, int iType/*=0*/, int iShow/*=MAX_ARTICLE_ROWS*/, int iSkip/*=0*/ )
{
	// Check the NodeID!
	if (iNodeID == 0)
	{
		return SetDNALastError("CCategory","NoNodeIDGiven","Illegal NodeID");
	}

	// Setup the StoredProcedure 
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CCategory","FailedToInitStoredProcedure","Failed to intialise Stored ComponentSP");
	}

	CUser* pUser = m_InputContext.GetCurrentUser();
	int iUserTaxonomyNodeID = 0;
	// Now get the node articles for the given list id
	bool bHaveResults = true;
	bool bNeedMediaAssetInfo = false;
	bool bIncludeKeyPhraseData = false;

	bNeedMediaAssetInfo = m_InputContext.DoesCurrentSiteHaveSiteOptionSet("MediaAsset", "ReturnInCategoryList");

	bIncludeKeyPhraseData = m_InputContext.DoesCurrentSiteHaveSiteOptionSet("KeyPhrases", "ReturnInCategoryList");

	if (bIncludeKeyPhraseData)
	{
		if (!SP.GetHierarchyNodeArticlesWithKeyPhrases(iNodeID, iType, iShow + iSkip, bNeedMediaAssetInfo))
		{
			return SetDNALastError("CCategory","GetHierarchyNodeArticlesWithKeyPhrasesWithMediaAssets", "Failed getting articles with key phrases for category node");
		}
	}
	else
	{
		if (m_iMemberCrumbTrails == 1 && pUser)
		{
			pUser->GetTaxonomyNode(&iUserTaxonomyNodeID);

			if (bNeedMediaAssetInfo)
			{
				if (!SP.GetHierarchyNodeArticlesWithLocalWithMediaAssets(iNodeID, iType, iShow + iSkip, true, iUserTaxonomyNodeID))
				{
					return SetDNALastError("CCategory","GetHierarchyNodeArticlesWithLocalWithMediaAssets","Failed getting articles for category node");
				}
			}
			else
			{
				if (!SP.GetHierarchyNodeArticlesWithLocal(iNodeID, iType, iShow + iSkip, true, iUserTaxonomyNodeID))
				{
					return SetDNALastError("CCategory","GetHierarchyNodeArticlesWithLocal","Failed getting articles for category node");
				}
			}
		}
		else 
		{

			if (bNeedMediaAssetInfo)
			{
				if (!SP.GetHierarchyNodeArticlesWithMediaAssets(iNodeID, bHaveResults, iType, iShow + iSkip, true))
				{
					return SetDNALastError("CCategory","GetHierarchyNodeArticlesWithMediaAssets","Failed getting articles for category node");
				}
			}
			else
			{
				if (!SP.GetHierarchyNodeArticles(iNodeID, bHaveResults, iType, iShow + iSkip, true))
				{
					return SetDNALastError("CCategory","GetHierarchyNodeArticles","Failed getting articles for category node");
				}
			}
		}
	}

	// Add all the articles
	bool bOk = true;

	CTDVString sType(iType);
	
	//Process the keyphrases DataSet first
	ArticleKeyPhrases articleKeyPhrasesMap; 

	if (bIncludeKeyPhraseData)
	{
		SEARCHPHRASELIST phraselist;
		int ih2g2ID = 0;
		int ArticleCount=0;
		int PrevEntryID=0;
		int ThisEntryID=PrevEntryID;

		if(!SP.IsEOF())
		{
			if (iSkip > 0)
			{
				//Skips the number of articles in the returned key phrases
				do
				{
					ThisEntryID = SP.GetIntField("EntryID");
					if(PrevEntryID == 0) //The first time
					{
						PrevEntryID = ThisEntryID;
					}
					if(ThisEntryID != PrevEntryID)
					{
						PrevEntryID = ThisEntryID;
						ArticleCount++;
					}
				} while (SP.MoveNext() && ArticleCount < iSkip);
			}

			PrevEntryID = 0;
			//Now generates the list of phrases matching the entry id of the article
			do
			{
				ThisEntryID = SP.GetIntField("EntryID");
				if(PrevEntryID == 0) //The first time
				{
					PrevEntryID = ThisEntryID;
				}
				if(ThisEntryID != PrevEntryID)
				{
					articleKeyPhrasesMap[PrevEntryID] = phraselist;
					phraselist.clear();
					PrevEntryID = ThisEntryID;				
				}

				CTDVString sPhrase = "";
				CTDVString sNamespace = "";
				
				if(!SP.IsNULL("Phrase"))
				{
					SP.GetField("Phrase", sPhrase);

					if(SP.FieldExists("Namespace") && !SP.IsNULL("Namespace"))
					{
						SP.GetField("Namespace", sNamespace);
					}
					
					PHRASE phrase(sNamespace, sPhrase);

					phraselist.push_back(phrase);
				}

			} while (SP.MoveNext());
		}
		
	}
	
	if (iSkip > 0)
	{
		SP.MoveNext(iSkip);
	}

	int type = 0;
	int prevtype = -1;
	std::map<int,int> TypeCounts;
	while (bOk && !SP.IsEOF())
	{
		bOk = AddArticleMemberXML(SP, sXML, articleKeyPhrasesMap);
		
		//Record the count for each type.
		type = SP.GetIntField("Type");
		if ( prevtype != type )
		{
			TypeCounts[type] = SP.GetIntField("TypeCount");
			prevtype = type;
		}

		SP.MoveNext();

		if ( iSkip > 0  )
		{
			iShow--;
			if ( iShow == 0 )
			{
				break;
			}
		}				
	}

	//Add the count information.
	for ( std::map<int,int>::iterator iter = TypeCounts.begin(); iter != TypeCounts.end(); ++iter )
	{
		sXML << "<ARTICLEMEMBERCOUNT TYPE='" << iter->first << "'>" << iter->second << "</ARTICLEMEMBERCOUNT>";

		if ( pRows )
		{
			*pRows += iter->second;
		}
	}

	return bOk;
}


/*********************************************************************************
bool CCategory::AddArticleMemberXML(CStoredProcedure& SP, CTDVString& sXML)
Inputs:		SP - stored procedure object to use for db queries
Outputs:	sXML - resulting xml
Returns:	true on success
Purpose:	Builds ARTICLEMEMBER xml based on current row in SP
*********************************************************************************/

bool CCategory::AddArticleMemberXML(CStoredProcedure& SP, CTDVString& sXML, ArticleKeyPhrases& articleKeyPhraseMap)
{
	CTDVString sName, sExtraInfo;
	SP.GetField("subject", sName);
	SP.GetField("extrainfo", sExtraInfo);

	EscapeXMLText(&sName);

	CArticleMember articleMember(m_InputContext);

	int iH2g2Id = SP.GetIntField("h2g2id");
	articleMember.SetH2g2Id( iH2g2Id );
	articleMember.SetName( sName );
	articleMember.SetIncludeStrippedName(true);

	// Get editor data
	CTDVString sEditor;
	SP.GetField("editor", sEditor);
	CTDVString sEditorName;
	SP.GetField("editorName", sEditorName);

	EscapeXMLText(&sEditorName);
	
	CTDVString sEditorFirstNames;
	if(!SP.GetField("EditorFirstNames", sEditorFirstNames))
	{
		TDVASSERT(false, "EditorFirstNames field not found");
	}

	CTDVString sEditorLastName;
	if(!SP.GetField("EditorLastName", sEditorLastName))
	{
		TDVASSERT(false, "EditorLastName field not found");
	}

	CTDVString sEditorArea;
	if(!SP.GetField("EditorArea", sEditorArea))
	{
		TDVASSERT(false, "EditorArea field not found");
	}

	int nEditorStatus = 0;
	if(!SP.FieldExists("EditorStatus"))
	{
		TDVASSERT(false, "EditorStatus field not found");
	} 
	else
	{
		nEditorStatus = SP.GetIntField("EditorStatus");
	}

	int nEditorTaxonomyNode = 0;
	if(!SP.FieldExists("EditorTaxonomyNode"))
	{
		TDVASSERT(false, "EditorTaxonomyNode field not found");
	} 
	else
	{
		nEditorTaxonomyNode = SP.GetIntField("EditorTaxonomyNode");
	}

	int nEditorJournal = 0;
	if(!SP.FieldExists("EditorJournal"))
	{
		TDVASSERT(false, "EditorJournal field not found");
	} 
	else
	{
		nEditorJournal = SP.GetIntField("EditorJournal");
	}

	int nEditorActive = 0;
	if(!SP.FieldExists("EditorActive"))
	{
		TDVASSERT(false, "EditorActive field not found");
	} 
	else
	{
		nEditorActive = SP.GetIntField("EditorActive");
	}

	CTDVString sEditorSiteSuffix;
	if(!SP.GetField("EditorSiteSuffix", sEditorSiteSuffix))
	{
		TDVASSERT(false, "EditorSiteSuffix field not found");
	}

	CTDVString sEditorTitle;
	if(!SP.GetField("EditorTitle", sEditorTitle))
	{
		TDVASSERT(false, "EditorTitle field not found");
	}	
	
	// Set it
	articleMember.SetEditor(sEditor, 
		sEditorName, 
		sEditorFirstNames, 
		sEditorLastName, 
		sEditorArea, 
		nEditorStatus, 
		nEditorTaxonomyNode, 
		nEditorJournal, 
		nEditorActive, 
		sEditorSiteSuffix, 
		sEditorTitle);

	articleMember.SetStatus( SP.GetIntField("status") );
	if (SP.FieldExists("type"))
	{
		articleMember.SetExtraInfo( sExtraInfo, SP.GetIntField("type") );
	}
	else
	{
		articleMember.SetExtraInfo( sExtraInfo );
	}

	articleMember.SetDateCreated( SP.GetDateField("datecreated") );
	articleMember.SetLastUpdated( SP.GetDateField("lastupdated") );
		

	if (m_iMemberCrumbTrails == 1)
	{
		if (SP.FieldExists("Local")
			&& SP.GetIntField("Local"))
		{
			articleMember.SetLocal();
		}
	}

	if ( SP.FieldExists("CRPollID") )
	{
		articleMember.SetContentRatingStatistics(SP.GetIntField("CRPollID"), 
			SP.GetIntField("CRVoteCount"), 
			SP.GetDoubleField("CRAverageRating"));
	}

	if ( SP.FieldExists("MediaAssetID") )
	{
		CTDVString sCaption="";
		if(!SP.GetField("Caption", sCaption))
		{
			TDVASSERT(false, "Caption field not found");
		}	
		CTDVString sExtraElementXML="";
		if(!SP.GetField("ExtraElementXML", sExtraElementXML))
		{
			TDVASSERT(false, "ExtraElementXML field not found");
		}	
		CTDVString sExternalLinkURL="";
		if(!SP.GetField("ExternalLinkURL", sExternalLinkURL))
		{
			TDVASSERT(false, "ExternalLinkURL field not found");
		}	
		articleMember.SetMediaAssetInfo(SP.GetIntField("MediaAssetID"),
										SP.GetIntField("ContentType"),
										sCaption,
										SP.GetIntField("MimeType"),
										SP.GetIntField("OwnerID"),
										sExtraElementXML,
										SP.GetIntField("Hidden"),
										sExternalLinkURL);
	}
	
	bool bIncludeKeyPhraseData = m_InputContext.DoesCurrentSiteHaveSiteOptionSet("KeyPhrases", "ReturnInCategoryList");
	if (bIncludeKeyPhraseData)
	{
		int iEntryId = SP.GetIntField("entryid");
		articleMember.SetPhraseList(articleKeyPhraseMap[iEntryId]);
	}

	// Build XML for article member and get as string
	if(!articleMember.GetAsXML(sXML))
	{
		TDVASSERT(false, "CCategory::AddArticleMemberXML() articleMember.GetAsXML failed");
		return false;
	}

	return true;
}


/*********************************************************************************

	bool CCategory::GetClubMembersForNodeID(int iNodeID, CTDVString& sXML)

		Author:		Mark Howitt
        Created:	08/04/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CCategory::GetClubMembersForNodeID(int iNodeID, CTDVString& sXML, int* pRows, int iShow/*=0*/, int iSkip/*=0 */)
{
	// Check the NodeID!
	if (iNodeID == 0)
	{
		return SetDNALastError("CCategory","NoNodeIDGiven","Illegal NodeID");
	}

	// Setup the StoredProcedure 
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CCategory","FailedToInitStoredProcedure","Failed to intialise Stored ComponentSP");
	}

	// Now get the node articles for the given list id
	bool bHaveResults = false;
	int iUserTaxonomyNodeID = 0;
	CUser* pUser = m_InputContext.GetCurrentUser();
	if (m_iMemberCrumbTrails && pUser)
	{
		pUser->GetTaxonomyNode(&iUserTaxonomyNodeID);
		if (!SP.GetHierarchyNodeClubsWithLocal(iNodeID, iUserTaxonomyNodeID))
		{
			return SetDNALastError("CCategory","GetHierarchyNodeClubs","Failed getting clubs for category node");
		}
	}
	else
	{
		if (!SP.GetHierarchyNodeClubs(iNodeID,bHaveResults))
		{
			return SetDNALastError("CCategory","GetHierarchyNodeClubs","Failed getting clubs for category node");
		}
	}
	

	// Add all the articles	
	//Skip over however many we need to skip
	if ( iSkip > 0  )
	{	
		//int iLastClubID = 0;		
		if (!SP.IsEOF())
		{
			int iLastClubID = 0; 			
			int iCurClubID = 0;
			iCurClubID = iLastClubID = SP.GetIntField("ClubID");
			int iTempSkip = iSkip;	
			while (!SP.IsEOF() && iTempSkip)
			{			
				SP.MoveNext();			
				iCurClubID = SP.GetIntField("ClubID");
				if (iCurClubID != iLastClubID)
				{			
					--iTempSkip;			
					iLastClubID = iCurClubID;			
				}				
			}
		}
	}

	int iCount = 0;
	if ( !SP.IsEOF() )
	{		
		iCount = SP.GetIntField("COUNT");
	}

	//Add Club Members
	bool bOk = true;
	while (bOk && !SP.IsEOF())
	{
		bool bMovedToNextRec = false;
		bOk = AddClubMemberXML(SP, true, sXML, bMovedToNextRec);

		if ( bMovedToNextRec == false)
		{
			SP.MoveNext();
		}

		if ( iSkip > 0  )
		{
			iShow--;
			if ( iShow == 0 )
			{
				break;
			}
		}			
	}

	//Add Club Member count.
	sXML << "<CLUBMEMBERCOUNT TYPE='1001'>" << iCount << "</CLUBMEMBERCOUNT>";
	if ( pRows )
	{
		*pRows = iCount;
	}

	return bOk;
}


/*********************************************************************************
bool CCategory::AddClubMemberXML(CStoredProcedure& SP, bool bAddStrippedXML, CTDVString& sXML)
Inputs:		SP - stored procedure object to use for db queries
				bAddStrippedXML - Whether to add STRIPPEDNAME or not
				bMovedToNextRec - true if the cursor was advanced one step forward as a resukt of calling this method, false otherwise
Outputs:	sXML - resulting xml
Returns:	true on success
Purpose:	Builds CLUBMEMBER xml based on current row in SP
*********************************************************************************/

bool CCategory::AddClubMemberXML(CStoredProcedure& SP, bool bAddStrippedXML, CTDVString& sXML, bool& bMovedToNextRec)
{
	CClubMember clubMember(m_InputContext);

	CTDVString sName, sExtraInfo;
	// Some SPs use the 'name' field, others use the 'subject' field
	if (SP.FieldExists("Name"))
	{
		SP.GetField("Name", sName);
	}
	else
	{
		SP.GetField("Subject", sName);
	}
	SP.GetField("ExtraInfo", sExtraInfo);
	EscapeXMLText(&sName);

	// Populate the CClubMember object
	//
	clubMember.Clear();
	int iClubID = SP.GetIntField("ClubID");
	clubMember.SetClubId( iClubID );
	clubMember.SetName( sName );
	if (bAddStrippedXML)
	{
		clubMember.SetIncludeStrippedName(true);
	}

	if (SP.FieldExists("type"))
	{
		clubMember.SetExtraInfo( sExtraInfo, SP.GetIntField("type") );
	}
	else
	{
		clubMember.SetExtraInfo( sExtraInfo );
	}

	// Dates
	if (SP.FieldExists("DateCreated"))
	{
		clubMember.SetDateCreated( SP.GetDateField("DateCreated") );
	}
	
	//Club LastUpdated is most recent of club, clubs article and clubs journal.
	CTDVDateTime dArticleLastUpdated;
	CTDVDateTime dClubForumLastUpdated;
	CTDVDateTime dClubLastUpdated;
	if ( SP.FieldExists("ClubLastUpdated") )
	{
		dClubLastUpdated = SP.GetDateField("ClubLastUpdated");
	}
	if ( SP.FieldExists("LastUpdated") )
	{
		dArticleLastUpdated = SP.GetDateField("LastUpdated");
	}
	if ( SP.FieldExists("ClubForumLastUpdated") )
	{
		dClubForumLastUpdated = SP.GetDateField("ClubForumLastUpdated");
	}
	
	if ( dArticleLastUpdated > dClubLastUpdated )
		dClubLastUpdated = dArticleLastUpdated;
	if ( dClubForumLastUpdated > dClubLastUpdated ) 
		dClubLastUpdated = dClubForumLastUpdated;
	clubMember.SetLastUpdated( dClubLastUpdated );

	if (m_iMemberCrumbTrails == 1)
	{
		if (SP.FieldExists("Local")
			&& SP.GetIntField("Local"))
		{
			clubMember.SetLocal();
		}
	}

	return clubMember.GetAsXML(SP, sXML, bMovedToNextRec );
}

/*********************************************************************************

	bool CCategory::GetNoticesForNodeID(int iNodeID, CTDVString& sXML)

		Author:		Martin Robb.
        Created:	03/02/2005
        Inputs:		- iNodeID, iShow, iSkip
        Outputs:	- sXML - ouput xml	
        Returns:	- false on error
        Purpose:	- Produce XML for notice board posts tagged to the specified node.
					  Produces <NOTICE\> XML members
*********************************************************************************/
bool CCategory::GetNoticesForNodeID(int iNodeID, CTDVString& sXML, int iShow, int iSkip )
{
	bool bOk = true;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);

	if ( !SP.GetNoticeBoardPostsForNode(iNodeID,m_InputContext.GetSiteID()) )
	{
		SetDNALastError("CCategory","GetNoticeBoardPostsForNode","SP.GetNoticeBoardPostsForNode failed");
		return false;
	}

	if ( iSkip > 0  )
	{		
		SP.MoveNext(iSkip);	
	}

	InitialiseXMLBuilder(&sXML,&SP);
	//OpenXMLTag("NOTICES");

	int iCount = 0;
	while ( !SP.IsEOF() )
	{
		//Add Notice XML
		OpenXMLTag("Notice",true);
		AddDBXMLAttribute("Type","Type",true,true,true);
		CNotice notice(m_InputContext);
		bOk = bOk && notice.Initialise(SP,sXML);
		CloseXMLTag("Notice");

		SP.MoveNext();
		++iCount;
		if ( iSkip > 0  )
		{
			iShow--;
			if ( iShow == 0 )
			{
				break;
			}
		}
	}

	//CloseXMLTag("Notices");

	//Add Notice Board Member count.
	bOk = bOk && AddXMLIntTag("NOTICEMEMBERCOUNT",iCount);
	return bOk;
}

/*********************************************************************************

	bool CCategory::GetUsersForNodeID(int iNodeID, CTDVString& sXML)

		Author:		Martin Robb.
        Created:	10/05/2005
        Inputs:		- iNodeID, skip, show
        Outputs:	- sXML - ouput xml	
        Returns:	- false on error
        Purpose:	- Produce XML for users posts tagged to the specified node.
					  Produces <USER\> XML members
*********************************************************************************/
bool CCategory::GetUsersForNodeID(int iNodeID, CTDVString& sXML, int iShow, int iSkip )
{
	bool bOk = true;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);

	if ( !SP.GetUsersForNode(iNodeID,m_InputContext.GetSiteID()) )
	{
		SetDNALastError("CCategory","GetUsersForNode","SP.GetUsersForNode failed");
		AddInside("H2G2",GetLastErrorAsXMLString());
		
		return false;
	}

	if ( iSkip > 0  )
	{		
		SP.MoveNext(iSkip);	
	}

	InitialiseXMLBuilder(&sXML,&SP);

	int iCount = 0;
	while ( !SP.IsEOF() )
	{
		//Add Standard User XML
		OpenXMLTag("USER",false);
		int iuserID = SP.GetIntField("UserID");
		bOk = bOk && AddXMLIntTag("USERID",iuserID);
		bOk = bOk && AddDBXMLTag("USERNAME");
		bOk = bOk && AddDBXMLTag("FIRSTNAMES",NULL,false);
		bOk = bOk && AddDBXMLTag("LASTNAME",NULL,false);
		bOk = bOk && AddDBXMLTag("AREA",NULL,false);
		bOk = bOk && AddDBXMLTag("STATUS");
		bOk = bOk && AddDBXMLTag("TAXONOMYNODE",NULL,false);
		bOk = bOk && AddDBXMLTag("JOURNAL");
		bOk = bOk && AddDBXMLTag("ACTIVE");
		bOk = bOk && AddDBXMLTag("SITESUFFIX",NULL,false);
		bOk = bOk && AddDBXMLTag("TITLE",NULL,false);

		//Create Groups XML
		CTDVString sGroupsXML;
		m_InputContext.GetUserGroups(sGroupsXML,iuserID,m_InputContext.GetSiteID());
		sXML << sGroupsXML;

		CloseXMLTag("USER");

		SP.MoveNext();
		++iCount;
		if ( iSkip > 0  )
		{
			iShow--;
			if ( iShow == 0 )
			{
				break;
			}
		}
	}

	//Add Notice Board Member count.
	bOk = bOk && AddXMLIntTag("USERMEMBERCOUNT",iCount);

	if ( !bOk )
	{
		SetDNALastError("Category","GetUsersForNodeID","Could not create XML");
		AddInside("H2G2",GetLastErrorAsXMLString());
	}
	return bOk;
}


/*********************************************************************************

	bool CCategory::GetNodeAliasMembersForNodeID(int iNodeID, CTDVString& sXML)

		Author:		Mark Howitt
        Created:	08/04/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CCategory::GetNodeAliasMembersForNodeID(int iNodeID, CTDVString& sXML)
{
	// Check the NodeID!
	if (iNodeID == 0)
	{
		return SetDNALastError("CCategory","NoNodeIDGiven","Illegal NodeID");
	}

	// Setup the StoredProcedure 
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CCategoryList","FailedToInitStoredProcedure","Failed to intialise Stored ComponentSP");
	}

	// Now get the Aliases for the given list id
	bool bHaveResults = true;
	if (!SP.GetHierarchyNodeAliases(iNodeID,bHaveResults))
	{
		return SetDNALastError("CCategoryList","GetHierarchyNodeAliases","Failed getting subjects for category node");
	}

	// Setup some local variables
	int iLastNodeID = 0, iCurNodeID= 0;
	bool bAddedSubNodes = false;
	bool bOk = true;
	CTDVString sSubNodeName;

	// Initialise the XML Builder
	InitialiseXMLBuilder(&sXML,&SP);

	// get all the Aliases too
	while (bOk && !SP.IsEOF())
	{
		// Get the current nodeid
		iCurNodeID = SP.GetIntField("LinkNodeID");
		if (iCurNodeID != iLastNodeID)
		{
			if (iLastNodeID != 0)
			{
				if (bAddedSubNodes)
				{
					bOk = bOk && CloseXMLTag("SUBNODES");
					bAddedSubNodes = false;
				}
				bOk = bOk && CloseXMLTag("NODEALIASMEMBER");
			}

			bOk = bOk && OpenXMLTag("NODEALIASMEMBER");
			bOk = bOk && AddDBXMLIntTag("LINKNODEID");
			bOk = bOk && AddDBXMLIntTag("NODEMEMBERS","NODECOUNT");
			bOk = bOk && AddDBXMLIntTag("ARTICLEMEMBERS","ARTICLECOUNT");
			bOk = bOk && AddDBXMLIntTag("NODEALIASMEMBERS","ALIASCOUNT");
			bOk = bOk && AddDBXMLTag("DISPLAYNAME","NAME");
			if (bOk)
			{
				CXMLStringUtils::AddStrippedNameXML(SP, "DisplayName", sXML);
			}
		}

		// Check to see if it's got any subnodes!
		if (!SP.IsNULL("SubName"))
		{
			// If we havn't opened the SUbnodes Tag, do so
			if (!bAddedSubNodes)
			{
				bAddedSubNodes = true;
				bOk = bOk && OpenXMLTag("SUBNODES");
			}
			bOk = bOk && OpenXMLTag("SUBNODE",true);
			bOk = bOk && AddDBXMLIntAttribute("SubNodeID","ID",true,true);
			SP.GetField("SubName", sSubNodeName);
			EscapeXMLText(&sSubNodeName);
			bOk = bOk && CloseXMLTag("SUBNODE",sSubNodeName);
		}

		// Set the last node and move to the next result
		iLastNodeID = iCurNodeID;
		SP.MoveNext();

		// Check to see if we've reached the end of the results and need to close the subnodes!
		if (SP.IsEOF() && iLastNodeID != 0)
		{
			if (bAddedSubNodes)
			{
				bOk = bOk && CloseXMLTag("SUBNODES");
			}
			bOk = bOk && CloseXMLTag("NODEALIASMEMBER");
		}
	}

	return bOk;
}

/*********************************************************************************

	bool CCategory::SetSortOrderForNodeMembers(CXMLTree* pTree, const TDVCHAR* sParentTagName)

		Author:		Mark Howitt
        Created:	08/04/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CCategory::SetSortOrderForNodeMembers(CXMLTree* pTree, const TDVCHAR* sParentTagName)
{
	// Check the Tree Pointer
	if (pTree == NULL)
	{
		return SetDNALastError("CCategory","NULLTreePointer","NULL Tree Pointer Given!");
	}

	int iCurIndex = 0;
	CXMLTree* pMemberNode = pTree->FindFirstTagName(sParentTagName);
	CXMLTree* pFirstMember = pMemberNode->GetFirstChild();
	bool bFoundLowest = false;
	CTDVString sLowest;
	CTDVString sThisName;
	CXMLTree* pName = NULL;
	CXMLTree* pLowest = NULL;
	CXMLTree* pNode = pFirstMember;
	do
	{
		sLowest.Empty();
		pLowest = NULL;
		pNode = pFirstMember;
		bFoundLowest = false;
		while (pNode != NULL)
		{
			if (!pNode->DoesAttributeExist("SORTORDER"))
			{
				// Get the name value
				// !!! Not sure about the parent in this call...
				sThisName.Empty();
				pName = pNode->FindFirstTagName("NAME", pNode, false);
				if (pName != NULL)
				{
					pName->GetTextContents(sThisName);
				}

				if (sThisName.FindText("a ") == 0)
				{
					sThisName.RemoveLeftChars(2);
				}
				else if (sThisName.FindText("the ") == 0)
				{
					sThisName.RemoveLeftChars(4);
				}
				sThisName.MakeLower();

				// If we've already got a lowest value...
				if (bFoundLowest)
				{
					if (!sThisName.IsEmpty() && sThisName < sLowest)
					{
						pLowest = pNode;
						sLowest = sThisName;
					}
				}
				else
				{
					bFoundLowest = true;
					pLowest = pNode;
					sLowest = sThisName;
				}
			}
			pNode = pNode->GetNextSibling();
		}
		if (bFoundLowest)
		{
			pLowest->SetAttribute("SORTORDER", iCurIndex);
			iCurIndex++;
		}
	} while (bFoundLowest);

	return true;
}

/*********************************************************************************

	bool CCategory::GetDetailsForNodes(CDNAIntArray& NodeArray, const TCHAR* psTagName)

		Author:		Mark Howitt
        Created:	07/06/2004
        Inputs:		NodeArray - A list of nodes you want to get the details for.
					psTagName - An optional name for the parent tag if required.
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CCategory::GetDetailsForNodes(CDNAIntArray& NodeArray, const TCHAR* psTagName)
{
	// Check to make sure we've been given a valid list?
	if (NodeArray.GetSize() == 0)
	{
		return SetDNALastError("CCategory","NoNodesGiven","No Nodes Given To Get Details For");
	}

	// SetUp the Parent Tag Name
	CTDVString TagName = psTagName;
	if (TagName.IsEmpty())
	{
		TagName = "NODEDETAILS";
	}

	// Now get the details for the given nodes
	int iNodeID = 0;
	int iType = 0;
	CTDVString sName;
	CTDVString sDescription;
	CTDVString sXML;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	InitialiseXMLBuilder(&sXML);
	bool bOk = OpenXMLTag(TagName);
	for (int i = 0; i < NodeArray.GetSize() && bOk; i++)
	{
		// Get the details for each node in turn
		iNodeID = NodeArray.GetAt(i);
		bOk = bOk && SP.GetHierarchyNodeDetailsViaNodeID(iNodeID, &sName, &sDescription, NULL, NULL, NULL, NULL, NULL, &iType);
		bOk = bOk && OpenXMLTag("NODE",true);
		bOk = bOk && AddXMLIntAttribute("ID",iNodeID);
		bOk = bOk && AddXMLAttribute("NAME",sName,false);
		bOk = bOk && AddXMLAttribute("DESCRIPTION",sDescription,false);
		bOk = bOk && AddXMLIntAttribute("TYPE",iType,true);
		bOk = bOk && CloseXMLTag("NODE");
	}
	bOk = bOk && CloseXMLTag(TagName);

	// Create and return the verdict
	return bOk && CreateFromXMLText(sXML,NULL,true);
}


/*********************************************************************************
void CCategory::CreateHierarchyDetailsXML(CStoredProcedure& SP, CTDVString& sXML)
Inputs:		SP - stored procedure object to accuire information from
Outputs:	sXML - resulting xml
Purpose:	Creates HIERARCHYDETAILS xml. Gets data from current row in SP.
*********************************************************************************/

void CCategory::CreateHierarchyDetailsXML(CStoredProcedure& SP, CTDVString& sXML)
{
	CTDVString sDescription;
	SP.GetField("Description", sDescription);

	CTDVString Synonyms;
	SP.GetField("Synonyms", Synonyms);

	m_h2g2ID = SP.GetIntField("h2g2ID");
	m_NodeID = SP.GetIntField("NodeID");

	int iUserAdd = SP.GetIntField("UserAdd");
	int iParentID = SP.GetIntField("ParentId");
	int iTypeID = SP.GetIntField("Type");

	sXML = "<HIERARCHYDETAILS NODEID='";
	sXML << m_NodeID << "' ISROOT='";
	if (iParentID == 0)	//is root?
	{
		sXML << "1'";
	}
	else
	{
		sXML << "0'";
	}

	sXML << " USERADD='" << iUserAdd << "'";
	sXML << " TYPE='" << iTypeID << "'";
	sXML << ">";
	
	EscapeXMLText(&m_NodeName);
	EscapeXMLText(&Synonyms);
	sXML << "<DISPLAYNAME>" << m_NodeName << "</DISPLAYNAME>";
	if (m_NodeID > 0)
	{
		sXML << "<DESCRIPTION>" << sDescription << "</DESCRIPTION>";
		sXML << "<SYNONYMS>" << Synonyms << "</SYNONYMS>";
		if (m_h2g2ID > 0)
		{
			sXML << "<H2G2ID>" << m_h2g2ID << "</H2G2ID>";
		}

		// Check to see if the node is being redirected
		if (SP.FieldExists("RedirectNodeID") && !SP.IsNULL("RedirectNodeID"))
		{
			CTDVString sDisplayName = "";
			SP.GetField("RedirectNodeName",sDisplayName);
			sXML << "<REDIRECTNODE ID='" << SP.GetIntField("RedirectNodeID") << "'>" << sDisplayName << "</REDIRECTNODE>";
		}
	}

	sXML << "</HIERARCHYDETAILS>";
}


/*********************************************************************************
bool CCategory::GetHierarchyCloseMembers(CStoredProcedure& SP, int iNodeId, 
	int iMaxRows, CTDVString& sXML)
Author:		Igor Loboda
Created:	13/06/2004
Inputs:		SP - stored procedure object to use for db queries
			iNodeId - node id
			iMaxRows - maximum number of elements to be put into xml by this method
Outputs:	sXML - resulting xml
Returns:	true on success
Purpose:	Gets the list of nodes which are close to given node. For all of them
			it gets ordered list of tagged articles and clubs. For each of them it
			inserts an element into xml.
*********************************************************************************/

bool CCategory::GetHierarchyCloseMembers(CStoredProcedure& SP, int iNodeId, 
	int iMaxRows, CTDVString& sXML)
{
	if (iMaxRows <= 0)
	{
		return true;
	}

	if (!SP.GetTaggedContentForNode(iMaxRows,iNodeId))
	{
		return false;
	}

	sXML << "<CLOSEMEMBERS>";

	while (!SP.IsEOF())
	{
		CTDVString sSource;
		SP.GetField("source", sSource);

		bool bMovedToNextRec = false;
		if (sSource.CompareText("club"))
		{
			if (!AddClubMemberXML(SP, true, sXML, bMovedToNextRec))
			{
				return false;
			}
		}
		else	//article
		{
			ArticleKeyPhrases akp;
			bool bAddedMember = AddArticleMemberXML(SP, sXML, akp );

			if (!bAddedMember)
			{
				return false;
			}
		}

		if ( bMovedToNextRec == false)
		{
			SP.MoveNext();
		}
	}

	sXML << "</CLOSEMEMBERS>";

	return true;
}

bool CCategory::GetHierarchyName(const int iNode, CTDVString& sCategoryName)
{
	sCategoryName = "";
	CTDVString sCategoryDescription;
	CTDVString sSynonyms;
	int iUserAdd = 0;
	int  iNodeIDTemp = 0;
	int iTypeID=0; 	
	int iBaseLine = 0;
	int iParentID = 0;
	int iH2G2ID= 0;
	int  iSiteID = m_InputContext.GetSiteID( );

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if (!SP.GetHierarchyNodeDetailsViaNodeID(iNode, &sCategoryName, &sCategoryDescription, &iParentID, &iH2G2ID, &sSynonyms, &iUserAdd, &iNodeIDTemp, &iTypeID, &iSiteID, &iBaseLine))
	{
		return false;
	}

	return true;
}

