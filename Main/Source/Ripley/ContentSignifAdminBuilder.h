// ContentSignifAdminBuilder.h: interface for the ContentSignifAdminBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "XMLBuilder.h"
#include "InputContext.h"
#include "User.h"
#include "ContentSignifSettings.h"


class CContentSignifAdminBuilder : public CXMLBuilder 
{
public:
	CContentSignifAdminBuilder(CInputContext& inputContext);
	virtual ~CContentSignifAdminBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
	bool ProcessParams(CContentSignifSettings& ContentSignifSettings);

protected:
	CWholePage* m_pPage;
	CUser* m_pViewingUser;
};