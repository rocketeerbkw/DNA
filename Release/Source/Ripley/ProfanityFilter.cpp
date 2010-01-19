// ProfanityFilter.cpp: implementation of the CProfanityFilter class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ProfanityFilter.h"
#include "CGI.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CProfanityFilter::CProfanityFilter(CInputContext inputContext) :
	m_InputContext(inputContext)
{

}

CProfanityFilter::~CProfanityFilter()
{

}

/*********************************************************************************

	bool CProfanityFilter::CheckForProfanities(const TDVCHAR *pCheckString, CTDVString* psMatch)

	Author:		Mark Howitt
	Created:	20/01/2004
	Inputs:		pCheckString - The string you want to check for profanities
	Outputs:	psMatch - A String Pointer that if not NULL Takes the value of the matching profanity
	Returns:	True if the string contains a profanity, false if not
	Purpose:	Checks a given string for profanities which are taken from
				the profanities table in the dtabase.

*********************************************************************************/

CProfanityFilter::FilterState CProfanityFilter::CheckForProfanities(const TDVCHAR *pCheckString, CTDVString* psMatch)
{
	// Check the list of known profanities to see if we have any in the given text.
	// First create a local version of the string to check and make it lowercase.
	CTDVString sCheck(pCheckString);
	sCheck.MakeLower();

	CTDVString sCheckNoLinks;
	RemoveLinksFromText(sCheck, sCheckNoLinks);

	// Now get the profanity list from the cache and call the contains function
	CTDVString sProfanityList;
	CTDVString sReferList;


	std::pair<CTDVString, CTDVString> wordLists;
	CGI::GetProfanities(m_InputContext.GetModClassID(), wordLists);

	sProfanityList = wordLists.first;
	sReferList = wordLists.second;

    //CTDVString sNoPunctuation = TrimPunctuation(sCheckNoLinks);
	
	if (sCheckNoLinks.DoesTextContain(sProfanityList, "¶", false, false, psMatch))
	{
		return FailBlock;
	}
	
    if (sCheckNoLinks.DoesTextContain(sReferList, "¶", false, false, psMatch))
	{
		return FailRefer;
	}
	
	return Pass;
}

/*********************************************************************************

	bool CProfanityFilter::TrimPunctuation(CTDVString sText)

	Author:		Martin Robb
	Created:	01/08/2008
	Inputs:		sText - the text to check
	Returns:	the input text with punctuation trimmed from words.
	Purpose:	Trim punctuation form words to stop the profanity filter being evaded ading punctuation to word.

*********************************************************************************/
CTDVString CProfanityFilter::TrimPunctuation(CTDVString sText)
{
	CTDVString sNoPunctuation;

	// Trim Punctuation from words.
	int inputlength = sText.GetLength();
	bool bNewWord = true;
	const TDVCHAR* pData = sText;
    for (int i=0; i < inputlength; i++)
	{
        // Dont want asci values > 128 to be negative. Use unsigned char.
        unsigned char c = pData[i];

		// Space Marks Start / End of Word.
		if ( !bNewWord && (isspace(c) != 0 || i == inputlength-1) )
		{
			//Right Trim punctuation off previous word.
			const TDVCHAR* pNoPunctuation = sNoPunctuation;
			for ( int j = sNoPunctuation.GetLength()-1; j >= 0; --j )
			{
                unsigned int np = pNoPunctuation[j];
				if ( isalnum( np ) != 0 )
				{
					//Alphanumeric found
					break;
				}
				else
				{
					// Found non alphanumeric - Remove it.
					sNoPunctuation.RemoveTrailingChar( np );
				}
			}
			
			if ( isspace( c ) != 0 )
			{
				sNoPunctuation += pData[i];
			}
			bNewWord = true;
		}
		
		if ( isalnum( c ) != 0 )
		{
			bNewWord = false;
            sNoPunctuation += pData[i];
		}
		else if ( !bNewWord && (ispunct( c ) != 0 ) )
		{
			// Allow punctuation within word . Do not allow control characters.
			sNoPunctuation += c;
		}
	}

	return sNoPunctuation;
}


/*********************************************************************************

	bool CProfanityFilter::RemoveLinksFromText(CTDVString sText)

	Author:		David Williams
	Created:	24/07/2007
	Inputs:		sText - the text to remove urls from.
	Returns:	the input text stripped of urls
	Purpose:	Removes http:// urls from the given text.

*********************************************************************************/
void CProfanityFilter::RemoveLinksFromText(CTDVString sText, CTDVString& newText)
{
	long pos = 0;
	
	while((pos = sText.Find("http://")) >= 0)
	{
		if (pos > 0)
		{
			newText += sText.Left(pos);
			sText = sText.Mid(pos);
		}

		pos = sText.FindContaining("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890&?%-#*+_./:~=;");

		if (pos < 0)
		{
			pos = sText.GetLength();
		}
		sText = sText.Mid(pos);
	}

	if ( pos < 0)
	{
		newText = sText;
	}

}
