// HierarchyNodeTyperBuilder.cpp: implementation of the CHierarchyNodeTyperBuilder class.
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
#include "HierarchyNodeTyperBuilder.h"
#include "TDVString.h"
#include "XMLBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


CHierarchyNodeTyperBuilder::CHierarchyNodeTyperBuilder(CInputContext& inputContext) 
: CXMLBuilder(inputContext),
m_pPage(NULL)
{
}

CHierarchyNodeTyperBuilder::~CHierarchyNodeTyperBuilder()
{
}


/*********************************************************************************

	CWholePage* CHierarchyNodeTyperBuilder::Build()

	Author:		Nick Stevenson
	Created:	01/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CHierarchyNodeTyperBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	if (!InitPage(m_pPage, "HIERARCHYNODETYPER", true))
	{
		return false;
	}

	//check that the user is a super user
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if(pViewingUser == NULL || !pViewingUser->GetIsSuperuser())
	{
		return ErrorMessage("Invalid viewing user", "Please log in with a valid super-user account");
	}

	int iSiteID = m_InputContext.GetSiteID();
	if(iSiteID <= 0)
	{
		return ErrorMessage("No site id specified", "There must be a site id"); 
	}

	//get the action
	CTDVString sAction;
	m_InputContext.GetParamString("action", sAction);

	CTDVString sSuccess;
	sSuccess << "<HIERARCHYNODETYPER>";
	if(sAction.CompareText("TypeHierarchy"))
	{
		// HierarchyNodeTyper?action=TypeHierarchy&aNodeID=2655&NodeTypeID=2&skin=purexml		
		sSuccess << "<NODETYPER>";
		if(!TypeHierarchyNodes(iSiteID, sSuccess))
		{
			return ErrorMessage("Problem typing nodes in hierarchy", "");
		}
		sSuccess << "</NODETYPER>";
	}
	else if(sAction.CompareText("AddNewType"))
	{
		// HierarchyNodeTyper?action=AddNewType&TypeID=2&Limit=7&Description=foo+bar&skin=purexml
		sSuccess << "<NEWTYPE>";
		if(!AddNewTypeDefinition(iSiteID, sSuccess))
		{
			return ErrorMessage("Problem adding new type definition", "");
		}
		sSuccess << "</NEWTYPE>";
	}
	else
	{
		return ErrorMessage("Invalid action", "Either create new type or type the existing hierarchy"); 
	}
	sSuccess << "</HIERARCHYNODETYPER>";
	m_pPage->AddInside("H2G2", sSuccess);

	return true;

}

/*********************************************************************************

	CWholePage* CHierarchyNodeTyperBuilder::TypeHierarchyNodes(const int iSiteID, CTDVString& sSuccess)

	Author:		Nick Stevenson
	Created:	17/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CHierarchyNodeTyperBuilder::TypeHierarchyNodes(const int iSiteID, CTDVString& sSuccess)
{
	int iAncestor		= m_InputContext.GetParamInt("ANodeID");
	int iTypeID			= m_InputContext.GetParamInt("NodeTypeID");
	
	if(iTypeID <= 0 || iAncestor <= 0)
	{
		//return ErrorMessage("Bad input values", "Please make sure the ancestor id and type values are valid"); 
		return false;
	}


	// function call here
	if(!TypeNodesHavingAncestor(iAncestor, iTypeID, iSiteID))
	{
		//return ErrorMessage("Problem updating node types", "");
		return false;
	}

	// Set something sensible to be retured
	// create the page

	sSuccess << "Set hierarchy node type " << iTypeID << " for children of node ";
	sSuccess << iAncestor;

	return true;	
}

/*********************************************************************************

	bool CHierarchyNodeTyperBuilder::AddNewTypeDefinition(const int iSiteID, CTDVString& sSuccess)

	Author:		Nick Stevenson
	Created:	17/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CHierarchyNodeTyperBuilder::AddNewTypeDefinition(const int iSiteID, CTDVString& sSuccess)
{
	int iTypeID	= m_InputContext.GetParamInt("TypeID");
	CTDVString sDescription;
	m_InputContext.GetParamString("Description", sDescription);
	
	int iDescLength = sDescription.GetLength();
	if(iTypeID <= 0  || iDescLength <= 0)
	{
		m_pPage->SetError("HierarchyNodeTyperBuilder, Bad Param, Please make sure the type id, limit and description have values");
		return false;	
	}

	if(iDescLength > 50)
	{
		m_pPage->SetError("HierarchyNodeTyperBuilder, Bad Param, Description has too many characters");
		return false;
	}

	// function call here
	if(!AddNewType(iTypeID, sDescription, iSiteID))
	{
		return false; 
		m_pPage->SetError("HierarchyNodeTyperBuilder, Node Typing, Problem updating node types");
	}

	sSuccess << "Added new type " << iTypeID << " for site " << iSiteID;
	
	return true;
}

/*********************************************************************************

	CHierarchyNodeTyperBuilder::TypeNodesHavingAncestor(const int iAncestor, const int iTypeID, const int iSiteID)

	Author:		Nick Stevenson
	Created:	02/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CHierarchyNodeTyperBuilder::TypeNodesHavingAncestor(const int iAncestor, const int iTypeID, const int iSiteID)
{

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	//trawl the nodes with ancestorid	
	if (!SP.SetTypeForNodesWithAncestor(iAncestor, iTypeID, iSiteID))
	{	
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CHierarchyNodeTyperBuilder::AddNewType(const int iTypeID, const CTDVString& sDescription, const int iSiteID)

	Author:		Mark Neves
	Created:	17/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CHierarchyNodeTyperBuilder::AddNewType(const int iTypeID, const CTDVString& sDescription, const int iSiteID)
{

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	//trawl the nodes with ancestorid	
	if (!SP.AddNewHierarchyType(iTypeID, sDescription, iSiteID))
	{	
		return false;
	}

	return true;
}
/*********************************************************************************

	CWholePage* CHierarchyNodeTyperBuilder::ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg)

	Author:		Nick Stevenson
	Created:	01/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CHierarchyNodeTyperBuilder::ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg)
{

	InitPage(m_pPage, "HierarchyNodeTyperBuilder", true);

	CTDVString sError = "<ERROR TYPE='";
	sError << sType << "'>" << sMsg << "</ERROR>";

	m_pPage->AddInside("H2G2", sError);

	return true;
}



