// TestHTMLTransformer.cpp: implementation of the CTestHTMLTransformer class.
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
#include "TestHTMLTransformer.h"
#include "XSLT.h"
#include "TDVAssert.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CTestHTMLTransformer::CTestHTMLTransformer(CInputContext& inputContext,
											   COutputContext* pOutputContext)
																			 ,	
	Author:		Kim Harries
	Created:	23/02/2000
	Inputs:		pInputContext - pointer to an input context for getting information
					about the current request
				pOutputContext - pointer to an output context for allowing the
					resulting transformed data to be output to the client
	Outputs:	-
	Returns:	-
	Purpose:	Construct the object with sensible default values for any data
				members and pointers to the input and output contexts it requires.

*********************************************************************************/

CTestHTMLTransformer::CTestHTMLTransformer(CInputContext& InputContext,
										   COutputContext* pOutputContext) :
	CXMLTransformer(InputContext, pOutputContext)
{
// no further construction
}

/*********************************************************************************

	CTestHTMLTransformer::~CTestHTMLTransformer()
																			 ,	
	Author:		Kim Harries
	Created:	23/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor. No resources to release at this point.

*********************************************************************************/

CTestHTMLTransformer::~CTestHTMLTransformer()
{
// no explicit destruction required
}

/*********************************************************************************

	CTestHTMLTransformer::Output(CXMLObject* pXMLObject, const TDVCHAR* pCacheName, const TDVCHAR* pItemName)
																			 ,	
	Author:		Kim Harries
	Created:	23/02/2000
	Modified:	28/02/2000
	Inputs:		pXMLObject - a pointer to an xml object containing the xml that
					describes the content of the page to be served.
	Outputs:	-
	Returns:	true for success, false for failure
	Purpose:	Take the given content xml and transform it into HTML to be sent
				to the client. This test class will only deal with a simplified
				article page.

*********************************************************************************/

bool CTestHTMLTransformer::Output(CXMLObject* pXMLObject, const TDVCHAR* pCacheName, const TDVCHAR* pItemName)
{
	TDVASSERT(pXMLObject != NULL, "CTestHTMLTransformer::Output(...) passed a NULL CXMLObject pointer");
	TDVASSERT(!pXMLObject->IsEmpty(), "CTestHTMLTransformer::Output(...) passed an empty CXMLObject");

	if (pXMLObject == NULL || pXMLObject->IsEmpty())
	{
		// should just fail if xml object is null or empty, but send a default HTML message
		// indicatig an internal error for debug purposes ???
		m_pOutputContext->SendOutput("<HTML><HEAD><TITLE>ERROR!!!</TITLE></HEAD><BODY>CTestHTMLTransformer::Output(...) called with NULL or empty CXMLObject</BODY></HTML>");
		return true;
		//return false;
	}
	else
	{
		CXSLT xslt;				// object capable of doing stylesheet transforms
		CTDVString outString;
		CTDVString skin;
		CTDVString command;
		CTDVString stylesheet;
		
		// find the home path for where the different skins directories are kept
		if (!m_InputContext.GetStylesheetHomePath(stylesheet))
		{
			// something is seriously wrong if you can't get the stylesheet homepath
			return false;
		}
		stylesheet += "\\Skins";
		// if a skin is specified on the command line use that skin directory
		// else use the DefaultSkin directory
		// - don't bother checking if it is a valid skin directory since this
		// will not be the final method of determining skins anyway ???
		if (!m_InputContext.GetParamString("skin", skin))
		{
			skin = "DefaultSkin";
		}
		stylesheet += "\\" + skin;
		// select the appropriate stylesheet from within the skin directory
		// dependent on the type of request
		if (m_InputContext.GetCommand(command))
		{
			// first case becomes redundant soon - Kim
			if (command.CompareText("TEST"))	// case insensitive equality test
			{
				stylesheet += "\\TestArticlePage.xsl";
			}
			else if (command.CompareText("ARTICLE"))	// case insensitive equality test
			{
				stylesheet += "\\ArticlePage.xsl";
			}
			else if (command.CompareText("USERPAGE"))	// case insensitive equality test
			{
				stylesheet += "\\UserPage.xsl";
			}
			else if (command.CompareText("FRONTPAGE"))	// case insensitive equality test
			{
				stylesheet += "\\FrontPage.xsl";
			}
			else if (command.CompareText("FORUM"))		// case insensitive equality test
			{
				stylesheet += "\\ForumPage.xsl";
			}
			else
			{
				stylesheet += "\\DefaultStylesheet.xsl";
			}
		}
		else
		{
			// if there is no command then we are showing the frontpage
			stylesheet += "\\FrontPage.xsl";
		}
		// now apply the selected stylesheet from the selected skin to the XML
		// and then send the result to the client via the output context
		// TODO: should check at this point for the existence of the stylesheet
		// and if it is not present return an appropriate error, or perhaps use
		// a default skin ???
		bool bOk = xslt.ApplyTransform(stylesheet, pXMLObject, outString);
		m_pOutputContext->SendOutput(outString);
		return true;
	}
}
