// ManageLinksBuilder.h: interface for the CManageLinksBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MANAGELINKSBUILDER_H__B76FE8C9_F3A0_483D_8894_3B36669BA163__INCLUDED_)
#define AFX_MANAGELINKSBUILDER_H__B76FE8C9_F3A0_483D_8894_3B36669BA163__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CManageLinksBuilder : public CXMLBuilder  
{
public:
	virtual bool Build(CWholePage* pPage);
	CManageLinksBuilder(CInputContext& inputContext);
	virtual ~CManageLinksBuilder();

};

#endif // !defined(AFX_MANAGELINKSBUILDER_H__B76FE8C9_F3A0_483D_8894_3B36669BA163__INCLUDED_)
