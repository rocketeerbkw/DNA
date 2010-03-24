// SignalBuilder.h: interface for the CSignalBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_SIGNALBUILDER_H__BE5E6BB9_4246_4969_9061_D87EFE1793DF__INCLUDED_)
#define AFX_SIGNALBUILDER_H__BE5E6BB9_4246_4969_9061_D87EFE1793DF__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CSignalBuilder : public CXMLBuilder  
{
public:
	virtual bool Build(CWholePage* pPage);
	CSignalBuilder(CInputContext& inputContext);
	virtual ~CSignalBuilder();

};

#endif // !defined(AFX_SIGNALBUILDER_H__BE5E6BB9_4246_4969_9061_D87EFE1793DF__INCLUDED_)
