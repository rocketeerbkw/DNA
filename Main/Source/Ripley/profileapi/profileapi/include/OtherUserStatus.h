#ifndef OTHERUSERSTATUS_H
#define OTHERUSERSTATUS_H

#include <Str.h>
#include <Dll.h>
#include <SimpleTemplates.h>


/*******************************************************************************************
class COtherUserStatus 
Author:		Igor Loboda
Created:	29/04/2003
Purpose:	Stores user status information for the user the current service do not have
			full authentication information for.
*******************************************************************************************/

class DllExport COtherUserStatus 
{
	protected:
		CStr m_UserName;
		CStr m_OnlineStatus;
		CStr m_OnlineStatusDate;
		CStr m_UserStatus;
		CStr m_UserStatusDate;
		bool m_bIsLoggedIn;
		CStr m_LoggedInChangeDate;
		bool m_IsRegisteredWithService;
		CStr m_sServiceRegistrationDate;

	public:
		COtherUserStatus();
		virtual ~COtherUserStatus() {;}
		virtual void Clear();
		

		void SetUserName(const char* pUserName);		
		void SetOnlineStatus(const char* pOnlineStatus);
		void SetOnlineStatusDate(const char* pOnlineStatusDate);
		void SetUserStatus(const char* pUserStatus);
		void SetUserStatusDate(const char* pUserStatusDate);
		void SetLoggedInStatus(bool bIsLoggedIn);
		void SetLoggedInChangeDate(const char* pLoggedInChangeDate);
		void SetIsRegisteredWithTheService(bool bIsRegistered);
		void SetServiceRegistrationDate(const char* pServiceRegistrationDate);
		

		const char* GetUserName() const;
		const char* GetOnlineStatus() const;
		const char* GetOnlineStatusDate() const;
		const char* GetUserStatus() const;
		const char* GetUserStatusDate() const;
		bool GetLoggedInStatus() const;
		const char* GetLoggedInChangeDate() const;
		bool GetIsRegisteredWithTheService() const;
		const char* GetServiceRegistrationDate() const { return m_sServiceRegistrationDate; }
		
		static bool IsAccountRemoved(const char* pAccountStatus);
		static bool IsAccountValid(const char* pAccountStatus);
};


/*******************************************************************************************
inline bool COtherUserStatus::GetIsRegisteredWithTheService() const
Author:		Igor Loboda
Created:	02/05/2003
Visibility:	public
Returns:	true if the user is registered with the current service (SetService)
*******************************************************************************************/

inline bool COtherUserStatus::GetIsRegisteredWithTheService() const
{
	return m_IsRegisteredWithService;
}


/*******************************************************************************************
inline const char* COtherUserStatus::GetOnlineStatus() const
Author:		Igor Loboda
Created:	29/04/2003
Visibility:	public
Returns:	current user online status
Purpose:	this is service specific information so it will be empty if the user is not 
			registered with the current service (SetService);
*******************************************************************************************/

inline const char* COtherUserStatus::GetOnlineStatus() const
{
	return m_OnlineStatus;
}


/*******************************************************************************************
inline const char* COtherUserStatus::GetOnlineStatusDate() const
Author:		Igor Loboda
Created:	29/04/2003
Visibility:	public
Returns:	the date when the user online status was last updated
Purpose:	this is service specific information so it will be empty if the user is not 
			registered with the current service (SetService);
*******************************************************************************************/

inline const char* COtherUserStatus::GetOnlineStatusDate() const
{
	return m_OnlineStatusDate;
}


/*******************************************************************************************
inline const char* COtherUserStatus::GetUserStatus() const
Author:		Igor Loboda
Created:	29/04/2003
Visibility:	public
Returns:	current user account status. see USER_STATUS_* constants
*******************************************************************************************/

inline const char* COtherUserStatus::GetUserStatus() const
{
	return m_UserStatus;
}


/*******************************************************************************************
inline const char* COtherUserStatus::GetUserStatusDate() const
Author:		Igor Loboda
Created:	29/04/2003
Visibility:	public
Returns:	date when user account  status was last updated
*******************************************************************************************/

inline const char* COtherUserStatus::GetUserStatusDate() const
{
	return m_UserStatusDate;
}


/*******************************************************************************************
inline bool COtherUserStatus::GetLoggedInStatus() const
Author:		Igor Loboda
Created:	29/04/2003
Visibility:	public
Returns:	true if the user currently logged in
Purpose:	this is service specific information so it will be empty if the user is not 
			registered with the current service (SetService);
*******************************************************************************************/

inline bool COtherUserStatus::GetLoggedInStatus() const
{
	return m_bIsLoggedIn;
}


/*******************************************************************************************
inline const char* COtherUserStatus::GetLoggedInChangeDate() const
Author:		Igor Loboda
Created:	29/04/2003
Visibility:	public
Returns:	Last date when login status was updated
Purpose:	this is service specific information so it will be empty if the user is not 
			registered with the current service (SetService);
*******************************************************************************************/

inline const char* COtherUserStatus::GetLoggedInChangeDate() const
{
	return m_LoggedInChangeDate;
}


/*******************************************************************************************
inline const char* COtherUserStatus::GetUserName() const
Author:		Igor Loboda
Created:	02/05/2003
Visibility:	public
Returns:	user name
*******************************************************************************************/

inline const char* COtherUserStatus::GetUserName() const
{
	return m_UserName;
}


/*******************************************************************************************
class COtherUsersList : public CSimplePtrList<COtherUserStatus>
Author:		Igor Loboda
Created:	29/04/2003
Purpose:	holds the list of COtherUserStatus pointers
*******************************************************************************************/

class DllExport COtherUsersList : public CSimplePtrList<COtherUserStatus>
{
};
	

#endif
