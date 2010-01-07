// OutputContext.cpp: implementation of the COutputContext class.
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
#include "CGI.h"
#include "OutputContext.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

COutputContext::COutputContext(CGI* pCGI) : m_pCGI(pCGI)
{
	// No further construction
}

COutputContext::~COutputContext()
{

}

/*********************************************************************************

	void COutputContext::SendOutput(const TDVCHAR *pString)
																			 ,
	Author:		Jim Lynn, Kim Harries, Oscar Gillesbie, Shim Young, Sean Solle
	Created:	17/02/2000
	Inputs:		pString - ptr to string to send to the output
	Outputs:	-
	Returns:	-
	Purpose:	Sends output to the client in some strange, platform dependent
				way. Can be called multiple times. If headers were defined they
				are sent first, so the SetHeader and SetCookie functions cannot
				be called after this function is called.

*********************************************************************************/

void COutputContext::SendOutput(const TDVCHAR *pString)
{
	m_pCGI->SendOutput(pString);
}

void COutputContext::SetMimeType(const TDVCHAR *pType)
{
	m_pCGI->SetMimeType(pType);
}

/*********************************************************************************

	void COutputContext::SendPicture()

	Author:		Oscar Gillespie
	Created:	15/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Sends a picture to the client in some strange, platform dependent
				way. Can be called multiple times. If headers were defined they
				are sent first, so the SetHeader and SetCookie functions cannot
				be called after this function is called.

*********************************************************************************/

bool COutputContext::SendPicture(const TDVCHAR* sServerName, const TDVCHAR* sPath, const TDVCHAR* sMimeType)
{
	return m_pCGI->SendPicture(sServerName, sPath, sMimeType);
}

void COutputContext::SetCookie(const TDVCHAR* pCookie, bool bMemoryCookie, const TDVCHAR* pCookieName, const TDVCHAR* pCookieDomain)
{
	m_pCGI->SetCookie(pCookie, bMemoryCookie, pCookieName, pCookieDomain);
}

void COutputContext::ClearCookie()
{
	m_pCGI->ClearCookie();
}

bool COutputContext::SendRedirect(const TDVCHAR *pLocation)
{
	return m_pCGI->SendRedirect(pLocation);
}

bool COutputContext::SendAbsoluteRedirect(const TDVCHAR *pLocation)
{
	return m_pCGI->SendAbsoluteRedirect(pLocation);
}

void COutputContext::SetHeader(const TDVCHAR* pHeader)
{
	m_pCGI->SetHeader(pHeader);
}

void COutputContext::LogTimerEvent(const TDVCHAR* pMessage)
{
	m_pCGI->LogTimerEvent(pMessage);
}

/*********************************************************************************

	void COutputContext::SendRedirectWithCookies(const TDVCHAR* pLocation, CXMLCookie::CXMLCookieList oCookieList)

		Author:		DE
        Created:	15/02/2005
        Inputs:		-const TDVCHAR* pLocation - page to redirect to 
						-CXMLCookie::CXMLCookieList oCookieList - list of cookies to pass back to client
        Outputs:	-Causes redirection
        Returns:	-true if successful, false otherwise
        Purpose:	-Sends a redirect (302) + cookies to the client redirecting to the location	provided.
*********************************************************************************/
void COutputContext::SendRedirectWithCookies(const TDVCHAR* pLocation, CXMLCookie::CXMLCookieList oCookieList)
{
	m_pCGI->SendRedirectWithCookies(pLocation, oCookieList);
}