#pragma once

#include "TDVString.h"

#include "DBO.h"


class CTDVDateTime;
//class DBO;
class CGI;
class CInputContext;

class CStoredProcedureBase
{
	friend class CGI;

	protected:	
		//TODO:IL:these should be private, but I cant do it now 
		//as some CStoredProcedure methods use them

		CTDVString m_sQuery;
		CTDVString m_sProcName;
		DBO* m_pDBO;
		CGI* m_pCGI;
		DBO* m_pReadDBO;
		DBO* m_pWriteDBO;

	public:
		CStoredProcedureBase();
		virtual ~CStoredProcedureBase();
		bool Initialise(CInputContext& inputContext);
		bool Release();

		void AddNullParam();
		void AddDefaultParam();

		bool AddUIDParam(const TDVCHAR* psUID);

		//void AddParam(long lParam);
		void AddParam(int iValue);
		void AddParam(double dValue);
		void AddParam(const TDVCHAR* pParam);
		void AddParam(const CTDVDateTime& dDate);

		//Named Parameters
		void AddNullParam(const TDVCHAR* pName);
		void AddDefaultParam(const TDVCHAR* pName);

		bool AddUIDParam(const TDVCHAR* pName, const TDVCHAR* psUID);

		//void AddParam(const TDVCHAR* pName, long lValue);
		void AddParam(const TDVCHAR* pName, int iValue);
		void AddParam(const TDVCHAR* pName, double dValue);
		void AddParam(const TDVCHAR* pName, const TDVCHAR* pValue);
		void AddParam(const TDVCHAR* pName, const CTDVDateTime& dDate);


		//Output Parameters
		void AddOutputParam( const TDVCHAR* pName, int* pValue, DBO::PARAMINOUTTYPE = DBO::OUTPARAM );
		void AddOutputParam( const TDVCHAR* pName, double* pParam, DBO::PARAMINOUTTYPE = DBO::OUTPARAM );
		void AddOutputParam( const TDVCHAR* pName, TDVCHAR* pParam, DBO::PARAMINOUTTYPE = DBO::OUTPARAM );
		void AddOutputParam( int* pValue, DBO::PARAMINOUTTYPE = DBO::OUTPARAM );
		void AddOutputParam( double* pParam, DBO::PARAMINOUTTYPE = DBO::OUTPARAM );
		void AddOutputParam( TDVCHAR* pParam, DBO::PARAMINOUTTYPE = DBO::OUTPARAM );

		//Request Return Value from Stored Procedure.
		void AddReturnParam(int* pValue);

		bool DoesStoredProcedureExist(const TDVCHAR *pSPName, bool& bSuccess);
		void StartStoredProcedure(const TDVCHAR* pProcName, bool bWrite = true);
		bool ExecuteStoredProcedure();
		bool CheckProcedureName(const TDVCHAR *pProcName);

		bool HandleError(const TDVCHAR *pFuncName);
		bool GetLastError(CTDVString* oError, int& iError);
		CTDVString GetLastError(int* pError = NULL);

		bool MoveNext(int NumRows = 1);
		bool IsEOF();

		bool GetBoolField(const TDVCHAR *pName);
		int GetIntField(const TDVCHAR *pName);
		double GetDoubleField(const TDVCHAR *pName);
		CTDVDateTime GetDateField(const TDVCHAR *pName);
		bool IsNULL(const TDVCHAR *pName);
		bool FieldExists(const TDVCHAR* pName);
		bool GetField(const TDVCHAR *pName, CTDVString &sResult);

		bool FormatDateField(const TDVCHAR* pName, const TDVCHAR* pFormat, CTDVString& sResult);

	protected:
		bool Initialise(DBO* pDBO, CGI* pCGI);
		void RealRelease();

	private:
		bool GetWriteConnection();

		// The Fix UID function
		bool FixBBCUID( CTDVString& UID );
};

