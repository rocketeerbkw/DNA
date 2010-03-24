
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

#include "stdafx.h"
#include "TDVString.h"
#include "tdvassert.h"


#ifdef _DEBUG
void LogError(LPCTSTR pErrMess, LPCTSTR pFile, int lineno)
{
	char errmess[256];
	strncpy(errmess,pErrMess,255);
	errmess[255]=0;

	char output[4096];
	const char* pOut = output;

	sprintf(output, "Assertion failed: %s in %s at line %d",errmess, pFile, lineno);
	
	HANDLE hEventLog = OpenEventLog(NULL, // pointer to server name 
									"h2g2server"); // pointer to source name 

	// Check to see if we have access to the report logs
	if (GetLastError() != ERROR_ACCESS_DENIED)
	{
		LPCTSTR *lpStrings = &pOut;
		LPVOID lpRawData = (LPVOID)&output;

		// Write the event out to the log.
		ReportEvent( hEventLog,  // handle returned by RegisterEventSource 
							EVENTLOG_ERROR_TYPE,		// event type to log 
							42,			// event category source-specific information - can have any value
							42,			// DWORD dwEventID, event identifier 
 							NULL,		// user security identifier (optional) 
							1,			// number of strings to merge with message 
 							0,			// size of binary data, in bytes 
							lpStrings,	// array of strings to merge with message
							lpRawData	// address of binary data 
						); 

		CloseEventLog(hEventLog);
	}

	OutputDebugString(pOut);
	OutputDebugString("\r\n");
}

#endif

/*********************************************************************************

	void AddToEventLog(const TDVCHAR* pMsg, int nEventType)

		Author:		Mark Neves
        Created:	20/07/2005
        Inputs:		pMsg = the message to appear in Event application log
					nEventType = one of the following:
						EVENTLOG_SUCCESS
						EVENTLOG_ERROR_TYPE
						EVENTLOG_WARNING_TYPE
						EVENTLOG_INFORMATION_TYPE
						EVENTLOG_AUDIT_SUCCESS
						EVENTLOG_AUDIT_FAILURE
        Outputs:	-
        Returns:	-
        Purpose:	Puts a message into the application event log.

					**** USE WITH EXTREME CAUTION ****

					Only ever enter something into the event log if you know it will
					benefit diagnosing problems with DNA on the live site.

					Never add calls to this if it's going to be called frequently, as 
					adding entries to the app log is very expensive.

*********************************************************************************/

void AddToEventLog(const TDVCHAR* pMsg, int nEventType,int nEventID)
{
	HANDLE hEventLog = ::OpenEventLog(NULL, // pointer to server name 
									"h2g2server"); // pointer to source name 

	// Check to see if we have access to the report logs
	if (GetLastError() != ERROR_ACCESS_DENIED && hEventLog > 0)
	{
		LPCTSTR *lpStrings = (LPCTSTR*)&pMsg;
		LPVOID lpRawData = (LPVOID)(LPCTSTR)pMsg;

		// Write the event out to the log.
		::ReportEvent( hEventLog,  // handle returned by RegisterEventSource 
							nEventType,	// event type to log 
							43,			// event category source-specific information - can have any value
							nEventID,	// DWORD dwEventID, event identifier 
 							NULL,		// user security identifier (optional) 
							1,			// number of strings to merge with message 
 							0,			// size of binary data, in bytes 
							lpStrings,	// array of strings to merge with message
							lpRawData	// address of binary data 
						); 

		::CloseEventLog(hEventLog);
	}

#ifdef _DEBUG
	OutputDebugString(pMsg);
	OutputDebugString("\r\n");
#endif //_DEBUG
}
