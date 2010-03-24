// NewEmailBuilder.cpp: implementation of the CNewEmailBuilder class.
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
#include "NewEmailBuilder.h"
#include "StoredProcedure.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CNewEmailBuilder::CNewEmailBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CNewEmailBuilder::~CNewEmailBuilder()
{

}

/*********************************************************************************

	CWholePage* CNewEmailBuilder::Build()

	Author:		Jim Lynn
	Created:	24/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	Page with new email details.
	Purpose:	Receives a change of email address notification with a key
				and performs the email change. This script is always called
				from a link in an email sent to the user.

*********************************************************************************/

bool CNewEmailBuilder::Build(CWholePage* pPageXML)
{
	int iKey = m_InputContext.GetParamInt("key");

	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	int iUserID = 0;
	
	if (pViewingUser != NULL)
	{
		iUserID = pViewingUser->GetUserID();
	}

	bool bPageSuccess = true;
	bPageSuccess = InitPage(pPageXML, "NEWEMAIL",true);
	
	if (!bPageSuccess)
	{
		pPageXML->SetError("We were unable to initialise the Page object");
	}

	bool bSuccess = bPageSuccess;

	// Now actually do the thing
	if (bSuccess)
	{
		CStoredProcedure SP;
		
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			bSuccess = false;
			pPageXML->SetError("Failed to connect to database");
		}
		else
		{
			CTDVString sReason;
			if (SP.ActivateNewEmail(iUserID, iKey, &sReason))
			{
				// Store the confirmation information
				CTDVString sXML = "<NEWEMAILSTORED>";
				sXML << sReason << "</NEWEMAILSTORED>";
				if (!pPageXML->AddInside("H2G2",sXML))
				{
					bSuccess = false;
					pPageXML->SetError("Failed to add the tag to the page");
				}
			}
			else
			{
				CTDVString sXML = "<NEWEMAILFAILED>";
				sXML << sReason << "</NEWEMAILFAILED>";
				if (!pPageXML->AddInside("H2G2",sXML))
				{
					bSuccess = false;
					pPageXML->SetError("Failed to add the tag to the page");
				}
			}
		}
	}

	return bPageSuccess;
}
