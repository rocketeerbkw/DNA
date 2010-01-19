// WholePage.cpp: implementation of the CWholePage class.
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
#include "CGI.h"
#include "WholePage.h"
#include "tdvassert.h"
#include "TDVDateTime.h"


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CWholePage::CWholePage(CInputContext& inputContext)

	Author:		Oscar Gillesquie
	Created:	01/03/2000
	Inputs:		inputContext - input context object
				allowing abstracted access to the database if necessary
	Outputs:	-
	Returns:	NA
	Purpose:	Construct an instance of the class with all data members
				correctly initialised. Note that any initialisation that
				could possibly fail is put in a seperate initialise method.

*********************************************************************************/

CWholePage::CWholePage(CInputContext& inputContext) : CXMLObject(inputContext)
{
// no other construction code required here (he says)
}

/*********************************************************************************

	CWholePage::~CWholePage()

	Author:		Oscar Gillesquie
	Created:	01/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	NA
	Purpose:	Destructor. Must ensure that all resources allocated by this
				class are correctly released. e.g. memory is deallocated.
				We don't use any memory in CPageBody yet so the destructor does
				sod all. The base class will zap the memory it used.

*********************************************************************************/

CWholePage::~CWholePage()
{

}

/*********************************************************************************

	CWholePage::Initialise()

	Author:		Oscar Gillesquie
	Created:	01/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true for successful initialisation, false for failure
	Purpose:	Initialises the whole page to be <H2G2></H2G2>

*********************************************************************************/

bool CWholePage::Initialise()
{
	//TDVASSERT(this->IsEmpty(), "CPageBody::Initialise(...) called on non-empty XML whole page");

	Destroy();
	
	CTDVString xmlText;				// string to store the xml text returned by the stored procedure

	xmlText = "<H2G2 TYPE=''><VIEWING-USER></VIEWING-USER></H2G2>";

	bool bSuccess = CreateFromXMLText(xmlText);

	CTDVDateTime dDateTime = CTDVDateTime::GetCurrentTime();	
	CTDVString sXMLDate = "";
	dDateTime.GetAsXML(sXMLDate);
	bSuccess = bSuccess && AddInside("H2G2", sXMLDate);
	return bSuccess;

}

/*********************************************************************************

	bool CWholePage::GetPageType(CTDVString &sResult)

	Author:		Jim Lynn
	Created:	08/03/2000
	Inputs:		-
	Outputs:	sResult - string to contain the page type
	Returns:	true if OK, false if it couldn't find an H2G2 tag
	Purpose:	returns the value of the TYPE attribute of the page.
				If there's no attribute, the string is unchanged.

*********************************************************************************/

bool CWholePage::GetPageType(CTDVString &sResult)
{
	TDVASSERT(m_pTree != NULL, "NULL tree found in CWholePage::GetPageType");
	if (m_pTree == NULL)
	{
		return false;
	}

	CXMLTree* pNode = m_pTree->FindFirstTagName("H2G2");
	if (pNode != NULL)
	{
		pNode->GetAttribute("TYPE", sResult);
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CWholePage::SetPageType(const TDVCHAR *pType)

	Author:		Jim Lynn
	Created:	08/03/2000
	Inputs:		pType - string containing the page type
	Outputs:	-
	Returns:	true if successful, false otherwise
	Purpose:	Sets the TYPE attribute for the page, telling the transformer
				what kind of specialist stylesheet it needs (if any)

*********************************************************************************/

bool CWholePage::SetPageType(const TDVCHAR *pType)
{
	TDVASSERT(m_pTree != NULL, "NULL tree found in CWholePage::SetPageType");
	if (m_pTree == NULL)
	{
		return false;
	}

	CXMLTree* pNode = m_pTree->FindFirstTagName("H2G2");
	if (pNode != NULL)
	{
		pNode->SetAttribute("TYPE",pType);
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	CWholePage* CWholePage::SetError(const TDVCHAR *pError)

	Author:		?
	Created:	?
	Inputs:		pError - error message
	Outputs:	-
	Returns:	pointer to this object
	Purpose:	Adds an error to the wholepage
	16/8/01:	DR: Changed return type to this so that you can return straight away

*********************************************************************************/

bool CWholePage::SetError(const TDVCHAR *pError)
{
	SetPageType("ERROR");
	CTDVString sError = pError;
	EscapeXMLText(&sError);
	CTDVString sXML = "<ERROR>";
	sXML << sError << "</ERROR>";
	AddInside("H2G2",sXML);
	return true;
}

CXMLTree* CWholePage::ExtractTree()
{
	if (m_pTree != NULL)
	{
		CXMLTree* pNode = m_pTree->FindFirstTagName("FOOTNOTE", 0, false);
		int iIndex = 1;
		while (pNode != NULL)
		{
			pNode->SetAttribute("INDEX", iIndex);
			iIndex++;
			pNode = pNode->FindNextTagNode("FOOTNOTE");
		}
	}
	return CXMLObject::ExtractTree();
}

bool CWholePage::GetAsString(CTDVString& sResult)
{
	if (m_pTree != NULL)
	{
		CXMLTree* pNode = m_pTree->FindFirstTagName("FOOTNOTE",NULL,false);
		int iIndex = 1;
		while (pNode != NULL)
		{
			pNode->SetAttribute("INDEX", iIndex);
			iIndex++;
			pNode = pNode->FindNextTagNode("FOOTNOTE");
		}
	}
	return CXMLObject::GetAsString(sResult);
}

/*********************************************************************************

	bool CWholePage::Redirect(const TDVCHAR* pRedirectPage)

	Author:		Mark Neves
	Created:	05/11/2003
	Inputs:		pRedirectPage = ptr to page you want to redirect
	Outputs:	-
	Returns:	true if OK, false otherwise
	Purpose:	Centralised place for adding a redirect to this page.
				pRedirectPage can be any page within the application
				e.g.
					"U1063883678"
					"umc"
					"club59?s_view=edit"

*********************************************************************************/

bool CWholePage::Redirect(const TDVCHAR* pRedirectPage)
{
	if (pRedirectPage == NULL)
	{
		return SetDNALastError("CWholePage", "Redirect", "NULL ptr passed in");
	}

	if (IsEmpty())
	{
		// Make sure this page is initialised
		if (!Initialise())
			return SetDNALastError("CWholePage","InitialiseFailed","Unable to initialise this page");
	}

	CTDVString sURL(pRedirectPage);

	// Split out the URL and the Anchor part, if there is one
	CTDVString sAnchor;
	int iAnchorLocation = sURL.FindText("#");
	if (iAnchorLocation >= 0)
	{
		sAnchor = sURL.Mid(iAnchorLocation);
		sURL = sURL.Left(iAnchorLocation);
	}

	// Get all the s_ params fro the input URL so they are propogated to the redirect URL
	CTDVString sParams;
	m_InputContext.GetParamsAsString(sParams,"s_");

	// Check to see if we've got a s_returnto param.  If so, we need to remove it
	// otherwise we could end up with an infinite loop!
	RemoveParam(sParams, "s_returnto");

	// If in preview mode, add the preview mode URL param to the list of params
	if (m_InputContext.GetIsInPreviewMode())
	{
		if (!sParams.IsEmpty())
		{
			sParams << "&";
		}

		sParams << CGI::GetPreviewModeURLParam();
	}

	if (!sParams.IsEmpty())
	{
		if (sURL.FindText("?") >= 0)
		{
			sURL << "&";
		}
		else
		{
			sURL << "?";
		}
	}

	// Put all the bits together
	sURL << sParams << sAnchor;

	CXMLObject::EscapeXMLText(&sURL);

	SetPageType("REDIRECT");
	CTDVString sRedirect = "<REDIRECT-TO>";

	sRedirect << sURL;
	sRedirect << "</REDIRECT-TO>";
	return AddInside("H2G2",sRedirect);
}

/*********************************************************************************

	void CWholePage::RemoveParam(CTDVString& sParams, const TDVCHAR* pParamToRemove)

		Author:		Mark Neves
        Created:	24/03/2005
        Inputs:		sParams = a string of URL params
					pParamToRemove = ptr to param to remove
        Outputs:	sParams potentially changed with removal of pParamToRemove
        Returns:	-
        Purpose:	Removes the given param from the param string.
					
					NB:  This function needs moving to a more sensible class

*********************************************************************************/

void CWholePage::RemoveParam(CTDVString& sParams, const TDVCHAR* pParamToRemove)
{
	int iStartPost = sParams.FindText(pParamToRemove);
	if (iStartPost > -1)
	{
		// Take a copy of the params
		CTDVString sTempParams(sParams);

		// Find the next s_ param
		int iNextS = sParams.FindText("s_",iStartPost + 1);
		if (iNextS < 0)
		{
			iNextS = 0;
		}

		// Now empty and insert only the non s_returnto params
		sParams.Empty();

		// Add everything before it
		if (iStartPost > 0)
		{
			if (iStartPost > 1 && sTempParams[iStartPost-1] == '&')
			{
				// Remove the leading &
				iStartPost--;
			}
			sParams = sTempParams.Mid(0,iStartPost);
		}

		// Add everything after it
		if (iNextS > 0)
		{
			sParams << sTempParams.Mid(iNextS,sTempParams.GetLength() - iNextS);
		}
	}
}

/*********************************************************************************

	bool CWholePage::RedirectWithCookie(const TDVCHAR* pRedirectPage, const TDVCHAR *pCookie, bool bMemoryCookie, const TDVCHAR* pCookieName, const TDVCHAR* pCookieDomain)

		Author:		DE
        Created:	09/02/2005
        Inputs:		-pRedirectPage = ptr to page you want to redirect
						-CXMLCookie::CXMLCookieList oCookieList - list of cookies to include						
        Outputs:	-include cookie-enabling xml on output page
        Returns:	true if OK, false otherwise
		Purpose:	Centralised place for adding a redirect to this page (with cookie-handling).
						pRedirectPage can be any page within the application
						e.g.
							"U1063883678"
							"umc"
							"club59?s_view=edit"
*********************************************************************************/
bool CWholePage::RedirectWithCookies(const TDVCHAR* pRedirectPage, CXMLCookie::CXMLCookieList oCookieList)
{	
	//include page-redirecting xml
	if ( Redirect(pRedirectPage)==false)
	{
		return false;
	}
	
	//include cookie-setting xml
	return SetCookies( oCookieList);
}

/*********************************************************************************

	bool CWholePage::SetCookies( CXMLCookie::CXMLCookieList oCookieList)

		Author:		DE
        Created:	15/02/2005
        Inputs:		-CXMLCookie::CXMLCookieList oCookieList - list of cookies to include in page object 
        Outputs:	-
        Returns:	-true if OK, false otherwise
        Purpose:	-include cookie-enabling xml on output page

*********************************************************************************/
bool CWholePage::SetCookies( CXMLCookie::CXMLCookieList oCookieList)
{
	bool bResult = true;
	for ( CXMLCookie::iterator Iter = oCookieList.begin( ); Iter != oCookieList.end( ); Iter++ )
	{							
		//get cookie 
		CXMLCookie oXMLCookie = *Iter;				

		//now add inside H2G2 node
		bResult = bResult & SetCookie(oXMLCookie);
	}

	return bResult;
}

/*********************************************************************************

	bool CWholePage::SetCookie( CXMLCookie oCXMLCookie)

		Author:		DE
        Created:	15/02/2005
        Inputs:		-CXMLCookie oCXMLCookie - cookie to include
        Outputs:	-
        Returns:	-true if OK, false otherwise
        Purpose:	-include cookie-enabling xml on output page
*********************************************************************************/
bool CWholePage::SetCookie( CXMLCookie oXMLCookie)
{
	CTDVString sXML = "";		
	sXML  << "<SETCOOKIE>";		

	//set the cookie's name, can be optional 
	if ( oXMLCookie.GetCookieName( ).IsEmpty( ) == false)
	{
		sXML <<	"<NAME>" + oXMLCookie.GetCookieName( ) + "</NAME>";
	}

	//set the cookie's value
	sXML	<<	"<COOKIE>" + oXMLCookie.GetCookieValue( ) + "</COOKIE>";

	//set whether this is a session cookie
	if ( oXMLCookie.GetIsSessionCookie( ) == true)
	{
		sXML <<	"<MEMORY/>";		
	}

	//set the cookie's domain , can be optional 
	if ( oXMLCookie.GetCookieDomain( ).IsEmpty( ) == false)
	{
		sXML <<	"<DOMAIN>" + oXMLCookie.GetCookieDomain( ) + "</DOMAIN>";
	}	

	//wrap up
	sXML <<	"</SETCOOKIE>";		

	//now add inside H2G2 node
	return AddInside("H2G2", sXML);
}