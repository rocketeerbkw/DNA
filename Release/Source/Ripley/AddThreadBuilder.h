// AddThreadBuilder.h: interface for the CAddThreadBuilder class.
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


#if !defined(AFX_ADDTHREADBUILDER_H__79F0D433_FC50_11D3_8A2B_00104BF83D2F__INCLUDED_)
#define AFX_ADDTHREADBUILDER_H__79F0D433_FC50_11D3_8A2B_00104BF83D2F__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CAddThreadBuilder : public CXMLBuilder  
{
public:
	CAddThreadBuilder(CInputContext& inputContext);
	virtual ~CAddThreadBuilder();
	virtual bool Build(CWholePage* pPage);

protected:

	bool IsReviewForum(int iForumID,CTDVString& sReviewForumDetails);
	void BuildPostThreadFormXML(CTDVString& sXML,int iForumID, int iThreadID,int iReplyTo, int iPostIndex,
								int iProfanityTriggered, int iSeconds, bool bCanWrite, int iPostStyle, int iArticle, int iUserID, 
								CTDVString& sSubject, CTDVString& sBody, CTDVString& sInReplyToXML, int iNonAllowedURLsTriggered, int iEmailAddressTriggerred );
};

#endif // !defined(AFX_ADDTHREADBUILDER_H__79F0D433_FC50_11D3_8A2B_00104BF83D2F__INCLUDED_)
