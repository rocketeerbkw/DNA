 // CGI.cpp: implementation of the CGI class.
//
//////////////////////////////////////////////////////////////////////

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
#include "tdvassert.h"
#include "TDVString.h"
#include "SmileyTranslator.h"
#include "RipleyServer.h"
#include <wininet.h>
#include "DBO.h"
#include "XSLT.h"
#include "vwcl\networking\vsmtpsocket.hpp"
#include <ProfileApi.h>
#include "SiteConfig.h"
#include "CGI.h"
#include "StoredProcedureBase.h"
#include "Config.h"
#include "emaillinebreak.h"
#include "Topic.h"
#include "usergroups.h"
#include "dynamiclists.h"
#include "SiteOptions.h"
#include "AutoCS.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


// the one and only smiley list instance - this is where the ascii sequence/name
// pairs for all the smilies will be loaded when the server is started up
CSmileyList CGI::m_Smilies;
CSmileyTranslator CGI::m_Translator;
//CTDVString CGI::m_sProfanities;
LONG CGI::m_ReqCount = 0;
bool CGI::m_bShowTimers = false;
CMimeExt CGI::m_MimeExt;
std::map<int, std::pair<CTDVString, CTDVString> > CGI::m_ProfanitiesMap;
std::map<int, CTDVString> CGI::m_AllowedURLListsMap;
std::map<int, int> CGI::m_SiteModClassMap;

// Log file related static vars
CRITICAL_SECTION CGI::s_CSLogFile;
DWORD CGI::s_CurLogFilePtr = 0;
CTDVString CGI::s_LastLogFile;


//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CMimeExt::CMimeExt()
{
	m_Map.insert(CMimesMap::value_type("image/gif", "gif"));
	m_Map["image/pjpeg"] = "jpg";
	m_Map["image/jpeg"] = "jpg";
	m_Map["image/bmp"] = "bmp";
	m_Map["application/x-shockwave-flash"] = "swf";
}


CGI::CGI() :					m_pSiteList(NULL),
								m_pSiteOptions(NULL),
								m_pDynamicLists(NULL),
								m_pUserGroups(NULL),
								m_pOutputContext(NULL), 
								//m_pCtxt(NULL), 
								m_pStatistics(NULL),
								m_pCurrentUser(NULL), 
								m_bPreModeration(false),
								m_bWasInitialisedFromDatabase(false),
								m_bNoAutoSwitch(false),
								m_SiteID(0),
								m_ThreadOrder(0),
								m_ThreadEditTimeLimit(0),
								m_pProfilePool(NULL),
								m_bFastBuilderMode(false),
								m_bSiteListInitialisedFromDB(false),
								m_bDatabaseAvailable(false),
								m_bPreviewMode(false),
								m_bTimeTransform(false),
								m_AllowRemoveVote(0), 
								m_IncludeCrumbtrail(0),
								m_AllowPostCodesInSearch(0),
								m_bQueuePostings(false),
								m_bSiteEmergencyClosed(false)
{
	m_TickStart = GetTickCount();
	m_LastEventTime = m_TickStart;
	m_InputContext.SetCgi(this);
}

CGI::CGI(const CGI& other) :	m_pSiteList(other.m_pSiteList),
								m_pSiteOptions(other.m_pSiteOptions),
								m_pDynamicLists(other.m_pDynamicLists),
								m_pUserGroups(other.m_pUserGroups),
								m_ServerName(other.m_ServerName),
								m_DefaultSkinPreference(other.m_DefaultSkinPreference),
								m_DomainName(other.m_DomainName),
								m_Connection(other.m_Connection),
								m_WriteConnection(other.m_WriteConnection),
								//That's right, copies the pointers, and it's bad
								//and the only reason it does not break is because of the
								//way it's used. The only copy operations which take place
								//are those copying from master instance and it does have
								//the pointers set to NULL. Surely this code needs to be
								//changed if the pattern of user changes.
								m_pOutputContext(other.m_pOutputContext),
								m_pCurrentUser(other.m_pCurrentUser),
								m_pECB(other.m_pECB),
								m_pStatistics(other.m_pStatistics),
								m_Query(other.m_Query),
								m_Command(other.m_Command),
								m_SiteID(other.m_SiteID),
								m_SiteName(other.m_SiteName),
								m_SkinName(other.m_SkinName),
								m_bPreModeration(other.m_bPreModeration),
								m_bWasInitialisedFromDatabase(false),
								m_bNoAutoSwitch(other.m_bNoAutoSwitch),
								m_SiteDescription(other.m_SiteDescription),
								m_pProfilePool(other.m_pProfilePool),
								m_SiteConfig(other.m_SiteConfig),
								m_sTopicsXML(other.m_sTopicsXML),
								m_ThreadOrder(other.m_ThreadOrder),
								m_ThreadEditTimeLimit(other.m_ThreadEditTimeLimit),
								m_bFastBuilderMode(other.m_bFastBuilderMode),
								m_bSiteListInitialisedFromDB(other.m_bSiteListInitialisedFromDB),
								m_bDatabaseAvailable(other.m_bDatabaseAvailable),
								m_bPreviewMode(other.m_bPreviewMode),
								m_bTimeTransform(other.m_bTimeTransform),
								m_AllowRemoveVote(other.m_AllowRemoveVote), 
								m_IncludeCrumbtrail(other.m_IncludeCrumbtrail),
								m_AllowPostCodesInSearch(other.m_AllowPostCodesInSearch),
								m_sRipleyServerInfoXML(other.m_sRipleyServerInfoXML),
								m_IPAddress(other.m_IPAddress),
								m_bQueuePostings(other.m_bQueuePostings),
								m_bSiteEmergencyClosed(other.m_bSiteEmergencyClosed),
								m_SSOService(other.m_SSOService)
{
	m_TickStart = GetTickCount();
	m_LastEventTime = m_TickStart;
	m_pECB = NULL;

	m_InputContext.SetCgi(this);
}

/*********************************************************************************

	bool CGI::Initialise(CHttpServerContext* pECB, LPTSTR pszQuery, LPTSTR pszCommand)

	Author:		Jim Lynn
	Created:	25/02/2000
	Inputs:		pCtxt - ptr to MFC-specific server context object
				pszQuery - query string
				pszCommand - command
	Outputs:	-
	Returns:	true if initialisation succeeded, false if it failed.
	Purpose:	Platform-specific initialisation of the CGI object. Gives the
				CGI object all the information the server has about the current
				request, so that it can perform all its necessary methods.

*********************************************************************************/

bool CGI::Initialise(EXTENSION_CONTROL_BLOCK* pECB, const TDVCHAR* pszQuery, LPTSTR pszCommand)
{
	
	try
	{
		m_pECB = pECB;
		m_Query = pszQuery;
		m_Command = pszCommand;

		StartInputLog();

		// handle multi-part form data
		CTDVString sCType;
		GetServerVariable("CONTENT_TYPE", sCType);
		CTDVString sCLength;
		GetServerVariable("CONTENT_LENGTH", sCLength);
		m_ContentLength = atoi(sCLength);
		m_pActualQuery = pszQuery;
		m_sBoundary.Empty();
		if (sCType.FindText("multipart/form-data") == 0)
		{
			int iBoundPos = sCType.FindText("boundary=") + 9;
			int iEndBoundary = sCType.GetLength();
			if (iEndBoundary > iBoundPos)
			{
				m_sBoundary = "--";
				m_sBoundary << sCType.Mid(iBoundPos, iEndBoundary - iBoundPos);
				const char* iPos = 0;
				CTDVString sName;
				CTDVString sType;
				int iLength;
				m_Query = "";
				CTDVString sData;
				while (FindDataSection(&iPos, &sName, &iLength, &sType))
				{
					sName.Replace("&","%26");
					sName.Replace("?","%3F");
					if (sType.GetLength() == 0)
					{
						// only append fields which aren't files
						sData.Empty();
						sData.AppendChars(iPos, iLength);
						sData.Replace("&","%26");
						sData.Replace("?","%3F");
						if (m_Query.GetLength() > 0)
						{
							m_Query << "&";
						}
						m_Query << sName << "=" << sData;
					}
					else
					{
						// Create some useful params for the file info
						// paramname_type
						// paramname_size
						sType.Replace("&","%26");
						sType.Replace("/","%2F");
						sType.Replace("?","%3F");
						if (m_Query.GetLength() > 0)
						{
							m_Query << "&";
						}
						m_Query << sName << "_type=" << sType << "&";
						m_Query << sName << "_size=" << iLength;
					}
				}
			}
		}
		
		// Sometimes the rightmost character of the command is a ?
		int iQMark = m_Command.Find('?');
		if (iQMark > 0)
		{
			m_Query << "&" << m_Command.Mid(iQMark + 1);
			m_Command = m_Command.Left(iQMark);
		}

		m_pOutputContext = new COutputContext(this);
	}
	catch (...)
	{
		delete m_pOutputContext;
		m_pOutputContext = NULL;
		return false;
	}

	// if we get a NotFound
	if (m_Query.Left(11) == "404;http://")
	{
		int pos = 11;
		while (pos < m_Query.GetLength() && m_Query.GetAt(pos) != '/')
		{
			pos++;
		}
		m_Query = m_Query.Mid(pos+1);
		m_Command = "article";
		m_Query = "name=" + m_Query;
	}
	
	GetParamString("_sk", m_SkinName);
	if (ParamExists("skin"))
	{
		CTDVString tskin;
		GetParamString("skin", tskin);
		if (tskin.GetLength() > 0)
		{
			m_SkinName = tskin;
		}
	}

	if (!GetParamString("_si", m_SiteName))
	{
		m_SiteName = "h2g2";
	}
	
	GetParamString("__ip__",m_IPAddress);

	//CTDVString sDefaultSkin;
	if (m_bSiteListInitialisedFromDB == false) 
	{
		// Don't go any further if the DB is not ready
		return false;
	}
	m_pSiteList->GetSiteDetails(m_SiteName, &m_SiteID, &m_bPreModeration, 
						&m_DefaultSkinPreference, &m_bNoAutoSwitch, &m_SiteDescription, 
						NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL, &m_SiteConfig, &m_ThreadOrder, NULL, 
						&m_ThreadEditTimeLimit, NULL, &m_AllowRemoveVote, &m_IncludeCrumbtrail, &m_AllowPostCodesInSearch,
						&m_bQueuePostings, &m_bSiteEmergencyClosed, &m_SSOService);

	m_pSiteList->GetTopicsXML(m_SiteID,m_sTopicsXML);

	CTDVString sCmd;
	m_InputContext.GetCommand(sCmd);

	// Check to see if we're going to use a fast builder
	if (sCmd.Find("FAST_") == 0 || IsRequestForCachedFeed())
	{
		// We have a fast builder or a request for a feed so set the flag
		m_bFastBuilderMode = true;
	}

	// Set the preview mode flag
	m_bPreviewMode = (GetParamInt("_previewmode") == 1);

	m_bTimeTransform = (GetParamInt("_ttrans") == 1);
	
	return true;

}


/*********************************************************************************

	bool CGI::InitUser()

		Author:		Mark Neves
        Created:	12/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Initialises the user-related aspects of the CGI object

					This was all done in the Initialise() function.  I've just taken the code out of that
					function and put it in here.

*********************************************************************************/

bool CGI::InitUser()
{
	bool bValidSignInObject = false;
	CTDVString sServiceName = m_SSOService;
	CTDVString sSignInSystem = "SSO-Signin - ";
	if (m_InputContext.GetSiteUsesIdentitySignIn(m_SiteID))
	{
		sSignInSystem = "IDENTITY-Signin - ";
		sServiceName = m_pSiteList->GetSiteIdentityPolicy(m_SiteID);
	}
	LogTimerEvent(sSignInSystem + "Creating User");

	try
	{
		if (!m_pProfilePool->GetConnection(m_ProfileConnection,GetSiteUsesIdentitySignIn(m_SiteID), GetIPAddress()))
		{
			throw "Unable to Initialise Profile Connection";
		}
		bValidSignInObject = true;

		if (ParamExists("logsignin") || theConfig.UseExtraSigninlogging())
		{
			WriteInputLog(CTDVString("SIGNIN ") + m_ProfileConnection.GetLastTimings());
		}
	}
	catch (...)
	{
		WriteInputLog(sSignInSystem << " ERROR : " << m_ProfileConnection.GetErrorMessage());		
		if (m_ProfileConnection.IsInitialised())
		{
			m_ProfileConnection.ReleaseConnection();
		}
		return false;
	}

	CTDVString sCmd;
	m_InputContext.GetCommand(sCmd);

	// if you are a blob then don't create the user. Check for fast builders too!
	if (!sCmd.CompareText("BLOB") && !m_bFastBuilderMode && bValidSignInObject)
	{
		WriteInputLog("SSOSTART");
		DWORD ssostart = GetTickCount();
		bool bRet = m_ProfileConnection.SetService(sServiceName, this);		
		
		//if this fails we should keep going but output a debug error message
		if (!bRet)
		{
			TDVASSERT(false,"In CGI::Initialise() failed to set the service name");
		}
		
		//always create the user
		int duration = GetTickCount() - ssostart;
		CTDVString sMessage;
		sMessage << "SSOEND " << duration;
		WriteInputLog(sMessage);
		CreateCurrentUser();
	}

	if (m_pCurrentUser != NULL)
	{
		LogTimerEvent(sSignInSystem + "Created User " + CTDVString(m_pCurrentUser->GetUserID()));
	}
	else
	{
		LogTimerEvent(sSignInSystem + "Created User");
	}

	return true;
}


/*********************************************************************************

	CGI::~CGI()

	Author:		Jim Lynn
	Created:	25/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	destructor for the CGI class. deletes all the context objects
				it created in its initialisation.

*********************************************************************************/

CGI::~CGI()
{
#ifdef _DEBUG
	if (!CRipleyServerExtension::IsShuttingDown())
	{
		// Don't write this out if shutting down, because we can't guarantee that the
		// config object is around at this point, because in debug builds object memory is 
		// automatically vaped on destruction, therefore it will write to the wrong place.
		// In fact, it ends up writing a log file in the System32 Windows folder!
		WriteInputLog("CLOSE");
	}
#else
	// In release builds it works because the config object doesn't automatically get
	// vaped during closure
	WriteInputLog("CLOSE");
#endif
	delete m_pOutputContext;
	m_pOutputContext = NULL;
	delete m_pCurrentUser;
	m_pCurrentUser = NULL;
	m_ProfileConnection.ReleaseConnection();

	DeleteInitDatabaseObjects();
}

/*********************************************************************************

	void CGI::DeleteInitDatabaseObjects()

		Author:		Mark Neves
        Created:	21/07/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Deletes any objects that may have been created as a result of a call
					to InitialiseFromDatabase();

*********************************************************************************/

void CGI::DeleteInitDatabaseObjects()
{
	// Only allow the Master CGI object delete these resources
	if (m_bWasInitialisedFromDatabase)
	{
		if (m_pSiteList != NULL)
		{
			delete m_pSiteList;
			m_pSiteList = NULL;
		}
		
		if (m_pSiteOptions != NULL)
		{
			delete m_pSiteOptions;
			m_pSiteOptions = NULL;
		}
		
		if (m_pProfilePool != NULL)
		{
			delete m_pProfilePool;
			m_pProfilePool = NULL;
		}
		
		if (m_pUserGroups != NULL)
		{
			delete m_pUserGroups;
			m_pUserGroups = NULL;
		}

		if (m_pDynamicLists != NULL)
		{
			delete m_pDynamicLists;
			m_pDynamicLists = NULL;
		}

		if ( m_pStatistics != NULL )
		{
			delete m_pStatistics;
			m_pStatistics = NULL;
		}
	}
}

/*********************************************************************************

	int CGI::GetParamInt(const TDVCHAR* pName, int iIndex)

	Author:		Jim Lynn
	Created:	24/02/2000
	Inputs:		pName - case insensitive name of parameter to find
				iIndex - optional index indicating which parameter to fetch from
					multiple ones sharing the same name
	Outputs:	-
	Returns:	Integer value of parameter or 0 if not found
	Purpose:	looks at the query string and finds the named parameter, and
				returns its integer value. If an index is supplied then that
				number of matches are skipped before returning the next parameter.

*********************************************************************************/

int CGI::GetParamInt(const TDVCHAR* pName, int iIndex)
{
	CTDVString string;
	if (GetParamString(pName, string, iIndex))
	{
		return atoi(string);
	}
	else
	{
		return 0;
	}
}

/*********************************************************************************

	bool CGI::ParamExists(const TDVCHAR* pName, int iIndex)

	Author:		Kim Harries
	Created:	16/03/2000
	Inputs:		pName - case insensitive name of parameter to find
				iIndex - optional index indicating which parameter to check for the
					existence of in the case of multiple parameters with the same
					name.
	Outputs:	-
	Returns:	true if paramter of that name exists, false otherwise.
	Purpose:	looks at the query string and sees if the named parameter exists.
				If iIndex is given then skips this number of matching parameters
				before checking for another one.

*********************************************************************************/

bool CGI::ParamExists(const TDVCHAR* pName, int iIndex)
{
	TDVASSERT(iIndex >= 0, "iIndex < 0 in CGI::ParamExists(...)");
	// if invalid index given then fail
	if (iIndex < 0)
	{
		return false;
	}

	CTDVString	sQuery = m_Query;
	CTDVString	sTemp = pName;
	int			iCount = 0;
	int			iStart = -1;
	bool		bExists = false;

	// all parameters will have an equals sign after them
	sTemp = sTemp + "=";
	// loop through counting each match until the appropriate number is found
	// then set the bExists varialbe if the parameter exists
	do
	{
		// search for an occurence of the temp string after the last one found
		iStart = sQuery.FindText(sTemp, iStart + 1);
		// if we have found something that is a parameter then increment the counter
		// must check beginning of param for & or ? if we are searching for a specific
		// name to prevent matching params with a longer but similar name
		if (iStart >= 0 && (iStart == 0 || m_Query[iStart-1] == '&' || m_Query[iStart-1] == '?'))
		{
			if (iCount == iIndex)
			{
				bExists = true;
			}
			iCount++;
		}
	} while (iStart >= 0 && !bExists);
	// return if the parameter was found
	if (!bExists)
	{
		// check for img buttons
		sTemp = pName;
		sTemp << ".x=";
		iStart = -1;
		iCount = 0;
		do
		{
			// search for an occurence of the temp string after the last one found
			iStart = sQuery.FindText(sTemp, iStart + 1);
			// if we have found something that is a parameter then increment the counter
			// must check beginning of param for & or ? if we are searching for a specific
			// name to prevent matching params with a longer but similar name
			if (iStart >= 0 && (iStart == 0 || m_Query[iStart-1] == '&' || m_Query[iStart-1] == '?'))
			{
				if (iCount == iIndex)
				{
					bExists = true;
				}
				iCount++;
			}
		} while (iStart >= 0 && !bExists);

	}
	return bExists;

/*
old code...

	CTDVString Query = m_Query;
	CTDVString temp = pName;
	temp = temp + "=";

	long start = Query.FindText(temp);
	if (start >= 0)
	{
		if (start == 0)
		{
			return true;
		}
		else if (m_Query[start-1] == '&' || m_Query[start-1] == '?')
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		return false;
	}
*/
}

/*********************************************************************************

	bool CGI::GetParamString(const TDVCHAR* pName, CTDVString& sResult, int iIndex)

	Author:		Jim Lynn
	Created:	24/02/2000
	Inputs:		pName - name of parameter to find (case insensitive)
				iIndex - optional index indicating which parameter to fetch in
					the case of multiple parameters with the same name.
	Outputs:	sResult - contains the value of the parameter found
	Returns:	true if parameter found, false otherwise
	Purpose:	Looks at the incoming query and finds the given parameter,
				putting its value into sResult. If it doesn't find the parameter
				it returns false, and sResult is set to an empty string.

*********************************************************************************/

bool CGI::GetParamString(const TDVCHAR* pName, CTDVString& sResult, int iIndex, bool bPrefix, CTDVString* pParamName)
{
	TDVASSERT(iIndex >= 0, "iIndex < 0 in CGI::GetParamString(...)");
	// if invalid index given then fail
	if (iIndex < 0)
	{
		sResult = "";
		return false;
	}

	CTDVString	sQuery = m_Query;
	CTDVString	sTemp = pName;
	int			iCount = 0;
	int			iStart = -1;
	bool		bExists = false;


	// all parameters will have an equals sign after them
	sTemp = sTemp + "=";
	// loop through counting each match until the appropriate number is found
	// then set the bExists varialbe if the parameter exists and fetch it's
	// value into sResult
	do
	{
		// search for an occurence of the temp string after the last one found
		if (!bPrefix)
		{
			iStart = sQuery.FindText(sTemp, iStart + 1);
		}
		else
		{
			iStart = sQuery.FindText(pName, iStart + 1);
			if (iStart >=0)
			{
				int iEnd = iStart;
				while (iEnd < sQuery.GetLength() && sQuery.GetAt(iEnd) != '=')
				{
					iEnd++;
				}
				sTemp = sQuery.Mid(iStart, iEnd - iStart);
				if (pParamName != NULL)
				{
					*pParamName = sTemp;
				}
				sTemp = sTemp + "=";
			}
		}

		// if we have found something that is a parameter then increment the counter
		// must check beginning of param for & or ? if we are searching for a specific
		// name to prevent matching params with a longer but similar name
		if (iStart >= 0 && (iStart == 0 || m_Query[iStart-1] == '&' || m_Query[iStart-1] == '?'))
		{
			// if we have got to the parameter we are looking for then process it
			if (iCount == iIndex)
			{
				// set this so we will exit the loop
				bExists = true;
				iStart += sTemp.GetLength(); // skip the name and equals sign
				int iEnd = iStart;

				// find the end of the parameter by looking for the beginning of the next one
				while (iEnd < sQuery.GetLength() && sQuery.GetAt(iEnd) != '&' && sQuery.GetAt(iEnd) != '?')
				{
					iEnd++;
				}
				// if -1 then the whole string matches, i.e. this is the last parameter
				if (iEnd < 0)
				{
					sQuery = sQuery.Mid(iStart);
				}
				else
				{
					sQuery = sQuery.Mid(iStart, iEnd - iStart);
				}
				sResult = sQuery;
				UnEscapeString(&sResult);
			}
			iCount++;
		}
	} while (iStart >= 0 && !bExists);
	// if not found then set the result string to empty
	if (!bExists)
	{
		sResult = "";
	}
	
	// Fix any illegal characters from the input
	sResult.RemoveDodgyChars();
	
	// return if the parameter was found
	return bExists;

/*
old code...
	
	CTDVString Query = m_Query;
	CTDVString temp = pName;
	temp = temp + "=";

	long start = Query.FindText(temp);
	if (start >= 0)
	{
		start += temp.GetLength(); // skip the name and equals sign
		int end = start;
		while (end < Query.GetLength() && Query.GetAt(end) != '&')
		{
			end++;
		}

		// if -1 then the whole string matches
		if (end < 0)
		{
			Query = Query.Mid(start);
		}
		else
		{
			Query = Query.Mid(start,end-start);
		}
		sResult = Query;
		UnEscapeString(&sResult);
		return true;
	}
	else
	{
		sResult = "";
		return false;
	}
*/
}

bool CGI::GetParamFile(const TDVCHAR* pName, int iAvailableLength, char* pBuffer, 
	int& iLength, CTDVString& sMime)
{
	if (!pBuffer) 
	{
		return false;
	}

	const char* pSection;
	if (FindNamedDataSection(pName, &pSection, &iLength, &sMime))
	{
		if (iLength > iAvailableLength)	
		{
			//simply return - calling code must check iLength
			//against iAvailableLength and if latter is less 
			//it means that content was not copied
			return true;
		}
		memcpy(pBuffer, pSection, iLength);
		return true;
	}
	
	return false;
}

bool CGI::GetParamFilePointer(const TDVCHAR* pName, const char** pBuffer, int& iLength, CTDVString& sMime, CTDVString *sFilename)
{
	if (FindNamedDataSection(pName, pBuffer, &iLength, &sMime, sFilename ))
	{
		return true;
	}
	
	return false;
}

/*********************************************************************************

	int CGI::GetParamCount(const TDVCHAR* pName = NULL)

	Author:		Kim Harries
	Created:	21/11/2000
	Inputs:		pName - case insensitive name of parameter to count the
					number of occurences of
	Outputs:	-
	Returns:	The total number of parameters with that name
	Purpose:	Counts the total number of parameters in the query string with the
				given name. If pName is NULL (the default value) then counts the
				total number of parameters.

*********************************************************************************/

int CGI::GetParamCount(const TDVCHAR* pName)
{
	CTDVString	sQuery = m_Query;
	CTDVString	sTemp = pName;
	int			iCount = 0;
	int			iStart = -1;

	// all parameters will have an equals sign after them - all equals signs
	// inside parameter values should have been escaped out, so searching for
	// just and equals sign should count all parameters
	sTemp = sTemp + "=";
	// loop through counting each match until there aren't any more
	do
	{
		// search for an occurence of the temp string after the last one found
		iStart = sQuery.FindText(sTemp, iStart + 1);
		// if we have found something that is a parameter then increment the counter
		// must check beginning of param for & or ? if we are searching for a specific
		// name to prevent matching params with a longer but similar name
		if (iStart >= 0 && (iStart == 0 || m_Query[iStart-1] == '&' || m_Query[iStart-1] == '?' || sTemp.CompareText("=")))
		{
			iCount++;
		}
	} while (iStart >= 0);
	// return the number of occurences found
	return iCount;
}

/*********************************************************************************

	CInputContext& CGI::GetInputContext()

	Author:		Jim Lynn
	Created:	25/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	ptr to this object's input context
	Purpose:	Gives a pointer to an inputcontext object to the caller, which
				it can use to interrogate the input for things like params, domain
				names, commands, etc. The object remains the property of the CGI
				object and must not be deleted.

*********************************************************************************/

CInputContext& CGI::GetInputContext()
{
	return m_InputContext;
}

/*********************************************************************************

	COutputContext* CGI::GetOutputContext()

	Author:		Jim Lynn
	Created:	25/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	ptr to the output context
	Purpose:	Gives a pointer to an outputcontext object to the caller, through
				which the caller can talk to the server. The object remains the 
				property of the CGI object and must not be deleted by the caller.

*********************************************************************************/

COutputContext* CGI::GetOutputContext()
{
	return m_pOutputContext;
}



/*********************************************************************************

	CProfileApi* CGI::GetProfileApi()

	Author:		Dharmesh Raithatha
	Created:	9/11/2003
	Inputs:		-
	Outputs:	-
	Returns:	ptr to the profile api instance
	Purpose:	the profile api instance. The caller must not delete this pointer
				it remains the property of the CGI object. The Api should be 
				initialised and the service should be set. However if there was an error
				in initialisation or setting the service name you will still be able to 
				get the profile api instance. However calls will fail.

*********************************************************************************/

CProfileConnection* CGI::GetProfileConnection()
{
	if (!m_ProfileConnection.IsInitialised())
	{
		return NULL;
	}

	return &m_ProfileConnection;
}

/*********************************************************************************

	CUser* CGI::GetCurrentUser()

	Author:		Kim Harries
	Created:	02/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	Pointer to the current viewing user, or NULL if non signed in user
	Purpose:	Returns a pointer to a CUser object containing all the info on
				the user that made the current request. 

*********************************************************************************/

CUser* CGI::GetCurrentUser()
{
	if (m_pCurrentUser != NULL)
	{
		return m_pCurrentUser;
	}
	else
	{
		return NULL;
	}
}


/*********************************************************************************

	CUser* CGI::GetCurrentLoggedInUser()

	Author:		Dharmesh Raithatha
	Created:	9/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	returns the user only if they are logged in

*********************************************************************************/

CUser* CGI::GetCurrentLoggedInUser()
{
	
	if (m_pCurrentUser != NULL)
	{
		if (m_pCurrentUser->IsUserLoggedIn())
		{
			return m_pCurrentUser;
		}
	}

	return NULL;
}

#ifdef _DEBUG

bool CGI::CreateDebugCurrentUser(int iDebugUserID)
{
	m_pCurrentUser = new CUser(GetInputContext());
	
	m_pCurrentUser->SetUserSignedIn();
	m_pCurrentUser->SetSsoUserName("debuguser");
	
	bool bSuccess = true;

	CStoredProcedure SP;
	if (m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		bSuccess = SP.GetUserFromUserID(iDebugUserID, m_SiteID);
	}
	
	if (bSuccess)
	{
		m_pCurrentUser->CreateFromID(iDebugUserID);
		m_pCurrentUser->SetUserLoggedIn();
		m_iDebugUserID = iDebugUserID;
		return true;
	}

	return false;
}

bool CGI::GetDebugCookie(int& iUserID)
{
	iUserID = 0;
	CTDVString sDebugCookie;
	bool bSuccess = GetServerVariable("HTTP_COOKIE", sDebugCookie);

	if (!bSuccess)
	{
		return false;
	}
	
	CTDVString sNameToFind = "H2G2DEBUG=";
	long pos = sDebugCookie.Find(sNameToFind);		// find the start of the cookie
	long len = sDebugCookie.GetLength();

	// The old code (pre 27/1/06) may have put in a cookie that reads "H2G2USER=H2G2DEBUG=<id>A"
	// This loop should eliminate the false positives
	while (pos > 0 && sDebugCookie.GetAt(pos-1) == '=')
	{
		pos = sDebugCookie.Find(sNameToFind,pos+1);
	}

	if (pos >= 0)
	{
		const char* pCookie = sDebugCookie;
		sDebugCookie = pCookie + pos + sNameToFind.GetLength();;
		long separator = sDebugCookie.Find("A");
		if (separator >= 0)
		{
			sDebugCookie = sDebugCookie.Mid(0, separator);
			iUserID = atoi(sDebugCookie);
		}
		if (iUserID > 0)
		{
			bSuccess = true;
		}
		else
		{
			bSuccess = false;
		}
	}
	else
	{
		bSuccess = false;
	}
	
	return bSuccess;
}

void CGI::SetDebugCookie(int iUserID)
{
	m_bSetDebugCookie = true;
	m_iDebugUserID = iUserID;

	CTDVString sCookie;
	sCookie << iUserID << "A";
	SetCookie(sCookie,false,"H2G2DEBUG");
}

void CGI::ClearDebugCookie()
{
	m_bSetDebugCookie = false;
	m_iDebugUserID = 0;
	SetCookie("0A",false,"H2G2DEBUG");
}

bool CGI::GetDebugCookieString(CTDVString& sCookie)
{
	if (m_bSetDebugCookie)
	{
		sCookie = "<SETCOOKIE><COOKIE>H2G2DEBUG=";
		sCookie << m_iDebugUserID;
		sCookie << "</COOKIE>";
		return true;
	}

	return false;
}

#endif

/*********************************************************************************

	bool CGI::CreateCurrentUser()

	Author:		Dharmesh Raithatha
	Created:	9/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	true if the user was created. false otherwise
	Purpose:	Creates the user from the cookie. If the user is already created 
				then it won't try to create another one. If user is signed in to
				the profile api then a user will be created. The flag will be also 
				set in the user if they are logged into that service or not.

*********************************************************************************/

bool CGI::CreateCurrentUser()
{
#ifdef _DEBUG

	m_bSetDebugCookie = false;
	m_iDebugUserID = 0;

	int iDebugCookieTemp = 0;
	
	if (m_InputContext.ParamExists("d_userid") || GetDebugCookie(iDebugCookieTemp))
	{
		if (m_InputContext.ParamExists("d_clearid"))
		{
			//Clear the cookie here
			ClearDebugCookie();
		}
		else
		{
			int iDebugUserID = m_InputContext.GetParamInt("d_userid");
			
			if (iDebugUserID > 0)
			{
				//set the cookie here
				SetDebugCookie(iDebugUserID);
				return CreateDebugCurrentUser(iDebugUserID);
			}
			//if the cookie exists then use it
			else
			{
				m_bSetDebugCookie = false;
				return CreateDebugCurrentUser(iDebugCookieTemp);
			}
		}
		
	}
#endif


	// if we already have a current user object then return a pointer to that
	if (m_pCurrentUser != NULL)
	{
		return true;
	}
	else
	{
		////////////////
		CTDVString sSsoCookie;
		bool bSuccess = GetCookie(sSsoCookie);
		if (!bSuccess)
		{
			return false;
		}

		CTDVString sIdentityUserName;
		GetCookieByName("IDENTITY-USERNAME", sIdentityUserName);

		m_pCurrentUser = new CUser(GetInputContext());
		if (m_pCurrentUser != NULL)
		{
			m_pCurrentUser->SetSyncByDefault(true);
		}

		bool bUserSet = m_ProfileConnection.SetUserViaCookieAndUserName(sSsoCookie, sIdentityUserName);
		if (ParamExists("logsignin") || theConfig.UseExtraSigninlogging())
		{
			WriteInputLog(CTDVString("SIGNIN ") + m_ProfileConnection.GetLastTimings());
		}

		bool bUserSignedIn = false;
		if (GetSiteUsesIdentitySignIn(m_SiteID))
		{
			m_ProfileConnection.IsUserSignedIn(bUserSignedIn);
		}
		
		// If the user is not set, but is signed in, then we want to carry on, but only return the sso name.
		if (bUserSet || bUserSignedIn)
		{
			m_pCurrentUser->SetUserSignedIn();
			m_pCurrentUser->SetSsoUserName(m_ProfileConnection.GetUserName());
		}
		else
		{
			m_pCurrentUser->SetUserNotSignedIn(m_ProfileConnection.GetErrorMessage());
			return true;
		}

		bool bUserLoggedIn = false;

		m_ProfileConnection.CheckUserIsLoggedIn(bUserLoggedIn);
		
		//if they are not logged in then try to log them in automatically
		//always do this through the user object
		if (!bUserLoggedIn)
		{
			bUserLoggedIn = m_pCurrentUser->LoginUserToProfile();
		}

		//user is now logged in so create the data
		if (bUserLoggedIn)
		{
			if (m_pCurrentUser->CreateFromSigninIDAndInDatabase(m_ProfileConnection.GetUserId()))
			{
				m_pCurrentUser->SetUserLoggedIn();
			}
			else
			{
				m_pCurrentUser->SetUserNotLoggedIn();
			}
		}

		return true;

	}
}

/*********************************************************************************
> void CGI::SendOutput(const TDVCHAR *pString)

	Author:		Jim Lynn
	Created:	17/02/2000
	Inputs:		pString - ptr to string to send to the output
	Outputs:	-
	Returns:	-
	Purpose:	Sends output to the client in some strange, platform dependent
				way. Can be called multiple times. If headers were defined they
				are sent first, so the SetHeader and SetCookie functions cannot
				be called after this function is called.

*********************************************************************************/

void CGI::SendOutput(const TDVCHAR *pString)
{
	if (m_bShowTimers && m_TimerHeaders.GetLength() > 0) 
	{
        WriteContext(m_TimerHeaders);
        m_sHeaders << m_TimerHeaders;
		//*m_pCtxt << m_TimerHeaders;
		// This tells the server where the headers end
		//m_pCtxt->m_dwEndOfHeaders = m_pCtxt->m_pStream->GetStreamSize();
		m_TimerHeaders.Empty();
	}

    //Send Headers
    m_sHeaders << "\r\n";
    WriteHeaders(m_sHeaders);

    //Send content
    WriteContext(pString);
	//*m_pCtxt << pString;
}

const char* CGI::GetMimeExtension(const char* pMime)
{
	if (!pMime)
	{
		return "";
	}

	CMimeExt::CMimesMap::iterator it = m_MimeExt.m_Map.find(pMime);
	if (it == m_MimeExt.m_Map.end())
	{
		return "";
	}

	return it->second;
}

/*********************************************************************************
> void CGI::SendPicture()

	Author:		Oscar Gillespie
	Created:	15/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Sends a picture to the client in some strange, platform dependent
				way. Can be called multiple times. If headers were defined they
				are sent first, so the SetHeader and SetCookie functions cannot
				be called after this function is called.

*********************************************************************************/

bool CGI::SendPicture(const TDVCHAR* sServerName, const TDVCHAR* sPath, const TDVCHAR* sMimeType)
{
	// the heuristic for this function is
	
	// 1) try to load the blob from our cache

	// 2) if it fails, get it from the authoratitive place, copy it to our cache
	// (creating the path as well as the file if we need to) and load that file

	// 3) Transmit our (hopefully) happy binary


	// *** step 1 ***
	// try to load the blob from our cache (we use "E:\h2g2cache\" as our cache root for now)

	CTDVString sLocalCacheRoot = theConfig.GetBlobCacheRoot();

	// this string builds up a local computer path locator thingy
	// which is of the form "DriveLetter:\SomeFolderCacheName(s)\BlobNumber"

	// this makes "E:\h2g2cache\xxxxx" for most valid blobs
	// (the shared drive information is stripped off)

	CTDVString sFilePath = sLocalCacheRoot;

	// temporary string initialised from a parameter so that it can be used as a CTDVString
	// could be either "blobs\51522" (shared directory name only at the beginning) or
	// "blobs\silver\gloss\25912" (shared directory name plus subdirectory stuff)
	CTDVString tPath = sPath;

	// this string should only ever contain something like "22445" or "blue\24168"
	CTDVString sBlobAndPathOnly;

	// find the first occurence of a slash in the string
	int iSlashIndex = tPath.Find('\\');

	if (iSlashIndex > 1)
	{
		// strip away everything up to including the first '\' character
		sBlobAndPathOnly = tPath.Mid(iSlashIndex + 1);
	
		// put this path information into the file path we're going to look in
		sFilePath << sBlobAndPathOnly;
	}
	else
	{
		// the path doesn't need to be treated since it doesn't contain any slash characters
		sFilePath << sPath;
	}

	sFilePath << "." << GetMimeExtension(sMimeType);

	/*
	if (_stricmp(sMimeType, "image/gif") == 0)
	{
		sFilePath << ".gif";
	}
	else if (_stricmp(sMimeType, "image/pjpeg") == 0)
	{
		sFilePath << ".jpg";
	}
	else if (_stricmp(sMimeType, "image/jpeg") == 0)
	{
		sFilePath << ".jpg";
	}
	else if (_stricmp(sMimeType, "application/x-shockwave-flash") == 0)
	{
		sFilePath << ".swf";
	}
	*/
	// turn the CTDVStrings into LPCTSTR type strings... 
	// windows uses them because they have quirky unicode benefits
	LPCTSTR pstrFullPath = static_cast<LPCTSTR>(sFilePath);
	LPCTSTR pstrContentType = static_cast<LPCTSTR>(sMimeType);

	// lets see if we can find the file...
	// get a handle (dodgy file pointer affair) to the file we want
	HANDLE hFile = ::CreateFile(pstrFullPath,
					GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING,
					FILE_FLAG_SEQUENTIAL_SCAN | FILE_FLAG_OVERLAPPED, NULL);

	// integer variable to keep an eye on the validity of our file handle
	int iFileError = 0;

	if (hFile == INVALID_HANDLE_VALUE)
	{
		// this will give the iFileError variable a nonzero value to express the problem that came up
		iFileError = static_cast<int>(GetLastError());
	}
	else
	{
	// if we've got a decent file handle we should close it... 
	// we can open it again later but we've found out now if the path is valid or not.
	BOOL bTryClose = CloseHandle(hFile);
	}

	// success tracking boolean variable
	bool bSuccess = true;

	// If the file open failed it's very likely that the blob doesn't habitate the cache atm.
	if (iFileError != 0)
	{
		// in which case we need to perform
		// *** step 2 ***

		// we've hit a problem...  things aren't looking good so we set the success 
		// value to false
		bSuccess = false;

		// these error codes taken from the MS help files:
		// (2) The system cannot find the file specified.  ERROR_FILE_NOT_FOUND 
		// (3) The system cannot find the path specified.  ERROR_PATH_NOT_FOUND 

		if (iFileError == ERROR_PATH_NOT_FOUND)
		{
			// create sBlobAndPathOnly (minus the actual blob part)
			// sBlobAndPathOnly should look something like 35521 or spinach\61251
			// and we know that it is the second kind of path because we got a ERROR_PATH_NOT_FOUND
			// so we want to get everything but the last part:

			// find the furthest right slash in the string
			int iLastSlash = sBlobAndPathOnly.ReverseFind('\\');
		
			if (iLastSlash > 0)
			{
				// if we find a slash then anything to the right of it is the blob number
				// we need the path on it's own so we can make the directory

				// this should resemble something like "spinach\" or "red\likeblood\"
				CTDVString sPathOnly = sLocalCacheRoot + sBlobAndPathOnly.Left(iLastSlash);

				// turn the CTDVStrings into another one of those charming LPCTSTR strings... 
				LPCTSTR pstrPathOnly = static_cast<LPCTSTR>(sPathOnly);

				// attempt to make the directory
				bool bEnsureTargetPath = (CreateDirectory(pstrPathOnly, NULL) != FALSE);
			}
		}
	
		if (iFileError == ERROR_PATH_NOT_FOUND || iFileError == ERROR_FILE_NOT_FOUND)
		{
			// ok... the file isn't there... use copy file to put it in the right place
			// and test that we can open it now that we've remedied the immediate obstacle

			// String describing the location to look for the file
			CTDVString sWhereFrom = "\\\\";
			sWhereFrom << sServerName;
			sWhereFrom << "\\";
			sWhereFrom << sPath;

			// turn the CTDVStrings into another one of those charming LPCTSTR strings... 
			LPCTSTR pstrWhereFrom = static_cast<LPCTSTR>(sWhereFrom);

			// attempt to copy the file from the main blob place to our cache
			BOOL bCopySuccess = CopyFile(pstrWhereFrom, pstrFullPath, FALSE);

			// if we didn't get any objections then we've succeeded
			if (bCopySuccess != FALSE)
			{
				// the copy claims to have worked, so lets try and open the file again
				HANDLE hCopiedFile = ::CreateFile(pstrFullPath,
					GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING,
					FILE_FLAG_SEQUENTIAL_SCAN | FILE_FLAG_OVERLAPPED, NULL);

				if (hCopiedFile != INVALID_HANDLE_VALUE)
				{
					// this is our chance for redemption... 
					// if we got a file handle that wasn't invalid then we've been forgiven
					bSuccess = true;
				}

				// try to close the file
				BOOL bFinishedWithThatFella = CloseHandle(hCopiedFile);
			}
			else
			{
				DWORD err = GetLastError();
			}
		}
	}

	if (bSuccess) // if we're managing to stay afloat up until this point
	{	
		// try to transmit the file we've opened

		// lets see if we can find the file...
		// get a handle (dodgy file pointer affair) to the file we want
		HANDLE hFileToSend = ::CreateFile(pstrFullPath,
					GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING,
					FILE_FLAG_SEQUENTIAL_SCAN | FILE_FLAG_OVERLAPPED, NULL);

		if (hFileToSend == INVALID_HANDLE_VALUE)
		{
			// if we've got a duff file handle then we can't manage to do this
			bSuccess = false;
		}
		else
		{
			// work out the file size... we'll need to know that later
			// at the minute this function is behaving like a slag
			DWORD dwLength = GetFileSize(hFileToSend, NULL);

			// formulate a proper header
			CString strHeader;
			strHeader.Format(
				_T("HTTP/1.0 200 OK\r\nContent-type: %s\r\nContent-length: %d\r\n\r\n"),
				pstrContentType, dwLength);

			// here we go... let's have a go at sending it
			// double-cast is necessary because TransmitFile() params are not const
			//bSuccess = (m_pCtxt->TransmitFile(hFileToSend, HSE_IO_ASYNC,
			//	(LPVOID)(LPCTSTR) strHeader) != FALSE);

			// we don't close the file because it's TransmitFile's responsibility now
		}

	}

	return bSuccess;
}


/*********************************************************************************

	CStoredProcedure* CGI::CreateStoredProcedureObject()

	Author:		Jim Lynn
	Created:	25/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	A ptr to a StoredProcedure object pointing at the correct database
	Purpose:	Creates a new StoredProcedure object and passes it out to the caller.
				The SPobject points at the right database for this request (as
				determined by the config data) and *must* be deleted by the caller
				when they have finished with it.

*********************************************************************************/

CStoredProcedure* CGI::CreateStoredProcedureObject()
{
	// Here we can create a DBO object and pass it into a new
	// stored procedure object. First get the connection string

	DBO* pDBO = new DBO(GetDBConnection());
	CStoredProcedure* pSP = new CStoredProcedure(pDBO, m_SiteID, this);
	return pSP;
}

CDBConnection* CGI::GetDBConnection()
{
	return &m_Connection;
}

CDBConnection* CGI::GetWriteDBConnection()
{
	return &m_WriteConnection;
}


/*********************************************************************************
> CTDVString CGI::GetDBConnectionString()

	Author:		Jim Lynn
	Created:	Tuesday, February 22, 2000
	Inputs:		-
	Outputs:	-
	Returns:	Connection string suitable for this request
	Purpose:	Returns a connection string so that ODBC can talk to a database.
				This is *very* platform specific. Another platform might not
				even need a connection string, and might connect to the database
				in a different way.

*********************************************************************************/

/*
CTDVString CGI::GetDBConnectionString()
{
	//return CTDVString("DRIVER={SQL Server};SERVER=(LOCAL);UID=sa;PWD=;APP=test;WSID=GUIDE=us_english;DATABASE=TheGuide");	// unimplemented so far
	return m_DBConnectionString;
}
*/

/*********************************************************************************
> bool CGI::GetCommand(CTDVString &sResult)

	Author:		Jim Lynn
	Created:	Friday, February 18, 2000
	Inputs:		-
	Outputs:	sResult - string containing command from query string
	Returns:	true if a command was found, false if no command found
	Purpose:	The DLL is called as follows:
					RipleyServer.dll?Command?id=1&set=8
				The query string is everything after the first ?
				This function returns the command.

*********************************************************************************/

bool CGI::GetCommand(CTDVString &sResult)
{
	if (m_Command.GetLength() > 0)
	{
		sResult = m_Command;
		return true;
	}
	
	int qmark = m_Query.Find("?");
	int ampersand = m_Query.Find("&");
	if ((ampersand < qmark) && (ampersand >= 0))
	{
		qmark = ampersand;
	}
	if (qmark < 0)
	{
		sResult = m_Query;
		return true;
	}
	sResult = m_Query.Left(qmark);
	return true;
}

/*********************************************************************************

	bool CGI::InitialiseWithConfig()

	Author:		Jim Lynn, Oscar Gillespie
	Created:	25/02/2000
	Modified:	16/03/2000
	Inputs:		pConfig - an XML tree to configure this request.
	Outputs:	-
	Returns:	true if config succeeded, false otherwise.
	Purpose:	Gives the server configuration information to the CGI object
				so it knows (for example) which database to talk to.

*********************************************************************************/

bool CGI::InitialiseWithConfig()
{
	DWORD bufsize = 256;
	char pBuff[256];
	::GetComputerName(pBuff, &bufsize);
	m_ServerName = pBuff;
	
	m_DefaultSkinPreference = theConfig.GetDefaultSkin();

	CTDVString sConn;
	BuildConnectionString(theConfig.GetDbServer(), theConfig.GetDbName(), 
		theConfig.GetDbUser(), theConfig.GetDbPassword(), theConfig.GetDbApp(), theConfig.GetDbPooling(), sConn);

	m_Connection.Initialise(sConn);

	BuildConnectionString(theConfig.GetWriteDbServer(), theConfig.GetWriteDbName(), 
		theConfig.GetWriteDbUser(), theConfig.GetWriteDbPassword(), theConfig.GetWriteDbApp(), theConfig.GetWriteDbPooling(), sConn);

	m_WriteConnection.Initialise(sConn);

	HandleExistingLogFile();

	return true;
}


/*********************************************************************************

	void CGI::HandleExistingLogFile()

		Author:		Mark Neves
		Created:	12/02/2008
		Inputs:		-
		Outputs:	-
		Returns:	-
		Purpose:	This handles the existence of a log file during app start-up.
					If it's able to read the log file ptr, it uses it so that
					subsequent writes get appended to the log file.
					
					If the file exists, but there's no log file ptr, it renames it
					to ensure it doesn't get blatted over

*********************************************************************************/

void CGI::HandleExistingLogFile()
{
	CTDVString sLogFile, sDate;
	CGI::GenerateLogFileNameAndDate(sLogFile, sDate);
	if (CGI::DoesFileExist(sLogFile))
	{
		// Set the file ptr to the last known value
		CGI::s_CurLogFilePtr = CGI::ReadLogFilePtr();
		if (CGI::s_CurLogFilePtr == 0)
		{
			// the log file exists but we were unable to read the last log file ptr
			// so we rename the existing log file to prevent overwriting information

			CTDVString sNewLogFileName = sLogFile;
			for (int n=0;CGI::DoesFileExist(sNewLogFileName) == true;n++)
			{
				sNewLogFileName = sLogFile;
				sNewLogFileName << "_" << n;
			}
			::MoveFile(sLogFile,sNewLogFileName);
		}
		else
		{
			// We have a file ptr we trust, so remember this log file as the last
			// log file we used.
			CGI::s_LastLogFile = sLogFile;
		}
	}
}


void CGI::BuildConnectionString(const char* pServer, const char* pDbName,
	const char* pUser, const char* pPassword, 
	const char* pApp, const char* pPooling, CTDVString& sConn)
{
	sConn = "DRIVER={SQL Server};";
	sConn << "SERVER=" << pServer << ";";
	sConn << "UID=" << pUser << ";";
	sConn << "PWD=" << pPassword << ";";
	if (strlen(pApp) != 0)
	{
		sConn << "APP=" << pApp << ";";
	}
	else
	{
		sConn << "APP=Ripley;";
	}
	if (strlen(pPooling) != 0)
	{
		sConn << "POOLING=" << pPooling << ";";
	}
	sConn << "WSID=" << m_ServerName << ";";
	sConn << "DATABASE=" << pDbName;	// no terminating ;
}

/*********************************************************************************

	bool CGI::GetDomainName(CTDVString &sResult)

	Author:		Jim Lynn
	Created:	24/02/2000
	Inputs:		-
	Outputs:	sResult - contains site name on exit
	Returns:	true if site name found, false otherwise
	Purpose:	Gets the domain name (e.g. www.h2g2.com) from the request.

*********************************************************************************/

bool CGI::GetDomainName(CTDVString &sResult)
{
	bool bSuccessful = true;
	if (m_DomainName.GetLength() == 0)
	{
			DWORD bufsize = 4096;
			char buffer[4096];
	
            if (!(m_pECB->GetServerVariable(m_pECB->ConnID,"SERVER_NAME", (void*)buffer, &bufsize)))
			{
				TDVASSERT(false,"Failed to read server name");
				bSuccessful = false;
			}
			else
			{
				m_DomainName = buffer;
				sResult = m_DomainName;
			}
	}
	else
	{
		sResult = m_DomainName;
	}
	return bSuccessful;
}

/*********************************************************************************

	bool CGI::GetClientAddr(CTDVString &sResult)

	Author:		Adam Cohen-Rose
	Created:	08/08/2000
	Inputs:		-
	Outputs:	sResult - contains IP address of client on exit
	Returns:	true if client IP found, false otherwise
	Purpose:	Gets the (dotted quad) IP address of the client making the request.

*********************************************************************************/

bool CGI::GetClientAddr(CTDVString &sResult)
{
	bool bSuccessful = true;

	DWORD bufsize = 4096;
	char buffer[4096];

	if (!(m_pECB->GetServerVariable(m_pECB->ConnID,"REMOTE_ADDR", (void*)buffer, &bufsize)))
	{
		TDVASSERT(false,"Failed to read client IP address");
		bSuccessful = false;
	}
	else
	{
		sResult = buffer;
	}

	return bSuccessful;
}

/*********************************************************************************

	bool CGI::GetStylesheetHomePath(CTDVString &sResult)

	Author:		Jim Lynn
	Created:	25/02/2000
	Inputs:		-
	Outputs:	sResult - string to contain the result
	Returns:	true if successful, false otherwise
	Purpose:	puts the absolute pathname of the root directory where
				the xsl stylesheet hierarchy lives.

*********************************************************************************/

bool CGI::GetStylesheetHomePath(CTDVString &sResult)
{
	sResult = m_pECB->lpszPathTranslated;
	return true;
}

/*********************************************************************************

	bool CGI::GetHomePath(CTDVString& sResult)

		Author:		Mark Neves
        Created:	29/03/2005
        Inputs:		-
        Outputs:	sResult = path of the home folder
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CGI::GetHomePath(CTDVString& sResult)
{
	sResult = m_pECB->lpszPathTranslated;
	return true;
}

/*********************************************************************************

	bool CGI::GetRipleyServerPath(CTDVString& sResult)

		Author:		Mark Neves
        Created:	29/03/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CGI::GetRipleyServerPath(CTDVString& sResult)
{
	if (GetHomePath(sResult))
	{
		sResult << "\\RipleyServer.dll";
		return true;
	}

	return false;
}

/*********************************************************************************

	bool CGI::GetShortName(CTDVString& sShortName)

	Author:		Igor Loboda
	Created:	22/02/2002
	Inputs:		iSiteID - if -1 returns short name for the current site, otherwise
					for specified one.
	Outputs:	sShortName - site short name
	Returns:	true
	Purpose:	Puts the value for current site short name into
				the sShortName output variable.

*********************************************************************************/
bool CGI::GetShortName(CTDVString& sShortName, int iSiteID)
{
	if (iSiteID == -1)
	{
		iSiteID = GetSiteID();
	}

	return m_pSiteList->GetShortName(iSiteID, sShortName);
}

/*********************************************************************************

	bool CGI::GetEmail(int iEmailType, CTDVString& sEmail, int iSiteID)

	Author:		Igor Loboda
	Created:	22/02/2002
	Inputs:		iEmailType email type id to know what email shoud be retured:
					moderators, editors, etc. see EMAIL_... constants.
				iSiteID site id
	Outputs:	sEmail - moderators email for the current site
	Returns:	true
	Purpose:	Puts the value for moderators email for the given site of for the
				current site if iSiteID = -1 into
				the sEmail output variable.

*********************************************************************************/
bool CGI::GetEmail(int iEmailType, CTDVString& sEmail, int iSiteID)
{
	if (iSiteID == - 1)
	{
		iSiteID = GetSiteID();
	}

	return m_pSiteList->GetEmail(iSiteID, iEmailType, sEmail);
}

int CGI::GetAutoMessageUserID(int iSiteID)
{
	if (iSiteID == - 1)
	{
		iSiteID = GetSiteID();
	}

	return m_pSiteList->GetAutoMessageUserID(iSiteID);
}

/*********************************************************************************

	bool CGI::GetDefaultSkin(CTDVString& sSkinName)

	Author:		Kim Harries
	Created:	25/05/2000
	Inputs:		-
	Outputs:	sSkinName - the name of the default skin specified in the config file
	Returns:	true if successful, false otherwise
	Purpose:	Puts the value for the default skin name from the config file into
				the sSkinName output variable.

*********************************************************************************/

bool CGI::GetDefaultSkin(CTDVString& sSkinName)
{
	sSkinName = m_DefaultSkinPreference;
	return true;
}

/*********************************************************************************

	bool CGI::GetSiteRootURL(int iSiteID, CTDVString& sSiteRootURL)

		Author:		Mark Neves
        Created:	18/03/2004
        Inputs:		iSiteID = the site you want the root URL to					
        Outputs:	sSiteRootURL = the URL for this site
        Returns:	true if OK, false otherwise
        Purpose:	Used to get the root URL for the given site
					e.g. www.bbc.co.uk/dna/ican/

*********************************************************************************/

bool CGI::GetSiteRootURL(int iSiteID, CTDVString& sSiteRootURL)
{
	CTDVString sSiteRoot = theConfig.GetSiteRoot();
	CTDVString sSiteName = "h2g2";
	sSiteRootURL.Empty();

	if (m_pSiteList != NULL)
	{
		m_pSiteList->GetNameOfSite(iSiteID,&sSiteName);
	}

	sSiteRootURL << sSiteRoot << sSiteName << "/";

	return true;
}


/*********************************************************************************

	bool CGI::GetCookieByName(const TDVCHAR* pCookieName, CTDVString& sCookieValue)

	Author:		David van Zijl - moved here from GetCookie() by unknown author
	Created:	18/10/2004
	Inputs:		pCookieName - Cookie name e.g. 'BBC-UID'
	Outputs:	sCookieValue - Value of cookie
	Returns:	true if cookie found, false otherwise
	Purpose:	Returns the cookie value for a specified name

*********************************************************************************/

bool CGI::GetCookieByName(const TDVCHAR* pCookieName, CTDVString& sCookieValue)
{
	if (pCookieName == NULL || pCookieName[0] == 0)
	{
		return false;
	}

	CTDVString sSsoCookie;
	bool bSuccess = GetServerVariable("HTTP_COOKIE", sSsoCookie);

	if (!bSuccess)
	{
		return false;
	}
	
	CTDVString sNameToFind;
	sNameToFind << pCookieName << "=";
	long pos = sSsoCookie.Find(sNameToFind);		// find the start of the cookie
	long len = sSsoCookie.GetLength();
	if (pos >= 0)
	{
		sSsoCookie.RemoveLeftChars(pos + sNameToFind.GetLength());
		long separator = sSsoCookie.Find(";");
		if (separator >= 0)
		{
			sSsoCookie = sSsoCookie.Mid(0, separator);
		}
		bSuccess = true;
	}
	else
	{
		sSsoCookie = "";
		bSuccess = false;
	}

	// Cookie values are encoded
	UnEscapeString(&sSsoCookie);

	sCookieValue = sSsoCookie;

	return bSuccess;
}


/*********************************************************************************

	bool CGI::GetCookie(CTDVString& sResult)

	Author:		-
    Created:	-
    Inputs:		-
    Outputs:	sResult - Value of cookie param
    Returns:	true if cookie found, false otherwise
    Purpose:	Returns the value of the BBC SSO cookie

*********************************************************************************/

bool CGI::GetCookie(CTDVString& sResult)
{
    if (m_InputContext.GetSiteUsesIdentitySignIn(m_SiteID))
	{
        // BODGE!!! Make sure that the cookie is fully decoded.
        // Currently the cookie can come in from Forge double encoded.
        // Our tests are correct in encoding only the once.
		if (GetCookieByName( "IDENTITY", sResult))
		{
			int i = 0;
			while (sResult.Find(' ') < 0 && sResult.Find('/') < 0 && sResult.Find('+') < 0 && i < 3)
			{
				UnEscapeString(&sResult);
				i++;
			}
			return true;
		}
		return false;
	}
	else
	{
		return GetCookieByName( CProfileApi::GetCookieName(), sResult);
	}
}

bool CGI::HasSSOCookie()
{
	CTDVString sSSOCookie;
	return GetCookie(sSSOCookie);
}

bool CGI::GetServerVariable(const TDVCHAR* pName, CTDVString& sResult)
{
	if (m_pECB != NULL)
	{
		// Make a buffer that's probably long enough
		DWORD bufsize = 4096;
		char buffer[4096];

		bool bSuccess = false;
		// Read the variable from the server context object
		if (m_pECB->GetServerVariable(m_pECB->ConnID,(char*)pName, (void*)buffer, &bufsize) != 0)
		{
			bSuccess = true;
		}
		else
		{
			bSuccess = false;
		}

		// Store the value in the output variable
		if (bSuccess)
		{
			sResult = buffer;
		}

		// Return success flag
		return bSuccess;
	}
	else
	{
		CTDVString temp(pName);
		temp.MakeUpper();
		sResult = m_ServerVariables[temp];
		return sResult.GetLength() > 0;
	}
}

void CGI::SetMimeType(const TDVCHAR *pType)
{
    CTDVString s = "Content-Type: ";
    s << pType << "\r\n";
    m_sHeaders << s;
	//*m_pCtxt << "Content-Type: " << pType << "\r\n";
	// This tells the server where the headers end
	//m_pCtxt->m_dwEndOfHeaders = m_pCtxt->m_pStream->GetStreamSize();
}

/*********************************************************************************

	void CGI::UnEscapeString(CTDVString *pString)

	Author:		Jim Lynn
	Created:	17/03/2000
	Inputs:		pString - ptr to TDVString to unescape
	Outputs:	pString - string has been converted
	Returns:	-
	Purpose:	UnEscapes a URL parameter. Replaces + with spaces and %XX with
				the ascii equivalent. Used to clean up parameters passed in the
				query string.

*********************************************************************************/

void CGI::UnEscapeString(CTDVString *pString)
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
			//pString->SetAt(pos, ' ');
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

	void CGI::SetCookie(const TDVCHAR *pCookie, 
						bool bMemoryCookie, 
						const TDVCHAR* pCookieName, 
						const TDVCHAR* pCookieDomain)

	Author:		Jim Lynn
	Created:	25/03/2000
	Inputs:		pCookie - string containing the cookie value
				bMemoryCookie - true if the user has asked for a memory cookie
	Outputs:	-
	Returns:	-
	Purpose:	Sets a cookie in the header. Takes the domain from the config file.

*********************************************************************************/

void CGI::SetCookie(const TDVCHAR *pCookie, 
					bool bMemoryCookie, const TDVCHAR* pCookieName, const TDVCHAR* pCookieDomain)
{
	CTDVString sCookieName;
	if (pCookieName != NULL)
	{
		sCookieName = pCookieName;
	}
	else
	{
		sCookieName = theConfig.GetCookieName();
	}
	
	CTDVString sCookieDomain = theConfig.GetCookieDomain();
	if (pCookieDomain != NULL)
	{
		sCookieDomain = pCookieDomain;
	}

	CTDVString EscapedCookie = pCookie;
	EscapedCookie.Replace(" ","%20");
	EscapedCookie.Replace(",","%2C");
	EscapedCookie.Replace(";","%3B");
	CTDVString cookie = "";
	cookie << sCookieName << "=" << EscapedCookie << ";";

	if (!bMemoryCookie)		// If we don't want a memory cookie, set an expiry date
	{
		COleDateTimeSpan span(365.0);	// timespan of 365 days
		COleDateTime yearfromnow = COleDateTime::GetCurrentTime();
		yearfromnow += span;
		CTDVString date = (LPCSTR)yearfromnow.Format("%a, %d-%b-%Y 00:00:00 GMT");
	//	CTDVString date = (LPCSTR)COleDateTime::GetCurrentTime().Format("%a %d-%b-%Y 00:00:00 GMT");
		cookie << "EXPIRES=" << date << ";";
	}
	cookie << "PATH=/;";
	if (sCookieDomain.GetLength() == 0)
	{
		cookie << "DOMAIN=bbc.co.uk;";
	}
	else
	{
		cookie << "DOMAIN=" << sCookieDomain << ";";
	}

	// Check for NULL pointers!
	if (m_pECB != NULL)
	{
        CTDVString s = "Set-Cookie: ";
        s << cookie << "\r\n";

        m_sHeaders << s;
        //CRipleyServerExtension::WriteContext(m_pECB,s);
		//*m_pCtxt << "Set-Cookie: " << cookie << "\r\n";
	
		// This tells the server where the headers end
		//m_pCtxt->m_dwEndOfHeaders = m_pCtxt->m_pStream->GetStreamSize();
	}
}

void CGI::ClearCookie()
{
	// Check for NULL pointers!
	if (m_pECB != NULL)
	{
		CTDVString cookie = "";
		cookie << theConfig.GetCookieName() << "=;";
		cookie << "EXPIRES=-12M;";
		cookie << "PATH=/;";
		cookie << "DOMAIN=" << theConfig.GetCookieDomain() << ";";

        CTDVString set = "Set-Cookie: ";
        set << cookie << "\r\n\r\n";
		m_sHeaders << set;
        //WriteContext(set);
		//*m_pCtxt << "Set-Cookie: " << cookie << "\r\n";
		// This tells the server where the headers end
		//m_pCtxt->m_dwEndOfHeaders = m_pCtxt->m_pStream->GetStreamSize();
	}
}

/*********************************************************************************

	bool CGI::SendRedirect(const TDVCHAR* pLocation)

	Author:		Jim Lynn
	Created:	05/04/2000
	Inputs:		pLocation
	Outputs:	-
	Returns:	true if succeeded
	Purpose:	Sends a redirect (302) to the client redirecting to the location
				provided.

*********************************************************************************/

bool CGI::SendRedirect(const TDVCHAR* pLocation)
{
	// Check for NULL pointers!
	if (m_pECB != NULL)
	{
		CTDVString location = pLocation;
		
		// Fix the XML-safe ampersands
		location.Replace("&amp;", "&");
		
		// append http://domain to the URL
	//	CTDVString sDomain;
	//	GetDomainName(sDomain);
	//	location = sDomain + location;
	//	location = "http://" + location;
		
		DWORD len = location.GetLength();
        m_pECB->ServerSupportFunction(m_pECB->ConnID,HSE_REQ_SEND_URL, (void*)(const char*)location, &len, NULL);
        // Make sure ISAPI doesn't send other rogue headers
		//m_pCtxt->m_bSendHeaders = false;
	}
	return true;
}


/*********************************************************************************

	bool CGI::SendAbsoluteRedirect(const TDVCHAR* pLocation)

	Author:		Oscar Gillespie
	Created:	10/05/2000
	Inputs:		pLocation
	Outputs:	-
	Returns:	true if succeeded
	Purpose:	Sends a redirect (302) to the client redirecting to the location
				provided.

*********************************************************************************/

bool CGI::SendAbsoluteRedirect(const TDVCHAR* pLocation)
{
	CTDVString location = pLocation;
	
	// Fix the XML-safe ampersands
	location.Replace("&amp;", "&");

	// append http:// to the URL if no protocol is declared
	if (location.Find("://") < 0) location = "http://" + location;
	
	// Check for NULL pointers!
	if (m_pECB != NULL)
	{
		DWORD len = location.GetLength();
        m_pECB->ServerSupportFunction(m_pECB->ConnID,HSE_REQ_SEND_URL, (void*)(const char*)location, &len, NULL);
		// Make sure ISAPI doesn't send other rogue headers
		//m_pCtxt->m_bSendHeaders = false;
	}

	return true;
}

/*********************************************************************************

	bool CGI::SendRedirectWithCookies(const TDVCHAR* pLocation, CXMLCookie::CXMLCookieList oCookieList)

		Author:		DE
        Created:	15/02/2005
        Inputs:		-const TDVCHAR* pLocation - page to redirect to 
						-CXMLCookie::CXMLCookieList oCookieList - list of cookies to pass back to client
        Outputs:	-Causes redirection
        Returns:	-true if successful, false otherwise
        Purpose:	-Sends a redirect (302) + cookies to the client redirecting to the location	provided.
*********************************************************************************/
bool CGI::SendRedirectWithCookies(const TDVCHAR* pLocation, CXMLCookie::CXMLCookieList oCookieList)
{	
	CTDVString sHeaders = "";	
	CTDVString sCookieHeaders = "";
	CTDVString sContentTypeHeader = "";
	CTDVString sContentLocationHeader = "";
	
	//extract cookies
	for ( CXMLCookie::iterator Iter = oCookieList.begin( ); Iter != oCookieList.end( ); Iter++ )
	{	
		//get cookie 
		CXMLCookie oXMLCookie = *Iter;

		//declare header text
		CTDVString sThisCookieHeader = "Set-Cookie: ";	
	
		CTDVString sCookieName = "";
		if (oXMLCookie.GetCookieName( ).IsEmpty() == false)
		{
			sCookieName << oXMLCookie.GetCookieName( );
		}
		else
		{
			sCookieName << theConfig.GetCookieName();
		}

		CTDVString sEscapedCookieValue = oXMLCookie.GetCookieValue( );
		sEscapedCookieValue.Replace(" ","%20");
		sEscapedCookieValue.Replace(",","%2C");
		sEscapedCookieValue.Replace(";","%3B");
		sThisCookieHeader << sCookieName << "=" << sEscapedCookieValue << ";";
		
		// If we don't want a memory cookie, set an expiry date
		if (oXMLCookie.GetIsSessionCookie() == false)		
		{
			COleDateTimeSpan span(365.0);	// timespan of 365 days
			COleDateTime yearfromnow = COleDateTime::GetCurrentTime();
			yearfromnow += span;
			CTDVString date = (LPCSTR)yearfromnow.Format("%a, %d-%b-%Y 00:00:00 GMT");
			sThisCookieHeader << "EXPIRES=" << date << ";";
		}

		sThisCookieHeader << "PATH=/;";

		if (oXMLCookie.GetCookieDomain( ).IsEmpty() == false)
		{
			sThisCookieHeader << "DOMAIN=" << oXMLCookie.GetCookieDomain( ) << ";";
		}
		else
		{
			sThisCookieHeader << "DOMAIN=" << theConfig.GetCookieDomain() << ";";
		}

		sCookieHeaders << sThisCookieHeader << "\r\n" ;		
	}

	//set the content type
	sContentTypeHeader = "Content-type: text/html\r\n" ;

	//set the localtion	
	CTDVString sLocation ( pLocation );
	sContentLocationHeader << "Location: " << sLocation << "\r\n" ;
		
	//set all headers
	sHeaders << sCookieHeaders << sContentTypeHeader << sContentLocationHeader << "\r\n";
	
	//set up HTTP status
	CHAR szStatus[] = "302 Found";		

	//set up content
	CHAR szContent[400] = "Please wait...";
	DWORD  cchContent = strlen(szContent);	
	
	//Populate SendHeaderExInfo struct
	HSE_SEND_HEADER_EX_INFO  SendHeaderExInfo = {0};		
	SendHeaderExInfo.fKeepConn = TRUE;
	SendHeaderExInfo.pszStatus = szStatus;
	SendHeaderExInfo.pszHeader = sHeaders;
	SendHeaderExInfo.cchStatus = lstrlen(szStatus);
	SendHeaderExInfo.cchHeader = sHeaders.GetLength( );

	//Send header.
    bool bResult = m_pECB->ServerSupportFunction(m_pECB->ConnID,HSE_REQ_SEND_RESPONSE_HEADER_EX, &SendHeaderExInfo,NULL,NULL) ? true : false;    
	 if (bResult == false)
	{
			return false;
	}      
	
	//write content
     bResult = m_pECB->WriteClient(m_pECB->ConnID,szContent,&cchContent,HSE_IO_SYNC) ? true : false;    
	
	return bResult;
}


bool CGI::GetParsingErrors(const TDVCHAR *pText, CTDVString *pErrorString, CTDVString *pErrorLine, int *piLineNo, int *piCharNo)
{
	CXSLT XSLT;
	bool bResult = XSLT.GetParsingErrors(pText, pErrorString, pErrorLine, piLineNo, piCharNo);
	return bResult;
}

bool CGI::CacheGetItem(const TDVCHAR *pCacheName, const TDVCHAR *pItemName, CTDVDateTime *pdExpires, CTDVString *oXMLText, bool bIncInStats)
{
	try
	{
		CTDVString serr;
		CTDVString sFullPath = theConfig.GetCacheRootPath();
		if (sFullPath.GetLength() == 0)
		{
			// Can't cache if we don't have a root directory
			WriteInputLog("[cache-error-get] GetCacheRootPath() len == 0");
			CTDVString message = "RipleyCache:missed:";
			message << pCacheName << ":" << pItemName;
			LogTimerEvent(message);
			return false;
		}
		sFullPath << pCacheName << "\\" << pItemName;

		CTDVString sXML;

		WIN32_FIND_DATA FindFileData;
		HANDLE hFind;	
		
		bool bGotCachedFile = false;

		hFind = FindFirstFile(sFullPath, &FindFileData);
		if (hFind != INVALID_HANDLE_VALUE)
		{
			// Check the expiry date.
			CTDVDateTime dFileDate(FindFileData.ftLastWriteTime);
			if ( pdExpires == NULL || dFileDate > (*pdExpires))
			{
				DWORD flen = FindFileData.nFileSizeLow;
				char* pBuff = new char[flen+16];

				//char fnamebuff[512];
				//strcpy(fnamebuff, sFullPath);
				FILE* cachefile = fopen(sFullPath, "r");

				if (cachefile != NULL)
				{
					int bytes = fread((void*)pBuff,sizeof(char),flen+7,cachefile);
					if(feof(cachefile) != 0)
					{
						// EOF, so config read properly
						// terminate the string
						pBuff[bytes] = 0;
						*oXMLText = pBuff;
						bGotCachedFile = true;
					}
					else
					{
						serr = FormatLastErrorMessage();
						serr = "[cache-error-io-get] fread() failed - Couldn't read all of cached file - " + sFullPath + ":"+serr;
						TDVASSERT(false, serr);
						WriteInputLog(serr);
					}
					if (fclose(cachefile) == EOF)
					{
						serr = FormatLastErrorMessage();
						serr = "[cache-error-io-get] fclose() failed - Couldn't read all of cached file - " + sFullPath + ":"+serr;
						TDVASSERT(false, serr);
						WriteInputLog(serr);
					}
				}
				else
				{
					serr = FormatLastErrorMessage();
					serr = "[cache-error-io-get] fopen() failed - " + sFullPath + ":"+serr;
					TDVASSERT(false, serr);
					WriteInputLog(serr);
				}
				delete [] pBuff;
			}
			if (pdExpires != NULL)
			{
				*pdExpires = dFileDate;
			}
			if (FindClose(hFind) == 0)
			{
				CTDVString sLastError = FormatLastErrorMessage();
				CTDVString msg = "[cache-error-io-get] FindClose() failed - "+sFullPath;
				WriteInputLog(msg);
				msg = "[cache-error-io-get] Last Error - "+sLastError;
				WriteInputLog(msg);
			}
		}
		else
		{
			CTDVString sLastError = FormatLastErrorMessage();
			CTDVString msg = "[cache-warning-io-get] FindFirstFile() failed - "+sFullPath;
			WriteInputLog(msg);
			if (sLastError.Find("The system cannot find the file specified") < 0)
			{
				msg = "[cache-error-io-get] Last Error - "+sLastError;
				WriteInputLog(msg);
			}

			CTDVString message = "RipleyCache:missed:";
			message << pCacheName << ":" << pItemName;
			LogTimerEvent(message);
			return false;
		}

		if ( m_pStatistics && bIncInStats)
		{
			if ( bGotCachedFile )
				m_pStatistics->AddCacheHit();
			else
				m_pStatistics->AddCacheMiss();
		}

		if (bGotCachedFile)
		{
			CTDVString message = "RipleyCache:found:";
			message << pCacheName << ":" << pItemName;
			LogTimerEvent(message);
		}
		else
		{
			CTDVString message = "RipleyCache:missed:";
			message << pCacheName << ":" << pItemName;
			LogTimerEvent(message);
		}
		
		return bGotCachedFile;
	}
	catch (CFileException* theException) 
	{
		CTDVString msg = "[cache-error-file-exception-get] "+ExtractFileExceptionInfo(theException);
		WriteInputLog(msg);
	}
	catch(...)
	{
		CTDVString msg = "[cache-error-unknown-exception-get]";
		
		if (pCacheName != NULL)
		{
			msg += "("+CTDVString(pCacheName)+")";
		}
		
		if (pItemName != NULL)
		{
			msg+= "("+CTDVString(pItemName)+")";
		}
		WriteInputLog(msg);
	}

	return false;

}

bool CGI::CachePutItem(const TDVCHAR *pCacheName, const TDVCHAR *pItemName, const TDVCHAR *pText)
{
	try
	{
		CTDVString serr;
		CTDVString sFullPath = theConfig.GetCacheRootPath();
		if (sFullPath.GetLength() == 0)
		{
			// Can't cache if we don't have a root directory
			WriteInputLog("[cach-error-put] GetCacheRootPath() len == 0");
			return false;
		}
		sFullPath << pCacheName << "\\" << pItemName;
		CTDVString sCacheDir = theConfig.GetCacheRootPath();
		sCacheDir << pCacheName;

		CTDVString sXML;

		WIN32_FIND_DATA FindFileData;
		HANDLE hFind;	
		
		bool bDirectoryExists = false;
		
		hFind = FindFirstFile(sCacheDir, &FindFileData);
		if (hFind != INVALID_HANDLE_VALUE)
		{
			if (FindClose(hFind) == 0)
			{
				CTDVString sLastError = FormatLastErrorMessage();
				CTDVString msg = "[cache-error-io-put] FindClose() failed - "+sFullPath;
				WriteInputLog(msg);
				msg = "[cache-error-io-put] Last Error - "+sLastError;
				WriteInputLog(msg);
			}
			bDirectoryExists = true;
		}
		else
		{
			CTDVString sLastError = FormatLastErrorMessage();
			CTDVString msg = "[cache-error-io-put] FindFirstFile() failed - "+sFullPath;
			WriteInputLog(msg);
			msg = "[cache-error-io-put] Last Error - "+sLastError;
			WriteInputLog(msg);

			// The directory doesn't exist, so create it 
			CTDVString sDirs(pCacheName);

			if (sDirs.FindText("\\") == -1)
			{
				// Just a single directory name, so create 
				bDirectoryExists = (::CreateDirectory(sCacheDir, NULL) != 0);
				if (!bDirectoryExists)
				{
					CTDVString sLastError = FormatLastErrorMessage();
					CTDVString msg = "[cache-error-io-put] CreateDirectory() failed - "+sCacheDir;
					WriteInputLog(msg);
					msg = "[cache-error-io-put] Last Error - "+sLastError;
					WriteInputLog(msg);
				}
			}
			else
			{
				// We've been give a path of folders, so create each in turn
				CTDVString sCurrentDir = theConfig.GetCacheRootPath();

				while (!sDirs.IsEmpty())
				{
					CTDVString sDir;

					int slash = sDirs.FindText("\\");
					if (slash > 0)
					{
						sDir = sDirs.Left(slash);
						sDirs = sDirs.Mid(slash+1);
					}
					else
					{
						sDir = sDirs;
						sDirs.Empty();
					}
					sCurrentDir << sDir;
					bDirectoryExists = (::CreateDirectory(sCurrentDir, NULL) != 0);
					if (!bDirectoryExists)
					{
						CTDVString sLastError = FormatLastErrorMessage();
						CTDVString msg = "[cache-error-io-put] CreateDirectory() failed - "+sCurrentDir;
						WriteInputLog(msg);
						msg = "[cache-error-io-put] Last Error - "+sLastError;
						WriteInputLog(msg);
					}
					// Add a slash, ready for the next one
					sCurrentDir << "\\";
				}
			}
		}
		if (bDirectoryExists)
		{
				//char fnamebuff[512];
				//strcpy(fnamebuff, sFullPath);
				FILE* cachefile = fopen(sFullPath, "w");
				
				if (cachefile != NULL)
				{
					DWORD err = GetLastError();
					int len = strlen(pText);
					int bytes = fwrite((void*)pText,sizeof(char),len,cachefile);
					if (bytes < len)
					{
						serr = FormatLastErrorMessage();
						serr = "[cache-error-io-put] fwrite() failed - " + sFullPath + ":"+serr;
						TDVASSERT(false, serr);
						WriteInputLog(serr);
					}
					if (fclose(cachefile) == EOF)
					{
						serr = FormatLastErrorMessage();
						serr = "[cache-error-io-put] fclose() failed - " + sFullPath + ":"+serr;
						TDVASSERT(false, serr);
						WriteInputLog(serr);
					}
				}
				else
				{
					serr = FormatLastErrorMessage();
					serr = "[cache-error-io-put] fopen() failed - " + sFullPath + ":"+serr;
					TDVASSERT(false, serr);
					WriteInputLog(serr);
				}
		}
		else
		{
			return false;
		}
		CTDVString message = "RipleyCache:write:";
		message << pCacheName << ":" << pItemName;
		LogTimerEvent(message);
		return true;
	}
	catch (CFileException* theException) 
	{
		CTDVString msg = "[cache-error-file-exception-put] "+ExtractFileExceptionInfo(theException);
		WriteInputLog(msg);
	}
	catch(...)
	{
		CTDVString msg = "[cache-error-unknown-exception-put]";
		
		if (pCacheName != NULL)
		{
			msg += "("+CTDVString(pCacheName)+")";
		}
		
		if (pItemName != NULL)
		{
			msg+= "("+CTDVString(pItemName)+")";
		}
		WriteInputLog(msg);
	}

	return false;
}

/*********************************************************************************

	CTDVString CGI::ExtractFileExceptionInfo(CFileException* theException)

		Author:		Mark Neves
		Created:	24/10/2007
		Inputs:		theException = ptr to a caught CFileException
		Outputs:	-
		Returns:	A string description of the exception
		Purpose:	Helper function for diagnosing CFileExceptions

*********************************************************************************/

CTDVString CGI::ExtractFileExceptionInfo(CFileException* theException)
{
	CTDVString sFileName;
	for (int i=0;i < theException->m_strFileName.GetLength(); i++)
	{
		sFileName += theException->m_strFileName[i];
	}

	CTDVString msg = "("+CTDVString(theException->m_cause)+") ("+CTDVString(theException->m_lOsError)+") ("+sFileName+") :";
	switch (theException->m_cause)
	{
		case CFileException::genericException: msg+="An unspecified error occurred."; break;
		case CFileException::fileNotFound: msg+="The file could not be located."; break;
		case CFileException::badPath: msg+="All or part of the path is invalid."; break;
		case CFileException::tooManyOpenFiles: msg+="The permitted number of open files was exceeded."; break;
		case CFileException::accessDenied: msg+="The file could not be accessed."; break;
		case CFileException::invalidFile: msg+="There was an attempt to use an invalid file handle."; break;
		case CFileException::removeCurrentDir: msg+="The current working directory cannot be removed."; break;
		case CFileException::directoryFull: msg+="There are no more directory entries."; break;
		case CFileException::badSeek: msg+="There was an error trying to set the file pointer."; break;
		case CFileException::hardIO: msg+="There was a hardware error."; break;
		case CFileException::sharingViolation: msg+="SHARE.EXE was not loaded, or a shared region was locked."; break;
		case CFileException::lockViolation: msg+="There was an attempt to lock a region that was already locked."; break;
		case CFileException::diskFull: msg+="The disk is full."; break;
		case CFileException::endOfFile: msg+="The end of file was reached. "; break;
	}

	return msg;
}

/*********************************************************************************

	CTDVString CGI::FormatLastErrorMessage()

		Author:		Mark Neves
		Created:	24/10/2007
		Inputs:		-
		Outputs:	-
		Returns:	String representation of GetLastError()
		Purpose:	Helper for reporting the last error.  It calls GetLastError() as the first
					thing it does.
					
					You must call this method immediately after an error is detected
					otherwise you may get incorrect error info

*********************************************************************************/

CTDVString CGI::FormatLastErrorMessage()
{
	DWORD err = GetLastError();
	CTDVString sErrMsg;

	LPVOID lpMessageBuffer = NULL;
	FormatMessage(
		FORMAT_MESSAGE_ALLOCATE_BUFFER|FORMAT_MESSAGE_FROM_SYSTEM,
		NULL, err,
		0,
		(LPTSTR) &lpMessageBuffer, 0, NULL);

	sErrMsg << (LPTSTR) lpMessageBuffer;
	LocalFree(lpMessageBuffer);

	return sErrMsg;
}

bool CGI::GetServerName(CTDVString *oServerName)
{
	*oServerName = m_ServerName;
	return true;
}

void CGI::SetHeader(const TDVCHAR *pHeader)
{
	// Check for NULL pointers!
	if (m_pECB != NULL)
	{
        CTDVString s = pHeader;
        s << "\r\n";
        m_sHeaders << s;
        //CRipleyServerExtension::WriteContext(m_pECB,s);
		//m_pCtxt << pHeader << "\r\n";
		// This tells the server where the headers end
		//m_pCtxt->m_dwEndOfHeaders = m_pCtxt->m_pStream->GetStreamSize();
	}
}

/*********************************************************************************

	CSmileyList* CGI::GetSmileyList()

	Author:		Kim Harries
	Created:	20/10/2000
	Inputs:		-
	Outputs:	-
	Returns:	A pointer to the single instance of the smiley list.
	Purpose:	Gives a pointer allowing access to the smiley list member
				variable.

*********************************************************************************/

CSmileyList* CGI::GetSmileyList()
{
	return &m_Smilies;
}

/*********************************************************************************

	bool CGI::LoadSmileyList(const TDVCHAR* sSmileyListFile)

	Author:		Kim Harries
	Created:	19/10/2000
	Inputs:		sSmileyListFile - path to a text file containing the smiley info
	Outputs:	-
	Returns:	true if loaded successfully, false if an error occurs
	Purpose:	If the given file exists and is in the right format then this method
				loads the name/ascii sequence pairs into the m_SmileyList member
				variable so that they can be accessed whenever required.

*********************************************************************************/

bool CGI::LoadSmileyList(const TDVCHAR* sSmileyListFile)
{
	// First initialise the smileytranslator with the default mappings
	CHttpUnit* pUnit = new CHttpUnit;
	m_Translator.AddUnit(pUnit, 'h');

	CArticleUnit* pArtUnit = new CArticleUnit(CArticleUnit::T_ARTICLE);
	m_Translator.AddUnit(pArtUnit, 'A');
	
	CArticleUnit* pForumUnit = new CArticleUnit(CArticleUnit::T_FORUM);
	pForumUnit->AddFilterExpression("F1");
	pForumUnit->AddFilterExpression("F2");
	pForumUnit->AddFilterExpression("F3");
	pForumUnit->AddFilterExpression("F4");
	pForumUnit->AddFilterExpression("F5");
	pForumUnit->AddFilterExpression("F6");
	pForumUnit->AddFilterExpression("F7");
	pForumUnit->AddFilterExpression("F8");
	pForumUnit->AddFilterExpression("F9");
	pForumUnit->AddFilterExpression("F10");
	pForumUnit->AddFilterExpression("F11");
	pForumUnit->AddFilterExpression("F12");
	m_Translator.AddUnit(pForumUnit, 'F');

	//Add Filter Expressions for U5 - U21 excluding valid users. 
	CArticleUnit* pUserUnit = new CArticleUnit(CArticleUnit::T_USER);
	pUserUnit->AddFilterExpression("U2");
	pUserUnit->AddFilterExpression("U8");
	pUserUnit->AddFilterExpression("U9");
	pUserUnit->AddFilterExpression("U10");
	pUserUnit->AddFilterExpression("U11");
	pUserUnit->AddFilterExpression("U14");
	pUserUnit->AddFilterExpression("U15");
	pUserUnit->AddFilterExpression("U16");
	pUserUnit->AddFilterExpression("U17");
	pUserUnit->AddFilterExpression("U18");
	pUserUnit->AddFilterExpression("U20");
	pUserUnit->AddFilterExpression("U21");
	m_Translator.AddUnit(pUserUnit, 'U');

	CArticleUnit* pCatUnit = new CArticleUnit(CArticleUnit::T_CATEGORY);
	pCatUnit->AddFilterExpression("C4");
	pCatUnit->AddFilterExpression("C5");
	m_Translator.AddUnit(pCatUnit, 'C');
	
	CArticleUnit* pClubUnit = new CArticleUnit(CArticleUnit::T_CLUB);
	pClubUnit->AddFilterExpression("G8");
	pClubUnit->AddFilterExpression("G4");
	pClubUnit->AddFilterExpression("G20");
	m_Translator.AddUnit(pClubUnit, 'G');

	CRelativeURLUnit* pRelURLUnit = new CRelativeURLUnit;
	m_Translator.AddUnit(pRelURLUnit,'<');

	CQuoteUnit* pQuoteUnit = new CQuoteUnit;
	m_Translator.AddUnit(pQuoteUnit,'<');

	CBracketUnit* pBrUnit = new CBracketUnit;
	m_Translator.AddUnit(pBrUnit, '<');
	m_Translator.AddUnit("\r\n", "<BR/>", false);
	m_Translator.AddUnit("\n", "<BR/>", false);
	m_Translator.AddUnit("<","&lt;",false);
	m_Translator.AddUnit(">", "&gt;",false);
	m_Translator.AddUnit("&", "&amp;",false);


	bool bOkay = true;
	// try to open the specified file and load the smiley map info from it
	FILE* fp = fopen(sSmileyListFile, "r");
	if (fp == NULL)
	{
		TDVASSERT(false, "Could not open file specified in CGI::LoadSmileyList(...)");
		bOkay = false;
	}
	// file exists, now try reading it
	if (bOkay)
	{
		TDVCHAR		ascii[256];
		TDVCHAR		name[256];
		int			iVarsRead = 0;
		int			iCount = 0;

		// read each name/ascii sequence pair in one by one, a bit like the animals going
		// into the arc, except less smelly
		while (!feof(fp) && bOkay)
		{
			iVarsRead = fscanf(fp, "%s %s ", ascii, name);
			if (iVarsRead == 2)
			{
				CTDVString sTag = "<SMILEY TYPE='***' H2G2='Smiley#***'/>";
				sTag.Replace("***", name);
				if (ascii[0] == '<')
				{
					pBrUnit->AddUnit(ascii+1, sTag);
				}
				else
				{
					m_Translator.AddUnit(ascii, sTag);
				}
				m_Smilies.AddPair(ascii, name);
				iCount++;
			}
			else
			{
				TDVASSERT(false, "Bad file format in CGI::LoadSmileyList(...)");
				bOkay = false;
			}
		}
		fclose(fp);
	}
	// if failed to read file then at least enter the standard pairs that
	// we always expect
	// TODO: should we clear the list first?
	if (!bOkay)
	{
		TDVASSERT(false, "Loading default smilies into smiley list");
		m_Smilies.AddPair(":-)", "smiley");
		m_Smilies.AddPair(":-(", "sadface");
		m_Smilies.AddPair(";-)", "winkeye");
		m_Smilies.AddPair("8-)", "bigeyes");
		m_Smilies.AddPair(":-P", "tongueout");
		m_Smilies.AddPair("><>", "fish");
	}
	// return success or not
	return bOkay;
}

bool CGI::GetParamsAsXML(CTDVString* oResult,const TDVCHAR* pPrefix)
{
	int iLength = m_Query.GetLength();
	int iPos = 0;
	bool bPrefixTestPassed = true;

	while (iPos < iLength)
	{
		// get the name of the parameter
		CTDVString sName = "";
		CTDVString sValue = "";
		while ((iPos < iLength) && m_Query.GetAt(iPos) != '?' && m_Query.GetAt(iPos) != '&' && m_Query.GetAt(iPos) != '=')
		{
			sName += m_Query.GetAt(iPos);
			iPos++;
		}
		if (iPos >= iLength || m_Query.GetAt(iPos) == '?' || m_Query.GetAt(iPos) == '&' )
		{
			if (pPrefix != NULL)
			{
				bPrefixTestPassed = (sName.FindText(pPrefix) == 0);
			}

			// Got to the end of the string without a value so store an empty param
			if (sName.GetLength() > 0 && bPrefixTestPassed)
			{
				*oResult << "<PARAM><NAME>" << sName << "</NAME><VALUE/></PARAM>";
			}
		}
		else
		{
			// name terminated by equals sign
			// Skip over the equals sign
			iPos++;
			
			// Get value (anything up to &, ? or end of string)
			while ((iPos < iLength) && m_Query.GetAt(iPos) != '?' && m_Query.GetAt(iPos) != '&')
			{
				sValue += m_Query.GetAt(iPos);
				iPos++;
			}
			UnEscapeString(&sValue);

			if (pPrefix != NULL)
			{
				bPrefixTestPassed = (sName.FindText(pPrefix) == 0);
			}

			if (sName.GetLength() > 0 && bPrefixTestPassed)
			{
				*oResult << "<PARAM><NAME>" << sName << "</NAME><VALUE>" << sValue << "</VALUE></PARAM>";
			}
		}

		// Skip over the terminator (if present)
		if (iPos < iLength)
		{
			iPos++;
		}
	}
	return true;
}

/*********************************************************************************

	void CGI::GetQueryHash(CTDVString& sHash)

		Author:		Mark Neves
        Created:	15/05/2006
        Inputs:		-
        Outputs:	sHash contains the hash code of the request query string, excluding the __ip__ param
        Returns:	-
        Purpose:	Makes a hash code from the query string for the request.

					Requests that come through the .htaccess file contain an __ip__ param.
					This is stripped out before creating the hash, otherwise the hash code would be uniqified
					based on the machine that issued the request.

*********************************************************************************/

void CGI::GetQueryHash(CTDVString& sHash)
{
	int start = m_Query.Find("__ip__",0);
	if (start != -1)
	{
		int end = start;
		while (end < m_Query.GetLength() && m_Query.GetAt(end) != '?' && m_Query.GetAt(end) != '&')
		{
			end++;
		}

		sHash.Empty();

		if (start > 0)
		{
			sHash = m_Query.Left(start-1);
		}
		else
		{
			end++;
		}

		sHash << m_Query.Mid(end);
	}
	else
	{
		sHash = m_Query;
	}

	CStoredProcedure::GenerateHash(sHash, sHash);
}

/*********************************************************************************

	bool CGI::DoesFileExist(const TDVCHAR* pFileName)

		Author:		Mark Neves
		Created:	12/02/2008
		Inputs:		-
		Outputs:	-
		Returns:	true if the given file exists, false otherwise
		Purpose:	-

*********************************************************************************/

bool CGI::DoesFileExist(const TDVCHAR* pFileName)
{
	OFSTRUCT of;
	HFILE h = ::OpenFile(pFileName,&of,OF_EXIST);
	return (HFILE_ERROR != h);
}

/*********************************************************************************

	void CGI::GenerateLogFileNameAndDate(CTDVString& sLogFileName, CTDVString& sDate)

		Author:		Mark Neves
		Created:	12/02/2008
		Inputs:		-
		Outputs:	sLogFileName = full path to the log file
					sDate = full date used to generate the file
		Returns:	-
		Purpose:	Centralised function that generates the log file that should
					be used at this point in time

*********************************************************************************/

void CGI::GenerateLogFileNameAndDate(CTDVString& sLogFileName, CTDVString& sDate)
{
	CTDVDateTime dDate = CTDVDateTime::GetCurrentTime();;
	sDate = (LPCTSTR)dDate.Format("%Y-%m-%d.%H:%M:%S ");
	sLogFileName = theConfig.GetInputLogPath();
	sLogFileName << (LPCTSTR)dDate.Format("in%Y%m%d%H.log");
}

/*********************************************************************************

	void CGI::TruncateLogFile(CTDVString& sLogFile, DWORD nFilePointer)

		Author:		Mark Neves
		Created:	12/02/2008
		Inputs:		sLogFile = the log file to truncate
					nFilePointer = the point in the file to truncate it to
		Outputs:	-
		Returns:	-
		Purpose:	This truncates the given file to the point specified in nFilePointer.

*********************************************************************************/

void CGI::TruncateLogFile(CTDVString& sLogFile, DWORD nFilePointer)
{
	HANDLE hLogfile = ::CreateFile(sLogFile, GENERIC_WRITE, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hLogfile != INVALID_HANDLE_VALUE)
	{
		::SetFilePointer(hLogfile, nFilePointer, NULL, FILE_BEGIN);
		::SetEndOfFile(hLogfile);
		::CloseHandle(hLogfile);
	}
}

/*********************************************************************************

	void CGI::WriteLogFilePointer(DWORD nLogFilePtr)

		Author:		Mark Neves
		Created:	12/02/2008
		Inputs:		nLogFilePtr = The current log file ptr
		Outputs:	-
		Returns:	-
		Purpose:	Writes the log file ptr number to a known file inside the InputLog folder

*********************************************************************************/

void CGI::WriteLogFilePointer(DWORD nLogFilePtr)
{
	CTDVString sPathname = theConfig.GetInputLogPath();
	sPathname << "logfileptr.txt";
	HANDLE h = ::CreateFile(sPathname, GENERIC_WRITE, FILE_SHARE_READ, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	if (h != INVALID_HANDLE_VALUE)
	{
		CTDVString sLogFilePtr(nLogFilePtr);
		sLogFilePtr << "                              "; // Make sure we blat out any existing digits
		DWORD nBytesRead;
		::SetFilePointer(h, 0, NULL, FILE_BEGIN);
		::WriteFile(h, sLogFilePtr, sLogFilePtr.GetLength(), &nBytesRead, NULL);
		::CloseHandle(h);
	}
}

/*********************************************************************************

	DWORD CGI::ReadLogFilePtr()

		Author:		Mark Neves
		Created:	12/02/2008
		Inputs:		-
		Outputs:	-
		Returns:	The log file ptr read from file, or 0 if it can't find the file
		Purpose:	Reads the last written file ptr value, or 0 if it fails to open the file

*********************************************************************************/

DWORD CGI::ReadLogFilePtr()
{
	DWORD ptr = 0;

	CTDVString sPathname = theConfig.GetInputLogPath();
	sPathname << "logfileptr.txt";
	HANDLE h = ::CreateFile(sPathname, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (h != INVALID_HANDLE_VALUE)
	{
		CHAR lpBuffer[30];
		DWORD nBytesRead;
		if (::ReadFile(h,lpBuffer,30,&nBytesRead,NULL) != 0)
		{
			ptr = atoi(lpBuffer);
		}
		::CloseHandle(h);
	}

	return ptr;
}


void CGI::WriteInputLog(const TDVCHAR* pString)
{
	CAutoCS cs(&s_CSLogFile);

	CTDVString sPathname, sDate;
	CGI::GenerateLogFileNameAndDate(sPathname, sDate);

	if (!CGI::DoesFileExist(sPathname))
	{
		// We have a new log file
		if (!CGI::s_LastLogFile.IsEmpty())
		{
			// We've been writing to this file, so shrink it
			CGI::TruncateLogFile(CGI::s_LastLogFile,CGI::s_CurLogFilePtr);
		}
		CGI::s_CurLogFilePtr = 0;
		CGI::s_LastLogFile = sPathname;
	}

	HANDLE hLogfile = CreateFile(sPathname, GENERIC_WRITE, FILE_SHARE_READ, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hLogfile != INVALID_HANDLE_VALUE)
	{
		if (CGI::s_CurLogFilePtr == 0)
		{
			// It's a new log file, so pre-allocate some disk space
			LONG d = theConfig.GetInitialLogFileSize();
			SetFilePointer(hLogfile, d, NULL, FILE_BEGIN);
			SetEndOfFile(hLogfile);
		}
		SetFilePointer(hLogfile, CGI::s_CurLogFilePtr, NULL, FILE_BEGIN);

		//SetFilePointer(hLogfile, 0, NULL, FILE_END);
		DWORD dBytes;
		CTDVString sCount;
		sCount << m_ThisRequest;
		WriteFile(hLogfile, sCount, sCount.GetLength(), &dBytes, NULL);
		WriteFile(hLogfile, " ", 1, &dBytes, NULL);
		WriteFile(hLogfile, sDate, sDate.GetLength(), &dBytes, NULL);
		WriteFile(hLogfile, pString, strlen(pString), &dBytes, NULL);
		WriteFile(hLogfile, "\r\n", 2, &dBytes, NULL);

		CGI::s_CurLogFilePtr = SetFilePointer(hLogfile, 0, NULL, FILE_CURRENT);

		CGI::WriteLogFilePointer(CGI::s_CurLogFilePtr);

		CloseHandle(hLogfile);
	}
}

bool CGI::InitialiseStoredProcedureObject(CStoredProcedure *pSP)
{
	DBO* pDBO;
	try 
	{
		pDBO = new DBO(GetDBConnection());
	}
	catch(...)
	{
		return false;
	}
	pSP->Initialise(pDBO, m_SiteID, this);
	return pDBO->IsGoodConnection();
}

bool CGI::InitialiseStoredProcedureObject(CStoredProcedureBase& sp)
{
	DBO* pDBO;
	try 
	{
		pDBO = new DBO(GetDBConnection());
	}
	catch(...)
	{
		return false;
	}
	sp.Initialise(pDBO, this);
	return true;
}

DBO* CGI::GetWriteDatabaseObject()
{
	DBO* pDBO;
	try
	{
		//LogTimerEvent("Initialising DBO");
		pDBO = new DBO(GetWriteDBConnection());
		//LogTimerEvent("Finished initialising DBO");
	}
	catch(...)
	{
		return NULL;
	}
	return pDBO;
}

bool CGI::StartInputLog()
{
	m_ThisRequest = InterlockedIncrement(&m_ReqCount);
	CTDVString sForwarded;
	if (!GetServerVariable("X_FORWARDED_FOR", sForwarded))
	{
		sForwarded = "-";
	}
	CTDVString sHost;
	GetServerVariable("REMOTE_HOST", sHost);
	sForwarded.Replace(" ","+");
	sHost.Replace(" ","+");
	CTDVString sLogLine;
	sLogLine << "OPEN " << m_Command << " " << m_Query << " " << sHost << " " << sForwarded;
	WriteInputLog(sLogLine);
	return true;
}

/*********************************************************************************

	bool CGI::InitialiseFromDatabase()

	Author:		Jim Lynn
	Created:	15/07/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if succeeded, false if failed
	Purpose:	Imitialise data from the database for this CGI object. This call
				should be made for the model CGI object, a copy of which

*********************************************************************************/

bool CGI::InitialiseFromDatabase(bool bCreateNewSiteList)
{
	if (m_pSiteList == NULL)
	{
		m_pSiteList = new CSiteList;
		m_pSiteOptions = new CSiteOptions();
		m_pUserGroups = new CUserGroups();
		m_pDynamicLists = new CDynamicLists();
		m_pProfilePool = new CProfileConnectionPool(theConfig.GetMdbConfigFile(),theConfig.GetIdentityUri());
		m_pStatistics = new CRipleyStatistics;
		m_bWasInitialisedFromDatabase = true;
		m_pSiteList->Lock();
	}
	else
	{
		m_pSiteList->Lock();
		m_pSiteList->Clear();
	}
	
	bool bSiteDataFound = InitialiseSiteList(m_pSiteList);
	
	if (bSiteDataFound)
	{
		//Setup Topics for all sites.
		RefreshTopics(m_pSiteList);

		// Now setup the profanity list
		RefreshProfanityList();

		// Now setup the allowed url list
		RefreshAllowedURLList();

		m_pSiteOptions->GetAllSiteOptions(this);
	}
	// Signal that the DB has initialised OK at the last possible moment
	m_bSiteListInitialisedFromDB = bSiteDataFound;

	m_pSiteList->Unlock();
	return m_bSiteListInitialisedFromDB;
}

bool CGI::InitialiseSiteList(CSiteList* pSiteList)
{
		// Information we need to get from the database:
	// List of sites and their rules
	int iPrevSiteID = 0;
	CStoredProcedure SP;
	bool bSPInitialised = InitialiseStoredProcedureObject(&SP);
	if (!bSPInitialised)
	{
		//detect failure as early as possible to so when can 
		//abort the request and not leave the user wondering.
		pSiteList->Unlock();
		return false;
	}
	
	CStoredProcedure SP1;
	bSPInitialised = InitialiseStoredProcedureObject(&SP1);
	if (!bSPInitialised)
	{
		//detect failure as early as possible to so when can 
		//abort the request and not leave the user wondering.
		pSiteList->Unlock();
		return false;
	}

	SP.FetchSiteData();

	CTDVString sURLName;
	CTDVString sSSOService;
	CTDVString sDescription;
	CTDVString sSkinDescription;
	CTDVString sDefaultSkin;
    CTDVString sSkinSet;
	CTDVString sSkinName;
	CTDVString sShortName;
	CTDVString sModeratorsEmail;
	CTDVString sEditorsEmail;
	CTDVString sFeedbackEmail;
	CTDVString sEMailAlertSubject;
	int iAutoMessageUserID;
	int iThreadOrder;
	int iAllowRemoveVote;
	int iIncludeCrumbtrail;
	int iAllowPostCodesInSearch;
	int iThreadEditTimeLimit;
	int iEventAlertMessageUserID;
	bool bPreModeration;
	bool bNoAutoSwitch;
	bool bUseFrames;
	bool bPassworded;
	bool bUnmoderated;
	bool bArticleGuestBookForums;
	bool bQueuePostings;
	bool bSiteEmergencyClosed;
	bool bIsKidsSite;
	bool bUseIdentitySignIn;
	CTDVString sIdentityPolicy;
	CTDVString sSiteConfig;
	
	bool bSiteDataFound = !SP.IsEOF();

	// Now read all the skin information
	while (!SP.IsEOF())
	{
		int iSiteID = SP.GetIntField("SiteID");
		if (iSiteID != iPrevSiteID)
		{
			SP.GetField("URLName", sURLName);
			SP.GetField("SSOService", sSSOService);
			iThreadOrder = SP.GetIntField("ThreadOrder");
			iAllowRemoveVote = SP.GetIntField("AllowRemoveVote");
			iIncludeCrumbtrail = SP.GetIntField("IncludeCrumbtrail");
			iAllowPostCodesInSearch = SP.GetIntField("AllowPostCodesInSearch");
			bSiteEmergencyClosed = SP.GetBoolField("SiteEmergencyClosed");
			iThreadEditTimeLimit = SP.GetIntField("ThreadEditTimeLimit");
			iEventAlertMessageUserID = SP.GetIntField("EventAlertMessageUserID");
			SP.GetField("Description", sDescription);
			SP.GetField("DefaultSkin", sDefaultSkin);
			SP.GetField("ShortName", sShortName);
			SP.GetField("ModeratorsEmail", sModeratorsEmail);
			SP.GetField("EditorsEmail", sEditorsEmail);
			SP.GetField("FeedbackEmail", sFeedbackEmail);
			SP.GetField("EventEMailSubject", sEMailAlertSubject);
			bPreModeration = SP.GetBoolField("PreModeration");
			bNoAutoSwitch = SP.GetBoolField("NoAutoSwitch");
			bPassworded = SP.GetBoolField("Passworded");
			bUnmoderated = SP.GetBoolField("Unmoderated");
			bQueuePostings = SP.GetBoolField("QueuePostings");
			bArticleGuestBookForums = (SP.GetIntField("ArticleForumStyle") == 1);
			iAutoMessageUserID = SP.GetIntField("AutoMessageUserID");
            SP.GetField("SkinSet", sSkinSet);

			SP.GetField("config",sSiteConfig);
			if (sSiteConfig.IsEmpty())
			{
				CSiteConfig SiteConfig(GetInputContext());
				SiteConfig.CreateEmptyConfig();
				SiteConfig.GetAsString(sSiteConfig);
			}

			bUseIdentitySignIn = SP.GetBoolField("UseIdentitySignIn");

			int iMinAge = -1, iMaxAge = -1;
			bIsKidsSite = SP.GetBoolField("IsKidsSite");
			if (bIsKidsSite)
			{
				iMinAge = 0, iMaxAge = 16;
			}
			else
			{
				iMinAge = 0, iMaxAge = 255;
			}

			CTDVString sMinMaxAge;
			sMinMaxAge = "Setting site details for ";
			sMinMaxAge << sURLName;
			LogTimerEvent(sMinMaxAge);

			SP.GetField("IdentityPolicy",sIdentityPolicy);

			pSiteList->AddSiteDetails(sURLName, iSiteID, bPreModeration, 
								sDefaultSkin, bNoAutoSwitch, sDescription, 
								sShortName, sModeratorsEmail, sEditorsEmail,
								sFeedbackEmail,iAutoMessageUserID, bPassworded,
								bUnmoderated, bArticleGuestBookForums, sSiteConfig,
								iThreadOrder, sEMailAlertSubject, iThreadEditTimeLimit, 
								iEventAlertMessageUserID, iAllowRemoveVote, iIncludeCrumbtrail,
								iAllowPostCodesInSearch, bQueuePostings, bSiteEmergencyClosed,
								iMinAge, iMaxAge, sSSOService, bIsKidsSite, bUseIdentitySignIn,
								sSkinSet, sIdentityPolicy );
			iPrevSiteID = iSiteID;
		}

		SP.GetField("SkinName", sSkinName);
		SP.GetField("SkinDescription", sSkinDescription);
		bUseFrames = SP.GetBoolField("UseFrames");
		pSiteList->AddSkinToSite(sURLName, sSkinName, sSkinDescription, bUseFrames);

		SP.MoveNext();
	}
		SP.Release();
	//for (int iSiteID = 1; iSiteID <= pSiteList->GetMaxSiteId(); iSiteID++)
	//{
	//	// Read site-related information from the SSO database
	//	// Default values to -1.  This means that if SSO is unavailable at this point, we will know about it.
	//	// Once SSO is available again, we can recahce the site info.
	//	CTDVString ssoService;
	//	if (pSiteList->GetSSOService(iSiteID, &ssoService))
	//	{
	//		int iMinAge = -1, iMaxAge = -1;
	//		CProfileConnection conn;
	//		if (m_pProfilePool->GetConnection(conn,false))
	//		{
	//			conn.GetServiceMinAndMaxAge(ssoService,iMinAge,iMaxAge);
	//		}
	//		//iMinAge=0;iMaxAge=255;
	//		// Record this in the Input Logs
	//		CTDVString sMinMaxAge;
	//		sMinMaxAge << "Site " << iSiteID << " : MinAge=" << iMinAge << " : MaxAge=" << iMaxAge;
	//		WriteInputLog(sMinMaxAge);
	//		pSiteList->SetSiteMinMaxAge(iSiteID, iMinAge,iMaxAge);
	//	}
	//}
			SP1.GetKeyArticleList(0);
			while (!SP1.IsEOF())
			{
				CTDVString sName;
				SP1.GetField("ArticleName", sName);
				int siteID = SP1.GetIntField("SiteID");
				pSiteList->AddArticle(siteID, sName);
				SP1.MoveNext();
			}
		SP1.GetSiteOpenCloseTimes(0);
		while (!SP1.IsEOF())
		{
			int iDayWeek = SP1.GetIntField("DayWeek");
			int iHour = SP1.GetIntField("Hour");
			int iMinute = SP1.GetIntField("Minute");
			int iClosed = SP1.GetIntField("Closed");
			int siteID = SP1.GetIntField("SiteID");
			pSiteList->AddSiteOpenCloseTime(siteID, iDayWeek, iHour, iMinute, iClosed);
			SP1.MoveNext();
		}
		SP1.GetReviewForums(0);
		while (!SP1.IsEOF())
		{
			CTDVString sName;
			SP1.GetField("URLFriendlyName", sName);
			int siteID = SP1.GetIntField("SiteId");
			int iForumID = SP1.GetIntField("ReviewForumID");
			pSiteList->AddReviewForum(siteID, sName, iForumID);
			SP1.MoveNext();
		}

	return bSiteDataFound;
}


/*********************************************************************************
	bool CGI::GetSkin()

	Author:		
	Created:	
	Inputs:		-
	Outputs:	-
	Returns:	true if succeeded, false if failed
	Purpose:	Returns the requested skin as specified with the _sk parameter. 

*********************************************************************************/
bool CGI::GetSkin(CTDVString* pSkinName )
{
	*pSkinName = m_SkinName;
	return true;
}

/*********************************************************************************
	bool CGI::GetSiteSkin()

	Author:		
	Created:	
	Inputs:		-
	Outputs:	-
	Returns:	true if succeeded, false if failed
	Purpose:	Returns the skin set or branding skin group for a site
*********************************************************************************/
bool CGI::GetSkinSet(CTDVString* pSkinSet )
{
    m_pSiteList->GetSkinSet(m_SiteID,pSkinSet);
	return true;
}

bool CGI::TestSetServerVariable(const TDVCHAR *pName, const TDVCHAR *pValue)
{
	CTDVString temp(pName);
	temp.MakeUpper();

	m_ServerVariables[temp] = pValue;
	return true;
}

#define REQUIRED_WINSOCK_VERSION 0x0101

bool CGI::SendMail(const TDVCHAR* pEmail, const TDVCHAR* pSubject, const TDVCHAR* pBody, const TDVCHAR* pFromAddress, const TDVCHAR* pFromName, const bool bInsertLineBreaks)
{
	CTDVString sServer = theConfig.GetSmtpServer();
	CTDVString sReturnAddress = pFromAddress;
	CTDVString sReturnName = pFromName;
	CTDVString sClientAddr;
	CTDVString sBody(pBody);

	if (bInsertLineBreaks)
	{
		CTDVString sOldBody(pBody);
		CLineBreakInserter lineBreakInserter(72);
		sBody = lineBreakInserter(sOldBody);
	}

	bool bSuccess = true;
	if (sServer.GetLength() == 0)
	{
		TDVASSERT(false, "No SMTP server name defined");
		bSuccess = false;
	}
	else
	{

		GetClientAddr(sClientAddr);
		// use default return address if none given
		if (sReturnAddress.GetLength() == 0)
		{
			GetEmail(EMAIL_FEEDBACK, sReturnAddress);
			GetShortName(sReturnName);
		}

		WSADATA	wsaData;
		if ( WSAStartup(REQUIRED_WINSOCK_VERSION, &wsaData) == 0 )
		{

			VSMTPSocket MailSock;
			VUINT err = MailSock.Connect(sServer);
	//		VUINT err = MailSock.Connect("post.tdv.com");
			if (err == VSMTPSocket::ERROR_CONNECT_NONE)
			{
				MailSock.SendHello();
				MailSock.SendMailFrom(sReturnAddress);
				MailSock.SendRecipient(pEmail);
				MailSock.SendRecipient(sReturnAddress);
	//			MailSock.SendRecipient("h2g2.feedback@bbc.co.uk");
	//#ifdef _DEBUG
	//CTDVString	sEmail = pEmail;
	// only send emails to bbc addresses when debugging
	//if (sEmail.FindText("@bbc.co.uk") < 0)
	//{
	//	sEmail = "kim.harries@bbc.co.uk";
	//}
	//MailSock.SendRecipient(sEmail);
	//#else
	//#error send mail still set to kim.harries@bbc.co.uk
	//#endif
				MailSock.SendData();
				CTDVString tofield;
				if (sClientAddr.GetLength() > 0)
				{
					tofield = "X-Originating-IP: [";
					tofield << sClientAddr << "]";
					MailSock.SendMessage(tofield);
				}
				MailSock.SendSubject(pSubject);
				tofield = "To: ";
				tofield << pEmail;
				MailSock.SendMessage(tofield);
				tofield = "From: ";
				tofield << "\"" << sReturnName << "\" <" << sReturnAddress << ">";
				MailSock.SendMessage(tofield);
				//MailSock.SendMessage("To: James Lynn <jim@h2g2.com>");
				//MailSock.SendMessage("Reply-To: James F Lynn <jim@h2g2.com>");
				MailSock.SendMessage("\r\n");
				MailSock.SendMessage(sBody);
				MailSock.SendEndData();
				MailSock.SendQuit();
				MailSock.Disconnect();
			}
			else
			{
				bSuccess = false;
			}
			// Cleanup sockets
			WSACleanup();
		}
		else
		{
			bSuccess = false;;
		}
	}

	if (bSuccess)
	{
		return true;
	}
	else
	{
		TDVASSERT(false, "Error connecting to VSMTPSocket in CXMLBuilder::SendMail(...)");

		//Create a unique filename. QueryPerformanceCounter used to distinguish emails sent within a second.
		CTDVString sFilename = "M";
		CTDVDateTime dt = CTDVDateTime::GetCurrentTime();
		sFilename << (LPCTSTR)dt.Format("%Y%m%d%H%M%S");
		LARGE_INTEGER counter;
		QueryPerformanceCounter(&counter);
		sFilename << "-" <<  long(counter.HighPart) << long(counter.LowPart) << ".txt";
		
		CTDVString sMail;
		sMail << "From: " << sReturnAddress << "\r\n";
		sMail << "Recipient: " << pEmail << "\r\n";

		CTDVString tofield;
		if (sClientAddr.GetLength() > 0)
		{
			tofield = "X-Originating-IP: [";
			tofield << sClientAddr << "]";
			sMail << tofield << "\r\n";
		}
		sMail << "Subject: " << pSubject << "\r\n";
		tofield = "To: ";
		tofield << pEmail;
		sMail << tofield << "\r\n";
		tofield = "From: ";
		tofield << "\"" << sReturnName << "\" <" << sReturnAddress << ">";
		sMail << tofield << "\r\n";
		//MailSock.SendMessage("To: James Lynn <jim@h2g2.com>");
		//MailSock.SendMessage("Reply-To: James F Lynn <jim@h2g2.com>");
		sMail << "\r\n";
		sMail << pBody;
		
		CachePutItem("failedmails",sFilename, sMail);

		return false;
	}
}

bool CGI::SendDNASystemMessage(int piSendToUserID, int piSiteID, const TDVCHAR* psMessageBody)
{
	bool bSuccess; 
	CStoredProcedure SP;

	if (m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return bSuccess = SP.SendDNASystemMessage(piSendToUserID, piSiteID, psMessageBody);
	}

	return false; // failed to initialise stored procedure error
}

bool CGI::SendMailOrSystemMessage(const TDVCHAR* pEmail, const TDVCHAR* pSubject, const TDVCHAR* pBody, const TDVCHAR* pFromAddress, const TDVCHAR* pFromName, const bool bInsertLineBreaks, int piUserID, int piSiteID)
{
	if (IsSystemMessagesOn(piSiteID) && piUserID > 0)
	{
		return SendDNASystemMessage(piUserID, piSiteID, pBody);
	}
	else 
	{
		return SendMail(pEmail, pSubject, pBody, pFromAddress, pFromName, bInsertLineBreaks);
	}
}

bool CGI::GetPreModerationState()
{
	return m_bPreModeration;
}


/*********************************************************************************

	bool CGI::ChangeSite(int iSiteID)

	Author:		Jim Lynn
	Created:	24/07/2001
	Inputs:		iSiteID - ID of the new site to change to
	Outputs:	-
	Returns:	true if succeeded, false otherwise (bad site ID?)
	Purpose:	Based on site rules, and the source site of a piece of content,
				the builder needs to be able to switch the site to another.
				This method changes the current site rules etc. to another site.
*********************************************************************************/

bool CGI::ChangeSite(int iSiteID)
{
	if (!m_ProfileConnection.IsInitialised())
	{
		return false;
	}

	//CTDVString sDefaultSkin;
	m_SiteID = iSiteID;
	m_pSiteList->GetSiteDetails(m_SiteID, &m_SiteName, &m_bPreModeration, 
								&m_DefaultSkinPreference, &m_bNoAutoSwitch, &m_SiteDescription, 
								NULL, NULL, NULL, NULL,NULL, NULL, NULL,NULL, &m_SiteConfig, NULL,
								NULL, &m_ThreadEditTimeLimit, NULL, NULL, NULL, NULL, NULL, &m_SSOService );

	//Get Topics for this Site.
	m_pSiteList->GetTopicsXML(m_SiteID,m_sTopicsXML);

	if (m_pCurrentUser != NULL)
	{
		delete m_pCurrentUser;
		m_pCurrentUser = NULL;
	}
	
	bool bRet = false;
	if (m_pSiteList->GetSiteUsesIdentitySignIn(m_SiteID))
	{
		bRet = m_ProfileConnection.SetService(m_pSiteList->GetSiteIdentityPolicy(m_SiteID), this);
	}
	else
	{
		bRet = m_ProfileConnection.SetService(m_SSOService, this);		
	}

	//if this fails we should keep going but output a debug error message
	if (!bRet)
	{
		TDVASSERT(false,"In CGI::Initialise() failed to set the service name");
	}

	CreateCurrentUser();
	
    // Skins are Managed and verified by SkinSelector class.
/*	if (bSwapSkins)
	{
		m_SkinName = "";
		if (m_pCurrentUser != NULL && m_pCurrentUser->GotUserData())
		{
			m_pCurrentUser->GetPrefSkin(&m_SkinName);
		}
		
		if (m_SkinName.GetLength() == 0)
		{
			m_SkinName = m_DefaultSkinPreference;
		}

		// Force the skin to match the site properly
		if (!m_pSiteList->SkinExistsInSite(m_SiteID, m_SkinName) && !m_SkinName.CompareText("purexml") && !(m_SkinName.FindText("http://") == 0) && !m_SkinName.CompareText("xml"))
		{
			m_SkinName = m_DefaultSkinPreference;
		}
    }*/
	return true;
}

int CGI::GetSiteID()
{
	return m_SiteID;
}

int CGI::GetModClassID()
{
	return m_SiteModClassMap[GetSiteID()];
}

int CGI::GetThreadOrder()
{
	return m_ThreadOrder;
}
int CGI::GetAllowRemoveVote()
{
	return m_AllowRemoveVote;
}

int CGI::GetIncludeCrumbtrail()
{
	return m_IncludeCrumbtrail;
}

int CGI::GetAllowPostCodesInSearch()
{
	return m_AllowPostCodesInSearch;
}

/*********************************************************************************

	bool CGI::IsSiteClosed(int iSiteID, bool &bIsClosed)

		Author:		Mark Howitt
		Created:	20/07/2006
		Inputs:		iSiteID - The site that you want to know is closed or not
		Outputs:	bIsClosed - The closed status of the given site
		Returns:	True if the site is closed OR Emergency closed, false if open
		Purpose:	Returns the open or closed state for a given site

*********************************************************************************/
bool CGI::IsSiteClosed(int iSiteID, bool &bIsClosed)
{
	// Return true if the site is emergency closed OR the scheduled events have closed the site.
	bool bIsEmergencyClosed = false;
	bool bOk = m_pSiteList->IsSiteEmergencyClosed(iSiteID,bIsEmergencyClosed);
	if (bIsEmergencyClosed)
	{
		bIsClosed = true;
}
	else
{
		bOk = bOk && m_pSiteList->GetSiteScheduledClosed(iSiteID,bIsClosed);
}
	TDVASSERT(bOk,"Failed To Get Site Is Closed Details");
	return bOk;
}

/*********************************************************************************

	bool CGI::IsSiteEmergencyClosed(int iSiteID, bool &bEmergencyClosed)

		Author:		Mark Howitt
		Created:	20/07/2006
		Inputs:		iSiteID - The site that you want to know is emergency closed or not
		Outputs:	bEmergencyClosed - The sites emergency closed status
		Returns:	True if the site is emergency closed
		Purpose:	Returns the status of the site emergency closed setting

*********************************************************************************/
bool CGI::IsSiteEmergencyClosed(int iSiteID, bool &bEmergencyClosed)
{
	bool bOk = m_pSiteList->IsSiteEmergencyClosed(iSiteID,bEmergencyClosed);
	TDVASSERT(bOk,"Failed To Get Site Is Emergency Closed Details");
	return bOk;
}

/*********************************************************************************

	bool CGI::SetSiteIsEmergencyClosed(int iSiteID, bool bEmergencyClosed)

		Author:		Mark Howitt
		Created:	20/07/2006
		Inputs:		iSiteID - the site that you want to set the emergency closed status for.
					bEmergencyClosed - The new value for the site emergency closed status
		Purpose:	Sets the sites emergency closed status

*********************************************************************************/
bool CGI::SetSiteIsEmergencyClosed(int iSiteID, bool bEmergencyClosed)
	{
	bool bOk = m_pSiteList->SetSiteIsEmergencyClosed(iSiteID,bEmergencyClosed);
	TDVASSERT(bOk,"Failed To Set Site Is Emergency Closed Details");
	return bOk;
	}

/*********************************************************************************

	bool CGI::GetSiteScheduleAsXMLString(int iSiteID, CTDVString& sXML)

		Author:		Mark Howitt
		Created:	21/07/2006
		Inputs:		iSiteID - the site that you want to get the Schedule for
		Outputs:	-
		Returns:	true if ok, false if not
		Purpose:	Gets the schedule for a given site

*********************************************************************************/
bool CGI::GetSiteScheduleAsXMLString(int iSiteID, CTDVString& sXML)
	{
	bool bOk = m_pSiteList->GetSiteScheduleAsXMLString(iSiteID, sXML);
	TDVASSERT(bOk,"Failed To Get Site Schedule Details");
	return bOk;
	}
	
bool CGI::IsForumATopic(int iSiteID, int iForumID)
{
	return m_pSiteList->IsForumATopic(iSiteID, iForumID);
}


bool CGI::GetNoAutoSwitch()
{
	return m_bNoAutoSwitch;
}

int CGI::GetThreadEditTimeLimit()
{
	return m_ThreadEditTimeLimit;
}

bool CGI::GetNameOfSite(int iSiteID, CTDVString *oName)
{
	return m_pSiteList->GetNameOfSite(iSiteID, oName);
}

bool CGI::GetSiteSSOService(int iSiteID, CTDVString* psSSOService )
{
	if ( !psSSOService )
		return NULL;

	return m_pSiteList->GetSSOService(iSiteID, psSSOService );
}

CTDVString CGI::GetNameOfCurrentSite()
{
	CTDVString sSiteName;
	GetNameOfSite(GetSiteID(),&sSiteName);
	return sSiteName;
}

bool CGI::GetSiteListAsXML(CTDVString *oXML, int iMode)
{
	return m_pSiteList->GetAsXMLString(oXML, iMode);
}

CTDVString CGI::GetSiteAsXML(int iSiteID, int iMode)
{
	CTDVString sXML;
	m_pSiteList->GetSiteAsXMLString(iSiteID, sXML, iMode);
	return sXML;
}

bool CGI::MakeCUDRequest(const TDVCHAR *pRequest, CTDVString *oResponse)
{
	return MakeURLRequest(theConfig.GetRegServer(), "POST", theConfig.GetRegProxy(), 
		theConfig.GetRegScript(), pRequest, *oResponse, CTDVString() );
}

/*********************************************************************************

	void CGI::SiteDataUpdated()

	Author:		Jim Lynn
	Created:	26/10/2001
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Signals to all other web servers (asynchronously?) that the data
				for the current site has changed, and that it should clear and
				re-read its cached data.

*********************************************************************************/

void CGI::SiteDataUpdated()
{
	//InitialiseFromDatabase(false);
	CSiteList templist;
	bool bSiteDataFound = InitialiseSiteList(&templist);
	
	if (bSiteDataFound)
	{
		//Setup Topics for all sites.
		RefreshTopics(&templist);

		// Now setup the profanity list
		RefreshProfanityList();

		// Now setup the allowed url list
		RefreshAllowedURLList();

		CSiteOptions options;
		options.GetAllSiteOptions(this);
		m_pSiteList->Lock();
		m_pSiteList->SwapData(templist);
		m_pSiteOptions->SwapData(options);
		m_pSiteList->Unlock();
	}

}

bool CGI::ConvertPlainText(CTDVString* oResult, int MaxSmileyLimit)
{
	return m_Translator.Translate(oResult, MaxSmileyLimit);
}

/*

  Signalling:

  Start a number of new threads which simply signal the other servers in the web farm
  with the supplied URL. Because they are separate threads, they will not block the 
  current thread from completing.

  They can't rely on any data structures from the existing request as they might get
  deleted before this thread completes, so we create a special object to hold all the
  data we need (which is just the proxy server name and URL for now).

*/

class CSignalData
{
public:
	CSignalData(const TDVCHAR* pURL, const TDVCHAR* pHost, const TDVCHAR* pProxyName);
	virtual ~CSignalData() {}
	CTDVString	m_Proxy;
	CTDVString	m_Host;
	CTDVString	m_URL;
	int			m_Port;
private:
	CSignalData() {}
};

CSignalData::CSignalData(const TDVCHAR* pURL, const TDVCHAR* pHost, const TDVCHAR* pProxyName) : m_Proxy(pProxyName), m_URL(pURL), m_Port(INTERNET_DEFAULT_HTTP_PORT), m_Host(pHost)
{
	//Check to see if host has port identified. eg 127.0.01:80
	CTDVString parse = pHost;
	int colon = parse.Find(':');
	if ( colon > 0 )
	{
		m_Host = parse.Left(colon);
		CTDVString sPort = parse.Mid(colon+1);
		if ( sPort.GetLength() > 0 )
		{
			m_Port = atoi(sPort);
		}
	}
}

UINT SendSignal( LPVOID lpParam)
{
	CSignalData* pSigData = (CSignalData*) lpParam;
	HINTERNET nethandle;
	if (pSigData->m_Proxy.GetLength() == 0)
	{
		nethandle = InternetOpen(NULL, INTERNET_OPEN_TYPE_DIRECT ,NULL , NULL, NULL);
	}
	else
	{
		nethandle = InternetOpen(NULL, INTERNET_OPEN_TYPE_PROXY, pSigData->m_Proxy, NULL, NULL);
	}
	
	// Get the useragent
	CTDVString sHeader = "User-Agent: DNA-Signaller\r\n";
	
	HINTERNET httphandle = InternetConnect(nethandle,
											pSigData->m_Host,
											pSigData->m_Port,
											NULL,
											NULL,
											INTERNET_SERVICE_HTTP ,
											NULL,
											0);

	
	HINTERNET urlhandle = HttpOpenRequest(	httphandle,
											"GET",
											pSigData->m_URL,
											NULL,
											NULL,
											NULL,
											INTERNET_FLAG_NO_AUTO_REDIRECT,
											0);
	
	if (!HttpSendRequest(urlhandle, sHeader, sHeader.GetLength(), NULL, 0))
	{
		DWORD err = GetLastError();
		delete pSigData;
		return 0;
	}
	
/*
	char buf[65536];
	bool bNotFinished = true;
	while (bNotFinished)
	{
		DWORD buflen = 65535;
		bool bResult = (InternetReadFile(urlhandle, buf, buflen, &buflen) != 0);
		if (!bResult)
		{
			DWORD err = GetLastError();
		}
		if (bResult && buflen > 0)
		{
			buf[buflen] = 0;
			*oResponse << buf;
		}
		if (bResult && buflen == 0)
		{
			bNotFinished = false;
		}
	}
	
*/
	InternetCloseHandle(urlhandle);
	InternetCloseHandle(httphandle);
	InternetCloseHandle(nethandle);
	delete pSigData;
	return 0;
}

bool CGI::Signal(const TDVCHAR *pURL)
{
	STRINGVECTOR::const_iterator start = theConfig.GetServerArray().begin();
	STRINGVECTOR::const_iterator end = theConfig.GetServerArray().end();
	while (start != end)
	{
		CSignalData* pSigData = new CSignalData(pURL, *start++, "");
		AfxBeginThread(&SendSignal, pSigData, 0, 0, 0, NULL);
	}

	CTDVString sDotNetURL(pURL);
	sDotNetURL = "/dna" + sDotNetURL.Mid(1) + "&skin=purexml";

	CTDVString sAPISigURL(pURL);
	int paramsStart = sDotNetURL.Find("?");
	sAPISigURL = "/dna/api/comments/status.aspx" + sDotNetURL.Mid(paramsStart);

	start = theConfig.GetDotNetServerArray().begin();
	end = theConfig.GetDotNetServerArray().end();
	while (start != end)
	{
		// Send the signal to the .net BBC.Dna
		CSignalData* pSigData = new CSignalData(sDotNetURL, *start, "");
		AfxBeginThread(&SendSignal, pSigData, 0, 0, 0, NULL);

		// Send the signal to the .net API Service
		CSignalData* pAPISigData = new CSignalData(sAPISigURL, *start, "");
		AfxBeginThread(&SendSignal, pAPISigData, 0, 0, 0, NULL);

		*start++;
	}

	return true;
}

bool CGI::SetSkin(const TDVCHAR *pSkin)
{
	m_SkinName = pSkin;
	return true;
}

bool CGI::GetNamedSectionMetadata(const char* pName, int& iLength, CTDVString& sMime)
{
	const char* iPos;
	return FindNamedDataSection(pName, &iPos, &iLength, &sMime);
}

bool CGI::FindNamedDataSection(const TDVCHAR *pName, const char** iPos, int *oLength, CTDVString *oMimeType, CTDVString *oFilename)
{
	
	*iPos = 0;
	CTDVString sName;
	while (FindDataSection(iPos, &sName, oLength, oMimeType, oFilename) 
		&& !sName.CompareText(pName))
	{
		// nothing else
	}
	if (sName.CompareText(pName))
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool CGI::FindDataSection(const char** iPos, CTDVString *oName, int *oLength, 
	CTDVString *oMimeType, CTDVString *oFileName)
{
	oName->Empty();
	oMimeType->Empty();
	*oLength = 0;
	int boundarylength = m_sBoundary.GetLength();
	if (boundarylength == 0)
	{
		return false;
	}
	const TDVCHAR* pEndPos = m_pActualQuery + m_ContentLength;
	const TDVCHAR* pCurPos = *iPos;
	const char* pStartBound = (const char*)m_sBoundary;
	int compare;
	if (*iPos == 0)
	{
		*iPos = m_pActualQuery;
	}
	else
	{
		while ((pCurPos + boundarylength < pEndPos) && ((compare = memcmp(pCurPos,pStartBound,boundarylength)) != 0))
		{
			pCurPos++;
		}
		if (compare == 0)
		{
			// matched the start of the string
			*iPos = pCurPos;
		}
		else
		{
			return false;
		}
	}
	// Got the pointer to the next boundary, let's get the info for it.
	// First see if this is the terminating boundary
	*iPos += boundarylength;
	// It's the last if the boundary is immediately followed by '--'
	if (memcmp(*iPos, "--",2) == 0)
	{
		return false;
	}

	// We now know this is another chunk, so get the details
	// skip over CRLF
	*iPos += 2;
	while (memcmp(*iPos, "\r\n",2) != 0)
	{
		// Got a header. See what it is
		CTDVString header;
		int headerend = strstr(*iPos,"\r\n") - *iPos;
		header.AppendChars(*iPos, headerend);
		if (header.FindText("Content-Disposition:") == 0)
		{
			int nameptr = header.FindText("; name=\"") + 8;
			int endname = header.FindText("\"",nameptr);
			oName->AppendChars((const TDVCHAR*)header + nameptr, endname - nameptr);

			if (oFileName != NULL)
			{
				oFileName->Empty();
				int iFilenameStart = header.FindText("; filename=\"");
				if (iFilenameStart != -1)
				{
					iFilenameStart += 12;
					int iFilenameEnd = header.FindText("\"", iFilenameStart);
					if (iFilenameEnd >= 0)
					{
						oFileName->AppendChars((const TDVCHAR*)header + iFilenameStart, 
							iFilenameEnd - iFilenameStart);
					}
				}
			}

		}
		else if (header.FindText("Content-Type:") == 0)
		{
			*oMimeType = header.Mid(13);
			while(*oMimeType[0] == ' ')
			{
				oMimeType->RemoveLeftChars(1);
			}
		}

		*iPos += headerend + 2;
	}
	*iPos += 2;
	pCurPos = *iPos;
	while ((pCurPos + boundarylength < pEndPos) && ((compare = memcmp(pCurPos,pStartBound,boundarylength)) != 0))
	{
		pCurPos++;
	}
	if (compare == 0)
	{
		// matched the start of the string
		*oLength = (pCurPos - *iPos) - 2;	// -2 to remove the CRLF
	}
	else
	{
		return false;
	}

	return true;
}

bool CGI::SaveUploadedSkin(const TDVCHAR *pSkinName, const TDVCHAR *pFileName, const TDVCHAR* pParamName, bool bCreateNew, CTDVString *oError)
{
	CTDVString sStylesheetPath;
	GetStylesheetHomePath(sStylesheetPath);
	sStylesheetPath << "\\Skins";
	CTDVString sFilename = pFileName;
	if (pSkinName[0] != 0)
	{
		sStylesheetPath << "\\" << pSkinName;
		CreateDirectory(sStylesheetPath, NULL);	// Don't care if this already exists
		CTDVString sTemp = sStylesheetPath;
		srand( (unsigned)time( NULL ) );
		
		CTDVString sOldSkin = sStylesheetPath;
		sOldSkin << "\\" << pFileName;
		sTemp << "\\st" << rand() << ".xsl";
		const char* iPos = 0;
		int iLength = 0;
		CTDVString sType;
		if (FindNamedDataSection(pParamName, &iPos, &iLength, &sType))
		{
			if (!CopyFile(sOldSkin, sTemp, false) && GetLastError() != 2)
			{
				LPVOID lpMessageBuffer = NULL;
				FormatMessage(
					FORMAT_MESSAGE_ALLOCATE_BUFFER|FORMAT_MESSAGE_FROM_SYSTEM,
					NULL, GetLastError(),
					0,
					(LPTSTR) &lpMessageBuffer, 0, NULL);


				*oError << "<COPYERROR>" << (LPTSTR) lpMessageBuffer << "</COPYERROR>";
				LocalFree(lpMessageBuffer);
				return false;
			}
			FILE* tempfile = fopen(sOldSkin,"wb");
			if (tempfile == NULL)
			{
				DeleteFile(sTemp);
				LPVOID lpMessageBuffer = NULL;
				FormatMessage(
					FORMAT_MESSAGE_ALLOCATE_BUFFER|FORMAT_MESSAGE_FROM_SYSTEM,
					NULL, GetLastError(),
					0,
					(LPTSTR) &lpMessageBuffer, 0, NULL);

				*oError << "<COPYERROR>" << (LPTSTR) lpMessageBuffer << "</COPYERROR>";
				LocalFree(lpMessageBuffer);
				return false;
			}
			fwrite(iPos, 1, iLength, tempfile);
			fclose(tempfile);
			CXSLT xslt;
			bool bWorked = false;
			CTDVString stylesheettocheck = sOldSkin;
			if (!sFilename.CompareText("HTMLOutput.xsl"))
			{
				stylesheettocheck = sStylesheetPath;
				stylesheettocheck << "\\HTMLOutput.xsl";
			}
			if (!xslt.VerifyStylesheet(stylesheettocheck, false, oError))
			{
				DeleteFile(sOldSkin);
				CopyFile(sTemp, sOldSkin, false);
				DeleteFile(sTemp);
				return false;
			}
			else
			{
				DeleteFile(sTemp);
				CXSLT::ClearTemplates();
				return true;
			}
		}
		else
		{
			*oError << "<UPLOADERROR/>";
			return false;
		}
	}
	else
	{
		CTDVString sTemp = sStylesheetPath;
		srand( (unsigned)time( NULL ) );
		
		sTemp << "\\st" << rand() << ".xsl";
		CTDVString sOldSkin = sStylesheetPath;
		sOldSkin << "\\" << pFileName;
		const char* iPos = 0;
		int iLength = 0;
		CTDVString sType;
		if (FindNamedDataSection(pParamName, &iPos, &iLength, &sType))
		{
			if (!CopyFile(sOldSkin, sTemp, false) && GetLastError() != 2)
			{
				*oError << "<COPYERROR/>";
				return false;
			}
			FILE* tempfile = fopen(sOldSkin,"wb");
			fwrite(iPos, 1, iLength, tempfile);
			fclose(tempfile);
			CTDVString stylesheettocheck = sStylesheetPath;
			stylesheettocheck << "\\Alabaster\\HTMLOutput.xsl";
			CXSLT xslt;
			if (!xslt.VerifyStylesheet(stylesheettocheck, false, oError))
			{
				CopyFile(sTemp, sOldSkin, false);
				DeleteFile(sTemp);
				return false;
			}
			else
			{
					DeleteFile(sTemp);
					CXSLT::ClearTemplates();
					return true;
			}
		}
		else
		{
			*oError << "<UPLOADERROR/>";
			return false;
		}
	}


	return false;
}



bool CGI::DoesCurrentSkinUseFrames()
{
	return m_pSiteList->GetSkinUseFrames(m_SiteID, m_SkinName);
}

bool CGI::DoesSkinExistInSite(int iSiteID, const TDVCHAR *pSkinName)
{
	return m_pSiteList->SkinExistsInSite(iSiteID, pSkinName);
}

bool CGI::DoesKeyArticleExist(int iSiteID, const TDVCHAR *pArticleName)
{
	return m_pSiteList->DoesArticleExist(iSiteID, pArticleName);
}

int CGI::GetReviewForumID(int iSiteID, const TDVCHAR *pForumName)
{
	return m_pSiteList->GetReviewForumID(iSiteID, pForumName);
}

bool CGI::ReplaceQueryString(const TDVCHAR *pNewParams)
{
	CTDVString sSiteName;
	CTDVString sSkinName;
	GetParamString("_si", sSiteName);
	GetParamString("_sk", sSkinName);
	m_Query = pNewParams;
	m_Query << "&_sk=" << sSkinName << "&_si=" << sSiteName;
	return true;
}

/*********************************************************************************

	void CGI::SendAuthRequired()

	Author:		Jim Lynn
	Created:	11/04/2002
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Sends a 401 Access Denied header and message to the client. Nothing
				else should be sent to the client after this. This should be used
				when it's detected that what the user has requested is not valid for 
				the username they have supplied.

*********************************************************************************/

void CGI::SendAuthRequired()
{
	//SetHeader("Content-type: text/plain");
	
	char* extra = "Content-type: text/plain\r\n\r\nYou are not authorised to access this server.\r\nPlease do not press this button again.\r\n";
	DWORD dwSize = strlen(extra);
	
    m_pECB->ServerSupportFunction(m_pECB->ConnID,HSE_REQ_SEND_RESPONSE_HEADER, "401 Access Denied", &dwSize, (LPDWORD)extra);
	
    // Make sure ISAPI doesn't send other rogue headers
	//m_pCtxt->m_bSendHeaders = false;
	//SendOutput("You are not authorised to access this server. Please do not press this button again.");
}

bool CGI::GetUserName(CTDVString *oName)
{
	return GetServerVariable("REMOTE_USER", *oName);
}

bool CGI::IsSitePassworded(int iSiteID)
{
	return m_pSiteList->GetIsSitePassworded(iSiteID);
}

int CGI::GetSiteMinAge(int iSiteID)
{
	return m_pSiteList->GetSiteMinAge(iSiteID);
}

int CGI::GetSiteMaxAge(int iSiteID)
{
	return m_pSiteList->GetSiteMaxAge(iSiteID);
}

bool CGI::GetSiteUsesIdentitySignIn(int iSiteID)
{
	return m_pSiteList->GetSiteUsesIdentitySignIn(iSiteID);
}

#ifdef DEBUG
bool CGI::SetSiteUsesIdentitySignIn(int iSiteID, bool bUseIdentity)
{
	m_pSiteList->SetSiteUsesIdentitySignIn(iSiteID, bUseIdentity);
	return true;
}
#endif

bool CGI::GetSiteIsKidsSite(int iSiteID)
{
	return m_pSiteList->GetSiteIsKidsSite(iSiteID);
}

bool CGI::IsCurrentSiteMessageboard()
{
	return m_pSiteOptions->GetValueBool(GetSiteID(),"General","IsMessageboard");
}

bool CGI::IsCurrentSiteEmailAddressFiltered()
{
	return m_pSiteOptions->GetValueBool(GetSiteID(),"Forum","EmailAddressFilter");
}

bool CGI::DoesCurrentSiteCacheHTML()
{
	return m_pSiteOptions->GetValueBool(GetSiteID(),"Cache","HTMLCaching");
}

int CGI::GetCurrentSiteHTMLCacheExpiry()
{
	return m_pSiteOptions->GetValueInt(GetSiteID(),"Cache","HTMLCachingExpiryTime");
}

bool CGI::IsSystemMessagesOn(int piSiteID)
{
	return m_pSiteOptions->GetValueBool(piSiteID,"General","UseSystemMessages");
}

bool CGI::DoesSiteUsePreModPosting(int piSiteID)
{
	return m_pSiteOptions->GetValueBool(piSiteID,"Moderation","ProcessPreMod");
}

bool CGI::DoesSiteUseArticleGuestBookForums(int iSiteID)
{
	return m_pSiteList->DoesSiteUseArticleGuestBookForums(iSiteID);
}

bool CGI::IncludeUsersGuideEntryInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludeUsersGuideEntry");
}

bool CGI::IncludeUsersGuideEntryForumInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludeUsersGuideEntryForum");
}

bool CGI::IncludeJournalInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludeJournal");
}

bool CGI::IncludeRecentPostsInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludeRecentPosts");
}

bool CGI::IncludeRecentGuideEntriesInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludeRecentGuideEntries");
}

bool CGI::IncludeUploadsInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludeUploads");
}

bool CGI::IncludeWatchInfoInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludeWatchInfo");
}

bool CGI::IncludeClubsInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludeClubs");
}

bool CGI::IncludePrivateForumsInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludePrivateForums");
}

bool CGI::IncludeLinksInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludeLinks");
}

bool CGI::IncludeTaggedNodesInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludeTaggedNodes");
}

bool CGI::IncludePostcoderInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludePostcoder");
}

bool CGI::IncludeNoticeboardInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludeNoticeboard");
}

bool CGI::IncludeSiteOptionsInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludeSiteOptions");
}

bool CGI::IncludeRecentCommentsInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludeRecentComments");
}

bool CGI::IncludeRecentArticlesOfSubscribedToUsersInPersonalSpace()
{
	int iSiteID = GetSiteID(); 
	return m_pSiteOptions->GetValueBool(iSiteID,"PersonalSpace","IncludeRecentArticlesOfSubscribedToUsers");
}

bool CGI::CanUserMoveToSite(int iCurrentSiteID, int iNewSiteID)
{
	bool bCurrentNoAuto = m_pSiteList->GetNoAutoSwitch(iCurrentSiteID);
	bool bNewNoAuto = m_pSiteList->GetNoAutoSwitch(iNewSiteID);
	bool bNewSitePassworded = m_pSiteList->GetIsSitePassworded(iNewSiteID);
	if (bNewSitePassworded || bCurrentNoAuto || bNewNoAuto)
	{
		return false;
	}
	else
	{
		return true;
	}
}

bool CGI::IsSiteUnmoderated(int iSiteID)
{
	if (iSiteID == 0)
	{
		iSiteID = GetSiteID();
	}
	return m_pSiteList->GetIsSiteUnmoderated(iSiteID);
}

bool CGI::PostcoderPlaceRequest(const TDVCHAR *pPlaceName, CTDVString &oResult)
{
	CTDVString sRequest = theConfig.GetPostcoderPlace();
	CTDVString sPlaceName = pPlaceName;
	EscapeTextForURL(sPlaceName);
	sRequest.Replace("--**placename**--", pPlaceName);

	return MakeURLRequest(theConfig.GetPostcoderServer(), "GET", 
		theConfig.GetPostcoderProxy(), sRequest, "", oResult, CTDVString(), true);
}

/*********************************************************************************

	bool CGI::PostcoderPlaceCookieRequest(const TDVCHAR* pPostCode, CTDVString& oValue)

	Author:		Martin Robb
	Created:	11/03/2005
	Inputs:		pPostCode
	Outputs:	oValue - value of cookie
	Returns:	true on success
	Purpose:	Requests the creation of a cookie and parses the SET COOKIE Header for the BBCPOstcoder cookie.

*********************************************************************************/
bool CGI::PostcoderPlaceCookieRequest( const TDVCHAR* pPostCode, CTDVString &oValue )
{
	//Get URL/path from Config File
	CTDVString sURL = theConfig.GetPostcoderCookieURL();
	//EscapeTextForURL(sURL);
	sURL.Replace("--**placename**--", pPostCode);

	CTDVString sResponseHeader;
	bool bSuccess = MakeURLRequest(theConfig.GetPostcoderCookieServer(), "GET", 
		theConfig.GetPostcoderCookieProxy(), sURL, "", CTDVString(), sResponseHeader );
	
	if ( bSuccess )
	{	
		//Retrieve BBCPostcoder cookie from the string.
		CTDVString sBBCPostcodeCookieName = theConfig.GetPostcoderCookieName();
		sBBCPostcodeCookieName += "=";
		int start = sResponseHeader.Find(sBBCPostcodeCookieName);
		if ( start >= 0 )
		{
			start+= sBBCPostcodeCookieName.GetLength();
			int end = sResponseHeader.Find(";",start);
			if ( end > start )
			{
				oValue = sResponseHeader.Mid(start,end - start);
			}
		}
	}
	return bSuccess;
}

bool CGI::MakeURLRequest(const TDVCHAR *pHost, const TDVCHAR* pReqType, const TDVCHAR *pProxy, const TDVCHAR *pRequest, const TDVCHAR *pPostData, CTDVString &oResult, CTDVString& oHeader, bool bFastTimeout)
{
	try
	{
	HINTERNET nethandle;
	if (pProxy == NULL || pProxy[0] == 0)
	{
		nethandle = InternetOpen(NULL, INTERNET_OPEN_TYPE_DIRECT ,NULL , NULL, NULL);
	}
	else
	{
		nethandle = InternetOpen(NULL, INTERNET_OPEN_TYPE_PROXY, pProxy, NULL, NULL);
	}

	if ( nethandle == NULL )
	{
		throw GetLastError();
	}
	
	// Get the useragent
	CTDVString sUserAgent;
	GetServerVariable("HTTP_USER_AGENT", sUserAgent);
	CTDVString sHeader = "User-Agent: ";
	sHeader << sUserAgent << "\r\n";
	
	//Timeout in milliseconds;
	DWORD iTimeout = 30000;
    if (bFastTimeout) 
	{
		//Set the timeout on the net handle to iTimeout
		InternetSetOption(nethandle, INTERNET_OPTION_CONNECT_TIMEOUT, (LPVOID)&iTimeout, sizeof(DWORD));
		InternetSetOption(nethandle, INTERNET_OPTION_RECEIVE_TIMEOUT, (LPVOID)&iTimeout, sizeof(DWORD));
	}

	HINTERNET httphandle = InternetConnect(nethandle,
											pHost,
											80,
											NULL,
											NULL,
											INTERNET_SERVICE_HTTP ,
											NULL,
											0);
	//Handle error 
	if ( httphandle == NULL )
	{
		DWORD dwerr = GetLastError();
		InternetCloseHandle(nethandle);
		throw dwerr;
	}

	if (bFastTimeout) 
	{
		//Set the timeout on the HTTP connect handle to iTimeout
		InternetSetOption(httphandle, INTERNET_OPTION_CONNECT_TIMEOUT, (LPVOID)&iTimeout, sizeof(DWORD));
		InternetSetOption(httphandle, INTERNET_OPTION_RECEIVE_TIMEOUT, (LPVOID)&iTimeout, sizeof(DWORD));
	}

	HINTERNET urlhandle = HttpOpenRequest(	httphandle,
											pReqType,
											pRequest,
											NULL,
											NULL,
											NULL,
											INTERNET_FLAG_NO_AUTO_REDIRECT,
											0);
	//Handle error
	if ( urlhandle == NULL )
	{
		DWORD dwerr = GetLastError();
		InternetCloseHandle(httphandle);
		InternetCloseHandle(nethandle);
		throw dwerr;
	}


	//Send Request
	if ( !HttpSendRequest(urlhandle, sHeader, sHeader.GetLength(), (void*)pPostData, strlen(pPostData)))
	{
		DWORD dwerr = GetLastError();
		InternetCloseHandle(urlhandle);
		InternetCloseHandle(httphandle);
		InternetCloseHandle(nethandle);
		throw dwerr;
	}

	//Read the Headers
	char header_buf[1024];
	DWORD header_buflen = 1024;
	DWORD index = 0;
	if ( !HttpQueryInfo(urlhandle, HTTP_QUERY_RAW_HEADERS_CRLF  , header_buf, &header_buflen, &index ) )
	{
		DWORD dwerr = GetLastError();
		InternetCloseHandle(urlhandle);
		InternetCloseHandle(httphandle);
		InternetCloseHandle(nethandle);
		throw dwerr;
	}

	oHeader = header_buf;
	
	//Read the document
	char buf[65536];
	bool bNotFinished = true;
	while (bNotFinished)
	{
		DWORD buflen = 65535;
		if ( !InternetReadFile(urlhandle, buf, buflen, &buflen))
		{
			DWORD dwerr = GetLastError();
			InternetCloseHandle(urlhandle);
			InternetCloseHandle(httphandle);
			InternetCloseHandle(nethandle);
			throw dwerr;
		}

		if ( buflen > 0 )
		{
			buf[buflen] = 0;
			oResult << buf;
		}
		if ( buflen == 0 )
		{
			bNotFinished = false;
		}
	}
	
	//Close Resources
	InternetCloseHandle(urlhandle);
	InternetCloseHandle(httphandle);
	InternetCloseHandle(nethandle);
	return true;

	}
	catch ( DWORD dwerr )
	{
		if( dwerr == ERROR_INTERNET_EXTENDED_ERROR )
		{
			DWORD dwExtLength = 0;
			DWORD dwInetError = 0;
			if ( InternetGetLastResponseInfo( &dwInetError, NULL, &dwExtLength ) )
			{
				TCHAR* pbuff = new TCHAR[dwExtLength+1];
				InternetGetLastResponseInfo(&dwInetError,pbuff,&dwExtLength );
				oResult << pbuff;
				TDVASSERT(false,CTDVString(pbuff) << " " << pHost << " " << pRequest );
				delete [] pbuff;
				return false;
			}
		}

		TCHAR MsgBuf[512];

		//Try to get WININET Error Message
		if ( FormatMessage(
		FORMAT_MESSAGE_FROM_HMODULE, //|
		//FORMAT_MESSAGE_ALLOCATE_BUFFER,				// dwFlags
		GetModuleHandle( "wininet.dll" ),			// lpSource
		dwerr,										// dwMessageId
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),	// dwLanguageId
		MsgBuf,									// lpBuffer
		512,											// nSize
		NULL ) )									// * arguments
		{
			oResult << MsgBuf;
			TDVASSERT(false,CTDVString(MsgBuf) << " " << pHost << " " << pRequest );
			return false;
		}

		//Try to get System Error Message 
		if ( FormatMessage( 
			//FORMAT_MESSAGE_ALLOCATE_BUFFER | 
			FORMAT_MESSAGE_FROM_SYSTEM | 
			FORMAT_MESSAGE_IGNORE_INSERTS,
			NULL,
			dwerr,
			MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
			MsgBuf,
			512,
			NULL ) )
		{
			oResult << MsgBuf;
			TDVASSERT(false,CTDVString(MsgBuf) << " " << pHost << " " << pRequest );
		}
		return false;
	}
}

void CGI::EscapeTextForURL(CTDVString &String)
{
	CTDVString sEscapedTerm;
	
	int iPos = 0;
	int iLen = String.GetLength();
	while (iPos < iLen)
	{
		char ch = String.GetAt(iPos);
		if (ch == ' ')
		{
			sEscapedTerm << "+";
		}
		else if (strchr("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_-~",ch) != NULL)
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
	String = sEscapedTerm;
	return;
}


/*********************************************************************************

	bool CGI::GetParamsAsString(CTDVString* oResult, const TDVCHAR* pPrefix = NULL)

	Author:		Mark Neves
	Created:	12/11/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CGI::GetParamsAsString(CTDVString& sResult, const TDVCHAR* pPrefix)
{
	sResult.Empty();

	CTDVString sXML;
	GetParamsAsXML(&sXML,pPrefix);
	CXMLTree* pRoot = CXMLTree::Parse(sXML);
	if (pRoot != NULL)
	{
		CTDVString sName, sValue;

		CXMLTree* pName = pRoot->FindFirstTagName("NAME", 0, false);
		while (pName != NULL)
		{
			if (!sResult.IsEmpty())
			{
				sResult << "&";
			}

			sName.Empty();
			pName->GetTextContents(sName);
			sResult << sName << "=";

			CXMLTree* pValue = pName->FindFirstTagName("VALUE");
			if (pValue != NULL)
			{
				sValue.Empty();
				pValue->GetTextContents(sValue);
				sResult << sValue;
			}

			pName = pName->FindNextTagNode("NAME");
		}
		delete pRoot;
		pRoot = NULL;
	}

	return true;
}

/*********************************************************************************

	bool CGI::GetBBCUIDFromCookie(CTDVString& sBBCUID)

	Author:		Mark Howitt
	Created:	14/11/2003
	Inputs:		-
	Outputs:	sBBCUID - The BBCUID value
	Returns:	true if valid, false if not
	Purpose:	Gets and checks the BBC-UID from the cookie

*********************************************************************************/

bool CGI::GetBBCUIDFromCookie(CTDVString& sBBCUID)
{
	// Make sure we empty the results string
	sBBCUID.Empty();
	
	// Get the HTTP Cookie variable
	CTDVString sCookie;
	if (GetServerVariable("HTTP_COOKIE", sCookie))
	{
		// Find the start of the BBC-UID
		CTDVString sNameToFind("BBC-UID=");
		int iPosA = sCookie.Find(sNameToFind);
		if (iPosA >= 0)
		{
			// Extract the UID and Hash values
			iPosA += sNameToFind.GetLength();
			int iPosB = sCookie.Find(";",iPosA) - iPosA;

			// If no semicolon found then this must be only value in cookie
			// or last value in cookie
			if(iPosB < 0)
			{
				// move to end
				iPosB = sCookie.GetLength()-iPosA;
			}

			if (iPosA >= 0 && iPosB > 0)
			{
				if (DecryptAndValidateBBCUID(sCookie.Mid(iPosA,iPosB),sBBCUID))
				{
					// The UID is valid, so return ok!
					return true;
				}
				else
				{
					TDVASSERT(false,"Invalid BBCUID found!");
				}
			}
		}
	}

	// If we get here, somthing went wrong!
	return false;
}

/*********************************************************************************

	CTDVString CGI::GetBBCUIDFromCookie()

		Author:		Mark Neves
		Created:	19/06/2006
		Inputs:		-
		Outputs:	-
		Returns:	The BBCUID from the cookie
		Purpose:	An alternative was of calling the other GetBBCUIDFromCookie() func

*********************************************************************************/

CTDVString CGI::GetBBCUIDFromCookie()
{
	CTDVString sBBCUID;
	GetBBCUIDFromCookie(sBBCUID);
	return sBBCUID;
}

/*********************************************************************************

	bool CGI::DecryptAndValidateBBCUID(CTDVString& sCookie, CTDVString& sUID)

	Author:		Mark Howitt
	Created:	14/11/2003
	Inputs:		sCookie - An Encrypted BBCUID cookie to check
	Outputs:	sUID - The UID for the cookie
	Returns:	true if valid BBCUID, false if not
	Purpose:	Decrypts the BBCUID into it's UID and checks to make sure it's valid!

*********************************************************************************/

bool CGI::DecryptAndValidateBBCUID(CTDVString& sCookie, CTDVString& sUID)
{
	// Decrypt the Hash and UID values from the cookie
	CTDVString sHash;
	sUID.Empty();

	// We expect the cookie to have at least 64 characters
	if (sCookie.GetLength() < 64)
	{
		return false;
	}

	int i;
	for (i = 0; i < 64; i += 2)
	{
		sHash += sCookie[i];
		sUID += sCookie[i+1];
	}

	// Now get the logged in status, if there are 
	CTDVString sLoggedIn;
	if ( i < sCookie.GetLength())
	{
		sLoggedIn = sCookie[i++];
	}

	// Get the Browser info, making sure we unescape it!
	CTDVString sBrowserInfo;
	if (i < sCookie.GetLength())
	{
		sBrowserInfo = sCookie.Mid(i);
		UnEscapeString(&sBrowserInfo);
	}

	// Now reencrypt the UID, LoggedIn and Browser Info to see if it matches the Hash value given
	CTDVString sReHash;
	CStoredProcedure::GenerateHash(sUID + sLoggedIn + 
		sBrowserInfo + theConfig.GetSecretKey(),sReHash);
	CStoredProcedure::GenerateHash(theConfig.GetSecretKey() + sReHash,sReHash);

	// Return the verdict
	if (sReHash != sHash)
	{
		sUID.Empty();
		return false;
	}

	// Markn 20-7-06
	// The UID can sometimes have invalid characters in it.  This is a bug in the BBC's cookie creation code and will hopefully be fixed soon
	// If we detect any non-hex chars, we get out quickly!
	for (int n=0;n < sUID.GetLength(); n++)
	{
		if (!isxdigit(sUID[n]))
		{
			sUID.Empty();
			return false;
		}
	}

	return true;
}

bool CGI::LogTimerEvent(const TDVCHAR* pMessage)
{
	DWORD curtime = GetTickCount();
	if (true)
	{
		CTDVString sLog = "TIMER ";
		sLog << pMessage << " : ";
		DWORD taken = curtime - m_TickStart;
		sLog << (int)taken;
		taken = curtime - m_LastEventTime;
		sLog << " (" << (int)taken << ")";
		WriteInputLog(sLog);
	}
	if (m_bShowTimers)
	{
		m_TimerHeaders << "X-DNATiming: " << pMessage << " : ";
		DWORD taken = curtime - m_TickStart;
		m_TimerHeaders << (int)taken;
		taken = curtime - m_LastEventTime;
		m_TimerHeaders << " (" << (int)taken << ")\r\n";
	}
	m_LastEventTime = curtime;
	return true;
}

void CGI::SwitchTimers(bool bNewState)
{
	m_bShowTimers = bNewState;
}

bool CGI::RefreshProfanityList()
{
	// Initialise a temporary list to populate
	std::map<int, std::pair<CTDVString, CTDVString> > proflist;
	std::map<int, int> modclassmap;
	// CLear the current list
	//m_sProfanities.Empty();

	// Now setup the profanity list
	CStoredProcedure SP;
	if (!InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false,"Failed to initialise stored procedure!");
		return false;
	}

	SP.GetAllProfanities();
	
	CTDVString sProfanity;
	CTDVString sBlockProfanities;
	CTDVString sReferProfanities;
	 
	int iModClassID = 0;
	int iCurrentRefer = 0;
	int iRefer = 0;

	while (!SP.IsEOF())
	{
        if ( iModClassID == 0 )
            iModClassID = SP.GetIntField("modclassid");
     
		while(iModClassID == SP.GetIntField("modclassid") && !SP.IsEOF())
		{
			iRefer = SP.GetIntField("Refer");
			SP.GetField("Profanity", sProfanity);

			if (iRefer)
			{
				sReferProfanities << sProfanity << "¶";
			}
			else
			{
				sBlockProfanities << sProfanity << "¶";
			}
			SP.MoveNext();
		}

		sBlockProfanities.MakeLower();
		sReferProfanities.MakeLower();
		proflist[iModClassID] = std::make_pair(sBlockProfanities, sReferProfanities);
		
        sBlockProfanities.Empty();
		sReferProfanities.Empty();
        iModClassID = SP.GetIntField("modclassid");
	}

	CStoredProcedure SP2;
	m_InputContext.InitialiseStoredProcedureObject(SP2);

	SP2.GetSitesModerationDetails();

	while (!SP2.IsEOF())
	{
		int iSiteID = SP2.GetIntField("SiteID");
		int iModClassID = SP2.GetIntField("ModClassID");

//		m_SiteModClassMap[iSiteID] = iModClassID;
		modclassmap[iSiteID] = iModClassID;

		SP2.MoveNext();
	}
	// Make sure we have everything in lower case!
	//m_sProfanities.MakeLower();

	// Swap temp maps with the static members
	m_SiteModClassMap.swap(modclassmap);
	m_ProfanitiesMap.swap(proflist);

	// Return ok
	return true;
}


bool const CGI::GetProfanities(int iModClassID, std::pair<CTDVString, CTDVString>& profanityLists)
{
	if (m_ProfanitiesMap.find(iModClassID) != m_ProfanitiesMap.end())
	{
		profanityLists = m_ProfanitiesMap[iModClassID];
		return true;
	}
	return false;
}
/*********************************************************************************

	bool CGI::RefreshTopics()

	Author:		Martin Robb
	Created:	28/10/2004
	Inputs:		SiteID, Stored Procedure.
	Outputs:	NA
	Returns:	true on success
	Purpose:	Hits database and fetches topics for all sites.
				Uses CTopic to create XML for each site, then initialises SiteData cache.
				Resultset must be ordered by siteID for this to work.

*********************************************************************************/
bool CGI::RefreshTopics()
{
	if ( !m_pSiteList )
	{
		return false;
	}

	return RefreshTopics(m_pSiteList);
}

bool CGI::RefreshTopics(CSiteList* pSiteList)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	SP.GetTopics(CTopic::TS_LIVE);
	
	CTDVString strSubject;
	int iTopicID = 0;
	int iduplicate = -1;
	int iH2G2ID = 0;
	int iForumID = 0;
	int iSiteID = -1;
	
	if ( SP.IsEOF() )
	{
		return false;
	}

	//Use the Topic class to create XML
	CTopic topics(m_InputContext);
	CTDVString sXML;
	topics.InitialiseXMLBuilder(&sXML,&SP);
	topics.OpenXMLTag("TOPICLIST",true);
	topics.AddXMLAttribute("STATUS","ACTIVE",true);

	int iSiteId = 0;
	while (!SP.IsEOF())
	{
		//Due to join on GuideEntries - duplicate values might be possible
		int iTopicID = SP.GetIntField("TopicID");
		if ( iduplicate == iTopicID )
		{
			SP.MoveNext();
			continue;
		}

		topics.CreateXMLForTopic();

		iduplicate = iTopicID;
		iSiteId = SP.GetIntField("SITEID");

		// update SiteData.cpp's vector for topic forums
		pSiteList->AddTopicForum(iSiteId, SP.GetIntField("FORUMID")); 

		SP.MoveNext();

		//Check finished processing site.
		if ( SP.IsEOF() || iSiteId != SP.GetIntField("SiteID") )
		{
			//Cache topics XML and reset CTopic
			topics.CloseXMLTag("TOPICLIST");
			pSiteList->SetTopicsXML(iSiteId,sXML);
			
			topics.Destroy();
			sXML = "";
			topics.OpenXMLTag("TOPICLIST");
		}
	}

	// Return ok
	return true;
}

void CGI::GetSiteConfig(CTDVString& sSiteConfig)
{
	sSiteConfig = m_SiteConfig;
}

void CGI::SetSiteConfig(const TDVCHAR* pSiteConfig)
{
	if (pSiteConfig != NULL)
	{
		m_SiteConfig = pSiteConfig;
	}
}

void CGI::GetTopics(CTDVString& sTopics)
{
	sTopics = m_sTopicsXML;
}


// Fetches the UserAgent from the web server and returns the string representing it.
bool CGI::GetUserAgent(CTDVString& oAgentString)
{
	GetServerVariable("HTTP_USER_AGENT", oAgentString);
	return true;
}

/*********************************************************************************

	bool CGI::IsUsersEMailVerified(bool& bVerified)

		Author:		Mark Howitt
        Created:	21/09/2004
        Inputs:		-
        Outputs:	bVerified - A flag that takes the value of the users email status
        Returns:	true if ok, false if not
        Purpose:	Checks the user email to see if it valid or not.

*********************************************************************************/
bool CGI::IsUsersEMailVerified(bool& bVerified)
{
	// check the profile connection to make sure it has been initialised
	if (!m_ProfileConnection.IsInitialised())
	{
		TDVASSERT(false,"CGI::IsUsersEMailVerified - Proifile Connection not initialised");
		return false;
	}

	// Now get the email status
	return m_ProfileConnection.IsUsersEMailValidated(bVerified);
}

/*********************************************************************************

	bool CGI::GetSitesEMailAlertSubject(int iSiteID, CTDVString& sEmailAlertSubject)

		Author:		Mark Howitt
        Created:	22/09/2004
        Inputs:		iSite the site yoiu want to get the email subject for.
        Outputs:	sEmailAlertSubject - The string that will take the site value
        Returns:	true if ok, false if not
        Purpose:	Gets the Subject for the Email Alert system

*********************************************************************************/
bool CGI::GetSitesEMailAlertSubject(int iSiteID, CTDVString& sEmailAlertSubject)
{
	// Check the site list pointer
	if (m_pSiteList == NULL)
	{
		TDVASSERT(false,"CGI::GetSitesEMailAlertSubject - SiteList pointer is NULL!!!");
		return false;
	}

	// Get the value from the list
	return m_pSiteList->GetSiteEMailAlertSubject(iSiteID,sEmailAlertSubject);
}
/*
	Pending some secure and reliable way of ensuring that a user is coming in over reith...
*/
bool CGI::IsUserAllowedInPasswordedSite(int* pReason)
{
	// This presupposes this is a secure way of doing it
	if (GetParamInt("_bbc_") == 1)
	{
		return true;
	}

	// Only logged in users, then
	CUser* pUser = GetCurrentUser();
	if (pUser == NULL)
	{
		if (pReason != NULL)
		{
			*pReason = 1;
		}
		return false;
	}
	if (pUser->IsUserInGroup("INVITED") || pUser->GetIsEditor() || pUser->GetIsModerator() || pUser->GetIsBBCStaff())
	{
		return true;
	}
	if (pReason != NULL)
	{
		*pReason = 2;
	}
	return false;
}

UINT DatabaseWatchdog(LPVOID pParam)
{
	CGI* pCGI = (CGI*)pParam;

	while (true)
	{
		::Sleep(30000);
		AddToEventLog("Database Watchdog Initialising DB",EVENTLOG_INFORMATION_TYPE,DNA_EVENTLOGID_DATABASEWATCHDOG);

		//check on the database
		if (pCGI->InitialiseFromDatabase())
		{
			AddToEventLog("Database Watchdog successfully Initialised DB",EVENTLOG_INFORMATION_TYPE,DNA_EVENTLOGID_DATABASEWATCHDOG);
			break;
		}

		AddToEventLog("Database Watchdog failed to initialise DB",EVENTLOG_WARNING_TYPE,DNA_EVENTLOGID_DATABASEWATCHDOG);
	}

	AddToEventLog("Database Watchdog thread closing down",EVENTLOG_INFORMATION_TYPE,DNA_EVENTLOGID_DATABASEWATCHDOG);
	return 0;
}

void CGI::StartDatabaseWatchdog() 
{
	AddToEventLog("Database Watchdog thread starting",EVENTLOG_INFORMATION_TYPE,DNA_EVENTLOGID_DATABASEWATCHDOG);
	::AfxBeginThread(&DatabaseWatchdog, (LPVOID)this, 0, 0, 0, NULL);	
}

/*********************************************************************************

	bool CGI::GetEventAlertMessageUserID(int iSiteID, int& iUserID)

		Author:		Mark Howitt
        Created:	23/11/2004
        Inputs:		iSiteId - the site you want to get the UserID for
        Outputs:	iUserID - The Id of the Auto EventAlert UserID
        Returns:	true
        Purpose:	Gets the userid for the automatic alert messages

*********************************************************************************/
bool CGI::GetEventAlertMessageUserID(int iSiteID, int& iUserID)
{
	// Check the site list pointer
	if (m_pSiteList == NULL)
	{
		TDVASSERT(false,"CGI::GetSitesEMailAlertSubject - SiteList pointer is NULL!!!");
		return false;
	}

	// Get the value from the list
	return m_pSiteList->GetEventAlertMessageUserID(iSiteID,iUserID);
}

int CGI::GetSiteID(const TDVCHAR* pSiteName)
{
	// Check the site list pointer
	if (m_pSiteList == NULL)
	{
		TDVASSERT(false,"CGI::GetSitesEMailAlertSubject - SiteList pointer is NULL!!!");
		return false;
	}
	
	return m_pSiteList->GetSiteID(pSiteName);
}


CTDVString CGI::GetPreviewModeURLParam()
{
	return CTDVString("_previewmode=1");
}

void CGI::GroupDataUpdated()
{
	if(!m_pUserGroups)
	{
		// I expect m_pUserGroups to be initialized by now
		// If not, group data cache will not be refreshed from database
		TDVASSERT(false, "CGI::GroupDataUpdated() Unexpected NULL m_pUserGroups");
	}
	else
	{
		// Expire the cache so that it will be
		// refreshed next time its needed
		m_pUserGroups->SetCacheExpired(m_InputContext);
	}
}

void CGI::UserGroupDataUpdated(int iUserID)
{
	if(!m_pUserGroups)
	{
		// I expect m_pUserGroups to be initialized by now
		// If not, group data cache will not be refreshed from database
		TDVASSERT(false, "CGI::GroupDataUpdated() Unexpected NULL m_pUserGroups");
	}
	else
	{
		// Expire the cache so that it will be
		// refreshed next time its needed
		m_pUserGroups->RefreshUserGroups(m_InputContext, iUserID);
	}
}

void CGI::DynamicListDataUpdated()
{
	if(!m_pDynamicLists)
	{
		TDVASSERT(false, "CGI::DynamicListDataUpdated() Unexpected NULL m_pDynamicLists");
	}
	else
	{
		// Refresh cache next time its requested
		m_pDynamicLists->ForceRefresh();
	}
}

bool CGI::IsDatabaseInitialised()
{
	return m_bSiteListInitialisedFromDB;
}

/*********************************************************************************

	CTDVString CGI::GetRipleyServerInfoXML()

		Author:		Mark Neves
        Created:	01/11/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

CTDVString CGI::GetRipleyServerInfoXML()
{
	return m_sRipleyServerInfoXML;
}

/*********************************************************************************

	void CGI::SetRipleyServerInfoXML(const TDVCHAR* pXML)

		Author:		Mark Neves
        Created:	01/11/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

void CGI::SetRipleyServerInfoXML(const TDVCHAR* pXML)
{
	m_sRipleyServerInfoXML = pXML; 
}

/*********************************************************************************

	CTDVString CGI::GetIPAddress()

		Author:		Mark Neves
        Created:	22/11/2005
        Inputs:		-
        Outputs:	-
        Returns:	The IP address of the machine that initiated the request, or "" if none supplied
        Purpose:	-

*********************************************************************************/

CTDVString CGI::GetIPAddress()
{
	return m_IPAddress;
}

bool CGI::GetFeedsCacheName(CTDVString& sFeedsCacheFolderName, CTDVString& sFeedsCacheItemName)
{
	bool bSuccess = true; 

	CTDVString sFeedsCacheFileSuffix; 

	bSuccess = bSuccess && GetRequestFeedCacheFolderName(sFeedsCacheFolderName);

	GetQueryHash(sFeedsCacheItemName); 
	
	bSuccess = bSuccess && GetRequestFeedCacheFileSuffix(sFeedsCacheFileSuffix);

	sFeedsCacheItemName = sFeedsCacheItemName << sFeedsCacheFileSuffix; 

	return bSuccess;
}
bool CGI::GetRequestFeedCacheFolderName(CTDVString& sFeedsCacheFolderName)
{
	CTDVString sCommandQuery; 

	GetCommand(sCommandQuery);

	if (IsRequestForRssFeed())
	{
		sFeedsCacheFolderName = sFeedsCacheFolderName << "rss\\" << sCommandQuery;
	} else if (IsRequestForSsiFeed())
	{
		sFeedsCacheFolderName = sFeedsCacheFolderName << "ssi\\" << sCommandQuery;
	} else
	{
		TDVASSERT(false,"CXMLBuilder::GetRequestFeedCacheFolderName - don't have recognised feed request type.");
		return false; 
	}

	return true; 
}
bool CGI::GetRequestFeedCacheFileSuffix(CTDVString& sFeedsCacheFileSuffix)
{
	if (m_InputContext.IsRequestForRssFeed())
	{
		sFeedsCacheFileSuffix = sFeedsCacheFileSuffix << ".rdf";
	} 
	else if (m_InputContext.IsRequestForRssFeed())
	{
		sFeedsCacheFileSuffix = sFeedsCacheFileSuffix << ".ssi";
	}
	else
	{
		sFeedsCacheFileSuffix = sFeedsCacheFileSuffix << ".txt";
	}

	return true; 
}
void CGI::AddRssCacheHit()
{
	m_pStatistics->AddRssCacheHit();
}
void CGI::AddRssCacheMiss()
{
	m_pStatistics->AddRssCacheMiss();
}
void CGI::AddSsiCacheHit()
{
	m_pStatistics->AddSsiCacheHit();
}
void CGI::AddSsiCacheMiss()
{
	m_pStatistics->AddSsiCacheMiss();
}
void CGI::AddHTMLCacheHit()
{
	m_pStatistics->AddHTMLCacheHit();
}
void CGI::AddHTMLCacheMiss()
{
	m_pStatistics->AddHTMLCacheMiss();
}
void CGI::AddNonSSORequest()
{
	m_pStatistics->AddNonSSORequest();
}
bool CGI::IsRequestForCachedFeed()
{
	return (IsRequestForRssFeed() || IsRequestForSsiFeed());
}
bool CGI::IsRequestForRssFeed()
{
    return CSkinSelector::IsXmlSkin(m_SkinName);
}
bool CGI::IsRequestForSsiFeed()
{
	if (m_SkinName.CompareText("ssi") || m_SkinName.Right(4).CompareText("-ssi"))
	{
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CGI::IsCurrentSiteURLFiltered()

		Author:		Steven Francis
        Created:	02/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	
        Purpose:	Checks site options to see if the current site is
					one that has to be URL filtered

*********************************************************************************/
bool CGI::IsCurrentSiteURLFiltered()
{
	return m_pSiteOptions->GetValueBool(GetSiteID(), "General", "IsURLFiltered");
}

/*********************************************************************************

	bool CGI::RefreshAllowedURLList()

		Author:		Steven Francis
        Created:	02/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	
        Purpose:	Refreshes the in memory cached allowed URL list

*********************************************************************************/
bool CGI::RefreshAllowedURLList()
{
	// Initialise a temporary list to populate
	std::map<int, CTDVString> AllowedURLList;
	std::map<int, int> sitemap;

	// Now setup the Allowed URL list
	CStoredProcedure SP;
	if (!InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false,"Failed to initialise stored procedure!");
		return false;
	}

	SP.GetAllAllowedURLs();
	
	CTDVString sURL;
	CTDVString sAllowedURLs;
	 
	int iCurrentSiteID = 1;
	int iSiteID = 1;

	while (!SP.IsEOF())
	{
		iSiteID = SP.GetIntField("SiteID");
        iCurrentSiteID = iSiteID;
		while(iSiteID == iCurrentSiteID && !SP.IsEOF())
		{
			iSiteID = SP.GetIntField("SiteID");
			if (iSiteID != iCurrentSiteID)
			{
				break;
			}
			SP.GetField("URL", sURL);

			sAllowedURLs << sURL << "¶";
			SP.MoveNext();
		}
		sAllowedURLs.MakeLower();

		AllowedURLList[iCurrentSiteID] = sAllowedURLs;
		
		sAllowedURLs.Empty();
	}

	m_AllowedURLListsMap.swap(AllowedURLList);

	// Return ok
	return true;
}

/*********************************************************************************

	bool CGI::GetAllowedURLList(int iSiteID, CTDVString& AllowedURLList)

		Author:		Steven Francis
        Created:	02/05/2006
        Inputs:		Site ID 
        Outputs:	AllowedURLList - list of allowed urls for that site
        Returns:	
        Purpose:	Gets the list of allowed urls for a site

*********************************************************************************/
bool const CGI::GetAllowedURLList(int iSiteID, CTDVString& AllowedURLList)
{
	if (m_AllowedURLListsMap.find(iSiteID) != m_AllowedURLListsMap.end())
	{
		AllowedURLList = m_AllowedURLListsMap[iSiteID];
		return true;
	}
	return false;
}

/*********************************************************************************

	bool CGI::DoesCurrentSiteAllowedMAExternalLinks()

		Author:		Steven Francis
        Created:	02/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	
        Purpose:	Checks site options to see if the current site is
					one that has to be URL filtered

*********************************************************************************/
bool CGI::DoesCurrentSiteAllowedMAExternalLinks()
{
	return m_pSiteOptions->GetValueBool(GetSiteID(), "MediaAsset", "AllowExternalLinks");
}


/*********************************************************************************

	bool CGI::IsModerationSite(int iSiteID)

		Author:		James Conway
		Created:	12/07/2006
		Inputs:		- int SiteID
		Outputs:	-
		Returns:	-
		Purpose:	- Returns whether the given Site id is the moderation site

*********************************************************************************/
bool CGI::IsModerationSite(int iSiteID)
{
	CTDVString sSiteName = "";

	m_pSiteList->GetNameOfSite(iSiteID, &sSiteName);

	if (sSiteName.CompareText("moderation"))
	{
		return true; 
	}

	return false; 
}

/*********************************************************************************

	bool CGI::DoesCurrentSiteAllowOwnerHiding()

		Author:		Steven Francis
        Created:	27/07/2006
        Inputs:		-
        Outputs:	-
        Returns:	
        Purpose:	Returns whether the current site is
					one that allows the owners of an article to hide other users comments

*********************************************************************************/
bool CGI::DoesCurrentSiteAllowOwnerHiding()
{
	return m_pSiteOptions->GetValueBool(GetSiteID(), "General", "AllowOwnerHiding");
}



bool CGI::DoesSiteAllowOwnerHiding(int iSiteID)
{
	return m_pSiteOptions->GetValueBool(iSiteID, "General", "AllowOwnerHiding");
}

/*********************************************************************************

	bool CGI::DoesCurrentSiteHaveSiteOptionSet()

		Author:		Steven Francis
        Created:	15/08/2006
        Inputs:		-
        Outputs:	-
        Returns:	
        Purpose:	Returns whether the current site has the given SiteOption set

*********************************************************************************/
bool CGI::DoesCurrentSiteHaveSiteOptionSet(const TDVCHAR* pSection, const TDVCHAR* pName)
{
	return m_pSiteOptions->GetValueBool(GetSiteID(), pSection, pName);
}

/*********************************************************************************

	CTDVString CGI::GetCurrentSiteOptionString(const TDVCHAR* pSection, const TDVCHAR* pName)

		Author:		Mark Howitt
        Created:	20/06/2007
        Inputs:		pSection - The site option section the option belongs to
					pName - The name of the option you are wanting the value for.
        Outputs:	-
        Returns:	The value for the site option requested
        Purpose:	Gets the requested site option value string

*********************************************************************************/
CTDVString CGI::GetCurrentSiteOptionString(const TDVCHAR* pSection, const TDVCHAR* pName)
{
	return m_pSiteOptions->GetValue(GetSiteID(), pSection, pName);
}

/*********************************************************************************

	bool CGI::DoesCurrentSiteHaveDistressMsgUserId()

		Author:		Martin Robb
        Created:	19/09/2006
        Inputs:		- iSiteId - site to check 
        Outputs:	- iUserId - returns userid to use for sending distress messages if defined.
        Returns:	
        Purpose:	Set if a specific user account is to be used for sending distress messages.
*********************************************************************************/
bool CGI::DoesSiteHaveDistressMsgUserId( int iSiteId, int& iUserId )
{
	iUserId =  m_pSiteOptions->GetValueInt(iSiteId,"Moderation","DistressMsgUserId");
	return iUserId > 0;
}

/*********************************************************************************

	bool CGI::GetDefaultShow()

		Author:		James Conway
        Created:	30/11/2006
        Inputs:		- iSiteId - site to check 
        Outputs:	
        Returns:	Default show for the site
        Purpose:	Gets the default number of posts to show on a page.
*********************************************************************************/
int CGI::GetDefaultShow( int iSiteId )
{
	return m_pSiteOptions->GetValueInt(iSiteId,"CommentForum","DefaultShow");
}

/*********************************************************************************

	int CGI::GetCurrentSiteOptionInt(const TDVCHAR* pSection, const TDVCHAR* pName)

		Author:		Steve Francis
        Created:	03/08/2007
        Inputs:		pSection - The site option section the option belongs to
					pName - The name of the option you are wanting the value for.
        Outputs:	-
        Returns:	The value for the site option requested
        Purpose:	Gets the requested site option value int

*********************************************************************************/
int CGI::GetCurrentSiteOptionInt(const TDVCHAR* pSection, const TDVCHAR* pName)
{
	return m_pSiteOptions->GetValueInt(GetSiteID(), pSection, pName);
}


/*********************************************************************************

	bool CGI::IsDateRangeInclusive( int iSiteId )

		Author:		James Conway
        Created:	13/08/2007
        Inputs:		- iSiteId - site to check 
        Outputs:	
        Returns:	True if site uses inclusive date ranges, false otherwise
        Purpose:	Check if date range is inclusive.
*********************************************************************************/
bool CGI::IsDateRangeInclusive( int iSiteId )
{
	int iIsDateRangeInclusive = m_pSiteOptions->GetValueInt(iSiteId,"GuideEntries","InclusiveDateRange");
	if (iIsDateRangeInclusive == 1)
	{
		return true; 
	}

	return false; 
}


void CGI::StaticInit()
{
	InitializeCriticalSection(&s_CSLogFile);
}

/*********************************************************************************

	CTDVString CGI::GetSiteInfomationXML(int iSiteID)

		Author:		Mark Howitt
		Created:	23/07/2008
		Inputs:		iSiteID - The id of the site you want to get the Information for.
		Returns:	The XML as a string
		Purpose:	Gets the site information as XML. This contains sitename, ssoservice,
						minage, maxage, siteoptions... This is found on every page.

*********************************************************************************/
CTDVString CGI::GetSiteInfomationXML(int iSiteID)
{
	return m_pSiteList->GetSiteInfomationXML(iSiteID, this);
}

void CGI::WriteContext(const TDVCHAR* pContent)
{
    DWORD dwSize = strlen(pContent);
	m_pECB->WriteClient(m_pECB->ConnID, (LPVOID) pContent, &dwSize, 0);
}

void CGI::WriteHeaders(const TDVCHAR* pHeaders)
{
    DWORD dwSize = strlen(pHeaders);
    m_pECB->ServerSupportFunction(m_pECB->ConnID,HSE_REQ_SEND_RESPONSE_HEADER,0,&dwSize,(DWORD*) pHeaders);
}