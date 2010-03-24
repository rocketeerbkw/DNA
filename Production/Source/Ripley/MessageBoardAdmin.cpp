#include "stdafx.h"
#include "MessageBoardAdmin.h"
#include "TDVAssert.h"
#include "StoredProcedure.h"
#include "FrontPageLayout.h"
#include "Topic.h"
#include "FrontPageTopicElement.h"
#include "MessageBoardPromo.h"
#include "TextBoxElement.h"
#include "User.h"
#include "ForumSchedule.h"
#include "SiteConfigPreview.h"

/*********************************************************************************
CMessageBoardAdmin::CMessageBoardAdmin()
Author:		Nick Stevenson
Created:	29/07/2004
Purpose:	Constructor
*********************************************************************************/

CMessageBoardAdmin::CMessageBoardAdmin(CInputContext& inputContext) :
CXMLObject(inputContext), m_InputContext(inputContext)
{
}

/*********************************************************************************
CMessageBoardAdmin::~CMessageBoardAdmin()
Author:		Nick Stevenson
Created:	29/07/2004
Purpose:	Destructor
*********************************************************************************/

CMessageBoardAdmin::~CMessageBoardAdmin()
{
}

bool CMessageBoardAdmin::GetAdminState()
{
	bool bSuccess = true;
	CTDVString sXML;
	sXML << "<ADMINSTATE>";
	
	// errors are kept track of in called functions
	bSuccess = bSuccess && GetStatusIndicators(sXML);
	bSuccess = bSuccess && GetReadyToLauchIndicators(sXML);

	sXML << "</ADMINSTATE>";
	if (!CreateFromXMLText(sXML))
	{
		return SetDNALastError("CMessageBoardAdmin","GetAdminState()","Failed to generate XML from string");
	}

	return bSuccess;
}

/*********************************************************************************

	bool CMessageBoardAdmin::GetStatusIndicators(CTDVString& sXML)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::GetStatusIndicators(CTDVString& sXML)
{
	bool bSuccess = true;

	CStoredProcedure SP;
	if(!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMessageBoardAdmin","GetStatusIndicators()","Failed to create SP");
	}

	if( !SP.GetMessageBoardAdminStatusIndicators(m_InputContext.GetSiteID()) )
	{
		return SetDNALastError("CMessageBoardAdmin","GetStatusIndicators()","Stored procedure Failed to get status data");
	}
	
	sXML << "<STATUS-INDICATORS>";
	while(!SP.IsEOF())
	{
		int iType = SP.GetIntField("Type");
		int iStatus = SP.GetIntField("Status");
		sXML << "<TASK TYPE='" << iType << "'>";	
		sXML << "<STATUS>" << iStatus << "</STATUS>";
		sXML << "</TASK>";

		SP.MoveNext();
	}
	sXML << "</STATUS-INDICATORS>";
	
	return bSuccess;
}

/*********************************************************************************

	bool CMessageBoardAdmin::GetReadyToLauchIndicators(CTDVString& sXML)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::GetReadyToLauchIndicators(CTDVString& sXML)
{	
	bool bSuccess = true;

	sXML << "<READYTOLAUNCH-INDICATORS>";
	
	// errors are kept track of in called functions
	bSuccess = bSuccess && GetTemplateSetUpIsReadyIndicators(sXML);
	bSuccess = bSuccess && GetTopicIsReadyIndicators(sXML);
	bSuccess = bSuccess && GetHomepageContentIsReadyIndicators(sXML);
	bSuccess = bSuccess && GetBoardPromoIsReadyIndicators(sXML);
	bSuccess = bSuccess && GetBoardScheduleIsReadyIndicators(sXML);
	bSuccess = bSuccess && GetAssetsAreReadyIndicators(sXML);
	// instructional text can be determined from the assetmanager stuff
	// site navigation as for instructional text

	sXML << "</READYTOLAUNCH-INDICATORS>";

	return bSuccess;
}

/*********************************************************************************

	bool CMessageBoardAdmin::ActivateBoard(CTDVString& sRedirect)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::ActivateBoard(CTDVString& sRedirect)
{
	int iSiteID = m_InputContext.GetSiteID();

	//xml frontpage preview
	CFrontPageLayout FPLayout(m_InputContext);
	if(!FPLayout.MakePreviewItemActive(iSiteID))
	{
		return SetDNALastError("CMessageBoardAdmin","ActivateBoard()","Failed to make active FrontPageLayout preview");
	}

	//topics
	int iEditorID = 0;	
	CUser* pUser = m_InputContext.GetCurrentUser();
	if ( pUser && pUser->GetIsEditor() )
	{
		iEditorID = pUser->GetUserID( );	
	}

	if (iEditorID == 0)
	{
		return SetDNALastError("CMessageBoardAdmin","ActivateBoard()","Failed to make active FrontPageLayout preview- invalid user");
	}

	CTopic Topic(m_InputContext);
	if(!Topic.MakePreviewTopicsActiveForSite(iSiteID, iEditorID))
	{
		return SetDNALastError("CMessageBoardAdmin","ActivateBoard()","Failed to make active Topic preview");
	}

	// Topic Elements
	CFrontPageTopicElement TopicElement(m_InputContext);
	if (!TopicElement.MakePreviewTopicFrontPageElementsActive(iSiteID,iEditorID))
	{
		return SetDNALastError("CMessageBoardAdmin","ActivateBoard","Failed to make the TopicElements Active");
	}

	// Setup Forum Opening And Closing Times
	if ( !SetupTopicsForumOpeningAndClosingTimes(CTopic::TS_LIVE, iSiteID))
	{
		return SetDNALastError("CMessageBoardAdmin","ActivateBoard","Failed to Setup Forum Opening And Closing Times");
	}

	//text boxes
	CTextBoxElement TBElem(m_InputContext);
	if(!TBElem.MakePreviewTextBoxesActive(iSiteID,iEditorID))
	{
		return SetDNALastError("CMessageBoardAdmin", "ActivateBoard()", "Failed to make active TextBoxElements preview");
	}

	//promos
	CMessageBoardPromo MBPromo(m_InputContext);
	if(!MBPromo.MakePreviewBoardPromosActive(iSiteID,iEditorID))
	{
		return SetDNALastError("CMessageBoardAdmin", "ActivateBoard()", "Failed to make active MessageBoardPromo preview");
	}

	// Site Config
	CSiteConfigPreview SiteConfigPreview(m_InputContext);
	if (!SiteConfigPreview.MakePreviewSiteConfigActive(iSiteID))
	{
		return SetDNALastError("CMessageBoardAdmin", "ActivateBoard()", "Failed to make site config active!");		
	}

	// reset the values of MessageBoardAdmin
	if(!UpdateEveryAdminStatusForSite(AS_UNREAD))
	{
		return SetDNALastError("CMessageBoardAdmin", "ActivateBoard()", "Failed to reset the values of MessageBoard Admin status by siteid");		
	}

	sRedirect << "MessageBoardAdmin?cmd=display";
	
	// create a cursory bit of XML
	if (!CreateFromXMLText("<BOARDACTIVATED>1</BOARDACTIVATED>"))
	{
		return false;
	}	

	return true;
}



/*********************************************************************************

	bool CMessageBoardAdmin::GetTemplateSetUpIsReadyIndicators(CTDVString& sXML)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::GetTemplateSetUpIsReadyIndicators(CTDVString& sXML)
{
	int iLayout = 0, iTmpl = 0, iElemTmpl = 0;
	CTDVString sElemTmplGuideML;
	CFrontPageLayout FPL(m_InputContext);

	// Now initialise and get the Layout details
	if (!FPL.InitialisePageBody(m_InputContext.GetSiteID(),true,true) || !FPL.GetLayoutAndTemplateData(iLayout, iTmpl, iElemTmpl, sElemTmplGuideML))
	{
		return SetDNALastError("CMessageBoardAdmin::GetTemplateSetUpIsReadyIndicators", "FailedToGetFrontPageLayout","Failed to get frontpage layout information!!!");
	}

	CTDVString sInsert;
	if (iLayout > 0)
	{
		CTDVString sInsert;
		sInsert << "<LAYOUT>" << iLayout << "</LAYOUT>";
		BuildReadyToLaunchXML(AT_FRONTPAGELAYOUT, sXML, sInsert);
	}
	if (iTmpl > 0)
	{
		CTDVString sInsert;
		sInsert << "<TEMPLATE>" << iTmpl << "</TEMPLATE>";
		BuildReadyToLaunchXML(AT_FRONTPAGETEMPLATE, sXML, sInsert);
	}
	if (iElemTmpl > 0)
	{
		CTDVString sInsert;
		sInsert << "<ELEMTEMPLATE>" << iElemTmpl << "</ELEMTEMPLATE>";
		BuildReadyToLaunchXML(AT_TOPICFRONTPAGEELEMENT, sXML, sInsert);
	}
	
	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::GetTopicIsReadyIndicators(CTDVString& sXML)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::GetTopicIsReadyIndicators(CTDVString& sXML)
{
	// some function-wide vars
	CTDVString sInsert;
	CTopic Topic(m_InputContext);

	// get the preview topic data
	CTDVString sPreviewTopics;
	if(!Topic.GetTopicsForSiteID(m_InputContext.GetSiteID(), Topic.TS_PREVIEW))
	{
		return SetDNALastError("CMessageBoardAdmin", "GetTemplateSetUpIsReadyIndicators()","Failed to get Topic data.");
	}
	Topic.GetAsString(sPreviewTopics);

	sInsert << sPreviewTopics;

	BuildReadyToLaunchXML(AT_TOPICCREATION, sXML, sInsert);

	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::GetHomepageContentIsReadyIndicators(CTDVString& sXML)

		Author:		Nick Stevnson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::GetHomepageContentIsReadyIndicators(CTDVString& sXML)
{
	int iNumPreviewTextBoxes = 0;
	int iNumActiveTextBoxes = 0;
	CTDVString sInsert;

	CTextBoxElement TBElem(m_InputContext);

	// get number of preview textboxes
	if(!TBElem.GetNumberOfTextBoxesForSiteID(m_InputContext.GetSiteID(), iNumPreviewTextBoxes, TBElem.ES_PREVIEW))
	{
		return SetDNALastError("CMessageBoardAdmin", "GetTextBoxContentIsReadyIndicators()", "Failed to get Text Box content data.");
	}
	sInsert << "<TEXTBOX-TOTAL STATUS='PREVIEW'>" << iNumPreviewTextBoxes << "</TEXTBOX-TOTAL>";

	// get preview topic elements
	CTDVString sFPTEPreview;
	CFrontPageTopicElement FPTopicElemsPreview(m_InputContext);
	if(!FPTopicElemsPreview.GetTopicFrontPageElementsForSiteID(m_InputContext.GetSiteID(), FPTopicElemsPreview.ES_PREVIEW))
	{
		return SetDNALastError("CMessageBoardAdmin", "GetTopicIsReadyIndicators()","Failed to get FrontPage Topic Element data.");
	}
	FPTopicElemsPreview.GetAsString(sFPTEPreview);

	sInsert << sFPTEPreview;

	BuildReadyToLaunchXML( AT_HOMEPAGECONTENT, sXML, sInsert);

	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::GetBoardPromoIsReadyIndicators(CTDVString& sXML)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::GetBoardPromoIsReadyIndicators(CTDVString& sXML)
{
	//Jan 2005 -Board Promos are not mandatory so just build a true value in XML
	CMessageBoardPromo MBPromo(m_InputContext);
	
	CTDVString sInsert;
	int iNumPreviewPromos = 0;
	MBPromo.GetNumberOfBoardPromosForSiteID(m_InputContext.GetSiteID(), iNumPreviewPromos, MBPromo.ES_PREVIEW);

	sInsert << "<BOARDPROMO-TOTAL>" << iNumPreviewPromos << "</BOARDPROMO-TOTAL>";
	BuildReadyToLaunchXML(AT_MESSAGEBOARDPROMOS, sXML, sInsert);
	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::GetBoardScheduleIsReadyIndicators(CTDVString& sXML)

		Author:		Nick Stevenson
        Created:	22/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::GetBoardScheduleIsReadyIndicators(CTDVString& sXML)
{
	CForumSchedule FSchedule(m_InputContext);
	// get one or more topic ids for the site
	CTopic Topic(m_InputContext);
	CDNAIntArray ForumIDs;
	ForumIDs.SetSize(0,1);

	CDNAIntArray TopicForumIDs;
	// get preview and live id-sets because there no concept of preview/active in the 
	// scheduler
	bool bSuccess = Topic.GetTopicForumIDs(m_InputContext.GetSiteID(), ForumIDs, CTopic::TS_PREVIEW);
	bSuccess = bSuccess && Topic.GetTopicForumIDs(m_InputContext.GetSiteID(), TopicForumIDs, CTopic::TS_LIVE);
	
	if(!bSuccess)
	{
		return SetDNALastError("CMessageBoardAdmin", "GetBoardScheduleIsReadyIndicators()", "Failed to get forum ids for Topic data.");
	}

	// add the forum ids to int array ForumIDs
	int iTopicCount = TopicForumIDs.GetSize();
	int iIDCount = ForumIDs.GetSize();
	ForumIDs.SetSize((ForumIDs.GetSize() + iTopicCount), 1);
	int i = 0;
	while(i < TopicForumIDs.GetSize())
	{
		ForumIDs.SetAt((iIDCount + i), TopicForumIDs.GetAt(i));
		i++;
	}
	CTDVString sInsert;
	if(ForumIDs.GetSize() > 0)
	{
		//get the results
		// Get the schedule info and request a normalised set
		if(!FSchedule.GetForumScheduleInfo(ForumIDs, true))
		{
			return SetDNALastError("CMessageBoardAdmin", "GetBoardScheduleIsReadyIndicators()", "Failed to get Board schedule data.");
		}
		FSchedule.GetAsString(sInsert);
		BuildReadyToLaunchXML(AT_MESSAGEBOARDSCHEDULE, sXML, sInsert);
	}
	else
	{
		// add and empty element
		sInsert << "<FORUMSCHEDULES/>";
		BuildReadyToLaunchXML(AT_MESSAGEBOARDSCHEDULE, sXML, sInsert);
	} 
	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::GetAssetsAreReadyIndicators(CTDVString& sXML)

		Author:		Nick Stevenson
        Created:	15/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::GetAssetsAreReadyIndicators(CTDVString& sXML)
{
	CTDVString sInsert;
	CSiteConfigPreview SCPreview(m_InputContext);
	SCPreview.GetPreviewSiteConfig(sInsert, m_InputContext.GetSiteID());

	// Config data is added to 'MANAGEASSETS' only
	// There is no need to include other Site Config 'tasks'
	BuildReadyToLaunchXML(AT_MANAGEASSETS, sXML, sInsert);

	/*
	BuildReadyToLaunchXML(AT_INSTRUCTIONALTEXT, sXML);
	BuildReadyToLaunchXML(AT_ASSETLOCATIONS, sXML);
	BuildReadyToLaunchXML(AT_SITENAVIGATIONS, sXML);
	BuildReadyToLaunchXML(AT_BOARDFEATURES, sXML);
	*/
	
	return true;
}



/*********************************************************************************

	void CMessageBoardAdmin::BuildReadyToLaunchXML(const int iStatus, const int iType, CTDVString& sXML, const CTDVString& sOptInsert)

	Author:		Nick Stevenson
    Created:	28/01/2005
    Inputs:		-
    Outputs:	-
    Returns:	-
    Purpose:	-

*********************************************************************************/

void CMessageBoardAdmin::BuildReadyToLaunchXML(const int iType, CTDVString& sXML, const CTDVString& sOptInsert /*=NULL*/)
{
	//Status is considered either '1' or '0'
	sXML << "<TASK TYPE='" << iType << "'>";
	if(!sOptInsert.IsEmpty())
	{
		sXML << sOptInsert;
	}
	sXML << "</TASK>";
}


/*********************************************************************************

	bool CMessageBoardAdmin::ViewChooseFrontPageLayout(CTDVString& sRedirect)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	This function is deprecated and its job is now handled by 
					ViewChooseFrontPageTemplate. We keep the function call here
					for completeness 

*********************************************************************************/

bool CMessageBoardAdmin::ViewChooseFrontPageLayout(CTDVString& sRedirect)
{
	bool bSuccess = true;

	if(!UpdateAdminStatus(AT_FRONTPAGELAYOUT, AS_EDITED))
	{
		return SetDNALastError("CMessageBoardAdmin", "UpdateAdminStatus()","Failed to update FrontPageLayout admin status.");
	}
	
	//do redirect
	sRedirect << "FrontPageLayout?s_updatelayout=yes&s_fromadmin=1";

	// create a cursory bit of XML
	if (!CreateFromXMLText("<TASKVIEWER>FRONTPAGELAYOUT</TASKVIEWER>"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::ViewChooseFrontPageTemplate(CTDVString& sRedirect)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::ViewChooseFrontPageTemplate(CTDVString& sRedirect)
{
	// Update for both layout and template stuff cos we handle them together now
	// update for the layout tool
	if(!UpdateAdminStatus(AT_FRONTPAGELAYOUT, AS_EDITED))
	{
		return SetDNALastError("CMessageBoardAdmin", "ViewChooseFrontPageTemplate()","Failed to update FrontPage template admin status.");
	}
	// update for template tool
	if(!UpdateAdminStatus(AT_FRONTPAGETEMPLATE, AS_EDITED))
	{
		return SetDNALastError("CMessageBoardAdmin", "ViewChooseFrontPageTemplate()","Failed to update FrontPage template admin status.");
	}
	
	//do redirect
	//sRedirect << "FrontPageLayout?s_updateHomepageTemplate=yes&s_fromadmin=1";
	sRedirect << "FrontPageLayout?s_updatelayout=yes&s_fromadmin=1";

	// create a cursory bit of XML
	if (!CreateFromXMLText("<TASKVIEWER>FRONTPAGETEMPLATE</TASKVIEWER>"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::ViewChooseTopicFrontPageElementTemplate(CTDVString& sRedirect)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::ViewChooseTopicFrontPageElementTemplate(CTDVString& sRedirect)
{

	if(!UpdateAdminStatus(AT_TOPICFRONTPAGEELEMENT, AS_EDITED))
	{
		return SetDNALastError("CMessageBoardAdmin", "ViewChooseTopicFrontPageElementTemplate()","Failed to update FrontPage Topic Element admin status.");
	}
	//do redirect
	sRedirect << "FrontPageLayout?s_updatetopictemplate=yes&s_fromadmin=1";
	
	// create a cursory bit of XML
	if (!CreateFromXMLText("<TASKVIEWER>TOPICFRONTPAGEELEMENT</TASKVIEWER>"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::ViewCreateTopics(CTDVString& sRedirect)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::ViewCreateTopics(CTDVString& sRedirect)
{

	if(!UpdateAdminStatus(AT_TOPICCREATION, AS_EDITED))
	{
		return SetDNALastError("CMessageBoardAdmin", "ViewCreateTopics", "Failed to update Create Topics admin status.");
	}

	//do redirect
	sRedirect << "TopicBuilder?s_fromadmin=1";

	// create a cursory bit of XML
	if (!CreateFromXMLText("<TASKVIEWER>TOPICCREATION</TASKVIEWER>"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::ViewCreateHomepageContent(CTDVString& sRedirect)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::ViewCreateHomepageContent(CTDVString& sRedirect)
{
	if(!UpdateAdminStatus(AT_HOMEPAGECONTENT, AS_EDITED))
	{

		return SetDNALastError("CMessageBoardAdmin", "ViewCreateHomepageContent", "Failed to updateTextBox Content admin status.");
	}
	//do redirect
	sRedirect << "FrontPageLayout?s_fromadmin=1";

	// create a cursory bit of XML
	if (!CreateFromXMLText("<TASKVIEWER>HOMEPAGECONTENT</TASKVIEWER>"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::ViewCreateBoardPromos(CTDVString& sRedirect)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::ViewCreateBoardPromos(CTDVString& sRedirect)
{
	if(!UpdateAdminStatus(AT_MESSAGEBOARDPROMOS, AS_EDITED))
	{
		return SetDNALastError("CMessageBoardAdmin", "ViewCreateBoardPromos", "Failed to update BoardPromos admin status.");
	}

	//do redirect
	sRedirect << "BoardPromos?s_fromadmin=1";

	// create a cursory bit of XML
	if (!CreateFromXMLText("<TASKVIEWER>MESSAGEBOARDPROMOS</TASKVIEWER>"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::ViewEditInstructionalText(CTDVString& sRedirect)

		Author:		Nick Stevenson
        Created:	01/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::ViewEditInstructionalText(CTDVString& sRedirect)
{
	if(!UpdateAdminStatus(AT_INSTRUCTIONALTEXT, AS_EDITED))
	{
		return SetDNALastError("CMessageBoardAdmin", "ViewEditInstructionalText", "Failed to update Instructional text admin status.");
	}

	//do redirect
	sRedirect << "SiteConfig?s_instructionaltext=1&s_fromadmin=1";

	// create a cursory bit of XML
	if (!CreateFromXMLText("<TASKVIEWER>INSTRUCTIONALTEXT</TASKVIEWER>"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::ViewDefineAssetLocations(CTDVString& sRedirect)

		Author:		Nick Stevenson
        Created:	01/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::ViewDefineAssetLocations(CTDVString& sRedirect)
{
	if(!UpdateAdminStatus(AT_ASSETLOCATIONS, AS_EDITED))
	{
		return SetDNALastError("CMessageBoardAdmin", "ViewDefineAssetLocations", "Failed to update Asset locations admin status.");
	}

	//do redirect
	sRedirect << "SiteConfig?s_assetlocations=1&s_fromadmin=1";

	// create a cursory bit of XML
	if (!CreateFromXMLText("<TASKVIEWER>ASSETLOCATIONS</TASKVIEWER>"))
	{
		return false;
	}

	return true;
}


/*********************************************************************************

	bool CMessageBoardAdmin::ViewManageAssets(CTDVString& sRedirect)

		Author:		Nick Stevenson
        Created:	15/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::ViewManageAssets(CTDVString& sRedirect)
{
	if(!UpdateAdminStatus(AT_MANAGEASSETS, AS_EDITED))
	{
		return SetDNALastError("CMessageBoardAdmin", "ViewManageAssets", "Failed to update manage-assets admin status.");
	}

	//do redirect
	sRedirect << "SiteConfig?s_manageassets=1&s_fromadmin=1";

	// create a cursory bit of XML
	if (!CreateFromXMLText("<TASKVIEWER>MANAGEASSETS</TASKVIEWER>"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::ViewConfigureSiteNavigation(CTDVString& sRedirect)

		Author:		Nick Stevenson
        Created:	01/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::ViewConfigureSiteNavigation(CTDVString& sRedirect)
{
	if(!UpdateAdminStatus(AT_SITENAVIGATION, AS_EDITED))
	{
		return SetDNALastError("CMessageBoardAdmin", "ViewConfigureSiteNavigation", "Failed to update site navigations admin status.");
	}

	//do redirect
	sRedirect << "SiteConfig?s_sitenavigation=1&s_fromadmin=1";

	// create a cursory bit of XML
	if (!CreateFromXMLText("<TASKVIEWER>SITENAVIGATION</TASKVIEWER>"))
	{
		return false;
	}

	return true;
}

bool CMessageBoardAdmin::ViewConfigureBoardFeatures(CTDVString& sRedirect)
{
	
	if(!UpdateAdminStatus(AT_BOARDFEATURES, AS_EDITED))
	{
		return SetDNALastError("CMessageBoardAdmin", "ViewConfigureBoardFeatures", "Failed to update board features admin status.");
	}

	//do redirect
	sRedirect << "SiteConfig?s_boardfeatures=1&s_fromadmin=1";

	// create a cursory bit of XML
	if (!CreateFromXMLText("<TASKVIEWER>BOARDFEATURES</TASKVIEWER>"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::ViewSetMessageBoardSchedule(CTDVString& sRedirect)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::ViewSetMessageBoardSchedule(CTDVString& sRedirect)
{
	if(!UpdateAdminStatus(AT_MESSAGEBOARDSCHEDULE, AS_EDITED))
	{
		return SetDNALastError("CMessageBoardAdmin", "ViewSetMessageBoardSchedule", "Failed to update Board schedule admin status.");
	}

	sRedirect << "MessageBoardSchedule?s_fromadmin=1";
	
	// create a cursory bit of XML
	if (!CreateFromXMLText("<TASKVIEWER>MESSAGEBOARDSCHEDULE</TASKVIEWER>"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CMessageBoardAdmin::UpdateAdminStatus(int iTask, int iStatus)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::UpdateAdminStatus(int iTask, int iStatus)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMessageBoardAdmin", "UpdateAdminStatus()","Failed to initialise SP.");
	}

	return SP.UpdateAdminStatus(m_InputContext.GetSiteID(), iTask, iStatus);
}

/*********************************************************************************

	bool CMessageBoardAdmin::UpdateEveryAdminStatusForSite(int iStatus)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::UpdateEveryAdminStatusForSite(int iStatus)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMessageBoardAdmin", "UpdateEveryAdminStatusForSite()","Failed to initialise SP.");
	}

	return SP.UpdateEveryAdminStatusForSite(m_InputContext.GetSiteID(), iStatus);
}

/*********************************************************************************

	bool CMessageBoardAdmin::HandleUpdateType(int iTypeID)

		Author:		Nick Stevenson
        Created:	10/03/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdmin::HandleUpdateType(int iTypeID)
{
	// assert that the value is acceptable
	TDVASSERT(iTypeID > 0, "CMessageBoardAdmin - iTypeID value must be greater than 0");

	if(!UpdateAdminStatus(iTypeID, AS_EDITED))
	{
		return SetDNALastError("CMessageBoardAdmin", "UpdateAdminStatus()","Failed to update FrontPageLayout admin status.");
	}
	return true;
}


/*********************************************************************************

	bool CMessageBoardAdmin::SetupTopicsForumOpeningAndClosingTimes(int iTypeID)

		Author:		DE
        Created:	23/05/2005
        Inputs:		-iTopicStatus - type of topics we are dealing with - most likely be live ones
						-iSiteID - the site id
        Outputs:	-None
        Returns:	-returns true if successful else false;
        Purpose:	-gets a list of Topics from the database, Iterates through this list and builds an array of Topic IDs and
						- then calls CForumSchedule::GenerateSchedulesIfNewForums passing in the array from step 2 and 
						- the site id as parameters. This will basically create the appropriate entries on the appropriate tables 
						- used for opening and closing times thing

*********************************************************************************/
bool CMessageBoardAdmin::SetupTopicsForumOpeningAndClosingTimes(  int iTopicStatus, int iSiteID )
{
	//get a list of topics
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CMessageBoardAdmin", "SetupTopicsForumOpeningAndClosingTimes()","Failed to initialise SP.");
	}

	// Now call the procedure
	if (!SP.GetTopicsForSiteID(iSiteID, iTopicStatus, false))
	{
		return SetDNALastError("CTopic::SetupTopicsForumOpeningAndClosingTimes","FailedToGetTopicsForSiteID","Failed to get topics for site");
	}

	CDNAIntArray listOfFourmsID;

	// Go go through the results and build a DWORDList of ForumID
	while (!SP.IsEOF())
	{
		//get forum id 
		int iThisForumID = SP.GetIntField("FORUMID");		

		bool bAlreadyInList = false;

		//search for this forum id if its not already i list then insert
		for(int iItem = 0; iItem < listOfFourmsID.GetSize( ); iItem++ )
		{
			int iTemp = listOfFourmsID.GetAt(iItem);
			if ( iThisForumID == iTemp)
			{
				bAlreadyInList = true;
				break;
			}
		}

		if ( bAlreadyInList == false)
		{
			listOfFourmsID.Add(iThisForumID);
		}
		
		// Now get the next result
		SP.MoveNext();
	}

	if ( listOfFourmsID.GetSize( ) )
	{
		CForumSchedule oForumSchedule(m_InputContext);
		return oForumSchedule.GenerateSchedulesIfNewForums (listOfFourmsID,iSiteID) ;
	}
	else
	{
		return true;
	}
}
