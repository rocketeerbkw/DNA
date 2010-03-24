// ModBillingBuilder.cpp: implementation of the CModBillingBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "ModBillingBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CModBillingBuilder::CModBillingBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CModBillingBuilder::~CModBillingBuilder()
{

}

bool CModBillingBuilder::Build(CWholePage* pPageXML)
{
	InitPage(pPageXML, "MODERATION-BILLING", true);
	
	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		pPageXML->SetPageType("ERROR");
		pPageXML->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot use this page unless you are logged in as an Editor.</ERROR>");
		return true;
	}
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	CTDVString startdate;
	CTDVString enddate;
	bool bGotParam = m_InputContext.GetParamString("startdate", startdate);
	bGotParam = bGotParam && m_InputContext.GetParamString("enddate", enddate);
	int ForceRecalc = m_InputContext.GetParamInt("recalc");
	if (bGotParam)
	{
		SP.GetModerationBilling(startdate,enddate, ForceRecalc);
		CTDVString sXML = "<MODERATION-BILLING>";
		if (!SP.IsEOF())
		{
			CTDVDateTime startdate = SP.GetDateField("StartDate");
			CTDVDateTime enddate = SP.GetDateField("EndDate");
			CTDVString sdate;
			startdate.GetAsXML(sdate, false);
			CTDVString edate;
			enddate.GetAsXML(edate, false);
			sXML << "<START-DATE>" << sdate << "</START-DATE><END-DATE>" << edate << "</END-DATE>";
		}
		while (!SP.IsEOF())
		{
			sXML << "<BILL><SITEID>" << SP.GetIntField("SiteID") << "</SITEID>";
			sXML << "<THREADTOTAL>" << SP.GetIntField("ThreadTotal") << "</THREADTOTAL>";
			sXML << "<THREADPASSED>" << SP.GetIntField("ThreadPassed") << "</THREADPASSED>";
			sXML << "<THREADFAILED>" << SP.GetIntField("ThreadFailed") << "</THREADFAILED>";
			sXML << "<THREADREFERRED>" << SP.GetIntField("ThreadReferred") << "</THREADREFERRED>";
			sXML << "<THREADCOMPLAINT>" << SP.GetIntField("ThreadComplaint") << "</THREADCOMPLAINT>";
			sXML << "<ARTICLETOTAL>" << SP.GetIntField("ArticleTotal") << "</ARTICLETOTAL>";
			sXML << "<ARTICLEPASSED>" << SP.GetIntField("ArticlePassed") << "</ARTICLEPASSED>";
			sXML << "<ARTICLEFAILED>" << SP.GetIntField("ArticleFailed") << "</ARTICLEFAILED>";
			sXML << "<ARTICLEREFERRED>" << SP.GetIntField("ArticleReferred") << "</ARTICLEREFERRED>";
			sXML << "<ARTICLECOMPLAINT>" << SP.GetIntField("ArticleComplaint") << "</ARTICLECOMPLAINT>";
			sXML << "<GENERALTOTAL>" << SP.GetIntField("GeneralTotal") << "</GENERALTOTAL>";
			sXML << "<GENERALPASSED>" << SP.GetIntField("GeneralPassed") << "</GENERALPASSED>";
			sXML << "<GENERALFAILED>" << SP.GetIntField("GeneralFailed") << "</GENERALFAILED>";
			sXML << "<GENERALREFERRED>" << SP.GetIntField("GeneralReferred") << "</GENERALEFERRED>";
			sXML << "</BILL>";
			SP.MoveNext();
		}
		sXML << "</MODERATION-BILLING>";
		pPageXML->AddInside("H2G2", sXML);
	}	
	CTDVString sSiteXML;
	m_InputContext.GetSiteListAsXML(&sSiteXML);
	pPageXML->AddInside("H2G2", sSiteXML);

	return true;
}
