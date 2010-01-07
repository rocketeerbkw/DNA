// SiteAdminBuilder.h: interface for the CSiteAdminBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_SITEADMINBUILDER_H__4D0E42C4_F2B6_4323_BECA_8CA1D62E3198__INCLUDED_)
#define AFX_SITEADMINBUILDER_H__4D0E42C4_F2B6_4323_BECA_8CA1D62E3198__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

// Impose a hard limit of 10 years on ThreadEditTimeLimit
// Shouldn't change often enough to warrant putting in config file
#define UPPERLIMIT_THREADEDITTIMELIMIT 315360000

class CSiteAdminBuilder : public CXMLBuilder  
{
public:
	virtual bool Build(CWholePage* pPage);
	CSiteAdminBuilder(CInputContext& inputContext);
	virtual ~CSiteAdminBuilder();

private:
	bool GetAndCheckThreadEditTimeLimit(int& iThreadEditTimeLimit);
};

#endif // !defined(AFX_SITEADMINBUILDER_H__4D0E42C4_F2B6_4323_BECA_8CA1D62E3198__INCLUDED_)
