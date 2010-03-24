// ForumSchedule.h: interface for the CForumSchedule class.
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

#if !defined(AFX_ForumSchedule_H__BF6FCCDE_0A01_4BB3_80AC_57C3D23553DE__INCLUDED_)
#define AFX_ForumSchedule_H__BF6FCCDE_0A01_4BB3_80AC_57C3D23553DE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "afxtempl.h"
#include "User.h"
#include "XMLObject.h"
#include "MultiStep.h"
#include "DNAArray.h"

class CInputContext;

class CForumSchedule : public CXMLObject  
{
public:
	CForumSchedule(CInputContext& inputContext);
	virtual ~CForumSchedule();

public:
bool Create24SevenSchedule(CDNAIntArray& ForumIDList);
bool CreateDailyRecurSchedule(CDNAIntArray& ForumIDList, int iHoursOpen, int iHoursClose, int iMinsOpen, int iMinsClose);
bool CreateWeeklyRecurSchedule(CDNAIntArray& ForumIDList, CDNAIntArray& iHoursOpen, CDNAIntArray& iHoursClose, CDNAIntArray& iMinsOpen, CDNAIntArray& iMinsClose, CDNAIntArray& iClosedAllDay);
bool GetForumScheduleInfo(CDNAIntArray& ForumIDList, bool bNormalise, int* pCount = NULL);
bool SetActiveStatus(CDNAIntArray& ForumIDList, int active);
bool DeleteSchedulesForForumID(CDNAIntArray& ForumIDList);
bool GenerateSchedulesIfNewForums(CDNAIntArray& ForumIDList, int iSiteID);

bool CreateScheduleDirect(CDNAIntArray& ForumIDList, int iEventType, int iAction, int iActive, int iDayType, int iHours, int iMins);

protected:
	bool BuildForumIDs(CDNAIntArray& ForumIDList, CTDVString& sForumIDs);
	bool m_bHasSchedule;


private:

bool BuildScheduleInfoXML(CDNAIntArray& ForumIDList, CTDVString& sXML,int* pCount);
bool BuildNormalisedScheduleInfoXML(CDNAIntArray& ForumIDList, CTDVString& sXML, bool& bDoneFirst, int* pCount);
bool GenerateDuplicateScheduledEventsForNewForums(int iFirstExisting, CDNAIntArray& ForumIDList);

};
	
#endif // !defined(AFX_FORUMSCHEDULE_H__BF6FCCDE_0A01_4BB3_80AC_57C3D23553DE__INCLUDED_)
