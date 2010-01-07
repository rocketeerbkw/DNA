// LogoutBuilder.cpp: implementation of the CLogoutBuilder class.
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
#include "LogoutBuilder.h"
#include "pageui.h"
#include "tdvassert.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CLogoutBuilder::CLogoutBuilder(CInputContext& inputContext)
																			 
	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		inputContext - input context object (stuff coming in from the real world)
	Outputs:	-
	Returns:	-
	Purpose:	Constructor for our the Logout... anything that might fail is done in Build instead

*********************************************************************************/

CLogoutBuilder::CLogoutBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

/*********************************************************************************

	CLogoutBuilder::~CLogoutBuilder()

	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor for the CLogoutBuilder class. Functionality due when we start allocating memory

*********************************************************************************/

CLogoutBuilder::~CLogoutBuilder()
{

}

/*********************************************************************************

	CWholePage* CLogougBuilder::Build()

	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	ptr to a CWholePage containing the XML data, NULL for failure
	Purpose:	Makes a whole XML page saying "au revoir" to the user and nuking their cookie

*********************************************************************************/

bool CLogoutBuilder::Build(CWholePage* pPageXML)
{
	bool bSuccess = true;

	// first create the page root into which to insert the article
	bSuccess = InitPage(pPageXML, "LOGOUT",true);

	if (bSuccess)
	{
		// add the Index block of XML inside the PageXML
		bSuccess = pPageXML->AddInside("H2G2", "<CLEARCOOKIE/>");
	}

	return bSuccess;
}