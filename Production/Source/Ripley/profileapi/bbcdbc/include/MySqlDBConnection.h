/******************
class CMySqlDBConnection : public CDBConnection

Author:		Michael Ryan, Igor Loboda
Created:	2/08/02
Purpose:	MySQL specific implementation of CDBConnection class. Constructor tries
			to establish connection to MySQL database using connection parameters
			provided in CConfiguration instance passed as a parameter to constructor.
			Throws an exception if can't connect. See CDBConnection.
*******************/

#ifndef MYSQLDBCONNECTION_H
#define MYSQLDBCONNECTION_H

#include "mysql\include\mysql.h"
#include "DBConnection.h"
#include <string.h>
#include <assert.h>
#include <Dll.h>

class CConfiguration;

class DllExport CMySqlDBConnection : public bbcdbc::CDBConnection
{
	protected:
		MYSQL* m_pConnPtr;

	public:
		CMySqlDBConnection();
		~CMySqlDBConnection();

				
		bool Connect(CConfiguration& conf, unsigned int uiFlags = CLIENT_FOUND_ROWS);
		void Disconnect();
		
		int EscapeQuery(char* pDestQuery, const char* pSrcQuery);
		bool ExecuteQuery(const char *query, CDBCursor& cursor, bool iNullTerminateRS = true);
		bool Do(const char *query, unsigned long* pAffectedRows);
		unsigned long LastInsertId();
		const char* GetErrorMessage();
		unsigned long GetErrorNumber();
};

#endif
