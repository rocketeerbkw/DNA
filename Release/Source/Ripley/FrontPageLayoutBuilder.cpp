// FrontPageLayoutBuilder.cpp: implementation of the CFrontPageLayoutBuilder class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/


#include "stdafx.h"
#include "FrontPageLayoutBuilder.h"
#include "PageUI.h"
#include "WholePage.h"
#include "tdvassert.h"
#include "TextBoxElement.h"
#include "FrontPageTopicElement.h"
#include "FrontPageLayout.h"
#include "Topic.h"
#include "TopFives.h"
#include "SiteConfigPreview.h"


#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


CFrontPageLayoutBuilder::CFrontPageLayoutBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
}

CFrontPageLayoutBuilder::~CFrontPageLayoutBuilder()
{
}


/*********************************************************************************

	bool CFrontPageLayoutBuilder::Build(CWholePage* pPage)

		Author:		Nick Stevenson
        Created:	03/11/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CFrontPageLayoutBuilder::Build(CWholePage* pPage)
{
	// some important variables
	int iSiteID = m_InputContext.GetSiteID();
	bool bSuccess = true;

	//initialise the page object
	if (!InitPage(pPage, "FRONTPAGE-LAYOUT", true))
	{
		// now handle the error
		SetDNALastError("CFrontPageLayoutBuilder::Build", "FailedToCreatePage", "Failed to create page");
		return pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}

	//handle the user
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (pViewingUser == NULL || !pViewingUser->GetIsEditor())
	{
		//handle the error -we don't want to assert here as this is not a functional error
		SetDNALastError("CFrontPageLayoutBuilder::Build", "UserNotAuthorised", "User not logged in or not authorised");
		return pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}

	// Initialise the PageBody object
	CFrontPageLayout FPL(m_InputContext);
	if (!FPL.InitialisePageBody(iSiteID,true,true))
	{
		SetDNALastError("CFrontPageLayoutBuilder::Build", "FailedToInitialisePageBody", "Problems Initialising the pagebody!!!");
		return pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}

	// Get the command parameter
	bool bActivated = false;
	CTDVString sRedirect;
	CTDVString sCmd;
	if (m_InputContext.ParamExists("cmd"))
	{
		m_InputContext.GetParamString("cmd", sCmd);
	}

	// Are we updating layout values?
	if (sCmd.CompareText("chooseLayout") || sCmd.CompareText("chooseTemplate") || sCmd.CompareText("chooseElemTemplate"))
	{
		// Setup some locals
		int iLayoutUpdate = 0;
		int iLayoutType = 0;
		int iTmplType = 0;
		int iElemTmplType = 0;
		bool bUpdateOk = true;

		// if we're processing some page layout data
		if (m_InputContext.ParamExists("layouttype"))
		{
			// Get the Layout Type
			iLayoutType = m_InputContext.GetParamInt("layouttype");

			// Are we changing to GuideML?
			if (iLayoutType == CFrontPageLayout::LAYOUT_GUIDEML_INDICATOR)
			{
				// Set redirect string
				sRedirect << "FrontPageEditor?_previewmode=1";
			}

			// Update the Layout type
			bUpdateOk = FPL.SetFrontPageLayoutType(iLayoutType);
			iLayoutUpdate = 1;
		}
		else if (m_InputContext.ParamExists("tmpltype"))
		{
			// Get The Template type if given
			iTmplType = m_InputContext.GetParamInt("tmpltype");
			bUpdateOk = FPL.SetFromtPageTemplateType(iTmplType);
			iLayoutUpdate = 2;
		}
		else if (m_InputContext.ParamExists("elemtmpltype"))
		{
			// Get the Element Template Type if given
			iElemTmplType = m_InputContext.GetParamInt("elemtmpltype");
			bUpdateOk = FPL.SetFrontPageElementType(iElemTmplType);
			iLayoutUpdate = 3;

			// See if we're still wanting GuideML for the Elements
			if (iElemTmplType < CFrontPageLayout::ELEMENTTEMPLATE_GUIDEML_INDICATOR)
			{
				// We no longer want the GuideML
				bUpdateOk = bUpdateOk && FPL.SetFrontPageElementGuideML("");
			}
			else if (iElemTmplType == CFrontPageLayout::ELEMENTTEMPLATE_GUIDEML_INDICATOR && m_InputContext.ParamExists("CustomElem"))
			{
				// Get the custom Element info
				CTDVString sElemTemplateGuideML;
				m_InputContext.GetParamString("CustomElem", sElemTemplateGuideML);
				if (!sElemTemplateGuideML.IsEmpty())
				{
					// we need to check the GUIDEML is correctly formatted
					CTDVString sError = CXMLObject::ParseXMLForErrors(sElemTemplateGuideML);
					if (!sError.IsEmpty())
					{
						SetDNALastError("CFrontPageLayoutBuilder", "BuildLayout()", "GUIDEML is badly formed.");
						return pPage->AddInside("H2G2", GetLastErrorAsXMLString());
					}
				}
				bUpdateOk = bUpdateOk && FPL.SetFrontPageElementGuideML(sElemTemplateGuideML);
			}
		}

		// Okay!
		if (bSuccess && bUpdateOk)
		{
			// Update the preview
			bool bEditedByAnotherUser = false;
			CTDVString sEditKey;
			m_InputContext.GetParamString("EditKey", sEditKey);
			bUpdateOk = bUpdateOk && FPL.UpdateFrontPagePreview(pViewingUser->GetUserID(), sEditKey, bEditedByAnotherUser);

			// Check to see if we're ok and that we're not clashing with other editors!
			if (bEditedByAnotherUser || !bUpdateOk )
			{
				// Get the last error!
				bSuccess = bSuccess && pPage->AddInside("H2G2", FPL.GetLastErrorAsXMLString());
			}
		}

		// Set the Update step. This will be cleared if 0
		bUpdateOk = bUpdateOk && FPL.SetUpdateStep(iLayoutUpdate);

		// See if the updates went ok?
		if (!bUpdateOk)
		{
			// Get the last error from the FrontPageLayout Obejct
			bSuccess = bSuccess && pPage->AddInside("H2G2",FPL.GetLastErrorAsXMLString());
		}
	}
	else if (sCmd.CompareText("makeactive")) // Are we making preview data active?
	{
		// Try to make the Preview FrontPage active!
		FPL.SetUpdateStep(0);
		bSuccess = bSuccess && FPL.MakePreviewItemActive(m_InputContext.GetSiteID());
		bActivated = bSuccess;
		if (!bSuccess)
		{
			SetDNALastError("CFrontPageLayoutBuilder::Build", "FailedToMakePreviewPageActive", "Failed To Make Preview Frontpage Active!!!");
			return pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		}
	}
	else
	{
		// make sure the update step is cleared
		FPL.SetUpdateStep(0);
	}

	// Deal with frontpage XML data that should be escaped for editing
	bSuccess = bSuccess && FPL.AddEscapedElementGuideML();

	// create an encapsulating element called 'FRONTPAGELAYOUTCOMPONENTS'
	bSuccess = bSuccess && pPage->AddInside("H2G2", "<FRONTPAGELAYOUTCOMPONENTS/>");

	// add the pageBody object data to the page
	if (FPL.CreateFromPageLayout())
	{
		bSuccess && pPage->AddInside("FRONTPAGELAYOUTCOMPONENTS", &FPL);
	}
	else
	{
		bSuccess && pPage->AddInside("H2G2", FPL.GetLastErrorAsXMLString());
	}

	// If we've just been made active, put the frontpagelayout object into the page
	if (bActivated)
	{
		// Add the FrontpageLayout object into the page
		bSuccess = bSuccess && pPage->AddInside("ARTICLEINFO", &FPL);
	}

	// Only redirect if we know if/where we want to redirect
	bool bUseReturnToRedirect = true;
	if (bSuccess && !sRedirect.IsEmpty())
	{
		// Redirect here.
		if(!pPage->Redirect(sRedirect))
		{
			SetDNALastError("CFrontPageLayoutBuilder::Build", "RedirectFailed", "Failed to redirect!!!");
			return pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		}
		bUseReturnToRedirect = false;
	}

	// Check to see if we're ok and if we are given a redirect?
	if (bSuccess && bUseReturnToRedirect)
	{
		// Call the redirect function
		if (CheckAndUseRedirectIfGiven(pPage))
		{
			// We've had a valid redirect! return now
			return true;
		}
	}

	// Get all the relevent data for a MessageBoard frontpage
	if (bSuccess)
	{
		// get list of text boxes
		CTextBoxElement TextBElem(m_InputContext);
		bSuccess = bSuccess && TextBElem.GetTextBoxesForSiteID(iSiteID, CTextBoxElement::ES_PREVIEW);
		bSuccess = bSuccess && pPage->AddInside("FRONTPAGELAYOUTCOMPONENTS", &TextBElem);
	
		// get list of topic elements
		CFrontPageTopicElement TopicElem(m_InputContext);
		bSuccess = bSuccess && TopicElem.GetTopicFrontPageElementsForSiteID(iSiteID,CFrontPageElement::ES_PREVIEW);
		bSuccess = bSuccess && pPage->AddInside("FRONTPAGELAYOUTCOMPONENTS", &TopicElem);
	
		// get list of topics
		CTopic Topic(m_InputContext);
		bSuccess = bSuccess & Topic.GetTopicsForSiteID(iSiteID, CTopic::TS_PREVIEW);
		bSuccess = bSuccess && pPage->AddInside("FRONTPAGELAYOUTCOMPONENTS", &Topic);

		// get the site config (preview version)
		CTDVString sConfig;
		CSiteConfigPreview SCPreview(m_InputContext);
		bSuccess = bSuccess && SCPreview.GetPreviewSiteConfig(sConfig, iSiteID);
		if ( ! sConfig.IsEmpty() )
		{
			bSuccess = bSuccess && pPage->AddInside("FRONTPAGELAYOUTCOMPONENTS", sConfig);
		}
		
		// get the top fives
		CTopFives TFives(m_InputContext);
		TFives.Initialise(m_InputContext.GetSiteID());
		bSuccess = bSuccess && pPage->AddInside("FRONTPAGELAYOUTCOMPONENTS", &TFives);
	}

	// waszzzaaaap?
	return bSuccess;
}
