// InfoBuilder.cpp: implementation of the CInfoBuilder class.
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
#include "InfoBuilder.h"
#include "Info.h"
#include "tdvassert.h"
#include "PageUI.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CInfoBuilder::CInfoBuilder(CInputContext& inputContext)
																			 
	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		inputContext - input context object (stuff coming in from the real world)
				curiously similar to the base class
	Outputs:	-
	Returns:	-
	Purpose:	Constructor for our the Info (stats and such) builder

*********************************************************************************/

CInfoBuilder::CInfoBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{


}

/*********************************************************************************

	CInfoBuilder::~CInfoBuilder()

	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor for the CInfoBuilder class. Functionality due when we start allocating memory

*********************************************************************************/


CInfoBuilder::~CInfoBuilder()
{

}

/*********************************************************************************

	CWholePage* CInfoBuilder::Build()

	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	ptr to a CWholePage containing the XML data, NULL for failure
	Purpose:	Makes a whole XML page holding a bunch of statistical info about the site

*********************************************************************************/

bool CInfoBuilder::Build(CWholePage* pPageXML)
{
	CUser* pViewer = NULL; // the viewing user xml object	

	CInfo Info(m_InputContext);
	bool bSuccess = true; // success tracking variable
	
	// get the current viewing user
	pViewer = m_InputContext.GetCurrentUser();

	// initialise the page
	bSuccess = InitPage(pPageXML, "INFO",true);

	if (bSuccess)
	{
		CTDVString cmd;
		if (m_InputContext.GetParamString("cmd", cmd))
		{
			int iSkip = m_InputContext.GetParamInt("skip");
			int iShow = m_InputContext.GetParamInt("show");
			if (iShow == 0)
			{
				iShow = 20;
			}
			int iSiteID = m_InputContext.GetSiteID();

			if (cmd.CompareText("conv"))
			{
				bSuccess = Info.CreateRecentConversations(iSiteID, iSkip, iShow);
			}
			else if (cmd.CompareText("art"))
			{
				bSuccess = Info.CreateRecentArticles(iSiteID, iSkip, iShow);
			}
			else if (cmd.CompareText("tru"))
			{
				bSuccess = Info.CreateTotalRegUsers();
			}
			else if (cmd.CompareText("tae"))
			{
				bSuccess = Info.CreateTotalApprovedEntries(iSiteID);
			}
			else if (cmd.CompareText("pp"))
			{
				bSuccess = Info.CreateProlificPosters(iSiteID);
			}
			else if (cmd.CompareText("ep"))
			{
				bSuccess = Info.CreateEruditePosters(iSiteID);
			}
			else
			{
				bSuccess = Info.CreateBlank();
			}
		}
		else
		{
			Info.CreateBlank();
		}
	}
	// if all still well then add the whosonlineobject xml inside the H2G2 tag
	if (bSuccess)
	{
		bSuccess = pPageXML->AddInside("H2G2", &Info);
	}
	
	// finally if everything worked then return the page that was built
	return bSuccess;
}