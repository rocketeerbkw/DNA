// ContentSignifBuilder.h: interface for the ContentSignifBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "XMLBuilder.h"
#include "InputContext.h"
#include "User.h"
#include "SignifContent.h"


class CContentSignifBuilder : public CXMLBuilder 
{
public:
	CContentSignifBuilder(CInputContext& inputContext);
	virtual ~CContentSignifBuilder();
	virtual bool Build(CWholePage* pPage);

protected:
	bool ProcessParams(CSignifContent& SignifContent);

protected:
	CWholePage* m_pPage;
	CUser* m_pViewingUser;
};