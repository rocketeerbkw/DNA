// ProfanityFilter.h: interface for the CProfanityFilter class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_PROFANITYFILTER_H__EC247675_2FC9_4D6A_BC0D_18DD8CB88C3A__INCLUDED_)
#define AFX_PROFANITYFILTER_H__EC247675_2FC9_4D6A_BC0D_18DD8CB88C3A__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "TDVString.h"
#include "InputContext.h"

class CProfanityFilter
{
public:
	CProfanityFilter(CInputContext inputContext);
	virtual ~CProfanityFilter();

	enum FilterState
	{
		Pass,
		FailBlock,
		FailRefer,
	};

public:
	FilterState CheckForProfanities(const TDVCHAR* pCheckString, CTDVString* psMatch = NULL);
	void RemoveLinksFromText(CTDVString sText, CTDVString& newText);
    CTDVString TrimPunctuation(CTDVString sText);
private:
	CInputContext m_InputContext;

};

#endif // !defined(AFX_PROFANITYFILTER_H__EC247675_2FC9_4D6A_BC0D_18DD8CB88C3A__INCLUDED_)
