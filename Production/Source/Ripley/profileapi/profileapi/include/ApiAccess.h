#ifndef APIACCESS_H
#define APIACCESS_H

#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <Str.h>
#include <Dll.h>

#define ACCESSVALUE_YES	'1'
#define ACCESSVALUE_NO	'0'

#define ARRAY_LEN(arrayName) sizeof(arrayName)/sizeof(arrayName[0])

#define ACCESS_REMOVED_ACCOUNTS						0
#define ACCESS_CODE_NOT_USED						1

#define ACCESS_SET_ADMIN_USER						3

#define ACCESS_SET_SERVICE_AGREEMENT_SERVICE		5
#define ACCESS_SET_USER_STATUS_REMOVED				6

#define ACCESS_SET_USER_STATUS_VALID				8
#define ACCESS_SET_USER_TYPE						9
#define ACCESS_SET_SERVICE_AGREEMENT				10
#define ACCESS_SET_GLOBAL_AGREEMENT					11
#define ACCESS_GET_USER_SERVICES					12
#define ACCESS_GET_USER_ADMIN_SERVICES				13
#define ACCESS_SET_ADMIN_PASSWORD					14
#define ACCESS_GET_ADMINUSERS_LIST					15
#define ACCESS_ADD_TO_ADMIN_LOG						16
#define ACCESS_GET_ADMIN_LOG						17
#define ACCESS_SET_USER_PASSWORD					18
#define ACCESS_SET_USER_NAME						19
#define ACCESS_SET_BLOCK							20
#define ACCESS_REGISTER_ADMIN_USER					21
#define ACCESS_REGISTER_USER						22
#define ACCESS_ADMIN_USER_CURRENTSERVICE			23
#define ACCESS_ADMIN_USER_SERVICE					24
#define ACCESS_ADMIN_ADMINUSER_SERVICE				25
#define ACCESS_SET_WARNING							26
#define ACCESS_SET_WARNING_OTHER_SERVICE			27
#define ACCESS_SET_WARNING_ADMIN_SERVICE			28
#define ACCESS_GET_WARNING_OTHER_SERVICE			29
#define ACCESS_GET_WARNING_ADMIN_SERVICE			30

#define ACCESS_BULKLOGOUT_OTHER_SERVICE				32
#define ACCESS_BULKLOGOUT_ADMIN_SERVICE				33
#define ACCESS_UPDATE_ADMIN_SERVICE					34
#define ACCESS_UPDATE_OTHER_SERVICE					35
#define ACCESS_ADD_SERVICE							36
#define ACCESS_ADMIN_ATTRIBUTE						37
#define ACCESS_ADMIN_SERVICE_ATTRIBUTE				38
#define ACCESS_ADMIN_MESSAGES						39
#define ACCESS_LOGIN_OTHER_SERVICE					40
#define ACCESS_LOGIN_ADMIN_SERVICE					41
#define ACCESS_USER_STATUS_OTHER_SERVICE			42
#define ACCESS_USER_STATUS_ADMIN_SERVICE			43
#define ACCESS_USER_TYPE							44
#define ACCESS_LOGOUT_FROM_ALL						45

#define NUMBER_OF_PRIVILEGES						46


/*********************************************************************************
class CPrivilegeDescription
Author:		Igor Loboda
Created:	27/05/2003
Purpose:	holds one privilege description
*********************************************************************************/

class DllExport CPrivilegeDescription
{
	protected:
		unsigned int m_uiId;
		const char* m_pDescription;
		unsigned int m_uiNumberOfMethods;
		const char** m_pMethods;
		const char* m_pId;
		
	public:
		CPrivilegeDescription(const char* pId, unsigned int uiId, const char* pDescription, 
			unsigned int uiNumberOfMethods,	const char** pMethods);
	
		unsigned int GetNumberOfMethods() const;
		const char* GetMethodName(unsigned int uiIndex) const;
		unsigned int GetId() const;
		const char* GetDescription() const;
		const char* GetStringId() const;
};


/*********************************************************************************
inline unsigned int CPrivilegeDescription::GetId() const
Author:		Igor Loboda
Created:	27/05/2003
Visibility:	public
Returns:	privilege id
*********************************************************************************/

inline unsigned int CPrivilegeDescription::GetId() const
{
	return m_uiId;
}


/*********************************************************************************
inline unsigned int CPrivilegeDescription::GetStringId() const
Author:		Igor Loboda
Created:	21/07/2003
Visibility:	public
Returns:	privilege id (string)
*********************************************************************************/

inline const char* CPrivilegeDescription::GetStringId() const
{
	return m_pId;
}


/*********************************************************************************
inline unsigned int CPrivilegeDescription::GetNumberOfMethods() const
Author:		Igor Loboda
Created:	27/05/2003
Visibility:	public
Returns:	number of methods affected by this privilege
*********************************************************************************/

inline unsigned int CPrivilegeDescription::GetNumberOfMethods() const
{
	return m_uiNumberOfMethods;
}


/*********************************************************************************
inline const char* CPrivilegeDescription::GetDescription() const
Author:		Igor Loboda
Created:	27/05/2003
Visibility:	public
Returns:	privilege description
*********************************************************************************/

inline const char* CPrivilegeDescription::GetDescription() const
{
	return m_pDescription;
}

			
/*********************************************************************************
class CApiAccess

Author:		Igor Loboda
Created:	10/04/2003
Purpose:	holds information about service's rights about which api methods that service
			may call. Privileges string is a string of a number of 1-es or 0-es. Each position
			in the string represents a particular privilege. If the string is shorter that
			the position to check - it is assumed to have 0 in it.
*********************************************************************************/

class DllExport CApiAccess
{
	protected:
		CStr m_Access;
		static CPrivilegeDescription m_Privileges[];
		char m_PrivilegesBuffer[NUMBER_OF_PRIVILEGES + 1];
		
	public:
		void SetApiAccess(const char* pAccess);
		const char* GetApiAccess() const;

		bool IsAllowed(unsigned int uiPrivilege) const;
		void SetPrivilege(unsigned int uiPrivilege, bool bAllowed);
		
		static unsigned int GetNumberOfPrivileges();
//TODO: const CPrivilegeDescription * const Get..?
		static const CPrivilegeDescription * GetPrivilegeDescription(unsigned int uiPrivilege);
		
		CApiAccess& operator=(const CApiAccess& src);
};


/*********************************************************************************
static inline unsigned int CApiAccess::GetNumberOfPrivileges()
Author:		Igor Loboda
Created:	27/05/2003
Visibility:	public
Returns:	number of all possible privileges
*********************************************************************************/

inline unsigned int CApiAccess::GetNumberOfPrivileges()
{
	return NUMBER_OF_PRIVILEGES;
}


/*********************************************************************************
const char* CApiAccess::GetApiAccess() const
Author:		Igor Loboda
Created:	27/05/2003
Visibility:	public
Returns:	api access string
*********************************************************************************/

inline const char* CApiAccess::GetApiAccess() const
{
	return m_Access;
}

#endif
