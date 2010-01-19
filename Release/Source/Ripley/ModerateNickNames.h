#pragma once

#include "XMLObject.h"

class CModerateNickNames : public CXMLObject
{
public:
	CModerateNickNames( CInputContext& InputContext );
	~CModerateNickNames(void);

	bool GetNickNames( int iUserID, bool bAlerts, bool bHeld, bool bLocked, int iModClass = 0, int iShow = 10 );

	bool Update(int iModID, int iStatus, CTDVString& sUsersEmail );

	bool UnlockNickNamesForUser( int iUserID, int iModClassID );
};
