#ifndef USER_H
#define USER_H

#include "SimpleTemplates.h"
#include "Str.h"
#include "UserProfile.h"
#include "UserStatus.h"
#include <Dll.h>

class DllExport CUserId
{
	public:
		CUserId();
		CUserId(unsigned long ulId, const char* pCudId, const char* pUserName);
		unsigned long GetId() const { return m_ulId; }
		const char* GetCudId() const { return m_CudId.GetStr(); }
		const char* GetUserName() const { return m_UserName.GetStr(); }
		void SetId(unsigned long ulId) { m_ulId = ulId; }
		void SetCudId(const char* pCudId) { m_CudId = pCudId; }
		void SetUserName(const char* pUserName) { m_UserName = pUserName; }

	protected:
		unsigned long m_ulId;
		CStr m_CudId;
		CStr m_UserName;
};

class DllExport CUser
{
	public:
		CUser();
		~CUser();

		CUserId m_UserId;
		CUserProfile* m_pUserProfile;
		CUserStatus* m_pUserStatus;
};

/*******************************************************************************************
class CUsers : public CSimplePtrList<CUser>
Author:		Igor Loboda
Created:	29/04/2003
Purpose:	holds the list of COtherUserStatus pointers
*******************************************************************************************/

class DllExport CUsers : public CSimplePtrList<CUser>
{
};
	

/*******************************************************************************************
class COtherUsersList : public CSimplePtrList<COtherUserStatus>
Author:		Igor Loboda
Created:	29/04/2003
Purpose:	holds the list of COtherUserStatus pointers
*******************************************************************************************/

class DllExport CUsersMap : public CSimplePtrMap<CStr, CUser>
{
};
	
#endif
