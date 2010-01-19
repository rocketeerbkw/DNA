#pragma once
#include "xmlobject.h"
#include "storedprocedure.h"
#include "tdvstring.h"
#include <map>

class CEmailVocab :
	public CXMLObject
{
public:
	CEmailVocab(CInputContext& inputContext, int iSiteIDm = 0);
	virtual ~CEmailVocab(void);
	bool InitialiseVocab(void);
	const CTDVString& GetSubstitution(const int iSiteID, const CTDVString& sName, CTDVString& sSubstitution) const;
	bool AddNewEntry(int iSiteID, const CTDVString& sName, const CTDVString& sSubstitution);
	bool RemoveEntry(const int iSiteID, const CTDVString& sName);

	typedef std::pair<CTDVString, CTDVString> DictionaryEntry;
	typedef std::map<CTDVString, CTDVString> Dictionary;
	typedef std::pair<int, Dictionary> SitesDictionaryEntry;
	typedef std::map<int, Dictionary> SitesDictionary;

	virtual bool GetAsString(CTDVString& sEmailVocab);

private:
	CStoredProcedure m_SP;
	CInputContext& m_InputContext;
	int m_iSiteID;
	
	SitesDictionary m_siteDictionary;

	bool AddEntryFromSP(void);
	bool AddEntryToSitesDictionary(int iSiteID, const CTDVString& sName, const CTDVString& sSubstitution);
	
};
