#pragma once
#include ".\xmlbuilder.h"
#include ".\EMailAlertList.h"

class CEmailAlertBuilder : public CXMLBuilder
{
public:
	CEmailAlertBuilder(CInputContext& inputContext);
	virtual ~CEmailAlertBuilder(void);

public:
	virtual bool Build(CWholePage* pPage);

private:
	void SendEmails();
	void CheckStatus(void);
	bool DisableUserAlerts();
	bool CreateEMailList();

	bool AddCategoryToEmailList(int iNodeID);
	bool AddArticleToEMailList(int ih2g2ID);
	bool AddClubToEMailList(int iClubID);
	bool AddForumToEmailList(int iForumID);
	bool AddThreadToEMailList(int iThreadID);
	bool AddPostToEMailList(int iPostID);

private:
	int m_iUserID;
	int m_iSiteID;
	CWholePage* m_pWholePage;
	CEmailAlertList m_EMailAlert;
	CEmailAlertList::eEMailListType m_ListType;
	CEmailAlertList::eNotifyType m_NotifyType;
	bool ChangeItemListType(int iMemberID, CEmailAlertList::eEMailListType NewListTYpe);
};
