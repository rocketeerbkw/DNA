// SiteConfigBuilder.cpp: implementation of the CSiteConfigBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "SiteConfig.h"
#include "SiteConfigBuilder.h"
#include ".\siteconfigbuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSiteConfigBuilder::CSiteConfigBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CSiteConfigBuilder::~CSiteConfigBuilder()
{

}

/*********************************************************************************

	bool CSiteConfigBuilder::Build(CWholePage* pPageXML)

		Author:		Mark Howitt
        Created:	09/02/2005
        Inputs:		pPageXML - The page object you want to add to
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Builds the SiteConfig page

*********************************************************************************/
bool CSiteConfigBuilder::Build(CWholePage* pPageXML)
{
	bool bPageOk = InitPage(pPageXML, "SITECONFIG-EDITOR", true);

	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !pViewer->GetIsEditorOnAnySite() )
	{
		bPageOk = bPageOk && pPageXML->SetPageType("ERROR");
		bPageOk = bPageOk && pPageXML->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot administer a site unless you are logged in as an Editor.</ERROR>");
		return bPageOk;
	}

	//Site List XML - Config can be applied to a particular site.
	CTDVString sSitesXML;
	m_InputContext.GetSiteListAsXML(&sSitesXML);
	pPageXML->AddInside("H2G2",sSitesXML);

	//Add Site Being processed.
	int iSiteId = m_InputContext.GetSiteID();
	if ( m_InputContext.ParamExists("siteid") )
	{
		iSiteId = m_InputContext.GetParamInt("siteid");
	}

	// Add processing sites information - i.e. the site that is being changed. 
	CTDVString sXML;
	sXML << "<PROCESSINGSITE>"; 
	sXML << m_InputContext.GetSiteAsXML(iSiteId);
	sXML << "</PROCESSINGSITE>"; 
	pPageXML->AddInside("H2G2",sXML);


	// Set up the a SiteConfig object add call the process action function
	CSiteConfig SiteConfig(m_InputContext);
	return ProcessAction(pPageXML,&SiteConfig);
}

/*********************************************************************************

	bool CSiteConfigBuilder::ProcessAction(CWholePage* pPageXML, CSiteConfig* pSiteConfig)

		Author:		Mark Howitt
        Created:	09/02/2005
        Inputs:		pPageXML - The page object that will take the XML
					pSiteConfig - A Pointer to a SiteConfig Object that will do the work
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Process the url for the action parameter and calls the relative functions
					in the site config object.

*********************************************************************************/
bool CSiteConfigBuilder::ProcessAction(CWholePage* pPageXML, CSiteConfig* pSiteConfig)
{
	// Check to make sure we've been given a valid pointer
	if (pSiteConfig == NULL || pPageXML == NULL)
	{
		// Problems!
		TDVASSERT(false,"CSiteConfigBuilder::ProcessAction - NULL SiteConfig Pointer used!");
		return false;
	}

	bool bMultiStepReady = false;
	CTDVString sAction;
	m_InputContext.GetParamString("action", sAction);
	if (sAction.CompareText("update"))
	{
		// Call the update function
		pSiteConfig->UpdateConfig(m_InputContext,bMultiStepReady);

        //Send Signal - Config updated.
        //m_InputContext.Signal("/Signal?action=recache-site");
	}
	else
	{
		// Call the edit function
		pSiteConfig->EditConfig(m_InputContext);
	}

	// Check to see if everything went ok
	if ( pSiteConfig->ErrorReported() )
	{
		// Add the last error to the page
		pPageXML->AddInside("H2G2", pSiteConfig->GetLastErrorAsXMLString());
	}
	else
	{
		// Insert the Object into the page
		pPageXML->AddInside("H2G2", pSiteConfig);
	}

	// Call the redirect function
	if ( bMultiStepReady )
	{
		// Check to see if we've been given a redirect!
		if (CheckAndUseRedirectIfGiven(pPageXML))
		{
			// We've been given a redirect!
			return true;
		}
	}

	// Return the verdict!
	return true;
}
