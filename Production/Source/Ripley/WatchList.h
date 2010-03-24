// WatchList.h: interface for the CWatchList class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_WATCHLIST_H__A3FE9420_E96B_4086_82C2_EF6F169901EA__INCLUDED_)
#define AFX_WATCHLIST_H__A3FE9420_E96B_4086_82C2_EF6F169901EA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include "TDVString.h"	// Added by ClassView

class CWatchList : public CXMLObject  
{
public:
	bool WatchingUsers(int iUserID, int iSiteID);
	bool FetchJournalEntries(int iUserID, int iSkip = 0, int iShow = 20);
	bool DoDeleteUsers();
	CTDVString m_sDeleteXML;
	bool AddDeleteUser(int iWatchedUserID);
	int m_iDelUserCount;
	CStoredProcedure* m_pDelSP;
	bool StartDeleteUsers(int iUserID);
	bool StopWatchingUser(int iUserID, int iWatchedUserID);
	bool WatchUser(int iUserID, int iWatchedUserID, int iSiteID);
	bool Initialise(int iUserID);
	CWatchList(CInputContext& inputContext);
	virtual ~CWatchList();

protected:
	bool GetDeletedUserDetails();
	bool BuildUserXML( CTDVString& sXML, int bUsageType = 0  );  
};

#endif // !defined(AFX_WATCHLIST_H__A3FE9420_E96B_4086_82C2_EF6F169901EA__INCLUDED_)
