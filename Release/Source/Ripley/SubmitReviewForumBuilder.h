// SubmitReviewForumBuilder.h: interface for the CSubmitReviewForumBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_SUBMITREVIEWFORUMBUILDER_H__E702CDA1_922A_11D5_87AD_00A024998768__INCLUDED_)
#define AFX_SUBMITREVIEWFORUMBUILDER_H__E702CDA1_922A_11D5_87AD_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CSubmitReviewForumBuilder : public CXMLBuilder  
{
public:
	CSubmitReviewForumBuilder(CInputContext& inputContext);
	virtual ~CSubmitReviewForumBuilder();
	virtual bool Build(CWholePage* pPage);
};

#endif // !defined(AFX_SUBMITREVIEWFORUMBUILDER_H__E702CDA1_922A_11D5_87AD_00A024998768__INCLUDED_)
