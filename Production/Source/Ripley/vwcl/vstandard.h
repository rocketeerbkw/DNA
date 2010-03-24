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

#ifndef VSTANDARD
#define VSTANDARD

/* This is the standard include file for the Virtual Windows Class Library (VWCL).
This header replaces the older VWCL.H and is used only to define basic functionality,
and implies nothing about the application being written. In fact, the application can
be C++ or a mix of C and C++. Previous releases of VWCL (Prior to December 1997) used
the preprocessor extensively to include or excluse code. VWCL grew to such a size that
this method proved extremely hard to maintain. The new method requires the users of VWCL
to manually include the classes they need. Those classes, should they require others, will
include those other headers as needed. This makes the code more maintainable, and also has
the benefit of better code re-use and builds smaller and tighter applications by only including
required code. There are still some basic preprocessor command that can, or should, be defined:

VWCL_DONT_REGISTER_CLASSES -	Causes VWCL initialization code to not register standard VWCL window class(es).
								This is most useful for dialog box based applications, or where VWCL is being compiled into a shared DLL.
VWCL_EXPORT_DLL -				Define this when building a DLL version of class library.
								A shared VWCL DLL can only be loaded once per process. VWCL has
								no state or resource management functions, so multiple DLL's that
								use VWCL dynamically linked into one EXE would fail to locate resources
								outside of the calling programs resources. A call to VGetApp().Init()
								from these DLL's would corrupt the EXE's global VApplication object.
VWCL_IMPORT_DLL -				Define this when using VWCL from a DLL (importing).
VWCL_NO_WIN32_API -				Define when the Win32 API is not available. WINE (www.winehq.com), and MainWin (www.mainsoft.com) are implementations of Win32 on UNIX platforms.
VWCL_TARGET_IIS_EXTENSION -		Define when building a Internet Information Server extension application.
VWCL_TARGET_LINUX -				Defines Linux as the target UNIX platform.
VWCL_TARGET_SOLARIS -			Defines Sun Microsystems Solaris as the target UNIX platform.
VWCL_TARGET_SCO -				Defines SCO UNIX as the target UNIX platform.
VWCL_TARGET_HPUX -				Defines HPUX as the target UNIX platform.
VWCL_TARGET_BSD -				Defines BSD as the target UNIX platform.
VWCL_TARGET_DEC -				Defines DEC Digital Unix as the target UNIX platform.
VWCL_TARGET_MAC -				Defines Apple Macintosh as the target platform.

The following directives will be defined by this header file and should not be defined elsewhere:
VWCL_CONSOLE_APP -				Causes VWCL to eliminate code not needed when a console app is the target.
VWCL_TARGET_UNIX -				Instructs VWCL classes to compile for (generic) UNIX platforms.
VWCL_DEBUG -					VWCL directive defined when a debug build is the target for all platforms.
VWCL_UNICODE -					VWCL directive defined when UNICODE is being used.*/

// Make sure user did not already specify a directive this header defines.
#ifdef VWCL_CONSOLE_APP
	#error VWCL_CONSOLE_APP should not yet be defined. For Windows console mode, define _CONSOLE
#endif
#ifdef VWCL_TARGET_UNIX
	#error VWCL_TARGET_UNIX should not yet be defined. Define VWCL_TARGET_LINUX, VWCL_TARGET_SOLARIS, VWCL_TARGET_SCO, VWCL_TARGET_HPUX, VWCL_TARGET_BSD, or VWCL_TARGET_DEC for UNIX compatiblity.
#endif
#ifdef VWCL_DEBUG
	// TODO: UNIX (GCC) compiler debug directive?
	#error VWCL_DEBUG should not yet be defined. For Windows, define _DEBUG. For UNIX, define ??.
#endif
#ifdef VWCL_UNICODE
	#error VWCL_UNICODE should not yet be defined. For Windows, define _UNICODE.
#endif
#ifdef VODS
	#error VODS should not yet be defined.
#endif

// Force strict type checking.
#ifndef STRICT
	#define STRICT
#endif

// First, determine if a UNIX platform is the target.
#if defined VWCL_TARGET_LINUX
	#define VWCL_TARGET_UNIX
#elif defined VWCL_TARGET_SOLARIS
	#define VWCL_TARGET_UNIX
#elif defined VWCL_TARGET_SCO
	#define VWCL_TARGET_UNIX
#elif defined VWCL_TARGET_HPUX
	#define VWCL_TARGET_UNIX
#elif defined VWCL_TARGET_BSD
	#define VWCL_TARGET_UNIX
#elif defined VWCL_TARGET_DEC
	#define VWCL_TARGET_UNIX
#endif

// Should VWCL_CONSOLE_APP be defined?
#ifndef VWCL_TARGET_UNIX
	#ifdef _CONSOLE
		#define VWCL_CONSOLE_APP
	#endif
#else
	// TODO: What defines a console UNIX app?
#endif
	
// Define other settings for console applications.
#ifdef VWCL_CONSOLE_APP
	#ifndef VWCL_DONT_REGISTER_CLASSES
		#define VWCL_DONT_REGISTER_CLASSES
	#endif
#endif

// Should VWCL_DEBUG be defined?
#ifdef VWCL_TARGET_UNIX
	// TODO: UNIX (GCC) compiler debug directive?
	#ifdef _DEBUG
		#define VWCL_DEBUG
	#endif
#elif defined _DEBUG
	#define VWCL_DEBUG
#endif

// Should VWCL_UNICODE be defined?
#ifdef _UNICODE
	#define VWCL_UNICODE
#endif

/* Define VASSERT macro, which really does compile away to nothing for release builds. This macro already defines
the trailing ; so users should NOT append a semicolon to the end of this macro. The reason for this is that if the
semicolon is there, it results in double ;; during debug builds and a body ; in release builds. This normally does
not do any harm, but some compilers have been reported to have problems with this.*/
#ifdef VWCL_DEBUG
	#define VASSERT(expr)	assert(expr);
#else
	#define VASSERT(expr)
#endif

/* Define VVERIFY which compiles to VASSERT(expression) in debug build, and just expression in release build.
This is useful when the expression should be evaluated in the debug and release builds, but when the
expression is still required to be computed in release builds. Like VASSERT, you should not include the
trailing semicolon. It will be inserted as needed in release builds.*/
#ifdef VWCL_DEBUG
	#define	VVERIFY(expr) VASSERT(expr)
#else
	#define VVERIFY(expr) expr;
#endif

/* Define VVERIFY_EXPR which can be used like VVERIFY, except it can also be used in a conditional construct
such as a if or while statement. During debug builds, the macro will assert if the expression is evaluated
as false. During release builds, the expression is evalulated, but will never assert.*/
#ifdef VWCL_DEBUG
	#define VVERIFY_EXPR(expr)	((expr) || (_assert(#expr,__FILE__,__LINE__),0))
#else
	#define VVERIFY_EXPR(expr)	(expr)
#endif

/* OutputDebugString wrapper. Sends output to OutputDebugString() on Windows, stderr otherwise.
If stderr is wanted, even on Windows platforms, use VODS_CONSOLE, which always sends output to
stderr. Both macros compile to nothing in a non-debug build. Under a UNIX target, VODS is the same
as VODS_CONSOLE and always sends output to stderr. In all cases, you should not include a trailing
semicolon. This macro will insert one as needed.*/
#ifdef VWCL_DEBUG
	#define VODS_CONSOLE(string)	fprintf(stderr, "\nDEBUG: %s\n", string);
	#ifdef VWCL_NO_WIN32_API
		#define VODS(string)		VODS_CONSOLE(string)
	#else
		#define VODS(string)		OutputDebugString(string);
	#endif
#else
	#define VODS_CONSOLE(string)
	#define VODS(string)
#endif

// Include CRT standard headers.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>

#ifdef VWCL_DEBUG
	#include <assert.h>
#endif

#ifdef VWCL_TARGET_UNIX
	#include <varargs.h>
#else
	#include <stdarg.h>
#endif

// Include platform specific headers.
#ifdef VWCL_NO_WIN32_API
	// TODO: Standard UNIX headers. Take WINE and MainWin into account.
#else
	// Standard Windows headers.
	#include <windows.h>
	#include <windowsx.h>
	#include <commctrl.h>
	#include <commdlg.h>
	#include <tchar.h>
	// Include Internet Information Server?
	#ifdef VWCL_TARGET_IIS_EXTENSION
		#include <httpext.h>
		#include <httpfilt.h>
	#endif
#endif

// VREF_PTR macro derefences any pointer to a reference.
#define	VREF_PTR(p)	*p

// Use VREF_THIS when you have a "this" pointer and need to convert it to a reference.
#define VREF_THIS	VREF_PTR(this)

// Macro to determine static array size.
#define VARRAY_SIZE(the_array)			sizeof(the_array) / sizeof(the_array[0])

// Macro to determine if a file exists (Win32 Only).
#ifndef VWCL_NO_WIN32_API
	#define VDOES_FILE_EXIST(filename)	((!filename || GetFileAttributes(filename) == 0xffffffff) ? VFALSE : VTRUE)
#endif

// Macro to zero fill a section of memory.
#ifndef VWCL_NO_WIN32_API
	#define VZEROMEMORY(address, bytes)		ZeroMemory(address, bytes)
#else
	#define VZEROMEMORY(address, bytes)		memset((VVOIDPTR)address, (VINT)0, (size_t)bytes)
#endif

// Macro to zero fill all members of a structure.
#define VZEROSTRUCT(zero_struct)			VZEROMEMORY(&zero_struct, sizeof(zero_struct))

// Macro to define true and false values.
#define	VTRUE				1
#define	VFALSE				0

// This section defines standard C/C++ data types as VWCL data types.
typedef int					VINT;			// Target Dependant Signed Integer.
typedef unsigned int		VUINT;			// Target Dependant Unsigned Integer.
typedef __int8				VINT8;			// 8 Bit Signed Integer.
typedef unsigned __int8		VUINT8;			// 8 Bit Unsigned Integer.
typedef __int16				VINT16;			// 16 Bit Signed Integer.
typedef unsigned __int16	VUINT16;		// 16 Bit Unsigned Integer.
typedef __int32				VINT32;			// 32 Bit Signed Integer.
typedef unsigned __int32	VUINT32;		// 32 Bit Unsigned Integer.
typedef __int64				VINT64;			// 64 Bit Signed Integer.
typedef unsigned __int64	VUINT64;		// 64 Bit Unsigned Integer.
typedef char				VCHAR;			// Always char.
typedef unsigned char		VUCHAR;			// Always unsigned char.
typedef short				VSHORT;			// Target Dependant Signed Short Integer.
typedef unsigned short		VUSHORT;		// Target Dependant Unsigned Short Integer.
typedef long				VLONG;			// Target Dependant Signed Long Integer.
typedef unsigned long		VULONG;			// Target Dependant Unsigned Long Integer.
typedef float				VFLOAT;			// Target Dependant Float.
typedef double				VDOUBLE;		// Target Dependant Double.
typedef long double			VLONGDOUBLE;	// Target Dependant Long Double.
typedef void*				VVOIDPTR;		// Always a void*.
typedef void const*			VVOIDPTR_CONST;	// Always a void* const.
typedef VUINT8				VBOOL;			// Same as VUINT8, always a 1 byte (8 bit) Unsigned Integer.
typedef VINT8				VBYTE;			// Same as VINT8, always a 1 byte (8 bit) Signed Integer.

// This section maps Windows defined data types as new types, or uses existing types when available.
#ifdef VWCL_NO_WIN32_API
	typedef VCHAR			VTCHAR;			// Same as VCHAR (No UNICODE support).
	typedef VTCHAR*			VSTRING;		// Same as VTCHAR* (No UNICODE support).
	typedef VTCHAR const*	VSTRING_CONST;	// Same as VTCHAR* (No UNICODE support - const).
	typedef VBOOL			VWINBOOL;		// Same as VBOOL.
	typedef VUSHORT			VWORD;			// Same as VUSHORT.
	typedef VULONG			VDWORD;			// Same as VULONG.
	typedef VUINT			VWPARAM;		// Same as VUINT.
	typedef VLONG			VLPARAM;		// Same as VLONG.
#else
	typedef TCHAR			VTCHAR;			// Same as TCHAR (UNICODE supported).
	typedef VTCHAR*			VSTRING;		// Same as VTCHAR* (UNICODE supported).
	typedef VTCHAR const*	VSTRING_CONST;	// Same as VTCHAR const* (UNICODE supported - const).
	typedef BOOL			VWINBOOL;		// Same as compiler defined BOOL.
	typedef WORD			VWORD;			// Same as compiler defined WORD.
	typedef DWORD			VDWORD;			// Same as compiler defined DWORD.
	typedef WPARAM			VWPARAM;		// Same as compiler defined WPARAM.
	typedef LPARAM			VLPARAM;		// Same as compiler defined LPARAM.
#endif

// This section creates macros which map non-portable C Runtime Library Functions.

// Common to UNIX and Windows.
#define		VSTRNCPY			strncpy
#define		VSTRDUP				strdup

#ifdef VWCL_TARGET_UNIX
	#define VSTRCAT				strcat
	#define	VSTRCHR				strchr
	#define	VSTRCMP				strcmp
	#define	VSTRCPY				strcpy
	#define	VSTRICMP			stricmp
	#define	VSTRLEN				strlen
	#define	VSTRLWR				strlwr
	#define VSTRRCHR			strrchr
	#define	VSTRSTR				strstr
	#define	VSTRUPR				strupr
	#define VISLOWER			islower
	#define VISUPPER			isupper
#else
	#define VSTRCAT				lstrcat
	#define	VSTRCHR				_tcschr
	#define	VSTRCMP				lstrcmp
	#define	VSTRCPY				lstrcpy
	#define	VSTRICMP			lstrcmpi
	#define	VSTRLEN				lstrlen
	#define	VSTRLWR				_tcslwr
	#define VSTRRCHR			_tcsrchr
	#define	VSTRSTR				_tcsstr
	#define	VSTRUPR				_tcsupr
	#define VISLOWER			_istlower
	#define VISUPPER			_istupper
#endif

// Macro to perform a non-case sensistive string comparison.
#define	VSTRCMP_NOCASE			VSTRICMP

// Macro to return string length, or 0 if string is NULL.
#define	VSTRLEN_CHECK(str)		((str) ? VSTRLEN(str) : 0)

/* Macro to force operator new to return NULL and not throw an exception.
TODO: This is not yet implemented until the compiler vendors make ANSI compliant C++ compilers.*/
#define	VNEW					new

// For consistency with VNEW, we define VDELETE.
#define VDELETE					delete

// When deleting array, use this version.
#define VDELETE_ARRAY			VDELETE []

/* This macro will return either _T(string) or just (string), which on Windows platforms, can be
used to create a UNICODE string from a literal string if UNICODE is defined.*/
#ifdef VWCL_TARGET_UNIX
	#define	VTEXT(string)		string
#else
	#ifdef VWCL_UNICODE
		#define VTEXT(string)	_T(string)
	#else
		#define	VTEXT(string)	string
	#endif
#endif

// Define the default file path seperator character.
#ifdef VWCL_TARGET_UNIX
	static VSTRING_CONST	VFILE_PATH_SEP =		VTEXT("/");
	static VTCHAR const		VFILE_PATH_SEP_CHAR =	VTEXT('/');
#else
	static VSTRING_CONST	VFILE_PATH_SEP =		VTEXT("\\");
	static VTCHAR const		VFILE_PATH_SEP_CHAR =	VTEXT('\\');
#endif

/* This macro simply expands to Don Box's (dbox@develop.com) _U macro, to take any string, ANSI or UNICODE, and
return whatever type of string is requested by a function. ustring.cpp or vstringconvert.c must be included in the project.*/
#define		VTEXT_ANY			_U

// Same as above, but adds non-const conversions.
#define		VTEXT_ANY_NON_CONST	_UNCC

/* Macro compiles to VShowLastErrorMessage() global function for Win32 release builds, nothing otherwise. expr
is the expression to evaluate. If expr evaluates to a 0 value, VShowLastErrorMessage() will be called,
otherwise it will not. In essence, this works exactly like VASSERT, where you expect expr to be non-0, but shows a
messagebox or sends output to VODS. Like VASSERT, do not end this macro with a semicolon, since that would leave
a bogus extra one that some compilers may have problems with.*/
#ifndef VWCL_NO_WIN32_API
	#ifdef VWCL_DEBUG
		#define VSHOWLASTERRORMESSAGE(expr, hwnd)	if ( !(expr) ) VShowLastErrorMessage(hwnd);
	#else
		#define VSHOWLASTERRORMESSAGE(expr, hwnd)
	#endif
#else
	#define VSHOWLASTERRORMESSAGE(expr, hwnd)
#endif

// During debug builds, this string is defined, mostly for use in messagebox titles.
#ifdef VWCL_DEBUG
	static VSTRING_CONST VWCL_DEBUG_MESSAGE_STRING = VTEXT("VWCL DEBUG MESSAGE");
#endif

// Determine how classes and functions are exported, imported, or nothing (Win32 only).
#ifndef VWCL_NO_WIN32_API
	#ifdef VWCL_EXPORT_DLL
		#define VWCL_API _declspec(dllexport)
	#else
		#ifdef VWCL_IMPORT_DLL
			#define VWCL_API _declspec(dllimport)
		#else
			#define VWCL_API
		#endif
	#endif
#else
	#define VWCL_API
#endif

#ifdef __cplusplus
	// Forward Declaration(s).
	class						VApplication;
	
	// Returns a reference to the VApplication application object.
	VApplication&				VGetApp();

	// The following are only valid on Win32 platforms.
	#ifndef VWCL_NO_WIN32_API
		// Handle dailog box message routing.
		#ifndef VWCL_CONSOLE_APP
			VWCL_API VBOOL		VTranslateDialogMessage(MSG const& msg);
		#endif

		// The standard window class that VWCL registers unless VWCL_DONT_REGISTER_CLASSES is defined.
		static VSTRING_CONST	VWINDOWCLASS = VTEXT("VWindow");
	#endif
#endif

// For argc and argv support in Windows.
#ifndef VWCL_NO_WIN32_API
	#ifdef __cplusplus
		extern "C" __declspec(dllimport) int	argc;
		extern "C" __declspec(dllimport) char**	argv;
	#else
		static int		argc;
		static char**	argv;
	#endif

	#define argc		__argc
	#define argv		__argv
#endif

// Standard C style Global VWCL API's.
#ifdef __cplusplus
	extern "C" {
#endif

/* If building a standard Windows GUI VWCL application, these functions will already be implemented
for you in vapplication.cpp and other global modules. However, if you are picking an choosing classes from VWCL
to use in your application, you may have to implement these C style functions because classes that require these
will have to have them to compile and link properly.*/

// Return a static string buffer to the applications title, or name.
VSTRING_CONST		VGetAppTitle();

#ifndef VWCL_NO_WIN32_API
	// Return the show command (ShowWindow() SW_xxx constant passed on command line).
	VINT			VGetCommandShow();

	// Return the global instance handle of the application or DLL.
	HINSTANCE		VGetInstanceHandle();

	// Return the instance handle where resources are held.
	HINSTANCE		VGetResourceHandle();

	// GDI Support Routines implemented in vgdiglobal.c.
	VWCL_API void	VMapCoords(HDC hDC, SIZEL* pSizeL, VBOOL bToPixels);
	#define			VPixelsToHIMETRIC(hDC, pSizeL)		VMapCoords(hDC, pSizeL, VFALSE)
	#define			VPixelsFromHIMETRIC(hDC, pSizeL)	VMapCoords(hDC, pSizeL, VTRUE)

	// ActiveX Support Routines implemented in vactivexglobal.cpp.

	// Determine if a string is a valid ActiveX structured storage name. This includes length and valid characters.
	VWCL_API VBOOL	VIsValidStructuredStorageName(VSTRING_CONST pszName);

	// Given a C string, allocate a new string with CoTaskMemAlloc() and copy it.
	VWCL_API VBOOL	VCoStringFromString(VSTRING* ppszCoString, VSTRING_CONST pszString);

	// Debugging Support Routines implemented in vdebugglobal.c.

	/* Show the result from GetLastError() as a message box, or VODS if a console application. This function is
	implemented in utility/vdebugglobal.c. This function is not available in release builds, so it should rarely
	be called directly. Rather, the VSHOWLASTERRORMESSAGE macro should be used.*/
	#ifdef VWCL_DEBUG
		VWCL_API VINT	VShowLastErrorMessage(HWND hWndParent);
	#endif
#endif

#ifdef __cplusplus
	}
#endif

#endif // VSTANDARD
