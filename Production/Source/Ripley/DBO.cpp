// DBO.cpp: implementation of the DBO class.
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
  


#include "stdafx.h"
#pragma warning(disable:4786)
#include <atlbase.h>
#include <afxdisp.h>
#include "tdvassert.h"

//#include <Odbcss.h>
#pragma warning(disable:4786)
#include "DBO.h"
#include "config.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW

#define __FLAGFIELDS 1
#endif

CDBConnection::CDBConnection()
{
}

CDBConnection::CDBConnection(const CDBConnection& other)
{
	m_ConnectionString = other.m_ConnectionString;
}

CDBConnection::~CDBConnection()
{
}

bool CDBConnection::Initialise(const TDVCHAR* pConnString)
{
	m_ConnectionString = pConnString;
	return true;
}

CTDVString CDBConnection::GetConnectionString()
{
	return m_ConnectionString;
}


CMySQLConnection::CMySQLConnection()
{
}

CMySQLConnection::~CMySQLConnection()
{
}

CMySQLConnection::CMySQLConnection(const CMySQLConnection& other)
{
	m_ServerName = other.m_ServerName;
	m_DatabaseName = other.m_DatabaseName;
	m_UserName = other.m_UserName;
	m_Password = other.m_Password;
	m_iPort = other.m_iPort;
}



bool CMySQLConnection::Initialise(const TDVCHAR* pServer, const TDVCHAR* pDatabase, const TDVCHAR* pUsername, const TDVCHAR* pPassword, int iPort)
{
	m_ServerName = pServer;
	m_DatabaseName = pDatabase;
	m_UserName = pUsername;
	m_Password = pPassword;
	m_iPort = iPort;
	return true;
}

const char*CMySQLConnection::GetServer()
{
	return (const char*)m_ServerName;
}

const char*CMySQLConnection::GetDatabase()
{
	return (const char*)m_DatabaseName;
}

const char*CMySQLConnection::GetUsername()
{
	return (const char*)m_UserName;
}

const char*CMySQLConnection::GetPassword()
{
	return (const char*)m_Password;
}

int CMySQLConnection::GetPort()
{
	return m_iPort;
}


/**********************************************************************
DBO::SQLPARAMETER::~SQLPARAMETER

  Author: Martin Robb
  Purpose: Destructor - deletes embedded data buffer too if it is owner 
						( an output parameter will be provided with a buffer ).
**********************************************************************/
DBO::SQLPARAMETER::~SQLPARAMETER()
{ 
	if ( m_bOwnData )
	{
		delete m_pData;
	}
}

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/**********************************************************************
DBO::DBO()

  Author: Jim Lynn
  Inputs: -
  Outputs: -
  Returns: -

  Purpose: Constructor for the database object. Does the necessary DB connections
			and setting up of handles etc, and initialises the internal data structures

**********************************************************************/

DBO::DBO(CDBConnection* pConn) : m_hEnv(SQL_NULL_HANDLE), m_hConn(SQL_NULL_HDBC), m_hStmt(SQL_NULL_HSTMT), m_GoodConnection(true),
	m_bError(false), m_pReturnParam(NULL)
{
	m_Names.clear();
	m_Strings.clear();
	m_Longs.clear();	
	m_Dates.clear();
	m_Doubles.clear();	
	m_Nulls.clear();	
	m_EOF = true;
	

#ifdef __MYSQL__
#else
	// Look in the registry for a connection string
	CTDVString sConn;
	
	if (pConn == NULL)
	{
		char tmp[256];
		char* pConnString = tmp;
		DWORD dwLength = 256;
		DWORD ktype;
		HKEY hRegKey;
		LONG Result = RegOpenKeyEx( HKEY_LOCAL_MACHINE,
		 							"SOFTWARE\\The Digital Village\\h2g2 web server",
									0,						// reserved
									KEY_READ,				// security access mask
									&hRegKey);	// address of handle of open key
		Result = RegQueryValueEx(	hRegKey,
										"connectionstring",
										NULL,		// lpReserved. Reserved; must be NULL. 
										&ktype,
										(LPBYTE)pConnString,
										&dwLength);

		TDVASSERT(Result == ERROR_SUCCESS, "Couldn't open registry keys");

		if (Result != ERROR_SUCCESS)
		{
			return;
		}
		sConn = pConnString;
	}
	else
	{
		sConn = pConn->GetConnectionString();
	}

#endif

#ifdef __MYSQL__

	MYSQL* ptr = mysql_init(&m_mysql);
	CMySQLConnection* pMyConn = (CMySQLConnection*)pConn;
//	m_pconnection = mysql_real_connect(&m_mysql, "localhost", "zarquon", "zarniwoop", "theguide", 3306, NULL, 0);

//	if (mysql_errno(&m_mysql))
//	{
//		CTDVString sErr = mysql_error(&m_mysql);
//		sErr << "!";
//	}
	m_pconnection = mysql_real_connect(&m_mysql, pMyConn->GetServer(), pMyConn->GetUsername(), pMyConn->GetPassword(), pMyConn->GetDatabase(), pMyConn->GetPort(), NULL,0);
	if (m_pconnection == NULL)
	{
		CTDVString sErr = mysql_error(&m_mysql);
		sErr << "!";
	}
	m_pResult = NULL;
	m_Row = NULL;
	if (m_pconnection == NULL)
	{
		m_GoodConnection = false;
	}
#else
	// by default, open a connection
	SQLRETURN rc = SQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, &m_hEnv);
	TDVASSERT(rc == SQL_SUCCESS || rc == SQL_SUCCESS_WITH_INFO, "SQLAllocHandle failed");

	if (rc == SQL_SUCCESS || rc == SQL_SUCCESS_WITH_INFO)
		rc = SQLSetEnvAttr(m_hEnv, SQL_ATTR_ODBC_VERSION, (SQLPOINTER)SQL_OV_ODBC3,0);
	
	TDVASSERT(rc == SQL_SUCCESS || rc == SQL_SUCCESS_WITH_INFO, "SQLSetEnvAttr failed");
	// ODBC connection
	if (rc == SQL_SUCCESS || rc == SQL_SUCCESS_WITH_INFO)
		rc = SQLAllocHandle(SQL_HANDLE_DBC, m_hEnv, &m_hConn);
	TDVASSERT(rc == SQL_SUCCESS || rc == SQL_SUCCESS_WITH_INFO, "SQLAllocHandle failed to create DBC");

	// Turn off pooling of connections if we're told to
	if (_stricmp(theConfig.GetDbPooling(),"false") == 0)
	{
		if (rc == SQL_SUCCESS || rc == SQL_SUCCESS_WITH_INFO)
			rc = SQLSetEnvAttr(NULL, SQL_ATTR_CONNECTION_POOLING, SQL_CP_OFF,0);
	}

	// use a hard-coded connection string to save DSNs
	char sConnOut[1024];
	SQLSMALLINT iCount = 1024;
	if (rc == SQL_SUCCESS || rc == SQL_SUCCESS_WITH_INFO) {
		rc = SQLSetConnectAttr(m_hConn, SQL_ATTR_LOGIN_TIMEOUT, (SQLPOINTER)4, SQL_IS_UINTEGER);
		rc = SQLDriverConnect(m_hConn, NULL, (SQLCHAR*)(const TDVCHAR*)sConn, sConn.GetLength(), (SQLCHAR*)sConnOut, 1024, &iCount, SQL_DRIVER_NOPROMPT);
	}
	TDVASSERT(rc == SQL_SUCCESS || rc == SQL_SUCCESS_WITH_INFO, "SQLDriverConnect failed");

	if (rc == SQL_SUCCESS || rc == SQL_SUCCESS_WITH_INFO)
	{
	//	rc = SQLAllocHandle(SQL_HANDLE_STMT, m_hConn, &m_hStmt);
		m_hStmt = SQL_NULL_HSTMT;
	}
	TDVASSERT(rc == SQL_SUCCESS || rc == SQL_SUCCESS_WITH_INFO, "SQLAllocHandle failed to create STMT");
	
	if (rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO)
	{
		m_GoodConnection = false;
	}
#endif
}

/*********************************************************************************
> DBO::~DBO()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	dtor for DBO object. Frees up all the SQL handles etc.

*********************************************************************************/

DBO::~DBO()
{
	FreeDataBuffers();

	for ( std::vector<SQLPARAMETER*>::iterator iter = m_Parameters.begin(); iter != m_Parameters.end(); ++iter )
	{
		delete *iter;
	}
	m_Parameters.clear();

	delete m_pReturnParam;

#ifdef __MYSQL__
	if (m_pResult != NULL)
	{
		mysql_free_result(m_pResult);
		m_pResult = NULL;
	}
	mysql_close(m_pconnection);
	m_pconnection = NULL;
	// TODO: clean up the Result and Row objects as well.
#else
	SQLRETURN rc;
	if (m_hStmt != SQL_NULL_HSTMT)
	{
		SQLFreeStmt(m_hStmt,SQL_RESET_PARAMS);
		SQLCloseCursor(m_hStmt);
		rc = SQLFreeHandle(SQL_HANDLE_STMT, m_hStmt);
	}

	rc = SQLDisconnect(m_hConn);

	if(rc != SQL_SUCCESS)
	{
		CTDVString sErr;
		sErr << "SQLDisconnect: " << rc;
		TDVASSERT(false, sErr);
	}

	SQLFreeHandle(SQL_HANDLE_DBC, m_hConn);
	SQLFreeHandle(SQL_HANDLE_ENV, m_hEnv);
#endif
}

/*********************************************************************************
> void DBO::StartStoredProcedure(const TDVCHAR* pProcName)

	Author:		Jim Lynn
	Inputs:		pProcName - name of stored procedure
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Tells the dbo object you want to start giving it params
				for a stored procedure. Follow this with calls to AddParam
				and then use ExecuteStoredProcedure to execute the query.

*********************************************************************************/

void DBO::StartStoredProcedure(const TDVCHAR* pProcName)
{
	//m_bFirstProcParam = 1;
	//m_strStoredProcedure = _T("EXEC ");
	//m_strStoredProcedure = _T("{CALL ");
	//m_strStoredProcedure += pProcName;
	//m_strStoredProcedure += _T(" ");
	//m_strStoredProcedure += _T("(");
	StartStoredProcedure2(pProcName);
}

void DBO::StartStoredProcedure2( const TDVCHAR* pProcName )
{
	m_strStoredProcedure = pProcName;

	for ( std::vector<SQLPARAMETER*>::iterator iter = m_Parameters.begin(); iter != m_Parameters.end(); ++iter )
	{
		delete *iter;
	}
	m_Parameters.clear();

	if ( m_pReturnParam )
	{
		delete m_pReturnParam;
		m_pReturnParam = NULL;
	}
}

/*********************************************************************************
> void DBO::AddNullParam()

	Author:		Martin Robb
	Inputs:		None
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Adds a Null Parameter - Adds it as a SQL_C_CHAR.
				All SQL Data types may be converted from a SQL_CHAR.
				The data will be ignored as SQL_NULL_DATA is specified.

*********************************************************************************/
void DBO::AddNullParam( )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = SQL_PARAM_INPUT;
	pparameter->m_ParameterCType = SQL_C_CHAR;
	pparameter->m_SQLType = SQL_CHAR;
	pparameter->m_bOwnData;
	pparameter->m_pData = NULL;
	pparameter->m_bOwnData = false;
	//Non-zero to keep ODBC driver happy, there is however no data as indicated by SQL_NULL_DATA
	pparameter->m_DescLen = 0;	
	pparameter->m_ParamSize = 1;
	pparameter->m_DecimalDigits = 0;
	pparameter->m_DescLenOrInd = SQL_NULL_DATA;
	m_Parameters.push_back(pparameter);
}

/*********************************************************************************
> void DBO::AddNullParam()

	Author:		Martin Robb
	Inputs:		Parameter Name pName
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Adds a Named Null Parameter
				All SQL Data types may be converted from a SQL_CHAR.
				The data will be ignored as SQL_NULL_DATA is specified.

*********************************************************************************/
void DBO::AddNullParam( const TDVCHAR* pName )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = SQL_PARAM_INPUT;
	pparameter->m_ParameterCType = SQL_C_CHAR;
	pparameter->m_SQLType = SQL_CHAR;
	pparameter->m_pData = NULL;
	pparameter->m_DescLen = 0;	//No Data.
	pparameter->m_DescLenOrInd= SQL_NULL_DATA;
	pparameter->m_ParamSize = 1;	//Set Column Size to 1 
	pparameter->m_DecimalDigits = 0;
	pparameter->m_sName << "@" << pName;
	pparameter->m_bOwnData = false;
	m_Parameters.push_back(pparameter);
}


/*********************************************************************************
> void DBO::AddDefaultParam()

	Author:		Martin Robb
	Inputs:		None
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Adds a Default Parameter

*********************************************************************************/
void DBO::AddDefaultParam( )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = SQL_PARAM_INPUT;
	pparameter->m_ParameterCType = SQL_C_DEFAULT;
	pparameter->m_SQLType = SQL_INTEGER;
	pparameter->m_pData = NULL;
	pparameter->m_bOwnData = false;
	pparameter->m_DescLen = 0;
	pparameter->m_ParamSize = 0;
	pparameter->m_DecimalDigits = 0;
	pparameter->m_DescLenOrInd = SQL_DEFAULT_PARAM;
	m_Parameters.push_back(pparameter);
}

/*********************************************************************************
> void DBO::AddDefaultParam()

	Author:		Martin Robb
	Inputs:		Parameter name pName
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Adds a Default named parameter

*********************************************************************************/
void DBO::AddDefaultParam( const TDVCHAR* pName )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = SQL_PARAM_INPUT;
	pparameter->m_ParameterCType = SQL_C_DEFAULT;
	pparameter->m_SQLType = SQL_INTEGER;
	pparameter->m_pData = NULL;
	pparameter->m_DescLen = 0;
	pparameter->m_ParamSize = 0;
	pparameter->m_DecimalDigits = 0;
	pparameter->m_DescLenOrInd= SQL_DEFAULT_PARAM;
	pparameter->m_sName << "@" << pName;
	pparameter->m_bOwnData = false;
	m_Parameters.push_back(pparameter);
}

/*********************************************************************************
> void DBO::AddParam(double)

	Author:		Martin Robb
	Inputs:		parameter value
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Adds a double parameter 

*********************************************************************************/
void DBO::AddParam( double dValue )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = SQL_PARAM_INPUT;
	pparameter->m_ParameterCType = SQL_C_DOUBLE;
	pparameter->m_SQLType = SQL_DOUBLE;
	pparameter->m_pData = new double(dValue);
	pparameter->m_bOwnData = true;
	pparameter->m_DescLen = 0;
	pparameter->m_ParamSize = 0;
	pparameter->m_DecimalDigits = 0;
	pparameter->m_DescLenOrInd = 0;
	m_Parameters.push_back(pparameter);
}

/*********************************************************************************
> void DBO::AddNullParam(double)

	Author:		Martin Robb
	Inputs:		parameter name and value
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Adds a named double parameter

*********************************************************************************/
void DBO::AddParam(const TDVCHAR* pName, double dValue )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = SQL_PARAM_INPUT;
	pparameter->m_ParameterCType = SQL_C_DOUBLE;
	pparameter->m_SQLType = SQL_DOUBLE;
	pparameter->m_pData = new double(dValue);
	pparameter->m_bOwnData = true;
	pparameter->m_DescLen = 0;
	pparameter->m_ParamSize = 0;
	pparameter->m_DecimalDigits = 0;
	pparameter->m_DescLenOrInd = 0;
	pparameter->m_sName << "@" << pName;
	m_Parameters.push_back(pparameter);
}

/*********************************************************************************
> void DBO::AddParam(int)

	Author:		Martin Robb
	Inputs:		None
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Adds an integer parameter

*********************************************************************************/
void DBO::AddParam(int iValue )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = SQL_PARAM_INPUT;
	pparameter->m_ParameterCType = SQL_C_LONG;
	pparameter->m_SQLType = SQL_INTEGER;
	pparameter->m_pData = new int(iValue);
	pparameter->m_bOwnData = true;
	pparameter->m_DescLen = 0;
	pparameter->m_ParamSize = 0;
	pparameter->m_DecimalDigits = 0;
	pparameter->m_DescLenOrInd = 0;
	m_Parameters.push_back(pparameter);
}

/*********************************************************************************
> void DBO::AddParam()

	Author:		Martin Robb
	Inputs:		None
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Adds a named integer parameter

*********************************************************************************/
void DBO::AddParam(const TDVCHAR* pName, int iValue )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = SQL_PARAM_INPUT;
	pparameter->m_ParameterCType = SQL_C_LONG;
	pparameter->m_SQLType = SQL_INTEGER;
	pparameter->m_pData = new int(iValue);
	pparameter->m_bOwnData = true;
	pparameter->m_DescLen = 0;
	pparameter->m_ParamSize = 0;
	pparameter->m_DecimalDigits = 0;
	pparameter->m_DescLenOrInd = 0;
	pparameter->m_sName << "@" << pName;
	m_Parameters.push_back(pparameter);
}

/*void DBO::AddParam(long lValue )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = SQL_PARAM_INPUT;
	pparameter->m_ParameterCType = SQL_C_LONG;
	pparameter->m_SQLType = SQL_INTEGER;
	pparameter->m_pData = new long(lValue);
	pparameter->m_bOwnData = true;
	pparameter->m_DescLen = 0;
	m_Parameters.push_back(pparameter);
}
void DBO::AddParam(const TDVCHAR* pName, long lValue )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = SQL_PARAM_INPUT;
	pparameter->m_ParameterCType = SQL_C_LONG;
	pparameter->m_SQLType = SQL_INTEGER;
	pparameter->m_pData = new long(lValue);
	pparameter->m_bOwnData = true;
	pparameter->m_DescLen = 0;
	pparameter->m_sName = pName;
	m_Parameters.push_back(pparameter);
}*/

/*********************************************************************************
> void DBO::AddParam(const TDVCHAR* pValue)

	Author:		Martin Robb
	Inputs:		TDVCHAR* - NULL TERMINATED.
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Adds a string parameter.
				Sets up data > 8K as a SQL_LONGVARCHAR - there is an 8K limit for sql varchar, char types.
				Maximum limit for SQL_LONGVARCHAR is 400KB
				Data At Execution is not used as it results in subtle differences in the results when 
				a duplicate key error occurs - SQLMoreResults returns SQLError even though a further resultset exists and
				may be processed successfully.
*********************************************************************************/
void DBO::AddParam( const TDVCHAR* pValue )
{
	TDVASSERT(pValue != NULL,"Calling AddParam with NULL - Use AddNullParam");

	if ( pValue )
	{
		SQLPARAMETER*  pparameter = new SQLPARAMETER;
		pparameter->m_InputOutputType = SQL_PARAM_INPUT;
		pparameter->m_ParameterCType = SQL_C_CHAR;

		int buffer_len = strlen(pValue) + 1; //Include string terminator		
		pparameter->m_DescLen = buffer_len; 

		pparameter->m_ParamSize = buffer_len;
		pparameter->m_DecimalDigits = 0;

		//For safety - Take a copy of the data.
		TDVCHAR* pData  = new TDVCHAR[buffer_len];
		memcpy(pData,pValue,sizeof(TDVCHAR)*buffer_len);
		pparameter->m_bOwnData = true;
		pparameter->m_pData = pData;

		if ( buffer_len >=  8000 )
		{
			//Handle 8K Limit
			pparameter->m_SQLType = SQL_LONGVARCHAR;
			pparameter->m_DescLenOrInd = SQL_NTS; //SQL_LEN_DATA_AT_EXEC(buffer_len);
		}
		else
		{
			pparameter->m_SQLType = SQL_VARCHAR;
			pparameter->m_DescLenOrInd = SQL_NTS;
		}
		m_Parameters.push_back(pparameter);
	}
}


/*********************************************************************************
> void DBO::AddParam(const TDVCHAR*, const TDVCHAR* pValue)

	Author:		Martin Robb
	Inputs:		TDVCHAR* Name, TDVCHAR* Value - NULL TERMINATED.
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Adds a named string parameter.
				Sets up data > 8K as a SQL_LONGVARCHAR - there is an 8K limit for sql varchar, char types.
				Maximum limit for SQL_LONGVARCHAR is 400KB
				Data At Execution is not used as it results in subtle differences in the results when 
				a duplicate key error occurs - SQLMoreResults returns SQLError even though a further resultset exists and
				may be processed successfully.
*********************************************************************************/
void DBO::AddParam(const TDVCHAR* pName, const TDVCHAR* pValue )
{
	TDVASSERT(pValue != NULL,"Calling AddParam with NULL - Use AddNullParam");
	
	if ( pValue )
	{
		SQLPARAMETER*  pparameter = new SQLPARAMETER;
		pparameter->m_InputOutputType = SQL_PARAM_INPUT;
		pparameter->m_ParameterCType = SQL_C_CHAR;
		pparameter->m_sName << "@" << pName;
 
		int buffer_len = strlen(pValue) + 1; //Include string terminator
		pparameter->m_DescLen = buffer_len;

		pparameter->m_ParamSize = buffer_len;
		pparameter->m_DecimalDigits = 0;

		//For safety - Take a copy of the data.
		pparameter->m_pData = new TDVCHAR[buffer_len];
		memcpy(pparameter->m_pData,pValue,sizeof(TDVCHAR)*buffer_len);
		pparameter->m_bOwnData = true;

		if ( buffer_len >= 8000 )
		{
			//Handle 8K Limit
			pparameter->m_SQLType = SQL_LONGVARCHAR;
			pparameter->m_DescLenOrInd = SQL_NTS; //SQL_LEN_DATA_AT_EXEC(buffer_len);
		}
		else
		{
			pparameter->m_DescLenOrInd = SQL_NTS;
			pparameter->m_SQLType = SQL_VARCHAR;
		}
		m_Parameters.push_back(pparameter);
	}
}

/*********************************************************************************
> void DBO::AddParam(CTDVDateTime)

	Author:		Martin Robb
	Inputs:		CTDVDateTime
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Adds a datetime parameter

*********************************************************************************/
void DBO::AddParam( const CTDVDateTime& datetime )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = SQL_PARAM_INPUT;
	pparameter->m_ParameterCType = SQL_C_TYPE_TIMESTAMP;
	pparameter->m_SQLType = SQL_TYPE_TIMESTAMP;

	//Convert from CTDVDateTime to SQL Timestamp struct
	SQL_TIMESTAMP_STRUCT*  pTimeStamp = new SQL_TIMESTAMP_STRUCT;
	pTimeStamp->day = datetime.GetDay();
	pTimeStamp->month = datetime.GetMonth();
	pTimeStamp->year = datetime.GetYear();
	pTimeStamp->hour = datetime.GetHour();
	pTimeStamp->minute = datetime.GetMinute();
	pTimeStamp->second = datetime.GetSecond();
	pTimeStamp->fraction = 0;

	pparameter->m_pData = pTimeStamp;
	pparameter->m_bOwnData = true;
	pparameter->m_DescLen = sizeof(*pTimeStamp);
	pparameter->m_ParamSize = 19;		//Dates in yyyy-mm-dd hh:mm:ss format
	pparameter->m_DecimalDigits = 0;	//Precision in seconds 
	pparameter->m_DescLenOrInd = 0;
	m_Parameters.push_back(pparameter);
}

/*********************************************************************************
> void DBO::AddParam(CTDVDateTime)

	Author:		Martin Robb
	Inputs:		CTDVDateTime
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Adds a named datetime parameter

*********************************************************************************/
void DBO::AddParam(const TDVCHAR* pName, const CTDVDateTime& datetime )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = SQL_PARAM_INPUT;
	pparameter->m_ParameterCType = SQL_C_TYPE_TIMESTAMP;
	pparameter->m_SQLType = SQL_TYPE_TIMESTAMP;

	//Convert from CTDVDateTime to SQL Timestamp struct
	SQL_TIMESTAMP_STRUCT*  pTimeStamp = new SQL_TIMESTAMP_STRUCT;
	pTimeStamp->day = datetime.GetDay();
	pTimeStamp->month = datetime.GetMonth();
	pTimeStamp->year = datetime.GetYear();
	pTimeStamp->hour = datetime.GetHour();
	pTimeStamp->minute = datetime.GetMinute();
	pTimeStamp->second = datetime.GetSecond();
	pTimeStamp->fraction = 0;

	pparameter->m_pData = pTimeStamp;
	pparameter->m_bOwnData = true;
	pparameter->m_DescLen = sizeof(*pTimeStamp);
	pparameter->m_ParamSize = 19;		//Dates in yyyy-mm-dd hh:mm:ss format
	pparameter->m_DecimalDigits = 0;	//Precision in seconds 
	pparameter->m_DescLenOrInd = 0;
	pparameter->m_sName << "@" << pName;
	m_Parameters.push_back(pparameter);
}

/*********************************************************************************
> void DBO::AddOutputParam( int* pParam, PARAMINOUTTYPE ParamInOutType )

	Author:		Martin Robb
	Inputs:		pParam, OUT/INOUT parameter type
	Outputs:	- pParam 
	Returns:	- None
	Scope:		public
	Purpose:	Adds a reference to an output/inout parameter. 
*********************************************************************************/
void DBO::AddOutputParam( int* pParam, PARAMINOUTTYPE ParamInOutType )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = ParamInOutType == OUTPARAM ? SQL_PARAM_OUTPUT : SQL_PARAM_INPUT_OUTPUT;
	pparameter->m_ParameterCType = SQL_C_LONG;
	pparameter->m_SQLType = SQL_INTEGER;
	pparameter->m_pData = pParam;
	pparameter->m_bOwnData = false;
	pparameter->m_DescLen = 0;
	pparameter->m_ParamSize = 0;
	pparameter->m_DecimalDigits = 0;
	pparameter->m_DescLenOrInd = 0;
	m_Parameters.push_back(pparameter);
}

/*********************************************************************************
> void DBO::AddOutputParam( const TDVCHAR* pName, int* pParam, PARAMINOUTTYPE ParamInOutType )

	Author:		Martin Robb
	Inputs:		Name, pParam, OUT/INOUT parameter type
	Outputs:	- pParam 
	Returns:	- None
	Scope:		public
	Purpose:	Adds a reference to an output/inout parameter. 
*********************************************************************************/
void DBO::AddOutputParam( const TDVCHAR* pName, int* pParam, PARAMINOUTTYPE ParamInOutType )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = ParamInOutType == OUTPARAM ? SQL_PARAM_OUTPUT : SQL_PARAM_INPUT_OUTPUT;
	pparameter->m_ParameterCType = SQL_C_LONG;
	pparameter->m_SQLType = SQL_INTEGER;
	pparameter->m_pData = pParam;
	pparameter->m_bOwnData = false;
	pparameter->m_DescLen = 0;
	pparameter->m_ParamSize = 0;
	pparameter->m_DecimalDigits = 0;
	pparameter->m_DescLenOrInd = 0;
	pparameter->m_sName << "@" << pName;
	m_Parameters.push_back(pparameter);
}

/*********************************************************************************
> void DBO::AddOutputParam( double* pParam, PARAMINOUTTYPE ParamInOutType )

	Author:		Martin Robb
	Inputs:		pParam, OUT/INOUT parameter type
	Outputs:	- pParam 
	Returns:	- None
	Scope:		public
	Purpose:	Adds a reference to an output/inout parameter. 
*********************************************************************************/
void DBO::AddOutputParam( double* pParam, PARAMINOUTTYPE ParamInOutType )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = ParamInOutType == OUTPARAM ? SQL_PARAM_OUTPUT : SQL_PARAM_INPUT_OUTPUT;
	pparameter->m_ParameterCType = SQL_C_DOUBLE;
	pparameter->m_SQLType = SQL_DOUBLE;
	pparameter->m_pData = pParam;
	pparameter->m_bOwnData = false;
	pparameter->m_DescLen = 0;
	pparameter->m_ParamSize = 0;
	pparameter->m_DecimalDigits = 0;
	pparameter->m_DescLenOrInd = 0;
	m_Parameters.push_back(pparameter);
}

/*********************************************************************************
> void DBO::AddOutputParam( const TDVCHAR* pName, double* pParam, PARAMINOUTTYPE ParamInOutType )

	Author:		Martin Robb
	Inputs:		Name, pParam, OUT/INOUT parameter type
	Outputs:	- pParam 
	Returns:	- None
	Scope:		public
	Purpose:	Adds a reference to an output/inout parameter. 
*********************************************************************************/
void DBO::AddOutputParam( const TDVCHAR* pName, double* pParam, PARAMINOUTTYPE ParamInOutType )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = ParamInOutType == OUTPARAM ? SQL_PARAM_OUTPUT : SQL_PARAM_INPUT_OUTPUT;
	pparameter->m_ParameterCType = SQL_C_DOUBLE;
	pparameter->m_SQLType = SQL_DOUBLE;
	pparameter->m_pData = pParam;
	pparameter->m_bOwnData = false;
	pparameter->m_DescLen = 0;
	pparameter->m_ParamSize = 0;
	pparameter->m_DecimalDigits = 0;
	pparameter->m_DescLenOrInd = 0;
	pparameter->m_sName << "@" << pName;
	m_Parameters.push_back(pparameter);
}

/*********************************************************************************
> void DBO::AddOutputParam( TDVCHAR* pParam, PARAMINOUTTYPE ParamInOutType )

	Author:		Martin Robb
	Inputs:		pParam, OUT/INOUT parameter type
	Outputs:	- pParam 
	Returns:	- None
	Scope:		public
	Purpose:	Adds a reference to an output/inout parameter. 
				Note: StoredProcedure OUTPUT parameter should be of type CHAR, NCHAR not VARCHAR.
*********************************************************************************/
void DBO::AddOutputParam( TDVCHAR* pParam, int size, PARAMINOUTTYPE ParamInOutType )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = ParamInOutType == OUTPARAM ? SQL_PARAM_OUTPUT : SQL_PARAM_INPUT_OUTPUT;
	pparameter->m_ParameterCType = SQL_C_CHAR;
	pparameter->m_SQLType = SQL_VARCHAR;
	pparameter->m_pData = pParam;
	pparameter->m_bOwnData = false;
	pparameter->m_DescLen = size;
	pparameter->m_ParamSize = size;
	pparameter->m_DecimalDigits = 0;
	pparameter->m_DescLenOrInd = SQL_NTS;
	m_Parameters.push_back(pparameter);
}

/*********************************************************************************
> void DBO::AddOutputParam( const TDVCHAR* pName, TDVCHAR* pParam, PARAMINOUTTYPE ParamInOutType )

	Author:		Martin Robb
	Inputs:		Name, pParam, OUT/INOUT parameter type
	Outputs:	- pParam 
	Returns:	- None
	Scope:		public
	Purpose:	Adds a reference to an output/inout parameter. 
				Note: StoredProcedure OUTPUT parameter should be of type CHAR, NCHAR not VARCHAR.
*********************************************************************************/
void DBO::AddOutputParam( const TDVCHAR* pName, TDVCHAR* pParam, int size, PARAMINOUTTYPE ParamInOutType )
{
	SQLPARAMETER*  pparameter = new SQLPARAMETER;
	pparameter->m_InputOutputType = ParamInOutType == OUTPARAM ? SQL_PARAM_OUTPUT : SQL_PARAM_INPUT_OUTPUT;
	pparameter->m_ParameterCType = SQL_C_CHAR;
	pparameter->m_SQLType = SQL_VARCHAR;
	pparameter->m_pData = pParam;
	pparameter->m_bOwnData = false;
	pparameter->m_DescLen = size;
	pparameter->m_ParamSize = size;
	pparameter->m_DecimalDigits = 0;
	pparameter->m_DescLenOrInd= SQL_NTS;
	pparameter->m_sName << "@" << pName;
	m_Parameters.push_back(pparameter);  
}

/*********************************************************************************
> void DBO::AddReturnParam( int* pParam )

	Author:		Martin Robb
	Inputs:		int* - receives output return parameter.
	Outputs:	- pReturnParam 
	Returns:	- None
	Scope:		public
	Purpose:	Allows return value of stored procedure to be retrieved
*********************************************************************************/
void DBO::AddReturnParam(int* pReturnValue)
{
	if ( m_pReturnParam )
	{
		delete m_pReturnParam;
	}

	m_pReturnParam = new SQLPARAMETER;
	m_pReturnParam->m_InputOutputType = SQL_PARAM_OUTPUT;
	m_pReturnParam->m_ParameterCType = SQL_C_LONG;
	m_pReturnParam->m_SQLType = SQL_INTEGER;
	m_pReturnParam->m_pData = pReturnValue;
	m_pReturnParam->m_bOwnData = false;
	m_pReturnParam->m_DescLen = 0;
	m_pReturnParam->m_ParamSize = 0;
	m_pReturnParam->m_DecimalDigits = 0;
	m_pReturnParam->m_DescLenOrInd = 0;
}


/*********************************************************************************
> void DBO::SetQuery(LPTSTR pQuery)

	Inputs:		pQuery - string containing SQL query
	Outputs:	-
	Returns:	-
	Purpose:	Passes an SQL query to the DBO object. Call ExecuteQuery to
				actually execute it.

**********************************************************************************/

void DBO::SetQuery(const TDVCHAR* pQuery)
{
	m_strSQLQuery = _T(pQuery);
}

/*********************************************************************************
> void DBO::DiagnoseError()

	Inputs:		None
	Outputs:	-
	Returns:	-
	Purpose:	Retrieves last error information.
				Does not set m_bError as it could be used to retrieve SQL_SUCCESS_WITH_INFO information.
				States beginning with 01 ar einformation or warning messages so only their text is logged.
				The method SQLGetDiagRec() returns a resultset of messages for the last statement executed. 

**********************************************************************************/
void DBO::DiagnoseError()
{
	SQLCHAR state[6] = "";
	SQLINTEGER NativeError = 0;
	SQLCHAR errormessage[4096] = "";
	SQLSMALLINT txtLength = 4096;

	m_iLastErrorCode = 0;
	
	int iRec = 1;
	CTDVString sError;
	CTDVString sInfo;
	SQLRETURN rc = SQLGetDiagRec(SQL_HANDLE_STMT, m_hStmt, iRec, state, &NativeError, errormessage, 4096, &txtLength);
	while ( rc == SQL_SUCCESS || rc == SQL_SUCCESS_WITH_INFO)
	{
		//Check Severity - ( Information/Warning  messages have a class starting 01 too ).
		int severity = 0;
		SQLGetDiagField(SQL_HANDLE_STMT, m_hStmt,iRec,SQL_DIAG_SS_SEVERITY,&severity,0,NULL);

		//Record error / information returned with query
		m_sLastError << " (" << NativeError << ") " << (TDVCHAR*)	errormessage  << ".\n";

		//Record the first error number - severity 10 is informational
		if ( severity > 10 && m_iLastErrorCode == 0 )
		{
			m_iLastErrorCode = NativeError;
		}
		rc = SQLGetDiagRec(SQL_HANDLE_STMT, m_hStmt, ++iRec, state, &NativeError, errormessage, 4096, &txtLength);
	}

	//Handle No Error Information 
	if ( iRec == 1)
	{

		if ( rc == SQL_ERROR  )
		{
			m_iLastErrorCode = SQL_ERROR;
			m_sLastError << " (" << m_iLastErrorCode << ") " << "Failed to get error information.\n";
		}
		else if ( rc == SQL_INVALID_HANDLE )
		{
			m_iLastErrorCode = SQL_INVALID_HANDLE;
			m_sLastError << " (" << m_iLastErrorCode << ") " << "Invalid Statement Handle.\n";
		}
		else
		{
			m_iLastErrorCode = SQL_NO_DATA;
			m_sLastError << " (" << m_iLastErrorCode << ") " << "No error information provided.\n";
		}
	}
}

/*********************************************************************************
> void DBO::DiagnoseErrorInResults()

	Inputs:		None
	Outputs:	-
	Returns:	-
	Purpose:	Retrieves error information from Error field in resultet.

**********************************************************************************/
bool DBO::DiagnoseErrorInResults()
{
	CTDVString columnName = GetFieldName(1);
	if (columnName.CompareText("ErrorCode"))
	{
		m_bError = true;
		m_iLastErrorCode = GetLongField("ErrorCode");
		m_sLastError = "Error ";
		m_sLastError << m_iLastErrorCode << " inside stored procedure";
		m_sLastError << " (" << m_strSQLQuery << ")";
		TDVASSERT(false, m_sLastError);
	}

	return m_bError;
}


/*********************************************************************************
	bool DBO::MoreResults()

	Author:		Martin Robb
	Inputs:		-
	Outputs:	-
	Returns:	true for if more results, false on error or end of data 
	Scope:		public
	Purpose:	Moves to the Next Resultset. 
				If another resultset is not available returns false.
				If Duplicate Key errors are found - violation of unique key 2627 or 
				Duplicate Key ignored 3604 then processing continues with the next resultset.
				Otherwise the error flag is signalled.

*********************************************************************************/
bool DBO::MoreResults ( int& columns )
{
	SQLSMALLINT icolumns = columns =  0;
	SQLRETURN rc = SQL_SUCCESS;
	while ( columns == 0 && rc != SQL_NO_DATA )
	{
		rc = SQLMoreResults(m_hStmt);
		if ( rc == SQL_ERROR )
		{
			DiagnoseError();

			//Continue processing on violation of unique key contstraints and duplicate key ignored.
			if ( m_iLastErrorCode == 0 || m_iLastErrorCode == 2627 || m_iLastErrorCode == 3604 || m_iLastErrorCode == 2601 )
			{
				continue;
			}
			else
			{
				m_bError = true;
				break;
			}
		}

		if ( SQL_SUCCESS == SQLNumResultCols(m_hStmt,&icolumns) )
		{
			columns = icolumns;
		}
	}

	return columns > 0;
}

/*********************************************************************************
	bool DBO::ExecuteQuery()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Scope:		public
	Purpose:	Assumes a query as been passed to the object by SetQuery. Executes
				the query and prepares the first row. IsEOF() will return true
				after this call if the query returned no results.
				The caller should call the various Get functions (GetField, 
				GetLongField, GetDateField,	GetDoubleField, GetBoolField and 
				GetRelativeDateField to fetch the result set in whichever way 
				they require. To fetch the next row, call MoveNext().

*********************************************************************************/

bool DBO::ExecuteQuery()
{
#ifdef __MYSQL__
	if (m_pResult != NULL)
	{
		mysql_free_result(m_pResult);
	}
	m_NumCols = 0;
	FreeDataBuffers();
	int qresult = mysql_query(m_pconnection, m_strSQLQuery);
	
	if (qresult != 0)
	{
		CTDVString sErr = mysql_error(m_pconnection);
		sErr << "!";
		return false;
	}
	m_pResult = mysql_store_result(m_pconnection);
    int x = 0;;
	MYSQL_FIELD* field;
	if (m_pResult != NULL)
	{
		for ( x = 0 ; field = mysql_fetch_field( m_pResult ) ; x++ )
		{
			CTDVString fieldname = field->name;
			fieldname.MakeUpper();
			m_Names[x] = fieldname;
		}
	}
	m_NumCols = x;
	MoveNext();
	return true;

#else

	// We've got the query in m_strSQLQuery
	SQLRETURN rc = SQL_SUCCESS;
	FreeDataBuffers();		// free up any previous buffers for data
	
	// test to see if there's already a statement executing
	if (m_hStmt != SQL_NULL_HSTMT)
	{
		// Close this statement
		rc = SQLCloseCursor(m_hStmt);
	}
	else
	{
		rc = SQLAllocHandle(SQL_HANDLE_STMT, m_hConn, &m_hStmt);
	}

	if (rc == SQL_SUCCESS || rc == SQL_SUCCESS_WITH_INFO)
	{
		rc = SQLExecDirect(m_hStmt, (SQLCHAR*)(const TDVCHAR*)m_strSQLQuery, SQL_NTS);
	}

	if (rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO && rc != SQL_NO_DATA)
	{
		SQLCHAR state[6];
		SQLINTEGER NativeError = 0;
		SQLCHAR errormessage[4096];
		memset(&errormessage,0,4096 * sizeof(SQLCHAR));
		SQLSMALLINT txtLength = 0;

		SQLGetDiagRec(SQL_HANDLE_STMT, m_hStmt, 1, state, &NativeError, errormessage, 4096, &txtLength);
		SQLCloseCursor(m_hStmt);
		m_bError = true;

		if (txtLength == 0)
		{
			m_sLastError = "No valid SQL error message given!";
		}
		else
		{
			m_sLastError = (TDVCHAR*)errormessage;
		}
		m_sLastError << " (" << m_strSQLQuery << ")";
		m_iLastErrorCode = NativeError;
		TDVASSERT(false,m_sLastError);
		m_EOF = true;
		return false;
	}
	else
	{
		m_bError = false;
		m_sLastError = "";
		SQLSMALLINT numcols = 0;
		rc = SQL_SUCCESS;
		while (numcols == 0)
		{
			rc = SQLNumResultCols(m_hStmt,&numcols);
			if (numcols == 0)
			{
				rc = SQLMoreResults(m_hStmt);
				if (rc == SQL_ERROR)
				{
					SQLCHAR state[6];
					SQLINTEGER NativeError = 0;
					SQLCHAR errormessage[4096];
					SQLSMALLINT txtLength = 0;

					SQLGetDiagRec(SQL_HANDLE_STMT, m_hStmt, 1, state, &NativeError, errormessage, 4096, &txtLength);
					if (NativeError == 3604)	// Duplicate key was ignored 
					{
						continue;
					}
					else
					{
						m_bError = true;
						m_sLastError = (TDVCHAR*)errormessage;
						m_sLastError << " (" << m_strSQLQuery << ")";
						m_iLastErrorCode = NativeError;
						TDVASSERT(false,m_sLastError);
						m_EOF = true;
						break;
					}
				}
				if ((rc != SQL_SUCCESS) && (rc != SQL_SUCCESS_WITH_INFO /*&& rc != SQL_NO_DATA*/))
				{
					break;
				}
			}
		}

		m_NumCols = numcols;

		if (numcols == 0)
		{
			m_EOF = true;
			if (rc != SQL_NO_DATA) 
			{
				SQLCloseCursor(m_hStmt);
			}
			SQLFreeHandle(SQL_HANDLE_STMT, m_hStmt);
			m_hStmt = SQL_NULL_HSTMT;
			return true;
		}

	
		MoveNext();		// This function will fetch the next row data

		//check if error information is returned as resultset
		CTDVString columnName = GetFieldName(1);
		if (columnName.CompareText("ErrorCode"))
		{
			SQLCloseCursor(m_hStmt);
			m_bError = true;
			m_iLastErrorCode = this->GetLongField("ErrorCode");
			m_sLastError = "Error ";
			m_sLastError << m_iLastErrorCode << " inside stored procedure";
			m_sLastError << " (" << m_strSQLQuery << ")";
			TDVASSERT(false, m_sLastError);
			m_EOF = true;
			return false;
		}
	}

	return !m_bError;
#endif
}

/*********************************************************************************
	bool DBO::ExecuteQuery2()

	Author:		Martin Robb
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Scope:		public
	Purpose:	Assumes a query as been passed to the object by SetQuery. Executes
				the query and prepares the first row. IsEOF() will return true
				after this call if the query returned no results.
				The caller should call the various Get functions (GetField, 
				GetLongField, GetDateField,	GetDoubleField, GetBoolField and 
				GetRelativeDateField to fetch the result set in whichever way 
				they require. To fetch the next row, call MoveNext().

				Binds Paramaters to markers in the ODBC Call statement.
				The parameters should have been set-up by calling AddParameter.

				Supports Named Parameters - parameters may be supplied in a different than they appear in the stored procedure.
				If a named parameter is used, all parameters must be named parameters. 
				If any parameter is not a named parameter, then none of the parameters ca be named parameters. 
				If there were a mixture of named parameters and unnamed parameters, the behavior would be driver-dependent.
				
				Supports Data at Execution for large fields eg Images.

				If Duplicate Key errors are found processing is allowed to continue:
				2627 - Violation of unique key constraint - severity 14.
				3604 - Duplicate Key ignored - severity 10.
				2601 - Cannot insert duplicate key row - severity 14.
				( Processing of a stored procedure will continue with errors of severity < 20 )
				TODO: Resolve Inconsistency - SQL_SUCCESS_WITH_INFO not checked for error information of the first statement executed.

*********************************************************************************/
bool DBO::ExecuteQuery2()
{
	m_bError = false;
	m_sLastError = "";
	m_iLastErrorCode = 0;

	SQLRETURN rc = SQL_SUCCESS;
	FreeDataBuffers();		// free up any previous buffers for data
	
	// test to see if there's already a statement executing
	if (m_hStmt != SQL_NULL_HSTMT)
	{
		// Close this statement - not worried about errors due to cursor already closed.
		//Might be closed due to committing of transactions/explicit closure/automatically closed when eof reached.
		SQLFreeStmt(m_hStmt,SQL_RESET_PARAMS);
		SQLCloseCursor(m_hStmt);
	}
	else
	{
		rc = SQLAllocHandle(SQL_HANDLE_STMT, m_hConn, &m_hStmt);
	}

	//Handle failure.
	if ( rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO )
	{
		m_bError = true;
		m_EOF = true;
		DiagnoseError();
		TDVASSERT(false,m_sLastError);
		return false;
	}

	//Build a Query String from the Parameter Structures.
	// ? Is a marker which will be used to bind a parameter.
	if ( m_pReturnParam )
	{
		m_strSQLQuery = "{?=CALL ";
	}
	else
	{
		m_strSQLQuery = "{CALL ";
	}
	m_strSQLQuery += m_strStoredProcedure;

	CTDVString sParameters;
	for ( std::vector<SQLPARAMETER*>::iterator iter = m_Parameters.begin(); iter != m_Parameters.end(); ++iter )
	{	
		if ( sParameters.GetLength() == 0 )
		{
			sParameters = "(?";
		}
		else
		{
			sParameters += ",?";
		}
	}

	if ( sParameters.GetLength() )
	{
		sParameters += ")}";
	}
	else
	{
		sParameters += "}";
	}
	m_strSQLQuery += sParameters;

	//SQLPrepare(m_hStmt, (SQLCHAR*)(const TDVCHAR*) m_strSQLQuery, SQL_NTS);

	int index = 1;

	//Add Return Parameter.
	if ( m_pReturnParam )
	{
		SQLBindParameter(m_hStmt,index++,m_pReturnParam->m_InputOutputType, m_pReturnParam->m_ParameterCType, m_pReturnParam->m_SQLType, m_pReturnParam->m_DescLen,0, m_pReturnParam->m_pData, m_pReturnParam->m_DescLen, &(m_pReturnParam->m_DescLenOrInd));
	}

	//Add Bound Parameters
	SQLPOINTER hIpd = NULL;
	SQLGetStmtAttr(m_hStmt, SQL_ATTR_IMP_PARAM_DESC, &hIpd, 0, 0);
	for ( std::vector<SQLPARAMETER*>::iterator iter = m_Parameters.begin(); iter != m_Parameters.end(); ++iter )
	{
		SQLPARAMETER* pParameter = *iter;
		SQLBindParameter(m_hStmt,index,pParameter->m_InputOutputType, pParameter->m_ParameterCType, pParameter->m_SQLType, pParameter->m_ParamSize, pParameter->m_DecimalDigits, pParameter->m_pData, pParameter->m_DescLen, &(pParameter->m_DescLenOrInd));

		//Support for Named Parameters.
		if ( pParameter->m_sName.GetLength() > 0 )
		{
			SQLSetDescField(hIpd, index, SQL_DESC_NAME, (SQLPOINTER) (const TDVCHAR*)  pParameter->m_sName, SQL_NTS);
			SQLSetDescField(hIpd, index, SQL_DESC_UNNAMED, SQL_NAMED, 0);

		}
		++index;
	}

	rc = SQLExecDirect(m_hStmt,(SQLCHAR*)(const TDVCHAR*) m_strSQLQuery, SQL_NTS);
	//rc = SQLExecute(m_hStmt);

	//Handle Data at execution parameters
	SQLPOINTER pValue = NULL;
	while ( rc == SQL_NEED_DATA )
	{
		if ( pValue == NULL )
		{
			rc = SQLParamData(m_hStmt,&pValue);
		}

		if ( rc == SQL_NEED_DATA )
		{
			//Find Data to send.
			SQLPARAMETER* pParameter = NULL;
			for ( std::vector<SQLPARAMETER*>::iterator iter = m_Parameters.begin(); iter != m_Parameters.end(); ++iter )
			{
				if ( (*iter)->m_pData == pValue )
				{
					pParameter = *iter;
					break;
				}
			}

			//Send all data at once.
			if ( pParameter )
			{
				SQLRETURN rc = SQLPutData(m_hStmt,pParameter->m_pData,pParameter->m_DescLen);
				if ( rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO )
				{
					break;
				}
			}

			//Indicate Done.
			rc = SQLParamData(m_hStmt,&pValue);
		}
	}

	//Handle Error
	if (rc != SQL_SUCCESS && rc != SQL_SUCCESS_WITH_INFO && rc != SQL_NO_DATA)
	{
		DiagnoseError();
		SQLFreeStmt(m_hStmt,SQL_RESET_PARAMS);
		SQLCloseCursor(m_hStmt);
		SQLFreeHandle(SQL_HANDLE_STMT, m_hStmt);
		m_hStmt = SQL_NULL_HSTMT;
		m_EOF = true;
		m_bError = true;
		TDVASSERT(false,m_sLastError);
		return false;
	}
	else
	{
		//Deal with Success with Info - Suppress Duplicate Key Errors.
		if ( rc == SQL_SUCCESS_WITH_INFO )
		{
			DiagnoseError();

			//Stop processing on unexpected error - Expecting Unique Key Violations.
			if ( !(m_iLastErrorCode == 0 || m_iLastErrorCode == 2627 || m_iLastErrorCode == 3604 || m_iLastErrorCode == 2601) )
			{
				SQLFreeStmt(m_hStmt,SQL_RESET_PARAMS);
				SQLCloseCursor(m_hStmt);
				SQLFreeHandle(SQL_HANDLE_STMT, m_hStmt);
				m_hStmt = SQL_NULL_HSTMT;
				m_bError = true;
				m_EOF = true;
				TDVASSERT(false,m_sLastError);
				return false;
			}
		}

		//Find first resultset.
		SQLSMALLINT numcols = 0;
		rc = SQL_SUCCESS;
		while (numcols == 0 && rc != SQL_NO_DATA)
		{
			rc = SQLNumResultCols(m_hStmt,&numcols);
			if (numcols == 0)
			{
				rc = SQLMoreResults(m_hStmt);
				if (rc == SQL_ERROR)
				{
					DiagnoseError();

					//Continue processing only on violation of duplicate key errors
					if (  m_iLastErrorCode == 0 || m_iLastErrorCode == 2627 || m_iLastErrorCode == 3604 || m_iLastErrorCode == 2601 )
					{
						continue;
					}
					else
					{
						m_bError = true;
						break;
					}
				}
			}
		}
		m_NumCols = numcols;

		//Clean up if no results available
		if (numcols == 0 || m_bError )
		{
			m_EOF = true;
			SQLFreeStmt(m_hStmt,SQL_RESET_PARAMS);
			SQLCloseCursor(m_hStmt);
			SQLFreeHandle(SQL_HANDLE_STMT, m_hStmt);
			m_hStmt = SQL_NULL_HSTMT;
			TDVASSERT(!m_bError,m_sLastError);
			return !m_bError;
		}

		//Fetch Result Fields.
		MoveNext();

		//check if error information is returned as resultset
		if ( DiagnoseErrorInResults() )
		{
			m_bError = true;
			m_EOF = true;
			SQLFreeStmt(m_hStmt,SQL_RESET_PARAMS);
			rc = SQLCloseCursor(m_hStmt);
			SQLFreeHandle(SQL_HANDLE_STMT, m_hStmt);
			m_hStmt = SQL_NULL_HSTMT;
		}
	}

	return !m_bError;
}



/**********************************************************************
> bool DBO::IsEOF()

  Author: Jim Lynn
  Inputs: -
  Outputs: -
  Returns: True if there are no more rows to be fetched, false if there are.
  Purpose: Sees if the query has finished returning results (or failed to
			return any.)

**********************************************************************/

bool DBO::IsEOF()
{
//	return (VARIANT_TRUE == m_RecordSet->EndOfFile);
	return m_EOF;
}

/**********************************************************************
bool DBO::ExecuteQuery(const TDVCHAR* pQuery)

  Author: Jim Lynn
  Inputs: pQuery - string containing SQL query to be executed
  Outputs: -
  Returns: true if success

  Purpose: Executes the given query. If the query returns a result set,
			the DBO object will fetch the first row ready to be queried
			by the caller. It also sets its internal EOF flag to false,
			which can be tested by IsEOF(). The caller should call the
			various Get functions (GetField, GetLongField, GetDateField,
			GetDoubleField, GetBoolField and GetRelativeDateField to fetch
			the result set in whichever way they require. To fetch the
			next row, call MoveNext().

**********************************************************************/

bool DBO::ExecuteQuery(const TDVCHAR* pQuery)
{
	SetQuery(pQuery);
	return ExecuteQuery();
}

/**********************************************************************
  bool DBO::ExecuteStoredProcedure()

  Author: Jim Lynn
  Inputs: -
  Outputs: -
  Returns: true for success
  Purpose: Having previous called StartStoredProcedure and AddParam,
			call ExecuteStoredProcedure to execute your query. After
			that, behaviour is similar to ExecuteQuery.

**********************************************************************/

bool DBO::ExecuteStoredProcedure()
{
	//m_strStoredProcedure += ")}";
	m_strSQLQuery = m_strStoredProcedure;
	return ExecuteQuery2();
}
 
bool DBO::ExecuteStoredProcedure2()
{
//	m_strStoredProcedure += ")";
	m_strSQLQuery = m_strStoredProcedure;
	return ExecuteQuery2();
}

/*********************************************************************************
> bool DBO::IsNull(const TDVCHAR* pFieldName)

	Author:		Jim Lynn
	Inputs:		pFieldName - name of field to test
	Outputs:	-
	Returns:	True or False depending on NULL status of field

  Returns whether a given field in the result set is NULL.

**********************************************************************************/

bool DBO::IsNull(const TDVCHAR* pFieldName)
{
	CTDVString fname = pFieldName;
	fname.MakeUpper();
	return m_Nulls[fname];	
	
/*	long colcount = 0;
	while (colcount < m_NumCols && !m_pNames[colcount].CompareText(pFieldName))
	{
		colcount++;
	}
	if (colcount == m_NumCols)
	{
		return true;
	}
	else
	{
		return m_pNulls[colcount];
	}
*/
}

/**********************************************************************
> long DBO::GetFieldNum(const TDVCHAR* pFieldName)

  Author: Jim Lynn
  Inputs: pFieldName - textual name of a field in the returned row
  Outputs: -
  Returns: index of field number in result set

  Purpose: A database query will return its fields in the same order for
			each row, and sometimes it is more convenient for the caller
			to fetch the fields based on the column index rather than the
			textual name. This function gets the index you should use to
			fetch a particular field from the row by its index.

**********************************************************************/

long DBO::GetFieldNum(const TDVCHAR* pFieldName)
{
	CTDVString fname = pFieldName;
	fname.MakeUpper();
	STRLONGMAP::iterator MapIt;
	for (MapIt = m_Names.begin(); MapIt != m_Names.end();MapIt++)
	{
		if ((*MapIt).second == fname)
		{
			return (*MapIt).first;
		}
	}
	return -1;

/*
	long colcount = 0;
	while (colcount < m_NumCols && !m_pNames[colcount].CompareText(pFieldName))
	{
		colcount++;
	}
	if (colcount == m_NumCols)
	{
		return -1;
	}
	else
	{
		return colcount;
	}
*/
}

/*********************************************************************************
> CTDVString DBO::GetField(const TDVCHAR* pName)

	Author:		Jim Lynn
	Inputs:		pName - name of the field in the recordset
	Outputs:	-
	Returns:	String value of field or "" for empty

	Purpose:	returns the string value of the named field. Will do the appropriate
				string conversion on non-string fields.

**********************************************************************************/

CTDVString DBO::GetField(const TDVCHAR* pName)
{
	//Could not find field.
#ifdef __FLAGFIELDS
	CTDVString error;
	error << "Failed to find field " << pName << " in GetField";
	TDVASSERT(FieldExists(pName),error);
#endif

	CTDVString strTemp;
	CTDVString fName = pName;
	fName.MakeUpper();

#if __MYSQL__
	return m_Strings[fName];
#endif

	LONGMAP::const_iterator iter = m_Types.find(fName);
	if ( iter != m_Types.end() )
	{
		switch (iter->second)
		{
		case DBO_STRING:
			return m_Strings[fName];
			break;
		case DBO_LONG:
			return CTDVString(m_Longs[fName]);
			break;
		case DBO_FLOAT:
			TDVCHAR strbuff[40];
			sprintf((char*)strbuff, "%f",m_Doubles[fName]);
			strTemp = strbuff;
			return strTemp;
			break;
		case DBO_DATE:
			strTemp = (LPCSTR)m_Dates[fName].Format("%Y-%m-%d %H:%M:%S");
			return strTemp;
			break;
		}
	}

	return strTemp;
}

/*********************************************************************************
> DWORD DBO::GetLongField(const TDVCHAR* pName)

  Author:	Jim Lynn
  Inputs:	pName - string containing the field name
  Outputs:	-
  Returns:	DWORD representing the value of the field, or 0.

  This function returns the DWORD value of an integer field from a result set

**********************************************************************************/

long DBO::GetLongField(const TDVCHAR* pFieldName)
{
#ifdef __FLAGFIELDS
	CTDVString error;
	error << "Failed to find field " << pFieldName << " in GetLongField";
	TDVASSERT(FieldExists(pFieldName),error);
#endif
	CTDVString fname = pFieldName;
	fname.MakeUpper();
	//long fieldnum = GetFieldNum(pFieldName);

#ifdef __MYSQL__
	if (m_Nulls[fname])
	{
		return 0;
	}
	return atoi(m_Strings[fname]);
#endif

	LONGMAP::const_iterator iter = m_Longs.find(fname);
	if ( iter != m_Longs.end() )
	{
		return iter->second;
	}

	return 0;
}

/*********************************************************************************
> DWORD DBO::GetNumFields()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	Number of fields in record
	Scope:		public
	Purpose:	Returns number of fields in the current record.

*********************************************************************************/

DWORD DBO::GetNumFields()
{
	return m_NumCols;
}

/*********************************************************************************
> CTDVString DBO::GetFieldName(long lFieldNum)

	Author:		Jim Lynn
	Inputs:		lFieldNum
	Outputs:	-
	Returns:	Name of field
	Scope:		public
	Purpose:	Given a field number, return the name of the field that
				represents in the current result set

*********************************************************************************/

CTDVString DBO::GetFieldName(long lFieldNum)
{
	CTDVString sTemp;
	
	if (lFieldNum <= 0 || lFieldNum > m_NumCols)
	{
		return sTemp;
	}

	return m_Names[lFieldNum];
}

/**********************************************************************
> CTDVString DBO::GetField(long iFieldNum)

  Author: Jim Lynn
  Inputs: iFieldNum - column number of field to fetch
  Outputs: -
  Returns: string representation of field

  Purpose: Fetches string representation of the given column. Note that
			this function indexes by field name, and so might actually
			be slower than the version which uses the field name.

**********************************************************************/

CTDVString DBO::GetField(long iFieldNum)
{
	return GetField(m_Names[iFieldNum]);
/*	switch (m_pTypes[iFieldNum])
	{
	case DBO_STRING:
		return m_pStrings[iFieldNum];
		break;
	case DBO_LONG:
		return CTDVString(m_pLongs[iFieldNum]);
		break;
	case DBO_FLOAT:
		TDVCHAR strbuff[40];
		sprintf((char*)strbuff, "%f",m_pDoubles[iFieldNum]);
		strTemp = strbuff;
		return strTemp;
		break;
	case DBO_DATE:
		strTemp = (LPCSTR)m_pDates[iFieldNum].Format("%Y-%m-%d %H:%M:%S");
		return strTemp;
		break;
	}
	return strTemp;
*/

}

/**********************************************************************
> CTDVString DBO::FormatDateField(const TDVCHAR* pFieldName, const TDVCHAR* pFormat)

  Author: Jim Lynn
  Inputs:	pFieldName - name of field to fetch
			pFormat - date format to use on date
  Outputs: -
  Returns:	formatted string representation of date

  Purpose: Fetches a date field and formats it according to the format spec
			(see COleDateTime.Format for more information about the Format spec)

**********************************************************************/

CTDVString DBO::FormatDateField(const TDVCHAR* pFieldName, const TDVCHAR* pFormat)
{
//	long fieldnum = GetFieldNum(pFieldName);
//	if (fieldnum == -1 || m_pTypes[fieldnum] != DBO_DATE || m_pNulls[fieldnum])
//	{
//		return "";
//	}
	CTDVString fname = pFieldName;
	fname.MakeUpper();
#ifdef __MYSQL__
	COleDateTime date;
	date.ParseDateTime(m_Strings[fname]);
	return CTDVString((LPCSTR)date.Format(pFormat));
#else
	return CTDVString((LPCSTR)m_Dates[fname].Format(pFormat));
#endif
}

/**********************************************************************
> CTDVString DBO::GetRelativeDateField(const TDVCHAR* pFieldName)

  Author: Jim Lynn
  Inputs:	pFieldName - name of field to fetch
  Outputs: -
  Returns:	string version of date in relative format (e.g. 17 minutes ago)

  Purpose:	Used to present non-time-zone-specific dates where possible or useful.

**********************************************************************/

CTDVString DBO::GetRelativeDateField(const TDVCHAR* pFieldName)
{
//	long fieldnum = GetFieldNum(pFieldName);
//	if (fieldnum == -1 || m_pTypes[fieldnum] != DBO_DATE || m_pNulls[fieldnum])
//	{
//		return CTDVString("No Date");
//	}

#ifdef __FLAGFIELDS
	CTDVString error;
	error << "Failed to find field " << pFieldName << " in GetRelativeDateField";
	TDVASSERT(FieldExists(pFieldName),error);
#endif
	COleDateTime dateval;
	CTDVString fname = pFieldName;
	fname.MakeUpper();
#ifdef __MYSQL__
	dateval.ParseDateTime(m_Strings[fname]);
#else
	dateval = m_Dates[fname];
#endif
	CTDVString retString;		// to build the result

		COleDateTime curTime = COleDateTime::GetCurrentTime();
		COleDateTimeSpan Difference = curTime - dateval;

		// Now do all the relative stuff
		if (Difference.GetTotalSeconds() < 60)
		{
			return "Just Now";
		}
		if (Difference.GetTotalMinutes() < 60)
		{
			if (Difference.GetTotalMinutes() == 1)
			{
				return "1 Minute ago";
			}
			else
			{
				retString = CTDVString((long)Difference.GetTotalMinutes()) + " Minutes ago";
				return retString;
			}
		}

		if (Difference.GetTotalHours() < 24)
		{
			if (Difference.GetTotalHours() == 1)
			{
				return "1 Hour ago";
			}
			else
			{
				retString = CTDVString((long)Difference.GetTotalHours()) + " Hours ago";
				return retString;
			}
		}

		long numdays = (long)Difference.GetTotalDays();
		if (numdays <= 1)
		{
			return "Yesterday";
		}
		if (numdays < 7)
		{
			retString = CTDVString(numdays) + " Days ago";
			return retString;
		}
		if (numdays < 14)
		{
			return "Last Week";
		}
		if (numdays < 365)
		{
			long numweeks = numdays / 7;
			retString = CTDVString(numweeks) + " Weeks ago";
			return retString;
		}


		return "Over a year ago";
}

/**********************************************************************
> COleDateTime DBO::GetDateField(const TDVCHAR* pFieldName)

  Author: Jim Lynn
  Inputs: pFieldName - name of field to fetch
  Outputs: -
  Returns:	date value as a COleDateTime

  Purpose: fetches a date field as a COleDateTime

**********************************************************************/

CTDVDateTime DBO::GetDateField(const TDVCHAR* pFieldName)
{
	//COleDateTime retDate;		//default

#ifdef __FLAGFIELDS
	CTDVString error;
	error << "Failed to find field " << pFieldName << " in GetDateField";
	TDVASSERT(FieldExists(pFieldName),error);
#endif
	CTDVString fname = pFieldName;
	fname.MakeUpper();
#ifdef __MYSQL__
	COleDateTime tempdate;
	tempdate.ParseDateTime(m_Strings[fname]);
	CTDVDateTime tempDate(tempdate);
	return tempDate;
#endif

	DATEMAP::const_iterator iter = m_Dates.find(fname);
	if ( iter != m_Dates.end() )
	{	
		return CTDVDateTime(iter->second);
	}
	return CTDVDateTime(COleDateTime());

//	long fieldnum = GetFieldNum(pFieldName);
//	if (fieldnum == -1 || m_pTypes[fieldnum] != DBO_DATE || m_pNulls[fieldnum])
//	{
//		return retDate;
//	}
//	else
//	{
//		return m_pDates[fieldnum];
//	}
}

/**********************************************************************
> double DBO::GetDoubleField(const TDVCHAR* pFieldName)

  Author: Jim Lynn
  Inputs:	pFieldName
  Outputs: -
  Returns: value of field as a double

  Purpose: fetches a named field from the database as a double.

**********************************************************************/

double DBO::GetDoubleField(const TDVCHAR* pFieldName)
{
#ifdef __FLAGFIELDS
	CTDVString error;
	error << "Failed to find field " << pFieldName << " in GetDoubleField";
	TDVASSERT(FieldExists(pFieldName),error);
#endif
	CTDVString fname = pFieldName;
	fname.MakeUpper();
#ifdef __MYSQL__
	if (m_Nulls[fname])
	{
		return 0.0;
	}
	else
	{
		return atof(m_Strings[fname]);
	}
#endif

	DBLMAP::const_iterator iter = m_Doubles.find(fname);
	if ( iter != m_Doubles.end() )
	{
		return iter->second;
	}
	return 0.0;
/*
	long fieldnum = GetFieldNum(pFieldName);
	if (fieldnum == -1 || m_pTypes[fieldnum] != DBO_FLOAT || m_pNulls[fieldnum])
	{
		return 0.0;
	}
	else
	{
		return m_pLongs[fieldnum];
	}
*/
}

/*********************************************************************************
> bool DBO::MoveNext(int NumRows)

	Author:		Jim Lynn
	Inputs:		NumRows - number of rows to move (defaults to 1)
	Outputs:	-
	Returns:	True if there's a new row, false if at the end of the data set
	Putpose:	This does all the work of fetching the next row from the DB, filling
				in all the pointers (alocating if necessary) and setting the EOF flag.
				NumRows allows you to skip rows without fetching all the data (which
				can be more efficient when skipping large numbers of rows). NumRows
				is the number of rows by which the current row moves, so if the current
				row is row 6 and NumRows is 4, the current row will be row 10 on
				exit (assuming there were 10 or more rows in the result set).

**********************************************************************************/

bool DBO::MoveNext(int NumRows)
{
	TDVASSERT(NumRows >= 1, "MoveNext got illegal Repeats value");
#ifdef __MYSQL__
	
	if (m_pResult == NULL)
	{
		m_EOF = true;
		return false;
	}
	
	while (NumRows > 0)
	{
		m_Row = mysql_fetch_row(m_pResult);
		if (m_Row == NULL)
		{
			m_EOF = true;
			return false;
		}
		NumRows--;
	}
/*
	if (m_NumCols == 0)
	{
		unsigned int num_fields;
		unsigned int i;
		MYSQL_FIELD *fields;

		num_fields = mysql_num_fields(m_pResult);
		m_NumCols = num_fields;
		fields = mysql_fetch_fields(m_pResult);
		for(i = 0; i < num_fields; i++)
		{
			CTDVString fieldname = fields[i].name;
			fieldname.MakeUpper();
			m_Names[i] = fieldname;
		}
	}
*/	
	for (int i = 0; i < m_NumCols; i++ )
	{
		if (m_Row[i] == NULL)
		{
			m_Nulls[m_Names[i]] = true;
		}
		else
		{
			m_Nulls[m_Names[i]] = false;
			m_Strings[m_Names[i]] = m_Row[i];
		}
	}
	m_EOF = false;
	return true;

#else	/********** SQL Server *************/

	SQLRETURN rc;
	FreeDataBuffers();

	//Skip to desired row
	//Move to the next result set ( if it exists ).
	while (NumRows > 0)
	{
		rc = SQLFetch(m_hStmt);
		NumRows--;
		if (rc != SQL_SUCCESS)
		{
			//End of current resultset
			if ( rc == SQL_NO_DATA )
			{
				//Process Next Resultset.
				if ( MoreResults(m_NumCols) )
				{
					//Fetch Data.
					MoveNext();

					//Check for error in results - End processing on error
					if ( DiagnoseErrorInResults() )
					{
						m_bError = true;
						m_EOF = true;
					}
				}
				else
				{
					//No more Results.
					m_EOF = true;
					TDVASSERT(!m_bError,m_sLastError);
				}
			}
			return false;
		}
	}

	//Nothing to retrieve
	if ( m_NumCols == 0 )
	{
		m_EOF = true;
		return false;
	}

	//Process results - retrieve fields
	m_EOF = false;
	SQLCHAR namebuff[127];
	SQLCHAR strbuff[1024];
	SQLSMALLINT NameLength;
	SQLSMALLINT DataType;
	SQLUINTEGER ColumnSize;
	SQLSMALLINT DecimalDigits;
	SQLSMALLINT Nullable;

	SQLCHAR longtextbuff[65536];	// 64K buffer to start fetching text

	SQLINTEGER StrLen;
	TIMESTAMP_STRUCT time;

	for (int i = 1;i<=m_NumCols;i++)
	{
		rc = SQLDescribeCol(
						m_hStmt,
						i,
						namebuff,
						127,
						&NameLength,
						&DataType,
						&ColumnSize,
						&DecimalDigits,
						&Nullable);

		CTDVString fieldname = (LPCSTR)namebuff;
		fieldname.MakeUpper();
		m_Names[i] = fieldname;

		if (DataType == SQL_INTEGER || DataType == SQL_TINYINT || DataType == SQL_SMALLINT)
		{
			long tlong = 0;
			SQLGetData(m_hStmt, i,SQL_C_SLONG ,&tlong,sizeof(tlong), &StrLen);
			m_Types[fieldname] = DBO_LONG;
			if (StrLen == SQL_NULL_DATA)
			{
				m_Nulls[fieldname] = true;
			}
			else
			{
				m_Nulls[fieldname] = false;
				m_Longs[fieldname] = tlong;
			}
		}
		else if (DataType == SQL_LONGVARCHAR || DataType == SQL_WLONGVARCHAR)
		{
			m_Nulls[fieldname] = true;
			m_Types[fieldname] = DBO_STRING;
			m_Strings[fieldname] = "";
			while ((rc = SQLGetData(m_hStmt, i, SQL_C_CHAR, longtextbuff, 65536,&StrLen)) != SQL_NO_DATA)
			{
				if (StrLen > 0)
				{
					m_Strings[fieldname] += (LPCSTR)longtextbuff;
					m_Nulls[fieldname] = false;
				}
			}
		}
		else if (DataType == SQL_FLOAT || DataType == SQL_DOUBLE || DataType == SQL_REAL)
		{
			double tdouble;
			m_Types[fieldname] = DBO_FLOAT;
			SQLGetData(m_hStmt, i,SQL_C_DOUBLE,&tdouble,sizeof(tdouble), &StrLen);
			if (StrLen == SQL_NULL_DATA)
			{
				m_Nulls[fieldname] = true;
			}
			else
			{
				m_Nulls[fieldname] = false;
				m_Doubles[fieldname] = tdouble;
			}
		}
		else if (DataType == SQL_BIT)
		{
			long tlong;
			m_Types[fieldname] = DBO_LONG;
			SQLGetData(m_hStmt, i,SQL_C_SLONG,&tlong,sizeof(tlong), &StrLen);
			if (StrLen == SQL_NULL_DATA)
			{
				m_Nulls[fieldname] = true;
			}
			else
			{
				m_Nulls[fieldname] = false;
				m_Longs[fieldname] = tlong;
			}
		}
		else if ((DataType == SQL_VARCHAR) || (DataType == SQL_CHAR) || (DataType == SQL_WCHAR) || (DataType == SQL_WVARCHAR))
		{
			m_Types[fieldname] = DBO_STRING;
			SQLGetData(m_hStmt, i,SQL_C_CHAR ,longtextbuff, 65536, &StrLen);
			if (StrLen == SQL_NULL_DATA)
			{
				m_Nulls[fieldname] = true;
			}
			else
			{
				m_Nulls[fieldname] = false;
				m_Strings[fieldname] = (LPCSTR)longtextbuff;
			}
		}
		else if (DataType == SQL_TYPE_DATE)
		{
			m_Types[fieldname] = DBO_DATE;
			SQLGetData(m_hStmt, i, SQL_C_TYPE_TIMESTAMP, &time, sizeof(time), &StrLen);
			if (StrLen == SQL_NULL_DATA)
			{
				m_Nulls[fieldname] = true;
			}
			else
			{
				m_Nulls[fieldname] = false;
				m_Dates[fieldname] = COleDateTime(time.year, time.month, time.day, time.hour, time.minute, time.second);
			}
		}
		else if (DataType == SQL_GUID)
		{
			m_Types[fieldname] = DBO_STRING;
			SQLGetData(m_hStmt, i,SQL_C_CHAR ,&strbuff,1024, &StrLen);
			if (StrLen == SQL_NULL_DATA)
			{
				m_Nulls[fieldname] = true;
			}
			else
			{
				m_Nulls[fieldname] = false;
				m_Strings[fieldname] = (LPCSTR)strbuff;
			}
		}
		else if (DataType == SQL_TYPE_TIMESTAMP)
		{
			SQLGetData(m_hStmt, i, SQL_C_TYPE_TIMESTAMP, &time, sizeof(time), &StrLen);
			if (StrLen == SQL_NULL_DATA)
			{
				m_Nulls[fieldname] = true;
			}
			else
			{
				m_Nulls[fieldname] = false;
				m_Dates[fieldname] = COleDateTime(time.year, time.month, time.day, time.hour, time.minute, time.second);
			}
		}
	}
	return true;
#endif
}

/**********************************************************************
> bool DBO::GetBoolField(const TDVCHAR *pFieldName)

  Author: Jim Lynn
  Inputs: pFieldName - name of field to fetch
  Outputs: -
  Returns: true or false depending on value of field

  Purpose: gets value of boolean field

**********************************************************************/

bool DBO::GetBoolField(const TDVCHAR *pFieldName)
{
#ifdef __FLAGFIELDS
	CTDVString error;
	error << "Failed to find field " << pFieldName << " in GetBoolField";
	TDVASSERT(FieldExists(pFieldName),error);
#endif

	CTDVString fname = pFieldName;
	fname.MakeUpper();

#ifdef __MYSQL__
	if (m_Nulls[fname])
	{
		return false;
	}
	return (!m_Strings[fname].CompareText("0"));
#endif

	LONGMAP::const_iterator iter = m_Longs.find(fname);
	if ( iter != m_Longs.end() )
	{
		return (iter->second != 0);
	}
	return false;

//	long fieldnum = GetFieldNum(pFieldName);
//	if (fieldnum == -1 || m_pTypes[fieldnum] != DBO_LONG)
//	{
//		return false;
//	}
//	else
//	{
//		return (m_pTypes[fieldnum] != 0);
//	}

}

/*********************************************************************************
> bool DBO::AllocDataBuffers(long ColCount)

	Author:		Jim Lynn
	Inputs:		ColCount - number of columns in record
	Outputs:	-
	Returns:	true if successful, false otherwise
	Scope:		protected
	Purpose:	internal function to allocate storage for the fetched records

*********************************************************************************/

bool DBO::AllocDataBuffers(long ColCount)
{
	m_NumCols = ColCount;

	// in order to cope with different data types, we
	// allocate several buffers which can contain the data
	// we're interested in
	
/*
	m_pNames = new CTDVString[ColCount];
	if (!m_pNames)
	{
		m_NumCols = 0;
		return false;
	}

	m_pStrings = new CTDVString[ColCount];
	m_pLongs = new long[ColCount];
	m_pDates = new COleDateTime[ColCount];
	m_pDoubles = new double[ColCount];
	m_pNulls = new bool[ColCount];
	m_pTypes = new long[ColCount];

	// If any of these failed, call FreeDataBuffers
	if (!m_pStrings || !m_pLongs || !m_pDates || !m_pDoubles || !m_pNulls)
	{
		FreeDataBuffers();
		return false;
	}

*/
	return true;
}

/*********************************************************************************
> void DBO::FreeDataBuffers()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	-
	Scope:		protected
	Purpose:	Internal function to free up storage for fields in record

*********************************************************************************/

void DBO::FreeDataBuffers()
{
	// Free up all my buffers as necessary

	m_Longs.clear();
	m_Types.clear();
	m_Strings.clear();
#ifdef __MYSQL__
	if (m_NumCols == 0)
	{
		m_Names.clear();
	}
#else
	m_Names.clear();
#endif
	m_Nulls.clear();
	m_Types.clear();
	m_Dates.clear();
	m_Doubles.clear();
	
/*
	if (m_NumCols > 0)
	{
		delete m_pNames;
		m_pNames = NULL;
		delete m_pStrings;
		m_pStrings = NULL;		// The CTDVString destructors will be called
		delete m_pLongs;
		m_pLongs = NULL;
		delete m_pDates;
		m_pDates = NULL;
		delete m_pDoubles;
		m_pDoubles = NULL;
		delete m_pNulls;
		m_pNulls = NULL;
		delete m_pTypes;
		m_pTypes = NULL;

		m_NumCols = 0;
	}
*/
}

/*********************************************************************************
> bool DBO::IsGoodConnection()

	Author:		Jim Lynn
	Inputs:		-
	Outputs:	-
	Returns:	true if the database was successfully connected to,
				false otherwise.
	Purpose:	Used to check if the DBO object successfully connected to the
				destination database. Returns true if it did, false otherwise.

*********************************************************************************/

bool DBO::IsGoodConnection()
{
	return m_GoodConnection;
}

/*********************************************************************************

	bool DBO::GetLastError(CTDVString *oError)

	Author:		Jim Lynn
	Created:	28/03/2000
	Inputs:		-
	Outputs:	oError - string to contain the error/information message
				iError - error code
	Returns:	true if there *was* an error, false if not
	Purpose:	Asks the DBO object if the last statement failed because of an error
				or simply because there was no data to be found. Will return
				true if the last statement generated an error, and false if the last
				statement completed successfully. If true, oError is filled in with
				the error message and iError with error code provided by data source.

*********************************************************************************/

bool DBO::GetLastError(CTDVString *oError, int& iError)
{
	//Return retrieved info - results of a PRINT, Information returned with query etc.
	*oError = m_sLastError;
	if (m_bError)
	{
		iError = m_iLastErrorCode;
		return true;
	}
	else
	{
		return false;
	}
}


/*********************************************************************************

	bool DBO::FieldExists(const TDVCHAR* pFieldName)

	Author:		Kim Harries
	Created:	10/05/2000
	Inputs:		pFieldName - the name of the field to check the existence of
	Outputs:	-
	Returns:	true if the field exists, false if not
	Purpose:	Used when you simply want to check the existence of a particular
				field in the dataset returned by a query

*********************************************************************************/

bool DBO::FieldExists(const TDVCHAR* pFieldName)
{
	CTDVString fname = pFieldName;
	fname.MakeUpper();

	// iterate through all the names and if one matches pFieldName return true
	// otherwise return false
	STRLONGMAP::iterator MapIt;
	for (MapIt = m_Names.begin(); MapIt != m_Names.end(); MapIt++)
	{
		if ((*MapIt).second == fname)
		{
			return true;
		}
	}
	return false;
}
