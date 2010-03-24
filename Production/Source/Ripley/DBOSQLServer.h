// DBOSQLServer.h: interface for the DBOSQLServer class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_DBOSQLSERVER_H__6ED85A70_1B69_46FC_A79E_FFE45882918F__INCLUDED_)
#define AFX_DBOSQLSERVER_H__6ED85A70_1B69_46FC_A79E_FFE45882918F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#pragma warning(disable:4786)
#include <afxdisp.h>

#ifdef __MYSQL__
#define __LCC__
#include <mysql.h>
#endif


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

class DBOSQLServer : public DBO  
{
	virtual ~DBOSQLServer();
	/*
public:
	virtual bool GetLastError(CTDVString* oError, int& iError);
	virtual bool FieldExists(const TDVCHAR* pName);
	virtual bool GetBoolField(const TDVCHAR* pFieldName);
	virtual bool MoveNext(int NumRows = 1);
	virtual CTDVString GetField(long iFieldNum);
	virtual CTDVString GetFieldName(long lFieldNum);
	virtual DWORD GetNumFields();
	virtual void AddNullParam();
	virtual void AddParam(long lParam);
	virtual void AddParam(int iValue);									// added by Kim 31/10/2000
	virtual void AddParam(double dValue);								// added by Kim 31/10/2000
	virtual void AddParam(const TDVCHAR* pParam);
	virtual void AddParam(const TDVCHAR* pName, const TDVCHAR* pValue);	// added by Kim 15/03/2000
	virtual void AddParam(const TDVCHAR* pName, long lValue);			// added by Kim 15/03/2000
	virtual void AddParam(const TDVCHAR* pName, int iValue);			// added by Kim 31/10/2000
	virtual void AddParam(const TDVCHAR* pName, double dValue);			// added by Kim 31/10/2000
	virtual void AddNullParam(const TDVCHAR* pName);					// added by Kim 15/03/2000
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
	virtual bool ExecuteQuery(const TDVCHAR* pQuery);
	virtual bool ExecuteStoredProcedure();
	virtual void StartStoredProcedure(const TDVCHAR* pProcName);
	DBOSQLServer(CDBConnection* pConn);
	

protected:
	virtual bool AllocDataBuffers(long ColCount);
	virtual void FreeDataBuffers();



	*/

};


#endif // !defined(AFX_DBOSQLSERVER_H__6ED85A70_1B69_46FC_A79E_FFE45882918F__INCLUDED_)
