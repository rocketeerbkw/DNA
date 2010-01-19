// PostcodeBuilder.h: interface for the CPostcodeBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_POSTCODEBUILDER_H__A7DA7BE3_6EFD_4BCE_A222_8C391D2176ED__INCLUDED_)
#define AFX_POSTCODEBUILDER_H__A7DA7BE3_6EFD_4BCE_A222_8C391D2176ED__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CPostcodeBuilder : public CXMLBuilder  
{
public:
	static CTDVString GetPostcodeFromCookie();

	virtual bool Build(CWholePage* pPage);
	CPostcodeBuilder(CInputContext& inputContext);
	virtual ~CPostcodeBuilder();
};

#endif // !defined(AFX_POSTCODEBUILDER_H__A7DA7BE3_6EFD_4BCE_A222_8C391D2176ED__INCLUDED_)
