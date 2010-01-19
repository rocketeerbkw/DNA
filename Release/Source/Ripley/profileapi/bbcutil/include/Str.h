//
// CStr.h
//

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#if !defined(AFX_CStr_H__42263227_03C5_11D3_86FB_00A0C941F4C7__INCLUDED_)
#define AFX_CStr_H__42263227_03C5_11D3_86FB_00A0C941F4C7__INCLUDED_

#include "Dll.h"

//
// This header file assumes the following standard things are defined:
//
// BOOL, TRUE, FALSE
//


/*

	class CStr

	Author:		Tim Browse
	Created:	19/3/97
	Purpose:	Implement a platform-independent string class.

*/


class DllExport CStr
{
 friend class CParseString;
	 // See towards the end of the class declaration for functions specific
	// to certain platform/OS types (e.g. Windows LPCSTR and CString types)

	 public:
		// Initialization
		CStr();
		CStr(char Ch, unsigned int nRepeat = 1);
		CStr(const CStr& Src);
		CStr(const char* pString);
		CStr(int nNumber);
		CStr(unsigned int nNumber);
		CStr(double dNumber);
		CStr(long lNumber);
		CStr(unsigned long ulNumber);
		CStr(float fNumber);
		virtual ~CStr();
		
		void SetStr(const char* pString);
		
		int GetLength() const;
		bool IsEmpty() const;
		void Empty();                       // free up the data
		
		const CStr& operator=(const char* pString);
		const CStr& operator=(const CStr& Src);
		const CStr& operator=(char *pString);
	
		CStr& operator<<(int iValue);
		CStr& operator<<(const char* pString);
		CStr& operator<<(unsigned int iValue);
		CStr& operator<<(double dValue);
		CStr& operator<<(const CStr& String1);
		CStr& operator<<(long lValue);
		CStr& operator<<(unsigned long ulValue);
		CStr& operator<<(float fValue);
		
		char GetAt(unsigned int nIndex) const; // same as GetAt
	
		int operator==(const char *pString);
	
		const CStr& operator+=(const char *pString);
		const CStr& operator+=(const CStr& String);
	
		long Replace(const char* pSearch, const char* pReplace);
	
		// Cast operators...
		operator const char *() const;
		const char* GetStr() const;
		
		bool CompareText(const char *pOther) const;
		
		void CopyChars(const char *pSrc, unsigned int nFirst, unsigned int nCharsToCopy);
		
		bool operator <(const CStr &Other) const;
		

		friend CStr operator+(const CStr& String, const char *pString);
		friend CStr operator+(const char *pString, const CStr& String);
		friend CStr operator+(const CStr& String1, const CStr& String2);

		void EnsureAvailable(unsigned int nBytes);
		
		// simple sub-string extraction
		CStr Mid(unsigned int nFirst, unsigned int nCount) const;

		void SetAt(unsigned int nIndex, char ch);
								
		void MakeUpper();		// Change string to uppercase
		void MakeLower();		// Change string to lowercase
	
	
protected:
	// Helper functions
		
	void CopyStr(const char *);
	void Concat(const char *);
	
protected:
	char *m_pData;
	int   m_BufferLength;
	int   m_StringLength;
	static const char* m_EmptyString;
	int	m_BufferPad;
			
};

#endif // !defined(AFX_CStr_H__42263227_03C5_11D3_86FB_00A0C941F4C7__INCLUDED_)
