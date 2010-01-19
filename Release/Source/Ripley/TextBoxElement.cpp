#include "stdafx.h"
#include ".\textboxelement.h"
#include ".\tdvassert.h"
#include "threadsearchphrase.h"

CTextBoxElement::CTextBoxElement(CInputContext& inputContext) : CFrontPageElement(inputContext,ET_TEXTBOX,"TEXTBOX")
{
}

CTextBoxElement::~CTextBoxElement(void)
{
}

/*********************************************************************************

	bool CTextBoxElement::CreateNewTextBox(int iSiteID, int& iNewTextBoxID, int iFrontPagePos = 0, CTDVString* pEditKey = NULL)

		Author:		Mark Howitt
        Created:	03/11/2004
        Inputs:		iSiteID - The site that the textbox will belong to.
					iFrontPagePos - The position on the page for the new TextBox, 0 = Auto placement
        Outputs:	iNewElementID - The ID Of the new TextBox.
					pEditKey - contains the new edit key, (can be NULL)
        Returns:	true if ok, false if not.
        Purpose:	Creates a new textbox element for the given site.

*********************************************************************************/
bool CTextBoxElement::CreateNewTextBox(int iSiteID, int iEditorID, int& iNewTextBoxID, int iFrontPagePos,CTDVString* pEditKey)
{
	// Call the base class with the correct element type and status.
	CTDVString sEditKey;
	bool bOK = CreateNewElement(ES_PREVIEW,iSiteID,iEditorID, iNewTextBoxID,sEditKey,iFrontPagePos);

	if (pEditKey != NULL)
	{
		*pEditKey = sEditKey;
	}

	return bOK;
}

/*********************************************************************************

	bool CTextBoxElement::CreateInternalXMLForElement(CDBXMLBuilder& XML)

		Author:		Martin Robb
        Created:	01/08/2005
        Inputs:		XML Builder
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Override - allows XML to be injected that is specific to this class of element.

*********************************************************************************/
bool CTextBoxElement::CreateInternalXMLForElement(CDBXMLBuilder& XML)
{
	// Now see what type of element we are, and pick out the relevant info
	bool bOk = XML.AddIntTag("TEXTBOXTYPE",m_iTextBoxType);
	bOk = bOk && XML.AddIntTag("TEXTBORDERTYPE",m_iTextBoarderType);

	//Get any Key Phrases specified for this textbox.
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	if ( !SP.GetFrontPageElementKeyPhrases(m_InputContext.GetSiteID(),m_eFrontPageElementType, m_iElementID,NULL) )
	{
		TDVASSERT(false, "Failed to get keyphrases for element");
		SetDNALastError("CFrontPageElement::CreateXMLForElement","CreateXMLForElement","Failed to get keyphrases");
		return false;
	}

	CTDVString sPhrase;
	CTDVString sNamespace="";
	SEARCHPHRASELIST phrases;
	while (!SP.IsEOF())
	{
		SP.GetField("Phrase",sPhrase);
		if(SP.FieldExists("Namespace") && !SP.IsNULL("Namespace"))
		{
			SP.GetField("Namespace", sNamespace);
		}
		
		PHRASE phrase(sNamespace, sPhrase);
		phrases.push_back(phrase);
		SP.MoveNext();
	}
	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CThreadSearchPhrase tsp(m_InputContext,delimit);
	tsp.SetPhraseList(phrases);
	tsp.GeneratePhraseListXML(XML);
	return bOk;
}

/*********************************************************************************

	bool CTextBoxElement::DeleteTextBox(int iTextBoxID)

		Author:		Mark Howitt
        Created:	04/11/2004
        Inputs:		iTextBoxID - The Id of the text box you're trying top delete
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Deletes the given TextBox. The base class does a sanity check
					to make sure the id belongs to the coreect element type!

*********************************************************************************/
bool CTextBoxElement::DeleteTextBox(int iTextBoxID,int iUserID)
{
	// Call the base class function
	return DeleteElement(iTextBoxID,iUserID);
}

/*********************************************************************************

	bool CTextBoxElement::GetTextBoxesForSiteID(int iSiteID, eElementStatus ElementStatus, int iActiveBoxID)

		Author:		Mark Howitt
        Created:	01/11/2004
        Inputs:		iSiteID - The ID of the site you want to get the text box elements for.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Creates a list of textbox elements for a given site.

*********************************************************************************/
bool CTextBoxElement::GetTextBoxesForSiteID(int iSiteID, eElementStatus ElementStatus, int iActiveBoxID)
{
	// Call the base class with the correct element type
	return GetElementsForSiteID(iSiteID,ElementStatus,iActiveBoxID);
}

bool CTextBoxElement::GetTextBoxesForPhrase( int iSiteId, const SEARCHPHRASELIST& phrases, eElementStatus elementstatus )
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	if ( !SP.GetFrontPageElementsForPhrases( iSiteId, phrases, m_eFrontPageElementType, elementstatus ) )
	{
		SetDNALastError("CMessageBoardPromo::GetBoardPromosForPhrase", "CMessageBoardPromosForPhrase::GetBoardPromosForPhrase","Failed to get Promos for Phrase");
		return false;
	}

	CTDVString sXML;
	CDBXMLBuilder XML;
	XML.Initialise(&sXML);
	bool bOk = XML.OpenTag(m_sElementTagName+"LIST",false);
	
	while (!SP.IsEOF() && bOk)
	{
		// Create the XML For the element
		bOk = bOk && GetElementDetailsFromDatabase(SP);
		bOk = bOk && CreateXMLForElement(XML);

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

	bool CTextBoxElement::GetTextBoxDetails(int iTextBoxID)

		Author:		Mark Howitt
        Created:	03/11/2004
        Inputs:		iTextBoxID - the id of the textbox you want to get the details for.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Gets the current detials for the given textbox id.

*********************************************************************************/
bool CTextBoxElement::GetTextBoxDetails(int iTextBoxID)
{
	// Call the base class function with the correct element type
	return GetElementDetails(iTextBoxID);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::SetTemplateType(int iTextBoxID, int iType, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iTextBoxID,iType,bCommitChanges,EV_TEMPLATETYPE, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::SetTitle(int iTextBoxID, const TDVCHAR* psTitle, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iTextBoxID,psTitle,bCommitChanges,EV_TITLE, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::SetText(int iTextBoxID, const TDVCHAR* psText, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iTextBoxID,psText,bCommitChanges,EV_TEXT, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::SetPosition(int iTextBoxID, int iPosition, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iTextBoxID,iPosition,bCommitChanges,EV_FRONTPAGEPOSITION, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::SetImageName(int iTextBoxID, const TDVCHAR* psImageName, bool bCommitChanges, int iUserID,  const TDVCHAR* psEditKey)
{
	return SetElementValue(iTextBoxID,psImageName,bCommitChanges,EV_IMAGENAME, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::SetTextBoxType(int iTextBoxID, int iBoxType, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iTextBoxID,iBoxType,bCommitChanges,EV_TEXTBOXTYPE, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::SetBorderType(int iTextBoxID, int iBorderType, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iTextBoxID,iBorderType,bCommitChanges,EV_TEXTBORDERTYPE, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::SetImageWidth(int iTextBoxID, int iImageWidth, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iTextBoxID,iImageWidth,bCommitChanges,EV_IMAGEWIDTH, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::SetImageHeight(int iTextBoxID, int iImageHeight, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iTextBoxID,iImageHeight,bCommitChanges,EV_IMAGEHEIGHT, iUserID, psEditKey);
}

bool CTextBoxElement::SetImageAltText(int iTextBoxID, const TDVCHAR* psImageAltText, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iTextBoxID,psImageAltText,bCommitChanges,EV_IMAGEALTTEXT, iUserID, psEditKey);
}

bool CTextBoxElement::SetKeyPhrases( int iTextBoxId, const SEARCHPHRASELIST& vPhrases )
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	return SP.UpdateTextBoxKeyPhrases(iTextBoxId, vPhrases);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::CommitTextBoxChanges(int iUserID, const TDVCHAR* psEditKey)
{
	bool bOk =  CommitElementChanges(iUserID,psEditKey);
	return bOk;
}

// Wrapper function for the BaseClass
bool CTextBoxElement::MakePreviewTextBoxesActive(int iSiteID, int iEditorID, int iTextBoxID)
{
	return MakeElementsActiveForSite(iSiteID,iEditorID,iTextBoxID);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::GetTextBoxTitle(CTDVString& sTitle, int iElementID)
{
	return GetElementValue(EV_TITLE,sTitle,iElementID);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::GetTextBoxText(CTDVString& sText, int iElementID)
{
	return GetElementValue(EV_TEXT,sText,iElementID);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::GetTextBoxImageName(CTDVString& sImageName, int iElementID)
{
	return GetElementValue(EV_IMAGENAME,sImageName,iElementID);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::GetTextBoxImageWidth(int& iImageWidth, int iElementID)
{
	return GetElementValue(EV_IMAGEWIDTH,iImageWidth,iElementID);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::GetTextBoxImageHeight(int& iImageHeight, int iElementID)
{
	return GetElementValue(EV_IMAGEHEIGHT,iImageHeight,iElementID);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::GetTextBoxImageAltText(CTDVString& sImageAltText, int iElementID)
{
	return GetElementValue(EV_IMAGEALTTEXT,sImageAltText,iElementID);
}

// Wrapper function for the BaseClass
bool CTextBoxElement::GetNumberOfTextBoxesForSiteID(int iSiteID, int& iNumberOfTextBoxes, eElementStatus ElementStatus)
{
	return GetNumberOfFrontPageElementsForSiteID(iSiteID,ElementStatus,iNumberOfTextBoxes);
}
