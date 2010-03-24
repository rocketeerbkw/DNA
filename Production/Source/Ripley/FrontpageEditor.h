// FrontpageEditor.h: interface for the CFrontpageEditor class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_FRONTPAGEEDITOR_H__754DDA11_05D5_4D9E_9879_7F7D0C377642__INCLUDED_)
#define AFX_FRONTPAGEEDITOR_H__754DDA11_05D5_4D9E_9879_7F7D0C377642__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CFrontPageEditor : public CXMLBuilder  
{
public:
	virtual bool Build(CWholePage* pPage);
	CFrontPageEditor(CInputContext& inputContext);
	virtual ~CFrontPageEditor();

protected:
	bool AddEditForm(CWholePage* pPageXML, const TDVCHAR* pSubject, const TDVCHAR* pBody, const TDVCHAR* pSkin, const TDVCHAR* pDate, int iRegistered);
};

#endif // !defined(AFX_FRONTPAGEEDITOR_H__754DDA11_05D5_4D9E_9879_7F7D0C377642__INCLUDED_)
