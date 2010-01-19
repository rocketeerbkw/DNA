#ifndef ADMINMESSAGE_H
#define ADMINMESSAGE_H

#include <SimpleTemplates.h>
#include <Str.h>
#include <Dll.h>


/*******************************************************************************************
class CUserAdminMessages : public CSimplePtrList<CStr>
Author:		Igor Loboda
Created:	08/05/2003
Purpose:	holds the list of admin messages (list of CStr*)
*******************************************************************************************/
 
class DllExport CUserAdminMessages : public CSimplePtrList<CStr>
{
};


/*******************************************************************************************
class CAdminMessage
Author:		Igor Loboda
Created:	09/06/2003
Purpose:	holds admin message and it's metadata
*******************************************************************************************/
 
class DllExport CAdminMessage
{
	protected:
		unsigned long m_ulId;
		unsigned long m_ulServiceId;
		CStr m_ServiceName;
		CStr m_Message;
		CStr m_ActivateDate;
		CStr m_ExpireDate;
		CStr m_CreateDate;		
		
	public:
		CAdminMessage();
		virtual ~CAdminMessage() {;}
		virtual void Clear();
		
		void SetId(unsigned long ulId);
		void SetServiceId(unsigned long ulServiceId);
		void SetMessage(const char* pMessage);
		void SetActivateDate(const char* pActivateDate);
		void SetExpireDate(const char* pExpireDate);
		void SetCreateDate(const char* pCreateDate);
		void SetServiceName(const char* pServiceName);
		
		unsigned long GetId() const;
		unsigned long GetServiceId() const;
		const char* GetMessage() const;
		const char* GetActivateDate() const;
		const char* GetExpireDate() const;
		const char* GetCreateDate() const;
		const char* GetServiceName() const;
};


/*******************************************************************************************
inline const char* CAdminMessage::GetServiceName() const
Author:		Igor Loboda
Created:	09/06/2003
Visibility:	public
Returns:	service name the message relates to
*******************************************************************************************/
 
inline const char* CAdminMessage::GetServiceName() const
{
	return m_ServiceName;
}


/*******************************************************************************************
inline unsigned long CAdminMessage::GetId() const
Author:		Igor Loboda
Created:	09/06/2003
Visibility:	public
Returns:	message id
*******************************************************************************************/
 
inline unsigned long CAdminMessage::GetId() const
{
	return m_ulId;
}


/*******************************************************************************************
inline unsigned long CAdminMessage::GetServiceId() const
Author:		Igor Loboda
Created:	09/06/2003
Visibility:	public
Returns:	id of a service the message relates to
*******************************************************************************************/
 
inline unsigned long CAdminMessage::GetServiceId() const
{
	return m_ulServiceId;
}


/*******************************************************************************************
inline const char* CAdminMessage::GetMessage() const
Author:		Igor Loboda
Created:	09/06/2003
Visibility:	public
Returns:	message text
*******************************************************************************************/
 
inline const char* CAdminMessage::GetMessage() const
{
	return m_Message;
}


/*******************************************************************************************
inline const char* CAdminMessage::GetActivateDate() const
Author:		Igor Loboda
Created:	09/06/2003
Visibility:	public
Returns:	timestamp when the message should be activated
*******************************************************************************************/
 
inline const char* CAdminMessage::GetActivateDate() const
{
	return m_ActivateDate;
}


/*******************************************************************************************
inline const char* CAdminMessage::GetExpireDate() const
Author:		Igor Loboda
Created:	09/06/2003
Visibility:	public
Returns:	timestamp when the message expires
*******************************************************************************************/
 
inline const char* CAdminMessage::GetExpireDate() const
{
	return m_ExpireDate;
}


/*******************************************************************************************
inline const char* CAdminMessage::GetCreateDate() const
Author:		Igor Loboda
Created:	09/06/2003
Visibility:	public
Returns:	timestamp when the message was created
*******************************************************************************************/
 
inline const char* CAdminMessage::GetCreateDate() const
{
	return m_CreateDate;
}


/*******************************************************************************************
class CAdminMessages : public CSimplePtrList<CStr>
Author:		Igor Loboda
Created:	09/06/2003
Purpose:	holds the list of admin messages (list of CStr*)
*******************************************************************************************/
 
class DllExport CAdminMessages : public CSimplePtrList<CAdminMessage>
{
};

#endif

