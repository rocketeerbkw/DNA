// SmileyTranslator.cpp: implementation of the CSmileyTranslator class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "GuideEntry.h"
#include "SmileyTranslator.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

#define URL_CHARS "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890&?%-#*+_./:~=;,$!()'@"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSmileyTranslator::CSmileyTranslator()
{
	for (int i=0;i<256;i++)
	{
		m_aList[i] = NULL;
	}
}


CSmileyTranslator::~CSmileyTranslator()
{
	for (int i=0;i<256;i++)
	{
		if (m_aList[i] != NULL)
		{
			delete m_aList[i];
			m_aList[i] = NULL;
		}
	}
}

CHttpUnit::CHttpUnit() : CSmileyUnit(NULL,NULL, false)
{
}

CHttpUnit::~CHttpUnit()
{
}

bool CHttpUnit::IsBigger(CSmileyUnit* pOther)
{
	return true;
}

/*********************************************************************************

	CSmileyTranslator::DoReplace()

		Author:		Various
        Created:	
        Inputs:		- ppReplace, pStart, oResult, SmileyCount
        Outputs:	- oResult - translated string 
        Returns:	- False if no translation found or was possible
        Purpose:	- Translate the given string. Adds <LINK> XML where an external link is found.
*********************************************************************************/
bool CHttpUnit::DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* pCurrentSmileyCount)
{
	if (strncmp(*ppReplace, "http://",7) == 0)
	{
		TDVCHAR pstr[1024];
		const TDVCHAR* ptr = *ppReplace;
		int urllen = strspn(ptr,URL_CHARS);
		
		
		if (urllen > 0 && (ptr[urllen -1] == '.' || ptr[urllen - 1] == '?'))
		{
			urllen--;
		}
			
		if (urllen > 1023)
		{
			return false;
		}

		//Ideally url validation would be conducted by DnaUrl but is done here for performance reasons.
		//@ character can be used for spoofing eg http://www.bbc.co.uk@191.250.10.1 but is valid after the domain.
		if ( urllen > 7 )
		{
			//Start after the http:// and fail if a @ is found before a / char.
			int charcount = 7;
			const TDVCHAR* pValidate = &ptr[charcount];
			while ( charcount < urllen )
			{
				if ( *pValidate == '@' )
					return false;
				else if ( *pValidate == '/' )
					break;
				++pValidate;
				++charcount;
			}
		}

		//Valid link found create link XML.
		*oResult << "<LINK HREF=\"";
		strncpy(pstr, *ppReplace, urllen);
		pstr[urllen] = 0;
		*oResult << pstr << "\">" << pstr << "</LINK>";
		*ppReplace += urllen;
		(*pCurrentSmileyCount)++;
		return true;
	}
	return false;
}

CRelativeURLUnit::CRelativeURLUnit() : CSmileyUnit(NULL,NULL, false)
{
}

CRelativeURLUnit::~CRelativeURLUnit()
{
}

bool CRelativeURLUnit::IsBigger(CSmileyUnit* pOther)
{
	return true;
}

bool CRelativeURLUnit::DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* pCurrentSmileyCount)
{

	int opentaglen = 4;
	int closetaglen = 4;
	//get the pointer to the first position in the string
	const TDVCHAR* ptr = *ppReplace;

	TDVCHAR pstr[1024];
	
	if (strncmp(*ppReplace, "<./>",opentaglen) == 0)
	{
		
		ptr += opentaglen;
		int urllen = 0;
		urllen = strspn(ptr," " URL_CHARS);
		if (urllen == 0 || urllen > 1023)
		{
			return false;
		}
		strncpy(pstr, ptr, urllen);
		pstr[urllen] = 0;

		ptr += urllen;
		//check that the closing tag is there too
		if (strncmp(ptr,"</.>",closetaglen) != 0)
		{
			return false;
		}

		
		CTDVString sEscaped = pstr;
		sEscaped.Replace("&","&amp;");

		*oResult << "<LINK HREF=\"";
		*oResult << pstr << "\">" << sEscaped << "</LINK>";
		*ppReplace += urllen + opentaglen + closetaglen;
		return true;
	}
	return false;
}



CArticleUnit::CArticleUnit(ARTICLETYPE atype) : m_Type(atype), CSmileyUnit(NULL,NULL, true)
{
}

CArticleUnit::~CArticleUnit()
{
}

bool CArticleUnit::IsBigger(CSmileyUnit* pOther)
{
	return true;
}

bool CArticleUnit::DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* pCurrentSmileyCount)
{
	// Rules for replacing A12345:
	// Can only have the following chars before it: ([ and space and crlf
	// Letter followed by 1 or more number followed by ? followed by alphanumeric or &
	const TDVCHAR* ptr = *ppReplace;
	if ((ptr == pStart) || (ptr[-1] == '(') || (ptr[-1] == '[') || (ptr[-1] == ' ') || (ptr[-1] == 13) || (ptr[-1] == 10))
	{
		ptr++;
		int NumberLen = strspn(ptr, "0123456789");
		if (NumberLen > 0)
		{
			TDVCHAR pID[1024];
			if (NumberLen > 1023)
			{
				return false;
			}

			strncpy(pID, ptr, NumberLen);
			pID[NumberLen] = 0;
			int h2g2ID = atoi(pID);

			if (m_Type == T_ARTICLE && !CGuideEntry::IsValidChecksum(h2g2ID))
			{
				return false;
			}

			ptr += NumberLen;

			// Do we also have a query string after it?
			bool bGotQuery = (ptr[0] == '?');
			if (bGotQuery)
			{
				NumberLen = strspn(ptr, URL_CHARS);
				// strip off terminating full stop
				if (NumberLen > 0 && (ptr[NumberLen -1] == '.' || ptr[NumberLen - 1] == '?' || ptr[NumberLen - 1] == ')'))
				{
					NumberLen--;
				}
				ptr += NumberLen;
			}
			NumberLen = ptr - (*ppReplace);
			if (NumberLen > 1023)
			{
				return false;
			}

			//Look for a match against exclusions
			for ( std::vector<CTDVString>::iterator iter = m_Exclusions.begin(); iter != m_Exclusions.end(); ++iter )
			{
				if ( strncmp(*iter,*ppReplace,NumberLen) == 0 ) 
				{
					return false;
				}
			}

			strncpy(pID, *ppReplace, NumberLen);
			pID[NumberLen] = 0;
			CTDVString sEscaped = pID;
			sEscaped.Replace("&","&amp;");
			if (m_Type == T_ARTICLE || m_Type == T_CLUB || m_Type == T_FORUM )
			{
				*oResult << "<LINK DNAID=\"";
			}
			else if (m_Type == T_USER)
			{
				*oResult << "<LINK BIO=\"";
			}
			else
			{
				*oResult << "<LINK HREF=\"";
			}
			*oResult << sEscaped << "\">" << sEscaped << "</LINK>";
			*ppReplace += NumberLen;
			(*pCurrentSmileyCount)++;
			return true;
		}
	}
	return false;
}

void CArticleUnit::AddFilterExpression( const CTDVString& expression )
{
	m_Exclusions.push_back(expression);
}

CBracketUnit::CBracketUnit() : CSmileyUnit(NULL,NULL, true)
{
}

CBracketUnit::~CBracketUnit()
{
}

bool CBracketUnit::AddUnit(const TDVCHAR* pString, const TDVCHAR* pReplace)
{
	return m_Translator.AddUnit(pString, pReplace);
}

bool CBracketUnit::IsBigger(CSmileyUnit* pOther)
{
	return true;
}

bool CBracketUnit::DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* pCurrentSmileyCount)
{
	(*ppReplace)++;
	if (m_Translator.SingleTranslate(ppReplace, pStart, oResult, pCurrentSmileyCount))
	{
		return true;
	}
	else
	{
		(*ppReplace)--;
		return false;
	}
}

bool CSmileyUnit::IsBigger(CSmileyUnit* pOther)
{
	if (pOther->m_sUnit.GetLength() == m_sUnit.GetLength())
	{
		return (pOther->m_sUnit) < m_sUnit;
	}
	else
	{
		return (pOther->m_sUnit.GetLength() < m_sUnit.GetLength());
	}
}

CSmileyUnit::CSmileyUnit(const TDVCHAR* pValue, const TDVCHAR* pReplace, bool bCountAsSmiley) : m_sUnit(pValue), m_sReplace(pReplace), m_pNext(NULL), m_bCountAsSmiley(bCountAsSmiley), m_iOpenTags(0)
{
}

CSmileyUnit::~CSmileyUnit()
{
	if (m_pNext != NULL)
	{
		delete m_pNext;
		m_pNext = NULL;
	}
}

bool CSmileyUnit::DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* pCurrentSmileyCount)
{
	// TODO - check le of incoming string to avoid buffer overrun
	// *ppReplace points at the first char matching
	if (strncmp(*ppReplace, m_sUnit, m_sUnit.GetLength()) == 0)
	{
		*oResult << m_sReplace;
		*ppReplace += m_sUnit.GetLength();
		if (m_bCountAsSmiley)
		{
			(*pCurrentSmileyCount)++;
		}
		return true;
	}
	else
	{
		return false;
	}
}

void CSmileyTranslator::Dump()
{
	for (int i=0;i<256;i++)
	{
		CSmileyUnit* pUnit = m_aList[i];
		while (pUnit != NULL)
		{
			pUnit->Dump();
			pUnit = pUnit->GetNext();
		}
	}
}

bool CSmileyTranslator::Translate(CTDVString* pString, int MaxSmileyCount)
{
	int CurrentSmileyCount = 0;
	int iLength = pString->GetLength();
	CTDVString sResult;
	sResult.EnsureAvailable(iLength + (iLength / 5));
	
	const TDVCHAR* pInside = (const TDVCHAR*)(*pString);
	const TDVCHAR* pStart = pInside;

	while (pInside[0] != 0 && ((MaxSmileyCount == 0) || (CurrentSmileyCount <= MaxSmileyCount)))
	{
		if (!SingleTranslate(&pInside, pStart, &sResult, &CurrentSmileyCount))
		{
			sResult += pInside[0];
			pInside++;
		}
/*		int iIndex = (unsigned char)pInside[0];
		CSmileyUnit* pUnit = m_aList[iIndex];
		while (pUnit != NULL && !(pUnit->DoReplace(&pInside, pStart, &sResult)))
		{
			pUnit = pUnit->GetNext();
		}
		if (pUnit == NULL)
		{
			sResult += pInside[0];
			pInside++;
		}
*/
	}
	if (pInside[0] != 0)
	{
		return false;	// too many smileys
	}
	else
	{
		*pString = sResult;
		return true;
	}
}

bool CSmileyTranslator::SingleTranslate(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* pCurrentSmileyCount)
{
	const TDVCHAR* pInside = *ppReplace;
	int iIndex = (unsigned char)pInside[0];

	//A Translator Unit is registered against each chracter.
	//Get Translator Unit for this letter.
	CSmileyUnit* pUnit = m_aList[iIndex];

	// Do the replacement
	while (pUnit != NULL && !(pUnit->DoReplace(ppReplace, pStart, oResult, pCurrentSmileyCount)))
	{
		pUnit = pUnit->GetNext();
	}

	if (pUnit == NULL)
	{
		return false;
	}
	else 
	{
		return true;
	}
}

bool CSmileyTranslator::AddUnit(const TDVCHAR* pString, const TDVCHAR* pReplace, bool bCountAsSmiley)
{
	if (pString != NULL && pString[0] != 0)
	{
		CSmileyUnit* pNew = new CSmileyUnit(pString, pReplace, bCountAsSmiley);
		int iValue = (unsigned char)pString[0];
		AddUnit(pNew, iValue);
	}
	return true;
}

bool CSmileyTranslator::AddUnit(CSmileyUnit* pUnit, int ArrayPos)
{
	CSmileyUnit* pFirst = m_aList[ArrayPos];
	CSmileyUnit* pPrev = NULL;
	while (pFirst != NULL && pFirst->IsBigger(pUnit))
	{
		pPrev = pFirst;
		pFirst = pFirst->GetNext();
	}
	if (pPrev == NULL)
	{
		pUnit->SetNext(m_aList[ArrayPos]);
		m_aList[ArrayPos] = pUnit;
	}
	else
	{
		pUnit->SetNext(pPrev->GetNext());
		pPrev->SetNext(pUnit);
	}
	return true;
}

CQuoteUnit::CQuoteUnit() : CSmileyUnit(NULL,NULL, false)
{
}

CQuoteUnit::~CQuoteUnit()
{
}

bool CQuoteUnit::IsBigger(CSmileyUnit* pOther)
{
	return true;
}

/*********************************************************************************

	bool CQuoteUnit::DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* pCurrentSmileyCount)

		Author:		Mark Howitt
        Created:	21/06/2004
        Inputs:		ppReplace - The text to parse for replacement.
					pStart - A pointer to the start position of the replacement string.
        Outputs:	oResult - The string to add the replacement text to.
					pCurrentSmileyCount - a pointer to a count, so we can track the smiley limits
        Returns:	true if we found a opening or closing quote tag, false if not
        Purpose:	Parses for quote tags. NOTE!!! There is currently no checking to make sure there are matching
					opening and closing tags! Due to the fact that we have attributes within the open tag, it makes
					parsing for correct xml structure very difficult. 

*********************************************************************************/
bool CQuoteUnit::DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* pCurrentSmileyCount)
{
	// Make a string copy of the replace
	CTDVString sReplace(*ppReplace);

	// Now see if we've got an open or close quote tag!
	bool bFoundQuote = false;
	if (sReplace.Find("<quote") == 0)
	{
		// Make sure it has a closing bracket and it comes before the closing tag!
		int iEndBracket = sReplace.Find(">");
		if (iEndBracket == -1)
		{
			// No closing bracket for the open tag!
			return false;
		}

		if (iEndBracket == 6)
		{
			// We've just got a bog standard open quote tag!
			*oResult << "<QUOTE>";
			*ppReplace += 7;
		}
		else
		{
			// We've got a closing bracket before the closing tag! It's an open tag with attributes!
			// Mkae sure we put it all into upper case!
			*oResult << "<QUOTE";
			CTDVString sTemp = sReplace.Mid(6,iEndBracket - 6);
			CTDVString sEscaped;
			int iFirst = 0, iCount = 0;

			// Find the PostID info if any
			int iPostPos = sTemp.Find("postid='");
			if (iPostPos > -1)
			{
				// Found a user name attribute, add it to the result string
				iFirst = iPostPos + 8;
				iCount = sTemp.Find("'",iFirst) - iPostPos - 8;
				if (iCount > 0)
				{
					sEscaped = sTemp.Mid(iFirst,iCount);
					CXMLObject::EscapeAllXML(&sEscaped);
					*oResult << " POSTID='" << sEscaped << "'";
				}
			}

			// Find the user info if any
			int iUserPos = sTemp.Find("user='");
			if (iUserPos > -1)
			{
				// Found a user name attribute, add it to the result string
				iFirst = iUserPos + 6;
				iCount = sTemp.Find("'",iFirst) - iUserPos - 6;
				if (iCount > 0)
				{
					sEscaped = sTemp.Mid(iFirst,iCount);
					CXMLObject::EscapeAllXML(&sEscaped);
					*oResult << " USER='" << sEscaped << "'";
				}
			}

			// Find the username if any
			int iUserIDPos = sTemp.Find("userid='");
			if (iUserIDPos > -1)
			{
				// Found a userid attribute, put it into the result string
				iFirst = iUserIDPos + 8;
				iCount = sTemp.Find("'",iFirst) - iUserIDPos - 8;
				if (iCount > 0)
				{
					sEscaped = sTemp.Mid(iFirst,iCount);
					CXMLObject::EscapeAllXML(&sEscaped);
					*oResult << " USERID='" << sEscaped << "'";
				}
			}

			// Close the open tag and Update the pointer position
			*oResult << ">";
			*ppReplace += iEndBracket + 1;
		}

		// Increment the number of open tags
		m_iOpenTags++;
		bFoundQuote = true;
	}
	else if (sReplace.Find("</quote>") == 0)
	{
		// Copy the close tag into the result string and move the pointer on
		*oResult << "</QUOTE>";
		*ppReplace += 8;
		m_iOpenTags--;
		bFoundQuote = true;
	}

	// Return saying if we've found and replaced a quote
	return bFoundQuote;
}

/*********************************************************************************

	bool CEmailUnit::DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* pCurrentSmileyCount)

		Author:		Martin Robb
        Created:	04/05/2006
        Inputs:		ppReplace - The text to parse for replacement.
					pStart - A pointer to the start position of the replacement string.
        Outputs:	oResult - The string to add the replacement text to.
					pCurrentSmileyCount - a pointer to a count, so we can track the smiley limits
        Returns:	true if eail address found
        Purpose:	Looks for email addresses and replaces the email with [email removed] text.
					Not currently used as email address filtering is done by CEmailAddressFilter as a validation step.

*********************************************************************************/
/*bool CEmailUnit::DoReplace(const TDVCHAR** ppReplace, const TDVCHAR* pStart, CTDVString* oResult, int* pCurrentSmileyCount)
{
	// Make a string copy of the replace
	CTDVString sReplace(*ppReplace);

	int chars = 0;
	const TDVCHAR* pptr = *ppReplace;
	
	//Decide whether string could be an email address.
	if ( *pptr == '@' && (pptr != pStart) && isalnum(pptr[-1]) && isalnum(pptr[1]) )
	{
		const TDVCHAR* ptrdomain = *ppReplace;
		const TDVCHAR* ptrusername = *ppReplace;
		char emaildomain[64];
		while ( *ptrdomain != ' ' && chars < 63 )
		{
			emaildomain[chars] = *ptrdomain;
			chars ++;
			ptrdomain++;
		}
		
		
		emaildomain[chars] = '\0';
		if ( strchr(emaildomain,'.') == NULL )
		{
			//Does not appear to be a  valid email domain eg no .com .co.uk etc
			return false;
		}

		//Skip passed email domain.
		*ppReplace += chars;

		//Move to  start of username part of email address.
		chars = 0;
		while ( *ptrusername != ' ' && ptrusername != pStart )
		{
			chars++;
			ptrusername--;
		}

		//Remove username from result string.
		*oResult = oResult->TruncateRight(chars);
		*oResult << " [ am email address has been removed ]. ";

		*pCurrentSmileyCount++;
		return true;
	}
	else
	{
		//Does not appear to b ean email address.
		return false;
	}
}*/
