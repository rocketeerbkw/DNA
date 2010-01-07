#pragma once

#include "TDVString.h"
#include "XMLObject.h"

#include "ThreadSearchPhrase.h"	//Definition of CSearchPhraseBase

class CMediaAssetSearchPhrase : public CSearchPhraseBase
{
public:
	CMediaAssetSearchPhrase( CInputContext&, CTDVString sToken );

	bool AddKeyPhrases( int AssetID );
	bool GetMediaAssetsFromKeyPhrases( int iContentType, int iSkip, int iShow, CTDVString sSortBy, int& iNumResults );

	bool GetKeyPhraseHotList( int iSkip, int iShow, CTDVString sSortBy, int iMediaAssetType, bool bCache = true);

	bool GetKeyPhrasesFromAsset( int iAssetID );

	bool CreatePreviewPhrases( const CTDVString& sPhrases );

	bool RemoveKeyPhrasesFromAsset( int iMediaAssetID, CTDVString& sPhrases );
	bool RemoveAllKeyPhrasesFromAsset( int iMediaAssetID );

};
