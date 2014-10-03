// H2G2FILTER.CPP - Implementation file for your Internet Server
//    h2g2 filter

#include "stdafx.h"
#include "h2g2filter.h"

// Hash-define the string of all numeric digits, to make sure it's not mis-typed ;-)

#define DIGITS "0123456789"

///////////////////////////////////////////////////////////////////////
// The one and only CWinApp object - actually, a CH2g2App
// NOTE: You may remove this object if you alter your project to no
// longer use MFC in a DLL.

CWinApp theApp;

REGSAM RegAccess = KEY_READ|KEY_WOW64_64KEY;  // This will work on Window 7 64 bit
//REGSAM RegAccess = KEY_READ;  // This will work on 32 bit Windows

///////////////////////////////////////////////////////////////////////
// The one and only CH2g2Filter object

CH2g2Filter theFilter;


/******************************************************************************

	CH2g2Filter::CH2g2Filter()
						 ,
	Author:		Sean Solle
	Created:	28/1/99
	Inputs:		None.
	Purpose:	Constructor. Opens the CH2g2Filter log.

******************************************************************************/

CH2g2Filter::CH2g2Filter() : m_bKeepAuditTrail(0)
{
	// Open an event log.
		
	m_hEventLog = OpenEventLog( NULL,			// pointer to server name 
								"h2g2filter"	// pointer to source name 
							  );


	EventLog("Filter started.", EVENTLOG_SUCCESS);
	
	// Find the registry key.

	LONG Result;
	
	Result = RegOpenKeyEx( HKEY_LOCAL_MACHINE,
		 						"SOFTWARE\\The Digital Village\\h2g2 web server\\URLmap",
								0,						// reserved
								RegAccess,				// security access mask
								&m_RegKeyRoot);	// address of handle of open key

	
	// Read the terminators.
	
	DWORD dwBufferSize = URL_BUFFER_SIZE;
	DWORD KeyType;

	Result = RegQueryValueEx(	m_RegKeyRoot,
								"Suffixes",
								NULL,		// lpReserved. Reserved; must be NULL. 
								&KeyType,
								(LPBYTE)m_pSuffixes,
								&dwBufferSize
							  );

	Result = RegOpenKeyEx(	m_RegKeyRoot,
		 					"Prefixes",
							0,					// reserved
							RegAccess,			// security access mask
							&m_RegKeyPrefixes);	// address of handle of open key

	Result = RegOpenKeyEx(	m_RegKeyRoot,
		 					"Redirects",
							0,					// reserved
							RegAccess,			// security access mask
							&m_RegKeyRedirects);	    // address of handle of open key

	Result = RegOpenKeyEx(	m_RegKeyRoot,
		 					"Extensions",
							0,					// reserved
							RegAccess,			// security access mask
							&m_RegKeyExtensions);	// address of handle of open key


	Result = RegOpenKeyEx(	m_RegKeyRoot,
		 					"UnCookied",
							0,					// reserved
							RegAccess,			// security access mask
							&m_RegKeyUnCookied);// address of handle of open key

	Result = RegOpenKeyEx(	m_RegKeyRoot,
		 					"TimeToLive",
							0,					// reserved
							RegAccess,			// security access mask
							&m_RegKeyTimeToLive);	// address of handle of open key


}

/******************************************************************************

	CH2g2Filter::~CH2g2Filter()
						 ,
	Author:		Sean Solle
	Created:	28/1/99
	Inputs:		None.
	Purpose:	Destructor. Close the CH2g2Filter log.

******************************************************************************/

CH2g2Filter::~CH2g2Filter()
{

	EventLog("Filter destructor called.", EVENTLOG_SUCCESS);
	
	BOOL bResult = CloseEventLog( m_hEventLog );
}


/******************************************************************************

	BOOL CH2g2Filter::GetFilterVersion(PHTTP_FILTER_VERSION pVer)
						 ,
	Author:		Sean Solle
	Created:	28/1/99
	Inputs:		None.
	Purpose:	Called by the internet server to get the filter version
				indicated by pVer. 
				
				It is called only once, after the CHttpFilter object is constructed. 

******************************************************************************/

BOOL CH2g2Filter::GetFilterVersion(PHTTP_FILTER_VERSION pVer)
{
	// Call default implementation for initialization
	CHttpFilter::GetFilterVersion(pVer);

	// Clear the flags set by base class
	pVer->dwFlags &= ~SF_NOTIFY_ORDER_MASK;

	// Set the flags we are interested in
	pVer->dwFlags |= SF_NOTIFY_ORDER_LOW | SF_NOTIFY_SECURE_PORT | SF_NOTIFY_NONSECURE_PORT
			 | SF_NOTIFY_PREPROC_HEADERS | SF_NOTIFY_END_OF_NET_SESSION | SF_NOTIFY_URL_MAP;

	// Load description string
	TCHAR sz[SF_MAX_FILTER_DESC_LEN+1];
	ISAPIVERIFY(::LoadString(AfxGetResourceHandle(),
			IDS_FILTER, sz, SF_MAX_FILTER_DESC_LEN));
	strcpy_s(pVer->lpszFilterDesc, sz);
	return TRUE;
}

char* FindEndslash(char* pURL)
{
	// Find the first slash *after* the initial directory name 
	// (the URL always starts with a slash so we always add one)
	// Also check that it's not after a query or ampersand
	char* pFirstSlash = strchr(pURL+1, '/');
	char* pQuery = strchr(pURL, '?');
	char* pAmpersand = strchr(pURL, '&');
	
	if (pFirstSlash != NULL && ((pQuery == NULL) || (pFirstSlash < pQuery)) && ((pAmpersand == NULL) || (pFirstSlash < pAmpersand)))
	{
		return pFirstSlash;
	}
	else
	{
		return NULL;
	}
}


/******************************************************************************

	DWORD CH2g2Filter::OnPreprocHeaders(CHttpFilterContext* pCtxt ....
						 ,
	Author:		Sean Solle
	Created:	28/1/99
	Inputs:		None.
	Purpose:	Called by the framework to notify the client that the server 
				has preprocessed the client headers. The default does nothing.

				We override to provide our own method for processing client headers.

******************************************************************************/

DWORD CH2g2Filter::OnPreprocHeaders(CHttpFilterContext* pCtxt,
	PHTTP_FILTER_PREPROC_HEADERS pHeaderInfo)
{
	char pURL[ URL_BUFFER_SIZE ];
	char pPrefix[ URL_BUFFER_SIZE ];
	char pRedirect[ URL_BUFFER_SIZE ];
	char pNumericID[ URL_BUFFER_SIZE ];

	char pDestURL[ URL_BUFFER_SIZE ];
	char pServerName[ URL_BUFFER_SIZE ];
	char pRootDir[ URL_BUFFER_SIZE ];

	char pServiceName[ URL_BUFFER_SIZE ];
	char pSkinName[URL_BUFFER_SIZE];
	pServiceName[0] = 0;
	pSkinName[0] = 0;

#ifdef _DEBUG
	memset(pURL, '*', URL_BUFFER_SIZE);
	memset(pPrefix, '*', URL_BUFFER_SIZE);
	memset(pRedirect, '*', URL_BUFFER_SIZE);
	memset(pDestURL, '*', URL_BUFFER_SIZE);
	memset(pServerName, '*', URL_BUFFER_SIZE);
#endif

	// See if a specific sub-key exists for the site server
	// that we're being accessed through. 
	//
	// This allows /Axxxxx -> script mappings to be done on 
	// a per-site basis.

	DWORD buflen = URL_BUFFER_SIZE;
	pCtxt->GetServerVariable("SERVER_NAME", pServerName, &buflen);

	strcat_s(pServerName, "\\Prefixes");

	HKEY hRegKeyPrefixes;
	LONG bRes = RegOpenKeyEx(	m_RegKeyRoot,
		 					pServerName,
							0,					// reserved
							RegAccess,			// security access mask
							&hRegKeyPrefixes);	// address of handle of open key

	// If we didn't find a specific site subkey, we default to the root.
	
	if (bRes != ERROR_SUCCESS)
	{
		hRegKeyPrefixes = m_RegKeyPrefixes;
	}
	
	// Search the URL for an article etc. request.
	// If we match one, modify it accordingly.
	// If we don't, just leave it alone.

	// The GetHeader method is used to retrieve header text from an HTTP file.
	// First, we need the cookie passed to us.
	
	DWORD dwBufferSize = URL_BUFFER_SIZE;

	// See if we can get a cookie.
	
	BOOL bCookie = pHeaderInfo->GetHeader(pCtxt->m_pFC, "cookie:", pURL, &dwBufferSize);

	if (bCookie)
	{
		EventLog(pURL, EVENTLOG_INFORMATION_TYPE);
	}
	else
	{
		EventLog("No cookie here.", EVENTLOG_INFORMATION_TYPE);
	}

	//
	// Now examine the url passed to us
	//
	
	dwBufferSize = URL_BUFFER_SIZE;
	BOOL bResult = pHeaderInfo->GetHeader(pCtxt->m_pFC, "url", pURL, &dwBufferSize);

	if ( !bResult )
	{
		EventLog("Couldn't get URL from header info", EVENTLOG_ERROR_TYPE);
		return SF_STATUS_REQ_NEXT_NOTIFICATION;
	}


	// 
	// Special debug option - check for a dword called 'debug' in the root.
	//

	DWORD KeyType;
	LONG Result;

#ifdef _DEBUG

	DWORD dwDebug = 0;
	dwBufferSize = sizeof(dwDebug);

	Result = RegQueryValueEx(	m_RegKeyRoot,
								"LogURL",
								NULL,				// lpReserved. Reserved; must be NULL. 
								&KeyType,
								(LPBYTE)dwDebug,	// The word value is 
								&dwBufferSize);

	
	// If we found 'DEBUG', and it's a dword, and its true, output the entire URL to the event log.

	m_bKeepAuditTrail = (Result == ERROR_SUCCESS); //&& (KeyType == REG_DWORD) && (dwDebug != 0))

#endif
	
	EventLog(pURL, EVENTLOG_AUDIT_SUCCESS);

	// Filter translation requests are of the form ....
	//
	// Prefix[0123456789[xyz]][?extraopts]
	//
	// ... and need translating to ...
	//
	// script.cgi?id= 0123456789 & option = X & selection
	//
	// Ripley.dll?script?id= 0123456789 & option = X & selection
	//
	//
	// The registry provides complete string lookup, so we can't identify
	// the Prefix in the "traditional compare each character until stop matching"
	// manner. 
	//
	// Instead we need to check for both a numeric-terminated prefix, and if we don't
	// find one, check for a query-terminated prefix, i.e.
	//
	// Prefix[0123456789]
	// Prefix[?extraopts]
	//
	//
	// Whichever Prefix is found in the registry is then used. 


	// Ultra-quick check - is it the root of the site?

	if ( strcmp( pURL, "/") == 0)
	{
		// Don't do any registry munging on http://www.h2g2.com/

		EventLog("Root bypass :-)", EVENTLOG_INFORMATION_TYPE);
		
		return SF_STATUS_REQ_NEXT_NOTIFICATION;
	}

	// This next bit is designed for a debug site - it will strip off /h2g2/guide
	// from the URL so that the rest of the matching can go ahead

	// This will be overridden by the more general site/skin matching
	// but we'll leave it for now
	
	dwBufferSize = sizeof(pRootDir);
	Result = RegQueryValueEx(	m_RegKeyRoot,
									"Root",
									NULL,		// lpReserved. Reserved; must be NULL. 
									&KeyType,
									(LPBYTE)pRootDir, // The URL we ultimately return.
									&dwBufferSize);
	
	// strip off if the start of the URL matches pRootDir
	if (pRootDir[0] != 0)
	{
		if (_strnicmp(pRootDir, pURL, strlen(pRootDir)) == 0)
		{
			strcpy_s(pURL, pURL+strlen(pRootDir)-1);
		}
	}
	
	// Now look at the URL. It can contain the following:
	//		/A12345
	//		/h2g2/A12345
	//		/h2g2/servicename/A12345
	//		/h2g2/servicename/skinname/A12345

	// So we keep stripping off stuff until we run out of directory names

	// Find the first slash *after* the initial directory name 
	char* pSlash = FindEndslash(pURL);

	bool bGotSiteInfo = false;

	// Simply pass through anything starting /dna/-/
	if (_strnicmp(pURL,"/dna/-/",7) == 0)
	{
		pHeaderInfo->SetHeader(pCtxt->m_pFC, "url", pURL + 6);

		return SF_STATUS_REQ_HANDLED_NOTIFICATION;
	}
	
	if (pSlash != NULL)
	{
		// If we found a slash, then remove the subdirectory - it's /h2g2/
		if (_strnicmp(pURL, "/dna/",5) == 0)
		{
			strcpy_s(pURL, pSlash);

			// Now see if there's another one - this one will be the service name
			pSlash = FindEndslash(pURL);
			if (pSlash != NULL)
			{
				// Found a servicename, which goes from pURL+1 to pSlash-1
				// so copy that to pServiceName
				strncpy_s(pServiceName, pURL+1, pSlash - (pURL+1));
				pServiceName[pSlash-(pURL+1)] = 0;

				// Now strip it off as well
				strcpy_s(pURL, pSlash);

				bGotSiteInfo = true;
				// Now look for a skin name
				pSlash = FindEndslash(pURL);
				if (pSlash != NULL)
				{
					// Found a skinname
					// so copy that
					strncpy_s(pSkinName, pURL+1, pSlash - (pURL+1));
					pSkinName[pSlash-(pURL+1)] = 0;

					// Now strip it off as well
					strcpy_s(pURL, pSlash);
				}
			}
			else	// No endslash but we're expecting a service name so assume an omitted endslash
			{
				strcpy_s(pServiceName, pURL+1);
				strcpy_s(pURL, "/");
			}
		}
	}

/*
    CHECK TO SEE IF WE NEED TO REDIRECT
*/
	Result = RegQueryValueEx(   m_RegKeyRedirects,
								pServiceName,
								NULL,		// lpReserved. Reserved; must be NULL. 
								&KeyType,
								(LPBYTE)pDestURL, // The URL we ultimately return.
								&dwBufferSize);
									
    if (Result == ERROR_SUCCESS)
    {
        BOOL bRedirect = TRUE;
        
        char* pParamCopy = strstr(pDestURL,"$");
        if (pParamCopy != NULL)
        {
            if (strstr(pDestURL,"http") != NULL)
            {
                strncpy_s(pDestURL,pDestURL,pParamCopy-pDestURL);
                if (pURL != NULL)
                {
                    strcat_s(pDestURL,pURL);
                }
            }
            else
            {
                // We want to replace the service name, not redirect
                strncpy_s(pServiceName,pDestURL,pParamCopy-pDestURL);
                bRedirect = FALSE;
            }
        }
        
        if (bRedirect)
        {
            char szTemp[URL_BUFFER_SIZE];
            wsprintf(szTemp, "Location: %s\r\n\r\n",pDestURL);

            pCtxt->ServerSupportFunction (  SF_REQ_SEND_RESPONSE_HEADER,
                                            (PVOID) "302 Redirect",
                                            (LPDWORD) szTemp,
                                            0); 

            pHeaderInfo->SetHeader(pCtxt->m_pFC, "url", pDestURL);
           
            return SF_STATUS_REQ_FINISHED_KEEP_CONN;
        }
    }


	// *** strip off leading directory
	
/*
	char* pFirstSlash = strchr( pURL+1, '/');
	if ( pFirstSlash != NULL)
	{
		// Make sure the / is only part of the pathname and isn't after parameters
		char* pQuery = strchr( pURL, '?');
		char* pAmpersand = strchr( pURL, '&');
		
		// If we found an ampersand or a query, they *must* be after the first slash
		// otherwise the slash is part of a parameter and must be ignored
		if (((pQuery == NULL) || (pFirstSlash < pQuery)) && ((pAmpersand == NULL) || (pFirstSlash < pAmpersand)))
		{
			// Strip off root dir, leaving the last /
			strcpy_s(pURL, strchr(pURL + 1, '/'));
		}
	}
*/

	// Ensure that the numeric ID is empty.
	
	*pNumericID = NULL;

	
	// Try to identify whether Prefix is numeric-terminated or query-terminated.

	char* pPostPrefix = CopyNonMatching(pPrefix, pURL, DIGITS );
	
	// pPrefix could now be pointing at ...
	//
	// 'Prefix'			(eg from /Prefix0123456789), or ...
	// 'Prefix?value='	(eg from /Prefix?value=0123456789)
	//
	// In either case, pPostPrefix will be pointing at 0123456789
	
	// Look up expecting to be numeric-terminated.

	// 
	// Use the prefix to find matching keys in the registry.
	//

	bool bModifiedURL = FALSE;
	
	dwBufferSize = URL_BUFFER_SIZE;

	Result = RegQueryValueEx(	hRegKeyPrefixes,
									pPrefix,
									NULL,		// lpReserved. Reserved; must be NULL. 
									&KeyType,
									(LPBYTE)pDestURL, // The URL we ultimately return.
									&dwBufferSize);

	if ( Result == ERROR_SUCCESS )
	{
		// For the lookup to have succeded, the string must have been numeric-terminated.

		// Keep a copy of all the numerals *following* the prefix,
		// updating pPostPrefix to point after the last digit.

		pPostPrefix = CopyMatching(pNumericID, pPostPrefix, DIGITS );
		
		// pDestURL now holds a URL from the registry of the form /showbinary.cgi?id=
		// We append the numeric ID to give /showbinary.cgi?id=XXXXXX
	
		EventLog("Numeric ID or null-terminated prefix found", EVENTLOG_INFORMATION_TYPE);
		
		strcat_s(pDestURL, pNumericID);

		// Hurrah! 
		bModifiedURL = TRUE;
			
	}
	else
	{
		// The lookup failed as there are no valid prefixes terminated by numbers.

		EventLog("No numeric-terminated Prefix found.", EVENTLOG_INFORMATION_TYPE);

		// So, let's see if the string is query-terminated.

		pPostPrefix = CopyNonMatching(pPrefix, pURL, "?");

		// pPrefix could now be pointing at ...
		//
		// 'Prefix'	(eg from /Prefix?value=0123456789)
		// 
		// Look up expecting to be query-terminated.

		dwBufferSize = URL_BUFFER_SIZE;
		Result = RegQueryValueEx(	hRegKeyPrefixes,
										pPrefix,
										NULL,		// lpReserved. Reserved; must be NULL. 
										&KeyType,
										(LPBYTE)pDestURL, // The URL we ultimately return.
										&dwBufferSize);


		// If we failed, then there are no valid prefixes to match, 
		// and we exit now, with no modifications made.

		if ( Result != ERROR_SUCCESS )
		{
			EventLog("No query-terminated Prefix found.", EVENTLOG_INFORMATION_TYPE);
		
			// OK, so see if the string is one we accept as a key article
			// meaning it contains 0-9A-Z and -.
			if (pPrefix[0] == '/')
			{
				size_t LastValid = strspn(pPrefix + 1, "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-");
				if (pPrefix[LastValid + 1] != 0)
				{
				//	if (bGotSiteInfo)
				//	{
				//		strcpy_s(pDestURL, pURL);
				//	}
				//	else
				//	{
						return SF_STATUS_REQ_NEXT_NOTIFICATION;
				//	}
				}
				else
				{
					dwBufferSize = URL_BUFFER_SIZE;
					Result = RegQueryValueEx(	hRegKeyPrefixes,
													"-KeyArticle",
													NULL,		// lpReserved. Reserved; must be NULL. 
													&KeyType,
													(LPBYTE)pDestURL, // The URL we ultimately return.
													&dwBufferSize);
					if (Result != ERROR_SUCCESS)
					{
						strcpy_s(pDestURL, "/ripleyserver.dll?article?name=");
					}
					strcat_s(pDestURL,pPrefix + 1);
					strcat_s(pDestURL, "&");
				}
			}
			else
			{
				return SF_STATUS_REQ_NEXT_NOTIFICATION;
			}
		}

		// Otherwise we carry on, having modified the destination URL, 
		// with pPrefix holding a valid key, and pPostPrefix pointing at anything afterwards.

		// Hurrah! 
		bModifiedURL = TRUE;


	}

	// If there was something following the prefix (and the numeric ID if 
	// there's one of those too), then append it to the final URL.
	
	if ( bModifiedURL && (*pPostPrefix != NULL ))
	{
		// Append " & option=";

		strcat_s(pDestURL, "&option=");

		// Append the remainder of the input string, changing any '?' to '&'

		char* pDestEnd = pDestURL + strlen(pDestURL);
		ASSERT(*pDestEnd == NULL);

		while ( *pPostPrefix != NULL )
		{
			if ( *pPostPrefix == '?' )
			{
				*pDestEnd = '&';
			}
			else
			{
				*pDestEnd = *pPostPrefix;
			}

			pPostPrefix++;
			pDestEnd++;

		}

		*pDestEnd = NULL;
	}

	char* pTerm = pDestURL + strlen(pDestURL) - 1;
	
	if (bModifiedURL && pSkinName[0] != 0)
	{
		if (*pTerm != '&' && *pTerm != '?')
		{
			strcat_s(pDestURL, "&");
		}
		strcat_s(pDestURL, "_sk=");
		strcat_s(pDestURL, pSkinName);
		pTerm = pDestURL + strlen(pDestURL) - 1;
	}

	if (bModifiedURL && pServiceName[0] != 0)
	{
		if (*pTerm != '&' && *pTerm != '?')
		{
			strcat_s(pDestURL, "&");
		}
		strcat_s(pDestURL, "_si=");
		strcat_s(pDestURL, pServiceName);
	}

	// Check for over-ridden registry keys - UnCookied and Extensions
	// which hold pathnames of locally cached files etc.
	// 
	// We use the already-validated pPrefix found above.

	if ( *pNumericID != NULL )
	{
		CheckForCachedFiles(pDestURL, pPrefix, pNumericID, bCookie);
	}

	// Write back the new url to the header :-)


	if ( bModifiedURL )
	{
		EventLog(pDestURL, EVENTLOG_AUDIT_SUCCESS);
		
		bResult = pHeaderInfo->SetHeader(pCtxt->m_pFC, "url", pDestURL);

		if ( bResult )
		{
			return SF_STATUS_REQ_HANDLED_NOTIFICATION;
		}
		else
		{
			EventLog("Couldn't modify URL in header.", EVENTLOG_ERROR_TYPE);
		}

	}

	return SF_STATUS_REQ_NEXT_NOTIFICATION;
}

/******************************************************************************

	BOOL CH2g2Filter::CheckForCachedFiles(char* pDestURL, char* pPrefix, char* pNumericID, BOOL bCookie)
						 ,
	Author:		Sean Solle
	Created:	24/4/00
	Inputs:		Pointer to destination buffer to modify.
				Prefix string - e.g. 'B'
				Numeric ID of local cached files to search for - e.g. '1234'
				True/False of cookie.
				
	Outputs:	True if found a file, false if not.
	Purpose:	If we found a numeric ID, we check for over-ridden values
				these are locally cached files - blobs etc.

******************************************************************************/

BOOL CH2g2Filter::CheckForCachedFiles(char* pDestURL, char* pPrefix, char* pNumericID, BOOL bCookie)
{

	// At this point, we know pPrefix to exist as a valid key in the registry,
	// and that pNumericID is a non-empty numeric string.

	char pExtensions[ MAX_PATH ];

#if _DEBUG
	sprintf(pExtensions,"Searching for cached ID %s\n",pNumericID);
	EventLog(pExtensions, EVENTLOG_INFORMATION_TYPE);
	*pExtensions = NULL;
#endif

	
	BOOL bCookiesAreImportant = false;
	BOOL bDoExtensionMatching = false;

	// If there's a special UNCOOKIED key, we may need to return 
	// either /A/xxxxx.html or /AU/xxxxx.html for (un)registered users.

	if ( !bCookie )
	{
		DWORD KeyType, dwBufferSize = MAX_PATH;

		LONG Result = RegQueryValueEx(	m_RegKeyUnCookied,
										pPrefix,
										NULL,		// lpReserved. Reserved; must be NULL. 
										&KeyType,
										(LPBYTE)pExtensions,
										&dwBufferSize);

		// If we found a matching key then cookies are important, so we do uncookied extension matching.

		if ( Result == ERROR_SUCCESS )
		{
			bCookiesAreImportant = true;
			bDoExtensionMatching = true;

			EventLog("Able to match special Uncookied Extensions.", EVENTLOG_INFORMATION_TYPE);

		}

	}


	// Otherwise we check for an EXTENSIONS registry key (e.g. /B/xxxxxxx.jpg)
	
	if ( !bCookiesAreImportant )
	{
		// There wasn't an "uncookied" match, so it's not important that we have a cookie,
		// so we see if there's a normal extension (e.g. /B/xxxxx.jpg images),

		DWORD KeyType, dwBufferSize = MAX_PATH;
		
		LONG Result = RegQueryValueEx(	m_RegKeyExtensions,
										pPrefix,
										NULL,		// lpReserved. Reserved; must be NULL. 
										&KeyType,
										(LPBYTE)pExtensions,
										&dwBufferSize);

		// If we found a matching key then we can do extension matching.

		if ( Result == ERROR_SUCCESS )
		{
			bDoExtensionMatching = true;

			EventLog("Matching normal extensions.", EVENTLOG_INFORMATION_TYPE);

		}

	}

	//
	// If we didn't find any pathnames in the registry, don't try to filematch.
	//

	if ( bDoExtensionMatching )
	{
		// There's a key for extensions - pExtensions is the directory holding the files to match.

		// Append the numeric ID passed, and terminate with a wildcard extension,
		// e.g. "1234.*"

		strcat_s(pExtensions, pNumericID);
		strcat_s(pExtensions, ".*");

		EventLog(pExtensions, EVENTLOG_INFORMATION_TYPE);
		
		// Attempt to find a file that matches this wildcard.

		WIN32_FIND_DATA FindFileData;
		char pExt[_MAX_EXT];

		// If we find a file, append the extension to filename.

		if ( FindFirstFile(pExtensions, &FindFileData) != INVALID_HANDLE_VALUE )
		{
			EventLog(FindFileData.cFileName, EVENTLOG_INFORMATION_TYPE);

			_splitpath( FindFileData.cFileName, NULL, NULL, NULL, pExt );

			// Build a URL of the form /B/XXXXX.jpg or /AU/XXXXXX.html
			
			strcpy(pDestURL, pPrefix);

			// If it's important to distinguish that we're cookied, insert the 'U' (
			
			if ( bCookiesAreImportant && !bCookie )
			{
				strcat(pDestURL, "U");
			}

			// Append the rest of the URL
			strcat(pDestURL, "/");
			strcat(pDestURL, pNumericID);
			strcat(pDestURL, pExt);

			// Hurrah! 
			return TRUE;
		}

	}

	// We didn't match any cached files, so we return with destination URL or unmodified.

	return FALSE;

}


/******************************************************************************

	char* CH2g2Filter::CopyAsFarAs(char* pDest, char* pStart, char* pEnd)
						 ,
	Author:		Sean Solle
	Created:	23/2/99
	Inputs:		Destination, source start, source end.
	Purpose:	Copy all characters from pStart up to but EXCLUDING pEnd.
				Terminate string with a null.

******************************************************************************/


char* CH2g2Filter::CopyAsFarAs(char* pDest, char* pStart, char* pEnd)
{
	while ( pStart < pEnd )
	{
		*pDest = *pStart;
		pDest++;
		pStart++;
	}

	*pDest = NULL;

	return pDest;
}

/******************************************************************************

	char* CH2g2Filter::CopyMatching(char* pDest, char* pSrc, char* pMatches)
						 ,
	Author:		Sean Solle
	Created:	23/2/99
	Inputs:		Destination, source start, characters to match.
	Returns:	Pointer to the 1st non-matching char.
	Purpose:	Copy all characters from pSrc that also occur in pMatches
				Terminate string with a null.


******************************************************************************/


char* CH2g2Filter::CopyMatching(char* pDest, char* pSrc, char* pMatches)
{
	
	// Copy all matching chars.
	
	while ( (*pSrc != NULL) && strchr( pMatches, *pSrc ) )
	{
		*pDest = *pSrc;
		pDest++;
		pSrc++;
	}

	// Terminate string.
	
	*pDest = NULL;

	// Return pointer to 1st non-matching char.
	
	return pSrc;
}


/******************************************************************************

	char* CH2g2Filter::CopyNonMatching(char* pDest, char* pSrc, char* pMatches)
						 ,
	Author:		Sean Solle
	Created:	23/2/99
	Inputs:		Destination, source start, characters to match.
	Returns:	Pointer to the 1st non-matching char.
	Purpose:	Copy all characters from pSrc until a match is found.
				Terminate string with a null.


******************************************************************************/


char* CH2g2Filter::CopyNonMatching(char* pDest, char* pSrc, char* pMatches)
{
	
	// Copy until a matching char is found, or the end of the string.
	
	while ( (NULL != *pSrc) && !strchr( pMatches, *pSrc ) )
	{
		*pDest = *pSrc;
		pDest++;
		pSrc++;
	}

	// Terminate string.
	
	*pDest = NULL;

	// Return pointer to first matching char.
	
	return pSrc;
}

//DWORD CH2g2Filter::OnLog(CHttpFilterContext* pCtxt, PHTTP_FILTER_LOG pLog)
//{
//	return SF_STATUS_REQ_NEXT_NOTIFICATION;
//}

/******************************************************************************

	DWORD CH2g2Filter::OnPreprocHeaders(CHttpFilterContext* pCtxt ....
						 ,
	Author:		Sean Solle
	Created:	28/1/99
	Inputs:		None.
	Purpose:	Called by the framework to notify the filter 
				that the session is ending.

				Override this member function to provide your own end of session
				implementation. The default implementation does nothing.

******************************************************************************/

DWORD CH2g2Filter::OnEndOfNetSession(CHttpFilterContext* pCtxt)
{
	// Close the CH2g2Filter log.

	//BOOL bResult = CloseEventLog( m_hEventLog );

	// return the appropriate status code
	return SF_STATUS_REQ_NEXT_NOTIFICATION;
}


/******************************************************************************

	BOOL CH2g2Filter::EventLog( LPCTSTR lpString, WORD wEventType = EVENTLOG_INFORMATION_TYPE)
						 ,
	Author:		Sean Solle
	Created:	5/6/97
	Inputs:		None.
	Purpose:	Write a string out to the event log.

******************************************************************************/

BOOL CH2g2Filter::EventLog( LPCTSTR lpString, WORD wEventType)
{

	BOOL bResult = FALSE;

	// Now both release and debug builds log events.

	if ( m_bKeepAuditTrail || (wEventType==EVENTLOG_SUCCESS) || (wEventType==EVENTLOG_ERROR_TYPE) || (wEventType==EVENTLOG_WARNING_TYPE))
	{
	
		LPCTSTR *lpStrings = &lpString;
		LPVOID lpRawData = (LPVOID)&lpString;

		// Write the event out to the log.

		
		
		bResult = ReportEvent( m_hEventLog,  // handle returned by RegisterEventSource 
							wEventType,		// event type to log 

							42,			// event category source-specific information - can have any value
							42,			// DWORD dwEventID, event identifier 
 							NULL,		// user security identifier (optional) 

							1,			// number of strings to merge with message 
 							0,			// size of binary data, in bytes 


							lpStrings,	// array of strings to merge with message
							lpRawData	// address of binary data 

						); 
	}
	
	return bResult;
}


// Do not edit the following lines, which are needed by ClassWizard.
#if 0
BEGIN_MESSAGE_MAP(CH2g2Filter, CHttpFilter)
	//{{AFX_MSG_MAP(CH2g2Filter)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()
#endif	// 0

///////////////////////////////////////////////////////////////////////
// If your extension will not use MFC, you'll need this code to make
// sure the extension objects can find the resource handle for the
// module.  If you convert your extension to not be dependent on MFC,
// remove the comments arounn the following AfxGetResourceHandle()
// and DllMain() functions, as well as the g_hInstance global.

/****

static HINSTANCE g_hInstance;

HINSTANCE AFXISAPI AfxGetResourceHandle()
{
	return g_hInstance;
}

BOOL WINAPI DllMain(HINSTANCE hInst, ULONG ulReason,
					LPVOID lpReserved)
{
	if (ulReason == DLL_PROCESS_ATTACH)
	{
		g_hInstance = hInst;
	}

	return TRUE;
}

****/


DWORD CH2g2Filter::OnUrlMap(CHttpFilterContext* pfc, PHTTP_FILTER_URL_MAP pUrlMap) 
{
/*	// TODO: Add your specialized code here and/or call the base class
	char pPrefix[ URL_BUFFER_SIZE ];
	char pDigits[ URL_BUFFER_SIZE ];
	char pPathname[ URL_BUFFER_SIZE ];
	char* pURL = (char*)pUrlMap->pszURL;
	char* pPostPrefix = CopyNonMatching(pPrefix, pURL, DIGITS );

	if (stricmp("/B",pPrefix) == 0)
	{
		char* pPostNumeric = CopyMatching(pDigits, pPostPrefix, DIGITS);
		
		strcpy_s(pPathname, "E:\\blobcache\\");
		
		// If there's anything after the blob, it's a directory
		if (*pPostNumeric != '0')
		{
			strcat_s(pPathname, pPostNumeric);
			strcat_s(pPathname, "\\");
		}
		strcat_s(pPathname, pDigits);
		strcat_s(pPathname, ".*");

		WIN32_FIND_DATA fdData;

		HANDLE hFile = FindFirstFile(pPathname, &fdData);
		if (hFile != INVALID_HANDLE_VALUE)
		{
			// Found the file, so put its path into the output
			strcpy_s(pUrlMap->pszPhysicalPath, "E:\\blobcache\\");
			strcat_s(pUrlMap->pszPhysicalPath, pPostNumeric);
			strcat_s(pUrlMap->pszPhysicalPath, "\\");
			strcat_s(pUrlMap->pszPhysicalPath, fdData.cFileName);
		}
		pfc->AddResponseHeaders("Content-Type: image/gif");
		return SF_STATUS_REQ_HANDLED_NOTIFICATION;
	}
*/
	return CHttpFilter::OnUrlMap(pfc, pUrlMap);
}
