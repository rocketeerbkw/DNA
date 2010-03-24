// EventQueue.h: interface for the CEventQueue class.
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

#if !defined(AFX_EVENTQUEUE_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_)
#define AFX_EVENTQUEUE_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "EMailAlertList.h"

class CInputContext;

class CEventQueue : public CXMLObject  
{
public:
	CEventQueue(CInputContext& inputContext);
	virtual ~CEventQueue();

public:
	enum EventType
	{
		ET_ARTICLEEDITED = 0,
		ET_CATEGORYARTICLETAGGED,
		ET_CATEGORYARTICLEEDITED,
		ET_FORUMEDITED,
		ET_NEWTEAMMEMBER,
		ET_POSTREPLIEDTO,
		ET_POSTNEWTHREAD,
		ET_CATEGORYTHREADTAGGED,
		ET_CATEGORYUSERTAGGED,
		ET_CATEGORYCLUBTAGGED,
		ET_NEWLINKADDED,
		ET_VOTEADDED,
		ET_VOTEREMOVED,
		ET_CLUBOWNERTEAMCHANGE,
		ET_CLUBMEMBERTEAMCHANGE,
		ET_CLUBMEMBERAPPLICATIONCHANGE,
		ET_CLUBEDITED,
		ET_CATEGORYHIDDEN
	};

public:
	bool AddToEventQueue(	EventType eET, int iUserID,
							int iItemID, CEmailAlertList::eItemType iItemType,
							int iItemID2 = 0, CEmailAlertList::eItemType iItemType2 = CEmailAlertList::IT_H2G2);
	bool DeleteAllFromEventQueue();
	bool DeleteByDateFromEventQueue(CTDVDateTime* p_dDate);
	bool IsArticleUpdated(CStoredProcedure* p_SP);

protected:
};

#endif // !defined(AFX_EVENTQUEUE_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_)
