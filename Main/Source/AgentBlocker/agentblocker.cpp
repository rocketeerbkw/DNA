// AGENTBLOCKER.CPP - Implementation file for your Internet Server
//    agentblocker Filter

#include "stdafx.h"
#include "agentblocker.h"




CAgentList::CAgentList()
{
	InitializeCriticalSection(&m_criticalsection);
	for (int i = 0; i < MAX_AGENTS; i++)
	{
		*m_NameList[i] = '\0';
		m_LastAccess[i] = 0;
	}
}


CAgentList::~CAgentList()
{
	// Nothing more
}

void CAgentList::Initialise(DWORD ThrottlePeriod)
{
	m_ThrottlePeriod = ThrottlePeriod * 1000;
}

/*********************************************************************************

	bool CAgentList::IsAgentAllowed(const char* pAgentName)

	Author:		Jim Lynn
	Created:	12/02/2003
	Inputs:		pAgentName - useragent string we're searching for
	Outputs:	-
	Returns:	true if agent doesn't need to be throttled
				false if it's been here too much
	Purpose:	Maintains a list of throttled agent strings. Will keep track of
				the rate at which this agent is hitting the site. Current
				implementation will simply disallow more than one request within
				a number of seconds defined in the registry.

*********************************************************************************/

bool CAgentList::IsAgentAllowed(const char* pAgentName)
{
	bool bAllowed = false;

	EnterCriticalSection(&m_criticalsection);
	try
	{
		int WhichAgent = 0;
		bool FoundName = false;
		while ((WhichAgent < MAX_AGENTS) && !FoundName)
		{
			if (strcmp(pAgentName, m_NameList[WhichAgent]) == 0)
			{
				FoundName = true;
			}
			else if (*m_NameList[WhichAgent] == '\0')
			{
				break;
			}
			else
			{
				WhichAgent++;
			}
		}

		if (!FoundName)
		{
			// See if we can slot this name in

			if (strlen(pAgentName) < AGENT_LENGTH && (WhichAgent < MAX_AGENTS))
			{

				strcpy_s(m_NameList[WhichAgent], pAgentName);
				DWORD CurrentTime = GetTickCount();
				m_LastAccess[WhichAgent] = CurrentTime;
				bAllowed = true;
			}
			else
			{
				// Throttle because agent name is too long
				bAllowed = false;
			}
		}
		else
		{
			// Got a name - has enough time elapsed?
			DWORD CurrentTime = GetTickCount();
			DWORD PreviousTime = m_LastAccess[WhichAgent];

			// Cope with tickcount wrapping round...
			if (CurrentTime < PreviousTime)
			{
				// Wrapped, so I guess it's probably OK...
				bAllowed = true;
			}
			else if ((CurrentTime - PreviousTime) > m_ThrottlePeriod)
			{
				bAllowed = true;
			}
			else
			{
				bAllowed = false;
			}
			// Set the last access time
			if (bAllowed)
			{
				m_LastAccess[WhichAgent] = CurrentTime;
			}
		}

	}
	catch(...)
	{
		// Nothing
	}
	LeaveCriticalSection(&m_criticalsection);
	return bAllowed;
}

///////////////////////////////////////////////////////////////////////
// The one and only CAgentblockerFilter object

CAgentblockerFilter theFilter;


///////////////////////////////////////////////////////////////////////
// CAgentblockerFilter implementation

CAgentblockerFilter::CAgentblockerFilter()
{
	LONG Result;
	
	Result = RegOpenKeyEx( HKEY_LOCAL_MACHINE,
		 						"SOFTWARE\\The Digital Village\\h2g2 web server\\Agents",
								0,						// reserved
								KEY_READ,				// security access mask
								&m_hkAgents);	// address of handle of open key
	
	
	DWORD ThrottlePeriod = 20; // default to 20 seconds...
	HKEY hkWebKey;
	Result = RegOpenKeyEx( HKEY_LOCAL_MACHINE,
		 						"SOFTWARE\\The Digital Village\\h2g2 web server",
								0,						// reserved
								KEY_READ,				// security access mask
								&hkWebKey);	// address of handle of open key
	
	DWORD KeyType;
	DWORD dwBufferSize = sizeof(ThrottlePeriod);
	if (Result == ERROR_SUCCESS)
	{
		Result = RegQueryValueEx(	hkWebKey,
									"AgentThrottlePeriod",
									NULL,				// lpReserved. Reserved; must be NULL. 
									&KeyType,
									(LPBYTE)&ThrottlePeriod,	// The word value is 
									&dwBufferSize);
		if (Result != ERROR_SUCCESS)
		{
			ThrottlePeriod = 20;
		}
		RegCloseKey(hkWebKey);
	}

	m_AgentList.Initialise(ThrottlePeriod);

}

CAgentblockerFilter::~CAgentblockerFilter()
{
}

BOOL CAgentblockerFilter::GetFilterVersion(PHTTP_FILTER_VERSION pVer)
{
	// Call default implementation for initialization
	CHttpFilter::GetFilterVersion(pVer);

	// Clear the flags set by base class
	pVer->dwFlags &= ~SF_NOTIFY_ORDER_MASK;

	// Set the flags we are interested in
	pVer->dwFlags |= SF_NOTIFY_ORDER_LOW | SF_NOTIFY_SECURE_PORT | SF_NOTIFY_NONSECURE_PORT
			 | SF_NOTIFY_AUTHENTICATION | SF_NOTIFY_PREPROC_HEADERS | SF_NOTIFY_END_OF_NET_SESSION;

	// Load description string
	TCHAR sz[SF_MAX_FILTER_DESC_LEN+1];
	ISAPIVERIFY(::LoadString(AfxGetResourceHandle(),
			IDS_FILTER, sz, SF_MAX_FILTER_DESC_LEN));
	//_tcscpy(pVer->lpszFilterDesc, sz);
	_tcscpy(pVer->lpszFilterDesc, sz);
	return TRUE;
}

DWORD CAgentblockerFilter::OnPreprocHeaders(CHttpFilterContext* pCtxt,
	PHTTP_FILTER_PREPROC_HEADERS pHeaderInfo)
{
	// TODO: React to this notification accordingly and
	// return the appropriate status code
	char pUserAgent[ 1024 ];
	pUserAgent[0] = 0;
	DWORD buflen = 1024;
	pCtxt->GetServerVariable("HTTP_USER_AGENT", pUserAgent, &buflen);

	char* ptr = pUserAgent;
	while (*ptr != 0)
	{
		if (ptr[0] == ' ')
		{
			ptr[0] = '+';
		}
		ptr++;
	}

	DWORD dwDebug = 0;
	DWORD dwBufferSize = sizeof(dwDebug);
	DWORD KeyType;

	LONG Result = RegQueryValueEx(	m_hkAgents,
								pUserAgent,
								NULL,				// lpReserved. Reserved; must be NULL. 
								&KeyType,
								(LPBYTE)dwDebug,	// The word value is 
								&dwBufferSize);

	if (Result == ERROR_SUCCESS)
	{
		if (!m_AgentList.IsAgentAllowed(pUserAgent))
		{
			char szBuffer[1024];
			wsprintf(szBuffer, "Error: Too many requests have been made during a short time period so you have been blocked.");
			DWORD dwBuffSize = lstrlen(szBuffer);

			pCtxt->ServerSupportFunction(SF_REQ_SEND_RESPONSE_HEADER, "503 Service Unavailable", 0, 0);
			pCtxt->WriteClient(szBuffer, &dwBuffSize, 0);

			return SF_STATUS_REQ_FINISHED;
		}
	}
	
	return SF_STATUS_REQ_NEXT_NOTIFICATION;
}

DWORD CAgentblockerFilter::OnEndOfNetSession(CHttpFilterContext* pCtxt)
{
	// TODO: React to this notification accordingly and
	// return the appropriate status code
	return SF_STATUS_REQ_NEXT_NOTIFICATION;
}

DWORD CAgentblockerFilter::OnAuthentication(CHttpFilterContext* pCtxt,
	PHTTP_FILTER_AUTHENT pAuthent)
{
	// TODO: React to this notification accordingly and
	// return the appropriate status code
	return SF_STATUS_REQ_NEXT_NOTIFICATION;
}

// Do not edit the following lines, which are needed by ClassWizard.
#if 0
BEGIN_MESSAGE_MAP(CAgentblockerFilter, CHttpFilter)
	//{{AFX_MSG_MAP(CAgentblockerFilter)
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
