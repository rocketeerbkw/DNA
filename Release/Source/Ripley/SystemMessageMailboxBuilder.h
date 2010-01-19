#pragma once
#include "XMLBuilder.h"

class CSystemMessageMailboxBuilder :	public CXMLBuilder
{
public:
	CSystemMessageMailboxBuilder(CInputContext& inputContext);
	virtual ~CSystemMessageMailboxBuilder(void);

public:
	virtual bool Build(CWholePage* pPage);

};
