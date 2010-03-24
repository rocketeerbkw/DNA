// ModeratorListBuilder.cpp: implementation of the ModeratorListBuilder class.
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
#include "ModeratorListBuilder.h"
#include "InputContext.h"
#include "InputContext.h"
#include "WholePage.h"
#include "StoredProcedure.h"
#include "TDVString.h"
#include "TDVASSERT.h"
#include "User.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CModeratorListBuilder::CModeratorListBuilder(CInputContext& inputContext) 
: CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CModeratorListBuilder::~CModeratorListBuilder()
{
	
}

bool CModeratorListBuilder::Build(CWholePage* pPageXML)
{
	
	InitPage(pPageXML, "MODERATOR-LIST", true);
	
	bool bSuccess = true;
	// get the viewing user
	CUser* pViewer = m_InputContext.GetCurrentUser();
	
	// get any user ID parameter
	
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsModerator()))
	{
		bSuccess = bSuccess && pPageXML->SetPageType("ERROR");
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot perform moderation unless you are logged in as an Editor or a Moderator.</ERROR>");
	}
	else
	{
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		
		CTDVString sXML;
		
		CTDVString sSiteList;
		
		m_InputContext.GetSiteListAsXML(&sSiteList,2);
		
		sXML << "<MODERATORLIST>";
		sXML << "<CURRENTSITEID>" << m_InputContext.GetSiteID() << "</CURRENTSITEID>"; 
		
		sXML << sSiteList;
		
		if (SP.GetModeratorsForSite(m_InputContext.GetSiteID()))
		{
			int iActiveModID = 0;
			
			while (!SP.IsEOF())
			{
				int iNextModID = SP.GetIntField("userid");
				
				//if we have a new moderator the spit out the details
				if (iNextModID > 0 && iNextModID != iActiveModID)
				{
					//if we have an active moderator then close them off before
					//we start on a new one
					
					if (iActiveModID > 0)
					{
						sXML << "</MODERATOR>";
					}
					
					iActiveModID = iNextModID;
					
					CTDVString sUserName;
					SP.GetField("username",sUserName);
					
					sXML << "<MODERATOR>";
					sXML << "<USER>";
					sXML << "<USERID>" << iNextModID << "</USERID>";
					sXML << "<USERNAME>" << sUserName << "</USERNAME>";
					sXML << "</USER>";
				}
				
				//spit out the sites 
				
				int iSiteID = SP.GetIntField("SiteID");
				
				sXML << "<SITEID>" << iSiteID << "</SITEID>";
				
				SP.MoveNext();
			}
			
			//close the last moderator
			sXML << "</MODERATOR>";
			//close the moderator list
			
		}
		
		sXML << "</MODERATORLIST>";
		
		bSuccess = bSuccess && pPageXML->AddInside("H2G2",sXML);
	}
	

	return bSuccess;
}
