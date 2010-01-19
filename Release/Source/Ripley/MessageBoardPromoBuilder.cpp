#include "stdafx.h"
#include ".\messageboardpromobuilder.h"
#include ".\User.h"
#include ".\tdvassert.h"
#include ".\MultiStep.h"
#include ".\FrontPageLayout.h"
#include ".\Topic.h"
#include ".\SiteConfigPreview.h"
#include ".\ThreadSearchPhrase.h"

CMessageBoardPromoBuilder::CMessageBoardPromoBuilder(CInputContext& InputContext) : CXMLBuilder(InputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CMessageBoardPromoBuilder::~CMessageBoardPromoBuilder(void)
{
}

/*********************************************************************************

	bool CMessageBoardPromoBuilder::Build(CWholePage* pPage)

		Author:		Mark Howitt
        Created:	01/12/2004
        Inputs:		pPage - The page that will take the XML
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Creates the MessageBoardPromo page that allowes the user
					to create and manage the promos that belong to a given site.

*********************************************************************************/
bool CMessageBoardPromoBuilder::Build(CWholePage* pPage)
{
	// Set the page member to the passed in page.
	m_pWholePage = pPage;

	// Create and init the page
	bool bPageOk = true;
	bPageOk = InitPage(m_pWholePage, "MESSAGEBOARDPROMOPAGE",false,true);
	if (!bPageOk)
	{
		TDVASSERT(false,"CMessageBoardPromoBuilder - Failed to create Whole Page object!");
		return false;
	}

	// Get the status for the current user. Only editors are allowed to use this page.
	CUser* pUser = m_InputContext.GetCurrentUser();
	if (pUser == NULL || (!pUser->GetIsEditor() && !pUser->GetIsSuperuser()))
	{
		SetDNALastError("CMessageBoardPromoBuilder::Build","UserNotLoggedInOrNotAuthorised","User Not Logged In Or Authorised");
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
		return bPageOk;
	}

	// Get the users id
	int iUserID = pUser->GetUserID();

	// Get the site id from the input context
	int iSiteID = m_InputContext.GetSiteID();

	// See what page we are wanting to display
	CTDVString sPage = "boardpromolist";
	if (m_InputContext.ParamExists("page"))
	{
		// Get the value
		m_InputContext.GetParamString("Page",sPage);
		sPage.MakeLower();
	}

	// Put the CurrentPage into the XML
	bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<BOARDPROMOPAGE PAGE='" + sPage + "'></BOARDPROMOPAGE>");
	
	// Now put the Preview SiteConfig into the page xml
	CTDVString sSiteConfig;
	CSiteConfigPreview SiteConfig(m_InputContext);
	if (SiteConfig.GetPreviewSiteConfig(sSiteConfig,iSiteID))
	{
		// Insert into the page
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/BOARDPROMOPAGE",sSiteConfig);
	}

	// Put the frontpage layout info intot the page as this dictates how many textboxes and sizes are allowed.
	CFrontPageLayout FPLayout(m_InputContext);
	CTDVString sFrontPageLayout;
	if (FPLayout.InitialisePageBody(iSiteID,true,true) && FPLayout.GetPageLayoutXML(sFrontPageLayout))
	{
		// Insert the info as XML
		// generate the FRONTPAGE element
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2", "<FRONTPAGE/>");
		// add the object inside the FRONTPAGE element
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<FRONTPAGE></FRONTPAGE>");
		bPageOk = bPageOk && m_pWholePage->AddInside("FRONTPAGE", sFrontPageLayout);
	}
	else
	{
		// Set an error in the page
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",FPLayout.GetLastErrorAsXMLString());

	}

	// Setup a BoardPromo object
	CMessageBoardPromo BoardPromo(m_InputContext);

	// Get the action if any
	CTDVString sAction;
	m_InputContext.GetParamString("action",sAction);

	// Get the Default BoardPromo if we're passed it
	int iDefaultPromoID = -1;
	if (m_InputContext.ParamExists("defaultpromoid"))
	{
		iDefaultPromoID = m_InputContext.GetParamInt("defaultpromoid");
	}

	// Check to see if we have been given a specific BoardPromoID
	if (!m_InputContext.ParamExists("PromoID") && iDefaultPromoID < 0)
	{
		// Get all the boardPromos for the given site
		if (BoardPromo.GetBoardPromosForSite(iSiteID,CFrontPageElement::ES_PREVIEW))
		{
			// Insert the list into the page
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/BOARDPROMOPAGE",&BoardPromo);

			// Put the CurrentPage into the XML
			bPageOk = bPageOk && m_pWholePage->SetAttribute("BOARDPROMOPAGE","PAGE","boardpromolist");
		}
		else
		{
			// get the error from the BoardPromo object
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",BoardPromo.GetLastErrorAsXMLString());
		}

		// Get the list of topics for the site
		CTopic Topic(m_InputContext);
		if (Topic.GetTopicsForSiteID(iSiteID,CTopic::TS_PREVIEW))
		{
			// Insert the list into the page
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/BOARDPROMOPAGE",&Topic);
		}
		else
		{
			// get the error from the Topic object
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/BOARDPROMOPAGE",Topic.GetLastErrorAsXMLString());
		}

		return bPageOk;
	}

	// Get the BoardPromo ID and check for 0. If 0 then we're wanting to create a new BoardPromo!
	bool bOk = true;
	int iPromoID = m_InputContext.GetParamInt("PromoID");
	if (iPromoID == 0)
	{
		// Check to see if we're updating the default board promo
		if (iDefaultPromoID >= 0)
		{
			// Set the PromoID to the Default Promo
			iPromoID = iDefaultPromoID;
		}
		else
		{
			// Create a new BoardPromo Element.
			bOk = BoardPromo.CreateNewBoardPromo(iSiteID,iUserID,iPromoID);
			bPageOk = bPageOk && AddActionXMLResult(bOk,"create",iPromoID,&BoardPromo);
		}
	}

	// Now check to see if we're on the text and image page or that the action is to set the text and image.
	// If so, we need to set up the Multi step to parse the user input.
	CTDVString sTitle, sText, sImageName, sImageAltText;
	int iImageWidth = 0, iImageHeight = 0;
	CMultiStep Multi(m_InputContext,"TEXTANDIMAGE");
	if (sPage.CompareText("textandimage") || sAction.CompareText("textandimage"))
	{
		// Setup the multistep and get the required values
		BoardPromo.GetBoardPromoText(sText,iPromoID);
		BoardPromo.GetBoardPromoTitle(sTitle,iPromoID);
		BoardPromo.GetBoardPromoImageName(sImageName,iPromoID);
		BoardPromo.GetBoardPromoImageWidth(iImageWidth,iPromoID);
		BoardPromo.GetBoardPromoImageHeight(iImageHeight,iPromoID);
		BoardPromo.GetBoardPromoImageAltText(sImageAltText,iPromoID);

		Multi.AddRequiredParam("title",sTitle);
		Multi.AddRequiredParam("text",sText);
		Multi.AddRequiredParam("imagename",sImageName);
		Multi.AddRequiredParam("imagewidth",CTDVString(iImageWidth));
		Multi.AddRequiredParam("imageheight",CTDVString(iImageHeight));
		Multi.AddRequiredParam("imagealttext",sImageAltText);

		// Process the inputs to make sure we've got all the info we require
		if (!Multi.ProcessInput())
		{
			SetDNALastError("CMessageBoardPromoBuilder::Build","InvalidParamsInMultiStep","Invalid Params in MultiStep");
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
		}

		CTDVString sXML;
		Multi.GetAsXML(sXML);
		m_pWholePage->AddInside("H2G2/BOARDPROMOPAGE",sXML);
	}

	// If an action is given, find out what it is
	bool bUseRedirect = false;
	if (!sAction.IsEmpty())
	{
		// Get the EditKey from the URL
		CTDVString sEditKey;
		m_InputContext.GetParamString("editkey",sEditKey);
	

		// Now find out which page we're on
		if (sAction.CompareText("setname"))
		{
			// Get the boardpromo name from the URL
			if (m_InputContext.ParamExists("promoname"))
			{
				CTDVString sPromoName;
				m_InputContext.GetParamString("promoname",sPromoName);
				bOk = bOk && BoardPromo.SetBoardPromoName(iPromoID,sPromoName,sEditKey);
				bPageOk = bPageOk && AddActionXMLResult(bOk,"setname",iPromoID,&BoardPromo);
				bUseRedirect = bOk;
				if (!bOk)
				{
					bPageOk = bPageOk && m_pWholePage->SetAttribute("BOARDPROMOPAGE","PAGE","promoname");
				}
			}

			//Set Tags / Keyphrases associated with Promo.
			if ( m_InputContext.ParamExists("phrases") )
			{
				CTDVString sPhrases, sPhraseParam;
				CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
				CThreadSearchPhrase phrases(m_InputContext,delimit);
				for (int i=0;m_InputContext.GetParamString("phrases",sPhraseParam,i);i++)
					phrases.ParsePhrases(sPhraseParam,true);

				//Is board promo to be use as a default KeyPhraseBoardPromo.
				bool bdefault = (iDefaultPromoID == iPromoID) || (m_InputContext.ParamExists("defaultpromo") );
				bOk = BoardPromo.SetKeyPhrases(iPromoID, phrases.GetPhraseList(), bdefault );
				if (!bOk)
				{
					bPageOk = bPageOk && m_pWholePage->SetAttribute("BOARDPROMOPAGE","PAGE","promoname");
				}
			}
		}
		else if (sAction.CompareText("choosetype"))
		{
			// Get the values from the URL
			if (m_InputContext.ParamExists("Type"))
			{
				int iPromoType = m_InputContext.GetParamInt("type");
				bOk = BoardPromo.SetBoardPromoType(iPromoID,iPromoType,true,iUserID,sEditKey);
				bPageOk = bPageOk && AddActionXMLResult(bOk,"choosetype",iPromoID,&BoardPromo);
				bUseRedirect = bOk;
				if (!bOk)
				{
					bPageOk = bPageOk && m_pWholePage->SetAttribute("BOARDPROMOPAGE","PAGE","choosetype");
				}
			}
		}
		else if (sAction.CompareText("setdefaultpromo"))
		{
			// Get the default loaction from the URL
			if (m_InputContext.ParamExists("defaultpromoid"))
			{
				bOk = BoardPromo.SetDefaultBoardPromoForTopics(iSiteID,iDefaultPromoID,iUserID);
				bPageOk = bPageOk && AddActionXMLResult(bOk,"setdefaultlocation",iDefaultPromoID,&BoardPromo);
				bUseRedirect = bOk;
			}
		}
		else if (sAction.CompareText("setlocation"))
		{
			// Get the Locations from the URL
			CDNAIntArray TopicLocations;
			for (int i = 0; i < m_InputContext.GetParamCount("topicid"); i++)
			{
				// Get each topic from the URL
				TopicLocations.Add(m_InputContext.GetParamInt("topicid",i));
			}

			// Now pass the locations to the promo
			bOk = BoardPromo.SetBoardPromoLocations(iPromoID,TopicLocations,sEditKey,iUserID);
			bPageOk = bPageOk && AddActionXMLResult(bOk,"setlocation",iPromoID,&BoardPromo);
			bUseRedirect = bOk;
			if (!bOk)
			{
				bPageOk = bPageOk && m_pWholePage->SetAttribute("BOARDPROMOPAGE","PAGE","setlocation");
			}
		}
		else if (sAction.CompareText("choosetemplate"))
		{
			// Get the values from the URL
			if (m_InputContext.ParamExists("template"))
			{
				int iTemplate = m_InputContext.GetParamInt("template");
				bOk = BoardPromo.SetTemplateType(iPromoID,iTemplate,true,iUserID,sEditKey);
				bPageOk = bPageOk && AddActionXMLResult(bOk,"choosetemplate",iPromoID,&BoardPromo);
				bUseRedirect = bOk;
				if (!bOk)
				{
					bPageOk = bPageOk && m_pWholePage->SetAttribute("BOARDPROMOPAGE","PAGE","choosetemplate");
				}
			}
		}
		else if (sAction.CompareText("textandimage"))
		{
			// Get the values from the multi step object
			Multi.GetRequiredValue("title",sTitle);
			Multi.GetRequiredValue("text",sText);
			Multi.GetRequiredValue("imagename",sImageName);
			Multi.GetRequiredValue("imagewidth",iImageWidth);
			Multi.GetRequiredValue("imageheight",iImageHeight);
			Multi.GetRequiredValue("imagealttext",sImageAltText);

			// Set the boards new values
			bOk = bOk && BoardPromo.SetTitle(iPromoID,sTitle,false,iUserID,sEditKey);
			bOk = bOk && BoardPromo.SetText(iPromoID,sText,false,iUserID,sEditKey);
			bOk = bOk && BoardPromo.SetImageName(iPromoID,sImageName,false,iUserID,sEditKey);
			bOk = bOk && BoardPromo.SetImageWidth(iPromoID,iImageWidth,false,iUserID,sEditKey);
			bOk = bOk && BoardPromo.SetImageHeight(iPromoID,iImageHeight,false,iUserID,sEditKey);
			bOk = bOk && BoardPromo.SetImageAltText(iPromoID,sImageAltText,false,iUserID,sEditKey);

			// See if we're ready to use
			if (Multi.ReadyToUse())
			{
				// Now commit the changes to the database
				bOk = bOk && BoardPromo.CommitBoardPromoChanges(iUserID,sEditKey);
				bPageOk = bPageOk && AddActionXMLResult(bOk,"setvalues",iPromoID,&BoardPromo);
				bUseRedirect = bOk;
				if (!bOk)
				{
					bPageOk = bPageOk && m_pWholePage->SetAttribute("BOARDPROMOPAGE","PAGE","textandimage");
				}
			}
			else
			{
				// not yet! make sure we stay on this page untill we are!
				bPageOk = bPageOk && m_pWholePage->SetAttribute("BOARDPROMOPAGE","PAGE","textandimage");
				sPage = "textandimage";

				// Check to see if we've been cancelled as this means we want a preview!
				if (Multi.IsCancelled())
				{
					// Get the preview for the Board Promo
					if (BoardPromo.CreateXMLForCurrentState())
					{
						// Add the XML to the Page
						bPageOk = bPageOk && m_pWholePage->AddInside("BOARDPROMOPAGE","<BOARDPROMO-PREVIEW></BOARDPROMO-PREVIEW>");
						bPageOk = bPageOk && m_pWholePage->AddInside("BOARDPROMO-PREVIEW",&BoardPromo);
					}
					else
					{
						// Get the error from the object
						bPageOk = bPageOk && m_pWholePage->AddInside("BOARDPROMO-PREVIEW",BoardPromo.GetLastErrorAsXMLString());
					}
				}
			}
		}
		else if (sAction.CompareText("choosednatype"))
		{
			// Get the values from the URL
			if (m_InputContext.ParamExists("textboxtype"))
			{
				int iPromoType = m_InputContext.GetParamInt("textboxtype");
				bOk = BoardPromo.SetBoardPromoType(iPromoID,iPromoType,true,iUserID,sEditKey);
				bPageOk = bPageOk && AddActionXMLResult(bOk,"textboxtype",iPromoID,&BoardPromo);
				bUseRedirect = bOk;
			}
		}
		else if (sAction.CompareText("makeactive"))
		{
			// Try to make the preview boxes active
			bOk = BoardPromo.MakePreviewBoardPromosActive(iSiteID,iPromoID);
			bPageOk = bPageOk && AddActionXMLResult(bOk,"makeactive",iPromoID,&BoardPromo);
			bUseRedirect = bOk;
		}
		else if (sAction.CompareText("delete"))
		{
			// Try to delete the given BoardPromo
			bOk = BoardPromo.DeleteBoardPromo(iPromoID,iUserID);
			bPageOk = bPageOk && AddActionXMLResult(bOk,"delete",iPromoID,&BoardPromo);
			bUseRedirect = bOk && bPageOk;
		}
		else
		{
			// Don't know what Action they want!
			SetDNALastError("CMessageBoardPromoBuilder::Build","UnkownActiongiven","Unknown Action given");
			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
		}
	}

	// Check to see if we're ok, and if we are required to do a redirect.
	if (bUseRedirect && bPageOk)
	{
		// Call the redirect function
		if (CheckAndUseRedirectIfGiven(m_pWholePage))
		{
			// we've had a valid redirect! return
			return true;
		}
	}

	// Now get the BoardPromo list or single BoardPromo details
	bOk = BoardPromo.GetBoardPromosForSite(iSiteID,CFrontPageElement::ES_PREVIEW,iPromoID);

	// Check to see if everthing went ok?
	if (bOk)
	{
		// Insert the list into the page
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/BOARDPROMOPAGE",&BoardPromo);
	}
	else
	{
		// get the error from the BoardPromo object
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/BOARDPROMOPAGE",BoardPromo.GetLastErrorAsXMLString());
	}

	// Get the list of topics for the site
	CTopic Topic(m_InputContext);
	if (Topic.GetTopicsForSiteID(iSiteID,CTopic::TS_PREVIEW))
	{
		// Insert the list into the page
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/BOARDPROMOPAGE",&Topic);
	}
	else
	{
		// get the error from the Topic object
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/BOARDPROMOPAGE",Topic.GetLastErrorAsXMLString());
	}

	//Include Site Key Phrases - these are used to set up key phrases associated with the promo.
	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CThreadSearchPhrase tsp(m_InputContext,delimit);
	if ( tsp.GetSiteKeyPhrasesXML() )
	{
		//Dont fail page if not successful.
		m_pWholePage->AddInside("H2G2","<THREADSEARCHPHRASE/>");
		m_pWholePage->AddInside("H2G2/THREADSEARCHPHRASE",&tsp);
	}

	// return ok!
	return bPageOk;
}

/*********************************************************************************

	bool CMessageBoardPromoBuilder::AddActionXMLResult(bool bActionOk, const TDVCHAR* psActionName, int iPromoID, CMessageBoardPromo* pBoardPromo)

		Author:		Mark Howitt
        Created:	08/11/2004
        Inputs:		bActionOk - A flag that states whether or not the action worked.
					psActionName - The name of the action that was just used.
					iPromoID - The id of the Promo that the action was used on.
					pBoardPromo - A pointer to the Promo object that did the action.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Helper function for setting the last errors and action XML.

*********************************************************************************/
bool CMessageBoardPromoBuilder::AddActionXMLResult(bool bActionOk, const TDVCHAR* psActionName, int iPromoID, CMessageBoardPromo* pBoardPromo)
{
	// Add the result to the xml 
	bool bOk = true;
	CTDVString sResultXML;
	sResultXML << "<ACTION TYPE='" << psActionName << "' BOARDPROMOID='" << iPromoID << "'>";
	if (bActionOk)
	{
		sResultXML << "OK</ACTION>";
	}
	else
	{
		sResultXML << "FAILED</ACTION>";

		// Insert the error from the BoardPromo if we're given one!
		if (pBoardPromo != NULL)
		{
			// Insert the text box error into the page
			bOk = m_pWholePage->AddInside("H2G2",pBoardPromo->GetLastErrorAsXMLString());
		}
	}

	// Put the string into the page
	bOk = bOk && m_pWholePage->AddInside("H2G2/BOARDPROMOPAGE",sResultXML);
	return bOk;
}