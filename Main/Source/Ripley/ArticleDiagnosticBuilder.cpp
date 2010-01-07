// ArticleDiagnosticBuilder.cpp: implementation of the CArticleDiagnosticBuilder class.
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
#include "pageui.h"
#include "pagebody.h"
#include "tdvassert.h"
#include "ArticleDiagnosticBuilder.h"
#include "StoredProcedure.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CArticleDiagnosticBuilder::CArticleDiagnosticBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CArticleDiagnosticBuilder::~CArticleDiagnosticBuilder()
{

}

bool CArticleDiagnosticBuilder::Build(CWholePage* pPage)
{
	CPageBody PageBody(m_InputContext);

	InitPage(pPage, "DIAGNOSE", true);

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	
	int ih2g2id = m_InputContext.GetParamInt("h2g2id");


	if (ih2g2id == 0)
	{
		int iUserID = m_InputContext.GetParamInt("userid");
		CUser User(m_InputContext);
		User.CreateFromID(iUserID);
		ih2g2id = User.GetMasthead();
	}

	// get the h2g2 id parameter and check that this article is not cancelled
	// at the time of writing a status of 7 meant that an article was cancelled

	int iStatus = SP.GetEntryStatusFromh2g2ID(ih2g2id);
	bool bSuccess = (iStatus != 7 && iStatus != 0);

	if (bSuccess)
	{

		CTDVString xmlpage;
		xmlpage << "<GUIDE><BODY>";
		xmlpage << "<SUBHEADER>Analysing page...</SUBHEADER>";
	
		CTDVString xmltext;
		SP.FetchSimpleArticle(ih2g2id, xmltext);
		SP.Release();

		long NumErrors = 0;
		CXMLTree* pTree = CXMLTree::Parse(xmltext, true, &NumErrors);
		if (NumErrors > 0)
		{
			xmlpage << "<P>" << NumErrors << " errors found</P>";
			CTDVString disperror = pTree->DisplayErrors(xmltext);
			xmlpage << disperror;
		}
		delete pTree;
	
		CTDVString ParseError;
		CTDVString ErrorLine;
		int LineNo = 0;
		int LinePos = 0;
		bool bParseErrors = m_InputContext.GetParsingErrors(xmltext, &ParseError, &ErrorLine, &LineNo, &LinePos);
		if (!bParseErrors)
		{
			CXMLObject::EscapeXMLText(&ParseError);
			xmlpage << "<PARSE-ERROR><DESCRIPTION>" << ParseError << "</DESCRIPTION>";
			CXMLObject::EscapeXMLText(&ErrorLine);
			xmlpage << "<LINE>" << ErrorLine << "</LINE>";
			xmlpage << "<LINENO>" << LineNo << "</LINENO>";
			xmlpage << "<LINEPOS>" << LinePos << "</LINEPOS>";
			xmlpage << "</PARSE-ERROR>";
		}
	
		CTDVString safetext = xmltext;
		CXMLObject::EscapeAllXML(&safetext);
		xmlpage << "<FORM><TEXTAREA ROWS='20' COLS='80'>" << safetext << "</TEXTAREA></FORM>";
		xmlpage << "</BODY></GUIDE>";
		PageBody.CreatePageFromXMLText("Testing article", xmlpage);
		pPage->AddInside("H2G2", &PageBody);
	}
	else
	{
		// delete any page we have created so far and replace it with			
		// a simple error page instead
		CreateSimplePage(pPage, "Article Deleted", "<GUIDE><BODY>This Guide Entry has been deleted.</BODY></GUIDE>");
	}

	return true;
}