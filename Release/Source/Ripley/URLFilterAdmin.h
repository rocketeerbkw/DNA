//////////////////////////////////////////////////////////////////////
// URLFilterAdmin.h: interface for the CURLFilterAdmin class.
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
#if !defined(AFX_URLFILTERADMIN_H__1462C4C0_E28C_407C_AB7C_C43C349887AB__INCLUDED_)
#define AFX_URLFILTERADMIN_H__1462C4C0_E28C_407C_AB7C_C43C349887AB__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "URLFilterList.h"

class CURLFilterAdmin : public CXMLObject
{
public:
	CURLFilterAdmin(CInputContext& inputContext);
	virtual ~CURLFilterAdmin(void);

	bool Create(const TDVCHAR* pAction);

	void AddInsideSelf(const TDVCHAR* pXML);
	void AddInsideSelf(CXMLObject* objectToAdd);
	
	bool ProcessAllowedURLs(void);
	bool AddAllowedURL(void);
	bool ImportURLFilterList(void);

protected:
	void Clear();

	CURLFilterList m_URLFilterList;
};

/*********************************************************************************
inline void CProfanityAdmin::AddInsideSelf(const TDVCHAR* pXML)
Author:		Steven Francis
Created:	05/05/2006
Purpose:	Adds string to top URLFILTERADMIN node
*********************************************************************************/
inline void CURLFilterAdmin::AddInsideSelf(const TDVCHAR* pXML)
{
	AddInside("URLFILTERADMIN", pXML);
}


/*********************************************************************************
inline void AddInsideSelf(const TDVCHAR* pXML)
Author:		Steven Francis
Created:	05/05/2006
Purpose:	Adds string to top URLFILTERADMIN node
*********************************************************************************/
inline void CURLFilterAdmin::AddInsideSelf(CXMLObject* objectToAdd)
{
	AddInside("URLFILTERADMIN", objectToAdd);
}

#endif // !defined(AFX_URLFILTERADMIN_H__1462C4C0_E28C_407C_AB7C_C43C349887AB__INCLUDED_)
