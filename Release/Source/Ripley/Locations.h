#pragma once
#include "xmlobject.h"

class CLocations :
	public CXMLObject
{
public:
	CLocations(CInputContext& inputContext);
	~CLocations(void);

	bool GetEntryLocations(int h2g2id);
	bool HasLocations();

private:
	bool m_bHasLocations;
};
