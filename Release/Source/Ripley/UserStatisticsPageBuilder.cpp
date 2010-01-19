// UserStatisticsPageBuilder.cpp: implementation of the UserStatisticsPageBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "UserStatisticsPageBuilder.h"
#include "Forum.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CUserStatisticsPageBuilder::CUserStatisticsPageBuilder(CInputContext& inputContext, 
														CInputContext& inputContext)
																			 
	Author:		Igor Loboda
	Created:	21/01/2002
	Inputs:		inputContext - input context object (stuff coming in 
					from the real world)
	Outputs:	-
	Returns:	-
	Purpose:	Constructor for user statistics page building utility

*********************************************************************************/

CUserStatisticsPageBuilder::CUserStatisticsPageBuilder(CInputContext& inputContext)
: 
CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

/*********************************************************************************

	CUserStatisticsPageBuilder::~CUserStatisticsPageBuilder()

	Author:		Igor Loboda
	Created:	21/01/2002
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor for the CUserStatisticsPageBuilder class.

*********************************************************************************/

CUserStatisticsPageBuilder::~CUserStatisticsPageBuilder()
{

}

/*********************************************************************************

	CWholePage* CUserStatisticsPageBuilder::Build()

	Author:		Igor Loboda
	Created:	21/01/2002
	Inputs:		-
	Outputs:	-
	Returns:	ptr to a CWholePage containing the XML data, NULL for failure
	Purpose:	Makes an Whole Page (the one that's needed to send to the transformer). 
				Can build the page in two ways defined by input context paramer named
				"mode". If it present and equals to "byforum" the list of postings will
				be grouped by forum and by thread. Otherwize all postings are ordered 
				by Post Date.

*********************************************************************************/

bool CUserStatisticsPageBuilder::Build(CWholePage* pFramePage)
{
	//US1064243098?userid=&mode=byforum&skin=purexml
	CForum forum(m_InputContext);
	InitPage(pFramePage, "USERSTATISTICS", true);

	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		pFramePage->SetPageType("ERROR");
		pFramePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot view statistics unless you are logged in as an Editor.</ERROR>");
	}
	//find out which display mode is requested
	int iMode = 1;
	CTDVString sMode = "";
	bool bMode = m_InputContext.GetParamString("mode", sMode);
	if (bMode)
	{
		if (sMode.CompareText("byforum"))
		{
			iMode = 0;
		}
		else
		{
			iMode = 1;
		}
	}

	int iUserID = m_InputContext.GetParamInt("userid");
	int iSkip = m_InputContext.GetParamInt("skip");
	
	int iShow = m_InputContext.GetParamInt("show");
	if (iShow < 1)
	{
		iShow = 20;
	}

	CTDVDateTime dtStartDate;
	CTDVDateTime dtEndDate;

	bool bStartDate = m_InputContext.ParamExists("startdate");
	if (bStartDate)
	{
		CTDVString sDateParam;
		m_InputContext.GetParamString("startdate", sDateParam);
		if (!dtStartDate.SetFromString(sDateParam))
		{
			dtStartDate = COleDateTime::GetCurrentTime() - COleDateTimeSpan(30,0,0,0);
		}
	}
	else
	{
		dtStartDate = COleDateTime::GetCurrentTime() - COleDateTimeSpan(30,0,0,0);
	}

	CTDVDateTime dDateFrom;
	bool bEndDate = m_InputContext.ParamExists("enddate");
	if (bEndDate)
	{
		CTDVString sDateParam;
		m_InputContext.GetParamString("enddate", sDateParam);
		if (!dtEndDate.SetFromString(sDateParam))
		{
			dtEndDate = COleDateTime::GetCurrentTime();
		}
	}
	else
	{
		dtEndDate = COleDateTime::GetCurrentTime();
	}
	
	if (dtStartDate > dtEndDate)
	{
		dtStartDate = dtEndDate - COleDateTimeSpan(30,0,0,0);
	}

	if (dtEndDate - dtStartDate > COleDateTimeSpan(180,0,0,0))
	{
		dtStartDate = dtEndDate - COleDateTimeSpan(180,0,0,0);
	}

	forum.GetUserStatistics(iUserID, iShow, iSkip, iMode, dtStartDate, dtEndDate);

	pFramePage->AddInside("H2G2", &forum);

	// Add the site list info into the page
	CTDVString sSiteXML;
	m_InputContext.GetSiteListAsXML(&sSiteXML);
	pFramePage->AddInside("H2G2", sSiteXML);
	
	return true;
}
