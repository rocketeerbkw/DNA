#pragma once

#include "TDVString.h"

class CEmailAddressFilter
{
public:
	CEmailAddressFilter(void);
	~CEmailAddressFilter(void);

	bool CEmailAddressFilter::CheckForEmailAddresses( const TDVCHAR *pCheckString );
};
