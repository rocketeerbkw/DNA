// ProcessRunner.h: interface for the CProcessRunner class.
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

#if !defined(AFX_PROCESSRUNNER_H__A501C1DE_1D0D_4058_B70D_33BFC990DF42__INCLUDED_)
#define AFX_PROCESSRUNNER_H__A501C1DE_1D0D_4058_B70D_33BFC990DF42__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <afxmt.h>
#include "PipeHandles.h"

class CProcessRunner : public CPipeHandles
{
public:
	HANDLE GetOutputPipeRead();
	CProcessRunner();
	virtual ~CProcessRunner();

	bool Run(const TDVCHAR* pProcessPath);
	bool IsRunning();
	void ThreadEnded();
	void SetThreadStarting();
	void SetThreadMustEnd();
	bool IsThreadEnding();

	void GetOutput(CTDVString& csOutput);
	void ClearOutput();
	bool WasOutputUpdatedSinceLastGet();
	UINT GetNumLinesInLastUpdate();

	UINT GetOutputNumLines();
	UINT GetOutputLongestLine();
	UINT GetNumLines(CTDVString& csStr);
	UINT GetLongestLine(CTDVString& csStr);

	void WaitForReaderThreadExit();
	void Terminate();
	void SendMessages();

	static UINT ReaderThread(LPVOID pParam);

	UINT GetMyNumber() { return m_nMyNumber; }
	void IncMyNumber() { m_nMyNumber++; }

	CProcessRunner &operator=( CProcessRunner & );  // Right side is the argument.

private:

	void AddToOutput(const TDVCHAR* pBuffer);

	bool CreateTheProcess(const TDVCHAR* pProcessPath);
	bool CreatePipeHandles(CPipeHandles* pHandles);

	HANDLE m_hChildProcess;

	CPipeHandles m_PipeHandles;
	CWinThread*  m_pThread;

	CTDVString		 m_csOutput;
	bool			 m_bOutputUpdatedSinceLastGet;
	UINT			 m_nNumLinesInLastUpdate;
	CCriticalSection m_OutputCriticalSection;

	UINT m_nMyNumber;

	bool m_bThreadMustEnd;
};

#endif // !defined(AFX_PROCESSRUNNER_H__A501C1DE_1D0D_4058_B70D_33BFC990DF42__INCLUDED_)
