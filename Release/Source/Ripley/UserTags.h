#pragma once
#include "xmlobject.h"

class CUserTags :
	public CXMLObject
{
public:
	CUserTags(CInputContext& inputContext);
	virtual ~CUserTags(void);
	bool GetUserTags(void);
};
