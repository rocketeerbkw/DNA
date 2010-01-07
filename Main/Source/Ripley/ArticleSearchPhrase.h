//////////////////////////////////////////////////////////////////////
// ArticleSearchPhrase.h: interface for the CArticleSearchPhrase class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/

#if !defined(AFX_ARTICLESEARCHPHRASE_H__FC72D80A_3534_4050_93F1_6A6C62203D8D__INCLUDED_)
#define AFX_ARTICLESEARCHPHRASE_H__FC72D80A_3534_4050_93F1_6A6C62203D8D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "TDVString.h"
#include "XMLObject.h"
#include "threadsearchphrase.h"

class CArticleSearchPhrase : public CSearchPhraseBase
{
public:
	CArticleSearchPhrase( CInputContext&, CTDVString sToken );

	bool AddKeyPhrases( int iH2G2ID );
	bool GetArticlesFromKeyPhrases( int iContentType, int iSkip, int iShow, CTDVString sSortBy, bool bCache, int& iNumResults );

	bool GetKeyPhraseHotList( int iSkip, int iShow, CTDVString sSortBy, int iMediaAssetType, bool bCache = true);

	bool GetKeyPhrasesFromArticle( int iH2G2ID );

	bool RemoveKeyPhrasesFromArticle( int iH2G2ID, std::vector<int> phrasenamespaceids );
	bool RemoveAllKeyPhrasesFromArticle( int iH2G2ID );

};
#endif // !defined(AFX_ARTICLESEARCHPHRASE_H__FC72D80A_3534_4050_93F1_6A6C62203D8D__INCLUDED_)
