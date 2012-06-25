//
// TDVString.cpp - the TDV platform independent String class.
//

#include "stdafx.h"
//#include "h2g2server.h"
#include "tdvassert.h"
#include "TDVString.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


#define __NO_RECT_STRINGS

#ifndef __NO_RECT_STRINGS
#include "TDVRect.h"
#endif
//
// Some of the donkey work is done by the ANSI library...
//
#include <string.h>
#include <stdio.h>
#include <ctype.h>

#ifndef ASSERT
#include <assert.h>
#include ".\tdvstring.h"
#define ASSERT assert
#endif

// memory tracking on

// This is the empty string that we refer when people want access to empty strings
const char* CTDVString::m_EmptyString = "";

const int BUFFER_PAD = 256;		// Always pad buffers by 256 bytes
								// This should NEVER be less than 1

#ifdef _MAC
//
// We have to implement the non-ANSI stricmp function for Mac.
// This code lifted from Microsoft's CRT source.
//

static int stricmp(const char * dst, const char * src)
{
        int f,l;

		// Doesn't handle locales but then I don't think we need to
        do 
        {
            if ( ((f = (unsigned char)(*(dst++))) >= 'A') && (f <= 'Z') )
                f -= ('A' - 'a');

            if ( ((l = (unsigned char)(*(src++))) >= 'A') && (l <= 'Z') )
                l -= ('A' - 'a');
        } while ( f && (f == l) );

        return(f - l);
}

#endif

#ifdef CTDVSTRING_INCLUDE_STATS
#pragma message(" - CTDVSTRING_INCLUDE_STATS is on in TDVString.h")
#endif // CTDVSTRING_INCLUDE_STATS

/******************************************************************************

	CTDVString::CTDVString()

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	
	Inputs:		
	Returns:	

******************************************************************************/

CTDVString::CTDVString() : m_pData(m_FixedBuffer),
						   m_BufferLength(CTDVSTRING_FIXED_BUFFER_LENGTH),
						   m_StringLength(0),
						   m_BufferPad(BUFFER_PAD),
						   m_pBuffer(NULL)
{
	CTDVSTRING_STATS_INCNUMCONSTRUCTS();
	Empty();
}


/******************************************************************************

	CTDVString::CTDVString(const CTDVString& Src)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Construct a new string from the given string.
	Inputs:		Src - String to copy

******************************************************************************/

CTDVString::CTDVString(const CTDVString& Src)
:
m_pData(m_FixedBuffer), m_BufferLength(CTDVSTRING_FIXED_BUFFER_LENGTH), 
m_StringLength(0), m_BufferPad(BUFFER_PAD), m_pBuffer(NULL)
{
	CTDVSTRING_STATS_INCNUMCONSTRUCTS();
	Copy(Src.m_pData);
}

/******************************************************************************

	CTDVString::CTDVString(TDVCHAR Ch, int nRepeat = 1)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Construct a new string, consisting of one or more of the
				same character.
	Inputs:		Ch - the character to repeat
				nRepeat - how many times to repeat it.

******************************************************************************/

CTDVString::CTDVString(TDVCHAR Ch, int nRepeat)
:
m_pData(m_FixedBuffer), m_BufferLength(CTDVSTRING_FIXED_BUFFER_LENGTH),
m_pBuffer(NULL), m_BufferPad(BUFFER_PAD)
{
	CTDVSTRING_STATS_INCNUMCONSTRUCTS();
	// Sanity check
	if (nRepeat < 0)
	{
		// Illegal
		throw CTDVString("Negative repeat value in constructor not allowed");
	}

	// Make repetitions of this character.
	EnsureBufferLength(nRepeat,false);

	if (nRepeat > 0)
		memset(m_pData, Ch, nRepeat);

	m_StringLength = nRepeat;
	// Terminate the string
	m_pData[m_StringLength] = 0;
}

/******************************************************************************

	CTDVString::CTDVString(int nNumber)
						 ,
	Author:		Sean Solle
	Created:	10/4/97
	Purpose:	Construct an ascii decimal version of the integer passed.
	Inputs:		An integer
	Returns:

******************************************************************************/

CTDVString::CTDVString(int nNumber)
: 
m_pData(m_FixedBuffer), m_BufferLength(CTDVSTRING_FIXED_BUFFER_LENGTH),
m_pBuffer(NULL), m_BufferPad(BUFFER_PAD)
{
	CTDVSTRING_STATS_INCNUMCONSTRUCTS();
	EnsureBufferLength(32,false);

	// Convert the number to ascii decimal.

	sprintf((char*)m_pData, "%d", nNumber);
	
	// Copy this string
	
	m_StringLength = strlen((char*)m_pData);

}

/******************************************************************************

	CTDVString::CTDVString(DWORD nNumber)

	Author:		Mark Neves
	Created:	12/02/08
	Purpose:	Construct an ascii decimal version of the unsigned integer passed.
	Inputs:		An unsigned integer
	Returns:

******************************************************************************/

CTDVString::CTDVString(DWORD nNumber)
: 
m_pData(m_FixedBuffer), m_BufferLength(CTDVSTRING_FIXED_BUFFER_LENGTH),
m_pBuffer(NULL), m_BufferPad(BUFFER_PAD)
{
	CTDVSTRING_STATS_INCNUMCONSTRUCTS();
	EnsureBufferLength(32,false);

	// Convert the number to ascii decimal.

	sprintf((char*)m_pData, "%u", nNumber);
	
	// Copy this string
	
	m_StringLength = strlen((char*)m_pData);

}

/******************************************************************************

	CTDVString::CTDVString(long lNumber)

	Author:		Kim Harries
	Created:	20/03/2001
	Purpose:	Construct an ascii decimal version of the long passed.
	Inputs:		A long
	Returns:

******************************************************************************/

CTDVString::CTDVString(long lNumber)
:
m_pData(m_FixedBuffer), m_BufferLength(CTDVSTRING_FIXED_BUFFER_LENGTH),
m_pBuffer(NULL), m_BufferPad(BUFFER_PAD)
{
	CTDVSTRING_STATS_INCNUMCONSTRUCTS();
	EnsureBufferLength(32,false);
	// Convert the number to ascii decimal.
	sprintf((char*)m_pData, "%d", lNumber);
	// Copy this string
	m_StringLength = strlen((char*)m_pData);
}

/******************************************************************************

	CTDVString::CTDVString(float fNumber)

	Author:		Kim Harries
	Created:	20/03/2001
	Purpose:	Construct an ascii decimal version of the float passed.
	Inputs:		A float
	Returns:

******************************************************************************/

CTDVString::CTDVString(float fNumber)
:
m_pData(m_FixedBuffer), m_BufferLength(CTDVSTRING_FIXED_BUFFER_LENGTH),
m_pBuffer(NULL), m_BufferPad(BUFFER_PAD)
{
	CTDVSTRING_STATS_INCNUMCONSTRUCTS();
	EnsureBufferLength(128,false);

	// Convert the number to ascii decimal.
	sprintf((char*)m_pData, "%f", fNumber);
	// Copy this string
	m_StringLength = strlen((char*)m_pData);
}

/******************************************************************************

	CTDVString::CTDVString(double dNumber)

	Author:		Kim Harries
	Created:	20/03/2001
	Purpose:	Construct an ascii decimal version of the float passed.
	Inputs:		A double
	Returns:

******************************************************************************/

CTDVString::CTDVString(double dNumber)
:
m_pData(m_FixedBuffer), m_BufferLength(CTDVSTRING_FIXED_BUFFER_LENGTH),
m_pBuffer(NULL), m_BufferPad(BUFFER_PAD)
{
	CTDVSTRING_STATS_INCNUMCONSTRUCTS();
	EnsureBufferLength(128,false);

	// Convert the number to ascii decimal.
	sprintf((char*)m_pData, "%f", dNumber);
	// Copy this string
	m_StringLength = strlen((char*)m_pData);
}

#ifndef __NO_RECT_STRINGS

/******************************************************************************

	CTDVString::CTDVString(CTDVRect& Rect)
						 ,
	Author:		Sean Solle
	Created:	10/4/97
	Purpose:	Construct an ascii decimal version of the rectangle passed.
	Inputs:		A rectangle.
	Returns:

******************************************************************************/

CTDVString::CTDVString(CTDVRect& Rect)
:
m_pData(m_FixedBuffer), m_BufferLength(CTDVSTRING_FIXED_BUFFER_LENGTH),
m_pBuffer(NULL), m_BufferPad(BUFFER_PAD)
{
	CTDVSTRING_STATS_INCNUMCONSTRUCTS();
	EnsureBufferLength(128,false);

	// Convert the number to ascii decimal.

	sprintf(m_pData, "Top: %d  Left:%d  Bottom:%d  Right: %d", Rect.top, Rect.left, Rect.bottom, Rect.right);

	// Update the stringlength.
	m_StringLength = strlen((char*)m_pData);

}

#endif


/******************************************************************************

	CTDVString::CTDVString(const TDVCHAR* pString)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Construct a new string from the given string.
	Inputs:		pString - null-terminated C-style string to copy.

******************************************************************************/

CTDVString::CTDVString(const TDVCHAR* pString)
:
m_pData(m_FixedBuffer), m_BufferLength(CTDVSTRING_FIXED_BUFFER_LENGTH),
m_pBuffer(NULL), m_BufferPad(BUFFER_PAD)
{
	CTDVSTRING_STATS_INCNUMCONSTRUCTS();
	// Copy this string
	if (pString)
	{
		int nLen = strlen(pString);
		EnsureBufferLength(nLen+1,false);
		strcpy(m_pData, pString);
		m_StringLength = nLen;
	}
	else
	{
		Empty();
	}
}


// Do a CString interface if CString has been defined (i.e. MFC is in use)
#if 0
#ifdef __AFX_H__

/******************************************************************************

	CTDVString::CTDVString(const CString& Src)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Construct a new string, using an MFC CString to copy from.
	Inputs:		Src - the MFC string to copy.

******************************************************************************/

CTDVString::CTDVString(const CString& Src)
:
m_pData(m_FixedBuffer), m_BufferLength(CTDVSTRING_FIXED_BUFFER_LENGTH),
m_pBuffer(NULL), m_BufferPad(BUFFER_PAD)
{
	CTDVSTRING_STATS_INCNUMCONSTRUCTS();

	// Copy this string
	int nLen = Src.GetLength();
	EnsureBufferLength(nLen+1,false);
	strcpy(m_pData, (LPCTSTR) Src);
	m_StringLength = nLen;
}

#endif
#endif


#ifdef _MAC
/******************************************************************************

	CTDVString::CTDVString(const CPascalString& Src)

	Author:		Mike Kenny
	Created:	14/8/98
	Purpose:	Construct a new string, using a CPascalString to copy from.
	Inputs:		Src - the CPascalString string to copy.

******************************************************************************/

CTDVString::CTDVString(const CPascalString& Src)
:
m_pData(m_FixedBuffer), m_BufferLength(CTDVSTRING_FIXED_BUFFER_LENGTH),
m_pBuffer(NULL), m_BufferPad(BUFFER_PAD)
{
	CTDVSTRING_STATS_INCNUMCONSTRUCTS();
	// Copy this string
	int nLen = Src.GetLength();
	EnsureBufferLength(nLen+1,false);
	Src.CopyCharsTo((BYTE*)m_pData,nLen);
	m_pData[nLen] = '\0';
	m_StringLength = nLen;
}
#endif



/******************************************************************************

	CTDVString::~CTDVString()

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Destructor

******************************************************************************/

CTDVString::~CTDVString()
{
	CTDVSTRING_STATS_INCNUMDESTRUCTS();
	CTDVSTRING_STATS_INCSUMSIZE(m_StringLength);

#ifdef CTDVSTRING_INCLUDE_STATS
	if (m_pData == NULL) CTDVSTRING_STATS_INCNUMNULLS();
	if (m_StringLength == 0) CTDVSTRING_STATS_INCNUM0();
	if (m_StringLength >=1  && m_StringLength < 32) CTDVSTRING_STATS_INCNUMLOWER32();
	if (m_StringLength >=32 && m_StringLength < 64) CTDVSTRING_STATS_INCNUMLOWER64();
	if (m_StringLength >=64 && m_StringLength < 128) CTDVSTRING_STATS_INCNUMLOWER128();
	if (m_StringLength >=128) CTDVSTRING_STATS_INCNUMHIGHER128();
#endif // CTDVSTRING_INCLUDE_STATS

	DeleteBuffer();
}

/******************************************************************************

	int CTDVString::GetLength() const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Find the length of the string, in characters.
	Returns:	Length of string, in characters.

******************************************************************************/

int CTDVString::GetLength() const
{
	return m_StringLength;
}




/******************************************************************************

	bool CTDVString::IsEmpty() const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Determine whether or not the string is empty.
	Returns:	TRUE => String is empty (contains no characters).
				FALSE => String is not empty

******************************************************************************/

bool CTDVString::IsEmpty() const
{
	return (m_StringLength == 0);
}




/******************************************************************************

	void CTDVString::Empty()

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Set the string to be empty (i.e. it will be 0 characters long).

******************************************************************************/

void CTDVString::Empty()
{
	if (m_pData != NULL)
	{
		m_pData[0] = 0;
	}
	m_StringLength = 0;
}


/******************************************************************************

	void CTDVString::EnsureAvailable(int nBytes)

	Author:		Tim Browse
	Created:	30/9/97
	Purpose:	Makes sure the buffer allocated for this string is at least
				nBytes in size.

******************************************************************************/

void CTDVString::EnsureAvailable(int nBytes)
{
	EnsureBufferLength(nBytes,true);
}

void CTDVString::EnsureBufferLength(int nLen, bool bPreserveString, int nPrefix)
{
	if (m_BufferLength >= nLen)
	{
		// Already big enough
		return;
	}

	int nRequiredLength = nLen + m_BufferPad;
	int nStringLength = 0;
	TDVCHAR* pNewBuffer = AllocTDVCHAR(nRequiredLength);
	if (bPreserveString && m_StringLength > 0)
	{
		strcpy(pNewBuffer+nPrefix,m_pData);
		nStringLength = m_StringLength + nPrefix;
	}
	else
		*pNewBuffer = 0;

	DeleteBuffer();
	m_pBuffer = pNewBuffer;
	m_pData	  = pNewBuffer;
	m_BufferLength = nRequiredLength;
	m_StringLength = nStringLength;
}

/******************************************************************************

	void CTDVString::UpdateLength()

	Author:		Tim Browse
	Created:	30/9/97
	Purpose:	Informs object that a client has just partied on the buffer
				directly, and the string length should be updated because of
				this.

******************************************************************************/

void CTDVString::UpdateLength()
{
	if (m_pData == NULL)
		m_StringLength = 0;
	else
		m_StringLength = strlen(m_pData);
}

/******************************************************************************

	TDVCHAR CTDVString::GetAt(int nIndex) const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Get the character at the specified index.
	Inputs:		nIndex - which character to get (0 based)
	Returns:	Character from specified position.

******************************************************************************/

TDVCHAR CTDVString::GetAt(int nIndex) const
{
	if (m_StringLength <= nIndex)
	{
		// Illegal
		throw CTDVString("GetAt() : index is out of range of string");
	}

	return m_pData[nIndex];
}




/******************************************************************************

	TDVCHAR CTDVString::operator[](int nIndex) const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Get the character at the specified index.
	Inputs:		nIndex - which character to get (0 based)
	Returns:	Character from specified position.

******************************************************************************/

TDVCHAR CTDVString::operator[](int nIndex) const
{
	if (m_StringLength <= nIndex)
	{
		// Illegal
		throw CTDVString("operator[] : index is out of range of string");
	}

	return m_pData[nIndex];
}




/******************************************************************************

	void CTDVString::SetAt(int nIndex, TDVCHAR Ch)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Set the specified character to the specified value.
	Inputs:		nIndex - which character to set (0 based)
				Ch - the character value to set it to.

******************************************************************************/

void CTDVString::SetAt(int nIndex, TDVCHAR Ch)
{
	if (m_StringLength <= nIndex)
	{
		// Illegal
		throw CTDVString("SetAt() : index is out of range of string");
	}

	// Set the character
	m_pData[nIndex] = Ch;

	// Was it a terminator character?
	if (Ch == 0)
	{
		// Yes, so update string length
		m_StringLength = nIndex;
	}
}


/******************************************************************************

	CTDVString::operator const char *() const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Cast a string object to a (read-only/const) C-style string.

******************************************************************************/

CTDVString::operator const char *() const
{
	// If the string is empty, then use the Empty null terminated string we happen to have
	if (m_pData==NULL)
		return m_EmptyString;

	// otherwise we can use the real string
	return (const char *) m_pData;
}



// Do a cast operator for CString if ithas been defined (i.e. MFC is in use)
#ifdef __AFX_H__
#if 0
/******************************************************************************

	CTDVString::operator CString() const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Cast a string object to an MFC-style CString object.

******************************************************************************/

CTDVString::operator CString() const
{
	// If the string is empty, then use the Empty null terminated string we happen to have
	if (m_pData==NULL)
		return CString(m_EmptyString);

	return CString(m_pData);
}

/******************************************************************************

	CTDVString::operator CString()

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Cast a string object to an MFC-style CString object.

******************************************************************************/

CTDVString::operator CString()
{
	// If the string is empty, then use the Empty null terminated string we happen to have
	if (m_pData==NULL)
		return CString(m_EmptyString);

	return CString(m_pData);
}
#endif
#endif



/******************************************************************************

	void CTDVString::Copy(const TDVCHAR *pSrc)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Generic copy function.
	Inputs:		pSrc - string to copy

******************************************************************************/

void CTDVString::Copy(const TDVCHAR *pSrc)
{
	// Look for the easy way out
	if (pSrc == NULL)
	{
		// We need to copy an empty string
		Empty();
		return;
	}

	// Do we have enough space to hold this string?
	int SrcLength = strlen(pSrc);
	EnsureBufferLength(SrcLength+1,false);

	// Copy the string, as we now have a big enough buffer
	ASSERT(m_pData != NULL);
	strcpy(m_pData, pSrc);
	m_StringLength = SrcLength;
}

/******************************************************************************

	const CTDVString& CTDVString::operator=(const CTDVString& Src)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Assignment operator.
	Inputs:		Src - string to copy
	Returns:	Reference to this string.

******************************************************************************/

const CTDVString& CTDVString::operator=(const CTDVString& Src)
{
	Copy(Src.m_pData);
	return *this;
}




/******************************************************************************

	const CTDVString& CTDVString::operator=(TDVCHAR *pString)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Assignment operator.
	Inputs:		pString - string to copy.
	Returns:	Reference to this string.

******************************************************************************/

const CTDVString& CTDVString::operator=(TDVCHAR *pString)
{
	Copy(pString);
	return *this;
}




/******************************************************************************

	const CTDVString& CTDVString::operator=(TDVCHAR Ch)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Assignment operator.  
				Makes the string one character long.
	Inputs:		Ch - the character to copy.
	Returns:	Reference to this string.

******************************************************************************/

const CTDVString& CTDVString::operator=(TDVCHAR Ch)
{
	TDVCHAR Temp[] = "?";
	Temp[0] = Ch;
	Copy(Temp);
	return *this;
}




/******************************************************************************

	const CTDVString& CTDVString::operator=(const TDVCHAR *pString)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Assignment operator.
	Inputs:		pString - string to copy.
	Returns:	Reference to this string.

******************************************************************************/

const CTDVString& CTDVString::operator=(const TDVCHAR *pString)
{
	Copy(pString);
	return *this;
}

/******************************************************************************

	int CTDVString::operator==(const TDVCHAR *pString)

	Author:		Tim Browse
	Created:	12/2/97
	Purpose:	Equality operator.
	Inputs:		pString - string to check against.
	Returns:	non-zero if equal;
				0 if not.

******************************************************************************/

int CTDVString::operator==(const TDVCHAR *pString)
{
	// Avoid accessing m_pData pointer of this string if it could be NULL.
	if (m_StringLength == 0)
	{
		// They're equal if they're both zero length.
		return (strlen(pString) == 0);
	}

	// Use strcmp to compare
	return (strcmp(m_pData, pString) == 0);
}

/******************************************************************************

	int CTDVString::operator!=(const CTDVString& Other)

	Author:		Tim Browse
	Created:	12/2/97
	Purpose:	Inequality operator.
	Inputs:		Other - string to check against.
	Returns:	non-zero if unequal;
				0 if not.

******************************************************************************/

int CTDVString::operator!=(const CTDVString& Other)
{
	// Avoid accessing m_pData pointer of either string if it could be NULL.
	if (Other.m_StringLength == 0)
	{
		// They're equal if they're both zero length.
		return (m_StringLength != 0);
	}
	else if (m_StringLength == 0)
	{
		// This one's zero length, but the other one isn't => not equal
		return 1;
	}

	// Use strcmp to compare
	return (strcmp(m_pData, Other.m_pData) != 0);
}

/******************************************************************************

	int CTDVString::operator!=(const TDVCHAR *pString)

	Author:		Tim Browse
	Created:	12/2/97
	Purpose:	Inequality operator.
	Inputs:		pString - string to check against.
	Returns:	non-zero if unequal;
				0 if not.

******************************************************************************/

int CTDVString::operator!=(const TDVCHAR *pString)
{
	// Avoid accessing m_pData pointer of this string if it could be NULL.
	if (m_StringLength == 0)
	{
		// They're equal if they're both zero length.
		return (strlen(pString) != 0);
	}

	// Use strcmp to compare
	return (strcmp(m_pData, pString) != 0);
}

/******************************************************************************

	bool CTDVString::CompareText(const CTDVString &Other) const

	Author:		Tim Browse
	Created:	24/6/97
	Purpose:	Case-insensitive equality operator.
	Inputs:		Other - string to check against.
	Returns:	TRUE if equal;
				FALSE if not.

******************************************************************************/

bool CTDVString::CompareText(const CTDVString &Other) const
{
	// If they are the same length, then test to see if they are the same
	if (Other.m_StringLength == m_StringLength)
	{
		// First check if both strings are empty and return true in this case
		if (m_StringLength == 0)
			return true;

		// NB. May need to change this on MacOS if it doesn't support stricmp().
		return (_stricmp(m_pData, Other.m_pData) == 0);
	}

	return false;
}

/******************************************************************************

	bool CTDVString::CompareText(const TDVCHAR *pOther) const

	Author:		Tim Browse
	Created:	12/2/97
	Purpose:	Case-insensitive equality operator.
	Inputs:		pOther - string to check against.
	Returns:	TRUE if equal;
				FALSE if not.

******************************************************************************/

bool CTDVString::CompareText(const TDVCHAR *pOther) const
{
	// Avoid accessing m_pData pointer of this string if it could be NULL.
	if (m_StringLength == 0)
	{
		// They're equal if they're both zero length.
		return (strlen(pOther) == 0);
	}

	// NB. May need to change this on MacOS if it doesn't support stricmp().
	return (_stricmp(m_pData, pOther) == 0);
}

bool CTDVString::operator <(const CTDVString& Other) const
{
	if (!m_pData || !Other.m_pData)
	{
		return false;
	}
	return (strcmp(m_pData, Other.m_pData) < 0);
}

bool CTDVString::operator >(const CTDVString& Other) const
{
	if (!m_pData || !Other.m_pData)
	{
		return false;
	}
	return (strcmp(m_pData, Other.m_pData) > 0);
}

/******************************************************************************

	void CTDVString::Concat(const TDVCHAR *pSrc)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Generic string concatenation function.
	Inputs:		pSrc - string to concatenate with this one

******************************************************************************/

void CTDVString::Concat(const TDVCHAR *pSrc)
{
	// Check for simple cases
	if (pSrc == NULL)
	{
		// Nothing to do!
		return;
	}

	if (m_StringLength == 0)
	{
		Copy(pSrc);
		return;
	}
	
	// Do we have enough space to hold this string?
	int RequiredLength = m_StringLength + strlen(pSrc);
	EnsureBufferLength(RequiredLength+1,true);

	// Concatentate the string, as we now have a big enough buffer
	ASSERT(m_pData != NULL);
	strcpy(m_pData + m_StringLength, pSrc);
	m_StringLength = RequiredLength;
}

/******************************************************************************

	void CTDVString::Prefix(const TDVCHAR *pSrc)
						 ,
	Author:		Sean Solle
	Created:	9/10/97
	Purpose:	Generic string prefixing function.
	Inputs:		pSrc - string to prefix to this one

******************************************************************************/

void CTDVString::Prefix(const TDVCHAR *pSrc)
{
	// Check for simple cases
	if (pSrc == NULL)
	{
		// Nothing to do!
		return;
	}

	if (m_StringLength == 0)
	{
		Copy(pSrc);
		return;
	}

	// Do we have enough space to hold this string?
	int nPrefixLength = strlen(pSrc);

	int RequiredLength = m_StringLength + nPrefixLength;
	if (m_BufferLength <= RequiredLength)
	{
		// No - get a new buffer, copy our data at the end of it,
		// and discard the old buffer.

		EnsureBufferLength(RequiredLength + 1,true, nPrefixLength);
	}
	else
	{
		// Yes ... shuffle our data down to make room for the prefix,
		// copying an extra char to ensure termination.
		// memmove() allows for overlapping buffers.

		memmove(m_pData + nPrefixLength, m_pData, m_StringLength+1);
	}

	// We now have a big enough space at the start of the buffer,
	// so copy the prefix to the start of the buffer ... 
	// memcpy() avoids copying the source's terminating zero.

	memcpy(m_pData, pSrc, nPrefixLength);

	// Update string length
	m_StringLength = RequiredLength;
}

/******************************************************************************

	void CTDVString::AppendChars(const TDVCHAR *pSrc, int nCharsToCopy)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Copy a slice out of a C-style string, and append it to this one.
	Inputs:		pSrc - string to concatenate with this one
				nCharsToCopy - the number of characters to copy.

******************************************************************************/

void CTDVString::AppendChars(const TDVCHAR *pSrc, int nCharsToCopy)
{
	// Check for simple cases
	if (pSrc == NULL)
	{
		// Nothing to do!
		return;
	}

	// Do we have enough space to hold this string?
	int RequiredLength = m_StringLength + nCharsToCopy;
	EnsureBufferLength(RequiredLength+1,true);

	// Concatentate the string, as we now have a big enough buffer
	ASSERT(m_pData != NULL);
	memcpy(m_pData + m_StringLength, pSrc, nCharsToCopy);
	m_StringLength = RequiredLength;

	// Terminate the string
	m_pData[m_StringLength] = 0;

	// Ensure we have a valid length for the string - the data we just
	// copied may have contained 0 bytes.
	m_StringLength = strlen(m_pData);
}



/******************************************************************************

	const CTDVString& CTDVString::operator+=(const CTDVString& String)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Concatenation operator.
	Inputs:		String - the string to append to this one.
	Returns:	Reference to this string.

******************************************************************************/

const CTDVString& CTDVString::operator+=(const CTDVString& String)
{
	Concat(String.m_pData);
	return *this;
}




/******************************************************************************

	const CTDVString& CTDVString::operator+=(TDVCHAR Ch)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Concatenation operator.
	Inputs:		Ch - the character to append to this string.
	Returns:	Reference to this string.

******************************************************************************/

const CTDVString& CTDVString::operator+=(TDVCHAR Ch)
{
	TDVCHAR Temp[] = "?";
	Temp[0] = Ch;
	Concat(Temp);
	return *this;
}




/******************************************************************************

	const CTDVString& CTDVString::operator+=(const TDVCHAR *pString)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Concatenation operator.
	Inputs:		String - the string to append to this one.
	Returns:	Reference to this string.

******************************************************************************/

const CTDVString& CTDVString::operator+=(const TDVCHAR *pString)
{
	Concat(pString);
	return *this;
}




/******************************************************************************

	void CTDVString::CopyChars(const TDVCHAR *pSrc, int nFirst, int nCharsToCopy)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Copies the substring specified.
	Inputs:		pSrc - the string to copy from.
				nFirst - the character to start from (0 based)
				nCount - number of characters to get from the string.

******************************************************************************/

void CTDVString::CopyChars(const TDVCHAR *pSrc, int nFirst, int nCharsToCopy)
{
	// Don't bother if we don't have a source string
	if (pSrc == NULL)
		return;

	// Trap for -ve character copies.
	if (nCharsToCopy < 0)
	{	
		ASSERT(FALSE);
		nCharsToCopy = 0;
	}

	// Do we have enough space to hold this string?
	EnsureBufferLength(nCharsToCopy + 1,false);

	// Copy the string, as we now have a big enough buffer
	ASSERT(m_pData != NULL);
	memcpy(m_pData, pSrc + nFirst, nCharsToCopy);
	m_StringLength = nCharsToCopy;

	// Terminate the string.
	m_pData[m_StringLength] = 0;
}


/******************************************************************************

	void CTDVString::RemoveTrailingChar(TDVCHAR Ch)

	Author:		Tim Browse
	Created:	19/5/97
	Purpose:	Remove the last character of a string if it matches the one
				the caller specified.
	Inputs:		Ch - character to remove.

******************************************************************************/

void CTDVString::RemoveTrailingChar(TDVCHAR Ch)
{
	if (m_StringLength > 0)
	{
		TDVCHAR LastCh = GetAt(m_StringLength - 1);
		if (LastCh == Ch)
		{
			// Remove the last character
			m_StringLength--;

			// Terminate the string.
			m_pData[m_StringLength] = 0;
		}
	}
}


/******************************************************************************

	CTDVString CTDVString::Mid(int nFirst, int nCount) const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Return a string object that contains the substring specified.
	Inputs:		nFirst - the character to start from (0 based)
				nCount - number of characters to get from the string.
	Returns:	The substring specified.

******************************************************************************/

CTDVString CTDVString::Mid(int nFirst, int nCount) const
{
	// Use helper function
	CTDVString Result;
	
	if (nCount + nFirst > m_StringLength)
	{
		nCount = m_StringLength - nFirst;
	}
	
	Result.CopyChars(m_pData, nFirst, nCount);
	return Result;
}




/******************************************************************************

	CTDVString CTDVString::Mid(int nFirst) const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Return a string object that contains the substring specified.
				The substring is from the character specified up to the end of 
				the string.
	Inputs:		nFirst - the character to start from (0 based)
	Returns:	The substring specified.

******************************************************************************/

CTDVString CTDVString::Mid(int nFirst) const
{
	// Use helper function
	CTDVString Result;
	Result.CopyChars(m_pData, nFirst, m_StringLength - nFirst);
	return Result;
}





/******************************************************************************

	CTDVString CTDVString::Left(int nCount) const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Return a substring of the first n characters of the string.
	Inputs:		nCount - the number of characters to copy.
	Returns:	The substring specified

******************************************************************************/

CTDVString CTDVString::Left(int nCount) const
{
	// Use helper function
	CTDVString Result;
	
	if (nCount > m_StringLength)
	{
		nCount = m_StringLength;
	}
	
	Result.CopyChars(m_pData, 0, nCount);
	return Result;
}




/******************************************************************************

	CTDVString CTDVString::Right(int nCount) const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Return a substring of the last n characters of the string.
	Inputs:		nCount - the number of characters to copy.
	Returns:	The substring specified

******************************************************************************/

CTDVString CTDVString::Right(int nCount) const
{
	// Use helper function
	CTDVString Result;

	// Limit substring to max size of source string
	if (nCount > m_StringLength)
		nCount = m_StringLength;

	Result.CopyChars(m_pData, m_StringLength - nCount, nCount);
	return Result;
}




/******************************************************************************

	void CTDVString::MakeUpper()

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Convert the whole string to upper case.

******************************************************************************/

void CTDVString::MakeUpper()
{
	if ((m_pData != NULL) && (m_StringLength > 0))
	{
		for (int i = 0; i < m_StringLength; i++)
		{
			m_pData[i] = toupper(m_pData[i]);
		}
	}
}




/******************************************************************************

	void CTDVString::MakeLower()

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Convert the whole string to lower case.

******************************************************************************/

void CTDVString::MakeLower()
{
	if ((m_pData != NULL) && (m_StringLength > 0))
	{
		for (int i = 0; i < m_StringLength; i++)
		{
			m_pData[i] = tolower(m_pData[i]);
		}
	}
}




/******************************************************************************

	void CTDVString::MakeReverse()

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Reverse the string on a character basis, 
					i.e. "hello" becomes "olleh".

******************************************************************************/

void CTDVString::MakeReverse()
{
	if ((m_pData != NULL) && (m_StringLength > 1))
	{
		int i = 0;
		int j = m_StringLength - 1;
		while (i < j)
		{
			// Swap characters
			TDVCHAR Temp = m_pData[i];
			m_pData[i] = m_pData[j];
			m_pData[j] = Temp;

			// Move along
			i++;
			j--;
		}
	}
}




/******************************************************************************

	int CTDVString::Find(TDVCHAR Ch) const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Find the first occurence of the character within the string.
	Inputs:		Ch - the character to look for.
	Returns:	0 or greater => index of the character
				negative => character not found

******************************************************************************/

int CTDVString::Find(TDVCHAR Ch) const
{
	if ((m_pData != NULL) && (m_StringLength > 0))
	{
		// Look for first occurence of character.
		for (int i = 0; i < m_StringLength; i++)
		{
			if (m_pData[i] == Ch)
			{
				// Found it!
				return i;
			}
		}
	}

	// Not found
	return -1;
}




/******************************************************************************

	int CTDVString::ReverseFind(TDVCHAR ch) const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Find the last occurence of the character within the string.
	Inputs:		Ch - the character to look for.
	Returns:	0 or greater => index of the character
				negative => character not found

******************************************************************************/

int CTDVString::ReverseFind(TDVCHAR Ch) const
{
	if ((m_pData != NULL) && (m_StringLength > 0))
	{
		// Look for first occurence of character.
		for (int i = (m_StringLength - 1); i >= 0; i--)
		{
			if (m_pData[i] == Ch)
			{
				// Found it!
				return i;
			}
		}
	}

	// Not found
	return -1;
}



/******************************************************************************

	int CTDVString::Find(const TDVCHAR *pSubString) const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Find the first occurence of the substring within this string.
	Inputs:		pSubString - the substring to search for.
	Returns:	0 or greater => index of the character
				negative => character not found

******************************************************************************/

int CTDVString::Find(const TDVCHAR *pSubString, int StartPos) const
{
	if ((m_pData != NULL) && (m_StringLength > 0) && (StartPos >= 0) && (StartPos < m_StringLength))
	{
		char *Result = strstr(m_pData + StartPos, pSubString);
		if (Result != NULL)
		{
			// Found it!
			return (Result - m_pData);
		}
	}
	
	// Not found
	return -1;
}

/******************************************************************************

	int CTDVString::FindText(const TDVCHAR *pSubString, int StartPos) const

	Author:		Tim Browse
	Created:	20/3/97
	Modified:	03/07/2000 - added StartPos param (Kim)
	Purpose:	Find the first occurence of the substring within this string,
				ignoring case.
	Inputs:		pSubString - the substring to search for.
				StartPos - place to start searching from
	Returns:	0 or greater => index of the character
				negative => character not found

******************************************************************************/

int CTDVString::FindText(const TDVCHAR *pSubString, int StartPos) const
{
	CTDVString This = *this;
	CTDVString SubString(pSubString);
	This.MakeLower();
	SubString.MakeLower();

	if ((m_pData != NULL) && (m_StringLength > 0) && (StartPos >= 0) && (StartPos < m_StringLength))
	{
		char *Result = strstr(This.m_pData + StartPos, SubString.m_pData);
		if (Result != NULL)
		{
			// Found it!
			return (Result - This.m_pData);
		}
	}
	
	// Not found
	return -1;
}


int CTDVString::FindTextLast(const TDVCHAR *pSubString, int nStartPos) const
{
	int nLastPos = -1;
	int nSubStrLen = strlen(pSubString);
	for (int n=nStartPos, p=0; p >= 0;)
	{
		p = FindText(pSubString, n);
		if (p >=0)
		{
			nLastPos = p;
			n = p + nSubStrLen;
		}
	}

	return nLastPos;
}

/******************************************************************************

	CTDVString operator+(const CTDVString& String1, const CTDVString& String2)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Join two strings together to form a new one.
	Inputs:		The strings to join together.
	Returns:	The result of concatenating String2 onto String1.

******************************************************************************/

CTDVString operator+(const CTDVString& String1, const CTDVString& String2)
{
	CTDVString Result(String1);
	Result += String2;
	return Result;
}



/******************************************************************************

	CTDVString operator+(const CTDVString& String, TDVCHAR Ch)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Join a character onto the end of a string.
	Inputs:		The string and character to join together.
	Returns:	The result of concatenating Ch onto String.

******************************************************************************/

CTDVString operator+(const CTDVString& String, TDVCHAR Ch)
{
	CTDVString Result(String);
	CTDVString ChString(Ch);
	Result += ChString;
	return Result;
}




/******************************************************************************

	CTDVString operator+(TDVCHAR Ch, const CTDVString& String)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Join a string onto the end of a single character string.
	Inputs:		The string and character to join together.
	Returns:	The result of concatenating String onto Ch.

******************************************************************************/

CTDVString operator+(TDVCHAR Ch, const CTDVString& String)
{
	CTDVString Result(Ch);
	Result += String;
	return Result;
}




/******************************************************************************

	CTDVString operator+(const CTDVString& String1, const TDVCHAR *pString2)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Join two strings together to form a new one.
	Inputs:		The strings to join together.
	Returns:	The result of concatenating pString2 onto String1.

******************************************************************************/

CTDVString operator+(const CTDVString& String1, const TDVCHAR *pString2)
{
	CTDVString Result(String1);
	Result += pString2;
	return Result;
}




/******************************************************************************

	CTDVString operator+(const TDVCHAR *pString1, const CTDVString& String2)

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Join two strings together to form a new one.
	Inputs:		The strings to join together.
	Returns:	The result of concatenating String2 onto pString1.

******************************************************************************/

CTDVString operator+(const TDVCHAR *pString1, const CTDVString& String2)
{
	CTDVString Result(pString1);
	Result += String2;
	return Result;
}

/******************************************************************************

	CTDVString CTDVString::TruncateRight(int nCount) const
						 ,
	Author:		Sean Solle
	Created:	3/6/97
	Purpose:	Return a substring with the right-most n characters stripped.
	Inputs:		nCount - the number of characters to strip.
	Returns:	The substring specified

******************************************************************************/

CTDVString CTDVString::TruncateRight(int nCount) const
{
	// Use helper function
	CTDVString Result;

	if (nCount < m_StringLength)
	{
		Result.CopyChars(m_pData, 0, m_StringLength-nCount);
	}
	else
	{
		Result.Empty();
	}

	return Result;
}


/*********************************************************************************
	long CTDVString::Replace(const TDVCHAR *pSearch, const TDVCHAR *pReplace, int nStartPos=0, int nEndPos=-1)

	Author:		Jim Lynn (Markn added sub-section replacement)
	Inputs:		pSearch - string to search for
				pReplace - string to replace with
				nStartPos = the start of the replace section of this string (0 == beginning)
				nEndPos = the send of the replace section (-1 = replace to the end)
	Returns:	number of replacements
	Purpose:	To replace instances of pSearch within this string with pReplace

				If nStartPos and nEndPos contain default values, the replace happens to the whole string.
				otherwise:
				nStartPos is the index of the start of the section considered for replacement
				nEndPos is the index of the end of the section considered for replacement
  
**********************************************************************************/

long CTDVString::Replace(const TDVCHAR *pSearch, const TDVCHAR *pReplace, int nStartPos, int nEndPos)
{
	if (m_pData == NULL)
	{
		return 0;
	}
	
	TDVCHAR *pData = m_pData;
	CTDVString sLeft, sRight;
	bool bReplaceSubSection = false;
	if (nStartPos > 0 || nEndPos > 0)
	{
		// If perfoming the replacement within a sub-section of the original string...

		// If nEndPos == -1, caller wants to replace up to the end of the string
		if (nEndPos == -1)
		{
			nEndPos = m_StringLength;
		}

		// Check for stupid inputs...
		if (nEndPos <= nStartPos)
		{
			TDVASSERT(false,"CTDVString::Replace() called where EndPos <= EndPos");
			return 0;
		}

		// Check for stupid inputs...
		if (nStartPos > m_StringLength || nEndPos > m_StringLength)
		{
			TDVASSERT(false,"CTDVString::Replace() called where StartPos > strlen or EndPos > strlen");
			return 0;
		}

		// Remember the bits of the original not taking part in the replace 
		sLeft = Left(nStartPos);
		sRight = Right(m_StringLength - nEndPos);

		// point to the start of the replace section and terminate the string at the end of the section
		// (m_pData is deleted eventually so it's safe to write directly to the buffer)
		pData[nEndPos] = 0;
		pData += nStartPos;
		m_StringLength = nEndPos - nStartPos;
		bReplaceSubSection = true;
	}

	// in order to cope with the replace string containing the search string
	// we build up the replaced string section by section, and chop off
	// the string we're searching accordingly
	CTDVString replace = "";
	CTDVString search = *this;
	long searchlen = strlen(pSearch);
	long replacelen = strlen(pReplace);
	long NumReplacements = 0;
	
	// First count the number of replacements to be made
	TDVCHAR* pScan = pData;
	while ((pScan = strstr(pScan, pSearch)) != NULL)
	{
		NumReplacements++;
		pScan += searchlen;
	}
	// Got number of bits to replace
	// Get the expected length of the new string
	UINT lNewLength = m_StringLength + ((replacelen - searchlen) * NumReplacements);

	// Now we should allocate a buffer for this replaced string 

	const UINT nReplacedStringBufferLength = lNewLength + m_BufferPad;
	TDVCHAR* pReplacedString = AllocTDVCHAR(nReplacedStringBufferLength);
	pReplacedString[0] = 0;
	
	// Get a pointer to the end of the replaced string (for concatenating)
	TDVCHAR* pReplPtr = pReplacedString;

	// Get pointer to start of string
	TDVCHAR* pSubStart = pData;

	while ((pScan = strstr(pSubStart, pSearch)) != NULL)
	{
		// Found a search result
		// So we have to copy everything between pSubStart and pScan to the replaced string
		// Then the Replace string
		// Then point pSubStart past the search string

		if (pScan > pSubStart)
		{
			strncpy(pReplPtr, pSubStart, pScan - pSubStart);
			pReplPtr += pScan - pSubStart;
		}
		strcpy(pReplPtr, pReplace);
		pReplPtr += replacelen;
		pSubStart = pScan + searchlen;
	}

	// Now just copy the remainder from pSubStart
	strcpy(pReplPtr, pSubStart);

	if (bReplaceSubSection)
	{
		// if replacing only a sub-section, construct the final string using the left and right parts
		// of the original no in the replace sub-section
		int nTotalLen = sLeft.GetLength() + sRight.GetLength() + lNewLength;
		EnsureBufferLength(nTotalLen + 1, false);
		strcpy(m_pData,sLeft);
		strcat(m_pData,pReplacedString);
		strcat(m_pData,sRight);
		DeleteTDVCHAR(pReplacedString);
		m_StringLength = nTotalLen;
	}
	else
	{
		ReplaceBuffer(pReplacedString, nReplacedStringBufferLength,lNewLength);
	}

	return NumReplacements;
}

/*********************************************************************************
	long CTDVString::FindContaining(TDVCHAR *pCharSet, long Pos)

	Author:		Jim Lynn
	Inputs:		pCharSet - set of characters to compare
				Pos (optional) position in string to start
	Outputs:	-
	Returns:	Position of first character not found in the search set

  Allows you to search for (for example) a set of digits. Will return the first
  character position which isn't in the search set

**********************************************************************************/

long CTDVString::FindContaining(TDVCHAR *pCharSet, long Pos)
{
	if (Pos >= m_StringLength)
	{
		return -1;
	}
	
	// Get the pointer to the first character to search from
	TDVCHAR* sPtr = m_pData + Pos;
	// Find the index from sPtr of the first character not in the char set
	long FirstNonChar = strspn(sPtr, pCharSet);
	if (FirstNonChar + Pos >= m_StringLength)
	{
		return -1;
	}
	return (FirstNonChar + Pos);
}

/*********************************************************************************

	CTDVString& CTDVString::operator <<(int iValue)

	Author:		Kim Harries
	Inputs:		iValue
	Outputs:	-
	Returns:	reference to this string
	Scope:		public
	Purpose:	override of the << operator to append the string representation
				if an int to the end of the string.

*********************************************************************************/

CTDVString& CTDVString::operator <<(int iValue)
{
	*this += CTDVString(iValue);
	return *this;
}

/*********************************************************************************
	CTDVString& CTDVString::operator <<(long lValue)

	Author:		Jim Lynn
	Inputs:		lValue
	Outputs:	-
	Returns:	reference to this string
	Scope:		public
	Purpose:	override of the << operator to append the string representation
				if a long to the end of the string.

*********************************************************************************/

CTDVString& CTDVString::operator <<(long lValue)
{
	*this += CTDVString(lValue);
	return *this;
}

/*********************************************************************************

	CTDVString& CTDVString::operator <<(float fValue)

	Author:		Kim Harries
	Inputs:		fValue
	Outputs:	-
	Returns:	reference to this string
	Scope:		public
	Purpose:	override of the << operator to append the string representation
				if a float to the end of the string.

*********************************************************************************/

CTDVString& CTDVString::operator <<(float fValue)
{
	*this += CTDVString(fValue);
	return *this;
}

/*********************************************************************************

	CTDVString& CTDVString::operator <<(double dValue)

	Author:		Kim Harries
	Inputs:		dValue
	Outputs:	-
	Returns:	reference to this string
	Scope:		public
	Purpose:	override of the << operator to append the string representation
				if a double to the end of the string.

*********************************************************************************/

CTDVString& CTDVString::operator <<(double dValue)
{
	*this += CTDVString(dValue);
	return *this;
}

/*********************************************************************************
	CTDVString& CTDVString::operator <<(const CTDVString& sValue)

	Author:		Jim Lynn
	Inputs:		reference to another string
	Outputs:	-
	Returns:	reference to this string
	Scope:		public
	Purpose:	appends the string to this one. Makes it easy to append lots of
				strings and numbers together.

*********************************************************************************/

CTDVString& CTDVString::operator <<(const CTDVString& sValue)
{
	*this += sValue;
	return *this;
}

/*********************************************************************************
	CTDVString& CTDVString::operator <<(const TDVCHAR* pString)
	
	Author:		Jim Lynn
	Inputs:		pString - string to append
	Outputs:	-
	Returns:	reference to this string
	Scope:		public
	Purpose:	appends a string to this string.

*********************************************************************************/

CTDVString& CTDVString::operator <<(const TDVCHAR* pString)
{
	*this += pString;
	return *this;
}


/*********************************************************************************

	void CTDVString::RemoveLeftChars(int iNumChars)

	Author:		Jim Lynn
	Created:	03/04/2000
	Inputs:		iNumChars - number of chars to remove from left hand side of string
	Outputs:	-
	Returns:	-
	Purpose:	Truncates the string from the left hand side, removing the given
				number of characters.

*********************************************************************************/

void CTDVString::RemoveLeftChars(int iNumChars)
{
	if (iNumChars <= 0)
	{
		TDVASSERT(iNumChars == 0, "RemoveLeftChars called with negative number");
		return;
	}

	if (iNumChars >= m_StringLength)
	{
		// Just remove the whole string
		Empty();
		return;
	}

	// We've just got to to a strcpy down the string

	//strcpy(m_pData, m_pData + iNumChars);
	memmove(m_pData, m_pData + iNumChars, m_StringLength - iNumChars + 1);
	m_StringLength -= iNumChars;
}

/******************************************************************************

	int CTDVParseString::Find(TDVCHAR Ch) const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Find the first occurence of the character within the string.
	Inputs:		Ch - the character to look for.
	Returns:	0 or greater => index of the character
				negative => character not found

******************************************************************************/

int CTDVParseString::Find(TDVCHAR Ch) const
{
	if ((m_pData != NULL) && (m_StringLength > 0))
	{
		// Look for first occurence of character.
		for (int i = 0; i < m_StringLength; i++)
		{
			if (m_pStringStart[i] == Ch)
			{
				// Found it!
				return i;
			}
		}
	}

	// Not found
	return -1;
}




/*********************************************************************************
	long CTDVParseString::FindContaining(TDVCHAR *pCharSet, long Pos)

	Author:		Jim Lynn
	Inputs:		pCharSet - set of characters to compare
				Pos (optional) position in string to start
	Outputs:	-
	Returns:	Position of first character not found in the search set

  Allows you to search for (for example) a set of digits. Will return the first
  character position which isn't in the search set

**********************************************************************************/

long CTDVParseString::FindContaining(TDVCHAR *pCharSet, long Pos)
{
	if (Pos >= m_StringLength)
	{
		return -1;
	}
	
	// Get the pointer to the first character to search from
	TDVCHAR* sPtr = m_pStringStart + Pos;
	// Find the index from sPtr of the first character not in the char set
	long FirstNonChar = strspn(sPtr, pCharSet);
	if (FirstNonChar + Pos >= m_StringLength)
	{
		return -1;
	}
	return (FirstNonChar + Pos);
}

/******************************************************************************

	CTDVString CTDVParseString::Left(int nCount) const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Return a substring of the first n characters of the string.
	Inputs:		nCount - the number of characters to copy.
	Returns:	The substring specified

******************************************************************************/

CTDVString CTDVParseString::Left(int nCount) const
{
	// Use helper function
	CTDVString Result;
	Result.CopyChars(m_pStringStart, 0, nCount);
	return Result;
}



/*********************************************************************************

	void CTDVParseString::RemoveLeftChars(int iNumChars)

	Author:		Jim Lynn
	Created:	03/04/2000
	Inputs:		iNumChars - number of chars to remove from left hand side of string
	Outputs:	-
	Returns:	-
	Purpose:	Truncates the string from the left hand side, removing the given
				number of characters.

*********************************************************************************/

void CTDVParseString::RemoveLeftChars(int iNumChars)
{
	if (iNumChars <= 0)
	{
		TDVASSERT(iNumChars == 0, "RemoveLeftChars called with negative number");
		return;
	}

	if (iNumChars >= m_StringLength)
	{
		// Just remove the whole string
		m_pData = NULL;
		m_StringLength = 0;
		m_pStringStart = NULL;
		return;
	}

	// We've just got to to a strcpy down the string

	m_pStringStart += iNumChars;
	m_StringLength -= iNumChars;
}

/******************************************************************************

	CTDVString CTDVParseString::Mid(int nFirst, int nCount) const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Return a string object that contains the substring specified.
	Inputs:		nFirst - the character to start from (0 based)
				nCount - number of characters to get from the string.
	Returns:	The substring specified.

******************************************************************************/

CTDVString CTDVParseString::Mid(int nFirst, int nCount) const
{
	// Use helper function
	CTDVString Result;
	Result.CopyChars(m_pStringStart, nFirst, nCount);
	return Result;
}


/******************************************************************************

	CTDVParseString::operator const char *() const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Cast a string object to a (read-only/const) C-style string.

******************************************************************************/

CTDVParseString::operator const char *() const
{
	// If the string is empty, then use the Empty null terminated string we happen to have
	if (m_pData==NULL)
		return NULL;

	// otherwise we can use the real string
	return (const char *) m_pStringStart;
}


CTDVParseString::CTDVParseString(const TDVCHAR* pData) : m_pData(pData)
{
	m_pStringStart = (char*)m_pData;
	m_StringLength = strlen((char*)m_pData);
}

CTDVParseString::~CTDVParseString()
{
}

/******************************************************************************

	int CTDVParseString::Find(const TDVCHAR *pSubString) const

	Author:		Tim Browse
	Created:	20/3/97
	Purpose:	Find the first occurence of the substring within this string.
	Inputs:		pSubString - the substring to search for.
	Returns:	0 or greater => index of the character
				negative => character not found

******************************************************************************/

int CTDVParseString::Find(const TDVCHAR *pSubString, int StartPos) const
{
	if ((m_pData != NULL) && (m_StringLength > 0) && (StartPos >= 0) && (StartPos < m_StringLength))
	{
		char *Result = strstr(m_pStringStart + StartPos, pSubString);
		if (Result != NULL)
		{
			// Found it!
			return (Result - m_pStringStart);
		}
	}
	
	// Not found
	return -1;
}

void CTDVString::RemoveDodgyChars()
{
	if (m_pData == NULL)
	{
		return;
	}

	for (int i=0;i < m_StringLength; i++)
	{
		if (m_pData[i] >= 0 && m_pData[i] < 32 && m_pData[i] != 10 && m_pData[i] != 13 && m_pData[i] != 9)
		{
			m_pData[i] = ' ';
		}
	}
	return;
}

void CTDVString::MakeFilenameSafe()
{
	if (m_pData == NULL)
	{
		return;
	}
	RemoveDodgyChars();

	TDVCHAR *szIllegalChars = "\\/:*?\"<>|";

	for (int i=0;i < m_StringLength; i++)
	{
		if (m_pData[i] == '\\' || m_pData[i] == '/'  || m_pData[i] == ':' || m_pData[i] == '*' || 
			m_pData[i] == '?' || m_pData[i] == '\"' || m_pData[i] == '<' || m_pData[i] == '>' || 
			m_pData[i] == '|')
		{
			m_pData[i] = '-';
		}
	}
	return;
}

/*********************************************************************************

	int CTDVString::CountWhiteSpaceChars()

	Author:		Mark Neves
	Created:	05/08/2003
	Inputs:		-
	Outputs:	-
	Returns:	Number of whitespace characters in this string
	Purpose:	Counts the number of whitespace characters in the string.
				It uses the lib function isspace(), which defines whitespace chars
				as 0x09-0x0d, and 0x20

*********************************************************************************/

int CTDVString::CountWhiteSpaceChars()
{
	int nCount=0;

	if (m_pData != NULL)
	{
		for (int i=0;i < m_StringLength; i++)
		{
			// Ensure the char is unsigned before passing it to isspace!
			// Use the bottom byte only to remove sign info.
			DWORD dw = DWORD(m_pData[i]);
			if (isspace(dw & 0xFF))
			{
				nCount++;
			}
		}
	}

	return nCount;
}

/*********************************************************************************

	void CTDVString::AppendMid(const CTDVString& sOtherString, int nFirst, int nCount)

	Author:		Jim Lynn
	Created:	13/06/2001
	Inputs:		sOtherString - string from which to get the substring
				nFirst - position of first character to append
				nCount - count of characters to append - if -1 then copy the rest
	Outputs:	-
	Returns:	-
	Purpose:	Appends a substring from one string to this string

*********************************************************************************/

void CTDVString::AppendMid(const CTDVString& sOtherString, int nFirst, int nCount)
{
	if (nCount == 0)
	{
		return;
	}

	int iOtherLength = sOtherString.GetLength();
	const TDVCHAR* pOtherData = (const TDVCHAR*)sOtherString;
	AppendMid(pOtherData, iOtherLength, nFirst, nCount);
	return;
}

void CTDVString::AppendMid(const CTDVParseString& sOtherString, int nFirst, int nCount)
{
	if (nCount == 0)
	{
		return;
	}

	int iOtherLength = sOtherString.GetLength();
	const TDVCHAR* pOtherData = (const TDVCHAR*)sOtherString;
	AppendMid(pOtherData, iOtherLength, nFirst, nCount);
	return;
}

void CTDVString::AppendMid(const TDVCHAR* pOtherData, int iOtherLength, int nFirst, int nCount)
{
	// just return if nFirst is off the end of the string or < 0
	if ((nFirst >= iOtherLength) || (nFirst < 0))
	{
		return;
	}

	if (nCount < 0)
	{
		nCount = iOtherLength - nFirst;
	}

	// if nCount gives more chars than are after the first char, truncate it
	if (((nFirst + nCount) > iOtherLength))
	{
		nCount = iOtherLength - nFirst;
	}

	// Now make sure that this string is long enough
	int nOrigStringLength = m_StringLength;
	int nNewStringLength = nOrigStringLength + nCount;
	EnsureBufferLength(nNewStringLength+1, true);
	
	// Copy that section of the string into our buffer
	strncpy(m_pData + nOrigStringLength, pOtherData + nFirst, nCount);
	
	m_pData[nNewStringLength] = 0;
	m_StringLength = nNewStringLength;
}

void CTDVString::SetPadSize(int iPadSize)
{
	if (iPadSize < 32)
	{
		return;
	}
	else
	{
		m_BufferPad = iPadSize;
	}
}

/*********************************************************************************

	bool CTDVString::DoesTextContain(const TDVCHAR *psWords, const TDVCHAR *psDelimit,
									 bool bAllowPrefixChars = false, bool bAllowSuffixChars = false,
									 CTDVString* psFirstMatch = NULL)

	Author:		Mark Howitt
	Created:	16/01/2004
	Inputs:		psWords - A string containing a list of delimited words to check for
				psDelimit - The char used to delimit the words in the string.
				bAllowPrefixChars - A flag that states wether or not to allow any ALPHABETICAL char to
					prefix a matching word.
				bAllowSuffixChars - A flag that states wether or not to allow any ALPHABETICAL char to
					suffix a matching word.
	Outputs:	psFirstMatch - A String pointer that if not NULL takes the value for the
				first matching word.
	Returns:	TRUE if a word matched, false if not
	Purpose:	Checks the Current string to see if any occurances of the given
				substrings exist.
				NOTE!!! This function is CASE Sensitive!

*********************************************************************************/

bool CTDVString::DoesTextContain(const TDVCHAR *psWords, const TDVCHAR *psDelimit,
								 bool bAllowPrefixChars, bool bAllowSuffixChars,
								 CTDVString* psFirstMatch)
{
	// Go through the list of words.
	// Make a copy of the words to check against as the strtok function modifies the string
	CTDVString sCheckWords(psWords);
	TDVCHAR* pWord = strtok((TDVCHAR*)((const TDVCHAR*)sCheckWords),psDelimit);

	TDVCHAR* pSearch = NULL;
	TDVCHAR* pCharBefore = NULL;
	TDVCHAR* pCharAfter = NULL;
	bool bMatch = false;
	while (pWord != NULL && !bMatch)
	{
		// Start from the beginning
		pSearch = strstr(m_pData,pWord);
		
		// If we're checking prefixes, do so
		if ((!bAllowPrefixChars || !bAllowSuffixChars) && pSearch != NULL)
		{
			// Keep checking while we have a search pointer
			while (pSearch != NULL && !bMatch)
			{
				// Get the chars before and after the matching word
				pCharBefore = &m_pData[pSearch - m_pData - 1];
				pCharAfter = &m_pData[pSearch - m_pData + strlen(pWord)];

				// Check to see if we've got a leading char when checking for prefix OR/AND
				// trailing chars when checking for suffix.
				if ((!bAllowPrefixChars && (pCharBefore > m_pData) && (isalpha(*pCharBefore) != 0)) ||
					(!bAllowSuffixChars && (isalpha(*pCharAfter) != 0)))
				{
					// We found chars! Find the next match
					pSearch = strstr(&m_pData[pSearch - m_pData + 1],pWord);
				}
				else
				{
					// We have a non alphabetical char in front! We've found a match.
					bMatch = true;
				}
			}
		}
		else
		{
			// Have we found a match?
			if (pSearch != NULL)
			{
				bMatch = true;
			}
		}

		// If still don't have a match, get the next word to search for.
		if (!bMatch)
		{
			pWord = strtok(NULL,psDelimit);
		}
	}

	// If we've found a match and we have a valid FirstMatch pointer, fill it in.
	if (bMatch && psFirstMatch != NULL)
	{
		*psFirstMatch = pWord;
	}

	// Return the verdict!
	return bMatch;
}

/*********************************************************************************

	CTDVString CTDVString::WriteToTempFile()

		Author:		Mark Neves
        Created:	20/04/2004
        Inputs:		-
        Outputs:	-
        Returns:	The full name of the temp file this string was written to,
					or an empty string if something when wrong
        Purpose:	Writes the string to a temp file using Win API calls

*********************************************************************************/

CTDVString CTDVString::WriteToTempFile() const
{
	char pathBuffer[MAX_PATH+1], filenameBuffer[MAX_PATH+1];
	DWORD dw = ::GetTempPath(MAX_PATH,pathBuffer);
	if (dw != 0)
	{
		dw = ::GetTempFileName(pathBuffer,"_xs",0,filenameBuffer);
	}

	CTDVString sTempFile;
	if (dw != 0)
	{
		sTempFile = filenameBuffer;
		if (!WriteToFile(sTempFile))
		{
			// Something went wrong, so empty the string
			sTempFile.Empty();
		}
	}

	return sTempFile;
}

/*********************************************************************************

	bool CTDVString::WriteToFile(const TDVCHAR* pFullFileName)

		Author:		Mark Neves
        Created:	08/04/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CTDVString::WriteToFile(const TDVCHAR* pFullFileName) const
{
	BOOL bOK = FALSE;
	HANDLE hFile = CreateFile(pFullFileName, GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hFile != INVALID_HANDLE_VALUE)
	{
		DWORD nNumWritten=0;
		bOK = WriteFile(hFile, m_pData, GetLength(),&nNumWritten, NULL);
		CloseHandle(hFile);
	}

	return (bOK != FALSE);
}

TDVCHAR* CTDVString::AllocTDVCHAR(UINT nSize)
{
	CTDVSTRING_STATS_INCNUMNEWS();
	return (TDVCHAR*)new TDVCHAR[nSize];
}

void CTDVString::DeleteTDVCHAR(TDVCHAR* ptr)
{
	CTDVSTRING_STATS_INCNUMDELETES();
	delete [] ptr;
}

void CTDVString::ReplaceBuffer(TDVCHAR* pNewBuffer, UINT nBufferLength, UINT nLen)
{
	DeleteBuffer();

	if (pNewBuffer != NULL)
	{
		if (nLen >= nBufferLength)
			nLen = nBufferLength-1;

		m_BufferLength = nBufferLength;
		m_pBuffer = pNewBuffer;
		m_pData   = pNewBuffer;
		m_pData[nLen] = 0;
		m_StringLength = nLen;
	}
}

void CTDVString::DeleteBuffer()
{
	if (m_pBuffer != NULL)
	{
		DeleteTDVCHAR(m_pBuffer);
		m_pBuffer = NULL;
	}

	m_pData = m_FixedBuffer;
	m_BufferLength = CTDVSTRING_FIXED_BUFFER_LENGTH;
	Empty();
}


#ifdef CTDVSTRING_INCLUDE_STATS
DWORD nStart = 0, nEnd = 0;
void CTDVString::ResetStats()
{
	m_nNumNews = 0;
	m_nNumDeletes = 0;
	m_nNumConstructs = 0;
	m_nNumDestructs = 0;
	m_nSumSize = 0;
	m_nNumNULLs = 0;
	m_nNum0 = 0;
	m_nNumLower32 = 0;
	m_nNumLower64 = 0;
	m_nNumLower128 = 0;
	m_nNumHigher128 = 0;
	nStart = GetTickCount();
}

void CTDVString::DumpStats()
{
	int nNumNews		= CTDVSTRING_STATS_GETNUMNEWS();
	int nNumDeletes		= CTDVSTRING_STATS_GETNUMDELETES();
	int nNumConstructs	= CTDVSTRING_STATS_GETNUMCONSTRUCTS();
	int nNumDestructs	= CTDVSTRING_STATS_GETNUMDESTRUCTS();
	int nSumSize		= CTDVSTRING_STATS_GETSUMSIZE();
	int nNumNULLs		= CTDVSTRING_STATS_GETNUMNULLS();
	int nNum0			= CTDVSTRING_STATS_GETNUM0();
	int nNumLower32		= CTDVSTRING_STATS_GETNUMLOWER32();
	int nNumLower64		= CTDVSTRING_STATS_GETNUMLOWER64();
	int nNumLower128	= CTDVSTRING_STATS_GETNUMLOWER128();
	int nNumHigher128	= CTDVSTRING_STATS_GETNUMHIGHER128();

	CTDVString msg;
	msg << "Num news:       " << nNumNews << "\n";
	msg << "Num deletes:    " << nNumDeletes << "\n";
	msg << "Num constructs: " << nNumConstructs << "\n";
	msg << "Num destructs:  " << nNumDestructs << "\n";
	msg << "Ave. size:      " << (nNumNews ? nSumSize/nNumNews : 0) << "\n";
	msg << "NULLs:          " << nNumNULLs << "\n";
	msg << "Zero:           " << nNum0 << "\n";
	msg << "Lower 32:       " << nNumLower32 << "\n";
	msg << "Lower 64:       " << nNumLower64 << "\n";
	msg << "Lower 128:      " << nNumLower128 << "\n";
	msg << "Higher 128:     " << nNumHigher128 << "\n";
	msg << "\n";

	nEnd = GetTickCount();
	msg << "Time : " << (int)(nEnd-nStart) << "\n";

	TRACE(msg);
}

int CTDVString::m_nNumNews = 0;
int CTDVString::m_nNumDeletes = 0;
int CTDVString::m_nNumConstructs = 0;
int CTDVString::m_nNumDestructs = 0;
int CTDVString::m_nSumSize = 0;
int CTDVString::m_nNumNULLs = 0;
int CTDVString::m_nNum0 = 0;
int CTDVString::m_nNumLower32 = 0;
int CTDVString::m_nNumLower64 = 0;
int CTDVString::m_nNumLower128 = 0;
int CTDVString::m_nNumHigher128 = 0;

#endif // CTDVSTRING_INCLUDE_STATS
