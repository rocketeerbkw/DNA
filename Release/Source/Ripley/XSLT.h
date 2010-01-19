// XSLT.h: interface for the CXSLT class.
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



#if !defined(AFX_XSLT_H__E5D14BC7_E642_11D3_89ED_00104BF83D2F__INCLUDED_)
#define AFX_XSLT_H__E5D14BC7_E642_11D3_89ED_00104BF83D2F__INCLUDED_

#define MSXML4

#include "TDVString.h"	// Added by ClassView
#include "XMLObject.h"
#ifdef MSXML4
#import "msxml4.dll" named_guids raw_interfaces_only rename_namespace("MSXML")
#else
#import "msxml3.dll" named_guids raw_interfaces_only rename_namespace("MSXML")
#endif

#pragma warning(disable:4786)
#include <map>

using namespace std ;
typedef map<CTDVString, MSXML::IXSLTemplate*> TemplateMap;

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class CXSLT  
{
public:
	CXSLT();
	virtual ~CXSLT();

public:
	bool VerifyStylesheet(const TDVCHAR* pStylesheet, bool bPartialSheet, CTDVString* oErrors);
	bool GetParsingErrors(const TDVCHAR* pText, CTDVString* pErrorString, CTDVString* pErrorLine, int* piLineNo, int* piCharNo);
	bool ApplyTransform(const TDVCHAR* pStylesheetName, CXMLObject* pObject, CTDVString& sOutput);
	bool ApplyCachedTransform(const TDVCHAR* pStylesheetName, CXMLObject* pObject, CTDVString& sOutput, bool bUseUTF8 = false);

	static void ClearTemplates();
	static void StaticInit();

	int GetLastError(CTDVString& sErrorMsg);

	enum XSLTErrors
	{
		XSLT_DOCLOAD_ERROR = 0,
		XSLT_XMLLOAD_ERROR,
		XSLT_XMLDOC_ERROR,
		XSLT_XSLTLOAD_ERROR
	};

protected:
	MSXML::IXSLProcessor* GetXSLProcessor(const TDVCHAR* pStylesheetName);
	static TemplateMap m_Templates;
	static CTDVString m_Entities;
	static CRITICAL_SECTION m_criticalsection;

private:
	MSXML::IXMLDOMDocument2* CreateNewDOMDocument();
	CTDVString FormatXMLError(MSXML::IXMLDOMDocument2* pDoc);
	bool SetLastError(int iErrorType, const TDVCHAR* pErrorMsg, const CTDVString* pOriginalFile = NULL, const TDVCHAR* pStyleSheetName = NULL);
	CTDVString GetErrorInfoDesc();

private:
	int m_iError;
	CTDVString m_sErrorMsg;
};

#endif // !defined(AFX_XSLT_H__E5D14BC7_E642_11D3_89ED_00104BF83D2F__INCLUDED_)
