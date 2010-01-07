#include "stdafx.h"
#include ".\FrontPageTopicElement.h"
#include ".\tdvassert.h"
#include ".\user.h"

CFrontPageTopicElement::CFrontPageTopicElement(CInputContext& inputContext)
: CFrontPageElement(inputContext,ET_TOPIC,"TOPICELEMENT")
{
}

CFrontPageTopicElement::~CFrontPageTopicElement(void)
{

}

bool CFrontPageTopicElement::GetTopicFrontPageElementsForSiteID(int iSiteID, eElementStatus ElementStatus, int iActivePromoID)
{
	// Call the base class with the correct element type
	return GetElementsForSiteID(iSiteID, ElementStatus, iActivePromoID);
}

/*********************************************************************************

	bool CFrontPageTopicElement::CreateTopicFrontPageElement(int& iElementID, int iSiteID, CFrontPageElement::eElementStatus ElementStatus,  int iElementLinkID, int iTopicID, const bool bUseNoOfPost, const TDVCHAR* psText, const TDVCHAR* psImageName, int iTemplate, const TDVCHAR* psTitle, const TDVCHAR* psImageAltText)

		Author:		Mark Neves
        Created:	12/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CFrontPageTopicElement::CreateTopicFrontPageElement(int& iElementID, int iSiteID, int iUserID, CFrontPageElement::eElementStatus ElementStatus,  int iElementLinkID, int iTopicID, const bool bUseNoOfPost, const TDVCHAR* psText, const TDVCHAR* psImageName, int iTemplate, const TDVCHAR* psTitle, const TDVCHAR* psImageAltText)
{
	TDVASSERT( iElementID == 0, "Element ID should be 0" );
	
	CTDVString sEditKey;
	if ( CreateNewElement(ElementStatus, iSiteID, iUserID, iElementID, sEditKey, 0, iElementLinkID)== false)
	{
		return false;
	}

	//now update topicID 
	if ( SetElementValue(iElementID , iTopicID , false , EV_TOPICID, iUserID, sEditKey) == false)
	{
		return false;
	}
/*
	// No longer used!!!
	//now update show now of shwo no of post  
	if ( SetElementValue(iElementID , bUseNoOfPost , false , EV_USENUMBEROFPOSTS, sEditKey) == false)
	{
		return false;
	}
*/
	//now update text 
	if ( SetElementValue(iElementID , psText , false , EV_TEXT, iUserID, sEditKey) == false)
	{
		return false;
	}

	//now update text 
	if ( SetElementValue(iElementID , psImageName , false , EV_IMAGENAME, iUserID, sEditKey) == false)
	{
		return false;
	}

	//now update the template
	if (SetElementValue(iElementID, iTemplate, false, EV_TEMPLATETYPE, iUserID, sEditKey) == false)
	{
		return false;
	}

	// Update the Title
	if (!SetElementValue(iElementID, psTitle, false, EV_TITLE, iUserID, sEditKey))
	{
		return false;
	}

	// Update the Image Alt Text
	if (!SetElementValue(iElementID, psImageAltText, false, EV_IMAGEALTTEXT, iUserID, sEditKey))
	{
		return false;
	}

	if ( CommitTopicFrontPageElementChanges(iUserID, sEditKey) == false)
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CFrontPageTopicElement::EditTopicFrontPageElement(int iElementID,  CFrontPageElement::eElementStatus ElementStatus, const bool bUseNoOfPost, const TDVCHAR* psText, const TDVCHAR* psImageName, int iTemplate, const TDVCHAR* psEditKey, const TDVCHAR* psTitle, const TDVCHAR* psImageAltText, bool bCommitChanges)

		Author:		Mark Neves
        Created:	12/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CFrontPageTopicElement::EditTopicFrontPageElement(int iElementID,  int iUserID, CFrontPageElement::eElementStatus ElementStatus, const bool bUseNoOfPost, const TDVCHAR* psText, const TDVCHAR* psImageName, int iTemplate, const TDVCHAR* psEditKey, const TDVCHAR* psTitle, const TDVCHAR* psImageAltText, bool bCommitChanges)
{	
	TDVASSERT( iElementID != 0, "Element ID should not be 0");

/*
	// No longer used!!!
	//now update show now of shwo no of post  
	bool bOk = SetElementValue(iElementID , bUseNoOfPost , false , EV_USENUMBEROFPOSTS, psEditKey);
*/

	//now update text 
	bool bOk = SetElementValue(iElementID , psText , false , EV_TEXT, iUserID, psEditKey);

	//now update text 
	bOk = bOk && SetElementValue(iElementID , psImageName , false , EV_IMAGENAME, iUserID, psEditKey);

	//now update template
	bOk = bOk && SetElementValue(iElementID , iTemplate , false , EV_TEMPLATETYPE, iUserID, psEditKey);

	// Update the Title
	bOk = bOk && SetElementValue(iElementID, psTitle, false, EV_TITLE, iUserID, psEditKey);

	// Update the Image Alt Text
	bOk = bOk && SetElementValue(iElementID, psImageAltText, false, EV_IMAGEALTTEXT, iUserID, psEditKey);

	// Check to see if we're required to commit the changes
	if (bCommitChanges)
	{
		// Finaly commit the changes to the database
		bOk = bOk && CommitTopicFrontPageElementChanges(iUserID, psEditKey);

		// Create the result XML
		CTDVString sXML;
		CDBXMLBuilder XML;
		XML.Initialise(&sXML);
		XML.OpenTag("EDITTOPICELEMENT");
		if (bOk)
		{
			XML.AddTag("ACTION","OK");
		}
		else
		{
			XML.AddTag("ACTION","FAILED");
		}
		XML.CloseTag("EDITTOPICELEMENT");

		// Create the XMLTree from the XML and return the verdict
		CreateFromXMLText(sXML,NULL,true);
	}

	// Return the verdict!
	return bOk;
}

/*********************************************************************************

	bool CFrontPageTopicElement::DeleteTopicFrontPageElement(int iElementID)

		Author:		Mark Neves
        Created:	12/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CFrontPageTopicElement::DeleteTopicFrontPageElement(int iElementID,int iUserID)
{
	if ( iElementID == 0 )
	{
		return SetDNALastError("CFrontPageTopicElement::DeleteTopicFrontPageElement" , "FailedToDeleteTopicFrontPageElement" , "iElementID is invalid");
	}	
	return CFrontPageElement::DeleteElement(iElementID,iUserID);
}

/*********************************************************************************

	bool CFrontPageTopicElement::GetTopicFrontPageElementDetails( int iElementID )

		Author:		Mark Neves
        Created:	12/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CFrontPageTopicElement::GetTopicFrontPageElementDetails( int iElementID )
{
	if ( iElementID == 0 )
	{
		return SetDNALastError("CFrontPageTopicElement::GetTopicFrontPageElementDetails" , "FailedToGetTopicFrontPageElementDetails" , "iElementID is invalid");
	}

	return GetElementDetails(iElementID);	
}

// Wrapper function for the BaseClass
bool CFrontPageTopicElement::SetTopicFrontPageElementTemplateType(int iElementID ,int iType, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey, bool bApplyTemplateToAllInSite/* = true*/)
{
	return SetElementValue(iElementID, iType, bCommitChanges, EV_TEMPLATETYPE, iUserID, psEditKey, bApplyTemplateToAllInSite);
}

// Wrapper function for the BaseClass
bool CFrontPageTopicElement::SetTopicFrontPageElementTitle(int iElementID, const TDVCHAR* psTitle, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	if ( iElementID == 0 )
	{
		return SetDNALastError("CFrontPageTopicElement::DeleteTopicFrontPageElement" , "FailedToSetTopicFrontPageElementTitle" , "iElementID is invalid");
	}	
	return SetElementValue(iElementID , psTitle , bCommitChanges , EV_TITLE, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CFrontPageTopicElement::SetTopicFrontPageElementText(int iElementID, const TDVCHAR* psText, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	if ( iElementID == 0 )
	{
		return SetDNALastError("CFrontPageTopicElement::DeleteTopicFrontPageElement" , "FailedToTopicFrontPageElementText" , "iElementID is invalid");
	}	
	return SetElementValue(iElementID , psText , bCommitChanges , EV_TEXT, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CFrontPageTopicElement::SetTopicFrontPageElementPosition(int iElementID, int iPosition, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	if ( iElementID == 0 )
	{
		return SetDNALastError("CFrontPageTopicElement::DeleteTopicFrontPageElement" , "FailedToSetTopicFrontPageElementPosition" , "iElementID is invalid");
	}	
	return SetElementValue(iElementID , iPosition , bCommitChanges , EV_FRONTPAGEPOSITION, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CFrontPageTopicElement::SetTopicFrontPageElementImageName(int iElementID, const TDVCHAR* psImageName, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	if ( iElementID == 0 )
	{
		return SetDNALastError("CFrontPageTopicElement::DeleteTopicFrontPageElement" , "FailedToSetTopicFrontPageElementImageName" , "iElementID is invalid");
	}	
	return SetElementValue(iElementID , psImageName , bCommitChanges , EV_IMAGENAME, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CFrontPageTopicElement::SetTopicFrontPageElementImageAltText(int iElementID, const TDVCHAR* psImageAltText, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iElementID , psImageAltText , bCommitChanges , EV_IMAGEALTTEXT, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
/*
// No longer used!!!
bool CFrontPageTopicElement::SetTopicFrontPageElementUseNoOfPost(int iElementID , int bUseNoOfPost , bool bCommitChanges, const TDVCHAR* psEditKey)
{
	if ( iElementID == 0 )
	{
		return SetDNALastError("CFrontPageTopicElement::DeleteTopicFrontPageElement" , "FailedToSetTopicFrontPageElementUseNoOfPost" , "iElementID is invalid");
	}	
	return SetElementValue(iElementID , bUseNoOfPost , bCommitChanges , EV_USENUMBEROFPOSTS, psEditKey);
}
*/

// Wrapper function for the BaseClass
bool CFrontPageTopicElement::CommitTopicFrontPageElementChanges(int iUserID, const TDVCHAR* psEditKey)
{
	return CommitElementChanges(iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CFrontPageTopicElement::MakePreviewTopicFrontPageElementsActive(int iSiteID, int iEditorID, int iElementID)
{
	return MakeElementsActiveForSite(iSiteID, iEditorID, iElementID);
}

// Wrapper function for the BaseClass
bool CFrontPageTopicElement::GetTopicFrontPageElementTitle(CTDVString& sTitle, int iElementID)
{
	return GetElementValue(EV_TITLE,sTitle,iElementID);
}

// Wrapper function for the BaseClass
bool CFrontPageTopicElement::GetTopicFrontPageElementText(CTDVString& sText, int iElementID)
{
	return GetElementValue(EV_TEXT,sText,iElementID);
}

// Wrapper function for the BaseClass
bool CFrontPageTopicElement::GetTopicFrontPageElementImageName(CTDVString& sImageName, int iElementID)
{
	return GetElementValue(EV_IMAGENAME,sImageName,iElementID);
}

// Wrapper function for the BaseClass
bool CFrontPageTopicElement::GetTopicFrontPageElementTopicID(int& iTopicID, int iElementID)
{
	return GetElementValue(EV_TOPICID,iTopicID,iElementID);
}

// Wrapper function for the BaseClass
bool CFrontPageTopicElement::GetTopicFrontPageElementTemplateType(int& iTemplateType, int iElementID)
{
	return GetElementValue(EV_TEMPLATETYPE,iTemplateType,iElementID);
}

// Wrapper function for the BaseClass
bool CFrontPageTopicElement::GetTopicFrontPageElementImageAltText(CTDVString& sImageAltText, int iElementID)
{
	return GetElementValue(EV_IMAGEALTTEXT,sImageAltText,iElementID);
}

// Wrapper function for the BaseClass
/*
// No longer used
bool CFrontPageTopicElement::GetTopicFrontPageElementUseNoOfPosts(int& iUseNoOfPosts, int iElementID)
{
	return GetElementValue(EV_USENUMBEROFPOSTS,iUseNoOfPosts,iElementID);
}
*/

//Wrapper for base class
bool CFrontPageTopicElement::GetNumberOfFrontPageTopicElementsForSiteID(int iSiteID, int& iNumTopicElements, eElementStatus ElementStatus) 
{
	return GetNumberOfFrontPageElementsForSiteID( iSiteID, ElementStatus, iNumTopicElements) ;
}