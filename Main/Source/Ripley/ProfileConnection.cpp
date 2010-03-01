// ProfileConnection.cpp: implementation of the CProfileConnection class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ProfileConnection.h"
#include "ProfileConnectionPool.h"
#include <ProfileApi.h>
#include "CGI.h"
#include "tdvassert.h"
#include "XmlObject.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CProfileConnection::CProfileConnection()
:m_pProfile(NULL),
m_pOwningPool(NULL),
m_pIdentityInteropPtr(NULL),
m_dTimerStart(0),
m_dTimerSplitTime(0)
{

}

CProfileConnection::~CProfileConnection()
{
	ReleaseConnection();
}

const TDVCHAR* CProfileConnection::GetLastTimings()
{
	return m_sLastTimingInfo;
}

void CProfileConnection::AddTimingsInfo(const TDVCHAR* sInfo, bool bNewInfo)
{
	DWORD dCurTime = GetTickCount();
	if (bNewInfo)
	{
		m_dTimerStart = dCurTime;
		m_dTimerSplitTime = dCurTime;
		m_sLastTimingInfo = "";
	}
	else
	{
		m_sLastTimingInfo << " : ";
	}
	m_sLastTimingInfo << sInfo << " " << (long)(dCurTime - m_dTimerStart) << " (" << (long)(dCurTime - m_dTimerSplitTime) << ")";
	m_dTimerSplitTime = dCurTime;
}

bool CProfileConnection::InitialiseConnection(CProfileConnectionPool* pOwningPool,
											  CProfileApi* pProfile,
											  bool bUseIdentityWebService,
											  const TDVCHAR* sClientIPAddress)
{
	AddTimingsInfo("InitialiseConnection",true);

	bool bInitialised = false;
	if (pOwningPool == NULL && pProfile == NULL && !bUseIdentityWebService)
	{
		AddTimingsInfo("Already Initialized",false);
		return bInitialised;
	}

	if (bUseIdentityWebService)
	{
		try
		{
			// Create a new connection to use
			AddTimingsInfo("Using Identity",false);
			CoInitialize(NULL);
			AddTimingsInfo("CoInitialized",false);
			//HRESULT hr = m_pIdentityInteropPtr.CreateInstance(__uuidof(DnaIdentityWebServiceProxy));
			HRESULT hr = m_pIdentityInteropPtr.CreateInstance(__uuidof(IdentityRestSignIn));
			
			if (FAILED(hr))
			{
				m_sLastIdentityError = CTDVString("Failed to create instance of Identity SignIn Proxy - HRESULT : ") << hr;
				AddTimingsInfo("CreateInstance failed",false);
				return bInitialised;
			}
			AddTimingsInfo("Created Instance",false);

			CTDVString sIdURL = pOwningPool->GetIdentityWebServiceUri();
			_bstr_t sIdentityUri(sIdURL);
			_bstr_t sIPAddress(sClientIPAddress);
			variant_t ok = m_pIdentityInteropPtr->Initialise(sIdentityUri, sIPAddress);
			bInitialised = ok.boolVal;
			if (!bInitialised)
			{
				USES_CONVERSION;
				m_sLastIdentityError = W2A(m_pIdentityInteropPtr->GetLastError());
				AddTimingsInfo(W2A(m_pIdentityInteropPtr->GetLastTimingInfo()),false);
			}
			AddTimingsInfo("Initialised",false);
		}
		catch (...)
		{
			AddTimingsInfo("Exception thrown",false);
			m_sLastIdentityError = CTDVString("Unknown Exception Thrown!");
			return bInitialised;
		}
	}
	else
	{
		bInitialised = true;
	}

	m_pOwningPool = pOwningPool;
	m_pProfile = pProfile;
	m_DateCreated = CTDVDateTime::GetCurrentTime();
	AddTimingsInfo("InitialiseConnection finished",false);

	return bInitialised;
}


bool CProfileConnection::IsInitialised()
{
	return (NULL != m_pOwningPool && (m_pProfile != NULL || m_pIdentityInteropPtr != NULL)); 
}
	
bool CProfileConnection::ReleaseConnection()
{
	if (!IsInitialised())
	{
		return true;
	}

	if (m_pProfile != NULL && m_pOwningPool->ReleaseProfileConnection(m_pProfile))
	{
		m_pProfile = NULL;
		m_pOwningPool = NULL;
		return true;
	}
	
	if (m_pIdentityInteropPtr != NULL)
	{
		m_pIdentityInteropPtr.Release();
		m_pOwningPool = NULL;
		CoUninitialize();
		return true;
	}

	return false;
}

bool CProfileConnection::SetService(const TDVCHAR* sSiteName, CGI* pCGI)
{
	bool bSuccess = false;
	
	if (m_pIdentityInteropPtr != NULL)
	{
		HRESULT hr;
		try
		{
			_bstr_t service(sSiteName);
			hr = m_pIdentityInteropPtr->SetService(service);
			m_sServiceName = sSiteName;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to set the service policy value";
			m_sServiceName = "";
		}
		
		bSuccess = SUCCEEDED(hr);
	}
	else if (m_pProfile != NULL)
	{
		bSuccess = m_pProfile->SetService(sSiteName);
		if (!bSuccess)
		{
			CTDVString sError = "CProfileConnection::SetService - ";
			sError << m_pProfile->GetErrorMessage();
			TDVASSERT(false,sError);
			pCGI->WriteInputLog("SSOERROR - " + sError);

			m_pProfile->Disconnect();
			bSuccess = m_pProfile->SetService(sSiteName);
		}
	}

	return bSuccess;
}

const TDVCHAR* CProfileConnection::GetUserName()
{
	if (m_pIdentityInteropPtr != NULL)
	{
		try
		{
			USES_CONVERSION;
			m_sUserName = W2A(m_pIdentityInteropPtr->GetLoginName());
			return m_sUserName;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to get user name";
		}
	}
	else if (m_pProfile != NULL)
	{
		return m_pProfile->GetUserName();
	}
	return NULL;
}

unsigned long CProfileConnection::GetUserId()
{
	if (m_pIdentityInteropPtr != NULL)
	{
		try
		{
			unsigned long id = m_pIdentityInteropPtr->GetUserID();
			return id;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to get user id";
		}
	}
	else if (m_pProfile != NULL)
	{
		return m_pProfile->GetUserId();
	}
	return 0;
}
	
bool CProfileConnection::UpdateUserProfileValue(const TDVCHAR* sName, const TDVCHAR* sValue)
{
	if (m_pIdentityInteropPtr != NULL)
	{
		TDVASSERT(false,"We don't do updates to users details in Identity");
	}
	else if (m_pProfile != NULL)
	{
		return m_pProfile->UpdateUserProfileTextValue(sName,sValue);
	}
	return false;
}

	
bool CProfileConnection::LoginUser(unsigned int& uiCanLogin)
{
	if (m_pIdentityInteropPtr != NULL)
	{
		try
		{
			return _variant_t(m_pIdentityInteropPtr->LoginUser());
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to get logged in status";
		}
	}
	else if (m_pProfile != NULL)
	{
		return m_pProfile->LoginUser(uiCanLogin);
	}
	return false;
}
	
bool CProfileConnection::GetUserProfileValue(const TDVCHAR* sName, CTDVString& sValue)
{
	AddTimingsInfo("GetUserProfileValue",true);
	bool bSuccess = false;
	if (m_pIdentityInteropPtr != NULL)
	{
		AddTimingsInfo("Using Identity",false);
		try
		{
			USES_CONVERSION;
			sValue = W2A(m_pIdentityInteropPtr->GetUserAttribute(_bstr_t(sName)));
			bSuccess = true;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to get user attribute";
		}
	}
	else if (m_pProfile != NULL)
	{
		AddTimingsInfo("Using ProfileAPI",false);
		CProfileValue ProfileValue;
		if (m_pProfile->GetUserProfileValue(sName,ProfileValue))
		{
			sValue = ProfileValue.GetTextValue();
			bSuccess = true;
		}
	}
	AddTimingsInfo("Finished getting value",false);

	return bSuccess;
}

/*********************************************************************************

	bool CProfileConnection::IsUsersEMailValidated(bool& bValidated)

		Author:		Mark Howitt
        Created:	21/09/2004
        Inputs:		-
        Outputs:	bValidated - a flag that takes the value of the validation state
        Returns:	true if ok, false if not
        Purpose:	Checks the profiler to see if the users email is valid

*********************************************************************************/
bool CProfileConnection::IsUsersEMailValidated(bool& bValidated)
{
	if (m_pIdentityInteropPtr != NULL)
	{
		TDVASSERT(false,"Identity does not support this feature. Returning true for now");
		bValidated = true;
		return true;
	}
	else if (m_pProfile != NULL)
	{
		CProfileValue ProfileValue;
		if (m_pProfile->GetUserProfileValue("email",ProfileValue))
		{
			bValidated = ProfileValue.GetIsValidated();
			return true;
		}
	}

	return false;
}

bool CProfileConnection::SetUser(const TDVCHAR* sSsoCookie)
{
	AddTimingsInfo("SetUser",true);
	if (m_pIdentityInteropPtr != NULL)
	{
		try
		{
			AddTimingsInfo("Using Identity",false);
			bool bLoggedIn = _variant_t(m_pIdentityInteropPtr->TrySetUserViaCookie(_bstr_t(sSsoCookie)));
			USES_CONVERSION;
			CTDVString sInfo = "(.net) ";
			sInfo << W2A(m_pIdentityInteropPtr->GetLastTimingInfo()) << "(.net)";
			sInfo << "Version:" << W2A(m_pIdentityInteropPtr->GetVersion()) << " ";
			AddTimingsInfo(sInfo,false);
			AddTimingsInfo("Finished Setting User",false);
			return bLoggedIn;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to set the user via cookie";
		}
	}
	else if (m_pProfile != NULL)
	{
		AddTimingsInfo("Using ProfileAPI",false);
		bool bLoggedIn = m_pProfile->SetUser(sSsoCookie);
		AddTimingsInfo("Finished Setting User",false);
		return bLoggedIn;
	}
	return false;
}

bool CProfileConnection::SetUser(const TDVCHAR* sUsername, const TDVCHAR* sPassword)
{
	if (m_pIdentityInteropPtr != NULL)
	{
		try
		{
			bool bOK = _variant_t(m_pIdentityInteropPtr->TrySetUserViaUserNamePassword(_bstr_t(sUsername),_bstr_t(sPassword)));
			return bOK;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to set user via username and password";
		}
	}
	else if (m_pProfile != NULL)
	{
		return m_pProfile->SetUser(sUsername, sPassword);		
	}

	return false;
}

bool CProfileConnection::SetUserViaCookieAndUserName(const TDVCHAR* sSsoCookie, const TDVCHAR* sIdentityUserName)
{
	AddTimingsInfo("SetUser",true);
	if (m_pIdentityInteropPtr != NULL)
	{
		try
		{
			AddTimingsInfo("Using Identity",false);
			bool bLoggedIn = _variant_t(m_pIdentityInteropPtr->TrySetUserViaCookieAndUserName(_bstr_t(sSsoCookie),_bstr_t(sIdentityUserName)));
			USES_CONVERSION;
			
			CTDVString sInfo = "(.net) ";
			sInfo << "Version:" << W2A(m_pIdentityInteropPtr->GetVersion()) << " ";
			//sInfo << "Info:" << W2A(m_pIdentityInteropPtr->GetLastTimingInfo());
			AddTimingsInfo(sInfo << "(.net)",false);
			AddTimingsInfo("Finished Setting User",false);
			m_sCookieValue = sSsoCookie;
			return bLoggedIn;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to set the user via cookie";
		}
	}
	else if (m_pProfile != NULL)
	{
		AddTimingsInfo("Using ProfileAPI",false);
		bool bLoggedIn = m_pProfile->SetUser(sSsoCookie);
		AddTimingsInfo("Finished Setting User",false);
		return bLoggedIn;
	}
	return false;
}

bool CProfileConnection::GetCookieValue(bool bRemember, CTDVString& sCookieValue)
{
	if (m_pIdentityInteropPtr != NULL)
	{
		try
		{
			USES_CONVERSION;
			sCookieValue = W2A(m_pIdentityInteropPtr->GetCookieValue);
			return true;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to get user cookie value";
		}
	}
	else if (m_pProfile != NULL)
	{
		CStr sValue;
		if (m_pProfile->GetCookieValue(bRemember,sValue))
		{
			sCookieValue = sValue.GetStr();
			return true;
		}
	}

	return false;
}

bool CProfileConnection::AttributeExistsForService(const TDVCHAR* sAttributeName, bool* pbIsMandatory)
{
	if (m_pIdentityInteropPtr != NULL)
	{
		try
		{
			return _variant_t(m_pIdentityInteropPtr->DoesAttributeExistForService(_bstr_t(m_sServiceName),_bstr_t(sAttributeName)));
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed checking for attribute exists";
		}
	}
	else if (m_pProfile != NULL)
	{
		CServiceAttribute attr;
		if (m_pProfile->GetServiceAttribute(sAttributeName,attr))
		{
			if (pbIsMandatory != NULL)
			{
				*pbIsMandatory = attr.GetIsMandatory();
			}
			return true;
		}
		
		if (pbIsMandatory != NULL)
		{
			*pbIsMandatory = false;
		}
	}

	return false;
}

bool CProfileConnection::CheckUserIsLoggedIn(bool& bUserLoggedIn)
{
	bool bSuccess = false;
	if (m_pIdentityInteropPtr != NULL)
	{
		try
		{
			bUserLoggedIn = _variant_t(m_pIdentityInteropPtr->IsUserLoggedIn);
			bSuccess = true;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed checking if user logged in";
		}
	}
	else if (m_pProfile != NULL)
	{
		bSuccess = m_pProfile->CheckUserIsLoggedIn(bUserLoggedIn);
	}
	return bSuccess;
}

bool CProfileConnection::IsUserSignedIn(bool& bUserSignedIn)
{
	bool bSuccess = false;
	if (m_pIdentityInteropPtr != NULL)
	{
		try
		{
			bUserSignedIn = _variant_t(m_pIdentityInteropPtr->IsUserSignedIn);
			bSuccess = true;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed checking if user signed in";
		}
	}
	else if (m_pProfile != NULL)
	{
		// ProfileAPI just uses the Logged in value
		bSuccess = m_pProfile->CheckUserIsLoggedIn(bUserSignedIn);
	}
	return bSuccess;
}

const TDVCHAR* CProfileConnection::GetErrorMessage()
{
	if (m_sLastIdentityError != "")
	{
		return m_sLastIdentityError;
	}
	else if (m_pProfile != NULL)
	{
		return m_pProfile->GetErrorMessage();
	}
	return "uninitialised connection";
}

/*********************************************************************************

	bool CProfileConnection::GetServiceMinAndMaxAge(const char* pServiceName,int& nMinAge,int& nMaxAge)

		Author:		Mark Neves
		Created:	25/09/2006
		Inputs:		pServiceName = the name of the service (equates to the URLName of the DNA site)
		Outputs:	nMinAge contains the min age for the service
					nMaxAge contains the max age for the service
		Returns:	-
		Purpose:	A Ronseal-class function :-)

*********************************************************************************/

bool CProfileConnection::GetServiceMinAndMaxAge(const char* pServiceName,int& nMinAge,int& nMaxAge)
{
	if (IsInitialised())
	{
		CService service;
		if (m_pProfile->GetServiceInfo(pServiceName,service))
		{
			nMinAge = service.GetMinAge();
			nMaxAge = service.GetMaxAge();
			return true;
		}
	}

	return false;
}

bool CProfileConnection::DoesAppNamedSpacedAttributeExist(const TDVCHAR* pAppNameSpace, const TDVCHAR* pAttributeName)
{
	if (m_pIdentityInteropPtr != NULL)
	{
		AddTimingsInfo("Using Identity",false);
		try
		{
			USES_CONVERSION;
			return _variant_t(m_pIdentityInteropPtr->DoesAppNameSpacedAttributeExist(_bstr_t(m_sCookieValue),_bstr_t(pAppNameSpace),_bstr_t(pAttributeName)));
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to get user attribute";
		}
	}
	else if (m_pProfile != NULL)
	{
		AddTimingsInfo("Using ProfileAPI - Not supported!",false);
	}
	return false;
}

bool CProfileConnection::GetAppNamedSpacedAttribute(const TDVCHAR* pAppNameSpace, const TDVCHAR* pAttributeName, CTDVString& sValue)
{
	AddTimingsInfo("GetAppNamedSpacedAttribute",true);
	bool bSuccess = false;
	if (m_pIdentityInteropPtr != NULL)
	{
		AddTimingsInfo("Using Identity",false);
		try
		{
			USES_CONVERSION;
			sValue = W2A(m_pIdentityInteropPtr->GetAppNameSpacedAttribute(_bstr_t(m_sCookieValue),_bstr_t(pAppNameSpace),_bstr_t(pAttributeName)));
			bSuccess = true;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to get user attribute";
		}
	}
	else if (m_pProfile != NULL)
	{
		AddTimingsInfo("Using ProfileAPI - Not supported!",false);
		bSuccess = false;
	}
	AddTimingsInfo("Finished getting value",false);

	return bSuccess;
}
