// ProfileConnection.cpp: implementation of the CProfileConnection class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ProfileConnection.h"
#include "ProfileConnectionPool.h"
#include "CGI.h"
#include "tdvassert.h"
#include "XmlObject.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CProfileConnection::CProfileConnection()
:m_pOwningPool(NULL),
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
											  bool bUseIdentityWebService,
											  const TDVCHAR* sClientIPAddress,
											  CTDVString sDebugUserID)
{
	AddTimingsInfo("InitialiseConnection",true);

	bool bInitialised = false;

	if (bUseIdentityWebService)
	{
		bool bError = false;
		try
		{
			// Create a new connection to use
			AddTimingsInfo("Using Identity",false);
			CoInitialize(NULL);
			AddTimingsInfo("CoInitialized",false);
			HRESULT hr = NULL;

			if (!sDebugUserID.IsEmpty())
			{
				hr = m_pIdentityInteropPtr.CreateInstance(__uuidof(IdentityDebugSigninComponent));
			}
			else
			{
				hr = m_pIdentityInteropPtr.CreateInstance(__uuidof(IdentityRestSignIn));
			}

			if (FAILED(hr))
			{
				m_sLastIdentityError = CTDVString("Failed to create instance of Identity SignIn Proxy - HRESULT : ") << hr;
				AddTimingsInfo("CreateInstance failed",false);
				return bInitialised;
			}
			AddTimingsInfo("Created Instance",false);

			if (!sDebugUserID.IsEmpty())
			{
				_bstr_t sBSTRUserID(sDebugUserID);
				m_pIdentityInteropPtr->Initialise(sBSTRUserID, _bstr_t(""));
				bInitialised = true;
			}
			else
			{
				CTDVString sIdURL = pOwningPool->GetIdentityWebServiceUri();
				_bstr_t sIdentityUri(sIdURL);
				_bstr_t sIPAddress(sClientIPAddress);
				bInitialised = variant_t(m_pIdentityInteropPtr->Initialise(sIdentityUri, sIPAddress));
			}
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
			bError = true;
		}

		if (bError)
		{
			USES_CONVERSION;
			m_sLastIdentityError = W2A(m_pIdentityInteropPtr->GetLastError());
			AddTimingsInfo("Exception thrown - " + m_sLastIdentityError,false);
			return bInitialised;
		}
	}
	else
	{
		bInitialised = true;
	}

	m_pOwningPool = pOwningPool;
	m_DateCreated = CTDVDateTime::GetCurrentTime();
	AddTimingsInfo("InitialiseConnection finished",false);

	return bInitialised;
}


bool CProfileConnection::IsInitialised()
{
	return (NULL != m_pOwningPool && m_pIdentityInteropPtr != NULL); 
}
	
bool CProfileConnection::ReleaseConnection()
{
	if (!IsInitialised())
	{
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
	return NULL;
}

const TDVCHAR* CProfileConnection::GetUserId()
{
	if (m_pIdentityInteropPtr != NULL)
	{
		try
		{
			USES_CONVERSION;
			m_sSignInUserId = W2A(m_pIdentityInteropPtr->GetUserID());
			return m_sSignInUserId;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to get user id";
		}
	}
	return NULL;
}
	
bool CProfileConnection::UpdateUserProfileValue(const TDVCHAR* sName, const TDVCHAR* sValue)
{
	if (m_pIdentityInteropPtr != NULL)
	{
		TDVASSERT(false,"We don't do updates to users details in Identity");
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
	AddTimingsInfo("Finished getting value",false);

	return bSuccess;
}

const WCHAR* CProfileConnection::GetUserDisplayNameUniCode()
{
	AddTimingsInfo("GetUserProfileValue",true);
	if (m_pIdentityInteropPtr != NULL)
	{
		AddTimingsInfo("Using Identity",false);
		try
		{
			return m_pIdentityInteropPtr->GetUserAttribute(_bstr_t("displayname"));
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to get user attribute";
		}
	}
	return NULL;
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
	return false;
}

bool CProfileConnection::SecureSetUserViaCookies(const TDVCHAR* sCookie, const TDVCHAR* sSecureCookie)
{
	AddTimingsInfo("SecureSetUserViaCookies",true);
	if (m_pIdentityInteropPtr != NULL)
	{
		try
		{
			AddTimingsInfo("Using Identity",false);
			bool bLoggedIn = _variant_t(m_pIdentityInteropPtr->TrySecureSetUserViaCookies(_bstr_t(sCookie),_bstr_t(sSecureCookie)));
			USES_CONVERSION;
			
			CTDVString sInfo = "(.net) ";
			sInfo << "Version:" << W2A(m_pIdentityInteropPtr->GetVersion()) << " ";
			AddTimingsInfo(sInfo << "(.net)",false);
			AddTimingsInfo("Finished Secure Setting User",false);
			m_sCookieValue = sCookie;
			m_sSecureCookieValue = sSecureCookie;
			return bLoggedIn;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to securely set the user via the cookies";
		}
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
	return false;
}

bool CProfileConnection::GetSecureCookieValue(CTDVString& sSecureCookieValue)
{
	if (m_pIdentityInteropPtr != NULL)
	{
		try
		{
			USES_CONVERSION;
			sSecureCookieValue = W2A(m_pIdentityInteropPtr->GetSecureCookieValue);
			return true;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed to get secure user cookie value";
		}
	}
	return false;
}

bool CProfileConnection::IsSecureRequest(bool& bSecureRequest)
{
	bool bSuccess = false;
	if (m_pIdentityInteropPtr != NULL)
	{
		try
		{
			bSecureRequest = _variant_t(m_pIdentityInteropPtr->IsSecureRequest);
			bSuccess = true;
		}
		catch(...)
		{
			m_sLastIdentityError = "Failed checking if the request is a Secure request";
		}
	}
	return bSuccess;
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
	return bSuccess;
}

const TDVCHAR* CProfileConnection::GetErrorMessage()
{
	if (m_sLastIdentityError != "")
	{
		return m_sLastIdentityError;
	}
	return "uninitialised connection";
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
	AddTimingsInfo("Finished getting value",false);
	return bSuccess;
}
