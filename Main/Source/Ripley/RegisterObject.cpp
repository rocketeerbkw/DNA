// RegisterObject.cpp: implementation of the CRegisterObject class.
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


#include "stdafx.h"
#include "ripleyserver.h"
#include "RegisterObject.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CRegisterBase::CRegisterBase(CInputContext& inputContext) : CXMLObject(inputContext), m_InputContext(inputContext)
{

}

CRegisterBase::~CRegisterBase()
{
	// nothing
}

CRegisterObject::CRegisterObject(CInputContext& inputContext) : CRegisterBase(inputContext), m_pResultTree(NULL)
{

}

CRegisterObject::~CRegisterObject()
{
	if (m_pResultTree != NULL)
	{
		delete m_pResultTree;
		m_pResultTree = 0;
	}
}


TDVCHAR* loginrequest = "<?xml version='1.0' encoding='iso-8859-1'?>\
<!-- See the relevant dtd for more detailed description of fields -->\
<req:req \
	version='1.0' \
	atomic='N'\
	authcode=''\
	type='live'\
	responsetype='http'\
	responseto='sender'\
	xmlns:req='http://dev3.kw.bbc.co.uk/mybbc/markh/req_1.0.dtd'\
	xmlns:cud='http://dev3.kw.bbc.co.uk/mybbc/markh/req_cud_1.0.dtd'>\
	<cud:cud service='h2g2' atomic='N'>\
		<cud:user atomic='N'>\
			<cud:details return='full'>\
				<cud:login username='--**username**--' password='--**password**--'/>\
			</cud:details>\
			<cud:required validate_email='Y'>\
				<cud:field name='username'/>\
				<cud:field name='email'/>\
			</cud:required>\
		</cud:user>\
	</cud:cud>\
</req:req>";


/*********************************************************************************

	bool CRegisterObject::LoginUser(const TDVCHAR *pUsername, const TDVCHAR *pPassword)

	Author:		Jim Lynn
	Created:	20/08/2001
	Inputs:		pUserName - BBC Username
				pPassword - BBC password
	Outputs:	-
	Returns:	true if user logged in successfully
				false if failed to log in
	Purpose:	Tries to log in the given user. If the login fails, other methods
				can be called to find out why including one which will create some
				XML suitable for the registration page.

*********************************************************************************/

bool CRegisterObject::LoginUser(const TDVCHAR *pUsername, const TDVCHAR *pPassword)
{
	CTDVString request = loginrequest;
	CTDVString username = pUsername;
	username.Replace("'","&quot;");
	CTDVString password = pPassword;
	password.Replace("'","&quot;");
	request.Replace("--**username**--", username);
	request.Replace("--**password**--", password);
	CTDVString response;
	m_InputContext.MakeCUDRequest(request, &response);
	bool bResult = true;

	if (m_pResultTree != NULL)
	{
		delete m_pResultTree;
		m_pResultTree = NULL;
	}
	m_pResultTree = CXMLTree::Parse(response);
	if (m_pResultTree != NULL)
	{
		CXMLTree* pDetails = m_pResultTree->FindFirstTagName("CUD:DETAILS");
		if (pDetails == NULL)
		{
			return false;
		}
		else
		{
			CTDVString error;
			CTDVString status;
			CTDVString field;
			pDetails->GetAttribute("FIELD", field);
			pDetails->GetAttribute("ERROR", error);
			pDetails->GetAttribute("STATUS", status);
			if (status.CompareText("registeredthisservice"))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
	return false;
}

TDVCHAR* registerrequest = "<?xml version='1.0' encoding='iso-8859-1'?>\
<!-- See the relevant dtd for more detailed description of fields -->\
<req:req \
	version='1.0' \
	atomic='N'\
	authcode=''\
	type='live'\
	responsetype='http'\
	responseto='sender'\
	xmlns:req='http://dev3.kw.bbc.co.uk/mybbc/markh/req_1.0.dtd'\
	xmlns:cud='http://dev3.kw.bbc.co.uk/mybbc/markh/req_cud_1.0.dtd'>\
	<cud:cud service='h2g2' atomic='N'>\
		<cud:user atomic='N'>\
			<cud:details return='full'>\
				<cud:login username='--**username**--' password='--**password**--'/>\
			</cud:details>\
			<cud:required validate_email='Y'>\
				<cud:field name='username'/>\
				<cud:field name='email'/>\
			</cud:required>\
			<cud:add email='--**email**--'/>\
		</cud:user>\
	</cud:cud>\
</req:req>";

bool CRegisterObject::RegisterUser(const TDVCHAR *pUserName, const TDVCHAR *pPassword, const TDVCHAR *pEmail)
{
	CTDVString request = registerrequest;
	CTDVString username = pUserName;
	username.Replace("'","&quot;");
	CTDVString password = pPassword;
	password.Replace("'","&quot;");
	CTDVString email = pEmail;
	email.Replace("'","&quot;");
	request.Replace("--**username**--", username);
	request.Replace("--**password**--", password);
	request.Replace("--**email**--", email);
	CTDVString response;
	m_InputContext.MakeCUDRequest(request, &response);
	bool bResult = true;

	if (m_pResultTree != NULL)
	{
		delete m_pResultTree;
		m_pResultTree = NULL;
	}
	m_pResultTree = CXMLTree::Parse(response);
	if (m_pResultTree != NULL)
	{
		CXMLTree* pDetails = m_pResultTree->FindFirstTagName("CUD:DETAILS");
		if (pDetails == NULL)
		{
			return false;
		}
		else
		{
			CTDVString error;
			CTDVString status;
			CTDVString field;
			pDetails->GetAttribute("FIELD", field);
			pDetails->GetAttribute("ERROR", error);
			pDetails->GetAttribute("STATUS", status);
			if (status.CompareText("registeredthisservice"))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
	return false;
	return false;
}



TDVCHAR* updateemailrequest = "<?xml version='1.0' encoding='iso-8859-1'?>\
<!-- See the relevant dtd for more detailed description of fields -->\
<req:req \
	version='1.0' \
	atomic='N'\
	authcode=''\
	type='live'\
	responsetype='http'\
	responseto='sender'\
	xmlns:req='http://dev3.kw.bbc.co.uk/mybbc/markh/req_1.0.dtd'\
	xmlns:cud='http://dev3.kw.bbc.co.uk/mybbc/markh/req_cud_1.0.dtd'>\
	<cud:cud service='h2g2' atomic='N'>\
		<cud:user atomic='N'>\
			<cud:details return='partial'>\
				<cud:login username='--**username**--' password='--**password**--'/>\
			</cud:details>\
			<cud:required validate_email='N'>\
				<cud:field name='username'/>\
				<cud:field name='email'/>\
			</cud:required>\
			<cud:update email='--**email**--'/>\
		</cud:user>\
	</cud:cud>\
</req:req>";

/*********************************************************************************

	bool CRegisterObject::UpdateEmail(const TDVCHAR *pUsername, const TDVCHAR *pPassword, const TDVCHAR *pEmail)

	Author:		Jonathan Sloman
	Created:	11/03/2002
	Inputs:		pUserName - BBC Username
			pPassword - BBC password
                        pEmail    - new Email address
	Outputs:	-
	Returns:	true if updated successfully
				false if failed 
	Purpose:	Tries to update the email record in the CUD for
                        the given user.

*********************************************************************************/

bool CRegisterObject::UpdateEmail(const TDVCHAR* pUsername, const TDVCHAR* pPassword, const TDVCHAR* pEmail)
{
	CTDVString request = updateemailrequest;
	CTDVString username = pUsername;
	username.Replace("'","&quot;");
	CTDVString password = pPassword;
	password.Replace("'","&quot;");
	CTDVString email = pEmail;
	email.Replace("'","&quot;");
	request.Replace("--**username**--", username);
	request.Replace("--**password**--", password);
	request.Replace("--**email**--", email);
	CTDVString response;
	m_InputContext.MakeCUDRequest(request, &response);
	bool bResult = true;

	if (m_pResultTree != NULL)
	{
		delete m_pResultTree;
		m_pResultTree = NULL;
	}
	m_pResultTree = CXMLTree::Parse(response);
	if (m_pResultTree != NULL)
	{
		CXMLTree* pUpdate = m_pResultTree->FindFirstTagName("CUD:UPDATE");
		if (pUpdate == NULL)
		{
			return false;
		}
		else
		{
			CTDVString error;
			CTDVString success;
			CTDVString field;
			pUpdate->GetAttribute("FIELD", field);
			pUpdate->GetAttribute("ERROR", error);
			pUpdate->GetAttribute("SUCCESS", success);
			if (success.CompareText("Y"))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
	return false;
}

/* note that 'email' is not specified in 'required' as if it is, it forces
   the update to include 'email' too - feature/bug in CUD XML interface */

TDVCHAR* updatepasswordrequest = "<?xml version='1.0' encoding='iso-8859-1'?>\
<!-- See the relevant dtd for more detailed description of fields -->\
<req:req \
	version='1.0' \
	atomic='N'\
	authcode=''\
	type='live'\
	responsetype='http'\
	responseto='sender'\
	xmlns:req='http://dev3.kw.bbc.co.uk/mybbc/markh/req_1.0.dtd'\
	xmlns:cud='http://dev3.kw.bbc.co.uk/mybbc/markh/req_cud_1.0.dtd'>\
	<cud:cud service='h2g2' atomic='N'>\
		<cud:user atomic='N'>\
			<cud:details return='partial'>\
				<cud:login username='--**username**--' password='--**password**--'/>\
			</cud:details>\
			<cud:required validate_email='N'>\
				<cud:field name='username'/>\
			</cud:required>\
			<cud:update new_password='--**newpassword**--' confirm_password='--**newpassword**--'/>\
		</cud:user>\
	</cud:cud>\
</req:req>";

/*********************************************************************************

	bool CRegisterObject::UpdatePassword(const TDVCHAR *pUsername, const TDVCHAR *pPassword, const TDVCHAR *pNewPassword)

	Author:		Jonathan Sloman
	Created:	11/03/2002
	Inputs:		pUserName - BBC Username
			pPassword - BBC password
                        pNewPassword - new Password
	Outputs:	-
	Returns:	true if updated successfully
				false if failed 
	Purpose:	Tries to update the password in the CUD for
                        the given user.

*********************************************************************************/

bool CRegisterObject::UpdatePassword(const TDVCHAR *pUsername, const TDVCHAR* pPassword, const TDVCHAR* pNewPassword)
{
	CTDVString request = updatepasswordrequest;
	CTDVString username = pUsername;
	username.Replace("'","&quot;");
	CTDVString password = pPassword;
	password.Replace("'","&quot;");
	CTDVString newpassword = pNewPassword;
	newpassword.Replace("'","&quot;");
	request.Replace("--**username**--", username);
	request.Replace("--**password**--", password);
	request.Replace("--**newpassword**--", newpassword);
	CTDVString response;
	m_InputContext.MakeCUDRequest(request, &response);
	bool bResult = true;

	if (m_pResultTree != NULL)
	{
		delete m_pResultTree;
		m_pResultTree = NULL;
	}
	m_pResultTree = CXMLTree::Parse(response);
	if (m_pResultTree != NULL)
	{
		CXMLTree* pUpdate = m_pResultTree->FindFirstTagName("CUD:UPDATE");
		if (pUpdate == NULL)
		{
			return false;
		}
		else
		{
			CTDVString error;
			CTDVString success;
			CTDVString field;
			pUpdate->GetAttribute("FIELD", field);
			pUpdate->GetAttribute("ERROR", error);
			pUpdate->GetAttribute("SUCCESS", success);
			if (success.CompareText("Y"))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
	return false;
}

TDVCHAR* requestpasswordrequest = "<?xml version='1.0' encoding='iso-8859-1'?>\
<!-- See the relevant dtd for more detailed description of fields -->\
<req:req \
	version='1.0' \
	atomic='N'\
	authcode=''\
	type='live'\
	responsetype='http'\
	responseto='sender'\
	xmlns:req='http://dev3.kw.bbc.co.uk/mybbc/markh/req_1.0.dtd'\
	xmlns:cud='http://dev3.kw.bbc.co.uk/mybbc/markh/req_cud_1.0.dtd'>\
	<cud:cud service='h2g2' atomic='N'>\
		<cud:user atomic='N'>\
			<cud:details return='partial'>\
				<cud:login username='--**username**--' password=''/>\
			</cud:details>\
			<cud:required validate_email='N'>\
				<cud:field name='username'/>\
				<cud:field name='email'/>\
			</cud:required>\
			<cud:newpassword email='--**email**--'/>\
		</cud:user>\
	</cud:cud>\
</req:req>";

/*********************************************************************************

	bool CRegisterObject::RequestPassword(const TDVCHAR *pUsername, const TDVCHAR *pEmail)

	Author:		Jonathan Sloman
	Created:	11/03/2002
	Inputs:		pUserName - BBC Username
			pEmail - BBC email address
	Outputs:	-
	Returns:	true if successful
				false if failed 
	Purpose:	Uses the newpassword action in the CUD to request
                        that a new password be issued to the specified user,
                        and an email sent to them containing it.

!! must sort out how to authenticate with CUD over XML interface
+ sort out how to test if it succeeded or not

*********************************************************************************/

bool CRegisterObject::RequestPassword(const TDVCHAR *pUsername, const TDVCHAR *pEmail)
{
	CTDVString request = requestpasswordrequest;
	CTDVString username = pUsername;
	username.Replace("'","&quot;");
	CTDVString email = pEmail;
	email.Replace("'","&quot;");
	request.Replace("--**username**--", username);
	request.Replace("--**email**--", email);
	CTDVString response;
	m_InputContext.MakeCUDRequest(request, &response);
	bool bResult = true;

	if (m_pResultTree != NULL)
	{
		delete m_pResultTree;
		m_pResultTree = NULL;
	}
	m_pResultTree = CXMLTree::Parse(response);
	if (m_pResultTree != NULL)
	{
	  /* 
	     this is a bit glitchy. The CUD XML interface always
	     responds with an error even if the username and email are
	     valid (in which case it gives a password error). So interpret
	     if success if we get a password error, otherwise it
	     really is an error. 
	  */
		CXMLTree* pDetails = m_pResultTree->FindFirstTagName("CUD:DETAILS");
		if (pDetails == NULL)
		{
			return false;
		}
		else
		{
			CTDVString error;
			CTDVString status;
			CTDVString field;
			pDetails->GetAttribute("FIELD", field);
			pDetails->GetAttribute("ERROR", error);
			pDetails->GetAttribute("STATUS", status);
			if (field.CompareText("password"))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
	return false;
}


bool CRegisterObject::GetBBCCookie(CTDVString *oName, CTDVString *oDomain, CTDVString *oValue)
{
	if (m_pResultTree == NULL)
	{
		return false;
	}
	CXMLTree* pDetails = m_pResultTree->FindFirstTagName("CUD:COOKIEVALUE");
	if (pDetails == NULL)
	{
		return false;
	}
	else
	{
		pDetails->GetAttribute("DOMAIN", *oDomain);
		pDetails->GetAttribute("NAME", *oName);
		pDetails->GetTextContents(*oValue);
		oValue->Replace("\n","");
		oValue->Replace("\t","");
		return true;
	}


}

bool CRegisterObject::GetBBCUID(CTDVString *oUID)
{
	if (m_pResultTree == NULL)
	{
		return false;
	}

	CXMLTree* pDetails = m_pResultTree->FindFirstTagName("CUD:USER");
	if (pDetails == NULL)
	{
		return false;
	}
	else
	{
		pDetails->GetAttribute("ID",*oUID);
		return true;
	}
}

bool CRegisterObject::GetError(CTDVString *oError)
{
	if (m_pResultTree == NULL)
	{
		*oError = "noconn";
		return true;
	}

	CXMLTree* pDetails = m_pResultTree->FindFirstTagName("CUD:DETAILS");
	if (pDetails != NULL)
	{
		CTDVString status,field,error;
		pDetails->GetAttribute("ERROR", error);
		pDetails->GetAttribute("STATUS", status);
		pDetails->GetAttribute("FIELD", field);
		if (status.CompareText("unregistered"))
		{
			if (field.CompareText("password"))
			{
				if (error.CompareText("password insecure") || error.CompareText("invalid password"))
				{
					*oError = "invalidpass";
					return true;
				}
				else
				{
					*oError = "badpassword";
					return true;
				}
			}
			else if (field.CompareText("username"))
			{
				if (error.CompareText("username taken"))
				{
					*oError = "loginused";
					return true;
				}
				else if (error.CompareText("invalid username"))
				{
					*oError = "invaliduser";
					return true;
				}
			}
			else if (field.CompareText("email"))
			{
				*oError = "invalidemail";
				return true;
			}
		}
		else // we're registered, so must have been an update that failed.
		{
			CXMLTree* pUpdate = m_pResultTree->FindFirstTagName("CUD:UPDATE");
			if (pUpdate != NULL)
			{	
				CTDVString success,field,error;
				pUpdate->GetAttribute("ERROR", error);
				pUpdate->GetAttribute("SUCCESS", success);
				pUpdate->GetAttribute("FIELD", field);
				if (success.CompareText("n") )
				{
					// At he moment we only handle invalid passwords
					if (error.CompareText("invalid password"))
					{
						*oError = "invalidpassupdate";
						return true;
					}
				}
			}
		}
	}
	*oError = "noconn";
	return true;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

CLocalRegisterObject::CLocalRegisterObject(CInputContext& inputContext) : CRegisterBase(inputContext)
{

}

CLocalRegisterObject::~CLocalRegisterObject()
{
}



/*********************************************************************************

	bool CLocalRegisterObject::LoginUser(const TDVCHAR *pUsername, const TDVCHAR *pPassword)

	Author:		Jim Lynn
	Created:	20/08/2001
	Inputs:		pUserName - BBC Username
				pPassword - BBC password
	Outputs:	-
	Returns:	true if user logged in successfully
				false if failed to log in
	Purpose:	Tries to log in the given user. If the login fails, other methods
				can be called to find out why including one which will create some
				XML suitable for the registration page.

*********************************************************************************/

bool CLocalRegisterObject::LoginUser(const TDVCHAR *pUsername, const TDVCHAR *pPassword)
{
	CStoredProcedure sp;
	m_InputContext.InitialiseStoredProcedureObject(&sp);
	CTDVString UserName;
	CTDVString Cookie;
	CTDVString BBCUID;
	int iUserID;
	if (sp.LoginLocalUser(pUsername, pPassword, &iUserID, &UserName, &Cookie, &BBCUID))
	{
		m_BBCUID = BBCUID;
		return true;
	}
	else
	{
		return false;
	}
	
}

bool CLocalRegisterObject::RegisterUser(const TDVCHAR *pUserName, const TDVCHAR *pPassword, const TDVCHAR *pEmail)
{
	CStoredProcedure sp;
	m_InputContext.InitialiseStoredProcedureObject(&sp);
	CTDVString Cookie;
	int iUserID, iErrorCode;
	if (sp.RegisterLocalUser(pUserName, pPassword, pEmail, &iErrorCode, &iUserID, &Cookie, &m_BBCUID))
	{
		if (iErrorCode > 0)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	else
	{
		return false;
	}
}




/*********************************************************************************

	bool CLocalRegisterObject::UpdateEmail(const TDVCHAR *pUsername, const TDVCHAR *pPassword, const TDVCHAR *pEmail)

	Author:		Jonathan Sloman
	Created:	11/03/2002
	Inputs:		pUserName - BBC Username
			pPassword - BBC password
                        pEmail    - new Email address
	Outputs:	-
	Returns:	true if updated successfully
				false if failed 
	Purpose:	Tries to update the email record in the CUD for
                        the given user.

*********************************************************************************/

bool CLocalRegisterObject::UpdateEmail(const TDVCHAR* pUsername, const TDVCHAR* pPassword, const TDVCHAR* pEmail)
{
	return false;
}

/* note that 'email' is not specified in 'required' as if it is, it forces
   the update to include 'email' too - feature/bug in CUD XML interface */


/*********************************************************************************

	bool CLocalRegisterObject::UpdatePassword(const TDVCHAR *pUsername, const TDVCHAR *pPassword, const TDVCHAR *pNewPassword)

	Author:		Jonathan Sloman
	Created:	11/03/2002
	Inputs:		pUserName - BBC Username
			pPassword - BBC password
                        pNewPassword - new Password
	Outputs:	-
	Returns:	true if updated successfully
				false if failed 
	Purpose:	Tries to update the password in the CUD for
                        the given user.

*********************************************************************************/

bool CLocalRegisterObject::UpdatePassword(const TDVCHAR *pUsername, const TDVCHAR* pPassword, const TDVCHAR* pNewPassword)
{
	CStoredProcedure sp;
	m_InputContext.InitialiseStoredProcedureObject(&sp);
	return sp.UpdateLocalPassword(pUsername, pPassword, pNewPassword);
}


/*********************************************************************************

	bool CLocalRegisterObject::RequestPassword(const TDVCHAR *pUsername, const TDVCHAR *pEmail)

	Author:		Jonathan Sloman
	Created:	11/03/2002
	Inputs:		pUserName - BBC Username
			pEmail - BBC email address
	Outputs:	-
	Returns:	true if successful
				false if failed 
	Purpose:	Uses the newpassword action in the CUD to request
                        that a new password be issued to the specified user,
                        and an email sent to them containing it.

!! must sort out how to authenticate with CUD over XML interface
+ sort out how to test if it succeeded or not

*********************************************************************************/

bool CLocalRegisterObject::RequestPassword(const TDVCHAR *pUsername, const TDVCHAR *pEmail)
{
	return false;
}


bool CLocalRegisterObject::GetBBCCookie(CTDVString *oName, CTDVString *oDomain, CTDVString *oValue)
{
	*oDomain = "";
	*oValue = "";
	*oName = "";
	return true;
}

bool CLocalRegisterObject::GetBBCUID(CTDVString *oUID)
{
	*oUID = m_BBCUID;
	return true;
}

bool CLocalRegisterObject::GetError(CTDVString *oError)
{
	*oError = "badpassword";
	return true;
}

