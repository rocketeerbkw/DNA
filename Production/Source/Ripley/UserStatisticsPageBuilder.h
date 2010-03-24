// UserStatisticsPageBuilder.h: interface for the UserStatisticsPageBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_USERSTATISTICSPAGEBUILDER_H__84C14E19_C919_4457_A551_3E9F7E0DB0D0__INCLUDED_)
#define AFX_USERSTATISTICSPAGEBUILDER_H__84C14E19_C919_4457_A551_3E9F7E0DB0D0__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CUserStatisticsPageBuilder : public CXMLBuilder  
{
	public:
		CUserStatisticsPageBuilder(CInputContext& inputContext);
		virtual ~CUserStatisticsPageBuilder();
		virtual bool Build(CWholePage* pPage);
};

#endif // !defined(AFX_USERSTATISTICSPAGEBUILDER_H__84C14E19_C919_4457_A551_3E9F7E0DB0D0__INCLUDED_)
