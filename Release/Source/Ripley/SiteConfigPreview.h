#pragma once
#include "siteconfig.h"

class CSiteConfigPreview : public CSiteConfig
{
public:
	CSiteConfigPreview(CInputContext& InputContext);
	virtual ~CSiteConfigPreview(void);

public:
	bool GetPreviewSiteConfig(CTDVString& sSiteConfig, int iSiteID, CTDVString* psEditKey = NULL);

	virtual bool GetSiteConfig(int iSiteID, CTDVString& sSiteConfig);
	virtual bool SetSiteConfig(CStoredProcedure* pSP, int iSiteID, const TDVCHAR* psSiteConfig, const TDVCHAR* psEditKey);

public:
	bool MakePreviewSiteConfigActive(int iSiteID);

private:
	bool MergeChangesToExistingConfig(int iSiteID, const TDVCHAR* sChangedConfig, CTDVString& sMergedConfig);
};
