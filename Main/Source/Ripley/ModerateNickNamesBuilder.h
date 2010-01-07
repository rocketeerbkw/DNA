#pragma once
#include "xmlbuilder.h"

class CModerateNickNamesBuilder : public CXMLBuilder
{
public:
	CModerateNickNamesBuilder( CInputContext& InputContext );
	~CModerateNickNamesBuilder(void);

	bool Build(CWholePage* pPage);
	bool ProcessSubmission(CUser* pViewer,CWholePage* pPage);
	bool SendEmail( int iUserID, CTDVString sOldNickname, CTDVString sUsersEmail);
	bool SendMailOrSystemMessage( int iUserID, CTDVString sOldNickname, CTDVString sUsersEmail, int iSiteID); 
};
