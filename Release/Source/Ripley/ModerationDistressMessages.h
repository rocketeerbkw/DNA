#pragma once
#include "xmlbuilder.h"

class CModerationDistressMessagesBuilder :
	public CXMLBuilder
{
public:
	CModerationDistressMessagesBuilder( CInputContext& InputContext );
	~CModerationDistressMessagesBuilder(void);

	bool Build(CWholePage* pPage);
};

class CModerationDistressMessages : public CXMLObject
{
public:
	CModerationDistressMessages( CInputContext& InputContext );

	bool GetDistressMessages( int iModClassId = 0 );
	bool GetDistressMessage( int iMessageID, CTDVString& sTitle, CTDVString& sBody );

	bool RemoveDistressMessage(int MessageId);
	bool AddDistressMessage(int iModClassId, CTDVString sTitle, CTDVString sText);
	bool UpdateDistressMessage(int MessageId, int iModClassId, CTDVString sTitle, CTDVString sText);

	bool PostDistressMessage( CUser* pUser, int iSiteId, int iForumId,int iThreadId, int iReplyTo, const CTDVString& sSubject, const CTDVString& sBody );

};
