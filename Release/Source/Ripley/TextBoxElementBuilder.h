#pragma once
#include "xmlbuilder.h"
#include ".\TextBoxElement.h"

class CTextBoxElementBuilder :	public CXMLBuilder
{
public:
	CTextBoxElementBuilder(CInputContext& inputContext);
	virtual ~CTextBoxElementBuilder(void);

private:
	CWholePage* m_pWholePage;

private:
	bool AddActionXMLResult(bool bActionOk, const TDVCHAR* psActionName, int iTextBoxID, CTextBoxElement* pTextBox = NULL);

public:
	virtual bool Build(CWholePage* pPage);
};
