// HTMLTransformer.cpp: implementation of the CHTMLTransformer class.
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


#include <stdio.h>
#include "stdafx.h"
#include "HTMLTransformer.h"
#include "XSLT.h"
#include "TDVAssert.h"
#include "WholePage.h"
#include "SkinSelector.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CHTMLTransformer::CHTMLTransformer(CInputContext& inputContext,
									   COutputContext* pOutputContext)
																			 ,	
	Author:		Kim Harries
	Created:	29/02/2000
	Inputs:		pInputContext - pointer to an input context for getting information
					about the current request
				pOutputContext - pointer to an output context for allowing the
					resulting transformed data to be output to the client
	Outputs:	-
	Returns:	-
	Purpose:	Construct the object with sensible default values for any data
				members and pointers to the input and output contexts it requires.

*********************************************************************************/

CHTMLTransformer::CHTMLTransformer(CInputContext& inputContext, COutputContext* pOutputContext) :
	CXMLTransformer(inputContext, pOutputContext)
{

 
}

/*********************************************************************************

	CHTMLTransformer::~CHTMLTransformer()
																			 ,	
	Author:		Kim Harries
	Created:	29/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor. No resources to release at this point.

*********************************************************************************/

CHTMLTransformer::~CHTMLTransformer()
{
// no explicit destruction required
}

/*********************************************************************************

	CHTMLTransformer::Output(CWholePage* pWholePage)

	Author:		Kim Harries
	Created:	29/02/2000
	Modified:	02/03/2000
	Inputs:		pXMLObject - a pointer to an xml object containing the xml that
					describes the content of the page to be served.
	Outputs:	-
	Returns:	true for success, false for failure
	Purpose:	Take the given content xml and transform it into HTML to be sent
				to the client.
				Currently only deals with simple article pages.

*********************************************************************************/

bool CHTMLTransformer::Output(CWholePage* pWholePage, const TDVCHAR* pCacheName, const TDVCHAR* pItemName)
{
	// Start time, in case viewer wants to time the transform
	long timeStart = GetTickCount();

	m_pOutputContext->LogTimerEvent("HTML Output started");
	TDVASSERT(pWholePage != NULL, "CHTMLTransformer::Output(...) passed a NULL CWholePage pointer");
	TDVASSERT(!pWholePage->IsEmpty(), "CHTMLTransformer::Output(...) passed an empty CWholePage");

	if (pWholePage == NULL || pWholePage->IsEmpty())
	{
		// should just fail if xml object is null or empty, but send a default HTML message
		// indicatig an internal error for debug purposes ???
		m_pOutputContext->SendOutput("<HTML><HEAD><TITLE>ERROR!!!</TITLE></HEAD><BODY>CHTMLTransformer::Output(...) called with NULL or empty CWholePage</BODY></HTML>");
		return true;
		//return false;
	}
	
	CTDVString sPageType;
	pWholePage->GetPageType(sPageType);
	
	if (sPageType.CompareText("REDIRECT"))
	{				
		CXMLCookie::CXMLCookieList oCookieList;		
		//see postcodebuilder class, for example of where this is used		
		
		CTDVString sLocation;
		pWholePage->GetContentsOfTag("REDIRECT-TO", &sLocation);
		CXMLObject::UnEscapeXMLText(&sLocation);		
				
		if ( ProcessCookies(pWholePage, &oCookieList) )
		{
			m_pOutputContext->SendRedirectWithCookies(sLocation, oCookieList);
		}
		else
		{
			m_pOutputContext->SendRedirect(sLocation);
		}
		return true;
	}
	else
	{
		CXSLT xslt;				// object capable of doing stylesheet transforms
		CTDVString outString;
		CTDVString command;

		// Make a string and put into it the type of the page that we are processing
		CTDVString sPageType = "";
		pWholePage->GetPageType(sPageType);
		
		//// check what the page type is so we can sort of predict if a cookie operation is going to be required
		//if ( sPageType.CompareText("REGISTER") || sPageType.CompareText("REGISTER-CONFIRMATION") || sPageType.CompareText("NEWREGISTER") )
		//{
		//	ProcessCookies(pWholePage);			
		//}
		//else if ( sPageType.CompareText("LOGOUT") )
		//{
		//	if (pWholePage->DoesTagExist("CLEARCOOKIE"))
		//	{
		//		// wipe the cookie from the users disk so nobody else can impersonate him/her
		//		m_pOutputContext->ClearCookie();
		//	}
		//}

		// now apply the selected stylesheet from the selected skin to the XML
		// and then send the result to the client via the output context
		// TODO: should check at this point for the existence of the stylesheet
		// and if it is not present return an appropriate error, or perhaps use
		// a default skin ???
		m_pOutputContext->LogTimerEvent("Applying Transform");

		// Apply the transform to the new page
		CTDVString stylesheet = GetStylesheet(); 
        CTDVString sSkin;
	    m_InputContext.GetSkin(&sSkin);
        bool bUseUTF8 = CSkinSelector::IsXmlSkin(sSkin);
		if (!xslt.ApplyCachedTransform(stylesheet, pWholePage, outString, bUseUTF8))
		{
			// We've had an error! Check the last error state
			CTDVString sError;
			int iError = xslt.GetLastError(sError);
            m_InputContext.WriteInputLog("xslt error", sError);

#ifdef DEBUG
			if (iError == CXSLT::XSLT_DOCLOAD_ERROR)
			{
				TDVASSERT(false,"XSLT_DOCLOAD_ERROR - " + sError);
			}
			else if (iError == CXSLT::XSLT_XMLDOC_ERROR)
			{
				TDVASSERT(false,"XSLT_XMLDOC_ERROR - " + sError);
			}
			else if (iError == CXSLT::XSLT_XMLLOAD_ERROR)
			{
				TDVASSERT(false,"XSLT_XMLLOAD_ERROR - " + sError);
			}
			else
			{
				TDVASSERT(false,"XSLT Error - " + sError);
			}

			outString << sError;
#else
			// Redirect the user to the problem page. Check to see if the site has the page, if not default to the global
			CTDVString sFileName = GetErrorPage();

			// Now try to open the file
			CTDVString sText;
			FILE* pFile;
			pFile = fopen(sFileName, "r");

			if (pFile != NULL)
			{
				// Setup a buffer and make sure it's initialised
				int iCount = 0;
				TDVCHAR Buffer[4048];
				memset(&Buffer,0,4048);
				while (!feof(pFile))
				{
					iCount = fread(&Buffer,sizeof(TDVCHAR),4048,pFile);
					sText.AppendChars(*(&Buffer),iCount);
				}

				// Finaly close the file
				fclose(pFile);
			}
			else
			{
				sText = "<HTML><HEAD><TITLE>ERROR!!!</TITLE></HEAD><BODY>There has been a problem with the page</BODY></HTML>";
			}

			// Set the mime type and output the file
			m_pOutputContext->SetMimeType("text/html");
			m_pOutputContext->SendOutput(sText);

			return true;
#endif
		}

		// If timing the transform, put it in the page
		if (m_InputContext.GetTimeTransform())
		{
			AddTransformTime(outString,GetTickCount() - timeStart);
		}

		m_pOutputContext->LogTimerEvent("Applied transform");
		if (!bUseUTF8)
		{
			outString.Replace("\xA0", "&nbsp;");
		}
//		m_pOutputContext->SetHeader("Expires: -1");
//		m_pOutputContext->SetHeader("Pragma: no-cache");
		m_pOutputContext->SetHeader("Cache-Control: Private");
		m_pOutputContext->SetMimeType(GetSkinMIMEType());

		CTDVString sLenHeader;
		sLenHeader << "Content-Length: " << outString.GetLength();
		m_pOutputContext->SetHeader(sLenHeader);

		// check what the page type is so we can sort of predict if a cookie operation is going to be required
		if ( sPageType.CompareText("REGISTER") || sPageType.CompareText("REGISTER-CONFIRMATION") || sPageType.CompareText("NEWREGISTER") )
		{
			ProcessCookies(pWholePage);			
		}
		else if ( sPageType.CompareText("LOGOUT") )
		{
			if (pWholePage->DoesTagExist("CLEARCOOKIE"))
			{
				// wipe the cookie from the users disk so nobody else can impersonate him/her
				m_pOutputContext->ClearCookie();
			}
		}

		m_pOutputContext->LogTimerEvent("Finished HTMLTransformer");

		CTDVString sFeedsCacheName;
		CTDVString sFeedsCacheItemName;
		
		if(m_InputContext.IsRequestForCachedFeed())
		{
			m_InputContext.GetFeedsCacheName(sFeedsCacheName, sFeedsCacheItemName);

			m_InputContext.CachePutItem(sFeedsCacheName, sFeedsCacheItemName, outString);
		}

		m_pOutputContext->SendOutput(outString);

		if (pCacheName != NULL && pItemName != NULL)
		{
			if (strlen(pCacheName) > 0 && strlen(pItemName) > 0)
			{
				m_InputContext.CachePutItem(pCacheName,pItemName,outString);
			}
		}

		return true;
	}
}

/*********************************************************************************

	bool CHTMLTransformer::AddTransformTime(CTDVString& sOutput,long lTimeTaken)

		Author:		Mark Neves
        Created:	11/03/2005
        Inputs:		sOutput = the HTML page to return
					lTimeTaken = the time taken in milliseconds
        Outputs:	sOutput is modified to contain the time taken
        Returns:	true if inserted, false otherwise
        Purpose:	The time taken is inserted immediately after the opening <body> tag.
					If the insert fails, false is returned

*********************************************************************************/

bool CHTMLTransformer::AddTransformTime(CTDVString& sOutput,long lTimeTaken)
{
	int pos = sOutput.FindText("<body");
	if (pos >=0)
	{
		pos = sOutput.FindText(">",pos);
		if (pos >= 0)
		{
			CTDVString sReplace;
			sReplace << ">Time to transform: " << CTDVString(lTimeTaken);
			sOutput.Replace(">",sReplace,pos,pos+1);

			return true;
		}
	}

	return false;
}

/*********************************************************************************

	CTDVString CHTMLTransformer::GetSkinMIMEType()

		Author:		Mark Neves
        Created:	16/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	The MIME type based on the name of the skin
        Purpose:	If the skin is an XML-type skin (i.e. it's called "xml" or it's name
					ends with "-xml", then "text/xml" is returned.

					In all other circumstances it returns "text/html"

*********************************************************************************/

CTDVString CHTMLTransformer::GetSkinMIMEType()
{
	CTDVString sSkin;
	m_InputContext.GetSkin(&sSkin);
    if ( CSkinSelector::IsXmlSkin(sSkin) )
	{
		return "text/xml; charset=utf-8";
	}

	return "text/html";
}

/*********************************************************************************

	CTDVString CHTMLTransformer::GetRealSkinName()

		Author:		Mark Neves
        Created:	16/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	The actual skin name to use
        Purpose:	This function returns the real skin name, i.e. the name of the actual
					skin folder that the skin name corresponds to.

					If the skin is called "xml", this means the user wants to use the site's
					default skin, but wants the transform to go through XMLOutput.xsl, and
					the MIME type of the response to be "text/xml"

					If the skin ends with "-xml", this means the user wants to use skin whose
					name precedes the "-xml", for it to go through XMLOutput.xsl, and the 
					MIME type of the response to be "text/xml"

					If no skin is specified, the default skin for the site is used.

					Otherwise, the skin specified on the URL is used.

					(For this func "Default skin" means use the viewing user's pref skin if there
					is one, and if not, use the site's default skin)

*********************************************************************************/

CTDVString CHTMLTransformer::GetRealSkinName()
{
	bool bGetDefaultSkin = false;
	bool bForceXML = false;
	bool bForceSSI = false; 

	CTDVString sSkin;
	if (!m_InputContext.GetSkin(&sSkin))
	{
		// if we can't get the skin, use the default
		bGetDefaultSkin = true;
	}

	if (sSkin.CompareText("xml"))
	{
		// if the skin is "xml", use the default
		bGetDefaultSkin = true;
		bForceXML = true;
	}
	
	if (sSkin.CompareText("ssi"))
	{
		// if the skin is "ssi", use the default
		bGetDefaultSkin = true;
		bForceSSI = true;
	}

	if (sSkin.Right(4).CompareText("-xml"))
	{
		// Strip off "-xml" postfix
		sSkin = sSkin.Left(sSkin.GetLength()-4);
	}

	if (sSkin.Right(4).CompareText("-ssi"))
	{
		// Strip off "-ssi" postfix
		sSkin = sSkin.Left(sSkin.GetLength()-4);
	}

	if (bGetDefaultSkin)
	{
		// have default skin as, er, like, the default
		if (!m_InputContext.GetDefaultSkin(sSkin))
		{
			// GetDefaultSkin should never fail, but if it does log error
			// and try to do something sensible
			TDVASSERT(false, "GetDefaultSkin(...) failed inside CHTMLTransformer::Output(...)");
			sSkin = "Alabaster";
		}

		// but if we have a viewer and can get their preferred skin use that
		// which may of course be the default skin...
		CUser* pViewer = m_InputContext.GetCurrentUser();
		if (!bForceXML && !bForceSSI && pViewer != NULL)
		{
			CTDVString sPrefSkin = "";
			bool bOkay = pViewer->GetPrefSkin(&sPrefSkin);
			TDVASSERT(bOkay, "GetPrefSkin(...) failed in CHTMLTransformer::Output(...)");
			// don't use the users skin preference if it is empty
			if (sPrefSkin.GetLength() > 0)
			{
				sSkin = sPrefSkin;
			}
		}
	}

	return sSkin;
}

/*********************************************************************************

	CTDVString CHTMLTransformer::GetStylesheetHomePath()

		Author:		Mark Neves
        Created:	16/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	The path to the "Skins" folder for the site
        Purpose:	-

*********************************************************************************/

CTDVString CHTMLTransformer::GetStylesheetHomePath()
{
	CTDVString sStylesheet;
	if (!m_InputContext.GetStylesheetHomePath(sStylesheet))
	{
		// something is seriously wrong if you can't get the stylesheet homepath
		TDVASSERT(false, "GetStylesheetHomePath(...) failed in CHTMLTransformer::Output(...)");
		return false;
	}
	sStylesheet += "\\Skins\\SkinSets";

	return sStylesheet;
}


/*********************************************************************************

	bool CHTMLTransformer::TestFileExists(const CTDVString& sFile)

		Author:		Mark Neves
        Created:	16/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	true if file exists, false otherwise
        Purpose:	Helper function.  This should be in a central FileUtils-type
					class really!

*********************************************************************************/

bool CHTMLTransformer::TestFileExists(const CTDVString& sFile)
{
	FILE* fp;
	fp = fopen(sFile, "r");
	if (fp == NULL)
	{
		return false;
	}
    fclose(fp);
	return true;
}


/*********************************************************************************

	CTDVString CHTMLTransformer::GetStylesheet()

		Author:		Mark Neves
        Created:	16/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	The full path to the stylesheet for the requested skin
        Purpose:	Works out the full path for the skin that is to be used for
					this particular request.

*********************************************************************************/

CTDVString CHTMLTransformer::GetStylesheet()
{
    CSkinSelector skinSelector;
    skinSelector.Initialise(m_InputContext);
    CTDVString sSkin = skinSelector.GetSkinName();
    if ( sSkin.IsEmpty() )
         TDVASSERT(false, "Non-existent skin specified in CHTMLTransformer::Output()");

    CTDVString sSkinSet = skinSelector.GetSkinSet();
    if ( sSkinSet.IsEmpty() )
        TDVASSERT(false, "Non-existent skinset specified in CHTMLTransformer::Output()");

    CTDVString sStyleSheet = GetStylesheetHomePath() + "\\" + sSkinSet + "\\" + sSkin + "\\Output.xsl";
    return sStyleSheet;

}

/*********************************************************************************

	CTDVString CHTMLTransformer::GetErrorPage()

		Author:		Mark Neves
        Created:	16/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	The path that points the the error page
        Purpose:	Each skin has a custom error page.  This function locates
					the correct error page for for the request's skin.

*********************************************************************************/

CTDVString CHTMLTransformer::GetErrorPage()
{
    CSkinSelector skinSelector;
    skinSelector.Initialise(m_InputContext);
    CTDVString sSkin = skinSelector.GetSkinName();
	
    CTDVString sErrorPath;
	sErrorPath = GetStylesheetHomePath()+"\\SkinSets\\"+ skinSelector.GetSkinSet() + "\\" + sSkin + "\\Error.htm";
	if (!TestFileExists(sErrorPath))
	{
		sErrorPath = GetStylesheetHomePath()+"\\Error.htm";
	}

	return sErrorPath;
}


/*********************************************************************************

	void CHTMLTransformer::ProcessCookies( CWholePage* pWholePage, CXMLCookie::CXMLCookieList& oCookieList   )

		Author:		DE
        Created:	10/02/2005
        Inputs:		-CWholePage* pWholePage - page xml object 
						-CXMLCookie::CXMLCookieList oCookieList  -extracted list of cookies
        Outputs:	-code  which streams out cookie info onto output http response header
        Returns:	-none
        Purpose:	-goes through the page's xml, looking for cookie setting code						 
*********************************************************************************/
bool CHTMLTransformer::ProcessCookies( CWholePage* pWholePage, CXMLCookie::CXMLCookieList* pCookieList /* = NULL */ )
{
	bool bGotCookie = pWholePage->FindFirstNode("SETCOOKIE", 0, false);
	while(bGotCookie)
	{	
		CTDVString sCookieValue=""; 
		if (pWholePage->GetTextContentsOfChild("COOKIE", &sCookieValue))
		{			
			CTDVString sCookieDomain = "";
			CTDVString sCookieName = "";		

			//true if this is a session cookie, false otherwise
			bool bIsSessionCookie = pWholePage->DoesChildTagExist("MEMORY");
		
			//get cookie's name, can be optional 
			pWholePage->GetTextContentsOfChild("NAME", &sCookieName);

			//get cookie's domain , can be optional 
			pWholePage->GetTextContentsOfChild("DOMAIN", &sCookieDomain);			
			

			//declare and insert cookie thing into list
			if ( pCookieList )
			{
				CXMLCookie oXMLCookie( sCookieName, sCookieValue, sCookieDomain, bIsSessionCookie); 
				pCookieList->push_back(oXMLCookie);
			}
			else
			{
				if  (sCookieName.IsEmpty( ) == false)
				{
					if (sCookieDomain.IsEmpty( ) == false)
					{
						m_pOutputContext->SetCookie(sCookieValue, bIsSessionCookie, sCookieName, sCookieDomain);
					}
					else
					{
						m_pOutputContext->SetCookie(sCookieValue, bIsSessionCookie, sCookieName, NULL);
					}
				}
				else
				{
					m_pOutputContext->SetCookie(sCookieValue, bIsSessionCookie);
				}
			}
		}
		else
		{
			//should be at least one of these
			TDVASSERT(false, "Failed to read Cookie from XML");
		}

		//break if no other cookie xml fragments exists	
		bGotCookie = pWholePage->NextNode();
	}

	if ( pCookieList ) 
	{
		return (pCookieList->size( ) > 0);
	}
	else
	{
		return true;
	}
}
