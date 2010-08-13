// ProfileConnectionPool.cpp: implementation of the CProfileConnectionPool class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ProfileConnectionPool.h"
#include "ProfileConnection.h"
#include <ProfileApi.h>
#include "tdvassert.h"
//#include <atlbase.h>

//#import "DnaIdentityWebServiceProxy.tlb"

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
	//CoInitialize(NULL);   // Initialize COM Components
	InitializeCriticalSection(&m_criticalsection);
}

CProfileConnectionPool::~CProfileConnectionPool()
{
	while (!m_ProfileList.empty()) 
	{                      
		CProfileApi* pProfile = m_ProfileList.front();
		m_ProfileList.pop_front();
		CProfileApi::Destroy(pProfile);
	}

	DeleteCriticalSection(&m_criticalsection);
	//CoUninitialize();
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

	bool bCreateNew = true;
	CProfileApi* pProfile = NULL;
	try
	{
		// Check to see if we're using profile api or the identity websevice
		if (!bUseIdentitySignIn)
		{
			if (m_ProfileList.size() > 0)
			{
				pProfile = m_ProfileList.front();
				m_ProfileList.pop_front();
				bCreateNew = false;
			}
			
			if (bCreateNew)
			{	
				pProfile = CProfileApi::Create();
				if (!pProfile->Initialise(m_sConnectionFile))
				{
					TDVASSERT(false,"In ProfileConenctionPool::Initialise() failed to Initialise the Profile API");
					CProfileApi::Destroy(pProfile);
					Unlock();
					return false;
				}
			}
		}

		if (!Connection.InitialiseConnection(this, pProfile, bUseIdentitySignIn, sClientIPAddress, m_sDebugUserID))
		{
			if (pProfile != NULL)
			{
				CProfileApi::Destroy(pProfile);
				pProfile = NULL;
			}
			Unlock();
			return false;
		}
	}
	catch (...) 
	{
		if (pProfile != NULL)
		{
			CProfileApi::Destroy(pProfile);
			pProfile = NULL;
		}
		Unlock();
		return false;
	}
	
	Unlock();

	return true;

}

bool CProfileConnectionPool::ReleaseProfileConnection(CProfileApi* pProfile)
{
	if (pProfile == NULL)
	{
		return false;
	}
	Lock();

	try
	{
		//if there are too many available then delete this one
		//also if there are things in the list that 
		if (m_ProfileList.size() >= m_iMaxSize)
		{
			CProfileApi::Destroy(pProfile);
		}
		else
		{
			m_ProfileList.push_back(pProfile);
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

const void CProfileConnectionPool::Lock()
{
	EnterCriticalSection(&m_criticalsection);
}

const void CProfileConnectionPool::Unlock()
{
	LeaveCriticalSection(&m_criticalsection);
}

