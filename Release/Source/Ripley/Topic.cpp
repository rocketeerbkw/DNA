#include "stdafx.h"
#include ".\topic.h"
#include ".\tdvassert.h"

CTopic::CTopic(CInputContext& inputContext) : CXMLObject(inputContext), m_bValidTopic(false), m_iTextStyle(1), m_iTopicID(0), m_iTopicListSiteID(0)
{
}

CTopic::~CTopic(void)
{
}

/*********************************************************************************

	bool CTopic::CreateXMLForTopic(CDBXMLBuilder& XML)

		Author:		David E
        Created:	15/12/2004
        Inputs:		-CDBXMLBuilder& XML
        Outputs:	None.
        Returns:	False on failure.
        Purpose:	Create XML for a Topic.
					This function is used to create the XML for all topics - preview and currently live.
					The elements are only created therefore if the fields have been specified in the stored procedure
					This allows the procedure to produce only the xml elements that are required.

*********************************************************************************/

bool CTopic::CreateXMLForTopic()
{
	//If not initialised can't proceed.
	CStoredProcedure* pSP = m_XMLBuilder.GetStoredProcedure();
	if ( pSP == NULL )
	{
		return false;
	}

	int iTopicLinkID = 0;
	int iTopicID = 0;
	bool bOk = OpenXMLTag("TOPIC");
	bOk = bOk && AddDBXMLIntTag("TOPICID", NULL, false, &iTopicID);
	bOk = bOk && AddDBXMLIntTag("H2G2ID");
	bOk = bOk && AddDBXMLIntTag("SITEID");
	bOk = bOk && AddDBXMLIntTag("TOPICSTATUS");	 
	bOk = bOk && AddDBXMLIntTag("TOPICLINKID", NULL, false, &iTopicLinkID);	 
	bOk = bOk && AddDBXMLTag("TITLE",NULL,false,false,&m_sTitle);
	bOk = bOk && AddDBXMLIntTag("FORUMID");
	bOk = bOk && AddDBXMLIntTag("FORUMPOSTCOUNT");
	if (pSP->FieldExists("FASTMOD"))
	{
		bOk = bOk && AddDBXMLIntTag("FASTMOD");
	}

	// Check to see if we're dealing with the cutdown list or the full info version
	if (pSP->FieldExists("DESCRIPTION"))
	{
		bOk = bOk && AddDBXMLTag("DESCRIPTION",NULL,false,false,&m_sText);
		bOk = bOk && AddDBXMLIntTag("POSITION");

		bOk = bOk && OpenXMLTag("CREATEDBY");
		bOk = bOk && AddDBXMLTag("CreatedByUserName","USERNAME");
		bOk = bOk && AddDBXMLIntTag("CreatedByUserID","USERID");
		bOk = bOk && AddDBXMLDateTag("CREATEDDATE");
		bOk = bOk && CloseXMLTag("CREATEDBY");

		bOk = bOk && OpenXMLTag("UPDATEDBY");
		bOk = bOk && AddDBXMLTag("UPDATEDBYUSERNAME","USERNAME");
		bOk = bOk && AddDBXMLIntTag("UPDATEDBYUSERID","USERID");
		bOk = bOk && AddDBXMLDateTag("LASTUPDATED");
		bOk = bOk && CloseXMLTag("UPDATEDBY");

		bOk = bOk && AddDBXMLIntTag("STYLE",NULL,false,&m_iTextStyle);
		bOk = bOk && AddDBXMLIntTag("FP_ELEMENTID", NULL, false);
		bOk = bOk && AddDBXMLIntTag("FP_TEMPLATE", NULL, false);
		bOk = bOk && AddDBXMLIntTag("FP_POSITION", NULL, false);
		bOk = bOk && AddDBXMLTag("FP_TITLE", NULL, false);		
		bOk = bOk && AddDBXMLTag("EDITKEY",NULL,false,false,&m_sEditKey);
	}

	bOk = bOk && CloseXMLTag("TOPIC");

	if (iTopicID > 0)
	{
		topicInfo t;
		t.editKey = "";
		t.iTopicID = iTopicID;
		t.iTopicLinkID = iTopicLinkID;
		m_siteTopicIDs.AddHead(t);
	}

	return bOk;
}

/*********************************************************************************

	bool CTopic::CreateTopic(int& iTopicID, int iSiteID, int iEditorID, const TDVCHAR* psTitle, const TDVCHAR* psText, CTopic::eTopicStatus TopicStatus, int  iTopicLinkID, bool bIgnoreDuplicates)

		Author:		David E
        Created:	15/12/2004
        Inputs:		-int& iTopicID
						-int iSiteID
						-int iEditorID
						-const TDVCHAR* psTitle
						-const TDVCHAR* psText
						-CTopic::eTopicStatus TopicStatus
						-int iTopicLinkID
						-bool bIgnoreDuplicates - true will not check for duplicates
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CTopic::CreateTopic(int& iTopicID, int iSiteID, int iEditorID, const TDVCHAR* psTitle, const TDVCHAR* psText, CTopic::eTopicStatus TopicStatus, int  iTopicLinkID, bool bIgnoreDuplicates)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTopic::CreateTopic","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}
	
	if (!bIgnoreDuplicates)
	{
		//find out if an entry with the existing title already exists 
		bool bTopicTitleAlreadyExist = false;
		if ( !SP.DoesTopicAlreadyExist(iSiteID, psTitle, TopicStatus, bTopicTitleAlreadyExist))
		{
			return SetDNALastError("CTopic::CreateTopic","FailedToCreateTopic","Failed to execute DoesTopicAlreadyExist");
		}

		if ( bTopicTitleAlreadyExist)
		{
			return SetDNALastError("CTopic::CreateTopic","FailedToCreateTopic","A Topic with the same title already exists for this site");
		}
	}

	// Now call the procedure
	if (!SP.CreateTopic(iTopicID, iSiteID, iEditorID, psTitle, psText, TopicStatus, iTopicLinkID))
	{
		return SetDNALastError("CTopic::CreateTopic","FailedToCreateTopic","Failed to create topic");
	}

	return true;
}

/*********************************************************************************

	bool CTopic::EditTopic(int iTopicID, int iSiteID, int iEditorID, const TDVCHAR* psTitle, const TDVCHAR* psText, CTopic::eTopicStatus TopicStatus,  bool bIsTextGuideML)

		Author:		David E
        Created:	15/12/2004
        Inputs:		-int iTopicID
						-int iSiteID
						-int iEditorID
						-const TDVCHAR* psTitle
						-const TDVCHAR* psText
						-CTopic::eTopicStatus TopicStatus
						-int iStyle
						-const TDVCHAR* sEditKey -unique id used to verify that item has not been updated by another editor
						-the Edit Key will differ if rec has been updated, as a new one is generated for each edit 
						-bool& bEditKeyClash - set to true on return if an edit key clash was detected
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CTopic::EditTopic(int iTopicID, int iSiteID, int iEditorID, const TDVCHAR* psTitle, const TDVCHAR* psText, CTopic::eTopicStatus TopicStatus,  int iStyle, const TDVCHAR* sEditKey, bool& bEditKeyClash)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTopic::EditTopic","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}
	
	//find out if an entry with the existing title already exists 
	bool bTopicTitleAlreadyExist = false;
	if ( !SP.DoesTopicAlreadyExist(iSiteID, psTitle, TopicStatus, bTopicTitleAlreadyExist, iTopicID))
	{
		return SetDNALastError("CTopic::EditTopic","FailedToEditTopic","Failed to execute DoesTopicAlreadyExist");
	}

	if ( bTopicTitleAlreadyExist)
	{
		return SetDNALastError("CTopic::EditTopic","FailedToEditTopic","A Topic with the same title already exists for this site");
	}

	// Now call the procedure
	if (!SP.EditTopic(iTopicID, iEditorID, psTitle, psText, iStyle, sEditKey))
	{
		return SetDNALastError("CTopic::EditTopic","FailedToEditTopic","Failed to create topic");
	}
	
	//check that record was updated
	bEditKeyClash = ((int)(SP.GetIntField("ValidEditKey"))) == 1;

	if (!bEditKeyClash)
	{
		SP.GetField("NewEditKey", m_sEditKey);
	}

	return true;
}

/*********************************************************************************

	bool CTopic::GetTopicsForSiteID(int iSiteID, CTopic::eTopicStatus TopicStatus, bool bIncludeArchivedTopics = false)

		Author:		David E
        Created:	15/12/2004
        Inputs:		-int iSiteID
						-CTopic::eTopicStatus TopicStatus
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CTopic::GetTopicsForSiteID(int iSiteID, CTopic::eTopicStatus TopicStatus, bool bIncludeArchivedTopics)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTopic::GetTopicsForSiteID","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	if (!SP.GetTopicsForSiteID(iSiteID, TopicStatus, bIncludeArchivedTopics))
	{
		return SetDNALastError("CTopic::GetTopicsForSiteID","FailedToGetTopicsForSiteID","Failed to get topics for site");
	}

	m_iTopicListSiteID = iSiteID;
	m_siteTopicIDs.RemoveAll();

	// Setup the list of status types
	CTDVString sTopicListStatus[5];
	sTopicListStatus[0] = "ACTIVE";
	sTopicListStatus[1] = "PREVIEW";
	sTopicListStatus[2] = "DELETED";
	sTopicListStatus[3] = "ARCHIVEDACTIVE";
	sTopicListStatus[4] = "ARCHIVEDPREVIEW";

	// Now insert the results into the XML
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	bool bOk = OpenXMLTag("TOPICLIST",true);
	bOk = bOk && AddXMLAttribute("STATUS",sTopicListStatus[TopicStatus],true);
	
	// Go go through the results
	while (!SP.IsEOF() && bOk)
	{
		// Crete the XML For the element
		bOk = bOk && CreateXMLForTopic();

		// Now get the next result
		SP.MoveNext();
	}

	// Close the XML Block
	bOk = bOk && CloseXMLTag("TOPICLIST");

	// Check to see if everything went ok
	if (!bOk)
	{
		return SetDNALastError("CTopic::GetTopicsForSiteID","FailedToParseResults","Failed Parse Results");
	}

	// Now create the tree
	if (!CreateFromXMLText(sXML, NULL, true))
	{
		return SetDNALastError("CTopic::GetTopicsForSiteID","FailedToParseResults","Failed Creating XML");
	}

	return true;
}

bool CTopic::GetTopicLinkIDAndEditKeyForTopicIDOnSite(int iTopicID, int iSiteID, CTDVString& editKey, int& iTopicLinkID, int& iLinkTopicElementID, CTDVString& topicElementEditKey)
{
	if (m_iTopicListSiteID != iSiteID || iTopicID == 0)
	{
		return false;
	}

	POSITION pos = m_siteTopicIDs.GetHeadPosition();
	for (int i=0; i < m_siteTopicIDs.GetCount(); i++)
	{
	   topicInfo ti = m_siteTopicIDs.GetNext(pos);
		if (ti.iTopicLinkID == iTopicID)
		{
			CStoredProcedure SP;
			if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
			{
				return SetDNALastError("CTopic::DoesTopicExistForSite","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
			}

			iTopicLinkID = ti.iTopicID;
			if (GetTopicDetailsFromDatabase(iTopicLinkID, SP))
			{
				iLinkTopicElementID = SP.GetIntField("FP_ELEMENTID");
				bool bOk = SP.GetField("EDITKEY", editKey);
				bOk = bOk && SP.GetField("FP_EDITKEY", topicElementEditKey);
				return bOk;
			}
		}
	}


	return false;
}

bool CTopic::GetTopicDetailsFromDatabase(int iTopicID, CStoredProcedure& SP)
{
	// Now call the procedure
	if (!SP.GetTopicDetails(iTopicID))
	{
		return SetDNALastError("CTopic::GetTopicDetails","FailedToGetTopicDetails","Failed to get topic details");
	}
	return true;
}

/*********************************************************************************

	bool CTopic::GetTopicDetails(int iTopicID)

		Author:		David E
        Created:	15/12/2004
        Inputs:		-int iTopicID
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CTopic::GetTopicDetails(int iTopicID)
{
	m_bValidTopic = false;

	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(SP))
	{
		return SetDNALastError("CTopic::GetTopicDetails","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	if (!GetTopicDetailsFromDatabase(iTopicID, SP))
	{
		return false;
	}

	// Now insert the results into the XML
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	
	bool bOk = CreateXMLForTopic();

	// Check to see if everything went ok
	if (!bOk)
	{
		return SetDNALastError("CTopic::GetTopicDetails","FailedToParseResults","Failed Parse Results");
	}

	// Now create the tree
	if (!CreateFromXMLText(sXML))
	{
		return SetDNALastError("CTopic::GetTopicDetails","FailedToParseResults","Failed Creating XML");
	}

	m_iTopicID = iTopicID;
	m_bValidTopic = true;
	return true;
}

/*********************************************************************************

	bool CTopic::DeleteTopic(int iTopicID)

		Author:		David E
        Created:	15/12/2004
        Inputs:		-int iTopicID
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CTopic::DeleteTopic(int iTopicID)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTopic::DeleteTopic","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	if (!SP.DeleteTopic(iTopicID))
	{
		return SetDNALastError("CTopic::DeleteTopic","FailedToDeleteTopic","Failed to delete topic");
	}

	return true;
}

/*********************************************************************************

	bool CTopic::MoveTopicPositionally(int iTopicID, int iDirection)

		Author:		David E
        Created:	15/12/2004
        Inputs:		-int iTopicID
						-int iDirection
						-const TDVCHAR* sEditKey -unique id used to verify that item has not been updated by another editor
						-the Edit Key will differ if rec has been updated, as a new one is generated for each edit 
						-bool& bEditKeyClash - set to true on return if an edit key clash was detected 
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CTopic::MoveTopicPositionally(int iTopicID, int iDirection, const TDVCHAR* sEditKey, bool& bEditKeyClash)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTopic::MoveTopicPositionally","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	if (!SP.MoveTopicPositionally(iTopicID, iDirection, sEditKey))
	{
		return SetDNALastError("CTopic::MoveTopicPositionally","FailedToMoveTopicPositionally","Failed to Move Positionally");
	}
	
	//check that record was updated
	bEditKeyClash = ((int)(SP.GetIntField("ValidEditKey"))) == 1;				

	return true;
}

/*********************************************************************************

	bool CTopic::GetTopicTitle(int iTopicID, CTDVString& sTitle)

		Author:		David E
        Created:	15/12/2004
        Inputs:		-int iTopicID
						-CTDVString& sTitle
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CTopic::GetTopicTitle(int iTopicID, CTDVString& sTitle)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTopic::GetTopicsForSiteID","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	if (!SP.GetTopicTitle(iTopicID, sTitle))
	{
		return SetDNALastError("CTopic::GetTopicsForSiteID","FailedToGetTopicsForSiteID","Failed to get topics for site");
	}
	
	return true;
}

/*********************************************************************************

	bool CTopic::GetNumberOfTopicsForSiteID(int iSiteID, CTopic::eTopicStatus TopicStatus, int& iNumTopics)

		Author:		DavidE
        Created:	12/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CTopic::GetNumberOfTopicsForSiteID(int iSiteID, int& iNumTopics, CTopic::eTopicStatus TopicStatus) 
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTopic::GetNumberOfTopicsForSiteID","FailedToGetNumberOfTopicsForSiteID","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	if (!SP.GetNumberOfTopicsForSiteID(iSiteID, TopicStatus, iNumTopics))
	{
		return SetDNALastError("CTopic::GetNumberOfTopicsForSiteID","FailedToGetNumberOfTopicsForSiteID","Failed to Get Number Of Topic For Site ID");
	}

	
	//check that record was updated
	iNumTopics = SP.GetIntField("NumOfTopics");				

	return true;
}

/*********************************************************************************

	bool CTopic::MakePreviewTopicActiveForSite(int iSiteID, int iTopicID)

		Author:		DavidE
        Created:	13/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CTopic::MakePreviewTopicActiveForSite(const int iSiteID, int iTopicID, int iEditorID)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTopic::MakePreviewTopicActiveForSite","FailedToMakePreviewTopicActiveForSite","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	if (!SP.MakePreviewTopicActiveForSite(iSiteID, iTopicID, iEditorID))
	{
		return SetDNALastError("CTopic::MakePreviewTopicActiveForSite","FailedToMakePreviewTopicActiveForSite","Failed to Make Preview Topic Active For Site");
	}
	
	return true;
}

/*********************************************************************************

	bool CTopic::MakePreviewTopicsActiveForSite(const int iSiteID)

		Author:		DE
        Created:	24/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CTopic::MakePreviewTopicsActiveForSite(const int iSiteID, int iEditorID)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTopic::MakePreviewTopicsActiveForSite","FailedToMakePreviewTopicsActiveForSite","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	if (!SP.MakePreviewTopicsActiveForSite(iSiteID, iEditorID))
	{
		return SetDNALastError("CTopic::MakePreviewTopicsActiveForSite","FailedToMakePreviewTopicsActiveForSite","Failed to Make Preview Topics Active For Site");
	}
	
	return true;
}

bool CTopic::GetTopicForumIDs(const int iSiteID, CDNAIntArray& ForumIDs, CTopic::eTopicStatus TopicStatus)
{
	if(!ForumIDs.IsEmpty())
	{
		ForumIDs.RemoveAll();
	}

	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTopic::GetTopicForumIDs","FailedToGetTopicForumIDs","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	if (!SP.GetTopicForumIDs(TopicStatus, iSiteID))
	{
		return SetDNALastError("CTopic::GetTopicForumIDs","FailedToGetTopicForumIDs","Failed to Get Topic Forum IDs");
	}
	//ForumIDs.SetSize(SP.GetIntField("Count"), 1);
	ForumIDs.SetSize(0, 1);
	while(!SP.IsEOF())
	{
		ForumIDs.Add(SP.GetIntField("ForumID"));
		SP.MoveNext();
	}

	return true;
}

/*********************************************************************************

	bool CTopic::CheckAndGetBoardPromoForTopic(int ih2g2ID, int& iBoardPromoID)

		Author:		Mark Howitt
        Created:	03/02/2005
        Inputs:		ih2g2ID - The id of the guideentry you want to get the topic for
        Outputs:	iBoardPromoID - The id of the board promo for the topic if found
        Returns:	true if ok, false if not
        Purpose:	Tries to find a Topic that the ForumID belongs to.
					If it does, then it fetches the Board promo for that topic.

*********************************************************************************/
bool CTopic::CheckAndGetBoardPromoForTopic(int ih2g2ID, int& iBoardPromoID)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTopic::CheckAndGetBoardPromoForTopic","FailedToMakePreviewTopicsActiveForSite","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	if (!SP.GetTopicFromh2g2ID(ih2g2ID))
	{
		return SetDNALastError("CTopic::CheckAndGetBoardPromoForTopic","FailedToGetTopicForh2g2id","Failed getting topic for h2g2id");
	}
	
	// See if we found a topic or not
	if (!SP.IsEOF())
	{
		// Get the PromoID
        iBoardPromoID = SP.GetIntField("BoardPromoID");

		// Check to see if it's zero, if so then get the default board promo
		if (iBoardPromoID == 0)
		{
			iBoardPromoID = SP.GetIntField("DefaultBoardPromoID");
		}
	}
	else
	{
		// No topic found, set the id to 0!
		iBoardPromoID = 0;
	}

	return true;
}

bool CTopic::GetTopicText(CTDVString& sText, bool bMakeEditable)
{
	// Check to see if we've got a valid topic?
	if (!m_bValidTopic)
	{
		TDVASSERT(false,"Invalid Topic, Call GetTopicDetails() First!");
	}

	// Check to see if we want an editable version of the text.
	if (bMakeEditable)
	{
		// Check to make sure we have a valid tree
		if (m_pTree == NULL)
		{
			TDVASSERT(false,"Invalid tree! Call GetTopicDetails() First!");
			return false;
		}

		// Get the GUIDE node from thre tree
		CXMLTree* pTemp = m_pTree->FindFirstTagName("GUIDE");
		if (pTemp != NULL)
		{
			// Now put the contents into the string.
			pTemp->OutputXMLTree(sText);

			// Find out what type of style the text is in
			if (m_iTextStyle == 1) // PlainText
			{
				// Convert the guideML inot plain text
				CXMLObject::GuideMLToPlainText(&sText);
			}
			else if (m_iTextStyle == 2) // GuideML
			{
				// do nothing as it is already in GuideML format
			}
			else
			{
				// this should never happen
				TDVASSERT(false, "Non-valid style format in CGuideEntry::GetBody(...)");
			}
		}
		else
		{
			// flag error, but give a empty string rather than failing
			TDVASSERT(false, "No <GUIDE> tag found in CGuideEntry::GetBody(...)");
			sText.Empty();
		}
	}
	else
	{
		sText = m_sText;
	}

	return true;
}

bool CTopic::GetTopicTitle(CTDVString& sTitle)
{
	// Check to see if we've got a valid topic?
	if (!m_bValidTopic)
	{
		TDVASSERT(false,"Invalid Topic, Call GetTopicDetails() First!");
	}

	sTitle = m_sTitle;
	return true;
}

bool CTopic::GetTopicTextStyle(int& iType)
{
	// Check to see if we've got a valid topic?
	if (!m_bValidTopic)
	{
		TDVASSERT(false,"Invalid Topic, Call GetTopicDetails() First!");
	}

	iType = m_iTextStyle;
	return true;
}

bool CTopic::GetTopicEditKey(CTDVString& sEditKey)
{
	// Check to see if we've got a valid topic?
	if (!m_bValidTopic)
	{
		TDVASSERT(false,"Invalid Topic, Call GetTopicDetails() First!");
	}

	sEditKey = m_sEditKey;
	return true;
}

bool CTopic::GetTopicID(int& iTopicID)
{
	// Check to see if we've got a valid topic?
	if (!m_bValidTopic)
	{
		TDVASSERT(false,"Invalid Topic, Call GetTopicDetails() First!");
	}

	iTopicID = m_iTopicID;
	return true;
}

/*********************************************************************************

	bool CTopic::UnArchiveTopic(int iTopicID, int iUserID)

		Author:		Mark Howit
        Created:	12/05/2006
        Inputs:		iTopicID - The id of the topic you want to unarchive.
					iUserID - The ID of the user who is unarchiving the topic
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Un archives an archived topic. This only works for preview topics.
					The make active functionality will unarchive the active state.

*********************************************************************************/
bool CTopic::UnArchiveTopic(int iTopicID, int iUserID)
{
	// Create and initialise a storedprocedure
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTopic::UnArchiveTopic","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}
	
	// Now call the procedure
	bool bValidTopicID = false;
	if (!SP.UnArchiveTopic(iTopicID,iUserID,bValidTopicID))
	{
		return SetDNALastError("CTopic::UnArchiveTopic","FailedToUnArchiveTopic","Failed to Un Archive Topic");
	}
	
	// Now check to make sure that the topic id was valid
	if (!bValidTopicID)
	{
		return SetDNALastError("CTopic::UnArchiveTopic","InvalidTopicIDGiven","Invalid Topic ID Given");
	}

	// Everything went ok, return true
	return true;
}
