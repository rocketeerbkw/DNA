// ReservedArticlesBuilder.h: interface for the CReservedArticlesBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_RESERVEDARTICLESBUILDER_H__B76FE8C9_F3A0_483D_8894_3B36669BA163__INCLUDED_)
#define AFX_RESERVEDARTICLESBUILDER_H__B76FE8C9_F3A0_483D_8894_3B36669BA163__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CReservedArticlesBuilder : public CXMLBuilder  
{
public:
	virtual bool Build(CWholePage* pPage);
	CReservedArticlesBuilder(CInputContext& inputContext);
	virtual ~CReservedArticlesBuilder();

};

#endif // !defined(AFX_RESERVEDARTICLESBUILDER_H__B76FE8C9_F3A0_483D_8894_3B36669BA163__INCLUDED_)
