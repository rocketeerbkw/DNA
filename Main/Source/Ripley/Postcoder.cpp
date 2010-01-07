// Postcoder.cpp: implementation of the CPostcoder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "Postcoder.h"
#include "GuideEntry.h"
#include "TagItem.h"
#include "Config.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CPostcoder::CPostcoder(CInputContext& inputContext) : CXMLObject(inputContext), m_pResultTree(NULL)
{

}

CPostcoder::~CPostcoder()
{

}


/*********************************************************************************

	bool CPostcoder::GetPostcodeFromCookie()

	Author:		Martin Robb
	Created:	11/03/2005
	Inputs:		None
	Outputs:	None
	Returns:	Postcode retrieved from Postcoder cookie
	Purpose:	Retrieves a postcode value from the BBC Postcoder cookie

*********************************************************************************/
CTDVString CPostcoder::GetPostcodeFromCookie()
{ 
	CTDVString sResult;
	m_InputContext.GetCookieByName(m_InputContext.GetPostcoderCookieName(), sResult);
	CTDVString sPostCodeKey = m_InputContext.GetPostcoderCookiePostcodeKey();
	int start = sResult.Find(sPostCodeKey);
	if ( start >= 0 )
	{
		start += sPostCodeKey.GetLength();
		int end = sResult.Find(":",start);
		if ( end > start )
		{
			sResult = sResult.Mid( start,end - start );
		}
	}
	return sResult;
}

bool CPostcoder::MakePlaceRequest(const TDVCHAR* pPlaceName, bool& bHitPostcode)
{
	//*****************************************************************
	//Temp Optimisation - Only need Post Codes in ActionNetwork site.
	//Return no postcode found if another site.
	//*****************************************************************
	CTDVString sSiteName;
	m_InputContext.GetNameOfSite(m_InputContext.GetSiteID(),&sSiteName);
	if (!sSiteName.CompareText("actionnetwork"))
	{
		bHitPostcode = false;
		return true;
	}
	//*****************************************************************

	m_InputContext.LogTimerEvent("Postcode request starting");
	CTDVString sResult;
	bool bRequestOk = m_InputContext.PostcoderPlaceRequest(pPlaceName, sResult);
	CreateFromXMLText(sResult);
	CXMLTree* pResult = m_pTree->FindFirstTagName("RESULT");
	if (pResult == NULL) 
	{
		bHitPostcode = false;
	}
	else
	{
		CXMLTree* pMatchtype = pResult->FindFirstTagName("MATCH_TYPE", pResult);
		if (pMatchtype == NULL) 
		{
			bHitPostcode = false;
		}
		else
		{
			CTDVString sMatchType;
			pMatchtype->GetTextContents(sMatchType);
			if (sMatchType.CompareText("postcode")) 
			{
				bHitPostcode = true;
			}
			else
			{
				bHitPostcode = false;
			}
		}
	}
	m_InputContext.LogTimerEvent("Postcode request complete");
	return bRequestOk;
}

bool CPostcoder::PlaceHitPostcode(CTDVString& oPostcode, CTDVString& oLocalAuthorityID, CTDVString& oLocalAuthorityName, int& iNodeID)
{
	if (IsEmpty()) 
	{
		return false;
	}
	CXMLTree* pResult = m_pTree->FindFirstTagName("RESULT");
	if (pResult == NULL) 
	{
		return false;
	}
	CXMLTree* pMatchtype = pResult->FindFirstTagName("MATCH_TYPE", pResult);
	if (pMatchtype == NULL) 
	{
		return false;
	}
	CTDVString sMatchType;
	pMatchtype->GetTextContents(sMatchType);
	if (sMatchType.CompareText("postcode")) 
	{
		CXMLTree* pNode = pResult->FindFirstTagName("POSTCODE", pResult);
		if (pNode) 
		{
			pNode->GetTextContents(oPostcode);
		}
		pNode = pResult->FindFirstTagName("LOCAL_AUTHORITY");
		if (pNode != NULL) 
		{
			CXMLTree* pSubNode = pNode->FindFirstTagName("ID");
			if (pSubNode != NULL) 
			{
				CTDVString sID;
				pSubNode->GetTextContents(sID);
				oLocalAuthorityID << "local_authority:" << sID;
			}
			pSubNode = pNode->FindFirstTagName("NAME");
			if (pSubNode != NULL) 
			{
				pSubNode->GetTextContents(oLocalAuthorityName);
			}
			CStoredProcedure SP;
			m_InputContext.InitialiseStoredProcedureObject(&SP);
			SP.GetTaxonomyNodeFromID(oLocalAuthorityID, iNodeID);
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CPostcoder::UpdateUserPostCodeInfo(CTDVString& sPostCode, CTDVString& sArea, int iNodeID)

	Author:		Mark Howitt
	Created:	13/10/2003
	Inputs:		-
	Outputs:	-
	Returns:	True if all went well, false if no user logged in or something went wrong!
	Purpose:	Updates the current user postcode info and tags their userpage
				to the new taxonomy node.

*********************************************************************************/

bool CPostcoder::UpdateUserPostCodeInfo(CTDVString& sPostCode, CTDVString& sArea, int iNodeID)
{
	// Get the viewing user from the context.
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser == NULL)
	{
		TDVASSERT(false,"CPostcoder::UpdateUserPostCodeInfo - No viewing user found!");
		return false;
	}

	// Check to make sure we're trying to add the userpage to a valid node
	if (iNodeID == 0)
	{
		TDVASSERT(false,"CPostcoder::UpdateUserPostCodeInfo - No Node Id Given!");
	}

	// Now set the users new postcode, area and taxonomy node.
	pViewingUser->SetPostcode(sPostCode);
	pViewingUser->SetArea(sArea);
	pViewingUser->SetTaxonomyNode(iNodeID);

	// Update the users details with the new stuff
	if (!pViewingUser->UpdateDetails())
	{
		TDVASSERT(false,"CPostcoder::UpdateUserPostCodeInfo - Failed to update user details!");
		return false;
	}

	// Tag the users page to the new location. Only do this is the original and new nodes are different!
	if (iNodeID > 0)
	{
		CTagItem UserTagging(m_InputContext);
		if (!UserTagging.InitialiseFromUserId(pViewingUser->GetUserID(),m_InputContext.GetSiteID(),pViewingUser))
		{
			TDVASSERT(false,"CPostcoder::UpdateUserPostCodeInfo - Failed to initialise tag object for user!");
			return false;
		}

		if (!UserTagging.RemoveFromAllNodes("Location"))
		{
			TDVASSERT(false, "CPostcoder::RemoveFromAllNodes - Failed to remove user from existing nodes!");
			return false;
		}

		if (!UserTagging.AddTagItemToNode(iNodeID,false))
		{
			TDVASSERT(false,"CPostcoder::UpdateUserPostCodeInfo - Failed to add th euser to the given node!");
			return false;
		}
	}

	// Everything ok
	return true;
}
