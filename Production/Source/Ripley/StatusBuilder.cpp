// StatusBuilder.cpp: implementation of the CStatusBuilder class.
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
#include "TDVAssert.h"
#include "StatusBuilder.h"
#include <ProfileApi.h>

#include "ripleystatistics.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CStatusBuilder::CStatusBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
	// no further construction required
}

CStatusBuilder::~CStatusBuilder()
{
	// no explicit destruction required
}

bool CStatusBuilder::Build(CWholePage* pWholePage)
{
	// make this builder as simple as possible, so only use the CWholePage object
	CTDVString	sDomainName;
	CTDVString	sPageXML;
	bool		bSuccess = true;

	// simply initialise the page, give it a page type and add some content

	CStoredProcedure SP;
	bSuccess = m_InputContext.InitialiseStoredProcedureObject(&SP);
	bSuccess = bSuccess && SP.IsDatabaseRunning();
	bSuccess = bSuccess && m_InputContext.GetDomainName(sDomainName);
	sPageXML = "<STATUS-REPORT>";
	sPageXML << "<STATUS>OK"
		"</STATUS>";
	sPageXML << "<MESSAGE>Ripley is up and running on " << sDomainName << "</MESSAGE>";
	bSuccess = bSuccess && InitPage(pWholePage, "STATUSPAGE",false,false);
	bSuccess = bSuccess && pWholePage->AddInside("H2G2", sPageXML);

	
	if ( m_InputContext.GetStatistics() )
	{
		if ( m_InputContext.ParamExists("resetstatistics") )
			m_InputContext.GetStatistics()->ResetCounters();

		int interval = 60;	//default 60 min intervals.
		if ( m_InputContext.ParamExists("interval") )
			interval = m_InputContext.GetParamInt("interval");

		bSuccess = bSuccess && pWholePage->AddInside("H2G2/STATUS-REPORT", m_InputContext.GetStatistics()->GetStatisticsXML(interval) );
	}
	bSuccess = bSuccess && AddRipleyServerInfo(pWholePage);
	
//	if (m_InputContext.ParamExists("exitprocess"))
//	{
//		ExitProcess(0);
//	}
//	if (m_InputContext.ParamExists("sleep"))
//	{
//		Sleep(60000);
//	}
	
	TDVASSERT(bSuccess, "CStatusBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CStatusBuilder::AddRipleyServerInfo(CWholePage* pPage)

		Author:		Mark Neves
        Created:	29/03/2005
        Inputs:		pPage = ptr to the page object for this builder
        Outputs:	-
        Returns:	true if OK, false otherwise
        Purpose:	Returns information about the ripley server DLL this machine is running

*********************************************************************************/

bool CStatusBuilder::AddRipleyServerInfo(CWholePage* pPage)
{
	CTDVString sRipleyServerInfoXML;
	sRipleyServerInfoXML << m_InputContext.GetRipleyServerInfoXML();
	pPage->AddInside("STATUS-REPORT", sRipleyServerInfoXML);

	CTDVString sProfileAPIVersionXML;
	sProfileAPIVersionXML <<  "<PROFILEAPIVERSION>" << CProfileApi::GetVersion() << "</PROFILEAPIVERSION>";
	pPage->AddInside("STATUS-REPORT", sProfileAPIVersionXML);

	return true;
}
