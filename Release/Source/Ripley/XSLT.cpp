// XSLT.cpp: implementation of the CXSLT class.
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



#include "stdafx.h"
#include "RipleyServer.h"
#include "comutil.h"
#include "ProcessRunner.h"
#include "XSLT.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

/*********************************************************************************

	#define SAFERELEASE(pUnk)

	Author:		Jim Lynn
	Created:	17/03/2000
	Inputs:		pUnk - ptr to a COM interface
	Outputs:	-
	Returns:	-
	Purpose:	Safely releases a ptr to a COM interface and sets the ptr tp NULL

*********************************************************************************/


#define SAFERELEASE(pUnk) if (pUnk != NULL) { pUnk->Release(); pUnk = NULL; }


/*********************************************************************************

	#define SAFEADDREF(pUnk)

	Author:		Jim Lynn
	Created:	17/03/2000
	Inputs:		pUnk - ptr to a com interface
	Outputs:	-
	Returns:	-
	Purpose:	Safely does an AddRef to the interface. Doesn't try if it's NULL
	
*********************************************************************************/

#define SAFEADDREF(pUnk) if (pUnk != NULL) pUnk->AddRef();

/*********************************************************************************

	BSTR AsciiToBSTR(const char* psz)

	Author:		Jim Lynn
	Created:	17/03/2000
	Inputs:		psz - ptr to ASCII string to convert
	Outputs:	-
	Returns:	ptr to a BSTR
	Purpose:	Converts an ASCII string to a unicode BSTR. The calling function
				is responsible for deleting the string by calling SysFreeString

*********************************************************************************/

BSTR AsciiToBSTR(const char* psz)
{
    int len = ::MultiByteToWideChar(CP_ACP, 0, psz, -1, NULL, 0);
    BSTR result = SysAllocStringLen(NULL,len);
    ::MultiByteToWideChar(CP_ACP, 0, psz, -1, result, len);
    return result;
}

/*********************************************************************************

	void WideToAscii(const WCHAR* wsz, CTDVString& sResult)

	Author:		Jim Lynn
	Created:	17/03/2000
	Inputs:		wsz - ptr to a wide char string
	Outputs:	sResult - TDV String to contain the ASCII result
	Returns:	-
	Purpose:	Converts a wide char string to a TDV string. Does *not* call
				SysFreeString on the incoming string.

*********************************************************************************/

void WideToAscii(const WCHAR* wsz, CTDVString& sResult)
{
    int len = ::WideCharToMultiByte(CP_ACP, 0, wsz, -1, NULL, 0, 0, 0);
    char* psz = new char[len+1];
    ::WideCharToMultiByte(CP_ACP, 0, wsz, -1, psz, len, 0, 0);
    psz[len] = 0;
    sResult = psz;
	delete psz;
	return;
}

//char* CopyString(const char* psz)
//{
//    char* copy = new char[strlen(psz)+1];
//    if (! copy) return NULL;
//    strcpy(copy,psz);
//    return copy;
//}

/*********************************************************************************
> CTDVString WideToTDVString(const WCHAR* wsz)

	Author:		Jim Lynn
	Inputs:		Wide (Unicode) string
	Outputs:	-
	Returns:	CTDVString converted from unicode.
	Purpose:	Helper function for handling the unicode strings that are required
				by COM.

*********************************************************************************/

CTDVString WideToTDVString(const WCHAR* wsz)
{
    int len = ::WideCharToMultiByte(CP_ACP, 0, wsz, -1, NULL, 0, 0, 0);
    char* psz = new char[len+1];
    ::WideCharToMultiByte(CP_ACP, 0, wsz, -1, psz, len, 0, 0);
    psz[len] = 0;
    CTDVString retval = psz;
	delete psz;
	return retval;
}


CTDVString WideToTDVStringUTF8(const WCHAR* wsz)
{
    int len = ::WideCharToMultiByte(CP_UTF8, 0, wsz, -1, NULL, 0, 0, 0);
    char* psz = new char[len+1];
    ::WideCharToMultiByte(CP_UTF8, 0, wsz, -1, psz, len, 0, 0);
    psz[len] = 0;
    CTDVString retval = psz;
	delete psz;
	return retval;
}



//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CTDVString CXSLT::m_Entities;
TemplateMap CXSLT::m_Templates;
CRITICAL_SECTION CXSLT::m_criticalsection;

CXSLT::CXSLT() : m_iError(0)
{

}

CXSLT::~CXSLT()
{

}

/*********************************************************************************

	CTDVString CXSLT::ApplyTransform(const TDVCHAR *pStylesheetName, CXMLObject *pObject)

	Author:		Jim Lynn
	Created:	17/03/2000
	Inputs:		pStylesheetName - full pathname of the stylesheet to apply
				pObject - ptr to the CXMLObject to have the sheet applied
	Outputs:	-
	Returns:	CTDVString containing the transformed result.
	Purpose:	Applies an xslt stylesheet to the XML tree supplied, returning
				the result in a TDV String

*********************************************************************************/

bool CXSLT::ApplyTransform(const TDVCHAR *pStylesheetName, CXMLObject *pObject, CTDVString& sOutput)
{
	HRESULT hr;

	MSXML::IXMLDOMDocument2 *pXSL = CreateNewDOMDocument();
	
	HINSTANCE hInst = AfxGetResourceHandle();
	HRSRC hRes = ::FindResource(hInst, (LPCTSTR)IDR_ENTITIES, (LPCTSTR)"LONGSTRING");
	HGLOBAL hResGlobal = ::LoadResource(hInst, hRes);

	char* buffer = (char*)::LockResource(hResGlobal);

	CTDVString sEntities(buffer);

	::FreeResource(hResGlobal);

	CTDVString retval;
	VARIANT stylesheet;
	VARIANT_BOOL result;
	VariantInit(&stylesheet);
	stylesheet.vt = VT_BSTR;

	V_BSTR(&stylesheet) = AsciiToBSTR(pStylesheetName);
	pXSL->put_validateOnParse(VARIANT_FALSE);
	hr = pXSL->load(stylesheet, &result);
	if (FAILED(hr) || result == VARIANT_FALSE)
	{
		CTDVString err = FormatXMLError(pXSL);
		SAFERELEASE(pXSL);
		return SetLastError(XSLT_DOCLOAD_ERROR,err);
	}
	VariantClear(&stylesheet);
	
	CTDVString origdocoutput,docoutput;

	pObject->GetAsString(origdocoutput);
	docoutput = sEntities + origdocoutput;
	
	MSXML::IXMLDOMDocument2 *pDoc = CreateNewDOMDocument();
	
	BSTR output = AsciiToBSTR(docoutput);
	pDoc->put_validateOnParse(VARIANT_FALSE);
	pDoc->put_preserveWhiteSpace(VARIANT_TRUE);
	hr = pDoc->loadXML(output, &result);
	SysFreeString(output);
	if (FAILED(hr) || result == VARIANT_FALSE)
	{
		// Must release pXSL and pDoc here.
		CTDVString err = FormatXMLError(pDoc);
		SAFERELEASE(pXSL);
		SAFERELEASE(pDoc);
		return SetLastError(XSLT_XMLLOAD_ERROR,err);
	}
	output = NULL;

	if (SUCCEEDED(hr))
	{
		hr = pDoc->transformNode(pXSL, &output);
	}
	if (FAILED(hr))
	{
		SysFreeString(output);
		CTDVString err = FormatXMLError(pDoc);
		SAFERELEASE(pXSL);
		SAFERELEASE(pDoc);
		return SetLastError(XSLT_XMLDOC_ERROR,err,&origdocoutput,pStylesheetName);
	}
	else
	{
		sOutput = WideToTDVString(output);
	}
	SysFreeString(output);
	SAFERELEASE(pXSL);
	SAFERELEASE(pDoc);
	return true;
}

// bUseUTF8 is false if we want the ANSI code page (suitable for HTML) and true for UTF-8 encoding (for RSS etc.)

bool CXSLT::ApplyCachedTransform(const TDVCHAR *pStylesheetName, CXMLObject *pObject, CTDVString& sOutput, bool bUseUTF8)
{
	HRESULT hr;

	bool bOk = true;
	VARIANT_BOOL result;
	
	CTDVString docoutput;

	docoutput.SetPadSize(32768);
	pObject->GetAsString(docoutput);
	docoutput = m_Entities + docoutput;
	
	MSXML::IXMLDOMDocument2 *pDoc = CreateNewDOMDocument();
	
	BSTR output = AsciiToBSTR(docoutput);
	pDoc->put_validateOnParse(VARIANT_FALSE);
	hr = pDoc->loadXML(output, &result);
	SysFreeString(output);
	if (FAILED(hr) || result == VARIANT_FALSE)
	{
		// Must release pXSL and pDoc here.
		CTDVString err = FormatXMLError(pDoc);
		SAFERELEASE(pDoc);
		return SetLastError(XSLT_XMLLOAD_ERROR,err);
	}
	output = NULL;

	// Get an XSL processor for this stylesheet (precompiles them).
	MSXML::IXSLProcessor* pProc = GetXSLProcessor(pStylesheetName);
	
	if (pProc != NULL)
	{
		// Give the current document to the processor
		hr = pProc->put_input(_variant_t(pDoc));
		if (SUCCEEDED(hr))
		{
			VARIANT varvalue;
			VARIANT_BOOL bResult;
			
			// Do the transform
			hr = pProc->transform(&bResult);
			if (SUCCEEDED(hr) || (bResult == VARIANT_TRUE))
			{
				// Get the current output and put it in the return string
				pProc->get_output(&varvalue);
				if (bUseUTF8)
				{
					sOutput = WideToTDVStringUTF8((_bstr_t)(varvalue));
				}
				else
				{
					sOutput = WideToTDVString((_bstr_t)(varvalue));
				}
				VariantClear(&varvalue);
			}
		}
		// Release the COM pointer to the processor
		SAFERELEASE(pProc);
	}
	else
	{
		bOk = false;
	}
	SAFERELEASE(pDoc);
	// We are actually outputting in ISO-8859-1 and not UTF-16
	// so convert any meta tags that lie.
	if (bUseUTF8)
	{
		sOutput.Replace("charset=UTF-16","charset=UTF-8");
		sOutput.Replace("encoding=\"UTF-16\"","encoding=\"UTF-8\"");
	}
	else
	{
		sOutput.Replace("charset=UTF-16","charset=iso-8859-1");
		sOutput.Replace("encoding=\"UTF-16\"","encoding=\"iso-8859-1\"");
	}
	return bOk;

}

MSXML::IXMLDOMDocument2* CXSLT::CreateNewDOMDocument()
{
	MSXML::IXMLDOMDocument2* pDoc = NULL;
#ifdef MSXML4
	HRESULT hr = CoCreateInstance(MSXML::CLSID_DOMDocument40, NULL, CLSCTX_INPROC_SERVER , MSXML::IID_IXMLDOMDocument2, (void**)&pDoc);
#else
	HRESULT hr = CoCreateInstance(MSXML::CLSID_DOMDocument30, NULL, CLSCTX_INPROC_SERVER , MSXML::IID_IXMLDOMDocument2, (void**)&pDoc);
#endif
	pDoc->put_async(VARIANT_FALSE);
	BSTR propname = AsciiToBSTR("ServerHTTPRequest");
	VARIANT bTrue;
	VariantInit(&bTrue);
	bTrue.vt = VT_BOOL;
	bTrue.boolVal = VARIANT_TRUE;
	pDoc->setProperty(propname, bTrue);
	SysFreeString(propname);
	VariantClear(&bTrue);
	return pDoc;
}

CTDVString CXSLT::FormatXMLError(MSXML::IXMLDOMDocument2* pDoc)
{
	CTDVString retval;	
	MSXML::IXMLDOMParseError* pError = NULL;
	HRESULT hr = pDoc->get_parseError(&pError);
	if (SUCCEEDED(hr))
	{
		long errorcode;
		BSTR dummy;
		long linenumber;
		long linepos;
		CTDVString url;
		CTDVString reason;
		CTDVString srctext;

		// Get all the error values
		pError->get_errorCode(&errorcode);
		pError->get_line(&linenumber);
		pError->get_linepos(&linepos);
		pError->get_reason(&dummy);
		WideToAscii(dummy, reason);
		SysFreeString(dummy);
		pError->get_url(&dummy);
		WideToAscii(dummy, url);
		SysFreeString(dummy);
		pError->get_srcText(&dummy);
		WideToAscii(dummy, srctext);
		SysFreeString(dummy);

//		if (reason.IsEmpty())
//		{
//			reason = "(MSXML has not provided a reason)";
//		}

		CTDVString spaces(' ',linepos);

		retval << "<HTML><TITLE>XML Parsing Error</TITLE>\n"
			<< "<BODY>";
		retval << "<font face='Verdana' size='2'><font size='4'>XML Error loading '" 
			<< url
			<< "'</font>"
			<< "<P><B>" << reason 
			<< "</B></P></font>";
		if (linenumber > 0)
		{
		  retval << "<font size=3><XMP>"
		  << "at line " << linenumber << ", character " << linepos
		  << "\n" << srctext
		  << "\n" << spaces << "^"
		  << "</XMP></font>";
		}
		retval << "</BODY></HTML>";

	}
	else
	{
		retval << "<HTML><BODY><B>Unknown XML parsing error</B></BODY></HTML>";
	}
	SAFERELEASE(pError);
	return retval;
}

/*********************************************************************************

	bool CXSLT::GetParsingErrors(const TDVCHAR *pText, CTDVString *pErrorString, CTDVString *pErrorLine, int *piLineNo, int *piCharNo)

	Author:		Jim Lynn
	Created:	09/06/2000
	Inputs:		pText - text of the page to check
	Outputs:	pErrorString - string description of error
				pErrorLine - line in text containing the error
				piLineNo - line number in text of error
				piCharNo - character position in line of error
	Returns:	false if parsing errors were found, true if none found
	Purpose:	You should call this function on the text that the user types
				in to the guide entry. It returns information from the MS XML
				parser, and tells us if the guide entry will cause the page
				not to be displayed. This is important, because there are still
				things that our parser will not fix.

*********************************************************************************/

bool CXSLT::GetParsingErrors(const TDVCHAR *pText, CTDVString *pErrorString, CTDVString *pErrorLine, int *piLineNo, int *piCharNo)
{
	HINSTANCE hInst = AfxGetResourceHandle();
	HRSRC hRes = ::FindResource(hInst, (LPCTSTR)IDR_ENTITIES, (LPCTSTR)"LONGSTRING");
	HGLOBAL hResGlobal = ::LoadResource(hInst, hRes);

	char* buffer = (char*)::LockResource(hResGlobal);

	CTDVString sEntities(buffer);

	::FreeResource(hResGlobal);

	MSXML::IXMLDOMDocument2 *pDoc = CreateNewDOMDocument();
	
	CTDVString docoutput;

	VARIANT_BOOL result;
	docoutput << sEntities << pText;
	BSTR output = AsciiToBSTR(docoutput);
	pDoc->put_validateOnParse(VARIANT_FALSE);
	HRESULT hr = pDoc->loadXML(output, &result);
	SysFreeString(output);
	if (FAILED(hr) || result == VARIANT_FALSE)
	{
		MSXML::IXMLDOMParseError* pError = NULL;
		HRESULT hr = pDoc->get_parseError(&pError);
		if (SUCCEEDED(hr))
		{
			long errorcode;
			BSTR dummy;
			long linenumber;
			long linepos;
			CTDVString url;
			CTDVString reason;
			CTDVString srctext;

			// Get all the error values
			pError->get_errorCode(&errorcode);
			pError->get_line(&linenumber);
			pError->get_linepos(&linepos);
			pError->get_reason(&dummy);
			WideToAscii(dummy, reason);
			SysFreeString(dummy);
			//pError->get_url(&dummy);
			//WideToAscii(dummy, url);
			//SysFreeString(dummy);
			pError->get_srcText(&dummy);
			WideToAscii(dummy, srctext);
			SysFreeString(dummy);
			*pErrorLine = srctext;
			*pErrorString = reason;
			*piLineNo = linenumber;
			*piCharNo = linepos;
		}
		// Must release pXSL and pDoc here.
		SAFERELEASE(pDoc);
		SAFERELEASE(pError);
		return false;
	}
	SAFERELEASE(pDoc);
	return true;
}

/*********************************************************************************

	void CNewXMLDocument::StaticInit()

	Author:		Jim Lynn
	Created:	19/12/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Static function to initialise the static string containing
				the Entities partial DTD. This saves having to create it
				each time.

*********************************************************************************/

void CXSLT::StaticInit()
{
	HINSTANCE hInst = AfxGetResourceHandle();
	HRSRC hRes = ::FindResource(hInst, (LPCTSTR)IDR_ENTITIES, (LPCTSTR)"LONGSTRING");
	HGLOBAL hResGlobal = ::LoadResource(hInst, hRes);

	char* buffer = (char*)::LockResource(hResGlobal);

	m_Entities = buffer;

	::FreeResource(hResGlobal);

	InitializeCriticalSection(&m_criticalsection);
	m_Templates.clear();
}

/*********************************************************************************

	MSXML::IXSLProcessor* CNewXMLDocument::GetXSLProcessor(const TDVCHAR *pStylesheetName)

	Author:		Jim Lynn
	Created:	02/01/2001
	Inputs:		pStylesheetName - name of sheet to get processor for
	Outputs:	-
	Returns:	pointer to an XSL processor to use. The caller has to release it.
	Purpose:	Helper function which returns a single-use XSL processor
				for this stylesheet (which might possibly require loading
				in the stylesheet and creating a template object, with whatever
				caching is required).

*********************************************************************************/

MSXML::IXSLProcessor* CXSLT::GetXSLProcessor(const TDVCHAR *pStylesheetName)
{
	// Make sure we don't let multiple threads update the stylesheet list
	// at the same time.
	try
	{
	EnterCriticalSection(&m_criticalsection);
	MSXML::IXSLProcessor* pProcessor = NULL;

	CTDVString sStylesheetName(pStylesheetName);
	sStylesheetName.MakeLower();
	
	// Do we already have a cached template in our map?
	MSXML::IXSLTemplate* pTemplate = m_Templates[sStylesheetName];
	SAFEADDREF(pTemplate);

	// If we got a template, use it to create a single-use processor
	if (pTemplate != NULL)
	{
		pTemplate->createProcessor(&pProcessor);
		SAFERELEASE(pTemplate);
	}
	else
	{
		// No template, so create one
		MSXML::IXMLDOMDocument2* pNewDoc = NULL;
#ifdef MSXML4
		HRESULT hr = CoCreateInstance(MSXML::CLSID_FreeThreadedDOMDocument40, NULL, CLSCTX_INPROC_SERVER , MSXML::IID_IXMLDOMDocument2, (void**)&pNewDoc);
#else
		HRESULT hr = CoCreateInstance(MSXML::CLSID_FreeThreadedDOMDocument, NULL, CLSCTX_INPROC_SERVER , MSXML::IID_IXMLDOMDocument2, (void**)&pNewDoc);
#endif
		pNewDoc->put_async(VARIANT_FALSE);
		pNewDoc->put_resolveExternals(VARIANT_TRUE);
		pNewDoc->put_validateOnParse(VARIANT_FALSE);
	
		VARIANT_BOOL bLoaded;
		hr = pNewDoc->load(_variant_t(pStylesheetName), &bLoaded);

		// Create a template out of this document
#ifdef MSXML4
		hr = CoCreateInstance(MSXML::CLSID_XSLTemplate40, NULL, CLSCTX_SERVER, MSXML::IID_IXSLTemplate, (LPVOID*)(&pTemplate));
#else
		hr = CoCreateInstance(MSXML::CLSID_XSLTemplate, NULL, CLSCTX_SERVER, MSXML::IID_IXSLTemplate, (LPVOID*)(&pTemplate));
#endif
		if (SUCCEEDED(hr))
		{
			hr = pTemplate->putref_stylesheet(pNewDoc);
			if (FAILED(hr))
			{
				SetLastError(XSLT_XSLTLOAD_ERROR,GetErrorInfoDesc(),NULL,pStylesheetName);
			}
		}
		if (SUCCEEDED(hr))
		{
			m_Templates[sStylesheetName] = pTemplate;
			pTemplate->createProcessor(&pProcessor);
		}
		SAFERELEASE(pNewDoc);
	}
	LeaveCriticalSection(&m_criticalsection);
	return pProcessor;
	}
	catch(...)
	{
		LeaveCriticalSection(&m_criticalsection);
		return NULL;
	}
}

/*********************************************************************************

	void CNewXMLDocument::ClearTemplates()

	Author:		Jim Lynn
	Created:	02/01/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Static function which clears the templates list, useful when
				a new stylesheet has been uploaded.

*********************************************************************************/

void CXSLT::ClearTemplates()
{
	EnterCriticalSection(&m_criticalsection);
	TemplateMap::iterator MapIt;
	for (MapIt = m_Templates.begin(); MapIt != m_Templates.end();MapIt++)
	{
		SAFERELEASE((*MapIt).second);
	}
	m_Templates.clear();
	LeaveCriticalSection(&m_criticalsection);
}

bool CXSLT::VerifyStylesheet(const TDVCHAR *pStylesheet, bool bPartialSheet, CTDVString *oErrors)
{
	HRESULT hr;

	MSXML::IXMLDOMDocument2 *pXSL = CreateNewDOMDocument();
	
	CTDVString retval;
	VARIANT stylesheet;
	VARIANT_BOOL result;
	VariantInit(&stylesheet);
	stylesheet.vt = VT_BSTR;
	
	V_BSTR(&stylesheet) = AsciiToBSTR(pStylesheet);
	pXSL->put_validateOnParse(VARIANT_FALSE);
	hr = pXSL->load(stylesheet, &result);
	if (FAILED(hr) || result == VARIANT_FALSE)
	{
		MSXML::IXMLDOMParseError* pError = NULL;
		HRESULT hr = pXSL->get_parseError(&pError);
		if (SUCCEEDED(hr))
		{
			long errorcode;
			BSTR dummy;
			long linenumber;
			long linepos;
			CTDVString url;
			CTDVString reason;
			CTDVString srctext;

			// Get all the error values
			pError->get_errorCode(&errorcode);
			pError->get_line(&linenumber);
			pError->get_linepos(&linepos);
			pError->get_reason(&dummy);
			WideToAscii(dummy, reason);
			SysFreeString(dummy);
			pError->get_url(&dummy);
			WideToAscii(dummy, url);
			SysFreeString(dummy);
			pError->get_srcText(&dummy);
			WideToAscii(dummy, srctext);
			SysFreeString(dummy);

			CTDVString spaces(' ',linepos);

			*oErrors << "<PARSE-ERROR TYPE='parse'>";
			*oErrors << "<URL>"
				<< url
				<< "'</URL>"
				<< "<REASON>" << reason 
				<< "</REASON>";
			if (linenumber > 0)
			{
				CXMLObject::EscapeXMLText(&srctext);
				*oErrors << "<LINE>"
			  << linenumber << "</LINE><CHARACTER>" << linepos
			  << "</CHARACTER><SRCTEXT>" << srctext
			  << "</SRCTEXT>";
			}
			*oErrors << "</PARSE-ERROR>";
		}
		else
		{
			*oErrors << "<PARSE-ERROR TYPE='unknown'><UNKNOWN/></PARSE-ERROR>";
		}
		SAFERELEASE(pError);
		SAFERELEASE(pXSL);
		VariantClear(&stylesheet);
		return false;
	}
	VariantClear(&stylesheet);	
	
	CTDVString docoutput = "<H2G2 TYPE='SIMPLE'/>";

	if (!bPartialSheet)
	{
		MSXML::IXMLDOMDocument2 *pDoc = CreateNewDOMDocument();
	
		BSTR output = AsciiToBSTR(docoutput);
		pDoc->put_validateOnParse(VARIANT_FALSE);
		pDoc->put_preserveWhiteSpace(VARIANT_TRUE);
		hr = pDoc->loadXML(output, &result);
		SysFreeString(output);
		if (FAILED(hr) || result == VARIANT_FALSE)
		{
			// Must release pXSL and pDoc here.
			// CTDVString err = FormatXMLError(pDoc);
			SAFERELEASE(pXSL);
			SAFERELEASE(pDoc);
			return false;
		}
		output = NULL;

		if (SUCCEEDED(hr))
		{
			hr = pDoc->transformNode(pXSL, &output);
		}
		if (FAILED(hr))
		{
			SysFreeString(output);
			*oErrors << "<PARSE-ERROR TYPE='runtime'><UNKNOWN/></PARSE-ERROR>";
			SAFERELEASE(pXSL);
			SAFERELEASE(pDoc);
			return false;
		}
		SysFreeString(output);
		SAFERELEASE(pDoc);
	}
	SAFERELEASE(pXSL);
	return true;
}

int CXSLT::GetLastError(CTDVString& sErrorMsg)
{
	sErrorMsg = m_sErrorMsg;
	return m_iError;
}

bool CXSLT::SetLastError(int iErrorType, const TDVCHAR* pErrorMsg, const CTDVString* pOriginalFile, const TDVCHAR* pStyleSheetName)
{
	m_iError = iErrorType;
	m_sErrorMsg = pErrorMsg;

#ifdef _DEBUG
	// Check to see if we've had an XMLLOAD Error, if so get the error message
	if (m_iError == XSLT_XMLDOC_ERROR && pOriginalFile != NULL)
	{
		CTDVString sTempFile = pOriginalFile->WriteToTempFile();
		if (!sTempFile.IsEmpty())
		{
			CTDVString sCmdLine = "xslterrors.exe ";
			sCmdLine << "\"" << pStyleSheetName << "\" \"" << sTempFile << "\"";

			CProcessRunner ProcRunner;
			if (ProcRunner.Run(sCmdLine))
			{
				while (ProcRunner.IsRunning())
				{
					// wait for it to finish
				}
			}

			if (ProcRunner.ErrorReported())
			{
				m_sErrorMsg << ProcRunner.GetLastErrorAsXMLString();
			}

			CTDVString sOutput;
			ProcRunner.GetOutput(sOutput);

			// Now add the output to the error message.
			// If the existing error message is an HTML page, make sure we insert it within
			// the HTML tag, otherwise it will be badly formed.  It has to be well formed, because the
			// req may have been made with an "-xml" skin - i.e. one that is returned as an XML document.
			int iHTMLTagPos = m_sErrorMsg.Find("</HTML>");
			if (iHTMLTagPos >= 0)
			{
				m_sErrorMsg = m_sErrorMsg.Left(iHTMLTagPos);
			}

			m_sErrorMsg << "<HR/>Don't take this the wrong way, and you're not a bad person, but the following error was found:<BR/><BR/>";
			m_sErrorMsg << "<B>" << sOutput << "</B><BR/><BR/>";
			m_sErrorMsg << "XSLT file: " << pStyleSheetName;

			if (iHTMLTagPos >= 0)
			{
				m_sErrorMsg << "</HTML>";
			}
			::DeleteFile(sTempFile);
		}
	}

	if (m_iError == XSLT_XSLTLOAD_ERROR)
	{
		m_sErrorMsg = "<HTML><BODY>Error is stylesheet " + CTDVString(pStyleSheetName) + 
				   "<H2>" + m_sErrorMsg + "</H2></BODY></HTML>";
	}

#endif
	return false;
}

/*********************************************************************************

	CTDVString CXSLT::GetErrorInfoDesc()

		Author:		Mark Neves
        Created:	20/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	The description of the last error recorded
        Purpose:	Some system calls set an error in an IErrorInfo object belonging to the current thread.
					This function retrives the description of the last error, if it can

*********************************************************************************/

CTDVString CXSLT::GetErrorInfoDesc()
{
	CTDVString sDesc;

	IErrorInfo* pError = NULL;
	::GetErrorInfo(0, &pError);
	if (pError != NULL)
	{
		CComBSTR description;
		pError->GetDescription(&description);
		COLE2T temp(description);
		sDesc = (LPCTSTR)temp;
		TDVASSERT(false,"CXSLT::GetXSLProcessor - " + sDesc);
		pError->Release();
	}
	else
	{
		sDesc = "(No description from GetErrorInfo)";
	}

	return sDesc;
}
