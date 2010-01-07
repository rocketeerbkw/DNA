// Implementation of the GetTransformer member function of CRipley
////////////////////////////////////////////////////////////

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
#include "XMLObject.h"
#include "HTMLTransformer.h"
#include "ThroughputTransformer.h"
#include "BlobTransformer.h"
#include "Ripley.h"
#include "tdvassert.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


/*********************************************************************************

	CXMLTransformer* CRipley::GetTransformer(CGI* pCGI)
																			 ,
	Author:		Jim Lynn, Kim Harries, Oscar Gillespie, Shim Young, Sean Solle
	Created:	17/02/2000
	Modified:	02/03/2000
	Inputs:		pCGI - ptr to the CGI Request object
	Outputs:	-
	Returns:	ptr to a CXMLTransformer object for this request or NULL for error
	Purpose:	Looks at the request and decides what is the most appropriate
				subclass of CXMLTransformer to create, creates an instance of
				that subclass (initialising it with the pCGI ptr) and returns
				it to the caller. The caller has the responsibility of deleting
				the object. !!! Ensure that calling delete on a pointer to a 
				base class will delete the derived class properly !!!

*********************************************************************************/

CXMLTransformer* CRipley::GetTransformer(CGI* pCGI)
{
	CInputContext& inputContext = pCGI->GetInputContext();
	COutputContext* pOutputContext = pCGI->GetOutputContext();

	// TODO: return correct transformer for clients platform

	// only currently returns an HTMLTransformer since we don't have a method
	// via the CGI to check what the clients platform is - Kim

	CTDVString sCommand;
	CTDVString sSkin;
	
	if (inputContext.GetSkin(&sSkin)) // check that url interrogating works
	{
		if (sSkin.CompareText("PureXML") || sSkin.Left(7).CompareText("http://"))
		{

			// if the user has requested XML throughput (displaying the XML source instead
			// of some HTML representation) in one of these 3 ways, let them have it

			CThroughputTransformer* pTransformer = NULL;
			// new exception handling lark
			try
			{
				pTransformer = new CThroughputTransformer(inputContext, pOutputContext);
			}
			catch (...)
			{
				// TODO: log this error somewhere
				// returns NULL to indicate failure
				return NULL;
			}

			return pTransformer;
		}
	}

	if (inputContext.GetCommand(sCommand)) // check that url interrogating works
	{
		if (sCommand.CompareText("BLOB"))
		{

			// Blob drawing

			CBlobTransformer* pTransformer = NULL;
			// new exception handling lark
			try
			{
				pTransformer = new CBlobTransformer(inputContext, pOutputContext);
			}
			catch (...)
			{
				// TODO: log this error somewhere
				// returns NULL to indicate failure
				return NULL;
			}

			return pTransformer;
		}
	}
	// otherwise they _must_ want a html transformer (pending CGI interrogating)

	CHTMLTransformer* pTransformer = NULL;
	// must catch any exceptions thrown by new
	try
	{
		pTransformer = new CHTMLTransformer(inputContext, pOutputContext);
	}
	catch (...)
	{
		// TODO: log this error somewhere
		// returns NULL to indicate failure
		return NULL;
	}
	return pTransformer;
}
