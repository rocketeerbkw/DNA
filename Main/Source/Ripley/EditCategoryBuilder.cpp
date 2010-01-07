
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
#include "EditCategoryBuilder.h"
#include "Wholepage.h"
#include "Search.h"
#include "PageUI.h"
#include "User.h"
#include "Category.h"
#include "EditCategory.h"
#include "GuideEntry.h"
#include "TDVAssert.h"
#include ".\TagItem.h"
#include "Postcodeparser.h"
#include "Notice.h"

CEditCategoryBuilder::CEditCategoryBuilder(CInputContext& inputContext)
:CXMLBuilder(inputContext), m_iTagMode(0)
{
	
}

CEditCategoryBuilder::~CEditCategoryBuilder()
{

}

bool CEditCategoryBuilder::Build(CWholePage* pPage)
{
	CCategory	Category(m_InputContext); // holds the hierarchy information from the given nodeid
	CEditCategory EditCategory(m_InputContext); //holds the information
	CUser*		pViewer = NULL;
	bool		bSuccess = true;

	if(!InitPage(pPage, "EDITCATEGORY",true))
	{
		return false;
	}

	// get the viewing user
	pViewer = m_InputContext.GetCurrentUser();

	
		bool bActionProcessed = false;

		//Where in the hierarchy we will display from
		int iDestinationNodeID = 0;
		
		//found out if there is a nodeid
		int iNodeID =0;
		if (m_InputContext.ParamExists("nodeid"))
		{
			iNodeID = m_InputContext.GetParamInt("nodeid");
		}
		
		//find out if there is an action
		CTDVString sAction;
		bool bActionExists = false;
		if(m_InputContext.ParamExists("action"))
		{
			bActionExists = m_InputContext.GetParamString("action",sAction);
		}
		
		//TagItemId can be provided as follows...
		//1. activenode parameter - depreciated.
		//2. tagitemid parameter if in tag mode.
		int iTagItemId = 0;
		if(m_InputContext.ParamExists("activenode"))
		{
			//ActiveNode parameter actually refers to the Id of the item to tag.
			iTagItemId = m_InputContext.GetParamInt("activenode");
		}
		else if ( m_InputContext.ParamExists("tagmode") )
		{
			iTagItemId = m_InputContext.GetParamInt("tagitemid");
		}
		
		
		//if there is no activeNode and no action then we are doing simple navigation
		if ( !iTagItemId  && !bActionExists && (iNodeID >=0))
		{
			bSuccess = bSuccess && EditCategory.Initialise(m_InputContext.GetSiteID());
		}
		else if (bActionExists && bSuccess)
		{	
			//there is something to do so let EditCategory deal with it and find out where it wants to display the hierarchy from 
			bSuccess = bSuccess && EditCategory.Initialise(m_InputContext.GetSiteID());
			bSuccess = ProcessAction(sAction,iTagItemId,iNodeID,iDestinationNodeID,&EditCategory,pPage,bActionProcessed);
				
		}
		else
		{
			bSuccess = false;
		}

		if(bSuccess)
		{
			bSuccess = bSuccess && Category.InitialiseViaNodeID(iDestinationNodeID, m_InputContext.GetSiteID());
			int h2g2ID = Category.Geth2g2ID();
			bSuccess = bSuccess && EditCategory.AddInside("EDITCATEGORY",&Category);

			if (h2g2ID > 0)
			{
				CGuideEntry GuideEntry(m_InputContext);
				GuideEntry.Initialise(h2g2ID, m_InputContext.GetSiteID(), pViewer, true, true, true, true);
				EditCategory.AddInside("HIERARCHYDETAILS", &GuideEntry);
			}

			// Check to see if we're in tagmode or category mode
			if(bSuccess)
			{
				// Check to see if we're in tag mode.
				if (m_InputContext.ParamExists("tagmode"))
				{
					// Get the TagitemID and the TagType from the url
					int iTagItemID = m_InputContext.GetParamInt("tagitemid");
					CTDVString sTagItemType;
					m_InputContext.GetParamString("tagitemtype",sTagItemType);
					int iTagMode = m_InputContext.GetParamInt("tagmode");
					int iSiteID = m_InputContext.GetSiteID();
					CUser* pCurrentUser = m_InputContext.GetCurrentUser();

					// Now put it into the XML
					CTDVString sTagInfo;
					sTagInfo << "<TAGINFO MODE='" << iTagMode << "'";
					
					// Check to see if we've been given the TagItemID
					if (iTagItemID == 0)
					{
						// No, just do the default thing by putting the tagmose into the xml
						sTagInfo << "></TAGINFO>";
						bSuccess = bSuccess && EditCategory.AddInside("HIERARCHYDETAILS",sTagInfo);
					}
					else
					{
						// We have! it to the XML and then get the tagitem details as well!
						sTagInfo << " TAGITEMID='" << iTagItemID << "' TAGITEMTYPE='" << sTagItemType << "'></TAGINFO>";
						bSuccess = bSuccess && EditCategory.AddInside("HIERARCHYDETAILS",sTagInfo);

						// Now get the tag items details
						CTagItem TagItem(m_InputContext);
						bool bOk = false;
						if (sTagItemType.CompareText("USER"))
						{
							bOk = TagItem.InitialiseFromUserId(iTagItemID,iSiteID,pCurrentUser);
						}
						else if (sTagItemType.CompareText("THREAD"))
						{
							bOk = TagItem.InitialiseFromThreadId(iTagItemID,iSiteID,pCurrentUser);
						}
						else
						{
							bOk = TagItem.InitialiseItem(iTagItemID,m_InputContext.GetParamInt("tagitemtype"),iSiteID,pCurrentUser);
						}

						if (!bOk)
						{
							// Get the error from the object
							bSuccess = bSuccess && EditCategory.AddInside("HIERARCHYDETAILS/TAGINFO",TagItem.GetLastErrorAsXMLString());
						}

						//Get taginfo
						CTDVString sDetailsXML;
						TagItem.GetItemDetailsXML(sDetailsXML);
						bSuccess = bSuccess && EditCategory.AddInside("HIERARCHYDETAILS/TAGINFO",sDetailsXML);

						// Get all the nodes that the item is currently tagged to.
						if (bOk && TagItem.GetAllNodesTaggedForItem())
						{
							// Put the results into the XML
							bSuccess = bSuccess && EditCategory.AddInside("HIERARCHYDETAILS/TAGINFO",&TagItem);
						}
						else
						{
							// Get the error from the object
							bSuccess = bSuccess && EditCategory.AddInside("HIERARCHYDETAILS/TAGINFO",TagItem.GetLastErrorAsXMLString());
						}

						// Get all the nodes that the user has ever tagged to.
						if (bOk && TagItem.GetNodesUserHasTaggedTo())
						{
							// Put the results into the XML
							bSuccess = bSuccess && EditCategory.AddInside("HIERARCHYDETAILS/TAGINFO",&TagItem);
						}
						else
						{
							// Get the error from the object
							bSuccess = bSuccess && EditCategory.AddInside("HIERARCHYDETAILS/TAGINFO",TagItem.GetLastErrorAsXMLString());
						}
					}
				}
				
				// Check to see if we're adding category nodes to cat lists
				if (m_InputContext.ParamExists("catlistid"))
				{
					CTDVString sCatList, sGUID;
					m_InputContext.GetParamString("catlistid",sGUID);
					sCatList << "<CATEGORYLIST MODE='1' GUID='" << sGUID << "'/>";
					bSuccess = bSuccess && EditCategory.AddInside("HIERARCHYDETAILS",sCatList);
				}
			}
		}
		
		//add the editcategory to the wholepage
		if (bSuccess)
		{
			bSuccess = bSuccess && pPage->AddInside("H2G2",&EditCategory);
		}

		{//add search functionality 								
		// Get the TagitemID and the TagType from the url
		int iTagItemID = m_InputContext.GetParamInt("tagitemid");
		CTDVString sTagItemType;
		m_InputContext.GetParamString("tagitemtype",sTagItemType);
		int iTagMode = m_InputContext.GetParamInt("tagmode");
		int iSiteID = m_InputContext.GetSiteID();
		int iActiveNode = m_InputContext.GetParamInt("activenode");
		CUser* pCurrentUser = m_InputContext.GetCurrentUser();

		CTDVString sActiveNode(iActiveNode), sNodeID(iNodeID), sTagMode(iTagMode), sTagItemID(iTagItemID);
		bSuccess = bSuccess && pPage->AddInside("H2G2","<SEARCH></SEARCH>");
		bSuccess = bSuccess && pPage->AddInside("H2G2/SEARCH", "<ACTION>" + sAction + "</ACTION>");
		bSuccess = bSuccess && pPage->AddInside("H2G2/SEARCH", "<NODEID>" + sNodeID + "</NODEID>");
		bSuccess = bSuccess && pPage->AddInside("H2G2/SEARCH", "<ACTIVENODE>" + sActiveNode + "</ACTIVENODE>");
		bSuccess = bSuccess && pPage->AddInside("H2G2/SEARCH", "<TAGITEMID>" + sTagItemID + "</TAGITEMID>");
		bSuccess = bSuccess && pPage->AddInside("H2G2/SEARCH", "<TAGMODE>" + sTagMode + "</TAGMODE>");
		bSuccess = bSuccess && pPage->AddInside("H2G2/SEARCH", "<TAGITEMTYPE>" + sTagItemType + "</TAGITEMTYPE>");

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
									SetDNALastError("CEditCategoryBuilder::Build", "CatgeoryNotFound", "Could not be found Category's Name");
									bSuccess = bSuccess && pPage->AddInside("H2G2",GetLastErrorAsXMLString());
									return false;
								}

								bSuccess = bSuccess && pPage->AddInside("H2G2/SEARCH","<SEARCHRESULTS TYPE=\"HIERARCHY\"></SEARCHRESULTS>");
								bSuccess = bSuccess && pPage->AddInside("H2G2/SEARCH/SEARCHRESULTS", "<ISPOSTCODE>1</FROMPOSTCODE>");
								bSuccess = bSuccess && pPage->AddInside("H2G2/SEARCH/SEARCHRESULTS", "<SEARCHTERM>" + sActualPostCode + "</SEARCHTERM>");


								CTDVString sSite(m_InputContext.GetSiteID( ));
								CTDVString sCatgeory(iNode);
								CTDVString sXML =  "";
								sXML += "<HIERARCHYRESULT>";
								sXML += "<NODEID>" + sCatgeory + "</NODEID>"; 
								sXML += "<DISPLAYNAME>" + sCategoryName + "</DISPLAYNAME>"; 
								sXML += "<SITEID>" + sSite + "</SITEID>"; 
								sXML += "</HIERARCHYRESULT>";
								bSuccess = bSuccess && pPage->AddInside("SEARCH/SEARCHRESULTS", sXML);

								bSearchItemsFound = true;
							}
						}
						else if ( nRes == CNotice::PR_POSTCODENOTFOUND)
						{
							SetDNALastError("CEditCategoryBuilder::Build", "PostcodeNotFound", sSearchString + " could not be found");
							bSuccess = bSuccess && pPage->AddInside("H2G2",GetLastErrorAsXMLString());
							//return true;
						}
						else if (nRes == CNotice::PR_REQUESTTIMEOUT)
						{
							SetDNALastError("CEditCategoryBuilder::Build", "RequestTimedOut", "Request timed out");
							bSuccess = bSuccess && pPage->AddInside("H2G2",GetLastErrorAsXMLString());
							//return true;
						}
					}
					else if ( oPostCodeParser.IsCloseMatch(sSearchString) )
					{
						SetDNALastError("CEditCategoryBuilder::Build", "PostCodeError", sSearchString + " looks like a post code, but it is invalid");
						bSuccess = bSuccess && pPage->AddInside("H2G2",GetLastErrorAsXMLString());
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
					bSuccess = bSuccess && pPage->AddInside("H2G2/SEARCH", &Search);
				}
			}					
		}
	}
		
	return bSuccess;
}


/*********************************************************************************

	bool ProcessAction(const CTDVString sAction,int iActiveNode,int iNodeID,int &iDestinationNodeID
						CWholePage* pPage, bool& bActionProcessed)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		Action, the activenode, the current nodeid
	Outputs:	the destination to display the hierarchy 
	Returns:	true if successful
	Purpose:	Depending on the action performs the action and returns a result

*********************************************************************************/

bool CEditCategoryBuilder::ProcessAction(const CTDVString sAction,int iActiveNode,int iNodeID,int &iDestinationNodeID, CEditCategory * const pEditCategory,
										 CWholePage* pPage,bool& bActionProcessed)
{
	if (pPage == NULL)
	{
		return false;
	}

	bActionProcessed = true;
	
	bool bIsInTagMode = m_InputContext.GetParamInt("tagmode") > 0 ? true : false;
	
	CUser* pViewer = m_InputContext.GetCurrentUser();
	
	if (sAction.CompareText("navigatesubject"))
	{
		if (!bIsInTagMode && (pViewer == NULL || !pViewer->GetIsEditor()))
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		return pEditCategory->NavigateWithSubject(iActiveNode,iNodeID,iDestinationNodeID);
	}

	//you can do this if you are an editor or you are in tagmode
	if (sAction.CompareText("navigatearticle"))
	{
		if (!bIsInTagMode && (pViewer == NULL || !pViewer->GetIsEditor()))
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		int iDelNodeID = m_InputContext.GetParamInt("delnode");
		return pEditCategory->NavigateWithArticle(iActiveNode,iNodeID,iDelNodeID,iDestinationNodeID);
	}
	
	if (sAction.CompareText("navigateclub"))
	{
		if (!bIsInTagMode && (pViewer == NULL || !pViewer->GetIsEditor()))
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}

		int iDelNodeID = m_InputContext.GetParamInt("delnode");
		return pEditCategory->NavigateWithClub(iActiveNode,iNodeID,iDelNodeID,iDestinationNodeID);
	}
	
	if (sAction.CompareText("navigatealias"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		int iDelNodeID = m_InputContext.GetParamInt("delnode");
		return pEditCategory->NavigateWithAlias(iActiveNode,iNodeID,iDelNodeID,iDestinationNodeID);
		
	}

	if (sAction.CompareText("navigatethread") )
	{
		if (!bIsInTagMode && (pViewer == NULL || !pViewer->GetIsEditor()))
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}

		int iDelNodeID = m_InputContext.GetParamInt("delnode");
		return pEditCategory->NavigateWithThread(iActiveNode,iNodeID,iDelNodeID, iDestinationNodeID);
	}
	if (sAction.CompareText("navigateuser") )
	{
		if (!bIsInTagMode && (pViewer == NULL || !pViewer->GetIsEditor()))
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}

		int iDelNodeID = m_InputContext.GetParamInt("delnode");
		return pEditCategory->NavigateWithUser(iActiveNode,iNodeID,iDelNodeID, iDestinationNodeID);
	}
	
	if(sAction.CompareText("renamesubject"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		return pEditCategory->RenameSubject(iNodeID,iDestinationNodeID);
		
	}
	
	if(sAction.CompareText("renamedesc"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		return pEditCategory->ChangeDescription(iNodeID,iDestinationNodeID);
	}
	
	if(sAction.CompareText("addsubject"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		return pEditCategory->AddSubject(iNodeID,iDestinationNodeID);
	}
	
	//moves the alias to the new location and deletes from the previous location
	if(sAction.CompareText("storealias"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		int iDelNodeID = m_InputContext.GetParamInt("delnode");
		return pEditCategory->StoreAlias(iActiveNode,iNodeID,iDelNodeID,iDestinationNodeID);
		
	}
	
	if(sAction.CompareText("doaddalias"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		return pEditCategory->DoAddAlias(iActiveNode,iNodeID,iDestinationNodeID);
	}
	
	if(sAction.CompareText("storesubject"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		return pEditCategory->MoveSubject(iActiveNode,iNodeID,iDestinationNodeID);
	}
	
	if(sAction.CompareText("storearticle"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		int iDelNodeID = m_InputContext.GetParamInt("delnode");
		return pEditCategory->StoreArticle(iActiveNode,iNodeID,iDelNodeID,iDestinationNodeID);
	}
	
	if(sAction.CompareText("storeclub"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		int iDelNodeID = m_InputContext.GetParamInt("delnode");
		return pEditCategory->StoreClub(iActiveNode,iNodeID,iDelNodeID,iDestinationNodeID);
	}
	
	if (sAction.CompareText("doaddarticle"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		CTDVString sh2g2ID;
		int iH2G2ID = 0;
		
		m_InputContext.GetParamString("h2g2ID",sh2g2ID);
		// get the h2g2ID from the request
		
		CGuideEntry::GetH2G2IDFromString(sh2g2ID,&iH2G2ID);
		
		return pEditCategory->AddNewArticle(iH2G2ID,iNodeID,iDestinationNodeID);
	}
	
	if (sAction.CompareText("doaddclub"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		CTDVString sClubID;
		int iClubID = 0;
		
		m_InputContext.GetParamString("ClubID",sClubID);
		// get the h2g2ID from the request
		
		iClubID = atoi(sClubID);
		bool bSuccess = false;
		return pEditCategory->AddNewClub(iClubID,iNodeID,iDestinationNodeID,bSuccess);
	}		
	
	if(sAction.CompareText("dorenamesubject"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		CTDVString sNewSubjectName;
		if (m_InputContext.GetParamString("subject",sNewSubjectName))
		{
			return pEditCategory->DoRenameSubject(iNodeID,iDestinationNodeID, sNewSubjectName);
		}
		
		return false;
	}
	
	if (sAction.CompareText("doupdatesynonyms"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		CTDVString sSynonyms;
		if (m_InputContext.GetParamString("synonyms",sSynonyms))
		{
			return pEditCategory->DoUpdateSynonyms(iNodeID, sSynonyms,iDestinationNodeID);
		}
		
		return false;
		
	}
	
	if(sAction.CompareText("dochangedesc"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		CTDVString sNewDescription;
		if (m_InputContext.GetParamString("description",sNewDescription))
		{
			return pEditCategory->DoChangeDescription(iNodeID,iDestinationNodeID,sNewDescription);
		}
		return false;
	}
	
	if(sAction.CompareText("doaddsubject"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		CTDVString sNewSubject;
		int iNewSubjectID;
		
		if (m_InputContext.GetParamString("subject",sNewSubject))
		{
			return pEditCategory->DoAddSubject(iNodeID,iDestinationNodeID,sNewSubject,iNewSubjectID);
		}
		return false;
	}
	
	if(sAction.CompareText("doupdateuseradd"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		if (m_InputContext.ParamExists("useradd"))
		{
			int iUserAdd = m_InputContext.GetParamInt("useradd");
			
			if (iUserAdd > 1)
			{
				iUserAdd = 1;
			}
			return pEditCategory->DoUpdateUserAdd(iNodeID,iUserAdd,iDestinationNodeID);
		}
		
		return false;
	}
	
	if(sAction.CompareText("delarticle"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		return pEditCategory->DeleteArticle(iActiveNode,iNodeID,iDestinationNodeID);
	}
	
	if(sAction.CompareText("delclub"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		return pEditCategory->DeleteClub(iActiveNode,iNodeID,iDestinationNodeID);
	}
	
	if(sAction.CompareText("delsubject"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		return pEditCategory->DeleteSubject(iActiveNode,iNodeID,iDestinationNodeID);
	}
	
	if(sAction.CompareText("delalias"))
	{
		if (pViewer == NULL || !pViewer->GetIsEditor())
		{
			pPage->SetPageType("ERROR");
			pPage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot edit the hierarchy unless you are logged in as an Editor.</ERROR>");
			bActionProcessed = false;
			return true;
		}
		
		return pEditCategory->DeleteAlias(iActiveNode,iNodeID,iDestinationNodeID);
	}
	
	//haven't dealt with the action so return false
	bActionProcessed = false;
	return false;
}