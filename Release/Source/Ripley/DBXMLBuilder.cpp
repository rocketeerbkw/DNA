// DBXMLBuilder.cpp: implementation of the CDBXMLBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "DBXMLBuilder.h"
#include "tdvassert.h"
#include "XMLObject.h"
#include "StoredProcedure.h"
#include ".\dbxmlbuilder.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CDBXMLBuilder::CDBXMLBuilder() : CXMLError(), m_pSP(NULL), m_psXML(NULL), m_bIncludeRelative(false)
{
	Initialise();
}

CDBXMLBuilder::CDBXMLBuilder(CTDVString* psXML) : CXMLError(), m_pSP(NULL), m_psXML(NULL), m_bIncludeRelative(false)
{
	Initialise(psXML);
}

CDBXMLBuilder::~CDBXMLBuilder()
{
}

/*********************************************************************************

	CStoredProcedure* CDBXMLBuilder::Initialise(CTDVString* psXML, CStoredProcedure *pSP = NULL)

	Author:		Mark Howitt
	Created:	03/02/2004
	Inputs:		psXML	- A pointer to a string that will recieve the XML (can be NULL)
				pSP		- A pointer to the Stored Procedure that the results will be taken from.
	Outputs:	
	Returns:	pOldSP	- A Pointer to the previous storedprocedure
	Purpose:	Sets up this object with the XML String and StoredProcedure.

				If psXML is NULL, it fills this object up with the XML.  This can be retrieved
				with the call to the member function GetXML()

*********************************************************************************/

CStoredProcedure* CDBXMLBuilder::Initialise(CTDVString* psXML, CStoredProcedure *pSP)
{
	// Setup the member variables
	CStoredProcedure* pOldSP = m_pSP;
	m_pSP = pSP;
	m_psXML = psXML;

	// If no XML string supplied, point to the one local to this object
	if (m_psXML == NULL)
	{
		m_psXML = &m_sXML;
	}

	return pOldSP;
}

/*********************************************************************************

	bool CDBXMLBuilder::GetDBResult(const TDVCHAR* psResultName, const TDVCHAR* psTagName = NULL,
									bool bFailIfNULL = true, bool bEscapeText = true,
									eDBResultType eType = DBRT_STRING, bool bIsAnAttribute = false,
									const void* pValue = NULL)

	Author:		Mark Howitt
	Created:	27/01/2004
	Inputs:		psResultName	- The name of the column to get the result from.
				psTagName		- The Name of the XML Tag for the result. If Empty, the ResultName is used,
									If this is set to empty ("") then no tags are added around the result. This is mainly
									used with GuideXML results. NOTE! In attribute mode this will return false, an ERROR!
				bFailIfNULL		- If true, we fail if we find NULL Results.
				bEscapeText		- If true, the result is escaped before inserting into the XML.
				eType			- An enum which states which type of field we want to get from the database.
									Values are DBRT_STRING (defualt), DBRT_INT and DBRT_DATE.
				bIsAttribute	- If set, The result is inserted into the XML as an attribute.
				
	Outputs:	pValue			- A pointer to either a CTDVString, int or CTDVDateTime object depending on
									what type of result you are trying to find. This, if not NULL, will
									take the value of the found result.

	Returns:	true if ok, false if there was a problem
	Purpose:	Gets a requested type of result from the m_pSP and inserts it into the m_sXML string.
				There are several flags that can be set to alter the way the result is represented in
				the XML. There are also flags that when set alter the way certain contidions are handeled.

*********************************************************************************/

bool CDBXMLBuilder::GetDBResult(const TDVCHAR* psResultName, const TDVCHAR* psTagName, bool bFailIfNULL,
								bool bEscapeText, eDBResultType eType, bool bIsAnAttribute, const void* pValue)
{
	// Check to make sure the object has been initialised!
	if (m_pSP == NULL || m_psXML == NULL)
	{
		return SetDNALastError("CDBXMLBuilder::GetDBResult","NotInitialised","THe XMLBuilder is not intialised!");
	}

	// Check to make sure we've got valid params
	if (psResultName == NULL || psResultName == "")
	{
		return SetDNALastError("CDBXMLBuilder::GetDBResult","NoResultNameGiven","No Result Name Given!");
	}

	// Check to see if the Result exists!
	CTDVString sError;
	if (!m_pSP->FieldExists(psResultName))
	{
		sError << "The requested result '" << psResultName << "' does not exist in the result set!";
		return SetDNALastError("CDBXMLBuilder::GetDBResult","DBResultDoesNotExist",sError);
	}

	// Now get the result from the database
 	if (m_pSP->IsNULL(psResultName))
	{
		// Check to see if we want to fil if we find NULL results!
		if (bFailIfNULL)
		{
			sError << "The requested result '" << psResultName << "' is NULL!";
			return SetDNALastError("CDBXMLBuilder::GetDBResult","ResultIsNULL",sError);
		}
	}
	else
	{
		// Get the string result and build up the XML
		CTDVString sResult;
		if (eType == DBRT_INT)
		{
			// Get the result as a number
			int iResult = m_pSP->GetIntField(psResultName);

			// Fill the pValue param if we've been given one
			if (pValue != NULL)
			{
				*((int*)pValue) = iResult;
			}
			sResult << iResult;
		}
		else if (eType == DBRT_DOUBLE)
		{
			// Get the result as a number
			double dResult = m_pSP->GetDoubleField(psResultName);

			// Fill the pValue param if we've been given one
			if (pValue != NULL)
			{
				*((double*)pValue) = dResult;
			}
			sResult << dResult;
		}
		else if (eType == DBRT_DATE)
		{
			// Get the result as a Date
			CTDVDateTime Date = m_pSP->GetDateField(psResultName);
			Date.GetAsXML(sResult,m_bIncludeRelative);

			// Fill the pValue param if we've been given one
			if (pValue != NULL)
			{
				*((CTDVDateTime*)pValue) = Date;
			}
		}
		else
		{
			// Get the result as a string
			if (!m_pSP->GetField(psResultName,sResult))
			{
				sError << "Failed to get the requested result '" << psResultName << "'!";
				return SetDNALastError("CDBXMLBuilder::GetDBResult","FailedToGetResult",sError);
			}

			// Are we required to escape the text?
			if (bEscapeText)
			{
				// Attributes need to escape everything, Normal tags only need the the xml bits.
				if (bIsAnAttribute)
				{
					CXMLObject::EscapeEverything(&sResult);
				}
				else
				{
					CXMLObject::EscapeXMLText(&sResult);
				}
			}

			// Fill the pValue param if we've been given one
			if (pValue != NULL)
			{
				*((CTDVString*)pValue) = sResult;
			}
		}

		// Setup the Tag name. IF the sTagName is empty, use the ResultName as the tag name.
		CTDVString sXMLName;
		if (psTagName != NULL)
		{
			sXMLName = psTagName;
		}
		else
		{
			sXMLName = psResultName;
		}

		// Make sure we're all uppercase!
		sXMLName.MakeUpper();

		// Check to see if we're inserting as an attribute or tag
		if (bIsAnAttribute)
		{
			if (sXMLName.IsEmpty())
			{
				return SetDNALastError("CDBXMLBuilder::GetDBResult","NoAttributeName","No attribute name given!");
			}
			
			*m_psXML << " " << sXMLName << "='" << sResult << "'";
		}
		else
		{
			if (sXMLName.IsEmpty())
			{
				// Don't use tags as the result already contains them!
				*m_psXML << sResult;
			}
			else
			{
				// insert the tagname with square brackets
				*m_psXML << "<" << sXMLName << ">" << sResult << "</" << sXMLName << ">";
			}
		}
	}

	// Everything went ok
	return true;
}


/*********************************************************************************

	bool CDBXMLBuilder::DBAddTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bEscapeText, CTDVString* psValue)

	Author:		Mark Howitt
	Created:	03/02/2004
	Purpose:	Wrapper function for getting String results as a XML Tag

*********************************************************************************/

bool CDBXMLBuilder::DBAddTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bEscapeText, CTDVString* psValue)
{
	return GetDBResult(psResultName,psTagName,bFailIfNULL,bEscapeText,DBRT_STRING,false,psValue);
}

/*********************************************************************************

	bool CDBXMLBuilder::DBAddAttribute(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bEscapeText, bool bIsLastAttribute, CTDVString* psValue)

	Author:		Mark Howitt
	Created:	03/02/2004
	Purpose:	Wrapper function for getting String results as a XML Attribute

*********************************************************************************/

bool CDBXMLBuilder::DBAddAttribute(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bEscapeText, bool bIsLastAttribute, CTDVString* psValue)
{
	bool bOk = GetDBResult(psResultName,psTagName,bFailIfNULL,bEscapeText,DBRT_STRING,true,psValue);

	// If we're ok and we're the last attribute, close the tag
	if (bOk && bIsLastAttribute)
	{
		*m_psXML << ">";
	}
	return bOk;
}

/*********************************************************************************

	bool CDBXMLBuilder::DBAddIntTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, int* piValue)

	Author:		Mark Howitt
	Created:	03/02/2004
	Purpose:	Wrapper function for getting Int results as a XML Tags

*********************************************************************************/

bool CDBXMLBuilder::DBAddIntTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, int* piValue)
{
	return GetDBResult(psResultName,psTagName,bFailIfNULL,false,DBRT_INT,false,piValue);
}

/*********************************************************************************

	bool CDBXMLBuilder::DBAddIntAttribute(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bIsLastAttribute, int* piValue)

	Author:		Mark Howitt
	Created:	03/02/2004
	Purpose:	Wrapper function for getting Int results as a XML Attribute

*********************************************************************************/

bool CDBXMLBuilder::DBAddIntAttribute(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bIsLastAttribute, int* piValue)
{
	bool bOk = GetDBResult(psResultName,psTagName,bFailIfNULL,false,DBRT_INT,true,piValue);

	// If we're ok and we're the last attribute, close the tag
	if (bOk && bIsLastAttribute)
	{
		*m_psXML << ">";
	}
	return bOk;
}

/*********************************************************************************

	bool CDBXMLBuilder::DBAddDateTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bIncludeRelative = false, CTDVDateTime* pDate)

	Author:		Mark Howitt
	Created:	03/02/2004
	Purpose:	Wrapper function for getting Date results as a XML Tags

*********************************************************************************/

bool CDBXMLBuilder::DBAddDateTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, bool bIncludeRelative, CTDVDateTime* pDate)
{
	m_bIncludeRelative = bIncludeRelative;
	return GetDBResult(psResultName,psTagName,bFailIfNULL,false,DBRT_DATE,false,pDate);
}


/*********************************************************************************

	bool CDBXMLBuilder::DBAddDoubleTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, double* pdValue)

	Author:		Mark Howitt
	Created:	03/02/2004
	Purpose:	Wrapper function for getting Double results as a XML Tags

*********************************************************************************/

bool CDBXMLBuilder::DBAddDoubleTag(const TDVCHAR *psResultName, const TDVCHAR *psTagName, bool bFailIfNULL, double* pdValue)
{
	return GetDBResult(psResultName,psTagName,bFailIfNULL,false,DBRT_DOUBLE,false,pdValue);
}

/*********************************************************************************

	bool CDBXMLBuilder::OpenTag(const TDVCHAR *psTagName, bool bHasAttributes)

	Author:		Mark Howitt
	Created:	03/02/2004
	Inputs:		psTagName	- The name of the tag you want to open.
				bHasAttributes - A flag which states wether the tag will have attributes.
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Inserts an open Tag into the XML, with the option of adding attributes.
				e.g. <TAGNAME> OR <TAGNAME

*********************************************************************************/

bool CDBXMLBuilder::OpenTag(const TDVCHAR *psTagName, bool bHasAttributes)
{
	// Check to make sure the object has been initialised!
	if (m_psXML == NULL)
	{
		return SetDNALastError("CDBXMLBuilder::OpenTag","NotInitialised","XML Builder not initialised!");
	}

	// Check to see if we've been given a valid TagName
	if (psTagName == NULL || psTagName == "")
	{
		return SetDNALastError("CDBXMLBuilder::OpenTag","NoTagName","No Tag Name given!");
	}

	// Make sure it's upper case!
	CTDVString NewTag(psTagName);
	NewTag.MakeUpper();

	// Check to see if we've starting an attribute or tag
	if (bHasAttributes)
	{
		*m_psXML << "<" << NewTag;
	}
	else
	{
		*m_psXML << "<" << NewTag << ">";
	}

	return true;
}

/*********************************************************************************

	bool CDBXMLBuilder::CloseTag(const TDVCHAR *psTagName, const TDVCHAR* psTagValue)

	Author:		Mark Howitt
	Created:	03/02/2004
	Inputs:		psTagName - The name of the Tag you want to close.
				psValue -	An optional String Value, used if you open a tag with attributes
							and then require a tag values as well.
							e.g. <ABC ID=777 NODE=1>psValue</ABC>
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Closes a given tag. It first does a quick check to see if it
				can find a matching open tag.
				e.g. </TAGNAME>

*********************************************************************************/

bool CDBXMLBuilder::CloseTag(const TDVCHAR *psTagName, const TDVCHAR* psTagValue)
{
	// Check to make sure the object has been initialised!
	if (m_psXML == NULL)
	{
		return SetDNALastError("CDBXMLBuilder::CloseTag","NotInitialised","XML Builder not initialised!");
	}

	// Check to see if we've been given a valid TagName
	if (psTagName == NULL || psTagName == "")
	{
		return SetDNALastError("CDBXMLBuilder::CloseTag","NoTagName","No Tag Name given!");
	}

	// Make sure it's upper case!
	CTDVString NewTag(psTagName);
	NewTag.MakeUpper();

	// Check to see if the sXML string contains the opening tag!
	bool bOk = true;
	if (strstr(*m_psXML,NewTag) == NULL)
	{
		TDVASSERT(false,"CDBXMLBuilder::CloseXMLTag - Could not find matching open tag!");
		bOk = false;
	}
	else
	{
		// Check to see if we're adding a value before closing
		if (psTagValue != NULL && psTagValue != "")
		{
			*m_psXML << psTagValue;
		}

		// Close and return
		*m_psXML << "</" << NewTag << ">";
	}

	return bOk;
}

/*********************************************************************************

	bool CDBXMLBuilder::AddTag(const TDVCHAR *psTagName, const TDVCHAR *psValue)

	Author:		Mark Howitt
	Created:	03/02/2004
	Inputs:		psTagName - The name of the Tag you want to insert.
							If this "" then no <tagname> will be added. This is mainly
							used for psValues that already contain XML Tag info!
				psValue - The String value for the tag
	Outputs:	-
	Returns:	true if ok, false if not.
	Purpose:	Inserts a Tag with a given value into the XML string.
				e.g. <TAGNAME>Value</TAGNAME>

*********************************************************************************/

bool CDBXMLBuilder::AddTag(const TDVCHAR *psTagName, const TDVCHAR *psValue)
{
	// Check to make sure the object has been initialised!
	if (m_psXML == NULL)
	{
		return SetDNALastError("CDBXMLBuilder::AddTag","NotInitialised","XML Builder not initialised!");
	}

	// Check to see if we've been given a valid TagName
	if (psTagName == NULL || psValue == NULL)
	{
		return SetDNALastError("CDBXMLBuilder::AddTag","NoTagNameOrValue","No Tag Name Or Value Given!");
	}

	// Do we have anything to insert?
	if (strlen(psValue) == 0)
	{
		// No! Just return without putting anything into the xml.
		return true;
	}

	// Check to see if we're creating a tag or it's already in the psValue?
	if (psTagName == "")
	{
		*m_psXML << psValue;
	}
	else
	{
		// Make sure it's upper case!
		CTDVString NewTag(psTagName);
		NewTag.MakeUpper();

		// Put the tag and value into the xml string
		*m_psXML << "<" << NewTag << ">" << psValue << "</" << NewTag << ">";
	}
	return true;
}

/*********************************************************************************

	bool CDBXMLBuilder::AddAttribute(const TDVCHAR *psTagName, const TDVCHAR *psValue, bool bIsLastAttribute)

	Author:		Mark Howitt
	Created:	03/02/2004
	Inputs:		psTagName - The name of the Tag you want to insert.
				psValue - The String value for the tag.
				bIsLastAttribute - A Flag that states wether this is the last attribute for the tag.
					If it is the last attribute, then it closes the tag.
	Outputs:	-
	Returns:	true if ok, false if not.
	Purpose:	Inserts an attribute of given string value into the xml
				e.g. TAGNAME='Value' OR TAGNAME='Value'>

*********************************************************************************/

bool CDBXMLBuilder::AddAttribute(const TDVCHAR *psTagName, const TDVCHAR *psValue, bool bIsLastAttribute)
{
	// Check to make sure the object has been initialised!
	if (m_psXML == NULL)
	{
		return SetDNALastError("CDBXMLBuilder::AddAttribute","NotInitialised","XML Builder not initialised!");
	}

	// Check to see if we've been given a valid TagName
	if (psTagName == NULL || psValue == NULL || psTagName == "")
	{
		return SetDNALastError("CDBXMLBuilder::AddAttribute","NoTagNameOrValue","No Tag Name Or Value Given!");
	}

	// Do we have anything to insert?
	if (strlen(psValue) == 0)
	{
		// No! Just return without putting anything into the xml.
		return true;
	}

	// Make sure it's upper case!
	CTDVString NewTag(psTagName);
	NewTag.MakeUpper();

	// Put the tag and value into the xml string
	*m_psXML << " " << NewTag << "='" << psValue << "'";

	// Close the tag if we're the last attribute
	if (bIsLastAttribute)
	{
		*m_psXML << ">";
	}

	return true;
}

/*********************************************************************************

	bool CDBXMLBuilder::AddIntTag(const TDVCHAR* psTagName, const int iValue)

	Author:		Mark Howitt
	Created:	03/02/2004
	Inputs:		psTagName - The name of the Tag you want to insert.
				iValue - The Int value for the tag
	Outputs:	-
	Returns:	true if ok, false if not.
	Purpose:	Inserts a Tag with a given value into the XML string.
				e.g. <TAGNAME>iValue</TAGNAME>

*********************************************************************************/

bool CDBXMLBuilder::AddIntTag(const TDVCHAR* psTagName, const int iValue)
{
	// Check to make sure the object has been initialised!
	if (m_psXML == NULL)
	{
		return SetDNALastError("CDBXMLBuilder::AddIntTag","NotInitialised","XML Builder not initialised!");
	}

	// Check to see if we've been given a valid TagName
	if (psTagName == NULL || psTagName == "")
	{
		return SetDNALastError("CDBXMLBuilder::AddIntTag","NoTagName","No Tag Name Given!");
	}

	// Make sure it's upper case!
	CTDVString NewTag(psTagName);
	NewTag.MakeUpper();

	// Put the tag and value into the xml string
	*m_psXML << "<" << NewTag << ">" << iValue << "</" << NewTag << ">";
	return true;
}

/*********************************************************************************

	bool CDBXMLBuilder::AddIntAttribute(const TDVCHAR* psTagName, const int iValue, bool bIsLastAttribute)

	Author:		Mark Howitt
	Created:	03/02/2004
	Inputs:		psTagName - The name of the Tag you want to insert.
				iValue - The int value for the tag.
				bIsLastAttribute - A Flag that states wether this is the last attribute for the tag.
					If it is the last attribute, then it closes the tag.
	Outputs:	-
	Returns:	true if ok, false if not.
	Purpose:	Inserts an attribute of given int value into the xml
				e.g. TAGNAME=Value OR TAGNAME=Value>

*********************************************************************************/

bool CDBXMLBuilder::AddIntAttribute(const TDVCHAR* psTagName, const int iValue, bool bIsLastAttribute)
{
	// Check to make sure the object has been initialised!
	if (m_psXML == NULL)
	{
		return SetDNALastError("CDBXMLBuilder::AddIntAttribute","NotInitialised","XML Builder not initialised!");
	}

	// Check to see if we've been given a valid TagName
	if (psTagName == NULL || psTagName == "")
	{
		return SetDNALastError("CDBXMLBuilder::AddIntAttribute","NoTagName","No Tag Name Given!");
	}

	// Make sure it's upper case!
	CTDVString NewTag(psTagName);
	NewTag.MakeUpper();

	// Put the tag and value into the xml string
	*m_psXML << " " << NewTag << "='" << iValue << "'";
	
	// Close the tag if we're the last attribute
	if (bIsLastAttribute)
	{
		*m_psXML << ">";
	}

	return true;
}

/*********************************************************************************

	bool CDBXMLBuilder::AddDateTag(const TDVCHAR* psTagName, CTDVDateTime& Date, bool bIncludeRelative = false)

	Author:		Mark Howitt
	Created:	04/02/2004
	Inputs:		psTagName - The name of the Tag you want to insert.
				Date - The Date object for the tag
				bIncludeRelative - A flag that states wether to include the relative date
					in the result.
	Outputs:	-
	Returns:	true if ok, false if not.
	Purpose:	Inserts a Tag with a given Date into the XML string.
				e.g. <TAGNAME>DAYNAME="Thursday" SECONDS="59" MINUTES="03" HOURS="17" DAY="05" MONTH="02" MONTHNAME="February" YEAR="2004" SORT="20040205170359"</TAGNAME>

*********************************************************************************/

bool CDBXMLBuilder::AddDateTag(const TDVCHAR* psTagName, CTDVDateTime& Date, bool bIncludeRelative)
{
	// Check to make sure the object has been initialised!
	if (m_psXML == NULL)
	{
		return SetDNALastError("CDBXMLBuilder::AddIntAttribute","NotInitialised","XML Builder not initialised!");
	}

	// Check to see if we've been given a valid TagName
	if (psTagName == NULL || psTagName == "")
	{
		return SetDNALastError("CDBXMLBuilder::AddIntAttribute","NoTagName","No Tag Name Given!");
	}

	// Get the date as xml
	CTDVString sValue;
	Date.GetAsXML(sValue,bIncludeRelative);

	// Make sure it's upper case!
	CTDVString NewTag(psTagName);
	NewTag.MakeUpper();

	// Put the tag and value into the xml string
	*m_psXML << "<" << NewTag << ">" << sValue << "</" << NewTag << ">";
	return true;
}

void CDBXMLBuilder::Clear(void)
{
	if (m_psXML != NULL)
	{
		m_psXML->Empty();
	}
	m_sXML.Empty();
}

CDBXMLBuilder::operator const char *() const
{
	if (m_psXML == NULL)
	{
		return NULL;
	}
	return (const char*)*m_psXML;
}

/*********************************************************************************

	CTDVString CDBXMLBuilder::GetXML()

		Author:		Mark Neves
        Created:	02/06/2005
        Inputs:		-
        Outputs:	-
        Returns:	The content of the local XML string
        Purpose:	If you initialise the object without an XML string param, the local
					XML string gets populated.  This function allows you to get at the
					XML string.

*********************************************************************************/

CTDVString CDBXMLBuilder::GetXML()
{
	return m_sXML;
}
