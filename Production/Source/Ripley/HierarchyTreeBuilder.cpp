// HierarchyTreeBuilder.cpp: implementation of the CHierarchyTreeBuilder class.
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
#include "InputContext.h"
#include "InputContext.h"
#include "StoredProcedure.h"
#include "WholePage.h"
#include "HierarchyTreeBuilder.h"
#include "HierarchyTree.h"
#include "TDVString.h"
#include "XMLBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


CHierarchyTreeBuilder::CHierarchyTreeBuilder(CInputContext& inputContext) 
: CXMLBuilder(inputContext),
m_pPage(NULL)
{
}

CHierarchyTreeBuilder::~CHierarchyTreeBuilder()
{
}

/*********************************************************************************

	CWholePage* CHierarchyTreeBuilder::Build()

	Author:		Nick Stevenson
	Created:	17/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CHierarchyTreeBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	if (!InitPage(m_pPage, "HIERARCHYTREE", true))
	{
		return false;
	}

	//CUser* pViewingUser = m_InputContext.GetCurrentUser();
	//if (!m_InputContext.ParamExists("action"))
	//{
		//if (pViewingUser)
		//{
			DisplayHierarchyTree();				
		//}
	//}

	
	return true;	

}


/*********************************************************************************

	CWholePage* CHierarchyTreeBuilder::DisplayHierarchyTree()

	Author:		Nick Stevenson
	Created:	17/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CHierarchyTreeBuilder::DisplayHierarchyTree()
{	
	// get the object
	CHierarchyTree HTree(m_InputContext);
			
 	bool bSuccess = HTree.GetHierarchyTree( 
		m_InputContext.GetSiteID(), 
		m_InputContext.GetParamInt("NodeRequired") 
	);
	if(!bSuccess)
	{
		return ErrorMessage("DisplayHierarchyTree","Failed to establish tree from Hierarchy data");		
	}
	
	// create the page
	bSuccess =	m_pPage->AddInside("H2G2",&HTree);
	if (!bSuccess)
	{
		return ErrorMessage("XML","Failed to build the XML");
	}

	return true; 
}



/*********************************************************************************

	CWholePage* CHierarchyTreeBuilder::ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg)

	Author:		Nick Stevenson
	Created:	17/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CHierarchyTreeBuilder::ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg)
{
	InitPage(m_pPage, "CLUB", true);

	CTDVString sError = "<ERROR TYPE='";
	sError << sType << "'>" << sMsg << "</ERROR>";

	m_pPage->AddInside("H2G2", sError);

	return true;
}

