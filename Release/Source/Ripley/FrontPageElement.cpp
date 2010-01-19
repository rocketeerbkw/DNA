#include "stdafx.h"
#include ".\frontpageelement.h"
#include ".\tdvassert.h"

CFrontPageElement::CFrontPageElement(CInputContext& inputContext, eElementType ElementType, const TDVCHAR* psElementTagName) : CXMLObject(inputContext),
						m_iUpdateElementID(0), m_bHaveStartedUpdate(false), m_iTopicID(0), m_iTextBoxType(0), m_iTemplateType(0),
                        m_iFrontPagePosition(0), m_iElementStatus(0), m_iLinkID(0), m_bUseNoOfPosts(true), m_iElementID(0), m_iSiteID(0),
						m_eFrontPageElementType(ET_VOID), m_iImageWidth(0), m_iImageHeight(0), m_iElementLinkID(0), m_iTextBoarderType(0),
						m_iForumPostCount(0), m_iEditorID(0)
{
	m_sElementTagName = psElementTagName;
	m_eFrontPageElementType = ElementType;
}

CFrontPageElement::~CFrontPageElement(void)
{
}

void CFrontPageElement::SetElementsLastActionXML(const TDVCHAR* psActionXML)
{
	m_LastActionXML = psActionXML;
}

CTDVString CFrontPageElement::GetElementsLastActionXML()
{
	return m_LastActionXML;
}

/*********************************************************************************

	bool CFrontPageElement::CreateNewElement(eElementStatus ElementStatus, int iSiteID, int &iNewElementID, CTDVString& sEditKey, int iFrontPagePos = 0, int iElementLinkID = 0)

		Author:		Mark Howitt
        Created:	03/11/2004
        Inputs:		ElementStatus - The status of the new element ES_PREVIEW or ES_LIVE
					iSiteID - the id of the site that the new element will belong to.
					
        Outputs:	iNewElementID - The new element id just created.
					sEditKey - The new EditKey for the new element.
        Returns:	true if ok, false if not
        Purpose:	Creates a new element of given type and status o a given site.

*********************************************************************************/
bool CFrontPageElement::CreateNewElement(eElementStatus ElementStatus, int iSiteID, int iEditorID, int &iNewElementID, CTDVString& sEditKey, int iFrontPagePos, int iElementLinkID)
{
	// Setup a stored procedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CFrontPageElement::CreateNewElement","FailedToInitialiseStoredProcedure","Failed creating stored procedure");
	}

	// Now call the procedure
	if (!SP.CreateFrontPageElement(iSiteID, iEditorID,(int)m_eFrontPageElementType,(int)ElementStatus,iElementLinkID,iFrontPagePos))
	{
		return SetDNALastError("CFrontPageElement::CreateNewElement","FailedCreatingNewElement","Failed Creating New Element!");
	}

	// Get the new element ID and edit key from the result.
	if (m_eFrontPageElementType == ET_TOPIC)
	{
		iNewElementID = SP.GetIntField("TopicElementID");
	}
	else if (m_eFrontPageElementType == ET_TEXTBOX)
	{
		iNewElementID = SP.GetIntField("TextBoxElementID");
	}
	else if (m_eFrontPageElementType == ET_BOARDPROMO)
	{
		iNewElementID = SP.GetIntField("BoardPromoElementID");
	}

	m_iElementID = iNewElementID;
	SP.GetField("EditKey",sEditKey);
	sEditKey.Replace("-","");

	return true;
}

/*********************************************************************************

	bool CFrontPageElement::DeleteElement(int iElementID)

		Author:		Mark Howitt
        Created:	03/11/2004
        Inputs:		iElementID - the id of the element you want to delete
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Marks the given element as deleted

*********************************************************************************/
bool CFrontPageElement::DeleteElement(int iElementID, int iUserID)
{
	// Setup the stored procedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CFrontPageElement::DeleteElement","FailedToInitialiseStoredProcedure","Failed creating stored procedure");
	}

	// Call the stored procedure
	if (!SP.DeleteFrontPageElement(iElementID,static_cast<int>(m_eFrontPageElementType), iUserID))
	{
		return SetDNALastError("CFrontPageElement::DeleteElement","FailedToDeleteElement","Failed to delete element");
	}

	// Check to make sure something was done!
	if (SP.GetIntField("ValidID") == 0)
	{
		return SetDNALastError("CFrontPageElement::DeleteElement","InvalidElementIDGiven","Invalid ElemenetID Given");
	}
	return true;
}

/*********************************************************************************

	bool CFrontPageElement::GetElementDetails(int iElementID)

		Author:		David E
        Created:	01/11/2004
        Inputs:		iElementID - the id of rht eelement you want to get the details for.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Gets all the details for a given frontpage element.

*********************************************************************************/
bool CFrontPageElement::GetElementDetails(int iElementID)
{
	// Setup the stored procedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CFrontPageElement::GetElementDetails","FailedToInitialiseStoredProcedure","Failed creating stored procedure");
	}

	// Now call the procedure
	if (!SP.GetFrontPageElementDetails(iElementID,m_eFrontPageElementType))
	{
		return SetDNALastError("CFrontPageElement::GetElementDetails","FailedToGetElementDetails","Failed to get elements deltails");
	}

	// Create the XML For the element if we found one!
	bool bOk = true;
	if (!SP.IsEOF())
	{
		// Do the XML Thing
		bOk = bOk && GetElementDetailsFromDatabase(SP);
		bOk = bOk && CreateXMLForCurrentState();
	}

	// Check to see if everything went ok
	if (!bOk)
	{
		return SetDNALastError("CFrontPageElement::GetElementsForSiteID","FailedToParseResults","Failed Parse Results");
	}

	// Set the member variable to the requested Element
	m_iElementID = iElementID;
	return true;
}

/*********************************************************************************

	bool CFrontPageElement::GetElementValue(eElementParam ElementParam, int& iValue, int iElementID)

		Author:		Mark Howitt
        Created:	09/12/2004
        Inputs:		ElementParam - The element param you want to get.
					iElementID - The id of the lement you want to get the details for.
        Outputs:	iValue - The Value of the param you want to get.
        Returns:	true if ok, false if not.
        Purpose:	Gets the integer value for a given element param.

*********************************************************************************/
bool CFrontPageElement::GetElementValue(eElementParam ElementParam, int& iValue, int iElementID)
{
	// Check to see if we are wanting to get the details for the current element or a new element
	if (iElementID != 0 && m_iElementID != iElementID)
	{
		// Get the details for the requested element
		if (!GetElementDetails(iElementID))
		{
			// Problems, return false!
			return false;
		}
	}
	else if (m_iElementID == 0)
	{
		// No element loaded!
		return SetDNALastError("CFrontPageElement::GetElementValue","ElementNotInitialised","Element is not valid!");
	}

	// Now set the value depending on the ElementParam
	if (ElementParam == EV_ELEMENTID)
	{
		iValue = m_iElementID;
	}
	else if (ElementParam == EV_TOPICID)
	{
		iValue = m_iTopicID;
	}
	else if (ElementParam == EV_TEMPLATETYPE)
	{
		iValue = m_iTemplateType;
	}
	else if (ElementParam == EV_TEXTBOXTYPE)
	{
		iValue = m_iTextBoxType;
	}
	else if (ElementParam == EV_TEXTBORDERTYPE)
	{
		iValue = 0; // Not used any more!
	}
	else if (ElementParam == EV_FRONTPAGEPOSITION)
	{
		iValue = m_iFrontPagePosition;
	}
	else if (ElementParam == EV_ELEMENTSTATUS)
	{
		iValue = m_iElementStatus;
	}
	else if (ElementParam == EV_LINKID)
	{
		iValue = m_iLinkID;
	}
/*
	// This is nolonger used by any of the elements
	else if (ElementParam == EV_USENUMBEROFPOSTS)
	{
		iValue = (int)m_bUseNoOfPosts;
	}
*/	
	else if (ElementParam == EV_SITEID)
	{
		iValue = m_iSiteID;
	}
	else if (ElementParam == EV_FRONTPAGEELEMENTTYPE)
	{
		iValue = (int)m_eFrontPageElementType;
	}
	else if (ElementParam == EV_IMAGEWIDTH)
	{
		iValue = m_iImageWidth;
	}
	else if (ElementParam == EV_IMAGEHEIGHT)
	{
		iValue = m_iImageHeight;
	}
	else
	{
		return SetDNALastError("CFrontPageElement::GetElementValue","IncorrectElementParamGiven","Incorrect Elemenet Parameter Given");
	}

	return true;
}

/*********************************************************************************

	bool CFrontPageElement::GetElementValue(eElementParam ElementParam, CTDVString& sValue, int iElementID)

		Author:		Mark Howitt
        Created:	09/12/2004
        Inputs:		ElementParam - The type of param you want ot get the value for.
					iElementId - the ID of the element that you want to get the param value for.
        Outputs:	sValue- the value of the param you want to get.
        Returns:	true if ok, false if not.
        Purpose:	Gets the string value for the given element param.

*********************************************************************************/
bool CFrontPageElement::GetElementValue(eElementParam ElementParam, CTDVString& sValue, int iElementID)
{
	// Check to see if we are wanting to get the details for the current element or a new element
	if (iElementID != 0 && m_iElementID != iElementID)
	{
		// Get the details for the requested element
		if (!GetElementDetails(iElementID))
		{
			// Problems, return false!
			return false;
		}
	}
	else if (m_iElementID == 0)
	{
		// No element loaded!
		return SetDNALastError("CFrontPageElement::GetElementValue","ElementNotInitialised","Element is not valid!");
	}

	// Now set the value depending on the ElementParam
	if (ElementParam == EV_TITLE)
	{
		sValue = m_sTitle;
	}
	else if (ElementParam == EV_TEXT)
	{
		sValue = m_sText;
	}
	else if (ElementParam == EV_IMAGENAME)
	{
		sValue = m_sImageName;
	}
	else if (ElementParam == EV_IMAGEALTTEXT)
	{
		sValue = m_sImageAltText;
	}
	else
	{
		return SetDNALastError("CFrontPageElement::GetElementValue","IncorrectElementParamGiven","Incorrect Elemenet Parameter Given");
	}
	return true;
}

/*********************************************************************************

	bool CFrontPageElement::GetElementsForSiteID(int iSiteID, eElementStatus ElementStatus, int iActiveElementID)

		Author:		Mark Howitt
        Created:	01/11/2004
        Inputs:		iSiteID - the id of the site you want to get all the elements for.
					ElementStatus - The Status of the elements you want to get!
						ES_LIVE, ES_PREVIEW
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets all the elements that belong to a given site.

*********************************************************************************/
bool CFrontPageElement::GetElementsForSiteID(int iSiteID, eElementStatus ElementStatus, int iActiveElementID)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CFrontPageElement::GetElementsForSiteID","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}

/*
	// Mark Howitt - Removed as not yet needed. This functionality will be comming soon, when the archiving system is developed a bit more.
	//				 Reinsert the iArchived flag in the GetFrontPageElementsForSiteID(...) function when needed!

	// Check to see if we're getting preview status elements. If so, get the archived status elements as well.
	int iArchived = -1;
	if (ElementStatus == ES_PREVIEW)
	{
		iArchived = ES_PREVIEWARCHIVED;
	}
*/

	// Now call the procedure
	if (!SP.GetFrontPageElementsForSiteID(iSiteID,m_eFrontPageElementType,ElementStatus/*,iArchived*/))
	{
		return SetDNALastError("CFrontPageElement::GetElementsForSiteID","FailedToGetElements","Failed to get elements for site");
	}

	// Now insert the results into the XML
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML);
	bool bOk = XML.OpenTag(m_sElementTagName+"LIST",true);
	if (ElementStatus == ES_PREVIEW)
	{
		bOk = bOk && XML.AddAttribute("STATUS","PREVIEW",true);
	}
	else
	{
		bOk = bOk && XML.AddAttribute("STATUS","ACTIVE",true);
	}
	
	// Go go through the results
	while (!SP.IsEOF() && bOk)
	{
		// Crete the XML For the element
		bOk = bOk && GetElementDetailsFromDatabase(SP);
		bOk = bOk && CreateXMLForElement(XML,iActiveElementID);

		// Now get the next result
		SP.MoveNext();
	}

	// Close the XML Block
	bOk = bOk && XML.CloseTag(m_sElementTagName+"LIST");

	// Check to see if everything went ok
	if (!bOk)
	{
		return SetDNALastError("CFrontPageElement::GetElementsForSiteID","FailedToParseResults","Failed Parse Results");
	}

	// Now create the tree
	if (!CreateFromXMLText(sXML,NULL,true))
	{
		return SetDNALastError("CFrontPageElement::GetElementsForSiteID","FailedToParseResults","Failed Creating XML");
	}

	return true;
}


/*********************************************************************************

	bool CFrontPageElement::CreateXMLForElement(CDBXMLBuilder& XML, int iActiveElementID)

		Author:		Mark Neves & Mark Howitt
        Created:	03/06/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-	Creates common XML from member elements.
						Should be overriden by concrete implementation to provide appropriate opening
						and closing tags.

*********************************************************************************/
bool CFrontPageElement::CreateXMLForElement(CDBXMLBuilder& XML, int iActiveElementID)
{
	// Get the values that require special or preXML
	CTDVString sDisplayText = m_sText;
	ReplaceReturnsWithBreaks(sDisplayText);

	// Open the XML Block with the correct element name
	bool bOk = XML.OpenTag(m_sElementTagName,true);

	// Check to see if we're the active element
	if (m_iElementID == iActiveElementID)
	{
		// Mark this element as the active one.
		bOk = bOk && XML.AddAttribute("EDITSTATUS","ACTIVE",true);
	}
	else
	{
		// Mark this element as inactive.
		bOk = bOk && XML.AddAttribute("EDITSTATUS","INACTIVE",true);
	}

	bOk = bOk && XML.AddIntTag("ELEMENTID",m_iElementID);
	bOk = bOk && XML.AddTag("TITLE",m_sTitle);
	bOk = bOk && XML.AddTag("TEXT",sDisplayText);
	bOk = bOk && XML.AddIntTag("SITEID",m_iSiteID);
	bOk = bOk && XML.AddIntTag("FRONTPAGEPOSITION",m_iFrontPagePosition);
	bOk = bOk && XML.AddIntTag("TEMPLATETYPE",m_iTemplateType);
	bOk = bOk && XML.AddTag("IMAGENAME",m_sImageName);
	bOk = bOk && XML.AddIntTag("IMAGEWIDTH",m_iImageWidth);
	bOk = bOk && XML.AddIntTag("IMAGEHEIGHT",m_iImageHeight);
	bOk = bOk && XML.AddTag("IMAGEALTTEXT",m_sImageAltText);
	bOk = bOk && XML.AddIntTag("ELEMENTSTATUS",m_iElementStatus);
	bOk = bOk && XML.AddIntTag("ELEMENTLINKID",m_iElementLinkID);
	bOk = bOk && XML.AddIntTag("ELEMENTTYPE",(int)m_eFrontPageElementType);
	bOk = bOk && XML.AddTag("EDITKEY",m_sEditKey);

	if ( m_iElementStatus == ES_PREVIEW || m_iElementStatus == ES_PREVIEWARCHIVED )
	{
		if ( m_dDateCreated.GetStatus() )
			bOk = bOk && XML.AddDateTag("DATECREATED",m_dDateCreated);
		if ( m_dLastUpdated.GetStatus() )
			bOk = bOk && XML.AddDateTag("LASTUPDATED",m_dLastUpdated);
		if ( m_iEditorID > 0 ) 
			bOk = bOk && XML.AddIntTag("USERID",m_iEditorID);
	}

	//Give specialised classes a chance to inject XML.
	CreateInternalXMLForElement(XML);

	
	if (m_eFrontPageElementType == ET_TOPIC)
	{
		bOk = bOk && XML.AddIntTag("TOPICID",m_iTopicID);
		bOk = bOk && XML.AddIntTag("FORUMPOSTCOUNT",m_iForumPostCount);
	}

	bOk = bOk && XML.CloseTag(m_sElementTagName);
	return bOk;
}

/*********************************************************************************

	bool CFrontPageElement::BeginElementUpdate(int iElementID)

		Author:		Mark Howitt
        Created:	01/11/2004
        Inputs:		iElementID - the element you are wanting to update.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Initialises the stored procedure memebr ready to start updating

*********************************************************************************/
bool CFrontPageElement::BeginElementUpdate(int iElementID )
{
	// Setup the stored procedure
	if (!m_InputContext.InitialiseStoredProcedureObject(&m_SP))
	{
		return SetDNALastError("CFrontPageElement::SetTitle","FailedToInitialiseStoredProcedure","Failed creating stored procedure");
	}

	// Set the status flag so that we know we can start setting values
	m_SP.StartUpdateFrontPageElement(iElementID, m_eFrontPageElementType );
	m_bHaveStartedUpdate = true;
	m_iUpdateElementID = iElementID;
	return true;
}

/*********************************************************************************

	bool CFrontPageElement::CommitElementChanges(const TDVCHAR* psEditKey,CTDVString* psNewEditKey)

		Author:		Mark Howitt
        Created:	01/11/2004
        Inputs:		psEditKey - The Unique edit key for the element.
					psNewEditKey - If not NULL, filled with new EditKey
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Calls the UpdateFrontPageElement procedure with the new params.
					It also checks to make sure that this call is valid via the EditKey.

					If all goes well, and psNewEditKey != NULL, it will contain the new
					edit key for this element.  In all other circumstances it will
					return empty.

*********************************************************************************/
bool CFrontPageElement::CommitElementChanges(int iUserID, const TDVCHAR* psEditKey,CTDVString* psNewEditKey)
{
	if (psNewEditKey != NULL)
	{
		psNewEditKey->Empty(); // Make sure this is empty, to indicate no new edit key available yet
	}

	// Check to make sure we've got a valid editkey!
	if (psEditKey == NULL || CTDVString(psEditKey).IsEmpty())
	{
		return SetDNALastError("CFrontPageElement::CommitElementChanges","InvalidEditKeyGiven","Invalid EditKey Given!");
	}

	// Check to see if we've actually done anything!
	if (!m_bHaveStartedUpdate)
	{
		// Just return true as this is not an error, just means none of the set functions were called!
		return true;
	}

	// Call the procedure
	bool bOk = m_SP.UpdateFrontPageElement(iUserID, psEditKey);

	// Now reset the status flag so that we know we need to reintialise the procedure
	m_bHaveStartedUpdate = false;
	m_iUpdateElementID = 0;

	// Check for errors!
	bool bSucceeded = true;
	if (!bOk)
	{
		SetDNALastError("CFrontPageElement::CommitElementChanges","FailedToUpdateFrontPageElement","Failed updating frontpage element");
		bSucceeded = false;
	}

	int iValidID = m_SP.GetIntField("ValidID");

	// Check to make sure the element was actually updated
	if (bSucceeded && iValidID == 0)
	{
		SetDNALastError("CFrontPageElement::CommitElementChanges","InvalidElementIDGivenToUpdate","Invalid ElementID Given To Update");
		bSucceeded = false;
	}

	// Check to see if someelse has done an update before this one!
	if (bSucceeded && iValidID == 2)
	{
		SetDNALastError("CFrontPageElement::CommitElementChanges","EditedByAnotherEditor","Edited By Another Editor");
		bSucceeded = false;
	}

	if (bSucceeded && psNewEditKey != NULL && m_SP.GetField("NewEditKey",*psNewEditKey))
	{
		if (psNewEditKey->IsEmpty())
		{
			bSucceeded = SetDNALastError("CFrontPageElement::CommitElementChanges","NoNewEditKey","No new edit key is available");
		}
	}

	if (bSucceeded && psNewEditKey != NULL && m_SP.GetField("NewEditKey",*psNewEditKey))
	{
		if (psNewEditKey->IsEmpty())
		{
			bSucceeded = SetDNALastError("CFrontPageElement::CommitElementChanges","NoNewEditKey","No new edit key is available");
		}
	}

	// Release the connection to the database, and return the verdict!
	m_SP.Release();
	return bSucceeded;
}

/*********************************************************************************

	bool CFrontPageElement::SetElementValue(int iElementID, int iValue, bool bCommitChanges, eElementParam ElementParam, const TDVCHAR* psEditKey)

		Author:		Mark Howitt
        Created:	02/11/2004
        Inputs:		iElementID - the id of the element you want to update.
					iValue - the new value for the element param.
					bCommitChanges - A flag that states whether to update the database after setting the value.
					ElementParam - The Param to update see eElementParam in .h file.
					bApplyTemplateToAllInSite - This Param is valid only when used with EV_TEMPLATETYPE
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Sets the value of one of the params in the element.
					This function also checks to see if the procedure is initialised and if not
					does the work to do so. It can also commit the changes if required.

		NOTES:		This function handles all the int parameters.

*********************************************************************************/
bool CFrontPageElement::SetElementValue(int iElementID, int iValue, bool bCommitChanges, eElementParam ElementParam, int iUserID, const TDVCHAR* psEditKey, bool bApplyTemplateToAllInSite/* = true*/)
{
	// Check to see if the procedure has been initialised yet
	bool bOk = true;
	if (!m_bHaveStartedUpdate)
	{
		// Start the procedure
		bOk = BeginElementUpdate(iElementID);
	}

	// Make sure that we're updating the same element!
	if (m_iUpdateElementID != iElementID)
	{
		return SetDNALastError("CFrontPageElement::SetElementValue","TryingToUpdateADifferentElement","Trying to update a different element!");
	}

	// Make sure we ok before setting the values
	if (bOk)
	{
		// Now set the value depending on the ElementParam
		if (ElementParam == EV_TOPICID)
		{
			m_SP.SetFPElementTopicID(iValue);
			m_iTopicID = iValue;
		}
		else if (ElementParam == EV_TEMPLATETYPE)
		{
			if ( bApplyTemplateToAllInSite )
			{
				m_SP.SetFPElementTemplateTypeToAllInSite(true);
			}
			m_SP.SetFPElementTemplateType(iValue);
			m_iTemplateType = iValue;
		}
		else if (ElementParam == EV_TEXTBOXTYPE)
		{
			m_SP.SetFPElementTextBoxType(iValue);
			m_iTextBoxType = iValue;
		}
		else if (ElementParam == EV_TEXTBORDERTYPE)
		{
			m_SP.SetFPElementBorderType(iValue);
			m_iTextBoarderType = iValue;
		}
		else if (ElementParam == EV_FRONTPAGEPOSITION)
		{
			m_SP.SetFPElementPosition(iValue);
			m_iFrontPagePosition = iValue;
		}
		else if (ElementParam == EV_ELEMENTSTATUS)
		{
			m_SP.SetFPElementStatus(iValue);
			m_iElementStatus = iValue;
		}
		else if (ElementParam == EV_LINKID)
		{
			m_SP.SetFPElementLinkID(iValue);
			m_iLinkID = iValue;
		}
		else if (ElementParam == EV_IMAGEWIDTH)
		{
			m_SP.SetFPElementImageWidth(iValue);
			m_iImageWidth = iValue;
		}
		else if (ElementParam == EV_IMAGEHEIGHT)
		{
			m_SP.SetFPElementImageHeight(iValue);
			m_iImageHeight = iValue;
		}
		/*
		// Nolonger used by any of the elements
		else if (ElementParam == EV_USENUMBEROFPOSTS)
		{
			m_SP.SetFPElementUseNoOfPosts(iValue);
		}
*/
		else
		{
			return SetDNALastError("CFrontPageElement::SetElementValue","IncorrectElementParamGiven","Incorrect Elemenet Parameter Given");
		}

		// See if we are required to commit the new changes
		if (bCommitChanges)
		{
			// Commit the changes
			bOk = CommitElementChanges(iUserID, psEditKey);
		}
	}

	// return the verdict!
	return bOk;
}

/*********************************************************************************

	bool CFrontPageElement::SetElementValue(int iElementID, const TDVCHAR* psValue, bool bCommitChanges, eElementParam ElementParam, int iUserID, const TDVCHAR* psEditKey)

		Author:		Mark Howitt
        Created:	02/11/2004
        Inputs:		iElementID - the id of the element you want to update.
					psValue - the new value for the element param.
					bCommitChanges - A flag that states whether to update the database after setting the value.
					ElementParam - The Param to update see eElementParam in .h file.
        Outputs:	pbParseErrors - A pointer to a flag that takes the status of the parsing of the text.
        Returns:	true if ok, false if not.
        Purpose:	Sets the value of one of the params in the element.
					This function also checks to see if the procedure is initialised and if not
					does the work to do so. It can also commit the changes if required.

		NOTES:		This function handles all the string parameters.
*********************************************************************************/
bool CFrontPageElement::SetElementValue(int iElementID, const TDVCHAR* psValue, bool bCommitChanges, eElementParam ElementParam, int iUserID, const TDVCHAR* psEditKey)
{
	// Check to see if the procedure has been initialised yet
	bool bOk = true;
	if (!m_bHaveStartedUpdate)
	{
		// Start the procedure
		bOk = BeginElementUpdate(iElementID);
	}

	// Make sure that we're updating the same element!
	if (m_iUpdateElementID != iElementID)
	{
		return SetDNALastError("CFrontPageElement::SetElementValue","TryingToUpdateADifferentElement","Trying to update a different element!");
	}

	// Make sure we ok before setting the values
	if (bOk)
	{
		// Now set the value depending on the ElementParam
		if (ElementParam == EV_TITLE)
		{
			m_SP.SetFPElementTitle(psValue);
			m_sTitle = psValue;
		}
		else if (ElementParam == EV_TEXT)
		{
			m_SP.SetFPElementText(psValue);
			m_sText = psValue;
		}
		else if (ElementParam == EV_IMAGENAME)
		{
			m_SP.SetFPElementImageName(psValue);
			m_sImageName = psValue;
		}
		else if (ElementParam == EV_IMAGEALTTEXT)
		{
			m_SP.SetFPElementImageAltText(psValue);
			m_sImageAltText = psValue;
		}
		else
		{
			return SetDNALastError("CFrontPageElement::SetElementValue","IncorrectElementParamGiven","Incorrect Elemenet Parameter Given");
		}

		// See if we are required to commit the new changes
		if (bCommitChanges)
		{
			// Commit the changes
			bOk = CommitElementChanges(iUserID, psEditKey);
		}
	}

	// return the verdict!
	return bOk;
}

/*********************************************************************************

	bool CFrontPageElement::MakePreviewItemActive(int iElementID)

		Author:		Mark Howitt
        Created:	30/11/2004
        Inputs:		iElementID - Elemnt Id of the item you want to make active
					iEditorID - UserID of editor
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Copies or creates the active item from the preview item.

*********************************************************************************/
bool CFrontPageElement::MakePreviewItemActive(int iElementID, int iEditorID)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CFrontPageElement::MakePreviewItemActive","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}

	// Now call the procedure
	if (!SP.MakeFrontPageElementActive(iElementID, iEditorID, m_eFrontPageElementType))
	{
		return SetDNALastError("CFrontPageElement::MakePreviewItemActive","FailedToMakeItemActive","Failed making preview item active");
	}

	return true;
}

/*********************************************************************************

	bool CFrontPageElement::MakeElementsActiveForSite(int iSiteID, int iElementID)

		Author:		Mark Howitt
        Created:	30/11/2004
        Inputs:		iSiteID - The ID of the site you want to make the elements active.
					iElementID - An optional param that allowes you to update a single element only.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Makes all the elements of a given type for a given site active.
					It optinally allowes you to update a single element.

*********************************************************************************/
bool CFrontPageElement::MakeElementsActiveForSite(int iSiteID, int iEditorID, int iElementID)
{
	// Check to see if we are updating a single element or all elements of type
	bool bOk = true;
	if (iElementID != 0)
	{
		// We're updaing a single element!
		return MakePreviewItemActive(iElementID, iEditorID);
	}
	else
	{
		// We need to get all the element ids for the the given type on the site.
		// Create and initialise a storedprocedure
		CStoredProcedure SP;
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			return SetDNALastError("CFrontPageElement::MakeElementsActiveForSite","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
		}

		// Call the procedure to make the preview elements active
		if (!SP.MakeFrontPageElementsActive(iSiteID,iEditorID,m_eFrontPageElementType))
		{
			return SetDNALastError("CFrontPageElement","MakeElementsActiveForSite","Failed to Mkae FrontPage elements Active!");
		}
	}
	// Return the verdict.
	return bOk;
}

/*********************************************************************************

	bool CFrontPageTopicElement::sp_GetNumberOfFrontPageTopicElementsForSiteID(int iSiteID, CFrontPageElement::eElementStatus ElementStatus, int& iNumTopicElements)

		Author:		DavidE
        Created:	12/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CFrontPageElement::GetNumberOfFrontPageElementsForSiteID(int iSiteID, CFrontPageElement::eElementStatus ElementStatus, int& iNumElements)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTopic::GetNumberOfFrontPageElementsForSiteID","FailedTo_GetNumberOfFrontPageElementsForSiteID","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	if (!SP.GetNumberOfFrontPageElementsForSiteID(iSiteID, m_eFrontPageElementType, ElementStatus, iNumElements))
	{
		return SetDNALastError("CFrontPageTopicElement::GetNumberOfFrontPageElementsForSiteID","FailedToGetNumberOfFrontPageElementsForSiteID","Failed to Get Number Of FrontPage Elements For Site ID");
	}

	//check that record was updated
	iNumElements = SP.GetIntField("NumOfElements");				
	return true;
}

/*********************************************************************************

	bool CFrontPageElement::CreateXMLForCurrentState(void)

		Author:		Mark Neves & Mark Howitt
        Created:	03/06/2005
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Creates the Element XML Block from the current member variables

*********************************************************************************/
bool CFrontPageElement::CreateXMLForCurrentState(void)
{
	// Now insert the results into the XML
	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML);

	// Check to see if everything went ok
	if (!CreateXMLForElement(XML,0))
	{
		return SetDNALastError("CFrontPageElement::GetElementsForSiteID","FailedToParseResults","Failed Parse Results");
	}

	// Now create the tree
	if (!CreateFromXMLText(sXML,NULL,true))
	{
		return SetDNALastError("CFrontPageElement::GetElementsForSiteID","FailedToParseResults","Failed Creating XML");
	}

	// Return the verdict!
	return true;
}

/*********************************************************************************

	bool CFrontPageElement::GetElementDetailsFromDatabase(CStoredProcedure& SP)

		Author:		Mark Neves & Mark Howitt
        Created:	03/06/2005
        Inputs:		SP - The storedprocedure that contains the result set
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets the details of the element from the database

*********************************************************************************/
bool CFrontPageElement::GetElementDetailsFromDatabase(CStoredProcedure& SP)
{
	// Do the Element Specific stuff first!
	if (m_eFrontPageElementType == ET_TOPIC)
	{
		m_iElementID = SP.GetIntField("TOPICELEMENTID");
	}
	else if (m_eFrontPageElementType == ET_TEXTBOX)
	{
		m_iElementID = SP.GetIntField("TEXTBOXELEMENTID");
	}
	else if (m_eFrontPageElementType == ET_BOARDPROMO)
	{
		m_iElementID = SP.GetIntField("BOARDPROMOELEMENTID");
	}
    
	// Get the values that require special or preXML
	bool bOk = SP.GetField("TEXT",m_sText);
	bOk = bOk && SP.GetField("TITLE",m_sTitle);
	m_iSiteID = SP.GetIntField("SITEID");
	m_iFrontPagePosition = SP.GetIntField("FRONTPAGEPOSITION");
	m_iTemplateType = SP.GetIntField("TEMPLATETYPE");
	bOk = bOk && SP.GetField("IMAGENAME",m_sImageName);
	m_iImageWidth = SP.GetIntField("IMAGEWIDTH");
	m_iImageHeight = SP.GetIntField("IMAGEHEIGHT");
	bOk = bOk && SP.GetField("IMAGEALTTEXT",m_sImageAltText);
	m_iElementStatus = SP.GetIntField("ELEMENTSTATUS");
	m_iElementLinkID = SP.GetIntField("ELEMENTLINKID");

	if ( !SP.IsNULL("DateCreated")  )
		m_dDateCreated = SP.GetDateField("DateCreated");
	else
		m_dDateCreated = CTDVDateTime();
	if ( !SP.IsNULL("LastUpdated") )
		m_dLastUpdated = SP.GetDateField("LastUpdated");
	else
		m_dLastUpdated = CTDVDateTime();
	if ( !SP.IsNULL("UserID") )
		m_iEditorID = SP.GetIntField("UserID");
	else
		m_iEditorID = 0;

	bOk = bOk && SP.GetField("EDITKEY",m_sEditKey);

	if (m_eFrontPageElementType == ET_TEXTBOX || m_eFrontPageElementType == ET_BOARDPROMO )
	{
		m_iTextBoxType = SP.GetIntField("TEXTBOXTYPE");
	}
	else if (m_eFrontPageElementType == ET_TOPIC)
	{
		m_iTopicID = SP.GetIntField("TOPICID");
		m_iForumPostCount = SP.GetIntField("FORUMPOSTCOUNT");
	}
	return bOk;
}
