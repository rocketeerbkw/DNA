// DBO.h: interface for the DBO class.
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


#if !defined(AFX_DBO_H__42263226_03C5_11D3_86FB_00A0C941F4C7__INCLUDED_)
#define AFX_DBO_H__42263226_03C5_11D3_86FB_00A0C941F4C7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#pragma warning(disable:4786)
#include <afxdisp.h>

#ifdef __MYSQL__
#define __LCC__
#include <mysql.h>
#endif

#include <vector>

#include <sql.h>
#pragma warning(disable:4786)
#include <sqlext.h>
#pragma warning(disable:4786)
#include <sqltypes.h>
//#import "c:\program files\common files\system\ado\msado15.dll" no_namespace rename("EOF", "EndOfFile")
#pragma warning(disable:4786)
#include "TDVString.h"
#pragma warning(disable:4786)

#include <map>

using namespace std ;
typedef map<CTDVString, long> LONGMAP;
typedef map<CTDVString, double> DBLMAP;
typedef map<CTDVString, COleDateTime> DATEMAP;
typedef map<CTDVString, bool> BOOLMAP;
typedef map<CTDVString, CTDVString> STRMAP;
typedef map<long, CTDVString> STRLONGMAP;

#include "TDVDateTime.h"

// Note: These are copied from odbcss.h to avoid having to include it (which can't compile in VC2005).

#define SQL_DIAG_SS_BASE		(-1150)
#define SQL_DIAG_SS_MSGSTATE	(SQL_DIAG_SS_BASE)
#define SQL_DIAG_SS_SEVERITY	(SQL_DIAG_SS_BASE-1)
#define SQL_DIAG_SS_SRVNAME 	(SQL_DIAG_SS_BASE-2)
#define SQL_DIAG_SS_PROCNAME	(SQL_DIAG_SS_BASE-3)
#define SQL_DIAG_SS_LINE		(SQL_DIAG_SS_BASE-4)


class CDBConnection
{
public:
	CDBConnection();
	CDBConnection(const CDBConnection& other);
	virtual ~CDBConnection();
	bool Initialise(const TDVCHAR* pConnString);
	CTDVString GetConnectionString();
protected:
	CTDVString m_ConnectionString;
};

class CMySQLConnection : public CDBConnection
{
public:
	CMySQLConnection();
	virtual ~CMySQLConnection();
	CMySQLConnection(const CMySQLConnection& other);
	bool Initialise(const TDVCHAR* pServer, const TDVCHAR* pDatabase, const TDVCHAR* pUsername, const TDVCHAR* pPassword, int iPort);
	const char*GetServer();
	const char*GetDatabase();
	const char*GetUsername();
	const char*GetPassword();
	int GetPort();
protected:
	CTDVString	m_ServerName;
	CTDVString	m_DatabaseName;
	CTDVString	m_UserName;
	CTDVString	m_Password;
	int			m_iPort;
};

/*

Database Access object wrapper

Wraps all database access up into useful functions so programmers don't need to
obsess about the details

*/

/*

Class: DBO
Methods:	StartStoredProcedure (procedure name
			AddParam(param);
			AddParam(paramName, paramValue);
			Execute;
			EOF;
			NextRow;
			GetField(fieldname);


*/

class DBO  
{
private:

	//Structure gathering information necessary for parameter binding.
	struct SQLPARAMETER
	{
	SQLSMALLINT		m_SQLType;
	SQLSMALLINT		m_ParameterCType;
	SQLPOINTER		m_pData;
	SQLSMALLINT		m_InputOutputType;
	SQLUINTEGER		m_ParamSize;
	SQLSMALLINT     m_DecimalDigits;
	int				m_DescLen;
	SQLINTEGER		m_DescLenOrInd;
	bool			m_bOwnData;
	CTDVString		m_sName;

	~SQLPARAMETER();
	};

	void DiagnoseError();
	bool DiagnoseErrorInResults();

	bool MoreResults(int& columns);

	//Disable Copying.
	DBO (const DBO& dbo) {}
public:     
	enum PARAMINOUTTYPE
	{	INOUTPARAM, OUTPARAM
	};

	DBO(CDBConnection* pConn);
	virtual ~DBO();

	virtual bool GetLastError(CTDVString* oError, int& iError);
	virtual bool FieldExists(const TDVCHAR* pName);
	virtual bool GetBoolField(const TDVCHAR* pFieldName);
	virtual bool MoveNext(int NumRows = 1);
	virtual CTDVString GetField(long iFieldNum);
	virtual CTDVString GetFieldName(long lFieldNum);
	virtual DWORD GetNumFields();
	bool m_bFirstProcParam;
	
	virtual void SetQuery(const TDVCHAR* pQuery);
	virtual bool IsEOF();
	virtual bool IsGoodConnection();
	virtual long GetFieldNum(const TDVCHAR* pFieldName);
	
	virtual CTDVString GetField(const TDVCHAR* pFieldName);
	virtual long GetLongField(const TDVCHAR* pFieldName);
	virtual double GetDoubleField(const TDVCHAR* pFieldName);
	virtual CTDVDateTime GetDateField(const TDVCHAR* pFieldName);
	virtual CTDVString GetRelativeDateField(const TDVCHAR* pFieldName);
	virtual CTDVString FormatDateField(const TDVCHAR* pFieldName, const TDVCHAR* pFormat);
	virtual bool IsNull(const TDVCHAR* pFieldName);

	virtual bool ExecuteQuery();
	virtual bool ExecuteQuery2();
	virtual bool ExecuteQuery(const TDVCHAR* pQuery);
	virtual bool ExecuteStoredProcedure();
	virtual bool ExecuteStoredProcedure2();
	virtual void StartStoredProcedure(const TDVCHAR* pProcName);
	virtual void StartStoredProcedure2(const TDVCHAR* pProcName);

	void AddNullParam(  );
	void AddNullParam( const TDVCHAR* pName  );

	void AddDefaultParam( );
	void AddDefaultParam( const TDVCHAR* );
	
	void AddParam(const TDVCHAR* pName, double param );
	void AddParam(double param );

	void AddParam(const TDVCHAR* pName, int param );
	void AddParam(int param );

	//void AddParam(const TDVCHAR* pName, long param );
	//void AddParam(long param );

	void AddParam(const TDVCHAR* pName, const TDVCHAR* pValue  );
	void AddParam( const TDVCHAR*  pparam  );

	void AddParam(const TDVCHAR* pName, const WCHAR* pValue );

	void AddParam( const CTDVDateTime& datetime );
	void AddParam( const TDVCHAR* pName, const CTDVDateTime& datetime );

	void AddOutputParam( int* pParam, PARAMINOUTTYPE ParamInOutType = OUTPARAM );
	void AddOutputParam( const TDVCHAR* pName, int* pParam, PARAMINOUTTYPE ParamInOutType = OUTPARAM );

	void AddOutputParam( double* pParam, PARAMINOUTTYPE ParamInOutType = OUTPARAM );
	void AddOutputParam( const TDVCHAR* pName, double* pParam, PARAMINOUTTYPE ParamInOutType = OUTPARAM );

	void AddOutputParam( TDVCHAR* pParam, int size, PARAMINOUTTYPE ParamInOutType = OUTPARAM );
	void AddOutputParam( const TDVCHAR* pName, TDVCHAR* pParam, int size, PARAMINOUTTYPE ParamInOutType = OUTPARAM );

	//Allows return value to be retrieved
	void AddReturnParam(int* pParam);


protected:
	CTDVString m_sLastError;
	int m_iLastErrorCode;
	bool m_bError;

	virtual bool AllocDataBuffers(long ColCount);
	virtual void FreeDataBuffers();

#ifdef __MYSQL__
		MYSQL * m_pconnection;
		MYSQL m_mysql;
		MYSQL_RES* m_pResult;
		MYSQL_ROW m_Row;
#endif

	CTDVString m_strSQLQuery;
	CTDVString m_strStoredProcedure;

	//_RecordsetPtr m_RecordSet;
	//_ConnectionPtr m_Connection;
	
	// Environment handle
	SQLHENV m_hEnv;
	// ODBC connection handle
	SQLHDBC m_hConn;
	// ODBC statement handle
	SQLHSTMT m_hStmt;

	bool m_EOF;		// So we know if there's more data to come
	bool m_GoodConnection;	// false if we've failed to connect for some reason

	int		m_NumCols;		// number of columns of data in buffers

	SQLPARAMETER* m_pReturnParam;	//Contains return value of stored procedure.
	

	// buffers for storing row data.
//	char** m_ppNames;		// column names array
//	char** m_ppStrings;		// string values

/*
	CTDVString* m_pStrings;
	CTDVString* m_pNames;
	long* m_pLongs;			// Long values
	COleDateTime* m_pDates;	// date values
	double* m_pDoubles;		// floating point values
	bool* m_pNulls;			// flags for null columns
	long* m_pTypes;			// type of variable
*/
	STRMAP m_Strings;		// associative map for strings
	STRLONGMAP m_Names;		// Associates names with indices
	LONGMAP m_Longs;
	DATEMAP m_Dates;
	BOOLMAP m_Nulls;
	DBLMAP m_Doubles;
	LONGMAP m_Types;
	LONGMAP m_ColMap;		// Maps column names to field numbers

	std::vector<SQLPARAMETER*>	m_Parameters;	//Parameters to stored procedure.
	
	enum DBO_TYPE
	{
		DBO_LONG,
		DBO_STRING,
		DBO_DATE,
		DBO_FLOAT
	};
};


#endif // !defined(AFX_DBO_H__42263226_03C5_11D3_86FB_00A0C941F4C7__INCLUDED_)
