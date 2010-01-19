//
// TDVString.h
//

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#if !defined(AFX_TDVSTRING_H__42263227_03C5_11D3_86FB_00A0C941F4C7__INCLUDED_)
#define AFX_TDVSTRING_H__42263227_03C5_11D3_86FB_00A0C941F4C7__INCLUDED_

//
// This character typedef defines the basic character used for this string class.
// All characters are referred to as 'TDVCHAR' type by this class.
//

#ifdef _MAC
//
// For MacOS we use char
//
typedef char TDVCHAR;
#else
// For Windows use, we map it to TCHAR.
//
typedef TCHAR TDVCHAR;
#endif

//
// This header file assumes the following standard things are defined:
//
// BOOL, TRUE, FALSE
//

#ifndef __NO_RECT_STRINGS

// We can now convert CTDVRects to strings.

class CTDVRect;
class CTDVParseString;

#endif

#ifdef _MAC
// For CPascalString=>TDVString conversion
#include "PascalString.h"
#endif

const int CTDVSTRING_FIXED_BUFFER_LENGTH = 64;

#ifdef _DEBUG
#define CTDVSTRING_INCLUDE_STATS
#endif // _DEBUG

/*

	class CTDVString

	Author:		Tim Browse
	Created:	19/3/97
	Purpose:	Implement a platform-independent string class.

*/

#define CLASSEXPORT

class CLASSEXPORT CTDVString
{
 friend class CTDVParseString;
	 // See towards the end of the class declaration for functions specific
	// to certain platform/OS types (e.g. Windows LPCSTR and CString types)

public:
	// Constructors
	CTDVString();
	CTDVString(const CTDVString& Src);
	CTDVString(const TDVCHAR* pString);
	CTDVString(TDVCHAR Ch, int nRepeat = 1);
	CTDVString(int nNumber);
	CTDVString(long lNumber);
	CTDVString(float fNumber);
	CTDVString(double dNumber);
	CTDVString(DWORD dNumber);

#ifndef __NO_RECT_STRINGS
	CTDVString(CTDVRect& Rect);
#endif

	// Destructor
	virtual ~CTDVString();

public:
	void SetPadSize(int iPadSize);
	void AppendMid(const CTDVParseString& sOtherString, int nFirst, int nCount = -1);
	void AppendMid(const CTDVString& sOtherString, int nFirst, int nCount = -1);
	void AppendMid(const TDVCHAR* pOtherData, int iOtherLength, int nFirst, int nCount);
	int GetLength() const;
	bool IsEmpty() const;
	void Empty();                       // free up the data

	void EnsureAvailable(int nBytes);
	void UpdateLength();

	TDVCHAR GetAt(int nIndex) const;      // 0 based
	TDVCHAR operator[](int nIndex) const; // same as GetAt
	void SetAt(int nIndex, TDVCHAR ch);

	// overloaded assignment
	const CTDVString& operator=(const CTDVString& Src);
	const CTDVString& operator=(TDVCHAR Ch);
	const CTDVString& operator=(TDVCHAR *pString);
	const CTDVString& operator=(const TDVCHAR* pString);

	int operator==(const TDVCHAR *pString);
	int operator!=(const CTDVString& Other);
	int operator!=(const TDVCHAR *pString);

	bool operator <(const CTDVString &Other) const;
	bool operator >(const CTDVString &Other) const;
	bool CompareText(const CTDVString &Other) const;
	bool CompareText(const TDVCHAR *pOther) const;

	// string concatenation
	const CTDVString& operator+=(const CTDVString& String);
	const CTDVString& operator+=(const TDVCHAR *pString);
	const CTDVString& operator+=(TDVCHAR ch);

	friend CTDVString operator+(const CTDVString& String1, const CTDVString& String2);
	friend CTDVString operator+(const CTDVString& String, TDVCHAR Ch);
	friend CTDVString operator+(TDVCHAR Ch, const CTDVString& String);
	friend CTDVString operator+(const CTDVString& String, const TDVCHAR *pString);
	friend CTDVString operator+(const TDVCHAR *pString, const CTDVString& String);

	CTDVString& operator<<(const CTDVString& String1);
	CTDVString& operator<<(int iValue);
	CTDVString& operator<<(long lValue);
	CTDVString& operator<<(float fValue);
	CTDVString& operator<<(double dValue);
	CTDVString& operator<<(const TDVCHAR* pString);
	
	void AppendChars(const TDVCHAR *pSrc, int nCharsToCopy);

	// string insertion
	void Prefix(const TDVCHAR *pSrc);

	// string removal
	void RemoveTrailingChar(TDVCHAR Ch);

	// simple sub-string extraction
	CTDVString Mid(int nFirst, int nCount) const;
	CTDVString Mid(int nFirst) const;
	CTDVString Left(int nCount) const;
	CTDVString Right(int nCount) const;
	CTDVString TruncateRight(int nCount) const;

	// upper/lower/reverse conversion
	void MakeUpper();		// Change string to uppercase
	void MakeLower();		// Change string to lowercase
	void MakeReverse();		// Reverse characters in string

	// searching (return starting index, or -1 if not found)
	// look for a single character match
	int Find(TDVCHAR Ch) const;               // like "C" strchr
	int ReverseFind(TDVCHAR Ch) const;

	// look for a specific sub-string
	int Find(const TDVCHAR *pSubString, int StartPos = 0) const;        // like "C" strstr

	// look for a specific sub-string - case insensitive
	int FindText(const TDVCHAR *pSubString, int StartPos = 0) const;        // like "C" strstr

	// look for the last occurrence of the given string - case insensitive
	int FindTextLast(const TDVCHAR *pSubString, int nStartPos = 0) const;

public:
	bool DoesTextContain(const TDVCHAR* psWords, const TDVCHAR* psDelimit,
						bool bAllowPrefixChars = false, bool bAllowSuffixChars = false,
						CTDVString* psFirstMatch = NULL);

	void RemoveDodgyChars();
	void RemoveLeftChars(int iNumChars);
	long FindContaining(TDVCHAR* pCharSet, long Pos = 0);
	long Replace(const TDVCHAR* pSearch, const TDVCHAR* pReplace, int nStartPos=0, int nEndPos=-1);
	int	 CountWhiteSpaceChars();
	CTDVString WriteToTempFile() const;
	bool WriteToFile(const TDVCHAR* pFullFileName) const;
	
	void MakeFilenameSafe();

	// Cast operators...
	operator const char *() const;

	// Do CString interfaces if CString has been defined (i.e. MFC is in use)
#ifdef __AFX_H__
	CTDVString(const CString& stringSrc);
	operator CString() const;
	operator CString();
#endif

#ifdef _MAC
	CTDVString(const CPascalString& stringSrc);
#endif

protected:
	// Helper functions
	void Copy(const TDVCHAR *);
	void CopyChars(const TDVCHAR *pSrc, int nFirst, int nCharsToCopy);
	void Concat(const TDVCHAR *);

	TDVCHAR* AllocTDVCHAR(UINT nSize);
	void DeleteTDVCHAR(TDVCHAR* ptr);
	void DeleteBuffer();
	void ReplaceBuffer(TDVCHAR* pNewBuffer, UINT nBufferLength, UINT nLen);
	void EnsureBufferLength(int nLen, bool bPreserveString, int nPrefix = 0);

protected:
	TDVCHAR *m_pData;
	int   m_BufferLength;
	int   m_StringLength;
	static const char* m_EmptyString;
	int	m_BufferPad;

	TDVCHAR  m_FixedBuffer[CTDVSTRING_FIXED_BUFFER_LENGTH];
	TDVCHAR* m_pBuffer;

#ifdef CTDVSTRING_INCLUDE_STATS
private:
	static int m_nNumNews;
	static int m_nNumDeletes;
	static int m_nNumConstructs;
	static int m_nNumDestructs;
	static int m_nSumSize;
	static int m_nNumNULLs;
	static int m_nNum0;
	static int m_nNumLower32;
	static int m_nNumLower64;
	static int m_nNumLower128;
	static int m_nNumHigher128;

	static void IncNumNews()		{ m_nNumNews++; }
	static void IncNumDeletes()		{ m_nNumDeletes++; }
	static void IncNumConstructs()	{ m_nNumConstructs++; }
	static void IncNumDestructs()	{ m_nNumDestructs++; }
	static void IncSumSize(int n)	{ m_nSumSize+=n; }
	static void IncNumNULLs()		{ m_nNumNULLs++; }
	static void IncNum0()			{ m_nNum0++; }
	static void IncNumLower32()		{ m_nNumLower32++; }
	static void IncNumLower64()		{ m_nNumLower64++; }
	static void IncNumLower128()	{ m_nNumLower128++; }
	static void IncNumHigher128()	{ m_nNumHigher128++; }

public:
	static int GetNumNews()			{ return m_nNumNews; }
	static int GetNumDeletes()		{ return m_nNumDeletes; }
	static int GetNumConstructs()	{ return m_nNumConstructs; }
	static int GetNumDestructs()	{ return m_nNumDestructs; }
	static int GetSumSize()			{ return m_nSumSize; }
	static int GetNumNULLs()		{ return m_nNumNULLs; }
	static int GetNum0()			{ return m_nNum0; }
	static int GetNumLower32()		{ return m_nNumLower32; }
	static int GetNumLower64()		{ return m_nNumLower64; }
	static int GetNumLower128()		{ return m_nNumLower128; }
	static int GetNumHigher128()	{ return m_nNumHigher128; }
	static void ResetStats();
	static void DumpStats();
#endif // CTDVSTRING_INCLUDE_STATS
};

// A lightweight string which contains a const string buffer
// which can only be truncated from the left and never changed

class CTDVParseString
{
public:
	CTDVParseString(const TDVCHAR* pData);
	virtual ~CTDVParseString();

	CTDVString Left(int nCount) const;
	void RemoveLeftChars(int iNumber);
	int Find(TDVCHAR Ch) const;               // like "C" strchr
	int Find(const TDVCHAR *pSubString, int StartPos = 0) const;        // like "C" strstr

	CTDVString Mid(int nFirst, int nCount) const;
	long FindContaining(TDVCHAR* pCharSet, long Pos = 0);
	operator const char *() const;
	
	int GetLength() const
	{
		return m_StringLength;
	}
	TDVCHAR GetAt(int nIndex) const     // 0 based
	{
		return m_pStringStart[nIndex];
	}

protected:
	const TDVCHAR* m_pData;
	int m_StringLength;
	TDVCHAR* m_pStringStart;
};

#ifdef CTDVSTRING_INCLUDE_STATS
#define CTDVSTRING_STATS_INCNUMNEWS()		CTDVString::IncNumNews()
#define CTDVSTRING_STATS_INCNUMDELETES()	CTDVString::IncNumDeletes()
#define CTDVSTRING_STATS_INCNUMCONSTRUCTS()	CTDVString::IncNumConstructs()
#define CTDVSTRING_STATS_INCNUMDESTRUCTS()	CTDVString::IncNumDestructs()
#define CTDVSTRING_STATS_INCSUMSIZE(n)		CTDVString::IncSumSize(n)
#define CTDVSTRING_STATS_INCNUMNULLS()		CTDVString::IncNumNULLs()
#define CTDVSTRING_STATS_INCNUM0()			CTDVString::IncNum0()
#define CTDVSTRING_STATS_INCNUMLOWER32()	CTDVString::IncNumLower32()
#define CTDVSTRING_STATS_INCNUMLOWER64()	CTDVString::IncNumLower64()
#define CTDVSTRING_STATS_INCNUMLOWER128()	CTDVString::IncNumLower128()
#define CTDVSTRING_STATS_INCNUMHIGHER128()	CTDVString::IncNumHigher128()

#define CTDVSTRING_STATS_GETNUMNEWS()		CTDVString::GetNumNews()
#define CTDVSTRING_STATS_GETNUMDELETES()	CTDVString::GetNumDeletes()
#define CTDVSTRING_STATS_GETNUMCONSTRUCTS()	CTDVString::GetNumConstructs()
#define CTDVSTRING_STATS_GETNUMDESTRUCTS()	CTDVString::GetNumDestructs()
#define CTDVSTRING_STATS_GETSUMSIZE()		CTDVString::GetSumSize()
#define CTDVSTRING_STATS_GETNUMNULLS()		CTDVString::GetNumNULLs()
#define CTDVSTRING_STATS_GETNUM0()			CTDVString::GetNum0()
#define CTDVSTRING_STATS_GETNUMLOWER32()	CTDVString::GetNumLower32()
#define CTDVSTRING_STATS_GETNUMLOWER64()	CTDVString::GetNumLower64()
#define CTDVSTRING_STATS_GETNUMLOWER128()	CTDVString::GetNumLower128()
#define CTDVSTRING_STATS_GETNUMHIGHER128()	CTDVString::GetNumHigher128()

#define CTDVSTRING_STATS_RESET()			CTDVString::ResetStats()
#define CTDVSTRING_STATS_DUMP()				CTDVString::DumpStats()

#else
#define CTDVSTRING_STATS_INCNUMNEWS()
#define CTDVSTRING_STATS_INCNUMDELETES()
#define CTDVSTRING_STATS_INCNUMCONSTRUCTS()
#define CTDVSTRING_STATS_INCNUMDESTRUCTS()
#define CTDVSTRING_STATS_INCSUMSIZE(n)
#define CTDVSTRING_STATS_INCNUMNULLS()
#define CTDVSTRING_STATS_INCNUM0()
#define CTDVSTRING_STATS_INCNUMLOWER32()
#define CTDVSTRING_STATS_INCNUMLOWER64()
#define CTDVSTRING_STATS_INCNUMLOWER128()
#define CTDVSTRING_STATS_INCNUMHIGHER128()

#define CTDVSTRING_STATS_GETNUMNEWS()		0
#define CTDVSTRING_STATS_GETNUMDELETES()	0
#define CTDVSTRING_STATS_GETNUMCONSTRUCTS() 0
#define CTDVSTRING_STATS_GETNUMDESTRUCTS()	0
#define CTDVSTRING_STATS_GETSUMSIZE()		0
#define CTDVSTRING_STATS_GETNUMNULLS()		0
#define CTDVSTRING_STATS_GETNUM0()			0
#define CTDVSTRING_STATS_GETNUMLOWER32()	0
#define CTDVSTRING_STATS_GETNUMLOWER64()	0
#define CTDVSTRING_STATS_GETNUMLOWER128()	0
#define CTDVSTRING_STATS_GETNUMHIGHER128()	0

#define CTDVSTRING_STATS_RESET()
#define CTDVSTRING_STATS_DUMP()
#endif // CTDVSTRING_INCLUDE_STATS

#endif // !defined(AFX_TDVSTRING_H__42263227_03C5_11D3_86FB_00A0C941F4C7__INCLUDED_)

