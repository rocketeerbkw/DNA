// SiteOpenCloseTime.h: interface for the CSiteOpenCloseTime class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/

#include "TDVDateTime.h"

class CSiteOpenCloseTime
{
public:
	CSiteOpenCloseTime();
	CSiteOpenCloseTime(int pDayWeek, int pHour, int pMinute, int pClosed);
	virtual ~CSiteOpenCloseTime();

	bool HasAlreadyHappened(CTDVDateTime dDate, bool& bHasAlreadyHappened);
	bool GetAsXMLString(CTDVString& sXML);

	int GetDayWeek();
	int GetHour();
	int GetMinute();
	int GetClosed();

protected:
	int mDayWeek;
	int mHour;
	int mMinute;
	int mClosed;
};
