// BlobBuilder.cpp: implementation of the CBlobBuilder class.
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
#include "Blob.h"
#include "BlobBuilder.h"
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

	CBlobBuilder::CBlobBuilder(CInputContext& inputContext)
																			 
	Author:		Oscar Gillespie
	Created:	14/03/2000
	Inputs:		inputContext - input context object (stuff coming in from the real world)
				curiously similar to the base class
	Outputs:	-
	Returns:	-
	Purpose:	Constructor for our bizarre binary object locator class

*********************************************************************************/

CBlobBuilder::CBlobBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

/*********************************************************************************

	CFrontPageBuilder::~CFrontPageBuilder()

	Author:		Oscar Gillespie
	Created:	14/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Destructor for the CBlobBuilder class. More functionality if/when we start allocating memory

*********************************************************************************/


CBlobBuilder::~CBlobBuilder()
{

}

/*********************************************************************************

	CWholePage* CBlobBuilder::Build()

	Author:		Oscar Gillespie
	Created:	14/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	ptr to a CWholePage containing the XML data, NULL for failure
	Purpose:	Makes a whole XML page (the one that's needed to send to the transformer)
				and puts inside it a CBlob (binary object locator class)

*********************************************************************************/


bool CBlobBuilder::Build(CWholePage* pPageXML)
{
	CBlob Blob(m_InputContext);

	bool bSuccess = true; // boolean value to keep track of how well we're doing

	bSuccess = InitPage(pPageXML,"",false);

	// an integer used to record the number of the binary file we're supposed to go looking for
	int iBlobID = 0;

	// a string used to hold the name of the blob if we take that approach instead of the integer
	CTDVString sBlobName = "";

	// a boolean variable to determine whether we want to go looking for a key (named) blob
	bool bUseNameInstead = false;

	if (bSuccess)
	{
		// get the value of blobid from the url
		iBlobID = m_InputContext.GetParamInt("blobid");

		if (iBlobID == 0) 
		{
			// if the blob number is 0 it means that no blobid has been supplied...
			// presumably this means we're supposed look for a named blob
			bSuccess = m_InputContext.GetParamString("blobname", sBlobName);
			// and if we can't find the blob name either then we shouldn't carry on.

			// clearly if we don't find a blobid but we do find a blobname we ought to look for that.
			if (bSuccess) bUseNameInstead = true;
		}
	}

	CTDVString sBGColour = "";

	if (bSuccess)
	{
		// get the value of bg (the background colour) from the url.
		// it shouldn't ruin our plans if this parameter doesn't exist
		m_InputContext.GetParamString("option", sBGColour); 
	}

	// ok,.. if everything is still funky then lets tell the blob object about itself... depending
	// on the state of bUseNameInstead we use the int version of Initialise or the CTDVString version.
	if (bSuccess && !bUseNameInstead)
	{
		// initialise the blob object with its id number and background colour
		bSuccess = Blob.Initialise(iBlobID, sBGColour);
	} 
	else if (bSuccess && bUseNameInstead)
	{
		// initialise the blob object with its key blob name and background colour
		bSuccess = Blob.Initialise(sBlobName, sBGColour);
	}

	if (bSuccess)
	{
		// add the BlobXML block inside the PageXML
		bSuccess = pPageXML->AddInside("H2G2", &Blob);
	}

	if (bSuccess)
	{
		// set the page to be of the type "redirect" or "picture" depending on the XML therein
		if (pPageXML->DoesTagExist("REDIRECT-TO"))
		{
			bSuccess = pPageXML->SetPageType("REDIRECT");
		}
		else
		{
			bSuccess = pPageXML->SetPageType("PICTURE");
		}
	}

	if (bSuccess)
	{
		// if everything worked then return the page that was built
		return true;
	}
	else
	{
		// if something went wrong then then delete the page xml and any
		// contents it had and return NULL for failure
		return false;
	}
}