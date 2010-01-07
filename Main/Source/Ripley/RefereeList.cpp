// RefereeList.cpp: implementation of the CRefereeList class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "RefereeList.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CRefereeList::CRefereeList(CInputContext& inputContext)
:
CXMLObject(inputContext)
{
}

CRefereeList::~CRefereeList()
{
}

/*********************************************************************************

	bool CRefereeList::FetchTheList()

	Author:		Igor Loboda
	Created:	27/02/2002
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Fetches the list of all referees for all sites

*********************************************************************************/
bool CRefereeList::FetchTheList()
{

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}

	if (!SP.FetchRefereeList())
	{
		return false;
	}

	CTDVString sRefereeList("<REFEREE-LIST>");

	int iUserID;
	CTDVString sUserName;
	int prevUserID = -1;
	int iSiteID;
	while (!SP.IsEOF())
	{
		iUserID = SP.GetIntField("UserID");
		iSiteID = SP.GetIntField("SiteID");
		SP.GetField("UserName", sUserName);

		if (iUserID != prevUserID)
		{
			if (prevUserID != -1)
			{
				sRefereeList << "</REFEREE>";
			}

			sRefereeList << "<REFEREE>";
			sRefereeList << "<USER><USERID>" << iUserID << "</USERID>";
			sRefereeList << "<USERNAME>" << sUserName << "</USERNAME></USER>";
			prevUserID = iUserID;
		}

		sRefereeList << "<SITEID>" << iSiteID << "</SITEID>";
		SP.MoveNext();
	}
	
	if (prevUserID != -1)
	{
		sRefereeList << "</REFEREE>";
	}

	sRefereeList << "</REFEREE-LIST>";

	if (m_pTree)
	{
		delete m_pTree;
		m_pTree = NULL;
	}

	m_pTree = CXMLTree::Parse(sRefereeList);

	return true;
}
