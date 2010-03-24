#pragma once
#include ".\xmlbuilder.h"
#include ".\inputcontext.h"

class CMemberDetailsPageBuilder :
	public CXMLBuilder
{
public:
	CMemberDetailsPageBuilder(CInputContext& inputContext);
	virtual ~CMemberDetailsPageBuilder(void);

	virtual bool Build(CWholePage* pPage);
};
