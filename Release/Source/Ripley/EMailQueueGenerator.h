#pragma once

#include ".\XMLObject.h"
#include ".\InputContext.h"
#include ".\EmailAlertList.h"

class CEMailQueueGenerator : public CXMLObject
{
public:
	CEMailQueueGenerator(CInputContext& inputContext);
	virtual ~CEMailQueueGenerator(void);

	enum eEMailUpdateType
	{
		EUT_NORMAL = 0,
		EUT_INSTANT
	};

public:
	int GetNumberOfSentEmails() { return m_iSentEMails; }
	int GetNumberOfSentPrivateMessages() { return m_iSentPrivateMsgs; }
	int GetNumberOfFailedEmails() { return m_iFailedAlerts; }
	CTDVString GetMinorErrorsXML() { return m_sErrorXML; }
	bool GetCurrentWorkingStatus(int iInstantTimeRange, int iNormalTimeRange);
	bool UpdateAndSendEMailAlerts(eEMailUpdateType UpdateType);

protected:
	bool SendEMailAndDeleteEvents(CTDVString& sXML, CTDVString& sEMail, int iUserID, int iSiteID, eEMailUpdateType EMailType, CEmailAlertList::eNotifyType NotifyType);

private:
	CInputContext& m_InputContext;
	int m_iSentEMails;
	int m_iSentPrivateMsgs;
	int m_iFailedAlerts;
	CTDVString m_sErrorXML;
};
