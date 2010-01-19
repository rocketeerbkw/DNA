#include "stdafx.h"
#include ".\textboxelementbuilder.h"
#include ".\textboxelement.h"
#include ".\tdvassert.h"
#include ".\User.h"
#include ".\MultiStep.h"
#include ".\FrontPageLayout.h"
#include ".\SiteConfigPreview.h"
#include "EditorsPick.h"
#include "ThreadSearchPhrase.h"

CTextBoxElementBuilder::CTextBoxElementBuilder(CInputContext& inputContext) :
									CXMLBuilder(inputContext), m_pWholePage(NULL)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CTextBoxElementBuilder::~CTextBoxElementBuilder(void)
{
}

/*********************************************************************************

	bool CTextBoxElementBuilder::Build(CWholePage* pPage)

		Author:		Mark Howitt
        Created:	01/11/2004
        Inputs:		pPage - a pointer to the page object that will take the new XML
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Builds the TextBox page from the params in the URL.

		URL Params:	Page - The current page we're displaying.
					NextPage - The name of the next page we want to go to.

*********************************************************************************/
bool CTextBoxElementBuilder::Build(CWholePage* pPage)
{
	// Set the page member to the passed in page.
	m_pWholePage = pPage;

	// Create and init the page
	bool bPageOk = true;
	bPageOk = InitPage(m_pWholePage, "TEXTBOXELEMENTPAGE",false,true);
	if (!bPageOk)
	{
		TDVASSERT(false,"EMailAlertBuilder - Failed to create Whole Page object!");
		return false;
	}

	// Get the status for the current user. Only editors are allowed to use this page.
	CUser* pUser = m_InputContext.GetCurrentUser();
	if (pUser == NULL || (!pUser->GetIsEditor() && !pUser->GetIsSuperuser()))
	{
		SetDNALastError("CTextBoxElementBuilder::Build","UserNotLoggedInOrNotAuthorised","User Not Logged In Or Authorised");
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
		return bPageOk;
	}

	// Get editor. 
	int iEditorID = pUser->GetUserID();

	// Get the site id from the input context
	int iSiteID = m_InputContext.GetSiteID();

	// See what page we are wanting to display
	CTDVString sPage = "textboxlist";
	if (m_InputContext.ParamExists("page"))
	{
		// Get the value
		m_InputContext.GetParamString("Page",sPage);
		sPage.MakeLower();
	}

	// Put the CurrentPage into the XML
	bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TEXTBOXPAGE PAGE='" + sPage + "'></TEXTBOXPAGE>");
	
	// Now put the Preview SiteConfig into the page xml
	CTDVString sSiteConfig;
	CSiteConfigPreview SiteConfig(m_InputContext);
	if (SiteConfig.GetPreviewSiteConfig(sSiteConfig,iSiteID))
	{
		// Insert into the page
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/TEXTBOXPAGE",sSiteConfig);
	}

	// Put the frontpage layout info intot the page as this dictates how many textboxes and sizes are allowed.
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

	// Setup a TextBox object
	CTextBoxElement TextBox(m_InputContext);

	// Check to see if we have been given a specific TextBoxID
	if (!m_InputContext.ParamExists("TextBoxID"))
	{
		// Get all the text boxes for the given site
		if (TextBox.GetTextBoxesForSiteID(iSiteID,CFrontPageElement::ES_PREVIEW))
		{
			// Insert the list into the page
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/TEXTBOXPAGE",&TextBox);

			// Put the CurrentPage into the XML
			bPageOk = bPageOk && m_pWholePage->SetAttribute("TEXTBOXPAGE","PAGE","textboxlist");
		}
		else
		{
			// get the error from the textbox object
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",TextBox.GetLastErrorAsXMLString());
		}
		return bPageOk;
	}

	// Get the TextBox ID and check for 0. If 0 then we're wanting to create a new textbox!
	bool bOk = true;
	int iTextBoxID = m_InputContext.GetParamInt("TextBoxID");
	if (iTextBoxID == 0)
	{
		// Get the new position for the new textbox
		int iFrontPagePos = m_InputContext.GetParamInt("FrontPagePosition");

		// Create a new TextBox Element.
		bOk = TextBox.CreateNewTextBox(iSiteID,iTextBoxID,iFrontPagePos);
		bPageOk = bPageOk && AddActionXMLResult(bOk,"create",iTextBoxID,&TextBox);
	}

	// Get the action if any
	CTDVString sAction;
	m_InputContext.GetParamString("action",sAction);

	// Now check to see if we're on the text and image page or that the action is to set the text and image.
	// If so, we need to set up the Multi step to parse the user input.
	CTDVString sTitle, sText, sImageName, sImageAltText;
	int iImageWidth = 0, iImageHeight = 0;
	CMultiStep Multi(m_InputContext,"TEXTANDIMAGE");
	if (sPage.CompareText("textandimage") || sAction.CompareText("textandimage") )
	{
		// Setup the multistep and get the required values
		TextBox.GetTextBoxText(sText,iTextBoxID);
		TextBox.GetTextBoxTitle(sTitle,iTextBoxID);
		TextBox.GetTextBoxImageName(sImageName,iTextBoxID);
		TextBox.GetTextBoxImageWidth(iImageWidth,iTextBoxID);
		TextBox.GetTextBoxImageHeight(iImageHeight,iTextBoxID);
		TextBox.GetTextBoxImageAltText(sImageAltText,iTextBoxID);

		Multi.AddRequiredParam("title",sTitle);
		Multi.AddRequiredParam("text",sText);
		Multi.AddRequiredParam("imagename",sImageName);
		Multi.AddRequiredParam("imagewidth",CTDVString(iImageWidth));
		Multi.AddRequiredParam("imageheight",CTDVString(iImageHeight));
		Multi.AddRequiredParam("imagealttext",sImageAltText);

		// Process the inputs to make sure we've got all the info we require
		if (!Multi.ProcessInput())
		{
			SetDNALastError("CTextBoxElementBuilder::Build","InvalidParamsInMultiStep","Invalid Params in MultiStep");
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
		}

		CTDVString sXML;
		Multi.GetAsXML(sXML);
		m_pWholePage->AddInside("H2G2/TEXTBOXPAGE",sXML);
	}

	// Add Editors Pick XML if requested.
	if (sPage.CompareText("editorspick") || sAction.CompareText("editorspick") )
	{
		//Get existing TextBox details
		TextBox.GetTextBoxText(sText,iTextBoxID);
		TextBox.GetTextBoxTitle(sTitle,iTextBoxID);

		//Setup MultiStep for editors pick page/processing.
		Multi.AddRequiredParam("title", sTitle);
		Multi.AddRequiredParam("text", sText);
		if (!Multi.ProcessInput())
		{
			SetDNALastError("CTextBoxElementBuilder::Build","InvalidParamsInMultiStep","Invalid Params in MultiStep");
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
		}

		//Add XML for Editors Pick Page.
		CTDVString sXML;
		Multi.GetAsXML(sXML);
		m_pWholePage->AddInside("H2G2/TEXTBOXPAGE",sXML);

		//Generate XML for Editor's pick.
		CEditorsPick EditorsPick(m_InputContext);
		EditorsPick.Initialise(iTextBoxID);
		m_pWholePage->AddInside("H2G2/TEXTBOXPAGE",&EditorsPick);
	}

	// If an action is given, find out what it is
	bool bDoRedirect = true;
	if (!sAction.IsEmpty())
	{
		// Get the EditKey from the URL
		CTDVString sEditKey;
		m_InputContext.GetParamString("editkey",sEditKey);

		// Now find out which page we're on
		if (sAction.CompareText("choosetype"))
		{
			// Get the values from the URL
			if (m_InputContext.ParamExists("type"))
			{
				int iTextBoxType = m_InputContext.GetParamInt("type");
				bOk = TextBox.SetTextBoxType(iTextBoxID,iTextBoxType,true,iEditorID, sEditKey);
				bPageOk = bPageOk && AddActionXMLResult(bOk,"choosetype",iTextBoxID,&TextBox);
			}
		}
		else if (sAction.CompareText("choosetemplate"))
		{
			// Get the values from the URL
			if (m_InputContext.ParamExists("template"))
			{
				int iTemplate = m_InputContext.GetParamInt("template");
				bOk = TextBox.SetTemplateType(iTextBoxID,iTemplate,true,iEditorID, sEditKey);
				bPageOk = bPageOk && AddActionXMLResult(bOk,"choosetemplate",iTextBoxID,&TextBox);
			}
		}
		else if (sAction.CompareText("textandimage"))
		{
			// Get the values from the multi step object
			Multi.GetRequiredValue("title",sTitle);
			Multi.GetRequiredValue("text",sText);
			Multi.GetRequiredValue("imagename",sImageName);
			Multi.GetRequiredValue("imageWidth",iImageWidth);
			Multi.GetRequiredValue("imageheight",iImageHeight);
			Multi.GetRequiredValue("imagealttext",sImageAltText);

			// Set the textbox new values
			bOk = bOk && TextBox.SetTitle(iTextBoxID,sTitle,false,iEditorID,sEditKey);
			bOk = bOk && TextBox.SetText(iTextBoxID,sText,false,iEditorID,sEditKey);
			bOk = bOk && TextBox.SetImageName(iTextBoxID,sImageName,false,iEditorID,sEditKey);
			bOk = bOk && TextBox.SetImageWidth(iTextBoxID,iImageWidth,false,iEditorID,sEditKey);
			bOk = bOk && TextBox.SetImageHeight(iTextBoxID,iImageHeight,false,iEditorID,sEditKey);
			bOk = bOk && TextBox.SetImageAltText(iTextBoxID,sImageAltText,false,iEditorID,sEditKey);

			// See if we're ready to use
			if (Multi.ReadyToUse())
			{
				// Now commit the changes to the database
				bOk = bOk && TextBox.CommitTextBoxChanges(iEditorID,sEditKey);
				bPageOk = bPageOk && AddActionXMLResult(bOk,"setvalues",iTextBoxID,&TextBox);
			}
			else
			{
				// not yet! make sure we stay on this page untill we are!
				bPageOk = bPageOk && m_pWholePage->SetAttribute("TEXTBOXPAGE","PAGE","textandimage");
				sPage = "textandimage";
				bDoRedirect = false;

				// Check to see if we've been cancelled as this means we want a preview!
				if (Multi.IsCancelled())
				{
					// Get the preview for the TextBox
					if (TextBox.CreateXMLForCurrentState())
					{
						// Add the XML to the Page
						bPageOk = bPageOk && m_pWholePage->AddInside("TEXTBOXPAGE","<TEXTBOX-PREVIEW></TEXTBOX-PREVIEW>");
						bPageOk = bPageOk && m_pWholePage->AddInside("TEXTBOX-PREVIEW",&TextBox);
					}
					else
					{
						// Get the error from the object
						bPageOk = bPageOk && m_pWholePage->AddInside("TEXTBOX-PREVIEW",TextBox.GetLastErrorAsXMLString());
					}
				}
			}
		}
		else if (sAction.CompareText("editorspick")  )
		{
			if ( Multi.ReadyToUse() )
			{
				//Save TextBox.
				Multi.GetRequiredValue("title",sTitle);
				Multi.GetRequiredValue("text",sText);
				TextBox.SetTitle(iTextBoxID,sTitle,false,iEditorID,sEditKey);
				TextBox.SetText(iTextBoxID,sText,false,iEditorID,sEditKey);
				bOk = bOk && TextBox.CommitTextBoxChanges(iEditorID,sEditKey);
					
				//Save Editors Picks/Links for this text box.
				CEditorsPick EditorsPick(m_InputContext);
				bOk = bOk && EditorsPick.Process(iTextBoxID);
				bPageOk = bPageOk && AddActionXMLResult(bOk,"editorspick",iTextBoxID,&TextBox);
			}
			else
			{
				bPageOk = bPageOk && m_pWholePage->SetAttribute("TEXTBOXPAGE","PAGE","editorspick");
				sPage = "editorspick";
				bDoRedirect = false;
			}
		}
		else if ( sAction.CompareText("choosekeyphrases") ) 
		{
			CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
			CThreadSearchPhrase tsp(m_InputContext,delimit);
			if ( m_InputContext.ParamExists("phrases",' ') )
			{
				CTDVString sPhrases, sPhraseParam;
				for (int i=0;m_InputContext.GetParamString("phrases",sPhraseParam,i);i++)
					tsp.ParsePhrases(sPhraseParam,true);

				bOk = bOk && TextBox.SetKeyPhrases(iTextBoxID, tsp.GetPhraseList() );
				bPageOk = bPageOk && AddActionXMLResult(bOk, "keyphrases", iTextBoxID, &TextBox );
			}
		}
		else if (sAction.CompareText("choosednatype"))
		{
			// Get the values from the URL
			if (m_InputContext.ParamExists("TextBoxType"))
			{
				int iTextBoxType = m_InputContext.GetParamInt("textboxtype");
				bOk = TextBox.SetTextBoxType(iTextBoxID,iTextBoxID, true, iEditorID,sEditKey);
				bPageOk = bPageOk && AddActionXMLResult(bOk,"textboxtype",iTextBoxID,&TextBox);
			}
		}
		else if (sAction.CompareText("makeactive"))
		{
			// Try to make the preview boxes active
			bOk = TextBox.MakePreviewTextBoxesActive(iSiteID,iTextBoxID);
			bPageOk = bPageOk && AddActionXMLResult(bOk,"makeactive",iTextBoxID,&TextBox);
		}
		else if (sAction.CompareText("delete"))
		{
			// Try to delete the given textbox
			bOk = TextBox.DeleteTextBox(iTextBoxID, iEditorID);
			bPageOk = bPageOk && AddActionXMLResult(bOk,"delete",iTextBoxID,&TextBox);

			// Get all the text boxes for the given site
			if (TextBox.GetTextBoxesForSiteID(iSiteID,CFrontPageElement::ES_PREVIEW))
			{
				// Insert the list into the page
				bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/TEXTBOXPAGE",&TextBox);

				// Put the CurrentPage into the XML
				bPageOk = bPageOk && m_pWholePage->SetAttribute("TEXTBOXPAGE","PAGE","textboxlist");
			}
			else
			{
				// get the error from the textbox object
				bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",TextBox.GetLastErrorAsXMLString());
			}
			return true;
		}
		else
		{
			// Don't know what Action they want!
			SetDNALastError("CTextBoxElementBuilder::Build","UnkownActiongiven","Unknown Action given");
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
		}
	}

	// Check to see if we're ok and if we are given a redirect?
	if (bPageOk && bOk && bDoRedirect)
	{
		// Call the redirect function
		if (CheckAndUseRedirectIfGiven(m_pWholePage))
		{
			// we've had a valid redirect! return
			return true;
		}
	}

	// Get all the text boxes for the given site
	if (TextBox.GetTextBoxesForSiteID(iSiteID,CFrontPageElement::ES_PREVIEW,iTextBoxID))
	{
		// Insert the list into the page
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/TEXTBOXPAGE",&TextBox);
	}
	else
	{
		// get the error from the textbox object
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/TEXTBOXPAGE",TextBox.GetLastErrorAsXMLString());
	}

	// return ok!
	return bPageOk;
}

/*********************************************************************************

	bool CTextBoxElementBuilder::AddActionXMLResult(bool bActionOk, const TDVCHAR* psActionName, int iTextBoxID, CTextBoxElement* pTextBox)

		Author:		Mark Howitt
        Created:	08/11/2004
        Inputs:		bActionOk - A flag that states whether or not the action worked.
					psActionName - The name of the action that was just used.
					iTextBoxID - The id of the textbox that the action was used on.
					pTextBox - A pointer to the textbox object that did the action.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Helper function for setting the last errors and action XML.

*********************************************************************************/
bool CTextBoxElementBuilder::AddActionXMLResult(bool bActionOk, const TDVCHAR* psActionName, int iTextBoxID, CTextBoxElement* pTextBox)
{
	// Add the result to the xml 
	bool bOk = true;
	CTDVString sResultXML;
	sResultXML << "<ACTION TYPE='" << psActionName << "' TEXTBOXID='" << iTextBoxID << "' RESULT='";
	if (bActionOk)
	{
		sResultXML << "OK'>";
	}
	else
	{
		sResultXML << "FAILED'>";

		// Insert the error from the textbox if we're given one!
		if (pTextBox != NULL)
		{
			// Insert the text box error into the page
			bOk = m_pWholePage->AddInside("H2G2",pTextBox->GetLastErrorAsXMLString());
		}
	}
	sResultXML << "</ACTION>";

	// Put the string into the page
	bOk = bOk && m_pWholePage->AddInside("H2G2/TEXTBOXPAGE",sResultXML);
	return bOk;
}