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

#if !defined(AFX_PIPEHANDLES_H__A501C1DE_1D0D_4058_B70D_33BFC990DF42__INCLUDED_)
#define AFX_PIPEHANDLES_H__A501C1DE_1D0D_4058_B70D_33BFC990DF42__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <afxmt.h>
#include "XMLError.h"

class CPipeHandles : public CXMLError
{

public:
	CPipeHandles();
	~CPipeHandles();
	bool Create();

	void CloseAll();

	void Reset();

	void   SetOutputPipeWrite(HANDLE h)		{ m_hOutputPipeWrite = h; }
	HANDLE GetOutputPipeWrite()				{ return m_hOutputPipeWrite; }
	void   CloseOutputPipeWrite()			{ ::CloseHandle(m_hOutputPipeWrite); m_hOutputPipeWrite = NULL; }

	void   SetOutputPipeRead(HANDLE h)		{ m_hOutputPipeRead = h; }
	HANDLE GetOutputPipeRead()				{	return m_hOutputPipeRead; }
	void   CloseOutputPipeRead()			{ ::CloseHandle(m_hOutputPipeRead); m_hOutputPipeRead = NULL; }

	void   SetErrorPipeWrite(HANDLE h)		{ m_hErrorPipeWrite = h; }
	HANDLE GetErrorPipeWrite()				{	return m_hErrorPipeWrite; }
	void   CloseErrorPipeWrite()			{ ::CloseHandle(m_hErrorPipeWrite); m_hErrorPipeWrite = NULL; }

	void   SetInputPipeWrite(HANDLE h)		{ m_hInputPipeWrite = h; }
	HANDLE GetInputPipeWrite()				{	return m_hInputPipeWrite; }
	void   CloseInputPipeWrite()			{ ::CloseHandle(m_hInputPipeWrite); m_hInputPipeWrite = NULL; }

	void   SetInputPipeRead(	HANDLE h)	{ m_hInputPipeRead = h; }
	HANDLE GetInputPipeRead()				{ return m_hInputPipeRead; }
	void   CloseInputPipeRead(	)			{ ::CloseHandle(m_hInputPipeRead); m_hInputPipeRead = NULL; }

protected:
		bool HandleError(const TDVCHAR* pszAPI);

private:
	HANDLE m_hOutputPipeWrite;// The end of the pipe the child will write Standard Output to
	HANDLE m_hOutputPipeRead;	// The end of the pipe we will read the child's Standard output from
	HANDLE m_hErrorPipeWrite;	// A copy of hOutputPipeWrite, to give the child a Standard Error to write to

	HANDLE m_hInputPipeWrite;	// The end of the pipe we will write to, to give the child Standard Input
	HANDLE m_hInputPipeRead;	// The end of the pipe the child will read from to receive Standard Input
};

#endif // !defined(AFX_PIPEHANDLES_H__A501C1DE_1D0D_4058_B70D_33BFC990DF42__INCLUDED_)
