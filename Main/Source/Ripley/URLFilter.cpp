// URLFilter.cpp: implementation of the CURLFilter class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "URLFilter.h"
#include "CGI.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CURLFilter::CURLFilter(CInputContext inputContext) :
	m_InputContext(inputContext)
{
}

CURLFilter::~CURLFilter(void)
{
}

/*********************************************************************************

	bool CURLFilter::CheckForURLs(const TDVCHAR *pCheckString, CTDVString* psMatch)

	Author:		Steven Francis
	Created:	03/05/2006
	Inputs:		pCheckString - The string you want to check for non allowed urls
	Outputs:	psMatch - A String Pointer that if not NULL Takes the value of the matching url
	Returns:	True if the string contains a non allowed url, false if not
	Purpose:	Checks a given string for non allowed urls which are taken from
				the nonallowedurl table in the database.

*********************************************************************************/

CURLFilter::FilterState CURLFilter::CheckForURLs(const TDVCHAR *pCheckString, CTDVString* psMatch)
{
	// Check if we have any URLs in the given text then if we have if they're not in the white list
	// First create a local version of the string to check and make it lowercase.
	CTDVString sCheck(pCheckString);
	sCheck.MakeLower();

	//Right go through the text and check to see if we actually have a url 
	//if we do then check it against the white list if it doesn't match reject it,
	//if there is no url or it is one that is in the white list then pass it
	int			iStart = -1;
	int			iEnd = -1;
	bool		bFailed = false;

	// Now get the Allowed URL list from the cache and call the contains function
	CTDVString sAllowedURLList;
	CGI::GetAllowedURLList(m_InputContext.GetSiteID(), sAllowedURLList);

	long pos=-1;
	while ((pos = sCheck.FindText("www.")) >= 0)
	{
		// We've found an www.
		if (pos > 0)
		{
			sCheck = sCheck.Mid(pos);
		}

		// get everything up to a space or end of string
		pos = sCheck.FindContaining("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890&?%-#*+_.\\/:~=;");
		if (pos < 0)
		{
			pos = sCheck.GetLength();
		}

		CTDVString sURL = sCheck.Left(pos);

		if (!sURL.DoesTextContain(sAllowedURLList, "¶", true, true, psMatch))
		{
			return Fail;
		}

		sCheck = sCheck.Mid(pos);
	}
		
	return Pass;
}