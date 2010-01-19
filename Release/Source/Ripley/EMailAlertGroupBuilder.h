#pragma once
#include "xmlbuilder.h"
#include ".\EMailAlertGroup.h"

class CEMailAlertGroupBuilder :	public CXMLBuilder
{
public:
	CEMailAlertGroupBuilder(CInputContext& inputContext);
	virtual ~CEMailAlertGroupBuilder(void);

public:
	virtual bool Build(CWholePage* pPage);

protected:
	bool AddItemToAlertList(int iUserID, int iItemID, int iItemType,/* CTDVString& sAlertType, CTDVString& sNotifyType, */bool& bPageOk);
	bool RemoveItemFromAlertList(int iUserID, int iGroupID, bool& bPageOk);
	bool EditItemInAlertList(int iUserID, int iGroupID, CTDVString& sAlertType, CTDVString& sNotifyType, bool& bPageOk);
	bool EditUserItemsInAlertList(int iUserID, bool bOwnedItems, const CTDVString& sAlertType, const CTDVString& sNotifyType, bool& bPageOk);

private:
	CWholePage* m_pPage;
};
