#ifndef SERVICE_H
#define SERVICE_H

#include "..\..\bbcutil\include\Str.h"
#include "..\..\bbcutil\include\SimpleTemplates.h"
#include "..\..\bbcutil\include\Dll.h"


/*********************************************************************************
class CService
Author:		Igor Loboda
Created:	23/05/2003
Purpose:	Stores data about a service
*********************************************************************************/

class DllExport CService
{
	protected:
		unsigned long m_ulId;
		int m_MinAge;
		int m_MaxAge;
		CStr m_Name;
		CStr m_Description;
		bool m_bRequiresSecureLogin;
		CStr m_Url;
		CStr m_ApiAccess;
		CStr m_CreateDate;
		CStr m_Tag;
		bool m_bCanAccessUnregisteredUsers;
		bool m_bAutoLogout;
		
	public:
		CService();
		virtual ~CService() {;}
		virtual void Clear();
		
		void SetId(unsigned long ulId);
		void SetName(const char* pName);
		void SetDescription(const char* pDescription);
		void SetRequiresSecureLogin(bool bSecure);
		void SetUrl(const char* pUrl);
		void SetApiAccess(const char* pAccess);
		void SetCreateDate(const char* pCreateDate);
		void SetMinAge(int minAge);
		void SetMaxAge(int maxAge);
		void SetTag(const char* pTag);
		void SetCanAccessUnregisteredUsers(bool bCanAccess);
		void SetAutoLogout(bool bAutoLogout);
		
		unsigned long GetId() const;
		const char* GetName() const;
		const char* GetDescription() const;
		bool GetRequiresSecureLogin() const;
		const char* GetUrl() const;
		const char* GetApiAccess() const;
		const char* GetCreateDate() const;
		int GetMinAge() const;
		int GetMaxAge() const;
		const char* GetTag() const;
		bool GetCanAccessUnregisteredUsers() const;
		bool GetAutoLogout() const { return m_bAutoLogout; }
};


/*********************************************************************************
inline int CService::GetMinAge() const
Author:		Igor Loboda
Created:	20/11/2003
Visibility:	public
Returns:	minimum age when a user may use the service.
*********************************************************************************/

inline int CService::GetMinAge() const
{
	return m_MinAge;
}


/*********************************************************************************
inline bool CService::GetCanAccessUnregisteredUsers() const
Author:		Igor Loboda
Created:	01/12/2004
Visibility:	public
Returns:	true if the service can access user's data if the user
			is not registered with the service
*********************************************************************************/

inline bool CService::GetCanAccessUnregisteredUsers() const
{
	return m_bCanAccessUnregisteredUsers;
}

/*********************************************************************************
inline int CService::GetMaxAge() const
Author:		Igor Loboda
Created:	20/11/2003
Visibility:	public
Returns:	maximum age when a user may use the service.
*********************************************************************************/

inline int CService::GetMaxAge() const
{
	return m_MaxAge;
}


/*********************************************************************************
inline unsigned long CService::GetId() const;
Author:		Igor Loboda
Created:	23/05/2003
Visibility:	public
Returns:	service id
*********************************************************************************/

inline unsigned long CService::GetId() const
{
	return m_ulId;
}


/*********************************************************************************
inline const char* CService::GetName() const
Author:		Igor Loboda
Created:	23/05/2003
Visibility:	public
Returns:	service name
*********************************************************************************/

inline const char* CService::GetName() const
{
	return m_Name;
}


/*********************************************************************************
inline const char* CService::GetDescription() const
Author:		Igor Loboda
Created:	23/05/2003
Visibility:	public
Returns:	service description
*********************************************************************************/

inline const char* CService::GetDescription() const
{
	return m_Description;
}


/*********************************************************************************
inline bool CService::GetRequiresSecureLogin() const
Author:		Igor Loboda
Created:	23/05/2003
Visibility:	public
Returns:	true if the service requires secure login
*********************************************************************************/

inline bool CService::GetRequiresSecureLogin() const
{
	return m_bRequiresSecureLogin;
}


/*********************************************************************************
inline const char* CService::GetUrl() const
Author:		Igor Loboda
Created:	23/05/2003
Visibility:	public
Returns:	service url 
*********************************************************************************/

inline const char* CService::GetUrl() const
{
	return m_Url;
}


/*********************************************************************************
inline const char* CService::GetApiAccess() const
Author:		Igor Loboda
Created:	23/05/2003
Visibility:	public
Returns:	api access privileges the service has
*********************************************************************************/

inline const char* CService::GetApiAccess() const
{
	return m_ApiAccess;
}


/*********************************************************************************
inline const char* CService::GetCreateDate() const
Author:		Igor Loboda
Created:	23/05/2003
Visibility:	public
Returns:	date when the service was created
*********************************************************************************/

inline const char* CService::GetCreateDate() const
{
	return m_CreateDate;
}


/*********************************************************************************
class CServices : public CSimplePtrList<CService>
Author:		Igor Loboda
Created:	23/05/2003
Purpose:	keeps a list of CService objects pointers
*********************************************************************************/

class DllExport CServices : public CSimplePtrList<CService>
{
};

#endif
