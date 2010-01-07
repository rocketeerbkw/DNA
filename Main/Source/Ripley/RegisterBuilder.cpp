// RegisterBuilder.cpp: implementation of the CRegisterBuilder class.
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
#include "RegisterBuilder.h"
#include "StoredProcedure.h"
#include "xmlcookie.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CRegisterBuilder::CRegisterBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CRegisterBuilder::~CRegisterBuilder()
{

}

bool CRegisterBuilder::Build(CWholePage* pPage)
{
	// Fetch all the parameters, we'll cope with the missing ones later
	CTDVString sEmail;
	CTDVString sPassword;
	CTDVString sCommand;
	CTDVString sKey;
	int iUserID;
	int iKey;
	bool bRemember = m_InputContext.ParamExists("remember");
	m_InputContext.GetParamString("email", sEmail);
	m_InputContext.GetParamString("password", sPassword);
	m_InputContext.GetParamString("cmd", sCommand);
	m_InputContext.GetParamString("key", sKey);
	// Correct for possible =3D problems
	if (sKey.Left(2).CompareText("3D"))
	{
		sKey.RemoveLeftChars(2);
	}
	iKey = atoi(sKey);
	
	iUserID = m_InputContext.GetParamInt("userid");

	bool bGotPassword = (sPassword.GetLength() > 0);
	bool bGotEmail = ((sEmail.GetLength() > 4) && (sEmail.Find('@') > 0) && (sEmail.Find(".") > 0));
	bool bGotActualPassword = false;

	bool bPageSuccess = false;
	bPageSuccess = InitPage(pPage, "REGISTER",true);
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	
	bool bSuccess = bPageSuccess;

	// Get the ID of the viewing user
	int iViewingUserID = 0;
	if (pViewingUser != NULL)
	{
		iViewingUserID = pViewingUser->GetUserID();
	}

	if (sCommand.CompareText("cancelaccount"))
	{
		CTDVString sXML = "<REGISTER STATUS='CONFIRMCANCEL'>";
		sXML << "<USERID>" << iUserID << "</USERID>";
		sXML << "<SECRETKEY>" << sKey << "</SECRETKEY>";
		sXML << "</REGISTER>";
		pPage->AddInside("H2G2", sXML);
	}
	else if (sCommand.CompareText("showterms") && m_InputContext.ParamExists("userid"))
	{
		CStoredProcedure SP;
		
		if (m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			CTDVString sReason;
			CTDVDateTime dReleased;
			int iResult;
			int iActive;
			SP.VerifyUserKey(iUserID, iKey, &iResult, &sReason, &sEmail, &dReleased, &iActive);
			if (iResult == 0)
			{
				CTDVString sXML = "<REGISTER STATUS='CONFIRMTERMS'>";
				sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
				sXML << "<SECRETKEY>" << sKey << "</SECRETKEY>";
				sXML << "<ACTIVE>" << iActive << "</ACTIVE>";
				sXML << "</REGISTER>";
				pPage->AddInside("H2G2", sXML);
			}
			else if (iResult < 3)	// Suspended account
			{
				CTDVString sXML = "<REGISTER STATUS='ACCOUNTSUSPENDED'>";
				sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
				sXML << "<SECRETKEY>" << sKey << "</SECRETKEY>";
				sXML << "<ERRORRESULT>" << iResult << "</ERRORRESULT>";
				sXML << "<ERRORREASON>" << sReason << "</ERRORREASON>";
				sXML << "<ACTIVE>" << iActive << "</ACTIVE>";
				if (iResult == 2)
				{
					CTDVString sDate;
					dReleased.GetAsXML(sDate);
					sXML << "<DATERELEASED>" << sDate << "</DATERELEASED>";
				}
				sXML << "</REGISTER>";
				pPage->AddInside("H2G2", sXML);
			}
			else
			{
				CTDVString sXML = "<REGISTER STATUS='TERMSERROR'>";
				sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
				sXML << "<SECRETKEY>" << sKey << "</SECRETKEY>";
				sXML << "<ERRORRESULT>" << iResult << "</ERRORRESULT>";
				sXML << "<ERRORREASON>" << sReason << "</ERRORREASON>";
				sXML << "<ACTIVE>" << iActive << "</ACTIVE>";
				sXML << "</REGISTER>";
				pPage->AddInside("H2G2", sXML);
			}
		}
	}
	else if (sCommand.CompareText("docancel") && m_InputContext.ParamExists("confirm"))
	{
		// Someone wants to cancel this account
		CTDVString sKey;
		m_InputContext.GetParamString("key", sKey);
		int iUserID = m_InputContext.GetParamInt("userid");
		CStoredProcedure SP;
		
		int iResult = 0;
		CTDVString sReason;
		if (m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			CTDVString sIPaddress;
			m_InputContext.GetClientAddr(sIPaddress);
			SP.CancelUserAccount(iUserID, sKey, &iResult, &sReason);
			SP.LogUserCancelled(iViewingUserID, sIPaddress, iUserID);

		}
		CTDVString sXML;
		if (iResult == 0)
		{
			sXML= "<REGISTER STATUS='CANCELLED'>";
			sXML << "<USERID>" << iUserID << "</USERID>";
			sXML << "<SECRETKEY>" << sKey << "</SECRETKEY>";
			sXML << "</REGISTER>";
		}
		else
		{
			sXML= "<REGISTER STATUS='CANCELERROR'>";
			sXML << "<USERID>" << iUserID << "</USERID>";
			sXML << "<SECRETKEY>" << sKey << "</SECRETKEY>";
			sXML << "<CANCELRESULT>" << iResult << "</CANCELRESULT>";
			sXML << "<CANCELREASON>" << sReason << "</CANCELREASON>";
			sXML << "</REGISTER>";
		}
		pPage->AddInside("H2G2", sXML);
	}
	else if (sCommand.CompareText("docancel") && m_InputContext.ParamExists("noconfirm"))
	{
		CTDVString sKey;
		m_InputContext.GetParamString("key", sKey);
		int iUserID = m_InputContext.GetParamInt("userid");
		CTDVString sXML = "<REGISTER STATUS='NOTCANCELLED'>";
		sXML << "<USERID>" << iUserID << "</USERID>";
		sXML << "<SECRETKEY>" << sKey << "</SECRETKEY>";
		sXML << "</REGISTER>";
		pPage->AddInside("H2G2", sXML);
	}
	// if there isn't a valid email address
	else if (!bGotEmail)
	{
		if (sEmail.GetLength() <= 0)
		{
			// if no email provided at all then we have no details
			pPage->AddInside("H2G2","<REGISTER STATUS='NODETAILS'/>");
		}
		else
		{
			// if a malformed email provided then must give an error message
			CTDVString sXML = "<REGISTER STATUS='BADEMAIL'>";
			sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
			sXML << "</REGISTER>";
			pPage->AddInside("H2G2", sXML);
		}
	}
	else
	{
		// They type something, let's store it
		// Get a stored procedure object
		CStoredProcedure SP;
		bSuccess = bSuccess && m_InputContext.InitialiseStoredProcedureObject(&SP);
		if (bSuccess)
		{
			// First, log the registration attempt
			CTDVString sIPaddress;
			m_InputContext.GetClientAddr(sIPaddress);
			SP.LogRegistrationAttempt(iViewingUserID, sEmail, sIPaddress);
			
			// Call the database and find out if they're already registered
			CTDVString sActualPassword;
			CTDVString sCookie;
			CTDVString sKey;
			int iUserID = 0;
			bool bExists = false;
			bool bNew = false;

			bSuccess = SP.StoreEmailRegistration(sEmail, &sCookie, &sKey, &sActualPassword, &iUserID, &bExists, &bNew);
			if (bSuccess)
			{
				// Set flag telling us if the user has a password in the database
				bGotActualPassword = (sActualPassword.GetLength() > 0);

				// if they don't already exist...
				if (!bExists || sCommand.CompareText("accept"))
				{
					// If they are completely new
					if (bNew || sCommand.CompareText("showterms")|| (!bNew && !sCommand.CompareText("accept")))
					{
						CTDVString sXML = "<REGISTER STATUS='CONFIRMTERMS'>";
						sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
						sXML << "<SECRETKEY>" << sKey << "</SECRETKEY>";
						sXML << "<USERID>" << iUserID << "</USERID>";
						if (bExists)
						{
							sXML << "<ACTIVE>1</ACTIVE>";
						}
						else
						{
							sXML << "<ACTIVE>0</ACTIVE>";
						}
						sXML << "</REGISTER>";
						pPage->AddInside("H2G2", sXML);
					}
					else
					{
						if (sCommand.CompareText("accept"))
						{
							// Coming from the terms page - either accepted or not
							if (m_InputContext.ParamExists("accept"))
							{
								// Yes, they've accepted
								CTDVString sPassword1;
								CTDVString sQueryKey;		// Key from the query
								m_InputContext.GetParamString("password1", sPassword1);
								m_InputContext.GetParamString("key", sQueryKey);
								// Check both passwords match
								if (sPassword != sPassword1)
								{
									// No, reask
									CTDVString sXML = "<REGISTER STATUS='UNMATCHEDPASSWORD'>";
									sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
									sXML << "<SECRETKEY>" << sKey << "</SECRETKEY>";
									if (bExists)
									{
										sXML << "<ACTIVE>1</ACTIVE>";
									}
									else
									{
										sXML << "<ACTIVE>0</ACTIVE>";
									}
									sXML << "</REGISTER>";
									pPage->AddInside("H2G2", sXML);
								}
								else if (sKey != sQueryKey)
								{
									// keys don't match - unusual
									pPage->AddInside("H2G2", "<REGISTER STATUS='BADKEY'/>");
								}
								else if (sPassword.GetLength() < 1)
								{
									// blank password
									CTDVString sXML = "<REGISTER STATUS='BLANKPASSWORD'>";
									sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
									sXML << "<SECRETKEY>" << sKey << "</SECRETKEY>";
									if (bExists)
									{
										sXML << "<ACTIVE>1</ACTIVE>";
									}
									else
									{
										sXML << "<ACTIVE>0</ACTIVE>";
									}
									sXML << "</REGISTER>";
									pPage->AddInside("H2G2", sXML);
								}
								else
								{
									SendRegistrationEmail(sEmail, "RegistrationNew", iUserID, sKey);
									// fast-track complete. Let's cookie
									int iKey = atoi(sKey);
									CTDVString sTempCookie;
									SP.ActivateUser(iUserID, iKey, &sTempCookie);
									SP.ChangePassword(iUserID, sPassword);
									CTDVString sXML = "<REGISTER STATUS='LOGGEDIN'>\n";
									sXML << "<USERID>" << iUserID << "</USERID>";
									if (bExists)
									{
										sXML << "<ACTIVE>1</ACTIVE>";
									}
									else
									{
										sXML << "<ACTIVE>0</ACTIVE>";
									}
									sXML << "</REGISTER>\n";
									pPage->AddInside("H2G2", sXML);

									/*
									/////////////////////////////////////////////////////////////////////////
									sXML = "<SETCOOKIE><COOKIE>";
									sXML << sCookie << "</COOKIE>\n";
									sXML << "</SETCOOKIE>";
									pPage->AddInside("H2G2", sXML);
									///////////////////////////////////////////////////////////////////////
									*/

									//declare cookie instance (can be more than one)
									CXMLCookie oXMLCookie ("", sCookie, "", false );	
											
									//add to page object 
									pPage->SetCookie( oXMLCookie );																	
								}

							}
							else
							{
								// No, not accepted
								int iResult = 0;
								CTDVString sReason;
								CTDVString sIPaddress;
								m_InputContext.GetClientAddr(sIPaddress);
								SP.CancelUserAccount(iUserID, sKey, &iResult, &sReason);
								SP.LogUserCancelled(iViewingUserID, sIPaddress, iUserID);
								CTDVString sXML = "<REGISTER STATUS='REJECTEDTERMS'>";
								sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
								sXML << "<SECRETKEY>" << sKey << "</SECRETKEY>";
								sXML << "</REGISTER>";
								pPage->AddInside("H2G2", sXML);
							}
						}
						else
						{
							// Send them the email
							SendRegistrationEmail(sEmail, "RegistrationNew", iUserID, sKey);
							pPage->AddInside("H2G2", "<REGISTER STATUS='NEWEMAIL'/>");
						}
					}
				}
				else
				{
					// They already exist - see if it's the person who's logged on
					if (iUserID == iViewingUserID)
					{
						// Tell them they's already logged on
						CTDVString sXML;
						sXML << "<REGISTER STATUS='ALREADY'>";
						sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
						sXML << "</REGISTER>";
						pPage->AddInside("H2G2", sXML);
					}
					else
					{
						// It's not the current viewing user, so see if the
						// details we got included a password
						if (bGotPassword && bGotActualPassword)
						{
							// There's a password and the user has typed one
							// do they match?
							if (sPassword == sActualPassword)
							{
								// it's them - send them a cookie in the XML
								// Warning: Don't try and add trees with two roots
								CTDVString sXML = "<REGISTER STATUS='LOGGEDIN'>\n";
								sXML << "<USERID>" << iUserID << "</USERID>";
								sXML << "<ACTIVE>1</ACTIVE>";
								sXML << "</REGISTER>\n";
								pPage->AddInside("H2G2", sXML);
								
								/*
								////////////////////////////////////////////////////////////////////////////////
								sXML = "<SETCOOKIE><COOKIE>";
								sXML << sCookie << "</COOKIE>\n";
								if (!bRemember)
								{
									sXML << "<MEMORY/>";
								}
								sXML << "</SETCOOKIE>";
								pPage->AddInside("H2G2", sXML);
								////////////////////////////////////////////////////////////////////////////////
								*/

								//declare cookie instance (can be more than one)
								CXMLCookie oXMLCookie ("", sCookie, "", (bRemember==false) );	
										
								//add to page object 
								pPage->SetCookie( oXMLCookie );
							}
							else
							{
								// Passwords don't match
								pPage->AddInside("H2G2", "<REGISTER STATUS='BADPASSWORD'/>");
							}
						}
						else
						{
							// either they didn't send a password or their account hasn't got one
							// Ask them if they haven't had a chance to enter one
							// (i.e. cmd != "withpassword")
							if (bGotActualPassword && (!sCommand.CompareText("withpassword")))
							{
								CTDVString sXML;
								sXML << "<REGISTER STATUS='ASKPASSWORD'>";
								sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
								sXML << "</REGISTER>";
								pPage->AddInside("H2G2", sXML);
							}
							else
							{
								// Just resend the registration email again
								SendRegistrationEmail(sEmail, "RegistrationExisting", iUserID, sKey);
								pPage->AddInside("H2G2", "<REGISTER STATUS='OLDEMAIL'/>");
							}
						}
					}
				}
			}
		}
	}	
	return bPageSuccess;
}

bool CRegisterBuilder::SendRegistrationEmail(const TDVCHAR *pEmail, const TDVCHAR *pWhichEmail, int iUserID, const TDVCHAR* pKey)
{
	CTDVString sURL;
	CTDVString sCancelURL;
	CTDVString sShowTermsURL;
	CTDVString sDomain;
	m_InputContext.GetDomainName(sDomain);
	sURL = "http://";
	sURL << sDomain << "/U";
	sURL << iUserID << "?key=" << pKey;
	sCancelURL	<< "http://" 
				<< sDomain 
				<< "/CancelMe" 
				<< iUserID
				<< "&key="
				<< pKey;
	sShowTermsURL << "http://"
					<< sDomain
					<< "/ShowTerms"
					<< iUserID
					<< "&key="
					<< pKey;
	CTDVString sPersonalSpace = "http://";
	sPersonalSpace << sDomain << "/U" << iUserID;
	CTDVString sBody;
	CTDVString sSubject;
	bool bSuccess = false;
	CStoredProcedure SP;
	
	if (m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		if (SP.FetchEmailText(m_InputContext.GetSiteID(), pWhichEmail, 
			&sBody, &sSubject))
		{
			sBody.Replace("++**activate**++",sURL);
			sBody.Replace("++**cancelreg**++",sCancelURL);
			sBody.Replace("++**showterms**++", sShowTermsURL);
			sBody.Replace("++**personalspace**++", sPersonalSpace);
			if (SendMail(pEmail, sSubject, sBody))
			{
				bSuccess = true;
			}
		}
		else
		{
			TDVASSERT(false, "Failed to fetch email in SendRegistrationEmail");
		}
	}
	else
	{
		TDVASSERT(false, "Failed to create stored procedure object");
	}
	return bSuccess;
/*
	= "Thank you for applying to become a field researcher for the \r\n\
Hitchhiker's Guide to the Galaxy.\r\n\
\r\n\
At the end of this email are a set of rules which you must read and \r\n\
accept before you can complete the registration process. A full \r\n\
version of these rules is available for perusal at \r\n\
http://www.h2g2.com/beware/of/the/leopard\r\n\
\r\n\
If you accept these rules, follow the link below to complete the\r\n\
registration process...";
	sBody << "\r\n" << pURL;
	sBody << "\r\n\
\r\n\
 ... at which point you'll be able to create your own pages and take \r\n\
part in discussions.\r\n\
\r\n\
If you choose not to accept these terms and conditions you need do \r\n\
nothing. (You'll still be able to read the guide by visiting \r\n\
http://www.h2g2.com )\r\n\
\r\n\
Best wishes,\r\n\
\r\n\
Mark Moxon\r\n\
Editor, The Hitchhiker's Guide to the Galaxy, Earth Edition\r\n\
\r\n\
Rules\r\n\
-----\r\n\
Right. Rules. The lawyers said we had to have some. They asked us what\r\n\
rules we wanted.\r\n\
\r\n\
We said we didn't really know much about rules and couldn't we just \r\n\
have the same rules that everyone else has because they  seem to be \r\n\
getting along all right so therefore they must be quite good rules, \r\n\
quite effective. The lawyers said that wasn't a problem and we could \r\n\
have exactly the same rules that everyone else used but if we thought \r\n\
that would make their bill any smaller then we had another think \r\n\
coming. We said fair enough we'll have exactly the same rules as \r\n\
everybody else then and since we're paying through the nose for it \r\n\
we'll have one extra rule while we're at it. And they said all right, \r\n\
we suppose so, if you really must. So here they are:\r\n\
\r\n\
\r\n\
Minimum standards\r\n\
-----------------\r\n\
Use of the site constitutes acceptance of the following terms and \r\n\
conditions.\r\n\
\r\n\
1. You agree not to use the forum to transmit material that\r\n\
   - promotes bigotry, racism, hatred, or harm of any kind against any\r\n\
     group or individual;\r\n\
   - is harassing, defamatory, invasive of another's privacy, abusive,\r\n\
     threatening, obscene or otherwise objectionable;\r\n\
   - that infringes the intellectual property or other rights of \r\n\
     another;\r\n\
   - that contains advertising or other forms of commercial \r\n\
     solicitation.\r\n\
\r\n\
2. You recognise that h2g2 may use and reproduce your messages, in whole\r\n\
   or in part, in the Guide and other content areas of the site.  By \r\n\
   contributing to this forum you recognise and acknowledge that h2g2 \r\n\
   shall have non-exclusive copyright for any material you may provide.\r\n\
\r\n\
3. No spitting.\r\n\
\r\n\
\r\n\
";
	return SendMail(pEmail, pSubject, sBody);
*/
}
