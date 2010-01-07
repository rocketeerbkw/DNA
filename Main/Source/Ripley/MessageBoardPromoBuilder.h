#pragma once
#include ".\xmlbuilder.h"
#include ".\MessageBoardPromo.h"

class CMessageBoardPromoBuilder : public CXMLBuilder
{
public:
	CMessageBoardPromoBuilder(CInputContext& InputContext);
	virtual ~CMessageBoardPromoBuilder(void);

private:
	CWholePage* m_pWholePage;
	bool AddActionXMLResult(bool bActionOk, const TDVCHAR* psActionName, int iPromoID, CMessageBoardPromo* pBoardPromo);

public:
	virtual bool Build(CWholePage* pPage);
};
