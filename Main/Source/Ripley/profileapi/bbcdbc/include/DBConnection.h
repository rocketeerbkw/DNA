/******************
class CDBConnection 

Author:		Michael Ryan, Igor Loboda
Created:	2/08/02
Purpose:	This is an abstract class which defines the minimal interface which should be
			implemented by any database specific class to provide database access.
				Method Do should be used if query does not return result set. Otherwise 
			method ExecuteQuery should be used. Either of these method could return 
			false in case of failure. 
				GetErrorNumber and ErrorMsg could be called to get information
			about last error. Error messages returned by ErrorMsg are first copied to
			the character buffer(member of the instance). Pointer to that buffer is 
			returned by ErrorMsg method. Do not use it after instance is deleted. ErrorMsg
			returns NULL when last operation was successfull.
				LogError logs given error message and additional information if 
			specified to the error log file if file name is provided in configuration 
			object and logging is on (also in cofiguration object).
				EscapeQuery implements database specific query string escaping. Calling 
			environment should allocate memory for escaped query. Amount should be 
			calculated as strlen(srcQuery) * 2 + 1. Method returns number of characters 
			in the escaped query string(excluding null terminator)
*******************/

#ifndef DBCONNECTION_H
#define DBCONNECTION_H

#include "Configuration.h"
#include <Dll.h>

class CDBCursor;

namespace bbcdbc
{
	

class DllExport CDBConnection 
{
	protected:
		char* m_pHostVal;		
		char* m_pUserVal;
		char* m_pPasswdVal;
		char* m_pDBVal;
		char* m_pSocketVal;
		char* m_pLogFileName;
		int m_iPortVal;
		bool m_bIsConnected;
		int m_TransLevel;
		bool m_bRollback;

	public:
		CDBConnection();
		virtual ~CDBConnection();

		virtual int EscapeQuery(char* pDestQuery, const char* pSrcQuery) = 0;
		virtual bool ExecuteQuery(const char *query, CDBCursor& cursor, bool iNullTerminateRS =	true) = 0;
		virtual bool Do(const char *query, unsigned long* pAffectedRows) = 0;
		virtual unsigned long LastInsertId() = 0;
		virtual const char* GetErrorMessage() = 0;
		virtual unsigned long GetErrorNumber() = 0;
		bool IsConnected();
		bool BeginTransaction();
		bool Commit();
		bool Rollback();
		bool TransactionPending();
		void LogError(const char *errorMessage, const char *otherInfo = NULL);

		static char* DupStr(const char* src);	
	
	protected:
		void GetConnectionInformation(CConfiguration& configuration);		
		void ReleaseMemory();	
};


/*********************************************************************************
inline bool CDBConnection::IsConnected()
Author:		Igor Loboda
Created:	05/06/2003
Visibility:	public
Returns:	true if there is a connection established
*********************************************************************************/

inline bool CDBConnection::IsConnected()
{
	return m_bIsConnected;
}
}

#endif

