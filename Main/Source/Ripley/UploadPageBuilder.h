// UploadPageBuilder.h: interface for the CUploadPageBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_UPLOADPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_)
#define AFX_UPLOADPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CUploadPageBuilder : public CXMLBuilder 
{
public:
	CUploadPageBuilder(CInputContext& inputContext);
	virtual ~CUploadPageBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
};

#endif // !defined(AFX_UPLOADPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_)
