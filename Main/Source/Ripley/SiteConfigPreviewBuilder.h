#pragma once
#include "siteconfigbuilder.h"

class CSiteConfigPreviewBuilder : public CSiteConfigBuilder
{
public:
	CSiteConfigPreviewBuilder(CInputContext& InputContext);
	virtual ~CSiteConfigPreviewBuilder(void);

public:
	virtual bool Build(CWholePage* pPage);
};
