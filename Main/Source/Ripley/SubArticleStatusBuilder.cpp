// SubArticleStatusBuilder.cpp: implementation of the CSubArticleStatusBuilder class.
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
#include "PageUI.h"
#include "ripleyserver.h"
#include "SubArticleStatusBuilder.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSubArticleStatusBuilder::CSubArticleStatusBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{

}

CSubArticleStatusBuilder::~CSubArticleStatusBuilder()
{

}

bool CSubArticleStatusBuilder::Build(CWholePage* pWholePage)
{
	// Got the whole page. Now see if we can use the stack for all
	// the rest of the objects

	CUser* pViewer = m_InputContext.GetCurrentUser();
	bool bSuccess = true;
	bSuccess = InitPage(pWholePage, "SUBBED-ARTICLE-STATUS",true);

	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot allocate recommended entries to sub editors unless you are logged in as an Editor.</ERROR>");
	}
	else
	{
		// get the h2g2id and display the details
		int ih2g2ID = m_InputContext.GetParamInt("h2g2id");

		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);

		CTDVString sXML;
		
		if (SP.FetchSubbedArticleDetails(ih2g2ID))
		{
			sXML  = "<SUBBED-ARTICLES>";
			while (!SP.IsEOF())
			{
				sXML << "<ARTICLEDETAILS>";
				CTDVString sTemp;
				sXML << "<RECOMMENDATIONID>" << SP.GetIntField("RecommendationID") << "</RECOMMENDATIONID>";
				sXML << "<H2G2ID>" << SP.GetIntField("h2g2ID") << "</H2G2ID>";
				sXML << "<ORIGINALH2G2ID>" << SP.GetIntField("Originalh2g2ID") << "</ORIGINALH2G2ID>";
				sXML << "<SUBJECT>";
				SP.GetField("Subject", sTemp);
				CXMLObject::EscapeXMLText(&sTemp);
				sXML << sTemp << "</SUBJECT>";
				sXML << "<ORIGINALID>" << SP.GetIntField("Originalh2g2ID") << "</ORIGINALID>";
				sXML << "<SUBEDITOR><USERID>" << SP.GetIntField("SubEditorID") << "</USERID>";
				sXML << "<USERNAME>";
				SP.GetField("SubEditorName", sTemp);
				sXML << sTemp << "</USERNAME></SUBEDITOR>";
				sXML << "<ACCEPTOR><USERID>" << SP.GetIntField("AcceptorID") << "</USERID>";
				sXML << "<USERNAME>";
				SP.GetField("AcceptorName", sTemp);
				sXML << sTemp << "</USERNAME></ACCEPTOR>";
				sXML << "<ALLOCATOR><USERID>" << SP.GetIntField("AllocatorID") << "</USERID>";
				sXML << "<USERNAME>";
				SP.GetField("AllocatorName", sTemp);
				sXML << sTemp << "</USERNAME></ALLOCATOR>";
				
				CTDVDateTime dDate;
				
				if (!SP.IsNULL("DateAllocated"))
				{
					dDate = SP.GetDateField("DateAllocated");
					sXML << "<DATEALLOCATED>";
					dDate.GetAsXML(sTemp);
					sXML << sTemp << "</DATEALLOCATED>";
				}

				if (!SP.IsNULL("DateReturned"))
				{
					dDate = SP.GetDateField("DateReturned");
					sXML << "<DATERETURNED>";
					dDate.GetAsXML(sTemp);
					sXML << sTemp << "</DATERETURNED>";
				}
				sXML << "<NOTIFICATION>" << SP.GetIntField("NotificationSent") << "</NOTIFICATION>";
				sXML << "<STATUS>" << SP.GetIntField("Status") << "</STATUS>";
				sXML << "<COMMENTS>";
				SP.GetField("Comments", sTemp);
				CXMLObject::EscapeXMLText(&sTemp);
				sXML << sTemp << "</COMMENTS>";
				sXML << "</ARTICLEDETAILS>";
				SP.MoveNext();
			}
			sXML << "</SUBBED-ARTICLES>";
		}
		else
		{
			sXML = "<ERROR TYPE='NO-DETAILS' H2G2ID='";
			sXML << ih2g2ID << "'>No details were found for this article</ERROR>";
		}
		pWholePage->AddInside("H2G2", sXML);
	}
	return true;
}
