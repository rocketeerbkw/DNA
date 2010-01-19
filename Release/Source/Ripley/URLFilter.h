// URLFilter.h: interface for the CURLFilter class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_URLFILTER_H__C094B319_42B5_4F92_AEC8_52F7E74E41E7__INCLUDED_)
#define AFX_URLFILTER_H__C094B319_42B5_4F92_AEC8_52F7E74E41E7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "TDVString.h"
#include "InputContext.h"

class CURLFilter
{
public:
	CURLFilter(CInputContext inputContext);
	virtual ~CURLFilter(void);

	enum FilterState
	{
		Pass,
		Fail
	};

public:
	FilterState CheckForURLs(const TDVCHAR* pCheckString, CTDVString* psMatch = NULL);
private:
	CInputContext m_InputContext;
};
#endif // !defined(AFX_URLFILTER_H__C094B319_42B5_4F92_AEC8_52F7E74E41E7__INCLUDED_)
