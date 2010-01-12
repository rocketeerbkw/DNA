/* This source code is part of the Virtual Windows Class Library (VWCL). VWCL is a public C++ class library,
placed in the public domain, and is open source software. VWCL is not governed by any rules other than these:
1) VWCL may be used in commercial and other applications.
2) VWCL may not be distributed, in source code form, in development related projects, unless the developer is also a VWCL contributor.
3) VWCL may be used in development related projects in binary, compiled form, by anyone.
4) VWCL shall remain open source software regardless of distribution method.
5) A proper copyright notice referencing the "VWCL Alliance" must be included in the application and/or documentation.
6) No company or individual can ever claim ownership of VWCL.
7) VWCL source code may be modified or used as a base for another class library.
8) Your use of this software forces your agreement to not hold any member, individual or company, liable for any damages
resulting from the use of the provided source code. You understand the code is provided as-is, with no warranty expressed
or implied by any member of the VWCL Alliance. You use this code at your own risk.

Primary Author of this source code file:  Todd Osborne (todd@vwcl.org)
Other Author(s) of this source code file: 

VWCL and all source code are copyright (c) 1996-1999 by The VWCL Alliance*/

#ifndef VSTRINGHPP
#define VSTRINGHPP

#include "../vstandard.h"

/* VString encapsulates a dynamically allocated C style null-terminated string, and provides many string related
processing functions. In addition, the class is capable of very high speed appending operations and is generally more
efficient and faster at performing routine string operations than conventional C style code. This class can also be used
any time a dynamically allocated chunk of memory is needed, be it a string or not. See the String() function for more information
on this feature. Most functions return a pointer to the internal C style string on success, NULL on failure. On failure to
append or set a string into this class, the previous string is still valid and safe.*/
class VString
{
public:
	/* Construct with existing C style string, or nothing. nMaxChars specifies the maximum number of characters in the
	string to copy from pszString. If 0 is used, the entire string is copied.*/
	VString(VSTRING_CONST pszString = NULL, VUINT nMaxChars = 0)
		{ Init(); String(pszString, 0, nMaxChars); }
	
	// Construct object with existing VString object (copy constructor).
	VString(VString const& str)
		{ Init(&str); }

	#ifndef VWCL_NO_WIN32_API
		// Construct by loading string from resources. If hResource is NULL, VGetResourceHandle() will be used.
		VString(VUINT nStringID, HINSTANCE hResource = NULL)
			{ Init(); Load(nStringID, hResource); }

		// Construct by loading string from a window string. See GetWindowText() for more information.
		VString(HWND hWnd, VUINT nMaxChars = 0)
			{ Init(); GetWindowText(hWnd, nMaxChars); }
	#endif
	
	// Virtual Destructor verifies internal memory is deallocated (as needed).
	virtual ~VString()
		{ Empty(); }

	// Returns non-const C-Style string pointer.
	operator VSTRING () const
		{ return (VSTRING)m_pszString; }

	// Returns const C-Style string pointer.
	operator VSTRING_CONST () const
		{ return (VSTRING_CONST)m_pszString; }

	// Assign an existing VString object (copy the string) to this object.
	VSTRING operator = (VString const& s)
		{ return String(s.String()); }

	// Assign a string pointer to this object. This will copy the string.
	VSTRING operator = (VSTRING_CONST pszString)
		{ return String(pszString); }

	// Assign an integer number to this object.
	VSTRING operator = (VINT nValue)
		{ return String(nValue); }

	// Assign a long number to this object.
	VSTRING operator = (VLONG nValue)
		{ return String(nValue); }

	// Assign an unsigned long number to this object.
	VSTRING operator = (VULONG nValue)
		{ return String(nValue); }

	#ifndef VWCL_NO_WIN32_API
		// Assign a string from resources to this object.
		VSTRING operator < (VUINT nStringID)
			{ return Load(nStringID); }

		// Append a string from resources to this object.
		VSTRING operator <= (VUINT nStringID)
			{ return LoadAppend(nStringID); }

		// Assign a window string to this object.
		VSTRING operator = (HWND hWnd)
			{ return GetWindowText(hWnd); }
	#endif

	// Concatenation of a second string.
	VSTRING operator += (VSTRING_CONST pszString)
		{ return Append(pszString); }
	VSTRING operator << (VSTRING_CONST pszString)
		{ return Append(pszString); }

	// Concatenation of a single character.
	VSTRING operator += (VTCHAR nChar)
		{ return Append(nChar); }
	VSTRING operator << (VTCHAR nChar)
		{ return Append(nChar); }

	// Concatenation of an integer number.
	VSTRING operator += (VINT nValue)
		{ return AppendNumber(nValue); }
	VSTRING operator << (VINT nValue)
		{ return AppendNumber(nValue); }

	// Concatenation of a long number.
	VSTRING operator += (VLONG nValue)
		{ return AppendNumber(nValue); }
	VSTRING operator << (VLONG nValue)
		{ return AppendNumber(nValue); }

	// Concatenation of an unsigned long number.
	VSTRING operator += (VULONG nValue)
		{ return AppendNumber(nValue); }
	VSTRING operator << (VULONG nValue)
		{ return AppendNumber(nValue); }

	#ifndef VWCL_NO_WIN32_API
		// Concatenation of a window string to this object.
		VSTRING operator += (HWND hWnd)
			{ return GetWindowTextAppend(hWnd); }
		VSTRING operator << (HWND hWnd)
			{ return GetWindowTextAppend(hWnd); }
	#endif

	// Comparison (equality) without case sensitivity.
	VBOOL operator == (VSTRING_CONST pszString) const
		{ return (CompareNoCase(pszString) == 0) ? VTRUE : VFALSE; }

	// Comparison (not equal) without case sensitivity.
	VBOOL operator != (VSTRING_CONST pszString) const
		{ return (CompareNoCase(pszString) != 0) ? VTRUE : VFALSE; }
	
	// Increase the error count and return the new error count.
	virtual VUINT	AddError()
		{ return ++m_nErrorCount; }

	/* Append new string segment to existing string. If nMaxChars is 0, entire string is appended, otherwise only
	the first nMaxChars of the string is added. To support client not having to check for NULL strings before calling this
	function, it can deal with a NULL value for pszString. If this is the case, the function is a NOOP, and the error count
	is NOT increased. This is not considered an error. If appending a string of a known length, a small performance boost may
	be seen by specifying the known	string length in the parameter nKnownStringLength. This value does NOT include the NULL
	terminator. It is valid to call this function with pszString set to itself, or within the existing string.*/
	VSTRING			Append(VSTRING_CONST pszString, VUINT nMaxChars = 0, VUINT nKnownStringLength = 0)
	{
		VBOOL bSuccess = VTRUE;
		
		// Anything to do?
		if ( pszString )
		{
			// Check for required duplication.
			VBOOL bDuplicateRequired;
			VString* pOverlap = DuplicateOverlap(pszString, bDuplicateRequired);

			// Return error if we needed a overlap duplication made and couldn't.
			if ( bDuplicateRequired && !pOverlap )
				bSuccess = VFALSE;

			// Still OK?
			if ( bSuccess )
			{
				// Assign overlap to string?
				if ( pOverlap )
					pszString = pOverlap->String();

				// Granularity cannot be 0! Set to default if it is.
				if ( !m_nGranularity )
					m_nGranularity = 64;

				// Determine memory allocation length. pszString cannot be NULL.
				if ( !nKnownStringLength )
					nKnownStringLength = (pOverlap) ? pOverlap->GetLength() : VSTRLEN(pszString);

				// Are we only interested in a certain number of characters? Save that memory.
				if ( nMaxChars && nMaxChars < nKnownStringLength )
					nKnownStringLength = nMaxChars;
				
				// Do we have something to do?
				if ( nKnownStringLength )
				{
					VSTRING pszBuffer = m_pszString;

					// Do we need to allocate more memory blocks?
					if ( !pszBuffer || nKnownStringLength + 1 > m_nAllocLength - m_nLength )
					{
						// Determine number of blocks and total block size to allocate.
						VUINT nBlocks =		((nKnownStringLength + 1) / m_nGranularity) + 1;
						VUINT nNewAlloc =	(nBlocks * m_nGranularity);

						// (Re)Alloc memory now?
						pszBuffer = (VSTRING)realloc(m_pszString, m_nAllocLength + nNewAlloc);
						
						// Did the re-allocation succeed? If not, m_pszString is still valid.
						if ( pszBuffer )
						{
							// Zero the memory we just allocated, but don't overwrite previous!
							VZEROMEMORY(pszBuffer + m_nAllocLength, nNewAlloc);

							// Make assignments and calculations.
							m_pszString =		pszBuffer;
							m_nAllocLength +=	nNewAlloc;
						}
					}

					// Do we (still) have a buffer to write to?
					if ( pszBuffer )
					{
						// Copy string now.
						memcpy(m_pszString + m_nLength, pszString, nKnownStringLength);

						// Increment known length.
						m_nLength += nKnownStringLength;

						// Zero terminate it.
						*(m_pszString + m_nLength) = VTEXT('\0');
					}
					else
					{
						AddError();
						bSuccess = VFALSE;
					}
				}
			}

			VDELETE pOverlap;
		}

		return (bSuccess) ? m_pszString : NULL;
	}

	// Append a single character.
	VSTRING			Append(VTCHAR nChar)
		{ VTCHAR sz[2] = {nChar, VTEXT('\0')}; return Append(sz); }

	// Append a carriage return and line feed to the string.
	VSTRING			AppendCRLF()
		{ return Append(VTEXT("\r\n")); }

	// Append an integer to the string.
	VSTRING			AppendNumber(VINT nValue)
		{ VTCHAR sz[64]; return Append(_itoa(nValue, sz, 10)); }

	// Append a long integer to the string.
	VSTRING			AppendNumber(VLONG nValue)
		{ VTCHAR sz[64]; return Append(_ltoa(nValue, sz, 10)); }

	// Append an unsigned long integer to the string.
	VSTRING			AppendNumber(VULONG nValue)
		{ VTCHAR sz[64]; return Append(_ultoa(nValue, sz, 10)); }

	// Returns a character reference at specified index into the string.
	VTCHAR&			CharAt(VUINT nIndex) const
		{ VASSERT(nIndex < GetLength()) return m_pszString[nIndex]; }

	// Set a character at specified index into the string.
	void			CharAt(VUINT nIndex, VTCHAR nChar)
		{ CharAt(nIndex) = nChar; }

	/* Case sensitive comparison. Returns zero if the strings are identical, -1 if this VString object is less
	than pszString, or 1 if this VString object is greater than pszString. If either string is NULL or empty, 2 will be returned.*/
	VINT			Compare(VSTRING_CONST pszString) const
		{ return (GetLength() && pszString) ? VSTRCMP(m_pszString, pszString) : 2; }

	/* Compare without case sensitibity. Returns zero if the strings are identical (ignoring case), -1 if this
	VString object is less than pszString (ignoring case), or 1 if this VString object is greater than pszString (ignoring case).
	If either string is NULL or empty, 2 will be returned.*/
	VINT			CompareNoCase(VSTRING_CONST pszString) const
		{ return (GetLength() && pszString) ? VSTRCMP_NOCASE(m_pszString, pszString) : 2; }

	/* Free the internal buffer and reset internal variables. If bFreeBuffer is VTRUE, the internal buffer will be free'd,
	otherwise this function will only reset internal members so the previously allocated memory can be re-used. If the internal
	buffer is kept for future use, this class guards against calls that make use of it. In other words, even if the internal
	pointer m_pszString is not NULL, calls to GetLength() or the comparison functions for instance will behave like it is NULL.*/
	VSTRING			Empty(VBOOL bFreeBuffer = VTRUE, VBOOL bResetErrorCount = VTRUE)
	{
		// Free string if allocated (and not stolen).
		if ( m_nLength && bFreeBuffer )
		{
			VASSERT(m_pszString)
			free(m_pszString);
			m_pszString = NULL;
		}
			
		// Reset internal variables.
		m_nLength = 0;
		
		if ( bFreeBuffer )
			m_nAllocLength = 0;

		if ( bResetErrorCount )
			m_nErrorCount =	0;

		return m_pszString;
	}

	// Find first occurence of substring in string. Returns index into string if found, -1 otherwise.
	VINT			Find(VSTRING_CONST pszSubString) const
	{
		VASSERT(pszSubString)

		if ( GetLength() && pszSubString )
		{
			VSTRING pszFound = VSTRSTR(m_pszString, pszSubString);
			
			if ( pszFound )
				return pszFound - m_pszString;
		}

		return -1;
	}

	// Find first occurence of a character in string. Returns index into string if found, -1 otherwise.
	VINT			Find(VTCHAR nChar) const
		{ VTCHAR sz[2] = {nChar, VTEXT('\0')}; return Find(sz); }

	/* Return the internal error count. This value is incremented anytime a memory allocation fails, or externally
	by calls to AddError().*/
	VUINT			GetErrorCount() const
		{ return m_nErrorCount; }

	/* Return a reference to the granularity size. This is how much memory, during appends, is allocated each time an
	append or allocation operation would require more memory than what is currently allocated. Any value, other than 0 is valid
	as the granularity setting. The larger the value, the more memory will be allocated each time a new block is required,
	but fewer allocations are needed. A smaller number decreases total memory usage, at the expense of more frequent
	reallocations. The default value is 64 bytes, and this will be used if set to 0.*/
	VUINT&			GetGranularity() const
		{ return (VUINT&)m_nGranularity; }

	// Get the length of the string, or if bBuffer is VTRUE, the amount of allocated buffer memory.
	VUINT			GetLength(VBOOL bBuffer = VFALSE) const
	{
		// Get buffer length?
		if ( bBuffer )
			return m_nAllocLength;
			
		if ( m_nLength )
		{	
			// If m_nLength is set, this better be valid!
			VASSERT(m_pszString)
			return m_nLength;
		}

		return 0;
	}

	/* Get the path of the module in hInstance into the string. If bPathOnly is specified, only the path, including
	the last slash or backlash will be saved, otherwise the entire path will be. If hInstance is NULL,
	VGetInstanceHandle() will be used. On Non-Win32, this function will load only the path of the calling
	program and an alternate module cannot be specified.*/
	#ifdef VWCL_NO_WIN32_API
		VSTRING		GetModulePath(VBOOL bPathOnly = VTRUE)
			{ return GetModulePathAppend(bPathOnly, VFALSE); }
	#else
		VSTRING		GetModulePath(VBOOL bPathOnly = VTRUE, HINSTANCE hInstance = NULL)
			{ return GetModulePathAppend(bPathOnly, hInstance, VFALSE); }
	#endif

	// Same as GetModulePath(), but appends the loaded string to the existing string, if any.
	#ifdef VWCL_NO_WIN32_API
		VSTRING		GetModulePathAppend(VBOOL bPathOnly = VTRUE, VBOOL bAppend = VTRUE)
	#else
		VSTRING		GetModulePathAppend(VBOOL bPathOnly = VTRUE, HINSTANCE hInstance = NULL, VBOOL bAppend = VTRUE)
	#endif
	{
		VTCHAR sz[1024];

		#ifdef VWCL_NO_WIN32_API
			VSTRCPY(sz, argv[0]);
		#else
			GetModuleFileName((hInstance) ? hInstance : VGetInstanceHandle(), sz, VARRAY_SIZE(sz));
		#endif

		// Terminate after path?
		VTCHAR* pszEnd = (bPathOnly) ? VSTRRCHR(sz, VFILE_PATH_SEP_CHAR) : NULL;

		if  ( pszEnd )
			*(pszEnd + 1) = VTEXT('\0');

		return (bAppend) ? Append(sz) : String(sz);
	}
	
	#ifndef VWCL_NO_WIN32_API
		/* Load the string from the contents of a window. Normally, the entire text of the window is retrieved, but if you
		are only interested in a certain number of bytes, this can be specified in the nMaxChars value. This value specifies
		the number of characters to get, excluding the NULL terminating character. So if you want 2 characters, pass 2 for
		nMaxChars. 3 total bytes will be allocated and 2 characters copied to the buffer.*/
		VSTRING		GetWindowText(HWND hWnd, VUINT nMaxChars = 0)
			{ return GetWindowTextAppend(hWnd, nMaxChars, VFALSE); }

		// Same as GetWindowText(), but appends the window string to the existing string, if any.
		VSTRING		GetWindowTextAppend(HWND hWnd, VUINT nMaxChars = 0, VBOOL bAppend = VTRUE)
		{
			VASSERT(hWnd && IsWindow(hWnd))

			if ( hWnd )
			{
				// Get the length of the window string.
				VUINT nLength = (VUINT)SendMessage(hWnd, WM_GETTEXTLENGTH, 0, 0);
				
				if ( nLength )
				{
					if ( nMaxChars && nMaxChars <= nLength )
						nLength = nMaxChars;
					else
						nLength++;

					VTCHAR sz[1024];
					
					// Get the text.
					if ( SendMessage(hWnd, WM_GETTEXT, (VWPARAM)nLength, (VLPARAM)sz) )
						return (bAppend) ? Append(sz, nMaxChars, nLength) : String(sz, 0, nMaxChars, nLength);
				}
			}

			return NULL;
		}
	#endif

	// Is the string empty?
	VBOOL			IsEmpty() const
		{ return (GetLength()) ? VFALSE : VTRUE; }

	// Is the string not empty?
	VBOOL			IsNotEmpty() const
		{ return (GetLength()) ? VTRUE : VFALSE; }

	/* Substring extraction, returns a new VString object with the first nCount of this strings characters in it. If this string
	is less that nCount in length, the entire string will be returned.*/
	VString			Left(VUINT nCount) const
	{
		VASSERT(nCount)

		VString str;
		
		if ( nCount && GetLength() )
			str.String(m_pszString, 0, nCount);

		return str;
	}

	#ifndef VWCL_NO_WIN32_API
		/* Load a string from resources. If hResource is NULL, VGetResourceHandle() will be used.*/
		VSTRING		Load(VUINT nStringID, HINSTANCE hResource = NULL)
			{ return LoadAppend(nStringID, hResource, VFALSE); }

		// Same as Load(), but appends the loaded string to the existing string, if any.
		VSTRING		LoadAppend(VUINT nStringID, HINSTANCE hResource = NULL, VBOOL bAppend = VTRUE)
		{
			VASSERT(nStringID)

			VTCHAR sz[1024];

			// Load string into stack buffer first and get length.
			VUINT nLength = LoadString((hResource) ? hResource : VGetResourceHandle(), nStringID, sz, VARRAY_SIZE(sz));

			if ( nLength )
				return (bAppend) ? Append(sz, 0, nLength) : String(sz, 0, 0, nLength);
			
			return NULL;
		}
	#endif

	// Make all characters lower case.
	VSTRING			LowerCase()
	{
		if ( GetLength() )
		{
			VASSERT(m_pszString)
			return VSTRLWR(m_pszString);
		}

		return NULL;
	}

	/* Make the string a GetOpenFileName() or GetSaveFileName() filter. That is, replace all occurances of \n in the
	string with \0 (zero terminators).*/
	VSTRING			MakeFilter()
		{ return ReplaceCharacters(VTEXT('\n'), VTEXT('\0')); }

	#ifndef VWCL_NO_WIN32_API
		// Same as above, but loads filter string from resources.
		VSTRING		MakeFilter(VUINT nFilterStringID, HINSTANCE hResource = NULL)
		{
			if ( Load(nFilterStringID, hResource) )
			{
				MakeFilter();
				return m_pszString;
			}

			return NULL;
		}
	#endif

	/* Substring extraction, returns a new VString object with part of the existing string extracted. This function
	will start at the nFirst character in the string, and copy nCount number of characters to the new string. If
	nCount is 0, the balance of the string after nFirst will be copied.*/
	VString			Mid(VUINT nFirst, VUINT nCount = 0) const
	{
		VString str;

		if ( nFirst < GetLength() )
			str.String(m_pszString + nFirst, 0, nCount);

		return str;
	}
	
	/* Set a pointer to an externally allocated C style string (allocated with malloc()) into object. This can be done
	to replace a string pointer with a previously "stolen" pointer from the StealBuffer() function. This class will
	then assume ownership of the string, deleting it as needed. The length of the allocated memory MUST be given to this
	class for the function to succeed. The C string essentially becomes a VString object, so the allocated memory size
	must be given, and it must be at least 1 byte longer than the string to be valid.*/
	VSTRING			ReplaceBuffer(VSTRING pszString, VUINT nAllocatedMemorySize, VUINT nKnownStringLength = 0)
	{
		// Free current string.
		Empty();
		
		// Save pointer?
		if ( pszString )
		{
			VASSERT(nAllocatedMemorySize > (VUINT)VSTRLEN(pszString))
				
			// Set member variables.
			m_pszString =		pszString;
			m_nAllocLength =	nAllocatedMemorySize;
			m_nLength =			(nKnownStringLength) ? nKnownStringLength : VSTRLEN(pszString);
		}

		return m_pszString;
	}

	// Replace all occurances of nFind in the string with nReplacement.
	VSTRING			ReplaceCharacters(VTCHAR nFind, VTCHAR nReplacement)
	{
		if ( GetLength() )
		{
			VSTRING pszOffSet = m_pszString;

			while ( *pszOffSet != VTEXT('\0') )
			{
				if ( *pszOffSet == nFind )
					*pszOffSet = nReplacement;

				pszOffSet++;
			}

			return m_pszString;
		}

		return NULL;
	}

	/* Replace the first occurance of nChar with nReplacement in the string. The default for nReplacement terminates
	the string. The return value is the point at which the string was terminated on success, NULL on failure.*/
	VSTRING			ReplaceFirstChar(VTCHAR nChar, VTCHAR nReplacement = VTEXT('\0'))
		{ return ReplaceFirstOrLastChar(nChar, nReplacement, VTRUE); }

	/* Replace the last occurance of nChar with nReplacement in the string. The default for nReplacement terminates
	the string. The return value is the point at which the string was terminated on success, NULL on failure.*/
	VSTRING			ReplaceLastChar(VTCHAR nChar, VTCHAR nReplacement = VTEXT('\0'))
		{ return ReplaceFirstOrLastChar(nChar, nReplacement, VFALSE); }

	/* Substring extraction, returns a new VString object with the nCount rightmost characters of this string. If there are
	more than nCount characters in this string, the entire string will be returned.*/
	VString			Right(VUINT nCount) const
	{
		VASSERT(nCount)

		VString str;
		
		if ( GetLength() && nCount )
		{
			if ( nCount > m_nLength )
				nCount = m_nLength;

			str.String(m_pszString + (m_nLength - nCount), 0, nCount);
		}

		return str;
	}

	/* Steal the C-Style string buffer. Calling code takes ownership of string pointer and must free it when done using the CRT
	function free(). On exit, this class is a newly initialized state, ready for more appending, but the current string will be
	NULL.*/
	VSTRING			StealBuffer()
		{ VSTRING pszString = Empty(VFALSE); m_nAllocLength = 0; return pszString; }

	// Get the internal string buffer.
	VSTRING			String() const
		{ return m_pszString; }

	/* Save pszString in class and returns pointer to buffer if a string is held. If nExtraBytes is set, that much
	more memory will be allocated in addition to the length of pszString. pszString can be NULL and still have memory
	allocated if nExtraBytes is not 0. Using the function this way is a good way to dynamically allocate heap memory
	and still have this class free the memory when no longer needed. The allocated memory will be 0 filled. If
	extra bytes are allocated, they will be filled with 0's. If this function is used to allocate memory only (pszString
	set to NULL and nExtraBytes set to non-0), UpdateLength() should be called as soon as the class contains a valid
	string so that future processing using this class is not harmed.
	It should be noted that for string that are not likely to change size, this function differs from Append() by not
	allocating more memory than is required. This does not affect future appends which can still be done, it merely
	means that for strings not likely to change, it uses a more efficient storage scheme. If pszString is not NULL and
	nMaxChars is given, only the number of character specified will be copied to the string, although the extra bytes will
	still be allocated if given. A very slight performance boost can be realized if the length of pszString is known when
	this function is called, and can be specified as the nKnownStringLength parameter. If this function fails to allocate
	memory, it will return NULL, however the previous string held by this class will be left intact and safe.*/
	VSTRING			String(VSTRING_CONST pszString, VUINT nExtraBytes = 0, VUINT nMaxChars = 0, VUINT nKnownStringLength = 0)
	{
		VBOOL bSuccess = VTRUE;

		// Same as empty?
		if ( !pszString && !nExtraBytes )
			return Empty();

		// Anything to do?
		if ( pszString || nExtraBytes )
		{
			// Check for required duplication.
			VBOOL bDuplicateRequired;
			VString* pOverlap = DuplicateOverlap(pszString, bDuplicateRequired);

			// Return error if we needed a overlap duplication made and couldn't.
			if ( bDuplicateRequired && !pOverlap )
				bSuccess = VFALSE;

			// Still OK?
			if ( bSuccess )
			{
				// Assign overlap to string?
				if ( pOverlap )
					pszString = pOverlap->String();

				// Determine memory allocation length. pszString can be NULL.
				if ( !nKnownStringLength )
					nKnownStringLength = (pOverlap) ? pOverlap->GetLength() : VSTRLEN_CHECK(pszString);

				// Are we only interested in a certain number of characters? Save that memory.
				if ( nMaxChars && nMaxChars < nKnownStringLength )
					nKnownStringLength = nMaxChars;
				
				// Determine allocation size, including requested extra bytes.
				VUINT nAllocLength = nKnownStringLength + nExtraBytes;

				// Anything to do?
				if ( nAllocLength )
				{
					// Add one for trailing 0 on string?
					if ( pszString )
						nAllocLength++;

					// (Re)Allocate memory for string.
					VSTRING pszBuffer = (VSTRING)realloc(m_pszString, nAllocLength);

					if ( pszBuffer )
					{
						// Initialize member variables.
						m_pszString =		pszBuffer;
						m_nLength =			nKnownStringLength;
						m_nAllocLength =	nAllocLength;

						// Zero fill unused memory.
						if ( nAllocLength > nKnownStringLength )
							VZEROMEMORY(m_pszString + nKnownStringLength, nAllocLength - nKnownStringLength);

						// Copy string as needed.
						if ( pszString )
							memcpy(m_pszString, pszString, nKnownStringLength);
					}
					else
					{
						AddError();
						bSuccess = VFALSE;
					}
				}
				else
					Empty();
			}

			VDELETE pOverlap;
		}

		return (bSuccess ) ? m_pszString : NULL;
	}

	// Set an integer to the string.
	VSTRING			String(VINT nValue)
		{ VTCHAR sz[64]; return String(_itoa(nValue, sz, 10)); }

	// Set a long integer to the string.
	VSTRING			String(VLONG nValue)
		{ VTCHAR sz[64]; return String(_ltoa(nValue, sz, 10)); }

	// Set an unsigned long integer to the string.
	VSTRING			String(VULONG nValue)
		{ VTCHAR sz[64]; return String(_ultoa(nValue, sz, 10)); }

	// Remote all spaces from left and right side of string.
	VSTRING			Trim()
		{ return (TrimLeft() && TrimRight()) ? m_pszString : NULL; }

	// Remove all space characters from left side of string.
	VSTRING			TrimLeft()
	{
		if ( GetLength() )
		{
			VSTRING pszOffSet = m_pszString;

			while ( *pszOffSet == VTEXT(' ') )
				pszOffSet++;
			
			// Anything to do?
			if ( pszOffSet != m_pszString )
			{
				// Copy to temp first.
				VString sTemp(pszOffSet);
				
				// Steal buffer.
				ReplaceBuffer(sTemp.StealBuffer(), sTemp.GetLength(VTRUE));
			}

			return m_pszString;
		}

		return NULL;
	}

	// Remove all space characters from right side of string.
	VSTRING			TrimRight()
	{
		if ( GetLength() )
		{
			VSTRING pszOffSet = m_pszString + (m_nLength - 1);

			while ( pszOffSet != m_pszString && *pszOffSet == VTEXT(' ') )
				pszOffSet--;
			
			// Anything to do?
			if ( pszOffSet != m_pszString + (m_nLength - 1) )
			{
				// All spaces?
				if ( pszOffSet == m_pszString )
					Empty();
				else
				{
					// Terminate string.
					*(pszOffSet + 1) = VTEXT('\0');

					// Recalc new length.
					m_nLength = (pszOffSet - m_pszString) + 1;
				}
			}
		}

		return (m_nLength) ? m_pszString : NULL;
	}

	/* This function should be called anytime the length of the string is altered outside of the class. If the exact length
	of the string is known (or you want to lie about it), pass a non-0 value for nLength. Passing 0 causes this function to
	determine the length of the string. nLength cannot be larger than the real string length, although it can be smaller. Since
	this class can be used to store non-string data as a string, which could contain embedded 0 terminators, this class cannot
	check the validity of nLength when non-0. Care must be taken here to set the length to the exact length of the data.
	This class will verify that nLength is not larger than the internally allocated length.*/
	void			UpdateLength(VUINT nLength = 0)
	{
		// nLength cannot be more than what is already allocated, at a max.
		if ( nLength > m_nAllocLength )
			nLength = m_nAllocLength;

		m_nLength = (nLength) ? nLength : VSTRLEN_CHECK(m_pszString);
	}

	// Make all characters upper case.
	VSTRING			UpperCase()
	{
		if ( GetLength() )
		{
			VASSERT(m_pszString)
			return VSTRUPR(m_pszString);
		}

		return NULL;
	}

protected:
	// Copy internal string if pszString is within us.
	VString*		DuplicateOverlap(VSTRING_CONST pszString, VBOOL& bDuplicateRequired)
	{
		bDuplicateRequired = VFALSE;

		// Deal with appending from an overlapping string. That is, a string that is part of us already.
		if ( pszString && m_pszString && pszString >= m_pszString && pszString <= m_pszString + m_nLength )
		{
			bDuplicateRequired = VTRUE;
			
			VString* pDuplicate = VNEW VString(pszString);

			if ( pDuplicate && pDuplicate->IsNotEmpty() )
				return pDuplicate;

			VDELETE pDuplicate;

			// Incremement error count.
			AddError();
		}

		return NULL;
	}

	// Initialize member variables to default values or copy from another object.
	void			Init(VString const* pExisting = NULL)
	{
		// Initiailize members.
		m_pszString =									NULL;
		m_nAllocLength = m_nLength = m_nErrorCount =	0;

		// Copy the granularity as needed.
		m_nGranularity = (pExisting) ? pExisting->m_nGranularity : 64;

		// Copy string too?
		if ( pExisting )
			String(pExisting->String());
	}

	// Replace the first or last occurance of nChar with nReplacement in the string.
	VSTRING			ReplaceFirstOrLastChar(VTCHAR nChar, VTCHAR nReplacement, VBOOL bFirst)
	{
		if ( GetLength() )
		{
			VSTRING psz = (bFirst) ? VSTRCHR(m_pszString, nChar) : VSTRRCHR(m_pszString, nChar);
			
			if ( psz )
			{
				*psz = nReplacement;
				return psz;
			}
		}

		return NULL;
	}

	// Embedded Member(s).
	VSTRING			m_pszString;
	VUINT			m_nLength;
	VUINT			m_nAllocLength;
	VUINT			m_nGranularity;
	VUINT			m_nErrorCount;
};

#endif	// VSTRINGHPP
