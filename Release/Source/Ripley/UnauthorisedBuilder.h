#pragma once
#include "xmlbuilder.h"

class CUnauthorisedBuilder :
	public CXMLBuilder
{
public:
	CUnauthorisedBuilder(CInputContext& inputContext);
	virtual ~CUnauthorisedBuilder(void);
	virtual bool Build(CWholePage* pPage);
	void DoBuild(CWholePage* pPage);
};
