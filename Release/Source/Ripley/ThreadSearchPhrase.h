#pragma once
#include "xmlobject.h"
#include "TDVString.h"
#include <vector>
#include ".\MessageBoardPromo.h"
#include "Phrase.h"

class CSearchPhraseBase : public CXMLObject
{
public:
	CSearchPhraseBase(CInputContext& InputContext, CTDVString sToken);
	
	void UnEscapeString(CTDVString *pString);
	void EscapePhraseForURL(CTDVString *pString); 

	bool ParsePhrases(const CTDVString& sPhrases, bool bKeepExisting = false, const CTDVString& sNameSpaces = "" );
	vector<CTDVString> ParseNamespaces(const CTDVString& sNamespaces);

	CTDVString GeneratePhraseListXML();
	void GeneratePhraseListXML( CDBXMLBuilder& XML);

	void SetPhraseList( const SEARCHPHRASELIST& phraselist ) { m_lPhraseList = phraselist; }
	const SEARCHPHRASELIST& GetPhraseList() { return m_lPhraseList; }

	CTDVString GetPhraseListAsString();
	CTDVString GetNameSpacesListAsString();

	bool GetSiteKeyPhrasesXML();
	bool GetSiteKeyPhrasesFromConfig();

protected:
	SEARCHPHRASELIST m_lPhraseList;

	TDVCHAR m_cToken;	//Token used to delimit phrases when parsing.

	bool GetSiteKeyPhrases( );
};

class CThreadSearchPhrase : public CSearchPhraseBase
{
public:
	CThreadSearchPhrase(CInputContext& inputContext, CTDVString sToken);

	bool GetThreadsFromKeyPhrases(int iSkip, int iShow, int& NumResults);
	bool GetKeyPhrasesFromThread( int iForumID, int iThreadID );

	bool AddKeyPhrases( int iThreadID );
	bool RemoveKeyPhrases(int iThreadID);

	bool GetKeyPhraseHotList( int iSkip = 0, int iShow = 100, CTDVString sSortBy = "", bool bCache = true );
	bool GetKeyPhraseScores(const CTDVString& sFilter);
	bool GetSiteKeyPhraseScores( const CTDVString sFilter);

	bool BuildValidKeyPhraseList(const CTDVString& sPhrases, CTDVString& sPhraseList);
};

