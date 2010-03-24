// HTMLTransformer.h: interface for the CHTMLTransformer class.
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


#if !defined(AFX_HTMLTRANSFORMER_H__0CC07E85_EE07_11D3_86F8_00A024998768__INCLUDED_)
#define AFX_HTMLTRANSFORMER_H__0CC07E85_EE07_11D3_86F8_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLTransformer.h"
#include "XMLCookie.h"

/*
	class CHTMLTransformer

	Author:		Kim Harries
	Created:	29/02/2000
	Inherits:	CXMLTransformer
	Purpose:	Subclass of CXMLTransformer which outputs HTML.
				Currently only deals with simple article pages only.

*/

class CHTMLTransformer : public CXMLTransformer  
{
public:
	CHTMLTransformer(CInputContext& inputContext, COutputContext* pOutputContext);
	virtual ~CHTMLTransformer();
	virtual bool Output(CWholePage* pWholePage, const TDVCHAR* pCacheName, const TDVCHAR* pItemName);

	virtual bool IsHTMLTransformer() { return true; }

private:
	CTDVString GetSkinMIMEType();
	CTDVString GetRealSkinName();
	CTDVString GetStylesheetHomePath();
	bool TestFileExists(const CTDVString& sFile);
	CTDVString GetStylesheet();
	CTDVString GetErrorPage();	
	bool ProcessCookies( CWholePage* pWholePage, CXMLCookie::CXMLCookieList* pCookieList = NULL );
	bool AddTransformTime(CTDVString& sOutput,long lTimeTaken);
};

#endif // !defined(AFX_HTMLTRANSFORMER_H__0CC07E85_EE07_11D3_86F8_00A024998768__INCLUDED_)
