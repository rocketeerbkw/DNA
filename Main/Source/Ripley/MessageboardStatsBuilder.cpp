// MessageboardStatsBuilder.cpp: implementation of the CMessageboardStatsBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "MessageboardStats.h"
#include "MessageboardStatsBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CMessageboardStatsBuilder::CMessageboardStatsBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CMessageboardStatsBuilder::~CMessageboardStatsBuilder()
{

}

/*********************************************************************************

	bool CMessageboardStatsBuilder::Build(CWholePage* pPageXML)

		Author:		Mark Neves
        Created:	24/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Builds the MESSAGEBOARDSTATS page

*********************************************************************************/

bool CMessageboardStatsBuilder::Build(CWholePage* pPageXML)
{
	InitPage(pPageXML, "MESSAGEBOARDSTATS", true);

	CMessageboardStats MessageboardStats(m_InputContext);

	MessageboardStats.Process();

	if (MessageboardStats.ErrorReported())
	{
		pPageXML->AddInside("H2G2",MessageboardStats.GetLastErrorAsXMLString());
	}

	pPageXML->AddInside("H2G2",&MessageboardStats);

	return true;
}
