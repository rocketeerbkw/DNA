// MessageBoardSchedulePageBuilder.h: interface for the CMessageBoardSchedulePageBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MESSAGEBOARDSCHEDULEPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_)
#define AFX_MESSAGEBOARDSCHEDULEPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "ForumSchedule.h"
#include "DNAArray.h"
#include "Topic.h"
#include "SiteOpenCloseSchedule.h"

class CMultiStep;

class CMessageBoardSchedulePageBuilder : public CXMLBuilder 
{
public:
	CMessageBoardSchedulePageBuilder(CInputContext& inputContext);
	virtual ~CMessageBoardSchedulePageBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
	bool ProcessParams(int iSiteID, CSiteOpenCloseSchedule& SiteOpenCloseSchedule);
	bool ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg);
	bool UpdateSchedule(int iSiteID, CSiteOpenCloseSchedule& SiteOpenCloseSchedule);
	bool UpdateSiteClosed(int iSiteID, bool bCloseSite);

protected:
	bool HasErrorBeenReported();

	CWholePage* m_pPage;
	CUser* m_pViewingUser;
};

#endif // !defined(AFX_MESSAGEBOARDSCHEDULEPAGEBUILDER_H__0885504D_4D91_4F1E_A08B_F2A143A5AC78__INCLUDED_)
