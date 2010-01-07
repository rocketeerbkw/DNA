#include "stdafx.h"
#include ".\storedprocedurebase.h"
#include "TDVDateTime.h"
#include "DBO.h"
#include "CGI.h"
#include "InputContext.h"

CStoredProcedureBase::CStoredProcedureBase()
:m_pDBO(NULL), m_pCGI(NULL), m_pReadDBO(NULL), m_pWriteDBO(NULL)
{
}



bool CStoredProcedureBase::Initialise(CInputContext& inputContext)
{
	return inputContext.InitialiseStoredProcedureObject(*this);
}


bool CStoredProcedureBase::Initialise(DBO* pDBO, CGI* pCGI)
{
	if (m_pReadDBO != NULL) 
	{
		delete m_pReadDBO;
		m_pReadDBO = NULL;
	}
	if (m_pWriteDBO != NULL) 
	{
		delete m_pWriteDBO;
		m_pWriteDBO = NULL;
	}

	m_pReadDBO = pDBO;
	m_pDBO = pDBO;
	m_pCGI = pCGI;

	return true;
}


CStoredProcedureBase::~CStoredProcedureBase()
{
	RealRelease();
}

/*********************************************************************************
void CStoredProcedureBase::RealRelease()
Author:		Igor Loboda
Created:	2005/07/19
Purpose:	releases database connections
*********************************************************************************/

void CStoredProcedureBase::RealRelease()
{
	if (m_pReadDBO != NULL) 
	{
		delete m_pReadDBO;
		m_pReadDBO = NULL;
	}
	if (m_pWriteDBO != NULL) 
	{
		delete m_pWriteDBO;
		m_pWriteDBO = NULL;
	}
	m_pDBO = NULL;
}

/*********************************************************************************

	void CStoredProcedureBase::StartStoredProcedure(const TDVCHAR *pProcName, bool bWrite)

	Author:		Jim Lynn
	Created:	03/03/2000
	Inputs:		pProcName - name of stored procedure
				bWrite - true if the SP requires a write connection, false if it's only a read SP
	Outputs:	-
	Returns:	-
	Purpose:	Starts building the stored procedure - helper function which
				passes info to the database object

*********************************************************************************/

void CStoredProcedureBase::StartStoredProcedure(const TDVCHAR *pProcName, bool bWrite)
{
	if (bWrite) 
	{
		GetWriteConnection();
		m_pDBO = m_pWriteDBO;
	}
	else
	{
		m_pDBO = m_pReadDBO;
	}

	//sql performance optimization
	CTDVString sProcName;
	sProcName << "dbo." << pProcName;
	sProcName.MakeLower( );

	m_pDBO->StartStoredProcedure(sProcName);
	m_sProcName = sProcName;
}

/*********************************************************************************

	bool CStoredProcedureBase::CheckProcedureName(const TDVCHAR *pProcName)

	Author:		Mark Neves
	Created:	31/07/2003
	Inputs:		pProcName = ptr to SP name
	Outputs:	-
	Returns:	true if the name of the stored procedure matches pProcName
	Purpose:	Checks the given name against the name of the stored procedure used
				in the last call to StartStoredProcedure.

*********************************************************************************/

bool CStoredProcedureBase::CheckProcedureName(const TDVCHAR *pProcName)
{
	return m_sProcName.CompareText(CTDVString("dbo.") << pProcName);
}


/*********************************************************************************

	void CStoredProcedureBase::AddNullParam()

	Author:		Jim Lynn
	Created:	03/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Appends a NULL parameter to the stored procedure query

*********************************************************************************/

void CStoredProcedureBase::AddNullParam()
{
	m_pDBO->AddNullParam();
}

void CStoredProcedureBase::AddDefaultParam()
{
	m_pDBO->AddDefaultParam();
}

void CStoredProcedureBase::AddDefaultParam( const TDVCHAR* pName)
{
	m_pDBO->AddDefaultParam();
}

/*********************************************************************************

	void CStoredProcedureBase::AddParam(long lParam)

	Author:		Jim Lynn
	Created:	03/03/2000
	Inputs:		lParam - integer parameter to pass to stored procedure
	Outputs:	-
	Returns:	-
	Purpose:	appends an integer parameter to the stored procedure

*********************************************************************************/

/*void CStoredProcedureBase::AddParam(long lParam)
{
	m_pDBO->AddParam(lParam);
}*/

/*********************************************************************************

	void CStoredProcedureBase::AddParam(int iValue)

	Author:		Kim Harries
	Created:	31/10/2000
	Inputs:		iValue - integer parameter to pass to stored procedure
	Outputs:	-
	Returns:	-
	Purpose:	appends an integer parameter to the stored procedure

*********************************************************************************/

void CStoredProcedureBase::AddParam(int iValue)
{
	m_pDBO->AddParam(iValue);
}

/*********************************************************************************

	void CStoredProcedureBase::AddParam(double dValue)

	Author:		Kim Harries
	Created:	31/10/2000
	Inputs:		dValue - double parameter to pass to stored procedure
	Outputs:	-
	Returns:	-
	Purpose:	appends a floating point parameter to the stored procedure

*********************************************************************************/

void CStoredProcedureBase::AddParam(double dValue)
{
	m_pDBO->AddParam(dValue);
}

/*********************************************************************************

	void CStoredProcedureBase::AddParam(const TDVCHAR* pParam)

	Author:		Jim Lynn
	Created:	03/03/2000
	Inputs:		pParam - string containing the parameter
	Outputs:	-
	Returns:	-
	Purpose:	appends the string parameter to the stored procedure

*********************************************************************************/

void CStoredProcedureBase::AddParam(const TDVCHAR* pParam)
{
	m_pDBO->AddParam(pParam);
}

/*********************************************************************************

	void CStoredProcedureBase::AddNullParam(const TDVCHAR* pName)

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Appends a NULL parameter with the given name to the stored procedure
				query.

*********************************************************************************/

void CStoredProcedureBase::AddNullParam(const TDVCHAR* pName)
{
	m_pDBO->AddNullParam(pName);
}

/*********************************************************************************

	void CStoredProcedureBase::AddParam(const TDVCHAR* pName, long lValue)

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		pName - name of the parameter to add to SP
				lValue - integer parameter to pass to stored procedure
	Outputs:	-
	Returns:	-
	Purpose:	appends an integer parameter with the given name to the stored
				procedure

*********************************************************************************/

/*void CStoredProcedureBase::AddParam(const TDVCHAR* pName, long lValue)
{
	//sql performance optimization
	CTDVString sName (pName);
	sName.MakeLower( );

	m_pDBO->AddParam(sName, lValue);
}*/

/*********************************************************************************

	void CStoredProcedureBase::AddParam(const TDVCHAR* pName, int iValue)

	Author:		Kim Harries
	Created:	31/10/2000
	Inputs:		pName - name of the parameter to add to SP
				iValue - integer parameter to pass to stored procedure
	Outputs:	-
	Returns:	-
	Purpose:	appends an integer parameter with the given name to the stored
				procedure

*********************************************************************************/

void CStoredProcedureBase::AddParam(const TDVCHAR* pName, int iValue)
{
	//sql performance optimization
	CTDVString sName (pName);
	sName.MakeLower( );

	m_pDBO->AddParam(sName, iValue);
}

/*********************************************************************************

	void CStoredProcedureBase::AddParam(const TDVCHAR* pName, double dValue)

	Author:		Kim Harries
	Created:	31/10/2000
	Inputs:		pName - name of the parameter to add to SP
				dValue - double parameter to pass to stored procedure
	Outputs:	-
	Returns:	-
	Purpose:	appends a floating point parameter with the given name to the stored
				procedure

*********************************************************************************/

void CStoredProcedureBase::AddParam(const TDVCHAR* pName, double dValue)
{
	//sql performance optimization
	CTDVString sName (pName);
	sName.MakeLower( );

	m_pDBO->AddParam(sName, dValue);
}

/*********************************************************************************

	void CStoredProcedureBase::AddParam(const TDVCHAR* pName, const TDVCHAR* pValue)

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		pName - naem of the parameter to add
				pValue - value to give the new parameter in the SP
	Outputs:	-
	Returns:	-
	Purpose:	appends the string parameter with the given name and value to the
				stored procedure

*********************************************************************************/

void CStoredProcedureBase::AddParam(const TDVCHAR* pName, const TDVCHAR* pValue)
{
	//sql performance optimization
	CTDVString sName (pName);
	sName.MakeLower( );

	m_pDBO->AddParam(sName, pValue);
}

/*********************************************************************************

	void CStoredProcedureBase::AddParam(const TDVCHAR* pName, const CTDVDateTime &dDate)

		Author:		Mark Howitt
        Created:	19/04/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

void CStoredProcedureBase::AddParam(const TDVCHAR* pName, const CTDVDateTime &dDate)
{
	//sql performance optimization
	CTDVString sName (pName);
	sName.MakeLower( );

	//CTDVString sParam = (LPCSTR)dDate.Format("%Y-%m-%d %H:%M:%S");
	//AddParam(sName,sParam);
	m_pDBO->AddParam(pName, dDate);
}

/*********************************************************************************

	void CStoredProcedureBase::AddParam(const CTDVDateTime &dDate)

		Author:		Mark Howitt
        Created:	19/04/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
void CStoredProcedureBase::AddParam(const CTDVDateTime &dDate)
{
	//CTDVString sParam = (LPCSTR)dDate.Format("%Y-%m-%d %H:%M:%S");
	//AddParam(sParam);
	m_pDBO->AddParam(dDate);
}

/*********************************************************************************

	void CStoredProcedureBase::AddOutputParam( int* pParam, DBO::PARAMINOUTTYPE InOutType )

	Author:		Martin Robb
	Created:	18/03/2005
	Inputs:		InOutType - OUT or INOUT, pParam
	Outputs:	- int* pParam
	Returns:	- None
	Purpose:	Adds a reference to an output/ inout parameter 

*********************************************************************************/
void CStoredProcedureBase::AddOutputParam( int* pParam, DBO::PARAMINOUTTYPE InOutType )
{
	m_pDBO->AddOutputParam( pParam, InOutType );
}

/*********************************************************************************

	void CStoredProcedureBase::AddOutputParam( double* pParam, DBO::PARAMINOUTTYPE InOutType )

	Author:		Martin Robb
	Created:	18/03/2005
	Inputs:		InOutType - OUT or INOUT, pParam
	Outputs:	- double* pParam
	Returns:	- None
	Purpose:	Adds a reference to an output/ inout parameter 

*********************************************************************************/
void CStoredProcedureBase::AddOutputParam( double* pParam, DBO::PARAMINOUTTYPE InOutType )
{
	m_pDBO->AddOutputParam( pParam, InOutType );
}

/*********************************************************************************

	void CStoredProcedureBase::AddOutputParam( TDVCHAR* pParam, DBO::PARAMINOUTTYPE InOutType )

	Author:		Martin Robb
	Created:	18/03/2005
	Inputs:		InOutType - OUT or INOUT, pParam
	Outputs:	- TDVCHAR* pParam
	Returns:	- None
	Purpose:	Adds a reference to an output/ inout parameter 

*********************************************************************************/
void CStoredProcedureBase::AddOutputParam( TDVCHAR* pParam, DBO::PARAMINOUTTYPE InOutType )
{
	m_pDBO->AddOutputParam( pParam, InOutType );
}

/*********************************************************************************

	void CStoredProcedureBase::AddOutputParam(const TDVCHAR* pName, int* pParam, DBO::PARAMINOUTTYPE InOutType )

	Author:		Martin Robb
	Created:	18/03/2005
	Inputs:		Parameter Name, InOutType - OUT or INOUT, pParam
	Outputs:	- int* pParam
	Returns:	- None
	Purpose:	Adds a reference to an output/ inout parameter 

*********************************************************************************/
void CStoredProcedureBase::AddOutputParam(const TDVCHAR* pName, int* pParam, DBO::PARAMINOUTTYPE InOutType )
{
	//sql performance optimization
	CTDVString sName (pName);
	sName.MakeLower( );

	m_pDBO->AddOutputParam(sName, pParam, InOutType );
}

/*********************************************************************************

	void CStoredProcedureBase::AddOutputParam(const TDVCHAR* pName, double* pParam, DBO::PARAMINOUTTYPE InOutType )

	Author:		Martin Robb
	Created:	18/03/2005
	Inputs:		Parameter Name, InOutType, InOutType - OUT or INOUT, pParam
	Outputs:	- pParam 
	Returns:	- None
	Purpose:	Adds a reference to an output/ inout parameter 

*********************************************************************************/
void CStoredProcedureBase::AddOutputParam(const TDVCHAR* pName, double* pParam, DBO::PARAMINOUTTYPE InOutType )
{
	//sql performance optimization
	CTDVString sName (pName);
	sName.MakeLower( );

	m_pDBO->AddOutputParam(sName, pParam, InOutType);
}

/*********************************************************************************

	void CStoredProcedureBase::AddOutputParam(const TDVCHAR* pName, TDVCHAR* pParam, DBO::PARAMINOUTTYPE InOutType )

	Author:		Martin Robb
	Created:	18/03/2005
	Inputs:		Parameter Name, InOutType,InOutType - OUT or INOUT,  allocated TDVCHAR* pParam 
	Outputs:	- TDVCHAR* pParam 
	Returns:	- None
	Purpose:	Adds a reference to an output/ inout parameter 

*********************************************************************************/
void CStoredProcedureBase::AddOutputParam(const TDVCHAR* pName, TDVCHAR* pParam, DBO::PARAMINOUTTYPE InOutType )
{
	//sql performance optimization
	CTDVString sName (pName);
	sName.MakeLower( );

	m_pDBO->AddOutputParam(sName, pParam, InOutType);
}

/*********************************************************************************

	void CStoredProcedureBase::AddReturnParam( int* pParam )

	Author:		Martin Robb
	Created:	03/05/2005
	Inputs:		None
	Outputs:	- int* pReturnValue
	Returns:	- None
	Purpose:	Retrieves return value from stored procedure

*********************************************************************************/
void CStoredProcedureBase::AddReturnParam( int* pReturnValue )
{
	m_pDBO->AddReturnParam(pReturnValue);
}

/*********************************************************************************

	void CStoredProcedureBase::ExecuteStoredProcedure()

	Author:		Jim Lynn
	Created:	03/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true on success
	Purpose:	Executes a previously built stored procedure.

*********************************************************************************/

bool CStoredProcedureBase::ExecuteStoredProcedure()
{
	CTDVString sTimerMess;
	sTimerMess << "Executing " << m_sProcName;
	m_pCGI->LogTimerEvent(sTimerMess);
	sTimerMess.Empty();
	if (!m_pDBO->ExecuteStoredProcedure())
	{
		CTDVString sError;
		int iError;
		m_pDBO->GetLastError(&sError, iError);
		m_pCGI->WriteInputLog(sError);
		sTimerMess << "Failed to execute " << m_sProcName;
		m_pCGI->LogTimerEvent(sTimerMess);
		return false;
	}
	sTimerMess << "Executed " << m_sProcName;
	m_pCGI->LogTimerEvent(sTimerMess);

	return true;
}

bool CStoredProcedureBase::GetWriteConnection()
{
	if (m_pWriteDBO == NULL) 
	{
		m_pWriteDBO = m_pCGI->GetWriteDatabaseObject();
	}
	return (m_pWriteDBO != NULL);
}



/*********************************************************************************

	bool CStoredProcedure::Release()

	Author:		Jim Lynn
	Created:	08/03/2002
	Inputs:		-
	Outputs:	-
	Returns:	true if connection was deleted, false if object was uninitialised
	Purpose:	This releases the database connection for this stored procedure object.
				You should use this call if you call a stored procedure early in
				your code, and have finished with the results (for example when calling
				a stored procedure which simply returns a single result, not a result
				set). This prevents the connection from being held open more than is 
				necessary, and prevents too much locking of database resources.

				If you don't call this function, the connection will be released
				when the StoredProcedure's destructor is called. If the SP is never
				destroyed, you will leak a connection object, and eventually cause
				problems because of the number of connections being held open (and
				possibly locking resources in the database server or on the client
				machine).

*********************************************************************************/

bool CStoredProcedureBase::Release()
{
	TDVASSERT(m_pDBO != NULL, "Attempting to release uninitialised stored procedure");

	if (m_pDBO != NULL)
	{
		RealRelease();
		return true;
	}
	else
	{
		return false;
	}
}
/*********************************************************************************

	bool CStoredProcedure::GetLastError(CTDVString* oError)

	Author:		Jim Lynn
	Created:	28/03/2000
	Inputs:		-
	Outputs:	oError - string to contain the error
				iError - error code
	Returns:	true if an error was reported, false otherwise
	Purpose:	Asks the DBO object if the last statement failed because of an error
				or simply because there was no data to be found. Will return
				true if the last statement generated an error, and false if the last
				statement completed successfully. If true, oError is filled in with
				the error message and iError with error code specific to data source.

*********************************************************************************/

bool CStoredProcedureBase::GetLastError(CTDVString* oError, int& iError)
{
	return m_pDBO->GetLastError(oError, iError);
}

/*********************************************************************************

	CTDVString CStoredProcedureBase::GetLastError(int* pError)

		Author:		Mark Neves
        Created:	26/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Same as the other GetLastError(), except it returns the error string

*********************************************************************************/

CTDVString CStoredProcedureBase::GetLastError(int* pError)
{
	int iError = 0;
	if (pError == NULL) pError = &iError;

	CTDVString sError;
	m_pDBO->GetLastError(&sError,*pError);

	return sError;
}


/*
bool CStoredProcedureBase::Initialise(DBO *pDBO, CGI* pCGI)
{
	if (m_pReadDBO != NULL) 
	{
		delete m_pReadDBO;
		m_pReadDBO = NULL;
	}
	if (m_pWriteDBO != NULL) 
	{
		delete m_pWriteDBO;
		m_pWriteDBO = NULL;
	}

	m_pReadDBO = pDBO;
	m_pDBO = pDBO;
	m_pCGI = pCGI;

	return true;
}
*/


bool CStoredProcedureBase::IsEOF()
{
	return m_pDBO->IsEOF();
}

bool CStoredProcedureBase::GetBoolField(const TDVCHAR *pName)
{
	return m_pDBO->GetBoolField(pName);
}

/*********************************************************************************

	bool CStoredProcedureBase::MoveNext(int NumRows)

	Author:		Jim Lynn
	Created:	29/03/2000
	Inputs:		NumRows - Number of rows to skip. If omitted, 1 is the default
	Outputs:	-
	Returns:	true if more results are available, false otherwise
	Purpose:	Skips over the given number of rows

*********************************************************************************/

bool CStoredProcedureBase::MoveNext(int NumRows)
{
	if (NumRows > 0)
	{
		return m_pDBO->MoveNext(NumRows);
	}
	else
	{
		return true;
	}
}

int CStoredProcedureBase::GetIntField(const TDVCHAR *pName)
{
	return m_pDBO->GetLongField(pName);
}

double CStoredProcedureBase::GetDoubleField(const TDVCHAR *pName)
{
	return m_pDBO->GetDoubleField(pName);
}

CTDVDateTime CStoredProcedureBase::GetDateField(const TDVCHAR *pName)
{
	return m_pDBO->GetDateField(pName);
}

bool CStoredProcedureBase::FormatDateField(const TDVCHAR* pName, const TDVCHAR* pFormat, CTDVString& sResult)
{
	sResult = m_pDBO->FormatDateField(pName,pFormat);
	return true;
}

bool CStoredProcedureBase::IsNULL(const TDVCHAR *pName)
{
	return m_pDBO->IsNull(pName);
}

bool CStoredProcedureBase::FieldExists(const TDVCHAR* pName)
{
	return m_pDBO->FieldExists(pName);
}

bool CStoredProcedureBase::GetField(const TDVCHAR *pName, CTDVString &sResult)
{
	sResult = m_pDBO->GetField(pName);
	return true;
}


/*********************************************************************************

	bool CStoredProcedureBase::HandleError(const TDVCHAR *pFuncName)

	Author:		Mark Neves
	Created:	09/07/2003
	Inputs:		pFuncName = the name of the function that wants the function handled
	Outputs:	true if an error was handled
				false if there was no error to handle
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedureBase::HandleError(const TDVCHAR *pFuncName)
{
	CTDVString sErrMsg;
	int iErrorCode;
	if (GetLastError(&sErrMsg, iErrorCode))
	{
		CTDVString sMessage;
		sMessage << "Error occurred in CStoredProcedure::" << pFuncName << sErrMsg;
		TDVASSERT(false, sMessage);
		return true;
	}

	return false;
}


/*********************************************************************************

	bool CStoredProcedureBase::DoesStoredProcedureExist(const TDVCHAR *pSPName, bool& bSuccess)

	Author:		Mark Neves
	Created:	10/07/2003
	Inputs:		pSPName = the name of the stored procedure
				bSuccess = place to store the result
	Outputs:	bSuccess = true if successful
	Returns:	true if executed ok, false if serious DB error occurred
	Purpose:	-

*********************************************************************************/

bool CStoredProcedureBase::DoesStoredProcedureExist(const TDVCHAR *pSPName, bool& bSuccess)
{
	CTDVString sQuery;
	sQuery << "select 'count'=count(*) from dbo.sysobjects where name='" << pSPName << "'";
	
	if (m_pDBO->ExecuteQuery(sQuery))
	{
		bSuccess = (GetIntField("count") == 1);
		return true;
	}

	bSuccess = false;
	HandleError("DoesStoredProcedureExist");
	return false;
}

/*********************************************************************************

	bool CStoredProcedureBase::AddUIDParam(const TDVCHAR* psUID)

		Author:		Mark Howitt
        Created:	19/04/2005
        Inputs:		psUID - the UID that you want to add as a param.
        Outputs:	-
        Returns:	true if added ok, false if invalid UID passed in
        Purpose:	Adds a given UID as a parameter. It first checks to make sure the
					passed in string is compatible for the DBO.

*********************************************************************************/
bool CStoredProcedureBase::AddUIDParam(const TDVCHAR* psUID)
{
	// Check and fix the given UID
	CTDVString sUID(psUID);
	if (!FixBBCUID(sUID))
	{
		TDVASSERT(false,"Failed To Fix BBCUID!!!");
		return false;
	}

	// Now add the Fixed UID
	m_pDBO->AddParam(sUID);
	return true;
}

/*********************************************************************************

	bool CStoredProcedureBase::AddUIDParam(onst TDVCHAR* pName, const TDVCHAR* psUID)

		Author:		Mark Howitt
        Created:	19/04/2005
        Inputs:		pName - The name of the parameter the value is intended for.
					psUID - the UID that you want to add as a param.
        Outputs:	-
        Returns:	true if added ok, false if invalid UID passed in
        Purpose:	Adds a given UID as a parameter. It first checks to make sure the
					passed in string is compatible for the DBO.

*********************************************************************************/
bool CStoredProcedureBase::AddUIDParam(const TDVCHAR* pName, const TDVCHAR* psUID)
{
	// Check and fix the given UID
	CTDVString sUID(psUID);
	if (!FixBBCUID(sUID))
	{
		TDVASSERT(false,"Failed To Fix BBCUID!!!");
		return false;
	}

	// Now add the Fixed UID using the named parameter
	CTDVString sName(pName);
	sName.MakeLower();
	m_pDBO->AddParam(sName, sUID);
	return true;
}

/*********************************************************************************

	bool CStoredProcedureBase::FixBBCUID( CTDVString& sUID)

		Author:		Mark Howitt
        Created:	19/04/2005
        Inputs:		sUID - the UID you want to check and fix ( if possible )
        Outputs:	-
        Returns:	true if ok, false if invalid
        Purpose:	Ensures that a given UID is of the correct format for a DBO
					uniqueidentifier input parameter

*********************************************************************************/
bool CStoredProcedureBase::FixBBCUID(CTDVString& sUID)
{
	// Fix BBC UID to have our format
	int iUIDlength = sUID.GetLength();
	if (iUIDlength == 32)
	{
		// Change from 0123456789ABCDEF0123456789ABCDEF
		// to 01234567-89AB-CDEF-0123-456789ABCDEF
		TDVCHAR temp[37];
		
		const TDVCHAR* src = sUID;
		TDVCHAR* dest = temp;

		strncpy(dest, src,8);
		dest += 8;
		src += 8;
		dest++[0] = '-';

		strncpy(dest, src,4);
		dest += 4;
		src += 4;
		dest++[0] = '-';

		strncpy(dest, src,4);
		dest += 4;
		src += 4;
		dest++[0] = '-';

		strncpy(dest, src,4);
		dest += 4;
		src += 4;
		dest++[0] = '-';

		strncpy(dest, src,12);
		dest += 12;
		src += 12;
		dest++[0] = 0;
		
		sUID = temp;
		return true;
	}
	else if (iUIDlength == 36)
	{
		//Correct length - presume OK.
		return true;
	}

	//Invalid length - neither fixed nor able to fix.
	return false;
}
