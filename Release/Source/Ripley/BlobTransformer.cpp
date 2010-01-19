 // BlobTransformer.cpp: implementation of the CBlobTransformer class.
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
#include "BlobTransformer.h"
#include "tdvassert.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CBlobTransformer::CBlobTransformer(CInputContext& inputContext,
									   COutputContext* pOutputContext)
																			 ,	
	Author:		Oscar Gillepsie
	Created:	15/03/2000
	Inputs:		pInputContext - pointer to an input context for getting information
					about the current request
				pOutputContext - pointer to an output context for allowing the
					resulting transformed data to be output to the client
	Outputs:	-
	Returns:	-
	Purpose:	Construct the object with the input and output contexts it requires.

*********************************************************************************/

CBlobTransformer::CBlobTransformer(CInputContext& inputContext, COutputContext* pOutputContext) :
	CXMLTransformer(inputContext, pOutputContext)
{
// no further construction
}

/*********************************************************************************

	CBlobTransformer::~CBlobTransformer()
																			 ,	
	Author:		Oscar Gillespie
	Created:	15/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor. No resources to release at this point.

*********************************************************************************/

CBlobTransformer::~CBlobTransformer()
{
// no explicit destruction required
}

/*********************************************************************************

	CBlobTransformer::Output(CWholePage* pWholePage, const TDVCHAR* pCacheName, const TDVCHAR* pItemName)

	Author:		Oscar Gillespie
	Created:	15/03/2000
	Modified:	16/03/2000
	Inputs:		pXMLObject - a pointer to an xml object containing the xml that
					describes the binary file to be sent out.
	Outputs:	-
	Returns:	true for success, false for failure
	Purpose:	Take the given content xml and figure out what binary file to be
					sent to the user through the http context stuff

*********************************************************************************/

bool CBlobTransformer::Output(CWholePage* pWholePage, const TDVCHAR* pCacheName, const TDVCHAR* pItemName)
{

	TDVASSERT(pWholePage != NULL, "CHTMLTransformer::Output(...) passed a NULL CWholePage pointer");
	TDVASSERT(!pWholePage->IsEmpty(), "CHTMLTransformer::Output(...) passed an empty CWholePage");

	if (pWholePage == NULL || pWholePage->IsEmpty())
	{
		// should just fail if xml object is null or empty, but send a default HTML message
		// indicating an internal error for debug purposes ???
		m_pOutputContext->SetMimeType("text/html");
		m_pOutputContext->SendOutput("<HTML><HEAD><TITLE>ERROR!!!</TITLE></HEAD><BODY>CBlobTransformer::Output(...) called with NULL or empty CWholePage</BODY></HTML>");
		return true;
	}

	CTDVString sPageType;
	pWholePage->GetPageType(sPageType);
	
	if (sPageType.CompareText("REDIRECT"))
	{
		CTDVString sLocation;
		pWholePage->GetContentsOfTag("REDIRECT-TO", &sLocation);
		if (sLocation.CompareText("notfound.gif")) 
		{
			m_pOutputContext->SendRedirect("/h2g2/guide/skins/Alabaster/images/notfound.gif");
/*
			// we'll need to assume that the site domain looks something like "fish.h2g2.com"

			CTDVString skin;
		
			// if a skin is specified on the command line use that skin directory
			// else use the skin preference of the viewer, else the Default Skin
			// TODO: should check if skin is valid somewhere
			if (!m_InputContext.GetParamString("skin", skin))
			{
				CUser* pViewer = m_InputContext.GetCurrentUser();

				// have default skin as, er, like, the default
				if (!m_InputContext.GetDefaultSkin(skin))
				{
					// GetDefaultSkin should never fail, but if it does log error
					// and try to do something sensible
					TDVASSERT(false, "GetDefaultSkin(...) failed inside CBlobTransformer::Output(...)");
					skin = "Alabaster";
				}
				// but if we have a viewer and can get their preferred skin use that
				// which may of course be the default skin...
				if (pViewer != NULL)
				{
					CTDVString sPrefSkin = "";
					bool bOkay = pViewer->GetPrefSkin(&sPrefSkin);
					TDVASSERT(bOkay, "GetPrefSkin(...) failed in CBlobTransformer::Output(...)");
					// don't use the users skin preference if it is empty
					if (sPrefSkin.GetLength() > 0)
					{
						skin = sPrefSkin;
					}
				}
			}

			if (skin.CompareText("Classic"))
			{
				m_pOutputContext->SendAbsoluteRedirect("http://www2.h2g2.com/images/notfound.gif");

			}
			else if (skin.CompareText("Alabaster"))
			{
				m_pOutputContext->SendAbsoluteRedirect("http://www2.h2g2.com/Skins/Alabaster/Images/notfound.gif");
			}
			else return false;
*/
		}
		else m_pOutputContext->SendRedirect(sLocation);
	
		return true;
	}
	else
	{
		bool bSuccess = true;

		if (pWholePage->DoesTagExist("PICTUREERROR"))
		{
			// if the xml already knows that there has been an error
			bSuccess = false;
		}

		// here we use the goblin to parse blob info

		// strings that correspond to parts of the Blob XML
		CTDVString sServerName;
		CTDVString sPath;
		CTDVString sMimeType;

		// this is the string to hold the XML for the blob info
		CTDVString sBlobInfo = NULL;
		CXMLTree* pBlobTree = NULL;

		if (bSuccess)
		{
			// extract a string representation of the XML from the whole page
			pWholePage->GetAsString(sBlobInfo);

			long lErrCount = 0; // an integer that will store the number of parsing errors

			// try to parse the blob xml into a tree so we can access bits of it more easily
			pBlobTree = CXMLTree::Parse(sBlobInfo, true, &lErrCount);

			// if the tree isn't null then the Parse function must have worked
			TDVASSERT(pBlobTree != NULL, "CXMLTree::Parse returned NULL");

			// continue if the parse worked happily
			if (lErrCount != 0) 
			{
				bSuccess = false;
			}
		}
			
		// see if we can get the value of a these attributes

		if (bSuccess)
		{
			// find the node called <SERVERNAME>
			CXMLTree* pServerNameNode = pBlobTree->FindFirstTagName("SERVERNAME");
			TDVASSERT(pServerNameNode != NULL, "malformed XML blob in BlobTransformer::Output");
			
			//really just don't continue if the pointer is shagged
			bSuccess = (pServerNameNode != NULL);

			// attempt to retrieve its contents
			bSuccess = pServerNameNode->GetTextContents(sServerName);
		}

		if (bSuccess)
		{
			// find the node called <PATH>
			CXMLTree* pPathNode = pBlobTree->FindFirstTagName("PATH");
			TDVASSERT(pPathNode != NULL, "malformed XML blob in BlobTransformer::Output");

			//really just don't continue if the pointer is shagged
			bSuccess = (pPathNode != NULL);

			// attempt to retrieve its contents			
			bSuccess = pPathNode->GetTextContents(sPath);
		}

		if (bSuccess)
		{
			// find the node called <MIMETYPE>
			CXMLTree* pMimeTypeNode = pBlobTree->FindFirstTagName("MIMETYPE");
			TDVASSERT(pMimeTypeNode  != NULL, "malformed XML blob in BlobTransformer::Output");

			//really just don't continue if the pointer is shagged
			bSuccess = (pMimeTypeNode != NULL);

			// attempt to retrieve its contents
			bSuccess = pMimeTypeNode->GetTextContents(sMimeType);
		}

		if (bSuccess)
		{	
			// ok boys (and girls), here it comes...
			bSuccess = m_pOutputContext->SendPicture(sServerName, sPath, sMimeType);
		}
		else
		{
			// TODO explain that the picture wasn't found in some way or other
		}

		// we've already established that the pointer is non-null so this is safe and necessary
		delete pBlobTree;
		pBlobTree = NULL;

		// return true if we've done all this without any hitches... false otherwise
		return bSuccess;
	}
}