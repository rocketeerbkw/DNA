// ContentSignifBuilder.h: interface for the ContentSignifBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "XMLBuilder.h"
#include "InputContext.h"
#include "XMLObject.h"


class CSignifContent : public CXMLObject 
{
public:
	CSignifContent(CInputContext& inputContext);
	virtual ~CSignifContent();
	bool GetMostSignifContent(int p_iSiteID, CTDVString& p_xmlString);
	bool DecrementContentSignif(int p_iSiteID);

protected:
	CWholePage* m_pPage;
};