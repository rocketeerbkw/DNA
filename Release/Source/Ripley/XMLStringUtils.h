// XMLStringUtils.cpp: interface for the CXMLStringUtils class.
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

#ifndef _XMLSTRINGUTILS_H_INCLUDED_
#define _XMLSTRINGUTILS_H_INCLUDED_

#include <vector>
#include "TDVString.h"
#include "InputContext.h"

class CXMLStringUtils
{
public:
	static void AddStrippedNameXML(CStoredProcedure& SP, const char* pFldName, CTDVString& sXML);
	static void AddStrippedNameXML(const char* sName, CTDVString& sXML);
	static bool AppendStatusTag(int iStatus, CTDVString& sXML);
	static void Split(const TDVCHAR* pStringToSplit, const TDVCHAR* pDelim, std::vector<CTDVString>& vResults);
	static void SplitCsvIntoInts(const TDVCHAR* pStringToSplit, std::vector<int>& vResults);
};

#endif
