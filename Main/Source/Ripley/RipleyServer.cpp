// RIPLEYSERVER.CPP - Implementation file for your Internet Server
//    RipleyServer Extension

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


#include "RipleyServerStdAfx.h"
#include "tdvassert.h"
#include "CGI.h"
#include "RipleyServer.h"
#include "Config.h"
// #include "httpext.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

///////////////////////////////////////////////////////////////////////
// command-parsing map

/*BEGIN_PARSE_MAP(CRipleyServerExtension, CHttpServer)
	// TODO: insert your ON_PARSE_COMMAND() and 
	// ON_PARSE_COMMAND_PARAMS() here to hook up your commands.
	// For example:

	ON_PARSE_COMMAND(Default, CRipleyServerExtension, ITS_EMPTY)
	DEFAULT_PARSE_COMMAND(Default, CRipleyServerExtension)
END_PARSE_MAP(CRipleyServerExtension)*/


///////////////////////////////////////////////////////////////////////
// The one and only CRipleyServerExtension object

CRipleyServerExtension theExtension;

bool CRipleyServerExtension::m_bIsShuttingDown = false;

//HINSTANCE CRipleyServerExtension::g_hInstance;

///////////////////////////////////////////////////////////////////////
// CRipleyServerExtension implementation

CRipleyServerExtension::CRipleyServerExtension() : m_bInitialisedFromConfigFile(false), m_RunningRequests(0)
{
	InitializeCriticalSection(&m_oCriticalSectionObjectForConfig);
}

CRipleyServerExtension::~CRipleyServerExtension()
{
	CRipleyServerExtension::m_bIsShuttingDown = true;
	DeleteCriticalSection(&m_oCriticalSectionObjectForConfig);
}

// Unnecessary - Config FileName can be retrieved
const char* CRipleyServerExtension::GetConfigFileName( )
{
	if (m_sConfigFileName.IsEmpty())
	{
		// Get the instance handle for the DLL
		HINSTANCE hInst = AfxGetResourceHandle();
		
        // Read the pathname of the DLL
		const unsigned uBufLen = 512;
		char confFileName[uBufLen];

		GetModuleFileName(hInst, confFileName, uBufLen);
		// Find the .dll extension
		char* pExtension = strstr(confFileName, ".dll");
		if (pExtension != NULL)
		{
			if ((uBufLen - strlen(confFileName) - 1) < 4)
			{
				return NULL;
			}
			// replace it with .xmlconf
			strcpy(pExtension, ".xmlconf");
		}
		else
		{
			if ((uBufLen - strlen(confFileName) - 1) < 8)
			{
				return NULL;
			}
			strcat(confFileName, ".xmlconf");
		}
        m_sConfigFileName = confFileName;

	}

	return m_sConfigFileName;
}

/*BOOL CRipleyServerExtension::GetExtensionVersion(HSE_VERSION_INFO* pVer)
{

	// Call default implementation for initialization
	CHttpServer::GetExtensionVersion(pVer);

	// Load description string
	TCHAR sz[HSE_MAX_EXT_DLL_NAME_LEN+1];
	ISAPIVERIFY(::LoadString(AfxGetResourceHandle(),
			IDS_SERVER, sz, HSE_MAX_EXT_DLL_NAME_LEN));
	_tcscpy(pVer->lpszExtensionDesc, sz);

	return TRUE;
}*/

/*BOOL CRipleyServerExtension::TerminateExtension(DWORD dwFlags)
{
	// extension is being terminated
	return TRUE;
}*/

///////////////////////////////////////////////////////////////////////
// CRipleyServerExtension command handlers

/*void CRipleyServerExtension::Default(CHttpServerContext* pCtxt)
{
	StartContent(pCtxt);
	WriteTitle(pCtxt);

	*pCtxt << _T("This default message was produced by the Internet");
	*pCtxt << _T(" Server DLL Wizard. Edit your CRipleyServerExtension::Default()");
	*pCtxt << _T(" implementation to change it.\r\n");

	EndContent(pCtxt);
}*/

// Do not edit the following lines, which are needed by ClassWizard.
/*#if 0
BEGIN_MESSAGE_MAP(CRipleyServerExtension, CHttpServer)
	//{{AFX_MSG_MAP(CRipleyServerExtension)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()
#endif	// 0*/



///////////////////////////////////////////////////////////////////////
// If your extension will not use MFC, you'll need this code to make
// sure the extension objects can find the resource handle for the
// module.  If you convert your extension to not be dependent on MFC,
// remove the comments arounn the following AfxGetResourceHandle()
// and DllMain() functions, as well as the g_hInstance global.

/*HINSTANCE AFXAPI AfxGetResourceHandle()
{
    return AfxGetInstanceHandle();
    //return CRipleyServerExtension::g_hInstance;
}


BOOL APIENTRY DllMain(HINSTANCE hInst, DWORD  ulReason, LPVOID lpReserved)
{
    if (ulReason == DLL_PROCESS_ATTACH)
	{
        CRipleyServerExtension::g_hInstance = hInst;
	}
    return TRUE;
}*/

BOOL WINAPI GetExtensionVersion(HSE_VERSION_INFO *pVer)
{
    // Load description string
	//TCHAR sz[HSE_MAX_EXT_DLL_NAME_LEN+1];
	//ISAPIVERIFY(::LoadString(AfxGetResourceHandle(),
	//		IDS_SERVER, sz, HSE_MAX_EXT_DLL_NAME_LEN));
	//_tcscpy(pVer->lpszExtensionDesc, sz);

	pVer->dwExtensionVersion = HSE_VERSION;
	strncpy(pVer->lpszExtensionDesc, "RipleyServer", HSE_MAX_EXT_DLL_NAME_LEN);

	return TRUE;
}

DWORD WINAPI CRipleyServerExtension::HttpExtensionProc(EXTENSION_CONTROL_BLOCK *pECB)
{  
     // AfxGetResourceHandle() calls require this macro so that dll resources are returned.
    AFX_MANAGE_STATE(AfxGetStaticModuleState( ));
    
    CTDVString sConfigFileError = "";
	if (!theExtension.InitFromConfigFile(pECB, sConfigFileError ))
	{	
		sConfigFileError = "<p>" + sConfigFileError + "</p>";			
		CTDVString sHeader = "Content-type: text/html\r\n\r\n";
        CRipleyServerExtension::WriteHeaders(pECB,sHeader);
      
		CTDVString sHTML;
        sHTML << "<html><head><title>Ripley Config File Error</title></head><body>" << sConfigFileError << "</body></html>";				
		//*(pCtxt->m_pStream) << sHTML;
        CRipleyServerExtension::WriteContext(pECB, sHTML);
		//return callOK;
        return HSE_STATUS_SUCCESS;
	}

    CTDVString requestdata;
    if ( pECB->cbAvailable > 0 )
    {
        //Request contains data.
        char* pBuffer = new char[pECB->cbAvailable+1];
        ZeroMemory(pBuffer, pECB->cbAvailable + 1); 
        strncpy(pBuffer, (const char*)pECB->lpbData, pECB->cbAvailable); 
        requestdata << pBuffer;
        delete [] pBuffer;

        if ( pECB->cbAvailable < pECB->cbTotalBytes )
        {
            // Read Remaining request data from client.
            char buffer[513];
            unsigned int iRead = pECB->cbAvailable;
            while ( iRead < pECB->cbTotalBytes )
            {
                DWORD length = 512;
                ZeroMemory(buffer,513);
                if ( !pECB->ReadClient(pECB->ConnID, buffer, &length) )
                {
                    //Get Error Message
                    LPTSTR lpBuffer = NULL;
                    FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
                        NULL,
                        GetLastError(),
                        0,
                        (LPTSTR) &lpBuffer,
                        0,
                        NULL);

                        // Display error page.
                        CTDVString sHeader = "Content-type: text/html\r\n\r\n";
                        CRipleyServerExtension::WriteHeaders(pECB,sHeader);
                        CTDVString sHTML;
                        sHTML << "<html><head><title>Error Handling Request</title></head><body>" << "An error has occured. Please try again later : " << (lpBuffer == NULL ? "" : lpBuffer) << "</body></html>";
                        CRipleyServerExtension::WriteContext(pECB, sHTML);
                        LocalFree(lpBuffer);
                        return HSE_STATUS_ERROR;
                }
                requestdata << buffer;
                iRead += length;

            }
            requestdata << "\0";
        }
    }
    
     if ( theExtension.InitialiseRequest(pECB, requestdata) )
     {
         return HSE_STATUS_SUCCESS;
     }
     else
     {
         return HSE_STATUS_ERROR;
     }
}

bool CRipleyServerExtension::InitialiseRequest(EXTENSION_CONTROL_BLOCK* pECB, const TDVCHAR* pRequestData)
{
    // Count the raw requests that come in.
	m_MasterCgi.GetStatistics()->AddRawRequest();

	// Create a CGI object to wrap around the server stuff
	CGI ThisRequest(m_MasterCgi);

	if (!ThisRequest.IsDatabaseInitialised())
	{
		return false;
	}

	// Initialise it with all the inputs
    if (!ThisRequest.Initialise(pECB, pRequestData, pECB->lpszQueryString) )
	{
		return false;
	}

	if (UseHTMLCache(ThisRequest))
	{
		return true;
	}

	InterlockedIncrement(&m_RunningRequests);
	if (m_RunningRequests > theConfig.GetServerTooBusyLimit())
	{
		try
		{
			ServerTooBusy(pECB);
		}
		catch(...)
		{
		}

		InterlockedDecrement(&m_RunningRequests);
		return false;
	}

	bool bHandleResult = false;
	try
	{
		if (!ThisRequest.InitUser())
		{
			InterlockedDecrement(&m_RunningRequests);
			return false;
		}

		bHandleResult = m_Ripley.HandleRequest(&ThisRequest);
	}
	catch(...)
	{
		bHandleResult = false;
	}

	InterlockedDecrement(&m_RunningRequests);
	return bHandleResult;
}


/*********************************************************************************

	int CRipleyServerExtension::CallFunction(CHttpServerContext* pCtxt, LPTSTR pszQuery, LPTSTR pszCommand) 

	Author:		Jim Lynn
	Created:	17/02/2000
	Inputs:		pCtxt - server context object from MFC framework
				pszQuery - query string
				pszCommand - command string
	Outputs:	-
	Returns:	result code (see base class docs)
	Purpose:	In a traditional ISAPI MFC app this just calls the base class
				CallFunction . To use Ripley we create a CGI object, then call the
				HandleRequest function of the Ripley object.

*********************************************************************************/

/*int CRipleyServerExtension::CallFunction(CHttpServerContext* pCtxt, LPTSTR pszQuery, LPTSTR pszCommand) 
{
	// We have to construct a stream for the pCtxt object.
	pCtxt->m_pStream = ConstructStream();	

	CTDVString sConfigFileError = "";
	if (!InitFromConfigFile(pCtxt, sConfigFileError ))
	{			
		sConfigFileError = "<p>" + sConfigFileError + "</p>";			
		*pCtxt << "Content-type: text/html\r\n";
		pCtxt->m_dwEndOfHeaders = pCtxt->m_pStream->GetStreamSize();
		CTDVString sHTML = "<html><head><title>Ripley Config File Error</title></head><body>" + sConfigFileError + "</body></html>";				
		*(pCtxt->m_pStream) << sHTML;
		return callOK;			
	}
	
	// Count the raw requests that come in.
	m_MasterCgi.GetStatistics()->AddRawRequest();

	// Create a CGI object to wrap around the server stuff
	CGI ThisRequest(m_MasterCgi);

	if (!ThisRequest.IsDatabaseInitialised())
	{
		return callBadCommand;
	}

	// Initialise it with all the inputs
	if (!ThisRequest.Initialise(pCtxt, pszQuery, pszCommand))
	{
		return callBadCommand;
	}

	if (UseHTMLCache(ThisRequest))
	{
		return callOK;
	}

	InterlockedIncrement(&m_RunningRequests);
	if (m_RunningRequests > theConfig.GetServerTooBusyLimit())
	{
		try
		{
			ServerTooBusy(pCtxt);
		}
		catch(...)
		{
		}

		InterlockedDecrement(&m_RunningRequests);
		return callBadCommand;
	}

	// Now call the handler function
	CHttpServer::errors	eReturnCode = callOK;
	bool bHandleResult = false;
	try
	{
		if (!ThisRequest.InitUser())
		{
			InterlockedDecrement(&m_RunningRequests);
			return callBadCommand;
		}

		bHandleResult = m_Ripley.HandleRequest(&ThisRequest,eReturnCode);
	}
	catch(...)
	{
		bHandleResult = false;
	}
	InterlockedDecrement(&m_RunningRequests);
	
	if (bHandleResult)
	{
		return eReturnCode;
	}
	else
	{
		return callBadCommand;
	}
}*/


/*********************************************************************************

	int CRipleyServerExtension::InitFromConfigFile(CHttpServerContext* pCtxt, CTDVString& sConfigFileError )

	Author:		DE
	Created:	05/04/2005
	Inputs:		CHttpServerContext* pCtxt = ptr to HTTP context
	Outputs:	sConfigFileError - error, if any, returned with this
	Returns:	true if successful, false otherwise
	Purpose:	Reads the config file, and if successful performs a one-time initialisation - if unsuccessful in
					reading config file returns false with the appropriate textual description of the error set
					in sConfigFileError. Note: Multithreaded calls can be made to InitFromConfigFile, hence
					a critical section object is used to control access to it.  	

*********************************************************************************/
bool CRipleyServerExtension::InitFromConfigFile(EXTENSION_CONTROL_BLOCK* pECB, CTDVString& sConfigFileError )
{
	// If we have initialised successfully from the config file, return immediately
	if (m_bInitialisedFromConfigFile)
		return true;

	sConfigFileError = "An unexpected application error occurred, please try again by refreshing this page";
	if ( TryEnterCriticalSection(&m_oCriticalSectionObjectForConfig) == 0 )
		return false;

	// It is possible for a thread to get hear after another thread has just been through.
	// This extra check ensures we never initialise twice
	if (m_bInitialisedFromConfigFile)
	{
		LeaveCriticalSection( &m_oCriticalSectionObjectForConfig );
		return true;
	}

	CTDVString sErrorTemp = ""; 
    CTDVString sConfPath = CTDVString(pECB->lpszPathTranslated) << "\\RipleyServer.xmlconf";
	if (!theConfig.Init(sConfPath, sErrorTemp))
	{
		//some went horribbly wrong - error description should be returned in sErrorTemp
		if ( sErrorTemp.IsEmpty( ) == false)
		{
			//assign to output parameter if valid
			sConfigFileError = sErrorTemp;
		}

		LeaveCriticalSection( &m_oCriticalSectionObjectForConfig );
		return false;
	}
	
	m_Ripley.Initialise();
	m_MasterCgi.InitialiseWithConfig();
	if (m_MasterCgi.InitialiseFromDatabase() == false) 
	{
		//start the worker thread that monitors the database
		//...
		m_MasterCgi.StartDatabaseWatchdog();
	}

    CTDVString sDLLPath = CTDVString(pECB->lpszPathTranslated) << "\\RipleyServer.dll";
    m_MasterCgi.SetRipleyServerInfoXML(GetRipleyServerInfoXML(sDLLPath));

	sConfigFileError.Empty( );		

	m_bInitialisedFromConfigFile = true;
	LeaveCriticalSection( &m_oCriticalSectionObjectForConfig );
	return true;
}

/*********************************************************************************

	CTDVString CRipleyServerExtension::GetRipleyServerInfoXML(const TDVCHAR* pFileName)

		Author:		Mark Neves
        Created:	04/11/2005
        Inputs:		pFileName = full path to the DLL this code is running in
        Outputs:	-
        Returns:	The XML that contains info about the DLL
        Purpose:	Finds out useful info about the DLL, such as the version, and creates an
					XML block that can be included in a DNA page

					The XML is cached on start-up in the master CGI object so that it accurately
					contains the information about the DLL that is actually running

*********************************************************************************/

CTDVString CRipleyServerExtension::GetRipleyServerInfoXML(const TDVCHAR* pFileName)
{
	CTDVString sFileXML;

	HANDLE h = ::CreateFile(pFileName,FILE_READ_ATTRIBUTES,FILE_SHARE_READ, NULL,OPEN_EXISTING, 0, NULL);

	if (h != INVALID_HANDLE_VALUE)
	{
		FILETIME CreationTime,LastAccessTime,LastWriteTime;

		if (::GetFileTime(h,&CreationTime,&LastAccessTime,&LastWriteTime))
		{
			CTime ctCreationTime(CreationTime);
			CTime ctLastAccessTime(LastAccessTime);
			CTime ctLastWriteTime(LastWriteTime);

			const TCHAR* pFormat = "%d/%m/%Y %X";
			CTDVString sCT((LPCTSTR)ctCreationTime.Format(pFormat));
			CTDVString sLAT((LPCTSTR)ctLastAccessTime.Format(pFormat));
			CTDVString sLWT((LPCTSTR)ctLastWriteTime.Format(pFormat));

			sFileXML << "<FILECREATED>" << sCT << "</FILECREATED>";
			sFileXML << "<FILELASTACCESSED>" << sLAT << "</FILELASTACCESSED>";
			sFileXML << "<FILELASTWRITTEN>" << sLWT << "</FILELASTWRITTEN>";
		}

		::CloseHandle(h);
	}

	CTDVString sVersion;
	GetDLLVersion(pFileName, sVersion);
	sFileXML << "<FILEVERSION>" << sVersion << "</FILEVERSION>";

	CTDVString sXML;
	sXML << "<RIPLEYSERVERINFO>" << sFileXML << "</RIPLEYSERVERINFO>";

	return sXML;
}


/*********************************************************************************

	bool CRipleyServerExtension::GetDLLVersion(const TDVCHAR* pFileName, CTDVString& sVersion)

		Author:		Mark Neves
        Created:	30/03/2005 (moved from CStatusBuilder 11/05)
        Inputs:		pFileName = full path to the DLL file
        Outputs:	sVersion = the version (e.g. "2,7,0,0"), or "Unkown" if it fails
        Returns:	true if OK, false otherwise
        Purpose:	Reads the version information from the DLL file

					This code was adapted from a code sample taken from:

					microsoft.public.vc.language
					subject: Calling GetFileVersionInfo() and VerQueryValue()
					From: Scot T Brennecke 
					posting date: 2002-02-22 

*********************************************************************************/

void CRipleyServerExtension::GetDLLVersion(const TDVCHAR* pFileName, CTDVString& sVersion)
{
	sVersion = "Unknown";

	DWORD dwVerHnd = 0 ;
	DWORD dwVerInfoSize = ::GetFileVersionInfoSize( pFileName, &dwVerHnd ) ;
	if ( ( dwVerInfoSize > 0 ) && ( dwVerHnd == 0 ) )
	{
		// Using a local array to avoid dynamic memory allocation
		char pVerInfo[1024*4];

		// If our buffer is big enough, proceed
		if (dwVerInfoSize < (1024*4))
		{
			// get the block
			if ( ::GetFileVersionInfo( pFileName, dwVerHnd, dwVerInfoSize, pVerInfo ) )
			{
				struct SLangCP { WORD wLang; WORD wCP; } * pTrans ;
	        
				UINT nVersionLen = 0 ;
				// Read the list of languages and code pages.  We will use only the first one, for now.
				::VerQueryValue( pVerInfo, TEXT("\\VarFileInfo\\Translation"), (LPVOID*)&pTrans, &nVersionLen ) ;
	        
				char szLookup[200] ;
	    
				// Get the file version and if valid, write it to the dialog member variable
				wsprintf( szLookup, TEXT("\\StringFileInfo\\%04x%04x\\ProductVersion"),pTrans[0].wLang, pTrans[0].wCP ) ;
				LPSTR pszVersion = NULL ;
				BOOL  bRetCode = ::VerQueryValue( pVerInfo, szLookup, (LPVOID*)&pszVersion, &nVersionLen ) ;
				if ( bRetCode && ( nVersionLen > 0 ) && ( pszVersion != NULL ) )
				{
					sVersion = pszVersion ;
				}
			}
		}
	}
 }


/*********************************************************************************

	void CRipleyServerExtension::ServerTooBusy(CHttpServerContext* pCtxt)

		Author:		Mark Neves
        Created:	15/05/2006
        Inputs:		pCtxt  = the context object for this request
        Outputs:	-
        Returns:	-
        Purpose:	Serves the "Server Too Busy" page

*********************************************************************************/

void CRipleyServerExtension::ServerTooBusy(EXTENSION_CONTROL_BLOCK* pECB)
{
		char* extra = "Content-type: text/html\r\n\r\n"
					"<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
					"<html>"
					"<head>"
					"<title>BBC - Interact with BBC community chat and message boards</title>"
					"<meta name=""description"" content="""" />"
					"<meta name=""keywords"" content="""" />"
					"<meta name=""created"" content=""20051010"" />"
					"<meta name=""updated"" content=""20051010"" />"
					"<meta http-equiv=""Content-Type"" content=""text/html;charset=iso-8859-1"" />"
					"<style type=""text/css"">"
					"<!--"
					"body {margin:0;}"
					"form {margin:0;padding:0;}"
					".bbcpageShadow {background-color:#828282;}"
					".bbcpageShadowLeft {border-left:2px solid #828282;}"
					".bbcpageBar {background:#999999 url(/images/v.gif) repeat-y;}"
					".bbcpageSearchL {background:#666666 url(/images/sl.gif) no-repeat;}"
					".bbcpageSearch {background:#666666 url(/images/st.gif) repeat-x;}"
					".bbcpageSearch2 {background:#666666 url(/images/st.gif) repeat-x 0 0;}"
					".bbcpageSearchRa {background:#999999 url(/images/sra.gif) no-repeat;}"
					".bbcpageSearchRb {background:#999999 url(/images/srb.gif) no-repeat;}"
					".bbcpageBlack {background-color:#000000;}"
					".bbcpageGrey, .bbcpageShadowLeft {background-color:#999999;}"
					".bbcpageWhite,font.bbcpageWhite,a.bbcpageWhite,a.bbcpageWhite:link,a.bbcpageWhite:hover,a.bbcpageWhite:visited {color:#ffffff;text-decoration:none;font-family:verdana,arial,helvetica,sans-serif;padding:1px 4px;}"
					".bbcpageTopleftlink,a.bbcpageTopleftlink,a:link.bbcpageTopleftlink,a:hover.bbcpageTopleftlink,a:visited.bbcpageTopleftlink {background:#ffffff;color:#666666;text-decoration:underline;}"
					".bbcpageToplefttd {background:#ffffff;color:#666666;}"
					"-->"
					"</style>"
					"<style type=""text/css"">"
					"@import url('/includes/tbenh.css') ;"
					"</style>"
					"<script language=""JavaScript"" type=""text/javascript"">"
					"<!--"
					"function popmailwin(x, y) {window.open(x,y,'status=no,scrollbars=yes,resizable=yes,width=350,height=400');}"
					"// -->"
					"</script>"
					"<style type=""text/css""></style>"
					"</head>"
					"<body bgcolor=""#ffffff"" text=""#666666"" link=""#333366"" vlink=""#666699"" alink=""#000066"" marginheight=""0"" marginwidth=""0"" topmargin=""0"" leftmargin=""0"">"
					"<!-- page layout templates v2.64 --><!-- GLOBAL NAVIGATION  --><!-- start dev -->"
					"<!-- variable settings"
					"bbcpage_charset - 	iso-8859-1"
					"bbcpage_bgcolor - 	ffffff"
					"bbcpage_navwidth - 	110"
					"bbcpage_navgraphic -	no"
					"bbcpage_navgutter - 	yes"
					"bbcpage_nav - 		yes"
					"bbcpage_contentwidth -	650"
					"bbcpage_contentalign -	left"
					"bbcpage_toolbarwidth - 	600"
					"bbcpage_searchcolour - 	666666"
					"bbcpage_banner - 	h2g2/maintenance/includes/maintenance"
					"bbcpage_crumb - 	h2g2/maintenance/includes/maintenance"
					"bbcpage_local - 	h2g2/maintenance/includes/maintenance"
					"bbcpage_graphic - 	(none)"
					"bbcpage_variant - 	gf"
					"bbcpage_language - 	gf"
					"bbcpage_lang -	 	(none)"
					"bbcpage_print - 	(none)"
					"bbcpage_topleft_textcolour - 	666666"
					"bbcpage_topleft_linkcolour - 	666666"
					"bbcpage_topleft_bgcolour - 	ffffff"
					"-->"
					"<!-- variable checks -->"
					"<!-- end variable checks -->"
					"<!-- end dev -->"
					"<a name=""top"" id=""top""></a><!-- toolbar 1.43 header.page  666666 --><table width=""100%"" cellpadding=""0"" cellspacing=""0"" border=""0"" lang=""en""><tr> <td class=""bbcpageShadow"" colspan=""2""><a href=""#startcontent"" accesskey=""2""><img src=""/f/t.gif"" width=""590"" height=""2"" alt=""Skip to main content"" title="""" border=""0"" /></a></td><td class=""bbcpageShadow""><a href=""/cgi-bin/education/betsie/parser.pl""><img src=""/f/t.gif"" width=""1"" height=""1"" alt=""Text Only version of this page"" title="""" border=""0"" /></a><br /><a href=""/accessibility/accesskeys/keys.shtml"" accesskey=""0""><img src=""/f/t.gif"" width=""1"" height=""1"" alt=""Access keys help"" title="""" border=""0"" /></a></td></tr><form action=""http://www.bbc.co.uk/cgi-bin/search/results.pl""><tr><td class=""bbcpageShadowLeft"" width=""94""><a href=""http://www.bbc.co.uk/go/toolbar/-/"" accesskey=""1""><img src=""/images/logo042.gif"" width=""90"" height=""30"" alt=""bbc.co.uk"" border=""0"" hspace=""2"" vspace=""0"" /></a></td><td class=""bbcpageGrey"" align=""right""><table cellpadding=""0"" cellspacing=""0"" border=""0"" style=""float:right""><tr><td><font size=""1""><b><a href=""http://www.bbc.co.uk/go/toolbar/text/-/"" class=""bbcpageWhite"">Home</a></b></font></td><td class=""bbcpageBar"" width=""6""><br /></td><td><font size=""1""><b><a href=""/go/toolbar/-/tv/"" class=""bbcpageWhite"">TV</a></b></font></td><td class=""bbcpageBar"" width=""6""><br /></td><td><font size=""1""><b><a href=""/go/toolbar/-/radio/"" class=""bbcpageWhite"">Radio</a></b></font></td><td class=""bbcpageBar"" width=""6""><br /></td><td><font size=""1""></font></td><td class=""bbcpageBar"" width=""6""><br /></td><td><font size=""1""><b><a href=""/go/toolbar/-/whereilive/"" class=""bbcpageWhite"">Where&nbsp;I&nbsp;Live</a></b></font></td><td class=""bbcpageBar"" width=""6""><br /></td><td><nobr><font size=""1""><b><a href=""/go/toolbar/-/a-z/"" class=""bbcpageWhite"" accesskey=""3"">A-Z&nbsp;Index</a></b></font></nobr></td><td class=""bbcpageSearchL"" width=""8""><br /></td><td class=""bbcpageSearch2"" width=""100""><input type=""text"" id=""bbcpageSearchbox"" name=""q"" size=""6"" style=""margin:3px 0 0;font-family:arial,helvetica,sans-serif;width:100px;"" title=""BBC Search"" accesskey=""4"" /></td><td class=""bbcpageSearch""><input type=""image"" src=""/images/srchb2.gif"" name=""go"" value=""go"" alt=""Search"" width=""64"" height=""25"" border=""0"" /></td><td class=""bbcpageSearchRa"" width=""1""><img src=""/f/t.gif"" width=""1"" height=""30"" alt="""" /></td></tr></table></td><td class=""bbcpageSearchRb""><img src=""/f/t.gif"" width=""1"" height=""1"" alt="""" /><input type=""hidden"" name=""uri"" value=""/h2g2/maintenance/toobusy.shtml"" /></td></tr></form><tr><td class=""bbcpageBlack"" colspan=""2""><table cellpadding=""0"" cellspacing=""0"" border=""0""><tr><td width=""110""><img src=""/f/t.gif"" width=""110"" height=""1"" alt="""" /></td><td width=""10""><img src=""/f/t.gif"" width=""10"" height=""1"" alt="""" /></td><td id=""bbcpageblackline"" width=""650""><img src=""/f/t.gif"" width=""650"" height=""1"" alt="""" /></td></tr></table></td><td class=""bbcpageBlack"" width=""100%""><img src=""/f/t.gif"" width=""1"" height=""1"" alt="""" /></td></tr></table><!-- end toolbar 1.42 --><table cellspacing=""0"" cellpadding=""0"" border=""0"" width=""100%""><tr><td class=""bbcpageToplefttd"" width=""110""><table cellspacing=""0"" cellpadding=""0"" border=""0""><tr><td width=""8""><img src=""/f/t.gif"" width=""8"" height=""1"" alt="""" /></td><td width=""102""><img src=""/f/t.gif"" width=""102"" height=""1"" alt="""" /><br clear=""all"" /><font face=""arial, helvetica, sans-serif"" size=""1"" class=""bbcpageToplefttd"" ><br/><a class=""bbcpageTopleftlink"" style=""text-decoration:underline;"" href=""/accessibility/"">Accessibility Help</a><br /><a class=""bbcpageTopleftlink"" style=""text-decoration:underline;"" href=""/cgi-bin/education/betsie/parser.pl"">Text only</a>      </font></td></tr></table></td><td width=""100%"" valign=""top""></td></tr></table><table style=""margin:0px;"" cellspacing=""0"" cellpadding=""0"" border=""0"" align="" left"" width=""110""><tr><td class=""bbcpageCrumb"" width=""8""><img src=""/f/t.gif"" width=""8"" height=""1"" alt="""" /></td><td class=""bbcpageCrumb"" width=""100""><img src=""/f/t.gif"" width=""100"" height=""1"" alt="""" /><br clear=""all"" /><font face=""arial, helvetica,sans-serif"" size=""2""><a class=""bbcpageCrumb"" href=""/"" lang=""en"">BBC Homepage</a><br /></font></td><td width=""2"" class=""bbcpageCrumb""><img src=""/f/t.gif"" width=""2"" height=""1"" alt="""" /></td><td class=""bbcpageGutter"" valign=""top"" width=""10"" rowspan=""4""><img src=""/f/t.gif"" width=""10"" height=""1"" vspace=""0"" hspace=""0"" alt="""" align=""left"" /></td></tr><tr><td class=""bbcpageLocal"" colspan=""3""><img src=""/f/t.gif"" width=""1"" height=""7"" alt="""" /></td></tr><tr><td class=""bbcpageLocal"" width=""8"" valign=""top"" align=""right""></td><td class=""bbcpageLocal"" valign=""top""><font face=""arial, helvetica,sans-serif"" size=""2""><br />&nbsp;</font></td><td class=""bbcpageLocal"" width=""2""><img src=""/f/t.gif"" width=""1"" height=""1"" alt="""" /></td></tr><tr><td class=""bbcpageServices""><img src=""/f/t.gif"" width=""1"" height=""1"" alt="""" /></td><td class=""bbcpageServices""><hr width=""50"" align=""left"" /><font face=""arial, helvetica, sans-serif"" size=""2""><a class=""bbcpageServices"" href=""/feedback/"">Contact Us</a><br /><br /><br /><font size=""1"">Like this page?<br /><a class=""bbcpageServices"" onclick=""popmailwin('/cgi-bin/navigation/mailto.pl?GO=1&REF=http://www.bbc.co.uk/h2g2/maintenance/toobusy.shtml','Mailer')"" href=""/cgi-bin/navigation/mailto.pl?GO=1&REF=http://www.bbc.co.uk/h2g2/maintenance/toobusy.shtml"" target=""Mailer"">Send it to a friend!</a></font><br />&nbsp;</font></td><td class=""bbcpageServices""><img src=""/f/t.gif"" width=""1"" height=""1"" alt="""" /></td></tr></table><table width=""650"" cellspacing=""0"" cellpadding=""0"" border=""0"" style=""margin:0px;"" style=""float:left;""><tr><td><!-- End of GLOBAL NAVIGATION  --><a name=""startcontent"" id=""startcontent""></a>"
					"<img src=""/h2g2/maintenance/images/too_busy.gif"" alt=""Sorry!"" width=""252"" height=""34"" vspace=""25"" border=""0""><br />"
					"<font size=""2"" face=""verdana,arial,helvetica"">"
					"Sorry! We're unable to bring you the page you're looking for right now. This is probably because our site has suddenly got very busy. Please do try again in a few minutes."
					"<br />&nbsp;<br />"
					"</font>"
					"<!-- begin footer --></td></tr></table><!--if no nav or stretchy but not both --><br clear=""all"" /><table  cellpadding=""0"" cellspacing=""0"" border=""0"" lang=""en""><tr><td class=""bbcpageFooterMargin"" width=""110""><img src=""/f/t.gif"" width=""110"" height=""1"" alt="""" /></td><td class=""bbcpageFooterGutter"" width=""10""><img src=""/f/t.gif"" width=""10"" height=""1"" alt="""" /></td><td class=""bbcpageFooter"" width=""650"" align=""center""><img src=""/f/t.gif"" width=""650"" height=""1"" alt="""" /><br /><font face=""arial, helvetica, sans-serif"" size=""1""><a class=""bbcpageServices"" href=""/info/"">About the BBC</a> | <a class=""bbcpageServices"" href=""/help/"">Help</a> | <a class=""bbcpageFooter"" href=""/terms/"">Terms of Use</a> | <a class=""bbcpageFooter"" href=""/privacy/"">Privacy &amp; Cookies Policy</a><br />&nbsp;</font></td></tr></table><br clear=""all"" /><script src=""/includes/linktrack.js"" type=""text/javascript""></script><!-- end footer -->"
					"</body>"
					"</html>";

		//char* extra = "Content-type: text/html\r\n\r\n<html><head><title>BBC - DNA - Server Too Busy</title></head><body><H1>Server Too Busy</H1></body></html>";
		DWORD dwSize = strlen(extra);

        pECB->ServerSupportFunction(pECB->ConnID,HSE_REQ_SEND_RESPONSE_HEADER, "500 Server Too Busy", &dwSize, (LPDWORD)extra);
		//pCtxt->ServerSupportFunction(HSE_REQ_SEND_RESPONSE_HEADER, "500 Server Too Busy", &dwSize, (LPDWORD)extra);
		
        // Make sure ISAPI doesn't send other rogue headers
		//pCtxt->m_bSendHeaders = false;

		m_MasterCgi.WriteInputLog("***SERVER TOO BUSY***");
		m_MasterCgi.GetStatistics()->AddServerBusy();
}

/*********************************************************************************

	bool CRipleyServerExtension::UseHTMLCache(CGI& ThisRequest)

		Author:		Mark Neves
        Created:	12/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	true if page served from the HTML cache, false otherwise
        Purpose:	Tries to use the HTML cache for the request

*********************************************************************************/

bool CRipleyServerExtension::UseHTMLCache(CGI& ThisRequest)
{
	bool bUsedHTMLCache = false;

	if (!ThisRequest.HasSSOCookie())
	{
		ThisRequest.AddNonSSORequest();

		if (!ThisRequest.DoesCurrentSiteCacheHTML() || ThisRequest.GetCurrentSiteHTMLCacheExpiry() == 0 )
		{
			return false;
		}

		CXMLBuilder* pBuilder = CRipley::GetBuilder(&ThisRequest);

		if (pBuilder != NULL)
		{
			if (pBuilder->IsRequestHTMLCacheable())
			{
				CTDVString sCacheFolderName = pBuilder->GetRequestHTMLCacheFolderName();
				CTDVString sCacheFileName   = pBuilder->GetRequestHTMLCacheFileName();

				if (sCacheFolderName.GetLength() > 0 && sCacheFileName.GetLength() > 0)
				{
					// Set the cache expiry time according to the site configuration 
					CTDVDateTime dExpires(ThisRequest.GetCurrentSiteHTMLCacheExpiry());

					CTDVString sHTML;
					if (ThisRequest.CacheGetItem(sCacheFolderName,sCacheFileName,&dExpires,&sHTML))
					{
						COutputContext* pOutputContext = ThisRequest.GetOutputContext();
						if (pOutputContext != NULL)
						{
							pOutputContext->SetMimeType("text/html");
							pOutputContext->SendOutput(sHTML);
							bUsedHTMLCache = true;
						}
					}
				}

				if (bUsedHTMLCache)
				{
					ThisRequest.LogTimerEvent("HTML Cache Hit");
					ThisRequest.AddHTMLCacheHit();
				}
				else
				{
					ThisRequest.LogTimerEvent("HTML Cache Miss");
					ThisRequest.AddHTMLCacheMiss();
				}
			}
			delete pBuilder;
		}
	}

	return bUsedHTMLCache;
}

void CRipleyServerExtension::WriteContext(EXTENSION_CONTROL_BLOCK *pECB, const TDVCHAR* pContent)
{
    DWORD dwSize = strlen(pContent);
	pECB->WriteClient(pECB->ConnID, (LPVOID) pContent, &dwSize, 0);
}

void CRipleyServerExtension::WriteHeaders(EXTENSION_CONTROL_BLOCK *pECB, const TDVCHAR* pHeaders)
{
    DWORD dwSize = strlen(pHeaders);
    pECB->ServerSupportFunction(pECB->ConnID,HSE_REQ_SEND_RESPONSE_HEADER,0,&dwSize,(DWORD*) pHeaders);
}