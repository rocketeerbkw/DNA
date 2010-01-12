#ifndef MISCUT_H
#define MISCUT_H

#include <Str.h>
#include <stdlib.h>
#include <Dll.h>

namespace bbc
{
	
	
	/********************************************************************************* 
	class CMiscUt
	
	Author:		Igor Loboda
	Created:	4/10/02
	Purpose:	Miscellaneous utilities
	**********************************************************************************/ 
	
	class DllExport CMiscUt
	{
		public:
			static void EscapeXml(const char* str, CStr& escapedStr);
			static bool GenerateGuid32(CStr& sUID);
			static int Randum(int range);
			static const char* CryptPassword(const char *pPassword, const char *pSalt = NULL);
			static void Interleave(const char* pFullString, CStr& interleaved);
			static void Uninterleave(const char* pString, CStr& uninterleaved);
			static void GetClientIP(const char* pRemoteAddr, const char* pForwardedFor, CStr& ip);
	};
}
	
#endif
