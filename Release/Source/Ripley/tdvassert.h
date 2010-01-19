/*
TDVASSERT

ISAPI-specific assert handler for logging debug errors

*/


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

#if !defined(INC_TDV_ASSERT_H_ABCDEF_)
#define INC_TDV_ASSERT_H_ABCDEF_

#ifdef _DEBUG

	void LogError(LPCTSTR pErrMess, LPCTSTR pFile, int lineno);

// DEBUGMESSAGE - sends a message to the debugger - outputdebugstring
// LOGDEBUGMESSAGE - write a message to the event log - debug only
// LOGINFOMESSAGE - available in production code - logs a message for informational purposes

#define TDVASSERT(cond,mess)	if (!(cond)) { LogError(mess, __FILE__, __LINE__);}


#else
#define TDVASSERT(cond,mess)
#endif

#include "TDVString.h"

#define DNA_EVENTLOGID_DATABASEWATCHDOG 1

void AddToEventLog(const TDVCHAR* pMsg, int nEventType, int nEventID);

#endif // !defined(INC_TDV_ASSERT_H_ABCDEF_)
