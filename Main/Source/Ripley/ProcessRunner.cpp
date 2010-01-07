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
//#include "ScriptRunner.h"
#include "ProcessRunner.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CProcessRunner::CProcessRunner()
{
	m_hChildProcess		= NULL;
	m_pThread			= NULL;
	m_nMyNumber			= 0;
	m_bThreadMustEnd    = FALSE;

	m_bOutputUpdatedSinceLastGet = FALSE;
	m_nNumLinesInLastUpdate		 = 0;
}

CProcessRunner::~CProcessRunner()
{
	SetThreadMustEnd();
	WaitForReaderThreadExit();

	m_pThread = NULL;
	m_hChildProcess = NULL;
}

// Define assignment operator.
CProcessRunner& CProcessRunner::operator=(CProcessRunner &RHS )
{
	CSingleLock singleLock(&m_OutputCriticalSection);
	singleLock.Lock();
	{
		m_hChildProcess = RHS.m_hChildProcess;
		m_PipeHandles	= RHS.m_PipeHandles;
		m_pThread		= RHS.m_pThread;
		m_csOutput		= RHS.m_csOutput;
	}
	singleLock.Unlock();

    return *this;  // Assignment operator returns left side.
}

void CProcessRunner::WaitForReaderThreadExit()
{
	TRACE("WaitForReaderThreadExit() : In (0x%x)\n",m_pThread);
	if (m_pThread != NULL)
	{
		if (WaitForSingleObject(m_pThread->m_hThread,INFINITE) == WAIT_FAILED)
			HandleError("WaitForSingleObject");
	}
	m_pThread = NULL;
	TRACE("WaitForReaderThreadExit() : Out\n");
}

UINT MyThread(LPVOID pParam)
{
	CProcessRunner* pProcessRunner = (CProcessRunner*) pParam;

	for (int i=0;i < 100000000;i++)
		pProcessRunner->IncMyNumber();

	return 0;
}

bool CProcessRunner::Run(const TDVCHAR* pProcessPath)
{
	if (CreateTheProcess(pProcessPath))
	{
		SetThreadStarting();
		m_pThread = AfxBeginThread( CProcessRunner::ReaderThread, LPVOID(this));
		return true;
	}

	return false;
}

void CProcessRunner::ThreadEnded()
{
	m_pThread = NULL;
}

void CProcessRunner::SetThreadStarting()
{
//	TRACE("SetThreadStarting()\n");
	m_bThreadMustEnd = FALSE;
}

void CProcessRunner::SetThreadMustEnd()
{
//	TRACE("SetThreadMustEnd()\n");
	m_bThreadMustEnd = true;
}

bool CProcessRunner::IsThreadEnding()
{
//	TRACE("IsThreadTerminating()\n");
	return m_bThreadMustEnd;
}


bool CProcessRunner::IsRunning()
{
	if (m_pThread == NULL)
		return FALSE;

	DWORD d = WaitForSingleObject(m_pThread->m_hThread,0);

	return	(d == WAIT_TIMEOUT);
}


void CProcessRunner::Terminate()
{
	if (m_hChildProcess != NULL)
	{
		if (!TerminateProcess(m_hChildProcess,1))
			HandleError("TerminateProcess");
		WaitForReaderThreadExit();
	}

	m_hChildProcess = NULL;
}

void CProcessRunner::GetOutput(CTDVString& csOutput)
{
	CSingleLock singleLock(&m_OutputCriticalSection);
	singleLock.Lock();
	{
		csOutput = m_csOutput;
		m_bOutputUpdatedSinceLastGet = FALSE;
	}
	singleLock.Unlock();
}

void CProcessRunner::ClearOutput()
{
	CSingleLock singleLock(&m_OutputCriticalSection);
	singleLock.Lock();
	{
		m_csOutput.Empty();
	}
	singleLock.Unlock();
}

void CProcessRunner::AddToOutput(const TDVCHAR* pBuffer)
{
	CTDVString csBuffer(pBuffer);

	CSingleLock singleLock(&m_OutputCriticalSection);
	singleLock.Lock();
	{
		m_csOutput += csBuffer;
		m_bOutputUpdatedSinceLastGet = true;
		m_nNumLinesInLastUpdate = GetNumLines(csBuffer);
	}
	singleLock.Unlock();
}


UINT CProcessRunner::GetNumLinesInLastUpdate()
{
	return m_nNumLinesInLastUpdate;
}

bool CProcessRunner::WasOutputUpdatedSinceLastGet()
{
	return m_bOutputUpdatedSinceLastGet;
}

bool CProcessRunner::CreateTheProcess(const TDVCHAR* pProcessPath)
{
	m_PipeHandles.Create();

	PROCESS_INFORMATION pi;
	STARTUPINFO si;

	// Set up the start up info struct.
	ZeroMemory(&si,sizeof(STARTUPINFO));
	si.cb = sizeof(STARTUPINFO);
	si.dwFlags = STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW;
	si.hStdOutput = m_PipeHandles.GetOutputPipeWrite();
	si.hStdInput  = m_PipeHandles.GetInputPipeRead();
	si.hStdError  = m_PipeHandles.GetErrorPipeWrite();
	si.wShowWindow= SW_MINIMIZE;
	// Use this if you want to hide the child:
	//     si.wShowWindow = SW_HIDE;
	// Note that dwFlags must include STARTF_USESHOWWINDOW if you want to
	// use the wShowWindow flags.

	// Launch the process that you want to redirect (in this case,
	// Child.exe). Make sure Child.exe is in the same directory as
	// redirect.c launch redirect from a command line to prevent location
	// confusion.
	if (!CreateProcess(NULL,(LPSTR)pProcessPath,NULL,NULL,true,
					 CREATE_NEW_CONSOLE,NULL,NULL,&si,&pi))
		return HandleError("CreateProcess");


	// Set child process handle to cause threads to exit.
	m_hChildProcess = pi.hProcess;

	// Close any unnecessary handles.
	if (!CloseHandle(pi.hThread))
		return HandleError("CloseHandle");

	// Close pipe handles (do not continue to modify the parent).
	// You need to make sure that no handles to the write end of the
	// output pipe are maintained in this process or else the pipe will
	// not close when the child process exits and the ReadFile will hang.
	m_PipeHandles.CloseInputPipeRead();
	m_PipeHandles.CloseOutputPipeWrite();
	m_PipeHandles.CloseErrorPipeWrite();

	return true;
}

UINT CProcessRunner::ReaderThread(LPVOID pParam)
{
	CProcessRunner* pProcessRunner = (CProcessRunner*) pParam;

	if (pProcessRunner == NULL)
		return FALSE;

	CHAR lpBuffer[256];
	DWORD nBytesRead;
	DWORD nTotalBytesRead=0;

	HANDLE hPipeRead = pProcessRunner->GetOutputPipeRead();
	if (hPipeRead == NULL)
		return FALSE;

	while(!pProcessRunner->IsThreadEnding())
	{
		if (!ReadFile(hPipeRead,lpBuffer,sizeof(lpBuffer)-1,
									  &nBytesRead,NULL) || !nBytesRead)
		{
			if (GetLastError() == ERROR_BROKEN_PIPE)
			{
				TRACE("************* pipe done - normal exit path.\n");
				break; // pipe done - normal exit path.
			}
			else
			{
				CProcessRunner temp;
				temp.HandleError("ReadFile"); // Something bad happened.
				break;
			}
		}

		nTotalBytesRead += nBytesRead;

		lpBuffer[nBytesRead] = 0;
		pProcessRunner->AddToOutput(lpBuffer);
	}

	TRACE("************* THE END (%d).\n",nTotalBytesRead);

	pProcessRunner->ThreadEnded();

	return 0;
}


HANDLE CProcessRunner::GetOutputPipeRead()
{
	return m_PipeHandles.GetOutputPipeRead();
}


UINT CProcessRunner::GetOutputNumLines()
{
	UINT nNumLines = 0;

	CSingleLock singleLock(&m_OutputCriticalSection);
	singleLock.Lock();
	{
		nNumLines = GetNumLines(m_csOutput);
	}
	singleLock.Unlock();

	return nNumLines;
}

UINT CProcessRunner::GetOutputLongestLine()
{
	UINT nLongestLine = 0;

	CSingleLock singleLock(&m_OutputCriticalSection);
	singleLock.Lock();
	{
		nLongestLine = GetLongestLine(m_csOutput);
	}
	singleLock.Unlock();

	return nLongestLine;
}


UINT CProcessRunner::GetNumLines(CTDVString& csStr)
{
	UINT nNumLines = 0;

	if (!csStr.IsEmpty())
	{
		int nNumChars = csStr.GetLength();
		for (int n=0;n < nNumChars;n++)
		{
			if (csStr[n] == TCHAR('\n'))
				nNumLines++;
		}
	}

	return nNumLines;
}

UINT CProcessRunner::GetLongestLine(CTDVString& csStr)
{
	UINT nLongestLine = 0;

	if (!csStr.IsEmpty())
	{
		int nNumChars = csStr.GetLength();
		UINT nLineLength = 0;
		for (int n=0; n < nNumChars; n++)
		{
			if (csStr[n] == TCHAR('\n'))
			{
				if (nLongestLine < nLineLength)
					nLongestLine = nLineLength;

				nLineLength = 0;
			}
			else
				nLineLength++;

			n++;
		}
	}

	return nLongestLine;
}
