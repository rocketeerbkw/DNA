// FixExtraInfoBuilder.h: interface for the CFixExtraInfoBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_FixExtraInfoBuilder_H__364302F1_EE1B_4DCB_9D82_853687F560B7__INCLUDED_)
#define AFX_FixExtraInfoBuilder_H__364302F1_EE1B_4DCB_9D82_853687F560B7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CFixExtraInfoBuilder  : public CXMLBuilder
{
public:
	CFixExtraInfoBuilder(CInputContext& inputContext);
	virtual ~CFixExtraInfoBuilder();

public:
	virtual bool Build(CWholePage* pPage);

protected:
	CWholePage* m_pPage;
};

#endif // !defined(AFX_FixExtraInfoBuilder_H__364302F1_EE1B_4DCB_9D82_853687F560B7__INCLUDED_)
