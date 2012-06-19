// ProfileConnectionPool.cpp: implementation of the CProfileConnectionPool class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ProfileConnectionPool.h"
#include "ProfileConnection.h"
#include "tdvassert.h"
//#include <atlbase.h>

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CProfileConnectionPool::CProfileConnectionPool(const TDVCHAR* sConnectionFile, const TDVCHAR* sIdentityWebServiceUri)
:m_iNumActive(0),
 m_iMaxSize(50),
 m_sConnectionFile(sConnectionFile),
 m_sIdentityWebServiceUri(sIdentityWebServiceUri)
{
	InitializeCriticalSection(&m_criticalsection);
}

CProfileConnectionPool::~CProfileConnectionPool()
{
	DeleteCriticalSection(&m_criticalsection);
}

CTDVString CProfileConnectionPool::GetIdentityWebServiceUri()
{
	return m_sIdentityWebServiceUri;
}

bool CProfileConnectionPool::GetConnection(CProfileConnection& Connection, bool bUseIdentitySignIn, const TDVCHAR* sClientIPAddress)
{
	if (Connection.IsInitialised())
	{
		return true;
	}

	Lock();
	try
	{
		if (!Connection.InitialiseConnection(this, bUseIdentitySignIn, sClientIPAddress, m_sDebugUserID))
		{
			Unlock();
			return false;
		}
	}
	catch (...) 
	{
		Unlock();
		return false;
	}
	
	Unlock();
	return true;

}

bool CProfileConnectionPool::ReleaseProfileConnection()
{
	return true;
}

const void CProfileConnectionPool::Lock()
{
	EnterCriticalSection(&m_criticalsection);
}

const void CProfileConnectionPool::Unlock()
{
	LeaveCriticalSection(&m_criticalsection);
}

