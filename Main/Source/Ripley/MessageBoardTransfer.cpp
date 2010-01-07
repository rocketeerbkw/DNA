#include "stdafx.h"
#include ".\MessageBoardTransfer.h"
#include ".\User.h"
#include ".\Topic.h"
#include ".\FrontPageTopicElement.h"
#include ".\TextBoxElement.h"
#include ".\ForumSchedule.h"
#include ".\FrontPageLayout.h"
#include ".\Site.h"
#include ".\SiteConfig.h"
#include ".\SiteConfigPreview.h"
#include ".\tdvassert.h"

#define BACKUPTAG			"MESSAGEBOARDTRANSFER-BACKUP"
#define BACKUPLOGTAG		"BACKUPLOG"
#define BACKUPLOGENTRYTAG	"BACKUPLOGENTRY"

#define RESTORETAG			"MESSAGEBOARDTRANSFER-RESTORE"
#define RESTORELOGTAG		"RESTORELOG"
#define RESTORELOGENTRYTAG	"RESTORELOGENTRY"

/*********************************************************************************

	CMessageBoardTransfer::CMessageBoardTransfer(CInputContext& inputContext) : CXMLObject(inputContext)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		inputContext = an input context
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

CMessageBoardTransfer::CMessageBoardTransfer(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

/*********************************************************************************

	CMessageBoardTransfer::~CMessageBoardTransfer()

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

CMessageBoardTransfer::~CMessageBoardTransfer()
{
}

/*********************************************************************************

	bool CMessageBoardTransfer::CreateBackupXML(int iSiteID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		iSiteID = the site to back up
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	

*********************************************************************************/

bool CMessageBoardTransfer::CreateBackupXML(int iSiteID)
{
	// Clear out any existing XML this object may harbour
	Destroy();

	if (!CreateFromXMLText("<"BACKUPTAG"/>"))
	{
		return SetDNALastError("CMessageBoardTransfer::CreateBackupXML","CREATEXMLFAILED","Unable to create initial XML Block");
	}

	if (!AddInside(BACKUPTAG,"<"BACKUPLOGTAG"/>"))
	{
		return SetDNALastError("CMessageBoardTransfer::CreateBackupXML","ADDBACKUPTAGFAILED","Unable to add the backup log tag");
	}

	bool bOK = true;

	// Put the site info in
	AddInside(BACKUPTAG,m_InputContext.GetSiteAsXML(iSiteID));

	// Front Page
	if (!AddFrontPage(iSiteID))
	{
		AddInside(BACKUPTAG,GetLastErrorAsXMLString());
	}

	// Topics
	if (!AddTopics(iSiteID))
	{
		AddInside(BACKUPTAG,GetLastErrorAsXMLString());
	}

	// Topic elements
	if (!AddFrontPageTopicElements(iSiteID))
	{
		AddInside(BACKUPTAG,GetLastErrorAsXMLString());
	}

	// Board promos
	if (!AddBoardPromos(iSiteID))
	{
		AddInside(BACKUPTAG,GetLastErrorAsXMLString());
	}

	// Text boxes
	if (!AddTextBoxes(iSiteID))
	{
		AddInside(BACKUPTAG,GetLastErrorAsXMLString());
	}

	// Forum schedule
	if (!AddForumSchedule(iSiteID))
	{
		AddInside(BACKUPTAG,GetLastErrorAsXMLString());
	}

	// Site Config
	if (!AddSiteConfig(iSiteID))
	{
		AddInside(BACKUPTAG,GetLastErrorAsXMLString());
	}

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::AddTopics(int iSiteID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		iSiteID = the site
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Adds the XML that describes the live topics for the given site

*********************************************************************************/

bool CMessageBoardTransfer::AddTopics(int iSiteID)
{
	CTopic Topic(m_InputContext);
	bool bOK = Topic.GetTopicsForSiteID(iSiteID,CTopic::TS_LIVE);	
	bOK = bOK && AddInside(BACKUPTAG,&Topic);

	if (!bOK)
	{
		return SetDNALastError("CMessageBoardTransfer::AddTopics","ADDTOPICSFAILED","Adding topics list failed");
	}

	AddInside(BACKUPLOGTAG,CXMLObject::MakeTag(BACKUPLOGENTRYTAG,"Topic List"));

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::AddFrontPage(int iSiteID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		iSiteID = the site
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Adds the Front Page XML

*********************************************************************************/

bool CMessageBoardTransfer::AddFrontPage(int iSiteID)
{
	// Setup a FrontPageLayout object so we can get the Text and FrontpageLayout info For the Board
	CFrontPageLayout Layout(m_InputContext);
	if (!Layout.InitialisePageBody(iSiteID,false,true))
	{
		return SetDNALastError("CMessageBoardTransfer::AddFrontPage","FailedToInitialisePageBody","Failed To Initialise The FrontPage PageBody Object");
	}

	// Now make sure the frontpage layout info is in the body!
	CTDVString sFrontPage;
	if (!Layout.CreateFromPageLayout() || !Layout.GetAsString(sFrontPage))
	{
		return SetDNALastError("CMessageBoardTransfer::AddFrontPage","FailedToGetTheFrontPageXML","Failed to get the xml from the frontpage layout object!");
	}

	// Now add the XML to the Transfer Tree
	CTDVString sFrontPageXMLTag = CXMLObject::MakeTag("FRONTPAGEXML",sFrontPage);
	if (!AddInside(BACKUPTAG,sFrontPageXMLTag))
	{
		return SetDNALastError("CMessageBoardTransfer::AddFrontPage","ADDFRONTPAGEFAILED","Adding frontpage failed");
	}

	AddInside(BACKUPLOGTAG,CXMLObject::MakeTag(BACKUPLOGENTRYTAG,"Front Page"));

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::AddFrontPageTopicElements(int iSiteID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		iSiteID = the site
        Outputs:	-
        Returns:	-
        Purpose:	Adds the XML that describes the live front page topic elements

*********************************************************************************/

bool CMessageBoardTransfer::AddFrontPageTopicElements(int iSiteID)
{
	CFrontPageTopicElement FPTopicElement(m_InputContext);
		
	bool bOK = FPTopicElement.GetTopicFrontPageElementsForSiteID(iSiteID, CFrontPageTopicElement::ES_LIVE);
	bOK = bOK && AddInside(BACKUPTAG,&FPTopicElement);

	if (!bOK)
	{
		return SetDNALastError("CMessageBoardTransfer::AddFrontPageTopicElements","ADDFPTOPICELEMENTSFAILED","Adding front page topic elements failed");
	}

	AddInside(BACKUPLOGTAG,CXMLObject::MakeTag(BACKUPLOGENTRYTAG,"Topic Element List"));

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::AddBoardPromos(int iSiteID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		iSiteID = the site
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Adds the XML that describes the live board promos

*********************************************************************************/

bool CMessageBoardTransfer::AddBoardPromos(int iSiteID)
{
	CMessageBoardPromo BoardPromo(m_InputContext);
		
	bool bOK = BoardPromo.GetBoardPromosForSite(iSiteID, CMessageBoardPromo::ES_LIVE);
	bOK = bOK && AddInside(BACKUPTAG,&BoardPromo);

	if (!bOK)
	{
		return SetDNALastError("CMessageBoardTransfer::AddBoardPromos","ADDBOARDPROMOSFAILED","Adding board promos failed");
	}

	AddInside(BACKUPLOGTAG,CXMLObject::MakeTag(BACKUPLOGENTRYTAG,"Board Promo List"));

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::AddTextBoxes(int iSiteID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		iSiteID = the site
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Adds the XML that descibes the live text box elements

*********************************************************************************/

bool CMessageBoardTransfer::AddTextBoxes(int iSiteID)
{
	CTextBoxElement TextBoxElement(m_InputContext);
		
	bool bOK = TextBoxElement.GetTextBoxesForSiteID(iSiteID, CTextBoxElement::ES_LIVE);
	bOK = bOK && AddInside(BACKUPTAG,&TextBoxElement);

	if (!bOK)
	{
		return SetDNALastError("CMessageBoardTransfer::AddTextBoxes","ADDTEXTBOXESFAILED","Adding text boxes failed");
	}

	AddInside(BACKUPLOGTAG,CXMLObject::MakeTag(BACKUPLOGENTRYTAG,"Text box list"));

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::AddForumSchedule(int iSiteID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		iSiteID = the site
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Adds the XML that describes the forum schedule for the live topics

*********************************************************************************/

bool CMessageBoardTransfer::AddForumSchedule(int iSiteID)
{
	CTopic Topic(m_InputContext);

	CDNAIntArray ForumIDs;
	Topic.GetTopicForumIDs(iSiteID,ForumIDs,CTopic::TS_LIVE);

	CForumSchedule ForumSchedule(m_InputContext);
	bool bDoneFirst = false;
	CTDVString sXML;

	if (!ForumSchedule.GetForumScheduleInfo(ForumIDs, true))
	{
		return CopyDNALastError("CMessageBoardTransfer::AddForumSchedule",ForumSchedule);
	}

	if (!AddInside(BACKUPTAG,&ForumSchedule))
	{
		return SetDNALastError("CMessageBoardTransfer::AddForumSchedule","ADDFORUMSCHEDULEFAILED","Adding forum schedule failed");
	}

	AddInside(BACKUPLOGTAG,CXMLObject::MakeTag(BACKUPLOGENTRYTAG,"Forum Schedules"));

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::AddSiteConfig(int iSiteID)

		Author:		Mark Neves
        Created:	16/02/2005
        Inputs:		iSiteID = the site
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Adds XML that describes the active site config 

*********************************************************************************/

bool CMessageBoardTransfer::AddSiteConfig(int iSiteID)
{
	CTDVString sSiteConfig;
	CSiteConfig SiteConfig(m_InputContext);

	if (!SiteConfig.GetSiteConfig(iSiteID,sSiteConfig))
	{
		return CopyDNALastError("CMessageBoardTransfer::AddSiteConfig",SiteConfig);
	}

	if (!AddInside(BACKUPTAG,sSiteConfig))
	{
		return SetDNALastError("CMessageBoardTransfer::AddSiteConfig","ADDSITECONFIGFAILED","Adding site config failed");
	}

	AddInside(BACKUPLOGTAG,CXMLObject::MakeTag(BACKUPLOGENTRYTAG,"Site Config"));

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::RestoreFromBackupXML(const TDVCHAR* pRestoreXML)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		pRestoreXML = ptr to XML of restore data
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Takes the string containing the XML of the restore data.

					It validates the XML, then picks out the main sections,
					restoring them in a logical order.

					The order can be important.  E.g. you have to restore the Topics
					before the topic elements, otherwise it can't link them together

					NB: The input context must contain an editor id in a param called
					"editor".  Some objects store the editor ID.  This ID must correspond
					to and editor for the target site.

*********************************************************************************/

bool CMessageBoardTransfer::RestoreFromBackupXML(const TDVCHAR* pRestoreXML)
{
	// Clear out any existing XML this object may harbour
	Destroy();

	if (!CreateFromXMLText("<"RESTORETAG"/>"))
	{
		return SetDNALastError("CMessageBoardTransfer::RestoreFromBackupXML","CREATEXMLFAILED","Unable to create initial XML Block");
	}

	if (!AddInside(RESTORETAG,"<"RESTORELOGTAG"/>"))
	{
		return SetDNALastError("CMessageBoardTransfer::RestoreFromBackupXML","ADDRESTORETAGFAILED","Unable to add the restore log tag");
	}

	CTDVString sXMLErrors = CXMLObject::ParseXMLForErrors(pRestoreXML);
	if (!sXMLErrors.IsEmpty())
	{
		return SetDNALastError("CMessageBoardTransfer::RestoreFromBackupXML","PARSEERROR",sXMLErrors);
	}

	int iEditorID=m_InputContext.GetParamInt("editor");
	if (iEditorID == 0)
	{
		return SetDNALastError("CMessageBoardTransfer::RestoreFromBackupXML","NOEDITORID","No editor ID passed in");
	}

	CXMLTree* pTree = CXMLTree::Parse(pRestoreXML);
	if (pTree != NULL)
	{
		int iSiteID = 0;
		bool bOK = GetRestoreSiteID(pTree,iSiteID);

		if (bOK)
		{
			if (iSiteID != m_InputContext.GetSiteID())
			{
				bOK = SetDNALastError("CMessageBoardTransfer::RestoreFromBackupXML","MISMATCHSITEID","The site in the XML doesn't match the current site");
			}
		}

		CTDVString sRestoreXMLErrors;
		if (bOK)
		{
			CXMLTree* pNode = NULL;

			// Front page
			pNode = pTree->FindFirstTagName("/"BACKUPTAG"/FRONTPAGEXML");
			RestoreFrontPageXML(pNode,iSiteID,iEditorID);
			sRestoreXMLErrors << GetLastErrorAsXMLString();
			ClearError();

			// Topics
			pNode = pTree->FindFirstTagName("/"BACKUPTAG"/TOPICLIST");
			RestoreTopicList(pNode,iSiteID,iEditorID);
			sRestoreXMLErrors << GetLastErrorAsXMLString();
			ClearError();

			// Topic elements
			pNode = pTree->FindFirstTagName("/"BACKUPTAG"/TOPICELEMENTLIST");
			RestoreTopicElementList(pNode,iSiteID,iEditorID);
			sRestoreXMLErrors << GetLastErrorAsXMLString();
			ClearError();

			// Board promos
			pNode = pTree->FindFirstTagName("/"BACKUPTAG"/BOARDPROMOLIST");
			RestoreBoardPromoList(pNode,iSiteID,iEditorID);
			sRestoreXMLErrors << GetLastErrorAsXMLString();
			ClearError();

			// Text boxes
			pNode = pTree->FindFirstTagName("/"BACKUPTAG"/TEXTBOXLIST");
			RestoreTextBoxList(pNode,iSiteID,iEditorID);
			sRestoreXMLErrors << GetLastErrorAsXMLString();
			ClearError();

			// Forum schedules
			pNode = pTree->FindFirstTagName("/"BACKUPTAG"/FORUMSCHEDULES");
			RestoreForumSchedules(pNode,iSiteID);
			sRestoreXMLErrors << GetLastErrorAsXMLString();
			ClearError();

			// Site config
			pNode = pTree->FindFirstTagName("/"BACKUPTAG"/SITECONFIG");
			RestoreSiteConfig(pNode,iSiteID);
			sRestoreXMLErrors << GetLastErrorAsXMLString();
			ClearError();
		}

		delete pTree;
		pTree = NULL;

		if (!sRestoreXMLErrors.IsEmpty())
		{
			SetDNALastError("CMessageBoardTransfer::RestoreFromBackupXML","RESTOREERRORS",sRestoreXMLErrors);
		}
	}
	else
	{
		SetDNALastError("CMessageBoardTransfer::RestoreFromBackupXML","PARSEERROR","NULL pTree for some reason!");
	}

	// Make sure all servers recache
	m_InputContext.SiteDataUpdated();
	m_InputContext.Signal("/Signal?action=recache-site");

	return !ErrorReported();
}


/*********************************************************************************

	bool CMessageBoardTransfer::RestoreFrontPageXML(CXMLTree* pFrontPageXMLNode,int iSiteID,int iEditorID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		pFrontPageXMLNode = The XML for the front page
					iSiteID = the site
					iEditorID = the editor ID to use if a preview front page need creating
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Restores the preview front page with the XML pointed to by pFrontPageXMLNode.

*********************************************************************************/

bool CMessageBoardTransfer::RestoreFrontPageXML(CXMLTree* pFrontPageXMLNode,int iSiteID,int iEditorID)
{
	if (pFrontPageXMLNode != NULL)
	{
		CXMLTree* pFrontPageNode = pFrontPageXMLNode->FindFirstTagName("FRONTPAGE",pFrontPageXMLNode);

		if (pFrontPageNode != NULL)
		{
			CTDVString sFrontPageXML;
			pFrontPageNode->OutputXMLTree(sFrontPageXML);

			CFrontPageLayout FrontPageLayout(m_InputContext);
			FrontPageLayout.UpdateFrontPagePreviewDirect(iSiteID,sFrontPageXML,iEditorID);

			if (FrontPageLayout.ErrorReported())
			{
				CopyDNALastError("CMessageBoardTransfer::RestoreFrontPageXML",FrontPageLayout);
			}
		}
		else
		{
			SetDNALastError("CMessageBoardTransfer::RestoreFrontPageXML","NOFRONTPAGENODE","Couldn't find the front page node");
		}
	}

	if (ErrorReported())
	{
		AddInside(RESTORETAG,GetLastErrorAsXMLString());
		return false;
	}

	AddInside(RESTORELOGTAG,CXMLObject::MakeTag(RESTORELOGENTRYTAG,"Front Page"));

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::RestoreTopicList(CXMLTree* pTopicListNode,int iSiteID,int iEditorID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		pTopicListNode = ptr to the topic list XML node
					iSiteID = the site
					iEditorID = editor ID to assign to any topics that is created
        Outputs:	m_mTopicIDMap = a map of original topic IDs to new topic IDs
        Returns:	true if OK, false otherwise
        Purpose:	Creates preview topics for all the topics pointed to by pTopicListNode,
					in the given site.

					It also creates a map of original->new topic IDs, so other elements
					that need to be linked to topics (e.g. topic element) can work out
					which of the new topics they need to be linked to.

*********************************************************************************/

bool CMessageBoardTransfer::RestoreTopicList(CXMLTree* pTopicListNode,int iSiteID,int iEditorID)
{
	m_mTopicIDMap.clear();

	if (pTopicListNode != NULL)
	{
		CXMLTree* pNode = pTopicListNode->FindFirstTagName("TOPIC",pTopicListNode);
		while (pNode != NULL && !ErrorReported())
		{
			int iOrigTopicID = GetNodeInt("TOPICID",pNode);

			if (iOrigTopicID > 0)
			{
				CTDVString sTitle = GetNodeChildXML("TITLE",pNode);
				CTDVString sText  = GetNodeChildXML("DESCRIPTION",pNode);

				CTopic Topic(m_InputContext);
				int iNewTopicID=0;
				Topic.CreateTopic(iNewTopicID,iSiteID,iEditorID,sTitle,sText,CTopic::TS_PREVIEW,0,true);

				// Remember mapping between orig & new IDs
				m_mTopicIDMap[iOrigTopicID] = iNewTopicID;

				if (Topic.ErrorReported())
				{
					CopyDNALastError("CMessageBoardTransfer::RestoreTopicList",Topic);
				}
			}
			else
			{
				SetDNALastError("CMessageBoardTransfer::RestoreTopicList","ZEROTOPICID","The original topic ID is zero");
			}

			pNode = pNode->FindNextTagNode("TOPIC",pTopicListNode);
		}
	}

	if (ErrorReported())
	{
		AddInside(RESTORETAG,GetLastErrorAsXMLString());
		return false;
	}

	AddInside(RESTORELOGTAG,CXMLObject::MakeTag(RESTORELOGENTRYTAG,"Topic List"));

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::RestoreTopicElementList(CXMLTree* pTopicElementListNode,int iSiteID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		pTopicElementListNode = ptr to topic elements node
					iSiteID = the site
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Creates the topic elements, linking each one to the correct topic

*********************************************************************************/

bool CMessageBoardTransfer::RestoreTopicElementList(CXMLTree* pTopicElementListNode,int iSiteID, int iEditorID)
{
	if (pTopicElementListNode != NULL)
	{
		CXMLTree* pNode = pTopicElementListNode->FindFirstTagName("TOPICELEMENT",pTopicElementListNode);
		while (pNode != NULL && !ErrorReported())
		{
			int iTopicID = GetNodeInt("TOPICID",pNode);
			int iMappedTopicID = m_mTopicIDMap[iTopicID];

			if (iTopicID > 0 && iMappedTopicID > 0)
			{
				CTDVString sText   = GetNodeChildXML("TEXT",pNode);
				CTDVString sImage  = GetNodeText("IMAGENAME",pNode);
				CTDVString sTitle   = GetNodeChildXML("TITLE",pNode);
				CTDVString sImageAltText  = GetNodeText("IMAGEALTTEXT",pNode);
				int iTemplateType  = GetNodeInt("TEMPLATETYPE",pNode);

				CFrontPageTopicElement TopicElement(m_InputContext);

				int iTopicElementID = 0;
				TopicElement.CreateTopicFrontPageElement(iTopicElementID,iSiteID,iEditorID,CFrontPageElement::ES_PREVIEW,0,iMappedTopicID,false,sText,sImage,iTemplateType,sTitle,sImageAltText);

				if (TopicElement.ErrorReported())
				{
					CopyDNALastError("CMessageBoardTransfer::RestoreTopicElementList",TopicElement);
				}
			}
			else
			{
				if (iTopicID <= 0)
				{
					SetDNALastError("CMessageBoardTransfer::RestoreTopicElementList","ZEROTOPICID","The topic ID is zero for topic element");
				}
				else
				{
					SetDNALastError("CMessageBoardTransfer::RestoreTopicElementList","NOMATCHINGTOPIC","No matching topic found for topic element");
				}
			}

			pNode = pNode->FindNextTagNode("TOPICELEMENT",pTopicElementListNode);
		}
	}

	if (ErrorReported())
	{
		AddInside(RESTORETAG,GetLastErrorAsXMLString());
		return false;
	}

	AddInside(RESTORELOGTAG,CXMLObject::MakeTag(RESTORELOGENTRYTAG,"Topic Element List"));

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::RestoreBoardPromoList(CXMLTree* pBoardPromoListNode,int iSiteID,int iEditorID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		pBoardPromoListNode = ptr to board promo list node
					iSiteID = the site
					iEditorID = the editor ID used to update the UserUpdated field in the
								associated topic
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Creates the board promos, and set their locations.

*********************************************************************************/

bool CMessageBoardTransfer::RestoreBoardPromoList(CXMLTree* pBoardPromoListNode,int iSiteID,int iEditorID)
{
	if (pBoardPromoListNode != NULL)
	{
		CXMLTree* pNode = pBoardPromoListNode->FindFirstTagName("BOARDPROMO",pBoardPromoListNode);
		while (pNode != NULL && !ErrorReported())
		{
			CMessageBoardPromo BoardPromo(m_InputContext);
			CTDVString sEditKey, sNewEditKey;
			int iNewPromoID=0;
			if (BoardPromo.CreateNewBoardPromo(iSiteID,iEditorID,iNewPromoID,&sEditKey))
			{
				int iTemplateType = GetNodeInt("TEMPLATETYPE",pNode);
				int iBoxType      = GetNodeInt("TEXTBOXTYPE",pNode);

				CTDVString sTitle     = GetNodeChildXML("TITLE",pNode);
				CTDVString sText      = GetNodeChildXML("TEXT",pNode);
				CTDVString sImageName = GetNodeText("IMAGENAME",pNode);

				BoardPromo.SetTemplateType(iNewPromoID,iTemplateType,false,iEditorID,"");
				BoardPromo.SetBoardPromoType(iNewPromoID,iBoxType,false,iEditorID,"");
				BoardPromo.SetTitle(iNewPromoID,sTitle,false,iEditorID,"");
				BoardPromo.SetText(iNewPromoID,sText,false,iEditorID,"");
				BoardPromo.SetImageName(iNewPromoID,sImageName,false,iEditorID,"");
				BoardPromo.CommitBoardPromoChanges(iEditorID,sEditKey,&sNewEditKey);

				if (!BoardPromo.ErrorReported())
				{
					SetBoardPromoLocations(BoardPromo,iNewPromoID,pNode,sNewEditKey,iEditorID);
				}

				CTDVString sName = GetNodeText("NAME",pNode);
				BoardPromo.SetBoardPromoName(iNewPromoID,sName,sNewEditKey);

				int iDefaultSitePromo = GetNodeInt("DEFAULTSITEPROMO",pNode);
				if (iDefaultSitePromo > 0)
				{
					BoardPromo.SetDefaultBoardPromoForTopics(iSiteID,iNewPromoID,iEditorID);
				}
			}

			if (BoardPromo.ErrorReported())
			{
				CopyDNALastError("CMessageBoardTransfer::RestoreBoardPromoList",BoardPromo);
			}

			pNode = pNode->FindNextTagNode("BOARDPROMO",pBoardPromoListNode);
		}
	}

	if (ErrorReported())
	{
		AddInside(RESTORETAG,GetLastErrorAsXMLString());
		return false;
	}

	AddInside(RESTORELOGTAG,CXMLObject::MakeTag(RESTORELOGENTRYTAG,"Board Promo List"));

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::SetBoardPromoLocations(CMessageBoardPromo& BoardPromo,int iBoardPromoID,CXMLTree* pNode,const TDVCHAR* pEditKey,int iEditorID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		BoardPromo = A board promo object
					iBoardPromoID = the id of BoardPromo
					pNode = ptr to a board promo node
					pEditKey = the edit key needed to update the board promo object
					iEditorID = the editor ID that's doing the editing
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	This reads the topic locations associated with the given board
					promo object from the XML input, then sets the them up using
					the SetBoardPromoLocations() method of CMessageBoardPromo

					Uses m_mTopicIDMap to map the original topic IDs to the
					new topic ids

*********************************************************************************/

bool CMessageBoardTransfer::SetBoardPromoLocations(CMessageBoardPromo& BoardPromo,int iBoardPromoID,CXMLTree* pNode,const TDVCHAR* pEditKey, int iEditorID)
{
	if (pNode == NULL || iBoardPromoID <= 0)
	{
		return SetDNALastError("CMessageBoardTransfer::SetBoardPromoLocations","INVALIDPARAMS","Invalid params");
	}

	CDNAIntArray aTopicLocs;

	CXMLTree* pTopicLocations = pNode->FindFirstTagName("TOPICLOCATIONS",pNode);
	CXMLTree* pTopicID = pTopicLocations;
	if (pTopicLocations != NULL)
	{
		pTopicID = pTopicID->FindNextTagNode("TOPICID",pTopicLocations);
		while (pTopicID != NULL)
		{
			CTDVString sTopicID;
			pTopicID->GetTextContents(sTopicID);
			int iTopicID = m_mTopicIDMap[atoi(sTopicID)];
			if (iTopicID > 0)
			{
				aTopicLocs.Add(iTopicID);
			}

			pTopicID = pTopicID->FindNextTagNode("TOPICID",pTopicLocations);
		}
	}

	if (!aTopicLocs.IsEmpty())
	{
		BoardPromo.SetBoardPromoLocations(iBoardPromoID,aTopicLocs,pEditKey,iEditorID);
	}

	if (BoardPromo.ErrorReported())
	{
		return CopyDNALastError("CMessageBoardTransfer::SetBoardPromoLocations",BoardPromo);
	}

	return true;
}


/*********************************************************************************

	bool CMessageBoardTransfer::RestoreTextBoxList(CXMLTree* pTextBoxListNode,int iSiteID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		pTextBoxListNode = ptr to the text box list node
					iSiteID = the site
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Creates the new preview text boxes in the given site

*********************************************************************************/

bool CMessageBoardTransfer::RestoreTextBoxList(CXMLTree* pTextBoxListNode,int iSiteID,int iEditorID)
{
	if (pTextBoxListNode != NULL)
	{
		CXMLTree* pNode = pTextBoxListNode->FindFirstTagName("TEXTBOX",pTextBoxListNode);
		while (pNode != NULL && !ErrorReported())
		{
			CTextBoxElement TextBox(m_InputContext);
			CTDVString sEditKey, sNewEditKey;
			int iNewTextBoxID=0;
			if (TextBox.CreateNewTextBox(iSiteID,iEditorID,iNewTextBoxID,0,&sEditKey))
			{
				int iTemplateType = GetNodeInt("TEMPLATETYPE",pNode);
				int iBoxType      = GetNodeInt("TEXTBOXTYPE",pNode);
				int iPosition	  = GetNodeInt("FRONTPAGEPOSITION",pNode);
				int iBorderType   = GetNodeInt("TEXTBORDERTYPE",pNode);
				int iImageWidth	  = GetNodeInt("IMAGEWIDTH",pNode);
				int iImageHeight  = GetNodeInt("IMAGEHEIGHT",pNode);

				CTDVString sTitle     = GetNodeChildXML("TITLE",pNode);
				CTDVString sText      = GetNodeChildXML("TEXT",pNode);
				CTDVString sImageName = GetNodeText("IMAGENAME",pNode);

				TextBox.SetTemplateType(iNewTextBoxID, iTemplateType,false,iEditorID,"");
				TextBox.SetTitle(iNewTextBoxID,sTitle, false,iEditorID, "");
				TextBox.SetText(iNewTextBoxID, sText, false, iEditorID, "");
				TextBox.SetPosition(iNewTextBoxID, iPosition, false, iEditorID, "");
				TextBox.SetImageName(iNewTextBoxID,sImageName, false, iEditorID, "");
				TextBox.SetTextBoxType(iNewTextBoxID, iBoxType, false, iEditorID, "");
				TextBox.SetBorderType(iNewTextBoxID, iBorderType, false, iEditorID, "");
				TextBox.SetImageWidth(iNewTextBoxID, iImageWidth, false, iEditorID, "");
				TextBox.SetImageHeight(iNewTextBoxID, iImageHeight, false, iEditorID, "");
				TextBox.CommitTextBoxChanges(iEditorID, sEditKey);
			}

			if (TextBox.ErrorReported())
			{
				CopyDNALastError("CMessageBoardTransfer::RestoreTextBoxList",TextBox);
			}

			pNode = pNode->FindNextTagNode("TEXTBOX",pTextBoxListNode);
		}
	}

	if (ErrorReported())
	{
		AddInside(RESTORETAG,GetLastErrorAsXMLString());
		return false;
	}

	AddInside(RESTORELOGTAG,CXMLObject::MakeTag(RESTORELOGENTRYTAG,"Text Box List"));

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::RestoreForumSchedules(CXMLTree* pForumSchedulesNode,int iSiteID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		pForumSchedulesNode = ptr to forum schedule info
					iSiteID = the site
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	This does one of two actions:

					If there's no schedule information for the current set of preview topics
					it creates schedules for them all based on the schedule info in the
					supplied XML node.

					If there's already forum schedule information, the existing schedules
					are copied to the new forums associated with the newly created topics.

					The reason for this behaviour is because there's no concept of preview
					and live forum schedules.  There's only one schedule.  So, if one has
					already been set up on the given site, it should be preserved, and assigned
					to all forums in this site.

*********************************************************************************/

bool CMessageBoardTransfer::RestoreForumSchedules(CXMLTree* pForumSchedulesNode,int iSiteID)
{
	if (pForumSchedulesNode == NULL)
	{
		return SetDNALastError("CMessageBoardTransfer::RestoreForumSchedules","NULLPTR","NULL ptr passed in");
	}

	CForumSchedule ForumSchedule(m_InputContext);
	CTopic Topic(m_InputContext);

	CDNAIntArray ForumIDList;
	Topic.GetTopicForumIDs(iSiteID,ForumIDList,CTopic::TS_PREVIEW);

	int iCount = 0;
	ForumSchedule.GetForumScheduleInfo(ForumIDList,true,&iCount);

	if (iCount == 0)
	{
		// No forum schedule currently set for the forums in this site
		// so set up the schedule from the XML provided

		CXMLTree* pScheduleNode = pForumSchedulesNode->FindFirstTagName("SCHEDULE",pForumSchedulesNode);
		if (pScheduleNode != NULL)
		{
			CXMLTree* pEventNode = pScheduleNode->FindFirstTagName("EVENT",pScheduleNode);
			while (pEventNode != NULL && !ErrorReported())
			{
				CXMLTree* pTimeNode = pEventNode->FindFirstTagName("TIME",pEventNode);
				if (pTimeNode != NULL)
				{
					int iEventType = pEventNode->GetIntAttribute("TYPE");
					int iAction    = pEventNode->GetIntAttribute("ACTION");
					int iActive	   = pEventNode->GetIntAttribute("ACTIVE");

					int iDayType   = pTimeNode->GetIntAttribute("DAYTYPE");
					int iHours     = pTimeNode->GetIntAttribute("HOURS");
					int iMins	   = pTimeNode->GetIntAttribute("MINUTES");

					ForumSchedule.CreateScheduleDirect(ForumIDList,iEventType,iAction,iActive,iDayType,iHours,iMins);

					if (ForumSchedule.ErrorReported())
					{
						CopyDNALastError("CMessageBoardTransfer::RestoreForumSchedules",ForumSchedule);
					}
				}
				else
				{
					SetDNALastError("CMessageBoardTransfer::RestoreForumSchedules","NOTIMETAG","Missing TIME tag in EVENT tag");
				}

				pEventNode = pEventNode->FindNextTagNode("EVENT",pScheduleNode);
			}
		}
	}
	else
	{
		// A forum schedule has already been set up
		// so copy the existing schedule info to the new forums
		ForumSchedule.GenerateSchedulesIfNewForums(ForumIDList,iSiteID);

		if (ForumSchedule.ErrorReported())
		{
			CopyDNALastError("CMessageBoardTransfer::RestoreForumSchedules",ForumSchedule);
		}
	}

	if (ErrorReported())
	{
		AddInside(RESTORETAG,GetLastErrorAsXMLString());
		return false;
	}

	AddInside(RESTORELOGTAG,CXMLObject::MakeTag(RESTORELOGENTRYTAG,"Forum Schedule"));

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::RestoreSiteConfig(CXMLTree* pSiteConfig,int iSiteID)

		Author:		Mark Neves
        Created:	16/02/2005
        Inputs:		pSiteConfig = ptr site config node
					iSiteID = the site
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Sets the preview site config for iSiteID with the XML pointed
					to by pSiteConfig

*********************************************************************************/

bool CMessageBoardTransfer::RestoreSiteConfig(CXMLTree* pSiteConfig,int iSiteID)
{
	if (pSiteConfig != NULL)
	{
		CTDVString sSiteConfig,sEditKey;

		CSiteConfigPreview SiteConfigPreview(m_InputContext);

		// Call this just for the Edit key
		SiteConfigPreview.GetPreviewSiteConfig(sSiteConfig,iSiteID,&sEditKey);

		// Throw away current site config, and replace it with the new stuff
		sSiteConfig.Empty();
		pSiteConfig->OutputXMLTree(sSiteConfig);

		// Set site config
		SiteConfigPreview.SetSiteConfig(NULL,iSiteID,sSiteConfig,sEditKey);

		if (SiteConfigPreview.ErrorReported())
		{
			CopyDNALastError("CMessageBoardTransfer::RestoreSiteConfig",SiteConfigPreview);
		}
	}
	else
	{
		SetDNALastError("CMessageBoardTransfer::RestoreSiteConfig","NOSITECONFIG","No site config supplied");
	}

	if (ErrorReported())
	{
		AddInside(RESTORETAG,GetLastErrorAsXMLString());
		return false;
	}

	AddInside(RESTORELOGTAG,CXMLObject::MakeTag(RESTORELOGENTRYTAG,"Site Config"));

	return true;
}

/*********************************************************************************

	bool CMessageBoardTransfer::GetRestoreSiteID(CXMLTree* pTree,int& iSiteID)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		pTree = ptr to the tree
        Outputs:	iSiteID = the site (set to 0 if no site is found)
        Returns:	true if OK, false otherwise
        Purpose:	Looks for the Site name in the SITE XML block,
					and returns the ID

*********************************************************************************/

bool CMessageBoardTransfer::GetRestoreSiteID(CXMLTree* pTree,int& iSiteID)
{
	iSiteID = 0;

	if (pTree == NULL)
	{
		return SetDNALastError("CMessageBoardTransfer::GetRestoreSiteID","NULLTREEPTR","NULL tree ptr");
	}

	CTDVString sSiteName = GetNodeText("/"BACKUPTAG"/SITE/NAME",pTree);
	if (sSiteName.IsEmpty())
	{
		return SetDNALastError("CMessageBoardTransfer::GetRestoreSiteID","NOSITENAME","Can't find site name");
	}

	iSiteID = m_InputContext.GetSiteID(sSiteName);
	if (iSiteID == 0)
	{
		return SetDNALastError("CMessageBoardTransfer::GetRestoreSiteID","BADSITENAME",CTDVString("Can't find site with name: ") << sSiteName);
	}

	return true;
}

/*********************************************************************************

	int CMessageBoardTransfer::GetNodeInt(const TDVCHAR* pNodeName,CXMLTree* pRoot)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		pNodeName = the name of the node in question
					pRoot = the root node
        Outputs:	-
        Returns:	The int stored in the first tag called pNodeName, 0 if not found.
        Purpose:	Helper function for getting tag data from a given node in the tree.

					When looking for pNodeName, it will not scan "above" pRoot, therefore
					localising the search.

					Probably should go into CXMLTree at some point

*********************************************************************************/

int CMessageBoardTransfer::GetNodeInt(const TDVCHAR* pNodeName,CXMLTree* pRoot)
{
	return atoi(GetNodeText(pNodeName,pRoot));
}

/*********************************************************************************

	CTDVString CMessageBoardTransfer::GetNodeText(const TDVCHAR* pNodeName,CXMLTree* pRoot)

		Author:		Mark Neves
        Created:	14/02/2005
        Inputs:		pNodeName = the name of the node in question
					pRoot = the root node
        Outputs:	-
        Returns:	The text content of node pNodeName, or "" if not found
        Purpose:	Helper function for getting tag data from a given node in the tree.

					When looking for pNodeName, it will not scan "above" pRoot, therefore
					localising the search.

					Probably should go into CXMLTree at some point

*********************************************************************************/

CTDVString CMessageBoardTransfer::GetNodeText(const TDVCHAR* pNodeName,CXMLTree* pRoot)
{
	CTDVString sResult;

	if (pNodeName != NULL && pRoot != NULL)
	{
		CXMLTree* pNode = pRoot->FindFirstTagName(pNodeName,pRoot);
		if (pNode != NULL)
		{
			pNode->GetTextContents(sResult);
		}
	}

	return sResult;
}

/*********************************************************************************

	CTDVString CMessageBoardTransfer::GetNodeChildXML(const TDVCHAR* pNodeName,CXMLTree* pRoot)

		Author:		Mark Neves
        Created:	12/04/2005
        Inputs:		pNodeName = the name of the node in question
					pRoot = the root node
        Outputs:	-
        Returns:	The XML content of node pNodeName, or "" if not found
        Purpose:	Helper function for getting tag XML data from a given node in the tree.

					When looking for pNodeName, it will not scan "above" pRoot, therefore
					localising the search.

					Only the XML of the child nodes (inc. the immediate text nodes) is returned.

					Probably should go into CXMLTree at some point

*********************************************************************************/

CTDVString CMessageBoardTransfer::GetNodeChildXML(const TDVCHAR* pNodeName,CXMLTree* pRoot)
{
	CTDVString sResult;

	if (pNodeName != NULL && pRoot != NULL)
	{
		CXMLTree* pNode = pRoot->FindFirstTagName(pNodeName,pRoot);
		if (pNode != NULL)
		{
			pNode->OutputChildrenXMLTree(sResult);
		}
	}

	return sResult;
}

