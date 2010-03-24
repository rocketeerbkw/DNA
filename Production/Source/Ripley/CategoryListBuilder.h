#pragma once
#include ".\xmlbuilder.h"

class CCategoryListBuilder : public CXMLBuilder
{
public:
	CCategoryListBuilder(CInputContext& inputContext);
	virtual ~CCategoryListBuilder(void);

public:
	virtual bool Build(CWholePage* pPage);

	enum eCatListViewMode
	{
		CLVM_NODES,
		CLVM_LISTS
	};
};
