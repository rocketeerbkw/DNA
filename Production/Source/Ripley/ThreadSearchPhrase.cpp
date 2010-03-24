#include "stdafx.h"
#include "ThreadSearchPhrase.h"
#include "User.h"
#include ".\tdvassert.h"
#include ".\SiteOptions.h"

#include <algorithm>
#include <map>


/*********************************************************************************

	CSearchPhraseBase::CSearchPhraseBase( CInputContext& InputContext, CTDVString sToken)

		Author:		Mark Howitt
		Created:	20/06/2007
		Inputs:		-
		Outputs:	-
		Returns:	-
		Purpose:	Default constructor that initialises the token to delimit phrase lists

*********************************************************************************/
CSearchPhraseBase::CSearchPhraseBase(CInputContext& InputContext, CTDVString sToken) : CXMLObject(InputContext)
{
	// Check to make sure we've been given a valid string
	if (sToken.GetLength() > 0)
	{
		m_cToken = sToken[0];
	}
	else
	{
		m_cToken = ' ';
	}
}

/*********************************************************************************

	CSearchPhraseBase::GetSiteKeyPhrases()

		Author:		Martin Robb
        Created:	15/06/2005
        Inputs:		- None
        Outputs:	- 
        Returns:	- false on error
        Purpose:	- Generate a list of key phrases for the site.
					  This is essentially a set of predefined key phrase searhes for a site.
					  Currently looks in the site config for the sites key phrase list 
					  NOT CURRENTLY USED - SiteKeyphrases have a DB table.
*********************************************************************************/
bool CSearchPhraseBase::GetSiteKeyPhrasesFromConfig()
{
	CTDVString sSiteConfig;
	m_InputContext.GetSiteConfig(sSiteConfig);
	InitialiseXMLBuilder(&sSiteConfig);
	if ( !CreateFromXMLText(sSiteConfig) )
	{
		SetDNALastError("CThreadSearchPhrase::GetSiteKeyPhrasesFromConfig","GetSiteKeyPhrasesFromConfig","Failed to parse regions");
		return false;
	}


	//Parse Site Config XML to get regions.
	CTDVString sPhrasesToParse;
	CXMLTree* pNode = m_pTree->FindFirstTagName("SITEKEYPHRASE");
	if ( !pNode )
	{
		SetDNALastError("CThreadSearchPhrase::GetSiteKeyPhrasesFromConfig","GetSiteKeyPhrasesFromConfig","Failed to parse site key phrases");
		return false;
	}

	CTDVString sPhraseList;
	do 
	{
		CXMLTree* pTerm = pNode->FindFirstTagName("TERM");
		if ( pTerm ) 
		{
			CTDVString sPhrase;
			pTerm->GetTextContents(sPhrase);
			UnEscapeString(&sPhrase);
			sPhraseList << ( sPhraseList.IsEmpty() ? "" : CTDVString(m_cToken)) << sPhrase;
		}
	} while ( (pNode = pNode->FindNextTagNode("SITEKEYPHRASE")) != NULL );

	m_lPhraseList.clear();
	ParsePhrases(sPhraseList);

	//Finished with site config XML.
	Destroy();

	return !m_lPhraseList.empty();
}

/*********************************************************************************

	CSearchPhraseBase::GetSiteKeyPhrases()

		Author:		Martin Robb
        Created:	12/10/2005
        Inputs:		- none
        Outputs:	- 
        Returns:	- false on error
        Purpose:	- Creates a list of site key phrases.
					  Fetches site key phrases from the database.
					  Creates a space separated string which is then parsed.
					  Would be more efficient to populate the list here - not done due to preparation issues.
					  Private method.
*********************************************************************************/
bool CSearchPhraseBase::GetSiteKeyPhrases( )
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);

	SP.GetKeyPhrasesForSite(m_InputContext.GetSiteID());

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	
	CTDVString sPhraseList;
	while ( !SP.IsEOF() )
	{
		CTDVString sPhrase;
		SP.GetField("Phrase", sPhrase);
		if ( sPhrase.Find(m_cToken) != -1 ) 
		{
			CTDVString sQuotedPhrase = sPhrase;
			sQuotedPhrase = '"';
			sQuotedPhrase += sPhrase;
			sQuotedPhrase += '"';
			sPhrase = sQuotedPhrase;
		}
		sPhraseList << (sPhraseList.IsEmpty() ? "" : CTDVString(m_cToken)) << sPhrase;
		SP.MoveNext();
	}

	ParsePhrases(sPhraseList);
	return !m_lPhraseList.empty();
}

/*********************************************************************************

	CSearchPhraseBase::GetSiteKeyPhrasesXML()

		Author:		Martin Robb
        Created:	15/06/2005
        Inputs:		- none
        Outputs:	- 
        Returns:	- false on error
        Purpose:	- Create SiteKeyPhrases XML - Created from cache if possible.

*********************************************************************************/
bool CSearchPhraseBase::GetSiteKeyPhrasesXML()
{
	CTDVString cachename;
		
	//Create a cache name including the site, keyphrases, skip and show params.
	cachename << "sitekeyphrases-" << m_InputContext.GetSiteID() <<  ".xml";

	//Try to get a cached copy.
	CTDVDateTime dExpires(60*60*24);		// expire every day
	CTDVString sXML;
	if ( CacheGetItem("keyphrase", cachename, &dExpires, &sXML) )
	{
		return CreateFromXMLText(sXML);
	}
	
	//Get Site Key Phrases from DB and produce XML
	if ( GetSiteKeyPhrases() )
	{
		CTDVString sName;
		CTDVString sNameSpace;
		InitialiseXMLBuilder(&sXML);
		OpenXMLTag("SITEKEYPHRASES");

		//Should use Generate phrase list XML but their is a small difference between enclosing tag <KEYPHRASE> and <PHRASE>
		for (SEARCHPHRASELIST::const_iterator iter = m_lPhraseList.begin(); iter != m_lPhraseList.end(); iter++)
		{
			OpenXMLTag("KEYPHRASE");
			sNameSpace = iter->m_NameSpace;
			sName = iter->m_Phrase;

			EscapeAllXML(&sNameSpace);
			AddXMLTag("NAMESPACE", sNameSpace);

			CTDVString sURLPhrase = sName;
			if ( sName.Find(m_cToken) != -1 ) 
			{
				sURLPhrase = '"';
				sURLPhrase += sName;
				sURLPhrase += '"';
			}

			EscapeAllXML(&sName);
			AddXMLTag("NAME",sName);

			EscapePhraseForURL(&sURLPhrase);
			AddXMLTag("TERM",sURLPhrase);

			CloseXMLTag("KEYPHRASE");
		} 
		CloseXMLTag("SITEKEYPHRASES");	
	}

	CachePutItem("keyphrase",cachename,sXML);

	return CreateFromXMLText(sXML);
}

/*********************************************************************************

	CSearchPhrase::GeneratePhraseListXML()

		Author:		Martin Robb
        Created:	15/06/2005
        Inputs:		- list of phrases, phrases as a comma separated string
        Outputs:	- 
        Returns:	- XML of provided phrase list.
        Purpose:	- Generates XML for the given phrase list.

*********************************************************************************/
CTDVString CSearchPhraseBase::GeneratePhraseListXML()
{
	CDBXMLBuilder XMLBuilder;
	CTDVString sXML;
	XMLBuilder.Initialise(&sXML);
	GeneratePhraseListXML(XMLBuilder);
	return sXML;
}

/*********************************************************************************

	CSearchPhrase::GeneratePhraseListXML()

		Author:		Martin Robb
        Created:	15/06/2005
        Inputs:		- Builder - used to create XML.
        Outputs:	- populated builder
        Returns:	- none
        Purpose:	- Generates XML for the given phrase list.

*********************************************************************************/
void CSearchPhraseBase::GeneratePhraseListXML(CDBXMLBuilder& XMLBuilder)
{
	XMLBuilder.OpenTag("PHRASES",true);
	XMLBuilder.AddAttribute("COUNT",CTDVString(static_cast<int>(m_lPhraseList.size())));
	XMLBuilder.AddAttribute("DELIMITER",CTDVString(m_cToken),true);

	CTDVString sPhrase;
	CTDVString sNamespace;
	for (SEARCHPHRASELIST::const_iterator i = m_lPhraseList.begin(); i != m_lPhraseList.end(); i++)
	{
		XMLBuilder.OpenTag("PHRASE");
		sNamespace = i->m_NameSpace;
		sPhrase = i->m_Phrase;

		EscapeAllXML(&sNamespace);
		XMLBuilder.AddTag("NAMESPACE", sNamespace);
		
		//If phrase contains token then quote.
		CTDVString sURLPhrase = sPhrase;
		if ( sPhrase.Find(' ') != -1 ) 
		{
			sURLPhrase = '"';
			sURLPhrase += sPhrase;
			sURLPhrase += '"';
		}

		EscapeAllXML(&sPhrase);
		XMLBuilder.AddTag("NAME", sPhrase);

		EscapePhraseForURL(&sURLPhrase);
		XMLBuilder.AddTag("TERM", sURLPhrase);

		if ( i->m_PhraseNameSpaceId > 0 )
		{
			XMLBuilder.AddIntTag("PHRASENAMESPACEID", i->m_PhraseNameSpaceId );
		}

		XMLBuilder.CloseTag("PHRASE");
	}

	XMLBuilder.CloseTag("PHRASES");
}

/*********************************************************************************

	CThreadSearchPhrase::ParsePhrases()

		Author:		Martin Robb
        Created:	15/06/2005
        Inputs:		- token that delimits phrase elements
					- bKeepExisting - if set existing parsed phrases are not cleared.
        Outputs:	- 
        Returns:	-
        Purpose:	- reads in token delimited string and creates a list of phrase elements.
					- A phrase element can be in quotes indicating that it should not be split.
					- populates an internal vector out of the parsed phrases.
*********************************************************************************/
bool CSearchPhraseBase::ParsePhrases( const CTDVString& sPhrases, bool bKeepExisting, const CTDVString& sNameSpaces)
{
	if ( !bKeepExisting )
	{
		m_lPhraseList.clear();
	}
	CTDVString ssource = sPhrases;

	//Integrity checking - strip off double tokens - not allowing these.
	CTDVString stmp = m_cToken;
	stmp += m_cToken;
	while ( ssource.Find(stmp) > 0 )
		ssource.Replace(stmp,CTDVString(m_cToken));

	//Truncate tokens off the end.
	while ( ssource.GetLength() > 1 && ssource.Right(1) == CTDVString(m_cToken) )
	{
		CTDVString ssrc = ssource.Mid(0,ssource.GetLength() -1 );
		ssource = ssrc;
	}

	//To link to a blank phrase it should be explicit - eg use ""
	if ( ssource.IsEmpty() )
		return true;

	//Genearate the list of new namespaces to pair up with the list of keyphrases
	//The position of the  namespace will match the position of the corresponding keyphrase
	vector<CTDVString> NameSpacesList;
	if (sNameSpaces != "")
	{
		NameSpacesList = ParseNamespaces(sNameSpaces);
	}

	//Parse the string now that it is in 'parsable' condition.
	CTDVString element;
	bool bquotes = false;
	int phrasestart = -1;
	int phraselen = 0;
	int phrasecount = 0;
	for ( int charcount = 0; charcount <= ssource.GetLength(); charcount++ )
	{	
		if ( charcount == ssource.GetLength() || (ssource.GetAt(charcount) == m_cToken && !bquotes) ) 
		{
			if ( phraselen > 0 )
				element = ssource.Mid(phrasestart, phraselen);
			UnEscapeString(&element);

			//if the keyphrase contain commas it adds blank tags into the keyphrase list
			//and eventually into the database so we'll remove them
			element.Replace(",", "");

			//RTrim whitespace.
			while ( element.GetLength()  && element.Right(1) == " ")
				element.RemoveTrailingChar(' ');

			//LTrim whitespace
			while ( element.GetLength() && element.Left(1) == " ")
				element.RemoveLeftChars(1);

			//Don't do anything with blank keyphrases
			if (!element.IsEmpty())
			{
				//try to find if we have already added this namespace key phrase pair
				//i.e. stop duplicates

				//try and get the corresponding NameSpace (which will be at the same position in the namespace list
				//there may not be one if so assume a NULL/Empty namespace
				CTDVString CorrespondingNameSpace;

				if (sNameSpaces == "")
				{
					CorrespondingNameSpace = "";
				}
				else
				{
					try
					{
						CorrespondingNameSpace = NameSpacesList.at(phrasecount);
					}
					catch(...)
					{
						CorrespondingNameSpace = "";
					}

				}

				SEARCHPHRASELIST::iterator iter;
				bool bExistsAlready = false;

				for (iter = m_lPhraseList.begin();iter != m_lPhraseList.end(); iter++)
				{
					CTDVString sNameSpace = iter->m_NameSpace;

					CTDVString sPhrase = iter->m_Phrase;
					if (sNameSpace == CorrespondingNameSpace && sPhrase == element)
					{
						bExistsAlready = true;
						break;
					}
				}

				//result = std::find(m_lPhraseList.begin(), m_lPhraseList.end(), element);
				//Only if it isn't already in the list of namespace/phrases to add do we add it
				if  (!bExistsAlready)
				{
					PHRASE phrase(CorrespondingNameSpace, element);

					m_lPhraseList.push_back(phrase);
				}
			}

			element = "";
			phrasestart = -1;
			phraselen = 0;
			phrasecount++;
		}
		else if ( ssource.GetAt(charcount) == '"' )
		{
			//Skip quote characters.
			bquotes = !bquotes;
			//phraselen--;
		}
		else
		{
			if ( phrasestart == -1 )
				phrasestart = charcount;
			phraselen++;
		}
	}
	return true;
}
/*********************************************************************************

	CThreadSearchPhrase::ParseNamspaces()

		Author:		Steven Francis
        Created:	16/05/2007
        Inputs:		- token that delimits phrase elements
        Outputs:	- 
        Returns:	- vector<CTDVString> of namespaces
        Purpose:	- reads in token delimited string and creates a list of namespace elements.
					- A namespace element can be in quotes indicating that it should not be split.
*********************************************************************************/
vector<CTDVString> CSearchPhraseBase::ParseNamespaces( const CTDVString& sNameSpaces )
{
	vector<CTDVString> NameSpacesList;

	CTDVString ssource = sNameSpaces;

	//Integrity checking - strip off double tokens - not allowing these.
	CTDVString stmp = m_cToken;
	stmp += m_cToken;
	while ( ssource.Find(stmp) > 0 )
		ssource.Replace(stmp,CTDVString(m_cToken));

	//Truncate tokens off the end.
	while ( ssource.GetLength() > 1 && ssource.Right(1) == CTDVString(m_cToken) )
	{
		CTDVString ssrc = ssource.Mid(0,ssource.GetLength() -1 );
		ssource = ssrc;
	}

	//Parse the string now that it is in 'parsable' condition.
	CTDVString element;
	bool bquotes = false;
	int namespacestart = -1;
	int namespacelen = 0;
	int namespacecount = 0;
	for ( int charcount = 0; charcount <= ssource.GetLength(); charcount++ )
	{	
		if ( charcount == ssource.GetLength() || (ssource.GetAt(charcount) == m_cToken && !bquotes) ) 
		{
			if ( namespacelen > 0 )
			{
				element = ssource.Mid(namespacestart, namespacelen);
			}
			UnEscapeString(&element);

			//if the namespace contain commas it adds blank a namespace into the namespace list
			//and eventually into the database so we'll remove them
			element.Replace(",", "");

			//RTrim whitespace.
			while ( element.GetLength()  && element.Right(1) == " ")
				element.RemoveTrailingChar(' ');

			//LTrim whitespace
			while ( element.GetLength() && element.Left(1) == " ")
				element.RemoveLeftChars(1);


			NameSpacesList.push_back(element);

			element = "";
			namespacestart = -1;
			namespacelen = 0;
			namespacecount++;
		}
		else if ( ssource.GetAt(charcount) == '"' )
		{
			//Skip quote characters.
			bquotes = !bquotes;
			//phraselen--;
		}
		else
		{
			if ( namespacestart == -1 )
			{
				namespacestart = charcount;
			}
			namespacelen++;
		}
	}
	return NameSpacesList;
}

/*********************************************************************************

	void CSearchPhraseBase::UnEscapeString(CTDVString *pString)

	Author:		Jim Lynn - original /Martin Robb
	Created:	20/07/2005
	Inputs:		pString - ptr to TDVString to unescape
	Outputs:	pString - string has been converted
	Returns:	-
	Purpose:	Source CGI class - should be part of a separate text manipulation library/namespace/class
				( Or moved to the base class. ) 
				UnEscapes a URL parameter. Replaces + with spaces and %XX with
				the ascii equivalent. Used to clean up parameters passed in the
				query string.
				THIS IS A COPY OF CGI::UnEscapeString().

*********************************************************************************/

void CSearchPhraseBase::UnEscapeString(CTDVString *pString)
{
	int pos = 0;
	int newpos = 0;
	long OriginalLength = pString->GetLength();
	TDVCHAR* pNewString = new TDVCHAR[OriginalLength+8];
	while (pos < OriginalLength)
	{
		// unescape +
		if (pString->GetAt(pos) == '+')
		{
			pNewString[newpos] = ' ';
			pos++;
			newpos++;
		}
		else if (pString->GetAt(pos) == '%')
		{
			// handle hex values
			if ((pos+2) >= pString->GetLength())
			{
				// Not enough hex digits, just skip over the %
				pNewString[newpos] = '%';
				newpos++;
				pos++;
			}
			else
			{
				char highbyte = pString->GetAt(pos+1);
				if (highbyte > '9')
				{
					if (highbyte >= 'a')
					{
						highbyte -= 'a';
						highbyte += 10;
					}
					else
					{
						highbyte -= 'A';
						highbyte += 10;
					}
				}
				else
				{
					highbyte -= '0';
				}
				char lowbyte = pString->GetAt(pos+2);
				if (lowbyte > '9')
				{
					if (lowbyte >= 'a')
					{
						lowbyte -= 'a';
						lowbyte += 10;
					}
					else
					{
						lowbyte -= 'A';
						lowbyte += 10;
					}
				}
				else
				{
					lowbyte -= '0';
				}
				char ascval = (lowbyte + 16*highbyte);
				pNewString[newpos] = ascval;
				newpos++;
				pos += 3;
				//*pString = pString->Left(pos) + CTDVString(ascval) + pString->Mid(pos+3);
				//pos++;
			}
		}
		else
		{
			pNewString[newpos] = pString->GetAt(pos);
			newpos++;
			pos++;
		}
	}
	pNewString[newpos] = 0;
	*pString = pNewString;
	delete pNewString;
}

/*********************************************************************************

	void CSearchPhraseBase::EscapeStringForURL(CTDVString *pString)

	Author:		Martin Robb
	Created:	20/07/2005
	Inputs:		String to escape
	Outputs:	pString - string has been converted
	Returns:	-
	Purpose:	Escape string for url - preserving phrase.

*********************************************************************************/
void CSearchPhraseBase::EscapePhraseForURL(CTDVString *pString)
{
	CTDVString sEscapedTerm;
	
	int iPos = 0;
	int iLen = pString->GetLength();
	while (iPos < iLen)
	{
		char ch = pString->GetAt(iPos);
		//if (ch == ' ')
		//{
		//	sEscapedTerm << "+";
		//}
		if ( strchr("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_-~ ",ch) != NULL || ch == 34 )
		{
			sEscapedTerm += ch;
		}
		else
		{
			char hextemp[20];
			sprintf(hextemp, "%%%2X", ch);
			sEscapedTerm += hextemp;
		}
		iPos++;
	}
	*pString = sEscapedTerm;
	return;
}


/*********************************************************************************

	CSearchPhraseBase::GetPhraseListAsString

		Author:		Martin Robb
        Created:	27/07/2006
        Inputs:		
        Outputs:	-
        Returns:	-
        Purpose:	- Get List of phrases as a string.

*********************************************************************************/
CTDVString CSearchPhraseBase::GetPhraseListAsString()
{
	//Create a comma delimited phrase list
	CTDVString sPhrases = "";
	for (SEARCHPHRASELIST::iterator iter = m_lPhraseList.begin();iter != m_lPhraseList.end(); iter++)
	{
		CTDVString sPhrase = iter->m_Phrase;
		if (sPhrase.Find(m_cToken) >= 0 )
		{
			//Need to quote the phrase.
			sPhrase = "\"";
			sPhrase << iter->m_Phrase << "\"";
		}

		sPhrases << (sPhrases.IsEmpty() ? "" : CTDVString(m_cToken)) << sPhrase;
	}

	return sPhrases;
}

/*********************************************************************************

	CSearchPhraseBase::GetNameSpacesListAsString

		Author:		Steven Francis
        Created:	15/05/2006
        Inputs:		
        Outputs:	-
        Returns:	-
        Purpose:	- Get List of namespaces as a string.

*********************************************************************************/
CTDVString CSearchPhraseBase::GetNameSpacesListAsString()
{
	//Create a comma delimited sNameSpaces list
	CTDVString sNameSpaces = "";
	for (SEARCHPHRASELIST::iterator iter = m_lPhraseList.begin();iter != m_lPhraseList.end(); iter++)
	{
		CTDVString sNameSpace = iter->m_NameSpace;
		if ((iter->m_NameSpace).Find(m_cToken) >= 0 )
		{
			//Need to quote the NameSpace.
			sNameSpace = "\"";
			sNameSpace << iter->m_NameSpace << "\"";
		}

		sNameSpaces << (sNameSpaces.IsEmpty() ? "" : CTDVString(m_cToken)) << sNameSpace;
	}

	return sNameSpaces;
}

/*********************************************************************************

	CSearchPhrase::CSearchPhrase(CInputContext& inputContext) : CXMLObject(inputContext)

		Author:		Martin Robb
        Created:	12/05/2005
        Inputs:		inputContext = an input context
		            cToken - charatect used to seperate key phrases.
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

CThreadSearchPhrase::CThreadSearchPhrase(CInputContext& inputContext, CTDVString sToken) : CSearchPhraseBase(inputContext, sToken)
{
}

bool CThreadSearchPhrase::GetThreadsFromKeyPhrases( int iSkip, int iShow, int& iNumResults )
{
	//Clean Up previous XML.
	Destroy();

	//Create a comma delimited phrase list
	CTDVString sPhrases = "";
	for (SEARCHPHRASELIST::iterator iter = m_lPhraseList.begin();iter != m_lPhraseList.end(); iter++)
	{
		sPhrases << (sPhrases.IsEmpty() ? "" : "|") << iter->m_Phrase;
	}

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CSearchPhrase::GetThreadsWithKeyPhrases","FailedToInitialiseStoredProcedure","Failed To Initialise Stored Procedure");
	}

	// Now call the procedure
	if (!SP.GetThreadsWithKeyPhrases(sPhrases, iSkip, iShow))
	{
		return SetDNALastError("CMessagCSearchPhrase::GetThreadsWithKeyPhrases","GETTHREADSWITHKEYPHRASESFAILED","Getting threads with key phrases failed");
	}

	bool bDefaultCanRead = true;
	bool bDefaultCanWrite = true;
	bool bThreadCanRead = true;
	bool bThreadCanWrite = true;
	bool bCanRead = true; 
	bool bCanWrite = true; 
	bool bEditor = false;
	
	int iTotalThreads = 0;
	int iModerationStatus = 0;
	int iForumPostCount = 0;
	int iAlertInstantly = 0;
	//int iJournalOwner = 0;
	int iNumThreads = iShow;
	int iForumID = 0;

	bool bOverflow = true;

	if (!SP.IsEOF())
	{
		//iJournalOwner = SP.GetIntField("JournalOwner");
		bDefaultCanRead = SP.GetBoolField("CanRead");
		bCanRead = bDefaultCanRead; 
		bDefaultCanWrite = SP.GetBoolField("CanWrite");
		bCanWrite = bDefaultCanWrite; 
		bThreadCanRead = SP.GetBoolField("ThreadCanRead");
		bThreadCanWrite = SP.GetBoolField("ThreadCanWrite");
		iModerationStatus = SP.GetIntField("ModerationStatus");
		iForumPostCount = SP.GetIntField("ForumPostCount");
		iAlertInstantly = SP.GetIntField("AlertInstantly");
		iForumID = SP.GetIntField("Forumid");
	}

	CTDVString sThreads;
	InitialiseXMLBuilder(&sThreads,&SP);

	sThreads << "<THREADSEARCH SKIPTO='" << iSkip << "' COUNT='" << iShow << "'";
	//if (iJournalOwner > 0)
	//{
	//	sThreads << " JOURNALOWNER='" << iJournalOwner << "'";
	//}
	
	if (!SP.IsEOF())
	{
		iNumResults = iTotalThreads = SP.GetIntField("ThreadCount");
		sThreads << " TOTALTHREADS='" << iTotalThreads << "'";
	}
	
	sThreads << " FORUMPOSTCOUNT='" << iForumPostCount << "' ";
	sThreads << " FORUMPOSTLIMIT='" << m_InputContext.GetCurrentSiteOptionInt("Forum", "PostLimit") << "' ";
	sThreads << " SITEID='" << m_InputContext.GetSiteID() << "'";

	// check user specific permissions and if site's topics are closed.
	CUser * pViewer = m_InputContext.GetCurrentUser();

	sThreads << " DEFAULTCANREAD=";
	if (bDefaultCanRead)
	{
		sThreads << "'1'";
	}
	else
	{
		sThreads << "'0'";
	}

	sThreads << " DEFAULTCANWRITE=";
	if (bDefaultCanWrite)
	{
		sThreads << "'1'";
	}
	else
	{
		sThreads << "'0'";
	}

	// get user specific permissions 
	if (pViewer != NULL && pViewer->GetUserID() != 0)
	{
		// Editors can read/write anything/anywhere
		if (pViewer->GetIsEditor() || pViewer->GetIsSuperuser())
		{
			bCanRead = true;
			bCanWrite = true;
			bEditor = true;
		}
		else
		{
			CStoredProcedure SP;
			if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
			{
				return false;
			}
			SP.GetForumPermissions(pViewer->GetUserID(), iForumID, bCanRead, bCanWrite);
		}
	}

	if (!bEditor)
	{
		// override user specific permissions if the site is closed.
		int iSiteID = m_InputContext.GetSiteID();
		bool bSiteClosed = false;
		if (!m_InputContext.IsSiteClosed(iSiteID,bSiteClosed))
		{
			SetDNALastError("ThreadSearchPhrase","IsSiteclosed","Failed to get SiteClosed state");
			return false;
		}

		if( bSiteClosed )
		{
			bCanWrite = false; 
		}
	}

	sThreads << " CANREAD=";
	if (bCanRead)
	{
		sThreads << "'1'";
	}
	else
	{
		sThreads << "'0'";
	}

	sThreads << " CANWRITE=";
	if (bCanWrite)
	{
		sThreads << "'1'";
	}
	else
	{
		sThreads << "'0'";
	}

	if (bThreadCanRead)
	{
		sThreads << " THREADCANREAD='1'";
	}
	else
	{
		sThreads << " THREADCANREAD='0'";
	}
	if (bThreadCanWrite)
	{
		sThreads << " THREADCANWRITE='1'";
	}
	else
	{
		sThreads << " THREADCANWRITE='0'";
	}
	
	if (iTotalThreads > ( iSkip + iShow )) 
	{
		sThreads << " MORE='1'";
	}
	
	// Add the alert instantly flag
	sThreads << " ALERTINSTANTLY='" << iAlertInstantly << "'";

	sThreads << ">";

	//sThreads << "<MODERATIONSTATUS ID='" << iForumID << "'>";
	//sThreads<< iModerationStatus << "</MODERATIONSTATUS>";

	int iIndex = 0;
	bool bFirstItem = true;
	
	CTDVString sORDER;
	//GetThreadOrderDesc(iThreadOrder, sORDER);
	//sThreads << "<ORDERBY>" << sORDER << "</ORDERBY>";
	int iCurrent = 0;
	while (!SP.IsEOF() && iTotalThreads > 0 && iNumThreads > 0)
	{
		int ThreadID = SP.GetIntField("ThreadID");
		//Create Thread XML.
		iCurrent = ThreadID;
		int iThisCanRead = SP.GetIntField("CanRead");
		int iThisCanWrite = SP.GetIntField("CanWrite");
		CTDVString sSubject = "";
		SP.GetField("FirstSubject", sSubject);
		EscapeAllXML(&sSubject);
		CTDVDateTime dDate = SP.GetDateField("LastPosted");
		CTDVString sDate = "";
		dDate.GetAsXML(sDate,true);
		
		CTDVString sDateFirstPosted;
		dDate = SP.GetDateField("FirstPosting");
		dDate.GetAsXML(sDateFirstPosted,true);
		CTDVString bodytext;
		SP.GetField("FirstPostText", bodytext);
		//CTDVString sUserName;
		//SP.GetField("FirstPostUserName", sUserName);
		//MakeSubjectSafe(&sUserName);
		int iUserID = SP.GetIntField("FirstPostUserID");
		int iPostID = SP.GetIntField("FirstPostEntryID");
		int iCountPosts = SP.GetIntField("threadpostcount");
		int iLastUserID = SP.GetIntField("LastPostUserID");
		//int iNotable	= SP.GetIntField("FirstPostNotableUser");
		//int iLastNotable= SP.GetIntField("LastPostNotableUser");
		//CTDVString sLastUserName;
		//SP.GetField("LastPostUserName", sLastUserName);
		CTDVString sLastText;
		SP.GetField("LastPostText", sLastText);
		//MakeSubjectSafe(&sLastUserName);

		int iFirstPostHidden = SP.GetIntField("FirstPostHidden");
		int iLastPostHidden = SP.GetIntField("LastPostHidden");

		if (SP.GetIntField("FirstPostStyle") != 1) 
		{
			DoPlainTextTranslations(&bodytext);
		}
		else
		{
			CTDVString sTemp;
			sTemp << "<RICHPOST>" << bodytext << "</RICHPOST>";
			bodytext = sTemp;
		}
		if (SP.GetIntField("LastPostStyle") != 1) 
		{
			DoPlainTextTranslations(&sLastText);
		}
		else
		{
			CTDVString sTemp;
			sTemp << "<RICHPOST>" << sLastText << "</RICHPOST>";
			sLastText = sTemp;
		}
		int iFinalPostID = SP.GetIntField("LastPostEntryID");

		sThreads << "<THREAD FORUMID='" << SP.GetIntField("ForumID") << "' THREADID='" << ThreadID << "' INDEX='" << iIndex << "'";
	
		// Add the CanRead and CanWrite For the Thread
		sThreads << " CANREAD='" << iThisCanRead << "' CANWRITE='" ;
		if (bEditor) 
		{
			// editor can always write to threads
			sThreads << "1";
		} 
		else 
		{
			sThreads << iThisCanWrite;
		}
		sThreads << "'>";

		sThreads << "<THREADID>" << ThreadID << "</THREADID>";
		sThreads << "<SUBJECT>" << sSubject;
		if (iThisCanRead == 0)
		{
			sThreads << " - Hidden";
		}
		sThreads << "</SUBJECT>";
		sThreads << "<DATEPOSTED>" << sDate << "</DATEPOSTED>";
		AddDBXMLDateTag("LASTPOSTED");
		sThreads << "<TOTALPOSTS>" << iCountPosts << "</TOTALPOSTS>";

		// Put the thread type and eventdate into the xml if it exists!
		if (SP.FieldExists("type"))
		{
			CTDVString sType;
			SP.GetField("Type",sType);
			sThreads << "<TYPE>" << sType << "</TYPE>";
		}

		// Put the thread type and eventdate into the xml if it exists!
		//if (SP.FieldExists("eventdate") && !SP.IsNULL("eventdate"))
		//{
		//	CTDVDateTime dEventDate = SP.GetDateField("EventDate");
		//	CTDVString sEventDate;
		//	dEventDate.GetAsXML(sEventDate,true);
		//	sThreads << "<EVENTDATE>" << sEventDate << "</EVENTDATE>";
		//}

		// Insert the details of the first person who posted
		sThreads << "<FIRSTPOST POSTID='" << iPostID << "' HIDDEN='" << SP.GetIntField("FirstPostHidden") << "'>"
			<< sDateFirstPosted
			<< "<USER><USERID>" << iUserID << "</USERID>"; //<USERNAME>" << sUserName << "</USERNAME>";

		// Get the title of the first person to post
		//CTDVString sFirstPostTitle;
		//SP.GetField("FirstPostTitle", sFirstPostTitle);
		//EscapeXMLText(&sFirstPostTitle);
		//if (!SP.IsNULL("FirstPostTitle"))
		//{
		//	sThreads << "<TITLE>" << sFirstPostTitle << "</TITLE>\n";
		//}
		
		// Get the area of the first person to post
		//CTDVString sFirstPostArea;
		//SP.GetField("FirstPostArea", sFirstPostArea);
		//EscapeXMLText(&sFirstPostArea);
		//if (!SP.IsNULL("FirstPostArea"))
		//{
		//	sThreads << "<AREA>" << sFirstPostArea << "</AREA>\n";
		//}
		
		//bool bOk = AddDBXMLTag("FirstPostFirstNames","FIRSTNAMES",false);
		//bOk = bOk && AddDBXMLTag("FirstPostLastName","LASTNAME",false);
		//bOk = bOk && AddDBXMLTag("FirstPostSiteSuffix","SITESUFFIX",false);
		//bOk = bOk && AddDBXMLTag("FirstPostStatus","STATUS",false);
		//bOk = bOk && AddDBXMLTag("FirstPostTaxonomyNode","TAXONOMYNODE",false);
		//bOk = bOk && AddDBXMLTag("FirstPostJournal","JOURNAL",false);
		//bOk = bOk && AddDBXMLTag("FirstPostActive","ACTIVE",false);

		//if(iNotable > 0)
		//{
		//	sThreads << "<NOTABLE>" << iNotable << "</NOTABLE>";
		//}

		// Add Groups
		//CTDVString sGroupsXML;
		//if(!m_InputContext.GetUserGroups(sGroupsXML, iUserID))
		//{
	//		TDVASSERT(false, "Failed to get user groups");
	//	}
	//	else
	//	{
	//		sThreads << sGroupsXML;
	//	}

		sThreads << "</USER>";
		
		if (iFirstPostHidden != 0) 
		{
			sThreads << "<TEXT>Hidden</TEXT>";
		}
		else
		{
			sThreads << "<TEXT>" << bodytext << "</TEXT>\n";
		}
		sThreads << "</FIRSTPOST>\n";
		
		// Now get the details of the last person to post
		sThreads << "<LASTPOST POSTID='" << iFinalPostID << "' HIDDEN='" << SP.GetIntField("LastPostHidden") << "'>"
			<< sDate
			<< "<USER><USERID>" << iLastUserID << "</USERID>\n";
		
		
		// Get the title of the last person to post
		//CTDVString sLastPostTitle;
		//SP.GetField("LastPostTitle", sLastPostTitle);
		//EscapeXMLText(&sLastPostTitle);
		//if (!SP.IsNULL("LastPostTitle"))
		//{
		//	sThreads << "<TITLE>" << sLastPostTitle << "</TITLE>\n";
		//}
		
		// Get the area of the last person to post
		//CTDVString sLastPostArea;
		//SP.GetField("LastPostArea", sLastPostArea);
		//EscapeXMLText(&sLastPostArea);
		//if (!SP.IsNULL("LastPostArea"))
		//{
		//	sThreads << "<AREA>" << sLastPostArea << "</AREA>\n";
		//}
		
		//bOk = bOk && AddDBXMLTag("LastPostFirstNames","FIRSTNAMES",false);
		//bOk = bOk && AddDBXMLTag("LastPostLastName","LASTNAME",false);
		//bOk = bOk && AddDBXMLTag("LastPostSiteSuffix","SITESUFFIX",false);
		//bOk = bOk && AddDBXMLTag("LastPostStatus","STATUS",false);
		//bOk = bOk && AddDBXMLTag("LastPostTaxonomyNode","TAXONOMYNODE",false);
		//bOk = bOk && AddDBXMLTag("LastPostJournal","JOURNAL",false);
		//bOk = bOk && AddDBXMLTag("LastPostActive","ACTIVE",false);
					
		//TDVASSERT(bOk,"Problems getting first, last name and site suffix for posts!");
		//if(iLastNotable > 0)
		//{
		//	sThreads << "<NOTABLE>" << iLastNotable << "</NOTABLE>";
		//}

		// Add Groups
		/*CTDVString sLastUserGroupsXML;
		if(!m_InputContext.GetUserGroups(sLastUserGroupsXML, iLastUserID))
		{
			TDVASSERT(false, "Failed to get user groups");
		}
		else
		{
			sThreads << sLastUserGroupsXML;
		}*/

		sThreads << "</USER>\n";
		
		
		if (iFirstPostHidden != 0) 
		{
			sThreads << "<TEXT>Hidden</TEXT>";
		}
		else
		{
			sThreads << "<TEXT>" << sLastText << "</TEXT>\n";
		}
		sThreads << "</LASTPOST>\n";
		
		//Create XML for the phrases associated with each thread.
		CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
		CThreadSearchPhrase tsp(m_InputContext,delimit);
		SEARCHPHRASELIST phraselist;
		do 
		{
			if ( !SP.IsNULL("Phrase") )
			{
				CTDVString sPhrase;
				CTDVString sNamespace = "";

				SP.GetField("Phrase", sPhrase);
				if(SP.FieldExists("Namespace") && !SP.IsNULL("Namespace"))
				{
					SP.GetField("Namespace", sNamespace);
				}
				
				PHRASE phrase(sNamespace, sPhrase);
				phraselist.push_back(phrase);
			}
		} while (SP.MoveNext() && !SP.IsEOF() && (ThreadID == SP.GetIntField("ThreadId")) ) ;
		tsp.SetPhraseList(phraselist);
		sThreads << tsp.GeneratePhraseListXML();

		sThreads << "</THREAD>\n";
		bFirstItem = false;
		iNumThreads--;
		iIndex++;
	}
	sThreads << "</THREADSEARCH>";
	bool bSuccess = CreateFromXMLText(sThreads);
	
	return bSuccess;

}

/*********************************************************************************

	CSearchPhrase::GetKeyPhrasesFromThread()

		Author:		Martin Robb
        Created:	18/06/2005
        Inputs:		- threadId
        Outputs:	- 
        Returns:	- false on error
        Purpose:	- Finds the key phrases associated with given discussion/threadId
*********************************************************************************/
bool CThreadSearchPhrase::GetKeyPhrasesFromThread( int iForumID, int iThreadID )
{
	Destroy();

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	if ( !SP.GetKeyPhrasesFromThread(iThreadID) )
	{
		SetDNALastError("CThreadSearchPhrase::GetKeyPhrasesFromThread","GetKeyPhrasesFromThread","Failed to get key phrases");	
		return false;
	}

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	OpenXMLTag("THREADPHRASELIST",true);
	AddXMLIntAttribute("FORUMID", iForumID);
	AddXMLIntAttribute("THREADID", iThreadID,true);
	
	if ( !SP.IsEOF() )
	{
		SEARCHPHRASELIST lPhraseList;
		//AddDBXMLIntAttribute("ThreadId",false,false);
		//AddDBXMLIntAttribute("ForumId","ForumId",false,true);

		CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
		CThreadSearchPhrase tsp(m_InputContext,delimit);
		while ( !SP.IsEOF() )
		{
			CTDVString sPhrase;
			CTDVString sNamespace = "";

			SP.GetField("Phrase", sPhrase);
			if(SP.FieldExists("Namespace") && !SP.IsNULL("Namespace"))
			{
				SP.GetField("Namespace", sNamespace);
			}
			
			PHRASE phrase(sNamespace, sPhrase);
			lPhraseList.push_back(phrase);
			SP.MoveNext();
		}
		tsp.SetPhraseList(lPhraseList);
		sXML << tsp.GeneratePhraseListXML();
	}

	CloseXMLTag("THREADPHRASELIST");
	return CreateFromXMLText(sXML);
}

/*********************************************************************************

	CSearchPhrase::AddKeyhrases()

		Author:		Martin Robb
        Created:	15/06/2005
        Inputs:		- threadId, sPhrases to add
        Outputs:	- 
        Returns:	- false on error.
        Purpose:	- Adds/Associates the given space separated list of phrases to the discussion.
					- Currently there is a restriction for normal users - tey can only add sitekeyphrases.
					- Function will add whatever phrases it can returning an error if one or more failed.

*********************************************************************************/
bool CThreadSearchPhrase::AddKeyPhrases( int iThreadID )
{
	Destroy();
	//m_lPhraseList.clear();
	//ParsePhrases(sPhrases, m_cToken);
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);

	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CThreadSearchPhrase tspsite(m_InputContext,delimit);
	tspsite.GetSiteKeyPhrases();
	SEARCHPHRASELIST sitephrases = tspsite.GetPhraseList();

	CUser * pViewer = m_InputContext.GetCurrentUser();
	if ( !pViewer )
	{
		SetDNALastError("CSearchPhrase::AddKeyPhrases","AddKeyPhrases","Failed to add phrase(s) - User not signed in.");
		return false;
	}

	CTDVString sPhraseList;
	CTDVString sFailedPhrases;
	
	//Examine phrases -  only an editor / superuser can add a non site key phrase
	if ( !( pViewer->GetIsSuperuser() || pViewer->GetIsEditor()) )
	{
		for (SEARCHPHRASELIST::iterator iter = m_lPhraseList.begin(); iter != m_lPhraseList.end(); iter++)
		{
			bool bMatched = false;
			for (SEARCHPHRASELIST::iterator search_iter = sitephrases.begin(); search_iter != sitephrases.end(); search_iter++)
			{
				if (search_iter->m_Phrase == iter->m_Phrase)
				{
					sPhraseList << (sPhraseList.IsEmpty() ? "" : "|") << iter->m_Phrase;
					bMatched = true;
					break;
				}
			}
			if(!bMatched)
			{
				//Phrase is not a site key phase.
				sFailedPhrases << delimit << iter->m_Phrase;
			}
		}
	}
	else
	{
		//Create a comma delimited phrase list
		SEARCHPHRASELIST::iterator iter;
		for (iter = m_lPhraseList.begin(); iter != m_lPhraseList.end(); iter++)
		{
			sPhraseList << (sPhraseList.IsEmpty() ? "" : "|") << iter->m_Phrase;
		}
	}

	if ( ! SP.AddKeyPhrasesToThread( iThreadID, sPhraseList ) )
	{
		SetDNALastError("CSearchPhrase::AddKeyPhrases","AddKeyPhrases","Failed to add phrase(s)");
		return false;
	}

	//Produce XML for add action -  ( not used. )
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML);
	OpenXMLTag("Action",true);
	AddXMLAttribute("Name","add",true);
	
	//Create a delimited string of the phrases added.
	CTDVString sAddPhrases;
	SEARCHPHRASELIST::iterator iter;
	for (iter = m_lPhraseList.begin(); iter != m_lPhraseList.end(); iter++)
	{
		sPhraseList << (sAddPhrases.IsEmpty() ? "" : CTDVString(m_cToken)) << iter->m_Phrase;
	}
	AddXMLAttribute("AddPhrase",sAddPhrases);
	CloseXMLTag("Action");
	
	CreateFromXMLText(sXML);

	if ( !sFailedPhrases.IsEmpty() )
	{
		//Report phrases that failed validation.
		SetDNALastError("CSearchPhrase::AddKeyPhrases","AddKeyPhrases",CTDVString("Failed to add phrase(s) - Insufficent Permissions ") << sFailedPhrases);
		return false;
	}

	return true;
}

/*********************************************************************************

	CSearchPhrase::BuildValidKeyPhraseList()

		Author:		Martin Robb
        Created:	15/06/2005
        Inputs:		- threadId, sPhrases to add
        Outputs:	- 
        Returns:	- false on error.
        Purpose:	- Adds/Associates the given space separated list of phrases to the discussion.
					- Currently there is a restriction for normal users - tey can only add sitekeyphrases.
					- Function will add whatever phrases it can returning an error if one or more failed.

*********************************************************************************/
bool CThreadSearchPhrase::BuildValidKeyPhraseList( const CTDVString& sPhrases, CTDVString& sPhraseList )
{
	Destroy();
	m_lPhraseList.clear();
	ParsePhrases(sPhrases);

	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CThreadSearchPhrase tspsite(m_InputContext,delimit);
	tspsite.GetSiteKeyPhrases();
	SEARCHPHRASELIST sitephrases = tspsite.GetPhraseList();

	CUser * pViewer = m_InputContext.GetCurrentUser();
	if ( !pViewer )
	{
		SetDNALastError("CSearchPhrase::AddKeyPhrases","AddKeyPhrases","Failed to add phrase(s) - User not signed in.");
		return false;
	}

	CTDVString sFailedPhrases;
	
	//Examine phrases -  only an editor / superuser can add a non site key phrase
	if ( !( pViewer->GetIsSuperuser() || pViewer->GetIsEditor()) )
	{
		for (SEARCHPHRASELIST::iterator iter = m_lPhraseList.begin(); iter != m_lPhraseList.end(); iter++)
		{
			bool bMatched = false;
			for (SEARCHPHRASELIST::iterator search_iter = sitephrases.begin(); search_iter != sitephrases.end(); search_iter++)
			{
				if ( search_iter->m_Phrase == iter->m_Phrase )
				{
					sPhraseList << (sPhraseList.IsEmpty() ? "" : "|") << iter->m_Phrase;
					bMatched = true;
					break;
				}
			}
			if(!bMatched)
			{
				//Phrase is not a site key phase.
				sFailedPhrases << delimit << iter->m_Phrase;
			}
		}
	}
	else
	{
		//Create a comma delimited phrase list
		SEARCHPHRASELIST::iterator iter;
		for (iter = m_lPhraseList.begin(); iter != m_lPhraseList.end(); iter++)
		{
			sPhraseList << (sPhraseList.IsEmpty() ? "" : "|") << iter->m_Phrase;
		}
	}

//	if ( !sFailedPhrases.IsEmpty() )
//	{
//		//Report phrases that failed validation.
//		SetDNALastError("CSearchPhrase::AddKeyPhrases","AddKeyPhrases",CTDVString("Failed to add phrase(s) - Insufficent Permissions ") << sFailedPhrases);
//		return false;
//	}

	return true;
}
/*********************************************************************************

	CSearchPhrase::GetKeyPhraseHotList()

		Author:		Martin Robb
        Created:	15/06/2005
        Inputs:		- skip, show and sort params
        Outputs:	- 
        Returns:	- false on error
        Purpose:	- Fetch a list of common key phrases 
					  Sort by phrase rating ( default ) or alphabetically by phrase.

*********************************************************************************/
bool CThreadSearchPhrase::GetKeyPhraseHotList( int iSkip, int iShow, CTDVString sSortBy, bool bCache )
{
	Destroy();

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);

	//Create a comma delimited phrase list
	CTDVString sPhraseList;
	SEARCHPHRASELIST::iterator iter;
	for (iter = m_lPhraseList.begin(); iter != m_lPhraseList.end(); iter++)
	{
		sPhraseList << (iter == m_lPhraseList.begin() ? "" : "|") << iter->m_Phrase;
	}

	CTDVString cachename;
	if ( bCache ) 
	{
		//Create a cache name including the site, keyphrases, skip and show params.
		cachename << "hotkeyphrases-" << m_InputContext.GetSiteID() << (sPhraseList.IsEmpty() ? "" : "-") 
			<< sPhraseList << "-" << iSkip << "-" << iShow << (sSortBy.IsEmpty() ? "" : "-") << sSortBy << ".xml";

		//Try to get a cached copy.
		CTDVDateTime dExpires(60*10);		// expire after 10 minutes
		if ( CacheGetItem("keyphrase", cachename, &dExpires, &sXML) )
			return CreateFromXMLText(sXML);
	}

	
	SP.GetKeyPhraseHotList( m_InputContext.GetSiteID(), sPhraseList, iSkip, iShow, sSortBy );
	if ( !SP.IsEOF() )
	{
		//Might get integarated into top-fives
		OpenXMLTag("HOT-PHRASES",true);
		AddXMLIntAttribute("SKIP",iSkip);
		AddXMLIntAttribute("SHOW",iShow);
		AddDBXMLIntAttribute("COUNT","Count",false,false);
		AddXMLIntAttribute("MORE",SP.GetIntField("COUNT") > iSkip+iShow,true);
		while ( !SP.IsEOF() )
		{
			CTDVString sPhrase;
			OpenXMLTag("HOT-PHRASE");
			SP.GetField("phrase",sPhrase);

			//If phrase contains token then quote.
			CTDVString sURLPhrase = sPhrase;
			if ( sPhrase.Find(' ') != -1 ) 
			{
				sURLPhrase = '"';
				sURLPhrase += sPhrase;
				sURLPhrase += '"';
			}

			EscapeAllXML(&sPhrase);
			AddXMLTag("NAME",sPhrase);

			EscapePhraseForURL(&sURLPhrase);
			AddXMLTag("TERM",sURLPhrase);

			AddDBXMLDoubleTag("Rank");
			CloseXMLTag("HOT-PHRASE");
			SP.MoveNext();
		}
		CloseXMLTag("HOT-PHRASES");
		CreateFromXMLText(sXML);

		if ( bCache && !cachename.IsEmpty() ) 
		{
			CachePutItem("keyphrase", cachename, sXML);
		}
	}

	return true;
}

/*********************************************************************************

	CSearchPhrase::GetScoresForKeyPhrasesWithPhrase()

		Author:		Martin Robb
        Created:	15/06/2005
        Inputs:		- None
        Outputs:	- 
        Returns:	- false on error
        Purpose:	- Score the current m_lPhraseList with sKeyPhrases as an additional filter
					- To score site key phrases with an optional filter use GetSiteKeyPhraseScores.

*********************************************************************************/
bool CThreadSearchPhrase::GetKeyPhraseScores( const CTDVString& sKeyPhrases )
{
	Destroy();

	CTDVString cachename;

	CTDVString sPhraseFilterList;
	SEARCHPHRASELIST::iterator iter;
	for (iter = m_lPhraseList.begin(); iter != m_lPhraseList.end(); iter++)
	{
		//Create a comma delimited phrase list
		sPhraseFilterList << (iter == m_lPhraseList.begin() ? "" : "|") << iter->m_Phrase;
	}

	CTDVString sPhraseList;
	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CThreadSearchPhrase phrases(m_InputContext,delimit);
	phrases.ParsePhrases(sKeyPhrases);

	SEARCHPHRASELIST filters =  phrases.GetPhraseList();
	for (iter = filters.begin(); iter != filters.end(); iter++)
	{
		//Ignore a filter if it is included in phrases to be scored.
//		if ( std::find(m_lPhraseList.begin(),m_lPhraseList.end(),*iter) != m_lPhraseList.end() )
//			continue;
		bool bMatched = false;
		for (SEARCHPHRASELIST::iterator search_iter = m_lPhraseList.begin(); search_iter != m_lPhraseList.end(); search_iter++)
		{
			if ( iter->m_Phrase == search_iter->m_Phrase )
			{
				bMatched = true;
				break;
			}
		}
		if(bMatched)
		{
			continue;
		}
		//Create a comma delimited phrase list
		sPhraseList << (sPhraseList.IsEmpty() ? "" : "|") << iter->m_Phrase;
	}

	//Get the scores for the region phrases.
	CTDVString sXML;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	if ( !SP.GetKeyPhraseScore(m_InputContext.GetSiteID(),sPhraseFilterList,sPhraseList) )
	{
		SetDNALastError("CThreadSearchPhrase:::GetScoresforKeyPhrases","KeyPhraseScore","Failed to get Key Phrase Score");
		return false;
	}

	std::map<CTDVString,int> phrasescores;
	int maxscore = 1;
	while ( !SP.IsEOF() )
	{
		CTDVString sName;
		SP.GetField("phrase",sName);

		int score = SP.GetIntField("score");
		maxscore = score > maxscore ? score : maxscore; 

		phrasescores.insert(std::pair<CTDVString,int>(sName,score));
		SP.MoveNext();

	}

	//The XML produced here is for SITEKEYPHRASES
	//However this method actually scores whatever phrase it has been set up with.
	CTDVString sName;
	InitialiseXMLBuilder(&sXML,&SP);
	OpenXMLTag("PHRASES");
	for ( std::map<CTDVString,int>::iterator iter = phrasescores.begin(); iter != phrasescores.end(); ++iter ) 
	{
		OpenXMLTag("PHRASE");
		sName = iter->first;
		
		CTDVString sURLPhrase = sName;
		if ( sURLPhrase.Find(' ') != -1 ) 
		{
			sURLPhrase = '"';
			sURLPhrase += sName;
			sURLPhrase += '"';
		}

		EscapeAllXML(&sName);
		AddXMLTag("NAME",sName);

		EscapePhraseForURL(&sURLPhrase);
		AddXMLTag("TERM",sURLPhrase);

		//(AddXMLTag doesn't support floats)
		sXML << "<SCORE>" << static_cast<float>(iter->second)/static_cast<float>(maxscore) << "</SCORE>"; 
		CloseXMLTag("PHRASE");
		SP.MoveNext();
	}
	CloseXMLTag("PHRASES");

	return CreateFromXMLText(sXML);

}

/*********************************************************************************

	CSearchPhrase::GetSiteKeyPhraseScores
		Author:		Martin Robb
        Created:	15/06/2005
        Inputs:		- Filter - only score site key phrases with reference to this filter. 
        Outputs:	- 
        Returns:	- false on error
        Purpose:	- Score any site key phrases with reference to an optional phrase filter(s).
					- Site Key Phrases are defined in the SiteKeyPhrases table. They are a set of keyphrases
					- that have special meaning for a site eg set of regions for English Regions.
					- The XML is cached for site key phrases scored with no filter.

*********************************************************************************/
bool CThreadSearchPhrase::GetSiteKeyPhraseScores( const CTDVString sFilter)
{
	//Get Site Key Phrases
	GetSiteKeyPhrases();

	//Analyse Filter removing any filters that are also site key phrases.
	CTDVString sPhraseList;
	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CThreadSearchPhrase phrases(m_InputContext,delimit);
	phrases.ParsePhrases(sFilter);

	SEARCHPHRASELIST filters =  phrases.GetPhraseList();
	for (SEARCHPHRASELIST::iterator iter = filters.begin(); iter != filters.end(); iter++)
	{
		//Ignore a filter if it is included in phrases to be scored.
		bool bMatched = false;
		for (SEARCHPHRASELIST::iterator search_iter = m_lPhraseList.begin(); search_iter != m_lPhraseList.end(); search_iter++)
		{
			if (iter->m_Phrase == search_iter->m_Phrase)
			{
				bMatched = true;
				break;
			}
		}
		if(bMatched)
		{
			continue;
		}
		//Create a comma delimited phrase list
		sPhraseList << (sPhraseList.IsEmpty() ? "" : "|") << iter->m_Phrase;
	}
	

	//Get the scores for the region phrases.
	CTDVString sXML;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	if ( !SP.GetSiteKeyPhraseScores(m_InputContext.GetSiteID(),sPhraseList) )
	{
		SetDNALastError("CThreadSearchPhrase:::GetSiteKeyPhraseScores","SiteKeyPhraseScores","Failed to get Site Key Phrase Scores");
		return false;
	}

	std::map<PHRASE,int> phrasescores;
	int maxscore = 1;
	while ( !SP.IsEOF() )
	{
		CTDVString sPhrase;
		SP.GetField("phrase", sPhrase);

		CTDVString sNamespace;
		if(SP.FieldExists("Namespace") && !SP.IsNULL("Namespace"))
		{
			SP.GetField("Namespace", sNamespace);
		}
		
		PHRASE phrase(sNamespace, sPhrase);

		int score = SP.GetIntField("score");
		maxscore = score > maxscore ? score : maxscore; 

		phrasescores.insert(std::pair<PHRASE, int>(phrase, score));
		SP.MoveNext();

	}

	CTDVString cachename;
	if ( sFilter.IsEmpty() )
	{
		//Create a cache name including the site, keyphrases, skip and show params.
		cachename << "sitekeyphrasescores-" << m_InputContext.GetSiteID()  <<  ".xml";

		//Try to get a cached copy.
		CTDVDateTime dExpires(60*10);		// expire after 10 minutes
		if ( CacheGetItem("keyphrase", cachename, &dExpires, &sXML) )
		{
				return CreateFromXMLText(sXML);
		}
	}

	//The XML produced here is for SITEKEYPHRASES
	CTDVString sName;
	CTDVString sNameSpace;
	InitialiseXMLBuilder(&sXML,&SP);
	OpenXMLTag("SITEKEYPHRASES");
	for ( std::map<PHRASE, int>::iterator iter = phrasescores.begin(); iter != phrasescores.end(); ++iter ) 
	{
		OpenXMLTag("KEYPHRASE");
		sNameSpace = (iter->first).m_NameSpace;
		sName = (iter->first).m_Phrase;

		EscapeAllXML(&sNameSpace);
		AddXMLTag("NAMESPACE",sNameSpace);
		
		CTDVString sURLPhrase = sName;
		if ( sURLPhrase.Find(' ') != -1 ) 
		{
			sURLPhrase = '"';
			sURLPhrase += sName;
			sURLPhrase += '"';
		}

		EscapeAllXML(&sName);
		AddXMLTag("NAME",sName);

		EscapePhraseForURL(&sURLPhrase);
		AddXMLTag("TERM",sURLPhrase);

		//(AddXMLTag doesn't support floats)
		sXML << "<SCORE>" << static_cast<float>(iter->second)/static_cast<float>(maxscore) << "</SCORE>"; 
		CloseXMLTag("KEYPHRASE");
		SP.MoveNext();
	}
	CloseXMLTag("SITEKEYPHRASES");

	bool bSuccess = CreateFromXMLText(sXML);
	
	if ( bSuccess && sFilter.IsEmpty() && !cachename.IsEmpty() )
	{
		CachePutItem("keyphrase",cachename,sXML);
	}
	return bSuccess;
}

/*********************************************************************************

	bool CThreadSearchPhrase::RemoveKeyPhrases(int iThreadID, CTDVString& sPhraseIDs)

		Author:		David Williams
        Created:	19/11/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CThreadSearchPhrase::RemoveKeyPhrases(int iThreadID )
{
	if ( m_lPhraseList.empty() )
	{
		SetDNALastError("CThreadSearchPhrase","RemovekeyPhrases","No key phrases");
		return false;
	}

	//Create a comma delimited phrase list
	CTDVString sPhraseList;
	SEARCHPHRASELIST::iterator iter;
	for (iter = m_lPhraseList.begin(); iter != m_lPhraseList.end(); iter++)
	{
		sPhraseList << (sPhraseList.IsEmpty() ? "" : "|") << iter->m_Phrase;
	}

	bool bSuccess = true;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);

	if (!SP.RemoveKeyPhrasesFromThread(iThreadID, sPhraseList))
	{
		SetDNALastError("CThreadSearchPhrase::RemoveKeyPhrases", "RemoveKeyPhrases", "Failed to remove key phrases from thread");
		bSuccess = false;
	}

	return bSuccess;
}