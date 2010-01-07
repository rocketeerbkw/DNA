#include "stdafx.h"
#include "FrontPageLayout.h"
#include "TDVAssert.h"
#include "StoredProcedure.h"


/*********************************************************************************
CFrontPageLayout::CFrontPageLayout()
Author:		Nick Stevenson
Created:	29/07/2004
Purpose:	Constructor
*********************************************************************************/
CFrontPageLayout::CFrontPageLayout(CInputContext& inputContext) : CXMLObject(inputContext), m_PageBody(m_InputContext)
{
}

/*********************************************************************************
CFrontPageLayout::~CFrontPageLayout()
Author:		Nick Stevenson
Created:	29/07/2004
Purpose:	Destructor
*********************************************************************************/
CFrontPageLayout::~CFrontPageLayout()
{
}

/*********************************************************************************

	bool CFrontPageLayout::MakePreviewItemActive(int iSiteID)

		Author:		Nick Stevenson
        Created:	11/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	calls a stored procedure which create/update a duplicate guide entry
					and adds a row to KeyArticles table so a corresponding 'active'
					version exists

*********************************************************************************/
bool CFrontPageLayout::MakePreviewItemActive(int iSiteID)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CFrontPageLayout::MakePreviewItemActive","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}

	// Now call the procedure
	if (!SP.MakeFrontPageLayoutActive(iSiteID))
	{
		TDVASSERT(false, "Stored Procedure class reported a faliure to update preview/active status");
		return SetDNALastError("CFrontPageLayout::MakePreviewItemActive","FailedToMakeItemActive","Failed making preview item active");
	}

	// add a bit of XML to flag up the change
	if(!CreateFromXMLText("<ACTIVE>1</ACTIVE>",NULL,true))
	{
		Destroy();
		TDVASSERT(false, "Failed to generate XML to flag up layout status change");
		return SetDNALastError("FrontPageLayout", "XML", "Failed to generate XML to flag up layout status change");
	}
	return true;
}

/*********************************************************************************

	bool CFrontPageLayout::GetLayoutAndTemplateData(int& iLayoutType, int& iTmplType, int& iElemTmplType, CTDVString& sElemTemplateGuideML)

		Author:		Nick Stevenson
        Created:	11/02/2005
        Inputs:		
        Outputs:	int& iLayoutType, int& iTmplType, int& iElemTmplType, CTDVString& sElemTemplateGuideML
        Returns:	succeess/fail bool
        Purpose:	Initialises object from data and extracts the layout value include GUIDML
					for topic element template. Values are assigned to the return values passed in
*********************************************************************************/
bool CFrontPageLayout::GetLayoutAndTemplateData(int& iLayoutType, int& iTmplType, int& iElemTmplType, CTDVString& sElemTemplateGuideML)
{
	// Make sure we've been initialised correctly
	if (!m_PageBody.IsInitialised())
	{
		return SetDNALastError("CFrontPageLayout::GetLayoutAndTemplateData","NotInitialised","Page has not been initialised!");
	}

	// Now get the ExtraInfo
	CExtraInfo* pExtraInfo = m_PageBody.GetExtraInfo();
	if (pExtraInfo == NULL)
	{
		return SetDNALastError("CFrontPageLayout::GetLayoutAndTemplateData","InvalidExtraInfoPointer","Failed to get the ExtraInfo for the Page!!!");
	}

	// Now get tha values
	CTDVString sLayout;
	CTDVString sTemplate;
	CTDVString sElementType;

	// Ok, get the Layout info
	if (pExtraInfo->GetInfoItem("LAYOUT",sLayout))
	{
		sLayout.Replace("<LAYOUT>","");
		sLayout.Replace("</LAYOUT>","");
		iLayoutType = atoi(sLayout);
	}

	// Ok, get the Template Info
	if (pExtraInfo->GetInfoItem("TEMPLATE",sTemplate))
	{
		sTemplate.Replace("<TEMPLATE>","");
		sTemplate.Replace("</TEMPLATE>","");
		iTmplType = atoi(sTemplate);
	}

	// Ok, get the Element Info
	if (pExtraInfo->GetInfoItem("ELEMTEMPLATE",sElementType))
	{
		sElementType.Replace("<ELEMTEMPLATE>","");
		sElementType.Replace("</ELEMTEMPLATE>","");
		iElemTmplType = atoi(sElementType);
	}

	// Ok, Get the Element GuideML Template
	pExtraInfo->GetInfoItem("ELEMTEMPLATE-GUIDEML",sElemTemplateGuideML);

	return true;
}

/*********************************************************************************

	bool CFrontPageLayout::UpdateFrontPagePreview(int iViewingUser, bool& bEditedByAnotherUser)

		Author:		Nick Stevenson
        Created:	11/02/2005
        Inputs:		int iViewingUser
        Outputs:	bEditedByAnotherUser - A flag that states whether or not
						the article had been edited by another editor!
        Returns:	true/false bool
        Purpose:	Updates the record in the DB. 

*********************************************************************************/
bool CFrontPageLayout::UpdateFrontPagePreview(int iViewingUser, const TDVCHAR* psEditKey, bool& bEditedByAnotherUser)
{
	// Setup some locals
	bool bSuccess = true;
	bEditedByAnotherUser = false;

	// Get theExtraInfo info
	CExtraInfo* pExtraInfo = m_PageBody.GetExtraInfo();

	// Check to see if we've got LAYOUT info in the ExtraInfo. If we have we need to make sure we remove it from the body
	if (pExtraInfo->ExistsInfoItem("LAYOUT") && m_PageBody.DoesTagExist("PAGE-LAYOUT"))
	{
		// Remove the PageLayout from the body.
		m_PageBody.RemoveTag("PAGE-LAYOUT");
		m_PageBody.UpdateBody();
	}

	// Now get the pagebody
	CTDVString sNewBody;
	m_PageBody.GetBodyText(&sNewBody);

	// attempt the update
	// init the stored procedure object
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	if(!SP.UpdateFrontpagePreview(m_InputContext.GetSiteID(), sNewBody, iViewingUser, psEditKey, *pExtraInfo))
	{
		return SetDNALastError("FrontPageLayout", "UpdateFrontPagePreview", "Failed to execute SP UpdateFrontpagePreview");
	}

	// check the return value
	CTDVString sEditKeyXML;
	int iValid = SP.GetIntField("ValidEditKey");
	if(iValid == 2)
	{
		// we're happy, all we need is the new EDIT-KEY to return in XML
		CTDVString sNewEditKey;
		SP.GetField("NewEditKey", sNewEditKey);
		sEditKeyXML << "<EDIT-KEY>" << sNewEditKey << "</EDIT-KEY>";
	}
	else if(iValid == 1)
	{
		// we're not happy, EDIT-KEY passed in did not match DB value
		// so return the Edit Key passed in.
		sEditKeyXML << "<EDIT-KEY>" << psEditKey << "</EDIT-KEY>";

		// set a value in the error string to be passed back to the builder
		SetDNALastError("FrontPageLayout::UpdateFrontPagePreview", "EditedByAnotherUser", "Edited by another User!!!");
		bEditedByAnotherUser = true;
	}

	// add em to the CPageBody instance
	bSuccess = bSuccess && m_PageBody.RemoveTag("EDIT-KEY");
	bSuccess = bSuccess && m_PageBody.AddInside("ARTICLEINFO", sEditKeyXML);

	//lubbly jubbly
	return bSuccess;
}

/*********************************************************************************

	bool CFrontPageLayout::UpdateFrontPagePreviewDirect(int iSiteID, const TDVCHAR* pBody,int iEditorID)

		Author:		Mark Neves
        Created:	15/02/2005
        Inputs:		iSiteID = the site
					pBody = the body text for the key article
					iEditorID = the ID of the editor doing the update
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Provides a direct route to updating the the preview frontpage for
					the given site

*********************************************************************************/
bool CFrontPageLayout::UpdateFrontPagePreviewDirect(int iSiteID, const TDVCHAR* pBody,int iEditorID)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CFrontPageLayout::UpdateFrontPagePreviewDirect","SPINITFAILED","Failed to init the SP object");
	}

	CExtraInfo* pExtraInfo = m_PageBody.GetExtraInfo();
	if (!SP.UpdateFrontpagePreview(iSiteID, pBody, iEditorID, NULL, *pExtraInfo))
	{
		return SetDNALastError("CFrontPageLayout::UpdateFrontPagePreviewDirect","FAILED","Unable to update frontpage preview");
	}

	return true;
}

/*********************************************************************************

	bool CFrontPageLayout::InitialisePageBody(int iSiteID, bool bIsPreviewFrontPage = false, bool bRequiresPageLayout = false)

		Author:		Mark Howitt
        Created:	08/07/2005
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Initialises the PageBody object with the current frontpage

*********************************************************************************/
bool CFrontPageLayout::InitialisePageBody(int iSiteID, bool bIsPreviewFrontPage, bool bRequiresPageLayout)
{
	// Make sure the PageBody is clean and then initialise it
	m_PageBody.Destroy();

	// Setup the name of the file we want to load
	CTDVString sNamedArticle = "xmlfrontpage";
	if (bIsPreviewFrontPage)
	{
		sNamedArticle << "preview";
	}

	// Now Intialise
	if (!m_PageBody.Initialise(sNamedArticle, iSiteID))
	{	
		//handle the error
		return SetDNALastError("CFrontPageLayout::InitialisePageBody()", "FailedToInitialisePageBody", "Failed to initialise body with xmlfrontpagepreview");
	}

	// Make sure the extra info if filled in correctly
	CExtraInfo* pExtraInfo = m_PageBody.GetExtraInfo();
	if (pExtraInfo != NULL)
	{
		// Check to make see if we have the minimum LAYOUT tag
		if (!pExtraInfo->ExistsInfoItem("LAYOUT") && bRequiresPageLayout)
		{
			// We might have an old style frontpage, try to initialise the ExtraInfo from the PageLayout
			if (!UpdateExtraInfoFromPageBody())
			{
				return false;
			}
		}
	}

	// Make sure we have a FRONTPAGE element in the pagebody
	if(!m_PageBody.FindFirstNode("FRONTPAGE", 0, false))
	{
		// get the existing frontpage article
		m_PageBody.AddInside("ARTICLE", "<FRONTPAGE/>");
		m_PageBody.UpdateBody();
	}

	// Ok
	return true;
}

/*********************************************************************************

	bool CFrontPageLayout::UpdateExtraInfoFromPageBody()

		Author:		Mark Howitt
        Created:	19/07/2005
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Tries to update the extra info from the page body.
					This is used to initialise from old frontpages which has
					the pagelayout info in the Body.

*********************************************************************************/
bool CFrontPageLayout::UpdateExtraInfoFromPageBody()
{
	// Setup some locals
	int iLayoutType = 0;
	int iTemplateType = 0;
	int iElemenetTemplateType = 0;
	CTDVString sElementTemplateGuideML;

	// See if the PAGE-LAYOUT Tag exists
	if (m_PageBody.DoesTagExist("PAGE-LAYOUT"))
	{
		// get the layout value
		CTDVString sLayout;
		if (m_PageBody.GetContentsOfTag("LAYOUT", &sLayout))
		{
			iLayoutType = atoi(sLayout);
		}
	
		// get the template type value
		CTDVString sTemplate;
		if (m_PageBody.GetContentsOfTag("TEMPLATE", &sTemplate))
		{
			iTemplateType = atoi(sTemplate);
		}

		// get the topic element template type value and guideml if it exists
		CTDVString sElementType;
		if (m_PageBody.GetContentsOfTag("ELEMTEMPLATE", &sElementType))
		{
			iElemenetTemplateType = atoi(sElementType);

			// if we're type 6 Get it if there is
			if (iElemenetTemplateType == ELEMENTTEMPLATE_GUIDEML_INDICATOR)
			{
				m_PageBody.GetContentsOfTag("ELEMTEMPLATE-GUIDEML", &sElementTemplateGuideML);
			}
		}
	}
	else
	{
		// We don't have any pagelayout information! just default!
		iLayoutType = 4;
		iTemplateType = 0;
		iElemenetTemplateType = 0;
		sElementTemplateGuideML.Empty();
	}

	// Now Update the ExtraInfo
	bool bOk = SetFrontPageLayoutType(iLayoutType);
	bOk = bOk && SetFromtPageTemplateType(iTemplateType);
	bOk = bOk && SetFrontPageElementType(iElemenetTemplateType);
	bOk = bOk && SetFrontPageElementGuideML(sElementTemplateGuideML);

	// Return the verdict
	return bOk;
}

/*********************************************************************************

	bool CFrontPageLayout::SetExtraInfoValue(const TDVCHAR* psTagName, CTDVString& sValue)

		Author:		Mark Howitt
        Created:	13/07/2005
        Inputs:		sValue - the new value for a the given tag
					sTagName - The name of the Tag you want to change the value of
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Private helper function for editing ExtraInfo values

*********************************************************************************/
bool CFrontPageLayout::SetExtraInfoValue(const TDVCHAR* psTagName, CTDVString& sValue)
{
	// Get the current extra info and then set the new value
	CExtraInfo* pExtraInfo = m_PageBody.GetExtraInfo();
	bool bOk = (pExtraInfo != NULL);

	// Now see if we already have a layout tag, if so remove it!
	if (bOk && pExtraInfo->ExistsInfoItem(psTagName))
	{
		// Found it, remove it!
		bOk = pExtraInfo->RemoveInfoItem(psTagName);
	}

	// Now try to reinsert with the new value
	if (bOk)
	{
		CTDVString sNewValue;
		sNewValue << "<" << psTagName << ">" << sValue << "</" << psTagName << ">";
		bOk = bOk && pExtraInfo->AddUniqueInfoItem(psTagName, sNewValue);
	}

	// Return the verdict
	return bOk;
}

/*********************************************************************************

	bool CFrontPageLayout::SetFrontPageLayoutType(int iType)

		Author:		Mark Howitt
        Created:	08/07/2005
        Inputs:		iType - The new type of layout for the front page
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Sets the Forontpage layout type in the extra info

*********************************************************************************/
bool CFrontPageLayout::SetFrontPageLayoutType(int iType)
{
	// Make sure we've been initialised!
	if (!m_PageBody.IsInitialised())
	{
		return SetDNALastError("CFrontPageLayout::SetFrontPageLayoutType","NotInitialised","Page has not been initialised!");
	}

	// Set the new value and check for errors
	if (!SetExtraInfoValue("LAYOUT",CTDVString(iType)))
	{
		return SetDNALastError("CFrontPageLayout::SetFrontPageLayoutType","FailedToSetLayout","Failed to set layout type for page!");
	}

	// Remove the FRONTPAGE Tag from the Body if we're not using GuideML for the frontpage
	if (iType < LAYOUT_GUIDEML_INDICATOR)
	{
		// Remove contents of the tag
		m_PageBody.RemoveTagContents("FRONTPAGE");
		m_PageBody.UpdateBody();
	}

	// Return the verdict
	return true;
}

/*********************************************************************************

	bool CFrontPageLayout::SetFrontPageElementType(int iType)

		Author:		Mark Howitt
        Created:	08/07/2005
        Inputs:		iType - The new Element type
        Outputs:	-
        Returns:	true if ok, fasle if not
        Purpose:	Sets the new element type in the extra info

*********************************************************************************/
bool CFrontPageLayout::SetFrontPageElementType(int iType)
{
	// Make sure we've been initialised!
	if (!m_PageBody.IsInitialised())
	{
		return SetDNALastError("CFrontPageLayout::SetFrontPageElementType","NotInitialised","Page has not been initialised!");
	}

	// Set the new value and check for errors
	if (!SetExtraInfoValue("ELEMTEMPLATE",CTDVString(iType)))
	{
		return SetDNALastError("CFrontPageLayout::SetFrontPageElementType","FailedToSetElementType","Failed to set the element type for the page!");
	}

	// Return the verdict
	return true;
}

/*********************************************************************************

	bool CFrontPageLayout::SetFromtPageTemplateType(int iType)

		Author:		Mark Howitt
        Created:	08/07/2005
        Inputs:		iType - The new Template type for the fornt page
        Outputs:	-
        Returns:	True if ok, false if not
        Purpose:	Sets the new template type for the frontpage

*********************************************************************************/
bool CFrontPageLayout::SetFromtPageTemplateType(int iType)
{
	// Make sure we've been initialised!
	if (!m_PageBody.IsInitialised())
	{
		return SetDNALastError("CFrontPageLayout::SetFromtPageTemplateType","NotInitialised","Page has not been initialised!");
	}

	// Set the new value and check for errors
	if (!SetExtraInfoValue("TEMPLATE",CTDVString(iType)))
	{
		return SetDNALastError("CFrontPageLayout::SetFromtPageTemplateType","FailedToSetTemplateType","Failed to set the template type for the page!");
	}

	// Return the verdict
	return true;
}

/*********************************************************************************

	bool CFrontPageLayout::SetFrontPageElementGuideML(const TDVCHAR* psElementGuideML)

		Author:		Mark Howitt
        Created:	08/07/2005
        Inputs:		psELementGuideML - The new GuideML for the frontpage elements
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Sets the GuideML for the frontpage elements

*********************************************************************************/
bool CFrontPageLayout::SetFrontPageElementGuideML(const TDVCHAR* psElementGuideML)
{
	// Make sure we've been initialised!
	if (!m_PageBody.IsInitialised())
	{
		return SetDNALastError("CFrontPageLayout::SetFrontPageElementGuideML","NotInitialised","Page has not been initialised!");
	}

	// Set the new value and check for errors
	if (!SetExtraInfoValue("ELEMTEMPLATE-GUIDEML",CTDVString(psElementGuideML)))
	{
		return SetDNALastError("CFrontPageLayout::SetFrontPageElementGuideML","FailedToSetElementGuideML","Failed to set the GuideML for the elements of the page!");
	}

	// Return the verdict
	return true;
}

/*********************************************************************************

	bool CFrontPageLayout::AddEscapedElementGuideML()

		Author:		Mark Howitt
        Created:	11/07/2005
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Inserts an Escaped version of the ElementGuideML into the XML

*********************************************************************************/
bool CFrontPageLayout::AddEscapedElementGuideML()
{
	// Make sure we've been initialised!
	if (!m_PageBody.IsInitialised())
	{
		return SetDNALastError("CFrontPageLayout::AddEscapedElementGuideML","NotInitialised","Page has not been initialised!");
	}

	// Get the current extra info and then set the new value
	CExtraInfo* pExtraInfo = m_PageBody.GetExtraInfo();
	if (pExtraInfo == NULL)
	{
		return SetDNALastError("CFrontPageLayout::AddEscapedElementGuideML","FailedToGetExtraInfo","Failed To get the extra info block!!!");
	}

	// See if the ELEMTEMPLATE-GUIDEML actually exists
	if (!pExtraInfo->ExistsInfoItem("ELEMTEMPLATE-GUIDEML"))
	{
		// Doesn't Exist! No worries, don't need to do anything!
		return true;
	}

	// Get the current value
	CTDVString sElementGuideML;
	if (!pExtraInfo->GetInfoItem("ELEMTEMPLATE-GUIDEML",sElementGuideML))
	{
		return SetDNALastError("CFrontPageLayout::AddEscapedElementGuideML","FailedToGetElementGuideML","Failed To get the Element GuideML!!!");
	}

	// Now Escape and insert the new Element
	EscapeAllXML(&sElementGuideML);
	if (!pExtraInfo->AddUniqueInfoItem("ELEMTEMPLATE-GUIDEML-ESCAPED","<ELEMTEMPLATE-GUIDEML-ESCAPED>" + sElementGuideML + "</ELEMTEMPLATE-GUIDEML-ESCAPED>"))
	{
		return SetDNALastError("CFrontPageLayout::AddEscapedElementGuideML","FailedToAddEscapedGuideML","Failed to insert Escaped GuideML For Elements");
	}

	return true;
}

/*********************************************************************************

	bool CFrontPageLayout::SetUpdateStep(int iStep)

		Author:		Mark Howitt
        Created:	13/07/2005
        Inputs:		iStep = the current step you're at
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Sets the Step value in the ExtraInfo. This tells the skins
					what was last updated

*********************************************************************************/
bool CFrontPageLayout::SetUpdateStep(int iStep)
{
	// Make sure we've been initialised!
	if (!m_PageBody.IsInitialised())
	{
		return SetDNALastError("CFrontPageLayout::SetFrontPageElementType","NotInitialised","Page has not been initialised!");
	}

	// Set the new value and check for errors
	if (!SetExtraInfoValue("UPDATE-STEP",CTDVString(iStep)))
	{
		return SetDNALastError("CFrontPageLayout::SetFrontPageElementType","FailedToSetElementType","Failed to set the element type for the page!");
	}

	// Return the verdict
	return true;
}

/*********************************************************************************

	bool CFrontPageLayout::GetPageLayoutXML(CTDVString& sPageLayoutXML)

		Author:		Mark Neves
        Created:	14/07/2005
        Inputs:		-
        Outputs:	sPageLayoutXML - The string that will take the page layout XML
        Returns:	true if ok, false if not
        Purpose:	Returns the block of XML that represents the Page Layout info

*********************************************************************************/
bool CFrontPageLayout::GetPageLayoutXML(CTDVString& sPageLayoutXML)
{
	// Make sure we've been initialised!
	if (!m_PageBody.IsInitialised())
	{
		return SetDNALastError("CFrontPageLayout::GetPageLayoutXML","NotInitialised","Page has not been initialised!");
	}

	// Get the current extra info and then set the new value
	CExtraInfo* pExtraInfo = m_PageBody.GetExtraInfo();
	if (pExtraInfo == NULL)
	{
		return SetDNALastError("CFrontPageLayout::AddEscapedElementGuideML","FailedToGetExtraInfo","Failed To get the extra info block!!!");
	}

	// Get the values from the extrainfo
	if (!pExtraInfo->ExistsInfoItem("LAYOUT"))
	{
		// Not a messageboard frontpage! Just return without doing anything.
		return true;
	}

	// Insert the layout info
	CTDVString sLayoutType;
	if (!pExtraInfo->GetInfoItem("LAYOUT",sLayoutType))
	{
		// Something wrong here! We MUST have a Layout tag!!!
		return SetDNALastError("CFrontPageLayout::AddEscapedElementGuideML","FailedToGetLayoutInfo","Failed To get the Layout Type!!!");
	}

	// Open the Fronpage Page-layout tags
	sPageLayoutXML << "<PAGE-LAYOUT>";

	// Insert the layout type
	sPageLayoutXML << sLayoutType;

	// Insert the template type
	CTDVString sTemplateType;
	pExtraInfo->GetInfoItem("TEMPLATE",sTemplateType);
	sPageLayoutXML << sTemplateType;

	// Insert the Element Template Type
	CTDVString sElementTemplateType;
	pExtraInfo->GetInfoItem("ELEMTEMPLATE",sElementTemplateType);
	sPageLayoutXML << sElementTemplateType;

	// Insert the element guideml
	CTDVString sElementTemplateGuideML;
	pExtraInfo->GetInfoItem("ELEMTEMPLATE-GUIDEML",sElementTemplateGuideML);
	sPageLayoutXML << sElementTemplateGuideML;

	// Insert the update step if we have it
	CTDVString sUpdateStep;
	pExtraInfo->GetInfoItem("UPDATE-STEP",sUpdateStep);
	sUpdateStep.Replace("<UPDATE-STEP>","<UPDATE STEP='");
	sUpdateStep.Replace("</UPDATE-STEP>","'/>");
	sPageLayoutXML << sUpdateStep;

	// Finally close the tags
	sPageLayoutXML << "</PAGE-LAYOUT>";
	return true;
}

/*********************************************************************************

	bool CFrontPageLayout::SetFrontPageBodyText(const TDVCHAR* psBodyText)

		Author:		Mark Howitt
        Created:	18/07/2005
        Inputs:		psTextBody
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Sets the new Body Text for the frontpage

*********************************************************************************/
bool CFrontPageLayout::SetFrontPageBodyText(const TDVCHAR* psBodyText)
{
	// Make sure we've been initialised!
	if (!m_PageBody.IsInitialised())
	{
		return SetDNALastError("CFrontPageLayout::SetFrontPageBodyText","NotInitialised","Page has not been initialised!");
	}

	// remove the existing FRONTPAGE element
	m_PageBody.RemoveTag("FRONTPAGE");
	
	// If string is not found function will return -1
	CTDVString sText(psBodyText);
	if (sText.Find("<FRONTPAGE>") < 0)
	{
		sText.Prefix("<FRONTPAGE>");
		sText << "</FRONTPAGE>";
	}

	// Now insert the updated text
	if (!m_PageBody.AddInside("ARTICLE",sText))
	{
		return SetDNALastError("CFrontPageLayout::SetFrontPageBodyText","FailedToUpdateBody","Failed to Update the body text!!!");
	}

	// Now update the body text
	m_PageBody.UpdateBody();

	// return the verdict
	return true;
}

/*********************************************************************************

	bool CFrontPageLayout::CreateFromPageLayout()

		Author:		Mark Howitt
        Created:	28/07/2005
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Adds the PageLayout XML to the FrontPageLayout tree

*********************************************************************************/
bool CFrontPageLayout::CreateFromPageLayout()
{
	// Make sure we've been initialised!
	if (!m_PageBody.IsInitialised())
	{
		return SetDNALastError("CFrontPageLayout::SetFrontPageBodyText","NotInitialised","Page has not been initialised!");
	}

	// Create from the pagebody object
	CTDVString sPageBody;
	m_PageBody.GetAsString(sPageBody);
	if (!CreateFromXMLText(sPageBody,NULL,true))
	{
		return false;
	}

	// Remove the Extra Info block
	RemoveTag("EXTRAINFO");

	// Get the PageLayout XML
	CTDVString sPageLayoutInfo;
	if (!GetPageLayoutXML(sPageLayoutInfo))
	{
		return SetDNALastError("CFrontPageLayout::SetFrontPageBodyText","FailedToGetPageLayoutInfo","Failed to get the pagelayout info!!!");
	}

	// Insert the pagelayout info
	if (!AddInside("FRONTPAGE",sPageLayoutInfo))
	{
		return false;
	}

	return true;
}
