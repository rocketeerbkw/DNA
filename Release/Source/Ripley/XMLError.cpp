// XMLError.cpp: implementation of the CXMLError class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "XMLError.h"
#include "XMLObject.h"
#include "TDVAssert.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CXMLError::CXMLError()
{

}

CXMLError::~CXMLError()
{
	
}

/*********************************************************************************

	void CXMLError::SetDNALastError(const TDVCHAR* sObject,const TDVCHAR* sCode, 
								const TDVCHAR* sErrMsg = NULL)

	Author:		Dharmesh Raithatha
	Created:	5/14/2003
	Inputs:		sObject - Name of calling Class 
				sCode - short text with no spaces describing the problem
				sErrMsg - longer textual description
				sRef - a Reference value useful in the error's context (optional)
	Outputs:	-
	Returns:	always returns false
	Purpose:	When an error occurs call this method to set the error which will
				produce a standard error format

*********************************************************************************/

bool CXMLError::SetDNALastError(const TDVCHAR* sObject,const TDVCHAR* sCode, 
								const TDVCHAR* sErrMsg, const TDVCHAR* sRef)
{
	m_sObject = sObject;
	m_sCode = sCode;
	m_sErrMsg = sErrMsg;

	m_sRef.Empty();
	if (sRef != NULL)
	{
		m_sRef = sRef;
	}

	m_sXMLError =  "<ERROR";
	m_sXMLError << " OBJECT='" << m_sObject << "'";
	m_sXMLError << " CODE='"   << m_sCode   << "'";
	m_sXMLError << " REF='"    << m_sRef    << "'";
	m_sXMLError << ">";
	m_sXMLError << m_sErrMsg << "</ERROR>";

#ifdef _DEBUG
	CTDVString msg;
	msg << m_sObject << " : " << m_sErrMsg;
	TDVASSERT(false,msg);
#endif

	return false;
}

/*********************************************************************************

	CTDVString CXMLError::CreateErrorXMLString(const TDVCHAR* sObject,const TDVCHAR* sCode, 
								const TDVCHAR* sErrMsg = NULL)

	Author:		Martin Robb
	Created:	30/01/2006
	Inputs:		sObject - Name of calling Class 
				sCode - short text with no spaces describing the problem
				sErrMsg - longer textual description
				sRef - a Reference value useful in the error's context (optional)
	Outputs:	-
	Returns:	Standard XML string.
	Purpose:	Produces standard error XML.

*********************************************************************************/
CTDVString CXMLError::CreateErrorXMLString(const TDVCHAR* sObject,const TDVCHAR* sCode, 
								const TDVCHAR* sErrMsg, const TDVCHAR* sRef)
{
	CXMLError err;
	err.SetDNALastError(sObject,sCode,sErrMsg,sRef);
	return err.GetLastErrorAsXMLString(); 
}

bool CXMLError::CopyDNALastError(const TDVCHAR* sObject,CXMLError& XMLError)
{
	if (XMLError.ErrorReported())
	{
        return SetDNALastError(sObject,XMLError.GetLastErrorCode(),XMLError.GetLastErrorMessage(),XMLError.GetLastErrorRef());
	}
	else
	{
		return false;
	}
}

void CXMLError::GetLastErrorObject(CTDVString& sObject)
{
	sObject = m_sObject;
}
	
void CXMLError::GetLastErrorCode(CTDVString& sCode)
{
	sCode = m_sCode;
}

void CXMLError::GetLastErrorMessage(CTDVString& sErrMsg)
{
	sErrMsg = m_sErrMsg;
}

void CXMLError::GetLastErrorRef(CTDVString& sRef)
{
	sRef = m_sRef;
}

void CXMLError::GetLastErrorAsXMLString(CTDVString& sXMLError)
{
	sXMLError = m_sXMLError;
}

CTDVString CXMLError::GetLastErrorObject()
{
	return m_sObject;
}

CTDVString CXMLError::GetLastErrorCode()
{
	return m_sCode;
}

CTDVString CXMLError::GetLastErrorMessage()
{
	return m_sErrMsg;
}

CTDVString CXMLError::GetLastErrorRef()
{
	return m_sRef;
}

CTDVString CXMLError::GetLastErrorAsXMLString()
{
	return m_sXMLError;
}

bool CXMLError::ErrorReported()
{
	return (!m_sCode.IsEmpty() || !m_sErrMsg.IsEmpty());
}

void CXMLError::ClearError()
{
	m_sXMLError.Empty();
	m_sObject.Empty();
	m_sCode.Empty();
	m_sErrMsg.Empty();
	m_sRef.Empty();
}
