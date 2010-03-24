// MessageboardStatsBuilder.h: interface for the CMessageboardStatsBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MESSAGEBOARDSTATSBUILDER_H__4D0E42C4_F2B6_4323_BECA_8CA1D62E3198__INCLUDED_)
#define AFX_MESSAGEBOARDSTATSBUILDER_H__4D0E42C4_F2B6_4323_BECA_8CA1D62E3198__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CMessageboardStatsBuilder : public CXMLBuilder
{
public:
	virtual bool Build(CWholePage* pPage);
	CMessageboardStatsBuilder(CInputContext& inputContext);
	virtual ~CMessageboardStatsBuilder();

};

#endif // !defined(AFX_MESSAGEBOARDSTATSBUILDER_H__4D0E42C4_F2B6_4323_BECA_8CA1D62E3198__INCLUDED_)
