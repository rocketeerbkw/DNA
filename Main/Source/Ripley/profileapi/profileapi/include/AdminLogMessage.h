#ifndef ADMINLOGMESSAGE_H
#define ADMINLOGMESSAGE_H


#include <Str.h>
#include <SimpleTemplates.h>
#include <Dll.h>


/*******************************************************************************************
class CAdminLogMessage
Author:		Igor Loboda
Created:	14/05/2003
Purpose:	holds data about a message from admin messages log.
*******************************************************************************************/

class DllExport CAdminLogMessage
{
	protected:
		unsigned long m_ulId;
	 	unsigned long m_ulUserId;
		unsigned long m_ulAdminId;
		CStr m_Comments;
		CStr m_DateCreated;
		CStr m_AdminName;
		
	public:
		CAdminLogMessage();
		virtual ~CAdminLogMessage() {;}
		virtual void Clear();
		
		void SetId(unsigned long ulId);
		void SetUserId(unsigned long ulUserId);
		void SetAdminId(unsigned long ulAdminId);
		void SetComments(const char* pComments);
		void SetDateCreated(const char* pDateCreated);
 		void SetAdminName(const char* pAdminName);
		
		unsigned long GetId() const;
		unsigned long GetUserId() const;
		unsigned long GetAdminId() const;
		const char* GetComments() const;
		const char* GetDateCreated() const;
		const char* GetAdminName() const;
};




/*******************************************************************************************
inline const char* CAdminLogMessage::GetAdminName() const
Author:		Igor Loboda
Created:	14/05/2003
Visibility:	public
Returns:	the admin name 
*******************************************************************************************/

inline const char* CAdminLogMessage::GetAdminName() const
{
	return m_AdminName;
}


/*******************************************************************************************
inline unsigned long CAdminLogMessage::GetId() const
Author:		Igor Loboda
Created:	14/05/2003
Visibility:	public
Returns:	id of the message
*******************************************************************************************/

inline unsigned long CAdminLogMessage::GetId() const
{
	return m_ulId;
}


/*******************************************************************************************
inline unsigned long CAdminLogMessage::GetUserId() const
Author:		Igor Loboda
Created:	14/05/2003
Visibility:	public
Returns:	id of the user the message is about
*******************************************************************************************/

inline unsigned long CAdminLogMessage::GetUserId() const
{
	return m_ulUserId;
}


/*******************************************************************************************
inline unsigned long CAdminLogMessage::GetAdminId() const
Author:		Igor Loboda
Created:	14/05/2003
Visibility:	public
Returns:	id of the AdminUser who created the message
*******************************************************************************************/

inline unsigned long CAdminLogMessage::GetAdminId() const
{
	return m_ulAdminId;
}


/*******************************************************************************************
inline const char* CAdminLogMessage::GetComments() const
Author:		Igor Loboda
Created:	14/05/2003
Visibility:	public
Returns:	body of the message
*******************************************************************************************/

inline const char* CAdminLogMessage::GetComments() const
{
	return m_Comments;
}


/*******************************************************************************************
inline const char* CAdminLogMessage::GetDateCreated() const
Author:		Igor Loboda
Created:	14/05/2003
Visibility:	public
Returns:	date when the message was created
*******************************************************************************************/

inline const char* CAdminLogMessage::GetDateCreated() const
{
	return m_DateCreated;
}


/*******************************************************************************************
class CAdminLog : public CSimplePtrList<CAdminLogMessage>
Author:		Igor Loboda
Created:	14/05/2003
Purpose:	holds the list of pointers to AdminLogMessage objects
*******************************************************************************************/

class DllExport CAdminLog : public CSimplePtrList<CAdminLogMessage>
{
};

#endif
