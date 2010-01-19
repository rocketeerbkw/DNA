#ifndef USERSERVICE_H
#define USERSERVICE_H

#include <Str.h>
#include <SimpleTemplates.h>
#include <Dll.h>


/*******************************************************************************************
class CUserService
Author:		Igor Loboda
Created:	08/05/2003
Purpose:	holds data about a service for which the user is registered
*******************************************************************************************/

class DllExport CUserService
{
	protected:
		unsigned long m_ulId;
		CStr m_Name;
		CStr m_Description;
		CStr m_RegistrationDate;
		CStr m_Url;
		bool m_bIsRegistered;
		
	public:
		CUserService();
		virtual ~CUserService() {;}
		virtual void Clear();
		
		void SetId(unsigned long ulId);
		void SetDescription(const char* pDescription);
		void SetRegistrationDate(const char* pRegistrationDate);
		void SetIsRegistered(bool bRegistered);
		void SetUrl(const char* pUrl);
		void SetName(const char* pName);
		
		unsigned long GetId() const;
		bool GetIsRegistered() const;
		const char* GetDescription() const;
		const char* GetRegistrationDate() const;
		const char* GetUrl() const;
		const char* GetName() const;
};


/*******************************************************************************************
inline const char* CUserService::GetName()
Author:		Igor Loboda
Created:	27/08/2003
Visibility:	public
Returns:	service name
*******************************************************************************************/

inline const char* CUserService::GetName() const
{
	return m_Name;
}


/*******************************************************************************************
inline unsigned long CUserService::GetId() const
Author:		Igor Loboda
Created:	08/05/2003
Visibility:	public
Returns:	service id
*******************************************************************************************/

inline unsigned long CUserService::GetId() const
{
	return m_ulId;
}


/*******************************************************************************************
inline const char* CUserService::GetDescription() const
Author:		Igor Loboda
Created:	08/05/2003
Visibility:	public
Returns:	service description
*******************************************************************************************/

inline const char* CUserService::GetDescription() const
{
	return m_Description;
}


/*******************************************************************************************
inline const char* CUserService::GetRegistrationDate() const
Author:		Igor Loboda
Created:	08/05/2003
Visibility:	public
Returns:	date when the user was registered with the service
*******************************************************************************************/

inline const char* CUserService::GetRegistrationDate() const
{
	return m_RegistrationDate;
}


/*******************************************************************************************
inline const char* CUserService::GetUrl() const
Author:		Igor Loboda
Created:	13/05/2003
Visibility:	public
Returns:	service url
*******************************************************************************************/

inline const char* CUserService::GetUrl() const
{
	return m_Url;
}


/*******************************************************************************************
inline bool CUserService::GetIsRegistered() const
Author:		Igor Loboda
Created:	13/05/2003
Visibility:	public
Returns:	true if the user is reigstered with the service
*******************************************************************************************/

inline bool CUserService::GetIsRegistered() const
{
	return m_bIsRegistered;
}


/*******************************************************************************************
class CUserServices : public CSimplePtrList<CUserService>
Author:		Igor Loboda
Created:	08/05/2003
Purpose:	Holds list of services for which the user is registered
*******************************************************************************************/

class DllExport CUserServices : public CSimplePtrList<CUserService>
{
};

#endif
