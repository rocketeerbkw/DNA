// ShareAndEnjoyBuilder.cpp: implementation of the CShareAndEnjoyBuilder class.
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
#include "ShareAndEnjoyBuilder.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CShareAndEnjoyBuilder::CShareAndEnjoyBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CShareAndEnjoyBuilder::~CShareAndEnjoyBuilder()
{

}

bool CShareAndEnjoyBuilder::Build(CWholePage* pPage)
{
	bool bPageSuccess = false;
	bPageSuccess = InitPage(pPage, "SHAREANDENJOY",true);
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	
	bool bSuccess = bPageSuccess;

	// Get the ID of the viewing user
	int iViewingUserID = 0;
	if (pViewingUser != NULL)
	{
		iViewingUserID = pViewingUser->GetUserID();
	}
	
	// Now we've created the page, let's do the work
	if (bSuccess)
	{
		// Get any parameters we might be expecting
		CTDVString sXML;
		CTDVString sEmail;
		CTDVString sWelcome;
		bool bGotEmail = m_InputContext.GetParamString("email", sEmail);
		bool bGotWelcome = m_InputContext.GetParamString("welcome", sWelcome);
		
		if (iViewingUserID == 0)
		{
			// Don't let unregistered users use this feature.
			sXML << "<SHAREANDENJOY STATUS='UNREGISTERED'/>";
			pPage->AddInside("H2G2", sXML);
		}
		else if (!bGotEmail)
		{
			// Initial state of the page
			sXML << "<SHAREANDENJOY STATUS='INITIAL'/>";
			pPage->AddInside("H2G2", sXML);
		}
		else if (((sEmail.GetLength() < 5) || (sEmail.Find('@') < 1) || sEmail.Find('.') <1)) 
		{
			// Badly formed email address
			sXML << "<SHAREANDENJOY STATUS='BADEMAIL'>";
			sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
			CXMLObject::EscapeAllXML(&sWelcome);
			sXML << "<MESSAGE>" << sWelcome << "</MESSAGE>";
			sXML << "</SHAREANDENJOY>";
			pPage->AddInside("H2G2", sXML);
		}
		else if (sWelcome.GetLength() == 0)
		{
			sXML << "<SHAREANDENJOY STATUS='NOMESSAGE'>";
			sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
			CXMLObject::EscapeAllXML(&sWelcome);
			sXML << "<MESSAGE>" << sWelcome << "</MESSAGE>";
			sXML << "</SHAREANDENJOY>";
			pPage->AddInside("H2G2", sXML);
		}
		else
		{
			// The input checks out, now see what happens when we
			// invite this user
			CStoredProcedure SP;
			m_InputContext.InitialiseStoredProcedureObject(&SP);
			CTDVString sCookie;
			CTDVString sKey;
			CTDVString sPassword;
			int iUserID;
			bool bExists = false;
			bool bNew = false;
			SP.StoreEmailRegistration(sEmail, &sCookie, &sKey, &sPassword, &iUserID, &bExists, &bNew);
			if (!bNew && bExists)
			{
				// Already joined (I think)
				sXML << "<SHAREANDENJOY STATUS='ALREADYJOINED'>";
				sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
				CXMLObject::EscapeAllXML(&sWelcome);
				sXML << "<MESSAGE>" << sWelcome << "</MESSAGE>";
				sXML << "<USERID>" << iUserID << "</USERID>";
				sXML << "</SHAREANDENJOY>";
				pPage->AddInside("H2G2", sXML);
			}
			else if (!bNew && !bExists)
			{
				// Asked but not yet joined
				sXML << "<SHAREANDENJOY STATUS='ALREADYASKED'>";
				sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
				CXMLObject::EscapeAllXML(&sWelcome);
				sXML << "<MESSAGE>" << sWelcome << "</MESSAGE>";
				sXML << "</SHAREANDENJOY>";
				pPage->AddInside("H2G2", sXML);
			}
			else
			{
				// Definitely new, so do all the stuff with sending emails
				CTDVString sMailText;	// text of the mail we're sending
				CTDVString sSubject;
				SP.FetchEmailText(m_InputContext.GetSiteID(), "ShareAndEnjoy", 
					&sMailText, &sSubject);
				CTDVString sDomain;
				m_InputContext.GetDomainName(sDomain);
				CTDVString sJoinURL = "http://";
				sJoinURL << sDomain << "/ShowTerms" << iUserID << "?key=" << sKey;
				CTDVString sCancelURL;
				sCancelURL	<< "http://" 
							<< sDomain 
							<< "/CancelMe" 
							<< iUserID
							<< "&key="
							<< sKey;
				CTDVString sPersonalSpace = "http://";
				sPersonalSpace << sDomain << "/U" << iViewingUserID;
				sMailText.Replace("++**showterms**++",sJoinURL);
				sMailText.Replace("++**cancelreg**++",sCancelURL);

				sMailText.Replace("++**usermessage**++", sWelcome);
				sMailText.Replace("++**personalspace**++", sPersonalSpace);
				SendMail(sEmail, sSubject, sMailText);

				sXML << "<SHAREANDENJOY STATUS='SUCCESS'>";
				sXML << "<EMAILADDRESS>" << sEmail << "</EMAILADDRESS>";
				CXMLObject::EscapeAllXML(&sWelcome);
				sXML << "<MESSAGE>" << sWelcome << "</MESSAGE>";
				sXML << "<USERID>" << iUserID << "</USERID>";
				sXML << "</SHAREANDENJOY>";
				pPage->AddInside("H2G2", sXML);
				SP.AddRecommendedUser(iViewingUserID, iUserID);
			}
		}
	}

	return bPageSuccess;

}
