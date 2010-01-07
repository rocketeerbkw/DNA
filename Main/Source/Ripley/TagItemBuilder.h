// TagItemBuilder.h: interface for the CTagItemBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_TAGITEMBUILDER_H__E8AC59CA_82FF_4319_849B_8877F662D2A3__INCLUDED_)
#define AFX_TAGITEMBUILDER_H__E8AC59CA_82FF_4319_849B_8877F662D2A3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "TagItem.h"
#include "TDVAssert.h"

class CTagItemBuilder : public CXMLBuilder  
{
public:
	CTagItemBuilder(CInputContext& inputContext);
	virtual ~CTagItemBuilder();

public:
	virtual bool Build(CWholePage* pPage);

	enum eTagMode
	{
		TAGMODE_ADD = 1,
		TAGMODE_MOVE = 2,
		TAGMODE_REMOVE = 3
	};

protected:
	bool AddToMultipleNodes(CTagItem& TagItem);
protected:
	CWholePage* m_pPage;
};

#endif // !defined(AFX_TAGITEMBUILDER_H__E8AC59CA_82FF_4319_849B_8877F662D2A3__INCLUDED_)
