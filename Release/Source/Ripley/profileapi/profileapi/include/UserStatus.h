#ifndef USERSTATUS_H
#define USERSTATUS_H

#include <SimpleTemplates.h>
#include <OtherUserStatus.h>
#include <Str.h>
#include <Dll.h>


/*******************************************************************************************
class CUserStatus : public COtherUserStatus
Author:		Igor Loboda
Created:	29/04/2003
Purpose:	Stores user status information for the user the current service has
			full authentication information for.
*******************************************************************************************/

class DllExport CUserStatus : public COtherUserStatus
{
	protected:
		unsigned long m_ulUserId;
		CStr m_LastLoginDate;
		bool bGlobalAgreementAccepted;
		bool bServiceAgreementAccepted;
		CStr m_Type;

	public:
		CUserStatus();
		void Clear();
		
		void SetLastLoginDate(const char* pLastLoginDate);
		void SetGlobalAgreementAccepted(bool bAccepted);
		void SetServiceAgreementAccepted(bool bAccepted);
		void SetUserId(unsigned long ulUserId);
		void SetType(const char* pType);
		
		const char* GetLastLoginDate() const;
		unsigned long GetUserId() const;
		bool GetIsGlobalAgreementAccepted() const;
		bool GetIsServiceAgreementAccepted() const;
		const char* GetType() const;
};


/*******************************************************************************************
inline void CUserStatus::SetUserId()
Author:		Igor Loboda
Created:	14/05/2003
Visibility:	public
*******************************************************************************************/

inline unsigned long CUserStatus::GetUserId() const 
{
	return m_ulUserId;
}


/*******************************************************************************************
inline void CUserStatus::GetType()
Author:		Igor Loboda
Created:	22/09/2003
Visibility:	public
Purpose:	Note, that only a service with ACCESS_USER_TYPE privilege is able to access this 
			information. Otherwise this field will be empty string
*******************************************************************************************/

inline const char* CUserStatus::GetType() const
{
	return m_Type;
}


/*******************************************************************************************
inline const char* CUserStatus::GetLastLoginDate() const
Author:		Igor Loboda
Created:	29/04/2003
Visibility:	public
Returns:	date when the user last logged in to the service
*******************************************************************************************/

inline const char* CUserStatus::GetLastLoginDate() const
{
	return m_LastLoginDate;
}


/*******************************************************************************************
inline bool CUserStatus::GetIsGlobalAgreementAccepted() const
Author:		Igor Loboda
Created:	29/04/2003
Visibility:	public
Returns:	true if global agreement accepted
*******************************************************************************************/

inline bool CUserStatus::GetIsGlobalAgreementAccepted() const
{
	return bGlobalAgreementAccepted;
}


/*******************************************************************************************
inline bool CUserStatus::GetIsServiceAgreementAccepted() const
Author:		Igor Loboda
Created:	29/04/2003
Visibility:	public
Returns:	true if service agreement accepted
*******************************************************************************************/

inline bool CUserStatus::GetIsServiceAgreementAccepted() const
{
	return bServiceAgreementAccepted;
}


/*******************************************************************************************
class CUsersList : public CSimplePtrList<CUserStatus>
Author:		Igor Loboda
Created:	14/05/2003
Purpose:	holds the list of CUserStatus pointers
*******************************************************************************************/

class DllExport CUsersList : public CSimplePtrList<CUserStatus>
{
};
	

#endif
