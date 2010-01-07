// UserDetailsPageBuilder.cpp: implementation of the CNewUserDetailsPageBuilder class.
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
#include "NewUserDetailsPageBuilder.h"
#include "WholePage.h"
#include "PageUI.h"
#include "TDVAssert.h"
#include "RegisterObject.h"
#include "profanityfilter.h"
#include "threadsearchphrase.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CNewUserDetailsPageBuilder::CNewUserDetailsPageBuilder(CInputContext& inputContext)

	Author:		Kim Harries
	Created:	13/03/2000
	Inputs:		inputContext - input context object.
	Outputs:	-
	Returns:	-
	Purpose:	Constructs the minimal requirements for a CNewUserDetailsPageBuilder object.

*********************************************************************************/

CNewUserDetailsPageBuilder::CNewUserDetailsPageBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
	// no further construction
}

/*********************************************************************************

	CNewUserDetailsPageBuilder::~CNewUserDetailsPageBuilder()
																			 ,
	Author:		Kim Harries
	Created:	13/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Release any resources this object is responsible for.

*********************************************************************************/

CNewUserDetailsPageBuilder::~CNewUserDetailsPageBuilder()
{
	// no further destruction
}

/*********************************************************************************

	bool CNewUserDetailsPageBuilder::Build(CWholePage* pWholePage)
																			 ,
	Author:		Kim Harries
	Created:	13/03/2000
	Modified:	14/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to a CWholePage containing the entire XML representation of
				the user details page.
	Purpose:	Construct a user page from its various constituent parts based
				on the request info available from the input context supplied during
				construction.

*********************************************************************************/

bool CNewUserDetailsPageBuilder::Build(CWholePage* pWholePage)
{
	// pointer to the xml objects we are going to need
	CUser*			pViewer = NULL;
	// get or create all the appropriate xml objects
	// first get the current user object and test that it isn't NULL
	pViewer = m_InputContext.GetCurrentUser();

	TDVASSERT(pViewer != NULL, "CNewUserDetailsPageBuilder::Build() called with NULL current user");

	CTDVString sPageError;
	bool bSuccess = true;
	bool bUpdateWasValid = true; // make a boolean variable to assess the validity of the submission

	// If the person is unregistered, show/deal with new password request
	// Also do this if 'unregcmd' exists as a parameter, so a
	// registered person can still request a new password.
	bool bRequest = false;
	CTDVString sRequestFormCommand = NULL;
	if (m_InputContext.GetParamString("unregcmd", sRequestFormCommand))
	{
		bRequest = true;
	}
	if (bRequest || pViewer == NULL)
	{
		CTDVString sMessage;
		CTDVString sMessageType = "";
		bool bSubmission = false;
		CTDVString sUpdateError = NULL;
		if (bSuccess && bRequest)
		{
			if (sRequestFormCommand.CompareText("Submit"))
			{
				bSubmission = true;
			} 
		} 
		if (bSuccess && bSubmission)
		{
			CTDVString sEmail;
			CTDVString sLoginname;
			CTDVString sUserid;
			bUpdateWasValid = bUpdateWasValid && m_InputContext.GetParamString("email", sEmail);
			bUpdateWasValid = bUpdateWasValid && m_InputContext.GetParamString("loginname", sLoginname);
			bUpdateWasValid = bUpdateWasValid && m_InputContext.GetParamString("userid", sUserid);

			while (sUserid.GetLength() > 0 && (sUserid[0] == 'u' || sUserid[0] == 'U' || sUserid[0] == ' '))
			{
				sUserid.RemoveLeftChars(1);
			}
			/* 
			   if loginname is empty, fall back on userid
			*/
			if (bUpdateWasValid && sLoginname.IsEmpty()) 
			{
				CUser TempUser(m_InputContext);
				if (TempUser.CreateFromID(atoi(sUserid))) 
				{
					bUpdateWasValid = TempUser.GetLoginName(sLoginname);
				}
				else
				{
					bUpdateWasValid = false;
				}
			}
			if (bUpdateWasValid) 
			{
				CRegisterObject RegObj(m_InputContext);
				bUpdateWasValid = RegObj.RequestPassword(sLoginname, sEmail);
				if (bUpdateWasValid)
				{
					sMessage = "A new password has been set and is being sent to you via email.";
					sMessageType = "newpasswordsent";
				}
				else 
				{
					sMessage = "The username or nickname you entered was not valid, or did not match the email address you provided.";
					sMessageType = "newpasswordfailed";
				}
			}
		}

		bSuccess = InitPage(pWholePage, "USERDETAILS",true,false);

		if (pViewer != NULL)
		{
			pViewer->SetIDNameVisible();
			pViewer->SetIDNameEmailVisible();
			pWholePage->AddInside("VIEWING-USER", pViewer);
		}

		CTDVString formXML;
		formXML << "<USER-DETAILS-UNREG>";
		formXML << "<MESSAGE TYPE='" << sMessageType << "'>" << sMessage << "</MESSAGE>";
		formXML << "</USER-DETAILS-UNREG>";

		bSuccess = pWholePage->AddInside("H2G2", formXML);
	}
	else    
	// We are registered, handle userdetails form 
	{
		// before anything else find out whether we are dealing with a request to view
		// the page or a submit request to update the details
		bool bSubmission = false;
		CTDVString sFormCommand = NULL;
		CTDVString sUpdateError;
		CTDVString sUpdateType;
		if (m_InputContext.ParamExists("setskin"))
		{
			CTDVString sNewSkin;
			if(m_InputContext.GetParamString("NewSkin", sNewSkin))
			{
				pViewer->SetPrefSkin(sNewSkin);
				bSuccess = pViewer->UpdateDetails();
				bSuccess = bSuccess && m_InputContext.SetSkin(sNewSkin);
				if (bSuccess)
				{
					sUpdateError = "Your new skin has been set";
					sUpdateType = "skinset";
				}
			}
		}

		// if a submit request then it will have a CGI parameter called 'cmd'
		// with the value 'submit'
		if (bSuccess)
		{
			if (m_InputContext.GetParamString("cmd", sFormCommand))
			{
				if (sFormCommand.CompareText("Submit"))
				{
					bSubmission = true;
				} 
			}
		} 

		if ((pViewer != NULL) && pViewer->GetIsBannedFromPosting())
		{
			bUpdateWasValid = false;
			sUpdateError = "Not allowed";
			sUpdateType = "restricteduser";
		}

		if ( bUpdateWasValid && bSubmission && bUpdateWasValid )
		{
			bUpdateWasValid  = UpdateUserDetails(pViewer, sUpdateError, sUpdateType);
		}
		
		bSuccess = bSuccess && InitPage(pWholePage, "USERDETAILS",true);

		// now add the XML for the FORM and its contents
		int iUserID = pViewer->GetUserID();

		CTDVString sUsername;
		//	CTDVString sFirstNames;
		//	CTDVString sLastName;
		CTDVString sEmail;
		CTDVString sPrefSkin;
		int iPrefUserMode;
		int iPrefForumStyle;
		CTDVString sPrefXML;
		CTDVString sSiteSuffix;
		CTDVString sRegion;
		// get the users settings, which may have just been updated...
		bSuccess = bSuccess && pViewer->GetUsername(sUsername);
		//		bSuccess = bSuccess && pViewer->GetFirstNames(sFirstNames);
		//		bSuccess = bSuccess && pViewer->GetLastName(sLastName);
		bSuccess = bSuccess && pViewer->GetEmail(sEmail);
		bSuccess = bSuccess && pViewer->GetPrefSkin(&sPrefSkin);
		bSuccess = bSuccess && pViewer->GetPrefUserMode(&iPrefUserMode);
		bSuccess = bSuccess && pViewer->GetPrefForumStyle(&iPrefForumStyle);
		bSuccess = bSuccess && pViewer->GetPrefXML(&sPrefXML);
		bSuccess = bSuccess && pViewer->GetSiteSuffix(sSiteSuffix);
		bSuccess = bSuccess && pViewer->GetRegion(sRegion);
		
		// construct the XML for the FORM and then insert it inside the body of the page
		if (bSuccess)
		{
			// TODO: is this the only XML we need to output?
			CTDVString sMessage;
			CTDVString sMessageType = "";

			if (sUpdateError.IsEmpty() && bSubmission)
			{
				sMessage = "Your details have been updated";
				sMessageType="detailsupdated";

			}
			else
			{
				sMessage = sUpdateError;
				sMessageType = sUpdateType;
			}

			// escape all XML sequences in the name fields before showing them in the form
			CXMLObject::EscapeAllXML(&sUsername);
			//		CXMLObject::EscapeAllXML(&sFirstNames);
			//		CXMLObject::EscapeAllXML(&sLastName);

			// now build the XML representation of the form for editing user details
			CTDVString formXML;
			formXML << "<USER-DETAILS-FORM>";
			formXML << "<MESSAGE TYPE='" << sMessageType << "'>" << sMessage << "</MESSAGE>";
			formXML << "<USERID>" << iUserID << "</USERID>";
			formXML << "<USERNAME>" << sUsername << "</USERNAME>";
			//		formXML << "<FIRST-NAMES>" << sFirstNames << "</FIRST-NAMES>";
			//		formXML << "<LAST-NAME>" << sLastName << "</LAST-NAME>";
			formXML << "<EMAIL-ADDRESS>" << sEmail << "</EMAIL-ADDRESS>";
			formXML << "<REGION>" << sRegion << "</REGION>"; 
			formXML << "<PREFERENCES>"
			  << "<SKIN>" << sPrefSkin << "</SKIN>"
			  << "<USER-MODE>" << iPrefUserMode << "</USER-MODE>"
			  << "<FORUM-STYLE>" << iPrefForumStyle << "</FORUM-STYLE>"
			  << "<SITESUFFIX>" << sSiteSuffix << "</SITESUFFIX>"
			  << "</PREFERENCES>";
			formXML << "<SITEPREFERENCES>" << sPrefXML << "</SITEPREFERENCES>";
			formXML << "</USER-DETAILS-FORM>";

			bSuccess = pWholePage->AddInside("H2G2", formXML);

			//Insert Regions XML into page if they exist.
			CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
			CThreadSearchPhrase tsp(m_InputContext,delimit);
			if ( bSuccess && tsp.GetSiteKeyPhrasesXML() )
			{
				pWholePage->AddInside("H2G2","<THREADSEARCHPHRASE/>");
				pWholePage->AddInside("H2G2/THREADSEARCHPHRASE",&tsp);
			}
		}
	}  /* end of 'we are registered user' if */

	if (!bSuccess && pWholePage != NULL)
    {
		// if haven't been able to produce a page then create a simple error page
		CTDVString sPageXML = "<ARTICLE>";
		sPageXML << "<SUBJECT>Error Page</SUBJECT>";
		sPageXML << "<GUIDE><BODY>";
		if (sPageError.IsEmpty())
		{
			sPageXML << "User Details Page could not be displayed due to unspecified strangeness";
		}
		else
		{
			sPageXML << "User Details Page could not be displayed: " << sPageError;
		}
		sPageXML << "</BODY></GUIDE></ARTICLE>";
		bSuccess = InitPage(pWholePage, "ERRORPAGE",true,false);
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", sPageXML);
	}
	return bSuccess;
}

/*********************************************************************************

	bool CNewUserDetailsPageBuilder::UpdateUserDetails(CUser* pViewer, CTDVString& sStatusMessage)
																			 ,
	Author:		Kim Harries
	Created:	13/03/2000
	Modified:	26/03/2000
	Inputs:		pViewer - pointer to the user object representing the current user
	Outputs:	pViewer - ditto.
				sStatusMessage - string describing the status of things after this
					call, in particular any error messages.
	Returns:	true for success, false for failure. A mistake in the users input
				will still return true but will set the sStatusMessage string to
				indicate what was wrong.
	Purpose:	Updates the users details based on the current form submission. If
				there is a problem such as the new password not being confirmed
				correctly then will return true since the system itself has not
				failed, but will set the sStatusMessage string to say what the
				problem was so this can be relayed to the user.

*********************************************************************************/

bool CNewUserDetailsPageBuilder::UpdateUserDetails(CUser* pViewer, CTDVString& sStatusMessage, CTDVString& sStatusType)
{
	TDVASSERT(pViewer != NULL, "NULL pViewer in CNewUserDetailsPageBuilder::UpdateUserDetails(...)");
	// something badly wrong if this method is called with a NULL pViewer
	if (pViewer == NULL)
	{
		return false;
	}
	// initialise the error message string to an empty string
	sStatusMessage.Empty();
	sStatusType.Empty();
	// these are strings for each of the fields in the form
//	CTDVString sFirstNames;
//	CTDVString sLastName;
	CTDVString sUserName;
	CTDVString sOldUserName;
	CTDVString sPrefSkin;
	int	iPrefUserMode;
	int	iPrefForumStyle;
	CTDVString sOldEmail;
	CTDVString sNewEmail;
	CTDVString sPassword;
	CTDVString sNewPassword;
	CTDVString sPasswordConfirm;
	CTDVString sError;
	CTDVString sSiteSuffix;
	
	bool bSuccess = true;
	bool bSiteSuffixExists = false;
	// get all the data entered into the form => they are passed as standard
	// parameters in the CGI request
	// all parameters should be sent with every request, even if they are unchanged
//	bSuccess = bSuccess && m_InputContext.GetParamString("FirstNames", sFirstNames);
//	bSuccess = bSuccess && m_InputContext.GetParamString("LastName", sLastName);
	bSuccess = bSuccess && m_InputContext.GetParamString("UserName", sUserName);
	bSiteSuffixExists = m_InputContext.GetParamString("SiteSuffix", sSiteSuffix);
	bSuccess = bSuccess && m_InputContext.GetParamString("PrefSkin", sPrefSkin);
	iPrefUserMode = m_InputContext.GetParamInt("PrefUserMode");
	iPrefForumStyle = m_InputContext.GetParamInt("PrefForumStyle");
	bSuccess = bSuccess && m_InputContext.GetParamString("OldEmail", sOldEmail);
	bSuccess = bSuccess && m_InputContext.GetParamString("NewEmail", sNewEmail);
	bSuccess = bSuccess && m_InputContext.GetParamString("Password", sPassword);
	bSuccess = bSuccess && m_InputContext.GetParamString("NewPassword", sNewPassword);
	bSuccess = bSuccess && m_InputContext.GetParamString("PasswordConfirm", sPasswordConfirm);

	// Coalesce the site-specific preferences:
	// For each parameter, we have a p_name parameter

	CTDVString sPrefXML;
	int iNumPrefs = m_InputContext.GetParamCount("p_name");
	for (int i=0; i < iNumPrefs; i++)
	{
		CTDVString sName;
		CTDVString sValue;
		m_InputContext.GetParamString("p_name", sName, i);
		m_InputContext.GetParamString(sName, sValue);
		sName.MakeUpper();
		CXMLObject::EscapeAllXML(&sValue);
		sValue.Replace("'","&apos;");
		sPrefXML << "<" << sName << " VALUE='" << sValue << "'/>";
	}


	// if at least one parameter exists then set the appropriate member variables in the current user
	// check if a new password has been specified.
	if (bSuccess && sNewPassword != "")
	{
		if (sNewPassword == sPasswordConfirm)
		{
			CRegisterObject RegObj(m_InputContext);
			CTDVString sUserLogin;
			pViewer->GetLoginName(sUserLogin);
			bSuccess = RegObj.UpdatePassword(sUserLogin, sPassword, sNewPassword);
			// make sure we use the new password for subsequent possible stuff, such as
			// updating email in the cud!
			sPassword = sNewPassword;
			if (!bSuccess) 
			  {
			    RegObj.GetError(&sError);
			   
			    // shouldn't really have actual error text here!
			    // assume only two possible failures.
			    if (sError.CompareText("invalidpassupdate"))
			    {
			      sStatusMessage = "You entered an invalid password. Passwords must be at least 6 characters long.";
				  sStatusType = "invalidpassword";
			    } 
			    else 
				{
					sStatusMessage = "You entered an incorrect password, password not changed.";
					sStatusType = "badpassword";
			    }
			  }
			
		}
		else
		{
			// Signal that password was not confirmed correctly
			// method has not failed, but the update could not occur due to user error
			sStatusMessage = "The passwords didn't match - your details have NOT been changed.";
			sStatusType = "unmatchedpasswords";
		}
	}

	bool bPremodNicknameChangesOption = m_InputContext.DoesCurrentSiteHaveSiteOptionSet("Moderation", "PremoderateNicknameChanges");
	bool bChildSite = (m_InputContext.GetSiteMaxAge(m_InputContext.GetSiteID()) < 16);
	bool bSiteInPreMod = m_InputContext.GetPreModerationState();
	
	// The username change is premoderated if the user is in premod, or if the site is a children's site (i.e. MaxAge < 16),
	// or if the site is a premod site AND the PremoderatedNicknameChanges site option is on.
	bool bUserNamePreModerated = pViewer->GetIsPreModerated() || bChildSite || (bSiteInPreMod && bPremodNicknameChangesOption);

	if ( bSuccess )
	{
		// get the old username so we cna check if they have changed it
		bSuccess = bSuccess && pViewer->GetUsername(sOldUserName);
		
		//Can only set username if user / site not premoderated.
		if (sOldUserName != sUserName && !bUserNamePreModerated )
		{
			bSuccess = bSuccess && pViewer->SetUsername(sUserName);
			bSuccess = bSuccess && pViewer->SetSiteSuffix(sSiteSuffix);
		}

		bSuccess = bSuccess && pViewer->SetPrefSkin(sPrefSkin);
		bSuccess = bSuccess && pViewer->SetPrefUserMode(iPrefUserMode);
		bSuccess = bSuccess && pViewer->SetPrefForumStyle(iPrefForumStyle);
		bSuccess = bSuccess && pViewer->SetPrefXML(sPrefXML);

		//Optional parameter.
		if ( m_InputContext.ParamExists("Region") )
		{
			CTDVString sRegion;
			m_InputContext.GetParamString("Region", sRegion);
			bSuccess = bSuccess && pViewer->SetRegion(sRegion);
		}
	}
	
	if (bSuccess && sNewEmail != sOldEmail)
	{
		// if we can't find out the email they want then we can't possibly win
		// OR if they want an email less than 5 characters long... it can't be done
		// (not a properly formed one with a tld and everything.. it'd still be pretty
		// difficult with 7 characters but let's assume that you could get z@b.e or similar
		// OR if there isn't an ampersat character (@) in their nominated email address
		// at _least_ 1 char into the string then that's a problem too. (eg "@foo.com")
		// OR if there is no '.' character there (needed to mark tld from domain or maybe
		// to seperate numeric ip?
		if ((!m_InputContext.GetParamString("NewEmail", sNewEmail)) ||
			((sNewEmail.GetLength() < 5) || (sNewEmail.Find('@') < 1) || sNewEmail.Find('.') == -1)) 
		{
			bSuccess = false;
			sStatusMessage = "Hey! Are you really sure about that email address? \"" + sNewEmail + "\" doesn't sound quite right.";
			sStatusType = "invalidemail";
		}
		else 
		{
			// set it in the CUD first, so if the password fails, it doesn't get changed
			CRegisterObject RegObj(m_InputContext);
			CTDVString sUserLogin;
			pViewer->GetLoginName(sUserLogin);
			bSuccess = RegObj.UpdateEmail(sUserLogin, sPassword, sNewEmail);
			bSuccess = bSuccess && pViewer->SetEmail(sNewEmail);
			
			// TODO: Can it fail other than for a bad password?
			if (!bSuccess) 
			{
			  sStatusMessage = "You entered an incorrect password, email not changed.";
			  sStatusType = "badpasswordforemail";
			}
		}
	}
	
	// only do the update if none of the methods failed and if there is no error
	// message indicating problems with the users input
	if ( bSuccess )
	{
		// finally make sure that the users details are updated in the database
		// TODO: if this can fail then we need to decide what to do if it does
		bSuccess = pViewer->UpdateDetails();

		// Set the skin to the users prefered skin. DO NOT DO THIS if we've specified we want purexml!
		CTDVString sSiteName;
		bool bPureXML = m_InputContext.ParamExists("skin") && m_InputContext.GetParamString("skin",sSiteName) && sSiteName.CompareText("purexml");
		if (!bPureXML)
		{
			bSuccess = bSuccess && m_InputContext.SetSkin(sPrefSkin);
		}

		// if username change is requested -  queue it for moderation
		if (!sOldUserName.CompareText(sUserName))
		{
			CProfanityFilter profanityFilter(m_InputContext);
			CProfanityFilter::FilterState filterState = profanityFilter.CheckForProfanities(sUserName);
			if (filterState == CProfanityFilter::FailBlock || filterState == CProfanityFilter::FailRefer)
			{
				//TODO: Indicate in the update moderation system that the profanity filter has been triggered
			}

			bSuccess = bSuccess && pViewer->QueueForModeration(m_InputContext.GetSiteID() ,sUserName );
			if ( bUserNamePreModerated )
			{
				sStatusMessage = "Username is in pre-moderation.";
				sStatusType = "usernamepremoderated"; 
			}
		}
	}
	// now do new email change if necessary

	/*
	if (bSuccess && sStatusMessage.IsEmpty() && sNewEmail != sOldEmail)
	{
		// TODO: do something with new and old emails ???
//		bSuccess = pViewer->SetEmail(sNewEmail);
		CStoredProcedure* pSP = m_InputContext.CreateStoredProcedureObject();

		if (pSP == NULL)
		{
			sStatusMessage = "Could not update email address in database";
		}
		else
		{
			CTDVString sReport;
			int iUserID = pViewer->GetUserID();
			int iSecretKey = 0;
			bool bOkay = true;
			// should always have a valid user ID by this point
			TDVASSERT(iUserID != 0, "User ID of zero in CNewUserDetailsPageBuilder::UpdateUserDetails(...)");

			// this stored procedure will return a secret key for the user if all is
			// successful, or an error message if something is wrong
			bOkay = pSP->ChangeUserEmailAddress(iUserID, sOldEmail, sNewEmail, &iSecretKey, &sReport);
			// if changed okay then send emails to both new and old addresses
			CTDVString sMessageToOldAddress = "";
			CTDVString sSubjectToOldAddress = "";
			CTDVString sMessageToNewAddress = "";
			CTDVString sSubjectToNewAddress = "";
			bOkay = bOkay && pSP->FetchEmailText("EmailChangeOld", &sMessageToOldAddress, &sSubjectToOldAddress);
			bOkay = bOkay && pSP->FetchEmailText("EmailChangeNew", &sMessageToNewAddress, &sSubjectToNewAddress);

			if (bOkay)
			{
				CTDVString sDomain;

				// get the domain name
				if (!m_InputContext.GetDomainName(sDomain))
				{
					// if this fails for some reason then assume the most likely name
					// rather than failing outright
					TDVASSERT(false, "GetDomainName() failed in CNewUserDetailsPageBuilder::UpdateUserDetails(...)");
					sDomain = "www.h2g2.com";
				}
				CTDVString sURL;
				sURL << "http://" << sDomain << "/NewEmail" << iSecretKey;
				
				// Now search and replace where necessary
				
				sMessageToOldAddress.Replace("++**email**++",sOldEmail);
				sMessageToOldAddress.Replace("++**newemail**++",sNewEmail);
				sMessageToOldAddress.Replace("++**changeemail**++",sURL);

				sMessageToNewAddress.Replace("++**email**++",sOldEmail);
				sMessageToNewAddress.Replace("++**newemail**++",sNewEmail);
				sMessageToNewAddress.Replace("++**changeemail**++",sURL);

/*				sMessageToOldAddress
					<< "Dear h2g2 researcher,\r\n\r\n"
					<< "This is just a safety message. You've requested to change\r\n"
					<< "your email address, so this message is being sent to your\r\n"
					<< "old email address as a double check.\r\n\r\n"
					<< "The new email address you've chosen is \r\n\r\n"
					<< sNewEmail << "\r\n\r\n"
					<< "If this is correct, you will also be receiving a message sent\r\n"
					<< "to your new email address which contains a link which will\r\n"
					<< "complete the change.\r\n\r\n"
					<< "If the address above is wrong, or you didn't ask to change\r\n"
					<< "your email address, reply to this email telling us, and we will \r\n"
					<< "correct the problem.\r\n\r\n"
					<< "Don't forget to check your new email account.\r\n\r\n"
					<< "Yours,\r\n\r\n"
					<< "The h2g2 Editors";

				sMessageToNewAddress
					<< "Dear h2g2 researcher,\r\n\r\n"
					<< "You've asked to change your email address. Your old\r\n"
					<< "address was:\r\n\r\n" << sOldEmail << "\r\n\r\n"
					<< "The new address is:\r\n\r\n" << sNewEmail << "\r\n\r\n"
					<< "To complete the address change, simply click on the link\r\n"
					<< "below or copy it into the Address field of your web browser.\r\n\r\n"
					<< "http://" << sDomain << "/NewEmail" << iSecretKey << "\r\n\r\n"
					<< "This is all you need to do to complete the change of address.\r\n"
					<< "If you have any problems, just reply to this email, explaining\r\n"
					<< "what the problems are.\r\n\r\n"
					<< "Yours,\r\n\r\n"
					<< "The h2g2 Editors\r\n";
*//*
				// try to send both mails but flag an error if either fails
				bOkay = SendMail(sOldEmail, sSubjectToOldAddress, sMessageToOldAddress);
				bOkay = SendMail(sNewEmail, sSubjectToNewAddress, sMessageToNewAddress) && bOkay;
				TDVASSERT(bOkay, "SendMail failed in CNewUserDetailsPageBuilder::UpdateUserDetails(...)");
				if (!bOkay)
				{
					// in the unlikely event that mail could not be sent
					sStatusMessage = "Warning: An error occurred whilst sending confirmation email. Please email us at ??? and we will ensure that your email address has been updated correctly.";
				}
				else
				{
					// message if all went okay
					sStatusMessage = "";
					sStatusMessage 
						<< "Note: Your email address change has been stored. However, \n"
						<< "in order to check that you've typed in your email address correctly,\n"
						<< "we have sent an email to your new address, which you will need to read\n"
						<< "before the email address change becomes permanent. For security, we've\n"
						<< "also sent a message to your old email address, but you don't need to \n"
						<< "respond to that one.\n\n"
						<< "Read the email, and go to the address provided, which will finally\n"
						<< "change your email address (in just the same way as your original registration\n"
						<< "email worked).\n";
				}
			}
			else
			{
				// if the stored procedure failed for some reason then report it
				sStatusMessage = "Warning: Your new email address has not been stored because " + sReport;
			}
		}
		delete pSP;
		pSP = NULL;
	}
*/
	return bSuccess;
}
