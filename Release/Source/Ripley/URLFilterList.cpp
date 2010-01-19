// URLFilter.cpp: implementation of the CURLFilter class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "URLFilterList.h"
#include "tdvassert.h"
#include "StoredProcedure.h"
#include "dbxmlbuilder.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


CURLFilterList::CURLFilterList(CInputContext& inputContext) :
	CXMLObject(inputContext)
{
}

CURLFilterList::~CURLFilterList(void)
{
}

bool CURLFilterList::GetURLFilterList(void)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	SP.GetAllAllowedURLs();
	CTDVString sURLFilterListXML;

	CDBXMLBuilder AllowedURLsBuilder;
	AllowedURLsBuilder.Initialise(&sURLFilterListXML, &SP);
	AllowedURLsBuilder.OpenTag("URLFILTER-LISTS");

	int iCurrentSiteID = 1;
	int iSiteID = 1;
	int iCurrentRefer = 0;
	int iRefer = 0;
	CTDVString sAllowedURLTag;
	CTDVString sAllowedURL;

	while (!SP.IsEOF())
	{
		AllowedURLsBuilder.OpenTag("URLFILTER-LIST", true);
		iCurrentSiteID = iSiteID = SP.GetIntField("SiteID");
		AllowedURLsBuilder.AddIntAttribute("SITEID", iSiteID, true);
		while (!SP.IsEOF())
		{
			SP.GetField("URL", sAllowedURL);
			sAllowedURLTag = "<ALLOWEDURL  ID='" + CTDVString(SP.GetIntField("ID"))+ "'>" + sAllowedURL + "</ALLOWEDURL>";
			sURLFilterListXML << sAllowedURLTag;
			SP.MoveNext();
			if (SP.IsEOF())
			{
				break;
			}
			iSiteID = SP.GetIntField("SiteID");
			if (iSiteID != iCurrentSiteID)
			{
				break;
			}				
		}
		AllowedURLsBuilder.CloseTag("URLFILTER-LIST");
	}
	AllowedURLsBuilder.CloseTag("URLFILTER-LISTS");

	return CreateFromXMLText(sURLFilterListXML);
}

bool CURLFilterList::UpdateAllowedURL(const int iAllowedURLID, const CTDVString& sAllowedURL, 
									 const int iSiteID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	CTDVString strCleanedAllowedURL(sAllowedURL);

	//Remove any dodgy characters
	strCleanedAllowedURL.RemoveDodgyChars();
	//Remove any spaces
	strCleanedAllowedURL.Replace(" ","");

	return SP.UpdateAllowedURL(iAllowedURLID, strCleanedAllowedURL, iSiteID);
}

bool CURLFilterList::DeleteAllowedURL(const int iAllowedURLID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	return SP.DeleteAllowedURL(iAllowedURLID);
}

bool CURLFilterList::AddNewAllowedURL(const CTDVString& sAllowedURL, const int iSiteID)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	CTDVString strCleanedAllowedURL(sAllowedURL);

	//Remove any dodgy characters
	strCleanedAllowedURL.RemoveDodgyChars();
	//Remove any spaces
	strCleanedAllowedURL.Replace(" ","");

	return SP.AddNewAllowedURL(strCleanedAllowedURL, iSiteID);
}