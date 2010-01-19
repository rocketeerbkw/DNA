// ThroughputTransformer.cpp: implementation of the CThroughputTransformer class.
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
#include "RipleyServer.h"
#include "ThroughputTransformer.h"
#include "XSLT.h"
#include "tdvassert.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CHTMLTransformer::CHTMLTransformer(CInputContext& inputContext,
									   COutputContext* pOutputContext)

	Author:		Oscar Gillespie
	Created:	02/03/2000
	Inputs:		pInputContext - pointer to an input context for getting information
					about the current request
				pOutputContext - pointer to an output context for allowing the
					resulting transformed data to be output to the client
	Outputs:	-
	Returns:	-
	Purpose:	Construct the object with sensible default values for any data
				members and pointers to the input and output contexts it requires.

*********************************************************************************/

CThroughputTransformer::CThroughputTransformer(CInputContext& inputContext, COutputContext* pOutputContext) :
	CXMLTransformer(inputContext, pOutputContext)
{
// no further construction
}

/*********************************************************************************

	CThroughputTransformer::~CThroughputTransformer()

	Author:		Oscar Gillespie
	Created:	02/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor. No resources to release at this point.

*********************************************************************************/

CThroughputTransformer::~CThroughputTransformer()
{
// no explicit destruction required
}


/*********************************************************************************

	CThroughputTransformer::Output(CXMLObject* pXMLObject, const TDVCHAR* pCacheName, const TDVCHAR* pItemName)
	
	Author:		Oscar Gillespie
	Created:	02/03/2000
	Inputs:		pXMLObject - a pointer to an xml object containing the xml that
					describes the content of the page to be served.
	Outputs:	-
	Returns:	true for success, false for failure
	Purpose:	Take the given XML and feed it through to be displayed as XML

*********************************************************************************/

bool CThroughputTransformer::Output(CWholePage* pWholePage, const TDVCHAR* pCacheName, const TDVCHAR* pItemName)
{
	TDVASSERT(pWholePage != NULL, "CThroughputTransformer::Output(...) passed a NULL CWholePage pointer");
	TDVASSERT(!pWholePage->IsEmpty(), "CThroughputTransformer::Output(...) passed an empty CWholePage");

	if (pWholePage == NULL || pWholePage->IsEmpty())
	{
		// should just fail if xml object is null or empty, but send a default HTML message
		// indicatig an internal error for debug purposes ???
		m_pOutputContext->SendOutput("<HTML><HEAD><TITLE>ERROR!!!</TITLE></HEAD><BODY>CThroughputTransformer::Output(...) called with NULL or empty CWholePage</BODY></HTML>");
		return true;
		//return false;
	}
	else
	{
		CXSLT xslt;				// object capable of doing stylesheet transforms
		CTDVString outString;

		// CTDVString stylesheet;
		// TOGO: probably redundant as of 3/3/00

		// find the home path for where the different skins directories are kept
		// if (!m_InputContext.GetStylesheetHomePath(stylesheet))
		// {
			// something is seriously wrong if you can't get the stylesheet homepath
		//	return false;
		// }
		
		// stylesheet += "\\Skins";
		// stylesheet += "\\raw-xml.xsl";
		// This is w3 organisations stylesheet for displaying and formatting XML
		// TOGO: probably redundant as of 3/3/00

		if (pWholePage->GetAsString(outString))
		{
			m_pOutputContext->SetMimeType("text/xml");	
			HINSTANCE hInst = AfxGetResourceHandle();
			HRSRC hRes = ::FindResource(hInst, (LPCTSTR)IDR_ENTITIES, (LPCTSTR)"LONGSTRING");
			HGLOBAL hResGlobal = ::LoadResource(hInst, hRes);

			char* buffer = (char*)::LockResource(hResGlobal);

			CTDVString sEntities(buffer);

			::FreeResource(hResGlobal);
			
			outString = sEntities + outString;
			CTDVString skin;
			m_InputContext.GetParamString("skin", skin);
			if (skin.GetLength() == 0)
			{
				m_InputContext.GetSkin(&skin);
			}
			if (skin.Left(7).CompareText("http://"))
			{
				outString = "<?xml-stylesheet type='text/xsl' href='" + skin + "'?>" + outString;
			}
			outString = "<?xml version=\"1.0\" encoding=\"ISO8859-1\"?>" + outString;
			
			CTDVString sLenHeader;
			sLenHeader << "Content-Length: " << outString.GetLength();
			m_pOutputContext->SetHeader(sLenHeader);
			m_pOutputContext->SendOutput(outString);
			return true;
		}

	return false;
	}
}

