// DBXMLBuilder.h: interface for the CDBXMLBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_DBXMLBUILDER_H__3190A711_6A95_4E94_8CF1_26E1037922A0__INCLUDED_)
#define AFX_DBXMLBUILDER_H__3190A711_6A95_4E94_8CF1_26E1037922A0__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLError.h"
#include "StoredProcedure.h"

class CTDVDateTime;

class CDBXMLBuilder : public CXMLError  
{
public:
	CDBXMLBuilder();
	CDBXMLBuilder(CTDVString* psXML);
	virtual ~CDBXMLBuilder();

public:
	enum eDBResultType
	{
		DBRT_STRING,
		DBRT_INT,
		DBRT_DATE,
		DBRT_DOUBLE
	};

	// Initialises the Stored Procedure to use and the XML string to fill in
	CStoredProcedure* Initialise(CTDVString* psXML=NULL, CStoredProcedure *pSP = NULL);
	
	// Non Database XML Functions
	bool OpenTag(const TDVCHAR *psTagName, bool bHasAttributes = false);
	bool CloseTag(const TDVCHAR *psTagName, const TDVCHAR* psTagValue = NULL);
	bool AddTag(const TDVCHAR *psTagName, const TDVCHAR *psValue);
	bool AddAttribute(const TDVCHAR *psTagName, const TDVCHAR *psValue, bool bIsLastAttribute = false);
	bool AddIntTag(const TDVCHAR* psTagName, const int iValue);
	bool AddIntAttribute(const TDVCHAR* psTagName, const int iValue, bool bIsLastAttribute = false);
	bool AddDateTag(const TDVCHAR* psTagName, CTDVDateTime& Date, bool bIncludeRelative = false);

	// Database XML Functions
	bool DBAddTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName = NULL, bool bFailIfNULL = true, bool bEscapeText = true, CTDVString* psValue = NULL);
	bool DBAddAttribute(const TDVCHAR *psResultName, const TDVCHAR *psTagName = NULL, bool bFailIfNULL = true, bool bEscapeText = true, bool bIsLastAttribute = false, CTDVString* psValue = NULL);
	bool DBAddIntTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName = NULL, bool bFailIfNULL = true, int* piValue = NULL);
	bool DBAddIntAttribute(const TDVCHAR *psResultName, const TDVCHAR *psTagName = NULL, bool bFailIfNULL = true, bool bIsLastAttribute = false, int* piValue = NULL);
	bool DBAddDateTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName = NULL, bool bFailIfNULL = true, bool bIncludeRelative = false, CTDVDateTime* pDate = NULL);
	bool DBAddDoubleTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName = NULL, bool bFailIfNULL = true, double* pdValue = NULL);
	
	CStoredProcedure* GetStoredProcedure() const { return m_pSP; }

	operator const char *() const;

	CTDVString GetXML();
private:
	bool GetDBResult(const TDVCHAR* psResultName, const TDVCHAR* psTagName = NULL,
					 bool bFailIfNULL = true, bool bEscapeText = true,
					 eDBResultType eType = DBRT_STRING, bool bIsAnAttribute = false,
					 const void* pValue = NULL);

private:
	CStoredProcedure* m_pSP;
	CTDVString* m_psXML;
	CTDVString m_sXML;
	bool m_bIncludeRelative;
public:
	void Clear(void);
};

#endif // !defined(AFX_DBXMLBUILDER_H__3190A711_6A95_4E94_8CF1_26E1037922A0__INCLUDED_)
