// SignifContent.cpp: implementation of the SignifContent class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
//#include "User.h"
#include "SignifContent.h"
#include "TDVAssert.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSignifContent::CSignifContent(CInputContext& inputContext)
:CXMLObject(inputContext)
{
}
CSignifContent::~CSignifContent()
{

}
/*********************************************************************************

	bool CSignifContent::GetMostSignifContent(int p_iSiteID, CTDVString& p_sxml)

		Author:		James Conway
        Created:	18/04/2005
        Inputs:		p_iSiteID (SiteID you want SignifContent for) and p_xmlString by reference.
        Outputs:	-
        Returns:	success boolean
        Purpose:	Gets site specific ContentSignif settings and returns them in p_sXML

*********************************************************************************/
bool CSignifContent::GetMostSignifContent(int p_iSiteID, CTDVString& p_xmlString) 
{
	CStoredProcedure SP;
	bool bSuccess;
	CTDVString sTypeName;
	int l_iType = 0;
	int currentType; 
	int l_iForumID; 
	CTDVString sContentTitle;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CSignifContent", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}
	
	bSuccess = SP.GetMostSignifContent(p_iSiteID);

	p_xmlString << "<SIGNIFCONTENT>";

	while(!SP.IsEOF())
	{
		currentType = SP.GetIntField("TYPE") ;

		if (currentType != l_iType)
		{
			// dealing with a new type so create parent node TYPE
			if (l_iType != 0)
				// not the first pass
			{
				p_xmlString << "</TYPE>";
			}

			p_xmlString << "<TYPE ID='" << currentType << "'>";

			l_iType = currentType; 
		}

		p_xmlString << "<CONTENT>" ;
			p_xmlString << "<ID>" << SP.GetIntField("CONTENTID") << "</ID>";
			
			SP.GetField("CONTENTTITLE", sContentTitle);
			p_xmlString << "<TITLE>" << sContentTitle << "</TITLE>";
			
			l_iForumID = SP.GetIntField("FORUMID"); 
			if (l_iForumID != 0)
			{
				p_xmlString << "<FORUMID>" << SP.GetIntField("FORUMID") << "</FORUMID>";
			}

			p_xmlString << "<SCORE>" << SP.GetDoubleField("SCORE") << "</SCORE>";			
		p_xmlString << "</CONTENT>" ;


		SP.MoveNext();
	}

	p_xmlString << "</SIGNIFCONTENT>";

	return bSuccess;
}
/*********************************************************************************

	bool CSignifContent::DecrementContentSignif(int p_iSiteID)

		Author:		James Conway
        Created:	13/05/2005
        Inputs:		p_iSiteID 
        Outputs:	-
        Returns:	success boolean
        Purpose:	Decrements site's ContentSignif tables.

*********************************************************************************/
bool CSignifContent::DecrementContentSignif(int p_iSiteID)
{
	CStoredProcedure SP;
	bool bSuccess;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CSignifContent::DecrementContentSignif", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}

	bSuccess = SP.DecrementContentSignif(p_iSiteID);

	return bSuccess; 
}