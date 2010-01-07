// Ripley.cpp: implementation of the CRipley class.
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
#include "RipleyServer.h"
#include "CGI.h"
#include "XSLT.h"
#include "WholePage.h"
#include "tdvassert.h"
#include "Ripley.h"
#include "SmileyList.h"
#include "Config.h"
#include "XmlObject.h"
#include "SiteOptions.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CRipley::CRipley()
																			 ,
	Author:		Jim Lynn, Kim Harries, Oscar Gillesbie, Shim Young, Sean Solle
	Inputs:		-
	Outputs:	-
	Returns:	-
	Scope:		public
	Purpose:	Constructor for the Ripley object. This object is constructed
				as part of the server constructor. It will initialise itself
				with a configuration file.

*********************************************************************************/

CRipley::CRipley()
{

}

/*********************************************************************************
	CRipley::~CRipley()

	Author:		Jim Lynn, Kim Harries, Oscar Gillesbie, Shim Young, Sean Solle
	Created:	17/02/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor for the Ripley class. Current behaviour: Delete config
				data if it exists.

*********************************************************************************/

CRipley::~CRipley()
{
}

/*********************************************************************************

	bool CRipley::HandleRequest(CGI *pCgi)
																			 ,
	Author:		Jim Lynn, Kim Harries, Oscar Gillespie, Shim Young, Sean Solle
	Created:	17/02/2000
	Modified:	01/03/2000
	Inputs:		pCGI - ptr to the CGI object for this request
	Outputs:	-
	Returns:	true for success, false for failure
	Purpose:	Handles requests into the server. Creates a specialised CXMLBuilder
				object to build the XML data for the page, and a specialised
				CXMLTransformer object to output the XML data back to the server.

*********************************************************************************/

bool CRipley::HandleRequest(CGI *pCGI)
{
	//CTDVString sSkin;

	//pCGI->GetSkin(&sSkin);

	if (pCGI->IsRequestForCachedFeed())
	{
		// Feed requested, check for cached output that has been transformed.
		CTDVString sFeedsCacheName;
		CTDVString sFeedsCacheItemName;
		CTDVString sCacheOutput;

		CTDVDateTime dtCacheExpiryTime(60*5); // expire after 5 minutes

		pCGI->GetFeedsCacheName(sFeedsCacheName, sFeedsCacheItemName);

		bool bCacheFileFound = pCGI->CacheGetItem(sFeedsCacheName, sFeedsCacheItemName, &dtCacheExpiryTime, &sCacheOutput, false);

		if (bCacheFileFound)
		{
			if (pCGI->IsRequestForRssFeed())
			{
				pCGI->AddRssCacheHit();
				pCGI->SetMimeType("text/xml; charset=utf-8");	
			}
			else if (pCGI->IsRequestForSsiFeed())
			{
				pCGI->AddSsiCacheHit();
				pCGI->SetMimeType("text/html");	
			}

			pCGI->SendOutput(sCacheOutput);

			return true;
		} 
		else
		{
			if (pCGI->IsRequestForRssFeed())
			{
				pCGI->AddRssCacheMiss();
			}

			if(pCGI->IsRequestForSsiFeed())
			{
				pCGI->AddSsiCacheMiss();
			}
		}
	}
	long tstart = GetTickCount();

//	pCGI->StartInputLog();
	
	if (pCGI->ParamExists("_time"))
	{
		pCGI->SwitchTimers((pCGI->GetParamInt("_time") == 1));
	}

	bool bAccessDeniedToPasswordedSite = false;	// default to allowed

//	if (pCGI->IsSitePassworded(pCGI->GetSiteID()))
//	{
//		if (!pCGI->IsUserAllowedInPasswordedSite())
//		{
//			bAccessDeniedToPasswordedSite = true;
//		}
//		CTDVString sUserName;
//		pCGI->GetUserName(&sUserName);
//		if (sUserName.GetLength() == 0)
//		{
//			pCGI->SendAuthRequired();
//			return true;
//		}
//	}
	
	// Create an appropriate builder object, based on the request as held
	// in the CGI object. Passes it as a CGI
	CXMLBuilder* pBuilder = GetBuilder(pCGI);
	if (!pBuilder)
	{
		// Something failed - return false
		return false;
	}

	// Create an appropriate transformer object
	CXMLTransformer* pTransformer = NULL;

	if (!pBuilder->IsUserAuthorised())
	{
		delete pBuilder;
		pCGI->SendAuthRequired();
		return true;
	}
	
	// bResult reflects the success or failure of the Transformer's Output function	

	bool bResult = false;         
	
	// The CXMLObject that the CXMLBuilder is going to give us
	// I have to set it to NULL to begin with or I get a warning saying that it has not
	// been initialized
	
	if (pCGI->GetParamInt("clear_templates") || AlwaysClearTemplates())
	{
		CXSLT::ClearTemplates();
	}

	// Check to see if we're resync'ing the user details!
	CUser* pUser = NULL;
	if (pCGI->GetParamInt("s_sync"))
	{
		// Prod the SSO Builder to resync before we carry on!
		// Don't worry about it failing, just carry on.
		pUser = pCGI->GetCurrentUser();
		if (pUser != NULL)
		{
			pUser->SynchroniseWithProfile();
		}
	}

	if (pCGI->GetParamInt("_ns"))
	{
		pCGI->SiteDataUpdated();
	}

    #ifdef DEBUG
	if (pCGI->ParamExists("d_useidentity"))
	{
		if (pCGI->GetParamInt("d_useidentity") > 0)
		{
			pCGI->SetSiteUsesIdentitySignIn(pCGI->GetSiteID(),true);
		}
		else
		{
			pCGI->SetSiteUsesIdentitySignIn(pCGI->GetSiteID(),false);
		}
	}
    #endif

	// Refresh groups cache
	if (pCGI->GetParamInt("_gc"))
	{
		pCGI->GroupDataUpdated();
	}

	// Refresh dynamic lists cache
	if (pCGI->GetParamInt("_dl"))
	{
		pCGI->DynamicListDataUpdated();
	}
	
	// Tell the Builder to create a CXMLObject representing the total data needed
	// on this page

	CWholePage ThisPage(pCGI->GetInputContext());
	bool bPageBuilt = false;
	try
	{
		bPageBuilt = pBuilder->Build(&ThisPage);
	}
	catch(...)
	{
		bPageBuilt = false;
		pCGI->WriteInputLog("FAIL BuilderFailed");
	}

	long ttaken = GetTickCount() - tstart;
	if ( pCGI->GetStatistics() )
		pCGI->GetStatistics()->AddRequestDuration(ttaken);
	
	// Check that Build has worked	
	
	if (!bPageBuilt)
	{
		ThisPage.Initialise();
		ThisPage.SetPageType("ERROR");
		ThisPage.SetError("An unknown error has occurred");
		bPageBuilt = true;
		//eReturnCode = pBuilder->GetHttpErrorCode();
	}
	else
	{
		// Everything went well.
		//eReturnCode = CHttpServer::errors::callOK;
	}

	if (bPageBuilt) 
	{
		CTDVString PageType;
		if (ThisPage.GetPageType(PageType) && PageType.CompareText("ACCESS-DENIED"))
		{
			delete pBuilder;
			pCGI->SendAuthRequired();
			return true;
		}

		//Add the signed in status here
		if (pUser == NULL)
		{
			pUser = pCGI->GetCurrentUser();
		}

		if (pUser != NULL)
		{
			CTDVString sSignedInStatus;
			if (pUser->GetSignedInStatusAsString(sSignedInStatus, pCGI->GetSiteUsesIdentitySignIn(pCGI->GetSiteID())))
			{
				ThisPage.AddInside("VIEWING-USER",sSignedInStatus);
                CTDVString sSignInName;
				if (pUser->GetSsoUserName(sSignInName))
				{
					ThisPage.AddInside("VIEWING-USER","<SIGNINNAME>" + sSignInName + "</SIGNINNAME>");
				}
			}
		}

		CTDVString sServerName;
		pCGI->GetServerName(&sServerName);
		CTDVString sXML = "<SERVERNAME>";
		sXML << sServerName << "</SERVERNAME>";
		ThisPage.AddInside("H2G2",sXML);
		sXML = "<TIMEFORPAGE>";
		sXML << ttaken << "</TIMEFORPAGE>";
		ThisPage.AddInside("H2G2",sXML);
		CTDVString sUserAgent;
		pCGI->GetUserAgent(sUserAgent);
		sUserAgent.Replace("&","&amp;");
		sUserAgent.Replace("<","&lt;");
		sUserAgent.Replace(">","&gt;");
		sXML = "<USERAGENT>";
		sXML << sUserAgent << "</USERAGENT>";
		ThisPage.AddInside("H2G2",sXML);

		CTDVString sUrlSkinName;
		if (pCGI->GetParamString("_sk", sUrlSkinName))
		{
			CTDVString sUrlSkinNameXml = "<URLSKINNAME>";
			CXMLObject::EscapeAllXML(&sUrlSkinName);

			sUrlSkinNameXml << sUrlSkinName << "</URLSKINNAME>";
			ThisPage.AddInside("H2G2", sUrlSkinNameXml);

			pCGI->DoesSkinExistInSite(pCGI->GetSiteID(), sUrlSkinName);
			CTDVString sSkinDoesNotExistinSiteXml = "<SKINDOESNOTEXISTINSITE>1</SKINDOESNOTEXISTINSITE>";
			ThisPage.AddInside("H2G2", sSkinDoesNotExistinSiteXml);
		}

		// Add all the CGI parameters passed to the script (except any starting with password)
		sXML="<PARAMS>";
		CTDVString sParams = "";
		pCGI->GetParamsAsXML(&sParams,"s_");
		sXML << sParams << "</PARAMS>";
		ThisPage.AddInside("H2G2", sXML);
		
		// Add the old style site XML to the page
		CreateOldStyleSiteXML(sXML, pCGI, ThisPage);

		// Add the new style XML to the page
		sXML = pCGI->GetSiteInfomationXML(pCGI->GetSiteID());
		ThisPage.AddInside("H2G2",sXML);

		// See if we've been given a redirect!
		CTDVString sRedirect;
		if (pCGI->ParamExists("_redirect") && pCGI->GetParamString("_redirect",sRedirect) && sRedirect.Find("//") < 0)
		{
			// Add the redirect to the Page
			if (!ThisPage.Redirect(sRedirect))
			{
				// Put the error into the page
				ThisPage.AddInside("H2G2",ThisPage.GetLastErrorAsXMLString());
			}
		}

		// Now transform the XML
		pTransformer = GetTransformer(pCGI);
		if (!pTransformer)
		{
			// This failed. delete the builder and return false
			delete pBuilder;
			pBuilder = NULL;
			return false;
		}

		// pObject itself should not be allowed to be NULL => this indicates an error
		// if however it is *empty*, i.e. its xml tree is empty, behaviour
		// should be defined within the transformer object ???
		try
		{
			CTDVString sCacheName, sCacheItem;

			if (!pCGI->HasSSOCookie())
			{
				if (pCGI->DoesCurrentSiteCacheHTML())
				{
					if (pTransformer->IsHTMLTransformer() && pBuilder->IsRequestHTMLCacheable())
					{
						sCacheName = pBuilder->GetRequestHTMLCacheFolderName();
						sCacheItem = pBuilder->GetRequestHTMLCacheFileName();
					}
				}
			}

			bResult = pTransformer->Output(&ThisPage,sCacheName,sCacheItem);
		}
		catch(...)
		{
			pCGI->WriteInputLog("FAIL TransformerFailed ");
		}
	}
	else
	{
		bResult = false;
	}

	//long ttotal = GetTickCount() - tstart;
	//CTDVString sOut = "\r\n<!-- Total time: ";
	//sOut << ttotal << "-->\r\n";
//	pCGI->SendOutput(sOut);
	
	// Now delete all these objects we've created
	delete pBuilder;
	pBuilder = NULL;

	delete pTransformer;
	pTransformer = NULL;

	// Now return the bResult...
	return bResult;
}


/*********************************************************************************

	void Cripley::CreateOldStyleSiteXML(CTDVString& sXML, CGI* pCGI, CWholePage& ThisPage)

		Author:		Mark Howitt
		Created:	23/07/2008
		Input:		sXML - The string that will take the xml
					pCGI - pointer to the current CGI
					ThisPage - The whole page object to insert the xml into
		Purpose:	Creates the old style XML for the site

*********************************************************************************/
void CRipley::CreateOldStyleSiteXML(CTDVString& sXML, CGI* pCGI, CWholePage& ThisPage)
{
	// Add current site ID
	sXML = "<CURRENTSITE>";
	sXML << pCGI->GetSiteID() << "</CURRENTSITE>";
	ThisPage.AddInside("H2G2", sXML);

	// Add current site URL name
	CTDVString sSiteURLName;
	pCGI->GetNameOfSite(pCGI->GetSiteID(),&sSiteURLName);
	sXML = "<CURRENTSITEURLNAME>";
	sXML << sSiteURLName << "</CURRENTSITEURLNAME>";
	ThisPage.AddInside("H2G2", sXML);

	// Add current site SSo Service
	CTDVString sSSOService;
	pCGI->GetSiteSSOService(pCGI->GetSiteID(),&sSSOService);
	sXML = "<CURRENTSITESSOSERVICE>";
	sXML << sSSOService << "</CURRENTSITESSOSERVICE>";
	ThisPage.AddInside("H2G2", sXML);

	// Add current site ID
	sXML = "<CURRENTSITEMINAGE>";
	sXML << pCGI->GetSiteMinAge(pCGI->GetSiteID()) << "</CURRENTSITEMINAGE>";
	ThisPage.AddInside("H2G2", sXML);

	// Add current site ID
	sXML = "<CURRENTSITEMAXAGE>";
	sXML << pCGI->GetSiteMaxAge(pCGI->GetSiteID()) << "</CURRENTSITEMAXAGE>";
	ThisPage.AddInside("H2G2", sXML);

	if (pCGI->GetIsInPreviewMode())
	{
		sXML = "<PREVIEWMODE>1</PREVIEWMODE>";
		ThisPage.AddInside("H2G2", sXML);
	}

	// Add some XML to show the current open state of the site
	sXML = "<SITE-CLOSED>";
	bool bSiteClosed = false;
	if (!pCGI->IsSiteClosed(pCGI->GetSiteID(),bSiteClosed))
	{
		TDVASSERT(false,"Failed To Get Site CLosed Status!!!");
	}
	sXML << bSiteClosed << "</SITE-CLOSED>";
	ThisPage.AddInside("H2G2",sXML);
}

/*********************************************************************************

	void CRipley::Initialise()

	Author:		Jim Lynn
	Created:	24/02/2000
	Inputs:		pInitString - string containing XML configuration file
	Outputs:	-
	Returns:	-
	Purpose:	

*********************************************************************************/

void CRipley::Initialise()
{
	bool bOkay = CGI::LoadSmileyList(theConfig.GetSmileyListFile());
	// if LoadSmileyList has problems it uses the default smiley list in any case
	// so no need to extra error processing here
	CXSLT::StaticInit();
	CGI::StaticInit();
}
	
/*********************************************************************************

	bool CRipley::AlwaysClearTemplates()

	Author:		Mark Neves
	Created:	14/07/2003
	Inputs:		-
	Outputs:	-
	Returns:	true if its a DEBUG built and the environment var "RipleyClearTemplates" is set to 1
				returns false in all other situations
	Purpose:	A DEBUG build helper function, allowing you to configure your machine to always
				clear the XSLT templates cache in debug builds, thus speeding up development of
				XSLT scripts

*********************************************************************************/

bool CRipley::AlwaysClearTemplates()
{
	bool bClearTemplates = false;

#ifdef _DEBUG
	const int buffersize=500;
	TCHAR* pBuffer = (TCHAR*)malloc(buffersize);
	if (pBuffer != NULL)
	{
		DWORD dw = ::GetEnvironmentVariable("RipleyClearTemplates",pBuffer,buffersize);

		// If not found, or the buffer is too small return false;
		if (dw > 0 && dw < buffersize)
		{
			bClearTemplates = (atoi(pBuffer) == 1);
		}

		free(pBuffer);
		pBuffer = NULL;
	}
#endif

	return bClearTemplates;
}