#pragma once
#include "xmlbuilder.h"

class CStatsBuilder :
	public CXMLBuilder
{
public:
	CStatsBuilder(CInputContext& inputContext);
	bool Build(CWholePage* pWholePage);

public:
	virtual ~CStatsBuilder(void);
};
