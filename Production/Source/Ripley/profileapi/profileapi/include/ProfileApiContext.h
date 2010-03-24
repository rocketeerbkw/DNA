#ifndef PROFILEAPICONTEXT_H
#define PROFILEAPICONTEXT_H

#include "ProfileApiBase.h"
#include <Str.h>
#include <ApiAccess.h>
#include <MiscUt.h>
#include <Service.h>
#include <Dll.h>

#define COOKIE_NAME					"SSO2-UID"		//do not change it.

/*******************************************************************************************
class CProfileApiContext : public CProfileApiBase
Author:		Igor Loboda
Created:	05/03/2003
Purpose:	holds context information: current user, current admin user, current service,
			current ip address, current service api access privileges.
*******************************************************************************************/

class DllExport CProfileApiContext : public CProfileApiBase
{
	protected:
		CStr m_IpAddress;
		CStr m_ForwardedFor;
			
	private:
		CStr m_CudId;
		unsigned long m_ulUserId;
		bool m_bUserIsAuthenticated;
		CStr m_UserName;
		CStr m_CookieValidationMark;
		CStr m_sRegistrationDate;
		bool m_bRememberMe;
		bool m_bRememberMeDefined;
		
		CStr m_AdminCudId;
		unsigned long m_ulAdminUserId;
		bool m_bAdminUserIsAuthenticated;
		CStr m_AdminUserName;
		
		bool m_bServiceIsSet;
		CService m_Service;

		CApiAccess m_ApiAccess;

		CStr m_sKey1;
		CStr m_sKey2;
		CStr m_sAdmKey1;
		CStr m_sAdmKey2;
		bool m_bKeysCached;
		bool m_bAdmKeysCached;

	public:
		CProfileApiContext();
	
		//
		//api access
		//
	
		bool IsAllowed(unsigned long ulPrivilege);
		void GetApiAccess(CApiAccess& access) const;
	
		
		//
		//ip address
		//
			
		void SetIpAddress(const char *pRemoteAddr, const char* pForwardedFor);
		void SetIpAddress(const char *pIpAddr);
		const char* GetIpAddress() const;
		const char* GetXForwardedFor() const;
		
		
		//
		//current service
		//
		
 		bool SetService(const char* pServiceName);
		bool IsServiceSet();
		unsigned long GetServiceId() const;
		const char* GetServiceName() const;
		const CService& GetService() const { return m_Service; }
		bool GetServiceRequiresSecureLogin() const;
		unsigned int GetServiceMinAge() const;
		unsigned int GetServiceMaxAge() const;

		
		//
		//User identification. 
		//

		bool SetUser(const char* pUserName, const char* pPassword);
		void UnsetUser();
		bool SetUser(const char* pCookieValue);
		bool SetUserByName(const char* pUserName);
		bool SetUserByCudId(const char* pCudId);
		bool SetUserById(unsigned long ulId);
		bool IsUserSet();
		const char* GetUserCudId() const;
		unsigned long GetUserId() const;
		const char* GetUserName() const;
		bool GetRememberMe();
		bool GetUserPassword(CStr& password);


		
		//
		//User identification. 
		//

		bool SetAdminUser(const char* pName, const char* pPassword1, const char* pPassword2, bool bSetUser = false);
		bool SetAdminUser(const char* pAdminCookieValue, bool bSetUser = false);
		bool SetAdminUserByName(const char* pAdminUserName, bool bSetUser = false);
		void UnsetAdminUser();
		bool IsAdminUserSet();
		const char* GetAdminUserCudId() const;
		unsigned long GetAdminUserId() const;
		const char* GetAdminUserName() const;
		

		static bool IsAdminUser(const char* pUserType);


		// Other user information

		const char* GetUserRegistrationDate() const { return m_sRegistrationDate; }
		
		
		//		
		//Cookies
		//
		
		static const char* GetCookieName();
		bool GetCookieValue(bool bRememberMe, CStr& cookieValue);
		static const char* GetAdminCookieName();
		bool GetAdminUserCookieValue(CStr& cookie);
				
	protected:
		void ReadService(CDBCursor& cursor, CService& service);
		bool GetCookieValue(const char* pCudId, bool bRememberMe, const char* pValidationMark, CStr& cookieValue);
		bool ServiceCanAccessAccount(const char* pAccountStatus);
		bool DoesPasswordMatch(const char* pPassword, const char* pEncodedPassword);
		bool AuthenticateAdminCookie(const char* pAdminCookieValue, CStr& sCudId);
		bool AuthenticateCookieValue(const char *pCookieValue, CStr& sCudId, bool& bRememberMe, 
			CStr& cookieValidationMark);
		bool CreateAdminMD5Hash(const char* pCudId, const char* pCreateDate, CStr& sHash);

	private:
		void SetUserAuthenticationInfo(CDBCursor& cursor);
		bool SetUser(CDBCursor& cursor, bool bCheckPassword, const char* pPassword, 
			const char* pCookieValidationMark);
		void SetAdminUserAuthenticationInfo(CDBCursor& cursor);
		bool SetAdminUser(CDBCursor& cursor, bool bCheckPassword, const char* pPassword1, const char* pPassword2);

		//cookie encryption keys
		bool GetCookieEncryptionKeys(CStr& sKey1, CStr& sKey2);
		bool GetAdmCookieEncryptionKeys(CStr& sKey1, CStr& sKey2);
};


/*******************************************************************************************
inline unsigned CProfileApiContext::GetServiceMinAge() const
Author:		Igor Loboda
Created:	21/01/2004
Visibility:	public
Returs:		minimum age allowed for the service
*******************************************************************************************/

inline unsigned CProfileApiContext::GetServiceMinAge() const
{
	return m_Service.GetMinAge();
}


/*******************************************************************************************
inline unsigned CProfileApiContext::GetServiceMaxAge() const
Author:		Igor Loboda
Created:	21/01/2004
Visibility:	public
Returs:		maximum age allowed for the service
*******************************************************************************************/

inline unsigned CProfileApiContext::GetServiceMaxAge() const
{
	return m_Service.GetMaxAge();
}


/*******************************************************************************************
inline const char* CProfileApiContext::GetServiceName() const
Author:		Igor Loboda
Created:	21/04/2003
Visibility:	public
Returns:	current service (SetService) name
*******************************************************************************************/

inline const char* CProfileApiContext::GetServiceName() const
{
	assert(m_bServiceIsSet);
	return m_Service.GetName();
}


/*******************************************************************************************
inline const char* CProfileApiContext::GetIpAddress() const
Author:		Igor Loboda
Created:	09/04/2003
Visibility:	public
Returns:	ip address previously set by SetIpAddress
*******************************************************************************************/

inline const char* CProfileApiContext::GetIpAddress() const
{
	return m_IpAddress;
}


/*******************************************************************************************
inline const char* CProfileApiContext::GetXForwardedFor() const
Author:		Igor Loboda
Created:	03/12/2003
Visibility:	public
Returns:	value of HTTP_X_FORWARDED_FOR as passed to SetIpAddress
*******************************************************************************************/

inline const char* CProfileApiContext::GetXForwardedFor() const
{
	return m_ForwardedFor;
}


/*******************************************************************************************
inline unsigned long CProfileApiContext::GetServiceId() const
Author:		Igor Loboda
Created:	19/05/2003
Visibility:	public
Returns:	the current service id of the service set by the call to SetService
*******************************************************************************************/

inline unsigned long CProfileApiContext::GetServiceId() const
{
	assert(m_bServiceIsSet);
	return m_Service.GetId();
}


/*******************************************************************************************
inline bool CProfileApiContext::GetServiceRequiresSecureLogin() const
Author:		Igor Loboda
Created:	19/05/2003
Visibility:	public
Returns:	true if the current service (SetService) rquires sequre login
*******************************************************************************************/

inline bool CProfileApiContext::GetServiceRequiresSecureLogin() const
{
	assert(m_bServiceIsSet);
	return m_Service.GetRequiresSecureLogin();
}


/*******************************************************************************************
void CProfileApiContext::GetApiAccess(CApiAccess& access) const
Author:		Igor Loboda
Created:	27/05/2003
Visibility:	public
Outputs:	current service api access privileges
*******************************************************************************************/

inline void CProfileApiContext::GetApiAccess(CApiAccess& access) const
{
	assert(m_bServiceIsSet);
	access = m_ApiAccess;
}


/*******************************************************************************************
inline unsigned long CProfileApiContext::GetUserId() const
Author:		Igor Loboda
Created:	13/03/2003
Visibility:	public
Returns:	current user id
Purpose:	does not check if there was a call to SetUser() before.
*******************************************************************************************/

inline unsigned long CProfileApiContext::GetUserId() const
{
	assert(m_ulUserId);
	return m_ulUserId;
}


/*******************************************************************************************
inline unsigned long CProfileApiContext::GetAdminUserId() const
Author:		Igor Loboda
Created:	15/03/2003
Visibility:	public
Returns:	current admin user id
Purpose:	does not check if there was a call to SetUser() before.
*******************************************************************************************/

inline unsigned long CProfileApiContext::GetAdminUserId() const
{
	assert(m_ulAdminUserId);
	return m_ulAdminUserId;
}

/*******************************************************************************************
inline const char* CProfileApiContext::GetUserCudId()
Author:		Igor Loboda
Created:	29/05/2003
Visibility:	public
Returns:	current user (SetUser) cud id
*******************************************************************************************/

inline const char* CProfileApiContext::GetUserCudId() const
{
	assert(m_ulUserId);
	return m_CudId;
}


/*******************************************************************************************
inline const char* CProfileApiContext::GetUserName() const
Author:		Igor Loboda
Created:	24/08/2003
Visibility:	public
Returns:	current user (SetUser) name. Note that name is cached and to reload it from the
			database SetUser should be called
*******************************************************************************************/

inline const char* CProfileApiContext::GetUserName() const
{
	assert(m_ulUserId);
	return m_UserName;
}


/*******************************************************************************************
inline const char* CProfileApiContext::GetAdminUserName() const
Author:		Igor Loboda
Created:	24/08/2003
Visibility:	public
Returns:	current admin user (SetAdminUser) name. Note that name is cached and to reload it from the
			database SetAdminUser should be called
*******************************************************************************************/

inline const char* CProfileApiContext::GetAdminUserName() const
{
	assert(m_ulAdminUserId);
	return m_AdminUserName;
}


/*******************************************************************************************
inline const char* CProfileApiContext::GetAdminUserCudId()
Author:		Igor Loboda
Created:	29/05/2003
Visibility:	public
Returns:	current admin user (SetAdminUser) cud id
*******************************************************************************************/

inline const char* CProfileApiContext::GetAdminUserCudId() const
{
	assert(m_ulAdminUserId);
	return m_AdminCudId;
}


/*******************************************************************************************
static inline const char* CProfileApiContext::GetCookieName()
Author:		Igor Loboda
Created:	14/04/2003
Visibility:	public
Returns:	user cookie name
*******************************************************************************************/

inline const char* CProfileApiContext::GetCookieName()
{
	return COOKIE_NAME;
}


/*******************************************************************************************
static inline const char* CProfileApiContext::GetAdminCookieName()
Author:		Igor Loboda
Created:	05/03/2003
Visibility:	public
Returns:	Admin cookie name
Purpose:	Do not ever delete returned pointer.
*******************************************************************************************/

inline const char* CProfileApiContext::GetAdminCookieName()
{
	return ADMIN_COOKIE_NAME;
}


/*********************************************************************************
inline bool CProfileApiContext::GetRememberMe()

Author:		Igor Loboda
Created:	31/07/2003
Visibility:	public
Returns:	Remember me flag encoded in user's cookie. You must call SetUser(cookie) before calling this one
*********************************************************************************/

inline bool CProfileApiContext::GetRememberMe()
{
	assert(m_bRememberMeDefined);
	return m_bRememberMe;
}


#endif
