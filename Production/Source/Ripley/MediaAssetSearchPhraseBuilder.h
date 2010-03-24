#pragma once

#include "xmlbuilder.h"

class CMediaAssetSearchPhraseBuilder : public CXMLBuilder
{
public:
	CMediaAssetSearchPhraseBuilder( CInputContext& InputContext);
	~CMediaAssetSearchPhraseBuilder();

	bool Build( CWholePage* pPage);

	//Move these definitions to a Media Asset object ?
	//Have set ranges to allow sub types to be defined.
	//A Search on images would then pull out an image suv type too.
	enum MEDIAASSET_CONTENTTYPE
	{
		MEDIAASSET_IMAGE=1000,
		MEDIAASSET_AUDIO=2000,
		MEDIAASSET_VIDEO=3000
	};
};
