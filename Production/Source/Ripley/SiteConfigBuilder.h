// SiteConfigBuilder.h: interface for the CSiteConfigBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_SITECONFIGBUILDER_H__4D0E42C4_F2B6_4323_BECA_8CA1D62E3198__INCLUDED_)
#define AFX_SITECONFIGBUILDER_H__4D0E42C4_F2B6_4323_BECA_8CA1D62E3198__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "SiteConfig.h"

class CSiteConfigBuilder : public CXMLBuilder  
{
public:
	CSiteConfigBuilder(CInputContext& inputContext);
	virtual ~CSiteConfigBuilder();

public:
	virtual bool Build(CWholePage* pPage);

protected:
	virtual bool ProcessAction(CWholePage* pPageXML, CSiteConfig* pSiteConfig);
};

#endif // !defined(AFX_SITECONFIGBUILDER_H__4D0E42C4_F2B6_4323_BECA_8CA1D62E3198__INCLUDED_)
