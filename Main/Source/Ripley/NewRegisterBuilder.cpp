// NewRegisterBuilder.cpp: implementation of the CNewRegisterBuilder class.
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
#include "PageUI.h"
#include "tdvassert.h"
//#include "..\Crypto\md5.h"
#include "md5.h"
#include "NewRegisterBuilder.h"
#include "RegisterObject.h"
#include <ProfileApi.h>
#include "ProfileConnection.h"
#include "NotFoundBuilder.h"
#include "StoredProcedure.h"

#define __USE_CUD

#define __SECRETKEY "geheimnis"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CNewRegisterBuilder::CNewRegisterBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CNewRegisterBuilder::~CNewRegisterBuilder()
{

}

/*
	Replacing the perl script: should we simply do the bbcTest thing properly?
	No, because it doesn't let us do new things.

	We need to add the login and registration code to the parameters.
	For cmd=returning
		Either create or login the BBC user, then carry on with the existing code
*/

bool CNewRegisterBuilder::Build(CWholePage* pPage)
{
	/*
	// Fetch the parameters from the qeury
	CTDVString	sLoginName;
	CTDVString	sError;
	CTDVString	sCommand;

	m_InputContext.GetParamString("loginname", sLoginName);
	m_InputContext.GetParamString("error", sError);
	m_InputContext.GetParamString("cmd", sCommand);

	CTDVString sPassthrough;
	CTDVString sAction;
	CTDVString sURLparams;

	bool bRemember = m_InputContext.ParamExists("remember");

	bool bSuccess = true;

	if (sCommand.CompareText("start"))
	{
		if (!InitPage(pPage, "NEWREGISTER", true))
		{
			return false;
		}

		pPage->AddInside("H2G2","<NEWREGISTER STATUS='SHOWFORM' COMMAND='normal'/>");

		return true;
	}

	if (sCommand.CompareText("faststart"))
	{
		if (!InitPage(pPage, "NEWREGISTER", true))
		{
			return false;
		}

		pPage->AddInside("H2G2","<NEWREGISTER STATUS='SHOWFORM' COMMAND='fasttrack'/>");

		return true;
	}

	//can only call it in fasttrack to login now
	if (sCommand.CompareText("fasttrack"))
	{
		
		if (!InitPage(pPage, "NEWREGISTER", true))
		{
			return false;
		}

		CTDVString	sPassword1;
		
		m_InputContext.GetParamString("password", sPassword1);
		
		CProfileConnection* Connection = m_InputContext.GetProfileConnection();

		if (Connection == NULL)
		{
			//Add error message here
			bSuccess = false;
		}
		
		bSuccess = bSuccess && Connection->SetUser(sLoginName,sPassword1);
		
		bool bUserLoggedIn = false;
		bSuccess = bSuccess && Connection->CheckUserIsLoggedIn(bUserLoggedIn);

		if (!bUserLoggedIn)
		{
			unsigned int uiCanLogin = 0;
			bSuccess = bSuccess && Connection->LoginUser(uiCanLogin);
			if (bSuccess && uiCanLogin == CANLOGIN_LOGGEDIN)
			{
				bUserLoggedIn = true;
			}
		}

		//now set the SSO cookie if they are logged in
		if (bSuccess && bUserLoggedIn)
		{
			CTDVString sSsoCookie;
			bSuccess = bSuccess && Connection->GetCookieValue(bRemember,sSsoCookie);

			CStoredProcedure SP;
			if (m_InputContext.InitialiseStoredProcedureObject(&SP))
			{
				bSuccess = SP.GetUserFromUserID(Connection->, m_InputContext.GetSiteID());
			}
	
			if (bSuccess)
			{
				CUser thisuser(m_InputContext);
				bSuccess = thisuser.CreateFromID(Connection->GetUserId());
				thisuser.SetUserLoggedIn();
				bSuccess = bSuccess && thisuser.SetSiteID(m_InputContext.GetSiteID());
				CTDVString sPrefSkin;
				bSuccess = bSuccess && thisuser.GetPrefSkin(&sPrefSkin);
				bSuccess = bSuccess && m_InputContext.SetSkin(sPrefSkin);
				
				CTDVString sXML;
				sXML << "<NEWREGISTER STATUS='LOGGEDIN' COMMAND='" << sCommand << "'>";
				sXML << "<USERID>" << (int) Connection->GetUserId() << "</USERID>";
				sXML 	<< "<FIRSTTIME>" << 0 << "</FIRSTTIME>";
				sXML 	<< "</NEWREGISTER>";
				pPage->AddInside("H2G2", sXML);
				
				 
				/////////////////////////////////////////////////////////////////////////////
				// Now set the cookie
				//sXML = "<SETCOOKIE><COOKIE>";
				//sXML << sSsoCookie << "</COOKIE>\n";
				//if (!bRemember)
				//{
				//	sXML << "<MEMORY/>";
				//}
				//sXML << "<NAME>" << CProfileApi::GetCookieName() << "</NAME>";
				//sXML << "</SETCOOKIE>";
				
				//pPage->AddInside("H2G2", sXML);
				///////////////////////////////////////////////////////////////////////////////
				
				
				//declare cookie instance (can be more than one)
				CXMLCookie oXMLCookie (CProfileApi::GetCookieName(), sSsoCookie, "", (bRemember==false) );	
						
				//add to page object 
				pPage->SetCookie( oXMLCookie );
			}
		}
		else
		{
			CTDVString sXML;
			sXML << "<NEWREGISTER STATUS='LOGINFAILED' COMMAND='fasttrack'/>";
			pPage->AddInside("H2G2", sXML);
		}

		return true;
	}	
	else
	{
		CNotFoundBuilder NotFound(m_InputContext);
		return NotFound.Build(pPage);
	}
	
*/	
	return false;
}


