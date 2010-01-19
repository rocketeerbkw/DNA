#include "stdafx.h"
#include ".\tdvassert.h"
#include ".\FrontPageTopicElementbuilder.h"
#include ".\MultiStep.h"
#include ".\User.h"
#include ".\FrontPageLayout.h"
#include ".\Topic.h"
#include ".\SiteConfigPreview.h"

/*********************************************************************************

	CFrontPageTopicElementBuilder::CFrontPageTopicElementBuilder(CInputContext& inputContext)

		Author:		David E
        Created:	04/11/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

CFrontPageTopicElementBuilder::CFrontPageTopicElementBuilder(CInputContext& inputContext)
: 
CXMLBuilder(inputContext),
m_pWholePage(NULL),
m_FrontPageTopicElement(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CFrontPageTopicElementBuilder::~CFrontPageTopicElementBuilder(void)
{

}


/*********************************************************************************

	bool CFrontPageTopicElementBuilder::Build(CWholePage* pPage)

		Author:		David E
        Created:	04/11/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CFrontPageTopicElementBuilder::Build(CWholePage* pPage)
{	
	m_pWholePage = pPage;
	
	// Create and init the page
	bool bPageOk = true;
	bPageOk = InitPage(m_pWholePage, "FRONTPAGETOPICELEMENTBUILDER", false, false);
	if (!bPageOk)
	{
		TDVASSERT(false,"FrontPageTopicElementBuilder - Failed to create Whole Page object!");
		return false;
	}

	// Check to make sure we have a logged in user or editor
	CUser* pUser = m_InputContext.GetCurrentUser();

	//if unable to do so then report error 
	if (pUser == NULL)
	{
		// this operation requires a logged on user
		SetDNALastError("CFrontPageTopicElementBuilder::Build", "UserNotLoggedIn", "User Not Logged In");
		m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
		return true;
	}
	
	// Get the editor status, and check to make sure the current user matches the input or they are an editor!
	if (!pUser->GetIsEditor())
	{
		SetDNALastError("CFrontPageTopicElementBuilder::Build","UserNotAuthorised","User Is Not Authorised");
		m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
		return true;
	}

	// Get the current site id
	int iSiteID = m_InputContext.GetSiteID();

	//Get the editor
	int iEditorID = pUser->GetUserID();
	
	// Find out what page we're on		
	//determine if a page was specified	
	CTDVString sCurrentPage="";	
	m_InputContext.GetParamString("page",sCurrentPage);
	if (sCurrentPage.IsEmpty())
	{
		sCurrentPage = "frontpagetopicelementlist";
	}

	// Put the CurrentPage into the XML
	bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TOPICELEMENTPAGE page='" + sCurrentPage + "'></TOPICELEMENTPAGE>");

	// Now put the Preview SiteConfig into the page xml
	CTDVString sSiteConfig;
	CSiteConfigPreview SiteConfig(m_InputContext);
	if (SiteConfig.GetPreviewSiteConfig(sSiteConfig,iSiteID))
	{
		// Insert into the page
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/TOPICELEMENTPAGE",sSiteConfig);
	}

	// Put the frontpage layout info intot the page as this dictates how many topicboxes and sizes are allowed.
	CFrontPageLayout FPLayout(m_InputContext);
	CTDVString sFrontPageLayout;
	if (FPLayout.InitialisePageBody(iSiteID,true,true) && FPLayout.GetPageLayoutXML(sFrontPageLayout))
	{
		// add the object inside the FRONTPAGE element
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<FRONTPAGE></FRONTPAGE>");
		bPageOk = bPageOk && m_pWholePage->AddInside("FRONTPAGE", sFrontPageLayout);
	}
	else
	{
		// Set an error in the page
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",FPLayout.GetLastErrorAsXMLString());
	}

	// Determine if a valid cmd param was passed in 
	CTDVString sCmd;
	m_InputContext.GetParamString("cmd",sCmd);

	// Get the ElementId if we've been given one!
	int iElementID = m_InputContext.GetParamInt("elementid");

	// Now check to see if we're on the text and image page or that the action is to set the text and image.
	// If so, we need to set up the Multi step to parse the user input.
	CTDVString sTitle, sText, sImageName, sShowPosts, sImageAltText;
	int iTopicID = 0, iTemplate = 0, iElementLinkID = 0, iUseNoOfPost = 0;
	bool bUseRedirect = false;
	CMultiStep Multi(m_InputContext,"TEXTANDIMAGE");
	if (sCurrentPage.CompareText("createpage") || sCurrentPage.CompareText("editpage") || sCmd.CompareText("create") || sCmd.CompareText("edit"))
	{
		// Check to make sure the element id was given for the edit functionality, if not complain!
		if (iElementID == 0 && (sCurrentPage.CompareText("editpage") || sCmd.CompareText("edit")))
		{
			// Problems! We need an element ID to work on!
			SetDNALastError("CFrontPageTopicElementBuilder::Build","InvalidElementIDToEdit","Invalid ElementID Given To Edit");
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
			sCurrentPage = "editpage";
			sCmd.Empty();
		}
		else
		{
			// If we're editing, get the current values for the topic element
			if (iElementID > 0)
			{
				// Setup the multistep and get the required values
				m_FrontPageTopicElement.GetTopicFrontPageElementText(sText,iElementID);
				m_FrontPageTopicElement.GetTopicFrontPageElementTitle(sTitle,iElementID);
				m_FrontPageTopicElement.GetTopicFrontPageElementImageName(sImageName,iElementID);
				m_FrontPageTopicElement.GetTopicFrontPageElementTopicID(iTopicID,iElementID);
				m_FrontPageTopicElement.GetTopicFrontPageElementTemplateType(iTemplate,iElementID);
				m_FrontPageTopicElement.GetTopicFrontPageElementImageAltText(sImageAltText,iElementID);
/*
				// No longer used !!!
				m_FrontPageTopicElement.GetTopicFrontPageElementUseNoOfPosts(iUseNoOfPost,iElementID);
*/
			}
			else
			{
				// We must have a topicid param, even if it's zero!!!
				if (!m_InputContext.ParamExists("topicid"))
				{
					// Problems! We need an element ID to work on!
					SetDNALastError("CFrontPageTopicElementBuilder::Build","NoTopicIDGiven","No TopicID Given!");
					bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
					sCurrentPage = "createpage";
					sCmd.Empty();
				}
				else
				{
					// Get the topcid value
					iTopicID = m_InputContext.GetParamInt("topicid");
				}
			}

			// Add the values to the multistep
			Multi.AddRequiredParam("title",sTitle);
			Multi.AddRequiredParam("text",sText);
			Multi.AddRequiredParam("imagename",sImageName);
			Multi.AddRequiredParam("imagealttext",sImageAltText);
			Multi.AddRequiredParam("templatetype",CTDVString(iTemplate));
/*
			// Not used any more!!!
			Multi.AddRequiredParam("showposts",CTDVString(iUseNoOfPost));
*/

			// Process the inputs to make sure we've got all the info we require
			if (!Multi.ProcessInput())
			{
				SetDNALastError("CFrontPageTopicElementBuilder::Build","InvalidParamsInMultiStep","Invalid Params in MultiStep");
				bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
				if (sCmd.CompareText("create"))
				{
					sCurrentPage = "createpage";
				}
				else if (sCmd.CompareText("edit"))
				{
					sCurrentPage = "editpage";
				}
				sCmd.Empty();
			}

			// Add the multistep into the page
			CTDVString sXML;
			Multi.GetAsXML(sXML);
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/TOPICELEMENTPAGE",sXML);
		}
	}

	// See if we're trying to complete a command, if so, get the values and do the action
	if (sCmd.CompareText("create") || sCmd.CompareText("edit") || sCmd.CompareText("delete"))
	{	
		// Figure out which command we're trying to do.		
		if (sCmd.CompareText("create"))
		{													
			Multi.GetRequiredValue("title",sTitle);
			Multi.GetRequiredValue("text",sText);
			Multi.GetRequiredValue("imagename",sImageName);
			Multi.GetRequiredValue("imagealttext",sImageAltText);
			Multi.GetRequiredValue("templatetype",iTemplate);
/*
			// Not used anymore!!!
			Multi.GetRequiredValue("showposts",sShowPosts);
*/

			// See if we're ready to use
			if (Multi.ReadyToUse())
			{
				// Now commit the changes to the database
				if (!m_FrontPageTopicElement.CreateTopicFrontPageElement(iElementID, iSiteID, iEditorID, CFrontPageElement::ES_PREVIEW, iElementLinkID, iTopicID, sShowPosts.CompareText("on"), sText, sImageName, iTemplate, sTitle, sImageAltText))
				{	
					// get the error if creatioh fails, and make sure we list the topics
					bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",m_FrontPageTopicElement.GetLastErrorAsXMLString());
					sCurrentPage = "createpage";
				}
				else
				{
					bUseRedirect = true;
				}
			}
			else
			{
				// not yet! make sure we stay on this page untill we are!
				sCurrentPage = "createpage";

				// Check to see if we've been cancelled as this means we want a preview!
				if (Multi.IsCancelled() && m_FrontPageTopicElement.EditTopicFrontPageElement(iElementID, iEditorID, CFrontPageElement::ES_PREVIEW, sShowPosts.CompareText("on"), sText, sImageName, iTemplate, NULL, sTitle, sImageAltText, false))
				{
					// Get the preview for the Topic Element
					if (m_FrontPageTopicElement.CreateXMLForCurrentState())
					{
						// Add the XML to the Page
						bPageOk = bPageOk && m_pWholePage->AddInside("TOPICELEMENTPAGE","<TOPICELEMENT-PREVIEW></TOPICELEMENT-PREVIEW>");
						bPageOk = bPageOk && m_pWholePage->AddInside("TOPICELEMENT-PREVIEW",&m_FrontPageTopicElement);
					}
					else
					{
						// Get the error from the object
						bPageOk = bPageOk && m_pWholePage->AddInside("TOPICELEMENT-PREVIEW",m_FrontPageTopicElement.GetLastErrorAsXMLString());
					}
				}
			}
		}
		else if (sCmd.CompareText("edit"))
		{
			// Get the EditKey from the URL
			CTDVString sEditKey;
			m_InputContext.GetParamString("editkey",sEditKey);

			// Get the values from the multi step
			Multi.GetRequiredValue("title",sTitle);
			Multi.GetRequiredValue("text",sText);
			Multi.GetRequiredValue("imagename",sImageName);
			Multi.GetRequiredValue("imagealttext",sImageAltText);
			Multi.GetRequiredValue("templatetype",iTemplate);
/*
			// Not used any more!!!
			Multi.GetRequiredValue("showposts",sShowPosts);
*/

			// See if we're ready to use
			if (Multi.ReadyToUse())
			{
				// Now commit the changes to the database
				if (!m_FrontPageTopicElement.EditTopicFrontPageElement( iElementID, iEditorID, CFrontPageElement::ES_PREVIEW, sShowPosts.CompareText("on"), sText, sImageName, iTemplate, sEditKey, sTitle, sImageAltText))
				{	
					// get the error if creatioh fails, and make sure we list the topics
					bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",m_FrontPageTopicElement.GetLastErrorAsXMLString());
					sCurrentPage = "editpage";
				}
				else
				{
					bUseRedirect = true;
				}
				
				// Now insert the action xml from the object
				bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",&m_FrontPageTopicElement);
			}
			else
			{
				// not yet! make sure we stay on this page untill we are!
				sCurrentPage = "editpage";

				// Check to see if we've been cancelled as this means we want a preview!
				if (Multi.IsCancelled() && m_FrontPageTopicElement.EditTopicFrontPageElement(iElementID, iEditorID, CFrontPageElement::ES_PREVIEW, sShowPosts.CompareText("on"), sText, sImageName, iTemplate, sEditKey, sTitle, sImageAltText, false))
				{
					// Get the preview for the Topic Element
					if (m_FrontPageTopicElement.CreateXMLForCurrentState())
					{
						// Add the XML to the Page
						bPageOk = bPageOk && m_pWholePage->AddInside("TOPICELEMENTPAGE","<TOPICELEMENT-PREVIEW></TOPICELEMENT-PREVIEW>");
						bPageOk = bPageOk && m_pWholePage->AddInside("TOPICELEMENT-PREVIEW",&m_FrontPageTopicElement);
					}
					else
					{
						// Get the error from the object
						bPageOk = bPageOk && m_pWholePage->AddInside("TOPICELEMENT-PREVIEW",m_FrontPageTopicElement.GetLastErrorAsXMLString());
					}
				}
			}
		}							
		else if (sCmd.CompareText("delete"))
		{
			//now return current Topic FrontPage Element details
			if (!m_FrontPageTopicElement.DeleteTopicFrontPageElement(iElementID,iEditorID))
			{
				// get the error from the textbox object
				bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",m_FrontPageTopicElement.GetLastErrorAsXMLString());
			}
			else
			{
				bUseRedirect = true;
			}
		}
	}		

	// Check to see if we're ok, and if we're needing to do a redirect!
	if (bPageOk && bUseRedirect)
	{
		// Call the redirect function
		if (CheckAndUseRedirectIfGiven(m_pWholePage))
		{
			// we've had a valid redirect! return
			return true;
		}
	}

	// Make sure we set the correct page
	bPageOk = bPageOk && m_pWholePage->SetAttribute("TOPICELEMENTPAGE","PAGE",sCurrentPage);

	if (sCurrentPage.CompareText("createpage"))
	{
		// Insert the TopicID that the element represents
		CTDVString sXML;
		CDBXMLBuilder XMLBuilder;
		XMLBuilder.Initialise(&sXML);
		XMLBuilder.OpenTag("TOPIC");
		XMLBuilder.OpenTag("TOPICID");
		XMLBuilder.CloseTag("TOPICID",(CTDVString)iTopicID);
		XMLBuilder.CloseTag("TOPIC");		

		//now return xml
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/TOPICELEMENTPAGE", sXML);
	}
	else
	{
		//now page given hence return Frontpage Topic element list  for site
		if (!m_FrontPageTopicElement.GetTopicFrontPageElementsForSiteID(iSiteID,CFrontPageElement::ES_PREVIEW,iElementID))
		{
			// get the error from the textbox object
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",m_FrontPageTopicElement.GetLastErrorAsXMLString());
		}
		else
		{
			//now return xml
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/TOPICELEMENTPAGE",&m_FrontPageTopicElement);
		}
	}

	// Insert the Preview Topics list
	CTopic Topic(m_InputContext);
	if (Topic.GetTopicsForSiteID(m_InputContext.GetSiteID(),CTopic::TS_PREVIEW))
	{
		// Add the list to the page
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/TOPICELEMENTPAGE",&Topic);
	}
	else
	{
		// Insert the error!
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/TOPICELEMENTPAGE",Topic.GetLastErrorAsXMLString());
	}

	// Return the verdict!
	return bPageOk;
}
