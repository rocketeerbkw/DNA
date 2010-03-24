//ContentSignifAdminBuilder.cpp: implementation of the ContentSignifAdminBuilder class.
//

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
#include "ContentSignifAdminBuilder.h"
#include "Link.h"
#include "TDVASSERT.h"



//#ifdef _DEBUG
//#undef THIS_FILE
//static char THIS_FILE[]=__FILE__;
//#define new DEBUG_NEW
//#endif


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CContentSignifAdminBuilder::CContentSignifAdminBuilder(CInputContext& inputContext)
:m_pViewingUser(NULL), m_pPage(NULL), CXMLBuilder(inputContext)
{
}

CContentSignifAdminBuilder::~CContentSignifAdminBuilder()
{

}
/*********************************************************************************

	CWholePage* CContentSignifAdminBuilder::Build()

		Author:		James Conway
        Created:	18/04/2005
        Inputs:		WholePage object (pointer)
        Outputs:	-
        Returns:	boolean
        Purpose:	Initialises page object if the viewing-user is an editor/superuser. 

*********************************************************************************/

bool CContentSignifAdminBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	bool bSuccess = true;
	CTDVString sSiteXML;
	CContentSignifSettings ContentSignifSettings(m_InputContext);
	
	if (!InitPage(m_pPage, "CONTENTSIGNIFADMIN", true))
	{
		// assert the problem for debugging
		TDVASSERT(false,"CContentSignifAdminBuilder - Failed to create Whole Page object!");
		// now handle the error
		SetDNALastError("CContentSignifAdminBuilder", "Build()", "Failed to initialise the page object");
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return bSuccess;
	}

	// Handle the user, checking if they have editor priviledges.
	m_pViewingUser = m_InputContext.GetCurrentUser();
	if (m_pViewingUser == NULL || !m_pViewingUser->GetIsEditor())
	{
		//handle the error (we don't want to assert here as this is not a functional error).
		SetDNALastError("CContentSignifAdminBuilder", "Build()", "User not logged in or not authorised");
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return bSuccess;
	}

	//bSuccess = bSuccess && m_pPage->AddInside("H2G2", "<CONTENTSIGNIFSETTINGS/>");
	bSuccess = bSuccess && ProcessParams(ContentSignifSettings);

	if (m_InputContext.GetSiteListAsXML(&sSiteXML))
	{
		m_pPage->AddInside("H2G2", sSiteXML);
	}

	// insert CContentSignifSettings object into the page
	// IF MAP insert XML bSuccess = bSuccess && m_pPage->AddInside("CONTENTSIGNIFSETTINGS", &ContentSignifSettings);
	TDVASSERT(bSuccess, "CContentSignifAdminBuilder::Build failed");

	return bSuccess;
}

/*********************************************************************************

	bool CContentSignifAdminBuilder::ProcessParams(CCContentSignifSettings& ContentSignifSettings)

		Author:		James Conway
        Created:	18/04/2005
        Inputs:		ContentSignifSettings Object by reference
        Outputs:	-
        Returns:	boolean (success/fail)
        Purpose:	Checks action type and sets or gets site specific ContentSignif settings as appropriate.
		
*********************************************************************************/

bool CContentSignifAdminBuilder::ProcessParams(CContentSignifSettings& ContentSignifSettings)
{
	const int iSiteID	= m_InputContext.GetSiteID(); 
	CTDVString m_param1, m_param2, m_param3, m_param4, m_param5, m_param6, m_param7, m_param8, m_param9, m_param10, m_param11, m_param12, m_param13, m_param14, m_param15, m_param16, m_param17, m_param18, m_param19, m_param20, m_param21, m_param22, m_param23, m_param24, m_param25, m_param26, m_param27, m_param28, m_param29, m_param30, m_param31, m_param32, m_param33, m_param34, m_param35;
	CTDVString sXML;
	CTDVString sDecrementParams;
	CTDVString sParams;
	CTDVString sSettingParam;
	bool bSuccess = true;
	bool bProcessedLast = false; 

	if (m_InputContext.ParamExists("updatesitesettings"))
	{
		// Get all decrement (d_) and increment (i_) params from URL.
		m_InputContext.GetParamsAsString(sDecrementParams,"d_");
		m_InputContext.GetParamsAsString(sParams,"i_");

		sParams += "&"; 
		sParams += sDecrementParams;

		int miStartPos = 0;
		int miCount = 0;
		int miAmpPos;

		if (!sParams.IsEmpty())
		{
			miAmpPos = sParams.FindText("&", miStartPos);

			// loop through increment and decrement settings, binding them to m_params until the last one is processed.
			while (!(bProcessedLast)) 
			{	
				if (miAmpPos < 0) {
					// get the last parameter 
					sSettingParam = sParams.Mid(miStartPos, (sParams.GetLength()-miStartPos));
					bProcessedLast = true; 
				} else {
					sSettingParam = sParams.Mid(miStartPos, (miAmpPos-miStartPos));
					miStartPos = miAmpPos + 1;
					miAmpPos = sParams.FindText("&", miStartPos);
				}
				miCount++;
				switch (miCount)
				{
					case 1: m_param1  = sSettingParam; break; 
					case 2: m_param2  = sSettingParam; break; 
					case 3: m_param3  = sSettingParam; break; 
					case 4: m_param4  = sSettingParam; break; 
					case 5: m_param5  = sSettingParam; break; 
					case 6: m_param6  = sSettingParam; break; 
					case 7: m_param7  = sSettingParam; break; 
					case 8: m_param8  = sSettingParam; break; 
					case 9: m_param9  = sSettingParam; break; 
					case 10: m_param10  = sSettingParam; break; 
					case 11: m_param11  = sSettingParam; break; 
					case 12: m_param12  = sSettingParam; break; 
					case 13: m_param13  = sSettingParam; break; 
					case 14: m_param14  = sSettingParam; break; 
					case 15: m_param15  = sSettingParam; break; 
					case 16: m_param16  = sSettingParam; break; 
					case 17: m_param17  = sSettingParam; break; 
					case 18: m_param18  = sSettingParam; break; 
					case 19: m_param19  = sSettingParam; break; 
					case 20: m_param20  = sSettingParam; break; 
					case 21: m_param21  = sSettingParam; break; 
					case 22: m_param22  = sSettingParam; break; 
					case 23: m_param23  = sSettingParam; break; 
					case 24: m_param24  = sSettingParam; break; 
					case 25: m_param25  = sSettingParam; break; 
					case 26: m_param26  = sSettingParam; break; 
					case 27: m_param27  = sSettingParam; break; 
					case 28: m_param28  = sSettingParam; break; 
					case 29: m_param29  = sSettingParam; break; 
					case 30: m_param30  = sSettingParam; break; 
					case 31: m_param31  = sSettingParam; break; 
					case 32: m_param32  = sSettingParam; break; 
					case 33: m_param33  = sSettingParam; break; 
					case 34: m_param34  = sSettingParam; break; 
					case 35: m_param35  = sSettingParam; break; 
				}
			}
		} 

		ContentSignifSettings.SetSiteSpecificContentSignifSettings(iSiteID, m_param1, m_param2, m_param3, m_param4, m_param5, m_param6, m_param7, m_param8, m_param9, m_param10, m_param11, m_param12, m_param13, m_param14, m_param15, m_param16, m_param17, m_param18, m_param19, m_param20, m_param21, m_param22, m_param23, m_param24, m_param25, m_param26, m_param27, m_param28, m_param29, m_param30, m_param31, m_param32, m_param33, m_param34, m_param35); 
	} else if (m_InputContext.ParamExists("decrementcontentsignif"))
	{
		ContentSignifSettings.DecrementContentSignif(iSiteID); 
	}

	bSuccess = ContentSignifSettings.GetSiteSpecificContentSignifSettings(iSiteID, sXML); 

	bSuccess = bSuccess && m_pPage->AddInside("H2G2", sXML);

	return bSuccess; 
}