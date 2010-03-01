// ProfileConnection.h: interface for the CProfileConnection class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_PROFILECONNECTION_H__14D25C59_BE37_44D2_AFDE_883DA08E2FD3__INCLUDED_)
#define AFX_PROFILECONNECTION_H__14D25C59_BE37_44D2_AFDE_883DA08E2FD3__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "TDVString.h"
#include "TDVDateTime.h"
#include "profileapi\profileapi\include\service.h"
#import "..\Reference DLLs\DnaIdentityWebServiceProxy.tlb" no_namespace

class CProfileConnectionPool;
class CProfileApi;
class CGI;

class CProfileConnection  
{
public:
	CProfileConnection();
	virtual ~CProfileConnection();

	enum eSignInType
	{
		SIT_PROFILEAPI,
		SIT_IDENTITY
	};

	virtual bool InitialiseConnection(CProfileConnectionPool* pOwningPool, CProfileApi* pProfile, bool bUseIdentityWebService, const TDVCHAR* sClientIPAddress);
	virtual bool IsInitialised();
	virtual bool ReleaseConnection();
	virtual bool SetService(const TDVCHAR* sSiteName, CGI* pCGI);
	virtual const TDVCHAR* GetUserName();
	virtual unsigned long GetUserId();
	virtual bool UpdateUserProfileValue(const TDVCHAR* sName, const TDVCHAR* sValue);
	virtual bool LoginUser(unsigned int& uiCanLogin);
	virtual bool GetUserProfileValue(const TDVCHAR* sName, CTDVString& sValue);
	virtual bool CheckUserIsLoggedIn(bool& bUserLoggedIn);
	virtual bool IsUserSignedIn(bool& bUserSignedIn);
	virtual bool SetUser(const TDVCHAR* sSsoCookie);
	virtual bool SetUserViaCookieAndUserName(const TDVCHAR* sSsoCookie, const TDVCHAR* sIdentityUserName);
	virtual const TDVCHAR* GetErrorMessage();
	virtual bool SetUser(const TDVCHAR* sUsername, const TDVCHAR* sPassword);
	virtual bool GetCookieValue(bool bRemember, CTDVString& sCookieValue);
	virtual bool AttributeExistsForService(const TDVCHAR* sAttributeName, bool* pbIsMandatory = NULL);
	virtual bool IsUsersEMailValidated(bool& bValidated);
	virtual bool GetServiceMinAndMaxAge(const char* pServiceName,int& nMinAge,int& nMaxAge);
	virtual eSignInType GetSignInType() { return SIT_PROFILEAPI; }

	virtual bool DoesAppNamedSpacedAttributeExist(const TDVCHAR* pAppNameSpace, const TDVCHAR* pAttributeName);
	virtual bool GetAppNamedSpacedAttribute(const TDVCHAR* pAppNameSpace, const TDVCHAR* pAttributeName, CTDVString& sValue);

	virtual const TDVCHAR* GetLastTimings();

protected:

	CProfileApi* m_pProfile;
	CProfileConnectionPool* m_pOwningPool;
	IDnaIdentityWebServiceProxyPtr m_pIdentityInteropPtr;
	CTDVDateTime m_DateCreated;
	CTDVString m_sServiceName;
	CTDVString m_sUserName;
	CTDVString m_sLastIdentityError;
	CTDVString m_sLastTimingInfo;
	CTDVString m_sCookieValue;
	DWORD m_dTimerStart;
	DWORD m_dTimerSplitTime;

	void AddTimingsInfo(const TDVCHAR* sInfo, bool bNewInfo);
};

#endif // !defined(AFX_PROFILECONNECTION_H__14D25C59_BE37_44D2_AFDE_883DA08E2FD3__INCLUDED_)
