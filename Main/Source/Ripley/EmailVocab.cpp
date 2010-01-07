#include "stdafx.h"
#include ".\emailvocab.h"

CEmailVocab::CEmailVocab(CInputContext& inputContext, int iSiteID) :
	CXMLObject(inputContext), m_InputContext(inputContext), m_iSiteID(iSiteID)
{
	inputContext.InitialiseStoredProcedureObject(m_SP);
}

CEmailVocab::~CEmailVocab(void)
{
}

/*********************************************************************************

	bool CEmailVocab::InitialiseVocab(void)

		Author:		David Williams
        Created:	01/12/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailVocab::InitialiseVocab(void)
{
	bool bRetVal = true;

	m_SP.FetchEmailVocab();

	while ( !m_SP.IsEOF() )
	{
		AddEntryFromSP();
		m_SP.MoveNext();
	}

	return bRetVal;
}

/*********************************************************************************

	bool CEmailVocab::AddEntry()

		Author:		David Williams
        Created:	01/12/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailVocab::AddEntryToSitesDictionary(int iSiteID, const CTDVString& sName, const CTDVString& sSubstitution)
{
	DictionaryEntry dictEntry(sName, sSubstitution);
	Dictionary dict;

	//see if we already have a dictionary for this site
	SitesDictionary::iterator it = m_siteDictionary.find(iSiteID);
	bool bHaveExistingDict = (it != m_siteDictionary.end());
	if ( bHaveExistingDict )
	{
		//get the existing dictionary
		dict = (*it).second;
	}

	//add the new entry to the dictionary
	dict.insert(dictEntry);

	//add the dictionary if necessary
	if ( !bHaveExistingDict )
	{
		m_siteDictionary.insert(SitesDictionaryEntry(iSiteID, dict));
	}	
	return true;
}

/*********************************************************************************

	bool CEmailVocab::AddEntryFromSP(void)

		Author:		David Williams
        Created:	01/12/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailVocab::AddEntryFromSP(void)
{
	int iSiteID;
	CTDVString sName;
	CTDVString sSubstitution;

	iSiteID = m_SP.GetIntField("SiteID");
	m_SP.GetField("Name", sName);
	m_SP.GetField("Substitution", sSubstitution);

	return AddEntryToSitesDictionary(iSiteID, sName, sSubstitution);
}
/*********************************************************************************

	CTDVString CEmailVocab::MakeSubstitution(int iSiteID, CTDVString& sName)

		Author:		David Williams
        Created:	01/12/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
const CTDVString& CEmailVocab::GetSubstitution(const int iSiteID, const CTDVString& sName, CTDVString& sSubstitution) const
{
	SitesDictionary::const_iterator it = m_siteDictionary.find(iSiteID);
	if (it != m_siteDictionary.end())
	{
		Dictionary dict = (*it).second;
		sSubstitution = dict[sName];
	}
	return sSubstitution;
}

/*********************************************************************************

	bool CEmailVocab::AddNewEntry(int iSiteID, const CTDVString& sName, const CTDVString& sSubstitution)

		Author:		David Williams
        Created:	30/11/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailVocab::AddNewEntry(int iSiteID, const CTDVString& sName, const CTDVString& sSubstitution)
{
	bool bRetVal = m_SP.AddNewEmailVocabEntry(iSiteID, sName, sSubstitution);
	if (bRetVal)
	{
		bRetVal = AddEntryToSitesDictionary(iSiteID, sName, sSubstitution);
	}
	return bRetVal;
}

/*********************************************************************************

	bool CEmailVocab::GetAsString(CTDVString& sEmailVocab)

		Author:		David Williams
        Created:	11/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CEmailVocab::GetAsString(CTDVString& sEmailVocab)
{
	bool bRetVal = true;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	CDBXMLBuilder emailVocabBuilder;
	emailVocabBuilder.Initialise(&sEmailVocab, &SP);	
	SP.FetchEmailVocab();
    
	emailVocabBuilder.OpenTag("EMAIL-VOCAB-LIST", true);
	emailVocabBuilder.AddIntAttribute("SiteID", m_iSiteID, true);
	while (!SP.IsEOF())
	{
		int iSiteID = SP.GetIntField("SiteID");
		
		if (iSiteID == m_iSiteID)
		{
			emailVocabBuilder.OpenTag("SITE-VOCAB");
			emailVocabBuilder.DBAddTag("Name");
			emailVocabBuilder.DBAddTag("Substitution");
			emailVocabBuilder.CloseTag("SITE-VOCAB");
		}
		SP.MoveNext();
	}
	emailVocabBuilder.CloseTag("EMAIL-VOCAB-LIST");
	return bRetVal;
}


bool CEmailVocab::RemoveEntry(const int iSiteID, const CTDVString& sName)
{
	bool sResult = true;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	sResult = SP.RemoveEmailVocabEntry(iSiteID, sName);


	return sResult;
}