// OutputContext.h: interface for the COutputContext class.
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


#if !defined(AFX_OUTPUTCONTEXT_H__98589425_E605_11D3_89EB_00104BF83D2F__INCLUDED_)
#define AFX_OUTPUTCONTEXT_H__98589425_E605_11D3_89EB_00104BF83D2F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLCookie.h"
class CGI;


class COutputContext
{
public:
	void LogTimerEvent(const TDVCHAR* pMessage);
	void SetHeader(const TDVCHAR* pHeader);
	bool SendRedirect(const TDVCHAR* pLocation);

	void SendRedirectWithCookies(const TDVCHAR* pLocation, CXMLCookie::CXMLCookieList oCookieList);

	bool SendAbsoluteRedirect(const TDVCHAR* pLocation);
	void ClearCookie();
	void SetCookie(const TDVCHAR* pCookie, bool bMemoryCookie = false, const TDVCHAR* pCookieName = NULL, const TDVCHAR* pCookieDomain = NULL);	
	void SetMimeType(const TDVCHAR* pType);
	COutputContext(CGI* pCGI);
	virtual ~COutputContext();
	void SendOutput(const TDVCHAR* pString);
	bool SendPicture(const TDVCHAR* sServerName, const TDVCHAR* sPath, const TDVCHAR* sMimeType);	
protected:
	CGI* m_pCGI;
};

#endif // !defined(AFX_OUTPUTCONTEXT_H__98589425_E605_11D3_89EB_00104BF83D2F__INCLUDED_)
