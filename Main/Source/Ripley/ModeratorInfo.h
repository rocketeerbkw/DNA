#pragma once
#include "xmlobject.h"
#include <vector>

class CModeratorInfo :
	public CXMLObject
{
public:
	CModeratorInfo(CInputContext& inputContext);
	virtual ~CModeratorInfo(void);
	bool GetModeratorInfo(int iUserId);
	bool GetModeratorClasses(std::vector<int>& moderatorClasses);

protected:
	std::vector<int> m_vecModeratorClasses;
};
