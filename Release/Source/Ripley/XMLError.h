// XMLError.h: interface for the CXMLError class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_XMLERROR_H__75EAF5C1_8EDE_4466_BDD5_111E0DD64998__INCLUDED_)
#define AFX_XMLERROR_H__75EAF5C1_8EDE_4466_BDD5_111E0DD64998__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLTree.h"
#include "TDVString.h"

class CXMLError  
{
public:
	CXMLError();
	virtual ~CXMLError();
	void GetLastErrorObject(CTDVString& sObject);
	void GetLastErrorCode(CTDVString& sCode);
	void GetLastErrorMessage(CTDVString& sErrMsg);
	void GetLastErrorRef(CTDVString& sRef);
	void GetLastErrorAsXMLString(CTDVString& sXMLError);

	CTDVString GetLastErrorObject();
	CTDVString GetLastErrorCode();
	CTDVString GetLastErrorMessage();
	CTDVString GetLastErrorRef();
	CTDVString GetLastErrorAsXMLString();

	bool ErrorReported();
	void ClearError();

	static CTDVString CreateErrorXMLString(const TDVCHAR* sObject,const TDVCHAR* sCode, 
						 const TDVCHAR* sErrMsg, const TDVCHAR* sRef = NULL );


protected:

	bool SetDNALastError(const TDVCHAR* sObject,const TDVCHAR* sCode, 
						 const TDVCHAR* sErrMsg, const TDVCHAR* sRef = NULL);

	bool CopyDNALastError(const TDVCHAR* sObject,CXMLError& XMLError);
	
protected:

	CTDVString m_sXMLError;
	CTDVString m_sObject;
	CTDVString m_sCode;
	CTDVString m_sErrMsg;
	CTDVString m_sRef;
};


#endif // !defined(AFX_XMLERROR_H__75EAF5C1_8EDE_4466_BDD5_111E0DD64998__INCLUDED_)
