#ifndef PROFILEAPIBASE_H
#define PROFILEAPIBASE_H

#include <stdlib.h>
#include "..\..\bbcutil\include\Str.h"
#include <ConfFile.h>
#include <Configuration.h>
#include <MySqlDBConnection.h>
#include <SQL.h>
#include <ProfileErrorMessage.h>
#include <DBCursor.h>
#include <Code.h>
#include <assert.h>
#include <Constants.h>
#include "..\..\bbcutil\include\Dll.h"
#include <Countries.h>


#define PROFILE_MAX_ERROR_MSG_LEN	256		//maximum length of an error message returned by profile api

class CProfileApiContext;
class CProfileApi;

class DllExport CProfileApiBase
{
	friend class CProfileApiContext;
	friend class CProfileApi;
	
	protected:
	
		//
		//connections
		//
			
		bool m_bUsePrimarySlave;			//use primary slave for reading data rather than secondary one
		CConfiguration m_ReadConf;
		CConfiguration m_ReadBackupConf;
		CConfiguration m_WriteConf;
		CMySqlDBConnection m_ReadConnection;
		CMySqlDBConnection m_WriteConnection;
		
		
		//
		//error handling
		//
		
		unsigned long m_ulErrorNumber;
		unsigned long m_ulDbErrorNumber;
		char m_ErrorMessage[PROFILE_MAX_ERROR_MSG_LEN];
		
		
	private:
		//
		//default sql object Do and Fetch work with
		//
		
		CSQL m_Sql;
			
		//
		//initialization
		//
			
		bool m_bInitialised;

			
	public:
			
		//
		//Init
		//

		CProfileApiBase();
		virtual ~CProfileApiBase();
		virtual void Disconnect();
		bool IsInitialised();

		
		//
		//Functions for getting last error type, number and message.
		//

		const char* GetErrorMessage() const;
		unsigned long GetErrorNumber() const;
		unsigned long GetDbErrorNumber() const;


		//
		//transactions
		//

		bool BeginTransaction();
		bool EndTransaction(bool bSuccess);
		bool IsTransactionPending();

		
		//
		//connections
		//
		
		
		bool GetReadConnection();
		bool GetWriteConnection();
		
		
		//
		//codes. For example: pCategory is ONLINE_STATUS, codes list is
		//IDLE, AVAILABLE and descriptions are "user is online but idle",
		//"user is online and available".
		//

		bool GetCodeDescription(const char* pCategory, const char* pCode, CStr& codeDesc);
		bool GetCodes(const char* pCategory, CCodes& codes);

	
		//
		//countries
		//
		
		bool GetCountries(CCountries& countries);
		bool GetCountry(int iId, CCountry& country);
		
		//
		//encryption
		//
		
		bool Encrypt(const char *pSrc, CStr& crypted);

				
	protected:
			
		//
		//init
		//
			
		bool Initialise(const char* configpath);
		void Uninitialise();
			

		//
		//Error handling
		//

		void SetApiError(unsigned long ulErrorNumber, const char* pErrorMessage, ...);
		void SetDbError(CMySqlDBConnection& pConnection);
		
		
		//
		//SQL statements related
		//
		
		bool Fetch(CDBCursor& cursor);
		bool Do(unsigned long* pAffectedRows = NULL);
		unsigned long GetLastInsertId();

		//country
		void ReadCountry(CDBCursor& cursor, CCountry& country);
};


/*******************************************************************************************
inline const char* CProfileApiBase::GetErrorMessage() const
Author:		Igor Loboda
Created:	14/04/2003
Visibility:	public
Returns:	last error message. See PEM_* constants. Never returns NULL. Returns empty string when no error occured.
*******************************************************************************************/

inline const char* CProfileApiBase::GetErrorMessage() const
{
	return m_ErrorMessage;
}


/*******************************************************************************************
inline unsigned long CProfileApiBase::GetErrorNumber() const
Author:		Igor Loboda
Created:	14/04/2003
Visibility:	public
Returns:	last error number. See PEN_* constants
*******************************************************************************************/

inline unsigned long CProfileApiBase::GetErrorNumber() const
{
	return m_ulErrorNumber;
}


/*******************************************************************************************
inline unsigned long CProfileApiBase::GetDbErrorNumber() const
Author:		Igor Loboda
Created:	28/04/2003
Visibility:	public
Returns:	last database error number. Call this if a method returned PEN_DB_ERROR which indicates
			that an error occurend on the database level.
*******************************************************************************************/

inline unsigned long CProfileApiBase::GetDbErrorNumber() const
{
	return m_ulDbErrorNumber;
}


/*******************************************************************************************
inline void CProfileApiBase::Uninitialise()
Author:		Igor Loboda
Created:	09/06/2003
Visibility:	protected
*******************************************************************************************/

inline void CProfileApiBase::Uninitialise()
{
	m_bInitialised = false;
}

#endif
