#include "stdafx.h"
#include "RipleyServer.h"
#include "CGI.h"
#include "XSLT.h"
#include "WholePage.h"
#include "tdvassert.h"
#include ".\unauthorisedbuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

CUnauthorisedBuilder::CUnauthorisedBuilder(CInputContext& inputContext):
				  CXMLBuilder(inputContext)
{
}

CUnauthorisedBuilder::~CUnauthorisedBuilder()
{
}

bool CUnauthorisedBuilder::Build(CWholePage* pPage)
{
	InitPage(pPage, "UNAUTHORISED", true);
	DoBuild(pPage);
	return true;
}

void CUnauthorisedBuilder::DoBuild(CWholePage* pPage)
{
	int iReason = 0;
	m_InputContext.IsUserAllowedInPasswordedSite(&iReason);
	
	if (iReason == 1)
	{
		pPage->AddInside("H2G2", "<REASON TYPE='1'>You are not logged in</REASON>");
	}
	else if (iReason == 2)
	{
		pPage->AddInside("H2G2", "<REASON TYPE='2'>You are not authorised to use this site</REASON>");
	}
	else
	{
		pPage->AddInside("H2G2", "<REASON TYPE='0'>Unknown reason</REASON>");
	}
	return;
}