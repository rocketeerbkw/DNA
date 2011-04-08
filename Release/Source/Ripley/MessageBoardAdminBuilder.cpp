// MessageBoardAdminBuilder.cpp: implementation of the CMessageBoardAdminBuilder class.
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
#include "MessageBoardAdminBuilder.h"
#include "MessageBoardAdmin.h"
#include "WholePage.h"
#include "tdvassert.h"


#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


CMessageBoardAdminBuilder::CMessageBoardAdminBuilder(CInputContext& inputContext)
: m_pViewingUser(NULL), m_pPage(NULL), CXMLBuilder(inputContext)
{
	//m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}


CMessageBoardAdminBuilder::~CMessageBoardAdminBuilder()
{
}

/*********************************************************************************

	bool CMessageBoardAdminBuilder::Build(CWholePage* pPage)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdminBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	int iSiteID = m_InputContext.GetSiteID();
	
	bool bSuccess = true;
	if (!InitPage(m_pPage, "MESSAGEBOARDADMIN", true))
	{
		// assert the problem for debugging
		TDVASSERT(false,"CMessageBoardAdminBuilder - Failed to create Whole Page object!");
		// now handle the error
		SetDNALastError("CMessageBoardAdminBuilder", "Build()", "Failed to initialise the frontpage preview");
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return bSuccess;
	}

	m_pViewingUser = m_InputContext.GetCurrentUser();
	if (m_pViewingUser == NULL || !m_pViewingUser->GetIsEditor())
	{
		SetDNALastError("CMessageBoardAdminBuilder", "Build()", "User does not have access to this functionality");
		m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return false;
	}

	CMessageBoardAdmin MBAdmin(m_InputContext);
	if(!ProcessParams(MBAdmin))
	{
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
	}
	else
	{
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", &MBAdmin);
	}

	return bSuccess;
}


/*********************************************************************************

	bool CMessageBoardAdminBuilder::ProcessParams(CMessageBoardAdmin& MBAdmin)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdminBuilder::ProcessParams(CMessageBoardAdmin& MBAdmin)
{
	bool bSuccess = true;

	CTDVString sCmd;
	if (m_InputContext.ParamExists("cmd"))
	{
		m_InputContext.GetParamString("cmd", sCmd);
	}

	CTDVString sRedirect;
	if(sCmd.IsEmpty() || sCmd.CompareText("display"))
	{
		// url: /MessageBoardAdmin?cmd=display or /MessageBoardAdmin?cmd=display&updatetype=10&updatetype=11
		// NB: the 'cmd' param isn't required to render the display page
		
		//in some instances and update type is passed in and some processing is required
		// in addition to simply displaying the data. Deal with it here
		if(m_InputContext.ParamExists("updatetype"))
		{
			CDNAIntArray UpdateTypes;
			GetUpdateTypeParams(UpdateTypes);
			for(int i = 0; i < UpdateTypes.GetSize(); i++)
			{
				if(!IsValidUpdateParamValue(UpdateTypes[i]))
				{
					bSuccess = bSuccess && m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
					return bSuccess;
				}
				bSuccess = bSuccess && MBAdmin.HandleUpdateType(UpdateTypes[i]);
			}
		}
		// now get the display data
		bSuccess = bSuccess && MBAdmin.GetAdminState();
	}
	/* This is no longer required, its functionality being dealt with by "ViewChooseFrontPageTemplate"
	else if(sCmd.CompareText("ViewChooseFrontPageLayout"))
	{
		// url: /MessageBoardAdmin?cmd=ViewChooseFrontPageLayout
		bSuccess = bSuccess && MBAdmin.ViewChooseFrontPageLayout(sRedirect);
	}*/
	else if(sCmd.CompareText("ViewChooseFrontPageTemplate"))
	{
		// url: /MessageBoardAdmin?cmd=ViewChooseFrontpageTemplate
		bSuccess = bSuccess && MBAdmin.ViewChooseFrontPageTemplate(sRedirect);
	}
	else if(sCmd.CompareText("ViewChooseTopicFrontPageElement"))
	{	
		// url: /MessageBoardAdmin?cmd=ViewChooseTopicFrontPageElement
		bSuccess = bSuccess && MBAdmin.ViewChooseTopicFrontPageElementTemplate(sRedirect);
	}
	else if(sCmd.CompareText("ViewCreateTopics"))
	{
		// url: /MessageBoardAdmin?cmd=ViewCreateTopics
		bSuccess = bSuccess && MBAdmin.ViewCreateTopics(sRedirect);
	}
	else if(sCmd.CompareText("ViewCreateHomepageContent"))
	{
		// url: /MessageBoardAdmin?cmd=ViewCreateTextBoxContent
		bSuccess = bSuccess && MBAdmin.ViewCreateHomepageContent(sRedirect);
	}
	else if(sCmd.CompareText("ViewCreateBoardPromos"))
	{
		// url: /MessageBoardAdmin?cmd=ViewCreateBoardPromos
		bSuccess = bSuccess && MBAdmin.ViewCreateBoardPromos(sRedirect);
	}
	else if (sCmd.CompareText("ViewSetMessageBoardSchedule"))
	{
		// url: /MessageBoardAdmin?cmd=ViewSetMessageBoardSchedule
		bSuccess = bSuccess && MBAdmin.ViewSetMessageBoardSchedule(sRedirect);
	}
	/*
	else if(sCmd.CompareText("ViewEditInstructionalText"))
	{
		// url: /MessageBoardAdmin?cmd=ViewEditInstructionalText
		bSuccess = bSuccess && MBAdmin.ViewEditInstructionalText(sRedirect);
	}
	else if(sCmd.CompareText("ViewDefineAssetLocations"))
	{
		// url: /MessageBoardAdmin?cmd=ViewDefineAssetLocations
		bSuccess = bSuccess && MBAdmin.ViewDefineAssetLocations(sRedirect);
	}
	else if(sCmd.CompareText("ViewManageAssets"))
	{
		// url: /MessageBoardAdmin?cmd=ViewManageAssets
		bSuccess = bSuccess && MBAdmin.ViewManageAssets(sRedirect);
	}
	else if(sCmd.CompareText("ViewConfigureSiteNavigation"))
	{
		// url: /MessageBoardAdmin?cmd=ViewConfigureSiteNavigation
		bSuccess = bSuccess && MBAdmin.ViewConfigureSiteNavigation(sRedirect);
	}
	else if (sCmd.CompareText("ViewConfigureBoardFeatures"))
	{
		// url: /MessageBoardAdmin?cmd=ViewConfigureBoardFeatures
		bSuccess = bSuccess && MBAdmin.ViewConfigureBoardFeatures(sRedirect);
	}
	*/
	else if (sCmd.CompareText("ActivateBoard"))
	{
		bSuccess = bSuccess && MBAdmin.ActivateBoard(sRedirect);
	}
	else
	{
		SetDNALastError("CMessageBoardAdminBuilder", "ProcessParams()", "Invalid param string submitted");
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return bSuccess;
	}

	if(bSuccess && !sRedirect.IsEmpty())
	{
		//redirect here.
		if(!m_pPage->Redirect(sRedirect))
		{
			SetDNALastError("CMessageBoardAdminBuilder", "ProcessParams()", "Call to redirect process failed");
			bSuccess = bSuccess && m_pPage->AddInside("H2G2", GetLastErrorAsXMLString());
			return bSuccess;
		}
	}
	return bSuccess;
}

/*********************************************************************************

	bool CMessageBoardAdminBuilder::IsValidUpdateParamValue(int iValue)

		Author:		Nick Stevenson
        Created:	10/03/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdminBuilder::IsValidUpdateParamValue(int iValue)
{
	// if its not a site config type id then this function should not have been called.
	//if (iValue < CMessageBoardAdmin::AT_FRONTPAGELAYOUT	|| iValue > CMessageBoardAdmin::AT_MANAGEASSETS)
	if (iValue != CMessageBoardAdmin::AT_INSTRUCTIONALTEXT	&& iValue != CMessageBoardAdmin::AT_ASSETLOCATIONS &&
		iValue != CMessageBoardAdmin::AT_SITENAVIGATION		&& iValue != CMessageBoardAdmin::AT_BOARDFEATURES && 
		iValue != CMessageBoardAdmin::AT_MANAGEASSETS)
	{
		return SetDNALastError("CMessageBoardAdmin", "HandleUpdateType()", "Invalid update type value submitted");
	}
	return true;
}

/*********************************************************************************

	bool CMessageBoardAdminBuilder::GetUpdateTypeParams(CDNAIntArray& UpdateTypeParams)

		Author:		Nick Stevenson
        Created:	10/03/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CMessageBoardAdminBuilder::GetUpdateTypeParams(CDNAIntArray& UpdateTypeParams)
{
	TDVASSERT(UpdateTypeParams.GetSize() == 0, "CMessageBoardAdminBuilder - DNAIntArray incorrectly contains data");

	bool bSuccess = true;
	if(m_InputContext.ParamExists("UpdateType"))
	{
		int i = 0;
		int iParamCnt = m_InputContext.GetParamCount("UpdateType");

		UpdateTypeParams.SetSize(iParamCnt, 0);
		while (i < iParamCnt)
		{
			int iUpdateType = m_InputContext.GetParamInt("UpdateType", i);
			UpdateTypeParams[i] = iUpdateType;
			i++;
		}
	}
	return bSuccess;
}

	