// TestXMLBuilder.cpp: implementation of the CTestXMLBuilder class.
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
#include "RipleyServer.h"
#include "TestXMLBuilder.h"
#include "TestArticleXML.h"
#include "PageUI.h"
#include "PageBody.h"
#include "tdvassert.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CTestXMLBuilder::CTestXMLBuilder(CInputContext& inputContext)
																			 
	Author:		Oscar Gillespie
	Created:	23/02/2000
	Inputs:		inputContext - input context object (stuff coming in from the real world)
	Outputs:	-
	Returns:	-
	Purpose:	Constructor for our test class

*********************************************************************************/


CTestXMLBuilder::CTestXMLBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}


/*********************************************************************************

	CTestXMLBuilder::~CTestXMLBuilder()

	Author:		Oscar Gillespie
	Created:	23/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor for the CTestXMLBuilder class. Functionality when we start allocating memory

*********************************************************************************/

CTestXMLBuilder::~CTestXMLBuilder()
{

}

/*********************************************************************************

	CXMLObject* CTestXMLBuilder::Build()

	Author:		Oscar Gillespie, Kim Harries
	Created:	17/02/2000
	Modified:	01/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	ptr to a CWholePage containing the XML representation of the page, NULL for failure
	Purpose:	Builds the Test article by telling the object which bits it ought to have.

*********************************************************************************/


bool CTestXMLBuilder::Build(CWholePage* pArticle)
{
	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	CPageBody Body(m_InputContext);
	
	bool bSuccess = true;
	bSuccess = InitPage(pArticle, "SIMPLEPAGE",true);
	
	// if we get this far it means we have an article and we're happy...
	// now let's tell it some stuff

	int iArticleID = m_InputContext.GetParamInt("ID");
	CTDVString sArticleName;
	bool bGotName = m_InputContext.GetParamString("name", sArticleName);

	// iArticleID should now contain the ID of the Article being viewed

	if (bGotName)
	{
		bSuccess = bSuccess && Body.Initialise(sArticleName);
	}
	else
	{
		if (iArticleID == 0)
		{
			TDVASSERT(iArticleID > 0, "If this fails then we're really looking at a dodgy article.");
		}
		else
		{
			bSuccess = bSuccess && Body.Initialise(iArticleID);
		}
	}

	if (bSuccess) // Might as well tell the article what it number article it is
	{
		pArticle->AddInside("H2G2", &Body);
		return true;
	}
	else
	{
		return false;
	}
}
