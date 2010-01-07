// ReservedArticlesBuilder.cpp: implementation of the CReservedArticlesBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ReservedArticlesBuilder.h"
#include "tdvassert.h"
#include "StoredProcedure.h"
#include "User.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CReservedArticlesBuilder::CReservedArticlesBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CReservedArticlesBuilder::~CReservedArticlesBuilder()
{

}

bool CReservedArticlesBuilder::Build(CWholePage* pPage)
{
	InitPage(pPage, "RESERVED-ARTICLES", true);
	
	CUser* pViewer = m_InputContext.GetCurrentUser();

	if (pViewer == NULL)
	{
		pPage->AddInside("H2G2", "<ERROR TYPE='1' REASON='notregistered'/>");
	}
	else
	{
		CTDVString sXML;
		sXML << "<RESERVED-ARTICLES>";

		CStoredProcedure SP;
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			TDVASSERT(false, "Failed to create stored procedure object in CReservedArticlesBuilder::Build");
			return false;
		}

		SP.GetReservedArticles(pViewer->GetUserID());
		int iCount = 20;
		while (iCount > 0 && !SP.IsEOF())
		{
			CTDVString sSubject;
			SP.GetField("subject",sSubject);

			sXML << "<RESERVED-ARTICLE>";
			sXML << "<H2G2ID>" << SP.GetIntField("h2g2id") << "</H2G2ID>";
			sXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
			sXML << "</RESERVED-ARTICLE>";
			SP.MoveNext();
			iCount++;
		}

		sXML << "</RESERVED-ARTICLES>";
		pPage->AddInside("H2G2",sXML);
	}
	return true;
}
