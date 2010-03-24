#pragma once
#include "xmlobject.h"
#include ".\StoredProcedure.h"

class CUserPrivacy : public CXMLObject
{
public:
	CUserPrivacy(CInputContext& inputContext);
	virtual ~CUserPrivacy(void);

public:
	// Intialisation
	bool InitialiseUserPrivacyDetails(int iUserID = 0);

	// Get the details as XML
	bool GetUserPrivacyDetails();

	// Update functions
	bool StartUpdate();
	bool UpdateHideLocation(bool bHide);
	bool UpdateHideUserName(bool bHide);
	bool CommitChanges();

protected:
	bool ResyncUsersLocation();
	bool ResyncUserDetails();

private:
	bool m_bInitialised;
	CStoredProcedure m_SP;
	int m_iCurrentUser;

	bool m_bHideLocation;
	bool m_bHideUserName;

	bool m_bUpdateStarted;
	bool m_bHideLocationUpdated;
	bool m_bHideUserNameUpdated;
};
