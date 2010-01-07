// ModBillingBuilder.h: interface for the CModBillingBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MODBILLINGBUILDER_H__C4B01B46_79BE_4A97_837D_9FF9488ABE9A__INCLUDED_)
#define AFX_MODBILLINGBUILDER_H__C4B01B46_79BE_4A97_837D_9FF9488ABE9A__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CModBillingBuilder : public CXMLBuilder  
{
public:
	virtual bool Build(CWholePage* pPage);
	CModBillingBuilder(CInputContext& inputContext);
	virtual ~CModBillingBuilder();

};

#endif // !defined(AFX_MODBILLINGBUILDER_H__C4B01B46_79BE_4A97_837D_9FF9488ABE9A__INCLUDED_)
