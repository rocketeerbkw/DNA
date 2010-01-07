// TagItemBuilder.cpp: implementation of the CTagItemBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "TagItemBuilder.h"
#include "TagItem.h"
#include "GuideEntry.h"
#include "Category.h"
#include "EventQueue.h"
#include "Club.h"
#include "HierarchyNodeTyperBuilder.h"
#include ".\EMailAlertList.h"
#include "Search.h"
#include "postcodeparser.h"
#include "Notice.h"
#include "XMLStringUtils.h"
#include "XMLObject.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CTagItemBuilder::CTagItemBuilder(CInputContext& inputContext):
				 CXMLBuilder(inputContext),m_pPage(NULL)
{
}

CTagItemBuilder::~CTagItemBuilder()
{
}

/*********************************************************************************

	CWholePage* CTagItemBuilder::Build()

	Author:		Mark Howitt
	Created:	11/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Creates the Tag Item Pages.
				The URL must ALWAYS include the following...
					"TagItem?tagitemtype=###&tagitemid=***"
					where ### is the item type. e.g. 1 = Article, 1001 = club,
					to see all types, refer to GuideEntry.h and the enum within.

				To preform actions the URL must include the following...
					"action=add&tagorigin=###" Adds the item to the
						node where ### = nodeid.

					"action=remove&tagorigin=###" Removes the item from
						the node where ## = nodeid

					"action=move&tagorigin=###&tagdestination=***" Moves the item
						from one node to another where ## is the nodeid of the
						source and *** is the nodeid of the destination

*********************************************************************************/

bool CTagItemBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	// Create and initialize the page
	if (!InitPage(m_pPage, "TAGITEM", true))
	{
		TDVASSERT(false, "Failed To Build Tag Item Page");
		return false;
	}

	// Setup some local variables
	CTDVString sError = "ErrorBuildingPage";
	CTDVString sSubject;
	bool bOk = true;

	// Get the current user info
	bool bIsAuthorised = false;
	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	// Add the page tags
	m_pPage->AddInside("H2G2","<TAGITEM-PAGE></TAGITEM-PAGE>");

	// Make sure the URL has a type and id! These are must haves!
	int iItemType = m_InputContext.GetParamInt("tagitemtype");
	int iItemID = m_InputContext.GetParamInt("tagitemid");
	int iThreadID = m_InputContext.GetParamInt("threadid");
	int iUserID = m_InputContext.GetParamInt("Userid");
	
	int iSiteID = m_InputContext.GetSiteID();

	CTDVString sAction;
	CTagItem TagItem(m_InputContext);

	CTDVString sItemType(iItemType);
	CTDVString sItemID(iItemID);
	
	m_pPage->AddInside("H2G2","<SEARCH></SEARCH>");
	m_pPage->AddInside("H2G2/SEARCH", "<TAGITEMTYPE>" + sItemType + "</TAGITEMTYPE>");
	m_pPage->AddInside("H2G2/SEARCH", "<TAGITEMID>" + sItemID + "</TAGITEMID>");

	if ( m_InputContext.ParamExists("searchstring")  )
	{				

		CTDVString sSearchString = "";
		CTDVString sSearchType   = "";
		bool bGotSearchString = m_InputContext.GetParamString("searchstring", sSearchString);

		//search type is always assumed to be hierarchial
		if ( bGotSearchString)
		{						
			bool bSearchItemsFound = false;
			//detect postcode searches
			if ( m_InputContext.GetAllowPostCodesInSearch() > 0  )
			{
				//detect if string is a postcode
				CPostCodeParser oPostCodeParser ;		
				if (oPostCodeParser.IsPostCode(sSearchString))
				{			
					CTDVString sActualPostCode ="";
					CTDVString sActualPostCodeXML = "";
					int iNode=0;
					CNotice oNotice(m_InputContext);

					int nRes =  oNotice.GetDetailsForPostCodeArea(sSearchString, iSiteID, iNode, sActualPostCode, sActualPostCodeXML);
					if (nRes == CNotice::PR_REQUESTOK)
					{
						if (iNode)
						{
							CTDVString sCategoryName;						
							CCategory oCategory(m_InputContext);		
							if ( oCategory.GetHierarchyName(iNode, sCategoryName) == false)
							{
								SetDNALastError("CTagItemBuilder::Build", "CatgeoryNotFound", "Could not be found Category's Name");
								m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
								return false;
							}

							m_pPage->AddInside("H2G2/SEARCH","<SEARCHRESULTS TYPE=\"HIERARCHY\"></SEARCHRESULTS>");
							m_pPage->AddInside("H2G2/SEARCH/SEARCHRESULTS", "<ISPOSTCODE>1</FROMPOSTCODE>");
							m_pPage->AddInside("H2G2/SEARCH/SEARCHRESULTS", "<SEARCHTERM>" + sActualPostCode + "</SEARCHTERM>");

							CTDVString sSite(m_InputContext.GetSiteID( ));
							CTDVString sCatgeory(iNode);
							CTDVString sXML =  "";
							sXML += "<HIERARCHYRESULT>";
							sXML += "<NODEID>" + sCatgeory + "</NODEID>"; 
							sXML += "<DISPLAYNAME>" + sCategoryName + "</DISPLAYNAME>"; 
							sXML += "<SITEID>" + sSite + "</SITEID>"; 
							sXML += "</HIERARCHYRESULT>";
							bOk = bOk && m_pPage->AddInside("H2G2/SEARCH/SEARCHRESULTS", sXML);

							bSearchItemsFound = true;
						}
					}
					else if ( nRes == CNotice::PR_POSTCODENOTFOUND)
					{
						SetDNALastError("CTagItemBuilder::Build", "PostcodeNotFound", sSearchString + " could not be found");
						bOk = bOk && m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
						//return true;
					}
					else if (nRes == CNotice::PR_REQUESTTIMEOUT)
					{
						SetDNALastError("CTagItemBuilder::Build", "RequestTimedOut", "Request timed out");
						bOk = bOk && m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
						//return true;
					}
				}
				else if ( oPostCodeParser.IsCloseMatch(sSearchString) )
				{
					SetDNALastError("CTagItemBuilder::Build", "PostCodeError", sSearchString + " looks like a post code, but it is invalid");
					bOk = bOk && m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
					//return true;
				}
			}
			
			if ( bSearchItemsFound == false)
			{
				int iSkip = m_InputContext.GetParamInt("skip");
				int iShow = m_InputContext.GetParamInt("show");
				if (iShow == 0)
				{
					// default case... show 20 search results at a time
					iShow = 20;
				}

				CSearch Search(m_InputContext);
				Search.InitialiseHierarchySearch(sSearchString,iSiteID,iSkip,iShow);
				
				//Add Search results to page.
				bOk = bOk && m_pPage->AddInside("H2G2/SEARCH", &Search);
			}
		}					
	}

	{//include the child location nodes to the user's location node 		
		if (pViewingUser && pViewingUser->IsUserLoggedIn( ))
		{
			// Set up the XML Block for the suggest nodes
			CTDVString sSuggestedXML = "<SUGGESTEDNODES>";
			int iSuggestedNodeID = m_InputContext.GetParamInt("suggestednodeid");
			if (iSuggestedNodeID > 0)
			{
				// Get the child nodes for the suggested
				sSuggestedXML << "<SUGGESTEDNODEID>" << iSuggestedNodeID << "</SUGGESTEDNODEID>";
				CCategory Category(m_InputContext);
				if (!Category.GetSubjectMembersForNodeID(iSuggestedNodeID, sSuggestedXML))
				{
					bOk = bOk && m_pPage->AddInside("H2G2",Category.GetLastErrorAsXMLString());
				}
			}
			sSuggestedXML << "</SUGGESTEDNODES>";
			bOk = bOk && m_pPage->AddInside("H2G2/TAGITEM-PAGE",sSuggestedXML);

/*
			CTDVString sPostCodeToFind;
			CTDVString sActualPostCodeXML;
			if (pViewingUser->GetPostcode(sPostCodeToFind))
			{
				int iNode=0;
				CNotice oNotice(m_InputContext);

				CTDVString sTemp = sPostCodeToFind;	
				sPostCodeToFind = "";
				int nRes =  oNotice.GetDetailsForPostCodeArea(sTemp, iSiteID, iNode, sPostCodeToFind, sActualPostCodeXML);
				if (nRes == CNotice::PR_REQUESTOK)
				{
					if (iNode)
					{
						CTDVString sCategoryName;
						CCategory oCategory(m_InputContext);
						if ( oCategory.GetHierarchyName(iNode, sCategoryName) == true)
						{
							CTDVString sCategoryNodeID(iNode);
							bOk = bOk && m_pPage->AddInside("H2G2/USERLOCATION", "<NODEID>" +  sCategoryNodeID + "</NODEID>");
							bOk = bOk && m_pPage->AddInside("H2G2/USERLOCATION", "<NAME>" +  sCategoryName + "</NAME>");
							
							CTDVString sXML;
							CCategory oCategory(m_InputContext);							
							if (oCategory.GetSubjectMembersForNodeIDEx(iNode, sXML) == false)
							{
								SetDNALastError("CTagItemBuilder::Build", "FailedToGetSubjectsInCategory", "Failed to get subjects in category");
								m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
								return false;
							}

							//Add Search results to page.							
							bOk = bOk && m_pPage->AddInside("H2G2/USERLOCATION", sXML);
						}
						else
						{
							SetDNALastError("CTagItemBuilder::Build", "CatgeoryNotFound", "Could not be found Category's Name");
							m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
							return false;
						}
						else
						{
							SetDNALastError("CTagItemBuilder::Build", "CatgeoryNotFound", "Could not be found Category's Name");
							m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
							return false;
						}
					}
				}
			}
			*/
		}
	}

	// Check to see if the site is closed or we're an editor
	bool bSiteClosed = true;
	if ((m_InputContext.IsSiteClosed(iSiteID,bSiteClosed) && !bSiteClosed) || pViewingUser->GetIsEditor())
	{
		//Site Limits.
		bool bUserCanSetLimits = (pViewingUser != NULL && (pViewingUser->GetIsEditor() || pViewingUser->GetIsSuperuser()));
		if ( m_InputContext.ParamExists("sitelimits") && bUserCanSetLimits )
		{
			// Check to see if we are trying to set the limits
			if (m_InputContext.ParamExists("action"))
			{
				if (m_InputContext.GetParamString("action",sAction))
				{
					if ( sAction.CompareText("setlimit") && m_InputContext.ParamExists("Limit") &&  m_InputContext.ParamExists("NodeType") )
					{
						int iNodeType = m_InputContext.GetParamInt("NodeType");
						int iLimit = m_InputContext.GetParamInt("Limit");
						if ( 1 == m_InputContext.GetParamInt("thread") )
						{
							//Setting Tag Limits for a thread.
							bOk = bOk && TagItem.SetTaggingLimitsForThread(pViewingUser, iNodeType, iLimit, iSiteID );
						}
						else if ( 1 == m_InputContext.GetParamInt("user") )
						{
							//Set Tagging Limits for a User.
							bOk = bOk && TagItem.SetTaggingLimitsForUser(pViewingUser, iNodeType, iLimit, iSiteID );
						}
						else if ( m_InputContext.ParamExists("ItemType") )
						{
							// Setting Tag Limits for a Typed Article. 
							int iItemType = m_InputContext.GetParamInt("ItemType");
							bOk = bOk && TagItem.SetTaggingLimitsForItem(pViewingUser,iItemType,iNodeType,iLimit,iSiteID);
						}
					}
				}
			}

			// Now get the siteinfo
			m_pPage->SetAttribute("TAGITEM-PAGE","MODE","EDITOR");
			bOk = bOk && TagItem.GetTagLimitInfo(iSiteID);
			m_pPage->AddInside("TAGITEM-PAGE",&TagItem);

			// Report failure.
			if (!bOk)
			{
				m_pPage->AddInside("H2G2",TagItem.GetLastErrorAsXMLString());
			}
			return true;
		}

		/************** Add / Remove / Move Item/Thread from specified Node(s) ***********************/
		if ( iThreadID > 0 )
		{
			//Initialise from thread.
			bOk = bOk && TagItem.InitialiseFromThreadId( iThreadID, iSiteID, pViewingUser );
		}
		else if ( iUserID > 0 )
		{
			bOk = bOk && TagItem.InitialiseFromUserId( iUserID, iSiteID, pViewingUser );
		}
		else
		{
			//Initialise from Typed Article
			bOk = bOk && TagItem.InitialiseItem(iItemID,iItemType,iSiteID,pViewingUser);
		}

		// Insert the item details into the page
		CTDVString sDetails;
		TagItem.GetItemDetailsXML(sDetails);
		m_pPage->AddInside("TAGITEM-PAGE",sDetails);

		// Get all the info from the URL
		int iFirstNodeID = m_InputContext.GetParamInt("tagorigin");
		int iSecondNodeID = m_InputContext.GetParamInt("tagdestination");
		
		// Check to see if we've been given an action
		if (bOk && m_InputContext.ParamExists("action"))
		{
			if (!m_InputContext.GetParamString("action",sAction))
			{
				SetDNALastError("CTagItemBuilder::Build","FailedToGetAction","FailedToGetAction");
				m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
				bOk = false;
			}
			else
			{
				// Check to see what action we're trying to do
				bool bValidAction = true;
				if (sAction.CompareText("add"))
				{
					if ( m_InputContext.GetParamInt("clearexisting") == 1 )
					{
						//Clear Existing Nodes before Add.
						bOk = bOk && TagItem.RemoveFromAllNodes();

						//Add Action XML if successful.
						bOk && m_pPage->AddInside("TAGITEM-PAGE",&TagItem);
					}

					bOk = bOk && TagItem.AddTagItemToNode(iFirstNodeID);
				}
				else if (sAction.CompareText("remove"))
				{
					bOk = bOk && TagItem.RemovedTagedItemFromNode(iFirstNodeID);
				}
				else if (sAction.CompareText("move"))
				{
					bOk = bOk && TagItem.MovedTagedItemFromSourceToDestinationNode(iFirstNodeID,iSecondNodeID);
				}
				else if (sAction.CompareText("addmulti"))
				{
					if ( m_InputContext.GetParamInt("clearexisting") == 1 )
					{
						//Clear Existing Nodes before Add.
						bOk = bOk && TagItem.RemoveFromAllNodes();

						//Add Action XML if successful.
						bOk && m_pPage->AddInside("TAGITEM-PAGE",&TagItem);
					}

					// Now get all the nodes that this item belongs to without creating the XML at this stage.
					// This will tell us if we've reached the tag limit for this type of item
					bOk = bOk && TagItem.GetAllNodesTaggedForItem(false);
					bOk = bOk && AddToMultipleNodes(TagItem);
				}
				else
				{
					// Don't know what the action is! Put in a default failed action result!
					m_pPage->AddInside("TAGITEM-PAGE","<ACTION RESULT='" + sAction + "Failed'/>");
					bValidAction = false;
					bOk = false;
				}

				// See if we had a valid action!
				if ( bValidAction )
				{
					// Add the TagItem even if we had an error as It contains the Action results
					m_pPage->AddInside("TAGITEM-PAGE",&TagItem);
				}
			}
		}

		// Report failure.
		if (!bOk)
		{
			m_pPage->AddInside("H2G2",TagItem.GetLastErrorAsXMLString());
		}

		// Get all the nodes that this item belongs to - ( even if action fails )
		if ( TagItem.GetAllNodesTaggedForItem() )
		{
			m_pPage->AddInside("TAGITEM-PAGE",&TagItem);
		}
		else
		{
			//Report Error
			m_pPage->AddInside("H2G2",TagItem.GetLastErrorAsXMLString());
		}
	}
	else
	{
		// Tell the user that the site is closed!
		SetDNALastError("CTagItemBuilder::Build","SiteClosed","Cannot tag when site is closed!!!");
		m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
	}

	//Create User Tag History XML - Nodes User has previously tagged to.
	CTagItem TagItemUserNodes(m_InputContext);
	if ( iThreadID ) 
	{
		bOk = TagItemUserNodes.InitialiseFromThreadId(iThreadID,iSiteID,pViewingUser);
	}
	else if ( iUserID )
	{
		bOk = TagItemUserNodes.InitialiseFromUserId(iUserID, iSiteID, pViewingUser);
	}
	else
	{
		bOk = TagItemUserNodes.InitialiseItem(iItemID,iItemType,iSiteID,pViewingUser);
	}
	bOk = bOk && TagItemUserNodes.GetNodesUserHasTaggedTo();

	if ( bOk )
	{
		m_pPage->AddInside("TAGITEM-PAGE",&TagItemUserNodes);
	}
	else
	{
		//Report Error.
		m_pPage->AddInside("H2G2",TagItemUserNodes.GetLastErrorAsXMLString());
	}

	// If we're ok, check to see if we've been given a s_returnto redirect?
	if (bOk && CheckAndUseRedirectIfGiven(m_pPage))
	{
		// We did and it went ok!
		return true;
	}

	return true;
}

/*********************************************************************************

	bool CTagItemBuilder::AddToMultipleNodes(CTagItem& TagItem)

		Author:		Mark Neves
        Created:	10/12/2004
        Inputs:		TagItem = the item we want to add to multiple nodes
        Outputs:	-
        Returns:	tre if OK, false otherwise
        Purpose:	Gathers all the "node" params into an array, and then attempts
					to tag the item to them.

*********************************************************************************/

bool CTagItemBuilder::AddToMultipleNodes(CTagItem& TagItem)
{
	// Get an array of all the "node" params supplied with the request
	CDNAIntArray NodeArray;
	int n = m_InputContext.GetParamCount("node");
	for (int i = 0; i < n; i++)
	{
		int iNodeID = m_InputContext.GetParamInt("node",i);
		if (iNodeID > 0)
		{
			NodeArray.Add(iNodeID);
		}
	}

	return TagItem.AddTagItemToMultipleNodes(NodeArray);
}
