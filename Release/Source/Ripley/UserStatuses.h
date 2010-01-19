#pragma once
#include "xmlobject.h"

class CUserStatuses :
	public CXMLObject
{
public:
    enum Status
    {
        STANDARD,
        PREMODERATED,
        POSTMODERATED,
        SENDFORREVIEW,
        RESTRICTED
    };

	CUserStatuses(CInputContext& inputContext);
	virtual ~CUserStatuses(void);

	bool GetUserStatuses();

    static CTDVString GetDescription( int StatusId );
};
