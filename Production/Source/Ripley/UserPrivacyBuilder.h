#pragma once
#include "XMLBuilder.h"

class CUserPrivacyBuilder :	public CXMLBuilder
{
public:
	CUserPrivacyBuilder(CInputContext& inputContext);
	virtual ~CUserPrivacyBuilder(void);

public:
	virtual bool Build(CWholePage* pPage);

};
