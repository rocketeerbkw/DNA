// FrontPageLayout.h: implementation of the CXMLBuilder class.
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

#if !defined(AFX_FRONTPAGELAYOUT_H__3166C3A7_EE08_11D3_BD68_00A02480D5F4__INCLUDED_)
#define AFX_FRONTPAGELAYOUT_H__3166C3A7_EE08_11D3_BD68_00A02480D5F4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "InputContext.h"
#include "PageBody.h"
#include "XMLError.h"

// Make sure that this matches up with ratingToString[]
//

class CFrontPageLayout : public CXMLObject
{
public:
	CFrontPageLayout(CInputContext& inputContext);
	~CFrontPageLayout();

public:
	bool MakePreviewItemActive(int iSiteID);
	bool GetLayoutAndTemplateData(int& iLayoutType, int& iTmplType, int& iElemTmplType, CTDVString& sElemTemplateGuideML);
	bool UpdateFrontPagePreview(int iUser, const TDVCHAR* psEditKey, bool& bEditedByAnotherUser);

	enum
	{
		LAYOUT_GUIDEML_INDICATOR			= 4,
		ELEMENTTEMPLATE_GUIDEML_INDICATOR	= 6
	};

	bool UpdateFrontPagePreviewDirect(int iSiteID, const TDVCHAR* pBody,int iEditorID);


	// Mark H's new code
	bool InitialisePageBody(int iSiteID, bool bIsPreviewFrontPage = false, bool bRequiresPageLayout = false);
	CPageBody* GetPageBody() { return &m_PageBody; }

	bool SetFrontPageLayoutType(int iType);
	bool SetFrontPageElementType(int iType);
	bool SetFromtPageTemplateType(int iType);
	bool SetFrontPageElementGuideML(const TDVCHAR* psElementGuideML);
	bool SetFrontPageBodyText(const TDVCHAR* psBodyText);

	bool AddEscapedElementGuideML();
	bool SetUpdateStep(int iStep);
	bool GetPageLayoutXML(CTDVString& sPageLayoutXML);
	bool CreateFromPageLayout();

private:
	CPageBody m_PageBody;

	bool SetExtraInfoValue(const TDVCHAR* psTagName, CTDVString& sValue);
	bool UpdateExtraInfoFromPageBody();
};

#endif