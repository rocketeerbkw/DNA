//////////////////////////////////////////////////////////////////////
// URLFilterAdminBuilder.h: interface for the CURLFilterAdminBuilder class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2006.

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

#if !defined(AFX_URLFILTERADMINBUILDER_H__7186C5E7_090E_4C9C_B47D_C2905840C297__INCLUDED_)
#define AFX_URLFILTERADMINBUILDER_H__7186C5E7_090E_4C9C_B47D_C2905840C297__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

/*********************************************************************************
class:	CURLFilterAdminBuilder

This class handles the builder for admin page for the allowed urls filter

		Author:		Steve Francis
        Created:	04/05/2005
        Inputs:		Input Context
*********************************************************************************/

class CURLFilterAdminBuilder : public CXMLBuilder
{
public:
	CURLFilterAdminBuilder(CInputContext& inputContext);
	virtual ~CURLFilterAdminBuilder(void);
	virtual bool Build(CWholePage* pPage);
protected:
	CWholePage* m_pPage;

};
#endif // !defined(AFX_URLFILTERADMINBUILDER_H__7186C5E7_090E_4C9C_B47D_C2905840C297__INCLUDED_)
