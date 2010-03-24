//ContentSignifBuilder.cpp: implementation of the ContentSignifBuilder class.
//

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
#include "ContentSignifBuilder.h"
#include "Link.h"
#include "TDVASSERT.h"



//#ifdef _DEBUG
//#undef THIS_FILE
//static char THIS_FILE[]=__FILE__;
//#define new DEBUG_NEW
//#endif


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CContentSignifBuilder::CContentSignifBuilder(CInputContext& inputContext)
:m_pViewingUser(NULL), m_pPage(NULL), CXMLBuilder(inputContext)
{
}

CContentSignifBuilder::~CContentSignifBuilder()
{

}
/*********************************************************************************

	CWholePage* CContentSignifBuilder::Build()

		Author:		James Conway
        Created:	18/04/2005
        Inputs:		WholePage object (pointer)
        Outputs:	-
        Returns:	boolean
        Purpose:	Initialises page object if the viewing-user is an editor/superuser. 

*********************************************************************************/

bool CContentSignifBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	bool bSuccess = true;
	CTDVString sSiteXML;
	CSignifContent SignifContent(m_InputContext);

	if (!InitPage(m_pPage, "CONTENTSIGNIF", true))
	{
		// assert the problem for debugging
		TDVASSERT(false,"CContentSignifAdminBuilder - Failed to create Whole Page object!");
		// now handle the error
		SetDNALastError("CContentSignifAdminBuilder", "Build()", "Failed to initialise the page object");
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return bSuccess;
	}

	bSuccess = bSuccess && ProcessParams(SignifContent); 
	
	return bSuccess;
}
/*********************************************************************************

	CWholePage* CContentSignifBuilder::ProcessParams()

		Author:		James Conway
        Created:	18/04/2005
        Inputs:		SignifContent Object by reference
        Outputs:	-
        Returns:	boolean
        Purpose:	Check post action and call the appropriate function

*********************************************************************************/
bool CContentSignifBuilder::ProcessParams(CSignifContent& SignifContent)
{
	const int iSiteID	= m_InputContext.GetSiteID();
	CTDVString sXML;
	bool bSuccess = true;

	if (m_InputContext.ParamExists("decrementcontentsignif"))
	{
		SignifContent.DecrementContentSignif(iSiteID); 
	}

	bSuccess = SignifContent.GetMostSignifContent(iSiteID, sXML); 

	bSuccess = bSuccess && m_pPage->AddInside("H2G2", sXML);

	return bSuccess; 
}
