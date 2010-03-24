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

#include "stdafx.h"
#include "DnaUrl.h"
#include "TDVString.h"
#include <ctype.h>
#include "config.h"

const int CDnaUrl::ARTICLE = 1;
const int CDnaUrl::CLUB = 2;
const int CDnaUrl::EXTERNAL = 3;
const int CDnaUrl::UNKNOWN = 4;
const int CDnaUrl::EMPTY = 5;
const bool CDnaUrl::DONTDEFAULTTOHTTP = false;
const bool CDnaUrl::DEFAULTTOHTTP = true;

CDnaUrl::CDnaUrl(CInputContext& inputContext): 
CXMLObject(inputContext)
{
}

CDnaUrl::~CDnaUrl()
{
}

/*********************************************************************************
CDnaUrl::Initialise(const char* pUrl, bool bDefaultToHttp)
Author:		Igor Loboda
Created:	14/01/2005
Inputs:		pUrl - url to parse
Purpose:	Stores given url internally and also tries to parse and classify it.
			See Parse method documentation
*********************************************************************************/

bool CDnaUrl::Initialise(const char* pUrl, bool bDefaultToHttp)
{
	m_iType = UNKNOWN;
	m_iTargetId = 0;
	m_sUrl = pUrl;

	Parse(pUrl);

	if (IsUnknown() && bDefaultToHttp)
	{
		m_iType = EXTERNAL;
		m_sUrl = "http://" + m_sUrl;
	}

	return true;
}


/*********************************************************************************
bool CDnaUrl::CheckUrlScheme(const CTDVString& sUrl)
Author:		Igor Loboda
Created:	19/04/2005
Inputs:		sUrl - url to check
Purpose:	Checks that given url has a scheme specified and it is
			of this format:ALPHA *( ALPHA / DIGIT / "+" / "-" / "." ).
			See rfc 3986
*********************************************************************************/

bool CDnaUrl::CheckUrlScheme(const CTDVString& sUrl)
{
	int iSchemeEnd = sUrl.Find("://");
	if (iSchemeEnd < 0)
	{
		return false;
	}

	CTDVString sScheme;
	sScheme.AppendChars(sUrl, iSchemeEnd);

	if (sScheme.IsEmpty())
	{
		return false;
	}

	if (!isalpha(sScheme[0]))
	{
		return false;
	}

	for (int i = 1; i < sScheme.GetLength(); i++)
	{
		if (!isalnum(sScheme[i]) && sScheme[i] != '+'
			&& sScheme[i] != '-' && sScheme != '.')
		{
			return false;
		}
	}

	return true;
}


/*********************************************************************************
void CDnaUrl::ExternalUrl(const CTDVString& sUrl)
Author:		Igor Loboda
Created:	19/04/2005
Inputs:		sUrl - url to check
Purpose:	Checks that given url has a proper formated scheme and sets
			type to EXTERNAL if it does. Sets type to UNKNOWN otherwise
*********************************************************************************/

void CDnaUrl::ExternalUrl(const CTDVString& sUrl)
{
	if (CheckUrlScheme(sUrl))
	{
		m_iType = EXTERNAL;
	}
	else
	{
		m_iType = UNKNOWN;
	}
}

/*********************************************************************************
void CDnaUrl::Parse(const char* pUrl)
Author:		Igor Loboda
Created:	14/01/2005
Inputs:		pUrl - url to parse
Purpose:	Stores given url internally and tries to parse and classify it. If
			the url matches site root variable from the config file and it has a form
			of /A4213413 it's article, /G23423 or /Club23432 it's compaign. Anything
			else is external/empty/unknown. Matching is case insesitive.
*********************************************************************************/

void CDnaUrl::Parse(const char* pUrl)
{
	CTDVString sUrl = pUrl;

	//TODO: move to CTDVString?
	//trim left
	int i;
	for (i = 0; i < sUrl.GetLength() && isspace(sUrl[i]); i++)
	{
		// do nothing - we just want to find the first nonspace char
	}
	sUrl.RemoveLeftChars(i);

	if (sUrl.IsEmpty())
	{
		m_iType = EMPTY;
		return;
	}
	sUrl.MakeUpper();

	if (!DnaUrl(sUrl))	//non dna link, at least not this dna instance link
	{
		ExternalUrl(sUrl);
	}
}


/*********************************************************************************
void CDnaUrl::DnaUrl(const CTDVString& sUrlIn)
Author:		Igor Loboda
Created:	19/04/2005
Inputs:		sUrlIn - url to check. presumably url starts with dna siteroot.
Purpose:	Checks if there is /A<number> /G<number> or /CLUB<number> in the
			url and if there is <number> is stored internaly and type is
			set accordingly (article, club, club). Othersize give url is
			treated as external one.
*********************************************************************************/

bool CDnaUrl::DnaUrl(const CTDVString& sUrlIn)
{
	CTDVString siteRoot(m_InputContext.GetSiteRoot());
	siteRoot.MakeUpper();
	int iPos = 0;
	if (sUrlIn.FindText(siteRoot) == 0)
	{
		iPos = sUrlIn.FindTextLast("/");
		if (iPos < 0)
		{
			return false;
		}
		else
		{
			iPos++;
		}
	}
	
	CTDVString sUrl = static_cast<const char*>(sUrlIn) + iPos;
	if (sUrl.Find("A") == 0)
	{
		m_iType = ARTICLE;
		iPos = 1;
	}
	else if (sUrl.Find("G") == 0)
	{
		m_iType = CLUB;
		iPos = 1;
	}
	else if (sUrl.Find("CLUB") == 0)
	{
		m_iType = CLUB;
		iPos = 4;
	}
	else
	{
		return false;
	}

	//get id
	CTDVString sId;
	int iLen = sUrl.GetLength();
	while (iPos < iLen && isdigit(sUrl[iPos]))
	{
		sId.AppendChars(static_cast<const char*>(sUrl) + iPos, 1);
		iPos++;
	}

	if (!sId.GetLength())
	{
		return false;
	}

	m_iTargetId = atoi(sId);
	return true;
}


/*********************************************************************************
const char* CDnaUrl::GetTypeName() const
Author:		Igor Loboda
Created:	14/01/2005
Outputs:	returns url type name: club, article, external, unknown, empty. 
*********************************************************************************/

const char* CDnaUrl::GetTypeName() const
{
	if (IsClub())
	{
		return "club";
	}
	else if (IsArticle())
	{
		return "article";
	}
	else if (IsExternal())
	{
		return "external";
	}
	else if (IsEmpty())
	{
		return "empty";
	}

	return "unknown";
}