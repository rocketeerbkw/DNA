// EditReviewForumForm.h: interface for the CEditReviewForumForm class.
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

#if !defined(AFX_EDITREVIEWFORUMFORM_H__114E2E12_D8EE_11D5_87E9_00A024998768__INCLUDED_)
#define AFX_EDITREVIEWFORUMFORM_H__114E2E12_D8EE_11D5_87E9_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"

class CEditReviewForumForm : public CXMLObject  
{
public:
	CEditReviewForumForm(CInputContext& inputContext);
	virtual ~CEditReviewForumForm();
	bool CreateFromDB(int iReviewForumID,int iCurrentSiteID);
	bool RequestUpdate(int iReviewForumID,const CTDVString& sName,const CTDVString& sURL,bool bRecommendable,int iIncubateTime,int iCurrentSiteID);
	bool DoAddNew(const CTDVString& sName,const CTDVString& sURL,bool bRecommendable,int iIncubateTime, int iCurrentSiteID, int iUserID);

};

#endif // !defined(AFX_EDITREVIEWFORUMFORM_H__114E2E12_D8EE_11D5_87E9_00A024998768__INCLUDED_)
