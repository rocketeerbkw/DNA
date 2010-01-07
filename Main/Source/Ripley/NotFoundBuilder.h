// NotFoundBuilder.h: interface for the CNotFoundBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_NOTFOUNDBUILDER_H__9A77EC7D_0CE1_40D9_8C45_C6DF9B0D366E__INCLUDED_)
#define AFX_NOTFOUNDBUILDER_H__9A77EC7D_0CE1_40D9_8C45_C6DF9B0D366E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CNotFoundBuilder : public CXMLBuilder  
{
public:
	virtual bool Build(CWholePage* pPage);
	CNotFoundBuilder(CInputContext& inputContext);
	virtual ~CNotFoundBuilder();

};

#endif // !defined(AFX_NOTFOUNDBUILDER_H__9A77EC7D_0CE1_40D9_8C45_C6DF9B0D366E__INCLUDED_)
