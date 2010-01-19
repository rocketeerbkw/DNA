// URLFilterAdminBuilder.cpp: implementation of the CURLFilterAdminBuilder class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2006.

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
#include "URLFilterAdmin.h"
#include "URLFilterList.h"
#include "XMLStringUtils.h"

#include <vector>

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CURLFilterAdmin::CURLFilterAdmin(CInputContext& inputContext) :
	CXMLObject(inputContext), m_URLFilterList(inputContext)
{
}

CURLFilterAdmin::~CURLFilterAdmin(void)
{
	Clear();
}

/*********************************************************************************

	void CURLFilterAdmin::Clear()

	Author:		Steven Francis
	Created:	05/05/2004
	Inputs:		-
	Outputs:	-
	Returns:	void
	Purpose:	Deletes and makes null the Tree pointer, clearing the page

*********************************************************************************/

void CURLFilterAdmin::Clear()
{
	if(m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}
}

/*********************************************************************************

	bool CURLFilterAdmin::Create(const TDVCHAR* pAction)

	Author:		Steven Francis
	Created:	05/05/2004
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Calls a function to create the 'URLFilterAdmin' page element

*********************************************************************************/

bool CURLFilterAdmin::Create(const TDVCHAR* pAction)
{
	if(m_pTree != NULL)
	{
		delete m_pTree;
		m_pTree = NULL;
	}

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML);

	int iSiteID =  m_InputContext.GetParamInt("siteid");
	if (iSiteID == 0)
	{
		iSiteID = m_InputContext.GetSiteID();
	}
	bool bIsSiteURLFiltered = m_InputContext.IsCurrentSiteURLFiltered();

	OpenXMLTag("URLFILTERADMIN");
	if (bIsSiteURLFiltered)
	{
		AddXMLIntTag("ISSITEURLFILTERED", 1);
	}
	else
	{
		AddXMLIntTag("ISSITEURLFILTERED", 0);
	}
	
	OpenXMLTag("ACTION", true);
	AddXMLIntAttribute("SITEID", iSiteID, true);
	CloseXMLTag("ACTION", pAction);
	//AddXMLTag("ACTION", pAction);
	CloseXMLTag("URLFILTERADMIN");

	if (!CreateFromXMLText(sXML))
	{
		SetDNALastError("CURLFilterAdmin", "INPUTPARAMS", "Bad action parameter passed");
		return false;
	}

	m_URLFilterList.GetURLFilterList();
	AddInsideSelf(&m_URLFilterList);

	return true;
}

bool CURLFilterAdmin::ProcessAllowedURLs(void)
{
	int iSiteID =  m_InputContext.GetParamInt("siteid");
	if (iSiteID == 0)
	{
		iSiteID = m_InputContext.GetSiteID();
	}

	CTDVString sAction;
	m_InputContext.GetParamString("action", sAction);

	if (sAction.CompareText("importallowedurls"))
	{
		ImportURLFilterList();
	}
	else if (sAction.CompareText("addallowedurl"))
	{
		AddAllowedURL();
	}
	else if (sAction.CompareText("updateallowedurl"))
	{
		int iAllowedURLCount = m_InputContext.GetParamCount("allowedurl");
		for (int i = 0; i < iAllowedURLCount; i++)
		{
			int iAllowedURLEdited = m_InputContext.GetParamInt("allowedurledited", i);
			
			if (iAllowedURLEdited > 0)
			{
				CTDVString sAllowedURL;
				m_InputContext.GetParamString("allowedurl", sAllowedURL, i);

				CTDVString sDelete;
				m_InputContext.GetParamString("delete", sDelete, i);

				int iAllowedURLId;
				iAllowedURLId = m_InputContext.GetParamInt("allowedurlid", i);

				int iAllowedURLSiteId;
				iAllowedURLSiteId = m_InputContext.GetParamInt("siteid", i);
				if (sDelete.CompareText("on"))
				{
					m_URLFilterList.DeleteAllowedURL(iAllowedURLId);
				}
				else
				{
					m_URLFilterList.UpdateAllowedURL(iAllowedURLId, sAllowedURL, iAllowedURLSiteId);
				}
			}
		}
	}

	Clear();
	Create("");

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML);
	OpenXMLTag("RESULT", false);
	AddXMLTag("ACTION", sAction);
	AddXMLIntTag("SUCCESS", 1);
	CloseXMLTag("RESULT");
	AddInsideSelf(sXML);

	return true;
}

bool CURLFilterAdmin::AddAllowedURL(void)
{
	int iAllowedURLCount = m_InputContext.GetParamCount("allowedurl");

	for (int i = 0; i < iAllowedURLCount; i++)
	{
		CTDVString sAllowedURL;
		m_InputContext.GetParamString("allowedurl", sAllowedURL, i);
		//replace certain characters
		sAllowedURL.Replace("\t", "");
		sAllowedURL.Replace("\r", "");
		sAllowedURL.Replace("\n", "");

		sAllowedURL.RemoveDodgyChars();
		sAllowedURL.Replace(" ","");

		//RTrim whitespace.
		while ( sAllowedURL.GetLength()  && sAllowedURL.Right(1) == " ")
			sAllowedURL.RemoveTrailingChar(' ');

		//LTrim whitespace
		while ( sAllowedURL.GetLength() && sAllowedURL.Left(1) == " " )
			sAllowedURL.RemoveLeftChars(1);

		if (sAllowedURL.CompareText(""))
		{
			continue;
		}
		
		int iSiteID = m_InputContext.GetParamInt("siteid");
		m_URLFilterList.AddNewAllowedURL(sAllowedURL, iSiteID);
	}

	Clear();
	Create("addallowedurl");

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML);
	OpenXMLTag("RESULT", false);
	AddXMLTag("ACTION", "addallowedurl");
	AddXMLIntTag("SUCCESS", 1);
	CloseXMLTag("RESULT");
	AddInsideSelf(sXML);

	return true;
}

bool CURLFilterAdmin::ImportURLFilterList(void)
{
	CTDVString sURLFilterList;
	m_InputContext.GetParamString("urlfilterlist", sURLFilterList);
	int iSiteID = m_InputContext.GetParamInt("siteid");

	std::vector<CTDVString> vecLines;
	CXMLStringUtils::Split(sURLFilterList, "\n", vecLines);

	for (int i = 0; i < (int)vecLines.size(); i++)
	{
		CTDVString sAllowedURL;
		sAllowedURL = vecLines[i];

		//replace certain characters
		sAllowedURL.Replace("\t", "");
		sAllowedURL.Replace("\r", "");
		sAllowedURL.Replace("\n", "");

		sAllowedURL.RemoveDodgyChars();
		sAllowedURL.Replace(" ","");

		//RTrim whitespace.
		while ( sAllowedURL.GetLength()  && sAllowedURL.Right(1) == " ")
			sAllowedURL.RemoveTrailingChar(' ');

		//LTrim whitespace
		while ( sAllowedURL.GetLength() && sAllowedURL.Left(1) == " " )
			sAllowedURL.RemoveLeftChars(1);

		if (sAllowedURL.CompareText(""))
		{
			continue;
		}
		
		m_URLFilterList.AddNewAllowedURL(sAllowedURL, iSiteID);
	}	

	Clear();
	Create("importallowedurls");

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML);
	OpenXMLTag("RESULT", false);
	AddXMLTag("ACTION", "importallowedurls");
	AddXMLIntTag("SUCCESS", 1);
	CloseXMLTag("RESULT");
	AddInsideSelf(sXML);

	return true;
}