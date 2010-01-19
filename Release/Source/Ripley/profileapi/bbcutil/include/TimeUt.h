#ifndef TIMEUT_H
#define TIMEUT_H

#include <time.h>
#include <Dll.h>


#define TU_BUFF_LEN		20


namespace bbc
{
	
	
	/********************************************************************************* 
	class CTimeUt
	Author:		Igor Loboda
	Created:	12/06/2003
	Purpose:	time utilities
	**********************************************************************************/ 
	
	class DllExport CTimeUt
	{
		public:
			static void GetYMDHMSTimestamp(time_t time, char* pBuffer);
			static time_t YMDHMSToTimeT(const char* pTime);
			static bool TimetToTM(time_t time, struct tm& tmTime);
			static unsigned GetAgeFullYears(const char* pDob);
			static unsigned GetAgeFullYears(const char* pBaseDate, const char* pDob);
			static unsigned GetAgeFullYears(time_t base, const char* pDob);
	};
	
	
};
	
#endif
