#pragma once
#include "xmlobject.h"

class CUsersTags :
	public CXMLObject
{
public:
	CUsersTags(CInputContext& inputContext);
	virtual ~CUsersTags(void);
};
