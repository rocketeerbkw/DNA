// ProfileConnectionPool.h: interface for the CProfileConnectionPool class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_PROFILECONNECTIONPOOL_H__B71A4195_6900_49FC_9BC7_A89B0BFFBAA4__INCLUDED_)
#define AFX_PROFILECONNECTIONPOOL_H__B71A4195_6900_49FC_9BC7_A89B0BFFBAA4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <list>
#include "TDVString.h"
using namespace std;

class CProfileConnection;

class CProfileConnectionPool  
{
public:
	CProfileConnectionPool(const TDVCHAR* sConnectionFile, const TDVCHAR* sIdentityWebServiceUri);
	virtual ~CProfileConnectionPool();
	bool GetConnection(CProfileConnection& Connection, bool bUseIdentitySignIn, const TDVCHAR* sClientIPAddress);
	bool ReleaseProfileConnection();
	CTDVString GetIdentityWebServiceUri();
	const void Unlock();
	const void Lock();
	void SetDebugMode(CTDVString sDebugUserID) { m_sDebugUserID = sDebugUserID; }

protected:
	CTDVString m_sConnectionFile;
	CTDVString m_sIdentityWebServiceUri;
	int m_iNumActive;
	int m_iMaxSize;
	CRITICAL_SECTION m_criticalsection;
	CTDVString m_sDebugUserID;
};

#endif // !defined(AFX_PROFILECONNECTIONPOOL_H__B71A4195_6900_49FC_9BC7_A89B0BFFBAA4__INCLUDED_)
