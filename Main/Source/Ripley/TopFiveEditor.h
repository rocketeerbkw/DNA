// TopFiveEditor.h: interface for the CTopFiveEditor class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_TOPFIVEEDITOR_H__00CE6942_67DC_4125_99B3_47162ED6BE81__INCLUDED_)
#define AFX_TOPFIVEEDITOR_H__00CE6942_67DC_4125_99B3_47162ED6BE81__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CTopFiveEditor : public CXMLBuilder  
{
public:
	virtual bool Build(CWholePage* pPage);
	CTopFiveEditor(CInputContext& inputContext);
	virtual ~CTopFiveEditor();

};

#endif // !defined(AFX_TOPFIVEEDITOR_H__00CE6942_67DC_4125_99B3_47162ED6BE81__INCLUDED_)
