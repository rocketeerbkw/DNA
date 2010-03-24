#ifndef USERTOUSERREQUEST_H
#define USERTOUSERREQUEST_H

#include <Str.h>
#include <SimpleTemplates.h>
#include <Dll.h>


/*******************************************************************************************
class CUserToUserRequest
Author:		Igor Loboda
Created:	06/05/2003
Purpose:	stores information about user to user request
*******************************************************************************************/

class DllExport CUserToUserRequest
{
	protected:
		unsigned long m_ulRequestId;
		unsigned long m_ulRequesterId;
		unsigned long m_ulResponderId;
		CStr m_RequestType;
		CStr m_RequestDate;
		CStr m_ResponseDate;
		CStr m_ResponseCode;
		CStr m_ResponderName;
		CStr m_RequesterName;

	public:
		CUserToUserRequest();
		virtual ~CUserToUserRequest() {;}
		virtual void Clear();

		void SetRequestId(unsigned long ulRequestId);
		void SetRequesterId(unsigned long ulRequesterId);
		void SetResponderId(unsigned long ulResponderId);
		void SetResponderName(const char* pUserName);
		void SetRequesterName(const char* pUserName);
		void SetRequestType(const char* pRequestType);
		void SetRequestDate(const char* pRequestDate);
		void SetResponseDate(const char* pResponseDate);
		void SetResponseCode(const char* pResponseCode);

		unsigned long GetRequestId() const;
		unsigned long GetRequesterId() const;
		unsigned long GetResponderId() const;
		const char* GetResponderName() const;
		const char* GetRequesterName() const;
		const char* GetRequestType() const;
		const char* GetRequestDate() const;
		const char* GetResponseDate() const;
		const char* GetResponseCode() const;
};


/*******************************************************************************************
inline unsigned long CUserToUserRequest::GetRequestId() const
Author:		Igor Loboda
Created:	06/05/2003
Visibility:	public
Returns:	request id
*******************************************************************************************/

inline unsigned long CUserToUserRequest::GetRequestId() const
{
	return m_ulRequestId;
}


/*******************************************************************************************
inline unsigned long CUserToUserRequest::GetRequesterId() const
Author:		Igor Loboda
Created:	06/05/2003
Visibility:	public
Returns:	requester id
*******************************************************************************************/

inline unsigned long CUserToUserRequest::GetRequesterId() const
{
	return m_ulRequesterId;
}


/*******************************************************************************************
inline unsigned long CUserToUserRequest::GetResponderId() const
Author:		Igor Loboda
Created:	06/05/2003
Visibility:	public
Returns:	responder id
*******************************************************************************************/

inline unsigned long CUserToUserRequest::GetResponderId() const
{
	return m_ulResponderId;
}


/*******************************************************************************************
inline const char* CUserToUserRequest::GetResponderName() const
Author:		Igor Loboda
Created:	06/05/2003
Visibility:	public
Returns:	responder name
*******************************************************************************************/

inline const char* CUserToUserRequest::GetResponderName() const
{
	return m_ResponderName;
}


/*******************************************************************************************
inline const char* CUserToUserRequest::GetRequesterName() const
Author:		Igor Loboda
Created:	19/09/2003
Visibility:	public
Returns:	requester name
*******************************************************************************************/

inline const char* CUserToUserRequest::GetRequesterName() const
{
	return m_RequesterName;
}


/*******************************************************************************************
inline const char* CUserToUserRequest::GetRequestType() const
Author:		Igor Loboda
Created:	06/05/2003
Visibility:	public
Returns:	request type. see USER_REQUEST_*
*******************************************************************************************/

inline const char* CUserToUserRequest::GetRequestType() const
{
	return m_RequestType;
}


/*******************************************************************************************
inline const char* CUserToUserRequest::GetRequestDate() const
Author:		Igor Loboda
Created:	06/05/2003
Visibility:	public
Returns:	date when the request was created
*******************************************************************************************/

inline const char* CUserToUserRequest::GetRequestDate() const
{
	return m_RequestDate;
}


/*******************************************************************************************
inline const char* CUserToUserRequest::GetResponseDate() const
Author:		Igor Loboda
Created:	06/05/2003
Visibility:	public
Returns:	the date when the request was responded
*******************************************************************************************/

inline const char* CUserToUserRequest::GetResponseDate() const
{
	return m_ResponseDate;
}


/*******************************************************************************************
inline const char* CUserToUserRequest::GetResponseCode() const
Author:		Igor Loboda
Created:	06/05/2003
Visibility:	public
Returns:	response code. one of ORIGINATOR_RESPONSE_* or USER_RESPONSE_*
*******************************************************************************************/

inline const char* CUserToUserRequest::GetResponseCode() const
{
	return m_ResponseCode;
}


/*******************************************************************************************
class CUserToUserRequest : public CSiplePtrList<CUserToUserRequest>
Author:		Igor Loboda
Created:	06/05/2003
Purpose:	holds the list of CUserToUserRequests objects pointers.
*******************************************************************************************/

class DllExport CUserToUserRequests : public CSimplePtrList<CUserToUserRequest>
{
};

#endif
