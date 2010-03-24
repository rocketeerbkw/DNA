// MonthSummaryPageBuilder.cpp: implementation of the CMonthSummaryPageBuilder class.
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
#include "ripleyserver.h"
#include "MonthSummaryPageBuilder.h"
#include "InputContext.h"
#include "InputContext.h"
#include "StoredProcedure.h"
#include "WholePage.h"
#include "MonthSummary.h"
#include "PageUI.h"

#include "tdvassert.h"


#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


CMonthSummaryPageBuilder::CMonthSummaryPageBuilder(CInputContext& inputContext) 
:CXMLBuilder(inputContext)
{

}

CMonthSummaryPageBuilder::~CMonthSummaryPageBuilder()
{

}


bool CMonthSummaryPageBuilder::Build(CWholePage* pPage)
{
	// XML object subclasses representing various parts of the front page
	CMonthSummary MonthSummary(m_InputContext);


	// initialise the page
	bool bPageSuccess = false;
	bPageSuccess = InitPage(pPage, "MONTH",true);
	bool bSuccess = bPageSuccess;

	//grabs the "month" summary data in xml format 
	bSuccess = bSuccess && (MonthSummary.GetSummaryForMonth(m_InputContext.GetSiteID()));

	if (bSuccess)
	{
		pPage->AddInside("H2G2", &MonthSummary);
	}

	TDVASSERT(bPageSuccess, "CMonthSummaryPageBuilder::Build() failed");

	return bPageSuccess;
}