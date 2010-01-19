#ifndef SQL_H
#define SQL_H

#include <Str.h>
#include <stdlib.h>
#include <Dll.h>


class DllExport CSQL 
{
	protected:
      CStr m_Statement;
      CStr m_SetStatement;

      bool m_bPreparedSet;
      
      int m_iParamIndex;
			
	public:
		void PrepareSetSQLForParams(const char* pSql);
		void PrepareNonSetSQLForParams(const char* pSql);
		
		void AddNullParam();
		void AddIntParam(int iParam);
		void AddBoolParam(bool bParam);
		void AddStringParam(const char* pParam);
		void AddDoubleParam(double dParam);
		void AddUIntParam(unsigned int iParam);
		void AddULongParam(unsigned long ulParam);
		void AddSQLParam(const char* pParam);

		const char *GetSetStatement();
		const char *GetSQLStatement();

		bool IsPreparedAsSet();

	protected:
		void AddEscapedParam(const char* pParam, bool bRawSql = false);
};


/*******************************************************************************************
inline bool CSQL::IsPreparedAsSet()
Visibility:	public
Purpose:	Determine if the SQL statement was prepared via PrepareSetSQL(). If so then there
                will be a SET statement and an SQL statement.
Returns:	true - prepared using PrepareSetSQL()
                false - NOT prepared using PrepareSetSQL()
*******************************************************************************************/

inline bool CSQL::IsPreparedAsSet()
{
   return m_bPreparedSet;
}

#endif
