// ProcessRunner.cpp: implementation of the CProcessRunner class.
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
#include "PipeHandles.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CPipeHandles::CPipeHandles()
{
	Reset();
}

CPipeHandles::~CPipeHandles()
{
	CloseAll();
}

void CPipeHandles::CloseAll()
{
	if (m_hOutputPipeWrite != NULL) ::CloseHandle(m_hOutputPipeWrite);
	if (m_hErrorPipeWrite  != NULL) ::CloseHandle(m_hErrorPipeWrite);
	if (m_hOutputPipeRead  != NULL) ::CloseHandle(m_hOutputPipeRead);
	if (m_hInputPipeWrite  != NULL) ::CloseHandle(m_hInputPipeWrite);
	if (m_hInputPipeRead   != NULL) ::CloseHandle(m_hInputPipeRead);
	Reset();
}

void CPipeHandles::Reset()
{
	m_hOutputPipeWrite = NULL;
	m_hErrorPipeWrite  = NULL;
	m_hOutputPipeRead  = NULL;
	m_hInputPipeWrite  = NULL;
	m_hInputPipeRead   = NULL;
}

bool CPipeHandles::Create()
{
	CloseAll();

	HANDLE hOutputReadTmp,hOutputRead,hOutputWrite;
	HANDLE hInputWriteTmp,hInputRead,hInputWrite;
	HANDLE hErrorWrite;
	SECURITY_ATTRIBUTES sa;

	// Set up the security attributes struct.
	sa.nLength= sizeof(SECURITY_ATTRIBUTES);
	sa.lpSecurityDescriptor = NULL;
	sa.bInheritHandle = true;

	// Create the child output pipe.
	if (!CreatePipe(&hOutputReadTmp,&hOutputWrite,&sa,0))
		return HandleError("CreatePipe");

	// Create a duplicate of the output write handle for the std error
	// write handle. This is necessary in case the child application
	// closes one of its std output handles.
	if (!DuplicateHandle(GetCurrentProcess(),hOutputWrite,
					   GetCurrentProcess(),&hErrorWrite,0,
					   true,DUPLICATE_SAME_ACCESS))
		return HandleError("DuplicateHandle");

	// Create the child input pipe.
	if (!CreatePipe(&hInputRead,&hInputWriteTmp,&sa,0))
		return HandleError("CreatePipe");

	// Create new output read handle and the input write handles. Set
	// the Properties to FALSE. Otherwise, the child inherits the
	// properties and, as a result, non-closeable handles to the pipes
	// are created.
	if (!DuplicateHandle(GetCurrentProcess(),hOutputReadTmp,
					   GetCurrentProcess(),
					   &hOutputRead, // Address of new handle.
					   0,FALSE, // Make it uninheritable.
					   DUPLICATE_SAME_ACCESS))
		return HandleError("DupliateHandle");

	if (!DuplicateHandle(GetCurrentProcess(),hInputWriteTmp,
					   GetCurrentProcess(),
					   &hInputWrite, // Address of new handle.
					   0,FALSE, // Make it uninheritable.
					   DUPLICATE_SAME_ACCESS))
		return HandleError("DupliateHandle");


	// Close inheritable copies of the handles you do not want to be
	// inherited.
	if (!CloseHandle(hOutputReadTmp))
		return HandleError("CloseHandle");
	if (!CloseHandle(hInputWriteTmp))
		return HandleError("CloseHandle");

	// Get std input handle so you can close it and force the ReadFile to
	// fail when you want the input thread to exit.
//	if ( (hStdIn = GetStdHandle(STD_INPUT_HANDLE)) == INVALID_HANDLE_VALUE )
//		return HandleError("GetStdHandle");

	m_hOutputPipeWrite = hOutputWrite;
	m_hOutputPipeRead  = hOutputRead;
	m_hErrorPipeWrite  = hErrorWrite;

	m_hInputPipeWrite = hInputWrite;
	m_hInputPipeRead  = hInputRead;

	return true;
}

bool CPipeHandles::HandleError(const TDVCHAR*pszAPI)
{
	LPVOID lpvMessageBuffer;
	CHAR szPrintBuffer[5000];

	DWORD dwLastError = GetLastError();

	FormatMessage(
		FORMAT_MESSAGE_ALLOCATE_BUFFER|FORMAT_MESSAGE_FROM_SYSTEM,
		NULL, dwLastError,
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
		(LPTSTR)&lpvMessageBuffer, 0, NULL);

	wsprintf(szPrintBuffer,
		"ERROR: API    = %s.\n   error code = %d.\n   message    = %s.\n",
		pszAPI, dwLastError, (char *)lpvMessageBuffer);

	LocalFree(lpvMessageBuffer);
	return 	SetDNALastError(pszAPI,CTDVString((int)dwLastError),szPrintBuffer);
}

