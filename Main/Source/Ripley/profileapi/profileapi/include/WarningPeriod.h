#ifndef WARNINGPERIOD_H
#define WARNINGPERIOD_H

#include "..\..\bbcutil\include\Str.h"
#include <time.h>
#include <assert.h>
#include "..\..\bbcutil\include\Dll.h"


#define WP_FOREVER	9999


/*********************************************************************************
class CWarningPeriod

Author:		Igor Loboda
Created:	7/1/2003
Purpose:	Stores information about warning levels:duration, next level down
*********************************************************************************/

class DllExport CWarningPeriod
{
	protected:
		unsigned int m_uiTime;
		char m_cType;
		CStr m_DegradeTo;
		
	public:
		CWarningPeriod(unsigned int uiTime, char type, const char* pDegradeTo);
		CWarningPeriod(const CWarningPeriod& wp);
		unsigned int GetTime() const;
		char GetType() const;
		const char* GetDegradeTo() const;
		time_t GetValidTo(time_t startTime);
};


/*********************************************************************************
inline unsigned int CWarningPeriod::GetTime() const

Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	time period for which the warning level should have effect
*********************************************************************************/

inline unsigned int CWarningPeriod::GetTime() const
{
	return m_uiTime;
}


/*********************************************************************************
inline char CWarningPeriod::GetType() const

Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	metrics for time period returnded by GetTime()
*********************************************************************************/

inline char CWarningPeriod::GetType() const
{
	return m_cType;
}


/*********************************************************************************
inline const char* CWarningPeriod::GetDegradeTo() const

Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	warning level this warning level sould degrade to when time period is over.
*********************************************************************************/

inline const char* CWarningPeriod::GetDegradeTo() const
{
	return m_DegradeTo;
}


#endif
