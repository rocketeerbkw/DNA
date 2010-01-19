// WholePage.h: interface for the CWholePage class.
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


#if !defined(AFX_WHOLEPAGE_H__E0A3D423_EF6A_11D3_BD69_00A02480D5F4__INCLUDED_)
#define AFX_WHOLEPAGE_H__E0A3D423_EF6A_11D3_BD69_00A02480D5F4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "xmlcookie.h"

/*
	class CWholePage

	Author:		Oscar Gillespie
	Created:	01/03/2000
	Inherits:	CXMLObject
	Purpose:	A kind of XMLObject that represents some H2G2 page.
				Ripley uses this class as a kind of container for passing
				XML pages around between the chosen Builder, the handleRequest,
				and the chosen Transformer.

*/

class CWholePage : public CXMLObject  
{
public:
	virtual bool GetAsString(CTDVString& sResult);
	bool SetError(const TDVCHAR* pError);
	bool SetPageType(const TDVCHAR* pType);
	bool GetPageType(CTDVString& sResult);
	CWholePage(CInputContext& inputContext);
	virtual ~CWholePage();

	bool Initialise();
	bool Redirect(const TDVCHAR* pRedirectPage);
	bool RedirectWithCookies(const TDVCHAR* pRedirectPage, CXMLCookie::CXMLCookieList oCookieList);
	bool SetCookie( CXMLCookie oXMLCookie);
	bool SetCookies( CXMLCookie::CXMLCookieList oCookieList);
protected:
	virtual CXMLTree* ExtractTree();
	void RemoveParam(CTDVString& sParams, const TDVCHAR* pParamToRemove);
};

#endif // !defined(AFX_WHOLEPAGE_H__E0A3D423_EF6A_11D3_BD69_00A02480D5F4__INCLUDED_)
