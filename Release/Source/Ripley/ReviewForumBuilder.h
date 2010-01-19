// ReviewForumBuilder.h: interface for the CReviewForumBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_REVIEWFORUMBUILDER_H__BDF154E3_A76D_11D5_87C0_00A024998768__INCLUDED_)
#define AFX_REVIEWFORUMBUILDER_H__BDF154E3_A76D_11D5_87C0_00A024998768__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "ReviewForum.h"

class CReviewForumBuilder  : public CXMLBuilder
{
public:
	CReviewForumBuilder(CInputContext& inputContext);
	virtual ~CReviewForumBuilder();
	virtual bool Build(CWholePage* pPage);
protected:
	bool SwitchSites(CWholePage* pPage,CReviewForum& mReviewForum);
};

#endif // !defined(AFX_REVIEWFORUMBUILDER_H__BDF154E3_A76D_11D5_87C0_00A024998768__INCLUDED_)
