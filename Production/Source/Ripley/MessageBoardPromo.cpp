#include "stdafx.h"
#include <vector>
#include ".\messageboardpromo.h"
#include ".\tdvassert.h"
#include "threadsearchphrase.h"

CMessageBoardPromo::CMessageBoardPromo(CInputContext& inputContext) : CFrontPageElement(inputContext,ET_BOARDPROMO,"BOARDPROMO")
{
}

CMessageBoardPromo::~CMessageBoardPromo(void)
{
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::CreateNewBoardPromo(int iSiteID, int iEditorID, int& iPromoID,CTDVString* pEditKey)
{
	CTDVString sEditKey;
	bool bOK = CreateNewElement(ES_PREVIEW,iSiteID,iEditorID,iPromoID,sEditKey);

	if (pEditKey != NULL)
	{
		*pEditKey = sEditKey;
	}

	return bOK;
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::DeleteBoardPromo(int iPromoID, int iUserID)
{
	return DeleteElement(iPromoID, iUserID);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::GetBoardPromosForSite(int iSiteID, eElementStatus ElementStatus, int iActivePromoID)
{
	return GetElementsForSiteID(iSiteID,ElementStatus,iActivePromoID);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::GetBoardPromoDetails(int iPromoID)
{
	return GetElementDetails(iPromoID);
}

bool CMessageBoardPromo::GetBoardPromosForPhrase( int iSiteId, const SEARCHPHRASELIST&  phrases, eElementStatus elementstatus )
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

	bool CMessageBoardPromo::CreateInternalXMLForElement

		Author:		Martin Robb
        Created:	01/08/2005
        Inputs:		XML Builder
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Override - allows customised XML for this class to be injected into a template/schema defined by the base class.

*********************************************************************************/
bool CMessageBoardPromo::CreateInternalXMLForElement(CDBXMLBuilder& XML )
{
	bool bOk = XML.AddIntTag("TEXTBOXTYPE",m_iTextBoxType);
	bOk = bOk && XML.AddIntTag("TEXTBORDERTYPE",m_iTextBoarderType);

	// Initialise and call the storedprocedure to get the locations.
	CStoredProcedure SP;
	if (m_InputContext.InitialiseStoredProcedureObject(SP) && SP.GetBoardPromoLocations(m_iElementID))
	{
		// Open and insert the locations
		bOk = bOk && XML.OpenTag("TOPICLOCATIONS");
		int iTopicID = 0;
		bool bIsDefaultBoardPromo = false;
		while (!SP.IsEOF())
		{
			// Add each of the topic locations
			iTopicID = SP.GetIntField("TopicID");
			bOk = bOk && XML.AddIntTag("TopicID",iTopicID);

			// See if this is the default board promo for the site
			bIsDefaultBoardPromo = bIsDefaultBoardPromo || SP.GetIntField("DefaultBoardPromoID") == m_iElementID;
			SP.MoveNext();
		}
		bOk = bOk && XML.CloseTag("TOPICLOCATIONS");

		// Add the default site promo status
		bOk = bOk && XML.AddIntTag("DEFAULTSITEPROMO",bIsDefaultBoardPromo);
	}

	//Get the name of the boardpromo
	bOk = bOk && XML.AddTag("Name",m_sBoardPromoName);

	//Get any Key Phrases specified for this promo.
	int idefaultkeyphrasepromo = 0;
	if ( !SP.GetFrontPageElementKeyPhrases(m_InputContext.GetSiteID(),m_eFrontPageElementType, m_iElementID, &idefaultkeyphrasepromo) )
	{
		TDVASSERT(false, "Failed to get keyphrases for element");
		SetDNALastError("CFrontPageElement::CreateXMLForElement","CreateXMLForElement","Failed to get keyphrases");
		return false;
	}

	CTDVString sPhrase;
	CTDVString sNamespace="";
	SEARCHPHRASELIST phrases;
	while ( !SP.IsEOF() )
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

	//Indicate if promo is a default site key phrase promo.
	bOk = bOk && XML.AddIntTag("DEFAULTSITEKEYPHRASEPROMO",(idefaultkeyphrasepromo != 0 )) ;

	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CThreadSearchPhrase tsp(m_InputContext,delimit);
	tsp.SetPhraseList(phrases);
	tsp.GeneratePhraseListXML(XML);

	return bOk;
}

bool CMessageBoardPromo::GetElementDetailsFromDatabase(CStoredProcedure& SP)
{
	bool bOk = CFrontPageElement::GetElementDetailsFromDatabase(SP);
	bOk = bOk && SP.GetField("NAME",m_sBoardPromoName);
	m_iTextBoxType = SP.GetIntField("TEXTBOXTYPE");
	return bOk;
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::SetTemplateType(int iPromoID, int iType, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iPromoID,iType,bCommitChanges,EV_TEMPLATETYPE, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::SetTitle(int iPromoID, const TDVCHAR* psTitle, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iPromoID,psTitle, bCommitChanges, EV_TITLE, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::SetText(int iPromoID, const TDVCHAR* psText, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iPromoID,psText,bCommitChanges,EV_TEXT, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::SetImageName(int iPromoID, const TDVCHAR* psImageName, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iPromoID,psImageName,bCommitChanges,EV_IMAGENAME, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::SetBoardPromoType(int iPromoID, int iBoxType, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iPromoID,iBoxType,bCommitChanges,EV_TEXTBOXTYPE,iUserID,psEditKey);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::SetImageWidth(int iPromoID, int iImageWidth, bool bCommitChanges, int iUserID,  const TDVCHAR* psEditKey)
{
	return SetElementValue(iPromoID,iImageWidth,bCommitChanges,EV_IMAGEWIDTH, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::SetImageHeight(int iPromoID, int iImageHeight, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iPromoID,iImageHeight,bCommitChanges,EV_IMAGEHEIGHT, iUserID, psEditKey);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::SetImageAltText(int iPromoID, const TDVCHAR* psImageAltText, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey)
{
	return SetElementValue(iPromoID, psImageAltText, bCommitChanges, EV_IMAGEALTTEXT,iUserID, psEditKey);
}

bool CMessageBoardPromo::SetKeyPhrases( int iPromoID, const SEARCHPHRASELIST& vPhrases, bool bDefaultPromo )
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	return SP.UpdateBoardPromoKeyPhrases(iPromoID, vPhrases, bDefaultPromo);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::CommitBoardPromoChanges(int iUserID, const TDVCHAR* psEditKey, CTDVString* psNewEditKey)
{
	bool bOk = CommitElementChanges(iUserID, psEditKey,psNewEditKey);
	return bOk;
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::MakePreviewBoardPromosActive(int iSiteID, int iEditorID, int iPromoID)
{
	bool bOk = MakeElementsActiveForSite(iSiteID,iEditorID,iPromoID);

	// Now call the clean up bit!
	if (bOk)
	{
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(SP);
		if (!SP.CleanUpActiveTopicBoardPromoLocations(iSiteID))
		{
			// Something went wrong!!!
			return SetDNALastError("CMessageBoardPromo::MakePreviewBoardPromosActive","FailedToCleanUpLocations","Failed cleaning up the boardpromo locations!");
		}
	}
	return bOk;
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::GetBoardPromoTitle(CTDVString& sTitle, int iElementID)
{
	return GetElementValue(EV_TITLE,sTitle,iElementID);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::GetBoardPromoText(CTDVString& sText, int iElementID)
{
	return GetElementValue(EV_TEXT,sText,iElementID);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::GetBoardPromoImageName(CTDVString& sImageName, int iElementID)
{
	return GetElementValue(EV_IMAGENAME,sImageName,iElementID);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::GetNumberOfBoardPromosForSiteID(int iSiteID, int& iNumberOfPromos, eElementStatus ElementStatus)
{
	return GetNumberOfFrontPageElementsForSiteID(iSiteID,ElementStatus,iNumberOfPromos);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::GetBoardPromoImageWidth(int& iImageWidth, int iElementID)
{
	return GetElementValue(EV_IMAGEWIDTH,iImageWidth,iElementID);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::GetBoardPromoImageHeight(int& iImageHeight, int iElementID)
{
	return GetElementValue(EV_IMAGEHEIGHT,iImageHeight,iElementID);
}

// Wrapper function for the BaseClass
bool CMessageBoardPromo::GetBoardPromoImageAltText(CTDVString& sImageAltText, int iElementID)
{
	return GetElementValue(EV_IMAGEALTTEXT,sImageAltText,iElementID);
}

/*********************************************************************************

	bool CMessageBoardPromo::SetBoardPromoLocations(int iBoardPromoID, CDNAIntArray& Locations, const TDVCHAR* psEditKey, int iUserID)

		Author:		Mark Howitt
        Created:	07/02/2005
        Inputs:		iBoardPromoID - The id of the promo you want to put on the topics
					Locations - The list of topics you want to put the board promo on.
					psEditKey - The EditKey for the board promo you are setting.
					iUserID - The id of the user that is doing the update.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Sets the board promo id for a given list of topics.
					The Board Promo will appear on the given topics.

*********************************************************************************/
bool CMessageBoardPromo::SetBoardPromoLocations(int iBoardPromoID, CDNAIntArray& Locations, const TDVCHAR* psEditKey, int iUserID)
{
	// Setup and initialise the storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMessageBoardPromo::SetBoardPromoLocations","FailedToInitialiseStoredProcedure","Failed creating stored procedure");
	}

	// Now set the locations.
	if (!SP.SetBoardPromoLocations(iBoardPromoID,Locations,psEditKey,iUserID))
	{
		return SetDNALastError("CMessageBoardPromo::SetBoardPromoLocations","FailedToSetPromoLocations","Failed to set the board promo locations");
	}

	// Check the valid result
	if (SP.GetIntField("Validid") == 0)
	{
		return SetDNALastError("CMessageBoardPromo::SetBoardPromoLocations","IncorrectBoardPromoIDGIven","Invalid BoardPromoID!");
	}
	else if (SP.GetIntField("Validid") == 2)
	{
		return SetDNALastError("CMessageBoardPromo::SetBoardPromoLocations","ChangedByOtherEditor","Edited By another Editor");
	}

	return true;
}

/*********************************************************************************

	bool CMessageBoardPromo::SetDefaultBoardPromoForTopics(int iSiteID, int iBoardPromoID, int iUserID)

		Author:		Mark Howitt
        Created:	07/02/2005
        Inputs:		iSiteID - The site that the topics must belong to.
					iBoardPromoID - The ID of the board promo you want to set aqs default.
					iUserID - The id of the user doing the update.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Sets all the topics default board promo ids to the given one
					that belong to the given site.

*********************************************************************************/
bool CMessageBoardPromo::SetDefaultBoardPromoForTopics(int iSiteID, int iBoardPromoID, int iUserID)
{
	// Setup and initialise the storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMessageBoardPromo::SetDefaultBoardPromoForTopics","FailedToCreateProcedure","Failed creating stored procedure");
	}

	// Now set the locations.
	if (!SP.SetDefaultBoardPromoForTopics(iSiteID,iBoardPromoID,iUserID))
	{
		return SetDNALastError("CMessageBoardPromo::SetDefaultBoardPromoForTopics","FailedToSetDefaultBoardPromo","Failed to set the Default board promo for topics");
	}

	// Check to make sure the Promo Existed on the site!
	if (!SP.IsEOF() && SP.GetIntField("Exists") == 0)
	{
		return SetDNALastError("CMessageBoardPromo::SetDefaultBoardPromoForTopics","BoardPromoDoesNotExist","BoardPromo Does Not Exists For Given Site!!!");
	}
	return true;
}

/*********************************************************************************

	bool CMessageBoardPromo::SetBoardPromoName(int iPromoID, const TDVCHAR* psPromoName, const TDVCHAR* psEditKey, CTDVString* psNewEditKey = NULL)

		Author:		Mark Howitt
        Created:	18/02/2005
        Inputs:		iPromoID - The id of the promo you want to name
					psPromoName - the new name for the given promo
					psEditKey - The edit key required to update the promo
        Outputs:	psNewEditKey - A string that will take the new value of the edit key
        Returns:	true if ok, false if not.
        Purpose:	Sets the boardpromo name for a given promo id

*********************************************************************************/
bool CMessageBoardPromo::SetBoardPromoName(int iPromoID, const TDVCHAR* psPromoName, const TDVCHAR* psEditKey, CTDVString* psNewEditKey)
{
	// Setup and initialise the storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMessageBoardPromo::SetBoardPromoName","FailedToInitialiseStoredProcedure","Failed creating stored procedure");
	}

	// Now set the locations.
	if (!SP.SetBoardPromoName(iPromoID,psPromoName,psEditKey))
	{
		return SetDNALastError("CMessageBoardPromo::SetBoardPromoName","FailedSettingPromoName","Failed to set the board promo name");
	}

	// Check the valid result
	if (SP.GetIntField("Validid") == 0)
	{
		return SetDNALastError("CMessageBoardPromo::SetBoardPromoName","InvalidPromoID","Invalid BoardPromoID!");
	}
	else if (SP.GetIntField("Validid") == 2)
	{
		return SetDNALastError("CMessageBoardPromo::SetBoardPromoName","EditedByANotherEditor","Edited By another Editor");
	}

	else if (SP.GetIntField("Validid") == 3)
	{
		return SetDNALastError("CMessageBoardPromo::SetBoardPromoName","BoardPromoNameAlreadyExists","A BoardPromo Already Exists With That Name!");
	}

	// If given, set the new edit key string
	if (psNewEditKey != NULL)
	{
		SP.GetField("NewEditKey",*psNewEditKey);
	}

	return true;
}