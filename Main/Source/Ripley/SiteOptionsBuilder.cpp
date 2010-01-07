// SiteOptionsBuilder.cpp: implementation of the CSiteOptionsBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "SiteOptions.h"
#include "SiteOptionsBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSiteOptionsBuilder::CSiteOptionsBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CSiteOptionsBuilder::~CSiteOptionsBuilder()
{

}

/*********************************************************************************

	bool CSiteOptionsBuilder::Build(CWholePage* pPageXML)

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Builds the SITEOPTIONS page

*********************************************************************************/

bool CSiteOptionsBuilder::Build(CWholePage* pPageXML)
{
	InitPage(pPageXML, "SITEOPTIONS", true);
	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		pPageXML->SetError("<ERROR TYPE='NOT-EDITOR'>You are not logged in as an Editor.</ERROR>");
		return true;
	}

	// Get SiteID to be processed. 
	bool bParamSiteIDPassedIn = true; 
	int iProcessingSiteID = m_InputContext.GetParamInt("siteid"); 
	if (iProcessingSiteID == 0)
	{
		bParamSiteIDPassedIn = false; 
		iProcessingSiteID = m_InputContext.GetSiteID(); 
	}

	// Add list of sites the viewing user is an editor of and check if they have permission to edit the site's options. 
	CTDVString sXML;
	sXML.Empty();
	int iFirstSiteID; // default to the first site user is editor of if no SiteID passed in. 
	bool bHasEditPermission = pViewer->GetSitesUserIsEditorOfXMLWithEditPermissionCheck(pViewer->GetUserID(), sXML, iFirstSiteID, iProcessingSiteID); 
	pPageXML->AddInside("H2G2",sXML);

	if (bHasEditPermission)
	{
		CSiteOptions* pSiteOptions = m_InputContext.GetSiteOptions();

		pSiteOptions->Process(m_InputContext);

		if (pSiteOptions->ErrorReported())
		{
			pPageXML->AddInside("H2G2",pSiteOptions->GetLastErrorAsXMLString());
		}

		// Add all the options for this site
		sXML.Empty();
		pSiteOptions->CreateXML(iProcessingSiteID,sXML);
		pPageXML->AddInside("H2G2",sXML);

		// Add all the DNA-wide defaults
		sXML.Empty();
		pSiteOptions->CreateXML(0,sXML);
		pPageXML->AddInside("H2G2",sXML);
	}
	else
	{
		// Insert the empty SITEOPTIONS element. 
		bool bPageOk = pPageXML->AddInside("H2G2", "<SITEOPTIONS/>");

		//record an error -we don't want to assert here as this is not a functional error
		SetDNALastError("CSiteOptionBuilder::Build", "UserNotLoggedInOrAuthorised", "User not logged in or not authorised for the site they are trying to update.");
		pPageXML->AddInside("H2G2", GetLastErrorAsXMLString());
	}

	// Add processing sites information - i.e. the site that is being changed. 
	sXML.Empty();
	sXML << "<PROCESSINGSITE>"; 
	sXML << m_InputContext.GetSiteAsXML(iProcessingSiteID, 1);
	sXML << "</PROCESSINGSITE>"; 
	pPageXML->AddInside("H2G2",sXML);

	if(!bParamSiteIDPassedIn && m_InputContext.IsModerationSite(iProcessingSiteID))
	{
		// redirect to the first site user is editor of if no SiteID passed in. 
		CTDVString sRedirect;
		sRedirect << "SiteOptions?siteid=" << iFirstSiteID;
		pPageXML->Redirect(sRedirect);
	}

	return true;
}
