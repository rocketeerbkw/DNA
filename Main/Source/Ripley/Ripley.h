// Ripley.h: interface for the CRipley class.
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


#if !defined(AFX_RIPLEY_H__03E3D46B_E4A0_11D3_89E5_00104BF83D2F__INCLUDED_)
#define AFX_RIPLEY_H__03E3D46B_E4A0_11D3_89E5_00104BF83D2F__INCLUDED_

#include "CGI.h"
#include "XMLBuilder.h"
#include "XMLTransformer.h"

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class CRipley  
{
public:
	void Initialise();
	virtual bool HandleRequest(CGI* pCgi);
	CRipley();
	virtual ~CRipley();

	bool AlwaysClearTemplates();
	static CXMLBuilder* GetBuilder(CGI* pCGI);

protected:
	void CreateOldStyleSiteXML(CTDVString& sXML, CGI* pCGI, CWholePage& ThisPage);
	void CreateNewStyleSiteXML(CTDVString& sXML, CGI* pCGI);

	CXMLTree* m_pConfigData;

	CXMLTransformer* GetTransformer(CGI* pCGI);
};

#endif // !defined(AFX_RIPLEY_H__03E3D46B_E4A0_11D3_89E5_00104BF83D2F__INCLUDED_)
