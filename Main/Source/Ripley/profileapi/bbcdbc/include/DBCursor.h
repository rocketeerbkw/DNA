#ifndef DBCURSOR_H
#define DBCURSOR_H

#include <map>
#include <string>
#include <assert.h>
#include <Dll.h>

using namespace std;

typedef map<string, int> FldNamesMap;

/******************
class CDBCursor

Author:		Michael Ryan, Igor Loboda
Created:	1/08/02
Purpose:	This class is data containter. It provides read and write access to the 
			data in it. Usually the data is filled by a class which reads data from
			database. Writing/changing data in the instance of this class does not
			have any effect on the original source of data (i.e. database). The data
			access provided by this class is completely open and calling environment 
			may	change the content of the object and state of this object is completely
			calling	environment responsibility after the object is handed off to it.
*******************/

class DllExport CDBCursor 
{
	protected:
		unsigned int m_uiCols;				//number of columns in resultset
		unsigned long m_ulRows;				//number of rows in resultset
		unsigned long m_ulAffectedRows;		//number of rows affected by query
		unsigned long m_ulCurFetchPos;		//index of the current row
		char *** m_pppData;					//data
		unsigned long** m_ppDataLength;		//data length for each column in each row
		FldNamesMap m_FieldNames;			//maps column name to column index
	
	public:
		CDBCursor();
		virtual ~CDBCursor();
		char **FetchRow();
		char **FetchRowAt(unsigned long rowNbr);
		char ***FetchAllRows();
		unsigned long ColumnLength(unsigned int columnNbr);
		unsigned long ColumnLengthAt(unsigned long rowNbr, unsigned int columnNbr);
		void Initialise();
		unsigned long Rows();
		unsigned int Cols();
		void SetAffectedRows(unsigned long ulRows);
		void SetRows(unsigned long rows);
		void SetCols(unsigned int columns);
		void SetData(char*** pppData);
		void SetDataLength(unsigned long** ppDataLength);
		unsigned long GetCurFetchPos();
		void SetCurFetchPos(unsigned long ulCurFetchPos);
		void MapFieldName(const char* name, unsigned int ix);
		unsigned int GetFieldIx(const char* name);
		char* GetColumn(char** pRow, const char* pColumnName);
		char* GetColumn(const char* pColumnName);
		unsigned long GetULongColumn(char** pRow, const char* pColumnName);
		unsigned long GetULongColumn(const char* pColumnName);
		int GetIntColumn(char** pRow, const char* pColumnName);
		int GetIntColumn(const char* pColumnName);
		bool GetBoolColumn(char** pRow, const char* pColumnName);
		bool GetBoolColumn(const char* pColumnName);
		

	protected:
		virtual void FreeData();
			
	private:
};


/******************
inline unsigned long CDBCursor::Rows() 

Author:		Michael Ryan, Igor Loboda
Created:	2/08/02
Returns:	number of rows in resultset
*******************/

inline unsigned long CDBCursor::Rows() 
{
	return(m_ulRows);
}


/******************
inline unsigned int CDBCursor::Cols() 

Author:		Michael Ryan, Igor Loboda
Created:	2/08/02
Returns:	number of columns in resultset
*******************/

inline unsigned int CDBCursor::Cols() 
{
	return(m_uiCols);
}


/******************
inline unsigned long CDBCursor::GetCurFetchPos()

Author:		Michael Ryan, Igor Loboda
Created:	2/08/02
Returns:	index of current row in the resultset
*******************/

inline unsigned long CDBCursor::GetCurFetchPos()
{
	return m_ulCurFetchPos;
}

#endif
