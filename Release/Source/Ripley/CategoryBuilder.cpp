// CategoryBuilder.cpp: implementation of the CCategoryBuilder class.
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
#include "Category.h"
#include "PageUI.h"
#include "GuideEntry.h"
#include "CategoryBuilder.h"
#include "Groups.h"
#include "tdvassert.h"
#include "EMailAlertList.h"
#include "PostcodeBuilder.h"
#include "Postcoder.h"
#include "EMailAlertGroup.h"
#include "Link.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CCategoryBuilder::CCategoryBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CCategoryBuilder::~CCategoryBuilder()
{

}

bool CCategoryBuilder::Build(CWholePage* pPage)
{
	// Initialise the objects we'll need to build the page
	CCategory Category(m_InputContext);
	if(!InitPage(pPage,"CATEGORY", true))
	{
		return false;
	}

	// That's the mundane page furniture out of the way...
	int iNodeID = m_InputContext.GetParamInt("catid");

	//------------------------------------------------------------------------------------------------------------------------------------//
	int iSkip			= 0;
	int iShow			= 0;		
	CCategory::CATEGORYTYPEFILTER	iTypeFilter		= CCategory::NONE;
	int								iArticleType = 0;

	if ( iNodeID != 0 )
	{
		//Filter on Typed Article
		if ( m_InputContext.ParamExists("s_type") )
		{
			iTypeFilter = CCategory::TYPEDARTICLE;
			iArticleType = m_InputContext.GetParamInt("s_type");	
		}

		//Filter on Notices
		if ( m_InputContext.ParamExists("s_thread") )
		{
			iTypeFilter = CCategory::THREAD;
		}

		//Filter on User
		if ( m_InputContext.ParamExists("s_user") )
		{
			iTypeFilter = CCategory::USER;
		}

		if ( m_InputContext.ParamExists("show") )
		{
			iShow = m_InputContext.GetParamInt("show");		
		}
		if ( m_InputContext.ParamExists("skip") )
		{
			iSkip = m_InputContext.GetParamInt("skip");	
		}
	}

	//------------------------------------------------------------------------------------------------------------------------------------//

	bool bSuccess = Category.InitialiseViaNodeID(
																			iNodeID, 
																			m_InputContext.GetSiteID(),																																														
																			iTypeFilter,
																			iArticleType,
																			iShow,																		
																			iSkip																			
																	);

	CTDVString sNodeName = Category.GetNodeName();
	int h2g2ID = Category.Geth2g2ID();
	bSuccess = bSuccess && pPage->AddInside("H2G2", &Category);

	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	if (h2g2ID > 0)
	{
		CGuideEntry GuideEntry(m_InputContext);
		
		GuideEntry.Initialise(h2g2ID, m_InputContext.GetSiteID(), pViewingUser, true, true, true, true);
		pPage->AddInside("HIERARCHYDETAILS", &GuideEntry);

		// Setup the GROUPS Tag
		pPage->AddInside("HIERARCHYDETAILS","<GROUPS></GROUPS>");

		// Add the members of the gurus group.
		CGroups Groups(m_InputContext);
		if (Groups.GetGroupMembers("Gurus",m_InputContext.GetSiteID()))
		{
			// Put the XML into the page
			pPage->AddInside("HIERARCHYDETAILS/GROUPS",&Groups);
		}

		// If we have a user, lets check their subscription for the category
		if (pViewingUser != NULL && iNodeID != 0)
		{
			// Get the users subsciption status for this category
			CEmailAlertList EMailAlert(m_InputContext);
			if (EMailAlert.GetUserEMailAlertSubscriptionForCategory(pViewingUser->GetUserID(),iNodeID))
			{
				pPage->AddInside("H2G2",&EMailAlert);
			}
		}
	}

	if (bSuccess && m_InputContext.ParamExists("clip")) 
	{
		CTDVString sURL;
		sURL << "C" << iNodeID;
		if (sNodeName.GetLength() == 0) 
		{
			sNodeName = sURL;
		}

		bool bPrivate = m_InputContext.GetParamInt("private") > 0 ;
		CLink Link(m_InputContext);
		if ( Link.ClipPageToUserPage("category", iNodeID, sNodeName, NULL, pViewingUser, bPrivate ) )
			pPage->AddInside("H2G2", &Link);
		
	}
	
	//include civic data
	if (bSuccess)
	{
		if ( m_InputContext.GetSiteID( ) == 16 )
		{			
			// First check to see if there is a postcode in the URL
			CTDVString sActualPostCode;		
			bool bFoundLocalInfo = false;
			if (m_InputContext.ParamExists("postcode"))
			{
				// Get the postcode and use this to display the noticeboard
				if (m_InputContext.GetParamString("postcode", sActualPostCode))
				{
					//dont do any validations
					bFoundLocalInfo = true;				
				}
			}

			//next if no postcode variable is included in URL
			//or if the specified postcode value is invalid 
			//or if the specified postcode value has no entries on the db			
			if (!bFoundLocalInfo)
			{
				// No postcode given, try to get the viewing users postcode if we have one.
				if (pViewingUser)
				{
					if (pViewingUser->GetPostcode(sActualPostCode))
					{
						if ( sActualPostCode.IsEmpty( ) == false)
						{
							//dont do any validations
							bFoundLocalInfo = true;
						}
					}							
				}
				else
				{
					//try session cookie, if any 
					CTDVString sPostCodeToFind;
					CPostcoder postcoder(m_InputContext);
					sActualPostCode = postcoder.GetPostcodeFromCookie();
					if ( !sActualPostCode.IsEmpty() )
					{
						//dont do any validations
						bFoundLocalInfo = true;
					}
				}
			}

			if ( bFoundLocalInfo )
			{
				if (!sActualPostCode.IsEmpty())
				{
					bool bHitPostcode = false;
					CPostcoder cPostcoder(m_InputContext);
					cPostcoder.MakePlaceRequest(sActualPostCode, bHitPostcode);
					if (bHitPostcode)
					{
						CTDVString sXML = "<CIVICDATA POSTCODE='";
						sXML << sActualPostCode << "'/>";
						pPage->AddInside("H2G2", sXML);
						bSuccess = pPage->AddInside("CIVICDATA",&cPostcoder);
					}
				}
			}
		}
	}

	// State whether user has any group alerts on this node
	if(pViewingUser != NULL)
	{
		CEMailAlertGroup EMailAlertGroup(m_InputContext);
		int iGroupID = 0;

		if(!EMailAlertGroup.HasGroupAlertOnItem(iGroupID, pViewingUser->GetUserID(), m_InputContext.GetSiteID(), CEmailAlertList::IT_NODE, iNodeID))
		{
			TDVASSERT(false, "CCategoryBuilder::Build() EMailAlertGroup.HasGroupAlert failed");
		}
		else if(iGroupID != 0)
		{
			// Put XML
			CTDVString sGAXml;
			sGAXml << "<GROUPALERTID>" << iGroupID << "</GROUPALERTID>";
			
			if(!pPage->AddInside("H2G2", sGAXml))
			{
				TDVASSERT(false, "CCategoryBuilder::Build() m_pPage->AddInside failed");
			}	
		}
	}

	// Dynamic Lists
	if(bSuccess)
	{
		// Create and add <dynamic-lists> to page
		CTDVString sDyanmicListsXml;
		if(!m_InputContext.GetDynamicLists(sDyanmicListsXml, m_InputContext.GetSiteID()))
		{
			TDVASSERT(false, "CCategoryBuilder::Build() m_InputContext.GetDynamicLists failed");
		}
		else
		{
			if(!pPage->AddInside("H2G2", sDyanmicListsXml))
			{
				TDVASSERT(false, "CCategoryBuilder::Build() m_pPage->AddInside failed");
			}
		}
	}


	if (bSuccess)
	{
		return true;
	}
	else
	{
		pPage->SetError("Unable to create category page");
		return true;
	}
}

/********************************************************************************

	bool CCategoryBuilder::IsRequestHTMLCacheable()

		Author:		Mark Neves
        Created:	18/07/2006
        Inputs:		-
        Outputs:	-
        Returns:	true if the current request can be cached
        Purpose:	Determines if the HTML for this request can be cached.
					Basically it boils down to "Is this request read-only?".

*********************************************************************************/

bool CCategoryBuilder::IsRequestHTMLCacheable()
{
	return true;
}

/*********************************************************************************

	CTDVString CCategoryBuilder::GetRequestHTMLCacheFolderName()

		Author:		Mark Neves
        Created:	18/07/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Returns the path, under the ripleycache folder, where HTML cache files 
					should be stored for this builder

*********************************************************************************/

CTDVString CCategoryBuilder::GetRequestHTMLCacheFolderName()
{
	return CTDVString("html\\category");
}

/*********************************************************************************

	CTDVString CCategoryBuilder::GetRequestHTMLCacheFileName()

		Author:		Mark Neves
        Created:	18/07/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Creates the HTML cache file name that uniquely identifies this request.

*********************************************************************************/

CTDVString CCategoryBuilder::GetRequestHTMLCacheFileName()
{ 
	CTDVString sHash;
	m_InputContext.GetQueryHash(sHash);

	int iNodeID = m_InputContext.GetParamInt("catid");

	CTDVString sCacheName;
	sCacheName << "C-" << m_InputContext.GetNameOfCurrentSite() << "-" << iNodeID << "-" << sHash << ".html";

	return sCacheName;
}
