#pragma once
#include "xmlobject.h"

class CModTriggers :
	public CXMLObject
{
public:
	CModTriggers(CInputContext& inputContext);
	bool GetModTriggers();
public:
	virtual ~CModTriggers(void);
};
