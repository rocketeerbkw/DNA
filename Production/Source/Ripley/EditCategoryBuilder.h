// UserDetailsPageBuilder.h: interface for the CUserDetailsPageBuilder class.
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


#if !defined(_EDITCATEGORYBUILDER_H__INCLUDED_)
#define _EDITCATEGORYBUILDER_H__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "WholePage.h"

class CEditCategory;

class CEditCategoryBuilder : public CXMLBuilder  
{
public:
	CEditCategoryBuilder(CInputContext& inputContext);
	virtual ~CEditCategoryBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
	virtual bool ProcessAction(const CTDVString sAction,int iActiveNode,int iNodeID,int &iDestinationNodeID, CEditCategory * const pEditCategory,CWholePage* pPage,bool& bActionProcessed);

	int m_iTagMode;
};

#endif // !defined(_EDITCATEGORYBUILDER_H__INCLUDED_)
