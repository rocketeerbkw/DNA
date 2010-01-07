// EditReviewForumBuilder.cpp: implementation of the CEditReviewForumBuilder class.
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
#include "EditReviewForumBuilder.h"
#include "EditReviewForumForm.h"
#include "User.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CEditReviewForumBuilder::CEditReviewForumBuilder(CInputContext& inputContext)
:CXMLBuilder(inputContext)
{

}

CEditReviewForumBuilder::~CEditReviewForumBuilder()
{

}

bool CEditReviewForumBuilder::Build(CWholePage* pPage)
{
	CEditReviewForumForm	mForm(m_InputContext);

	if(!InitPage(pPage, "EDITREVIEW", true))
	{
		return false;
	}

	CTDVString	sMode;

	m_InputContext.GetParamString("mode", sMode);
	if (sMode.GetLength() > 0)
	{
		pPage->SetAttribute("H2G2", "MODE", sMode);
	}

	//check that they have the privileges

	CUser* pUser = m_InputContext.GetCurrentUser();
	if (pUser == NULL || !pUser->GetIsEditor())	
	{
		pPage->AddInside("H2G2","<EDITREVIEWFORM><ERROR TYPE='NOEDIT'>Current User does not have permission to edit the Review Forum</ERROR></EDITREVIEWFORM>");		
		return true;
	}


	
	CTDVString sAction = "Edit";

	if (m_InputContext.ParamExists("action"))
	{
		m_InputContext.GetParamString("action",sAction);
	}

	if (sAction.CompareText("Update"))
	{
		
		int iReviewForumID = 0;
		
		if (m_InputContext.ParamExists("id"))
		{
			iReviewForumID = m_InputContext.GetParamInt("id");
		}
		else
		{
			pPage->AddInside("H2G2","<EDITREVIEWFORM><ERROR TYPE='BADPARAM'>The parameters are invalid</ERROR></EDITREVIEWFORM>");
			return true;
		}


		CTDVString sName;
		CTDVString sURL;
		bool bRecommendable = false;
		int iIncubateTime = 0;

		m_InputContext.GetParamString("name",sName);
		m_InputContext.GetParamString("url",sURL);
		
		if (m_InputContext.ParamExists("recommend"))
		{
			if (m_InputContext.GetParamInt("recommend") == 1)
			{
				bRecommendable = true;
				iIncubateTime = m_InputContext.GetParamInt("incubate");
			}
			else
			{
				bRecommendable = false;
			}

			if (!mForm.RequestUpdate(iReviewForumID,sName,sURL,bRecommendable,iIncubateTime,m_InputContext.GetSiteID()))
			{
				pPage->AddInside("H2G2","<EDITREVIEWFORM><ERROR TYPE='UPDATE'>Error occured while updating</ERROR></EDITREVIEWFORM>");
				return true;
			}

			//sitedata needs to be update for updates

			m_InputContext.SiteDataUpdated();
			m_InputContext.Signal("/Signal?action=recache-site");
		}
		else
		{
			pPage->AddInside("H2G2","<EDITREVIEWFORM><ERROR TYPE='BADPARAM'>The parameters are invalid</ERROR></EDITREVIEWFORM>");
			return true;
		}
	}
	//we should have a blank form and an add button
	else if (sAction.CompareText("AddNew"))
	{
		pPage->AddInside("H2G2","<EDITREVIEWFORM><BLANKFORM></BLANKFORM></EDITREVIEWFORM>");
		return true;
	}
	else if (sAction.CompareText("DoAddNew"))
	{
		CTDVString sName;
		CTDVString sURL;
		bool bRecommendable = false;
		int iIncubateTime = 0;
		int iH2G2ID = 0;

		m_InputContext.GetParamString("name",sName);
		m_InputContext.GetParamString("url",sURL);
		
		if (m_InputContext.ParamExists("recommend"))
		{
			if (m_InputContext.GetParamInt("recommend") == 1)
			{
				bRecommendable = true;
				iIncubateTime = m_InputContext.GetParamInt("incubate");
			}
			else
			{
				bRecommendable = false;
			}

			if (!mForm.DoAddNew(sName,sURL,bRecommendable,iIncubateTime,m_InputContext.GetSiteID(),pUser->GetUserID() ))
			{
				pPage->AddInside("H2G2","<EDITREVIEWFORM><ERROR TYPE='UPDATE'>Error occured while updating</ERROR></EDITREVIEWFORM>");
				return true;
			}

			//sitedata needs to be update for updates

			m_InputContext.SiteDataUpdated();
			m_InputContext.Signal("/Signal?action=recache-site");
		}
		else
		{
			pPage->AddInside("H2G2","<EDITREVIEWFORM><ERROR TYPE='BADPARAM'>The parameters are invalid</ERROR></EDITREVIEWFORM>");
			return true;
		}
	}
	else //sAction = "edit"
	{
		int iReviewForumID = 0;
		
		if (m_InputContext.ParamExists("id"))
		{
			iReviewForumID = m_InputContext.GetParamInt("id");
		}
		else
		{
			pPage->AddInside("H2G2","<EDITREVIEWFORM><ERROR TYPE='BADPARAM'>The parameters are invalid</ERROR></EDITREVIEWFORM>");
			return true;
		}

		if (!mForm.CreateFromDB(iReviewForumID,m_InputContext.GetSiteID()))
		{
			pPage->AddInside("H2G2","<EDITREVIEWFORM><ERROR TYPE='VIEW'>Error occured while creating from database</ERROR></EDITREVIEWFORM>");
			return true;
		}
	}

	pPage->AddInside("H2G2",&mForm);
	

	return true;

}
