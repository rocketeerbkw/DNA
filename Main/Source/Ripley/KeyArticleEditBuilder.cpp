// KeyArticleEditBuilder.cpp: implementation of the CKeyArticleEditBuilder class.
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
#include "ripleyserver.h"
#include "KeyArticleEditBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CKeyArticleEditBuilder::CKeyArticleEditBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CKeyArticleEditBuilder::~CKeyArticleEditBuilder()
{

}

bool CKeyArticleEditBuilder::Build(CWholePage* pPageXML)
{
	InitPage(pPageXML, "KEYARTICLE-EDITOR", true);
	int iSiteID = m_InputContext.GetSiteID();
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	CTDVString sXML;
	
	int iParamCount = m_InputContext.GetParamCount("removename");
	if (m_InputContext.ParamExists("remove") && iParamCount > 0)
	{
		int iCount = 0;
		int iThisBatch = 0;
		SP.StartDeleteKeyArticles(iSiteID);
		while (iCount < iParamCount)
		{
			CTDVString sName;
			m_InputContext.GetParamString("removename", sName, iCount);
			SP.AddDeleteKeyArticle(sName);
			iCount++;
			if (++iThisBatch >= 20)
			{
				SP.DoDeleteKeyArticles();
				SP.StartDeleteKeyArticles(iSiteID);
				iThisBatch = 0;
			}
		}
		if (iThisBatch > 0)
		{
			SP.DoDeleteKeyArticles();
		}
		m_InputContext.SiteDataUpdated();
		m_InputContext.Signal("/Signal?action=recache-site");
	}
	
	bool bGotForm = m_InputContext.ParamExists("setarticle");
	if (bGotForm)
	{
		sXML << "<KEYARTICLEFORM>";
		CTDVString sName;
		CTDVString sh2g2ID;
		CTDVString sDate;
		m_InputContext.GetParamString("name",sName);
		m_InputContext.GetParamString("h2g2id", sh2g2ID);
		m_InputContext.GetParamString("date", sDate);
		bool bAllowOtherSites = false;
		if (m_InputContext.GetParamInt("allowothersites") == 1)
		{
			bAllowOtherSites = true;
		}
		while ((!sh2g2ID.IsEmpty()) && ((sh2g2ID[0] == ' ') || (sh2g2ID[0] == 'A') || (sh2g2ID[0] == 'a')))
		{
			sh2g2ID.RemoveLeftChars(1);
		}
		int ih2g2ID = atoi(sh2g2ID);

		// Check the input and report any errors
		if (ih2g2ID == 0)
		{
			sXML << "<ERROR TYPE='BADVALUE'>The article ID you typed was incorrect</ERROR>";
			CXMLObject::EscapeXMLText(&sName);
			CXMLObject::EscapeXMLText(&sh2g2ID);
			sXML << "<NAME>" << sName << "</NAME><H2G2ID>" << sh2g2ID << "</H2G2ID>";
		}
		else if (sName.FindContaining("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-") >= 0)
		{
			sXML << "<ERROR TYPE='BADNAME'>The name can only contain numbers, letters and the '-' sign.</ERROR>";
			CXMLObject::EscapeXMLText(&sName);
			CXMLObject::EscapeXMLText(&sh2g2ID);
			sXML << "<NAME>" << sName << "</NAME><H2G2ID>" << sh2g2ID << "</H2G2ID>";
		}
		else if (sName.IsEmpty())
		{
			sXML << "<ERROR TYPE='NONAME'>You must type in a name.</ERROR>";
			CXMLObject::EscapeXMLText(&sName);
			CXMLObject::EscapeXMLText(&sh2g2ID);
			sXML << "<NAME>" << sName << "</NAME><H2G2ID>" << sh2g2ID << "</H2G2ID>";
		}
		else
		{
			// Try setting the key article
			CTDVString sError;
			if (SP.SetKeyArticle(sName, ih2g2ID, iSiteID, bAllowOtherSites, sDate, &sError))
			{
				sXML << "<SUCCESS/><NAME/><H2G2ID/>";
				m_InputContext.SiteDataUpdated();
				m_InputContext.Signal("/Signal?action=recache-site");
			}
			else
			{
				if (sError.CompareText("NOARTICLE"))
				{
					sXML << "<ERROR TYPE='NOARTICLE'>The article ID you typed doesn't exist</ERROR>";
				}
				else if (sError.CompareText("BADSITE"))
				{
					sXML << "<ERROR TYPE='BADSITE'>The article you typed belongs to a different dna site</ERROR>";
				}
				else
				{
					sXML << "<ERROR TYPE='" << sError << "'>An unknown error occurred</ERROR>";
				}
				CXMLObject::EscapeXMLText(&sName);
				CXMLObject::EscapeXMLText(&sh2g2ID);
				sXML << "<NAME>" << sName << "</NAME><H2G2ID>" << sh2g2ID << "</H2G2ID>";
			}
		}
	}
	else
	{
		// Do the form data - empty to begin with
		sXML << "<KEYARTICLEFORM><NAME/><H2G2ID/></KEYARTICLEFORM>";
	}
	pPageXML->AddInside("H2G2", sXML);
	sXML.Empty();
	
	if (SP.GetKeyArticleList(iSiteID))
	{
		// Got a list
		sXML  = "<KEYARTICLELIST>";
		while (!SP.IsEOF())
		{
			CTDVString sName;
			int iEntryID;
			int ih2g2ID;

			SP.GetField("ArticleName", sName);
			iEntryID = SP.GetIntField("EntryID");
			ih2g2ID = SP.GetIntField("h2g2ID");
			CXMLObject::EscapeXMLText(&sName);
			sXML << "<ARTICLE><NAME>" << sName << "</NAME>";
			sXML << "<ENTRYID>" << iEntryID << "</ENTRYID>";
			sXML << "<H2G2ID>" << ih2g2ID << "</H2G2ID>";
			sXML << "</ARTICLE>";
			SP.MoveNext();
		}
		sXML << "</KEYARTICLELIST>";
	}
	else
	{
		// No list - put in default XML
		sXML = "<KEYARTICLELIST/>";
	}

	pPageXML->AddInside("H2G2",sXML);
	sXML.Empty();

	return true;
}
