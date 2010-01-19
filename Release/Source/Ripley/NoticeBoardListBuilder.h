// NoticeBoardListBuilder.h: interface for the CNoticeBoardListBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_NOTICEBOARDLISTBUILDER_H__CB189117_3F2B_4536_983E_E28341265DF2__INCLUDED_)
#define AFX_NOTICEBOARDLISTBUILDER_H__CB189117_3F2B_4536_983E_E28341265DF2__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CNoticeBoardListBuilder : public CXMLBuilder  
{
public:
	CNoticeBoardListBuilder(CInputContext& inputContext);
	virtual ~CNoticeBoardListBuilder();

public:
	virtual bool Build(CWholePage* pPage);

protected:
	CWholePage* m_pPage;
};

#endif // !defined(AFX_NOTICEBOARDLISTBUILDER_H__CB189117_3F2B_4536_983E_E28341265DF2__INCLUDED_)
