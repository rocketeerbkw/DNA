#ifndef STRUT_H
#define STRUT_H

#include <string>
#include <ctype.h>
#include <Dll.h>

using namespace std;
#ifdef WIN32
#define strcasecmp _stricmp
#endif

namespace bbc
{
	/********************************************************************************* 
	class CStrUt
	
	Author:		Igor Loboda
	Created:	4/10/02
	Purpose:	String utilities
	*********************************************************************************/ 
	class DllExport CStrUt
	{
		public:
			enum {CH_ALNUM = 0x01, CH_AL = 0x02, CH_NUM = 0x04, CH_PUNCT = 0x08};
				
		public:
			static bool StartsWith(const char* pStr, const char* pStart);
			static char* Trim(char* pStr);
			static void Trim(const char* pStr, string& trimmedStr);
			static void TokenToTheLeft(const char* pStart, const char* pPosition, unsigned uType, 
				const char* pAccept, string& token);
			static bool IsOfType(char character, unsigned uType, const char* pAccept);	
			static char* SkipWS(char* pStr);
			static const char* SkipWS(const char* pStr);
			static void Assign(string& str, const char* pStr);
			static bool IsEmptyOrWhitespaceString(const char* pStr);
			static int CompareCaseInsensitive(const char *string1, const char *string2);	
	};

	/******************************************************************************** 
	void CStrUt::Assign(string& str, const char* pStr);
	
	Author:		Igor Loboda
	Created:	2/12/02
	Inputs:		pStr - string to assign to str
	Outputs:	str - resulting string object
	Purpose:	assignes "" to str if pStr is NULL and pStr otherwise
	*********************************************************************************/ 
	inline void CStrUt::Assign(string& str, const char* pStr)
	{
		str = (pStr ? pStr : "");
	}

	/********************************************************************************* 
	static inline int CStrUt::CompareCaseInsensitive(const char* pStr1, const char* pStr2)
	Author:		Igor Loboda
	Created:	25/06/03
	Inputs:		pStr1 - string one
				pStr2 - string two
	Returns:	see strcasecmp or _stricmp
	Purpose:	performs case insensitive comparison
	*********************************************************************************/
	inline int CStrUt::CompareCaseInsensitive(const char* pStr1, const char* pStr2)
	{
		return strcasecmp(pStr1, pStr2);
	}
}

#endif
