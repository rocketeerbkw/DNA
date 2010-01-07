// MessageBoardAdmin.cpp: implementation of the CXMLBuilder class.
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

#if !defined(AFX_MESSAGEBOARDADMIN_H__3166C3A7_EE08_11D3_BD68_00A02480D5F4__INCLUDED_)
#define AFX_MESSAGEBOARDADMIN_H__3166C3A7_EE08_11D3_BD68_00A02480D5F4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "InputContext.h"
#include "XMLError.h"
#include "TDVString.h"
#include "XMLobject.h"

// Make sure that this matches up with ratingToString[]
//

class CMessageBoardAdmin : public CXMLObject
{
public:
	CMessageBoardAdmin(CInputContext& inputContext);
	~CMessageBoardAdmin();
	bool ViewChooseFrontPageLayout(CTDVString& sRedirect);
	bool ViewChooseFrontPageTemplate(CTDVString& sRedirect);
	bool ViewChooseTopicFrontPageElementTemplate(CTDVString& sRedirect);
	bool ViewCreateTopics(CTDVString& sRedirect);
	bool ViewCreateBoardPromos(CTDVString& sRedirect);
	bool ViewEditInstructionalText(CTDVString& sRedirect);
	bool ViewDefineAssetLocations(CTDVString& sRedirect);
	bool ViewManageAssets(CTDVString& sRedirect);
	bool ViewConfigureSiteNavigation(CTDVString& sRedirect);
	bool ViewCreateHomepageContent(CTDVString& sRedirect);
	bool ViewConfigureBoardFeatures(CTDVString& sRedirect);
	bool ViewSetMessageBoardSchedule(CTDVString& sRedirect);
	bool ActivateBoard(CTDVString& sRedirect);
	bool GetAdminState();
	bool HandleUpdateType(int iTypeID);
	
	enum
	{
		AT_FRONTPAGELAYOUT			= 1,
		AT_FRONTPAGETEMPLATE		= 2,
		AT_TOPICFRONTPAGEELEMENT	= 3,
		AT_TOPICCREATION			= 4,
		AT_HOMEPAGECONTENT			= 5,
		AT_MESSAGEBOARDPROMOS		= 6,
		AT_MESSAGEBOARDSCHEDULE		= 7,
		AT_INSTRUCTIONALTEXT		= 8,
		AT_ASSETLOCATIONS			= 9,
		AT_SITENAVIGATION			= 10,
		AT_BOARDFEATURES			= 11,
		AT_MANAGEASSETS				= 12
	};


private:
	CInputContext& m_InputContext;
	bool UpdateAdminStatus(int iTask, int iStatus);
	bool UpdateEveryAdminStatusForSite(int iStatus);
	bool GetStatusIndicators(CTDVString& sXML);
	bool GetReadyToLauchIndicators(CTDVString& sXML);
	bool GetTemplateSetUpIsReadyIndicators(CTDVString& sXML);
	bool GetTopicIsReadyIndicators(CTDVString& sXML);
	bool GetHomepageContentIsReadyIndicators(CTDVString& sXML);
	bool GetBoardPromoIsReadyIndicators(CTDVString& sXML);
	bool GetBoardScheduleIsReadyIndicators(CTDVString& sXML);
	bool GetAssetsAreReadyIndicators(CTDVString& sXML);
	void BuildReadyToLaunchXML(const int iType, CTDVString& sXML, const CTDVString& sOptInsert="");
	bool SetupTopicsForumOpeningAndClosingTimes(  int iTopicStatus, int iSiteID );

	enum
	{
		AS_UNREAD					= 0,
		AS_EDITED					= 1,
	};

};


/*********************************************************************************
inline void CMessageBoardAdmin::SetId(const int iId)
Author:		David van Zijl
Created:	29/07/2004
Purpose:	Sets internal value
*********************************************************************************/
/*
inline void CMessageBoardAdmin::SetId(const int iId)
{
	m_iId = iId;
}
*/

#endif