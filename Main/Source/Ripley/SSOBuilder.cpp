// SSOBuilder.cpp: implementation of the CSSOBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "SSOBuilder.h"
#include "Postcoder.h"
#include "ProfileConnection.h"
#include "XMLStringUtils.h"
#include "User.h"
#include "tdvassert.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSSOBuilder::CSSOBuilder(CInputContext& inputContext) : 
CXMLBuilder(inputContext),
m_pPage(NULL)
{

}

CSSOBuilder::~CSSOBuilder()
{

}

/*********************************************************************************
bool CSSOBuilder::Build()
Author:		Martin Robb
Created:	
Returns:	false in case of an error
Purpose:	Examines parameters, builds xml
*********************************************************************************/
bool CSSOBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	if (!InitPage(m_pPage, "NEWREGISTER",true))
	{
		return false;
	}

	if (m_InputContext.ParamExists("ssoc"))
	{
		CTDVString sSsoAction;
		m_InputContext.GetParamString("ssoc",sSsoAction,0);

		if (sSsoAction.CompareText("register"))
		{
			return GetPostcodeFromUser();
		}
		else if (sSsoAction.CompareText("postcode"))
		{
			return VerifyPostcode();
		}
		else if (sSsoAction.CompareText("signout"))
		{
			return UserSignedOut();
		}
		else if (sSsoAction.CompareText("notme"))
		{
			return UserSaidNotMe();
		}
		else if(sSsoAction.CompareText("addservice"))
		{
			return true;
		}
		else
		{
			return UnknownAction();
		}
	}
	else
	{
		return ErrorMessage("BADPARAM","The url you called was has invalid parameters");
	}
	

	return false;
}

/*********************************************************************************
bool CSSOBuilder::UnknownAction()
Author:		Igor Loboda
Created:	16/02/2005
Returns:	false in case of an error
Purpose:	Generates <NEWREGISTER> element depending on
			whether there is a current user and he/she is
			signed in and logged in
*********************************************************************************/

bool CSSOBuilder::UnknownAction()
{
	CTDVString sNewRegister;
	CUser* pUser = m_InputContext.GetSignedinUser();
	if (pUser == NULL)
	{
		sNewRegister = "<NEWREGISTER STATUS='NOTSIGNEDIN'>";
	}
	else if (pUser->IsUserLoggedIn())
	{
		return UserNewRegister(false);
	}
	else if (pUser->GetIsInBannedEmailList())
	{
		sNewRegister = "<NEWREGISTER STATUS='RESTRICTED'>";
	}
	else
	{
		sNewRegister = "<NEWREGISTER STATUS='NOTLOGGEDIN'>";
	}

	CTDVString sPassThrough;
	CTDVString sURLParams;
	GetPassThrough(sPassThrough, sURLParams);
	if (!sPassThrough.IsEmpty())
	{
		sNewRegister << sPassThrough;
	}

	sNewRegister << "</NEWREGISTER>";

	m_pPage->AddInside("H2G2", sNewRegister);
	return true;
}

/*********************************************************************************
bool CSSOBuilder::GetPostcodeFromUser()
Author:		
Created:	
Returns:	false in case of an error
Purpose:	Generates <NEWREGISTER> element depending on whether a postcode is required.
			Synchronises user with profile.
*********************************************************************************/
bool CSSOBuilder::GetPostcodeFromUser()
{
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	
	if (pViewingUser == NULL)
	{
		return ErrorMessage("NOUSER","There was no user");
	}

	CProfileConnection* Connection = m_InputContext.GetProfileConnection();

	if (Connection == NULL)
	{
		return ErrorMessage("NOCONNECTION","There was no connection");
	}

	CTDVString sPostcode;
	if (Connection->AttributeExistsForService("postcode"))
	{
		CTDVString sRegistrationXML;
		sRegistrationXML << "<NEWREGISTER>";

		// Try to find the BBC Postcoder cookie and prefill with that.
		CTDVString sPostcode;
		if (GetPostcodeFromCookie(sPostcode))
		{
			sRegistrationXML << "<POSTCODE>" << sPostcode << "</POSTCODE>";
		}
		else
		{
			sRegistrationXML << "<POSTCODE />";
		}

		sRegistrationXML << "</NEWREGISTER>";

		m_pPage->AddInside("H2G2", sRegistrationXML);

		//Synchronise with Profile - do not create NewRegister XML as it has been done here.
		return UserNewRegister(true, false, true);
	}

	return UserNewRegister(true);
}

/*********************************************************************************
bool CSSOBuilder::VerifyPostcode()
Author:		
Created:	
Returns:	false in case of an error
Purpose:	Verifies the postcode parameter
*********************************************************************************/
bool CSSOBuilder::VerifyPostcode()
{
	if (!m_InputContext.ParamExists("postcode"))
	{
		return ErrorMessage("NOPOSTCODE","failed to submit a postcode");
	}

	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	if (pViewingUser == NULL)
	{
		return ErrorMessage("NOUSER","There was no user");
	}

	CPostcoder Postcoder(m_InputContext);

	CTDVString sPostcode;
	bool bGotPostcode = false;

	m_InputContext.GetParamString("postcode",sPostcode);
	
	if (sPostcode.GetLength() > 0)
	{
		Postcoder.MakePlaceRequest(sPostcode, bGotPostcode);
		if (bGotPostcode) 
		{
			CTDVString sPostcode;
			CTDVString sArea;
			CTDVString sAuthID;
			int iNode = 0;
			Postcoder.PlaceHitPostcode(sPostcode, sAuthID, sArea, iNode);
//			pViewingUser->SetPostcode(sPostcode);
//			pViewingUser->SetArea(sArea);
//			pViewingUser->SetTaxonomyNode(iNode);
//			pViewingUser->UpdateDetails();

			// Update the users details
			if (!Postcoder.UpdateUserPostCodeInfo(sPostcode,sArea,iNode))
			{
				CTDVString sMsg = "<NEWREGISTER><POSTCODE><POSTCODEERROR>";
				sMsg << sPostcode << "</POSTCODEERROR></POSTCODE></NEWREGISTER>";
				m_pPage->AddInside("H2G2",sMsg);
				return true;
			}

			//Generate NewRegister XML - synchronisation has already been done.
			return UserNewRegister(true,true,false);
		}
		else
		{
			CTDVString sMsg = "<NEWREGISTER><POSTCODE><BADPOSTCODE>";
			sMsg << sPostcode << "</BADPOSTCODE></POSTCODE></NEWREGISTER>";
			m_pPage->AddInside("H2G2",sMsg);
			return true;
		}
	}
	else
	{
		return ErrorMessage("NOPOSTCODE","Invalid postcode");
	}
}

/*********************************************************************************

	CWholePage* CSSOBuilder::UserNewRegister(bool bFirstTime, bCreateXML, bSynchronise)

	Author:		Dharmesh Raithatha
	Created:	9/10/2003
	Inputs:		Inputs:		bool bFirstTime - false means that it is a returning user,  true it is a new registration. 
								ie true if user has registered rather than an existing user agreeing terms for another site.
				bCreateXML		- Will create NEWREGISTER XML block if requested.
				bSynchronise	- Will update sso details to database i ftrue.
	Outputs:	-
	Returns:	-
	Purpose:	SSO has called DNA saying that it has logged someone in. This method
				will present the user with the various options based on the returning
				url. 

*********************************************************************************/

bool CSSOBuilder::UserNewRegister(bool bFirstTime, bool bCreateXML, bool bSynchronise )
{

	CUser* pUser = m_InputContext.GetCurrentUser();
	
	//there should be a user because they have just logged in!
	if (pUser == NULL)
	{
		return ErrorMessage("NOTSIGNEDIN","The user was not signed in");
	}
	
	//user has logged in successfully from the inputcontext and actually

	if (pUser->IsUserLoggedIn())
	{
		if ( bSynchronise ) 
		{
			//Synchronisation with SSO is done on creation of new user in DNA.
			//Synchronisation will also be done in CRipley::HandleRequest() if s_sync=1 specified.
			//Could have a flag on User indicating that it has been synchronised.
			if ( !pUser->IsSynchronised() )
			{
				pUser->SynchroniseWithProfile(false);
			}
		}

		if ( bCreateXML )
		{

			CTDVString sPassThrough, sURLParams;
			GetPassThrough(sPassThrough,sURLParams);
			
			CTDVString sNewRegister = "<NEWREGISTER STATUS='LOGGEDIN'>";
			if (!sPassThrough.IsEmpty())
			{
				sNewRegister << sPassThrough;
			}

			sNewRegister << "<USERID>" << pUser->GetUserID() << "</USERID>";

			sNewRegister << "<FIRSTTIME>";

			if (bFirstTime)
			{
				sNewRegister << "1";
			}
			else
			{
				sNewRegister << "0";
			}

			sNewRegister << "</FIRSTTIME></NEWREGISTER>";

			m_pPage->AddInside("H2G2",sNewRegister);
		}

		// Now set the h2g2 cookie if they are an editor so that 
		// the perl tools will work.
		CTDVString sCookie;
		if (pUser->GetIsEditor() && pUser->GetCookie(sCookie))
		{
			/*
			CTDVString sXML = "<SETCOOKIE><COOKIE>";
			sXML << sCookie << "</COOKIE>\n";
			sXML << "</SETCOOKIE>";			
			m_pPage->AddInside("H2G2",sXML);
			*/
			
			//declare cookie instance (can be more than one)
			CXMLCookie oXMLCookie ("", sCookie, "", false );	
					
			//add to page object 
			m_pPage->SetCookie( oXMLCookie );		
		}
		
	}
	else
	{
		return ErrorMessage("NOTLOGGEDIN","The user was not logged in");
	}
							
	return true;
}

/*********************************************************************************
bool CSSOBuilder::GetPassThrough()
Author:		
Created:	
Returns:	false in case of an error
Purpose:	Gets passthrough parameter and adds to XML.
*********************************************************************************/
bool CSSOBuilder::GetPassThrough(CTDVString& sPassThrough,CTDVString& sURLParams)
{
	CTDVString sAction;
	
	if (m_InputContext.GetParamString("pa", sAction))
	{
		int iPassCount = m_InputContext.GetParamCount("pt");
		sPassThrough = "<REGISTER-PASSTHROUGH ACTION='";
		sURLParams << "&amp;pa=" << sAction;
		sPassThrough << sAction << "'>";
		for (int iCount = 0; iCount < iPassCount; iCount++)
		{
			CTDVString sName;
			m_InputContext.GetParamString("pt", sName, iCount);
			CTDVString sValue;
			m_InputContext.GetParamString(sName, sValue);
			CXMLObject::EscapeAllXML(&sValue);
			sPassThrough << "<PARAM NAME='" << sName << "'>" << sValue << "</PARAM>";
			
			// Now do the URL version
			sURLParams << "&amp;pt=" << sName;
			sURLParams << "&amp;" << sName << "=" << sValue;
		}
		sPassThrough << "</REGISTER-PASSTHROUGH>";
		return true;
	}

	return false;
}


bool CSSOBuilder::UserSignedOut()
{

	if (m_InputContext.GetCurrentUser() == NULL)
	{
		m_pPage->SetPageType("LOGOUT");
		m_pPage->AddInside("H2G2","<CLEARCOOKIE/>");
		return true;
	}

	return ErrorMessage("NOTLOGGEDOUT","You are not logged out");
}
	
bool CSSOBuilder::UserSaidNotMe()
{

	if (m_InputContext.GetCurrentUser() == NULL)
	{
		m_pPage->SetPageType("LOGOUT");
		return true;
	}

	return ErrorMessage("NOTME","Unable to sign out current user");
}

bool CSSOBuilder::UserChangedDetails()
{
	return false;
}
	


/*********************************************************************************

	CWholePage* CSSOBuilder::ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg)

	Author:		Dharmesh Raithatha
	Created:	5/23/2003
	Inputs:		sType - type of error
				sMsg - Defualt message
	Outputs:	-
	Returns:	whole xml page with error
	Purpose:	default error message

*********************************************************************************/

bool CSSOBuilder::ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg)
{

	if (!InitPage(m_pPage, "NEWREGISTER",true))
	{
		return false;
	}

	CTDVString sError = "<ERROR TYPE='";
	sError << sType << "'>" << sMsg << "</ERROR>";

	m_pPage->AddInside("H2G2", sError);

	return true;
}

/*********************************************************************************

	CWholePage* CSSOBuilder::LoginErrorMessage(int iSsoResult)

	Author:		Dharmesh Raithatha
	Created:	9/10/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Creates an error message page based on the result from sso.

*********************************************************************************/

bool CSSOBuilder::LoginErrorMessage(int iSsoResult)
{
	if (iSsoResult == CANTLOGIN_MANDATORY_MISSING)
	{
		return ErrorMessage("CANT-LOGIN-MANDATORY-MISSING","Unable to log the user as their is a mandotory field missing");
	}
	else if (iSsoResult == CANTLOGIN_NOT_VALIDATED)
	{
		return ErrorMessage("CANT-LOGIN-NOT-VALIDATED","Unable to log the user as they need to validate their account");
	}
	else if (iSsoResult == CANTLOGIN_CHANGE_PASSWORD)
	{
		return ErrorMessage("CANT-LOGIN-CHANGE-PASSWORD","Unable to log the user as they need to change their password");
	}
	else if (iSsoResult == CANTLOGIN_NOT_REGISTERED)
	{
		return ErrorMessage("CANT-LOGIN-NOT-REGISTERED","Unable to log the user as their are not registered");
	}
	else if (iSsoResult == CANTLOGIN_SERVICE_AGREEMENT)
	{
		return ErrorMessage("CANT-LOGIN-SERVICE-AGREEMENT","Unable to log the user has not accepted their service agreement");
	}
	else if (iSsoResult == CANTLOGIN_GLOBAL_AGREEMENT)
	{
		return ErrorMessage("CANT-LOGIN-GLOBAL-AGREEMENT","Unable to log the user has not accepted their global agreement");
	}
	else if (iSsoResult == CANTLOGIN_SQBLOCK)
	{
		return ErrorMessage("CANT-LOGIN-SQBLOCK","Unable to log the user in as their was a secret question block");
	}
	else if (iSsoResult == CANTLOGIN_PASSBLOCK)
	{
		return ErrorMessage("CANT-LOGIN-PASSBLOCK","Unable to log the user in as their password has been blocked");
	}
	else if (iSsoResult == CANTLOGIN_BANNED)
	{
		return ErrorMessage("CANT-LOGIN-BANNED","Unable to log the user in as they were banned");
	}
	else if (iSsoResult == CANTLOGIN_INCORRECT_AUTHENTICATION_TYPE)
	{
		return ErrorMessage("INCORRECT-AUTHENTICATION-TYPE","Incorrect Authentication");
	}
	else if (iSsoResult == CANTLOGIN_NOT_VALID)
	{
		return ErrorMessage("CANT-LOGIN-NOT-VALID","The login is not valid");
	}

	return ErrorMessage("NO-SSO-RESULT","Unable to identify the result from Single Sign On");	

}


/*********************************************************************************

	bool CSSOBuilder::GetPostcodeFromCookie(CTDVString& sPostcode)

	Author:		David van Zijl
	Created:	18/10/2004
	Inputs:		-
	Outputs:	sPostCode
	Returns:	true if postcode found
	Purpose:	Tries to get the user's postcode from the BBCpostcoder cookie
				(if it exists)
				CPostcoder::GetPostcodeFromCookie() does the same thing!! 

*********************************************************************************/

bool CSSOBuilder::GetPostcodeFromCookie(CTDVString& sPostcode)
{
	CTDVString sCookieValue;
	if (m_InputContext.GetCookieByName(POSTCODER_COOKIENAME , sCookieValue))
	{
		// Found the cookie
		// Try to extract the postcode. The cookie val is a string of values
		// delimited with colons.
		//
		std::vector<CTDVString> postcoderArray;
		CXMLStringUtils::Split(sCookieValue, ":", postcoderArray);

		if (postcoderArray.size() > 0) // at least 1 element
		{
			std::vector<CTDVString>::iterator i;

			for (i = postcoderArray.begin(); i != postcoderArray.end(); i++)
			{
				// The bit we're looking for looks like this: 'PST###'
				// where ### is the proper postcode.
				//
				if ( (*i).Find(POSTCODER_IDENTIFIER) == 0 )
				{
					// Got it!
					// 
					sPostcode = *i;
					sPostcode.RemoveLeftChars(strlen(POSTCODER_IDENTIFIER));
					return (sPostcode.GetLength() > 0);
				}
			}
		}
	}

	// Not found :(
	//
	return false;
}
