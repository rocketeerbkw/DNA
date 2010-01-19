#include "stdafx.h"
#include ".\siteconfigpreviewbuilder.h"
#include ".\SiteConfigPreview.h"
#include ".\User.h"

CSiteConfigPreviewBuilder::CSiteConfigPreviewBuilder(CInputContext& InputContext) : CSiteConfigBuilder(InputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CSiteConfigPreviewBuilder::~CSiteConfigPreviewBuilder(void)
{
}

/*********************************************************************************

	bool CSiteConfigPreviewBuilder::Build(CWholePage* pPageXML)

		Author:		Mark Howitt
        Created:	09/02/2005
        Inputs:		pPageXML - The page object you want to add to
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Builds the SiteConfig page

*********************************************************************************/
bool CSiteConfigPreviewBuilder::Build(CWholePage* pPageXML)
{
	bool bPageOk = InitPage(pPageXML, "SITECONFIGPREVIEW-EDITOR", true);

	// Now check to make sure the builder was called in preview mode
	// if not, complain as it will contain the live siteconfig info!!!
	if (!m_InputContext.GetIsInPreviewMode())
	{
		bPageOk = bPageOk && pPageXML->SetPageType("ERROR");
		bPageOk = bPageOk && pPageXML->AddInside("H2G2", "<ERROR TYPE='NOT-IN-PREVIEWMODE'>You cannot use this page unless you are in preview mode.</ERROR>");
		return bPageOk;
	}

	int iSiteID = m_InputContext.GetSiteID();
	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		bPageOk = bPageOk && pPageXML->SetPageType("ERROR");
		bPageOk = bPageOk && pPageXML->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot administer a site unless you are logged in as an Editor.</ERROR>");
		return bPageOk;
	}

	// Set up the a SiteConfig object add call the process action function
	CSiteConfigPreview SiteConfig(m_InputContext);

	// Now finish by processing the Action
	return ProcessAction(pPageXML,&SiteConfig);
}