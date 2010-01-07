// RegisterObject.h: interface for the CRegisterObject class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/


#if !defined(AFX_REGISTEROBJECT_H__6D8428F4_B437_40A0_A6A7_9239162B2930__INCLUDED_)
#define AFX_REGISTEROBJECT_H__6D8428F4_B437_40A0_A6A7_9239162B2930__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"

class CRegisterBase : public CXMLObject
{
public:
	virtual bool GetError(CTDVString* oError) = 0;
	virtual bool GetBBCUID(CTDVString* oUID) = 0;
	virtual bool GetBBCCookie(CTDVString* oName, CTDVString* oDomain, CTDVString* oValue) = 0;
	virtual bool RegisterUser(const TDVCHAR* pUserName, const TDVCHAR* pPassword, const TDVCHAR* pEmail) = 0;
	virtual bool LoginUser(const TDVCHAR* pUsername, const TDVCHAR* pPassword) = 0;

	virtual bool UpdateEmail(const TDVCHAR* pUsername, const TDVCHAR* pPassword, const TDVCHAR* pEmail) = 0;
	virtual bool UpdatePassword(const TDVCHAR *pUsername, const TDVCHAR* pPassword, const TDVCHAR* pNewPassword) = 0;
	virtual bool RequestPassword(const TDVCHAR *pUsername, const TDVCHAR *pEmail) = 0;

	
	CRegisterBase(CInputContext& inputContext);
	virtual ~CRegisterBase();
protected:
	CInputContext& m_InputContext;

};

class CRegisterObject : public CRegisterBase  
{
public:
	bool GetError(CTDVString* oError);
	bool GetBBCUID(CTDVString* oUID);
	bool GetBBCCookie(CTDVString* oName, CTDVString* oDomain, CTDVString* oValue);
	bool RegisterUser(const TDVCHAR* pUserName, const TDVCHAR* pPassword, const TDVCHAR* pEmail);
	bool LoginUser(const TDVCHAR* pUsername, const TDVCHAR* pPassword);

	bool UpdateEmail(const TDVCHAR* pUsername, const TDVCHAR* pPassword, const TDVCHAR* pEmail);
	bool UpdatePassword(const TDVCHAR *pUsername, const TDVCHAR* pPassword, const TDVCHAR* pNewPassword);
	bool RequestPassword(const TDVCHAR *pUsername, const TDVCHAR *pEmail);

	
	CRegisterObject(CInputContext& inputContext);
	virtual ~CRegisterObject();

protected:
	CXMLTree* m_pResultTree;
};

class CLocalRegisterObject : public CRegisterBase  
{
public:
	bool GetError(CTDVString* oError);
	bool GetBBCUID(CTDVString* oUID);
	bool GetBBCCookie(CTDVString* oName, CTDVString* oDomain, CTDVString* oValue);
	bool RegisterUser(const TDVCHAR* pUserName, const TDVCHAR* pPassword, const TDVCHAR* pEmail);
	bool LoginUser(const TDVCHAR* pUsername, const TDVCHAR* pPassword);

	bool UpdateEmail(const TDVCHAR* pUsername, const TDVCHAR* pPassword, const TDVCHAR* pEmail);
	bool UpdatePassword(const TDVCHAR *pUsername, const TDVCHAR* pPassword, const TDVCHAR* pNewPassword);
	bool RequestPassword(const TDVCHAR *pUsername, const TDVCHAR *pEmail);

	
	CLocalRegisterObject(CInputContext& inputContext);
	virtual ~CLocalRegisterObject();

protected:
	CTDVString m_BBCUID;
};

#endif // !defined(AFX_REGISTEROBJECT_H__6D8428F4_B437_40A0_A6A7_9239162B2930__INCLUDED_)
