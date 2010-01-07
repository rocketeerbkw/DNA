#pragma once
#include "xmlobject.h"

class CModerationClasses :
	public CXMLObject
{
public:
	CModerationClasses(CInputContext& inputContext);
	virtual ~CModerationClasses(void);
	bool GetModerationClasses(void);
};
